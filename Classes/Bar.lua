---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

-- Monotonic counter for globally unique BarNode frame names.
-- Prevents WoW's CreateFrame from returning a stale frame when called with a
-- global name that still exists in _G from a previous BarNode:Destroy() cycle.
local barNodeCounter = 0

--[[
	BarNode: The atomic unit of the bar system.
	Represents a single StatusBar with its container frame, border frame, resource frame, and thresholds.
	This is the building block for both primary bars (N=1) and secondary "combo point" bars (N>1).
]]

---@class TRB.Classes.BarNode
---@field public frame StatusBar # The single consolidated StatusBar frame
---@field public overlaySlots table<string, TRB.Classes.OverlaySlot> # Named overlay slots keyed by slot name
---@field public thresholds Frame[]
---@field public index integer
---@field public name string
---@field public width number
---@field public height number
---@field public border number
---@field public isVisible boolean
---@field public smooth boolean?
---@field public borderTexture string? # Stored border texture path for toggling edge visibility
TRB.Classes.BarNode = {}
TRB.Classes.BarNode.__index = TRB.Classes.BarNode

---Creates a new BarNode
---@param parent Frame # The parent frame to attach this node to
---@param name string # Base name for the frame
---@param index integer # Index of this node within its group (1-based)
---@return TRB.Classes.BarNode
function TRB.Classes.BarNode:New(parent, name, index)
	local self = {}
	setmetatable(self, TRB.Classes.BarNode)

	self.index = index or 1
	self.name = name or "TwintopResourceBarFrame"

	-- Include index in name for unique cache keys when index > 0
	if index and index > 0 then
		self.name = self.name .. "_" .. index
	end

	-- Append a monotonic counter to guarantee a globally unique frame name.
	-- Without this, CreateFrame can return a stale frame object from _G when
	-- a previous BarNode with the same base name was destroyed but its global
	-- name entry was not cleared (WoW does not remove _G entries on SetParent(nil)).
	barNodeCounter = barNodeCounter + 1
	local uniqueFrameName = self.name .. "_v" .. barNodeCounter

	self.thresholds = {}
	self.width = 100
	self.height = 20
	self.border = 2
	self.isVisible = false
	self.smooth = nil
	self.borderTexture = nil
	self.overlaySlots = {}

	-- Create a single consolidated StatusBar frame
	self.frame = CreateFrame("StatusBar", uniqueFrameName, parent, "BackdropTemplate")
	self.frame:SetFrameStrata("BACKGROUND")
	-- Hide by default - nodes should only be shown explicitly
	self.frame:Hide()

	-- Initialize the frame's thresholds array for compatibility
---@diagnostic disable-next-line: inject-field
	self.frame.thresholds = self.thresholds

	return self
end

---Sets the value of the StatusBar
---@param value number # The current value
---@param smooth boolean? # Whether to use smooth animation (default: uses node's smooth setting)
function TRB.Classes.BarNode:SetValue(value, smooth)
	if smooth == nil then
		smooth = self.smooth or false
	end

	if smooth then
---@diagnostic disable-next-line: redundant-parameter
		self.frame:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut)
	else
---@diagnostic disable-next-line: redundant-parameter
		self.frame:SetValue(value, Enum.StatusBarInterpolation.Immediate)
	end
end

---Sets the StatusBar value using a DurationObject for secret-safe animation.
---The StatusBar will automatically animate based on the DurationObject's internal timing.
---@param durationObject any # A DurationObject from C_Spell.GetSpellChargeDuration() or similar
---@param interpolation any? # Enum.StatusBarInterpolation value (default: Immediate)
---@param direction any? # Enum.StatusBarTimerDirection value (default: ElapsedTime)
function TRB.Classes.BarNode:SetTimerDuration(durationObject, interpolation, direction)
	if durationObject == nil then return end
	interpolation = interpolation or Enum.StatusBarInterpolation.Immediate
	direction = direction or Enum.StatusBarTimerDirection.ElapsedTime
	self.frame:SetTimerDuration(durationObject, interpolation, direction)
	self.hasTimerDuration = true
end

---Clears any active DurationObject-driven animation, restoring normal SetValue behavior.
---Hides and re-shows the StatusBar to force WoW to drop the timer binding.
function TRB.Classes.BarNode:ClearTimerDuration()
	if self.hasTimerDuration then
		local shouldRestoreVisibility = self.isVisible
		self.frame:Hide()
		self.frame:SetMinMaxValues(0, 1)
		self.frame:SetValue(0)
		if shouldRestoreVisibility then
			self.frame:Show()
		end
		self.hasTimerDuration = false
	end
end

---Sets the minimum and maximum values for the StatusBar
---@param min number
---@param max number
function TRB.Classes.BarNode:SetMinMax(min, max)
	self.frame:SetMinMaxValues(min, max)
end

---Gets the current min/max values
---@return number min
---@return number max
function TRB.Classes.BarNode:GetMinMax()
	return self.frame:GetMinMaxValues()
end

---Sets the color of the resource bar
---@param colorString string # ARGB hex color string (e.g., "FFFF0000" for red)
function TRB.Classes.BarNode:SetColor(colorString)
	TRB.Functions.Color:SetStatusBarColorFromRGBAString(self.frame, self.name .. "_resource", colorString)
end

---Sets the color of the resource bar
---@diagnostic disable-next-line: undefined-doc-name
---@param colorResult LuaCurveEvaluatedResult
function TRB.Classes.BarNode:SetColorCurve(colorResult)
	if colorResult == nil or type(colorResult.GetRGBA) ~= "function" then
		return
	end
	local texture = self.frame:GetStatusBarTexture()
	if texture then
		texture:SetVertexColor(colorResult:GetRGBA())
	end
end

---Sets the border color
---@param colorString string # ARGB hex color string
function TRB.Classes.BarNode:SetBorderColor(colorString)
	TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(self.frame, self.name .. "_border", colorString)
end

---Sets the border color from a curve result
---@diagnostic disable-next-line: undefined-doc-name
---@param colorResult LuaCurveEvaluatedResult
function TRB.Classes.BarNode:SetBorderColorCurve(colorResult)
	if colorResult == nil or type(colorResult.GetRGBA) ~= "function" then
		return
	end
	TRB.Data.cache.colors.border[self.name .. "_border"] = nil
	self.frame:SetBackdropBorderColor(colorResult:GetRGBA())
end

---Sets the background color
---@param r number # Red (0-1)
---@param g number # Green (0-1)
---@param b number # Blue (0-1)
---@param a number # Alpha (0-1)
function TRB.Classes.BarNode:SetBackgroundColor(r, g, b, a)
	TRB.Functions.Color:SetBackdropColor(self.frame, self.name .. "_background", r, g, b, a)
end

---Sets the background color from a color string
---@param colorString string # ARGB hex color string
function TRB.Classes.BarNode:SetBackgroundColorFromString(colorString)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	self:SetBackgroundColor(r, g, b, a)
end

