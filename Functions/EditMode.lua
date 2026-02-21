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

	-- Try to hook the Cooldown Manager resize and show events
	-- This may fail if CDM doesn't exist yet; we'll retry in RegisterPrimaryBar
	self:HookCooldownManagerResize()
	self:HookCooldownManagerShow()
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
		-- Only the primary bar needs border offset: its group.containerFrame is sized to
		-- inner dimensions (border subtracted), so the borderFrame extends beyond it.
		-- Non-primary roots (mana, etc.) use outer dimensions with SetAllPoints — no overhang.
		local rootBorderOffset = 0
		if rootBarKey == "primary" then
			rootBorderOffset = (settings.bar and settings.bar.border) or 0
		end
		rootGroup.containerFrame:ClearAllPoints()
		rootGroup.containerFrame:SetPoint("TOP", wrapperFrame, "TOP", baseOffsetX or 0, -(extendAbove + rootBorderOffset))
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
	local shouldShowSecondary = (currentForm == "cat")
	local shouldShowMana = (currentForm == "moonkin" and TRB.Data.character.specId == 1)

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

	-- DRUID SPECIAL CASE: Druids have form-based bar visibility that's controlled at
	-- runtime by HideResourceBar (not by settings.displayBar.*.visibility).
	-- The bounding box must match this runtime behavior:
	-- - Combo points (secondary): only visible in Cat form (displaySpecId 2)
	-- - Mana bar (custom): only visible in Balance/Moonkin form (displaySpecId 1)
	-- Without matching, the wrapper is the wrong size and creates gaps/offsets.
	--
	-- PER-TREE LOGIC: Only inject/strip bars that belong to the tree rooted at rootBarKey.
	-- In multi-root mode, secondary might be its own root (screen-anchored) or a child
	-- of another tree. We must determine which tree it belongs to before modifying settings.
	local treeSettings = settings
	if TRB.Data.character.classId == 11 and not includeHidden then
		local currentForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
		local shouldIncludeComboPoints = (currentForm == "cat")
		local shouldIncludeMana = (currentForm == "moonkin" and TRB.Data.character.specId == 1)

		local isNonFeralDruid = (TRB.Data.character.specId ~= 2)
		local feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings

		-- Determine which tree "secondary" belongs to, so we only inject/strip when
		-- calculating the bounding box for that specific tree.
		local secondaryRoot = nil
		if shouldIncludeComboPoints and isNonFeralDruid then
			-- Inject case: non-Feral in cat form. Since the current spec has no comboPoints
			-- settings (and thus no anchor), use Feral's anchor to determine secondary's tree.
			-- Walk from Feral's comboPoints anchor target up through the current spec's
			-- anchor chain to find the root.
			if feralSettings and feralSettings.comboPoints then
				local feralAnchor = feralSettings.comboPoints.anchor
				if feralAnchor and feralAnchor.barKey and feralAnchor.barKey ~= "screen" then
					secondaryRoot = findBarKeyRoot(feralAnchor.barKey, settings, barGroups)
				else
					secondaryRoot = "secondary" -- screen-anchored → secondary is its own root
				end
			end
		elseif not shouldIncludeComboPoints and settings.comboPoints then
			-- Strip case: not in cat form, but settings has comboPoints (e.g., Feral spec)
			secondaryRoot = findBarKeyRoot("secondary", settings, barGroups)
		end

		-- Determine which tree "mana" belongs to for mana stripping
		local manaRoot = nil
		if not shouldIncludeMana and settings.bars and settings.bars.mana then
			manaRoot = findBarKeyRoot("mana", settings, barGroups)
		end

		-- Only apply inject/strip for bars that are in THIS tree (rootBarKey)
		local needsComboPointsInject = shouldIncludeComboPoints and isNonFeralDruid and secondaryRoot == rootBarKey
		local needsComboPointsStrip = not shouldIncludeComboPoints and settings.comboPoints and secondaryRoot == rootBarKey
		local needsManaStrip = manaRoot ~= nil and manaRoot == rootBarKey

		if needsComboPointsInject or needsComboPointsStrip or needsManaStrip then
			-- Create a shallow copy of settings so we can modify it without affecting the original
			treeSettings = {}
			for k, v in pairs(settings) do
				treeSettings[k] = v
			end

			-- Copy displayBar so we can override visibility for stripped bars
			local newDisplayBar = {}
			for k, v in pairs(settings.displayBar or {}) do
				newDisplayBar[k] = v
			end
			treeSettings.displayBar = newDisplayBar

			if needsComboPointsInject then
				-- Cat form on non-Feral spec: always use Feral's comboPoints settings
				if feralSettings and feralSettings.comboPoints then
					treeSettings.comboPoints = feralSettings.comboPoints
				end
			elseif needsComboPointsStrip then
				-- Non-Cat form, but settings has comboPoints: strip them
				treeSettings.comboPoints = nil
				newDisplayBar.secondary = { visibility = "never" }
			end

			if needsManaStrip then
				-- Non-Balance form, but settings has mana bar: strip it so it doesn't
				-- inflate the bounding box or shift baseOffsetX
				local newBars = {}
				for k, v in pairs(settings.bars) do
					if k ~= "mana" then
						newBars[k] = v
					end
				end
				treeSettings.bars = newBars
				newDisplayBar.mana = { visibility = "never" }
			end
		end
	elseif TRB.Data.character.classId == 11 and includeHidden then
		-- Edit Mode: always inject Feral's comboPoints for non-Feral specs (so Edit Mode
		-- shows all bars with the correct Feral dimensions, not stale/global values)
		if TRB.Data.character.specId ~= 2 then
			local feralSettings = TRB.Data.specCache and TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings
			if feralSettings and feralSettings.comboPoints then
				treeSettings = {}
				for k, v in pairs(settings) do
					treeSettings[k] = v
				end
				treeSettings.comboPoints = feralSettings.comboPoints
			end
		end
	end

	-- Build anchor forest and select the tree for our root (collapse hidden bars when NOT including them)
	local forest = TRB.Functions.Bar:BuildAnchorForest(treeSettings, barGroups, not includeHidden, includeHidden)
	local rootNode = forest and forest[rootBarKey]
	if not rootNode then
		-- Fallback: if the requested root isn't in the forest, try the old single-tree approach
		-- This handles edge cases where rootBarKey might be inside another tree's subtree
		local fallbackRoot = TRB.Functions.Bar:BuildAnchorTree(treeSettings, barGroups, not includeHidden, includeHidden)
		if fallbackRoot and fallbackRoot.barKey == rootBarKey then
			rootNode = fallbackRoot
		end
		if not rootNode then
			return effectiveWidth, settings.bar.height, 0, 0, 0
		end
	end

	-- Root node dimensions
	-- Use effectiveWidth for all roots (accounts for CDM width matching).
	-- The raw settings width is only a fallback when effectiveWidth isn't available.
	local baseWidth, baseHeight
	if rootBarKey == "primary" then
		baseWidth = effectiveWidth
		baseHeight = settings.bar.height or 0
	else
		local rootBarSettings = rootNode.barSettings
		baseWidth = effectiveWidth
		baseHeight = (rootBarSettings and rootBarSettings.height) or 0
	end

	-- Check if root bar is visible
	if not TRB.Functions.Bar:IsBarVisible(settings, rootBarKey, includeHidden) then
		baseHeight = 0
	end

	-- Coordinate system: X-right positive, Y-up positive, base bar's bottom-left at (0,0)
	local minX, maxX = 0, baseWidth
	local minY, maxY = 0, baseHeight

	-- Helper: get effective size for a bar node, accounting for matchWidth and multi-node layout
	local function getEffectiveBarSize(node, parentWidth)
		local barSettings = node.barSettings
		if not barSettings then
			return node.width or 0, node.height or 0
		end

		local w = barSettings.width or 0
		local h = barSettings.height or 0

		local matchWidth = TRB.Functions.Bar:GetMatchWidth(barSettings)
		if matchWidth then
			w = parentWidth
		elseif node.barKey == "secondary" then
			-- Non-matchWidth secondary bar: calculate total width from node dimensions.
			-- The rendered group width (from BarGroup:ApplyLayout) is exactly:
			--   nodeCount * nodeWidth + (nodeCount - 1) * spacing
			-- Per-node borders are contained WITHIN each nodeWidth and don't add extra width.
			local nodeCount = TRB.Data.character.maxResource2 or 5
			if node.barGroup and node.barGroup.nodeCount then
				nodeCount = node.barGroup.nodeCount
			end
			local nodeWidth = barSettings.width or 10
			local nodeSpacing = barSettings.spacing or 2
			w = (nodeWidth * nodeCount) + (nodeSpacing * (nodeCount - 1))
		end

		-- CDM width matching override: Edit Mode may have CDM width matching enabled
		-- for this bar's root, expanding it beyond the matchWidth/calculated width.
		if node.barKey then
			local cdmMatched = TRB.Functions.EditMode:IsWidthMatchingEnabled(nil, node.barKey)
			if cdmMatched then
				local cdmWidth = TRB.Functions.EditMode:GetCooldownManagerWidth()
				if cdmWidth and cdmWidth > w then
					w = cdmWidth
				end
			end
		end

		return w, h
	end

	-- Recursive function to walk the tree and accumulate bounding box
	local function walkTree(parentNode, parentLeft, parentBottom, parentWidth, parentHeight)
		for _, child in ipairs(parentNode.children) do
			local anchor = child.anchor
			if anchor then
				local childWidth, childHeight = getEffectiveBarSize(child, parentWidth)
				if childWidth > 0 and childHeight > 0 then
					local anchorPt = anchor.anchorPoint or "TOP"
					local attachPt = anchor.attachPoint or "BOTTOM"
					local xOffset = anchor.xOffset or 0
					local yOffset = anchor.yOffset or 0
					local matchWidth = child.barSettings and TRB.Functions.Bar:GetMatchWidth(child.barSettings)

					-- Apply matchWidth center-alignment override (matching ConstructAnchoredBarGroup)
					if matchWidth then
						-- Strip horizontal component to force center alignment, preserve vertical
						anchorPt = string.gsub(anchorPt, "LEFT", "")
						anchorPt = string.gsub(anchorPt, "RIGHT", "")
						attachPt = string.gsub(attachPt, "LEFT", "")
						attachPt = string.gsub(attachPt, "RIGHT", "")
						if anchorPt == "" then anchorPt = "CENTER" end
						if attachPt == "" then attachPt = "CENTER" end
						xOffset = 0
					end

					-- Calculate anchor point position on parent (Y-up, origin=parent bottom-left)
					local apX, apY = TRB.Functions.Bar:CalculateAnchorPointOffset(parentWidth, parentHeight, anchorPt)
					-- Calculate attach point position on child
					local atX, atY = TRB.Functions.Bar:CalculateAnchorPointOffset(childWidth, childHeight, attachPt)

					-- Child's bottom-left in global coords
					local childLeft = parentLeft + apX + xOffset - atX
					local childBottom = parentBottom + apY + yOffset - atY

					-- Update bounding box
					minX = math.min(minX, childLeft)
					maxX = math.max(maxX, childLeft + childWidth)
					minY = math.min(minY, childBottom)
					maxY = math.max(maxY, childBottom + childHeight)

					-- Recurse into this child's children
					walkTree(child, childLeft, childBottom, childWidth, childHeight)
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

