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

	-- If spec is not supported (disabled), hide all bars immediately and skip all other logic
	if not TRB.Data.specSupported then
		local barGroups = TRB.Frames.barGroups
		if barGroups then
			for _, group in pairs(barGroups) do
				if type(group) == "table" and group.Hide then
					group:Hide()
				end
			end
		end
		if TRB.Data.snapshotData and TRB.Data.snapshotData.attributes then
			TRB.Data.snapshotData.attributes.isTracking = false
		end
		return
	end

	-- If Edit Mode is active, ensure bars stay visible so they can be repositioned
	-- Primary bar ALWAYS shows; other bars show unless configured to "never" display
	if TRB.Functions.EditMode and TRB.Functions.EditMode:IsInEditMode() then
		local barGroups = TRB.Frames.barGroups
		local displayBar = nil
		if TRB.Data.specCache and TRB.Data.character.specName then
			local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
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
			if barGroups.secondary and (displayBar == nil or displayBar.secondary.visibility ~= "never") then
				barGroups.secondary:Show()
				local maxNodes = TRB.Data.character.maxResource2 or barGroups.secondary.maxNodes or 5
				barGroups.secondary:ShowNodes(maxNodes)
			end
			-- Show health bar unless set to "never"
			if barGroups.health and (displayBar == nil or displayBar.health.visibility ~= "never") then
				barGroups.health:Show()
			end
			-- Show mana bar (Balance Druid, Shadow Priest, Elemental Shaman) unless set to "never"
			if barGroups.mana and (displayBar == nil or displayBar.mana.visibility ~= "never") then
				barGroups.mana:Show()
			end
			-- Show stagger bar (Brewmaster Monk) unless set to "never"
			if barGroups.stagger and (displayBar == nil or displayBar.stagger.visibility ~= "never") then
				barGroups.stagger:Show()
			end
			-- Show defensives bar (Protection Warrior) unless set to "never"
			if barGroups.defensives and (displayBar == nil or displayBar.defensives.visibility ~= "never") then
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

		local controls = TRB.Frames.interfaceSettingsFrameContainer and TRB.Frames.interfaceSettingsFrameContainer.controls
		if TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar then
			if controls and controls["global"] then
				controls["global"].horizontal:SetValue(xOfs)
				controls["global"].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0, nil, true))
				controls["global"].vertical:SetValue(yOfs)
				controls["global"].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0, nil, true))
			end
		else
			local key = TRB.Data.character.compositeKey
			if controls and controls[key] then
				controls[key].horizontal:SetValue(xOfs)
				controls[key].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0, nil, true))
				controls[key].vertical:SetValue(yOfs)
				controls[key].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0, nil, true))
			end
		end
	end
end