---Sets the dimensions of the node
---@param width number # Outer width (including border)
---@param height number # Outer height (including border)
---@param border number?
function TRB.Classes.BarNode:SetDimensions(width, height, border)
	self.width = width
	self.height = height
	local borderChanged = border ~= nil and border ~= self.border
	if border then
		self.border = border
	end

	-- Single frame uses outer dimensions
	self.frame:SetWidth(width)
	self.frame:SetHeight(height)

	-- Re-anchor all overlay slots
	for _, slot in pairs(self.overlaySlots) do
		slot:Reanchor()
	end

	-- Update the backdrop edgeSize when border changes
	if borderChanged and self.frame.backdropInfo then
		if self.border < 1 then
			-- No border: remove edge from backdrop entirely
			self.frame.backdropInfo.edgeFile = nil
			self.frame.backdropInfo.edgeSize = 0
		else
			-- Restore edge with stored texture path
			self.frame.backdropInfo.edgeFile = self.borderTexture
			self.frame.backdropInfo.edgeSize = self.border
		end
		self.frame.backdropInfo.insets = { left = self.border, right = self.border, top = self.border, bottom = self.border }
		self.frame:ApplyBackdrop()
		-- Restore cached border color after ApplyBackdrop resets it
		local borderCacheKey = self.name .. "_border"
		local cachedColor = TRB.Data.cache.colors.border[borderCacheKey]
		if cachedColor then
			self.frame:SetBackdropBorderColor(cachedColor.r, cachedColor.g, cachedColor.b, cachedColor.a)
		end
		-- Restore cached background color after ApplyBackdrop resets it
		local bgCacheKey = self.name .. "_background"
		local cachedBgColor = TRB.Data.cache.colors.backdrop[bgCacheKey]
		if cachedBgColor then
			self.frame:SetBackdropColor(cachedBgColor.r, cachedBgColor.g, cachedBgColor.b, cachedBgColor.a)
		end
	end
end

---Sets the border size
---@param size number
function TRB.Classes.BarNode:SetBorderSize(size)
	self.border = size
	self:SetDimensions(self.width, self.height, size)
end

---Sets the textures for all frame components
---@param resourceTexture string # Path to the resource bar texture
---@param borderTexture string # Path to the border texture
---@param backgroundTexture string # Path to the background texture
function TRB.Classes.BarNode:SetTextures(resourceTexture, borderTexture, backgroundTexture)
	-- Store border texture for later use in SetDimensions when toggling border
	self.borderTexture = borderTexture

	-- Set resource bar (StatusBar fill) texture
	self.frame:SetStatusBarTexture(resourceTexture)
	-- Lower the fill texture to BORDER,-1 so it draws above the backdrop background
	-- (BACKGROUND,0) but below the backdrop edge/border (BORDER,0).
	local fillTexture = self.frame:GetStatusBarTexture()
	if fillTexture then
		fillTexture:SetDrawLayer("BORDER", -1)
	end

	-- Configure unified backdrop: bgFile for background, edgeFile for border
	local edgeFile = nil
	local edgeSize = 0
	if self.border >= 1 then
		edgeFile = borderTexture
		edgeSize = self.border
	end

---@diagnostic disable-next-line: inject-field
	self.frame.backdropInfo = {
		bgFile = backgroundTexture,
		edgeFile = edgeFile,
		tile = true,
		tileSize = self.width,
		edgeSize = edgeSize,
		insets = { left = self.border, right = self.border, top = self.border, bottom = self.border }
	}
	self.frame:ApplyBackdrop()

	-- ApplyBackdrop resets border/background colors to white, and SetStatusBarTexture may
	-- reset the fill vertex color. Invalidate color caches so the next SetColor/SetBorderColor/
	-- SetBackgroundColor calls aren't skipped as no-ops.
	TRB.Data.cache.colors.bar[self.name .. "_resource"] = nil
	TRB.Data.cache.colors.border[self.name .. "_border"] = nil
	TRB.Data.cache.colors.backdrop[self.name .. "_background"] = nil

	-- Re-anchor all overlay slots (border insets and fill texture reference may have changed)
	for _, slot in pairs(self.overlaySlots) do
		slot:Reanchor()
	end
end

---Returns the OverlaySlot for the given name, creating it if it doesn't exist.
---@param slotName string # The unique name of the overlay slot (e.g., "casting", "absorb")
---@return TRB.Classes.OverlaySlot
function TRB.Classes.BarNode:GetOrCreateOverlaySlot(slotName)
	if not self.overlaySlots[slotName] then
		self.overlaySlots[slotName] = TRB.Classes.OverlaySlot:New(self, slotName)
	end
	return self.overlaySlots[slotName]
end

---Returns the OverlaySlot for the given name, or nil if it doesn't exist.
---@param slotName string
---@return TRB.Classes.OverlaySlot?
function TRB.Classes.BarNode:GetOverlaySlot(slotName)
	return self.overlaySlots[slotName]
end

---Sets the frame level for the node
---@param level integer
function TRB.Classes.BarNode:SetFrameLevel(level)
	self.frame:SetFrameLevel(level)
end

---Sets the frame strata for the node
---@param strata string
function TRB.Classes.BarNode:SetFrameStrata(strata)
	self.frame:SetFrameStrata(strata)
end

---Sets the node's alpha transparency
---@param alpha number
function TRB.Classes.BarNode:SetAlpha(alpha)
	self.frame:SetAlpha(alpha)
end

---Shows the node. Alpha is managed by the parent BarGroup's visibility/fade system.
function TRB.Classes.BarNode:Show()
	self.frame:Show()
	self.isVisible = true
end

---Hides the node
function TRB.Classes.BarNode:Hide()
	self.frame:Hide()
	self.isVisible = false
end

---Destroys the node by hiding all frames and clearing references
---Call this before discarding the node to ensure frames are cleaned up
function TRB.Classes.BarNode:Destroy()
	self:Hide()
	self:ClearThresholds()
	-- Clear the global name reference so CreateFrame won't return this stale frame
	local frameName = self.frame:GetName()
	if frameName and _G[frameName] == self.frame then
		_G[frameName] = nil
	end
	self.frame:SetParent(nil)
	self.frame:ClearAllPoints()
end

---Returns the frame (resource, container, and border are all the same frame now)
---@return StatusBar
function TRB.Classes.BarNode:GetFrame()
	return self.frame
end

---Registers a threshold frame with this node, or creates one at the specified index
---@param thresholdFrameOrIndex Frame|integer # Either a Frame to register, or an index to create a new threshold at
---@return Frame # The registered or created threshold frame
function TRB.Classes.BarNode:RegisterThreshold(thresholdFrameOrIndex)
	local thresholdFrame
	local index

	if type(thresholdFrameOrIndex) == "number" then
		-- Create a new threshold frame at the specified index
		index = thresholdFrameOrIndex
		if self.thresholds[index] then
			return self.thresholds[index]
		end
		thresholdFrame = CreateFrame("Frame", nil, self.frame)
	else
		-- Use the provided frame
		thresholdFrame = thresholdFrameOrIndex
		index = #self.thresholds + 1
	end

	self.thresholds[index] = thresholdFrame
	-- Keep frame.thresholds in sync for compatibility
---@diagnostic disable-next-line: inject-field
	self.frame.thresholds = self.thresholds
	return thresholdFrame
end

