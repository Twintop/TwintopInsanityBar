---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Bar = {}

local renderTransitionState = {
	active = true,
	token = 0,
	reason = "init",
	defaultDelay = 0.6
}

local function SetBarGroupsAlpha(alpha)
	local barGroups = TRB.Frames.barGroups
	if not barGroups then
		return
	end

	for _, group in pairs(barGroups) do
		if type(group) == "table" and group.SetAlpha then
			group:SetAlpha(alpha)
		elseif type(group) == "table" and group.GetContainerFrame then
			local container = group:GetContainerFrame()
			if container and container.SetAlpha then
				container:SetAlpha(alpha)
			end
		end
	end

	-- Also handle legacy frames just in case
	if TRB.Frames.barContainerFrame then
		TRB.Frames.barContainerFrame:SetAlpha(alpha)
	end
	if TRB.Frames.resource2ContainerFrame then
		TRB.Frames.resource2ContainerFrame:SetAlpha(alpha)
	end
end

-- Initialize transition state early to prevent flash on load
-- We'll clear this after a safe delay
C_Timer.After(10, function()
	if renderTransitionState.active and renderTransitionState.reason == "init" then
		TRB.Functions.Bar:EndRenderTransition("init:timeout")
	end
end)

local function HideAllBarGroupsAndBarText()
	local barGroups = TRB.Frames.barGroups

	if barGroups then
		for _, group in pairs(barGroups) do
			if type(group) == "table" and group.Hide then
				group:Hide()
			end
		end
	end

	-- Brutally hide legacy frames
	if TRB.Frames.barContainerFrame then
		TRB.Frames.barContainerFrame:Hide()
	end
	if TRB.Frames.resource2ContainerFrame then
		TRB.Frames.resource2ContainerFrame:Hide()
	end

	if TRB.Data.snapshotData and TRB.Data.snapshotData.attributes then
		TRB.Data.snapshotData.attributes.isTracking = false
	end

	if TRB.Data.specCache and TRB.Data.character and TRB.Data.character.compositeKey and TRB.Functions.BarText and TRB.Functions.BarText.Hide then
		local specCacheEntry = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if specCacheEntry and specCacheEntry.settings then
			TRB.Functions.BarText:Hide(specCacheEntry.settings)
		end
	end
end

---Builds a map from barKey to its root barKey by traversing a forest
---@param forest table<string, table> # Forest from BuildAnchorForest
---@return table<string, string> # Map of barKey -> rootBarKey
local function BuildBarKeyToRootMap(forest)
	local map = {}
	local function traverse(node, rootKey)
		map[node.barKey] = rootKey
		if node.children then
			for _, child in ipairs(node.children) do
				traverse(child, rootKey)
			end
		end
	end
	for rootKey, rootNode in pairs(forest) do
		traverse(rootNode, rootKey)
	end
	return map
end

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

---Calculates the total rendered width of a multi-node bar group (e.g., combo points).
---For multi-node bars, `barSettings.width` is per-node width, not total width.
---The total width is:  nodeCount * nodeWidth + (nodeCount - 1) * spacing
---@param barKey string # The bar key (e.g., "secondary")
---@param barSettings table? # The bar's settings (e.g., settings.comboPoints)
---@param barGroup TRB.Classes.BarGroup? # The bar group (for nodeCount)
---@return number # Total rendered width, or 0 if not applicable
function TRB.Functions.Bar:GetMultiNodeBarTotalWidth(barKey, barSettings, barGroup)
	if not barSettings then
		return 0
	end

	-- Determine if this bar is multi-node
	local isMultiNode = false
	local maxNodes = 1
	if barKey == "secondary" then
		isMultiNode = true
		maxNodes = TRB.Data.character.maxResource2 or 5
	else
		-- Check the BarTypeRegistry for custom multi-node bars (e.g., defensives)
		local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
		if registry then
			local barTypeDef = registry:Get(barKey)
			if barTypeDef and barTypeDef.isMultiNode and (barTypeDef.maxNodes or 1) > 1 then
				isMultiNode = true
				maxNodes = barTypeDef.maxNodes
			end
		end
	end

	if not isMultiNode then
		return barSettings.width or 0
	end

	-- Resolve actual node count from the bar group if available
	local nodeCount = maxNodes
	if barGroup and barGroup.lastRebuildNodeCount then
		nodeCount = barGroup.lastRebuildNodeCount
	elseif barGroup and barGroup.nodeCount and barGroup.nodeCount > 0 then
		nodeCount = barGroup.nodeCount
	end
	local nodeWidth = barSettings.width or 10
	local nodeSpacing = barSettings.spacing or 2
	return (nodeWidth * nodeCount) + (nodeSpacing * (nodeCount - 1))
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

	if self:IsRenderTransitionActive() then
		return
	end

	TRB.Data.snapshotData.attributes.isTracking = true
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Bar:IsRenderTransitionActive()
	return renderTransitionState.active
end

function TRB.Functions.Bar:QueueRenderTransition(reason, delaySeconds)
	local delay = delaySeconds or renderTransitionState.defaultDelay
	if delay < 0 then
		delay = 0
	end

	renderTransitionState.active = true
	renderTransitionState.reason = reason
	renderTransitionState.token = renderTransitionState.token + 1
	local token = renderTransitionState.token
	
	-- Force immediate hide
	HideAllBarGroupsAndBarText()
	SetBarGroupsAlpha(0)

	C_Timer.After(delay, function()
		if renderTransitionState.active and renderTransitionState.token == token then
			TRB.Functions.Bar:EndRenderTransition("timer")
		end
	end)
end

function TRB.Functions.Bar:TouchRenderTransition(delaySeconds)
	if not renderTransitionState.active then
		return
	end

	local delay = delaySeconds or renderTransitionState.defaultDelay
	if delay < 0 then
		delay = 0
	end

	renderTransitionState.token = renderTransitionState.token + 1
	local token = renderTransitionState.token
	
	-- Re-enforce hide
	HideAllBarGroupsAndBarText()
	SetBarGroupsAlpha(0)

	C_Timer.After(delay, function()
		if renderTransitionState.active and renderTransitionState.token == token then
			TRB.Functions.Bar:EndRenderTransition("activity")
		end
	end)
end

function TRB.Functions.Bar:EndRenderTransition(reason)
	if not renderTransitionState.active then
		return
	end

	renderTransitionState.active = false
	renderTransitionState.reason = reason

	-- Guard: if the WoW-reported spec no longer matches our stored specId, a spec switch is
	-- still in progress (LoadFromSpecializationCache may not have run yet). Bail out — the
	-- pending SwitchSpec will queue its own render transition and handle the update.
	local currentSpec = GetSpecialization()
	if currentSpec and TRB.Data.character and TRB.Data.character.specId ~= currentSpec then
		SetBarGroupsAlpha(1)
		return
	end

	TRB.Functions.BarVisibility:MarkDirty()
	TRB.Functions.Bar:HideResourceBar()
	if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end

	-- Restore alpha only AFTER visibility logic has run
	-- This prevents a single-frame flash where alpha becomes 1 while the bar is still technically "shown" but should be hidden
	SetBarGroupsAlpha(1)
end

function TRB.Functions.Bar:HideResourceBar(force)
	force = force or false
	
	if TRB.Data.character.inPetBattle or TRB.Data.character.onTaxi then
		force = true
	end

	-- If spec is not supported (disabled), hide all bars immediately and skip all other logic
	if not TRB.Data.specSupported then
		HideAllBarGroupsAndBarText()
		return
	end

	if self:IsRenderTransitionActive() then
		HideAllBarGroupsAndBarText()
		return
	end

	-- If Edit Mode is active, ensure bars stay visible so they can be repositioned
	-- Primary bar ALWAYS shows; other bars show unless configured to "never" display
	if TRB.Functions.EditMode and TRB.Functions.EditMode:IsInEditMode() then
		local barGroups = TRB.Frames.barGroups
		local displayBar = nil
		local specSettings = nil
		if TRB.Data.specCache and TRB.Data.character.compositeKey then
			specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
			if specSettings and specSettings.settings then
				displayBar = specSettings.settings.displayBar
			end
		end

		if barGroups then
			-- Build Edit Mode entries using the visibility engine
			local editContext = TRB.Classes.BarVisibilityContext:New(
				false, true, false, true, true, false
			)
			local entries = TRB.Functions.BarVisibility:BuildEditModeEntries(
				barGroups, displayBar, TRB.Data.character.maxResource2
			)
			local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
			TRB.Functions.BarVisibility:ProcessBars(
				editContext, entries, snapshotData,
				(specSettings and specSettings.settings) or nil
			)
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
	
	-- Check anchor frame - if anchor frame is set, don't override position here
	-- Anchor positioning is handled by ApplyBarGroupsLayout and ApplyAnchorFramePositioning
	local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey()
	if editModeLayoutEnabled and anchorFrameKey ~= "none" then
		local customFrameName = TRB.Functions.EditMode:GetCustomFrameName()
		if TRB.Functions.EditMode:IsAnchorFrameAvailable(anchorFrameKey, customFrameName) then
			-- Anchor positioning is active - position is controlled by ApplyBarGroupsLayout
			-- Just redraw thresholds and return
			TRB.Functions.Threshold:RedrawThresholdLines()
			return
		end
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

	-- Pre-emptive hide before doing anything else
	if self:IsRenderTransitionActive() then
		SetBarGroupsAlpha(0)
	end
	
	self:TouchRenderTransition(0.35)

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

	-- Create bar text frames (essential for bar text display)
	TRB.Functions.BarText:CreateBarTextFrames()
	TRB.Functions.BarText:Hide(settings)
	TRB.Functions.BarVisibility:MarkDirty()
	TRB.Functions.Class:HideResourceBar()

	if self:IsRenderTransitionActive() then
		SetBarGroupsAlpha(0)
	end
