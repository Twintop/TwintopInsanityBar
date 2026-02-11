local _, TRB = ...
local L = TRB.Localization

TRB.Options = TRB.Options or {}

-- Constants
local FRAME_WIDTH = 960
local FRAME_HEIGHT = 700
local TITLE_HEIGHT = 30
local NAV_WIDTH = 200
local NAV_INDENT = 20
local NAV_BUTTON_HEIGHT = 22
local NAV_BUTTON_PAD = 2

-- ─────────────────────────────────────────────────────────────────────
-- Class definition
-- ─────────────────────────────────────────────────────────────────────

---@class TRB.Options.OptionsFrame
---@field public mainFrame Frame
---@field public navScrollChild Frame
---@field public contentArea Frame
---@field public navEntries table<string, TRB.Options.OptionsFrame.NavEntry>
---@field public navOrder string[]
---@field public selectedKey string|nil
---@field public currentPanel Frame|nil
local OptionsFrame = {}
OptionsFrame.__index = OptionsFrame

---@class TRB.Options.OptionsFrame.NavEntry
---@field public key string
---@field public label string
---@field public panel Frame|nil
---@field public parentKey string|nil
---@field public children string[]|nil
---@field public collapsed boolean
---@field public button Frame|nil

-- ─────────────────────────────────────────────────────────────────────
-- Internal helpers
-- ─────────────────────────────────────────────────────────────────────

---@param parent Frame
---@param label string
---@param indent number
---@param isHeader boolean
---@return Frame
local function CreateNavButton(parent, label, indent, isHeader)
	local btn = CreateFrame("Button", nil, parent)
	btn:SetHeight(NAV_BUTTON_HEIGHT)
	btn:SetWidth(NAV_WIDTH - 16 - indent)

	-- Highlight texture
	local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetColorTexture(1, 1, 1, 0.1)

	-- Selected texture
	local selected = btn:CreateTexture(nil, "BACKGROUND")
	selected:SetAllPoints()
	selected:SetColorTexture(0.3, 0.5, 0.8, 0.3)
	selected:Hide()
	---@diagnostic disable-next-line: inject-field
	btn.selectedTexture = selected

	-- Text
	local text = btn:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(isHeader and GameFontNormal or GameFontHighlightSmall)
	text:SetJustifyH("LEFT")
	text:SetPoint("LEFT", 4, 0)
	text:SetPoint("RIGHT", -4, 0)
	text:SetText(label)
	---@diagnostic disable-next-line: inject-field
	btn.label = text

	-- Arrow for headers (texture rotated to indicate expand/collapse)
	if isHeader then
		local arrow = btn:CreateTexture(nil, "OVERLAY")
		arrow:SetSize(12, 12)
		arrow:SetPoint("RIGHT", -2, 0)
		arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
		arrow:SetRotation(0) -- right-pointing = collapsed
		---@diagnostic disable-next-line: inject-field
		btn.arrow = arrow
	end

	return btn
end

-- ─────────────────────────────────────────────────────────────────────
-- Constructor
-- ─────────────────────────────────────────────────────────────────────

---Creates a new OptionsFrame instance
---@return TRB.Options.OptionsFrame
function OptionsFrame:New()
	local instance = {}
	setmetatable(instance, OptionsFrame)

	instance.navEntries = {}
	instance.navOrder = {}
	instance.selectedKey = nil
	instance.currentPanel = nil
	instance.mainFrame = nil
	instance.navScrollChild = nil
	instance.contentArea = nil

	return instance
end

-- ─────────────────────────────────────────────────────────────────────
-- Frame construction (lazy, on first use)
-- ─────────────────────────────────────────────────────────────────────

