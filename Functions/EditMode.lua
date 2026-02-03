---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local L = TRB.Localization

TRB.Functions = TRB.Functions or {}
TRB.Functions.EditMode = {}

-- Local reference to LibEditMode
local LibEditMode = nil

-- Track the currently registered container frame to prevent duplicate registrations
local registeredFrame = nil

-- Edit Mode wrapper frame - this is the PARENT of the primary bar container
-- When LibEditMode drags this frame, all bars (children) move with it
local editModeWrapperFrame = nil

-- Track if Initialize has been called
local isInitialized = false

-- Guard to prevent re-entrancy when temporarily showing CDM to get dimensions
local isTemporarilyShowingCDM = false

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

	-- Try to hook the Cooldown Manager resize and show events
	-- This may fail if CDM doesn't exist yet; we'll retry in RegisterPrimaryBar
	self:HookCooldownManagerResize()
	self:HookCooldownManagerShow()
end

---Clears the registered frame reference
---Call this when bar groups are destroyed to ensure re-registration on next bar creation
function TRB.Functions.EditMode:ClearRegisteredFrame()
	-- Hide any selection frame that might be visible
	-- This prevents the Edit Mode overlay from showing after spec changes
	if editModeWrapperFrame and LibEditMode and LibEditMode.frameSelections then
		local selection = LibEditMode.frameSelections[editModeWrapperFrame]
		if selection and not LibEditMode:IsInEditMode() then
			selection:Hide()
		end
	end
	
	-- Clear tracking but keep the wrapper frame registered with LibEditMode
	-- The wrapper frame persists and will be reused
	registeredFrame = nil
end

---Gets or creates the Edit Mode wrapper frame
---This frame is the PARENT of the primary bar container
---When LibEditMode drags this frame, all bars move with it
---@return Frame
function TRB.Functions.EditMode:GetOrCreateWrapperFrame()
	if editModeWrapperFrame then
		return editModeWrapperFrame
	end

	-- Create a wrapper frame parented to UIParent
	editModeWrapperFrame = CreateFrame("Frame", "TRB_EditModeWrapper", UIParent)
	editModeWrapperFrame:SetFrameStrata("BACKGROUND")
	editModeWrapperFrame:SetFrameLevel(1)
	-- Start with a default size - will be updated to encompass all bars
	editModeWrapperFrame:SetSize(100, 100)
	editModeWrapperFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -200)

	return editModeWrapperFrame
end

---Gets the wrapper frame (nil if not yet created)
---@return Frame?
function TRB.Functions.EditMode:GetWrapperFrame()
	return editModeWrapperFrame
end

