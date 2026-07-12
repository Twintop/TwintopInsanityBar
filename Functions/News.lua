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

# 12.0.7.4-alpha02 (2026-07-13)
## General
### Cast Bar

- Bulk profession crafting (e.g. **Create All**) now shows as one merged, channel-style bar covering the whole queue, its total time computed from the remaining items and the single craft cast time. Tick marks at each craft boundary; `$castSpellName` shows progress as `Recipe Name 3 / 10`. Controlled by the new **Merge Bulk Crafting** option (on by default).

---

# 12.0.7.4-alpha01 (2026-07-12)
## General

- Rename the profile dropdown on the Global Options screen to **Global Profile: NAME**, from **Profile: NAME**, to distinguish it from the per-specialization profile dropdowns.

### Cast Bar

- Add a new **Cast Bar** for every specialization, covering standard, channeled, and empowered casts, with the same size, anchoring, texture, color, and bar text options as every other bar.
- Per-specialization visibility on the **Visibility** tab: **Casting**, **Channeling**, **Empowered**, **Always Show**, or **Never Show**, plus an **In Vehicle** hard-hide, active/inactive alpha, and fade controls. By default the bar shows while casting and lingers 0.25 seconds after a cast ends.
- Latency and pushback shown as bar overlays, with matching bar text variables.
- Channel tick markers, driven by a user-editable per-spell tick rate list with built-in defaults. Handles fixed-tick-count (Mind Flay) and fixed-duration (Void Torrent) channels, including chained ones.
- Empower stage threshold lines and per-level fill colors (a Base charging color, then Levels I through IV), with optional **Fill Each Empower Level Separately**. Only shown for specializations with empowered abilities (Windwalker Monk, Evoker) and the global Cast Bar screen.
- Bar text variables `$castTime`, `$castTimeRemaining`, `$castLatency`, `$castLatencyMs`, `$castPushback`, `$castSpellName`, and `$castSpellId`; the `#casting` icon shows the casting spell.
- A top-level **Cast Bar** options entry with global versions of every section and a **Global Profile** selector. Sections can follow global settings per specialization (or all at once) and be copied between Global Options, specializations, and profiles via **Copy...**.

## Hunter
### Survival

- (WIP) Add support for Raptor Swipe as its own threshold line.

## Priest
### Discipline

- Add new bar text variables for Harsh Discipline tracking: `$harshDisciplineTime`, `$harshDisciplineStacks`, and `$harshDisciplineMaxStacks`, and icon `#harshDiscipline`.

---

# 12.0.7.3-release (2026-07-03)
## General