end

---Applies size/position/layout updates to existing bar groups (OOP system only).
---This is safe to call from Options UI sliders for live updates.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	self:TouchRenderTransition(0.35)

	-- If render transition is active, force alpha 0 to prevent flicker
	if self:IsRenderTransitionActive() then
		SetBarGroupsAlpha(0)
	end

	-- Don't apply layout if spec is not supported (disabled in settings)
	if not TRB.Data.specSupported then
		return
	end

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels

	-- ========================
	-- DRUID SPECIAL CASE: Non-Feral Druids use Feral's combo point settings
	-- for layout purposes (anchor, dimensions, textures, colors). This must happen
	-- BEFORE building the anchor forest so the correct anchor config (e.g.,
	-- barKey="screen" for CDM binding) is used for tree construction.
	-- Triggers when form switching OR showComboPoints is enabled.
	-- ========================
	local layoutSettings = settings
	if TRB.Data.character.classId == 11 and TRB.Data.character.specId ~= 2 and barGroups.secondary then
		local specName = TRB.Data.character.specName
		local druidSettings = TRB.Data.settings.druid and TRB.Data.settings.druid[specName]
		local enableFormSwitching = true
		if druidSettings and druidSettings.displayBar and druidSettings.displayBar.enableFormSwitching == false then
			enableFormSwitching = false
		end
		local showComboPoints = druidSettings and druidSettings.displayBar and druidSettings.displayBar.showComboPoints

		if enableFormSwitching or showComboPoints then
			local feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			if not feralSettings then
				feralSettings = TRB.Data.settings.druid and TRB.Data.settings.druid.feral
			end
			if feralSettings and feralSettings.comboPoints then
				---@diagnostic disable-next-line: missing-fields
				layoutSettings = {}
				for k, v in pairs(settings) do
					layoutSettings[k] = v
				end
				layoutSettings.comboPoints = feralSettings.comboPoints
				-- Merge textures
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
					layoutSettings.textures = newTextures
				end
				-- Merge colors
				if feralSettings.colors and feralSettings.colors.comboPoints then
					local newColors = {}
					if settings.colors then
						for k, v in pairs(settings.colors) do
							newColors[k] = v
						end
					end
					newColors.comboPoints = feralSettings.colors.comboPoints
					layoutSettings.colors = newColors
				end
			end
		end
	end

	-- ========================
	-- Build the anchor forest and per-root metadata
	-- ========================
	local forest = self:BuildAnchorForest(layoutSettings, barGroups, false, false)
	local barKeyToRoot = BuildBarKeyToRootMap(forest)

	-- Per-root data: wrappers, anchor settings, effectiveWidth/effectiveHeight
	local rootMetadata = {}
	for rootBarKey, _ in pairs(forest) do
		local wrapper = TRB.Functions.EditMode:GetOrCreateWrapperFrame(rootBarKey)
		local rootWidthMatch = TRB.Functions.EditMode:IsWidthMatchingEnabled(nil, rootBarKey)
		local rootHeightMatch = TRB.Functions.EditMode:IsHeightMatchingEnabled(nil, rootBarKey)
		local rootEffWidth
		if rootBarKey == "primary" then
			rootEffWidth = settings.bar.width
		else
			local rootBarSettings = self:GetBarSettings(layoutSettings, rootBarKey)
			-- For multi-node bars (e.g., secondary/combo points), barSettings.width is
			-- per-node width. The total rendered width is nodeCount * nodeWidth + spacing.
			-- Without this, the root effective width would be just one node's width.
			local rootGroup = barGroups[rootBarKey]
			rootEffWidth = self:GetMultiNodeBarTotalWidth(rootBarKey, rootBarSettings, rootGroup)
			if rootEffWidth == 0 then
				rootEffWidth = (rootBarSettings and rootBarSettings.width) or settings.bar.width
			end
		end

		-- Resolve anchor frame settings
		local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey(nil, rootBarKey)
		local customFrameName = TRB.Functions.EditMode:GetCustomFrameName(nil, rootBarKey)
		local anchorFrame = TRB.Functions.EditMode:GetAnchorFrame(anchorFrameKey, customFrameName)
		local useAnchorFrame = TRB.Functions.EditMode:IsLayoutEnabled(nil, rootBarKey)
			and anchorFrameKey ~= "none"
			and anchorFrame ~= nil

		if rootWidthMatch and useAnchorFrame then
			local targetWidth = TRB.Functions.EditMode:GetAnchorFrameWidth(anchorFrameKey, customFrameName)
			if targetWidth then rootEffWidth = targetWidth end
		end

		-- Resolve root effective height: use the bar's OWN settings height, not settings.bar.height.
		-- For primary, that IS settings.bar.height; for non-primary roots (mana, stagger, etc.)
		-- it must be the bar's own barSettings.height, otherwise the wrapper uses the wrong base
		-- height when height matching is disabled.
		local rootEffHeight
		if rootBarKey == "primary" then
			rootEffHeight = settings.bar.height
		else
			local rootBarSettings = self:GetBarSettings(layoutSettings, rootBarKey)
			rootEffHeight = (rootBarSettings and rootBarSettings.height) or settings.bar.height
		end
		if rootHeightMatch and useAnchorFrame then
			local targetHeight = TRB.Functions.EditMode:GetAnchorFrameHeight(anchorFrameKey, customFrameName)
			if targetHeight then rootEffHeight = targetHeight end
		end

		rootMetadata[rootBarKey] = {
			wrapper = wrapper,
			effectiveWidth = rootEffWidth,
			effectiveHeight = rootEffHeight,
			editModeEnabled = TRB.Functions.EditMode:IsLayoutEnabled(nil, rootBarKey),
			anchorFrameKey = anchorFrameKey,
			customFrameName = customFrameName,
			anchorFrame = anchorFrame,
			anchorPoint = TRB.Functions.EditMode:GetAnchorPoint(nil, rootBarKey),
			attachPoint = TRB.Functions.EditMode:GetAttachPoint(nil, rootBarKey),
			xOffset = TRB.Functions.EditMode:GetHorizontalOffset(nil, rootBarKey),
			yOffset = TRB.Functions.EditMode:GetVerticalOffset(nil, rootBarKey),
			useAnchorFrame = useAnchorFrame,
			-- Backward compat: synthesized anchorMode/anchorOffset for callers that still use them
			anchorMode = TRB.Functions.EditMode:GetAnchorMode(nil, rootBarKey),
			anchorOffset = TRB.Functions.EditMode:GetVerticalOffset(nil, rootBarKey),
			useCdm = useAnchorFrame,  -- backward compat alias
		}
	end

	-- Primary root's effectiveWidth is the canonical one for secondary bar width matching
	local primaryRootKey = barKeyToRoot["primary"] or "primary"
	local primaryRootMeta = rootMetadata[primaryRootKey]
	local effectiveWidth = primaryRootMeta and primaryRootMeta.effectiveWidth or settings.bar.width
	barGroups.effectiveWidth = effectiveWidth

	-- Store per-root effective widths for ResolveBarWidth
---@diagnostic disable-next-line: missing-fields
	barGroups.rootEffectiveWidths = {}
	-- Store per-root effective heights for height matching