---Updates the wrapper frame's size to encompass all bars and positions the primary bar within it
---The wrapper position is controlled by LibEditMode or CDM anchoring
---@param settings table? # Settings table for dimension calculations
function TRB.Functions.EditMode:UpdateWrapperSize(settings)
	if not editModeWrapperFrame then
		return
	end

	local barGroups = TRB.Frames.barGroups
	if not barGroups or not barGroups.primary then
		return
	end

	-- Check if Edit Mode layout is enabled for this layout
	local editModeLayoutEnabled = self:IsLayoutEnabled()

	-- When Edit Mode layout is disabled, the wrapper should match the primary bar exactly.
	-- Secondary bars anchor to the primary bar container (not the wrapper), so they will
	-- position correctly relative to the center of the primary bar.
	-- When Edit Mode layout is enabled, the wrapper encompasses all bars for proper selection box.
	if not editModeLayoutEnabled then
		-- Legacy mode: wrapper matches primary bar dimensions, primary bar fills wrapper
		local effectiveWidth = (barGroups.effectiveWidth) or (settings and settings.bar and settings.bar.width) or 100
		local primaryHeight = (settings and settings.bar and settings.bar.height) or 100
		editModeWrapperFrame:SetSize(effectiveWidth, primaryHeight)

		-- Primary bar centered within the wrapper (legacy behavior)
		local primaryFrame = barGroups.primary.containerFrame
		primaryFrame:ClearAllPoints()
		primaryFrame:SetPoint("CENTER", editModeWrapperFrame, "CENTER", 0, 0)
		return
	end

	-- Edit Mode layout is enabled - encompass all bars for proper selection box

	-- In Edit Mode, include all bars (even hidden ones)
	local includeHidden = self:IsInEditMode()

	-- Calculate wrapper layout from settings (doesn't rely on screen coordinates)
	local totalWidth, totalHeight, extendAbove, extendBelow = self:CalculateWrapperLayout(settings, includeHidden)

	-- Size the wrapper to encompass all bars
	if totalWidth > 0 and totalHeight > 0 then
		editModeWrapperFrame:SetSize(totalWidth, totalHeight)
	end

	-- Reposition the primary bar within the wrapper to account for bars above it
	-- The primary bar should be offset down by extendAbove
	local primaryFrame = barGroups.primary.containerFrame
	primaryFrame:ClearAllPoints()
	primaryFrame:SetPoint("TOP", editModeWrapperFrame, "TOP", 0, -extendAbove)
end

---Calculates layout information for the wrapper frame based on settings
---This calculates dimensions and offsets without relying on screen coordinates
---@param settings table? # Settings table for dimension calculations
---@param includeHidden boolean? # If true, include hidden bars (for Edit Mode)
---@return number totalWidth # Total width needed
---@return number totalHeight # Total height needed
---@return number extendAbove # How much bars extend above the primary bar
---@return number extendBelow # How much bars extend below the primary bar
function TRB.Functions.EditMode:CalculateWrapperLayout(settings, includeHidden)
	local barGroups = TRB.Frames.barGroups
	if not barGroups or not barGroups.primary then
		return 100, 100, 0, 0
	end

	-- Use settings if provided, otherwise try to get from spec cache
	if not settings and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
		if specSettings then
			settings = specSettings.settings
		end
	end

	if not settings then
		return 100, 100, 0, 0
	end

	-- Start with primary bar dimensions
	local effectiveWidth = (barGroups.effectiveWidth) or settings.bar.width
	local totalWidth = effectiveWidth

	-- Check if primary bar is permanently hidden; collapse its height to 0 if so
	local primaryVisibilitySetting = settings.displayBar and settings.displayBar.primary
	local primaryVisible = primaryVisibilitySetting ~= "never"
	local primaryHeight = (primaryVisible or includeHidden) and settings.bar.height or 0

	local extendAbove = 0
	local extendBelow = 0

	-- Helper to determine if a bar is above or below primary based on relativeTo
	local function isAbovePrimary(relativeTo)
		return relativeTo == "TOP" or relativeTo == "TOPLEFT" or relativeTo == "TOPRIGHT"
	end

	-- Add secondary bar (combo points, arcane charges, etc.) if visible or includeHidden
	-- DRUID SPECIAL CASE: Non-Feral Druids don't have comboPoints in their settings,
	-- but they DO have a secondary bar group for combo points when in cat form.
	-- Check Feral settings for Druids when the current spec doesn't have comboPoints.
	local comboPointSettings = settings.comboPoints
	if not comboPointSettings and TRB.Data.character.classId == 11 then
		local feralSettings = TRB.Data.specCache and TRB.Data.specCache.feral and TRB.Data.specCache.feral.settings
		if feralSettings and feralSettings.comboPoints then
			comboPointSettings = feralSettings.comboPoints
		end
	end

	if barGroups.secondary and comboPointSettings then
		local secondaryGroup = barGroups.secondary
		-- Check displayBar settings rather than IsShown() since the bar may not be shown yet
		local secondaryVisibilitySetting = settings.displayBar and settings.displayBar.secondary
		local secondaryVisible = secondaryVisibilitySetting ~= "never"
		
		if secondaryVisible or includeHidden then
			local secondaryHeight = comboPointSettings.height or 0
			local secondarySpacing = math.abs(comboPointSettings.yPos or 0)
			local barHeight = secondaryHeight + secondarySpacing
			
			local relativeTo = comboPointSettings.relativeTo or "TOP"
			if isAbovePrimary(relativeTo) then
				extendAbove = extendAbove + barHeight
			else
				extendBelow = extendBelow + barHeight
			end
			
			-- Secondary bar might be wider if not fullWidth
			if not comboPointSettings.fullWidth then
				local nodeCount = TRB.Data.character.maxResource2 or secondaryGroup.nodeCount or 5
				local nodeWidth = comboPointSettings.width or 10
				local nodeSpacing = comboPointSettings.spacing or 2
				local secondaryWidth = (nodeWidth * nodeCount) + (nodeSpacing * (nodeCount - 1)) + (comboPointSettings.border or 1) * 2
				totalWidth = math.max(totalWidth, secondaryWidth)
			end
		end
	end

	-- Add health bar if visible or includeHidden
	if barGroups.health and settings.healthBar then
		-- Check displayBar settings rather than IsShown() since the bar may not be shown yet
		local healthVisibilitySetting = settings.displayBar and settings.displayBar.health
		local healthVisible = healthVisibilitySetting ~= "never"
		
		if healthVisible or includeHidden then
			local healthHeight = settings.healthBar.height or 0
			local healthSpacing = math.abs(settings.healthBar.yPos or 0)
			local barHeight = healthHeight + healthSpacing
			
			local relativeTo = settings.healthBar.relativeTo or "BOTTOM"
			if isAbovePrimary(relativeTo) then
				extendAbove = extendAbove + barHeight
			else
				extendBelow = extendBelow + barHeight
			end
		end
	end

	-- Check for custom bar types (stagger, mana bar, etc.) from the BarTypeRegistry
	local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
	if registry then
		local allBarTypes = registry:GetAll()
		for barKey, barTypeDef in pairs(allBarTypes) do
			if barGroups[barKey] and settings.bars and settings.bars[barKey] then
				-- Check displayBar settings rather than IsShown() since the bar may not be shown yet
				-- Custom bars use the visibilityKey from the barTypeDef (e.g., "mana", "stagger")
				local visibilityKey = barTypeDef.visibilityKey or barKey
				local customVisibilitySetting = settings.displayBar and settings.displayBar[visibilityKey]
				local customVisible = customVisibilitySetting ~= "never"
				
				if customVisible or includeHidden then
					local customSettings = settings.bars[barKey]
					local customHeight = customSettings.height or 0
					local customSpacing = math.abs(customSettings.yPos or 0)
					local barHeight = customHeight + customSpacing
					
					local relativeTo = customSettings.relativeTo or "TOP"
					if isAbovePrimary(relativeTo) then
						extendAbove = extendAbove + barHeight
					else
						extendBelow = extendBelow + barHeight
					end
				end
			end
		end
	end

	local totalHeight = primaryHeight + extendAbove + extendBelow
	return totalWidth, totalHeight, extendAbove, extendBelow
end

---Calculates the total dimensions needed to encompass all bars
---@param settings table? # Settings table for dimension calculations
---@param includeHidden boolean? # If true, include hidden bars (for Edit Mode)
---@return number? width # Total width
---@return number? height # Total height
function TRB.Functions.EditMode:CalculateTotalBarDimensions(settings, includeHidden)
	local totalWidth, totalHeight = self:CalculateWrapperLayout(settings, includeHidden)
	return totalWidth, totalHeight
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

---Registers the primary bar with Edit Mode using a wrapper frame
---The wrapper becomes the parent of the primary bar container
---@param containerFrame Frame # The primary bar's container frame
function TRB.Functions.EditMode:RegisterPrimaryBar(containerFrame)
	if not LibEditMode then
		return
	end

	if not containerFrame then
		return
	end

	-- Get or create the wrapper frame
	local wrapperFrame = self:GetOrCreateWrapperFrame()

	-- Don't re-register the same wrapper (check both our tracking variable AND LibEditMode's registry)
	-- The wrapper frame persists across spec changes, so it may already be registered
	local alreadyRegistered = registeredFrame == wrapperFrame or 
		(LibEditMode.frameSelections and LibEditMode.frameSelections[wrapperFrame])
	
	if alreadyRegistered then
		-- Update tracking and size, but don't re-add to LibEditMode
		registeredFrame = wrapperFrame
		self.primaryContainerFrame = containerFrame
		self:UpdateWrapperSize()
		
		-- Even when already registered, we need to reapply layout after a delay
		-- to ensure CDM width matching is applied correctly after spec switches.
		-- The CDM frame dimensions may not be finalized when ConstructBarGroups runs.
		C_Timer.After(0, function()
			C_Timer.After(0.1, function()
				if not TRB.Data.specSupported then
					return
				end
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
					local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
					if specSettings and specSettings.settings then
						TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
					end
				end
			end)
		end)
		return
	end

	-- Update the tracked frame reference
	registeredFrame = wrapperFrame

	-- Store reference to the primary container
	self.primaryContainerFrame = containerFrame

	-- Get default position from current spec settings or fall back to core defaults
	local defaultPosition = self:GetDefaultPosition()

	-- Register the WRAPPER frame with LibEditMode (not the primary container)
	-- When the wrapper is dragged, the primary bar (as its child) moves with it
	LibEditMode:AddFrame(
		wrapperFrame,
		function(frame, layoutName, point, x, y)
			self:OnPositionChanged(frame, layoutName, point, x, y)
		end,
		defaultPosition,
		L["TRBAddonName"]
	)

	-- Add the "Enable for this layout" checkbox setting
	LibEditMode:AddFrameSettings(wrapperFrame, {
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

				-- When enabling for the first time, capture the current wrapper position
				-- so the bar doesn't jump when Edit Mode takes over
				if newValue and layoutName then
					self:EnsureLayoutSettings(layoutName)
					local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
					if not layoutData.position then
						-- No position saved yet - capture current WRAPPER position
						-- The wrapper is what LibEditMode moves, so its position is what we save/restore
						-- IMPORTANT: Use the wrapper, NOT the container (which is positioned inside the wrapper)
						if editModeWrapperFrame then
							local point, x, y = self:NormalizePosition(editModeWrapperFrame)
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
		{
			kind = LibEditMode.SettingType.Divider,
		},
		{
			kind = LibEditMode.SettingType.Dropdown,
			name = L["EditModeAnchorTo"],
			desc = L["EditModeAnchorToTooltip"],
			default = "none",
			values = {
				{ text = L["EditModeAnchorFreePosition"], value = "none" },
				{ text = L["EditModeAnchorAboveCDM"], value = "above" },
				{ text = L["EditModeAnchorBelowCDM"], value = "below" },
			},
			get = function(layoutName)
				-- Use Raw version so UI always shows actual saved value, not effective value
				return self:GetAnchorModeRaw(layoutName)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetAnchorMode(layoutName, newValue)

				-- Reapply position when changing anchor mode
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.specName].settings,
						TRB.Frames.barGroups
					)
				end
			end,
		},
		{
			kind = LibEditMode.SettingType.Slider,
			name = L["EditModeAnchorOffset"],
			desc = L["EditModeAnchorOffsetTooltip"],
			default = 0,
			minValue = -200,
			maxValue = 200,
			valueStep = 1,
			get = function(layoutName)
				return self:GetAnchorOffset(layoutName)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetAnchorOffset(layoutName, newValue)

				-- Reapply position when changing offset
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.specName].settings,
						TRB.Frames.barGroups
					)
				end
			end,
		},
		{
			kind = LibEditMode.SettingType.Checkbox,
			name = L["EditModeMatchCDMWidth"],
			desc = L["EditModeMatchCDMWidthTooltip"],
			default = false,
			get = function(layoutName)
				-- Use Raw version so UI always shows actual saved value, not effective value
				return self:IsWidthMatchingEnabledRaw(layoutName)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetWidthMatchingEnabled(layoutName, newValue)

				-- Reapply layout when toggling width matching
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.specName].settings,
						TRB.Frames.barGroups
					)
				end
			end,
		},
	})

	-- Try to hook the Cooldown Manager resize and show events (retry in case they weren't available during Initialize)
	self:HookCooldownManagerResize()
	self:HookCooldownManagerShow()


	-- If we're registering while Edit Mode is active (e.g., after a spec switch),
	-- we need to show the selection frame and make the bar visible
	if LibEditMode:IsInEditMode() then
		-- Raise the wrapper strata so selection frame can receive clicks
		wrapperFrame:SetFrameStrata("DIALOG")
		wrapperFrame:SetFrameLevel(100)

		-- Show the bar so it's visible in Edit Mode
		containerFrame:Show()

		-- LibEditMode stores selection frames keyed by the registered frame (wrapperFrame, not containerFrame)
		local selection = LibEditMode.frameSelections and LibEditMode.frameSelections[wrapperFrame]
		if selection and selection.ShowHighlighted then
			selection:ShowHighlighted()
		end
	end
end

---Gets the default position for the bar
---Uses NormalizePosition to capture the actual current position if the wrapper exists
---@return table # Default position table with point, x, y
function TRB.Functions.EditMode:GetDefaultPosition()
	-- Use the wrapper frame position, NOT the container frame
	-- The wrapper is what LibEditMode moves, so its position is what we save/restore
	if editModeWrapperFrame then
		local point, x, y = self:NormalizePosition(editModeWrapperFrame)
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
---@param frame Frame # The frame that was moved (the primary bar container)
---@param layoutName string # The current layout name
---@param point string # The anchor point
---@param x number # X offset
---@param y number # Y offset
function TRB.Functions.EditMode:OnPositionChanged(frame, layoutName, point, x, y)
	if not layoutName then
		return
	end

	-- Check if Edit Mode is enabled for this layout
	-- If not enabled, ignore position changes - use legacy positioning instead
	if not self:IsLayoutEnabled(layoutName) then
		-- Not enabled - revert to legacy position
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local specSettings = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.specName]
			if specSettings and specSettings.settings then
				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
			end
		end
		return
	end

	-- Check if we're using CDM anchoring - if so, ignore position changes
	-- The bar should stay anchored to CDM, not be freely positioned
	local anchorMode = self:GetAnchorMode(layoutName)
	if anchorMode ~= "none" and self:IsCooldownManagerAvailable() then
		-- CDM anchored - revert to CDM position instead of saving
		-- Reapply the full bar layout to restore correct CDM anchoring
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local specSettings = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.specName]
			if specSettings and specSettings.settings then
				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
			end
		end
		return
	end

	-- LibEditMode has moved the wrapper frame
	-- Save the new position for this layout

	-- Ensure settings structure exists
	self:EnsureLayoutSettings(layoutName)

	-- Save the position for this layout
	local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
	layoutData.position = {
		point = point,
		x = x,
		y = y
	}
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
	-- Raise the wrapper frame's strata so the selection frame can receive mouse events
	-- The selection frame is a child of the wrapper, so it inherits wrapper's strata
	-- Without this, the bar frames (at higher levels within BACKGROUND) block clicks
	if editModeWrapperFrame then
		editModeWrapperFrame:SetFrameStrata("DIALOG")
		editModeWrapperFrame:SetFrameLevel(100)
	end

	-- Disable the legacy drag-and-drop while in Edit Mode
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
		TRB.Frames.barGroups.primary:SetDragAndDrop(false, nil)

		-- Show the bar during Edit Mode so it can be interacted with
		-- (even if it would normally be hidden outside of combat)
		TRB.Frames.barGroups.primary:Show()
	end

	-- Rebuild bar text frames to maintain proper strata/level ordering during Edit Mode
	TRB.Functions.BarText:CreateBarTextFrames()