---Clears all registered thresholds
function TRB.Classes.BarNode:ClearThresholds()
	for i, threshold in pairs(self.thresholds) do
		if threshold and type(threshold) ~= "number" and threshold.Hide then
			threshold:Hide()
		end
	end
	self.thresholds = {}
---@diagnostic disable-next-line: inject-field
	self.frame.thresholds = self.thresholds
end

---Gets all registered thresholds
---@return Frame[]
function TRB.Classes.BarNode:GetThresholds()
	return self.thresholds
end

--[[
	BarGroup: A container for 1 or more BarNode instances.
	Manages layout, positioning, and bulk operations across all nodes.
	
	For a primary resource bar, this would contain 1 node.
	For combo points/arcane charges, this would contain N nodes (e.g., 4 for Arcane Charges).
]]

---@class TRB.Classes.BarGroup
---@field public containerFrame Frame
---@field public nodes TRB.Classes.BarNode[]
---@field public nodeCount integer
---@field public maxNodes integer
---@field public name string
---@field public spacing number
---@field public fullWidth boolean
---@field public orientation string
---@field public isVisible boolean
---@field public isPrimary boolean
---@field public targetAlpha number # Target alpha from visibility system (0.0–1.0)
---@field public currentAlpha number # Current interpolated alpha (0.0–1.0)
---@field public lastAlphaTime number # GetTime() of last fade interpolation step
---@field public fadeDuration number # Seconds for fade transition (0 = instant)
---@field public fadeStartAlpha number # Alpha at the moment a fade began (used for normalized progress)
---@field public fadeDelayUntil number # GetTime() timestamp when the fade delay expires (0 = no delay active)
TRB.Classes.BarGroup = {}
TRB.Classes.BarGroup.__index = TRB.Classes.BarGroup

---Creates a new BarGroup
---@param parent Frame # The parent frame
---@param name string # Base name for the group and its nodes
---@param maxNodes integer # Maximum number of nodes this group can have
---@param isPrimary boolean? # Whether this is the primary (main) bar group
---@return TRB.Classes.BarGroup
function TRB.Classes.BarGroup:New(parent, name, maxNodes, isPrimary)
	local self = {}
	setmetatable(self, TRB.Classes.BarGroup)

	self.name = name or "TwintopResourceBarFrame"
	self.maxNodes = maxNodes or 1
	self.nodeCount = self.maxNodes
	self.nodes = {}
	self.spacing = 0
	self.fullWidth = false
	self.orientation = "HORIZONTAL"
	self.isVisible = false
	self.isPrimary = isPrimary or false
	self.smooth = nil
	self.targetAlpha = 0
	self.currentAlpha = 0
	self.lastAlphaTime = GetTime()
	self.fadeDuration = 0
	self.fadeStartAlpha = 0
	self.fadeDelayUntil = 0

	-- Create container frame for the group
	local containerName = self.name
	if not isPrimary then
		containerName = self.name .. "_Group"
	end
	self.containerFrame = CreateFrame("Frame", containerName, parent, "BackdropTemplate")
	self.containerFrame:SetFrameStrata("BACKGROUND")
	-- Hide the container by default - bars should only be shown explicitly
	self.containerFrame:Hide()

	-- Create all nodes upfront
	for i = 1, self.maxNodes do
		local nodeName = self.name
		if self.maxNodes > 1 then
			-- For multi-node groups, use indexed naming
			nodeName = self.name .. "_Node"
		end
		self.nodes[i] = TRB.Classes.BarNode:New(self.containerFrame, nodeName, self.maxNodes > 1 and i or 0)
	end

	return self
end

---Sets how many nodes should be active/visible
---@param count integer
function TRB.Classes.BarGroup:SetNodeCount(count)
	self.nodeCount = math.min(count, self.maxNodes)
end

---Dynamically adjusts the maximum number of nodes in the group.
---Creates new nodes if needed, hides extras if shrinking.
---@param newMaxNodes integer # The new maximum number of nodes
function TRB.Classes.BarGroup:SetMaxNodes(newMaxNodes)
	if newMaxNodes == self.maxNodes then
		return
	end

	if newMaxNodes > self.maxNodes then
		-- Create additional nodes
		for i = self.maxNodes + 1, newMaxNodes do
			local nodeName = self.name
			if newMaxNodes > 1 then
				nodeName = self.name .. "_Node"
			end
			self.nodes[i] = TRB.Classes.BarNode:New(self.containerFrame, nodeName, i)
			-- Propagate smooth setting to newly created nodes
			if self.smooth ~= nil then
				self.nodes[i].smooth = self.smooth
			end
		end
	else
		-- Hide and optionally destroy extra nodes
		for i = newMaxNodes + 1, self.maxNodes do
			if self.nodes[i] then
				self.nodes[i]:Hide()
			end
		end
	end

	self.maxNodes = newMaxNodes
	-- Adjust nodeCount if it exceeds the new max
	if self.nodeCount > self.maxNodes then
		self.nodeCount = self.maxNodes
	end
end

---Sets the smooth animation setting for all nodes in this group
---@param smooth boolean # Whether to use smooth animation
function TRB.Classes.BarGroup:SetSmooth(smooth)
	self.smooth = smooth
	for _, node in ipairs(self.nodes) do
		node.smooth = smooth
	end
end

---Gets a node by index
---@param index integer
---@return TRB.Classes.BarNode?
function TRB.Classes.BarGroup:GetNode(index)
	return self.nodes[index]
end

---Gets the current node count
---@return integer
function TRB.Classes.BarGroup:GetNodeCount()
	return self.nodeCount
end


---Gets the frame that other bars should anchor to.
---For single-node groups (primary, health, etc.), returns the node's frame,
---which represents the full visual extent including borders.
---For multi-node groups (combo points, defensives, etc.), returns the group container,
---which already encompasses all nodes at full visual extent.
---@return Frame
function TRB.Classes.BarGroup:GetAnchorFrame()
	if self.maxNodes == 1 then
		local node = self.nodes[1]
		if node then
			return node:GetFrame()
		end
	end
	return self.containerFrame
end

---Sets the alpha of the group container and all nodes
---@param alpha number
function TRB.Classes.BarGroup:SetAlpha(alpha)
	self.containerFrame:SetAlpha(alpha)
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:SetAlpha(alpha)
		end
	end
end

---Gets all nodes
---@return TRB.Classes.BarNode[]
function TRB.Classes.BarGroup:GetNodes()
	return self.nodes
end

---Sets the position of the group container
---@param xPos number
---@param yPos number
---@param relativeTo Frame?
---@param relativePoint string?
function TRB.Classes.BarGroup:SetPosition(xPos, yPos, relativeTo, relativePoint)
	self.containerFrame:ClearAllPoints()
	if relativeTo then
		self.containerFrame:SetPoint(relativePoint or "CENTER", relativeTo, relativePoint or "CENTER", xPos, yPos)
	else
		self.containerFrame:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
	end
end

---Sets the layout parameters for multi-node groups
---@param spacing number # Space between nodes
---@param fullWidth boolean # Whether nodes should stretch to fill the width
---@param orientation string? # "HORIZONTAL" or "VERTICAL"
function TRB.Classes.BarGroup:SetLayout(spacing, fullWidth, orientation)
	self.spacing = spacing or 0
	self.fullWidth = fullWidth or false
	self.orientation = orientation or "HORIZONTAL"