---Ensures the main frame and its sub-frames are created. Idempotent.
function OptionsFrame:EnsureFrame()
	if self.mainFrame then
		return
	end

	-- Main frame
	local mainFrame = CreateFrame("Frame", "TRB_OptionsFrame", UIParent, "BackdropTemplate")
	mainFrame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
	mainFrame:SetPoint("CENTER")
	mainFrame:SetFrameStrata("DIALOG")
	mainFrame:SetClampedToScreen(true)
	mainFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 16,
		tileSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	mainFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
	mainFrame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
	mainFrame:Hide()
	mainFrame:SetMovable(true)

	-- Add to UISpecialFrames for Escape-to-close
	tinsert(UISpecialFrames, "TRB_OptionsFrame")

	-- Title bar (drag region)
	local titleBar = CreateFrame("Frame", nil, mainFrame)
	titleBar:SetHeight(TITLE_HEIGHT)
	titleBar:SetPoint("TOPLEFT", 4, -4)
	titleBar:SetPoint("TOPRIGHT", -4, -4)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		mainFrame:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		mainFrame:StopMovingOrSizing()
	end)

	-- Title text
	local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titleText:SetPoint("LEFT", 8, 0)
	titleText:SetText(L["TwintopsResourceBar"])

	-- Close button
	local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -2, -2)
	closeBtn:SetScript("OnClick", function()
		mainFrame:Hide()
	end)

	-- Divider under title
	local titleDivider = mainFrame:CreateTexture(nil, "ARTWORK")
	titleDivider:SetHeight(1)
	titleDivider:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0)
	titleDivider:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
	titleDivider:SetColorTexture(0.4, 0.4, 0.4, 0.8)

	-- Left nav panel
	local navFrame = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	navFrame:SetWidth(NAV_WIDTH)
	navFrame:SetPoint("TOPLEFT", 4, -(TITLE_HEIGHT + 4))
	navFrame:SetPoint("BOTTOMLEFT", 4, 4)
	navFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	navFrame:SetBackdropColor(0, 0, 0, 0.3)

	-- Nav scroll frame
	local navScroll = CreateFrame("ScrollFrame", "TRB_OptionsFrame_NavScroll", navFrame, "UIPanelScrollFrameTemplate")
	navScroll:SetPoint("TOPLEFT", 4, -4)
	navScroll:SetPoint("BOTTOMRIGHT", -22, 4)

	local navScrollChild = CreateFrame("Frame", nil, navScroll)
	navScrollChild:SetWidth(NAV_WIDTH - 26)
	navScrollChild:SetHeight(1) -- updated by RefreshNav
	navScroll:SetScrollChild(navScrollChild)

	-- Vertical divider between nav and content
	local navDivider = mainFrame:CreateTexture(nil, "ARTWORK")
	navDivider:SetWidth(1)
	navDivider:SetPoint("TOPLEFT", navFrame, "TOPRIGHT", 0, 0)
	navDivider:SetPoint("BOTTOMLEFT", navFrame, "BOTTOMRIGHT", 0, 0)
	navDivider:SetColorTexture(0.4, 0.4, 0.4, 0.8)

	-- Right content area
	local contentArea = CreateFrame("Frame", "TRB_OptionsFrame_Content", mainFrame)
	contentArea:SetPoint("TOPLEFT", navFrame, "TOPRIGHT", 1, 0)
	contentArea:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -4, 4)

	-- Store references on self
	self.mainFrame = mainFrame
	self.navScrollChild = navScrollChild
	self.contentArea = contentArea

	TRB.Frames.optionsFrame = mainFrame
end

-- ─────────────────────────────────────────────────────────────────────
-- Registration API
-- ─────────────────────────────────────────────────────────────────────

---Register a top-level nav category (e.g., Global Options, Import/Export)
---@param key string
---@param label string
---@param panel Frame
function OptionsFrame:RegisterCategory(key, label, panel)
	self:EnsureFrame()
	self.navEntries[key] = {
		key = key,
		label = label,
		panel = panel,
		parentKey = nil,
		children = nil,
		collapsed = false,
		button = nil,
	}
	table.insert(self.navOrder, key)

	-- Re-parent the panel into content area, hide it
	panel:SetParent(self.contentArea)
	panel:ClearAllPoints()
	panel:SetAllPoints(self.contentArea)
	panel:Hide()
end

---Register a class header (collapsible, no panel)
---@param classKey string
---@param classLabel string
function OptionsFrame:RegisterClassHeader(classKey, classLabel)
	self:EnsureFrame()
	if self.navEntries[classKey] then
		return -- already registered
	end
	self.navEntries[classKey] = {
		key = classKey,
		label = classLabel,
		panel = nil,
		parentKey = nil,
		children = {},
		collapsed = true,
		button = nil,
	}
	table.insert(self.navOrder, classKey)
end

---Register a spec panel under a class header
---@param classKey string
---@param specKey string
---@param specLabel string
---@param panel Frame
function OptionsFrame:RegisterSpecPanel(classKey, specKey, specLabel, panel)
	self:EnsureFrame()

	-- Ensure the class header exists
	if not self.navEntries[classKey] then
		self:RegisterClassHeader(classKey, classKey)
	end

	self.navEntries[specKey] = {
		key = specKey,
		label = specLabel,
		panel = panel,
		parentKey = classKey,
		children = nil,
		collapsed = false,
		button = nil,
	}
	table.insert(self.navEntries[classKey].children, specKey)

	-- Re-parent the panel into content area, hide it
	panel:SetParent(self.contentArea)
	panel:ClearAllPoints()
	panel:SetAllPoints(self.contentArea)
	panel:Hide()

	-- Populate compat shim so existing code referencing addonCategory.specs still works
	TRB.Details.addonCategory = TRB.Details.addonCategory or {}
	TRB.Details.addonCategory.specs = TRB.Details.addonCategory.specs or {}
	TRB.Details.addonCategory.specs[specKey] = { key = specKey, ID = specKey }
end

-- ─────────────────────────────────────────────────────────────────────
-- Navigation
-- ─────────────────────────────────────────────────────────────────────

