---@diagnostic disable: undefined-field, undefined-global, redundant-parameter
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

local content = [====[
*Localization of the addon is underway! If you're interested in helping translate, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know. Thank you!*

---

# 11.0.0.0-alpha08 (2024-07-13)
## General 

## Demon Hunter
### Havoc

- [#357 - UPDATE (Twintop)](#357) Updates to reflect the state of Havoc in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Warblade's Hunger
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Chaos Strike threshold line has the "special" coloring while active.

## Hunter
### Beast Mastery

- [#365 - UPDATE (Twintop)](#365) Updates to reflect the state of Beast Mastery in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Hunter's Prey
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Show Kill Shot threshold line when active.

### Marksmanship

- [#366 - UPDATE (Twintop)](#366) Updates to reflect the state of Beast Mastery in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Deathblow
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Show Kill Shot threshold line when active.

## Monk
### Mistweaver

- [#368 - UPDATE (Twintop)](#368) Updates to reflect the state of Augmentation in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Mana Tea
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Add threshold lines, showing how much mana you will restore if you channeled Mana Tea right now and a passive threshold line to show how much mana you will end up with while channeling.
<br/>&emsp;&ensp;&emsp;&ensp;- Sheilun's Gift
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track how many clouds (stacks) you have and when it is maxed out.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Optional bar border color change when at maximum stacks.
<br/>&emsp;&ensp;&emsp;&ensp;- Heart of the Jade Serpent
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track how stacks the buff is at and when the buff is up.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Optional bar border color changes when you can use Sheilun's Gift to gain the proc, or, when the buff is active.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$sgStacks` - Number of Sheilun's Gift clouds (stacks) available to use
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsStacks` - Number of stacks of Heart of the Jade Serpent
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsMaxStacks` - Maximum number of stacks of Heart of the Jade Serpent before the buff occurs
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsRemainingStacks` - Remaining number of stacks of Heart of the Jade Serpent before the buff occurs
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsTime` - Time remaining on Heart of the Jade Serpent buff
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#hotjs` - Heart of the Jade Serpent
<br/>&emsp;&ensp;&emsp;&ensp;- `#sheilunsGift` - Sheilun's Gift

### Windwalker

- [#369 - UPDATE (Twintop)](#369) Updates to reflect the state of Windwalker in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Heart of the Jade Serpent
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track how many stacks the buff is at and when the buff is up.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Optional bar border color changes when you can use Strike of the Windlord to gain the proc, or, when the buff is active.
<br/>&emsp;&ensp;&emsp;&ensp;- Flurry Charge
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track how many stacks the buff is at.
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- Serenity
<br/>&emsp;&ensp;- Updated:
<br/>&emsp;&ensp;&emsp;&ensp;- Combat Wisdom
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Hide Expel Harm threshold line when talented.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$flurryChargeStacks` - Number of stacks of Flurry Charge
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsStacks` - Number of stacks of Heart of the Jade Serpent
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsMaxStacks` - Maximum number of stacks of Heart of the Jade Serpent before the buff occurs
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsRemainingStacks` - Remaining number of stacks of Heart of the Jade Serpent before the buff occurs
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsReady` - Is Heart of the Jade Serpent buff ready to be used. LOGIC VARIABLE ONLY!
<br/>&emsp;&ensp;&emsp;&ensp;- `$hotjsTime` - Time remaining on Heart of the Jade Serpent buff
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#hotjs` - Heart of the Jade Serpent

## Shaman
### Elemental

### Enhancement

### Restoration

- [#379 - UPDATE (Twintop)](#379) Updates to reflect the state of Windwalker in beta:
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- Serenity

---

# 11.0.0.0-alpha07 (2024-06-29)
## General 

- [#356 - UPDATE (Twintop)](#356) Adjust logic used to detect talents being active to:
<br/>&emsp;&ensp;- Properly detect the active hero talent tree.
<br/>&emsp;&ensp;- No longer require "baseline" talents from being explicitly flagged as such.

## Evoker
### Augmentation

- [#364 - UPDATE (Twintop)](#364) Updates to reflect the state of Augmentation in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Melt Armor support, applied via Breath of Eons.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track when the debuff is on a target and allow for the mana bar to change color while active.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$meltArmorTime` - Time remaining on Melt Armor on your current target
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#meltArmor` - Melt Armor

### Devastation

- [#362 - UPDATE (Twintop)](#362) Updates to reflect the state of Devastation in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Melt Armor support, applied via Deep Breath.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track when the debuff is on a target and allow for the mana bar to change color while active.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$meltArmorTime` - Time remaining on Melt Armor on your current target
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#meltArmor` - Melt Armor

## Hunter
### Beast Mastery

- [#365 - UPDATE (Twintop)](#365) Updates to reflect the state of Beast Mastery in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Black Arrow threshold line and options.
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- A Murder of Crows threshold line and options.
<br/>&emsp;&ensp;&emsp;&ensp;- Serpent Sting threshold line and options.
<br/>&emsp;&ensp;&emsp;&ensp;- Wailing Arrow threshold line and options.
<br/>&emsp;&ensp;- Moved from Class Tree to Specialization Tree:
<br/>&emsp;&ensp;&emsp;&ensp;- Barrage, Kill Command

### Marksmanship

- [#366 - UPDATE (Twintop)](#366) Updates to reflect the state of Beast Mastery in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Black Arrow threshold line and options.
<br/>&emsp;&ensp;- Updated:
<br/>&emsp;&ensp;&emsp;&ensp;- Wailing Arrow threshold line now only appears when it replaces Aimed Shot.
<br/>&emsp;&ensp;- Removed: 
<br/>&emsp;&ensp;&emsp;&ensp;- Kill Command
<br/>&emsp;&ensp;- Moved from Class Tree to Specialization Tree:
<br/>&emsp;&ensp;&emsp;&ensp;- Barrage
- (FIX (Twintop)) Show the correct Focus cost in bar text and in the bar progress for Aimed Shot.

### Survival

- [#367 - UPDATE (Twintop)](#367) Updates to reflect the state of Beast Mastery in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Wildfire Bomb threshold line and options.
<br/>&emsp;&ensp;&emsp;&ensp;- Bombardier support for Explosive Shot's threshold line.
<br/>&emsp;&ensp;- Updated:
<br/>&emsp;&ensp;&emsp;&ensp;- Coordinated Assault buff ID.
<br/>&emsp;&ensp;- Removed: 
<br/>&emsp;&ensp;&emsp;&ensp;- Carve
<br/>&emsp;&ensp;&emsp;&ensp;- Serpent Sting threshold line and options.
<br/>&emsp;&ensp;- Moved from Class Tree to Specialization Tree:
<br/>&emsp;&ensp;&emsp;&ensp;- Kill Command

## Monk
### Windwalker

- (FIX (Twintop)) Show the correct Energy cost in bar text and in the bar progress for Crackling Jade Lightning.

## Paladin
### Holy

- [#370 - UPDATE (Twintop)](#370) Updates to reflect the state of Holy in beta:
<br/>&emsp;&ensp;- Removed: 
<br/>&emsp;&ensp;&emsp;&ensp;- Daybreak
<br/>&emsp;&ensp;&emsp;&ensp;- Glimmer of Light

---

# 11.0.0.0-alpha06 (2024-06-18)
## General
### Healers

- [#384 - UPDATE (Twintop)](#384) Add detection for all Alchemist Stones.

## Paladin
### Holy

- (FIX (Twintop)) Fix Lua error when attempting to hide the bar.

---

# 11.0.0.0-alpha05 (2024-06-16)
## General

- (UPDATE (Twintop)) Change how the global variable, `Global_TwintopResourceBar`, gets data populated to reduce memory usage.

## Demon Hunter
### Havoc

- [#357 - UPDATE (Twintop)](#357) Updates to reflect the state of Havoc in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Art of the Glaive support, including Glaive Flurry and Rending Strike.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- In addition to Chaos Theory being active, now Rending Strike being active will change the threshold lines of Chaos Strike and Annihilation to be colored "special".
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Glaive Flurry being active will change the threshold lines of Blade Dance and Death Sweep to be colored "special".
<br/>&emsp;&ensp;&emsp;&ensp;- Student of Suffering support, including passive Fury being included in `$passive` and in the Global variable.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$aotgStacks` - Number of Art of the Glaive stacks you currently have
<br/>&emsp;&ensp;&emsp;&ensp;- `$aotgTime` - Time remaining on Art of the Glaive
<br/>&emsp;&ensp;&emsp;&ensp;- `$gfTime` - Time remaining on Glaive Flurry
<br/>&emsp;&ensp;&emsp;&ensp;- `$rsTime` - Time remaining on Rending Strike
<br/>&emsp;&ensp;&emsp;&ensp;- `$sosTime` - Time remaining on Student of Suffering
<br/>&emsp;&ensp;&emsp;&ensp;- `$sosTime` - Number of ticks left on Student of Suffering
<br/>&emsp;&ensp;&emsp;&ensp;- `$sosTime` - Fury from Student of Suffering
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#artOfTheGlaive` - Art of the Glaive
<br/>&emsp;&ensp;&emsp;&ensp;- `#glaiveFlurry` - Glaive Flurry
<br/>&emsp;&ensp;&emsp;&ensp;- `#rendingStrike` - Rending Strike
<br/>&emsp;&ensp;&emsp;&ensp;- `#studentOfSuffering` - Student of Suffering

### Vengeance

- [#358 - UPDATE (Twintop)](#358) Updates to reflect the state of Havoc in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Art of the Glaive support. *NOTE:* this is only the main buff, not any effects from using Reaver's Glaive. Currently, Reaver's Glaive is bugged and can't be triggered.
<br/>&emsp;&ensp;&emsp;&ensp;- Student of Suffering support, including passive Fury being included in `$passive` and in the Global variable.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$aotgStacks` - Number of Art of the Glaive stacks you currently have
<br/>&emsp;&ensp;&emsp;&ensp;- `$aotgTime` - Time remaining on Art of the Glaive
<br/>&emsp;&ensp;&emsp;&ensp;- `$sosTime` - Time remaining on Student of Suffering
<br/>&emsp;&ensp;&emsp;&ensp;- `$sosTime` - Number of ticks left on Student of Suffering
<br/>&emsp;&ensp;&emsp;&ensp;- `$sosTime` - Fury from Student of Suffering
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#artOfTheGlaive` - Art of the Glaive
<br/>&emsp;&ensp;&emsp;&ensp;- `#studentOfSuffering` - Student of Suffering

## Monk
### Mistweaver

- [#368 - UPDATE (Twintop)](#368) Updates to reflect the state of Mistweaver in beta:
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- Set bonuses: Soulfang Infusion (T30 / S2 Dragonflight)

---

# 11.0.0.0-alpha04 (2024-06-15)
## General

- (UPDATE (Twintop)) Support tracking of target buffs/debuffs with applications.

### Healers

- [#382 - UPDATE (Twintop)](#382) Remove Conjured Chillglobe support.

## Priest
### Discipline

- [#371 - UPDATE (Twintop)](#371) Updates to reflect the state of Discipline in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Voidwraith support.
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- Items: Conjured Chillglobe and Imbued Frostweave Slippers support.

### Holy

- [#372 - UPDATE (Twintop)](#372) Updates to reflect the state of Holy in beta:
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- Items: Conjured Chillglobe and Imbued Frostweave Slippers support.
<br/>&emsp;&ensp;&emsp;&ensp;- Set bonuses: Divine Conversation (T28 / S3+S4 Shadowlands) and Prayer Focus (T29 / S1 Dragonflight)

### Shadow

- [#373 - UPDATE (Twintop)](#373) Updates to reflect the state of Shadow in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Void Blast (Insanity generation) and Void Infusion (Insanity generation modifier).
<br/>&emsp;&ensp;&emsp;&ensp;- Voidwraith support.
<br/>&emsp;&ensp;- Removed:
<br/>&emsp;&ensp;&emsp;&ensp;- Death's Torment (Dragonflight Season 3 set bonus) support and customizations.
<br/>&emsp;&ensp;- Correct issue when tracking Shadowy Apparition spawns from Mind Blast.
<br/>&emsp;&ensp;- Flag Mindgames as a PvP talent.
<br/>&emsp;&ensp;- Adjust the baseline Insanity generation of the following:
<br/>&emsp;&ensp;&emsp;&ensp;- Mind Flay: Insanity - 2 / tick
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$reStacks` - Resonant Energy stacks on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$reTime` - Remaining time on Resonant Energy on your current target

---

# 11.0.0.0-alpha03 (2024-06-14)
## General

- [#356 - FIX (Twintop)](#356) Fix more Lua errors caused by API additions and game modifications for 11.0 since last bar release.
- (FIX (Twintop)) Don't allow PvP abilities to show threshold lines if you aren't in PvP or they aren't talented.

## Hunter
### Beast Mastery

- (FIX (Twintop)) Prevent bar and bar border color changes when your character does not have the appropriate talent learned.

---

# 11.0.0.0-alpha02 (2024-06-09)
## Druid
### Balance

- (FIX (Twintop)) Fix Lua errors when casting New Moon, Half Moon, and Full Moon.

---

# 11.0.0.0-alpha01 (2024-06-08)
## General

- [#356 - FIX (Twintop)](#356) Fix Lua errors caused by API additions and game modifications for 11.0. At this time, no class changes have been implemented, but the bar should be minimally functional (with Dragonflight options/talents) for all previously supported specs.

## Warrior
### Arms

- [#380 - FIX (Twintop)](#380) Update Thunder Clap spell id.

### Fury

- [#381 - FIX (Twintop)](#381) Update Thunder Clap spell id.

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
    simpleHtml:SetScript("OnHyperlinkLeave", function(f) SetCursor(nil)                                     end)

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