---@diagnostic disable-next-line: missing-fields
	barGroups.rootEffectiveHeights = {}
	for rootBarKey, meta in pairs(rootMetadata) do
		barGroups.rootEffectiveWidths[rootBarKey] = meta.effectiveWidth
		barGroups.rootEffectiveHeights[rootBarKey] = meta.effectiveHeight
	end

	-- Parent each tree root's bar to its tree's wrapper frame
	for rootBarKey, meta in pairs(rootMetadata) do
		local rootGroup = barGroups[rootBarKey]
		if rootGroup and meta.wrapper then
			if rootGroup.containerFrame:GetParent() ~= meta.wrapper then
				rootGroup.containerFrame:SetParent(meta.wrapper)
			end
			rootGroup.containerFrame:ClearAllPoints()
			if meta.editModeEnabled then
				rootGroup.containerFrame:SetPoint("TOP", meta.wrapper, "TOP", 0, 0)
			else
				rootGroup.containerFrame:SetPoint("CENTER", meta.wrapper, "CENTER", 0, 0)
			end
		end
	end

	-- Re-parent non-root bars to their root's wrapper frame.
	-- This is critical when a bar transitions from root to non-root: its containerFrame
	-- was parented to its own wrapper (which gets hidden), so it must be re-parented
	-- to the new root's wrapper to remain visible.
	for barKey, rootBarKey in pairs(barKeyToRoot) do
		if barKey ~= rootBarKey then
			local barGroup = barGroups[barKey]
			local rootMeta = rootMetadata[rootBarKey]
			if barGroup and rootMeta and rootMeta.wrapper then
				if barGroup.containerFrame:GetParent() ~= rootMeta.wrapper then
					barGroup.containerFrame:SetParent(rootMeta.wrapper)
				end
			end
		end
	end

	-- Configure the primary bar group
	if barGroups.primary then
		local primary = barGroups.primary
		local primaryNode = primary:GetNode(1)
		local primaryIsRoot = (primaryRootKey == "primary")

		-- If primary is NOT the root (it's a child bar in another root's tree),
		-- parent it to its root's wrapper and position via anchor
		if not primaryIsRoot then
			local rootWrapper = primaryRootMeta and primaryRootMeta.wrapper
			if rootWrapper and primary.containerFrame:GetParent() ~= rootWrapper then
				primary.containerFrame:SetParent(rootWrapper)
			end
			local primaryAnchor = self:GetBarAnchor(settings, "primary")
			if primaryAnchor and primaryAnchor.barKey and primaryAnchor.barKey ~= "screen" then
				local anchorGroup = barGroups[primaryAnchor.barKey]
				if anchorGroup then
					local ap = primaryAnchor.anchorPoint or "BOTTOM"
					local att = primaryAnchor.attachPoint or "TOP"
					local xo = primaryAnchor.xOffset or 0
					local yo = primaryAnchor.yOffset or 0
					-- Apply matchWidth center-alignment override
					if primaryAnchor.matchWidth then
						ap = string.gsub(ap, "LEFT", "")
						ap = string.gsub(ap, "RIGHT", "")
						att = string.gsub(att, "LEFT", "")
						att = string.gsub(att, "RIGHT", "")
						if ap == "" then ap = "CENTER" end
						if att == "" then att = "CENTER" end
						xo = 0
					end
					primary.containerFrame:ClearAllPoints()
					primary.containerFrame:SetPoint(att, anchorGroup:GetAnchorFrame(), ap, xo, yo)
				end
			end
		end
		-- If primary IS the root, it was already parented and positioned by the per-root loop above.

		-- Primary bar width: always use effectiveWidth.
		-- effectiveWidth already accounts for CDM width matching.
		local primaryWidth = effectiveWidth

		-- Primary bar height: use effectiveHeight from root metadata if available
		-- (accounts for anchor frame height matching), otherwise fall back to settings.
		local primaryHeight = (primaryRootMeta and primaryRootMeta.effectiveHeight) or settings.bar.height

		-- Primary group container matches the node's outer dimensions
		primary.containerFrame:SetWidth(primaryWidth)
		primary.containerFrame:SetHeight(primaryHeight)

		if primaryNode then
			-- Set frame strata
			primary:SetFrameStrata(strata)

			-- Set dimensions (outer dimensions including border)
			primaryNode:SetDimensions(primaryWidth, primaryHeight, settings.bar.border)

			-- Set frame level
			primaryNode:SetFrameLevel(frameLevels.bar)

			-- Primary node should fill the primary group container
			local primaryNodeFrame = primaryNode:GetFrame()
			if primaryNodeFrame then
				primaryNodeFrame:ClearAllPoints()
				primaryNodeFrame:SetAllPoints(primary.containerFrame)
			end

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

			-- If render transition is active, keep it hidden (alpha 0) despite the Show() call
			if self:IsRenderTransitionActive() then
				SetBarGroupsAlpha(0)
			end

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
	-- DRUID SPECIAL CASE: layoutSettings already has Feral's comboPoints merged in
	-- (done above, before BuildAnchorForest) so we can use it directly.
	local hasComboPointSettings = layoutSettings.comboPoints ~= nil

	if barGroups.secondary and hasComboPointSettings then
		-- Resolve anchor group for secondary bar from settings
		local secondaryAnchor = self:GetBarAnchor(layoutSettings, "secondary")
		local secondaryAnchorKey = (secondaryAnchor and secondaryAnchor.barKey) or "primary"
		local secondaryAnchorGroup
		if secondaryAnchorKey ~= "screen" then
			secondaryAnchorGroup = barGroups[secondaryAnchorKey] or barGroups.primary
		end
		-- secondaryAnchorGroup may be nil if barKey="screen"; ConstructAnchoredBarGroup handles this
		self:ConstructSecondaryBarGroup(layoutSettings, secondaryAnchorGroup, barGroups.secondary, false)
		-- Demon Hunter Devourer: secondary is a true 0..50 bar, and values may be "secret".
		-- Keep the node min/max in that range so SetValue() works without scaling/clamping.
		if TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 3 then
			local sfNode = barGroups.secondary:GetNode(1)
			if sfNode then
				sfNode:SetMinMax(0, TRB.Data.character.maxResource2Value or 50)
			end
		-- Demon Hunter Vengeance: 6 Soul Fragment nodes use stepped min/max ranges.
		-- ConstructAnchoredBarGroup resets all nodes to (0,1); restore (i-1, i) here.
		elseif TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 2 then
			for i = 1, barGroups.secondary.maxNodes do
				local node = barGroups.secondary:GetNode(i)
				if node then
					node:SetMinMax(i - 1, i)
				end
			end
		end

		-- Redraw thresholds on secondary nodes to match new bar dimensions
		for i = 1, barGroups.secondary.maxNodes do
			local node = barGroups.secondary:GetNode(i)
			if node then
				local thresholds = node:GetThresholds()
				if thresholds and #thresholds > 0 then
					for _, threshold in ipairs(thresholds) do
						TRB.Functions.Threshold:ResetThresholdLineComboPoint(threshold, layoutSettings)
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
		local healthAnchor = self:GetBarAnchor(layoutSettings, "health")
		local healthAnchorKey = (healthAnchor and healthAnchor.barKey) or "primary"
		local healthAnchorGroup
		if healthAnchorKey ~= "screen" then
			healthAnchorGroup = barGroups[healthAnchorKey] or barGroups.primary
		end
		-- healthAnchorGroup may be nil if barKey="screen"; ConstructAnchoredBarGroup handles this
		self:ConstructHealthBarGroup(layoutSettings, healthAnchorGroup, barGroups.health, true)
	end

	-- Configure custom bar groups from the registry (stagger, defensives, mana, etc.)
	self:ApplyCustomBarGroupsLayout(layoutSettings, barGroups)

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

	-- ========================
	-- Per-root wrapper positioning (replaces single-wrapper positioning)
	-- Each root bar tree gets its own wrapper with independent anchor settings
	-- ========================
	for rootBarKey, meta in pairs(rootMetadata) do
		local wrapperFrame = meta.wrapper
		wrapperFrame:ClearAllPoints()

		if meta.useAnchorFrame then
			-- Anchored to another frame: set point using anchor/attach points + offsets
			local targetFrame = meta.anchorFrame
			if targetFrame then
				wrapperFrame:SetPoint(meta.attachPoint, targetFrame, meta.anchorPoint, meta.xOffset, meta.yOffset)
			else
				-- Frame not available (shouldn't reach here due to useAnchorFrame check)
				wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
			end
		elseif meta.editModeEnabled then
			-- Edit Mode enabled + Free Position
			local editModePosition = TRB.Functions.EditMode:GetActivePosition(rootBarKey)
			if editModePosition and editModePosition.point then
				wrapperFrame:SetPoint(editModePosition.point, editModePosition.x, editModePosition.y)
			else
				-- No saved Edit Mode position yet; use root bar's screen position as default
				local rootAnchor = self:GetBarAnchor(layoutSettings, rootBarKey)
				local xPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.xOffset) or settings.bar.xPos or 0
				local yPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.yOffset) or settings.bar.yPos or -200
				wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
			end
		else
			-- Edit Mode disabled - use root bar's screen position
			local rootAnchor = self:GetBarAnchor(layoutSettings, rootBarKey)
			local xPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.xOffset) or settings.bar.xPos or 0
			local yPos = (rootAnchor and rootAnchor.barKey == "screen" and rootAnchor.yOffset) or settings.bar.yPos or -200
			wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
			-- Legacy mode: wrapper matches root bar dimensions
			wrapperFrame:SetSize(meta.effectiveWidth, meta.effectiveHeight)
		end
	end

	-- Re-register tree roots BEFORE sizing so stale wrapper frames (from bars that
	-- changed from root to non-root) are hidden and new roots are registered.
	-- This must happen before CDM anchoring/UpdateWrapperSize because RegisterTreeRoot
	-- calls UpdateWrapperSize internally, and we want the explicit sizing below to
	-- be the final authority on wrapper dimensions.
	if TRB.Functions.EditMode and TRB.Functions.EditMode.RegisterAllTreeRoots then
		TRB.Functions.EditMode:RegisterAllTreeRoots()
	end

	-- Per-root anchor frame positioning / wrapper sizing (must be done after all bars are laid out)
	for rootBarKey, meta in pairs(rootMetadata) do
		if meta.useAnchorFrame then
			self:ApplyAnchorFramePositioning(barGroups, meta, layoutSettings, rootBarKey)
		else
			TRB.Functions.EditMode:UpdateWrapperSize(layoutSettings, rootBarKey)
		end
	end

	-- There may be class-specific updates needed after layout changes. Only run this if we're not looping.
	if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
		TRB.Functions.Class:CheckCharacter()
	end
