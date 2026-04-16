---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local L = TRB.Localization

TRB.Functions = TRB.Functions or {}
TRB.Functions.EditMode = {}

-- Local reference to LibEditMode
local LibEditMode = nil

-- Track the currently registered container frames to prevent duplicate registrations
-- Map of rootBarKey -> wrapperFrame
local registeredFrames = {}

-- Legacy compat: single registered frame reference (points to primary root wrapper)
local registeredFrame = nil

-- Edit Mode wrapper frames - one per anchor tree root
-- Map of rootBarKey -> Frame
local editModeWrapperFrames = {}

-- Legacy compat: single wrapper frame reference (points to primary root wrapper)
local editModeWrapperFrame = nil

-- Track if Initialize has been called
local isInitialized = false

-- Guard to prevent re-entrancy when temporarily showing CDM to get dimensions
local isTemporarilyShowingCDM = false

-- Guard to prevent re-entrancy in ReapplyAnchorFrameLayout
local isReapplyingAnchorLayout = false

-- Map of frameKey -> WoW global frame name for anchor targets
local FRAME_KEY_TO_GLOBAL = {
	["cdm-essential"] = "EssentialCooldownViewer",
	["cdm-buffs"] = "BuffIconCooldownViewer",
	["cdm-utility"] = "UtilityCooldownViewer",
	["cdm-bars"] = "BuffBarCooldownViewer",
}

-- Track which frames have already been hooked (keyed by frame reference) to avoid double-hooking
local hookedFrames = {}

-- Track last known dimensions per hooked frame for change detection
local lastKnownDimensions = {}

---Walks the anchor chain from a bar key up to its tree root.
---Returns the root bar key. Used by the Druid per-tree guard in CalculateWrapperLayout.
---@param barKey string # The bar key to find the root for
---@param settings table # Spec settings table for anchor lookup
---@param barGroups table # Current bar groups
---@return string # The root bar key of the tree containing barKey
local function findBarKeyRoot(barKey, settings, barGroups)
	local current = barKey
	local visited = {}
	while current do
		if visited[current] then return current end
		visited[current] = true
		local anchor = TRB.Functions.Bar:GetBarAnchor(settings, current)
		if not anchor or not anchor.barKey or anchor.barKey == "screen" then
			return current -- this bar is a root
		end
		if not barGroups[anchor.barKey] then
			return current -- orphan (anchor target doesn't exist)
		end
		current = anchor.barKey
	end
	return barKey
end

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

	-- Try to hook all known anchor frame targets for resize and show events
	-- This may fail if frames don't exist yet; we'll retry in RegisterTreeRoot
	for frameKey, _ in pairs(FRAME_KEY_TO_GLOBAL) do
		self:HookAnchorFrame(frameKey)
	end
end

---Clears all registered frame references
---Call this when bar groups are destroyed to ensure re-registration on next bar creation
function TRB.Functions.EditMode:ClearRegisteredFrame()
	-- Hide any selection frames that might be visible
	-- This prevents the Edit Mode overlay from showing after spec changes
	for rootBarKey, wrapperFrame in pairs(editModeWrapperFrames) do
		if wrapperFrame and LibEditMode and LibEditMode.frameSelections then
			local selection = LibEditMode.frameSelections[wrapperFrame]
			if selection and not LibEditMode:IsInEditMode() then
				selection:Hide()
			end
		end
	end
	
	-- Clear tracking but keep the wrapper frames registered with LibEditMode
	-- The wrapper frames persist and will be reused
	registeredFrames = {}
	registeredFrame = nil
end

---Gets or creates the Edit Mode wrapper frame for a specific tree root.
---Each tree root gets its own wrapper. When LibEditMode drags a wrapper, all bars in that tree move with it.
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return Frame
function TRB.Functions.EditMode:GetOrCreateWrapperFrame(rootBarKey)
	rootBarKey = rootBarKey or "primary"

	if editModeWrapperFrames[rootBarKey] then
		return editModeWrapperFrames[rootBarKey]
	end

	-- Create a wrapper frame parented to UIParent
	local frameName = "TRB_EditModeWrapper_" .. rootBarKey
	local wrapperFrame = CreateFrame("Frame", frameName, UIParent)
	wrapperFrame:SetFrameStrata("BACKGROUND")
	wrapperFrame:SetFrameLevel(1)
	-- Start with a default size - will be updated to encompass all bars in this tree
	wrapperFrame:SetSize(100, 100)
	wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -200)

	-- Tag the frame with its root bar key so callbacks can identify it
	wrapperFrame.trbRootBarKey = rootBarKey

	editModeWrapperFrames[rootBarKey] = wrapperFrame

	-- Maintain legacy compat: editModeWrapperFrame always points to primary root
	if rootBarKey == "primary" then
		editModeWrapperFrame = wrapperFrame
	end

	return wrapperFrame
end

---Gets the wrapper frame for a specific tree root (nil if not yet created)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return Frame?
function TRB.Functions.EditMode:GetWrapperFrame(rootBarKey)
	rootBarKey = rootBarKey or "primary"
	return editModeWrapperFrames[rootBarKey]
end

---Gets all wrapper frames currently created
---@return table<string, Frame> # Map of rootBarKey -> wrapperFrame
function TRB.Functions.EditMode:GetAllWrapperFrames()
	return editModeWrapperFrames
end

