---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Bar = {}

---Computes the width of each Combo Point node
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return number
local function GetComboPointNodeWidth(settings)
	if settings.comboPoints ~= nil and TRB.Data.character.maxResource2 ~= nil and TRB.Data.character.maxResource2 > 0 then
		if settings.comboPoints.fullWidth then
			local nodes = TRB.Data.character.maxResource2
			local nodeSpacing = settings.comboPoints.spacing + settings.comboPoints.border * 2
			local width = ((settings.bar.width - ((nodes - 1) * (nodeSpacing - settings.comboPoints.border * 2))) / nodes)
			return width
		else
			return settings.comboPoints.width
		end
	end
	return 0
end

---Computes the absolute min/max values for the bar
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return table
function TRB.Functions.Bar:GetSanityCheckValues(settings)
	local sc = {}
	if settings ~= nil then
		if settings.bar ~= nil then
			sc.barMaxWidth = math.floor(GetScreenWidth())
			sc.barMinWidth = math.max(math.ceil(settings.bar.border * 2), 120)
			sc.barMaxHeight = math.floor(GetScreenHeight())
			sc.barMinHeight = math.max(math.ceil(settings.bar.border * 2), 1)
		end

		if settings.comboPoints ~= nil then
			sc.comboPointsMaxWidth = math.floor(GetScreenWidth() / 10) -- This should really be based on the maximum Combo Points for a specialization. Enhancement Shaman would be max (10), Devourer Demon Hunter would be min (1)
			sc.comboPointsMinWidth = math.max(math.ceil(settings.comboPoints.border * 2), 1)
			sc.comboPointsMaxHeight = math.floor(GetScreenHeight())
			sc.comboPointsMinHeight = math.max(math.ceil(settings.comboPoints.border * 2), 1)
		end
	end
	return sc
end

---Updates absolute min/max values for the bar
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.Bar:UpdateSanityCheckValues(settings)
	local sc = TRB.Functions.Bar:GetSanityCheckValues(settings)
	if settings ~= nil and settings.bar ~= nil then
		TRB.Data.sanityCheckValues.barMaxWidth = sc.barMaxWidth
		TRB.Data.sanityCheckValues.barMinWidth = sc.barMinWidth
		TRB.Data.sanityCheckValues.barMaxHeight = sc.barMaxHeight
		TRB.Data.sanityCheckValues.barMinHeight = sc.barMinHeight
	end
end

function TRB.Functions.Bar:ShowResourceBar()
	if TRB.Details.addonData.registered == false then
		TRB.Functions.Class:EventRegistration()
	end

	TRB.Data.snapshotData.attributes.isTracking = true
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Bar:HideResourceBar(force)
	force = force or false
	
	if TRB.Data.character.inPetBattle or TRB.Data.character.onTaxi then
		force = true
	end

	-- If Edit Mode is active, ensure bars stay visible so they can be repositioned
	-- Primary bar ALWAYS shows; other bars show unless configured to "never" display
	if TRB.Functions.EditMode and TRB.Functions.EditMode:IsInEditMode() then
		local barGroups = TRB.Frames.barGroups
		local displayBar = nil
		if TRB.Data.specCache and TRB.Data.character.specName then
			local specSettings = TRB.Data.specCache[TRB.Data.character.specName]
			if specSettings and specSettings.settings then
				displayBar = specSettings.settings.displayBar
			end
		end

		if barGroups then
			-- Primary bar ALWAYS shows - it's required for positioning
			if barGroups.primary then
				barGroups.primary:Show()
			end
			-- Show secondary bar (combo points, etc.) unless set to "never"
			if barGroups.secondary and (displayBar == nil or displayBar.secondary ~= "never") then
				barGroups.secondary:Show()
				local maxNodes = TRB.Data.character.maxResource2 or barGroups.secondary.maxNodes or 5
				barGroups.secondary:ShowNodes(maxNodes)
			end
			-- Show health bar unless set to "never"
			if barGroups.health and (displayBar == nil or displayBar.health ~= "never") then
				barGroups.health:Show()
			end
			-- Show mana bar (Balance Druid, Shadow Priest, Elemental Shaman) unless set to "never"
			if barGroups.mana and (displayBar == nil or displayBar.mana ~= "never") then
				barGroups.mana:Show()
			end
			-- Show stagger bar (Brewmaster Monk) unless set to "never"
			if barGroups.stagger and (displayBar == nil or displayBar.stagger ~= "never") then
				barGroups.stagger:Show()
			end
			-- Show defensives bar (Protection Warrior) unless set to "never"
			if barGroups.defensives and (displayBar == nil or displayBar.defensives ~= "never") then
				barGroups.defensives:Show()
			end
		end
		-- Set isTracking to true so bar text updates
		if TRB.Data.snapshotData and TRB.Data.snapshotData.attributes then
			TRB.Data.snapshotData.attributes.isTracking = true
		end
		return
	end

	TRB.Functions.Class:HideResourceBar(force)
end

function TRB.Functions.Bar:PulseFrame(frame, alphaOffset, flashPeriod)
	if alphaOffset > 1.0 then
		alphaOffset = 1.0
	elseif alphaOffset < 0 then
		alphaOffset = 0
	end

	if flashPeriod <= 0 then
		flashPeriod = 0.5
	end
	
	frame:SetAlpha(((1.0 - alphaOffset) * math.abs(math.sin(2 * (GetTime() / flashPeriod)))) + alphaOffset)
