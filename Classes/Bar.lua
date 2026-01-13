---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

--[[
	BarNode: The atomic unit of the bar system.
	Represents a single StatusBar with its container frame, border frame, resource frame, and thresholds.
	This is the building block for both primary bars (N=1) and secondary "combo point" bars (N>1).
]]

---@class TRB.Classes.BarNode
---@field public containerFrame Frame
---@field public borderFrame StatusBar
---@field public resourceFrame StatusBar
---@field public thresholds Frame[]
---@field public index integer
---@field public name string
---@field public width number
---@field public height number
---@field public border number
---@field public isVisible boolean
TRB.Classes.BarNode = {}
TRB.Classes.BarNode.__index = TRB.Classes.BarNode

---Creates a new BarNode
---@param parent Frame # The parent frame to attach this node to
---@param name string # Base name for the frames (will be suffixed with frame type)
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
	
	self.thresholds = {}
	self.width = 100
	self.height = 20
	self.border = 2
	self.isVisible = false

	-- Create container frame
	local containerName = self.name .. "_Container"
	self.containerFrame = CreateFrame("Frame", containerName, parent, "BackdropTemplate")
	self.containerFrame:SetFrameStrata("BACKGROUND")

	-- Create border frame
	local borderName = self.name .. "_Border"
	self.borderFrame = CreateFrame("StatusBar", borderName, self.containerFrame, "BackdropTemplate")
	self.borderFrame:SetFrameStrata("BACKGROUND")

	-- Create resource frame (the actual status bar)
	local resourceName = self.name .. "_Resource"
	self.resourceFrame = CreateFrame("StatusBar", resourceName, self.containerFrame, "BackdropTemplate")
	self.resourceFrame:SetFrameStrata("BACKGROUND")

	-- Initialize the resource frame's thresholds array for compatibility
	self.resourceFrame.thresholds = self.thresholds

	return self
end

---Sets the value of the StatusBar
---@param value number # The current value
---@param smooth boolean? # Whether to use smooth animation (default: uses global setting)
function TRB.Classes.BarNode:SetValue(value, smooth)
	if smooth == nil then
		smooth = TRB.Data.settings.core.smoothBarValueUpdates
	end

	if smooth then
---@diagnostic disable-next-line: redundant-parameter
		self.resourceFrame:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut)
	else
---@diagnostic disable-next-line: redundant-parameter
		self.resourceFrame:SetValue(value, Enum.StatusBarInterpolation.Immediate)
	end
end

---Sets the minimum and maximum values for the StatusBar
---@param min number
---@param max number
function TRB.Classes.BarNode:SetMinMax(min, max)
	self.resourceFrame:SetMinMaxValues(min, max)
end

---Gets the current min/max values
---@return number min
---@return number max
function TRB.Classes.BarNode:GetMinMax()
	return self.resourceFrame:GetMinMaxValues()
end

---Sets the color of the resource bar
---@param colorString string # ARGB hex color string (e.g., "FFFF0000" for red)
function TRB.Classes.BarNode:SetColor(colorString)
	TRB.Functions.Color:SetStatusBarColorFromRGBAString(self.resourceFrame, self.name .. "_resource", colorString)
end

---Sets the color of the resource bar
---@diagnostic disable-next-line: undefined-doc-name
---@param colorResult LuaCurveEvaluatedResult
function TRB.Classes.BarNode:SetColorCurve(colorResult)
	if colorResult == nil or type(colorResult.GetRGBA) ~= "function" then
		return
	end
	local texture = self.resourceFrame:GetStatusBarTexture()
	if texture then
		texture:SetVertexColor(colorResult:GetRGBA())
	end
end

---Sets the border color
---@param colorString string # ARGB hex color string
function TRB.Classes.BarNode:SetBorderColor(colorString)
	TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(self.borderFrame, self.name .. "_border", colorString)
end

