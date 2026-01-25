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

### Congratulations! You survived the Addon Apocalypse. You had us worried there for a bit -- dust yourself off and get back to raiding!*

---

### Bar text for all specializations has been reset to new defaults to accommodate API changes.

---

# 12.0.0.8-release (2026-01-26)
## General

- [#555](#555) Fix a Lua error when attempting to export settings for a class that doesn't yet have any configuration.

---

# 12.0.0.7-release (2026-01-25)
## Evoker
### Devastation

- [#523](#523) Add Dragonrage buff tracking via bar change and `$dragonrageTime` bar text variable with configurable expiration warning. This includes support for extensions via the Animosity talent.

## Monk
### Brewmaster

- [#518](#518) Add Invoke Niuzao, the Black Ox buff tracking via bar change and `$niuzaoTime` bar text variable with configurable expiration warning.

## Paladin
### Retribution

- Ensure the bar background color setting is for Mana is present in options.

---

# 12.0.0.6-release (2026-01-24)
## General

- Modify default visibility options for bars to be "Always" instead of "In Combat".

## Death Knight
### Unholy

- Ensure the bar background color setting is for Runic Power is present in options.

## Demon Hunter
### Devourer

- [#550](#550) Fix Soul Fragments not always updating when changing talents or zoning into/out of instances.

## Druid
### Guardian

- Fix an issue where changing the text colors under the "Font & Text" tab would cause Lua errors. If you're impacted by this, contact Twintop for an import string fix or reset the Guardian bar to default.

---

# 12.0.0.5-release (2026-01-24)
## Druid
### Feral

- [#549](#549) Re-enable Apex Predator's Craving detection. This allows for bar color change, audio cue, and threshold usable notifications to function again.

## Paladin
### Retribution

- Fix health bar text variables `$health`, `$healthMax`, and `$healthPercent` not working.

---

# 12.0.0.4-release (2026-01-24)
## General
### Import/Export

- Fix an issue when exporting entire categories of settings for all specs at once.

## Demon Hunter
### Devourer

- [#546](#546) Add bar text logic variables `$voidRayUsable` and `$collapsingStarUsable` to indicate when Void Ray and Collapsing Star can be used.
- [#546](#546) Add `#collapsingStar` icon variable.
- Add dedicated bar color for when Collapsing Star is active.
- Restore the missing Soul Fragment/Collapsing Star bar's background color setting.
- Clean up some localization strings.

## Druid
### Balance

- [#546](#546) Add bar text logic variables `$starsurgeUsable` and `$starfallUsable` to indicate when Starsurge and Starfall can be used.

## Paladin

- [#542](#542) Add two new audio cues for when Holy Power is at or above a configured threshold. These default to 3 and 5 Holy Power.

## Priest
### Shadow

- [#546](#546) Add bar text logic variable `$shadowWordMadnessUsable` to indicate when Shadow Word: Madness can be used.
- [#546](#546) Fix `#shadowWordMadness` and `#swm` icon variables.

## Shaman
### Elemental

- [#546](#546) Add bar text logic variables `$earthShockUsable`, `$elementalBlastUsable`, and `$earthquakeUsable` to indicate when Earth Shock/Elemental Blast and Earthquake can be used.
- [#546](#546) Add `#earthShock` and `#earthquake` icon variables.

---

# 12.0.0.3-release (2026-01-23)
## General

- Adjust how manual tracking of buffs handles increases to duration. Now, when a duration increase occurs, the overall duration of the buff is reset to be the remaining duration.

## Mage
### Arcane

- [#547](#547) Fix infinite loop causing Lua errors when trying to build the bar.

## Shaman
### Enhancement

- [#545](#545) Fix Maelstrom Weapon overflow (stacks 6-10) color settings not being saved correctly.

## Warrior
### Protection

- [#543](#543) Add support for Heavy Repercussions and Shield Charge as a source of Shield Block duration.

---

# 12.0.0.2-release (2026-01-23)
## General

- [#519](#519) Add decimal precision settings for Health percentage bar text.
- [#532](#532) Add decimal precision settings for Mana percentage bar text.

### Localization

- [#531](#531) Temporarily disable the Russian Google Translate localization file to help address strange bar behavior and Lua errors.

## Druid

- [#534](#534) Fix how the shared bars for Druids are constructed to ensure that the correct settings are applied for each form, especially when making modifications to the configuration of another form's settings.
- [#539](#539) Fix Lua errors that would occur when logging in as non-Feral in Cat Form.

### Balance

- [#540](#540) Ensure that the "Flash bar" checkbox state is respected.

## Warlock
### Destruction

- [#536](#536) Restore missing border color settings for Soul Shards.

---

# 12.0.0.1-release (2026-01-22)
## General

- Fix a Lua error that could occur when adjusting the spacing of Combo Points (and other similar secondary resources).
- Temporarily re-add settings upgrade support for versions of the bar as far back as 7.3.5.

### Localization

- Regenerate the Google Translate localization file for Russian to help address strange bar behavior and Lua errors.

## Death Knight

- [#517](#517) Add a new optional Rune color change to alert you when you are overcapping Rune regeneration (i.e., fewer than 3 Runes on cooldown while in combat).

## Hunter
### Marksmanship

- Fix Lua errors due to outdated audio cue checks.

## Warrior
### Protection

- [#530](#530) Ensure that the duration of Shield Block is extended rather than reset when using multiple charges.
- [#530](#530) Properly account for Enduring Defenses talent when calculating Shield Block duration.

---

# 12.0.0.0-release (2026-01-20)
## [#468](#468) General
### New Features

- [#297](#297) Completely rebuilt the bar construction, control, and rendering system for greater flexibility and future features.
- [#297](#297) Add an optional Mana Bar for Balance Druid, Shadow Priest, and Elemental Shaman, including new bar text variables `$mana`, `$manaMax`, and `$manaPercent`.
- [#505](#505) Add an optional player health bar, including new bar text variables `$health`, `$healthMax`, and `$healthPercent`.
- [#195](#195) Allow primary, secondary, and health bars to be independently shown Always, In Combat, or Never.
- [#437](#437) Updated import/export to use Blizzard's `C_EncodingUtil` with Deflate compression for smaller string sizes. Previous import strings remain compatible.
- Add import/export API functions for external addon/tool integration.
- Add `$inCombatTime` bar text variable showing elapsed time since entering combat.
- Add under-the-hood support for tracking custom fixed-duration cooldowns.

### Removed Features (API Limitations)

- Time To Die (TTD) tracking has been removed.
- Passive resource generation tracking and related threshold lines.
- Casting bar and passive bar displays.
- DoT tracking on targets.
- Potion tracking and cooldowns.
- End Cap functionality.
- Overcap audio cues.

### Adjusted for Midnight

- Bar text for all specializations has been reset to new defaults to accommodate API changes.
- Large number abbreviations now use Blizzard's built-in formatting methods.
- Smooth bar update functionality restored using Blizzard's built-in methods.
- Bar border and resource text overcap notifications via color change continue to work.

## Death Knight
### [#499](#499) Blood, [#500](#500) Frost, and [#501](#501) Unholy

- Add full support for the Blood, Frost, and Unholy specializations.
- Add support for tracking Runic Power and Runes.
- Runes can be sorted by cooldown remaining or position.
- Bar text variables for rune timing (`$rune1Time` through `$rune6Time`) and readiness (`$rune1Ready` through `$rune6Ready`).
- Threshold lines for Runic Power spending abilities (Death Coil, Death Strike, Raise Ally, and spec-specific abilities).

## Demon Hunter
### [#466](#466) Havoc

- Adjusted Metamorphosis tracking for Midnight compatibility, including bar color changes and bar text.

### [#467](#467) Vengeance

- Adjusted Metamorphosis tracking for Midnight compatibility.
- Adjusted Soul Fragment tracking using threshold lines as a workaround.

### [#491](#491) Devourer

- Add full support for the new Devourer specialization.
- Track Fury as primary resource with Soul Fragments as secondary.
- Void Metamorphosis tracking with bar color change and `$voidMeta` bar text variable (and synonyms).
- Collapsing Star bar with threshold line showing when usable (30 stacks).
- Support for Soul Glutton talent reducing Void Metamorphosis threshold.

## Druid

- [#297](#297) Add support for displaying the resource bar appropriate to your current shapeshift form (e.g., Rage bar in Bear Form as Balance).

### [#468](#468) Balance

- Adjusted Eclipse detection for Midnight compatibility, including bar color changes for Eclipse (Solar), Eclipse (Lunar), Celestial Alignment, and Incarnation: Chosen of Elune.
- Soul of the Forest modifier updated to 40%.

### [#469](#469) Feral

- Adjusted Berserk and Incarnation: Avatar of Ashamane tracking with bar color changes.
- Add threshold line support for Frantic Frenzy.

### [#493](#493) Guardian

- Add full support for the Guardian specialization.
- Add support for tracking Rage with threshold lines for Rage-consuming abilities.
- Add Berserk and Incarnation: Guardian of Ursoc tracking with bar color changes and duration bar text.

### [#470](#470) Restoration

- Adjusted Incarnation: Tree of Life tracking for Midnight compatibility.
- Updated Efflorescence detection with support for the Lifetreading talent.

## Evoker
### [#471](#471) Devastation, [#472](#472) Preservation, and [#473](#473) Augmentation

- Adjusted Essence tracking for Midnight compatibility.
- Add optional audio cue when Essence drops at or below a configured threshold.

### [#473](#473) Augmentation

- Add Ebon Might tracking via `$ebonMightTime` with configurable bar color changes and audio cue when hardcast ability won't complete in time.

## Hunter
### [#474](#474) Beast Mastery

- Adjusted Beast Cleave tracking for Midnight compatibility (`$beastCleaveTime`).
- Adjusted Bestial Wrath tracking as a bar color change (previously border) with configurable end-of-buff warning color (`$bestialWrathTime`).
- Add threshold line support for Wailing Arrow and Wild Thrash.

### [#475](#475) Marksmanship

- Adjusted Trueshot tracking for Midnight compatibility with support for Can't Miss, Won't Miss.
- Add threshold line support for Wailing Arrow.

### [#476](#476) Survival

- Add Takedown bar change and `$takedownTime` bar text variable with configurable expiration warning.
- Add threshold line support for Boomstick and Hatchet Toss.
- Removed Arcane Shot, Wildfire Bomb, and Steady Shot.

## Mage

- Add full support for the Arcane, Fire, and Frost specializations.

### [#502](#502) Arcane

- Add support for tracking Mana and Arcane Charges.

### [#503](#503) Fire and [#504](#504) Frost

- Add support for tracking Mana.

## Monk
### [#494](#494) Brewmaster

- Add full support for the Brewmaster specialization.
- Add support for tracking Energy with threshold lines for Energy-consuming abilities.
- Add Stagger Bar using new bar architecture with customizable colors.
- Stagger bar colors `$stagger` and `$staggerPercent` based on current Stagger level.
- Configurable thresholds and threshold lines for Medium and Heavy Stagger.
- Support for Jade Flash causing Crackling Jade Lightning to have a cooldown.

### [#477](#477) Mistweaver

- Adjusted Vivacious Vivification tracking for Midnight compatibility with support for both Rising Sun Kick and Rushing Wind Kick.

### [#478](#478) Windwalker

- Adjusted Chi tracking for Midnight compatibility.
- Add Soothing Mist as threshold line (disabled by default).

## Paladin
### [#479](#479) Holy

- Adjusted Holy Power tracking for Midnight compatibility.
- Adjusted Apotheosis tracking including `$apotheosisTime` and bar color changes.

### [#497](#497) Protection and [#498](#498) Retribution

- Add full support for the Protection and Retribution specializations.
- Add support for tracking Mana and Holy Power.

## Priest
### [#465](#465) Discipline

- Adjusted Surge of Light tracking (bar text variables removed due to API limitations).
- Power Word bars have been disabled for now. Watch this space!

### [#464](#464) Holy

- Adjusted Apotheosis tracking including `$apotheosisTime` and bar color changes.
- Adjusted Surge of Light tracking (bar text variables removed due to API limitations).
- Holy Word bars and cooldown reduction tracking has been disabled for now. Watch this space!

### [#463](#463) Shadow

- Adjusted Voidform tracking including `$vfTime` and bar color changes.
- Adjusted Mind Devourer and Mind Flay: Insanity detection for Midnight compatibility.
- Add Screams of the Void tracking via `$sotvTime`.
- Add Entropic Rift tracking via `$entropicRiftTime` and `$entropicRiftExtensionsRemaining` with optional bar border color change.
- Updated Mind Flay and Halo Insanity generation values.

## Rogue

- Adjusted Combo Point tracking for Midnight compatibility, including Charged Combo Points.
- Removed Slice and Dice tracking and bar color changes.

### [#480](#480) Assassination

- Removed Echoing Reprimand.

###[#481](#481) Outlaw

- Removed Ghostly Strike.
- Roll the Bones color changes and buff tracking has been disabled for now. Watch this space!

### [#482](#482) Subtlety

- Removed Shuriken Tornado.

## Shaman
### [#483](#483) Elemental

- Adjusted Ascendance tracking for Midnight compatibility with Preeminence support.

### [#484](#484) Enhancement

- Adjusted Maelstrom Weapon tracking for Midnight compatibility.
- Toggle between 5 and 10 Maelstrom Weapon UI elements.
- Add color option for Maelstrom Weapon stacks 1-5.
- Adjusted Ascendance and Doom Winds tracking via `$ascendanceTime`.

### [#485](#485) Restoration

- Adjusted Ascendance tracking for Midnight compatibility with Preeminence support.

## Warlock

- Adjusted Soul Shard tracking for Midnight compatibility.

### [#486](#486) Affliction

- Removed Soul Shard bar color changes and bar text variables related to their buffs.

### [#495](#495) Demonology and [#496](#496) Destruction

- Add full support for the Demonology and Destruction specializations.

## Warrior
### [#487](#487) Arms and [#488](#488) Fury

- Adjusted Rage tracking for Midnight compatibility.
- Cleaned up Execute threshold line logic.

### [#489](#489) Protection

- Add Defensives Bar using new bar architecture.
- Adjusted Shield Block tracking including timer and charge counts.
- Adjusted Ignore Pain tracking with early buff loss detection.

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