end

---Called when Edit Mode is exited
function TRB.Functions.EditMode:OnEditModeExit()
	-- Lower the wrapper frame's strata back to normal
	if editModeWrapperFrame then
		editModeWrapperFrame:SetFrameStrata("BACKGROUND")
		editModeWrapperFrame:SetFrameLevel(1)
	end

	-- Re-enable legacy drag-and-drop if it was enabled in settings and reapply layout
	-- Reapplying layout is critical to reset all frame stratas/levels that were affected during Edit Mode
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
		if specSettings and specSettings.settings then
			-- Reapply layout to reset frame stratas and levels
			TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
			
			-- Re-enable legacy drag-and-drop if it was enabled in settings
			if specSettings.settings.bar.dragAndDrop then
				TRB.Frames.barGroups.primary:SetDragAndDrop(true, specSettings.settings)
			end
		end

		-- Rebuild bar text frames to restore proper strata/level ordering
		-- This ensures bar text appears above thresholds after Edit Mode's strata changes
		TRB.Functions.BarText:CreateBarTextFrames()

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
			position = nil,
			anchorToCooldownManager = "none",
			anchorOffset = 0,
			matchCooldownManagerWidth = false
		}
	end

	-- Ensure new fields exist for existing layouts (migration)
	local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]
	if layoutData.anchorToCooldownManager == nil then
		layoutData.anchorToCooldownManager = "none"
	end
	if layoutData.anchorOffset == nil then
		layoutData.anchorOffset = 0
	end
	if layoutData.matchCooldownManagerWidth == nil then
		layoutData.matchCooldownManagerWidth = false
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

