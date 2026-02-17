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

-- Lookup tables for class/spec icons (all-lowercase class keys)
local CLASS_IDS = {
	deathknight = 6,
	demonhunter = 12,
	druid = 11,
	evoker = 13,
	hunter = 3,
	mage = 8,
	monk = 10,
	paladin = 2,
	priest = 5,
	rogue = 4,
	shaman = 7,
	warlock = 9,
	warrior = 1,
}

local SPEC_INDICES = {
	deathknight = { blood = 1, frost = 2, unholy = 3 },
	demonhunter = { havoc = 1, vengeance = 2, devourer = 3 },
	druid = { balance = 1, feral = 2, guardian = 3, restoration = 4 },
	evoker = { devastation = 1, preservation = 2, augmentation = 3 },
	hunter = { beastMastery = 1, marksmanship = 2, survival = 3 },
	mage = { arcane = 1, fire = 2, frost = 3 },
	monk = { brewmaster = 1, mistweaver = 2, windwalker = 3 },
	paladin = { holy = 1, protection = 2, retribution = 3 },
	priest = { discipline = 1, holy = 2, shadow = 3 },
	rogue = { assassination = 1, outlaw = 2, subtlety = 3 },
	shaman = { elemental = 1, enhancement = 2, restoration = 3 },
	warlock = { affliction = 1, demonology = 2, destruction = 3 },
	warrior = { arms = 1, fury = 2, protection = 3 },
}

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

		if CLASS_IDS[lookupClass] and SPEC_INDICES[lookupClass] then
			local classId = CLASS_IDS[lookupClass]
			local specIndex = SPEC_INDICES[lookupClass][bareSpec]
			if classId and specIndex and GetSpecializationInfoForClassID then
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

---@param parent Frame
---@param label string
---@param indent number
---@param isHeader boolean
---@param iconInfo table|nil {atlas=string} or {texture=number}
---@return Frame
local function CreateNavButton(parent, label, indent, isHeader, iconInfo)
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
		---@diagnostic disable-next-line: inject-field
		btn.icon = icon
		textLeftOffset = 2 + NAV_ICON_SIZE + 3
	end

	-- Text
	local text = btn:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(isHeader and GameFontNormal or GameFontHighlightSmall)
	text:SetJustifyH("LEFT")
	text:SetPoint("LEFT", textLeftOffset, 0)
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
	mainFrame:SetClampedToScreen(true)
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

	-- Nav scroll frame
	local navScroll = CreateFrame("ScrollFrame", "TRB_OptionsFrame_NavScroll", navFrame, "UIPanelScrollFrameTemplate")
	navScroll:SetPoint("TOPLEFT", 4, -4)
	navScroll:SetPoint("BOTTOMRIGHT", -26, 4)

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

	-- Divider above footer
	local footerDivider = mainFrame:CreateTexture(nil, "ARTWORK")
	footerDivider:SetHeight(1)
	footerDivider:SetPoint("BOTTOMLEFT", footerFrame, "TOPLEFT", 0, 0)
	footerDivider:SetPoint("BOTTOMRIGHT", footerFrame, "TOPRIGHT", 0, 0)
	footerDivider:SetColorTexture(0.4, 0.4, 0.4, 0.8)

	-- Footer: version text (left)
	local versionText = footerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	versionText:SetPoint("LEFT", 8, 0)
	versionText:SetTextColor(0.6, 0.6, 0.6, 1)
	local versionStr = TRB.Details.addonVersion
	if TRB.Details.addonReleaseDate and TRB.Details.addonReleaseDate ~= "" then
		versionStr = versionStr .. " (" .. TRB.Details.addonReleaseDate .. ")"
	end
	versionText:SetText(versionStr)

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
			panel:SetParent(self.contentArea)
			panel:ClearAllPoints()
			panel:SetAllPoints(self.contentArea)
			panel:Hide()

			-- If the button was already created (during RefreshNav) with no panel,
			-- it has no click handler yet. Set it now.
			if self.navEntries[specKey].button then
				local selfRef = self
				local k = specKey
				self.navEntries[specKey].button:SetScript("OnClick", function()
					selfRef:SelectCategory(k)
				end)
			end
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
		children = nil,
		collapsed = false,
		button = nil,
		builder = builder,
	}
	table.insert(self.navEntries[classKey].children, specKey)

	-- Re-parent the panel into content area, hide it
	if panel then
		panel:SetParent(self.contentArea)
		panel:ClearAllPoints()
		panel:SetAllPoints(self.contentArea)
		panel:Hide()
	end

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

	local entry = self.navEntries[key]

	-- Lazy loading: if no panel but a builder exists, call builder to construct the panel.
	-- The builder is expected to call RegisterSpecPanel which populates entry.panel.
	if entry.panel == nil and entry.builder then
		entry.builder()
	end

	-- Hide current panel
	if self.currentPanel then
		self.currentPanel:Hide()
	end
	-- Hide the Bar Text Variables flyout when switching panels
	if TRB.Frames.barTextVariablesPanel then
		TRB.Frames.barTextVariablesPanel:Hide()
	end
	if self.selectedKey and self.navEntries[self.selectedKey] and self.navEntries[self.selectedKey].button then
		self.navEntries[self.selectedKey].button.selectedTexture:Hide()
	end

	-- If this entry has a parent class header, expand it
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

---Render a list of nav keys into the scroll child and return the updated yOffset
---@param keys string[]
---@param yOffset number
---@return number
function OptionsFrame:RenderNavSection(keys, yOffset)
	for _, topKey in ipairs(keys) do
		local entry = self.navEntries[topKey]
		if entry then
			-- Create or update button
			local isHeader = (entry.children ~= nil and #entry.children > 0)
			if not entry.button then
				local iconInfo = isHeader and GetNavIcon(entry.key, nil) or nil
				entry.button = CreateNavButton(self.navScrollChild, entry.label, 0, isHeader, iconInfo)
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
			entry.button:SetWidth(NAV_WIDTH - 34)
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
						local childIconInfo = GetNavIcon(entry.key, childEntry.key)
						childEntry.button = CreateNavButton(self.navScrollChild, childEntry.label, NAV_INDENT, false, childIconInfo)
							local selfRef = self
							local ck = childEntry.key
							childEntry.button:SetScript("OnClick", function()
								selfRef:SelectCategory(ck)
							end)
						end

						childEntry.button:SetPoint("TOPLEFT", self.navScrollChild, "TOPLEFT", 4 + NAV_INDENT, yOffset)
						childEntry.button:SetWidth(NAV_WIDTH - 34 - NAV_INDENT)
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