function TRB.Functions.Bar:GetPosition(settings)
	-- Use wrapper frame if available (for proper position in wrapper-based system)
	-- Fall back to BarGroups primary container if no wrapper
	local containerFrame
	
	-- Try to get the wrapper frame first (it's the parent of all bars and what moves)
	local wrapperFrame = TRB.Functions.EditMode and TRB.Functions.EditMode:GetWrapperFrame()
	if wrapperFrame then
		containerFrame = wrapperFrame
	elseif TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
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



---Sets the position of the bar system
---In the new BarGroups architecture, this positions the WRAPPER frame, not the container
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param containerFrame frame # Deprecated parameter, kept for API compatibility. The wrapper frame is used instead.
function TRB.Functions.Bar:SetPosition(settings, containerFrame)
	if settings == nil then
		return
	end

	-- In the new BarGroups architecture, position is applied to the WRAPPER frame.
	-- The primary container is a CHILD of the wrapper at CENTER/0,0.
	-- Setting position on the container would cause a multiplicative offset bug.
	local wrapperFrame = TRB.Functions.EditMode and TRB.Functions.EditMode:GetWrapperFrame()
	local targetFrame = wrapperFrame or containerFrame
	
	-- Check if Edit Mode layout is enabled
	local editModeLayoutEnabled = TRB.Functions.EditMode:IsLayoutEnabled()
	
	-- Check anchor mode - if CDM anchoring is active, don't override position here
	-- CDM anchoring is handled by ApplyBarGroupsLayout and ApplyCooldownManagerAnchoring
	local anchorMode = TRB.Functions.EditMode:GetAnchorMode()
	if editModeLayoutEnabled and anchorMode ~= "none" and TRB.Functions.EditMode:IsCooldownManagerAvailable() then
		-- CDM anchoring is active - position is controlled by ApplyBarGroupsLayout
		-- Just redraw thresholds and return
		TRB.Functions.Threshold:RedrawThresholdLines()
		return
	end
	
	-- Check if Edit Mode should control positioning (free position mode)
	local editModePosition = TRB.Functions.EditMode:GetActivePosition()
	if editModePosition and editModePosition.point then
		-- Edit Mode position: Use the saved Edit Mode position
		targetFrame:ClearAllPoints()
		targetFrame:SetPoint(editModePosition.point, editModePosition.x, editModePosition.y)
	else
		-- Legacy position: Uses CENTER anchor with xPos/yPos offset
		local xPos = settings.bar.xPos or 0
		local yPos = settings.bar.yPos or -200
		targetFrame:ClearAllPoints()
		targetFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
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
			-- Only destroy BarGroup objects (skip numeric properties like effectiveWidth)
			if type(group) == "table" and group.Destroy then
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

	-- Don't construct bars if spec is not supported (disabled in settings)
	if not TRB.Data.specSupported then
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

	-- Don't apply layout if spec is not supported (disabled in settings)
	if not TRB.Data.specSupported then
		return
	end

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels

	-- Check for Cooldown Manager width matching
	local effectiveWidth = settings.bar.width
	local cdmWidthMatching = TRB.Functions.EditMode:IsWidthMatchingEnabled()
	if cdmWidthMatching then
		local cdmWidth = TRB.Functions.EditMode:GetCooldownManagerWidth()
		if cdmWidth then
			effectiveWidth = cdmWidth
		end
	end

	-- Store effectiveWidth on barGroups for use by secondary bar construction
	barGroups.effectiveWidth = effectiveWidth

	-- Check if Edit Mode layout is enabled for this layout
	local editModeLayoutEnabled = TRB.Functions.EditMode:IsLayoutEnabled()

	-- Get anchor mode for CDM positioning
	-- Note: GetAnchorMode() returns "none" if layout is not enabled
	local anchorMode = TRB.Functions.EditMode:GetAnchorMode()
	local anchorOffset = TRB.Functions.EditMode:GetAnchorOffset()

	-- Determine if we're using CDM anchoring
	-- CDM anchoring requires:
	-- 1. Edit Mode layout is enabled ("Enable for this layout" checked)
	-- 2. Anchor mode is not "none" ("Anchor To" set to Above/Below CDM)
	-- 3. CDM frame is available
	local useCdmAnchoring = editModeLayoutEnabled and anchorMode ~= "none" and TRB.Functions.EditMode:IsCooldownManagerAvailable()

	-- Get or create the wrapper frame for Edit Mode
	local wrapperFrame = TRB.Functions.EditMode:GetOrCreateWrapperFrame()

	-- Determine the root of the wrapper tree
	-- Walk from baseBarKey up anchor chain to find the screen-anchored bar that is the tree root
	local wrapperRootKey = self:FindWrapperRoot(settings, barGroups)
	local primaryIsRoot = (wrapperRootKey == "primary")

	-- If root is not primary, parent the root bar's container to the wrapper
	if not primaryIsRoot then
		local rootGroup = barGroups[wrapperRootKey]
		if rootGroup and wrapperFrame then
			if rootGroup.containerFrame:GetParent() ~= wrapperFrame then
				rootGroup.containerFrame:SetParent(wrapperFrame)
			end
			rootGroup.containerFrame:ClearAllPoints()
			if editModeLayoutEnabled then
				rootGroup.containerFrame:SetPoint("TOP", wrapperFrame, "TOP", 0, 0)
			else
				rootGroup.containerFrame:SetPoint("CENTER", wrapperFrame, "CENTER", 0, 0)
			end
		end
	end

	-- Configure the primary bar group
	if barGroups.primary then
		local primary = barGroups.primary
		local primaryNode = primary:GetNode(1)

		if primaryIsRoot then
			-- Primary is the wrapper root: parent to wrapper and position at origin
			if wrapperFrame and primary.containerFrame:GetParent() ~= wrapperFrame then
				primary.containerFrame:SetParent(wrapperFrame)
			end
			primary.containerFrame:ClearAllPoints()
			if editModeLayoutEnabled then
				primary.containerFrame:SetPoint("TOP", wrapperFrame, "TOP", 0, 0)
			else
				primary.containerFrame:SetPoint("CENTER", wrapperFrame, "CENTER", 0, 0)
			end
		else
			-- Primary is a child bar: parent to wrapper for Edit Mode drag, position via anchor
			if wrapperFrame and primary.containerFrame:GetParent() ~= wrapperFrame then
				primary.containerFrame:SetParent(wrapperFrame)
			end
			local primaryAnchor = self:GetBarAnchor(settings, "primary")
			if primaryAnchor and primaryAnchor.barKey and primaryAnchor.barKey ~= "screen" then
				local anchorGroup = barGroups[primaryAnchor.barKey]
				if anchorGroup then
					local anchorBarSettings = self:GetBarSettings(settings, primaryAnchor.barKey)
					local aBorder = (anchorBarSettings and anchorBarSettings.border) or 0
					local ap = primaryAnchor.anchorPoint or "BOTTOM"
					local att = primaryAnchor.attachPoint or "TOP"
					local xo = primaryAnchor.xOffset or 0
					local yo = primaryAnchor.yOffset or 0
					-- Apply border offsets (same logic as ConstructAnchoredBarGroup)
					if primaryAnchor.matchWidth then
						local isAbove = string.find(ap, "TOP") ~= nil
						local isBelow = string.find(ap, "BOTTOM") ~= nil
						if isAbove then att = "BOTTOM"; ap = "TOP"
						elseif isBelow then att = "TOP"; ap = "BOTTOM" end
						xo = 0
					else
						if string.find(att, "LEFT") ~= nil then xo = xo - aBorder
						elseif string.find(att, "RIGHT") ~= nil then xo = xo + aBorder end
					end
					if string.find(ap, "BOTTOM") ~= nil or ap == "BOTTOM" then yo = yo - aBorder
					elseif string.find(ap, "TOP") ~= nil or ap == "TOP" then yo = yo + aBorder end
					primary.containerFrame:ClearAllPoints()
					primary.containerFrame:SetPoint(att, anchorGroup:GetContainerFrame(), ap, xo, yo)
				end
			end
		end

		-- Primary bar width: always use effectiveWidth.
		-- effectiveWidth already accounts for CDM width matching.
		-- When matchWidth is true on a non-root primary, effectiveWidth is still correct
		-- because it propagates CDM width through the chain without needing to read the
		-- anchor bar's container (which may not be sized yet in this layout pass).
		local primaryWidth = effectiveWidth

		primary.containerFrame:SetWidth(primaryWidth - (settings.bar.border * 2))
		primary.containerFrame:SetHeight(settings.bar.height - (settings.bar.border * 2))

		-- Now position the WRAPPER frame based on the three use cases:
		-- Use Case 1: Edit Mode disabled -> Legacy position (settings.bar.xPos/yPos)
		-- Use Case 2: Edit Mode enabled + Free Position -> Edit Mode saved position
		-- Use Case 3: Edit Mode enabled + CDM anchor -> Anchor to CDM frame
		wrapperFrame:ClearAllPoints()

		if useCdmAnchoring then
			-- Use Case 3: CDM anchoring - anchor wrapper to CDM frame
			-- The real anchor will be refined by ApplyCooldownManagerAnchoring after all bars are laid out
			local cdmFrame = TRB.Functions.EditMode:GetCooldownManagerFrame()
			if cdmFrame then
				if anchorMode == "above" then
					wrapperFrame:SetPoint("BOTTOM", cdmFrame, "TOP", 0, anchorOffset)
				else
					wrapperFrame:SetPoint("TOP", cdmFrame, "BOTTOM", 0, -anchorOffset)
				end
			else
				-- Fallback if CDM frame not available
				wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
			end
		elseif editModeLayoutEnabled then
			-- Use Case 2: Edit Mode enabled + Free Position
			-- Use the position saved by LibEditMode for this layout
			local editModePosition = TRB.Functions.EditMode:GetActivePosition()
			if editModePosition and editModePosition.point then
				wrapperFrame:SetPoint(editModePosition.point, editModePosition.x, editModePosition.y)
			else
				-- No saved Edit Mode position yet; use root bar's screen position as default
				local rootAnchor = self:GetBarAnchor(settings, wrapperRootKey)
				local xPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.xOffset) or settings.bar.xPos or 0
				local yPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.yOffset) or settings.bar.yPos or -200
				wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
			end
		else
			-- Use Case 1: Edit Mode disabled - use root bar's screen position
			local rootAnchor = self:GetBarAnchor(settings, wrapperRootKey)
			local xPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.xOffset) or settings.bar.xPos or 0
			local yPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.yOffset) or settings.bar.yPos or -200
			wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
			-- Legacy mode: wrapper matches root bar dimensions
			wrapperFrame:SetSize(effectiveWidth, settings.bar.height)
		end

		if primaryNode then
			-- Set frame strata
			primary:SetFrameStrata(strata)

			-- Set dimensions (stores values and sizes border/resource frames)
			primaryNode:SetDimensions(primaryWidth, settings.bar.height, settings.bar.border)

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
			local max = TRB.Data.character.maxResource or effectiveWidth
			if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
				max = math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource or max)
			end
			primaryNode:SetMinMax(0, max)

			primary:SetDragAndDrop(false, settings)

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
	-- However, if enableFormSwitching is disabled, skip the secondary bar entirely for non-Feral.
	local hasComboPointSettings = settings.comboPoints ~= nil
	local feralSettingsForDruid = nil
	if not hasComboPointSettings and TRB.Data.character.classId == 11 then
		-- Check if form switching is enabled for this Druid spec
		-- enableFormSwitching defaults to true. Only skip secondary bar if explicitly set to false.
		local specName = TRB.Data.character.specName
		local druidSettings = TRB.Data.settings.druid and TRB.Data.settings.druid[specName]
		local enableFormSwitching = true
		if druidSettings and druidSettings.displayBar and druidSettings.displayBar.enableFormSwitching == false then
			enableFormSwitching = false
		end
		
		if enableFormSwitching then
			-- Try specCache first, fall back to settings.druid.feral if specCache not populated
			feralSettingsForDruid = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			if not feralSettingsForDruid then
				feralSettingsForDruid = TRB.Data.settings.druid and TRB.Data.settings.druid.feral
			end
			if feralSettingsForDruid and feralSettingsForDruid.comboPoints then
				hasComboPointSettings = true
			end
		end
	end

	if barGroups.secondary and hasComboPointSettings then
		-- DRUID SPECIAL CASE: All Druid specs share Feral's combo point settings.
		-- When on a non-Feral Druid spec, use Feral's combo point configuration
		-- so that changes made in Feral options are reflected immediately.
		local effectiveSettings = settings
		if TRB.Data.character.classId == 11 and (TRB.Data.character.specId ~= 2 or not settings.comboPoints) then
			-- Try specCache first, fall back to settings.druid.feral if specCache not populated
			local feralSettings = feralSettingsForDruid
			if not feralSettings then
				feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			end
			if not feralSettings then
				feralSettings = TRB.Data.settings.druid and TRB.Data.settings.druid.feral
			end
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

		-- Resolve anchor group for secondary bar from settings
		local secondaryAnchor = self:GetBarAnchor(effectiveSettings, "secondary")
		local secondaryAnchorKey = (secondaryAnchor and secondaryAnchor.barKey) or "primary"
		local secondaryAnchorGroup
		if secondaryAnchorKey ~= "screen" then
			secondaryAnchorGroup = barGroups[secondaryAnchorKey] or barGroups.primary
		end
		-- secondaryAnchorGroup may be nil if barKey="screen"; ConstructAnchoredBarGroup handles this
		self:ConstructSecondaryBarGroup(effectiveSettings, secondaryAnchorGroup, barGroups.secondary, false)
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
	elseif barGroups.secondary then
		-- No combo point settings for this spec/configuration - hide the secondary bar
		barGroups.secondary:Hide()
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
		-- Resolve anchor group for health bar from settings
		local healthAnchor = self:GetBarAnchor(settings, "health")
		local healthAnchorKey = (healthAnchor and healthAnchor.barKey) or "primary"
		local healthAnchorGroup
		if healthAnchorKey ~= "screen" then
			healthAnchorGroup = barGroups[healthAnchorKey] or barGroups.primary
		end
		-- healthAnchorGroup may be nil if barKey="screen"; ConstructAnchoredBarGroup handles this
		self:ConstructHealthBarGroup(settings, healthAnchorGroup, barGroups.health, true)
	end

	-- Configure custom bar groups from the registry (stagger, defensives, mana, etc.)
	self:ApplyCustomBarGroupsLayout(settings, barGroups)

	-- Apply per-bar smooth animation settings from displayBar
	if settings.displayBar then
		if barGroups.primary and settings.displayBar.primary then
			barGroups.primary:SetSmooth(settings.displayBar.primary.smooth or false)
		end
		if barGroups.secondary and settings.displayBar.secondary then
			barGroups.secondary:SetSmooth(settings.displayBar.secondary.smooth or false)
		end
		if barGroups.health and settings.displayBar.health then
			barGroups.health:SetSmooth(settings.displayBar.health.smooth or false)
		end
		-- Custom bars (mana, stagger, defensives, etc.)
		if barGroups.mana and settings.displayBar.mana then
			barGroups.mana:SetSmooth(settings.displayBar.mana.smooth or false)
		end
		if barGroups.stagger and settings.displayBar.stagger then
			barGroups.stagger:SetSmooth(settings.displayBar.stagger.smooth or false)
		end
		if barGroups.defensives and settings.displayBar.defensives then
			barGroups.defensives:SetSmooth(settings.displayBar.defensives.smooth or false)
		end
	end

	-- Apply CDM anchoring if enabled (must be done after all bars are laid out)
	-- This calculates the bounding box of all visible bars and positions relative to CDM
	if anchorMode ~= "none" and TRB.Functions.EditMode:IsCooldownManagerAvailable() and barGroups.primary then
		self:ApplyCooldownManagerAnchoring(barGroups, anchorMode, anchorOffset, effectiveWidth, settings)
	else
		-- Even when not using CDM anchoring, update wrapper size for proper Edit Mode selection box
		TRB.Functions.EditMode:UpdateWrapperSize(settings)
	end
	
	-- There may be class-specific updates needed after layout changes. Only run this if we're not looping.
	if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
		TRB.Functions.Class:CheckCharacter()
	end