-- ============================================================================
-- Cooldown Manager Integration
-- ============================================================================

-- Track whether we've hooked the CDM's OnSizeChanged and OnShow
local cdmSizeHooked = false
local cdmShowHooked = false

---Gets the Cooldown Manager (Essential Cooldowns) frame if available
---@param requireVisible boolean? # If true, only returns frame if visible (default: false)
---@return Frame? # The EssentialCooldownViewer frame or nil if not available
function TRB.Functions.EditMode:GetCooldownManagerFrame(requireVisible)
	-- EssentialCooldownViewer is the global name for the Essential Cooldowns frame
	if EssentialCooldownViewer then
		if requireVisible and not EssentialCooldownViewer:IsVisible() then
			return nil
		end
		return EssentialCooldownViewer
	end
	return nil
end

---Checks if the Cooldown Manager is available (frame exists)
---@return boolean # True if CDM frame exists
function TRB.Functions.EditMode:IsCooldownManagerAvailable()
	return self:GetCooldownManagerFrame() ~= nil
end

---Helper function to reapply bar layout when CDM changes
---@param layoutName string? # Optional layout name override
---@param forceUpdate boolean? # If true, skip the "no change" optimization
local function ReapplyCooldownManagerLayout(layoutName, forceUpdate)
	if not TRB.Data.specSupported then
		return
	end
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return
	end

	local layoutData = TRB.Data.settings.core.editMode.layouts and TRB.Data.settings.core.editMode.layouts[layoutName]
	if not layoutData then
		return
	end

	-- Only trigger updates if we're using CDM width matching or anchoring
	if layoutData.matchCooldownManagerWidth or (layoutData.anchorToCooldownManager and layoutData.anchorToCooldownManager ~= "none") then
		-- Reapply bar layout to update width/position
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
			local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
			if specSettings and specSettings.settings then
				-- Skip layout update if width hasn't changed (avoids flickering)
				-- We already got CDM width via temporary show, so bar is already sized correctly
				if not forceUpdate then
					local currentEffectiveWidth = TRB.Frames.barGroups.effectiveWidth
					local cdmWidth = TRB.Functions.EditMode:GetCooldownManagerWidth()
					if currentEffectiveWidth and cdmWidth and math.abs(currentEffectiveWidth - cdmWidth) < 1 then
						-- Width is already correct, no need to reapply layout
						return
					end
				end
				
				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
				-- Restore correct bar visibility after layout changes
				-- ApplyBarGroupsLayout may show bars that should be hidden
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end
end