end

---Applies anchor frame positioning to the bar groups wrapper.
---Updates wrapper size to encompass all bars, then anchors using 9-point system.
---@param barGroups table<string, TRB.Classes.BarGroup>
---@param meta table # Root metadata from ApplyBarGroupsLayout (includes anchorFrame, anchorPoint, attachPoint, etc.)
---@param settings table? # Settings for dimension calculations
---@param rootBarKey string # The root bar key for this tree
function TRB.Functions.Bar:ApplyAnchorFramePositioning(barGroups, meta, settings, rootBarKey)
	if not barGroups then
		return
	end

	local targetFrame = meta.anchorFrame
	if not targetFrame then
		return
	end

	rootBarKey = rootBarKey or "primary"
	local wrapperFrame = TRB.Functions.EditMode:GetWrapperFrame(rootBarKey)
	if not wrapperFrame then
		return
	end

	-- CRITICAL: In Edit Mode, include ALL bars (even hidden ones) in wrapper calculations.
	local includeHidden = TRB.Functions.EditMode:IsInEditMode()

	-- Calculate wrapper layout for this specific root's tree
	local totalWidth, totalHeight, extendAbove, extendBelow, baseOffsetX = TRB.Functions.EditMode:CalculateWrapperLayout(settings, includeHidden, rootBarKey)

	-- Update wrapper frame size to encompass all bars in this tree
	wrapperFrame:SetWidth(meta.effectiveWidth)
	wrapperFrame:SetHeight(totalHeight)

	-- Reposition the root bar within the wrapper.
	local rootGroup = barGroups[rootBarKey]
	if rootGroup then
		rootGroup.containerFrame:ClearAllPoints()
		rootGroup.containerFrame:SetPoint("TOP", wrapperFrame, "TOP", 0, -extendAbove)
	end

	-- Anchor the wrapper to the target frame using the 9-point system
	wrapperFrame:ClearAllPoints()
	wrapperFrame:SetPoint(meta.attachPoint, targetFrame, meta.anchorPoint, meta.xOffset, meta.yOffset)
end

---@deprecated Use ApplyAnchorFramePositioning instead.
---Applies Cooldown Manager anchoring to the bar groups (backward compat wrapper)
---@param barGroups table<string, TRB.Classes.BarGroup>
---@param anchorMode string # "above" or "below"
---@param anchorOffset number # Vertical offset in pixels
---@param effectiveWidth number # The width being used (may be CDM-matched)
---@param settings table? # Settings for dimension calculations
---@param rootBarKey string # The root bar key for this tree
function TRB.Functions.Bar:ApplyCooldownManagerAnchoring(barGroups, anchorMode, anchorOffset, effectiveWidth, settings, rootBarKey)
	local cdmFrame = TRB.Functions.EditMode:GetCooldownManagerFrame()
	if not cdmFrame then
		return
	end

	-- Build a synthetic meta table for the new function
	local attachPoint, anchorPoint, yOff
	if anchorMode == "above" then
		attachPoint = "BOTTOM"
		anchorPoint = "TOP"
		yOff = anchorOffset
	else
		attachPoint = "TOP"
		anchorPoint = "BOTTOM"
		yOff = -anchorOffset
	end

	local meta = {
		anchorFrame = cdmFrame,
		anchorPoint = anchorPoint,
		attachPoint = attachPoint,
		xOffset = 0,
		yOffset = yOff,
		effectiveWidth = effectiveWidth,
	}

	self:ApplyAnchorFramePositioning(barGroups, meta, settings, rootBarKey)
end


---Lightweight wrapper refresh that recalculates wrapper/CDM positioning without
---triggering a full bar reconstruction or render transition.
---Called when the visible set of bars changes (e.g., Druid form switch) so that
---the wrapper size, root bar offset, and CDM anchor are updated to match.
function TRB.Functions.Bar:RefreshWrapperPositioning()
	local barGroups = TRB.Frames.barGroups
	if not barGroups or not barGroups.primary then
		return
	end

	-- Get current spec settings
	local settings
	if TRB.Data.specCache and TRB.Data.character.compositeKey then
		local specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if specCache then
			settings = specCache.settings
		end
	end
	if not settings then
		return
	end

	local editModeLayoutEnabled = TRB.Functions.EditMode:IsLayoutEnabled()

	-- DRUID SPECIAL CASE: Non-Feral Druids use Feral's comboPoints for forest building
	local layoutSettings = settings
	if TRB.Data.character.classId == 11 and TRB.Data.character.specId ~= 2 and barGroups.secondary then
		local specName = TRB.Data.character.specName
		local druidSettings = TRB.Data.settings.druid and TRB.Data.settings.druid[specName]
		local enableFormSwitching = true
		if druidSettings and druidSettings.displayBar and druidSettings.displayBar.enableFormSwitching == false then
			enableFormSwitching = false
		end
		local showComboPoints = druidSettings and druidSettings.displayBar and druidSettings.displayBar.showComboPoints
		if enableFormSwitching or showComboPoints then
			local feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			if not feralSettings then
				feralSettings = TRB.Data.settings.druid and TRB.Data.settings.druid.feral
			end
			if feralSettings and feralSettings.comboPoints then
				---@diagnostic disable-next-line: missing-fields
				layoutSettings = {}
				for k, v in pairs(settings) do
					layoutSettings[k] = v
				end
				layoutSettings.comboPoints = feralSettings.comboPoints
			end
		end
	end

	-- Build forest to iterate per-root
	local forest = self:BuildAnchorForest(layoutSettings, barGroups, false, false)

	for rootBarKey, _ in pairs(forest) do
		local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey(nil, rootBarKey)
		local customFrameName = TRB.Functions.EditMode:GetCustomFrameName(nil, rootBarKey)
		local anchorFrame = TRB.Functions.EditMode:GetAnchorFrame(anchorFrameKey, customFrameName)
		local rootEditEnabled = TRB.Functions.EditMode:IsLayoutEnabled(nil, rootBarKey)
		local useAnchorFrame = rootEditEnabled and anchorFrameKey ~= "none" and anchorFrame ~= nil

		if useAnchorFrame then
			local rootEffWidth = (barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths[rootBarKey]) or barGroups.effectiveWidth or settings.bar.width
			local meta = {
				anchorFrame = anchorFrame,
				anchorPoint = TRB.Functions.EditMode:GetAnchorPoint(nil, rootBarKey),
				attachPoint = TRB.Functions.EditMode:GetAttachPoint(nil, rootBarKey),
				xOffset = TRB.Functions.EditMode:GetHorizontalOffset(nil, rootBarKey),
				yOffset = TRB.Functions.EditMode:GetVerticalOffset(nil, rootBarKey),
				effectiveWidth = rootEffWidth,
			}
			self:ApplyAnchorFramePositioning(barGroups, meta, layoutSettings, rootBarKey)
		else
			TRB.Functions.EditMode:UpdateWrapperSize(layoutSettings, rootBarKey)
		end
	end

	-- Druid form-switch: hide/show wrappers for form-dependent tree roots (e.g., combo
	-- points hidden when not in cat form, mana hidden when not in moonkin form).
	TRB.Functions.EditMode:RefreshDruidWrapperVisibility(layoutSettings, forest)
end