end

function TRB.Functions.Bar:SetPositionXY(xOfs, yOfs)
	if TRB.Functions.Number:IsNumeric(xOfs) and TRB.Functions.Number:IsNumeric(yOfs) then
		if xOfs < math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth / 2) then
			xOfs = math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth / 2)
		elseif xOfs > math.floor(TRB.Data.sanityCheckValues.barMaxWidth / 2) then
			xOfs = math.floor(TRB.Data.sanityCheckValues.barMaxWidth / 2)
		end

		if yOfs < math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight / 2) then
			yOfs = math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight / 2)
		elseif yOfs > math.floor(TRB.Data.sanityCheckValues.barMaxHeight / 2) then
			yOfs = math.floor(TRB.Data.sanityCheckValues.barMaxHeight / 2)
		end

		if TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar then
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].horizontal:SetValue(xOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0, nil, true))
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].vertical:SetValue(yOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0, nil, true))
		else
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal:SetValue(xOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0, nil, true))
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical:SetValue(yOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0, nil, true))
		end
	end
end

function TRB.Functions.Bar:GetPosition(settings)
	-- Use BarGroups system if available
	local containerFrame
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
		containerFrame = TRB.Frames.barGroups.primary:GetContainerFrame()
	end

	if not containerFrame then
		return
	end

	local _, _, relativePoint, xOfs, yOfs = containerFrame:GetPoint()

	if relativePoint == "CENTER" then
		--No action needed.
	elseif relativePoint == "TOP" then
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight / 2) + yOfs - (settings.bar.height / 2))
	elseif relativePoint == "TOPRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth / 2) + xOfs - (settings.bar.width / 2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight / 2) + yOfs - (settings.bar.height / 2))
	elseif relativePoint == "RIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth / 2) + xOfs - (settings.bar.width / 2))
	elseif relativePoint == "BOTTOMRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth / 2) + xOfs - (settings.bar.width / 2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight / 2) - yOfs - (settings.bar.height / 2))
	elseif relativePoint == "BOTTOM" then
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight / 2) - yOfs - (settings.bar.height / 2))
	elseif relativePoint == "BOTTOMLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth / 2) - xOfs - (settings.bar.width / 2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight / 2) - yOfs - (settings.bar.height / 2))
	elseif relativePoint == "LEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth / 2) - xOfs - (settings.bar.width / 2))
	elseif relativePoint == "TOPLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth / 2) - xOfs - (settings.bar.width / 2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight / 2) + yOfs - (settings.bar.height / 2))
	end

	TRB.Functions.Bar:SetPositionXY(xOfs, yOfs)
end



---Sets the position of the `containerFrame`
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param containerFrame frame
function TRB.Functions.Bar:SetPosition(settings, containerFrame)
	if settings == nil then
		return
	end

	---containerFrame:ClearAllPoints()
	---containerFrame:SetPoint("CENTER", UIParent)
	---containerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	
	-- Check if Edit Mode should control positioning
	local editModePosition = TRB.Functions.EditMode:GetActivePosition()
	if editModePosition and editModePosition.point then
		-- Edit Mode position: Use the same 3-argument SetPoint that LibEditMode uses
		containerFrame:SetPoint(editModePosition.point, editModePosition.x, editModePosition.y)
	else
		-- Legacy position: Uses CENTER anchor
		containerFrame:SetPoint("CENTER", UIParent)
		containerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	end

	TRB.Functions.Threshold:RedrawThresholdLines()
end


--[[
	New OOP-based Bar System
	These functions work with TRB.Classes.BarGroup and TRB.Classes.BarNode
	to provide a parallel, object-oriented bar construction system.
]]

-- Initialize parallel storage for new bar system
TRB.Frames.barGroups = TRB.Frames.barGroups or {}

---Destroys existing bar groups before creating new ones
---Call this when switching specs to prevent orphaned frames
function TRB.Functions.Bar:DestroyBarGroups()
	-- Clear the Edit Mode registered frame reference since the frame is being destroyed
	if TRB.Functions.EditMode and TRB.Functions.EditMode.ClearRegisteredFrame then
		TRB.Functions.EditMode:ClearRegisteredFrame()
	end

	if TRB.Frames.barGroups then
		for key, group in pairs(TRB.Frames.barGroups) do
			if group and group.Destroy then
				group:Destroy()
			end
		end
		TRB.Frames.barGroups = nil
	end
end

---Constructs bar groups using the new OOP system
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	-- Clear color caches to ensure fresh application on bar construction
	TRB.Data.cache.colors.border = {}
	TRB.Data.cache.colors.backdrop = {}

	-- Initialize Edit Mode if not yet done (safe to call multiple times)
	if TRB.Functions.EditMode and TRB.Functions.EditMode.Initialize then
		TRB.Functions.EditMode:Initialize()
	end

	self:ApplyBarGroupsLayout(settings, barGroups)
	self:ApplyBarGroupsAppearance(settings, barGroups)

	-- Register the primary bar with Edit Mode
	if barGroups.primary and TRB.Functions.EditMode then
		TRB.Functions.EditMode:RegisterPrimaryBar(barGroups.primary:GetContainerFrame())
	end

	-- Create bar text frames (essential for bar text display)
	TRB.Functions.BarText:CreateBarTextFrames()
	TRB.Functions.BarText:Hide(settings)
	TRB.Functions.Class:HideResourceBar()