end

---Sets dimensions for all nodes in the group
---@param width number
---@param height number
---@param border number?
function TRB.Classes.BarGroup:SetDimensions(width, height, border)
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:SetDimensions(width, height, border)
		end
	end
end

---Sets the same color for all nodes
---@param baseColor string
---@param borderColor string
---@param backgroundColor string
function TRB.Classes.BarGroup:SetAllNodeColors(baseColor, borderColor, backgroundColor)
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:SetColor(baseColor)
			self.nodes[i]:SetBorderColor(borderColor)
			self.nodes[i]:SetBackgroundColorFromString(backgroundColor)
		end
	end
end

---Sets the same textures for all nodes
---@param barTexture string
---@param borderTexture string
---@param bgTexture string
function TRB.Classes.BarGroup:SetAllNodeTextures(barTexture, borderTexture, bgTexture)
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:SetTextures(barTexture, borderTexture, bgTexture)
		end
	end
end

---Sets frame strata for all nodes
---@param strata string
function TRB.Classes.BarGroup:SetFrameStrata(strata)
	self.containerFrame:SetFrameStrata(strata)
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:SetFrameStrata(strata)
		end
	end
end

---Shows nodes up to the specified count
---@param count integer?
function TRB.Classes.BarGroup:ShowNodes(count)
	count = count or self.nodeCount
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			if i <= count then
				self.nodes[i]:Show()
			else
				self.nodes[i]:Hide()
			end
		end
	end
end

---Rebuilds the bar group with a specific number of display nodes.
---Handles node count, layout, textures, and visibility in one call.
---@param displayNodes integer # Number of nodes to display
---@param settings table # Settings table containing bar, comboPoints, textures, and colors subtables
function TRB.Classes.BarGroup:RebuildNodes(displayNodes, settings)
	if settings == nil or settings.comboPoints == nil or settings.bar == nil then
		return
	end

	-- Store the display node count so ApplyBarGroupsLayout respects compressed view
	-- when it runs from delayed timers
	self.lastRebuildNodeCount = displayNodes

	-- Set node count and apply layout
	self:SetNodeCount(displayNodes)
	self:SetLayout(TRB.Functions.Bar:GetEffectiveSpacing(settings.comboPoints), TRB.Functions.Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
	self:Show()

	-- Use effectiveWidth (CDM-matched) if available, otherwise fall back to settings.bar.width
	local barGroups = TRB.Frames.barGroups
	local effectiveWidth = (barGroups and barGroups.effectiveWidth) or settings.bar.width

	-- Apply layout to position all nodes correctly
	self:ApplyLayout(
		effectiveWidth,
		settings.comboPoints.width,
		settings.comboPoints.height,
		settings.comboPoints.border
	)

	-- Show/hide nodes and set up textures
	local frameLevels = TRB.Data.constants.frameLevels
	for i = 1, displayNodes do
		local node = self:GetNode(i)
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
				settings.textures.comboPointsBar,
				settings.textures.comboPointsBorder,
				settings.textures.comboPointsBackground
			)
			node:SetMinMax(0, 1)
			node:SetBorderColor(settings.colors.comboPoints.border.color)
			node:SetBackgroundColorFromString(settings.colors.comboPoints.background.color)
			node:SetColor(settings.colors.comboPoints.base.color)
			node:SetFrameLevel(frameLevels.comboPoint)
			node:Show()
		end
	end

	-- Hide any extra nodes beyond displayNodes
	for i = displayNodes + 1, self.maxNodes do
		local node = self:GetNode(i)
		if node then
			node:Hide()
		end
	end
end

---Hides all nodes
function TRB.Classes.BarGroup:HideAllNodes()
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:Hide()
		end
	end
end

---Shows the group container. Alpha is managed by the visibility/fade system, not here.
function TRB.Classes.BarGroup:Show()
	self.containerFrame:Show()
	self.isVisible = true
end

---Hides the group container (fully hidden, alpha irrelevant)
function TRB.Classes.BarGroup:Hide()
	self.containerFrame:Hide()
	self.isVisible = false
end

---Sets the target alpha and fade duration for the visibility fade system.
---@param target number # Target alpha (0.0–1.0)
---@param duration number # Seconds for the fade transition (0 = instant snap)
---@param delay number? # Seconds to wait before starting the fade (default 0)
function TRB.Classes.BarGroup:SetTargetAlpha(target, duration, delay)
	if self.targetAlpha == target then
		return
	end
	self.targetAlpha = target
	self.fadeDuration = duration or 0
	self.fadeStartAlpha = self.currentAlpha
	local now = GetTime()
	local fadeDelay = delay or 0
	if fadeDelay > 0 then
		self.fadeDelayUntil = now + fadeDelay
	else
		self.fadeDelayUntil = 0
	end
	self.lastAlphaTime = now
end

---Interpolates currentAlpha toward targetAlpha based on elapsed time.
---Respects fadeDelayUntil: while the current time is before that timestamp,
---the fade has not yet started but we report as still fading (in-progress).
---@return number currentAlpha # The current interpolated alpha
---@return boolean fading # true if the fade is still in progress
function TRB.Classes.BarGroup:UpdateFade()
	if self.currentAlpha == self.targetAlpha then
		return self.currentAlpha, false
	end

	local now = GetTime()

	-- Respect fade delay: don't start fading until delay expires
	if self.fadeDelayUntil > 0 and now < self.fadeDelayUntil then
		self.lastAlphaTime = now
		return self.currentAlpha, true -- still "fading" (waiting)
	end
	-- Clear the delay once expired
	if self.fadeDelayUntil > 0 then
		self.fadeDelayUntil = 0
	end

	local duration = self.fadeDuration or 0

	if duration <= 0 then
		-- Instant snap
		self.currentAlpha = self.targetAlpha
		self.lastAlphaTime = now
		return self.currentAlpha, false
	end

	local elapsed = now - self.lastAlphaTime

	if elapsed <= 0 then
		return self.currentAlpha, true
	end

	-- Normalized linear interpolation: progress is elapsed / duration over the
	-- start→target range, so fadeDuration is always the total transition time
	-- regardless of the alpha delta (e.g. 1.0→0.5 takes the same time as 1.0→0.0).
	local progress = math.min(elapsed / duration, 1.0)
	self.currentAlpha = self.fadeStartAlpha + (self.targetAlpha - self.fadeStartAlpha) * progress

	if progress >= 1.0 then
		self.currentAlpha = self.targetAlpha
	end

	return self.currentAlpha, (self.currentAlpha ~= self.targetAlpha)
end

---Destroys the group and all its nodes
---Call this before discarding the group to ensure all frames are cleaned up
function TRB.Classes.BarGroup:Destroy()
	self:Hide()
	self:HideAllNodes()
	for i = 1, self.maxNodes do
		if self.nodes[i] then
			self.nodes[i]:Destroy()
			self.nodes[i] = nil
		end
	end
	-- Clear the global name reference for the container frame
	local containerName = self.containerFrame:GetName()
	if containerName and _G[containerName] == self.containerFrame then
		_G[containerName] = nil
	end
	self.containerFrame:SetParent(nil)
	self.containerFrame:ClearAllPoints()