---Applies textures/colors to existing bar groups (OOP system only).
---This is intentionally separate from layout so moving/resizing doesn't inadvertently reset bar colors.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	self:TouchRenderTransition(0.35)

	-- If render transition is active, force alpha 0 to prevent flicker
	if self:IsRenderTransitionActive() then
		SetBarGroupsAlpha(0)
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
			primaryNode:SetFrameLevel(frameLevels.bar)

			-- Apply casting overlay appearance via named slot (if it exists)
			local castingSlot = primaryNode:GetOverlaySlot("casting")
			if castingSlot then
				local castingTexture = settings.textures.castingBar or settings.textures.resourceBar
				local castingColor = settings.colors.bar.casting and settings.colors.bar.casting.color
				castingSlot.texture = castingTexture
				if castingColor then
					castingSlot.color = castingColor
				end
				-- Resolve spending color for inset overlay
				local spendingColor = castingColor
				local spendingSettings = settings.colors.bar.spending
				if spendingSettings and spendingSettings.color then
					spendingColor = spendingSettings.color
				end
				castingSlot.spendingColor = spendingColor
				castingSlot:RefreshAppearance()
			end
		end
	end

	-- Apply casting overlay appearance on secondary bar nodes (if they exist)
	if barGroups.secondary then
		for i = 1, barGroups.secondary:GetNodeCount() do
			local secondaryNode = barGroups.secondary:GetNode(i)
			if secondaryNode then
				local secCastingSlot = secondaryNode:GetOverlaySlot("casting")
				if secCastingSlot then
					local secCastingTexture = settings.textures.castingBar or settings.textures.resourceBar
					local secCastingColor = settings.colors.bar.casting and settings.colors.bar.casting.color
					secCastingSlot.texture = secCastingTexture
					if secCastingColor then
						secCastingSlot.color = secCastingColor
					end
					secCastingSlot:RefreshAppearance()
				end
			end
		end
	end

	-- DRUID SPECIAL CASE: Non-Feral Druids don't have comboPoints in their settings,
	-- but they DO have a secondary bar group for combo points when in cat form.
	-- Check Feral settings for Druids when the current spec doesn't have comboPoints.
	-- Non-Feral Druids ALWAYS use Feral's combo point settings for appearance.
	local hasComboPointSettings = settings.comboPoints ~= nil
	local feralSettingsForDruid = nil
	if TRB.Data.character.classId == 11 and TRB.Data.character.specId ~= 2 then
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
			-- Non-Feral Druids require Feral's COMPLETE combo point data (dimensions AND colors)
			-- to display the secondary bar. If any piece is missing (e.g. during early initialization
			-- before Feral's FillSpecializationCacheSettings has run), skip combo point appearance.
			if feralSettingsForDruid and feralSettingsForDruid.comboPoints
				and feralSettingsForDruid.colors and feralSettingsForDruid.colors.comboPoints then
				hasComboPointSettings = true
			else
				hasComboPointSettings = false
			end
		else
			-- Form switching disabled for this spec — no combo points
			hasComboPointSettings = false
		end
	end

	if barGroups.secondary and hasComboPointSettings then
		-- DRUID SPECIAL CASE: Non-Feral Druids ALWAYS use Feral's combo point settings.
		local effectiveSettings = settings
		if TRB.Data.character.classId == 11 and TRB.Data.character.specId ~= 2 then
			-- feralSettingsForDruid was already validated to have comboPoints, colors, and
			-- colors.comboPoints in the hasComboPointSettings gate above.
			local feralSettings = feralSettingsForDruid
			if feralSettings and feralSettings.comboPoints
				and feralSettings.colors and feralSettings.colors.comboPoints then
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
				elseif isVengeance then
					-- Stepped min/max: node 1 = (0,1), node 2 = (1,2), ... node 6 = (5,6)
					-- All nodes receive the same raw secret value; StatusBar clamping handles fill
					node:SetMinMax(i - 1, i)
				else
					node:SetMinMax(0, 1)
				end
				node:SetBorderColor(effectiveSettings.colors.comboPoints.border.color)
				node:SetBackgroundColorFromString(effectiveSettings.colors.comboPoints.background.color)
				node:SetColor(effectiveSettings.colors.comboPoints.base.color)
				node:SetFrameLevel(frameLevels.comboPoint)
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
			healthNode:SetFrameLevel(frameLevels.comboPoint)

			-- Apply absorb overlay appearance via named slot (if it exists)
			local absorbSlot = healthNode:GetOverlaySlot("absorb")
			if absorbSlot then
				absorbSlot.texture = settings.textures.absorbBar
				if settings.colors.healthBar.absorb then
					absorbSlot.color = settings.colors.healthBar.absorb.color
				end
				absorbSlot:RefreshAppearance()
			end

			-- Apply incoming heal overlay appearance via named slot (if it exists)
			local incomingHealSlot = healthNode:GetOverlaySlot("incomingHeal")
			if incomingHealSlot then
				incomingHealSlot.texture = settings.textures.incomingHealBar
				if settings.colors.healthBar.incomingHeal then
					incomingHealSlot.color = settings.colors.healthBar.incomingHeal.color
				end
				incomingHealSlot:RefreshAppearance()
			end
		end
	end

	-- Apply custom bar group appearances from the registry (stagger, defensives, mana, etc.)
	self:ApplyCustomBarGroupsAppearance(settings, barGroups)

	-- Note: TriggerResourceBarUpdates is NOT called here because this function may be called
	-- from EventRegistration before talents/spells are set up. The caller is responsible for
	-- triggering updates after all setup is complete.
end

---Updates the absorb shield overlay on the health bar node.
---Lazily creates the overlay, sets min/max/value, applies texture and color, and shows/hides.
---Supports three display modes:
---  "overlay" (default): fills from the left edge of the bar up to the absorb amount.
---  "appended": visually appends the absorb region to the right of the current health fill,
---              using a clip frame so it never extends past the bar's right boundary.
---  "inset": reverse-fill absorb bar RIGHT-anchored to the health fill's RIGHT edge,
---           filling leftward to show absorb "eating into" visible health.
---@param healthNode TRB.Classes.BarNode # The health bar node
---@param snapshotData TRB.Classes.SnapshotData # The current snapshot data
---@param settings table # The spec cache settings (specCacheSettings)
function TRB.Functions.Bar:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, settings)
	if not healthNode then return end

	local absorbSlot = healthNode:GetOrCreateOverlaySlot("absorb")

	local absorbColorEntry = settings.colors.healthBar and settings.colors.healthBar.absorb
	if not absorbColorEntry or not absorbColorEntry.enabled then
		absorbSlot:HideAll()
		return
	end

	local absorbMode = absorbColorEntry.mode or "overlay"
	local healthMax = snapshotData.attributes.healthMax or 1
	local absorbAmount = snapshotData.attributes.absorb or 0
	local hasAbsorb = issecretvalue(absorbAmount) or absorbAmount > 0

	-- Store for RefreshAppearance
	absorbSlot.texture = settings.textures.absorbBar
	if settings.colors.healthBar and settings.colors.healthBar.absorb then
		absorbSlot.color = settings.colors.healthBar.absorb.color
	end

	if absorbMode == "appended" then
		-- Appended mode: absorb bar LEFT anchored to health fill's RIGHT, inside a clip frame
		absorbSlot:HideOverlay()
		absorbSlot:HideInsetOverlay()
		absorbSlot:CreateAppendedOverlay()

		absorbSlot:SetAppendedOverlayMinMax(0, healthMax)
		absorbSlot:SetAppendedOverlayValue(absorbAmount)
		absorbSlot:SetAppendedOverlayTexture(settings.textures.absorbBar)

		if settings.colors.healthBar and settings.colors.healthBar.absorb then
			absorbSlot:SetAppendedOverlayColor(settings.colors.healthBar.absorb.color)
		end

		if hasAbsorb then
			absorbSlot:ShowAppendedOverlay()
		else
			absorbSlot:HideAppendedOverlay()
		end
	elseif absorbMode == "inset" then
		-- Inset mode: reverse-fill absorb bar RIGHT anchored to health fill's RIGHT,
		-- fills leftward to show absorb "eating into" the visible health.
		absorbSlot:HideOverlay()
		absorbSlot:HideAppendedOverlay()
		absorbSlot:CreateInsetOverlay()

		absorbSlot:SetInsetOverlayMinMax(0, healthMax)
		absorbSlot:SetInsetOverlayValue(absorbAmount)
		absorbSlot:SetInsetOverlayTexture(settings.textures.absorbBar)

		if settings.colors.healthBar and settings.colors.healthBar.absorb then
			absorbSlot:SetInsetOverlayColor(settings.colors.healthBar.absorb.color)
		end

		if hasAbsorb then
			absorbSlot:ShowInsetOverlay()
		else
			absorbSlot:HideInsetOverlay()
		end
	else
		-- Overlay mode (default): fills from left edge
		absorbSlot:HideAppendedOverlay()
		absorbSlot:HideInsetOverlay()
		absorbSlot:CreateOverlay()

		absorbSlot:SetOverlayMinMax(0, healthMax)
		absorbSlot:SetOverlayValue(absorbAmount)
		absorbSlot:SetOverlayTexture(settings.textures.absorbBar)

		if settings.colors.healthBar and settings.colors.healthBar.absorb then
			absorbSlot:SetOverlayColor(settings.colors.healthBar.absorb.color)
		end

		if hasAbsorb then
			absorbSlot:ShowOverlay()
		else
			absorbSlot:HideOverlay()
		end
	end
end