end

---Applies size/position/layout updates to existing bar groups (OOP system only).
---This is safe to call from Options UI sliders for live updates.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels

	-- Configure the primary bar group
	if barGroups.primary then
		local primary = barGroups.primary
		local primaryNode = primary:GetNode(1)

		-- First, position and size the group container (parent of nodes)
		-- This must be done BEFORE positioning child nodes
		-- Check if Edit Mode should control positioning
		local editModePosition = TRB.Functions.EditMode:GetActivePosition()
		primary.containerFrame:ClearAllPoints()
		if editModePosition and editModePosition.point then
			-- Edit Mode position: Use the exact same 3-argument SetPoint that LibEditMode uses
			-- This is critical because normalizePosition calculates x,y relative to the anchor point
			-- and the 3-argument SetPoint(point, x, y) is equivalent to SetPoint(point, parent, point, x, y)
			primary.containerFrame:SetPoint(editModePosition.point, editModePosition.x, editModePosition.y)
		else
			-- Legacy position: Always uses CENTER anchor
			local xPos = settings.bar.xPos or 0
			local yPos = settings.bar.yPos or -200
			primary.containerFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
		end
		primary.containerFrame:SetWidth(settings.bar.width - (settings.bar.border * 2))
		primary.containerFrame:SetHeight(settings.bar.height - (settings.bar.border * 2))

		if primaryNode then
			-- Set frame strata
			primary:SetFrameStrata(strata)

			-- Set dimensions (stores values and sizes border/resource frames)
			primaryNode:SetDimensions(settings.bar.width, settings.bar.height, settings.bar.border)

			-- Set frame levels
			primaryNode:SetFrameLevels(
				frameLevels.barContainer,
				frameLevels.barBorder,
				frameLevels.barResource
			)

			-- Primary node should fill the primary group container
			local primaryNodeContainer = primaryNode:GetContainerFrame()
			if primaryNodeContainer then
				primaryNodeContainer:ClearAllPoints()
				primaryNodeContainer:SetAllPoints(primary.containerFrame)
			end

			-- Position the resource/border frames within the node container
			primaryNode:PositionResourceFrame()

			-- Set min/max values
			local max = TRB.Data.character.maxResource or settings.bar.width
			if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
				max = math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource or max)
			end
			primaryNode:SetMinMax(0, max)

			-- Enable drag and drop
			primary:SetDragAndDrop(settings.bar.dragAndDrop, settings)

			-- Show the primary bar (now parented directly to UIParent)
			primary:Show()
			primaryNode:Show()

			-- Redraw thresholds to match new bar dimensions
			local thresholds = primaryNode:GetThresholds()
			if thresholds and #thresholds > 0 then
				for _, threshold in ipairs(thresholds) do
					TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, true)
				end
			end
		end
	end

	-- Configure secondary bar groups (combo points, arcane charges, runes, etc.)
	-- DRUID SPECIAL CASE: Non-Feral Druids don't have comboPoints in their settings,
	-- but they DO have a secondary bar group for combo points when in cat form.
	-- Check Feral settings for Druids when the current spec doesn't have comboPoints.
	local hasComboPointSettings = settings.comboPoints ~= nil
	local feralSettingsForDruid = nil
	if not hasComboPointSettings and TRB.Data.character.classId == 11 then
		feralSettingsForDruid = TRB.Data.specCache and TRB.Data.specCache.feral and TRB.Data.specCache.feral.settings
		if feralSettingsForDruid and feralSettingsForDruid.comboPoints then
			hasComboPointSettings = true
		end
	end

	if barGroups.secondary and hasComboPointSettings then
		-- DRUID SPECIAL CASE: All Druid specs share Feral's combo point settings.
		-- When on a non-Feral Druid spec, use Feral's combo point configuration
		-- so that changes made in Feral options are reflected immediately.
		local effectiveSettings = settings
		if TRB.Data.character.classId == 11 and (TRB.Data.character.specId ~= 2 or not settings.comboPoints) then
			local feralSettings = feralSettingsForDruid or (TRB.Data.specCache and TRB.Data.specCache.feral and TRB.Data.specCache.feral.settings)
			if feralSettings and feralSettings.comboPoints then
				-- Create a shallow copy with Feral's combo point settings
				-- IMPORTANT: Must create NEW tables for nested objects, not just copy references