---Select and show the given category/spec
---@param key string
function OptionsFrame:SelectCategory(key)
	if not self.navEntries[key] then
		return
	end

	-- Hide current panel
	if self.currentPanel then
		self.currentPanel:Hide()
	end
	if self.selectedKey and self.navEntries[self.selectedKey] and self.navEntries[self.selectedKey].button then
		self.navEntries[self.selectedKey].button.selectedTexture:Hide()
	end

	-- If this entry has a parent class header, expand it
	local entry = self.navEntries[key]
	if entry.parentKey and self.navEntries[entry.parentKey] then
		self.navEntries[entry.parentKey].collapsed = false
	end

	-- Show new panel
	if entry.panel then
		entry.panel:Show()
		self.currentPanel = entry.panel
	end
	self.selectedKey = key

	-- Highlight the button
	if entry.button then
		entry.button.selectedTexture:Show()
	end

	self:RefreshNav()
end

---Rebuild the nav button layout
function OptionsFrame:RefreshNav()
	self:EnsureFrame()

	local yOffset = -4

	for _, topKey in ipairs(self.navOrder) do
		local entry = self.navEntries[topKey]
		if entry then
			-- Create or update button
			local isHeader = (entry.children ~= nil and #entry.children > 0)
			if not entry.button then
				entry.button = CreateNavButton(self.navScrollChild, entry.label, 0, isHeader)
				if isHeader then
					local selfRef = self
					entry.button:SetScript("OnClick", function()
						entry.collapsed = not entry.collapsed
						selfRef:RefreshNav()
					end)
				elseif entry.panel then
					local selfRef = self
					local k = entry.key
					entry.button:SetScript("OnClick", function()
						selfRef:SelectCategory(k)
					end)
				end
			end

			entry.button:SetPoint("TOPLEFT", self.navScrollChild, "TOPLEFT", 4, yOffset)
			entry.button:SetWidth(NAV_WIDTH - 30)
			entry.button:Show()

			-- Update selected highlight
			if self.selectedKey == topKey then
				entry.button.selectedTexture:Show()
			else
				entry.button.selectedTexture:Hide()
			end

			-- Update arrow rotation: 0 = right-pointing (collapsed), -π/2 = down-pointing (expanded)
			if entry.button.arrow then
				entry.button.arrow:SetRotation(entry.collapsed and 0 or (-math.pi / 2))
			end

			yOffset = yOffset - NAV_BUTTON_HEIGHT - NAV_BUTTON_PAD

			-- Children (spec entries)
			if entry.children and not entry.collapsed then
				for _, childKey in ipairs(entry.children) do
					local childEntry = self.navEntries[childKey]
					if childEntry then
						if not childEntry.button then
							childEntry.button = CreateNavButton(self.navScrollChild, childEntry.label, NAV_INDENT, false)
							local selfRef = self
							local ck = childEntry.key
							childEntry.button:SetScript("OnClick", function()
								selfRef:SelectCategory(ck)
							end)
						end

						childEntry.button:SetPoint("TOPLEFT", self.navScrollChild, "TOPLEFT", 4 + NAV_INDENT, yOffset)
						childEntry.button:SetWidth(NAV_WIDTH - 30 - NAV_INDENT)
						childEntry.button:Show()

						if self.selectedKey == childKey then
							childEntry.button.selectedTexture:Show()
						else
							childEntry.button.selectedTexture:Hide()
						end

						yOffset = yOffset - NAV_BUTTON_HEIGHT - NAV_BUTTON_PAD
					end
				end
			elseif entry.children then
				-- Collapsed: hide child buttons
				for _, childKey in ipairs(entry.children) do
					local childEntry = self.navEntries[childKey]
					if childEntry and childEntry.button then
						childEntry.button:Hide()
					end
				end
			end
		end
	end

	-- Update scroll child height
	self.navScrollChild:SetHeight(math.abs(yOffset) + 8)
end

-- ─────────────────────────────────────────────────────────────────────
-- Visibility
-- ─────────────────────────────────────────────────────────────────────

---Show the standalone options frame
function OptionsFrame:Show()
	self:EnsureFrame()
	self:RefreshNav()
	self.mainFrame:Show()
	self.mainFrame:Raise()
end

---Hide the standalone options frame
function OptionsFrame:Hide()
	if self.mainFrame then
		self.mainFrame:Hide()
	end
end

---Toggle the standalone options frame
function OptionsFrame:Toggle()
	if self.mainFrame and self.mainFrame:IsShown() then
		self:Hide()
	else
		self:Show()
	end
end

---Check if the frame is currently shown
---@return boolean
function OptionsFrame:IsShown()
	return self.mainFrame and self.mainFrame:IsShown() or false
end

-- ─────────────────────────────────────────────────────────────────────
-- Singleton instance
-- ─────────────────────────────────────────────────────────────────────

TRB.Options.OptionsFrame = OptionsFrame:New()