---Updates the incoming heal overlay on the health bar node.
---Lazily creates the overlay, sets min/max/value, applies texture and color, and shows/hides.
---Supports three display modes:
---  "overlay" (default): fills from the left edge of the bar up to the incoming heal amount.
---  "appended": visually appends the incoming heal region to the right of the current health fill,
---              using a clip frame so it never extends past the bar's right boundary.
---  "inset": reverse-fill incoming heal bar RIGHT-anchored to the health fill's RIGHT edge,
---           filling leftward to show incoming heals "eating into" visible health.
---@param healthNode TRB.Classes.BarNode # The health bar node
---@param snapshotData TRB.Classes.SnapshotData # The current snapshot data
---@param settings table # The spec cache settings (specCacheSettings)
function TRB.Functions.Bar:UpdateHealthBarIncomingHealOverlay(healthNode, snapshotData, settings)
	if not healthNode then return end

	local incomingHealSlot = healthNode:GetOrCreateOverlaySlot("incomingHeal")

	local incomingHealColorEntry = settings.colors.healthBar and settings.colors.healthBar.incomingHeal
	if not incomingHealColorEntry or not incomingHealColorEntry.enabled then
		incomingHealSlot:HideAll()
		return
	end

	local incomingHealMode = incomingHealColorEntry.mode or "overlay"
	local healthMax = snapshotData.attributes.healthMax or 1
	local incomingHealAmount = snapshotData.attributes.incomingHeal or 0
	local hasIncomingHeal = issecretvalue(incomingHealAmount) or incomingHealAmount > 0

	-- Store for RefreshAppearance
	incomingHealSlot.texture = settings.textures.incomingHealBar
	if settings.colors.healthBar and settings.colors.healthBar.incomingHeal then
		incomingHealSlot.color = settings.colors.healthBar.incomingHeal.color
	end

	if incomingHealMode == "appended" then
		-- Appended mode: incoming heal bar LEFT anchored to health fill's RIGHT, inside a clip frame
		incomingHealSlot:HideOverlay()
		incomingHealSlot:HideInsetOverlay()
		incomingHealSlot:CreateAppendedOverlay()

		incomingHealSlot:SetAppendedOverlayMinMax(0, healthMax)
		incomingHealSlot:SetAppendedOverlayValue(incomingHealAmount)
		incomingHealSlot:SetAppendedOverlayTexture(settings.textures.incomingHealBar)

		if settings.colors.healthBar and settings.colors.healthBar.incomingHeal then
			incomingHealSlot:SetAppendedOverlayColor(settings.colors.healthBar.incomingHeal.color)
		end

		if hasIncomingHeal then
			incomingHealSlot:ShowAppendedOverlay()
		else
			incomingHealSlot:HideAppendedOverlay()
		end
	elseif incomingHealMode == "inset" then
		-- Inset mode: reverse-fill incoming heal bar RIGHT anchored to health fill's RIGHT,
		-- fills leftward to show incoming heals "eating into" the visible health.
		incomingHealSlot:HideOverlay()
		incomingHealSlot:HideAppendedOverlay()
		incomingHealSlot:CreateInsetOverlay()

		incomingHealSlot:SetInsetOverlayMinMax(0, healthMax)
		incomingHealSlot:SetInsetOverlayValue(incomingHealAmount)
		incomingHealSlot:SetInsetOverlayTexture(settings.textures.incomingHealBar)

		if settings.colors.healthBar and settings.colors.healthBar.incomingHeal then
			incomingHealSlot:SetInsetOverlayColor(settings.colors.healthBar.incomingHeal.color)
		end

		if hasIncomingHeal then
			incomingHealSlot:ShowInsetOverlay()
		else
			incomingHealSlot:HideInsetOverlay()
		end
	else
		-- Overlay mode (default): fills from left edge
		incomingHealSlot:HideAppendedOverlay()
		incomingHealSlot:HideInsetOverlay()
		incomingHealSlot:CreateOverlay()

		incomingHealSlot:SetOverlayMinMax(0, healthMax)
		incomingHealSlot:SetOverlayValue(incomingHealAmount)
		incomingHealSlot:SetOverlayTexture(settings.textures.incomingHealBar)

		if settings.colors.healthBar and settings.colors.healthBar.incomingHeal then
			incomingHealSlot:SetOverlayColor(settings.colors.healthBar.incomingHeal.color)
		end

		if hasIncomingHeal then
			incomingHealSlot:ShowOverlay()
		else
			incomingHealSlot:HideOverlay()
		end
	end
end

---Updates all health bar overlays (absorb shield, incoming heals).
---Wrapper that calls each individual overlay update function.
---@param healthNode TRB.Classes.BarNode # The health bar node
---@param snapshotData TRB.Classes.SnapshotData # The current snapshot data
---@param settings table # The spec cache settings (specCacheSettings)
function TRB.Functions.Bar:UpdateHealthBarOverlays(healthNode, snapshotData, settings)
	self:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, settings)
	self:UpdateHealthBarIncomingHealOverlay(healthNode, snapshotData, settings)
end

---Updates the casting resource overlay on the primary resource bar node.
---Lazily creates the overlay, sets min/max/value, applies texture and color, and shows/hides.
---When castingAmount > 0, uses an appended overlay (resource gain, extends rightward).
---When castingAmount < 0, uses an inset overlay (resource spend, fills leftward).
---If the spec defines a separate spending color (colors.bar.spending) and it is enabled,
---the inset overlay uses that color instead of the casting color.
---@param node TRB.Classes.BarNode # The bar node to apply the overlay on
---@param snapshotData TRB.Classes.SnapshotData # The current snapshot data
---@param settings table # The spec cache settings (specCacheSettings)
---@param castingAmountOverride number|nil # Optional: explicit casting amount (pre-factored). When nil, reads snapshotData.casting.resourceFinal * resourceFactor.
---@param maxResourceOverride number|nil # Optional: explicit max resource. When nil, reads TRB.Data.character.maxResource.
function TRB.Functions.Bar:UpdateCastingResourceOverlay(node, snapshotData, settings, castingAmountOverride, maxResourceOverride)
	if not node then return end

	local castingSlot = node:GetOrCreateOverlaySlot("casting")

	local castingSettings = settings.colors and settings.colors.bar and settings.colors.bar.casting
	if not castingSettings or not castingSettings.enabled then
		-- Zero out any existing overlays but don't create them
		castingSlot:SetAppendedOverlayValue(0)
		castingSlot:SetInsetOverlayValue(0)
		return
	end

	local castingAmount
	if castingAmountOverride ~= nil then
		castingAmount = castingAmountOverride
	else
		local resourceFactor = TRB.Data.resourceFactor or 1
		castingAmount = (snapshotData.casting.resourceFinal or 0) * resourceFactor
	end

	if castingAmount == 0 then
		castingSlot:SetAppendedOverlayValue(0)
		castingSlot:SetInsetOverlayValue(0)
		return
	end

	local maxResource
	if maxResourceOverride ~= nil then
		maxResource = maxResourceOverride
	else
		maxResource = TRB.Data.character.maxResource or 0
	end

	if maxResource <= 0 then
		castingSlot:SetAppendedOverlayValue(0)
		castingSlot:SetInsetOverlayValue(0)
		return
	end

	local castingTexture = settings.textures.castingBar or settings.textures.resourceBar
	local castingColor = castingSettings.color or "FFFFFFFF"

	-- Resolve spending color: use spending if explicitly defined + enabled, otherwise fall back to casting
	local spendingColor = castingColor
	local spendingSettings = settings.colors and settings.colors.bar and settings.colors.bar.spending
	if spendingSettings and spendingSettings.enabled and spendingSettings.color then
		spendingColor = spendingSettings.color
	end

	-- Store for RefreshAppearance
	castingSlot.texture = castingTexture
	castingSlot.color = castingColor
	castingSlot.spendingColor = spendingColor

	if castingAmount > 0 then
		-- Resource gain: appended overlay extends rightward from current fill
		castingSlot:SetInsetOverlayValue(0)
		if not castingSlot.appendedClipFrame then
			castingSlot:CreateAppendedOverlay()
			-- Overlay is off-screen for one frame; skip rendering until reanchored
			return
		end
		if not castingSlot.appendedOverlayReady then
			return
		end
		castingSlot:SetAppendedOverlayMinMax(0, maxResource)
		castingSlot:SetAppendedOverlayTexture(castingTexture)
		castingSlot:SetAppendedOverlayColor(castingColor)
		castingSlot:SetAppendedOverlayValue(castingAmount)
	else
		-- Resource spend: inset overlay fills leftward from current fill
		castingSlot:SetAppendedOverlayValue(0)
		if not castingSlot.insetClipFrame then
			castingSlot:CreateInsetOverlay()
			-- Overlay is off-screen for one frame; skip rendering until reanchored
			return
		end
		if not castingSlot.insetOverlayReady then
			return
		end
		castingSlot:SetInsetOverlayMinMax(0, maxResource)
		castingSlot:SetInsetOverlayTexture(castingTexture)
		castingSlot:SetInsetOverlayColor(spendingColor)
		castingSlot:SetInsetOverlayValue(math.abs(castingAmount))
	end
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

---Returns the effective width and CDM-forced fullWidth state for a bar group.
---Checks per-root effective widths first (which include CDM width matching when the bar
---is a forest root), then falls back to the primary bar's effective width.
---@param barGroups table? # TRB.Frames.barGroups
---@param settings table # Spec settings containing bar.width as fallback
---@param barKey string # The bar key to resolve width for (e.g., "secondary")
---@return number effectiveWidth # The resolved width
---@return boolean cdmForced # Whether CDM width matching is active (caller should force fullWidth)
function TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, settings, barKey)
	local effectiveWidth = (barGroups and barGroups.effectiveWidth) or settings.bar.width
	local cdmForced = false

	-- Check for per-root effective width (handles CDM matching when the bar is its own root)
	if barGroups and barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths[barKey] then
		effectiveWidth = barGroups.rootEffectiveWidths[barKey]
		-- Check if CDM width matching is active for this root
		if TRB.Functions.EditMode and TRB.Functions.EditMode.IsWidthMatchingEnabled then
			cdmForced = TRB.Functions.EditMode:IsWidthMatchingEnabled(nil, barKey)
		end
	end

	return effectiveWidth, cdmForced