end

---Gets the container frame
---@return Frame
function TRB.Classes.BarGroup:GetContainerFrame()
	return self.containerFrame
end

---Applies layout to position nodes within the group (for multi-node groups)
---@param totalWidth number # Total width available for the group
---@param nodeWidth number # Width of each node (ignored if fullWidth is true)
---@param nodeHeight number
---@param border number
function TRB.Classes.BarGroup:ApplyLayout(totalWidth, nodeWidth, nodeHeight, border)
	if self.nodeCount == 0 then
		return
	end

	local actualNodeWidth = nodeWidth
	-- Each node is now a single frame at outer dimensions (including its own border),
	-- so spacing between nodes is just the user-configured spacing.
	local nodeSpacing = self.spacing

	if self.fullWidth then
		-- Calculate node width to fill the total width
		actualNodeWidth = (totalWidth - ((self.nodeCount - 1) * nodeSpacing)) / self.nodeCount
	end

	-- Set container dimensions
	local groupWidth = self.fullWidth and totalWidth or (self.nodeCount * actualNodeWidth + (self.nodeCount - 1) * nodeSpacing)
	self.containerFrame:SetWidth(groupWidth)
	self.containerFrame:SetHeight(nodeHeight)
	self.layoutHeight = nodeHeight -- Store layout height for collapse/expand by ProcessBars

	-- Position each node
	for i = 1, self.maxNodes do
		local node = self.nodes[i]
		if node then
			if i <= self.nodeCount then
				node:SetDimensions(actualNodeWidth, nodeHeight, border)

				node.frame:ClearAllPoints()
				if i == 1 then
					-- Node frame is the full outer boundary now, no border offset needed
					node.frame:SetPoint("TOPLEFT", self.containerFrame, "TOPLEFT", 0, 0)
				else
					local prevNode = self.nodes[i-1]
					if prevNode then
						node.frame:SetPoint("LEFT", prevNode.frame, "RIGHT", nodeSpacing, 0)
					end
				end
				node:Show()
			else
				node:Hide()
			end
		end
	end
end

---Enables or disables drag and drop for the group (primary bars only)
---@param enabled boolean
---@param settings table? # Settings table for position saving
function TRB.Classes.BarGroup:SetDragAndDrop(enabled, settings)
	if not self.isPrimary then
		return
	end

	-- Don't enable drag-and-drop if Edit Mode is active and layout is enabled
	if enabled and TRB.Functions.EditMode then
		if TRB.Functions.EditMode:IsInEditMode() then
			enabled = false
		elseif TRB.Functions.EditMode:IsLayoutEnabled() then
			-- When Edit Mode is enabled for this layout, disable legacy drag-and-drop
			-- since Edit Mode will handle positioning
			enabled = false
		end
	end

	-- When using the wrapper frame system, make the wrapper movable instead of the container
	-- The wrapper is the parent of all bars, so moving it moves everything
	local wrapperFrame = TRB.Functions.EditMode and TRB.Functions.EditMode:GetWrapperFrame()
	local targetFrame = wrapperFrame or self.containerFrame

	targetFrame:SetMovable(enabled)
	targetFrame:EnableMouse(enabled)

	-- Also disable mouse on container if using wrapper (so clicks pass through to wrapper)
	if wrapperFrame then
		self.containerFrame:EnableMouse(false)
	end

	if enabled and settings then
		targetFrame:SetScript("OnMouseDown", function(frame, button)
			if button == "LeftButton" and not frame.isMoving then
				frame:StartMoving()
				frame.isMoving = true
			end
		end)

		targetFrame:SetScript("OnMouseUp", function(frame, button)
			if button == "LeftButton" and frame.isMoving then
				frame:StopMovingOrSizing()
				-- Save position of the wrapper/bar
				TRB.Functions.Bar:GetPosition(settings)
				frame.isMoving = false
			end
		end)

		targetFrame:SetScript("OnHide", function(frame)
			if frame.isMoving then
				frame:StopMovingOrSizing()
				TRB.Functions.Bar:GetPosition(settings)
				frame.isMoving = false
			end
		end)
	else
		targetFrame:SetScript("OnMouseDown", nil)
		targetFrame:SetScript("OnMouseUp", nil)
		targetFrame:SetScript("OnHide", nil)
	end
end

--[[
	BarTypeDefinition: Metadata describing a custom bar type.
	Used by the bar system to configure construction, options UI, and IO.
	Custom bars are stored under settings.bars.<key>, colors under settings.colors.bars.<key>,
	and textures under flat keys like settings.textures.<key>Bar, settings.textures.<key>Border, settings.textures.<key>Background.
]]

---@class TRB.Classes.BarTypeDefinition.ThresholdLevel
---@field public key string # The data key in colorSettings (e.g., "low", "medium", "high", "heavy")
---@field public colorLabel string # Localized string for the color picker label
---@field public sliderLabel string? # Localized string for the threshold slider label (nil for first level which has no slider)
---@field public sliderTooltip string? # Localized string for the threshold slider tooltip

---@class TRB.Classes.BarTypeDefinition.NodeColorEntry
---@field public key string # Unique identifier for this node (e.g., "ignorePain", "shieldBlock")
---@field public displayName string # Localized label shown on the enable checkbox (e.g., "Enable Ignore Pain")
---@field public colorLabel string? # Localized label shown on the color swatch (e.g., "Ignore Pain"). Falls back to displayName if nil.
---@field public tooltip string? # Localized tooltip body text for the enable checkbox. Falls back to displayName if nil.
---@field public hasEnabled boolean? # True if this node can be independently enabled/disabled by the user

---@class TRB.Classes.BarTypeDefinition
---@field public key string # Unique key for this bar type (e.g., "stagger", "mana", "defensives")
---@field public displayName string # Localized display name for UI
---@field public settingsPath string # Path to settings (always "bars.<key>")
---@field public colorsPath string # Path to colors (always "colors.bars.<key>")
---@field public texturePrefix string # Prefix for texture keys (e.g., "stagger" -> "staggerBar", "staggerBorder", "staggerBackground")
---@field public isMultiNode boolean # True if bar has multiple nodes (like combo points), false for single node
---@field public maxNodes integer # Maximum number of nodes (1 for single-node bars)
---@field public minMaxMode string # "discrete" (0-1), "health", "mana", "percentage", or "custom"
---@field public hasSpacing boolean # True if bar supports spacing option (multi-node only)
---@field public hasThresholds boolean # True if bar supports threshold lines
---@field public colorCurveType string? # nil for simple colors, "step" or "linear" for gradient/threshold colors
---@field public thresholdLevels TRB.Classes.BarTypeDefinition.ThresholdLevel[]? # Required when colorCurveType is "step" or "linear". Ordered array of threshold level definitions.
---@field public colorTypeLabel string? # Localized string for the color type dropdown header
---@field public colorTypeStepLabel string? # Localized string for "step" option
---@field public colorTypeLinearLabel string? # Localized string for "linear" option
---@field public colorTypeNoneLabel string? # Localized string for "none" option
---@field public defaultDimensionsFunc function? # Function returning default dimensions (SecondaryBar structure)
---@field public defaultColorsFunc function? # Function returning default colors
---@field public defaultTexturesFunc function? # Function returning default textures
---@field public visibilityKey string # Key in displayBar for visibility setting (e.g., "stagger", "mana")
---@field public nodeColors TRB.Classes.BarTypeDefinition.NodeColorEntry[]? # Per-node color/enable definitions (e.g., Warrior defensives: Ignore Pain + Shield Block)
---@field public hasOrdering boolean # True if node display order can be customized by the user
---@field public orderUpTooltip string? # Localized tooltip for the "move up" arrow button
---@field public orderDownTooltip string? # Localized tooltip for the "move down" arrow button
---@field public onChangeCallback function? # Optional callback function to call after color/threshold changes
---@field public getNodeCountForKey (fun(key: string, colorSettings: table): integer)? # Optional callback returning node count per key (for multi-charge nodes like Holy Words). When nil, each enabled key counts as 1 node.
---@field public hasSameColor boolean # True if the "use highest color" checkbox should be shown for this bar's node colors. Defaults to true; set false to hide.
---@field public sameColorNodeKey string? # Key of the nodeColor entry that the sameColor checkbox should be placed next to. Defaults to the last nodeColor entry.
TRB.Classes.BarTypeDefinition = {}
TRB.Classes.BarTypeDefinition.__index = TRB.Classes.BarTypeDefinition