---Sets the background color
---@param r number # Red (0-1)
---@param g number # Green (0-1)
---@param b number # Blue (0-1)
---@param a number # Alpha (0-1)
function TRB.Classes.BarNode:SetBackgroundColor(r, g, b, a)
	TRB.Functions.Color:SetBackdropColor(self.containerFrame, self.name .. "_background", r, g, b, a)
end

---Sets the background color from a color string
---@param colorString string # ARGB hex color string
function TRB.Classes.BarNode:SetBackgroundColorFromString(colorString)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	self:SetBackgroundColor(r, g, b, a)
end

---Sets the dimensions of the node
---@param width number
---@param height number
---@param border number?
function TRB.Classes.BarNode:SetDimensions(width, height, border)
	self.width = width
	self.height = height
	local borderChanged = border ~= nil and border ~= self.border
	if border then
		self.border = border
	end

	local innerWidth = width - (self.border * 2)
	local innerHeight = height - (self.border * 2)

	self.containerFrame:SetWidth(innerWidth)
	self.containerFrame:SetHeight(innerHeight)

	self.borderFrame:SetWidth(width)
	self.borderFrame:SetHeight(height)

	self.resourceFrame:SetHeight(innerHeight)

	-- Update the border frame's edgeSize when border changes
	-- This is necessary because edgeSize is part of backdropInfo, not just frame dimensions
	if borderChanged and self.borderFrame.backdropInfo then
		if self.border < 1 then
			self.borderFrame.backdropInfo.edgeSize = 1
			self.borderFrame:ApplyBackdrop()
			self.borderFrame:SetBackdropColor(0, 0, 0, 0)
			self.borderFrame:Hide()
		else
			self.borderFrame.backdropInfo.edgeSize = self.border
			self.borderFrame:ApplyBackdrop()
			self.borderFrame:SetBackdropColor(0, 0, 0, 0)
			self.borderFrame:Show()
		end
		-- Restore cached border color after ApplyBackdrop resets it
		local borderCacheKey = self.name .. "_border"
		local cachedColor = TRB.Data.cache.colors.border[borderCacheKey]
		if cachedColor then
			self.borderFrame:SetBackdropBorderColor(cachedColor.r, cachedColor.g, cachedColor.b, cachedColor.a)
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
	-- Set resource bar texture
	self.resourceFrame:SetStatusBarTexture(resourceTexture)

	-- Set background texture using backdropInfo pattern for BackdropTemplate frames
---@diagnostic disable-next-line: inject-field
	self.containerFrame.backdropInfo = {
		bgFile = backgroundTexture,
		tile = true,
		tileSize = self.width,
		edgeSize = 1,
		insets = {0, 0, 0, 0}
	}
	self.containerFrame:ApplyBackdrop()

	-- Set border texture
	if self.border < 1 then
---@diagnostic disable-next-line: inject-field
		self.borderFrame.backdropInfo = {
			edgeFile = borderTexture,
			tile = true,
			tileSize = 4,
			edgeSize = 1,
			insets = {0, 0, 0, 0}
		}
		self.borderFrame:ApplyBackdrop()
		self.borderFrame:Hide()
	else
---@diagnostic disable-next-line: inject-field
		self.borderFrame.backdropInfo = {
			edgeFile = borderTexture,
			tile = true,
			tileSize = 4,
			edgeSize = self.border,
			insets = {0, 0, 0, 0}
		}
		self.borderFrame:ApplyBackdrop()
		self.borderFrame:Show()
	end
	self.borderFrame:SetBackdropColor(0, 0, 0, 0)
end

---Sets frame levels for all components
---@param containerLevel integer
---@param borderLevel integer
---@param resourceLevel integer
function TRB.Classes.BarNode:SetFrameLevels(containerLevel, borderLevel, resourceLevel)
	self.containerFrame:SetFrameLevel(containerLevel)
	self.borderFrame:SetFrameLevel(borderLevel)
	self.resourceFrame:SetFrameLevel(resourceLevel)
end

---Sets the frame strata for all components
---@param strata string
function TRB.Classes.BarNode:SetFrameStrata(strata)
	self.containerFrame:SetFrameStrata(strata)
	self.borderFrame:SetFrameStrata(strata)
	self.resourceFrame:SetFrameStrata(strata)