end

---Resolves the actual width for a bar, following the matchWidth chain if necessary.
---This handles bars that match their anchor's width, which may itself match another bar's width.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barKey string # "primary", "secondary", "health", "screen", or a BarTypeRegistry key
---@param visited table? # Internal: tracks visited bars to detect cycles
---@return number # The resolved width for this bar
function TRB.Functions.Bar:ResolveBarWidth(settings, barKey, visited)
	visited = visited or {}
	if visited[barKey] then
		-- Cycle detected, fall back to primary bar width
		return settings.bar.width
	end
	visited[barKey] = true

	local barGroups = TRB.Frames.barGroups

	if barKey == "primary" then
		-- Primary bar uses effectiveWidth (accounts for CDM width matching)
		return (barGroups and barGroups.effectiveWidth) or settings.bar.width
	elseif barKey == "screen" then
		-- Screen-anchored bars don't have a reference width to match
		return settings.bar.width
	end

	-- Check if this barKey has a per-root effective width override (e.g., CDM matching on a non-primary root)
	if barGroups and barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths[barKey] then
		-- This bar IS a root with its own effective width; check if it's a screen-rooted root
		local anchor = self:GetBarAnchor(settings, barKey)
		if not anchor or not anchor.barKey or anchor.barKey == "screen" then
			return barGroups.rootEffectiveWidths[barKey]
		end
	end

	local barSettings = self:GetBarSettings(settings, barKey)
	if not barSettings then
		return settings.bar.width
	end

	local anchor = self:GetBarAnchor(settings, barKey)
	if anchor and anchor.matchWidth and anchor.barKey ~= "screen" then
		-- This bar matches its anchor's width, recursively resolve
		return self:ResolveBarWidth(settings, anchor.barKey, visited)
	end

	return barSettings.width or settings.bar.width
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
	-- A secondary bar with 0 resource nodes is never visible (e.g., all Holy Word enables unchecked)
	if barKey == "secondary" and (TRB.Data.character.maxResource2 or 0) == 0 then
		return false
	end
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

---Enumerates all bar keys that a settings table defines, independent of live barGroups.
---This is used by the Options UI to determine valid anchor targets for a specific spec's
---configuration, even when a different spec is currently active (e.g., Druid forms).
---@param settings table # The spec's settings table (e.g., TRB.Data.settings.druid.feral)
---@return string[] # List of bar keys this settings table defines
function TRB.Functions.Bar:GetAllBarKeysFromSettings(settings)
	local keys = {}
	if settings.bar then table.insert(keys, "primary") end
	if settings.comboPoints then
		table.insert(keys, "secondary")
	elseif settings.displayBar and settings.displayBar.enableFormSwitching ~= nil then
		-- Druid: non-Feral specs don't have comboPoints in their settings (they inherit
		-- Feral's at runtime), but "secondary" must still be available as an anchor target
		-- so users can anchor other bars to combo points.
		table.insert(keys, "secondary")
	end
	if settings.healthBar then table.insert(keys, "health") end

	-- Custom bars from BarTypeRegistry that have settings
	if settings.bars then
		local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
		if registry then
			local allBarTypes = registry:GetAll()
			for barKey, _ in pairs(allBarTypes) do
				if settings.bars[barKey] then
					table.insert(keys, barKey)
				end
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

---Validates that an anchor configuration does not create a cycle.
---The tree is a forest: bars with barKey="screen" are roots (anchored to UIParent).
---A valid tree means every bar can reach either "screen" or "primary" by
---following parent links without revisiting a node.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>?
---@param testBarKey string? # If provided, validates with this bar's anchor changed
---@param testAnchorBarKey string? # If provided, the new anchor target for testBarKey
---@param barKeys string[]? # If provided, use these bar keys instead of deriving from barGroups
---@return boolean # true if valid (no cycles)
---@return string? # Error message if invalid
function TRB.Functions.Bar:ValidateAnchorTree(settings, barGroups, testBarKey, testAnchorBarKey, barKeys)
	local allKeys = barKeys or self:GetAllBarKeys(barGroups)

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
---@param barGroups table<string, TRB.Classes.BarGroup>?
---@param barKeys string[]? # If provided, use these bar keys instead of deriving from barGroups
---@return string[] # List of valid anchor target bar keys (includes "screen")
function TRB.Functions.Bar:GetAvailableAnchorTargets(thisBarKey, settings, barGroups, barKeys)
	local valid = { "screen" }
	local allKeys = barKeys or self:GetAllBarKeys(barGroups)
	for _, candidate in ipairs(allKeys) do
		if candidate ~= thisBarKey then
			local ok = self:ValidateAnchorTree(settings, barGroups, thisBarKey, candidate, allKeys)
			if ok then
				table.insert(valid, candidate)
			end
		end
	end
	return valid
end

---@deprecated Use BuildAnchorForest() instead. Retained as fallback for CalculateWrapperLayout edge cases.
---Builds the anchor tree from settings, returning the root node of the "primary" bar's tree.
---The tree is a forest: bars with barKey="screen" are independent roots.
---This function finds the root that contains "primary" and builds only that sub-tree.
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
		if not isRoot and anchor then
			parentOf[barKey] = anchor.barKey
		end
	end

	-- Find the root of the "primary" bar's tree by walking up the parent chain
	local rootKey = "primary"
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