---Creates a new BarTypeDefinition
---@param config table # Configuration table with bar type properties
---@return TRB.Classes.BarTypeDefinition
function TRB.Classes.BarTypeDefinition:New(config)
	local self = {}
	setmetatable(self, TRB.Classes.BarTypeDefinition)

	self.key = config.key
	self.displayName = config.displayName or config.key
	self.settingsPath = "bars." .. config.key
	self.colorsPath = "colors.bars." .. config.key
	self.texturePrefix = config.key -- Flat texture keys: staggerBar, staggerBorder, staggerBackground
	self.isMultiNode = config.isMultiNode or false
	self.maxNodes = config.maxNodes or 1
	self.minMaxMode = config.minMaxMode or "discrete"
	self.hasSpacing = config.hasSpacing or config.isMultiNode or false
	self.hasThresholds = config.hasThresholds or false
	self.colorCurveType = config.colorCurveType -- nil, "step", or "linear"

	-- Threshold color options (required when colorCurveType is "step" or "linear")
	self.thresholdLevels = config.thresholdLevels
	self.maxThresholdPercent = config.maxThresholdPercent -- Max percentage for threshold sliders (default 100 if nil)
	self.colorTypeLabel = config.colorTypeLabel
	self.colorTypeStepLabel = config.colorTypeStepLabel
	self.colorTypeLinearLabel = config.colorTypeLinearLabel
	self.colorTypeNoneLabel = config.colorTypeNoneLabel
	self.onChangeCallback = config.onChangeCallback

	-- Validate: thresholdLevels is required when colorCurveType is "step" or "linear"
	if (self.colorCurveType == "step" or self.colorCurveType == "linear") then
		assert(self.thresholdLevels and #self.thresholdLevels > 0,
			string.format("BarTypeDefinition '%s': thresholdLevels is required when colorCurveType is '%s'",
				self.key, self.colorCurveType))
	end

	self.defaultDimensionsFunc = config.defaultDimensionsFunc
	self.defaultColorsFunc = config.defaultColorsFunc
	self.defaultTexturesFunc = config.defaultTexturesFunc
	self.visibilityKey = config.visibilityKey or config.key
	self.nodeColors = config.nodeColors -- Array of {key, displayName, hasEnabled} for per-node colors
	self.hasOrdering = config.hasOrdering or false -- Whether node display order can be customized
	self.orderUpTooltip = config.orderUpTooltip -- Localized tooltip for the "move up" arrow button
	self.orderDownTooltip = config.orderDownTooltip -- Localized tooltip for the "move down" arrow button
	self.getNodeCountForKey = config.getNodeCountForKey -- Optional callback: (key, colorSettings) -> integer node count
	self.hasSameColor = config.hasSameColor ~= false -- Defaults to true; set false to hide "use highest" checkbox
	self.sameColorNodeKey = config.sameColorNodeKey -- Key of node that sameColor checkbox sits next to (defaults to last)

	return self
end

---Gets the settings table for this bar type from a spec's settings
---@param specSettings table # The spec's settings table
---@return table? # The bar settings, or nil if not found
function TRB.Classes.BarTypeDefinition:GetSettings(specSettings)
	if specSettings and specSettings.bars then
		return specSettings.bars[self.key]
	end
	return nil
end

---Gets the colors table for this bar type from a spec's settings
---@param specSettings table # The spec's settings table
---@return table? # The bar colors, or nil if not found
function TRB.Classes.BarTypeDefinition:GetColors(specSettings)
	if specSettings and specSettings.colors and specSettings.colors.bars then
		return specSettings.colors.bars[self.key]
	end
	return nil
end

---Gets the textures for this bar type from a spec's settings using flat keys
---@param specSettings table # The spec's settings table
---@return table? # The bar textures as {bar, barName, border, borderName, background, backgroundName}, or nil if not found
function TRB.Classes.BarTypeDefinition:GetTextures(specSettings)
	if specSettings and specSettings.textures then
		local barKey = self.key .. "Bar"
		local borderKey = self.key .. "Border"
		local bgKey = self.key .. "Background"
		if specSettings.textures[barKey] then
			return {
				bar = specSettings.textures[barKey],
				barName = specSettings.textures[barKey .. "Name"],
				border = specSettings.textures[borderKey],
				borderName = specSettings.textures[borderKey .. "Name"],
				background = specSettings.textures[bgKey],
				backgroundName = specSettings.textures[bgKey .. "Name"]
			}
		end
	end
	return nil
end

---Returns the number of enabled nodes based on colorSettings.nodeColors.
---Nodes without hasEnabled are always counted. Returns maxNodes if no nodeColors defined.
---When getNodeCountForKey is set, each enabled key contributes the callback's return value
---instead of a flat 1, allowing multi-charge nodes (e.g., Holy Words with Miracle Worker).
---@param colorSettings table # The bar's color settings (e.g., spec.colors.bars.defensives)
---@return integer
function TRB.Classes.BarTypeDefinition:GetEnabledNodeCount(colorSettings)
	if not self.nodeColors then
		return self.maxNodes or 1
	end
	local count = 0
	for _, nodeConfig in ipairs(self.nodeColors) do
		local isEnabled = true
		if nodeConfig.hasEnabled then
			isEnabled = colorSettings and colorSettings.nodeColors and colorSettings.nodeColors[nodeConfig.key]
				and colorSettings.nodeColors[nodeConfig.key].enabled
		end
		if isEnabled then
			if self.getNodeCountForKey then
				count = count + self.getNodeCountForKey(nodeConfig.key, colorSettings)
			else
				count = count + 1
			end
		end
	end
	return count
end

