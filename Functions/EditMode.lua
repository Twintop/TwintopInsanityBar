---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local L = TRB.Localization

TRB.Functions = TRB.Functions or {}
TRB.Functions.EditMode = {}

-- Local reference to LibEditMode
local LibEditMode = nil

-- Track the currently registered container frame to prevent duplicate registrations
local registeredFrame = nil

-- Track if Initialize has been called
local isInitialized = false

---Initializes the Edit Mode integration
---Sets up callbacks for layout changes, renames, and deletions
---Safe to call multiple times - will only initialize once
function TRB.Functions.EditMode:Initialize()
	if isInitialized then
		return
	end

	LibEditMode = TRB.Details.addonData.libs.LibEditMode
	if not LibEditMode then
		return
	end

	isInitialized = true

	-- Register for layout change callback
	LibEditMode:RegisterCallback('layout', function(layoutName, layoutIndex)
		self:OnLayoutChanged(layoutName, layoutIndex)
	end)

	-- Register for layout rename callback
	LibEditMode:RegisterCallback('rename', function(oldLayoutName, newLayoutName, layoutIndex)
		self:OnLayoutRenamed(oldLayoutName, newLayoutName, layoutIndex)
	end)

	-- Register for layout delete callback
	LibEditMode:RegisterCallback('delete', function(layoutName)
		self:OnLayoutDeleted(layoutName)
	end)

	-- Register for enter/exit callbacks to manage drag-and-drop state
	LibEditMode:RegisterCallback('enter', function()
		self:OnEditModeEnter()
	end)

	LibEditMode:RegisterCallback('exit', function()
		self:OnEditModeExit()
	end)
end

---Clears the registered frame reference
---Call this when bar groups are destroyed to ensure re-registration on next bar creation
function TRB.Functions.EditMode:ClearRegisteredFrame()
	registeredFrame = nil
end

---Normalizes a frame's position to an anchor point and offsets
---This mimics LibEditMode's normalizePosition function
---@param frame Frame # The frame to normalize position for
---@return string? point # The calculated anchor point
---@return number? x # The x offset from the anchor
---@return number? y # The y offset from the anchor
function TRB.Functions.EditMode:NormalizePosition(frame)
	if not frame then
		return nil, nil, nil
	end

	local parent = frame:GetParent()
	if not parent then
		return nil, nil, nil
	end

	local scale = frame:GetScale()
	if not scale then
		return nil, nil, nil
	end

	local left = frame:GetLeft()
	local top = frame:GetTop()
	local right = frame:GetRight()
	local bottom = frame:GetBottom()

	if not (left and top and right and bottom) then
		return nil, nil, nil
	end

	left = left * scale
	top = top * scale
	right = right * scale
	bottom = bottom * scale

	local parentWidth, parentHeight = parent:GetSize()

	local x, y, point
	if left < (parentWidth - right) and left < math.abs((left + right) / 2 - parentWidth / 2) then
		x = left
		point = 'LEFT'
	elseif (parentWidth - right) < math.abs((left + right) / 2 - parentWidth / 2) then
		x = right - parentWidth
		point = 'RIGHT'
	else
		x = (left + right) / 2 - parentWidth / 2
		point = ''
	end

	if bottom < (parentHeight - top) and bottom < math.abs((bottom + top) / 2 - parentHeight / 2) then
		y = bottom
		point = 'BOTTOM' .. point
	elseif (parentHeight - top) < math.abs((bottom + top) / 2 - parentHeight / 2) then
		y = top - parentHeight
		point = 'TOP' .. point
	else
		y = (bottom + top) / 2 - parentHeight / 2
		point = '' .. point
	end

	if point == '' then
		point = 'CENTER'
	end

	return point, x / scale, y / scale
end

