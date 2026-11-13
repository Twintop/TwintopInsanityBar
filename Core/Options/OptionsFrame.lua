local _, TRB = ...
local L = TRB.Localization

TRB.Options = TRB.Options or {}

-- URL copy dialog (defined eagerly so it's always available)
StaticPopupDialogs["TRB_OPTIONSFRAME_URL"] = {
	OnShow = function(self, data)
		self:SetWidth(450)
		self:SetFormattedText("%s", data.title)
		self:GetEditBox():SetText(data.url)
		self:GetEditBox():SetAutoFocus(true)
		self:GetEditBox():HighlightText()
	end,
	OnAccept = function(self) self:Hide() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	text = "",
	button1 = L["OK"],
	hasEditBox = true,
	hasWideEditBox = true,
	editBoxWidth = 400,
	timeout = 60,
	whileDead = true,
	closeButton = true,
	hideOnEscape = true
}

-- Constants
local FRAME_WIDTH = 960
local FRAME_HEIGHT = 750
local TITLE_HEIGHT = 30
local FOOTER_HEIGHT = 24
local NAV_WIDTH = 220
local NAV_INDENT = 20
local NAV_BUTTON_HEIGHT = 22
local NAV_BUTTON_PAD = 2
local NAV_ICON_SIZE = 16
local configuredDragHandles = setmetatable({}, { __mode = "k" })


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
---@field public navBottomOrder string[]
local OptionsFrame = {}
OptionsFrame.__index = OptionsFrame

---@class TRB.Options.OptionsFrame.NavEntry
---@field public key string
---@field public label string
---@field public panel Frame|TRB.Classes.OptionsUi.SectionedPanel|nil # A section's entry holds the panel its section is on
---@field public section string|nil # The section of the panel this entry shows
---@field public parentKey string|nil
---@field public children string[]|nil # Headers and specs only
---@field public collapsed boolean
---@field public button TRB.Classes.OptionsUi.NavButton|nil
---@field public builder function|nil
---@field public isClass boolean|nil
---@field public isSpec boolean|nil
---@field public lastChildKey string|nil # The child last selected, reopened when this entry is selected

-- ─────────────────────────────────────────────────────────────────────
-- Internal helpers
-- ─────────────────────────────────────────────────────────────────────

---Parse a composite key ("className_specName") into its class and spec parts
---@param compositeKey string e.g. "deathknight_frost"
---@return string|nil className
---@return string|nil specName
local function ParseCompositeKey(compositeKey)
	if not compositeKey then
		return nil, nil
	end
	local className, specName = string.match(compositeKey, "^([^_]+)_(.+)$")
	return className, specName
end

---Get icon info for a nav entry
---@param classKey string|nil All-lowercase class key (e.g., "deathknight")
---@param specKey string|nil Bare spec name (e.g., "frost"), composite key (e.g., "deathknight_frost"), or nil for class icon
---@return table|nil iconInfo {atlas=string} or {texture=number} or nil
local function GetNavIcon(classKey, specKey)
	if not classKey then
		return nil
	end
	if specKey then
		-- If specKey is a composite key, parse out the bare spec name
		local parsedClass, parsedSpec = ParseCompositeKey(specKey)
		local bareSpec = parsedSpec or specKey
		local lookupClass = parsedClass or classKey

		local classEntry = TRB.Data.classRegistry[lookupClass]
		local specEntry = classEntry and TRB.Data.specRegistry[lookupClass .. "_" .. bareSpec]
		if classEntry and specEntry then
			local classId = classEntry.classId
			local specIndex = specEntry.specId
			if classId and specIndex and specEntry.specGlobalId ~= nil then
				local _, _, _, icon = GetSpecializationInfoForClassID(classId, specIndex)
				if icon then
					return { texture = icon }
				end
			end
		end
	end
	-- Fall back to class icon atlas (classKey is already lowercase)
	return { atlas = "classicon-" .. classKey }
end

---Creates a navigation button with optional icon, highlight/selected textures, label text, and a collapse arrow for header entries
---@param parent Frame The scroll child frame to parent the button to
---@param label string Display text for the button
---@param indent number Pixel indent from the left edge (used for child/spec entries)
---@param isHeader boolean Whether this button represents a collapsible class header (adds an arrow indicator)
---@param iconInfo table|nil {atlas=string} or {texture=number} for an optional icon displayed left of the label
---@param useHeaderFont boolean? Whether the label takes the larger header font, as the top-level headers do
---@return TRB.Classes.OptionsUi.NavButton button The created navigation button frame
local function CreateNavButton(parent, label, indent, isHeader, iconInfo, useHeaderFont)
	local btn = CreateFrame("Button", nil, parent) --[[@as TRB.Classes.OptionsUi.NavButton]]
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
	btn.selectedTexture = selected

	-- Icon (optional)
	local textLeftOffset = 4
	if iconInfo then
		local icon = btn:CreateTexture(nil, "ARTWORK")
		icon:SetSize(NAV_ICON_SIZE, NAV_ICON_SIZE)
		icon:SetPoint("LEFT", 2, 0)
		if iconInfo.atlas then
			icon:SetAtlas(iconInfo.atlas)
		elseif iconInfo.texture then
			icon:SetTexture(iconInfo.texture)
		end
		btn.icon = icon
		textLeftOffset = 2 + NAV_ICON_SIZE + 3
	end

	-- Text
	local text = btn:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(useHeaderFont and GameFontNormal or GameFontHighlightSmall)
	text:SetJustifyH("LEFT")
	text:SetPoint("LEFT", textLeftOffset, 0)
	text:SetPoint("RIGHT", -4, 0)
	text:SetText(label)
	btn.label = text

	-- Arrow for headers (texture rotated to indicate expand/collapse)
	if isHeader then
		local arrow = btn:CreateTexture(nil, "OVERLAY")
		arrow:SetSize(12, 12)
		arrow:SetPoint("RIGHT", -2, 0)
		arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
		arrow:SetRotation(0) -- right-pointing = collapsed
		btn.arrow = arrow
	end

	return btn
end

---Make a frame act as a drag handle for the main options window.
---@param handleFrame Frame|nil
---@param mainFrame Frame|nil
local function ConfigureDragHandle(handleFrame, mainFrame)
	if handleFrame == nil or mainFrame == nil or configuredDragHandles[handleFrame] then
		return
	end

	configuredDragHandles[handleFrame] = true
	handleFrame:EnableMouse(true)
	handleFrame:RegisterForDrag("LeftButton")
	handleFrame:HookScript("OnDragStart", function()
		mainFrame:StartMoving()
	end)
	handleFrame:HookScript("OnDragStop", function()
		mainFrame:StopMovingOrSizing()
	end)
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
	instance.navBottomOrder = {}
	instance.selectedKey = nil
	instance.currentPanel = nil
	instance.mainFrame = nil
	instance.navScrollChild = nil
	instance.contentArea = nil
	instance.footerFrame = nil

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
	mainFrame:EnableMouse(true)
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
	mainFrame:HookScript("OnHide", function(self)
		self:StopMovingOrSizing()
	end)

	-- Add to UISpecialFrames for Escape-to-close
	tinsert(UISpecialFrames, "TRB_OptionsFrame")

	-- Title bar (drag region)
	local titleBar = CreateFrame("Frame", nil, mainFrame)
	titleBar:SetHeight(TITLE_HEIGHT)
	titleBar:SetPoint("TOPLEFT", 4, -4)
	titleBar:SetPoint("TOPRIGHT", -4, -4)
	ConfigureDragHandle(titleBar, mainFrame)

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

	-- Preview Mode toggle, left of the close button
	local previewCheckbox = CreateFrame("CheckButton", "TRB_OptionsFrame_PreviewMode", titleBar, "ChatConfigCheckButtonTemplate")
	local previewLabel = getglobal(previewCheckbox:GetName() .. "Text")
	previewLabel:SetText(L["PreviewMode"])
	previewCheckbox:SetPoint("RIGHT", titleBar, "RIGHT", -(36 + previewLabel:GetStringWidth()), 0)
	previewCheckbox:SetHitRectInsets(0, -previewLabel:GetStringWidth(), 0, 0)
	---@diagnostic disable-next-line: inject-field
	previewCheckbox.tooltip = L["PreviewModeTooltip"]
	previewCheckbox:SetScript("OnClick", function(self)
		TRB.Functions.Preview:SetActive(self:GetChecked())
		self:SetChecked(TRB.Functions.Preview:IsActive())
	end)
	TRB.Functions.Preview:AddListener(function(active)
		previewCheckbox:SetChecked(active)
	end)
	mainFrame:HookScript("OnHide", function()
		TRB.Functions.Preview:SetActive(false)
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
	navFrame:SetPoint("BOTTOMLEFT", 4, 4 + FOOTER_HEIGHT + 1)
	navFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	navFrame:SetBackdropColor(0, 0, 0, 0.3)
	ConfigureDragHandle(navFrame, mainFrame)

	-- Nav scroll frame
	local navScroll = CreateFrame("ScrollFrame", "TRB_OptionsFrame_NavScroll", navFrame, "UIPanelScrollFrameTemplate")
	navScroll:SetPoint("TOPLEFT", 4, -4)
	navScroll:SetPoint("BOTTOMRIGHT", -26, 4)
	ConfigureDragHandle(navScroll, mainFrame)

	local navScrollChild = CreateFrame("Frame", nil, navScroll)
	navScrollChild:SetWidth(NAV_WIDTH - 30)
	navScrollChild:SetHeight(1) -- updated by RefreshNav
	navScroll:SetScrollChild(navScrollChild)

	-- Vertical divider between nav and content
	local navDivider = mainFrame:CreateTexture(nil, "ARTWORK")
	navDivider:SetWidth(1)
	navDivider:SetPoint("TOPLEFT", navFrame, "TOPRIGHT", 0, 0)
	navDivider:SetPoint("BOTTOMLEFT", navFrame, "BOTTOMRIGHT", 0, 0)
	navDivider:SetColorTexture(0.4, 0.4, 0.4, 0.8)

	-- Footer bar
	local footerFrame = CreateFrame("Frame", "TRB_OptionsFrame_Footer", mainFrame)
	footerFrame:SetHeight(FOOTER_HEIGHT)
	footerFrame:SetPoint("BOTTOMLEFT", 4, 4)
	footerFrame:SetPoint("BOTTOMRIGHT", -4, 4)
	ConfigureDragHandle(footerFrame, mainFrame)

	-- Divider above footer
	local footerDivider = mainFrame:CreateTexture(nil, "ARTWORK")
	footerDivider:SetHeight(1)
	footerDivider:SetPoint("BOTTOMLEFT", footerFrame, "TOPLEFT", 0, 0)
	footerDivider:SetPoint("BOTTOMRIGHT", footerFrame, "TOPRIGHT", 0, 0)
	footerDivider:SetColorTexture(0.4, 0.4, 0.4, 0.8)

	-- Footer: version text (left) — click to copy
	local versionStr = TRB.Details.addonVersion
	if TRB.Details.addonReleaseDate and TRB.Details.addonReleaseDate ~= "" then
		versionStr = versionStr .. " (" .. TRB.Details.addonReleaseDate .. ")"
	end

	local versionBtn = CreateFrame("Button", nil, footerFrame)
	versionBtn:SetHeight(FOOTER_HEIGHT)
	versionBtn:SetPoint("LEFT", 8, 0)

	local versionText = versionBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	versionText:SetPoint("LEFT", 0, 0)
	versionText:SetTextColor(0.6, 0.6, 0.6, 1)
	versionText:SetText(versionStr)
	versionBtn:SetWidth(versionText:GetStringWidth() + 4)

	versionBtn:SetScript("OnEnter", function(self)
		versionText:SetTextColor(1, 1, 1, 1)
	end)
	versionBtn:SetScript("OnLeave", function(self)
		versionText:SetTextColor(0.6, 0.6, 0.6, 1)
	end)
	versionBtn:SetScript("OnClick", function()
		StaticPopup_Show("TRB_OPTIONSFRAME_URL", nil, nil, {
			title = "TwintopInsanityBar " .. L["Version"],
			url = versionStr,
		})
	end)

	local discordIconPath = "Interface\\AddOns\\TwintopInsanityBar\\Images\\discord64.png"
	local githubIconPath = "Interface\\AddOns\\TwintopInsanityBar\\Images\\GitHub_Invertocat_White64.png"
	local newsIconPath = "Interface\\AddOns\\TwintopInsanityBar\\Images\\newspaper.png"
	local kofiIconPath = "Interface\\AddOns\\TwintopInsanityBar\\Images\\kofi.png"
	local FOOTER_BTN_WIDTH = 120

	-- Footer: Discord button (right) — styled with blurple border, black bg, white text
	local blurpleR, blurpleG, blurpleB = 0.345, 0.396, 0.949
	local discordBtn = CreateFrame("Button", nil, footerFrame, "BackdropTemplate")
	discordBtn:SetSize(FOOTER_BTN_WIDTH, 20)
	discordBtn:SetPoint("RIGHT", -4, 0)
	discordBtn:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	discordBtn:SetBackdropColor(0, 0, 0, 1)
	discordBtn:SetBackdropBorderColor(blurpleR, blurpleG, blurpleB, 1)
	discordBtn:EnableMouse(true)
	discordBtn:RegisterForClicks("AnyUp")

	local discordText = discordBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	discordText:SetPoint("CENTER", 8, 0)
	discordText:SetText(L["FooterDiscord"])
	discordText:SetTextColor(1, 1, 1, 1)

	local discordHighlight = discordBtn:CreateTexture(nil, "HIGHLIGHT")
	discordHighlight:SetAllPoints()
	discordHighlight:SetColorTexture(blurpleR, blurpleG, blurpleB, 0.15)

	discordBtn:SetScript("OnClick", function()
		StaticPopup_Show("TRB_OPTIONSFRAME_URL", nil, nil, {
			title = L["FooterDiscord"],
			url = L["FooterDiscordUrl"]
		})
	end)
	local discordIcon = discordBtn:CreateTexture(nil, "ARTWORK")
	discordIcon:SetSize(14, 14)
	discordIcon:SetPoint("LEFT", 8, 0)
	discordIcon:SetTexture(discordIconPath)

	-- Footer: Ko-fi button (left of Discord) — styled with black bg, gray border, white text
	local kofiBtn = CreateFrame("Button", nil, footerFrame, "BackdropTemplate")
	kofiBtn:SetSize(FOOTER_BTN_WIDTH, 20)
	kofiBtn:SetPoint("RIGHT", discordBtn, "LEFT", -6, 0)
	kofiBtn:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	kofiBtn:SetBackdropColor(0, 0, 0, 1)
	kofiBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	kofiBtn:EnableMouse(true)
	kofiBtn:RegisterForClicks("AnyUp")

	local kofiText = kofiBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	kofiText:SetPoint("CENTER", 8, 0)
	kofiText:SetText(L["FooterKofi"])
	kofiText:SetTextColor(1, 1, 1, 1)

	local kofiHighlight = kofiBtn:CreateTexture(nil, "HIGHLIGHT")
	kofiHighlight:SetAllPoints()
	kofiHighlight:SetColorTexture(1, 1, 1, 0.1)

	kofiBtn:SetScript("OnClick", function()
		StaticPopup_Show("TRB_OPTIONSFRAME_URL", nil, nil, {
			title = L["FooterKofi"],
			url = L["FooterKofiUrl"]
		})
	end)
	local kofiIcon = kofiBtn:CreateTexture(nil, "ARTWORK")
	kofiIcon:SetSize(14, 14)
	kofiIcon:SetPoint("LEFT", 8, 0)
	kofiIcon:SetTexture(kofiIconPath)

	-- Footer: GitHub Issues button (left of Ko-fi) — styled with black bg, gray border, white text
	local githubBtn = CreateFrame("Button", nil, footerFrame, "BackdropTemplate")
	githubBtn:SetSize(FOOTER_BTN_WIDTH, 20)
	githubBtn:SetPoint("RIGHT", kofiBtn, "LEFT", -6, 0)
	githubBtn:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	githubBtn:SetBackdropColor(0, 0, 0, 1)
	githubBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	githubBtn:EnableMouse(true)
	githubBtn:RegisterForClicks("AnyUp")

	local githubText = githubBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	githubText:SetPoint("CENTER", 8, 0)
	githubText:SetText(L["FooterGitHubIssues"])
	githubText:SetTextColor(1, 1, 1, 1)

	local githubHighlight = githubBtn:CreateTexture(nil, "HIGHLIGHT")
	githubHighlight:SetAllPoints()
	githubHighlight:SetColorTexture(1, 1, 1, 0.1)

	githubBtn:SetScript("OnClick", function()
		StaticPopup_Show("TRB_OPTIONSFRAME_URL", nil, nil, {
			title = L["FooterGitHubIssues"],
			url = L["FooterGitHubIssuesUrl"]
		})
	end)
	local githubIcon = githubBtn:CreateTexture(nil, "ARTWORK")
	githubIcon:SetSize(14, 14)
	githubIcon:SetPoint("LEFT", 8, 0)
	githubIcon:SetTexture(githubIconPath)

	-- Footer: News button (left of GitHub) — styled with dark bg, gray border, white text
	local newsBtn = CreateFrame("Button", nil, footerFrame, "BackdropTemplate")
	newsBtn:SetSize(FOOTER_BTN_WIDTH, 20)
	newsBtn:SetPoint("RIGHT", githubBtn, "LEFT", -6, 0)
	newsBtn:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	newsBtn:SetBackdropColor(0.1, 0.1, 0.1, 1)
	newsBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	newsBtn:EnableMouse(true)
	newsBtn:RegisterForClicks("AnyUp")

	local newsText = newsBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	newsText:SetPoint("CENTER", 8, 0)
	newsText:SetText(L["FooterNews"])
	newsText:SetTextColor(1, 1, 1, 1)

	local newsHighlight = newsBtn:CreateTexture(nil, "HIGHLIGHT")
	newsHighlight:SetAllPoints()
	newsHighlight:SetColorTexture(1, 1, 1, 0.1)

	newsBtn:SetScript("OnClick", function()
		TRB.Functions.News:Show()
	end)
	local newsIcon = newsBtn:CreateTexture(nil, "ARTWORK")
	newsIcon:SetSize(14, 14)
	newsIcon:SetPoint("LEFT", 8, 0)
	newsIcon:SetTexture(newsIconPath)

	-- Right content area (above footer)
	local contentArea = CreateFrame("Frame", "TRB_OptionsFrame_Content", mainFrame)
	contentArea:SetPoint("TOPLEFT", navFrame, "TOPRIGHT", 1, 0)
	contentArea:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -4, 4 + FOOTER_HEIGHT + 1)
	ConfigureDragHandle(contentArea, mainFrame)

	-- Store references on self
	self.mainFrame = mainFrame
	self.navScrollChild = navScrollChild
	self.contentArea = contentArea
	self.footerFrame = footerFrame

	TRB.Frames.optionsFrame = mainFrame
end

-- ─────────────────────────────────────────────────────────────────────
-- Registration API
-- ─────────────────────────────────────────────────────────────────────

---Parents a panel to the content area, hidden until its nav entry is selected.
---@param panel Frame
function OptionsFrame:AdoptPanel(panel)
	panel:SetParent(self.contentArea)
	panel:ClearAllPoints()
	panel:SetAllPoints(self.contentArea)
	ConfigureDragHandle(panel, self.mainFrame)
	panel:Hide()
end

---Register a nav category with a panel of its own, at the top level or under a header.
---@param key string
---@param label string
---@param panel Frame
---@param parentKey string? # A registered header to list it under
function OptionsFrame:RegisterCategory(key, label, panel, parentKey)
	self:EnsureFrame()
	local parent = parentKey ~= nil and self.navEntries[parentKey] or nil
	self.navEntries[key] = {
		key = key,
		label = label,
		panel = panel,
		parentKey = parent ~= nil and parentKey or nil,
		children = nil,
		collapsed = false,
		button = nil,
	}
	if parent ~= nil then
		table.insert(parent.children, key)
	else
		table.insert(self.navOrder, key)
	end
	self:AdoptPanel(panel)
end

---Register a top-level nav category that always appears at the bottom of the nav list
---@param key string
---@param label string
---@param panel Frame
function OptionsFrame:RegisterBottomCategory(key, label, panel)
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
	table.insert(self.navBottomOrder, key)
	self:AdoptPanel(panel)
end

---Register a top-level collapsible header with no panel of its own.
---@param key string
---@param label string
function OptionsFrame:RegisterHeader(key, label)
	self:EnsureFrame()
	if self.navEntries[key] then
		return -- already registered
	end
	self.navEntries[key] = {
		key = key,
		label = label,
		panel = nil,
		parentKey = nil,
		children = {},
		collapsed = true,
		button = nil,
	}
	table.insert(self.navOrder, key)
end

---Register a class header (collapsible, no panel)
---@param classKey string
---@param classLabel string
function OptionsFrame:RegisterClassHeader(classKey, classLabel)
	if self.navEntries[classKey] then
		return -- already registered
	end
	self:RegisterHeader(classKey, classLabel)
	self.navEntries[classKey].isClass = true
end

---Register a spec under a class header. Its sections are listed under it once its panel is built.
---@param classKey string
---@param specKey string
---@param specLabel string
---@param panel Frame?
---@param builder function? # Optional builder function called on first navigation if panel is nil
function OptionsFrame:RegisterSpecPanel(classKey, specKey, specLabel, panel, builder)
	self:EnsureFrame()

	-- Ensure the class header exists
	if not self.navEntries[classKey] then
		self:RegisterClassHeader(classKey, classKey)
	end

	-- If this spec is already registered, update panel/builder if provided
	if self.navEntries[specKey] then
		if panel then
			self.navEntries[specKey].panel = panel
			self:AdoptPanel(panel)
		end
		if builder then
			self.navEntries[specKey].builder = builder
		end
		return
	end

	self.navEntries[specKey] = {
		key = specKey,
		label = specLabel,
		panel = panel,
		parentKey = classKey,
		children = {},
		collapsed = true,
		button = nil,
		builder = builder,
		isSpec = true,
	}
	table.insert(self.navEntries[classKey].children, specKey)

	if panel then
		self:AdoptPanel(panel)
	end

	-- Populate compat shim so existing code referencing addonCategory.specs still works
	TRB.Details.addonCategory = TRB.Details.addonCategory or {}
	TRB.Details.addonCategory.specs = TRB.Details.addonCategory.specs or {}
	TRB.Details.addonCategory.specs[specKey] = { key = specKey, ID = specKey }
end

---Register one section of a panel under that panel's header or spec entry.
---@param parentKey string
---@param sectionKey string
---@param label string
---@param panel Frame # The panel holding the section
---@return string key # The section's nav key
function OptionsFrame:RegisterSection(parentKey, sectionKey, label, panel)
	local key = parentKey .. ":" .. sectionKey
	local parent = self.navEntries[parentKey]
	if parent == nil or self.navEntries[key] then
		return key
	end
	self.navEntries[key] = {
		key = key,
		label = label,
		panel = panel,
		section = sectionKey,
		parentKey = parentKey,
		children = nil,
		collapsed = false,
		button = nil,
	}
	table.insert(parent.children, key)
	return key
end

---Moves a header's child to the end of its list.
---@param parentKey string
---@param childKey string
function OptionsFrame:MoveChildToEnd(parentKey, childKey)
	local parent = self.navEntries[parentKey]
	if parent == nil or parent.children == nil then
		return
	end
	for index, key in ipairs(parent.children) do
		if key == childKey then
			table.remove(parent.children, index)
			table.insert(parent.children, childKey)
			return
		end
	end
end

-- ─────────────────────────────────────────────────────────────────────
-- Navigation
-- ─────────────────────────────────────────────────────────────────────

---The entry whose children a header row lists: its own, or its lone spec's, so a class with one spec has no spec tier.
---@param entry TRB.Options.OptionsFrame.NavEntry
---@return TRB.Options.OptionsFrame.NavEntry
function OptionsFrame:GetNavDriver(entry)
	if entry.isClass and entry.children ~= nil and #entry.children == 1 then
		local only = self.navEntries[entry.children[1]]
		if only ~= nil and only.isSpec then
			return only
		end
	end
	return entry
end

---Expands or collapses a header row, building its panel first where the sections it lists come from one.
---@param key string
function OptionsFrame:ToggleHeader(key)
	local entry = self.navEntries[key]
	if entry == nil then
		return
	end
	local driver = self:GetNavDriver(entry)
	if driver.panel == nil and driver.builder then
		driver.builder()
	end
	driver.collapsed = not driver.collapsed
	self:RefreshNav()
end

---Select and show the given category, section, or spec. A header or spec opens the section last shown under it.
---@param key string
function OptionsFrame:SelectCategory(key)
	if not self.navEntries[key] then
		return
	end

	local entry = self.navEntries[key]

	-- Lazy loading: if no panel but a builder exists, call builder to construct the panel.
	-- The builder is expected to call RegisterSpecPanel which populates entry.panel.
	if entry.panel == nil and entry.builder then
		entry.builder()
	end

	if entry.children ~= nil and #entry.children > 0 then
		local childKey = entry.lastChildKey
		if childKey == nil or self.navEntries[childKey] == nil then
			childKey = entry.children[1]
		end
		self:SelectCategory(childKey)
		return
	end

	-- Sections of one panel swap inside it, so it stays shown.
	if self.currentPanel and self.currentPanel ~= entry.panel then
		self.currentPanel:Hide()
	end
	-- Clear active edit box tracking when switching panels
	TRB.Frames.activeBarTextEditBox = nil
	TRB.Frames.activeBarTextCursorPosition = nil

	-- Expand every header above this entry, and have each reopen on it.
	local child = entry
	while child.parentKey and self.navEntries[child.parentKey] do
		local parent = self.navEntries[child.parentKey]
		parent.collapsed = false
		parent.lastChildKey = child.key
		child = parent
	end

	-- Show new panel
	local tabs = TRB.Functions.OptionsUi.Tabs
	if entry.panel then
		if entry.section ~= nil then
			tabs:ShowSection(entry.panel, entry.section)
		end
		entry.panel:Show()
		self.currentPanel = entry.panel
	end
	self.selectedKey = key

	-- Show/hide the Bar Text Variables flyout based on the new panel's active tab
	local host = entry.panel and tabs:GetActiveTabHost(entry.panel)
	local barTextScrollChild = host and tabs:GetShownBarTextScrollChild(host, host.lastTabId)
	if host and (host.lastTabId == "barText" or barTextScrollChild ~= nil) then
		-- Swap to the new spec's variables panel
		tabs:ActivateBarTextVariablesPanel(barTextScrollChild)
	else
		tabs:HideAllBarTextVariablesPanels()
	end

	self:RefreshNav()
end

---Lays out one nav entry and everything listed under it, and returns the updated yOffset
---@param key string
---@param depth integer # 0 for the top level
---@param yOffset number
---@param shown boolean # False under a collapsed header
---@return number
function OptionsFrame:RenderNavEntry(key, depth, yOffset, shown)
	local entry = self.navEntries[key]
	if not entry then
		return yOffset
	end

	local driver = self:GetNavDriver(entry)
	local isHeader = driver.children ~= nil
	local indent = depth * NAV_INDENT

	if not shown then
		if entry.button then
			entry.button:Hide()
		end
	else
		if not entry.button then
			local iconInfo = nil
			if entry.isClass then
				iconInfo = GetNavIcon(entry.key, nil)
			elseif entry.isSpec then
				iconInfo = GetNavIcon(entry.parentKey, entry.key)
			end
			entry.button = CreateNavButton(self.navScrollChild, entry.label, indent, isHeader, iconInfo, depth == 0 and isHeader)
			local selfRef = self
			local k = entry.key
			if isHeader then
				entry.button:SetScript("OnClick", function()
					selfRef:ToggleHeader(k)
				end)
			else
				entry.button:SetScript("OnClick", function()
					selfRef:SelectCategory(k)
				end)
			end
		end

		entry.button:SetPoint("TOPLEFT", self.navScrollChild, "TOPLEFT", 4 + indent, yOffset)
		entry.button:SetWidth(NAV_WIDTH - 34 - indent)
		entry.button:Show()

		-- Update selected highlight
		if self.selectedKey == key then
			entry.button.selectedTexture:Show()
		else
			entry.button.selectedTexture:Hide()
		end

		-- Update arrow rotation: 0 = right-pointing (collapsed), -π/2 = down-pointing (expanded)
		if entry.button.arrow then
			entry.button.arrow:SetRotation(driver.collapsed and 0 or (-math.pi / 2))
		end

		-- Color spec text red when disabled
		if driver.isSpec and driver.parentKey then
			local specName = string.sub(driver.key, #driver.parentKey + 2)
			local enabled = TRB.Data.settings
				and TRB.Data.settings.core
				and TRB.Data.settings.core.enabled
				and TRB.Data.settings.core.enabled[driver.parentKey]
				and TRB.Data.settings.core.enabled[driver.parentKey][specName]
			if enabled == false then
				entry.button.label:SetTextColor(1, 0.3, 0.3)
			elseif depth == 0 then
				entry.button.label:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
			else
				entry.button.label:SetTextColor(1, 1, 1)
			end
		end

		yOffset = yOffset - NAV_BUTTON_HEIGHT - NAV_BUTTON_PAD
	end

	if driver.children then
		local childrenShown = shown and not driver.collapsed
		for _, childKey in ipairs(driver.children) do
			yOffset = self:RenderNavEntry(childKey, depth + 1, yOffset, childrenShown)
		end
	end

	return yOffset
end

---Render a list of top-level nav keys into the scroll child and return the updated yOffset
---@param keys string[]
---@param yOffset number
---@return number
function OptionsFrame:RenderNavSection(keys, yOffset)
	for _, topKey in ipairs(keys) do
		yOffset = self:RenderNavEntry(topKey, 0, yOffset, true)
	end
	return yOffset
end

---Rebuild the nav button layout
function OptionsFrame:RefreshNav()
	self:EnsureFrame()

	local yOffset = -4

	-- Main nav items (top section)
	yOffset = self:RenderNavSection(self.navOrder, yOffset)

	-- Bottom nav items (always last)
	if #self.navBottomOrder > 0 then
		yOffset = self:RenderNavSection(self.navBottomOrder, yOffset)
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