---Returns the ordered list of node keys, respecting colorSettings.nodeOrder if present.
---Sanitizes the persisted order: removes unknown/duplicate keys and appends any
---definition keys that are missing. Writes the sanitized list back to
---colorSettings.nodeOrder so settings self-heal on first access.
---Falls back to the definition order in self.nodeColors when no nodeOrder is stored.
---@param colorSettings table? # The bar's color settings (may contain nodeOrder)
---@return string[] # Ordered array of node keys (one entry per defined nodeColor, no duplicates)
function TRB.Classes.BarTypeDefinition:GetOrderedNodeKeys(colorSettings)
	-- Build the canonical set of known keys from the definition
	local knownKeys = {} ---@type table<string, boolean>
	local definitionOrder = {} ---@type string[]
	if self.nodeColors then
		for _, nodeConfig in ipairs(self.nodeColors) do
			knownKeys[nodeConfig.key] = true
			definitionOrder[#definitionOrder + 1] = nodeConfig.key
		end
	end

	if colorSettings and colorSettings.nodeOrder and #colorSettings.nodeOrder > 0 then
		local seen = {} ---@type table<string, boolean>
		local sanitized = {} ---@type string[]

		-- Keep only known, non-duplicate keys in their persisted order
		for _, key in ipairs(colorSettings.nodeOrder) do
			if knownKeys[key] and not seen[key] then
				seen[key] = true
				sanitized[#sanitized + 1] = key
			end
		end

		-- Append any definition keys that were missing from the persisted order
		for _, key in ipairs(definitionOrder) do
			if not seen[key] then
				sanitized[#sanitized + 1] = key
			end
		end

		-- Write the sanitized list back so settings self-heal
		colorSettings.nodeOrder = sanitized
		return sanitized
	end

	-- No persisted order — return definition order
	return definitionOrder
end

---Sets the settings table for this bar type in a spec's settings
---@param specSettings table # The spec's settings table
---@param barSettings table # The bar settings to set
function TRB.Classes.BarTypeDefinition:SetSettings(specSettings, barSettings)
	if specSettings then
		specSettings.bars = specSettings.bars or {}
		specSettings.bars[self.key] = barSettings
	end
end

---Sets the colors table for this bar type in a spec's settings
---@param specSettings table # The spec's settings table
---@param colorSettings table # The color settings to set
function TRB.Classes.BarTypeDefinition:SetColors(specSettings, colorSettings)
	if specSettings then
		specSettings.colors = specSettings.colors or {}
		specSettings.colors.bars = specSettings.colors.bars or {}
		specSettings.colors.bars[self.key] = colorSettings
	end
end

---Sets the textures for this bar type in a spec's settings using flat keys
---@param specSettings table # The spec's settings table
---@param textureSettings table # The texture settings to set {bar, barName, border, borderName, background, backgroundName}
function TRB.Classes.BarTypeDefinition:SetTextures(specSettings, textureSettings)
	if specSettings then
		specSettings.textures = specSettings.textures or {}
		local barKey = self.key .. "Bar"
		local borderKey = self.key .. "Border"
		local bgKey = self.key .. "Background"
		if textureSettings then
			specSettings.textures[barKey] = textureSettings.bar
			specSettings.textures[barKey .. "Name"] = textureSettings.barName
			specSettings.textures[borderKey] = textureSettings.border
			specSettings.textures[borderKey .. "Name"] = textureSettings.borderName
			specSettings.textures[bgKey] = textureSettings.background
			specSettings.textures[bgKey .. "Name"] = textureSettings.backgroundName
		end
	end
end

---Gets the default dimensions for this bar type
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar?
function TRB.Classes.BarTypeDefinition:GetDefaultDimensions(classic)
	if self.defaultDimensionsFunc then
		return self.defaultDimensionsFunc(classic)
	end
	-- Fall back to generic secondary bar dimensions
	return TRB.Functions.Settings:DefaultComboPointsDimensions(classic)
end

---Gets the default colors for this bar type
---@return table?
function TRB.Classes.BarTypeDefinition:GetDefaultColors()
	if self.defaultColorsFunc then
		return self.defaultColorsFunc()
	end
	-- Fall back to simple bar/border/background structure
	return {
		bar = { color = "FF0000FF" },
		border = { color = "FF000066" },
		background = { color = "66000000" }
	}
end

---Gets the default textures for this bar type
---@return table
function TRB.Classes.BarTypeDefinition:GetDefaultTextures()
	if self.defaultTexturesFunc then
		return self.defaultTexturesFunc()
	end
	-- Fall back to standard textures
	local L = TRB.Localization or {}
	return {
		bar = "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		barName = L["LSMStatusBarSmoother"],
		border = "Interface\\Buttons\\WHITE8X8",
		borderName = "1 Pixel",
		background = "Interface\\Tooltips\\UI-Tooltip-Background",
		backgroundName = "Blizzard Tooltip"
	}
end


--[[
	BarTypeRegistry: Central registry of all custom bar type definitions.
	Used to discover what bar types exist and how to configure them.
]]

---@class TRB.Classes.BarTypeRegistry
---@field private definitions table<string, TRB.Classes.BarTypeDefinition>
TRB.Classes.BarTypeRegistry = {}
TRB.Classes.BarTypeRegistry.__index = TRB.Classes.BarTypeRegistry

-- Singleton instance
TRB.Classes.BarTypeRegistry.instance = nil

---Gets the singleton instance of the registry
---@return TRB.Classes.BarTypeRegistry
function TRB.Classes.BarTypeRegistry:GetInstance()
	if not TRB.Classes.BarTypeRegistry.instance then
		local registry = {}
		setmetatable(registry, TRB.Classes.BarTypeRegistry)
		registry.definitions = {}
		TRB.Classes.BarTypeRegistry.instance = registry
	end
	return TRB.Classes.BarTypeRegistry.instance
end

---Registers a bar type definition
---@param definition TRB.Classes.BarTypeDefinition
function TRB.Classes.BarTypeRegistry:Register(definition)
	self.definitions[definition.key] = definition
end

---Gets a bar type definition by key
---@param key string
---@return TRB.Classes.BarTypeDefinition?
function TRB.Classes.BarTypeRegistry:Get(key)
	return self.definitions[key]
end

---Gets all registered bar type definitions
---@return table<string, TRB.Classes.BarTypeDefinition>
function TRB.Classes.BarTypeRegistry:GetAll()
	return self.definitions
end

---Checks if a bar type is registered
---@param key string
---@return boolean
function TRB.Classes.BarTypeRegistry:Has(key)
	return self.definitions[key] ~= nil
end

---Gets the bar types that a spec uses based on its GetSpecConfiguration
---@param classId integer
---@param specId integer
---@return table<string, TRB.Classes.BarTypeDefinition> # Map of key -> definition for this spec's custom bars
function TRB.Classes.BarTypeRegistry:GetBarTypesForSpec(classId, specId)
	local result = {}
	
	-- Get the class name from classId
	local classNames = {
		[1] = "Warrior",
		[2] = "Paladin",
		[3] = "Hunter",
		[4] = "Rogue",
		[5] = "Priest",
		[6] = "DeathKnight",
		[7] = "Shaman",
		[8] = "Mage",
		[9] = "Warlock",
		[10] = "Monk",
		[11] = "Druid",
		[12] = "DemonHunter",
		[13] = "Evoker"
	}
	
	local className = classNames[classId]
	if not className then
		return result
	end
	
	-- Get the factory for this class
	local classModule = TRB.Classes[className]
	if not classModule or not classModule.BarGroupsFactory or not classModule.BarGroupsFactory.GetSpecConfiguration then
		return result
	end
	
	-- Get the spec configuration
	local specConfig = classModule.BarGroupsFactory:GetSpecConfiguration(specId)
	if not specConfig then
		return result
	end
	
	-- Check each bar group in the config for custom bar types
	for barGroupKey, barGroupConfig in pairs(specConfig) do
		-- Skip primary, secondary, and health as they use the old system
		if barGroupKey ~= "primary" and barGroupKey ~= "secondary" and barGroupKey ~= "health" then
			-- Check if this is a registered custom bar type
			local definition = self.definitions[barGroupKey]
			if definition then
				result[barGroupKey] = definition
			end
		end
	end
	
	return result
end

--[[
	Register built-in bar types.
	This is called when the addon loads to set up the known custom bar types.
	Class-specific bar types are registered here so they're available before
	the class modules load.
]]

---Registers all built-in bar type definitions
function TRB.Classes.BarTypeRegistry:RegisterBuiltInTypes()
	local L = TRB.Localization or {}
	
	-- Stagger bar (Brewmaster Monk)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "stagger",
		displayName = L["ResourceStagger"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		minMaxMode = "percentage", -- 0-100% of max health
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = "step", -- Green -> Yellow -> Red based on stagger level
		visibilityKey = "stagger",
		maxThresholdPercent = 1000, -- Allow thresholds up to 1000% (matches max stagger scale)
		-- Threshold color configuration - pass resolved localized strings, NOT keys
		thresholdLevels = {
			{ key = "low", colorLabel = L["StaggerBarColorLight"] },
			{ key = "medium", colorLabel = L["StaggerBarColorMedium"], sliderLabel = L["StaggerBarThresholdMedium"], sliderTooltip = L["StaggerBarThresholdMediumTooltip"] },
			{ key = "heavy", colorLabel = L["StaggerBarColorHeavy"], sliderLabel = L["StaggerBarThresholdHeavy"], sliderTooltip = L["StaggerBarThresholdHeavyTooltip"] },
			{ key = "extreme", colorLabel = L["StaggerBarColorExtreme"], sliderLabel = L["StaggerBarThresholdExtreme"], sliderTooltip = L["StaggerBarThresholdExtremeTooltip"] }
		},
		colorTypeLabel = L["StaggerBarColorType"],
		colorTypeStepLabel = L["StaggerBarColorTypeStep"],
		colorTypeLinearLabel = L["StaggerBarColorTypeLinear"],
		colorTypeNoneLabel = L["StaggerBarColorTypeNone"],
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultStaggerBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultStaggerBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
	
	-- Defensives bar (Protection Warrior)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "defensives",
		displayName = L["ResourceWarriorDefensives"],
		isMultiNode = true,
		maxNodes = 2, -- Ignore Pain + Shield Block
		hasSameColor = false,
		minMaxMode = "discrete", -- 0-1 per node (buff active or not)
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil, -- Simple colors per buff type
		visibilityKey = "defensives",
		hasOrdering = true,
		orderUpTooltip = L["NodeOrderMoveUpTooltip"],
		orderDownTooltip = L["NodeOrderMoveDownTooltip"],
		nodeColors = {
			{ key = "ignorePain", displayName = L["IgnorePainBarEnable"], colorLabel = L["IgnorePain"], tooltip = L["IgnorePainBarEnableTooltip"], hasEnabled = true },
			{ key = "shieldBlock", displayName = L["ShieldBlockBarEnable"], colorLabel = L["ShieldBlock"], tooltip = L["ShieldBlockBarEnableTooltip"], hasEnabled = true }
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultDefensivesBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultDefensivesBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	-- Holy Words bar (Holy Priest)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "holyWords",
		displayName = L["ResourcePriestHolyWords"],
		isMultiNode = true,
		maxNodes = 5, -- Serenity x2 + Sanctify x2 + Chastise x1
		hasSameColor = false,
		minMaxMode = "discrete", -- 0-1 per node (cooldown progress)
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil, -- Simple colors per Holy Word
		visibilityKey = "holyWords",
		hasOrdering = true,
		orderUpTooltip = L["NodeOrderMoveUpTooltip"],
		orderDownTooltip = L["NodeOrderMoveDownTooltip"],
		nodeColors = {
			{ key = "holyWordSerenity", displayName = L["HolyWordSerenityBarEnable"], colorLabel = L["HolyWordSerenityBarColor"], tooltip = L["HolyWordSerenityBarEnableTooltip"], hasEnabled = true },
			{ key = "holyWordSanctify", displayName = L["HolyWordSanctifyBarEnable"], colorLabel = L["HolyWordSanctifyBarColor"], tooltip = L["HolyWordSanctifyBarEnableTooltip"], hasEnabled = true },
			{ key = "holyWordChastise", displayName = L["HolyWordChastiseBarEnable"], colorLabel = L["HolyWordChastiseBarColor"], tooltip = L["HolyWordChastiseBarEnableTooltip"], hasEnabled = true }
		},
		onChangeCallback = function()
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
		end,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultHolyWordsBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultHolyWordsBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
	
	-- Mana bar (Shadow Priest, Balance Druid, Elemental Shaman)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "mana",
		displayName = L["ResourceMana"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		minMaxMode = "mana",
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = nil, -- Simple bar color
		visibilityKey = "mana",
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultManaBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultManaBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	-- Whirlwind stacks bar (Fury Warrior)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "whirlwind",
		displayName = L["ResourceWarriorWhirlwind"],
		isMultiNode = true,
		maxNodes = 4,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil,
		nodeColors = {
			{ key = "charge1", displayName = L["WhirlwindCharge1"], colorLabel = L["WhirlwindColorPickerBase"] },
			{ key = "charge2", displayName = L["WhirlwindCharge2"], colorLabel = L["WhirlwindColorPickerSecondary"] },
			{ key = "charge3", displayName = L["WhirlwindCharge3"], colorLabel = L["WhirlwindColorPickerPenultimate"] },
			{ key = "charge4", displayName = L["WhirlwindCharge4"], colorLabel = L["WhirlwindColorPickerFinal"] },
		},
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultWhirlwindBarColors()
		end,
	}))

	-- Utility bar (generic multi-node discrete bar; class modules override displayName, nodeColors, and defaultColorsFunc)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "utility",
		displayName = L["ResourceUtility"],
		isMultiNode = true,
		maxNodes = 3,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "utility",
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultUtilityBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultUtilityBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "lightweaver",
		displayName = L["ResourcePriestLightweaver"],
		isMultiNode = true,
		maxNodes = 4,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "lightweaver",
		nodeColors = {
			{ key = "charge1", displayName = L["LightweaverCharge1"], colorLabel = L["LightweaverCharge1"] },
			{ key = "charge2", displayName = L["LightweaverCharge2"], colorLabel = L["LightweaverCharge2"] },
			{ key = "charge3", displayName = L["LightweaverCharge3"], colorLabel = L["LightweaverCharge3"] },
			{ key = "charge4", displayName = L["LightweaverCharge4"], colorLabel = L["LightweaverCharge4"] },
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultLightweaverBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultLightweaverBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