---Registers the primary bar with Edit Mode
---@param containerFrame Frame # The primary bar's container frame
function TRB.Functions.EditMode:RegisterPrimaryBar(containerFrame)
	if not LibEditMode then
		return
	end

	if not containerFrame then
		return
	end

	-- Don't re-register the exact same frame object
	if registeredFrame == containerFrame then
		return
	end

	-- Update the tracked frame reference
	registeredFrame = containerFrame

	-- Get default position from current spec settings or fall back to core defaults
	local defaultPosition = self:GetDefaultPosition()

	-- Register the frame with LibEditMode
	-- LibEditMode will create a new selection frame as a child of this frame
	LibEditMode:AddFrame(
		containerFrame,
		function(frame, layoutName, point, x, y)
			self:OnPositionChanged(frame, layoutName, point, x, y)
		end,
		defaultPosition,
		L["TRBAddonName"]
	)

	-- Add the "Enable for this layout" checkbox setting
	LibEditMode:AddFrameSettings(containerFrame, {
		{
			kind = LibEditMode.SettingType.Checkbox,
			name = L["EditModeEnableForLayout"],
			desc = L["EditModeEnableForLayoutTooltip"],
			default = false,
			get = function(layoutName)
				return self:IsLayoutEnabled(layoutName)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetLayoutEnabled(layoutName, newValue)

				-- When enabling for the first time, capture the current bar position
				-- so the bar doesn't jump when Edit Mode takes over
				if newValue and layoutName then
					self:EnsureLayoutSettings(layoutName)
					local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
					if not layoutData.position then
						-- No position saved yet - capture current position from the bar
						-- Use NormalizePosition to get the correct anchor point and offsets
						-- based on where the bar actually is on screen
						if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
							local frame = TRB.Frames.barGroups.primary:GetContainerFrame()
							local point, x, y = self:NormalizePosition(frame)
							if point and x and y then
								layoutData.position = {
									point = point,
									x = x,
									y = y
								}
							else
								-- Fallback to legacy settings if normalization fails
								local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
								if specSettings and specSettings.settings and specSettings.settings.bar then
									layoutData.position = {
										point = "CENTER",
										x = specSettings.settings.bar.xPos or 0,
										y = specSettings.settings.bar.yPos or -200
									}
								end
							end
						end
					end
				end

				-- Reapply position when toggling
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.specName].settings,
						TRB.Frames.barGroups
					)
				end
			end,
		},
	})

	-- If we're registering while Edit Mode is active (e.g., after a spec switch),
	-- we need to show the selection frame and make the bar visible
	if LibEditMode:IsInEditMode() then
		-- Show the bar so it's visible in Edit Mode
		containerFrame:Show()

		-- LibEditMode stores selection frames keyed by the frame reference
		-- Access the selection frame and show it
		local selection = LibEditMode.frameSelections and LibEditMode.frameSelections[containerFrame]
		if selection and selection.ShowHighlighted then
			selection:ShowHighlighted()
		end
	end
end

---Gets the default position for the bar
---Uses NormalizePosition to capture the actual current position if the bar exists
---@return table # Default position table with point, x, y
function TRB.Functions.EditMode:GetDefaultPosition()
	-- First try to get the actual current position from the bar frame
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
		local frame = TRB.Frames.barGroups.primary:GetContainerFrame()
		local point, x, y = self:NormalizePosition(frame)
		if point and x and y then
			return {
				point = point,
				x = x,
				y = y
			}
		end
	end

	-- Fallback to legacy settings
	local xPos = 0
	local yPos = -200

	if TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
		if specSettings and specSettings.settings and specSettings.settings.bar then
			xPos = specSettings.settings.bar.xPos or xPos
			yPos = specSettings.settings.bar.yPos or yPos
		end
	end

	return {
		point = "CENTER",
		x = xPos,
		y = yPos
	}
end

---Callback when the bar position is changed in Edit Mode
---@param frame Frame # The frame that was moved
---@param layoutName string # The current layout name
---@param point string # The anchor point
---@param x number # X offset
---@param y number # Y offset
function TRB.Functions.EditMode:OnPositionChanged(frame, layoutName, point, x, y)
	if not layoutName then
		return
	end

	-- Ensure settings structure exists
	self:EnsureLayoutSettings(layoutName)

	-- Save the position for this layout
	local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
	layoutData.position = {
		point = point,
		x = x,
		y = y
	}

	-- Mark this layout as having a custom position if it's enabled
	-- (The enabled flag is controlled separately via the checkbox)
end

---Called when the Edit Mode layout changes
---@param layoutName string # The new layout name
---@param layoutIndex number # The layout index
function TRB.Functions.EditMode:OnLayoutChanged(layoutName, layoutIndex)
	-- Reapply bar position based on the new layout
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
		if specSettings and specSettings.settings then
			TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
		end
	end
end