---Hooks the Cooldown Manager's OnSizeChanged to update bar layout when CDM width changes
---Safe to call multiple times - will only hook once
function TRB.Functions.EditMode:HookCooldownManagerResize()
	if cdmSizeHooked then
		return
	end

	-- Wait for the frame to exist
	if not EssentialCooldownViewer then
		return
	end

	-- Use HookScript to post-hook rather than replace (prevents taint)
	EssentialCooldownViewer:HookScript("OnSizeChanged", function(frame, width, height)
		ReapplyCooldownManagerLayout()
	end)

	cdmSizeHooked = true
end

---Hooks the Cooldown Manager's OnShow to update bar layout when CDM first becomes visible
---This ensures width matching works when CDM is shown after TRB is already initialized
---Safe to call multiple times - will only hook once
function TRB.Functions.EditMode:HookCooldownManagerShow()
	if cdmShowHooked then
		return
	end

	-- Wait for the frame to exist
	if not EssentialCooldownViewer then
		return
	end

	-- Use HookScript to post-hook rather than replace (prevents taint)
	-- Add a small delay to ensure CDM dimensions are finalized after showing
	-- Use nested timers to ensure the callback actually fires.
	-- Check the guard to prevent re-entrancy when we temporarily show CDM for dimension queries.
	EssentialCooldownViewer:HookScript("OnShow", function(frame)
		if isTemporarilyShowingCDM then
			return
		end
		C_Timer.After(0, function()
			C_Timer.After(0.1, function()
				ReapplyCooldownManagerLayout()
			end)
		end)
	end)

	cdmShowHooked = true
	
	-- If CDM is already visible when we hook it (e.g., "Always Show" setting),
	-- trigger layout update immediately since OnShow won't fire.
	-- Use nested timers to ensure the callback actually fires.
	if EssentialCooldownViewer:IsShown() then
		C_Timer.After(0, function()
			C_Timer.After(0.1, function()
				ReapplyCooldownManagerLayout()
			end)
		end)
	end