---@diagnostic disable-next-line: missing-fields
				effectiveSettings = {}
				for k, v in pairs(settings) do
					effectiveSettings[k] = v
				end
				effectiveSettings.comboPoints = feralSettings.comboPoints
				-- Create a new textures table with current spec's textures, then override combo point textures
				if feralSettings.textures then
					local newTextures = {}
					if settings.textures then
						for k, v in pairs(settings.textures) do
							newTextures[k] = v
						end
					end
					newTextures.comboPointsBar = feralSettings.textures.comboPointsBar
					newTextures.comboPointsBorder = feralSettings.textures.comboPointsBorder
					newTextures.comboPointsBackground = feralSettings.textures.comboPointsBackground
					effectiveSettings.textures = newTextures
				end
				-- Create a new colors table with current spec's colors, then override combo point colors
				if feralSettings.colors and feralSettings.colors.comboPoints then
					local newColors = {}
					if settings.colors then
						for k, v in pairs(settings.colors) do
							newColors[k] = v
						end
					end
					newColors.comboPoints = feralSettings.colors.comboPoints
					effectiveSettings.colors = newColors
				end
			end
		end

		self:ConstructSecondaryBarGroup(effectiveSettings, barGroups.primary, barGroups.secondary, false)
		-- Demon Hunter Devourer: secondary is a true 0..50 bar, and values may be "secret".
		-- Keep the node min/max in that range so SetValue() works without scaling/clamping.
		if TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 3 then
			local sfNode = barGroups.secondary:GetNode(1)
			if sfNode then
				sfNode:SetMinMax(0, TRB.Data.character.maxResource2Value or 50)
			end
		end

		-- Redraw thresholds on secondary nodes to match new bar dimensions
		for i = 1, barGroups.secondary.maxNodes do
			local node = barGroups.secondary:GetNode(i)
			if node then
				local thresholds = node:GetThresholds()
				if thresholds and #thresholds > 0 then
					for _, threshold in ipairs(thresholds) do
						TRB.Functions.Threshold:ResetThresholdLineComboPoint(threshold, effectiveSettings)
					end
				end
			end
		end
	end

	-- Clear threshold color cache so AdjustThresholdDisplay recalculates colors correctly
	-- This fixes a bug where moving the bar caused threshold colors to reset and stay wrong
	-- Also clear colors cache in general
	if TRB.Data.cache and TRB.Data.cache.values then
		TRB.Data.cache.values.threshold = {}
		TRB.Functions.Character:ResetColorCaches()
	end

	-- Configure health bar group (apply appearance immediately to ensure textures are set)
	if barGroups.health and settings.healthBar then
		self:ConstructHealthBarGroup(settings, barGroups.primary, barGroups.health, true)
	end

	-- Configure custom bar groups from the registry (stagger, defensives, mana, etc.)
	self:ApplyCustomBarGroupsLayout(settings, barGroups)
	
	-- There may be class-specific updates needed after layout changes. Only run this if we're not looping.
	if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
		TRB.Functions.Class:CheckCharacter()
	end
end

---Applies textures/colors to existing bar groups (OOP system only).
---This is intentionally separate from layout so moving/resizing doesn't inadvertently reset bar colors.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	-- Clear color caches to ensure colors are re-applied after ApplyBackdrop resets frames
	TRB.Data.cache.colors.border = {}
	TRB.Data.cache.colors.backdrop = {}

	local frameLevels = TRB.Data.constants.frameLevels

	if barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:SetTextures(
				settings.textures.resourceBar,
				settings.textures.border,
				settings.textures.background
			)
			primaryNode:SetColor(settings.colors.bar.base)
			primaryNode:SetBorderColor(settings.colors.bar.border)
			primaryNode:SetBackgroundColorFromString(settings.colors.bar.background)
			primaryNode:SetFrameLevels(
				frameLevels.barContainer,
				frameLevels.barBorder,
				frameLevels.barResource
			)
		end
	end

	-- DRUID SPECIAL CASE: Non-Feral Druids don't have comboPoints in their settings,
	-- but they DO have a secondary bar group for combo points when in cat form.
	-- Check Feral settings for Druids when the current spec doesn't have comboPoints.
	local hasComboPointSettings = settings.comboPoints ~= nil
	local feralSettingsForDruid = nil
	if not hasComboPointSettings and TRB.Data.character.classId == 11 then
		feralSettingsForDruid = TRB.Data.specCache and TRB.Data.specCache.feral and TRB.Data.specCache.feral.settings
		if feralSettingsForDruid and feralSettingsForDruid.comboPoints then
			hasComboPointSettings = true
		end
	end

	if barGroups.secondary and hasComboPointSettings then
		-- DRUID SPECIAL CASE: All Druid specs share Feral's combo point settings.
		local effectiveSettings = settings
		if TRB.Data.character.classId == 11 and (TRB.Data.character.specId ~= 2 or not settings.comboPoints) then
			local feralSettings = feralSettingsForDruid or (TRB.Data.specCache and TRB.Data.specCache.feral and TRB.Data.specCache.feral.settings)
			if feralSettings and feralSettings.comboPoints then
				-- Create a shallow copy with Feral's combo point settings
				-- IMPORTANT: Must create NEW tables for nested objects, not just copy references