---Builds all anchor trees (the anchor forest).
---Each screen-rooted bar is a root of its own tree. Returns a map from rootBarKey -> rootNode.
---Orphaned bars (anchor target not present in barGroups) become new roots.
---Hidden bars are optionally collapsed: their children re-parent to the hidden bar's parent.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
---@param collapseHidden boolean? # If true, skip hidden bars and re-parent their children
---@param includeHidden boolean? # If true, include bars with visibility="never" in the tree
---@return table<string, TRB.Classes.Settings.AnchorTreeNode> # Map of rootBarKey -> rootNode
function TRB.Functions.Bar:BuildAnchorForest(settings, barGroups, collapseHidden, includeHidden)
	if not settings or not barGroups then
		return {}
	end

	local allKeys = self:GetAllBarKeys(barGroups)

	-- Build all nodes; bars with barKey="screen" or no anchor are roots
	---@type table<string, TRB.Classes.Settings.AnchorTreeNode>
	local nodes = {}
	---@type table<string, string> # child -> parent adjacency
	local parentOf = {}
	for _, barKey in ipairs(allKeys) do
		local barSettings = self:GetBarSettings(settings, barKey)
		local barGroup = barGroups[barKey]
		local anchor = self:GetBarAnchor(settings, barKey)
		local isRoot = (not anchor) or (not anchor.barKey) or (anchor.barKey == "screen")

		-- Orphan check: if the anchor target doesn't exist in barGroups, treat as root
		if not isRoot and anchor and not barGroups[anchor.barKey] then
			isRoot = true
		end

		nodes[barKey] = {
			barKey = barKey,
			anchor = isRoot and nil or anchor,
			children = {},
			barGroup = barGroup,
			barSettings = barSettings,
			width = barSettings and barSettings.width or 0,
			height = barSettings and barSettings.height or 0,
		}
		if not isRoot and anchor then
			parentOf[barKey] = anchor.barKey
		end
	end

	-- Identify roots: nodes that have no parent entry
	local roots = {}
	for _, barKey in ipairs(allKeys) do
		if not parentOf[barKey] then
			roots[barKey] = nodes[barKey]
		end
	end

	-- Assign each non-root bar to its root's tree by walking up the parent chain
	-- Build parent-child relationships
	for _, barKey in ipairs(allKeys) do
		if parentOf[barKey] then
			local parentKey = parentOf[barKey]

			if collapseHidden then
				-- Walk up the parent chain to find the first visible parent
				local effectiveParentKey = parentKey
				local visited = {}
				while effectiveParentKey and not roots[effectiveParentKey] and
					  not self:IsBarVisible(settings, effectiveParentKey, includeHidden) do
					if visited[effectiveParentKey] then break end
					visited[effectiveParentKey] = true
					effectiveParentKey = parentOf[effectiveParentKey] or effectiveParentKey
				end
				parentKey = effectiveParentKey
			end

			-- Only add visible bars (or all bars if includeHidden)
			if self:IsBarVisible(settings, barKey, includeHidden) then
				if nodes[parentKey] then
					table.insert(nodes[parentKey].children, nodes[barKey])
				end
			end
		end
	end

	return roots
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
---@field public cdmWidthMatched boolean? # If true, CDM width matching is active and multi-node bars should force fullWidth

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
	-- Use GetAnchorFrame() which returns the border frame for single-node bars
	-- and the container frame for multi-node bars, giving us the full visual extent.
	local anchorContainer
	local isScreenRoot = false
	if anchor.barKey == "screen" then
		-- Screen-anchored bar: check if it's a tree root with a wrapper frame.
		-- ApplyBarGroupsLayout parents root bar containers to their wrapper frame.
		-- If the container has been parented to a wrapper, position relative to the wrapper,
		-- NOT UIParent. The wrapper handles CDM/EditMode positioning.
		local currentParent = targetGroup.containerFrame:GetParent()
		if currentParent and currentParent ~= UIParent and currentParent.trbRootBarKey then
			-- Container is parented to a TRB wrapper frame — position inside it
			anchorContainer = currentParent
			isScreenRoot = true
		else
			anchorContainer = UIParent
		end
	elseif anchorGroup and anchorGroup.GetAnchorFrame then
		-- Bar anchor: position relative to anchorGroup's visual extent (border)
		anchorContainer = anchorGroup:GetAnchorFrame()
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
		-- Match width: resolve the anchor bar's width, following matchWidth chains if necessary.
		-- This correctly handles anchoring to bars other than primary (e.g., health bar).
		groupWidth = self:ResolveBarWidth(settings, anchor.barKey)
		-- Force horizontal center alignment by stripping LEFT/RIGHT from anchor points
		-- but preserve the user's chosen vertical relationship (TOP/BOTTOM/CENTER).
		anchorPoint = string.gsub(anchorPoint, "LEFT", "")
		anchorPoint = string.gsub(anchorPoint, "RIGHT", "")
		attachPoint = string.gsub(attachPoint, "LEFT", "")
		attachPoint = string.gsub(attachPoint, "RIGHT", "")
		if anchorPoint == "" then anchorPoint = "CENTER" end
		if attachPoint == "" then attachPoint = "CENTER" end
		xPos = 0
	elseif anchor.barKey == "screen" and config.rootEffectiveWidth then
		-- Screen-anchored root bar: use the root's effective width (accounts for CDM width matching)
		groupWidth = config.rootEffectiveWidth
	end

	-- CDM width matching override: when Edit Mode has CDM width matching active for this
	-- bar's root, the CDM width should take precedence over the resolved groupWidth.
	-- This handles the case where the bar's own anchor is "primary" with matchWidth=true
	-- (resolved above to primary's width), but Edit Mode has positioned the wrapper at CDM
	-- with a wider CDM width.
	if config.cdmWidthMatched and config.rootEffectiveWidth then
		groupWidth = config.rootEffectiveWidth
	end

	-- Height matching override: when Edit Mode has anchor frame height matching active,
	-- use the anchor frame's height instead of settings height.
	if config.cdmHeightMatched and config.rootEffectiveHeight then
		groupHeight = config.rootEffectiveHeight
	end

	-- Position the target container using the new anchor system
	targetGroup.containerFrame:ClearAllPoints()
	if isScreenRoot then
		-- Screen-anchored tree root: position relative to wrapper frame.
		-- The wrapper handles CDM/EditMode positioning; the container just sits at its top.
		targetGroup.containerFrame:SetPoint("TOP", anchorContainer, "TOP", 0, 0)
	else
		targetGroup.containerFrame:SetPoint(attachPoint, anchorContainer, anchorPoint, xPos, yPos)
	end
	targetGroup.containerFrame:SetFrameLevel(frameLevels.comboPoint)

	-- Apply layout or size directly based on config
	if config.useApplyLayout then
		-- Multi-node layout (combo points, runes, etc.)
		-- Use groupWidth for totalWidth: it has been resolved for matchWidth (parent's width),
		-- screen-anchored root (rootEffectiveWidth/CDM), or per-node width (non-match case).

		-- When CDM width matching is active for a multi-node root, force fullWidth
		-- so ApplyLayout stretches nodes to fill the CDM width.
		-- This is needed because anchor.matchWidth (which normally sets fullWidth via
		-- SetLayout) doesn't account for CDM matching — they're separate mechanisms.
		if config.cdmWidthMatched then
			targetGroup.fullWidth = true
		end

		targetGroup:ApplyLayout(
			groupWidth,
			groupSettings.width,
			groupSettings.height,
			groupSettings.border
		)

		-- Set min/max for multi-node discrete bars (e.g., utility charge bars).
		-- ApplyLayout does not set min/max, and StatusBar frames default to (0,0),
		-- which causes all SetValue() calls to scale to 0 (empty).
		if config.minMaxMode == "discrete" then
			for i = 1, nodes do
				local multiNode = targetGroup:GetNode(i)
				if multiNode then
					multiNode:SetMinMax(0, 1)
				end
			end
		end
	else
		-- Single-node direct sizing (health bar, etc.)
		targetGroup.containerFrame:SetWidth(groupWidth)
		targetGroup.containerFrame:SetHeight(groupHeight)

		local singleNode = targetGroup:GetNode(1)
		if singleNode then
			singleNode:SetDimensions(groupWidth, groupHeight, groupBorder)
			singleNode:SetFrameLevel(frameLevels.comboPoint)

			-- Position node within container
			local nodeFrame = singleNode:GetFrame()
			if nodeFrame then
				nodeFrame:ClearAllPoints()
				nodeFrame:SetAllPoints(targetGroup.containerFrame)
			end

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

					node:SetFrameLevel(frameLevels.comboPoint)

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

		-- If render transition is active, keep it hidden (alpha 0) despite the Show() call
		if self:IsRenderTransitionActive() then
			SetBarGroupsAlpha(0)
		end
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
	local barGroups = TRB.Frames.barGroups
	local widthMatched = TRB.Functions.EditMode:IsWidthMatchingEnabled(nil, "secondary")

	-- Determine the effective root width for secondary.
	-- Priority: rootEffectiveWidths (if secondary is a forest root) > anchor frame width > nil
	local rootEffWidth = barGroups and barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths["secondary"]
	if not rootEffWidth and widthMatched then
		-- Secondary is a child of primary in the forest, but Edit Mode has width
		-- matching enabled for it. Get the anchor frame width directly.
		local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey(nil, "secondary")
		local customFrameName = TRB.Functions.EditMode:GetCustomFrameName(nil, "secondary")
		rootEffWidth = TRB.Functions.EditMode:GetAnchorFrameWidth(anchorFrameKey, customFrameName)
	end

	---@type TRB.Classes.AnchoredBarGroupConfig
	local config = {
		settingsKey = "comboPoints",
		colorsKey = "comboPoints",
		nodeCount = nil, -- Dynamic based on maxResource2
		useApplyLayout = true,
		defaultAnchorAbove = true,
		rootEffectiveWidth = rootEffWidth,
		cdmWidthMatched = widthMatched,
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
			
			-- Determine if anchor frame width/height matching is active for this custom bar
			local widthMatched = TRB.Functions.EditMode:IsWidthMatchingEnabled(nil, key)
			local heightMatched = TRB.Functions.EditMode:IsHeightMatchingEnabled(nil, key)
			local rootEffWidth = barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths[key]
			local rootEffHeight = barGroups.rootEffectiveHeights and barGroups.rootEffectiveHeights[key]
			if not rootEffWidth and widthMatched then
				-- Bar is not a forest root but has width matching; get anchor frame width directly
				local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey(nil, key)
				local customFrameName = TRB.Functions.EditMode:GetCustomFrameName(nil, key)
				rootEffWidth = TRB.Functions.EditMode:GetAnchorFrameWidth(anchorFrameKey, customFrameName)
			end
			if not rootEffHeight and heightMatched then
				local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey(nil, key)
				local customFrameName = TRB.Functions.EditMode:GetCustomFrameName(nil, key)
				rootEffHeight = TRB.Functions.EditMode:GetAnchorFrameHeight(anchorFrameKey, customFrameName)
			end

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
				minMaxMode = barTypeDef.minMaxMode or "custom",
				rootEffectiveWidth = rootEffWidth,
				rootEffectiveHeight = rootEffHeight,
				cdmWidthMatched = widthMatched,
				cdmHeightMatched = heightMatched,
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
					
					node:SetFrameLevel(frameLevels.comboPoint)
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

---Sets a BarNode's value using a DurationObject for secret-safe animation.
---Uses StatusBar:SetTimerDuration() to let WoW natively animate the bar progress.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param node TRB.Classes.BarNode
---@param durationObject any # A DurationObject from C_Spell.GetSpellChargeDuration() or similar
function TRB.Functions.Bar:SetBarNodeTimerDuration(settings, key, node, durationObject)
	if settings == nil or settings.bar == nil or node == nil or durationObject == nil then
		return
	end

	-- Invalidate the value cache for this key so future SetBarNodeValue calls don't skip
	TRB.Data.cache.values.bar[key] = TRB.Data.cache.values.bar[key] or {}
	TRB.Data.cache.values.bar[key].value = nil
	TRB.Data.cache.values.bar[key].maxResource = nil

	node:SetTimerDuration(durationObject, Enum.StatusBarInterpolation.Immediate, Enum.StatusBarTimerDirection.ElapsedTime)
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