end

---Shows the node
function TRB.Classes.BarNode:Show()
	self.containerFrame:Show()
	self.resourceFrame:Show()
	if self.border >= 1 then
		self.borderFrame:Show()
	end
	self.isVisible = true
end

---Hides the node
function TRB.Classes.BarNode:Hide()
	self.containerFrame:Hide()
	self.isVisible = false
end

---Destroys the node by hiding all frames and clearing references
---Call this before discarding the node to ensure frames are cleaned up
function TRB.Classes.BarNode:Destroy()
	self:Hide()
	self:ClearThresholds()
	self.borderFrame:Hide()
	self.resourceFrame:Hide()
	self.containerFrame:SetParent(nil)
	self.containerFrame:ClearAllPoints()
end

---Returns the resource frame (for legacy compatibility and bar text binding)
---@return StatusBar
function TRB.Classes.BarNode:GetResourceFrame()
	return self.resourceFrame
end

---Returns the container frame
---@return Frame
function TRB.Classes.BarNode:GetContainerFrame()
	return self.containerFrame
end

---Returns the border frame
---@return StatusBar
function TRB.Classes.BarNode:GetBorderFrame()
	return self.borderFrame
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
		thresholdFrame = CreateFrame("Frame", nil, self.resourceFrame)
	else
		-- Use the provided frame
		thresholdFrame = thresholdFrameOrIndex
		index = #self.thresholds + 1
	end

	self.thresholds[index] = thresholdFrame
	-- Keep resourceFrame.thresholds in sync for compatibility
---@diagnostic disable-next-line: inject-field
	self.resourceFrame.thresholds = self.thresholds
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
	self.resourceFrame.thresholds = self.thresholds
end

---Gets all registered thresholds
---@return Frame[]
function TRB.Classes.BarNode:GetThresholds()
	return self.thresholds
end

---Positions the resource frame within the container
function TRB.Classes.BarNode:PositionResourceFrame()
	-- Position the resource bar within the BarNode's container
	self.resourceFrame:ClearAllPoints()
	self.resourceFrame:SetPoint("LEFT", self.containerFrame, "LEFT", 0, 0)
	self.resourceFrame:SetPoint("RIGHT", self.containerFrame, "RIGHT", 0, 0)

	-- Position the border centered on the container
	self.borderFrame:ClearAllPoints()
	self.borderFrame:SetPoint("CENTER", self.containerFrame, "CENTER", 0, 0)
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

	-- Create container frame for the group
	local containerName = self.name
	if not isPrimary then
		containerName = self.name .. "_Group"
	end
	self.containerFrame = CreateFrame("Frame", containerName, parent, "BackdropTemplate")
	self.containerFrame:SetFrameStrata("BACKGROUND")

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

	-- Set node count and apply layout
	self:SetNodeCount(displayNodes)
	self:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")
	self:Show()

	-- Apply layout to position all nodes correctly
	self:ApplyLayout(
		settings.bar.width,
		settings.comboPoints.width,
		settings.comboPoints.height,
		settings.comboPoints.border
	)

	-- Show/hide nodes and set up textures
	local frameLevels = TRB.Data.constants.frameLevels
	for i = 1, displayNodes do
		local node = self:GetNode(i)
		if node then
			node:SetTextures(
				settings.textures.comboPointsBar,
				settings.textures.comboPointsBorder,
				settings.textures.comboPointsBackground
			)
			node:SetMinMax(0, 1)
			node:SetBorderColor(settings.colors.comboPoints.border)
			node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
			node:SetColor(settings.colors.comboPoints.base)
			node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
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

---Shows the group container
function TRB.Classes.BarGroup:Show()
	self.containerFrame:Show()
	self.isVisible = true
end