---Registers the primary bar with Edit Mode using a wrapper frame (legacy wrapper)
---The wrapper becomes the parent of the primary bar container
---@param containerFrame Frame # The primary bar's container frame
function TRB.Functions.EditMode:RegisterPrimaryBar(containerFrame)
	self:RegisterTreeRoot("primary", containerFrame)
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
		if enableFormSwitching then
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

---Gets a display name for a wrapper (for Edit Mode overlay title)
---@param rootBarKey string
---@return string
function TRB.Functions.EditMode:GetWrapperDisplayName(rootBarKey)
	local barDisplayName = TRB.Functions.Bar:GetBarDisplayName(rootBarKey)
	return L["TRBAddonName"] .. " - " .. barDisplayName
end

---Adds Edit Mode frame settings (checkbox, dropdown, slider) for a specific tree root wrapper.
---@param wrapperFrame Frame
---@param rootBarKey string
function TRB.Functions.EditMode:AddFrameSettingsForRoot(wrapperFrame, rootBarKey)
	LibEditMode:AddFrameSettings(wrapperFrame, {
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
						-- No position saved yet - capture current WRAPPER position
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
								-- Fallback to legacy settings if normalization fails
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

				-- Reapply position when toggling
				if TRB.Frames.barGroups and TRB.Data.specCache and TRB.Data.character.compositeKey then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.compositeKey].settings,
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
				return self:GetAnchorModeRaw(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetAnchorMode(layoutName, newValue, rootBarKey)

				-- Reapply position when changing anchor mode
				if TRB.Frames.barGroups and TRB.Data.specCache and TRB.Data.character.compositeKey then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.compositeKey].settings,
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
				return self:GetAnchorOffset(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetAnchorOffset(layoutName, newValue, rootBarKey)

				-- Reapply position when changing offset
				if TRB.Frames.barGroups and TRB.Data.specCache and TRB.Data.character.compositeKey then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.compositeKey].settings,
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
				return self:IsWidthMatchingEnabledRaw(layoutName, rootBarKey)
			end,
			set = function(layoutName, newValue, fromReset)
				self:SetWidthMatchingEnabled(layoutName, newValue, rootBarKey)

				-- Reapply layout when toggling width matching
				if TRB.Frames.barGroups and TRB.Data.specCache and TRB.Data.character.compositeKey then
					TRB.Functions.Bar:ApplyBarGroupsLayout(
						TRB.Data.specCache[TRB.Data.character.compositeKey].settings,
						TRB.Frames.barGroups
					)
				end
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

	-- Check if we're using CDM anchoring for this root - if so, ignore position changes
	local anchorMode = self:GetAnchorMode(layoutName, rootBarKey)
	if anchorMode ~= "none" and self:IsCooldownManagerAvailable() then
		-- CDM anchored - revert to CDM position instead of saving
		if TRB.Frames.barGroups then
			local specSettings = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey]
			if specSettings and specSettings.settings then
				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
			end
		end
		return
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

		-- Let HideResourceBar determine if the bar should be visible now
		TRB.Functions.Class:HideResourceBar()
	end