---@diagnostic disable-next-line: missing-fields
				effectiveSettings = {}
				for k, v in pairs(settings) do
					effectiveSettings[k] = v
				end
				effectiveSettings.comboPoints = feralSettings.comboPoints
				-- Create a new textures table with current spec's textures, then override combo point textures
				if feralSettings.textures then
					local newTextures = {}
					if settings.textures then
						for k, v in pairs(settings.textures) do
							newTextures[k] = v
						end
					end
					newTextures.comboPointsBar = feralSettings.textures.comboPointsBar
					newTextures.comboPointsBorder = feralSettings.textures.comboPointsBorder
					newTextures.comboPointsBackground = feralSettings.textures.comboPointsBackground
					effectiveSettings.textures = newTextures
				end
				-- Create a new colors table with current spec's colors, then override combo point colors
				if feralSettings.colors and feralSettings.colors.comboPoints then
					local newColors = {}
					if settings.colors then
						for k, v in pairs(settings.colors) do
							newColors[k] = v
						end
					end
					newColors.comboPoints = feralSettings.colors.comboPoints
					effectiveSettings.colors = newColors
				end
			end
		end

		local isDevourer = TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 3
		for i = 1, barGroups.secondary.maxNodes do
			local node = barGroups.secondary:GetNode(i)
			if node then
				node:SetTextures(
					effectiveSettings.textures.comboPointsBar,
					effectiveSettings.textures.comboPointsBorder,
					effectiveSettings.textures.comboPointsBackground
				)

				-- Secondary node min/max belongs with appearance (initial construct / appearance updates),
				-- not with layout (move/resize), to avoid clamping current values.
				if isDevourer and i == 1 then
					node:SetMinMax(0, TRB.Data.character.maxResource2Value or 50)
				else
					node:SetMinMax(0, 1)
				end
				node:SetBorderColor(effectiveSettings.colors.comboPoints.border)
				node:SetBackgroundColorFromString(effectiveSettings.colors.comboPoints.background)
				node:SetColor(effectiveSettings.colors.comboPoints.base)
				node:SetFrameLevels(
					frameLevels.cpContainer,
					frameLevels.cpBorder,
					frameLevels.cpResource
				)
			end
		end
	end

	-- Apply health bar appearance
	if barGroups.health and settings.healthBar and settings.colors.healthBar then
		local healthNode = barGroups.health:GetNode(1)
		if healthNode then
			healthNode:SetTextures(
				settings.textures.healthBar,
				settings.textures.healthBorder,
				settings.textures.healthBackground
			)
			healthNode:SetBorderColor(settings.colors.healthBar.border.color)
			healthNode:SetBackgroundColorFromString(settings.colors.healthBar.background.color)
			healthNode:SetColor(settings.colors.healthBar.bar)
			healthNode:SetFrameLevels(
				frameLevels.cpContainer,
				frameLevels.cpBorder,
				frameLevels.cpResource
			)
		end
	end

	-- Apply custom bar group appearances from the registry (stagger, defensives, mana, etc.)
	self:ApplyCustomBarGroupsAppearance(settings, barGroups)

	-- Trigger resource bar updates to ensure all colors are applied from current spec settings
	if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Configuration for constructing an anchored bar group
---@class TRB.Classes.AnchoredBarGroupConfig
---@field public settingsKey string? # Key to read from settings (e.g., "comboPoints", "healthBar"). Ignored if settingsTable is provided.
---@field public settingsTable table? # Direct settings table to use instead of looking up via settingsKey
---@field public colorsKey string? # Key to read from settings.colors (e.g., "comboPoints", "healthBar"). Ignored if colorsTable is provided.
---@field public colorsTable table? # Direct colors table to use instead of looking up via colorsKey
---@field public nodeCount integer? # Fixed node count, or nil to use TRB.Data.character.maxResource2
---@field public useApplyLayout boolean # If true, use group:ApplyLayout(); if false, size single node directly
---@field public defaultAnchorAbove boolean # If true, default anchor is TOP; if false, default is BOTTOM
---@field public textures { bar: string, border: string, background: string } # Texture setting keys
---@field public colors { border: string, background: string, bar: string } # Color setting keys within the colorsKey table
---@field public minMaxMode string # "discrete" (0-1), "health" (0-maxHealth), or "custom"

