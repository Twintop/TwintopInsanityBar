---@diagnostic disable: undefined-field, undefined-global, redundant-parameter
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

-- Two changelogs, one tab each: the flavor's (Flavors\<Flavor>\News.lua) and Core's (Core\News.lua). This
-- file only renders them.

-- Tab keys. A changelog links to a tab as tab:<key>, which is how a Core-only release points readers on.
local TAB_FLAVOR = "flavor"
local TAB_CORE = "core"
local TAB_GROUP_PREFIX = "News"

local newsFrame = CreateFrame("Frame", "TRB_News_Frame", UIParent, "BackdropTemplate")
newsFrame:SetFrameStrata("DIALOG")
newsFrame:SetFrameLevel(500)
newsFrame:EnableMouse(true)
newsFrame:SetMovable(true)
-- Anchor before clamping. A clamped frame with no points takes the screen rect as its anchor
-- origin, and anchoring it to UIParent afterwards fails the anchor family check.
newsFrame:SetPoint("CENTER", UIParent)
newsFrame:SetClampedToScreen(true)
newsFrame:RegisterForDrag("LeftButton")
newsFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
newsFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
local isConstructed = false

---Opens a link from either reader: tab links, GitHub issue numbers, and plain URLs.
---@param link string
---@param text string
local function OnHyperlinkClick(_, link, text)
	if link == "window:close" then
		TRB.Functions.News:Hide()
	elseif link:match("^tab:") then
		TRB.Functions.OptionsUi.Tabs:SwitchToTabByNamePrefix(TAB_GROUP_PREFIX, link:sub(5))
	elseif link:match("https?://") then
		StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = text, url = link })
	elseif link:match("^#%d+$") then
		local issueId = string.sub(link, 2)
		local url = "https://github.com/Twintop/TwintopInsanityBar/issues/" .. issueId
		local titleText = string.format(L["NewsHyperlinkViewIssueOnGitHub"], link)
		StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = titleText, url = url })
	end
end