end

---Applies Cooldown Manager anchoring to the bar groups
---This updates the wrapper frame size and re-anchors it to the CDM frame
---@param barGroups table<string, TRB.Classes.BarGroup>
---@param anchorMode string # "above" or "below"
---@param anchorOffset number # Vertical offset in pixels
---@param effectiveWidth number # The width being used (may be CDM-matched)
---@param settings table? # Settings for dimension calculations
function TRB.Functions.Bar:ApplyCooldownManagerAnchoring(barGroups, anchorMode, anchorOffset, effectiveWidth, settings)
	if not barGroups then
		return
	end

	-- Get the CDM frame for anchoring
	local cdmFrame = TRB.Functions.EditMode:GetCooldownManagerFrame()
	if not cdmFrame then
		return
	end

	-- Get the wrapper frame (which is the parent of all bars)
	local wrapperFrame = TRB.Functions.EditMode:GetWrapperFrame()
	if not wrapperFrame then
		return
	end

	-- CRITICAL: In Edit Mode, include ALL bars (even hidden ones) in wrapper calculations.
	-- This ensures the Edit Mode selection box encompasses all bars, not just visible ones.
	-- DO NOT hardcode `false` - use IsInEditMode() to prevent regression.
	local includeHidden = TRB.Functions.EditMode:IsInEditMode()

	-- Calculate wrapper layout from settings (doesn't rely on screen coordinates)
	local totalWidth, totalHeight, extendAbove, extendBelow, baseOffsetX = TRB.Functions.EditMode:CalculateWrapperLayout(settings, includeHidden)
	
	-- Update wrapper frame size to encompass all bars
	-- Use effectiveWidth for width (matches CDM if "Match CDM Width" is enabled)
	wrapperFrame:SetWidth(effectiveWidth)
	wrapperFrame:SetHeight(totalHeight)

	-- Reposition the root bar within the wrapper to account for bars above/beside it
	local wrapperRootKey = self:FindWrapperRoot(settings or {}, barGroups)
	local rootGroup = barGroups[wrapperRootKey]
	if rootGroup then
		rootGroup.containerFrame:ClearAllPoints()
		rootGroup.containerFrame:SetPoint("TOP", wrapperFrame, "TOP", baseOffsetX or 0, -extendAbove)
	end

	-- Now anchor the wrapper to the CDM frame, horizontally centered
	-- Include a 1px base gap to prevent border/CDM overlap regardless of strata
	wrapperFrame:ClearAllPoints()

	if anchorMode == "above" then
		-- Position wrapper above CDM, centered horizontally
		wrapperFrame:SetPoint("BOTTOM", cdmFrame, "TOP", 0, -1 + anchorOffset)
	else -- "below"
		-- Position wrapper below CDM, centered horizontally
		wrapperFrame:SetPoint("TOP", cdmFrame, "BOTTOM", 0, -1 - anchorOffset)
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
			primaryNode:SetColor(settings.colors.bar.base.color)
			primaryNode:SetBorderColor(settings.colors.bar.border.color)
			primaryNode:SetBackgroundColorFromString(settings.colors.bar.background.color)
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
	-- However, if enableFormSwitching is disabled, skip the secondary bar entirely for non-Feral.
	local hasComboPointSettings = settings.comboPoints ~= nil
	local feralSettingsForDruid = nil
	if not hasComboPointSettings and TRB.Data.character.classId == 11 then
		-- Check if form switching is enabled for this Druid spec
		-- enableFormSwitching defaults to true. Only skip if explicitly set to false.
		local specName = TRB.Data.character.specName
		local druidSettings = TRB.Data.settings.druid and TRB.Data.settings.druid[specName]
		local enableFormSwitching = true
		if druidSettings and druidSettings.displayBar and druidSettings.displayBar.enableFormSwitching == false then
			enableFormSwitching = false
		end
		
		if enableFormSwitching then
			-- Try specCache first, fall back to settings.druid.feral if specCache not populated
			feralSettingsForDruid = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			if not feralSettingsForDruid then
				feralSettingsForDruid = TRB.Data.settings.druid and TRB.Data.settings.druid.feral
			end
			if feralSettingsForDruid and feralSettingsForDruid.comboPoints then
				hasComboPointSettings = true
			end
		end
	end

	if barGroups.secondary and hasComboPointSettings then
		-- DRUID SPECIAL CASE: All Druid specs share Feral's combo point settings.
		local effectiveSettings = settings
		if TRB.Data.character.classId == 11 and (TRB.Data.character.specId ~= 2 or not settings.comboPoints) then
			-- Try specCache first, fall back to settings.druid.feral if specCache not populated
			local feralSettings = feralSettingsForDruid
			if not feralSettings then
				feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			end
			if not feralSettings then
				feralSettings = TRB.Data.settings.druid and TRB.Data.settings.druid.feral
			end
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
		local isVengeance = TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 2
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
				elseif isVengeance and i == 1 then
					node:SetMinMax(0, 6) -- 0-6 Soul Fragments
				else
					node:SetMinMax(0, 1)
				end
				node:SetBorderColor(effectiveSettings.colors.comboPoints.border.color)
				node:SetBackgroundColorFromString(effectiveSettings.colors.comboPoints.background.color)
				node:SetColor(effectiveSettings.colors.comboPoints.base.color)
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

	-- Note: TriggerResourceBarUpdates is NOT called here because this function may be called
	-- from EventRegistration before talents/spells are set up. The caller is responsible for
	-- triggering updates after all setup is complete.
end

-- ============================================================================
-- Anchor Tree System
-- ============================================================================
-- The anchor tree system allows each bar to anchor to any other bar, forming a
-- directed acyclic graph (tree). The "base bar" is the root of the tree and
-- receives absolute positioning (from Edit Mode or legacy xPos/yPos). All other
-- bars position themselves relative to their anchor target using 9-point
-- anchor/attach pairs.

---Gets the bar settings table for a given bar key from the spec settings.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barKey string # "primary", "secondary", "health", or a BarTypeRegistry key
---@return table? # The bar's settings table, or nil if not found
function TRB.Functions.Bar:GetBarSettings(settings, barKey)
	if barKey == "primary" then
		return settings.bar
	elseif barKey == "secondary" then
		return settings.comboPoints
	elseif barKey == "health" then
		return settings.healthBar
	else
		-- Check custom bars from BarTypeRegistry
		return settings.bars and settings.bars[barKey]
	end
end

---Gets the anchor block for a given bar key, with fallback from legacy fields.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barKey string
---@return TRB.Classes.Settings.BarAnchor?
function TRB.Functions.Bar:GetBarAnchor(settings, barKey)
	local barSettings = self:GetBarSettings(settings, barKey)
	if not barSettings then
		return nil
	end

	-- New anchor system takes priority
	if barSettings.anchor then
		return barSettings.anchor
	end

	-- Phase 1 fallback: synthesize from legacy fields
	if barSettings.relativeTo then
		local mapping = TRB.Data.constants.relativeToAnchorMap[barSettings.relativeTo]
		if mapping then
			return {
				barKey = "primary",
				anchorPoint = mapping.anchorPoint,
				attachPoint = mapping.attachPoint,
				xOffset = barSettings.xPos or 0,
				yOffset = barSettings.yPos or 0,
				matchWidth = barSettings.fullWidth or false,
			}
		end
	end

	-- Ultimate fallback: bars with xPos/yPos but no relativeTo (e.g., primary bar) are screen-anchored
	if barSettings.xPos ~= nil then
		return {
			barKey = "screen",
			anchorPoint = "CENTER",
			attachPoint = "CENTER",
			xOffset = barSettings.xPos or 0,
			yOffset = barSettings.yPos or -200,
			matchWidth = false,
		}
	end

	return nil
end

---Gets the effective matchWidth setting for a bar, reading from anchor with legacy fallback.
---@param barSettings table # The bar's settings table (e.g., settings.comboPoints)
---@return boolean
function TRB.Functions.Bar:GetMatchWidth(barSettings)
	if barSettings and barSettings.anchor then
		return barSettings.anchor.matchWidth or false
	end
	-- Phase 1 fallback to legacy field
	return barSettings and barSettings.fullWidth or false
end

---Gets the visibility key for a bar key (maps bar keys to displayBar sub-keys).
---@param barKey string
---@return string
function TRB.Functions.Bar:GetVisibilityKey(barKey)
	if barKey == "primary" then
		return "primary"
	elseif barKey == "secondary" then
		return "secondary"
	elseif barKey == "health" then
		return "health"
	else
		-- Custom bars use their BarTypeRegistry visibilityKey, which defaults to barKey
		local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
		if registry then
			local barTypeDef = registry:Get(barKey)
			if barTypeDef then
				return barTypeDef.visibilityKey or barKey
			end
		end
		return barKey
	end
end

---Checks if a bar is visible (not set to "never" visibility).
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barKey string
---@param includeHidden boolean?
---@return boolean
function TRB.Functions.Bar:IsBarVisible(settings, barKey, includeHidden)
	if includeHidden then return true end
	local visKey = self:GetVisibilityKey(barKey)
	local visibilitySetting = settings.displayBar and settings.displayBar[visKey]
	return not visibilitySetting or visibilitySetting.visibility ~= "never"
end

---Enumerates all bar keys present for the current bar groups.
---@param barGroups table<string, TRB.Classes.BarGroup>
---@return string[] # List of bar keys
function TRB.Functions.Bar:GetAllBarKeys(barGroups)
	local keys = {}
	if barGroups.primary then table.insert(keys, "primary") end
	if barGroups.secondary then table.insert(keys, "secondary") end
	if barGroups.health then table.insert(keys, "health") end

	-- Custom bars from BarTypeRegistry
	local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
	if registry then
		local allBarTypes = registry:GetAll()
		for barKey, _ in pairs(allBarTypes) do
			if barGroups[barKey] then
				table.insert(keys, barKey)
			end
		end
	end

	return keys
end

---Gets a human-readable display name for a bar key (for Options UI dropdowns).
---@param barKey string
---@return string
function TRB.Functions.Bar:GetBarDisplayName(barKey)
	local L = TRB.Localization
	if barKey == "screen" then
		return L["AnchorBarScreen"]
	elseif barKey == "primary" then
		return L["AnchorBarPrimary"]
	elseif barKey == "secondary" then
		return L["AnchorBarSecondary"]
	elseif barKey == "health" then
		return L["AnchorBarHealth"]
	else
		local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
		if registry then
			local barTypeDef = registry:Get(barKey)
			if barTypeDef and barTypeDef.displayName then
				return barTypeDef.displayName
			end
		end
		return barKey
	end
end

---Finds the root bar of the wrapper tree by walking up from baseBarKey.
---The root is the bar whose anchor has barKey="screen" (or no anchor), meaning it's positioned on UIParent.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
---@return string # The barKey of the wrapper tree root
function TRB.Functions.Bar:FindWrapperRoot(settings, barGroups)
	local baseBarKey = (settings.anchorLayout and settings.anchorLayout.baseBarKey) or "primary"
	local current = baseBarKey
	local visited = {}
	while true do
		if visited[current] then return current end -- cycle, stop
		visited[current] = true
		local anchor = self:GetBarAnchor(settings, current)
		if not anchor or not anchor.barKey or anchor.barKey == "screen" then
			return current -- reached a screen-anchored bar = this is the root
		end
		if not barGroups[anchor.barKey] then
			return current -- parent doesn't exist in barGroups, this is effectively the root
		end
		current = anchor.barKey
	end
end

---Validates that an anchor configuration does not create a cycle.
---The tree is a forest: bars with barKey="screen" are roots (anchored to UIParent).
---A valid tree means every bar can reach either "screen" or the baseBarKey by
---following parent links without revisiting a node.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
---@param testBarKey string? # If provided, validates with this bar's anchor changed
---@param testAnchorBarKey string? # If provided, the new anchor target for testBarKey
---@return boolean # true if valid (no cycles)
---@return string? # Error message if invalid
function TRB.Functions.Bar:ValidateAnchorTree(settings, barGroups, testBarKey, testAnchorBarKey)
	local allKeys = self:GetAllBarKeys(barGroups)

	-- Build adjacency: child -> parent
	-- Bars with barKey="screen" are roots (parentOf entry is nil)
	local parentOf = {}
	for _, barKey in ipairs(allKeys) do
		local anchor
		if testBarKey and barKey == testBarKey then
			-- Use the proposed test anchor instead of the real one
			anchor = { barKey = testAnchorBarKey }
		else
			anchor = self:GetBarAnchor(settings, barKey)
		end
		if anchor and anchor.barKey and anchor.barKey ~= "screen" then
			parentOf[barKey] = anchor.barKey
		end
		-- barKey="screen" → no parent (root)
	end

	-- Walk from each node to a root; detect cycles via revisit
	for _, barKey in ipairs(allKeys) do
		if parentOf[barKey] then
			local visited = {}
			local current = barKey
			while current and parentOf[current] do
				if visited[current] then
					local L = TRB.Localization
					return false, string.format(L["AnchorCycleError"], self:GetBarDisplayName(testAnchorBarKey or ""))
				end
				visited[current] = true
				current = parentOf[current]
			end
			-- current is now either a root (no parent, i.e. screen-anchored) or nil
			-- If current is nil, the parent chain referenced a non-existent bar — treat as invalid
			if current == nil then
				local L = TRB.Localization
				return false, string.format(L["AnchorCycleError"], self:GetBarDisplayName(testAnchorBarKey or ""))
			end
		end
	end

	return true, nil
end

---Returns the list of bar keys that the specified bar can anchor to without creating a cycle.
---Always includes "screen" as a valid target (anchoring to screen never creates a cycle).
---@param thisBarKey string
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
---@return string[] # List of valid anchor target bar keys (includes "screen")
function TRB.Functions.Bar:GetAvailableAnchorTargets(thisBarKey, settings, barGroups)
	local valid = { "screen" }
	local allKeys = self:GetAllBarKeys(barGroups)
	for _, candidate in ipairs(allKeys) do
		if candidate ~= thisBarKey then
			local ok = self:ValidateAnchorTree(settings, barGroups, thisBarKey, candidate)
			if ok then
				table.insert(valid, candidate)
			end
		end
	end
	return valid
end

---Builds the anchor tree from settings, returning the root node of the baseBarKey's tree.
---The tree is a forest: bars with barKey="screen" are independent roots.
---This function finds the root that contains the baseBarKey and builds only that sub-tree.
---Hidden bars are optionally collapsed: their children re-parent to the hidden bar's parent.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
---@param collapseHidden boolean? # If true, skip hidden bars and re-parent their children
---@param includeHidden boolean? # If true, include bars with visibility="never" in the tree
---@return TRB.Classes.Settings.AnchorTreeNode? # Root node, or nil if tree cannot be built
function TRB.Functions.Bar:BuildAnchorTree(settings, barGroups, collapseHidden, includeHidden)
	if not settings or not barGroups then
		return nil
	end

	local baseBarKey = (settings.anchorLayout and settings.anchorLayout.baseBarKey) or "primary"
	local allKeys = self:GetAllBarKeys(barGroups)

	-- Build all nodes; bars with barKey="screen" or no anchor are roots (anchor = nil)
	---@type table<string, TRB.Classes.Settings.AnchorTreeNode>
	local nodes = {}
	---@type table<string, string> # child -> parent adjacency
	local parentOf = {}
	for _, barKey in ipairs(allKeys) do
		local barSettings = self:GetBarSettings(settings, barKey)
		local barGroup = barGroups[barKey]
		local anchor = self:GetBarAnchor(settings, barKey)
		local isRoot = (not anchor) or (not anchor.barKey) or (anchor.barKey == "screen")
		nodes[barKey] = {
			barKey = barKey,
			anchor = isRoot and nil or anchor,
			children = {},
			barGroup = barGroup,
			barSettings = barSettings,
			width = barSettings and barSettings.width or 0,
			height = barSettings and barSettings.height or 0,
		}
		if not isRoot then
			parentOf[barKey] = anchor.barKey
		end
	end

	-- Find the root of the baseBarKey's tree by walking up the parent chain
	local rootKey = baseBarKey
	local visited = {}
	while parentOf[rootKey] and not visited[rootKey] do
		visited[rootKey] = true
		local parentKey = parentOf[rootKey]
		if nodes[parentKey] then
			rootKey = parentKey
		else
			break -- parent doesn't exist in barGroups; current node is effectively a root
		end
	end

	-- Ensure the root node exists
	if not nodes[rootKey] then
		return nil
	end

	-- Determine which bars belong to this tree (reachable from rootKey via parent chain)
	local inTree = { [rootKey] = true }
	for _, barKey in ipairs(allKeys) do
		if barKey ~= rootKey and not inTree[barKey] then
			-- Walk up from barKey; if we reach a node already known to be in the tree, mark the whole chain
			local chain = {}
			local current = barKey
			local reached = false
			local seen = {}
			while current do
				if inTree[current] then reached = true; break end
				if seen[current] then break end -- cycle
				seen[current] = true
				table.insert(chain, current)
				current = parentOf[current]
			end
			if reached then
				for _, k in ipairs(chain) do
					inTree[k] = true
				end
			end
		end
	end

	-- Build parent-child relationships for bars in this tree
	for _, barKey in ipairs(allKeys) do
		if barKey ~= rootKey and inTree[barKey] then
			local node = nodes[barKey]
			local parentKey = parentOf[barKey] or rootKey

			if collapseHidden then
				-- Walk up the parent chain to find the first visible parent within the tree
				local effectiveParentKey = parentKey
				while effectiveParentKey ~= rootKey and
					  not self:IsBarVisible(settings, effectiveParentKey, includeHidden) do
					effectiveParentKey = parentOf[effectiveParentKey] or rootKey
				end
				parentKey = effectiveParentKey
			end

			-- Only add visible bars (or all bars if includeHidden)
			if self:IsBarVisible(settings, barKey, includeHidden) then
				if nodes[parentKey] then
					table.insert(nodes[parentKey].children, node)
				end
			end
		end
	end

	return nodes[rootKey]
end

---Calculates the pixel position of an anchor point on a rectangle.
---Origin is at bottom-left of the rectangle (WoW convention).
---@param width number
---@param height number
---@param point string # One of the 9 anchor points
---@return number x
---@return number y
function TRB.Functions.Bar:CalculateAnchorPointOffset(width, height, point)
	local x, y = 0, 0
	if point == "TOPLEFT" then
		x, y = 0, height
	elseif point == "TOP" then
		x, y = width / 2, height
	elseif point == "TOPRIGHT" then
		x, y = width, height
	elseif point == "LEFT" then
		x, y = 0, height / 2
	elseif point == "CENTER" then
		x, y = width / 2, height / 2
	elseif point == "RIGHT" then
		x, y = width, height / 2
	elseif point == "BOTTOMLEFT" then
		x, y = 0, 0
	elseif point == "BOTTOM" then
		x, y = width / 2, 0
	elseif point == "BOTTOMRIGHT" then
		x, y = width, 0
	end
	return x, y
end

-- ============================================================================
-- End Anchor Tree System
-- ============================================================================

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

	-- Get effective width (may be CDM-matched) from barGroups or fall back to settings
	local barGroups = TRB.Frames.barGroups
	local effectiveWidth = (barGroups and barGroups.effectiveWidth) or settings.bar.width

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels

	-- Determine node count
	-- Priority: 1) config.nodeCount (explicit), 2) lastRebuildNodeCount (from RebuildNodes, respects compressed view), 3) maxResource2
	local nodes
	if config.nodeCount ~= nil then
		nodes = config.nodeCount
	elseif targetGroup.lastRebuildNodeCount ~= nil then
		-- Use the node count from the last RebuildNodes call (respects compressed view)
		nodes = targetGroup.lastRebuildNodeCount
	else
		nodes = TRB.Data.character.maxResource2
		if nodes == nil or nodes == 0 then
			nodes = targetGroup.maxNodes or 1
		end
		nodes = math.min(nodes, targetGroup.maxNodes or nodes)
	end

	-- Set node count
	targetGroup:SetNodeCount(nodes)

	-- Set layout parameters (use anchor.matchWidth with fallback)
	local matchWidth = self:GetMatchWidth(groupSettings)
	targetGroup:SetLayout(groupSettings.spacing or 0, matchWidth, "HORIZONTAL")

	-- Set frame strata
	targetGroup:SetFrameStrata(strata)

	-- Resolve anchor: new system with Phase 1 legacy fallback
	local anchor = groupSettings.anchor
	if not anchor then
		-- Phase 1 fallback: synthesize from legacy fields
		if groupSettings.relativeTo then
			local mapping = TRB.Data.constants.relativeToAnchorMap[groupSettings.relativeTo]
			if mapping then
				anchor = {
					barKey = "primary",
					anchorPoint = mapping.anchorPoint,
					attachPoint = mapping.attachPoint,
					xOffset = groupSettings.xPos or 0,
					yOffset = groupSettings.yPos or 0,
					matchWidth = groupSettings.fullWidth or false,
				}
			end
		end
		-- Ultimate fallback
		if not anchor then
			if config.defaultAnchorAbove then
				anchor = { barKey = "primary", anchorPoint = "TOP", attachPoint = "BOTTOM", xOffset = 0, yOffset = 0, matchWidth = true }
			else
				anchor = { barKey = "primary", anchorPoint = "BOTTOM", attachPoint = "TOP", xOffset = 0, yOffset = 0, matchWidth = true }
			end
		end
	end

	-- Resolve the actual anchor frame
	local anchorContainer
	local anchorBorder = 0
	if anchor.barKey == "screen" then
		-- Screen anchor: position directly on UIParent
		anchorContainer = UIParent
	elseif anchorGroup and anchorGroup.GetContainerFrame then
		-- Bar anchor: position relative to anchorGroup container
		anchorContainer = anchorGroup:GetContainerFrame()
		local anchorBarSettings = self:GetBarSettings(settings, anchor.barKey)
		anchorBorder = (anchorBarSettings and anchorBarSettings.border) or settings.bar.border
	else
		-- Fallback: anchor to UIParent
		anchorContainer = UIParent
	end

	-- Calculate dimensions
	local groupWidth = groupSettings.width
	local groupHeight = groupSettings.height
	local groupBorder = groupSettings.border

	-- Determine SetPoint values from the anchor
	local attachPoint = anchor.attachPoint
	local anchorPoint = anchor.anchorPoint
	local xPos = anchor.xOffset or 0
	local yPos = anchor.yOffset or 0

	if anchor.matchWidth and anchor.barKey ~= "screen" then
		-- Match width: always use effectiveWidth (the system-wide width).
		-- effectiveWidth accounts for CDM width matching and avoids ordering issues
		-- (the anchor bar's container may not have been sized yet in this layout pass).
		groupWidth = effectiveWidth
		-- Force center alignment vertically (above or below)
		-- Determine if attach is above or below and force center alignment
		local isAbove = string.find(anchorPoint, "TOP") ~= nil
		local isBelow = string.find(anchorPoint, "BOTTOM") ~= nil
		if isAbove then
			attachPoint = "BOTTOM"
			anchorPoint = "TOP"
		elseif isBelow then
			attachPoint = "TOP"
			anchorPoint = "BOTTOM"
		end
		xPos = 0
	else
		-- Apply border offset adjustments for non-matchWidth positioning
		-- This maintains visual alignment when bars have borders
		local isLeft = string.find(attachPoint, "LEFT") ~= nil
		local isRight = string.find(attachPoint, "RIGHT") ~= nil
		local isTop = string.find(attachPoint, "TOP") ~= nil or (attachPoint == "TOP")
		local isBottom = string.find(attachPoint, "BOTTOM") ~= nil or (attachPoint == "BOTTOM")

		if isLeft then
			xPos = xPos - anchorBorder
		elseif isRight then
			xPos = xPos + anchorBorder
		end
	end

	-- Apply border offset for vertical spacing
	local anchorIsTop = string.find(anchorPoint, "TOP") ~= nil or (anchorPoint == "TOP")
	local anchorIsBottom = string.find(anchorPoint, "BOTTOM") ~= nil or (anchorPoint == "BOTTOM")
	if anchorIsBottom then
		yPos = yPos - anchorBorder
	elseif anchorIsTop then
		yPos = yPos + anchorBorder
	end

	-- Position the target container using the new anchor system
	targetGroup.containerFrame:ClearAllPoints()
	targetGroup.containerFrame:SetPoint(attachPoint, anchorContainer, anchorPoint, xPos, yPos)
	targetGroup.containerFrame:SetFrameLevel(frameLevels.cpContainer)

	-- Apply layout or size directly based on config
	if config.useApplyLayout then
		-- Multi-node layout (combo points, runes, etc.)
		targetGroup:ApplyLayout(
			effectiveWidth,
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

	-- Show the group and active nodes only if spec is supported (enabled)
	-- This prevents health bars and other anchored bars from showing when the spec is disabled
	if TRB.Data.specSupported then
		targetGroup:Show()
		targetGroup:ShowNodes(nodes)
	else
		targetGroup:Hide()
	end
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
			
			-- Resolve the correct anchor group from settings
			local anchor = self:GetBarAnchor(settings, key)
			local anchorBarKey = (anchor and anchor.barKey) or "primary"
			local anchorGroup
			if anchorBarKey ~= "screen" then
				anchorGroup = barGroups[anchorBarKey] or barGroups.primary
			end
			-- anchorGroup may be nil if barKey="screen"; ConstructAnchoredBarGroup handles this

			-- Call ConstructAnchoredBarGroup (layout only, appearance handled separately)
			self:ConstructAnchoredBarGroup(settings, anchorGroup, barGroup, config, false)
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