end

---Gets the anchor mode for the current layout
---This returns the EFFECTIVE anchor mode (for bar positioning)
---Returns "none" if layout is not enabled
---@param layoutName string? # The layout name (uses active layout if nil)
---@return string # "none", "above", or "below"
function TRB.Functions.EditMode:GetAnchorMode(layoutName)
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	-- If Edit Mode layout is not enabled, anchor mode is always "none"
	-- This ensures CDM settings only apply when "Enable for this layout" is checked
	if not self:IsLayoutEnabled(layoutName) then
		return "none"
	end

	self:EnsureLayoutSettings(layoutName)
	return TRB.Data.settings.core.editMode.layouts[layoutName].anchorToCooldownManager or "none"
end

---Gets the RAW saved anchor mode for the current layout (for UI display)
---This returns the actual saved value regardless of whether layout is enabled
---@param layoutName string? # The layout name (uses active layout if nil)
---@return string # "none", "above", or "below"
function TRB.Functions.EditMode:GetAnchorModeRaw(layoutName)
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	self:EnsureLayoutSettings(layoutName)
	return TRB.Data.settings.core.editMode.layouts[layoutName].anchorToCooldownManager or "none"
end

---Sets the anchor mode for a layout
---@param layoutName string # The layout name
---@param mode string # "none", "above", or "below"
function TRB.Functions.EditMode:SetAnchorMode(layoutName, mode)
	self:EnsureLayoutSettings(layoutName)
	TRB.Data.settings.core.editMode.layouts[layoutName].anchorToCooldownManager = mode
