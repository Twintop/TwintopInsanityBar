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

# 11.2.0.0-beta02 (2025-07-30)
## Priest
### Shadow

- [#457 - NEW](#457) Fix Subservient Shadows lua error.

---

# 11.2.0.0-beta01 (2025-07-12)
## Hunter
### Beast Mastery

- [#457 - NEW](#457) Make the following adjustments to match changes in the 11.2.0 PTR:
<br/>&emsp;&ensp;- **Removed**: Barrage

## Priest
### Shadow

- [#457 - NEW](#457) Make the following adjustments to match changes in the 11.2.0 PTR:
<br/>&emsp;&ensp;- **Added**: Horrific Visions (Idol of N'Zoth), Subservient Shadows
<br/>&emsp;&ensp;- **Updated**: Mind Melt -> Shattered Psyche
<br/>&emsp;&ensp;- **Updated Insanity values**: Mind Flay, Mind Flay: Insanity
<br/>&emsp;&ensp;- **Removed**: Deathspeaker, Mind Spike, Mind Spike: Insanity, Devoured Despair

---

# 11.1.7.4-release (2025-07-11)
## General

- (FIX) Adjust how debuffs are tracked.

## Warrior
### Protection

- [#455 - EXPERIMENTAL](#455) Remove some debug prints.

---

# 11.1.7.3-release (2025-07-03)
## Warrior
### Protection

- [#455 - EXPERIMENTAL](#455) Update default text and threshold line settings.

---

# 11.1.7.2-release (2025-07-03)
## General

- (NEW) Include `m1` as a default texture for status bars.

## Druid
### Feral

- [#456 - FIX](#456) Fix Energy not being updated properly.

## Warrior
### Protection

- [#455 - EXPERIMENTAL](#455) Add Protection Warrior support, tracking Rage, Ignore Pain, and Shield Block. This is still very much an experimental feature and work in progress.

---

# 11.1.7.1-release (2025-06-26)
## General

- [#454 - NEW](#454) Significantly improve performance by tracking spell casts and channeled abilities via events rather than polling.
- (FIX) Prevent the wrong specialization's UX from being loaded when role is automatically changed via entering/exiting instances.

## Priest
### Holy

- (FIX) Ensure the mana bar changes colors when a cast will bring its associated Holy Word off of cooldown, when enabled.

---

# 11.1.7.0-release (2025-06-17)
## General

- [#451 - UPDATE](#451) Restore original functionality, with fixes, to significantly reduce how often the current resource values need to be refresh from the API.
- [#453 - NEW](#453) Reduce the amount of redundant data refreshes for buff and debuff tracking.

---

# 11.1.5.10-release (2025-06-12)
## General

- [#451 - FIX](#451) Fix some issues with combo points not rendering correctly.

---

# 11.1.5.8-release (2025-06-11)
## General

- [#451 - ROLLBACK](#451) Revert some changes to how resource values get refreshed.

---

# 11.1.5.7-release (2025-06-10)
## General

- [#451 - NEW](#451) Significantly reduce how often the current resource values need to be refresh from the API.
- [#452 - NEW](#452) Significantly reduce how often primary and secondary stat values need to be refresh from the API.
- (FIX) Fix the bar not loading correctly on some specializations when it is a newly played class or settings for that class have been reset.

---

# 11.1.5.6-release (2025-06-06)
## General

- (FIX) Remove stray debug prints.

---

# 11.1.5.5-release (2025-06-05)
## General

- [#279 - NEW](#279) Add an option to hide threshold lines when out of range. This option is in addition to the existing option to change the color of threshold lines when its associated spell is out of range.
- [#448 - UPDATE](#448) Change how/where spell range checks are performed.
- [#449 - FIX](#449) Fix intermittent caching issues when switching specializations or talents.

## Demon Hunter
### Havoc

- [#447 - UPDATE](#447) Allow the "Special" threshold line color change for Chaos Theory, Glaive Flurry, and Rending Strike to be disabled.

### Vengeance

- [#447 - UPDATE](#447) Allow the "Special" threshold line color change for Soul Furnace to be disabled.

## Rogue
### Assassination

- [#410 - NEW](#410) Add a new threshold line color for Mutilate when the Echoing Reprimand buff is active.
- [#447 - UPDATE](#447) Allow the "Special" threshold line color change for Garrote to be disabled.

### Outlaw

- [#410 - NEW](#410) Add a new threshold line color for Sinister Strike when the Echoing Reprimand buff is active.
- [#446 - NEW](#446) Add a new threshold line color for Restless Blades. This will change an ability's threshold line color when using a finisher will cause that ability to come off cooldown.
- [#447 - UPDATE](#447) Allow the "Special" threshold line color change for Skull and Crossbones, Ruthless, and Opportunity to be disabled.

### Subtlety

- [#410 - NEW](#410) Add a new threshold line color for Gloomblade when the Echoing Reprimand buff is active.
- [#447 - UPDATE](#447) Allow the "Special" threshold line color change for Finality, Silent Storm, and Coup de Grace to be disabled.

## Shaman
### Elemental

- [#447 - UPDATE](#447) Allow the "Special" threshold line color change for Echoes of Great Sundering to be disabled.

---

# 11.1.5.4-release (2025-05-30)
## General

- [#443 - NEW](#443) Add a bar End Cap as a new UI element. This sits at the end of your current resource and provides a bit of visual buffer to make it easier to see what your current resource is at.
<br/>&emsp;&ensp;- Configurable width and color.
<br/>&emsp;&ensp;- Optional color change to have it match your current bar border color. Extra option to only match the border color when it is not the baseline color.
<br/>&emsp;&ensp;- Global bar settings available.
- (FIX) Apply LibSharedMedia value checks to global bar settings.
- (FIX) Correct messaging around invalid LibSharedMedia values.
- (UPDATE) Modify smooth bar and smooth frame implementations to be more granular. This should smooth out the resources even more for some specializations with constant passive resource regeneration (Energy, Focus).

## Hunter
### Survival

- [#445 - FIX (Koroshy)](#445) Correct logic around Serpent Sting tracking.

## Rogue
### Subtlety

- (FIX) Correct an issue with the options UI color swatch for Shadowcraft border color change.

---

# 11.1.5.3-release (2025-05-20)
## General

- (FIX) Fix Lua errors caused by still WIP features.

---

# 11.1.5.2-release (2025-05-20)
## General

- [#431 - UPDATE](#431) Separate options related to Threshold Lines to their own tab per specialization in the Options menu. Adjust the layout of these settings to be more consistent and extendable. Update import/export to handle thresholds as their own category.
- [#431 - NEW](#431) Add Global Bar Setting support for threshold line icon and positioning, color (separate for DPS and tanks; healers), and potions for healers.

## Druid
### Balance

- [#442 - FIX](#442) Ensure Moonkin Form's state is properly detected on login.

## Hunter
### Survival

- [#441 - NEW (Koroshy)](#440) Add optional border color change when Explosive Shot is usable.

## Monk
### Mistweaver

- [#444 - UPDATE](#444) Adjust Heart of the Jade Serpent's implementation to match changes made originally in 11.1.0. It will now cause the "ready" border color change when Sheilun's Gift is castable and both are talented. Remove outdated bar text variables. 

### Windwalker

- [#444 - UPDATE](#444) Adjust Heart of the Jade Serpent's implementation to match changes made originally in 11.1.0. It will now cause the "ready" border color change when Strike of the Windlord is castable and both are talented. Remove outdated bar text variables. 

---

# 11.1.5.1-release (2025-04-27)
## General

- [#421 - UPDATE](#421) When restoring bar text defaults, the UI will no longer reload. Instead, the Bar Text tab for that specialization will refresh with the restored default bar text entries.
- [#438 - NEW](#438) Update ability in range checks to use the new `SPELL_RANGE_CHECK_UPDATE` event.
- (FIX) Correct threshold out of range checks.

## Hunter
### Survival

- [#440 - NEW (Koroshy)](#440) Add support for tracking Tip of the Spear.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$totsStacks` - Number of stacks of Tip of the Spear
<br/>&emsp;&ensp;&emsp;&ensp;- `$totsTime` - Time remaining on Tip of the Spear
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#tipOfTheSpear` or `#tots` - Tip of the Spear
- (FIX) Show the correct cooldown status of Butchery on its threshold line.

## Warlock
### Affliction

- [#439 - FIX](#438) Add support for Shadow Embrace tracking when Drain Soul is not talented.
- (FIX) Ensure `$shadowEmbraceTime` bar text variable gets populated with a valid value.

---

# 11.1.5.0-release (2025-04-22)
## Hunter
### Beast Mastery

- [#436 - NEW](#436) Add an optional audio cue that plays when the buff from Beast Cleave fades.

---

# 11.1.0.10-release (2025-04-07)
## Hunter

- [#433 - FIX](#433) Fix options breaking for Marksmanship (and Survival).

---

# 11.1.0.9-release (2025-04-07)
## General

- [#429 - NEW](#423) Add Global Bar Setting support for bar, border, and background textures for the main bar and combo point bars.
- [#395 - UPDATE](#395) Change dropdown menus to use the new `Blizzard_Menu` instead of LibDropDownMenu.

## Priest
### Shadow

- [#427 - NEW (Koroshy)](#427) Add an audio cue when you gain a Power Infusion buff.

---

# 11.1.0.8-release (2025-03-14)
## General

- [#428 - FIX](#428) Fix a Lua error that occurs sporadically when mounting or on a dynamic flight mount.

---

# 11.1.0.7-release (2025-03-11)
## Priest
### Shadow

- [#426 - NEW](#426) Add TWW S2 2-piece bonus support for Jackpot! When the set bonus is active, casting Void Eruption or Dark Ascension will also include the Insanity gain from Void Bolt in the casting bar and related bar text variables.

---

# 11.1.0.6-release (2025-03-10)
## General

- (FIX) Fix a caching issue with threshold lines.
- (UPDATE) Change overcap check logic to be inclusive of the configured value.

## Priest
### Holy

- [#424 - FIX](#424) Prevent the bar color and duration of Apotheosis from being set to 0 when stunned or out of combat while talented into Sustained Potency.

### Shadow

- [#424 - FIX](#424) Prevent the bar color and duration of Voidform and Dark Ascension from being set to 0 when stunned or out of combat while talented into Sustained Potency.

## Warrior
### Arms

- (NEW) Add support for tracking Ravager.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$ravagerTicks` - Number of expected ticks remaining on Ravager
<br/>&emsp;&ensp;&emsp;&ensp;- `$ravagerRage` - Rage from Ravager
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#ravager` - Ravager

## Fury

- (NEW) Add support for tracking Bladestorm.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$bladestormTicks` - Number of expected ticks remaining on Bladestorm
<br/>&emsp;&ensp;&emsp;&ensp;- `$bladestormRage` - Rage from Bladestorm
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#bladestorm` - Bladestorm

---

# 11.1.0.5-release (2025-03-03)
## General

- [#423 - NEW](#423) Add Global Bar Setting support for position and size for the main bar and combo point UI elements.

## Priest
### Holy

- (FIX) Prevent bar text from disabled Holy Words from displaying.

---

# 11.1.0.4-release (2025-02-28)
## Priest

- (FIX) Fix intermittent Lua errors when switching specializations.

---

# 11.1.0.3-release (2025-02-27)
## General

- [#418 - FIX](#418) Fix regression with secondary stat values not updating for bar text.

---

# 11.1.0.2-release (2025-02-26)
## General

- [#405 - ROLLBACK](#405) Fix settings corruption error.
- [#405 - NEW](#405) Add Global Bar Setting support for resource font colors, DoT colors, and decimal precision for secondary stats and resource bar text values.

---

# 11.1.0.1-release (2025-02-26)
## General

- [#405 - ROLLBACK](#405) Rollback changes releated to global bar settings for now.

---

# 11.1.0.0-release (2025-02-25)
## General

- [#416 - NEW](#416) Add addon category metadata for the new addon grouping system.
- [#417 - REFACTOR](#417) Futher optimizations:
<br/>&emsp;&ensp;- Reduce number of in combat checks.
<br/>&emsp;&ensp;- Snapshot UnitToken of enemies/allies; change rules for updating these.
<br/>&emsp;&ensp;- Only refresh primary and secondary stats once per frame at most.
- [#405 - NEW](#405) Add Global Bar Setting support for resource font colors, DoT colors, and decimal precision for secondary stats and resource bar text values.
- [#419 - FIX](#419) Adjust threshold line calculations to avoid off-by-1 pixel rendering issues.

## Demon Hunter 
### Havoc

- [#416 - NEW](#416) Add Illidan's Grasp support to hide the Fel Eruption threshold line when talented in PvP.

## Druid
### Balance

- [#416 - UPDATE](#416) Flag Moonkin Form as a baseline ability.

### Feral

- [#416 - UPDATE](#416) Flag Thrash as a baseline ability.

## Hunter
### Beast Mastery

- [#416 - UPDATE](#416) Remove Dire Beast: Basilisk as a threshold line option.

### Marksmanship

- [#416 - UPDATE](#416) Adjust the following spells:
<br/>&emsp;&ensp;- Removed Improved Steady Shot, Steady Focus, Barrage, Chimaera Shot, Wailing Arrow, and Sniper Shot (PvP).
<br/>&emsp;&ensp;- Flag Multi-Shot as a baseline ability.

## Monk
### Windwalker

- [#416 - UPDATE](#416) Remove Mark of the Crane and related bar text variables.

## Priest
### Discipline

- [#416 - UPDATE](#416) Adjust the following spells:
<br/>&emsp;&ensp;- Update Evangelism spell ID.
<br/>&emsp;&ensp;- Update Voidwraith's mana regen value when also talented into Mindbender.
<br/>&emsp;&ensp;- Removed Rapture and Purge the Wicked.

### Holy
- [#416 - UPDATE](#416) Remove Circle of Healing.

## Rogue
### Subtlety

- [#416 - UPDATE](#416) Remove Shadowy Duel.

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