end

---Ensures the layout settings structure exists for a given layout and root bar.
---Performs backward-compatible migration from the old flat structure to the new
---per-root structure: layouts[name].bars[rootBarKey] = { enabled, position, ... }
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

	-- Migration: if old flat format exists (has 'enabled' at root level), migrate to 'bars.primary'
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

	-- Ensure per-root entry exists
	if not layoutData.bars[rootBarKey] then
		layoutData.bars[rootBarKey] = {
			enabled = false,
			position = nil,
			anchorToCooldownManager = "none",
			anchorOffset = 0,
			matchCooldownManagerWidth = false,
		}
	end

	-- Ensure all fields exist for this root (field-level migration)
	local barData = layoutData.bars[rootBarKey]
	if barData.anchorToCooldownManager == nil then
		barData.anchorToCooldownManager = "none"
	end
	if barData.anchorOffset == nil then
		barData.anchorOffset = 0
	end
	if barData.matchCooldownManagerWidth == nil then
		barData.matchCooldownManagerWidth = false
	end
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
	if not layoutData or not layoutData.bars then
		return
	end

	-- Check if any root bar uses CDM width matching or anchoring
	local anyCdmUsage = false
	for _, barData in pairs(layoutData.bars) do
		if barData.enabled and (barData.matchCooldownManagerWidth or (barData.anchorToCooldownManager and barData.anchorToCooldownManager ~= "none")) then
			anyCdmUsage = true
			break
		end
	end

	if anyCdmUsage then
		-- Reapply bar layout to update width/position
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary and TRB.Data.specCache and TRB.Data.character.specName then
			local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
			if specSettings and specSettings.settings then
				-- Skip layout update if width hasn't changed (avoids flickering)
				if not forceUpdate then
					local currentEffectiveWidth = TRB.Frames.barGroups.effectiveWidth
					local cdmWidth = TRB.Functions.EditMode:GetCooldownManagerWidth()
					if currentEffectiveWidth and cdmWidth and math.abs(currentEffectiveWidth - cdmWidth) < 1 then
						return
					end
				end

				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, TRB.Frames.barGroups)
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