---Constructs an anchored bar group (combo points, health bar, etc.)
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param anchorGroup TRB.Classes.BarGroup # The group to anchor to (usually primary)
---@param targetGroup TRB.Classes.BarGroup # The group being constructed
---@param config TRB.Classes.AnchoredBarGroupConfig # Configuration for this bar group type
---@param applyAppearance boolean?
function TRB.Functions.Bar:ConstructAnchoredBarGroup(settings, anchorGroup, targetGroup, config, applyAppearance)
	-- Allow direct settings table OR lookup by key
	local groupSettings = config.settingsTable or (config.settingsKey and settings[config.settingsKey])
	if groupSettings == nil then
		return
	end

	if applyAppearance == nil then
		applyAppearance = true
	end

	-- Verify the target group has valid nodes (not destroyed)
	if targetGroup.nodes == nil or targetGroup:GetNode(1) == nil then
		return
	end

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels

	-- Determine node count
	local nodes
	if config.nodeCount ~= nil then
		nodes = config.nodeCount
	else
		nodes = TRB.Data.character.maxResource2
		if nodes == nil or nodes == 0 then
			nodes = targetGroup.maxNodes or 1
		end
		nodes = math.min(nodes, targetGroup.maxNodes or nodes)
	end

	-- Set node count
	targetGroup:SetNodeCount(nodes)

	-- Set layout parameters
	targetGroup:SetLayout(groupSettings.spacing or 0, groupSettings.fullWidth, "HORIZONTAL")

	-- Set frame strata
	targetGroup:SetFrameStrata(strata)

	-- Calculate positioning based on relativeTo setting
	local anchorContainer = anchorGroup:GetContainerFrame()
	local setPoint, setPointRelativeTo, topBottom, leftCenterRight

	-- Set defaults based on config
	if config.defaultAnchorAbove then
		setPoint = "BOTTOM"
		setPointRelativeTo = "TOP"
		topBottom = "TOP"
	else
		setPoint = "TOP"
		setPointRelativeTo = "BOTTOM"
		topBottom = "BOTTOM"
	end
	leftCenterRight = "CENTER"

	-- Override based on relativeTo setting
	if groupSettings.relativeTo == "TOPLEFT" then
		setPoint = "BOTTOMLEFT"
		setPointRelativeTo = "TOPLEFT"
		topBottom = "TOP"
		leftCenterRight = "LEFT"
	elseif groupSettings.relativeTo == "TOP" then
		setPoint = "BOTTOM"
		setPointRelativeTo = "TOP"
		topBottom = "TOP"
	elseif groupSettings.relativeTo == "TOPRIGHT" then
		setPoint = "BOTTOMRIGHT"
		setPointRelativeTo = "TOPRIGHT"
		topBottom = "TOP"
		leftCenterRight = "RIGHT"
	elseif groupSettings.relativeTo == "BOTTOMLEFT" then
		setPoint = "TOPLEFT"
		setPointRelativeTo = "BOTTOMLEFT"
		topBottom = "BOTTOM"
		leftCenterRight = "LEFT"
	elseif groupSettings.relativeTo == "BOTTOM" then
		setPoint = "TOP"
		setPointRelativeTo = "BOTTOM"
		topBottom = "BOTTOM"
	elseif groupSettings.relativeTo == "BOTTOMRIGHT" then
		setPoint = "TOPRIGHT"
		setPointRelativeTo = "BOTTOMRIGHT"
		topBottom = "BOTTOM"
		leftCenterRight = "RIGHT"
	end

	-- Calculate dimensions (may be overridden by fullWidth)
	local groupWidth = groupSettings.width
	local groupHeight = groupSettings.height
	local groupBorder = groupSettings.border

	local xPos, yPos

	if groupSettings.fullWidth then
		xPos = 0
		groupWidth = settings.bar.width
		if topBottom == "BOTTOM" then
			setPoint = "TOP"
			setPointRelativeTo = "BOTTOM"
		else
			setPoint = "BOTTOM"
			setPointRelativeTo = "TOP"
		end
		leftCenterRight = "CENTER"
	else
		if leftCenterRight == "LEFT" then
			xPos = -settings.bar.border + groupSettings.xPos
		elseif leftCenterRight == "RIGHT" then
			xPos = settings.bar.border + groupSettings.xPos
		else
			xPos = groupSettings.xPos
		end
	end

	if topBottom == "BOTTOM" then
		yPos = -settings.bar.border + groupSettings.yPos
	else
		yPos = settings.bar.border + groupSettings.yPos
	end

	-- Position the target container
	targetGroup.containerFrame:ClearAllPoints()
	targetGroup.containerFrame:SetPoint(setPoint, anchorContainer, setPointRelativeTo, xPos, yPos)
	targetGroup.containerFrame:SetFrameLevel(frameLevels.cpContainer)

	-- Apply layout or size directly based on config
	if config.useApplyLayout then
		-- Multi-node layout (combo points, runes, etc.)
		targetGroup:ApplyLayout(
			settings.bar.width,
			groupSettings.width,
			groupSettings.height,
			groupSettings.border
		)
	else
		-- Single-node direct sizing (health bar, etc.)
		targetGroup.containerFrame:SetWidth(groupWidth)
		targetGroup.containerFrame:SetHeight(groupHeight)

		local singleNode = targetGroup:GetNode(1)
		if singleNode then
			singleNode:SetDimensions(groupWidth, groupHeight, groupBorder)
			singleNode:SetFrameLevels(
				frameLevels.cpContainer,
				frameLevels.cpBorder,
				frameLevels.cpResource
			)

			-- Position node within container
			local nodeContainer = singleNode:GetContainerFrame()
			if nodeContainer then
				nodeContainer:ClearAllPoints()
				nodeContainer:SetAllPoints(targetGroup.containerFrame)
			end
			singleNode:PositionResourceFrame()

			-- Set min/max based on mode
			if config.minMaxMode == "health" then
				local healthMax = TRB.Data.snapshotData and TRB.Data.snapshotData.attributes.healthMax or UnitHealthMax("player")
				singleNode:SetMinMax(0, healthMax)
			elseif config.minMaxMode == "mana" then
				local manaMax = UnitPowerMax("player", Enum.PowerType.Mana) or 1
				singleNode:SetMinMax(0, manaMax)
			elseif config.minMaxMode == "discrete" then
				singleNode:SetMinMax(0, 1)
			end
			-- "custom" mode leaves min/max to be set externally
		end
	end

	-- Apply appearance only when requested
	if applyAppearance then
		-- Allow direct colors table OR lookup by key
		local colorSettings = config.colorsTable or (config.colorsKey and settings.colors[config.colorsKey])
		if colorSettings then
			for i = 1, nodes do
				local node = targetGroup:GetNode(i)
				if node then
					-- Clear cached colors for this node before setting textures.
					-- SetTextures() calls ApplyBackdrop() which resets border color to white.
					-- Without clearing the cache, SetBorderColor() may skip the update
					-- if it thinks the cached color matches the desired color.
					local borderCacheKey = node.name .. "_border"
					local backdropCacheKey = node.name .. "_background"
					TRB.Data.cache.colors.border[borderCacheKey] = nil
					TRB.Data.cache.colors.backdrop[backdropCacheKey] = nil

					node:SetTextures(
						settings.textures[config.textures.bar],
						settings.textures[config.textures.border],
						settings.textures[config.textures.background]
					)

					-- Set min/max for multi-node layouts
					if config.useApplyLayout then
						node:SetMinMax(0, 1)
					end

					node:SetFrameLevels(
						frameLevels.cpContainer,
						frameLevels.cpBorder,
						frameLevels.cpResource
					)

					-- Handle color values that may be strings or tables with .color property
					local borderColor = colorSettings[config.colors.border]
					if type(borderColor) == "table" then
						borderColor = borderColor.color
					end
					node:SetBorderColor(borderColor)

					local backgroundColor = colorSettings[config.colors.background]
					if type(backgroundColor) == "table" then
						backgroundColor = backgroundColor.color
					end
					node:SetBackgroundColorFromString(backgroundColor)

					local barColor = colorSettings[config.colors.bar]
					if type(barColor) == "table" then
						barColor = barColor.color
					end
					node:SetColor(barColor)
				end
			end
		end
	end

	-- Show the group and active nodes
	targetGroup:Show()
	targetGroup:ShowNodes(nodes)