- [#783 - @misterwiki](#783) Enhance bar visibility options to allow bars to be shown or hidden always when Skyriding or in Steady Flight, or, when actively in flight in either mode.
- [#784 - @EricaPomme](#784) Fix threshold flickering when bar is anchored to Cooldown Manager frames.

### Localization

- [#787 - @MOSS099](#787) Updated translations for Simplified Chinese (zhCN).

## Paladin
### Holy

- Add `$holyPowerPlusCasting` bar text variable, showing current Holy Power plus the amount coming from the active cast.

## Warlock

- Add `$castingShards` and `$castingSoulShards` as synonyms for `$castingFragments`, and fix all three to reflect Soul Shard spending (not just generation) as a negative value.
- Add `$soulShardsPlusCasting` bar text variable, showing current Soul Shards plus the net amount from the active cast (generation or spending).

---

# 12.0.7.2-release (2026-06-28)
## General
### Localization

- [#777](#777) Add an alternate number formatting method for CJK locales (zhCN/zhTW/koKR) that groups by myriads on a 10,000-step scale.
- [#782](#782) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Death Knight

- Add an option to disable showing the Rune recharge progress.

## Warlock
### Demonology

- Add a new dedicated overlay color for the Soul Shard that will be refunded when Hand of Gul'dan finishes casting while Dominion of Argus is active.

## Warrior
### Protection

- [#548](#548) Add support for tracking Violent Outburst procs, including a new bar text variable `$voTime` and icon (`#violentOutburst`).
- [#548](#548) Add a Color Indicator and audio cue for Violent Outburst being active.
- [#548](#548) Add support for tracking the Ignore Pain granted when Shield Slam consumes Violent Outburst.

---

# 12.0.7.1-release (2026-06-22)
## General

- [#519](#519) Add support for displaying healing absorbs (debuffs that consume incoming healing, such as Necrotic Wounds) as a new overlay on the Health Bar. This is distinct from the existing absorb overlay, which represents damage-absorbing shields.
- [#519](#519) Add a new bar text variable `$healAbsorb`. As this is a secret value, when used in bar text logic it will return only TRUE or FALSE and not the current value.
- [#777](#777) Fix an issue where changing the health bar color type wouldn't be reflected until after a UI reload.
- [#777](#777) Fix an issue where changing the shared font face would cause bar text to disappear until entering combat.
- Fix overlays to actually respect the setting to not overlap borders.

### Localization

- [#781](#781) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Monk
### Brewmaster

- [#775](#775) Allow the color of `$stagger` and `$staggerPercent` text to be configured independently of the bar color.

## Rogue

- [#779](#779) Add a new "5 Combo Points" color option for the 5th Combo Point, with a checkbox to control whether it overrides the Penultimate/Final color when you have a maximum of 5 or 6 Combo Points.

## Warlock
### Destruction

- Add support for tracking Infernal Bolt and Ruination procs.
- Add new bar text variables `$infernalBoltTime` and `$ruinationTime` and icon (`#ruination`).
- Add Color Indicators for Infernal Bolt and Ruination being available.
- Add audio cues for when Infernal Bolt and Ruination become available.

### Demonology

- Fix Dominion of Argus detection.
- Add End of Dominion of Argus support as a new Color Indicator.
- Add new default bar text entry to track Dominion of Argus time remaining.
- Add support for tracking Infernal Bolt and Ruination procs.
- Add new bar text variables `$infernalBoltTime` and `$ruinationTime`.
- Add Color Indicators for Infernal Bolt and Ruination being available.
- Add audio cues for when Infernal Bolt and Ruination become available.

---

# 12.0.7.0-release (2026-06-16)
## General

- [#42](#42) Allow custom threshold lines to be set using an offset value from max, like Overcapping, instead of just as a fixed absolute value.
- [#771](#771) Fix a rounding issue when changing colors.
- [#771](#771) Fix an issue where bar visibility would not respect transparency settings upon login or UI reloads.

### Localization

- [#770](#770), [#772](#772), [#776](#776) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Warlock
### Affliction

- [#774](#774) Add support for tracking Shard Instability.
- Add bar text variables for Shard Instability: `$shardInstabilityTime`, `$shardInstabilityStacks`, and `$shardInstabilityMaxStacks`. As the time and stack count are secret values, when used in bar text logic they will return only TRUE or FALSE and not the current value.
- Add a bar text icon variable for Shard Instability (`#shardInstability`).
- Add a Color Indicator for Shard Instability being active.

---

# 12.0.5.13-release (2026-06-07)
## General

- [#42](#42) Add support for custom threshold lines on all bars, including multi-node bars (e.g. Combo Points, Angelic Feather, Maelstrom Weapon, etc.).
- Fix an issue where overlay would sometimes flicker.
- Allow Bar Text entries to be copied to any profile rather than just the currently active ones.

### Localization

- [#768](#768) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Warlock
### Affliction

- [#760](#760) Add prediction support for Shadow of Death.

### Demonology

- [#760](#760) Add prediction support for Shadow Bolt, Infernal Bolt, Ruination, Shadow of Death, Summon Felguard, Call Dreadstalkers, Demonic Core, and Dominion of Argus.
- Add bar text variables for Demonic Core: `$demonicCoreTime` and `$demonicCoreStacks`. As these are both secret values, when used in bar text logic they will return only TRUE or FALSE and not the current value.
- Add bar text variable for Dominion of Argus: `$doaTime`.
- Add Color Indicators for Demonic Core and Dominion of Argus being active.
- Add an audio cue option for gaining Demonic Core.

### Destruction

- [#760](#760) Add prediction support for Infernal Bolt, and Chaos Bolt.

---

# 12.0.5.12-release (2026-06-01)
## General

- [#672](#672) Add options to duplicate bar text entries and copy them between Global and specialization bar text settings.
- [#672](#672) Enhance the "Bar Text Variables" flyout to show more information about each variable.
- Fix some Lua errors related to texture, font, and sound dropdowns.

### Localization

- [#767](#767) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Paladin
### Holy

- [#354](#354) Add incoming Holy Power generation overlay support for Flash of Light and Holy Light.
- [#354](#354) Add bar text icon variables for Flash of Light (`#flashOfLight`) and Holy Light (`#holyLight`).
- [#354](#354) Add `$castingHolyPower` as a valid bar text variable.

## Warlock
### Affliction

- [#760](#760) Add Soul Shard spending overlay support for Seed of Corruption and Unstable Affliction.
- [#760](#760) Add bar text icon variables for Seed of Corruption (`#seedOfCorruption`) and Unstable Affliction (`#unstableAffliction`).
- [#760](#760) Add `$castingFragments` as a valid bar text variable.

### Demonology

- [#760](#760) Add incoming Soul Shard generation overlay support for Demonbolt and Soul Shard spending overlay support for Hand of Gul'dan.
- [#760](#760) Add bar text icon variables for Demonbolt (`#demonbolt`) and Hand of Gul'dan (`#handOfGuldan`).
- [#760](#760) Add `$castingFragments` as a valid bar text variable.

### Destruction

- [#760](#760) Add Soul Shard spending overlay support for Chaos Bolt.
- [#760](#760) Add incoming Soul Shard generation tracking for Soul Fire.
- [#760](#760) Add bar text icon variables for Incinerate (`#incinerate`), Soul Fire (`#soulFire`), and Chaos Bolt (`#chaosBolt`).

---

# 12.0.5.11-release (2026-05-29)
## General
### Localization

- [#759](#759), [#761](#761), [#766](#766) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Druid

- Add visibility options for bars to be shown or hidden in specific Druid forms.
- Fix a bug where the visibility options for a bar were not being applied correctly when formswitching.

---

# 12.0.5.10-release (2026-05-25)
## Mage
### Fire

- [#690](#690) Add support for tracking Fire Blast charges and recharge time as a configurable multi-node bar. Fire Blast Charges can be positioned, sized, styled, and used as bar text anchors like other bar groups.
- [#690](#690) Add `$fireBlastCharges`, `$fireBlastChargesMax`, and `$fireBlastTime` bar text variables, plus default per-node recharge timer text and color options for each node and the partial recharge fill.

---

# 12.0.5.9-release (2026-05-24)
## General

- [#529](#529) Add new visibility overrides to always hide a bar when certain conditions are met, regardless of other visibility settings.
- [#541](#541) Add new value and percent visibility conditions for Mana Bars for Shadow Priest, Balance Druid, and Elemental Shaman.
- Fix an issue where specialization level bar text was not being rotated into the correct orientation when the bar's orientation was changed between horizontal and vertical. Shared/Global bar text remains unchanged when bar orientation changes occur.

### Localization

- [#756](#756), [#758](#758) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.5.8-release (2026-05-20)
## General

- [#327](#327) Allow bars to be oriented in vertical and horizontal orientations via new "Fill Direction" option. Left to Right/Right to Left are the default horizontal fill directions, and Top to Bottom/Bottom to Top are the new vertical fill directions. This is configurable on a per-bar/bar group basis.
- [#327](#327) Allow multi-node bars to have their growth direction be configured independently of their fill direction via new "Growth Direction" option. This will allow bar groups like Warrior Defensives to have each bar on its own row.
- [#327](#327) Add a new option to allow bars to match their anchor bar's (or frame's, for Edit Mode) height in addition to width.

### Localization

- [#753](#753) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Monk
### Brewmaster

- Ensure Stagger threshold lines respect the value of the "Threshold line overlap bar border?" option.

---

# 12.0.5.7-release (2026-05-18)
## General

- [#717](#717) Add a new color option for secondary bars that have partial fills (Destruction Warlock's Soul Shards) or time-based generation (Evoker's Essence, Feral Druid's Combo Points).
- [#717](#717) Standardize the layout of all secondary bar color options to be in the same format and order across all specializations.
- [#751](#751) Add a toggle to allow for overlays (casting, spending, absorb, incoming heal, etc.) to have their height match the full bar height including the border.
- Allow the settings window to be dragged off screen instead of being clamped within the screen boundaries.
- Allow the settings window to be dragged by other areas besides the title bar.

### Localization

- [#749](#749) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Death Knight

- [#752](#752) Fix an issue that would reset Rune Overcapping color settings to defaults when previously completely disabled.

## Druid

- Fix some issues with bar dimensions and visibility settings not being respected when switching between shapeshift forms.
- Ensure that the "Show Combo Points in all forms" option is respected when switching forms.

## Hunter
### Marksmanship

- Update the Focus gain from Steady Shot to be 20 Focus per cast, up from 10 Focus.
- Add support for Invigorating Pulse.

## Warlock
### Destruction

- [#685](#685) Add support for tracking the Soul Shard Fragments generated by hardcasting Incinderate via a bar overlay and new `$castingFragments` bar text variable.
- Add support for Diabolic Embers increasing the number of Soul Shard Fragments generated by Incinerate.

---

# 12.0.5.6-release (2026-05-02)
## Monk
### Mistweaver

- Ensure that Sheilun's Gift also resets Vivify instant color change.

---

# 12.0.5.5-release (2026-05-01)
## General
### Localization

- [#748](#748) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Hunter
### Marksmanship

- Fix Font & Text settings menu options overlapping.

## Monk
### Mistweaver

- Include Serene Surge procs in the optional instant Vivify color change.
- Disable Heart of the Jade Serpent color changes until detection can be improved.

---

# 12.0.5.4-release (2026-04-29)
## General

- [#747](#747) Add a way to copy shared settings between profiles, specializations, and global options. Settings sections that are supported have a new "Copy..." button next to the Global Options check box.
- Add support for Wago Profile Import/Export APIs.

### Localization

- [#746](#746) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.5.3-release (2026-04-25)
## General
### Localization

- [#744](#744) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Devourer

- Properly account for Celestial Echoes increasing the Fury gain of Consume.
- Adjust how Soul Fragments and Collapsing Star are tracked when full aura updates occur.

## Evoker

- Add new bar text variables for Essence Burst, showing the remaining duration (`$essenceBurstTime`) and number of stacks (`$essenceBurstStacks`). As these are both secret values, when used in bar text logic they will return only TRUE or FALSE and not the current value.

## Paladin

- Add new bar text variable for Divine Insight, showing the remaining duration (`$divineInsightTime`). As this is a secret value, when used in bar text logic it will return only TRUE or FALSE and not the current value.

## Priest
### Discipline

- Add new bar text variables for Surge of Light, showing the remaining duration (`$surgeOfLightTime`) and number of stacks (`$surgeOfLightStacks`). As these are both secret values, when used in bar text logic they will return only TRUE or FALSE and not the current value.

### Holy

- Add new bar text variables for Surge of Light, showing the remaining duration (`$surgeOfLightTime`) and number of stacks (`$surgeOfLightStacks`). As these are both secret values, when used in bar text logic they will return only TRUE or FALSE and not the current value.
- Force Benediction procs to clear correctly if the buff expires.

---

# 12.0.5.2-release (2026-04-22)
## Evoker

- Blizzard has made Essence regeneration timing values a `secret`. Add a workaround to calculate time remaining on Essence regeneration.

---

# 12.0.5.1-release (2026-04-22)
## General

- Fix an issue where bar profiles would reset to defaults for other classes.
- Fix an issue where when LibSharedMedia assets go missing Lua errors would occur instead of graceful resetting to default values.

---

# 12.0.5.0-release (2026-04-21)
## General

- [#742](#742) Add support for profiles for individual specializations, groupable into named profiles for easier sharing. This is configurable on a per-specialization and per-character basis with a default fallback.
- [#742](#742) Add support for profiles for Global Options. Only one is able to be used at a time and it continues to apply to all specializations that are using global settings.
- [#726](#726) Fix issues with primary and secondary stats now being secret values and not directly accessible.
- Fix an issue where manually tracked buff timers (e.g., Voidform, Metamorphosis, Dragonrage, Apotheosis, Eclipse, Ascendance, etc.) would not reset when the player dies.
- Adjust bar layout and visibility to be more aware of talent-gated bars (e.g., Holy Priest's Lightweaver) to prevent gaps in the layout when those bars are not active.

### Localization

- [#741](#741) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Hunter
### Marksmanship

- [#726](#726) Add Explosive Shot as a new threshold line.

]====]

local newsFrame = CreateFrame("Frame", "TRB_News_Frame", UIParent, "BackdropTemplate")
newsFrame:SetFrameStrata("DIALOG")
newsFrame:SetFrameLevel(500)
newsFrame:EnableMouse(true)
newsFrame:SetMovable(true)
newsFrame:SetClampedToScreen(true)
newsFrame:RegisterForDrag("LeftButton")
newsFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
newsFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
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
	newsFrame:SetBackdropColor(0, 0, 0, 0.95)
	newsFrame:SetWidth(650)
	newsFrame:SetHeight(480)
	newsFrame:SetPoint("CENTER", UIParent)

	local newsPanelParent = TRB.Functions.OptionsUi.Tabs:CreateTabFrameContainer("TRB_News_Frame_Panel", newsFrame, 640, 410)
	local newsPanel = newsPanelParent.scrollFrame.scrollChild
	newsPanelParent:SetBackdropColor(0, 0, 0, 1)
	newsPanelParent:ClearAllPoints()
	newsPanelParent:SetPoint("TOPLEFT", 5, -30)

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

	local simpleHtml = CreateFrame("SimpleHTML", "TRB_News_HTML_Frame", newsPanel)
	simpleHtml:SetPoint("TOPLEFT", newsPanel, "TOPLEFT", 5, -5)
	simpleHtml:SetPoint("BOTTOMRIGHT", newsPanel, "BOTTOMRIGHT", 5, -35)
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

	-- Override LibMarkdown inline color escapes for a cleaner palette
	LMD.config["strong"]  = "|cffffcc00"
	LMD.config["/strong"] = "|r"
	LMD.config["em"]      = "|cffff9966"
	LMD.config["/em"]     = "|r"
	LMD.config["code"]    = "|cffaaaadd"
	LMD.config["/code"]   = "|r"
	LMD.config["pre"]     = "<p>|cffaaaadd"
	LMD.config["/pre"]    = "|r</p><br />"

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
