---@diagnostic disable: undefined-field, undefined-global, redundant-parameter
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

local content = [====[
*Localization of the addon is still underway! If you have any interest in helping translate, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know. Thank you!*

---

# 12.0.0.0-alpha09 (2025-11-18)
## General

## Priest
### [#463](#463) Shadow

- Add support for tracking Screams of the Void via bar text variable `$sotvTime`.
- Add support for tracking Entropic Rift and its extension behavior via Darkening Horizon. This is available via bar text variables `$entropicRiftTime` and `$entropicRiftExtensionsRemaining`.
- Add an optional bar border color change when you have Entropic Rift active.
- Improve reliability of Mind Flay: Insanity tracking.

---

# 12.0.0.0-alpha08 (2025-11-17)
## [#462](#462) General

- Restore some more granular bar value setting for non-secrets. This should help with showing timers as bars for certain abilities.
- Add a basic way of tracking buff auras in some situations.

## Warrior
### [#489](#489) Protection

- Restore Shield Block timer bar and bar text variables (including timer and charge counts).
- Restore Ignore Pain timer bar and bar text variables (timer only); add some rudimentary early loss of buff detection.
- Clean up options menus to only show things that are functional.

---

# 12.0.0.0-alpha07 (2025-11-16)
## Demon Hunter
### [#491](#491) Devourer

- Add support for Soul Fragments.
- Add Soul Fragments color change for when Void Metamorphosis is ready.
- Add Soul Fragments color change for when Collapsing Star is ready when in Void Metamorphosis.
- Adjust default bar text to be centered and include Soul Fragments.
- Fix an issue with exporting setting configurations.
- Add English localization entries for currently available feature strings.

---

# 12.0.0.0-alpha06 (2025-11-15)
## [#462](#462) General

- Enhance detection of procs or ability changes for tracking purposes.

## Demon Hunter
### [#491](#491) Devourer

- Add barebones support for Devourer, tracking Fury.
- Add threshold line for Void Ray. This will only show when Void Metamorphosis is not active.
- Add Metamorphosis tracking for bar color change. No duration is available due to API limitations, however the `$voidMeta` bar text variable has been added to indicate if Void Metamorphosis is active for Boolean logic purposes.

## Druid
### [#468](#468) Balance

- Fix an issue where Eclipse detection was not functioning consistently depending on the state of talents.

---

# 12.0.0.0-alpha05 (2025-11-14)
## [#462](#462) General

- Update large number abbreviations of resources (e.g. Mana) to use Blizzard's built-in methods that allow `secret`s to be passed into them. This has been configured to attempt to reproduce the previous 4-digit outputs as closely as possible but is not 100% identical.

## Shaman

- Fix implementations to allow the bar to function in a mimimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Clean up options menus to only show things that are functionable.

### [#483](#483) Elemental

- Restore Ascendance tracking. Add support for Preeminence.

### [#484](#484) Enhancement

- Disable Maelstrom Weapon UX elements. At the time, this is untrackable due to it being a buff and not a proper resource in the eyes of the API.
- Restore Ascendance tracking and add support for Doom Winds. Both of these use the `$ascendanceTime` bar text variable. Detection does not work when talented into Deeply Rooted Elements due to API limitations.

### [#485](#485) Restoration

- Restore Ascendance tracking. Add support for Preeminence.

---

# 12.0.0.0-alpha04 (2025-11-13)
## Druid
### [#468](#468) Balance

- Added support for Whirling Stars for calculating the duration of Eclipse when using Celestial Alignment or Incarnation: Chosen of Elune.
- Fixed an issue where Eclipse duration was not being calculated when talented into both Whirling Stars and incarnation: Chosen of Elune.
- Re-enable Soul of the Forest and Moon Guardian for predictive Astral Power from hardcasting.

## Hunter

- Fix implementations to allow the bar to function in a mimimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Threshold likes work but are probably wrong/don't show correct use status/are missing abilities.

### [#474](#474) Beast Mastery

- Remove most of the old Barbed Shot tracking.
- Disable Bestial Wrath and Beast Cleave features until changes can be properly implemented.

### [#475](#475) Marksmanship

- Restore Trueshot tracking. Add support for Can't Miss, Won't Miss.

### [#476](#476) Survival

- Cull almost everything to reflect the changes made. You've got a Raptor Strike threshold line, what more do you *really* need?

---

# 12.0.0.0-alpha03 (2025-11-11)
## General

- [#462 - FIX](#462) The following specializations are now functional again to varying degrees:
<br/>&emsp;&ensp;- Demon Hunter: Havoc, Vengeance
<br/>&emsp;&ensp;- Druid: Balance, Restoration
<br/>&emsp;&ensp;- Monk: Mistweaver
<br/>&emsp;&ensp;- Priest: Discipline, Holy, Shadow
<br/>&emsp;&ensp;- Warrior: Arms, Fury
- [#462 - UPDATE](#462) Updated implementations for the following due to API changes:
<br/>&emsp;&ensp;- Continue to use `UnitPowerMax()` as it is no longer `secret`.
<br/>&emsp;&ensp;- Adjusted spell cast handling to avoid `secret` values from `UNIT_SPELLCAST_CHANNEL_*` events. This is likely a bug that will be fixed in a future beta build.
<br/>&emsp;&ensp;- Hide or manually override (disable) many options that are no longer functional due to API changes.
<br/>&emsp;&ensp;- Improve spell usable state detection.
<br/>&emsp;&ensp;- Update threshold line rendering to use some alternate approaches to avoid computations with `secret` values. 
<br/>&emsp;&ensp;- Disable all passive tracking and related threshold lines.
<br/>&emsp;&ensp;- Disable most bar and border color changes.
<br/>&emsp;&ensp;- Disable bar text variables that are no longer functional. Some of these ability icons remain for now.
<br/>&emsp;&ensp;- Remove DoT tracking.
<br/>&emsp;&ensp;- Adjusted default bar text to reflect current functionality.

### Healers

- [#490 - UPDATE](#490) Removed the following functionality due to API changes:
<br/>&emsp;&ensp;- Passive mana generation tracking from Symbol of Hope, Blessing of Winter, Innervate, Mana Tide Totem, Molten Radiance, and channeled mana potions.
<br/>&emsp;&ensp;- Mana potions and their cooldown tracking.
<br/>&emsp;&ensp;- Thresholds for spells that restore mana.
<br/>&emsp;&ensp;- Change mana text formatting to use Blizzard's built-in formatting of large numbers.

## Demon Hunter
### Havoc

- [#466 - UPDATE](#466) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Metamorphosis detection. This re-enabled bar color change, end of color change, bar text, and Metamorphosis specific threshold lines.
<br/>&emsp;&ensp;- Remove Fel Eruption.

### Vengeance

- [#467 - UPDATE](#467) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Disable Soul Fragment bars since they can no longer be easily tracked.
<br/>&emsp;&ensp;- Fix Metamorphosis detection. This re-enabled bar color change, end of color change, and bar text.
<br/>&emsp;&ensp;- Remove Fel Eruption.

## Druid
### Balance

- [#468 - UPDATE](#468) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Eclipse detection. This re-enabled bar color change, end of color change, and bar text for Eclipse (Solar), Eclipse (Lunar), Celestial Alignment, and Incarnation: Chosen of Elune.
<br/>&emsp;&ensp;- Boomkin Form detection is not presently working.

### Restoration

- [#470 - UPDATE](#470) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Incarnation: Tree of Life detection. This re-enabled bar color change, end of color change, and bar text.
<br/>&emsp;&ensp;- Fix and update Efflorescence detection. Add support for the new Lifetreading talent.

## Monk
### Mistweaver

- [#477 - UPDATE](#477) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Mana tea is disabled but may make a return.
<br/>&emsp;&ensp;- Vivacious Vivification and Spirit of the Jade Serpent detection is disabled but may make a return.

## Priest
### Discipline

- [#465 - UPDATE](#465) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Disable Power Word bars since they can no longer be easily tracked.

### Holy

- [#464 - UPDATE](#465) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Disable Holy Word bars since they can no longer be easily tracked.

### Shadow

- [#463 - UPDATE](#463) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Mind Devourer detection. This re-enabled bar border color change, bar text, audio cues, and Shadow Word: Madness threshold lines color change.
<br/>&emsp;&ensp;- Fix Mind Flay: Insanity detection. This re-enabled bar border color change, audio cues, and bar text.
<br/>&emsp;&ensp;- Disable Voidform tracking for now since it can no longer be easily tracked. This may make a return in the future.

## Warrior
### Arms

- [#487 - UPDATE](#487) Barebones updates to make Arms functional again.

### Fury

- [#488 - UPDATE](#488) Barebones updates to make Fury functional again.

---

# 12.0.0.0-alpha02 (2025-10-27)
## General

- [#462 - FIX](#462) Disable smooth bar updates due to Lua errors with secrets.

---

# 12.0.0.0-alpha01 (2025-10-27)
## General

- [#462 - NEW](#462) Reports of my demise have been greatly exaggerated. The Resource Bar lives on!
- [#462 - NEW](#462) Most specs are still bricked, but I am working on unbricking them one at a time with Shadow Priest as the guinea pig.
- [#462 - UPDATE](#462) Strip out all calls to things related to specific targets and `UNIT_AURA`. 
- [#462 - UPDATE](#462) Change how max resource is determined to be based off of talents and hardcoded values.
- [#462 - UPDATE](#462) Adjust bar and threshold rendering to not do computations with `secret` values.

## Priest
### Shadow

- [#463 - UPDATE](#462) Strip out everything but Shadow Word: Madness and resource detection.
- [#463 - UPDATE](#462) Track if Voidtouched is talented and adjust the maximum resource accordingly.
- [#463 - UPDATE](#462) Clean up default bar text since most of the old variables don't work anymore (yet?).

]====]

local newsFrame = CreateFrame("Frame", "TRB_News_Frame", UIParent, "BackdropTemplate")
newsFrame:SetFrameStrata("DIALOG")
local isConstructed = false

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
	newsFrame:SetBackdropColor(0, 0, 0, 0.5)
	newsFrame:SetWidth(650)
	newsFrame:SetHeight(480)
	newsFrame:SetPoint("CENTER", UIParent)

	local newsPanelParent = TRB.Functions.OptionsUi:CreateTabFrameContainer("TRB_News_Frame_Panel", newsFrame, 640, 410)
	local newsPanel = newsPanelParent.scrollFrame.scrollChild
	newsPanelParent:SetBackdropColor(0, 0, 0, 1)
	newsPanelParent:ClearAllPoints()
	newsPanelParent:SetPoint("TOPLEFT", 5, -30)

	TRB.Functions.OptionsUi:BuildSectionHeader(newsFrame, L["NewsHeaderTwintopsResourceBarUpdates"], oUi.xCoord, 0)
	local closeButton = TRB.Functions.OptionsUi:BuildButton(newsFrame, L["Close"], 510, -10, 100, 25)
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

	local simpleHtml = CreateFrame("SimpleHTML", "TRB_News_HTML_Frame", newsPanel)
	simpleHtml:SetPoint("TOPLEFT", newsPanel, "TOPLEFT", 5, -5)
	simpleHtml:SetPoint("BOTTOMRIGHT", newsPanel, "BOTTOMRIGHT", 5, -35)
	simpleHtml:SetWidth(600)
	
---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h1", "SubzoneTextFont")
	simpleHtml:SetTextColor("h1", 0, 0.6, 1, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h2", "Fancy22Font")
	simpleHtml:SetTextColor("h2", 0, 1, 0, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h3", "NumberFontNormalLarge")
	simpleHtml:SetTextColor("h3", 0, 0.8, 0.4, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("p", "GameFontNormal")
	simpleHtml:SetTextColor("p", 1, 1, 1, 1)

	simpleHtml:SetHyperlinkFormat("[|cff3399ff|H%s|h%s|h|r]")

	simpleHtml:SetScript("OnHyperlinkClick", 
		function(f, link, text, ...)
			if link=="window:close" then
				TRB.Functions.News:Hide()
			elseif link:match("https?://") then
				StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = text, url = link })
			elseif link:match("^#%d+$") then
				local issueId = string.sub(link, 2)
				local url = "https://github.com/Twintop/TwintopInsanityBar/issues/" .. issueId
				local titleText = string.format(L["NewsHyperlinkViewIssueOnGitHub"], link)
				StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = titleText, url = url })
			end 
		end)

	simpleHtml:SetScript("OnHyperlinkEnter", function(f) SetCursor("Interface\\CURSOR\\vehichleCursor.PNG") end)
---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetScript("OnHyperlinkLeave", function(f) SetCursor(nil)									 end)

	simpleHtml:SetText(LMD:ToHTML(content))
	-- ... and this is the popup it opens.
	StaticPopupDialogs["LIBMARKDOWNDEMOFRAME_URL"] = {
		OnShow = function(self, data)
			self:SetWidth(450)
			self.text:SetFormattedText(string.format(L["NewsHyperlinkGeneric"], data.title))
			self.editBox:SetText(data.url)
			self.editBox:SetAutoFocus(true)
			self.editBox:HighlightText()
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

function TRB.Functions.News:Show()
	if not isConstructed then
		TRB.Functions.News:BuildNewsPopup()
	end

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