end

---Constructs a secondary bar group (combo points, arcane charges, etc.)
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param primaryGroup TRB.Classes.BarGroup
---@param secondaryGroup TRB.Classes.BarGroup
---@param applyAppearance boolean?
function TRB.Functions.Bar:ConstructSecondaryBarGroup(settings, primaryGroup, secondaryGroup, applyAppearance)
	---@type TRB.Classes.AnchoredBarGroupConfig
	local config = {
		settingsKey = "comboPoints",
		colorsKey = "comboPoints",
		nodeCount = nil, -- Dynamic based on maxResource2
		useApplyLayout = true,
		defaultAnchorAbove = true,
		textures = {
			bar = "comboPointsBar",
			border = "comboPointsBorder",
			background = "comboPointsBackground"
		},
		colors = {
			border = "border",
			background = "background",
			bar = "base"
		},
		minMaxMode = "discrete"
	}

	self:ConstructAnchoredBarGroup(settings, primaryGroup, secondaryGroup, config, applyAppearance)
end

---Constructs a health bar group
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param primaryGroup TRB.Classes.BarGroup
---@param healthGroup TRB.Classes.BarGroup
---@param applyAppearance boolean?
function TRB.Functions.Bar:ConstructHealthBarGroup(settings, primaryGroup, healthGroup, applyAppearance)
	---@type TRB.Classes.AnchoredBarGroupConfig
	local config = {
		settingsKey = "healthBar",
		colorsKey = "healthBar",
		nodeCount = 1, -- Health bar always has 1 node
		useApplyLayout = false,
		defaultAnchorAbove = false,
		textures = {
			bar = "healthBar",
			border = "healthBorder",
			background = "healthBackground"
		},
		colors = {
			border = "border",
			background = "background",
			bar = "bar"
		},
		minMaxMode = "health"
	}

	self:ConstructAnchoredBarGroup(settings, primaryGroup, healthGroup, config, applyAppearance)
end

---Applies layout to all custom bar groups registered in the BarTypeRegistry
---Uses ConstructAnchoredBarGroup for consistent positioning with health bar and combo points
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyCustomBarGroupsLayout(settings, barGroups)
	if settings == nil or barGroups == nil or barGroups.primary == nil then
		return
	end
	
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local allBarTypes = registry:GetAll()
	
	for key, barTypeDef in pairs(allBarTypes) do
		local barGroup = barGroups[key]
		local barSettings = settings.bars and settings.bars[key]
		
		-- Apply layout if bar group exists
		if barGroup then
			-- Get dimensions from settings or defaults from registry
			local defaultSettings = nil
			if not barSettings and barTypeDef.defaultDimensionsFunc then
				defaultSettings = barTypeDef.defaultDimensionsFunc()
			end
			local effectiveSettings = barSettings or defaultSettings or {}
			
			-- Ensure effectiveSettings has required fields with defaults
			effectiveSettings.width = effectiveSettings.width
			effectiveSettings.height = effectiveSettings.height
			effectiveSettings.border = effectiveSettings.border
			effectiveSettings.spacing = effectiveSettings.spacing
			effectiveSettings.fullWidth = effectiveSettings.fullWidth
			effectiveSettings.relativeTo = effectiveSettings.relativeTo
			effectiveSettings.xPos = effectiveSettings.xPos
			effectiveSettings.yPos = effectiveSettings.yPos
			
			-- Get color settings
			local colorSettings = settings.colors and settings.colors.bars and settings.colors.bars[key]
			
			-- Build config for ConstructAnchoredBarGroup
			---@type TRB.Classes.AnchoredBarGroupConfig
			local config = {
				settingsTable = effectiveSettings,
				colorsTable = colorSettings,
				nodeCount = barTypeDef.maxNodes or 1,
				useApplyLayout = barTypeDef.isMultiNode and (barTypeDef.maxNodes or 1) > 1,
				defaultAnchorAbove = true, -- Custom bars default to above primary bar
				textures = {
					bar = key .. "Bar",
					border = key .. "Border",
					background = key .. "Background"
				},
				colors = {
					border = "border",
					background = "background",
					bar = "bar"
				},
				minMaxMode = barTypeDef.minMaxMode or "custom"
			}
			
			-- Call ConstructAnchoredBarGroup (layout only, appearance handled separately)
			self:ConstructAnchoredBarGroup(settings, barGroups.primary, barGroup, config, false)
		end
	end
