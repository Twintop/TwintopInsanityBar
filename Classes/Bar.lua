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
	self.thresholds = {}
	self.width = 100
	self.height = 20
	self.border = 2
	self.isVisible = false

	-- Create container frame
	local containerName = self.name .. "_Container"
	if index and index > 0 then
		containerName = self.name .. "_" .. index .. "_Container"
	end
	self.containerFrame = CreateFrame("Frame", containerName, parent, "BackdropTemplate")
	self.containerFrame:SetFrameStrata("BACKGROUND")

	-- Create border frame
	local borderName = self.name .. "_Border"
	if index and index > 0 then
		borderName = self.name .. "_" .. index .. "_Border"
	end
	self.borderFrame = CreateFrame("StatusBar", borderName, self.containerFrame, "BackdropTemplate")
	self.borderFrame:SetFrameStrata("BACKGROUND")

	-- Create resource frame (the actual status bar)
	local resourceName = self.name .. "_Resource"
	if index and index > 0 then
		resourceName = self.name .. "_" .. index .. "_Resource"
	end
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
		self.resourceFrame:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut)
	else
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

	-- Set background texture
	self.containerFrame:SetBackdrop({
		bgFile = backgroundTexture,
		tile = true,
		tileSize = self.width,
		edgeSize = 1,
		insets = {0, 0, 0, 0}
	})

	-- Set border texture
	if self.border < 1 then
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

---Registers a threshold frame with this node
---@param thresholdFrame Frame
function TRB.Classes.BarNode:RegisterThreshold(thresholdFrame)
	table.insert(self.thresholds, thresholdFrame)
	-- Keep resourceFrame.thresholds in sync for compatibility
	self.resourceFrame.thresholds = self.thresholds
end

---Clears all registered thresholds
function TRB.Classes.BarNode:ClearThresholds()
	for _, threshold in ipairs(self.thresholds) do
		threshold:Hide()
	end
	self.thresholds = {}
	self.resourceFrame.thresholds = self.thresholds
end

---Gets all registered thresholds
---@return Frame[]
function TRB.Classes.BarNode:GetThresholds()
	return self.thresholds
end

---Positions the resource frame within the container
function TRB.Classes.BarNode:PositionResourceFrame()
	self.resourceFrame:ClearAllPoints()
	self.resourceFrame:SetPoint("LEFT", self.containerFrame, "LEFT", 0, 0)
	self.resourceFrame:SetPoint("RIGHT", self.containerFrame, "RIGHT", 0, 0)

	self.borderFrame:ClearAllPoints()
	self.borderFrame:SetPoint("CENTER", self.containerFrame)
	self.borderFrame:SetPoint("CENTER", 0, 0)
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
	self.nodeCount = maxNodes
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
		self.nodes[i]:SetDimensions(width, height, border)
	end
end

---Sets the same color for all nodes
---@param baseColor string
---@param borderColor string
---@param backgroundColor string
function TRB.Classes.BarGroup:SetAllNodeColors(baseColor, borderColor, backgroundColor)
	for i = 1, self.maxNodes do
		self.nodes[i]:SetColor(baseColor)
		self.nodes[i]:SetBorderColor(borderColor)
		self.nodes[i]:SetBackgroundColorFromString(backgroundColor)
	end
end

---Sets the same textures for all nodes
---@param barTexture string
---@param borderTexture string
---@param bgTexture string
function TRB.Classes.BarGroup:SetAllNodeTextures(barTexture, borderTexture, bgTexture)
	for i = 1, self.maxNodes do
		self.nodes[i]:SetTextures(barTexture, borderTexture, bgTexture)
	end
end

---Sets frame strata for all nodes
---@param strata string
function TRB.Classes.BarGroup:SetFrameStrata(strata)
	self.containerFrame:SetFrameStrata(strata)
	for i = 1, self.maxNodes do
		self.nodes[i]:SetFrameStrata(strata)
	end
end

---Shows nodes up to the specified count
---@param count integer?
function TRB.Classes.BarGroup:ShowNodes(count)
	count = count or self.nodeCount
	for i = 1, self.maxNodes do
		if i <= count then
			self.nodes[i]:Show()
		else
			self.nodes[i]:Hide()
		end
	end
end

---Hides all nodes
function TRB.Classes.BarGroup:HideAllNodes()
	for i = 1, self.maxNodes do
		self.nodes[i]:Hide()
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
		if i <= self.nodeCount then
			node:SetDimensions(actualNodeWidth, nodeHeight, border)
			node:PositionResourceFrame()

			node.containerFrame:ClearAllPoints()
			if i == 1 then
				node.containerFrame:SetPoint("TOPLEFT", self.containerFrame, "TOPLEFT", border, 0)
			else
				node.containerFrame:SetPoint("LEFT", self.nodes[i-1].containerFrame, "RIGHT", nodeSpacing, 0)
			end
			node:Show()
		else
			node:Hide()
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