---Called when an Edit Mode layout is renamed
---@param oldLayoutName string # The old layout name
---@param newLayoutName string # The new layout name
---@param layoutIndex number # The layout index
function TRB.Functions.EditMode:OnLayoutRenamed(oldLayoutName, newLayoutName, layoutIndex)
	if not TRB.Data.settings.core.editMode.layouts then
		return
	end

	-- Migrate settings from old name to new name
	local oldData = TRB.Data.settings.core.editMode.layouts[oldLayoutName]
	if oldData then
		TRB.Data.settings.core.editMode.layouts[newLayoutName] = oldData
		TRB.Data.settings.core.editMode.layouts[oldLayoutName] = nil
	end
end

---Called when an Edit Mode layout is deleted
---@param layoutName string # The deleted layout name
function TRB.Functions.EditMode:OnLayoutDeleted(layoutName)
	if not TRB.Data.settings.core.editMode.layouts then
		return
	end

	-- Remove settings for the deleted layout
	TRB.Data.settings.core.editMode.layouts[layoutName] = nil
end

---Called when Edit Mode is entered
function TRB.Functions.EditMode:OnEditModeEnter()
	-- Disable the legacy drag-and-drop while in Edit Mode
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
		TRB.Frames.barGroups.primary:SetDragAndDrop(false, nil)

		-- Show the bar during Edit Mode so it can be interacted with
		-- (even if it would normally be hidden outside of combat)
		TRB.Frames.barGroups.primary:Show()
	end
end

---Called when Edit Mode is exited
function TRB.Functions.EditMode:OnEditModeExit()
	-- Re-enable legacy drag-and-drop if it was enabled in settings
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
		if specSettings and specSettings.settings and specSettings.settings.bar.dragAndDrop then
			TRB.Frames.barGroups.primary:SetDragAndDrop(true, specSettings.settings)
		end

		-- Let HideResourceBar determine if the bar should be visible now
		TRB.Functions.Class:HideResourceBar()
	end
end

---Ensures the layout settings structure exists for a given layout
---@param layoutName string # The layout name
function TRB.Functions.EditMode:EnsureLayoutSettings(layoutName)
	if not TRB.Data.settings.core.editMode then
		TRB.Data.settings.core.editMode = {
			layouts = {}
		}
	end

	if not TRB.Data.settings.core.editMode.layouts then
		TRB.Data.settings.core.editMode.layouts = {}
	end

	if not TRB.Data.settings.core.editMode.layouts[layoutName] then
		TRB.Data.settings.core.editMode.layouts[layoutName] = {
			enabled = false,
			position = nil
		}
	end
end

---Checks if a layout is enabled for Edit Mode positioning
---@param layoutName string? # The layout name (uses active layout if nil)
---@return boolean # True if the layout is enabled
function TRB.Functions.EditMode:IsLayoutEnabled(layoutName)
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return false
	end

	if not TRB.Data.settings.core.editMode or not TRB.Data.settings.core.editMode.layouts then
		return false
	end

	local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
	return layoutData and layoutData.enabled == true
end

---Sets whether a layout is enabled for Edit Mode positioning
---@param layoutName string # The layout name
---@param enabled boolean # Whether to enable Edit Mode for this layout
function TRB.Functions.EditMode:SetLayoutEnabled(layoutName, enabled)
	self:EnsureLayoutSettings(layoutName)
	TRB.Data.settings.core.editMode.layouts[layoutName].enabled = enabled
end

---Gets the position for the current Edit Mode layout if enabled
---@return table? # Position table {point, x, y} or nil if not using Edit Mode
function TRB.Functions.EditMode:GetActivePosition()
	if not LibEditMode then
		return nil
	end

	local layoutName = LibEditMode:GetActiveLayoutName()
	if not layoutName then
		return nil
	end

	-- Check if this layout is enabled
	if not self:IsLayoutEnabled(layoutName) then
		return nil
	end

	-- Get the saved position for this layout
	local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
	if layoutData and layoutData.position then
		return layoutData.position
	end

	return nil
end

---Checks if Edit Mode is currently active
---@return boolean
function TRB.Functions.EditMode:IsInEditMode()
	if not LibEditMode then
		return false
	end
	return LibEditMode:IsInEditMode()
end

---@deprecated No longer needed - Edit Mode is controlled per-layout only
---@return boolean # Always returns true for backwards compatibility
function TRB.Functions.EditMode:IsGlobalOptInEnabled()
	return true
end

---@deprecated No longer needed - Edit Mode is controlled per-layout only
---@param enabled boolean
function TRB.Functions.EditMode:SetGlobalOptIn(enabled)
	-- No-op, kept for backwards compatibility
end