---Builds one tab's reader: the markdown rendered as HTML with the shared fonts and link handling.
---@param scrollChild Frame
---@param name string
---@param markdown string
local function BuildReader(scrollChild, name, markdown)
	local simpleHtml = CreateFrame("SimpleHTML", name, scrollChild)
	simpleHtml:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 5, -5)
	simpleHtml:SetPoint("BOTTOMRIGHT", scrollChild, "BOTTOMRIGHT", 5, -35)
	simpleHtml:SetWidth(600)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h1", "SystemFont_Huge1")
	simpleHtml:SetTextColor("h1", 1.0, 0.82, 0.0, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h2", "SystemFont_Large")
	simpleHtml:SetTextColor("h2", 0.45, 0.75, 1.0, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h3", "SystemFont_Med3")
	simpleHtml:SetTextColor("h3", 0.9, 0.9, 0.9, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("p", "GameFontHighlight")
	simpleHtml:SetTextColor("p", 0.78, 0.78, 0.78, 1)

	simpleHtml:SetHyperlinkFormat("[|cff4da6ff|H%s|h%s|h|r]")
	simpleHtml:SetScript("OnHyperlinkClick", OnHyperlinkClick)
	simpleHtml:SetScript("OnHyperlinkEnter", function() SetCursor("Interface\\CURSOR\\vehichleCursor.PNG") end)
---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetScript("OnHyperlinkLeave", function() SetCursor(nil) end)

	simpleHtml:SetText(LMD:ToHTML(markdown))
end

function TRB.Functions.News:BuildNewsPopup()
	isConstructed = true
	TRB.Functions.News:Hide()
	---@diagnostic disable-next-line: missing-fields
	newsFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile =  "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	})
	newsFrame:SetBackdropColor(0, 0, 0, 0.95)
	newsFrame:SetWidth(650)
	newsFrame:SetHeight(505)

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(newsFrame, L["NewsHeaderTwintopsResourceBarUpdates"], oUi.xCoord, 0)

	local closeX = CreateFrame("Button", nil, newsFrame, "UIPanelCloseButton")
	closeX:SetPoint("TOPRIGHT", newsFrame, "TOPRIGHT", -2, -2)
	closeX:SetScript("OnClick", function()
		TRB.Functions.News:Hide()
	end)

	local closeButton = TRB.Functions.OptionsUi.Primitives:BuildButton(newsFrame, L["Close"], 510, -10, 100, 25)
	closeButton:ClearAllPoints()
	closeButton:SetPoint("BOTTOMRIGHT", -5, 5)
	closeButton:SetScript("OnClick", function(self, ...)
		TRB.Functions.News:Hide()
	end)

	---@type CheckButton
	local f = CreateFrame("CheckButton", "TwintopResourceBar_News_ShowAgain", newsFrame, "ChatConfigCheckButtonTemplate")
	f:SetPoint("BOTTOMLEFT", 5, 5)
	getglobal(f:GetName() .. 'Text'):SetText(L["NewsCheckboxShowOnNewVersion"])
---@diagnostic disable-next-line: inject-field
	f.tooltip = L["NewsCheckboxShowOnNewVersionTooltip"]
	f:SetChecked(TRB.Data.settings.core.news.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.news.enabled = self:GetChecked()
	end)

	-- Override LibMarkdown inline color escapes for a cleaner palette
	LMD.config["strong"]  = "|cffffcc00"
	LMD.config["/strong"] = "|r"
	LMD.config["em"]      = "|cffff9966"
	LMD.config["/em"]     = "|r"
	LMD.config["code"]    = "|cffaaaadd"
	LMD.config["/code"]   = "|r"
	LMD.config["pre"]     = "<p>|cffaaaadd"
	LMD.config["/pre"]    = "|r</p><br />"

	-- The tab row and both readers share a container that stops short of the bottom controls.
	local tabContainer = CreateFrame("Frame", "TRB_News_Frame_Tabs", newsFrame)
	tabContainer:SetPoint("TOPLEFT", newsFrame, "TOPLEFT", 0, -30)
	tabContainer:SetSize(650, 440)
	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(tabContainer, TAB_GROUP_PREFIX, {
		{ TAB_FLAVOR, L[TRB.Flavor.nameKey], oUi.tabWidth.large, function(scrollChild)
			BuildReader(scrollChild, "TRB_News_HTML_Frame", TRB.Flavor.newsContent or "")
		end },
		{ TAB_CORE, L["NewsTabCore"], oUi.tabWidth.large, function(scrollChild)
			BuildReader(scrollChild, "TRB_News_Core_HTML_Frame", TRB.Details.coreNewsContent or "")
		end },
	}, 0)
	for _, tabsheet in pairs(tabContainer.tabsheets) do
		tabsheet:SetBackdropColor(0, 0, 0, 1)
	end

	-- ... and this is the popup the URL links open.
	StaticPopupDialogs["LIBMARKDOWNDEMOFRAME_URL"] = {
		OnShow = function(self, data)
			self:SetWidth(450)
			self:SetFormattedText(string.format(L["NewsHyperlinkGeneric"], data.title))
			self:GetEditBox():SetText(data.url)
			self:GetEditBox():SetAutoFocus(true)
			self:GetEditBox():HighlightText()
		end,
		OnAccept = function(self)
			self:Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
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
end

function TRB.Functions.News:Hide()
	newsFrame:Hide()
end

---Opens the window on the flavor tab, marking the running version as seen.
function TRB.Functions.News:Show()
	if not isConstructed then
		TRB.Functions.News:BuildNewsPopup()
	end
	TRB.Functions.OptionsUi.Tabs:SwitchToTabByNamePrefix(TAB_GROUP_PREFIX, TAB_FLAVOR)

	if TRB.Data.settings.core.news.lastUpdate ~= TRB.Details.addonVersion then
		TRB.Data.settings.core.news.lastUpdate = TRB.Details.addonVersion
	end
	newsFrame:Show()
end

function TRB.Functions.News:Init()
	if TRB.Data.settings.core.news.enabled and TRB.Data.settings.core.news.lastUpdate ~= TRB.Details.addonVersion then
		TRB.Functions.News:Show()
	end
end