---Updates a specific wrapper frame's size to encompass all bars in its tree
---and positions the root bar within it.
---The wrapper position is controlled by LibEditMode or CDM anchoring.
---@param settings table? # Settings table for dimension calculations
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:UpdateWrapperSize(settings, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	local wrapperFrame = editModeWrapperFrames[rootBarKey]
	if not wrapperFrame then
		return
	end

	local barGroups = TRB.Frames.barGroups
	if not barGroups then
		return
	end

	-- Check if Edit Mode layout is enabled for this layout
	local editModeLayoutEnabled = self:IsLayoutEnabled(nil, rootBarKey)

	-- When Edit Mode layout is disabled, the wrapper should match the root bar exactly.
	if not editModeLayoutEnabled then
		-- Legacy mode: wrapper matches root bar dimensions, root bar fills wrapper
		local rootGroup = barGroups[rootBarKey]
		local rootBarSettings = settings and TRB.Functions.Bar:GetBarSettings(settings, rootBarKey)
		local effectiveWidth
		if barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths[rootBarKey] then
			effectiveWidth = barGroups.rootEffectiveWidths[rootBarKey]
		elseif rootBarKey == "primary" and barGroups.effectiveWidth and type(barGroups.effectiveWidth) == "number" then
			effectiveWidth = barGroups.effectiveWidth
		else
			local rootBarSettings = settings and TRB.Functions.Bar:GetBarSettings(settings, rootBarKey)
			effectiveWidth = (rootBarSettings and rootBarSettings.width) or (settings and settings.bar and settings.bar.width) or 100
		end
		local rootHeight = (rootBarSettings and rootBarSettings.height) or (rootBarKey == "primary" and settings and settings.bar and settings.bar.height) or 100
		-- Use effective height if available (accounts for anchor frame height matching)
		if barGroups.rootEffectiveHeights and barGroups.rootEffectiveHeights[rootBarKey] then
			rootHeight = barGroups.rootEffectiveHeights[rootBarKey]
		end
		wrapperFrame:SetSize(effectiveWidth, rootHeight)

		-- Root bar centered within the wrapper (legacy behavior)
		if rootGroup then
			rootGroup.containerFrame:ClearAllPoints()
			rootGroup.containerFrame:SetPoint("CENTER", wrapperFrame, "CENTER", 0, 0)
		end
		return
	end

	-- Edit Mode layout is enabled - encompass all bars for proper selection box

	-- In Edit Mode, include all bars (even hidden ones)
	local includeHidden = self:IsInEditMode()

	-- Calculate wrapper layout from settings for this specific tree root
	local totalWidth, totalHeight, extendAbove, extendBelow, baseOffsetX = self:CalculateWrapperLayout(settings, includeHidden, rootBarKey)

	-- Size the wrapper to encompass all bars in this tree
	if totalWidth > 0 and totalHeight > 0 then
		wrapperFrame:SetSize(totalWidth, totalHeight)
	end

	-- Reposition the root bar within the wrapper to account for bars above/beside it.
	local rootGroup = barGroups[rootBarKey]
	if rootGroup and settings then
		-- In the consolidated single-frame system, all bars (including primary) use outer
		-- dimensions. No border offset is needed — the group container matches the node's
		-- full visual extent.
		rootGroup.containerFrame:ClearAllPoints()
		rootGroup.containerFrame:SetPoint("TOP", wrapperFrame, "TOP", baseOffsetX or 0, -extendAbove)
	end
end

---Updates ALL wrapper frames' sizes
---@param settings table? # Settings table for dimension calculations
function TRB.Functions.EditMode:UpdateAllWrapperSizes(settings)
	for rootBarKey, _ in pairs(editModeWrapperFrames) do
		self:UpdateWrapperSize(settings, rootBarKey)
	end
end

---Hides or shows wrapper frames for Druid form-dependent bars.
---When the Druid changes form, bars like combo points (secondary) and mana may become
---invisible. If such a bar is the root of its own tree (screen-anchored), the wrapper
---should be hidden so it doesn't linger as an empty container or capture mouse events.
---@param settings table? # Spec settings table
---@param forest table<string, table>? # Pre-built anchor forest (avoids rebuilding)
function TRB.Functions.EditMode:RefreshDruidWrapperVisibility(settings, forest)
	if TRB.Data.character.classId ~= 11 then
		return
	end

	-- Don't hide wrappers during Edit Mode — all bars should remain visible
	if self:IsInEditMode() then
		return
	end

	local barGroups = TRB.Frames.barGroups
	if not barGroups then
		return
	end

	local currentForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
	local specId = TRB.Data.character.specId

	-- Determine displaySpecId (mirrors GetFormSpecForSettings in Druid.lua)
	local enableFormSwitching = true
	if settings and settings.displayBar and settings.displayBar.enableFormSwitching == false then
		enableFormSwitching = false
	end
	local displaySpecId = specId
	if enableFormSwitching then
		if currentForm == "cat" then displaySpecId = 2
		elseif currentForm == "bear" then displaySpecId = 3
		elseif currentForm == "moonkin" then
			displaySpecId = (specId == 1) and 1 or 4
		else displaySpecId = 4 end
	end

	-- Secondary (Combo Points): In cat form (displaySpecId == 2), CPs are the native resource
	-- and always show. In non-cat forms, the showComboPoints checkbox controls visibility
	-- (defaults ON for Feral, OFF for non-Feral).
	local shouldShowSecondary
	local secondaryVis = settings and settings.displayBar and settings.displayBar.secondary
	local secondaryNotNever = not secondaryVis or not secondaryVis.neverShow
	if displaySpecId == 2 then
		-- Cat form (or Feral with form-switching off): CPs are native, always eligible
		shouldShowSecondary = secondaryNotNever
	elseif specId == 2 then
		-- Feral in non-cat form: checkbox defaults ON (nil → show)
		local showCP = settings and settings.displayBar and settings.displayBar.showComboPoints
		shouldShowSecondary = (showCP ~= false) and secondaryNotNever
	else
		-- Non-Feral in non-cat form: checkbox defaults OFF (nil → hide)
		local showCP = settings and settings.displayBar and settings.displayBar.showComboPoints
		shouldShowSecondary = (showCP == true) and secondaryNotNever
	end

	-- Mana bar: eligible when specId == 1 (Balance) and displaySpecId == 1 (primary shows Astral Power,
	-- not Mana). This matches HideResourceBar, UpdateResourceBar, and GetBarTextFrame.
	-- When form switching is OFF, displaySpecId == specId == 1, so mana wrapper always shows.
	-- When form switching is ON, only moonkin gives displaySpecId == 1.
	local shouldShowMana = (specId == 1 and displaySpecId == 1)

	-- Check if secondary is its own tree root (has a wrapper)
	local secondaryWrapper = editModeWrapperFrames["secondary"]
	if secondaryWrapper then
		-- Only manage visibility if secondary is actually a root in the current forest
		local isSecondaryRoot = forest and forest["secondary"] ~= nil
		if isSecondaryRoot then
			if shouldShowSecondary then
				secondaryWrapper:Show()
			else
				secondaryWrapper:Hide()
			end
		end
	end

	-- Check if mana is its own tree root (has a wrapper)
	local manaWrapper = editModeWrapperFrames["mana"]
	if manaWrapper then
		local isManaRoot = forest and forest["mana"] ~= nil
		if isManaRoot then
			if shouldShowMana then
				manaWrapper:Show()
			else
				manaWrapper:Hide()
			end
		end
	end
end

---Calculates layout information for a specific wrapper frame based on settings.
---Uses the anchor forest to get the tree for the given root and recursively
---compute a 2D bounding box encompassing all bars in that tree.
---@param settings table? # Settings table for dimension calculations
---@param includeHidden boolean? # If true, include hidden bars (for Edit Mode)
---@param rootBarKey string? # The tree root to calculate for (defaults to "primary")
---@return number totalWidth # Total width needed
---@return number totalHeight # Total height needed
---@return number extendAbove # How much bars extend above the base bar's top edge
---@return number extendBelow # How much bars extend below the base bar's bottom edge
---@return number baseOffsetX # Horizontal offset of the base bar center from the wrapper center
function TRB.Functions.EditMode:CalculateWrapperLayout(settings, includeHidden, rootBarKey)
	rootBarKey = rootBarKey or "primary"

	local barGroups = TRB.Frames.barGroups
	if not barGroups then
		return 100, 100, 0, 0, 0
	end

	-- Use settings if provided, otherwise try to get from spec cache
	if not settings and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if specSettings then
			settings = specSettings.settings
		end
	end

	if not settings then
		return 100, 100, 0, 0, 0
	end

	-- Get effective width (may be CDM-matched) for this root
	local effectiveWidth
	if barGroups.rootEffectiveWidths and barGroups.rootEffectiveWidths[rootBarKey] then
		effectiveWidth = barGroups.rootEffectiveWidths[rootBarKey]
	elseif rootBarKey == "primary" and barGroups.effectiveWidth and type(barGroups.effectiveWidth) == "number" then
		effectiveWidth = barGroups.effectiveWidth
	else
		local rootBarSettings = TRB.Functions.Bar:GetBarSettings(settings, rootBarKey)
		-- For multi-node bars (secondary/combo points), barSettings.width is per-node.
		-- Calculate total group width: nodeCount * nodeWidth + (nodeCount-1) * spacing
		local rootGroup = barGroups[rootBarKey]
		effectiveWidth = TRB.Functions.Bar:GetMultiNodeBarTotalWidth(rootBarKey, rootBarSettings, rootGroup)
		if effectiveWidth == 0 then
			effectiveWidth = (rootBarSettings and rootBarSettings.width) or settings.bar.width
		end
	end

	-- DRUID SPECIAL CASE: Non-Feral Druids use Feral's combo point settings
	-- for layout purposes. This injection must happen BEFORE building the anchor
	-- forest so secondary has proper dimensions for tree traversal. Without this,
	-- secondary has nil barSettings (0 dimensions) and walkTree cannot reach any
	-- bars anchored to it (e.g., mana bar).
	--
	-- Visibility handling (which bars should vs. shouldn't show based on Druid form)
	-- is delegated to IsBarVisibleForLayout in the walkTree function, rather than
	-- stripping bars from treeSettings. This ensures the tree is fully traversable
	-- while hidden bars still collapse to 0 height in the bounding box.
	local treeSettings = settings
	if TRB.Data.character.classId == 11 then
		local isNonFeralDruid = (TRB.Data.character.specId ~= 2)
		if isNonFeralDruid and barGroups.secondary then
			-- Inject Feral's comboPoints so secondary has proper dimensions in the tree.
			-- IsBarVisibleForLayout will handle collapsing secondary when not needed.
			local feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			if feralSettings and feralSettings.comboPoints and not settings.comboPoints then
				treeSettings = {}
				for k, v in pairs(settings) do
					treeSettings[k] = v
				end
				treeSettings.comboPoints = feralSettings.comboPoints
			end
		end
	end

	-- Build anchor forest without collapsing hidden bars. Hidden bars serve as
	-- invisible positioning scaffolds so that wrapper bounding-box calculations
	-- are consistent with the actual SetPoint-based layout (which always uses
	-- full dimensions for all bars, visible or not).
	local forest = TRB.Functions.Bar:BuildAnchorForest(treeSettings, barGroups, false, true)
	local rootNode = forest and forest[rootBarKey]
	if not rootNode then
		-- Fallback: if the requested root isn't in the forest, try the old single-tree approach
		-- This handles edge cases where rootBarKey might be inside another tree's subtree
		local fallbackRoot = TRB.Functions.Bar:BuildAnchorTree(treeSettings, barGroups, not includeHidden, includeHidden)
		if fallbackRoot and fallbackRoot.barKey == rootBarKey then
			rootNode = fallbackRoot
		end
		if not rootNode then
			local fallbackHeight = settings.bar.height
			if barGroups.rootEffectiveHeights and barGroups.rootEffectiveHeights[rootBarKey] then
				fallbackHeight = barGroups.rootEffectiveHeights[rootBarKey]
			end
			return effectiveWidth, fallbackHeight, 0, 0, 0
		end
	end

	-- Root node dimensions
	-- Use effectiveWidth for all roots (accounts for CDM width matching).
	-- The raw settings width is only a fallback when effectiveWidth isn't available.
	-- Use effectiveHeight for all roots (accounts for anchor frame height matching).
	local effectiveHeight
	if barGroups.rootEffectiveHeights and barGroups.rootEffectiveHeights[rootBarKey] then
		effectiveHeight = barGroups.rootEffectiveHeights[rootBarKey]
	end

	local baseWidth, baseHeight
	if rootBarKey == "primary" then
		baseWidth = effectiveWidth
		baseHeight = effectiveHeight or settings.bar.height or 0
	else
		local rootBarSettings = rootNode.barSettings
		baseWidth = effectiveWidth
		baseHeight = effectiveHeight or (rootBarSettings and rootBarSettings.height) or 0
	end

	-- Hidden bars use 0 height in the bounding-box calculation so the wrapper
	-- doesn't reserve space for them. The actual container frames are also
	-- collapsed to 0 height in ApplyBarGroupsLayout, matching this calculation.
	-- Uses IsBarVisibleForLayout for runtime visibility (e.g., Druid forms).
	if not TRB.Functions.Bar:IsBarVisibleForLayout(settings, rootBarKey, includeHidden) then
		baseHeight = 0
	end

	-- Coordinate system: X-right positive, Y-up positive, base bar's bottom-left at (0,0)
	local minX, maxX = 0, baseWidth
	local minY, maxY = 0, baseHeight

	---Returns the effective width and height for a bar node, accounting for matchWidth, fill direction, multi-node layout, and anchor frame width matching
	---@param node table # An anchor tree node with barSettings, barKey, barGroup, width, height
	---@param parentWidth number # The parent bar's effective width (used for matchWidth inheritance when horizontal fill)
	---@param parentHeight number # The parent bar's effective height (used for matchWidth inheritance when vertical fill)
	---@return number w # The effective width of the bar
	---@return number h # The effective height of the bar
	local function getEffectiveBarSize(node, parentWidth, parentHeight)
		local barSettings = node.barSettings
		if not barSettings then
			return node.width or 0, node.height or 0
		end

		local w = barSettings.width or 0
		local h = barSettings.height or 0

		-- Determine if this is a multi-node bar
		local isMultiNode = false
		local maxNodes = 1
		if node.barKey == "secondary" then
			isMultiNode = true
			maxNodes = TRB.Data.character.maxResource2 or 5
		else
			local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
			if registry then
				local barTypeDef = registry:Get(node.barKey)
				if barTypeDef and barTypeDef.isMultiNode and (barTypeDef.maxNodes or 1) > 1 then
					isMultiNode = true
					maxNodes = barTypeDef.maxNodes
				end
			end
		end

		local matchWidth = TRB.Functions.Bar:GetMatchWidth(barSettings)
		local matchHeight = TRB.Functions.Bar:GetMatchHeight(barSettings)

		if matchWidth then
			w = parentWidth
		elseif isMultiNode then
			-- Multi-node bar: calculate group extent along the growth axis
			local growthDirection = barSettings.growthDirection
			local nodeCount = maxNodes
			if node.barGroup and node.barGroup.nodeCount then
				nodeCount = node.barGroup.nodeCount
			end
			local nodeSpacing = barSettings.spacing or 2

			if growthDirection == "topBottom" or growthDirection == "bottomTop" then
				-- Vertical growth: width is per-node (cross axis)
				w = barSettings.width or 10
			else
				-- Horizontal growth: total width = nodeCount * nodeWidth + spacing
				local nodeWidth = barSettings.width or 10
				w = (nodeWidth * nodeCount) + (nodeSpacing * (nodeCount - 1))
			end
		end

		if matchHeight then
			h = parentHeight
		elseif isMultiNode then
			local growthDirection = barSettings.growthDirection
			local nodeCount = maxNodes
			if node.barGroup and node.barGroup.nodeCount then
				nodeCount = node.barGroup.nodeCount
			end
			local nodeSpacing = barSettings.spacing or 2

			if growthDirection == "topBottom" or growthDirection == "bottomTop" then
				-- Vertical growth: total height = nodeCount * nodeHeight + spacing
				local nodeHeight = barSettings.height or 10
				h = (nodeHeight * nodeCount) + (nodeSpacing * (nodeCount - 1))
			else
				-- Horizontal growth: height is per-node (cross axis)
				h = barSettings.height or 10
			end
		end

		-- Anchor frame width matching override: Edit Mode may have width matching enabled
		-- for this bar's root, expanding it beyond the matchWidth/calculated width.
		if node.barKey then
			local anchorWidthMatched = TRB.Functions.EditMode:IsWidthMatchingEnabled(nil, node.barKey)
			if anchorWidthMatched then
				local anchorFrameKey = TRB.Functions.EditMode:GetAnchorFrameKey(nil, node.barKey)
				local customFrameName = TRB.Functions.EditMode:GetCustomFrameName(nil, node.barKey)
				local anchorWidth = TRB.Functions.EditMode:GetAnchorFrameWidth(anchorFrameKey, customFrameName)
				if anchorWidth and anchorWidth > w then
					w = anchorWidth
				end
			end
		end

		return w, h
	end

	---Recursively walks the anchor tree and accumulates the 2D bounding box of all visible bars.
	---Hidden bars use 0 height (collapsed) so they don't reserve space, but their children
	---are still visited so visible descendants are positioned correctly.
	---@param parentNode table # The current anchor tree node being traversed
	---@param parentLeft number # The parent bar's left edge in global wrapper coords
	---@param parentBottom number # The parent bar's bottom edge in global wrapper coords
	---@param parentWidth number # The parent bar's effective width
	---@param parentHeight number # The parent bar's effective height (0 if hidden)
	local function walkTree(parentNode, parentLeft, parentBottom, parentWidth, parentHeight)
		for _, child in ipairs(parentNode.children) do
			local anchor = child.anchor
			if anchor then
				local childWidth, childHeight = getEffectiveBarSize(child, parentWidth, parentHeight)
				if childWidth > 0 or childHeight > 0 then
					-- Hidden children use 0 height and 0 width so they collapse in the bounding box.
					-- This matches ApplyBarGroupsLayout which sets their container to 0 for both.
					-- Uses IsBarVisibleForLayout for runtime visibility (e.g., Druid forms).
					local childIsHidden = child.barKey and not TRB.Functions.Bar:IsBarVisibleForLayout(settings, child.barKey, includeHidden)
					local layoutHeight = childIsHidden and 0 or childHeight
					local layoutWidth = childIsHidden and 0 or childWidth

					local anchorPt = anchor.anchorPoint or "TOP"
					local attachPt = anchor.attachPoint or "BOTTOM"
					local xOffset = anchor.xOffset or 0
					local yOffset = anchor.yOffset or 0
					local matchWidth = child.barSettings and TRB.Functions.Bar:GetMatchWidth(child.barSettings)
					local matchHeight = child.barSettings and TRB.Functions.Bar:GetMatchHeight(child.barSettings)

					-- Apply matchWidth center-alignment: center horizontally
					if matchWidth then
						anchorPt = string.gsub(anchorPt, "LEFT", "")
						anchorPt = string.gsub(anchorPt, "RIGHT", "")
						attachPt = string.gsub(attachPt, "LEFT", "")
						attachPt = string.gsub(attachPt, "RIGHT", "")
						if anchorPt == "" then anchorPt = "CENTER" end
						if attachPt == "" then attachPt = "CENTER" end
						xOffset = 0
					end
					-- Apply matchHeight center-alignment: center vertically
					if matchHeight then
						anchorPt = string.gsub(anchorPt, "TOP", "")
						anchorPt = string.gsub(anchorPt, "BOTTOM", "")
						attachPt = string.gsub(attachPt, "TOP", "")
						attachPt = string.gsub(attachPt, "BOTTOM", "")
						if anchorPt == "" then anchorPt = "CENTER" end
						if attachPt == "" then attachPt = "CENTER" end
						yOffset = 0
					end

					-- Calculate anchor point position on parent (Y-up, origin=parent bottom-left)
					local apX, apY = TRB.Functions.Bar:CalculateAnchorPointOffset(parentWidth, parentHeight, anchorPt)
					-- Calculate attach point position on child (use layout dimensions for collapsed bars)
					local atX, atY = TRB.Functions.Bar:CalculateAnchorPointOffset(layoutWidth, layoutHeight, attachPt)

					-- Child's bottom-left in global coords
					local childLeft = parentLeft + apX + xOffset - atX
					local childBottom = parentBottom + apY + yOffset - atY

					-- Only include visible children in the bounding box
					if not childIsHidden then
						minX = math.min(minX, childLeft)
						maxX = math.max(maxX, childLeft + layoutWidth)
						minY = math.min(minY, childBottom)
						maxY = math.max(maxY, childBottom + layoutHeight)
					end

					-- Always recurse into children (even hidden ones may have visible descendants)
					walkTree(child, childLeft, childBottom, layoutWidth, layoutHeight)
				end
			end
		end
	end

	-- Walk the tree starting from the root
	walkTree(rootNode, 0, 0, baseWidth, baseHeight)

	local totalWidth = maxX - minX
	local totalHeight = maxY - minY

	-- extendAbove = how much above the base bar's top = maxY - baseHeight
	local extendAbove = math.max(0, maxY - baseHeight)
	-- extendBelow = how much below the base bar's bottom = max(0, -minY)
	local extendBelow = math.max(0, -minY)
	-- baseOffsetX = horizontal offset of base bar center from wrapper center
	local baseOffsetX = (baseWidth / 2 - minX) - (totalWidth / 2)

	return totalWidth, totalHeight, extendAbove, extendBelow, baseOffsetX
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

---Registers all tree roots in the current anchor forest with Edit Mode.
---Call this after all bars are constructed.
function TRB.Functions.EditMode:RegisterAllTreeRoots()
	if not LibEditMode then
		return
	end

	local barGroups = TRB.Frames.barGroups
	if not barGroups then
		return
	end

	-- Get current settings for building the forest
	local settings
	if TRB.Data.specCache and TRB.Data.character.compositeKey then
		local specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if specCache then
			settings = specCache.settings
		end
	end
	if not settings then
		-- Fallback: just register primary
		if barGroups.primary then
			self:RegisterTreeRoot("primary", barGroups.primary:GetContainerFrame())
		end
		return
	end

	-- DRUID SPECIAL CASE: Non-Feral Druids ALWAYS use Feral's comboPoints settings
	-- so the forest sees the correct anchor config for secondary (e.g., barKey="screen").
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

	-- Build the forest to find all tree roots
	local forest = TRB.Functions.Bar:BuildAnchorForest(layoutSettings, barGroups, false, true)

	-- Register each root
	for rootBarKey, _ in pairs(forest) do
		local rootGroup = barGroups[rootBarKey]
		if rootGroup then
			self:RegisterTreeRoot(rootBarKey, rootGroup:GetContainerFrame())
		end
	end

	-- Hide wrappers for roots that no longer exist in the forest
	for existingRootKey, wrapperFrame in pairs(editModeWrapperFrames) do
		if not forest[existingRootKey] then
			wrapperFrame:Hide()
			if LibEditMode.frameSelections and LibEditMode.frameSelections[wrapperFrame] then
				local selection = LibEditMode.frameSelections[wrapperFrame]
				if selection then
					selection:Hide()
				end
			end
		end
	end
end

---Registers a single tree root with Edit Mode using a per-root wrapper frame.
---The wrapper becomes the parent of the root bar's container frame.
---@param rootBarKey string # The bar key that is the root of this tree
---@param containerFrame Frame # The root bar's container frame
function TRB.Functions.EditMode:RegisterTreeRoot(rootBarKey, containerFrame)
	if not LibEditMode then
		return
	end

	if not containerFrame then
		return
	end

	-- Get or create the wrapper frame for this tree root
	local wrapperFrame = self:GetOrCreateWrapperFrame(rootBarKey)

	-- Don't re-register the same wrapper (check both our tracking variable AND LibEditMode's registry)
	-- The wrapper frame persists across spec changes, so it may already be registered
	local alreadyRegistered = registeredFrames[rootBarKey] == wrapperFrame or 
		(LibEditMode.frameSelections and LibEditMode.frameSelections[wrapperFrame])
	
	if alreadyRegistered then
		-- Update tracking and size, but don't re-add to LibEditMode
		registeredFrames[rootBarKey] = wrapperFrame
		if rootBarKey == "primary" then
			registeredFrame = wrapperFrame
			self.primaryContainerFrame = containerFrame
		end
		-- The wrapper may have been hidden by a previous RegisterAllTreeRoots call
		-- (when this bar was temporarily a non-root). Re-show it now that it's a root again.
		wrapperFrame:Show()
		self:UpdateWrapperSize(nil, rootBarKey)

		-- If Edit Mode is active, restore the selection frame visibility so the
		-- wrapper appears as a draggable frame immediately.
		if LibEditMode:IsInEditMode() then
			wrapperFrame:SetFrameStrata("DIALOG")
			wrapperFrame:SetFrameLevel(100)
			containerFrame:Show()
			local selection = LibEditMode.frameSelections and LibEditMode.frameSelections[wrapperFrame]
			if selection and selection.ShowHighlighted then
				selection:ShowHighlighted()
			end
		end
		return
	end

	-- Update the tracked frame reference
	registeredFrames[rootBarKey] = wrapperFrame
	if rootBarKey == "primary" then
		registeredFrame = wrapperFrame
		self.primaryContainerFrame = containerFrame
	end

	-- Get default position from current spec settings or fall back to core defaults
	local defaultPosition = self:GetDefaultPosition(rootBarKey)

	-- Generate display name for this wrapper
	local displayName = self:GetWrapperDisplayName(rootBarKey)

	-- Register the WRAPPER frame with LibEditMode (not the bar container)
	-- When the wrapper is dragged, the root bar (as its child) moves with it
	LibEditMode:AddFrame(
		wrapperFrame,
		function(frame, layoutName, point, x, y)
			self:OnPositionChanged(frame, layoutName, point, x, y)
		end,
		defaultPosition,
		displayName
	)

	-- Add per-root Edit Mode settings
	self:AddFrameSettingsForRoot(wrapperFrame, rootBarKey)

	-- Hook anchor frames for all known CDM frame keys, plus any configured custom frame.
	-- This ensures that if the user switches anchor targets, the hooks are already in place.
	for frameKey, _ in pairs(FRAME_KEY_TO_GLOBAL) do
		self:HookAnchorFrame(frameKey)
	end

	-- Also hook any custom frame that's already configured for this root
	local layoutName = LibEditMode and LibEditMode:GetActiveLayoutName()
	if layoutName then
		local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
		if barData and barData.anchor and barData.anchor.frameKey == "other" and barData.anchor.customFrameName then
			self:HookAnchorFrame("other", barData.anchor.customFrameName)
		end
	end

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

---Gets a display name for a wrapper (for Edit Mode overlay title)
---@param rootBarKey string
---@return string
function TRB.Functions.EditMode:GetWrapperDisplayName(rootBarKey)
	local barDisplayName = TRB.Functions.Bar:GetBarDisplayName(rootBarKey)
	return string.format(L["WrapperDisplayNameFormat"], L["TRBAddonName"], barDisplayName)
end

---Adds Edit Mode frame settings (checkbox, dropdowns, sliders) for a specific tree root wrapper.
---@param wrapperFrame Frame
---@param rootBarKey string
function TRB.Functions.EditMode:AddFrameSettingsForRoot(wrapperFrame, rootBarKey)
	if not LibEditMode then
		return
	end
	
	---Returns true when the Edit Mode layout checkbox is unchecked for the current root, indicating controls should be disabled
	---@param layoutName string # The Edit Mode layout name to check
	---@return boolean # True if the layout is NOT enabled
	local function isLayoutDisabled(layoutName)
		return not self:IsLayoutEnabled(layoutName, rootBarKey)
	end

	---Returns true when the anchor frame key is "none" (free position mode) for the current root
	---@param layoutName string # The Edit Mode layout name to check
	---@return boolean # True if the anchor frame key is "none"
	local function isAnchorNone(layoutName)
		return self:GetAnchorFrameKeyRaw(layoutName, rootBarKey) == "none"
	end

	---Returns true when the layout is disabled OR the anchor frame key is "none", used to disable anchor-dependent controls
	---@param layoutName string # The Edit Mode layout name to check
	---@return boolean # True if the layout is disabled or anchor is free position
	local function isLayoutDisabledOrAnchorNone(layoutName)
		return isLayoutDisabled(layoutName) or isAnchorNone(layoutName)
	end

	---Reapplies bar group layout after any anchor settings change in the Edit Mode frame settings panel
	local function reapplyLayout()
		if TRB.Frames.barGroups and TRB.Data.specCache and TRB.Data.character.compositeKey then
			TRB.Functions.Bar:ApplyBarGroupsLayout(
				TRB.Data.specCache[TRB.Data.character.compositeKey].settings,
				TRB.Frames.barGroups
			)
		end
	end

	-- Build the 9-point anchor values list for dropdowns
	local anchorPointNames = {
		TOPLEFT     = L["AnchorPointTOPLEFT"],
		TOP         = L["AnchorPointTOP"],
		TOPRIGHT    = L["AnchorPointTOPRIGHT"],
		LEFT        = L["AnchorPointLEFT"],
		CENTER      = L["AnchorPointCENTER"],
		RIGHT       = L["AnchorPointRIGHT"],
		BOTTOMLEFT  = L["AnchorPointBOTTOMLEFT"],
		BOTTOM      = L["AnchorPointBOTTOM"],
		BOTTOMRIGHT = L["AnchorPointBOTTOMRIGHT"],
	}
	local anchorPointValues = {}
	for _, point in ipairs(TRB.Data.constants.anchorPoints) do
		table.insert(anchorPointValues, {
			text = anchorPointNames[point],
			value = point,
		})
	end

	LibEditMode:AddFrameSettings(wrapperFrame, {
		-- 1. Enable checkbox
		{
			kind = LibEditMode.SettingType.Checkbox,
			name = L["EditModeEnableForLayout"],
			desc = L["EditModeEnableForLayoutTooltip"],
			default = false,
			get = function(layoutName)
				return self:IsLayoutEnabled(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetLayoutEnabled(layoutName, newValue, rootBarKey)

				-- When enabling for the first time, capture the current wrapper position
				-- so the bar doesn't jump when Edit Mode takes over
				if newValue and layoutName then
					self:EnsureLayoutSettings(layoutName, rootBarKey)
					local layoutData = self:GetLayoutBarSettings(layoutName, rootBarKey)
					if layoutData and not layoutData.position then
						local thisWrapper = editModeWrapperFrames[rootBarKey]
						if thisWrapper then
							local point, x, y = self:NormalizePosition(thisWrapper)
							if point and x and y then
								layoutData.position = {
									point = point,
									x = x,
									y = y
								}
							else
								local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
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

				reapplyLayout()
			end,
		},
		-- 2. Divider
		{
			kind = LibEditMode.SettingType.Divider,
		},
		-- 3. Anchor To Frame dropdown
		{
			kind = LibEditMode.SettingType.Dropdown,
			name = L["EditModeAnchorToFrame"],
			desc = L["EditModeAnchorToFrameTooltip"],
			default = "none",
			disabled = isLayoutDisabled,
			values = function()
				local otherText = L["EditModeAnchorOtherFrame"]
				local currentKey = self:GetAnchorFrameKeyRaw(nil, rootBarKey)
				if currentKey == "other" then
					local customName = self:GetCustomFrameName(nil, rootBarKey)
					if customName and customName ~= "" then
						otherText = string.format(L["EditModeAnchorOtherFrameDisplay"], customName)
					end
				end
				return {
					{ text = L["EditModeAnchorFreePosition"], value = "none" },
					{ text = L["EditModeAnchorCDMEssential"], value = "cdm-essential" },
					{ text = L["EditModeAnchorCDMTrackedBuffs"], value = "cdm-buffs" },
					{ text = L["EditModeAnchorCDMUtilityCooldowns"], value = "cdm-utility" },
					{ text = L["EditModeAnchorCDMTrackedBars"], value = "cdm-bars" },
					{ text = otherText, value = "other" },
				}
			end,
			get = function(layoutName)
				local frameKey = self:GetAnchorFrameKeyRaw(layoutName, rootBarKey)
				-- For "other", show the custom display text in the dropdown
				if frameKey == "other" then
					return "other"
				end
				return frameKey
			end,
			set = function(layoutName, newValue, fromReset)
				if newValue == "other" then
					-- Show StaticPopup for custom frame name entry
					local currentName = self:GetCustomFrameName(layoutName, rootBarKey) or ""
					self:ShowCustomFrameDialog(currentName, function(frameName)
						if frameName and frameName ~= "" then
							self:SetAnchorFrameKey(layoutName, "other", rootBarKey)
							self:SetCustomFrameName(layoutName, frameName, rootBarKey)

							-- Validate the frame exists and warn if not
							if not _G[frameName] then
								print("|cFFFF8800TRB:|r " .. string.format(L["EditModeCustomFrameWarning"], frameName))
							end

							-- Hook the custom frame for resize/show
							self:HookAnchorFrame("other", frameName)
							reapplyLayout()
							-- Refresh the settings dialog so the dropdown shows "Other: FrameName"
							LibEditMode:RefreshFrameSettings(wrapperFrame)
						else
							-- Empty name entered, treat as cancel — make no changes
							-- Just refresh the UI so the dropdown reverts to the previous value
							LibEditMode:RefreshFrameSettings(wrapperFrame)
						end
					end)
				else
					self:SetAnchorFrameKey(layoutName, newValue, rootBarKey)
					if newValue ~= "none" then
						-- Hook the selected frame for resize/show events
						self:HookAnchorFrame(newValue)
					end
					reapplyLayout()
				end
			end,
		},
		-- 4. Anchor Point (where on the target frame)
		{
			kind = LibEditMode.SettingType.Dropdown,
			name = L["EditModeAnchorPointEM"],
			desc = L["EditModeAnchorPointEMTooltip"],
			default = "BOTTOM",
			disabled = isLayoutDisabledOrAnchorNone,
			values = anchorPointValues,
			get = function(layoutName)
				return self:GetAnchorPoint(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetAnchorPoint(layoutName, newValue, rootBarKey)
				reapplyLayout()
			end,
		},
		-- 5. Attach Point (where on this bar)
		{
			kind = LibEditMode.SettingType.Dropdown,
			name = L["EditModeAttachPointEM"],
			desc = L["EditModeAttachPointEMTooltip"],
			default = "TOP",
			disabled = isLayoutDisabledOrAnchorNone,
			values = anchorPointValues,
			get = function(layoutName)
				return self:GetAttachPoint(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetAttachPoint(layoutName, newValue, rootBarKey)
				reapplyLayout()
			end,
		},
		-- 6. Horizontal Offset slider
		{
			kind = LibEditMode.SettingType.Slider,
			name = L["EditModeHorizontalOffset"],
			desc = L["EditModeHorizontalOffsetTooltip"],
			default = 0,
			disabled = isLayoutDisabledOrAnchorNone,
			minValue = -500,
			maxValue = 500,
			valueStep = 1,
			get = function(layoutName)
				return self:GetHorizontalOffset(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetHorizontalOffset(layoutName, newValue, rootBarKey)
				reapplyLayout()
			end,
		},
		-- 7. Vertical Offset slider
		{
			kind = LibEditMode.SettingType.Slider,
			name = L["EditModeVerticalOffset"],
			desc = L["EditModeVerticalOffsetTooltip"],
			default = 0,
			disabled = isLayoutDisabledOrAnchorNone,
			minValue = -500,
			maxValue = 500,
			valueStep = 1,
			get = function(layoutName)
				return self:GetVerticalOffset(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetVerticalOffset(layoutName, newValue, rootBarKey)
				reapplyLayout()
			end,
		},
		-- 8. Match Width checkbox
		{
			kind = LibEditMode.SettingType.Checkbox,
			name = L["EditModeMatchAnchorWidth"],
			desc = L["EditModeMatchAnchorWidthTooltip"],
			default = false,
			disabled = isLayoutDisabledOrAnchorNone,
			get = function(layoutName)
				return self:IsWidthMatchingEnabledRaw(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetWidthMatchingEnabled(layoutName, newValue, rootBarKey)
				reapplyLayout()
			end,
		},
	})
end

---Gets the default position for a tree root's wrapper
---Uses NormalizePosition to capture the actual current position if the wrapper exists
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return table # Default position table with point, x, y
function TRB.Functions.EditMode:GetDefaultPosition(rootBarKey)
	rootBarKey = rootBarKey or "primary"

	-- Use the wrapper frame position, NOT the container frame
	-- The wrapper is what LibEditMode moves, so its position is what we save/restore
	local wrapperFrame = editModeWrapperFrames[rootBarKey]
	if wrapperFrame then
		local point, x, y = self:NormalizePosition(wrapperFrame)
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
		local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
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

---Callback when a bar position is changed in Edit Mode
---@param frame Frame # The wrapper frame that was moved
---@param layoutName string # The current layout name
---@param point string # The anchor point
---@param x number # X offset
---@param y number # Y offset
function TRB.Functions.EditMode:OnPositionChanged(frame, layoutName, point, x, y)
	if not layoutName then
		return
	end

	-- Determine which tree root this wrapper belongs to
	local rootBarKey = frame and frame.trbRootBarKey or "primary"

	-- Check if Edit Mode is enabled for this root in this layout
	-- If not enabled, ignore position changes - use legacy positioning instead
	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		-- Not enabled - revert to legacy position
		if TRB.Frames.barGroups then
			local specSettings = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey]
			if specSettings and specSettings.settings then
				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
			end
		end
		return
	end

	-- Check if we're using anchor frame positioning for this root - if so, ignore position changes
	local anchorFrameKey = self:GetAnchorFrameKey(layoutName, rootBarKey)
	if anchorFrameKey ~= "none" then
		local customFrameName = self:GetCustomFrameName(layoutName, rootBarKey)
		if self:IsAnchorFrameAvailable(anchorFrameKey, customFrameName) then
			-- Anchor frame active - revert to anchor position instead of saving
			if TRB.Frames.barGroups then
				local specSettings = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey]
				if specSettings and specSettings.settings then
					TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
				end
			end
			return
		end
	end

	-- LibEditMode has moved the wrapper frame
	-- Save the new position for this layout + root

	-- Ensure settings structure exists
	self:EnsureLayoutSettings(layoutName, rootBarKey)

	-- Save the position for this root in this layout
	local layoutBarData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	if layoutBarData then
		layoutBarData.position = {
			point = point,
			x = x,
			y = y
		}
	end
end

---Called when the Edit Mode layout changes
---@param layoutName string # The new layout name
---@param layoutIndex number # The layout index
function TRB.Functions.EditMode:OnLayoutChanged(layoutName, layoutIndex)
	-- Reapply bar position based on the new layout
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
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
	-- Raise ALL wrapper frames' strata so selection frames can receive mouse events
	for _, wrapperFrame in pairs(editModeWrapperFrames) do
		if wrapperFrame then
			wrapperFrame:SetFrameStrata("DIALOG")
			wrapperFrame:SetFrameLevel(100)
		end
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

	-- CreateBarTextFrames clears all font text to ""; mark lookup dirty so
	-- UpdateResourceBarText re-renders on the next tick instead of early-outing.
	TRB.Functions.BarText:MarkLookupDirty()
end

---Called when Edit Mode is exited
function TRB.Functions.EditMode:OnEditModeExit()
	-- Lower ALL wrapper frames' strata back to normal
	for _, wrapperFrame in pairs(editModeWrapperFrames) do
		if wrapperFrame then
			wrapperFrame:SetFrameStrata("BACKGROUND")
			wrapperFrame:SetFrameLevel(1)
		end
	end

	-- Reapply layout to reset frame stratas and levels after Edit Mode
	if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
		local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if specSettings and specSettings.settings then
			-- Reapply layout to reset frame stratas and levels
			TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
		end

		-- Rebuild bar text frames to restore proper strata/level ordering
		-- This ensures bar text appears above thresholds after Edit Mode's strata changes
		TRB.Functions.BarText:CreateBarTextFrames()

		-- CreateBarTextFrames clears all font text to ""; mark lookup dirty so
		-- UpdateResourceBarText re-renders on the next tick instead of early-outing.
		TRB.Functions.BarText:MarkLookupDirty()

		-- Let HideResourceBar determine if the bar should be visible now
		TRB.Functions.BarVisibility:MarkDirty()
		TRB.Functions.Class:HideResourceBar()
	end
end

---Ensures the layout settings structure exists for a given layout and root bar.
---Performs backward-compatible migration from the old flat structure to the new
---per-root structure: layouts[name].bars[rootBarKey] = { enabled, position, anchor = { ... } }
---@param layoutName string # The layout name
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:EnsureLayoutSettings(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"

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
			bars = {}
		}
	end

	local layoutData = TRB.Data.settings.core.editMode.layouts[layoutName]

	-- If old flat format exists (has 'enabled' at root level), migrate to 'bars.primary'
	if layoutData.enabled ~= nil and not layoutData.bars then
		layoutData.bars = {}
		layoutData.bars["primary"] = {
			enabled = layoutData.enabled,
			position = layoutData.position,
			anchorToCooldownManager = layoutData.anchorToCooldownManager or "none",
			anchorOffset = layoutData.anchorOffset or 0,
			matchCooldownManagerWidth = layoutData.matchCooldownManagerWidth or false,
		}
		-- Clean up old flat fields
		layoutData.enabled = nil
		layoutData.position = nil
		layoutData.anchorToCooldownManager = nil
		layoutData.anchorOffset = nil
		layoutData.matchCooldownManagerWidth = nil
	end

	-- Ensure bars sub-table exists
	if not layoutData.bars then
		layoutData.bars = {}
	end

	-- Ensure per-root entry exists with new anchor block
	if not layoutData.bars[rootBarKey] then
		layoutData.bars[rootBarKey] = {
			enabled = false,
			position = nil,
			anchor = {
				frameKey = "none",
				customFrameName = nil,
				anchorPoint = "BOTTOM",
				attachPoint = "TOP",
				xOffset = 0,
				yOffset = 0,
				matchWidth = false,
			},
		}
	end

	-- Migrate old flat CDM fields into nested anchor block
	local barData = layoutData.bars[rootBarKey]
	if barData.anchorToCooldownManager ~= nil then
		local oldMode = barData.anchorToCooldownManager
		local oldOffset = barData.anchorOffset or 0
		local oldMatchWidth = barData.matchCooldownManagerWidth or false

		barData.anchor = barData.anchor or {}
		local anchor = barData.anchor

		if oldMode == "above" then
			anchor.frameKey = anchor.frameKey or "cdm-essential"
			anchor.anchorPoint = anchor.anchorPoint or "TOP"
			anchor.attachPoint = anchor.attachPoint or "BOTTOM"
			anchor.xOffset = anchor.xOffset or 0
			anchor.yOffset = anchor.yOffset or oldOffset
		elseif oldMode == "below" then
			anchor.frameKey = anchor.frameKey or "cdm-essential"
			anchor.anchorPoint = anchor.anchorPoint or "BOTTOM"
			anchor.attachPoint = anchor.attachPoint or "TOP"
			anchor.xOffset = anchor.xOffset or 0
			anchor.yOffset = anchor.yOffset or -oldOffset
		else
			anchor.frameKey = anchor.frameKey or "none"
			anchor.anchorPoint = anchor.anchorPoint or "BOTTOM"
			anchor.attachPoint = anchor.attachPoint or "TOP"
			anchor.xOffset = anchor.xOffset or 0
			anchor.yOffset = anchor.yOffset or 0
		end

		anchor.matchWidth = anchor.matchWidth or oldMatchWidth
		anchor.customFrameName = anchor.customFrameName or nil

		-- Clean up old flat CDM fields
		barData.anchorToCooldownManager = nil
		barData.anchorOffset = nil
		barData.matchCooldownManagerWidth = nil
	end

	-- Ensure anchor block and all its fields exist (field-level migration for partial data)
	if not barData.anchor then
		barData.anchor = {}
	end
	local anchor = barData.anchor
	if anchor.frameKey == nil then anchor.frameKey = "none" end
	if anchor.anchorPoint == nil then anchor.anchorPoint = "BOTTOM" end
	if anchor.attachPoint == nil then anchor.attachPoint = "TOP" end
	if anchor.xOffset == nil then anchor.xOffset = 0 end
	if anchor.yOffset == nil then anchor.yOffset = 0 end
	if anchor.matchWidth == nil then anchor.matchWidth = false end
	-- customFrameName can legitimately be nil, no default needed
end

---Gets the per-root layout settings for a given layout and root bar key.
---@param layoutName string
---@param rootBarKey string? # Defaults to "primary"
---@return table? # The bar-specific layout data
function TRB.Functions.EditMode:GetLayoutBarSettings(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	return TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey]
end

---Checks if a layout is enabled for Edit Mode positioning for a specific root
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return boolean # True if the layout is enabled
function TRB.Functions.EditMode:IsLayoutEnabled(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return false
	end

	if not TRB.Data.settings.core.editMode or not TRB.Data.settings.core.editMode.layouts then
		return false
	end

	self:EnsureLayoutSettings(layoutName, rootBarKey)
	local barData = TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey]
	return barData and barData.enabled == true
end

---Sets whether a layout is enabled for Edit Mode positioning for a specific root
---@param layoutName string # The layout name
---@param enabled boolean # Whether to enable Edit Mode for this layout
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetLayoutEnabled(layoutName, enabled, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].enabled = enabled
end

---Gets the position for the current Edit Mode layout if enabled for a specific root
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return table? # Position table {point, x, y} or nil if not using Edit Mode
function TRB.Functions.EditMode:GetActivePosition(rootBarKey)
	rootBarKey = rootBarKey or "primary"
	if not LibEditMode then
		return nil
	end

	local layoutName = LibEditMode:GetActiveLayoutName()
	if not layoutName then
		return nil
	end

	-- Check if this layout is enabled for this root
	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		return nil
	end

	-- Get the saved position for this root in this layout
	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	if barData and barData.position then
		return barData.position
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
-- Anchor Frame Integration
-- ============================================================================

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

---Resolves a frameKey (and optional customFrameName) to a WoW frame reference.
---For known CDM keys, uses FRAME_KEY_TO_GLOBAL mapping.
---For "other", looks up the customFrameName in _G.
---@param frameKey string # "none", "cdm-essential", "cdm-buffs", "cdm-utility", "cdm-bars", or "other"
---@param customFrameName string? # Only used when frameKey == "other"
---@return Frame? # The resolved frame, or nil if unavailable
function TRB.Functions.EditMode:GetAnchorFrame(frameKey, customFrameName)
	if frameKey == "none" then
		return nil
	end

	if frameKey == "other" then
		if customFrameName and customFrameName ~= "" then
			return _G[customFrameName]
		end
		return nil
	end

	local globalName = FRAME_KEY_TO_GLOBAL[frameKey]
	if globalName then
		return _G[globalName]
	end

	return nil
end

---Gets the anchor frame for the current layout for a specific root
---Convenience wrapper that reads frameKey/customFrameName from settings
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return Frame? # The resolved anchor frame, or nil
function TRB.Functions.EditMode:GetAnchorFrameForRoot(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return nil
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	if not barData or not barData.anchor then
		return nil
	end

	return self:GetAnchorFrame(barData.anchor.frameKey, barData.anchor.customFrameName)
end

---Gets the anchor target frame's width, temporarily showing it if hidden
---@param frameKey string # The frame key
---@param customFrameName string? # Only used when frameKey == "other"
---@return number? # The width in pixels, or nil if frame not available
function TRB.Functions.EditMode:GetAnchorFrameWidth(frameKey, customFrameName)
	local frame = self:GetAnchorFrame(frameKey, customFrameName)
	if not frame then
		return nil
	end

	local wasHidden = not frame:IsShown()
	if wasHidden then
		isTemporarilyShowingCDM = true
		local originalAlpha = frame:GetAlpha()
		frame:SetAlpha(0)
		frame:Show()
		local width = frame:GetWidth()
		frame:Hide()
		frame:SetAlpha(originalAlpha)
		isTemporarilyShowingCDM = false
		return width
	else
		return frame:GetWidth()
	end
end

---Gets the anchor target frame's height, temporarily showing it if hidden
---@param frameKey string # The frame key
---@param customFrameName string? # Only used when frameKey == "other"
---@return number? # The height in pixels, or nil if frame not available
function TRB.Functions.EditMode:GetAnchorFrameHeight(frameKey, customFrameName)
	local frame = self:GetAnchorFrame(frameKey, customFrameName)
	if not frame then
		return nil
	end

	local wasHidden = not frame:IsShown()
	if wasHidden then
		isTemporarilyShowingCDM = true
		local originalAlpha = frame:GetAlpha()
		frame:SetAlpha(0)
		frame:Show()
		local height = frame:GetHeight()
		frame:Hide()
		frame:SetAlpha(originalAlpha)
		isTemporarilyShowingCDM = false
		return height
	else
		return frame:GetHeight()
	end
end

---Checks if the frame identified by a frameKey is available (exists in _G)
---@param frameKey string # The frame key
---@param customFrameName string? # Only used when frameKey == "other"
---@return boolean # True if the frame exists
function TRB.Functions.EditMode:IsAnchorFrameAvailable(frameKey, customFrameName)
	return self:GetAnchorFrame(frameKey, customFrameName) ~= nil
end

---Helper function to reapply bar layout when an anchor frame changes size or visibility
---@param layoutName string? # Optional layout name override
---@param forceUpdate boolean? # If true, skip the "no change" optimization
local function ReapplyAnchorFrameLayout(layoutName, forceUpdate)
	-- Reentrancy guard: GetAnchorFrameWidth/Height may temporarily Show/Hide the
	-- anchor frame to read its dimensions, which fires OnSizeChanged hooks that
	-- would re-enter this function and create an infinite loop.
	if isReapplyingAnchorLayout then
		return
	end
	if not TRB.Data.specSupported then
		return
	end
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return
	end

	local layoutData = TRB.Data.settings.core.editMode.layouts and TRB.Data.settings.core.editMode.layouts[layoutName]
	if not layoutData or not layoutData.bars then
		return
	end

	-- Check if any root bar uses anchor frame features
	local anyAnchorUsage = false
	for _, barData in pairs(layoutData.bars) do
		if barData.enabled and barData.anchor and barData.anchor.frameKey ~= "none" then
			anyAnchorUsage = true
			break
		end
	end

	if anyAnchorUsage then
		-- Reapply bar layout to update width/height/position
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
			local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
			if specSettings and specSettings.settings then
				isReapplyingAnchorLayout = true
				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
				isReapplyingAnchorLayout = false
			end
		end
	end
end

-- Keep backward-compatible local reference
local ReapplyCooldownManagerLayout = ReapplyAnchorFrameLayout

---Hooks OnSizeChanged and OnShow on an anchor frame to trigger bar layout updates.
---Safe to call multiple times for the same frame — will only hook once per frame reference.
---@param frameKey string # The frame key (e.g., "cdm-essential", "other")
---@param customFrameName string? # Only used when frameKey == "other"
function TRB.Functions.EditMode:HookAnchorFrame(frameKey, customFrameName)
	local frame = self:GetAnchorFrame(frameKey, customFrameName)
	if not frame then
		return
	end

	-- Avoid double-hooking the same frame reference
	if hookedFrames[frame] then
		return
	end

	-- Hook OnSizeChanged (guard against temporary Show/Hide for measurement)
	frame:HookScript("OnSizeChanged", function(f, width, height)
		if isTemporarilyShowingCDM then
			return
		end
		ReapplyAnchorFrameLayout()
	end)

	-- Hook OnShow with guard and delayed reapply
	frame:HookScript("OnShow", function(f)
		if isTemporarilyShowingCDM then
			return
		end
		C_Timer.After(0, function()
			C_Timer.After(0.1, function()
				ReapplyAnchorFrameLayout()
			end)
		end)
	end)

	hookedFrames[frame] = true

	-- If the frame is already visible when we hook it, trigger layout update immediately
	if frame:IsShown() then
		C_Timer.After(0, function()
			C_Timer.After(0.1, function()
				ReapplyAnchorFrameLayout()
			end)
		end)
	end
end

---Hooks the Cooldown Manager's OnSizeChanged to update bar layout when CDM width changes
---@deprecated Use HookAnchorFrame("cdm-essential") instead
---Safe to call multiple times - will only hook once
function TRB.Functions.EditMode:HookCooldownManagerResize()
	self:HookAnchorFrame("cdm-essential")
end

---Hooks the Cooldown Manager's OnShow to update bar layout when CDM first becomes visible
---@deprecated Use HookAnchorFrame("cdm-essential") instead
---Safe to call multiple times - will only hook once
function TRB.Functions.EditMode:HookCooldownManagerShow()
	self:HookAnchorFrame("cdm-essential")
end

-- ============================================================================
-- Anchor Block Getters/Setters
-- ============================================================================

---Gets the anchor frame key for the current layout for a specific root.
---This returns the EFFECTIVE value — "none" if layout is not enabled.
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # "none", "cdm-essential", "cdm-buffs", "cdm-utility", "cdm-bars", or "other"
function TRB.Functions.EditMode:GetAnchorFrameKey(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		return "none"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchor and barData.anchor.frameKey) or "none"
end

---Gets the RAW saved anchor frame key (for UI display, regardless of enabled state)
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # "none", "cdm-essential", "cdm-buffs", "cdm-utility", "cdm-bars", or "other"
function TRB.Functions.EditMode:GetAnchorFrameKeyRaw(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchor and barData.anchor.frameKey) or "none"
end

---Sets the anchor frame key for a layout for a specific root
---@param layoutName string # The layout name
---@param frameKey string # "none", "cdm-essential", "cdm-buffs", "cdm-utility", "cdm-bars", or "other"
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAnchorFrameKey(layoutName, frameKey, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.frameKey = frameKey
end

---Gets the custom frame name for "other" anchor frame key
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string? # The custom frame name or nil
function TRB.Functions.EditMode:GetCustomFrameName(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return nil
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return barData and barData.anchor and barData.anchor.customFrameName
end

---Sets the custom frame name for "other" anchor frame key
---@param layoutName string # The layout name
---@param frameName string? # The WoW global frame name
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetCustomFrameName(layoutName, frameName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.customFrameName = frameName
end

---Gets the anchor point (where on the TRB bar to anchor FROM)
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # WoW anchor point string (e.g., "TOP", "BOTTOMLEFT")
function TRB.Functions.EditMode:GetAnchorPoint(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "BOTTOM"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchor and barData.anchor.anchorPoint) or "BOTTOM"
end

---Sets the anchor point (where on the TRB bar to anchor FROM)
---@param layoutName string # The layout name
---@param point string # WoW anchor point string (e.g., "TOP", "BOTTOMLEFT")
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAnchorPoint(layoutName, point, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.anchorPoint = point
end

---Gets the attach point (where on the target frame to attach TO)
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # WoW anchor point string (e.g., "TOP", "BOTTOMLEFT")
function TRB.Functions.EditMode:GetAttachPoint(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "TOP"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchor and barData.anchor.attachPoint) or "TOP"
end

---Sets the attach point (where on the target frame to attach TO)
---@param layoutName string # The layout name
---@param point string # WoW anchor point string (e.g., "TOP", "BOTTOMLEFT")
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAttachPoint(layoutName, point, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.attachPoint = point
end

---Gets the horizontal offset for the current layout for a specific root
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return number # The horizontal offset in pixels
function TRB.Functions.EditMode:GetHorizontalOffset(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return 0
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchor and barData.anchor.xOffset) or 0
end

---Sets the horizontal offset for a layout for a specific root
---@param layoutName string # The layout name
---@param offset number # The horizontal offset in pixels
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetHorizontalOffset(layoutName, offset, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.xOffset = offset
end

---Gets the vertical offset for the current layout for a specific root
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return number # The vertical offset in pixels
function TRB.Functions.EditMode:GetVerticalOffset(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return 0
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchor and barData.anchor.yOffset) or 0
end

---Sets the vertical offset for a layout for a specific root
---@param layoutName string # The layout name
---@param offset number # The vertical offset in pixels
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetVerticalOffset(layoutName, offset, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.yOffset = offset
end

---Gets the fill direction for a bar key from the current spec settings.
---@param rootBarKey string # The bar key to look up
---@return trbFillDirection # The fill direction, defaults to "leftRight"
function TRB.Functions.EditMode:GetBarFillDirection(rootBarKey)
	local specCache = TRB.Data.specCache
	if not specCache or not TRB.Data.character or not TRB.Data.character.compositeKey then
		return "leftRight"
	end
	local cached = specCache[TRB.Data.character.compositeKey]
	if not cached or not cached.settings then
		return "leftRight"
	end
	if rootBarKey == "primary" then
		return cached.settings.bar.fillDirection or "leftRight"
	end
	local barSettings = TRB.Functions.Bar:GetBarSettings(cached.settings, rootBarKey)
	return (barSettings and barSettings.fillDirection) or "leftRight"
end

---Gets whether width matching is enabled for the current layout for a specific root.
---This returns the EFFECTIVE value — false if layout is not enabled or no anchor frame set.
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return boolean # True if width matching is enabled and applicable
function TRB.Functions.EditMode:IsWidthMatchingEnabled(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	-- matchWidth means "match width" when horizontal, "match height" when vertical
	local fillDirection = self:GetBarFillDirection(rootBarKey)
	if TRB.Functions.Bar:IsVerticalFill(fillDirection) then
		return false
	end
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		-- Early init fallback: scan all layouts for potential width matching
		if TRB.Data.settings.core.editMode and TRB.Data.settings.core.editMode.layouts then
			for _, layoutData in pairs(TRB.Data.settings.core.editMode.layouts) do
				if layoutData.bars and layoutData.bars[rootBarKey] then
					local barData = layoutData.bars[rootBarKey]
					if barData.enabled and barData.anchor and barData.anchor.matchWidth and barData.anchor.frameKey ~= "none" then
						if self:IsAnchorFrameAvailable(barData.anchor.frameKey, barData.anchor.customFrameName) then
							return true
						end
						break
					end
				end
			end
		end
		return false
	end

	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		return false
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	if not barData or not barData.anchor or barData.anchor.frameKey == "none" then
		return false
	end

	return barData.anchor.matchWidth == true
end

---Gets the RAW saved width matching setting (for UI display)
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return boolean # True if width matching is enabled in settings
function TRB.Functions.EditMode:IsWidthMatchingEnabledRaw(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return false
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return barData and barData.anchor and barData.anchor.matchWidth == true
end

---Sets whether width matching is enabled for a layout for a specific root
---@param layoutName string # The layout name
---@param enabled boolean # Whether to enable width matching
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetWidthMatchingEnabled(layoutName, enabled, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor.matchWidth = enabled
end

---Gets whether height matching is enabled for the current layout for a specific root.
---This returns the EFFECTIVE value — false if layout is not enabled or no anchor frame set.
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return boolean # True if height matching is enabled and applicable
function TRB.Functions.EditMode:IsHeightMatchingEnabled(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	-- matchWidth means "match height" when vertical fill direction
	local fillDirection = self:GetBarFillDirection(rootBarKey)
	if not TRB.Functions.Bar:IsVerticalFill(fillDirection) then
		return false
	end
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return false
	end

	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		return false
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	if not barData or not barData.anchor or barData.anchor.frameKey == "none" then
		return false
	end

	return barData.anchor.matchWidth == true
end

-- ============================================================================
-- Backward-Compatible Anchor Mode Helpers
-- ============================================================================

---Gets the anchor mode for the current layout for a specific root.
---@deprecated Use GetAnchorFrameKey instead. Returns synthetic mode based on anchor block.
---Returns "none" if layout is not enabled or no anchor frame set.
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # "none", "above", or "below" (synthetic from anchor block)
function TRB.Functions.EditMode:GetAnchorMode(layoutName, rootBarKey)
	local frameKey = self:GetAnchorFrameKey(layoutName, rootBarKey)
	if frameKey == "none" then
		return "none"
	end

	local anchorPoint = self:GetAnchorPoint(layoutName, rootBarKey)
	-- If anchoring from the bar's BOTTOM to target's TOP → "above"
	-- If anchoring from the bar's TOP to target's BOTTOM → "below"
	if anchorPoint == "BOTTOM" or anchorPoint == "BOTTOMLEFT" or anchorPoint == "BOTTOMRIGHT" then
		return "above"
	elseif anchorPoint == "TOP" or anchorPoint == "TOPLEFT" or anchorPoint == "TOPRIGHT" then
		return "below"
	end
	return "above" -- default fallback
end

---Gets the RAW saved anchor mode (for UI display)
---@deprecated Use GetAnchorFrameKeyRaw instead.
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # "none", "above", or "below"
function TRB.Functions.EditMode:GetAnchorModeRaw(layoutName, rootBarKey)
	local frameKey = self:GetAnchorFrameKeyRaw(layoutName, rootBarKey)
	if frameKey == "none" then
		return "none"
	end

	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	if barData and barData.anchor then
		local ap = barData.anchor.anchorPoint or "BOTTOM"
		if ap == "BOTTOM" or ap == "BOTTOMLEFT" or ap == "BOTTOMRIGHT" then
			return "above"
		elseif ap == "TOP" or ap == "TOPLEFT" or ap == "TOPRIGHT" then
			return "below"
		end
	end
	return "above"
end

---Sets the anchor mode for a layout for a specific root. Translates to anchor block format.
---@deprecated Use SetAnchorFrameKey/SetAnchorPoint/SetAttachPoint instead.
---@param layoutName string # The layout name
---@param mode string # "none", "above", or "below"
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAnchorMode(layoutName, mode, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)

	local anchor = TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchor
	if mode == "none" then
		anchor.frameKey = "none"
	elseif mode == "above" then
		anchor.frameKey = anchor.frameKey == "none" and "cdm-essential" or anchor.frameKey
		anchor.anchorPoint = "BOTTOM"
		anchor.attachPoint = "TOP"
	elseif mode == "below" then
		anchor.frameKey = anchor.frameKey == "none" and "cdm-essential" or anchor.frameKey
		anchor.anchorPoint = "TOP"
		anchor.attachPoint = "BOTTOM"
	end
end

---Gets the anchor offset for the current layout for a specific root
---@deprecated Use GetVerticalOffset instead.
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return number # The vertical offset in pixels
function TRB.Functions.EditMode:GetAnchorOffset(layoutName, rootBarKey)
	return self:GetVerticalOffset(layoutName, rootBarKey)
end

---Sets the anchor offset for a layout for a specific root
---@deprecated Use SetVerticalOffset instead.
---@param layoutName string # The layout name
---@param offset number # The vertical offset in pixels
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAnchorOffset(layoutName, offset, rootBarKey)
	self:SetVerticalOffset(layoutName, offset, rootBarKey)
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

	---Updates the running bounding box (left, right, top, bottom) with the edges of a given frame
	---@param frame Frame? # The WoW frame whose edges should be incorporated into the bounding box
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
---@diagnostic disable-next-line: param-type-mismatch
			right = math.max(right, frameRight)
---@diagnostic disable-next-line: param-type-mismatch
			top = math.max(top, frameTop)
---@diagnostic disable-next-line: param-type-mismatch
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
---@deprecated Use GetAnchorFrameWidth("cdm-essential") instead
---@return number? # The width in pixels, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerWidth()
	return self:GetAnchorFrameWidth("cdm-essential")
end

---Gets the Cooldown Manager's center X position
---@deprecated Prefer using anchor points directly
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
---@deprecated Prefer using anchor points directly
---@return number? # The top Y coordinate, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerTop()
	local cdm = self:GetCooldownManagerFrame()
	if cdm then
		return cdm:GetTop()
	end
	return nil
end

---Gets the Cooldown Manager's bottom edge position
---@deprecated Prefer using anchor points directly
---@return number? # The bottom Y coordinate, or nil if CDM not available
function TRB.Functions.EditMode:GetCooldownManagerBottom()
	local cdm = self:GetCooldownManagerFrame()
	if cdm then
		return cdm:GetBottom()
	end
	return nil
end

-- ============================================================================
-- StaticPopup for "Other Frame" custom name entry
-- ============================================================================

StaticPopupDialogs["TRB_EDIT_MODE_CUSTOM_FRAME"] = {
	text = L["EditModeCustomFrameDialogText"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	editBoxWidth = 260,
	maxLetters = 128,
	OnShow = function(self)
		-- Pre-populate with current custom frame name if any
		local editBox = _G[self:GetName().."EditBox"]
		local currentName = self.data and self.data.currentName or ""
		if editBox then
			editBox:SetText(currentName)
			editBox:HighlightText()
			editBox:SetFocus()
		end
	end,
	OnAccept = function(self)
		local editBox = _G[self:GetName().."EditBox"]
		local frameName = editBox and editBox:GetText() or ""
		if self.data and self.data.callback then
			self.data.callback(frameName)
		end
	end,
	EditBoxOnEnterPressed = function(editBox)
		local parent = editBox:GetParent()
		local frameName = editBox:GetText()
		if parent.data and parent.data.callback then
			parent.data.callback(frameName)
		end
		parent:Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

---Shows the StaticPopup for entering a custom frame name.
---@param currentName string? # Current custom frame name to pre-populate
---@param callback fun(frameName: string) # Called with the entered frame name on Accept
function TRB.Functions.EditMode:ShowCustomFrameDialog(currentName, callback)
	StaticPopup_Show("TRB_EDIT_MODE_CUSTOM_FRAME", nil, nil, {
		currentName = currentName or "",
		callback = callback,
	})
end