end

---Gets the anchor offset for the current layout
---@param layoutName string? # The layout name (uses active layout if nil)
---@return number # The vertical offset in pixels
function TRB.Functions.EditMode:GetAnchorOffset(layoutName)
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return 0
	end

	self:EnsureLayoutSettings(layoutName)
	return TRB.Data.settings.core.editMode.layouts[layoutName].anchorOffset or 0
end

---Sets the anchor offset for a layout
---@param layoutName string # The layout name
---@param offset number # The vertical offset in pixels
function TRB.Functions.EditMode:SetAnchorOffset(layoutName, offset)
	self:EnsureLayoutSettings(layoutName)
	TRB.Data.settings.core.editMode.layouts[layoutName].anchorOffset = offset
end

---Gets whether width matching is enabled for the current layout
---This returns the EFFECTIVE value (for bar positioning)
---Returns false if layout is not enabled or anchor mode is "none"
---@param layoutName string? # The layout name (uses active layout if nil)
---@return boolean # True if width matching is enabled
function TRB.Functions.EditMode:IsWidthMatchingEnabled(layoutName)
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		-- LibEditMode hasn't initialized yet or no active layout
		-- During early initialization, we need to check if width matching MIGHT apply
		-- by looking at all saved layouts. If any enabled layout has width matching
		-- and we're anchored to CDM, assume we should try to match width.
		-- This prevents the bar from flashing to settings.bar.width during init.
		if TRB.Data.settings.core.editMode and TRB.Data.settings.core.editMode.layouts then
			for _, layoutData in pairs(TRB.Data.settings.core.editMode.layouts) do
				if layoutData.enabled and
				   layoutData.matchCooldownManagerWidth and
				   layoutData.anchorToCooldownManager and
				   layoutData.anchorToCooldownManager ~= "none" then
					-- At least one layout has CDM width matching enabled
					-- Check if CDM is actually available
					if self:IsCooldownManagerAvailable() then
						return true
					end
					break
				end
			end
		end
		return false
	end

	-- Width matching only applies when:
	-- 1. Edit Mode layout is enabled for this layout
	-- 2. Anchor mode is not "none" (actually anchored to CDM)
	if not self:IsLayoutEnabled(layoutName) then
		return false
	end

	local anchorMode = self:GetAnchorMode(layoutName)
	if anchorMode == "none" then
		return false
	end

	self:EnsureLayoutSettings(layoutName)
	return TRB.Data.settings.core.editMode.layouts[layoutName].matchCooldownManagerWidth == true
end

---Gets the RAW saved width matching setting (for UI display)
---This returns the actual saved value regardless of whether layout/anchor is enabled
---@param layoutName string? # The layout name (uses active layout if nil)
---@return boolean # True if width matching is enabled in settings
function TRB.Functions.EditMode:IsWidthMatchingEnabledRaw(layoutName)
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return false
	end

	self:EnsureLayoutSettings(layoutName)
	return TRB.Data.settings.core.editMode.layouts[layoutName].matchCooldownManagerWidth == true