---Gets the anchor mode for the current layout for a specific root
---This returns the EFFECTIVE anchor mode (for bar positioning)
---Returns "none" if layout is not enabled
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # "none", "above", or "below"
function TRB.Functions.EditMode:GetAnchorMode(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	-- If Edit Mode layout is not enabled for this root, anchor mode is always "none"
	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		return "none"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchorToCooldownManager) or "none"
end

---Gets the RAW saved anchor mode for the current layout (for UI display)
---This returns the actual saved value regardless of whether layout is enabled
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return string # "none", "above", or "below"
function TRB.Functions.EditMode:GetAnchorModeRaw(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return "none"
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchorToCooldownManager) or "none"
end

---Sets the anchor mode for a layout for a specific root
---@param layoutName string # The layout name
---@param mode string # "none", "above", or "below"
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAnchorMode(layoutName, mode, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchorToCooldownManager = mode
end

---Gets the anchor offset for the current layout for a specific root
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return number # The vertical offset in pixels
function TRB.Functions.EditMode:GetAnchorOffset(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		return 0
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return (barData and barData.anchorOffset) or 0
end

---Sets the anchor offset for a layout for a specific root
---@param layoutName string # The layout name
---@param offset number # The vertical offset in pixels
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetAnchorOffset(layoutName, offset, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].anchorOffset = offset
end

---Gets whether width matching is enabled for the current layout for a specific root
---This returns the EFFECTIVE value (for bar positioning)
---Returns false if layout is not enabled or anchor mode is "none"
---@param layoutName string? # The layout name (uses active layout if nil)
---@param rootBarKey string? # The root bar key (defaults to "primary")
---@return boolean # True if width matching is enabled
function TRB.Functions.EditMode:IsWidthMatchingEnabled(layoutName, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	layoutName = layoutName or (LibEditMode and LibEditMode:GetActiveLayoutName())
	if not layoutName then
		-- LibEditMode hasn't initialized yet or no active layout
		-- During early initialization, we need to check if width matching MIGHT apply
		-- by looking at all saved layouts. If any enabled layout has width matching
		-- and we're anchored to CDM, assume we should try to match width.
		-- This prevents the bar from flashing to settings.bar.width during init.
		if TRB.Data.settings.core.editMode and TRB.Data.settings.core.editMode.layouts then
			for _, layoutData in pairs(TRB.Data.settings.core.editMode.layouts) do
				-- Check per-root settings
				if layoutData.bars and layoutData.bars[rootBarKey] then
					local barData = layoutData.bars[rootBarKey]
					if barData.enabled and
					   barData.matchCooldownManagerWidth and
					   barData.anchorToCooldownManager and
					   barData.anchorToCooldownManager ~= "none" then
						if self:IsCooldownManagerAvailable() then
							return true
						end
						break
					end
				end
			end
		end
		return false
	end

	-- Width matching only applies when:
	-- 1. Edit Mode layout is enabled for this root
	-- 2. Anchor mode is not "none" (actually anchored to CDM)
	if not self:IsLayoutEnabled(layoutName, rootBarKey) then
		return false
	end

	local anchorMode = self:GetAnchorMode(layoutName, rootBarKey)
	if anchorMode == "none" then
		return false
	end

	local barData = self:GetLayoutBarSettings(layoutName, rootBarKey)
	return barData and barData.matchCooldownManagerWidth == true
end

---Gets the RAW saved width matching setting (for UI display)
---This returns the actual saved value regardless of whether layout/anchor is enabled
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
	return barData and barData.matchCooldownManagerWidth == true
end

---Sets whether width matching is enabled for a layout for a specific root
---@param layoutName string # The layout name
---@param enabled boolean # Whether to enable width matching
---@param rootBarKey string? # The root bar key (defaults to "primary")
function TRB.Functions.EditMode:SetWidthMatchingEnabled(layoutName, enabled, rootBarKey)
	rootBarKey = rootBarKey or "primary"
	self:EnsureLayoutSettings(layoutName, rootBarKey)
	TRB.Data.settings.core.editMode.layouts[layoutName].bars[rootBarKey].matchCooldownManagerWidth = enabled
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