end

---Applies appearance (textures/colors) to all custom bar groups registered in the BarTypeRegistry
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyCustomBarGroupsAppearance(settings, barGroups)
	if settings == nil or barGroups == nil then
		return
	end
	
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local allBarTypes = registry:GetAll()
	local frameLevels = TRB.Data.constants.frameLevels
	
	for key, barTypeDef in pairs(allBarTypes) do
		local barGroup = barGroups[key]
		local barSettings = settings.bars and settings.bars[key]
		
		-- Apply appearance if bar group exists, even if barSettings is missing (use fallbacks)
		if barGroup then
			-- Get textures from flat keys (same pattern as manaBar: staggerBar, staggerBorder, staggerBackground)
			local barTexture = settings.textures and (settings.textures[key .. "Bar"] or settings.textures.resourceBar)
			local borderTexture = settings.textures and (settings.textures[key .. "Border"] or settings.textures.border)
			local backgroundTexture = settings.textures and (settings.textures[key .. "Background"] or settings.textures.background)
			
			-- Get colors from nested structure
			local barColors = settings.colors and settings.colors.bars and settings.colors.bars[key] or {}
			
			-- Apply to all nodes
			local nodeCount = barTypeDef.maxNodes or 1
			for i = 1, nodeCount do
				local node = barGroup:GetNode(i)
				if node then
					-- Set textures
					if barTexture and borderTexture and backgroundTexture then
						node:SetTextures(barTexture, borderTexture, backgroundTexture)
					end
					
					-- Get colors (handle both raw string and { color = "..." } objects)
					local borderColor = barColors.border
					if type(borderColor) == "table" then borderColor = borderColor.color end
					local backgroundColor = barColors.background
					if type(backgroundColor) == "table" then backgroundColor = backgroundColor.color end
					
					-- Get bar color - could be simple or threshold-based
					local barColor = nil
					if barTypeDef.colorCurveType then
						-- Threshold-based - use the "low" color as default
						barColor = barColors.low and barColors.low.color
					else
						-- Simple bar color
						barColor = barColors.bar
						if type(barColor) == "table" then barColor = barColor.color end
					end
					
					-- Apply colors with fallbacks
					node:SetBorderColor(borderColor)
					node:SetBackgroundColorFromString(backgroundColor)
					if barColor then
						node:SetColor(barColor)
					end
					
					node:SetFrameLevels(
						frameLevels.cpContainer,
						frameLevels.cpBorder,
						frameLevels.cpResource
					)
				end
			end
		end
	end
end

---Updates the value on a BarNode using the standard caching mechanism
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param node TRB.Classes.BarNode
---@param value number
---@param maxResource number?
function TRB.Functions.Bar:SetBarNodeValue(settings, key, node, value, maxResource)
	TRB.Data.cache.values.bar[key] = TRB.Data.cache.values.bar[key] or {}
	local valueIsSecret = issecretvalue(value)
	local maxResourceIsSecret = maxResource and issecretvalue(maxResource) or false

	if not valueIsSecret and not maxResourceIsSecret and
	   not issecretvalue(TRB.Data.cache.values.bar[key].value) and TRB.Data.cache.values.bar[key].value == value and
	   TRB.Data.cache.values.bar[key].maxResource == maxResource then
		return
	end

	if settings ~= nil and settings.bar ~= nil and node ~= nil then
		local _, max = node:GetMinMax()
		local barMaxValueIsSecret = issecretvalue(max)

		if barMaxValueIsSecret or valueIsSecret or maxResourceIsSecret then
			node:SetValue(value)
		else
			maxResource = maxResource or 1
			value = value or 0

			local factor = max / maxResource

			if maxResource == 0 then
				factor = max / 1
			end

			local scaledValue = value * factor
			if factor ~= math.huge and max ~= math.huge then
				node:SetValue(math.min(scaledValue, max))
			end
		end

		TRB.Data.cache.values.bar[key].value = value
		TRB.Data.cache.values.bar[key].maxResource = maxResource
	end
end

---Sets the primary value on a BarNode
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param node TRB.Classes.BarNode
---@param value number
function TRB.Functions.Bar:SetBarNodePrimaryValue(settings, key, node, value)
	if TRB.Data.character.maxResource ~= nil and TRB.Data.character.maxResource > 0 then
		if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
			TRB.Functions.Bar:SetBarNodeValue(settings, key, node, value, math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource))
		else
			TRB.Functions.Bar:SetBarNodeValue(settings, key, node, value, TRB.Data.character.maxResource)
		end
	end
end