---Hides the group container
function TRB.Classes.BarGroup:Hide()
	self.containerFrame:Hide()
	self.isVisible = false
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
	local nodeSpacing = self.spacing + (border * 2)

	if self.fullWidth then
		-- Calculate node width to fill the total width
		actualNodeWidth = (totalWidth - ((self.nodeCount - 1) * (nodeSpacing - border * 2))) / self.nodeCount
	end

	-- Set container dimensions
	local groupWidth = self.fullWidth and totalWidth or (self.nodeCount * actualNodeWidth + (self.nodeCount - 1) * self.spacing)
	self.containerFrame:SetWidth(groupWidth)
	self.containerFrame:SetHeight(nodeHeight)

	-- Position each node
	for i = 1, self.maxNodes do
		local node = self.nodes[i]
		if node then
			if i <= self.nodeCount then
				node:SetDimensions(actualNodeWidth, nodeHeight, border)
				node:PositionResourceFrame()

				node.containerFrame:ClearAllPoints()
				if i == 1 then
					-- Offset Y by -border because borderFrame is centered on containerFrame
					-- and extends 'border' pixels above it. This aligns the visual top (border edge)
					-- with the group container's top edge.
					node.containerFrame:SetPoint("TOPLEFT", self.containerFrame, "TOPLEFT", border, -border)
				else
					local prevNode = self.nodes[i-1]
					if prevNode then
						node.containerFrame:SetPoint("LEFT", prevNode.containerFrame, "RIGHT", nodeSpacing, 0)
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

	self.containerFrame:SetMovable(enabled)
	self.containerFrame:EnableMouse(enabled)

	if enabled and settings then
		self.containerFrame:SetScript("OnMouseDown", function(frame, button)
			if button == "LeftButton" and not frame.isMoving then
				frame:StartMoving()
				frame.isMoving = true
			end
		end)

		self.containerFrame:SetScript("OnMouseUp", function(frame, button)
			if button == "LeftButton" and frame.isMoving then
				frame:StopMovingOrSizing()
				TRB.Functions.Bar:GetPosition(settings)
				frame.isMoving = false
			end
		end)

		self.containerFrame:SetScript("OnHide", function(frame)
			if frame.isMoving then
				frame:StopMovingOrSizing()
				TRB.Functions.Bar:GetPosition(settings)
				frame.isMoving = false
			end
		end)
	else
		self.containerFrame:SetScript("OnMouseDown", nil)
		self.containerFrame:SetScript("OnMouseUp", nil)
		self.containerFrame:SetScript("OnHide", nil)
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
---@field public nodeColors table[]? # Array of {key, displayName, hasEnabled} for per-node color pickers (e.g., Warrior defensives)
---@field public onChangeCallback function? # Optional callback function to call after color/threshold changes
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
		minMaxMode = "percentage", -- 0-100% of max health
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = "step", -- Green -> Yellow -> Red based on stagger level
		visibilityKey = "stagger",
		-- Threshold color configuration - pass resolved localized strings, NOT keys
		thresholdLevels = {
			{ key = "low", colorLabel = L["StaggerBarColorLight"] },
			{ key = "medium", colorLabel = L["StaggerBarColorMedium"], sliderLabel = L["StaggerBarThresholdMedium"], sliderTooltip = L["StaggerBarThresholdMediumTooltip"] },
			{ key = "heavy", colorLabel = L["StaggerBarColorHeavy"], sliderLabel = L["StaggerBarThresholdHeavy"], sliderTooltip = L["StaggerBarThresholdHeavyTooltip"] }
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
		minMaxMode = "discrete", -- 0-1 per node (buff active or not)
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil, -- Simple colors per buff type
		visibilityKey = "defensives",
		nodeColors = {
			{ key = "ignorePain", displayName = L["IgnorePain"] , hasEnabled = false },--true }, // TODO: Make these independently enableable.
			{ key = "shieldBlock", displayName = L["ShieldBlock"] , hasEnabled = false },--true }
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
	
	-- Mana bar (Shadow Priest, Balance Druid, Elemental Shaman)
	self:Register(TRB.Classes.BarTypeDefinition:New({
		key = "mana",
		displayName = L["ResourceMana"],
		isMultiNode = false,
		maxNodes = 1,
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
end