end

---Sets whether width matching is enabled for a layout
---@param layoutName string # The layout name
---@param enabled boolean # Whether to enable width matching
function TRB.Functions.EditMode:SetWidthMatchingEnabled(layoutName, enabled)
	self:EnsureLayoutSettings(layoutName)
	TRB.Data.settings.core.editMode.layouts[layoutName].matchCooldownManagerWidth = enabled
end

---Calculates the bounding box of all TRB bar groups
---Returns the extreme coordinates of all bars combined
---@param includeHidden boolean? # If true, include hidden bars (for Edit Mode). Default: false
---@return number? left # Left edge of bounding box (nil if no bars)
---@return number? right # Right edge of bounding box
---@return number? top # Top edge of bounding box
---@return number? bottom # Bottom edge of bounding box
function TRB.Functions.EditMode:GetTRBBounds(includeHidden)
	local barGroups = TRB.Frames.barGroups
	if not barGroups then
		return nil, nil, nil, nil
	end

	local left, right, top, bottom = nil, nil, nil, nil

	-- Helper to update bounds from a frame
	local function updateBounds(frame)
		if not frame then
			return
		end
		
		-- Skip hidden frames unless includeHidden is true
		if not includeHidden and not frame:IsVisible() then
			return
		end

		local frameLeft = frame:GetLeft()
		local frameRight = frame:GetRight()
		local frameTop = frame:GetTop()
		local frameBottom = frame:GetBottom()

		if not (frameLeft and frameRight and frameTop and frameBottom) then
			return
		end

		if left == nil then
			left = frameLeft
			right = frameRight
			top = frameTop
			bottom = frameBottom
		else
			left = math.min(left, frameLeft)
			right = math.max(right, frameRight)
			top = math.max(top, frameTop)
			bottom = math.min(bottom, frameBottom)
		end
	end

	-- Check all bar group container frames
	for key, group in pairs(barGroups) do
		if group and type(group) == "table" then
			local containerFrame = nil
			if group.GetContainerFrame then
				containerFrame = group:GetContainerFrame()
			elseif group.containerFrame then
				containerFrame = group.containerFrame
			end
			if containerFrame then
				updateBounds(containerFrame)
			end
		end
	end

	return left, right, top, bottom
end

---Gets the Cooldown Manager's width
---If CDM is hidden (e.g., "show in combat only"), temporarily shows it to get valid dimensions
---@return number? # The width in pixels, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerWidth()
	local cdm = self:GetCooldownManagerFrame()
	if cdm then
		-- If CDM is hidden, we need to temporarily show it to get valid dimensions
		-- Hidden frames return 0 or stale values for GetWidth()
		local wasHidden = not cdm:IsShown()
		if wasHidden then
			-- Set guard to prevent OnShow hook from triggering layout updates
			isTemporarilyShowingCDM = true
			
			-- Store original alpha and set to 0 so user doesn't see the flash
			local originalAlpha = cdm:GetAlpha()
			cdm:SetAlpha(0)
			cdm:Show()
			
			-- Get the width
			local width = cdm:GetWidth()
			
			-- Restore original state
			cdm:Hide()
			cdm:SetAlpha(originalAlpha)
			
			-- Clear the guard
			isTemporarilyShowingCDM = false
			
			return width
		else
			return cdm:GetWidth()
		end
	end
	return nil
end

---Gets the Cooldown Manager's center X position
---@return number? # The center X coordinate, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerCenterX()
	local cdm = self:GetCooldownManagerFrame()
	if cdm then
		local left = cdm:GetLeft()
		local right = cdm:GetRight()
		if left and right then
			return (left + right) / 2
		end
	end
	return nil
end

---Gets the Cooldown Manager's top edge position
---@return number? # The top Y coordinate, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerTop()
	local cdm = self:GetCooldownManagerFrame()
	if cdm then
		return cdm:GetTop()
	end
	return nil
end

---Gets the Cooldown Manager's bottom edge position
---@return number? # The bottom Y coordinate, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerBottom()
	local cdm = self:GetCooldownManagerFrame()
	if cdm then
		return cdm:GetBottom()
	end
	return nil
end
