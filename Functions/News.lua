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

# 12.1.0.2-release (2026-08-14)
## General
### Edit Mode

- [#810 - @EricaPomme](#810) Reduce the CPU cost of bars anchored to Cooldown Manager frames.

## Evoker
### Augmentation

- Fix the Ebon Might bar never filling when Ebon Might is tracked in the Cooldown Manager's Tracked Buffs category. Only Tracked Bars entries expose a readable remaining time; the fill is now driven by the aura engine instead, which does not care which category the spell sits in.
- Remove End Cap support from the Ebon Might bar. The cap anchors to the fill's leading edge, and an engine-driven fill edge cannot be anchored to from addon code.
- Fix the Ebon Might bar ignoring its gradient color. The render path was handed only the first color, so the second and the gradient direction never reached the bar.

## Mage
### Frost

- Add Fingers of Frost tracking. Bar text variables `$fingersOfFrostStacks`, `$fingersOfFrostStacksMax` and `$fingersOfFrostTime`, plus the `#fingersOfFrost` icon.
- Add Brain Freeze tracking. Bar text variable `$brainFreezeTime`, plus the `#brainFreeze` icon. `$brainFreezeTime` requires Brain Freeze to be tracked in the CDM's buff viewers.
- A Color Indicators tab for Frost, with Fingers of Frost and Brain Freeze entries. Both default to the Mana bar border, with Brain Freeze taking priority.

## Warrior
### Fury

- [#808](#808) Add a new Enrage bar, tracking the time remaining on Enrage. Requires CDM to be enabled and Enrage to be actively tracked to function. Set to Never Show by default; enable it under Bar Visibility.
- Fix the Enrage bar never filling when Enrage is tracked in the Cooldown Manager's Tracked Buffs category. Same aura engine change as the Ebon Might bar above.
- Remove End Cap support from the Enrage bar, for the same reason as the Ebon Might bar.
- Fix the Enrage bar ignoring its gradient color, same cause as the Ebon Might bar.

---

# 12.1.0.1-release (2026-08-14)
## General
### Cast Bars

- [#806](#806) Ensure that player cast bar Bar Text appears immediately when a cast starts instead of lagging several frames behind.
- [#806](#806) Fix an issue where the Blizzard player cast bar would flicker back into visibility briefly when beginning a cast.

### Edit Mode

- Fix bars not previewing in Edit Mode even though the Edit Mode container was sized to include them. Every bar now re-resolves its visibility as Edit Mode opens instead of keeping whatever it was rendering beforehand.
- Fix the Global Cooldown, Fatigue, Breath, Feign Death and cast bars previewing in Edit Mode while disabled, drawing outside the Edit Mode container.
- Hand those same bars back to their own rendering as Edit Mode closes, so an Edit Mode preview can no longer be left behind on screen.

### Localization

- [#805 - @MOSS099](#805) Updated translations for Simplified Chinese (zhCN).

## Evoker
### Augmentation

- [#807](#807) Fix Ebon Might tracking, which read its duration from the aura and went dead when aura data became secret. It now reads from the CDM and requires Ebon Might to be tracked there. The bar, its Color Indicator entry, and `$ebonMightTime` carry the CDM badge.
- [#807](#807) Remove the End of Ebon Might Configuration section, the "Ebon Might is Ending" and "Cast Won't Extend" Ebon Might Color Indicators, the Ebon Might ending audio cue, and custom threshold support for the Ebon Might bar. Each compared the remaining duration against a threshold, which a `secret` value cannot do. Replacements are being considered but no ETA on a replacement.
- [#807](#807) Custom threshold line support has been removed from the Ebon Might bar as it is no longer possible to reliably place them.
- [#807](#807) Fixed an error where casting Emerald Blossom could throw a Lua error.

---

# 12.1.0.0-release (2026-08-10)
## General

- Add a version check that, when enabled in the TOC, will prevent the addon from loading if the client version does not match one of the versions listed in the TOC. This is to prevent people from accidentally updating to a version of the addon that is not compatible with their client version.
- Remove the Aura Caching system since, with 12.1 API changes, it never returns usable (non-`secret`) data.
- Integrate with the Cooldown Manager (CDM) as a supplemental source of data for abilities, buffs, and debuffs. Abilities that used to read Aura data directly now read from the CDM.
- Settings and bar text variables that are fed by the Cooldown Manager now carry a **CDM** badge, with a tooltip explaining that the ability it tracks has to be added to one of the Cooldown Manager's viewers before a value can be shown.
- Add a Cooldown Manager value when unavailable option under Global Options -> Miscellaneous -> Bar Settings, choosing what a CDM fed bar text variable shows while the Cooldown Manager has no value for it -- because the ability was never added to a viewer, or its group is hidden. Choose Nothing (the default), `??`, or zero.
- Refactor how set bonus detection is handled to be more generic.
- Bars that are anchored to another bar now always draw on top of the bar they are attached to, so a bar can no longer be hidden behind its parent.
- Colors: the Health Bar gains a **Single (Class Color)** color option, painting the bar in your current class's color.
- Color Indicators: the bar/element target dropdowns are now a fixed height with a scrollbar, instead of running off the bottom of the screen when a spec has many bars.

### Audio Cues

- Rebuild the Audio Cues tab. The old "Audio & Tracking" tab is now **Audio Cues**, and lists every cue for the specialization in a sortable table showing its type, what triggers it, and the sound it plays, with a detail editor below.
- Specializations with a countable resource can now have **as many threshold cues as you want**, each with its own value and sound, instead of a fixed set. Available for Combo Points (Feral, all Rogue specs), Chi, Holy Power, Soul Shards, Arcane Charges, Icicles, Essence, Maelstrom Weapon stacks, Tip of the Spear stacks, and Lightweaver stacks.
- Threshold cues gain an **Also play when dropping to this value** option, so a cue can fire on the way back down as well as on the way up.
- Every built-in cue now describes exactly what triggers it, both in the table and in its detail pane.
- Audio cues you have deleted or changed no longer come back on the next load.

### Bar Settings

- Every bar's settings tab now has a pinned header with an **Enabled** checkbox, a shortcut for setting that bar's visibility to Never Show without leaving the tab. The header also summarises when the bar currently shows and links straight to the Visibility tab.
- A disabled bar's tab label is now shown in red, so it is obvious from the tab strip without opening the tab.
- Bars whose visibility is being driven by Global Options say so in the header instead of silently ignoring the checkbox.

### Bar Text

- [#802 - @Ignitetheskywow](#802) Font Outline is now a multiselect dropdown. Outline and Thick Outline still replace each other, but either can be combined with Monochrome and the new Slug style, and None clears the rest.
- The bar text variable list is now grouped into **Stats**, **Resources**, **Abilities**, **Other**, and **Cast Bars** sections.
- Add a **CDM** column to the variable list, marking variables whose value comes from Blizzard's Cooldown Manager and which render as `??` until the ability they track is added to one of its viewers.
- Hovering a variable in the list now shows its name and full description, instead of having to select the row.
- Fix bar text labeling to correctly denote bar text variables that are `secret` values, and clarify that a secret value cannot be used with comparison operators in bar text logic.
- Fix bare `{$variable}` checks never evaluating true for Clearcasting, Double Tap, Holy Word: Sanctify charges, Dominion of Argus, Whirlwind, Violent Outburst, and Enrage.

### Cast Bar

- Fix an empty Target or Focus Cast Bar flashing on screen after an interrupt.
- Fix the Target and Focus Cast Bar lingering after a hardcast finished, until the unit's next spell replaced it.
- Fix bar text anchored to the Target or Focus Cast Bar disappearing during the fade out, and on an idle Always Show bar.
- Fix the Target and Focus Cast Bars flickering during spec switches, bar reconstruction, and login.
- Add support for channel ticks to be modified by set bonuses.

### Localization

- [#803 - @MOSS099](#803) Updated translations for Simplified Chinese (zhCN).

### Other Bars

- [#79](#79) Add a new **Other Bars** screen with three optional timer bars available to every specialization -- **Global Cooldown**, **Fatigue**, and **Breath** -- plus a **Feign Death** bar for Hunters. Each has its own dimensions, anchoring, colors, textures, visibility rules, and bar text.
- The Global Cooldown, Fatigue, and Breath bars can be configured globally for every specialization at once, or on a per specialization basis. Feign Death is configured per Hunter specialization, as no other class can use it.
- The Global Cooldown bar can either drain a full bar down or grow an empty one up as the global cooldown elapses.
- The Fatigue, Breath, and Feign Death bars can each hide Blizzard's own version of that timer while they are shown.
- Add a Duration Decimal Precision option for the Global Cooldown bar's timer text. The mirror timers read as mm:ss and have no decimals to configure.
- New bar text variables: `$gcdDuration`, `$gcdDurationRemaining`, `$fatigueDuration`, `$fatigueDurationRemaining`, `$breathDuration`, and `$breathDurationRemaining`, plus `$feignDeathDuration` and `$feignDeathDurationRemaining` for Hunters.
- Each bar comes with a bar text entry for its remaining time already set up. The Global Cooldown's starts disabled, since its bar is thin and recycles constantly; enable it on the Bar Text screen if you want it.

## Death Knight
### Blood

- The Coagulating Blood bar can use an End Cap again. End caps were being suppressed on every bar fed by a secret value, but only multi-segment bars need that -- on a single bar the cap marks its own fill edge and is knowable.

- [#801](#801) Add a new Coagulating Blood bar, tracking your current stacks where each stack is 1% damage reduction, with an optional maximum value override so the bar and its threshold lines scale to the cap you actually reach. Adds the `$coagulatingBloodStacks` and `$coagulatingBloodStacksMax` bar text variables. Requires CDM to be enabled and Coagulating Blood to be actively tracked to function. On upgrade it starts with your Bone Shield bar's visibility settings, rather than appearing unannounced.

## Druid
### Feral

- Midnight Season Two 2-Piece: Add tracking for the Halazzi's Fury damage buff gained when Berserk / Incarnation: Avatar of Ashamane ends (1 second per Combo Point spent during it), shown as a new Color Indicator. Adds a bar text timer variable `$halazzisFuryTime` and an icon (`#halazzisFury`).
- Midnight Season Two 4-Piece: Account for the additional 10 seconds of duration granted to Berserk / Incarnation: Avatar of Ashamane.

## Evoker

- Essence Burst tracking now uses the CDM. Requires CDM to be enabled and Essence Burst to be actively tracked to function.

## Hunter
### Beast Mastery

- Update Beast Cleave's duration to 10 seconds.

## Mage
### Arcane

- Midnight Season Two 2-Piece: Increase the number of ticks when channeling Arcane Missiles by 1.

### Frost

- [#653](#653) Add a new Shatter bar, tracking the stacks of Shatter on your current target, up to 20. Adds the `$shatterStacks` and `$shatterStacksMax` bar text variables and an icon (`#shatter`). Requires CDM to be enabled and Shatter to be actively tracked to function. On upgrade it starts with your Icicles bar's visibility settings, rather than appearing unannounced.

## Paladin

- Divine Purpose tracking now uses the CDM. Requires CDM to be enabled and Divine Purpose to be actively tracked to function.

## Priest
### Discipline

- Surge of Light tracking now uses the CDM. Requires CDM to be enabled and Surge of Light to be actively tracked to function.

### Holy

- Surge of Light tracking now uses the CDM. Requires CDM to be enabled and Surge of Light to be actively tracked to function.

### Shadow

- Improved Voidform no longer grants bonus Insanity.
- Update Ancient Madness's extension behavior for Voidform.

## Rogue
### Outlaw

- Remove Count the Odds tracking and the `$rtbTemporaryCount` bar text variable.

## Shaman
### Elemental

- Power of the Maelstrom no longer grants bonus Maelstrom from Lightning Bolt and Chain Lightning.

## Warlock
### Affliction

- Shard Instability tracking now uses the CDM. Requires CDM to be enabled and Shard Instability to be actively tracked to function.

### Demonology

- Demonic Core tracking now uses the CDM. Requires CDM to be enabled and Demonic Core to be actively tracked to function.

## Warrior
### Fury

- Restore Enrage tracking, now fed by the CDM. Adds an `$enrageTime` bar text variable and an Enrage Color Indicator. Requires CDM to be enabled and Enrage to be actively tracked to function.

### Protection

- Ignore Pain tracking now uses the CDM. Requires CDM to be enabled and Ignore Pain to be actively tracked to function.

---

# 12.0.7.13-release (2026-08-03)
## General
### Cast Bars

- Add a shield icon that is shown when a cast can't be interrupted, on by default. This shield is fully customizable in size, position (icon/bar, behind/in front, anchored to 9-point), color, and can be hidden if desired.
- Improve cast bar performance by reducing the number of redraws required.

### Localization

- [#800 - @MOSS099](#800) Updated translations for Simplified Chinese (zhCN).

---

# 12.0.7.12-release (2026-07-25)
## General
### Cast Bars

- [#799](#799) Fix an issue where the Cast Bar would still reserve space in the layout even when it was configured to never show.

---

# 12.0.7.11-release (2026-07-24)
## General

- [#793](#793) Restrict what bars are shown in Edit Mode to just those that are enabled.
- Add a Dead option to Always Hide Bar When, hiding a bar while you are dead or a ghost. Available on all bars, including Cast Bars, and disabled by default.

### Cast Bars

- Add an ability icon beside the Cast Bar. Side (left/right/top/bottom), spacing, zoom to crop the stock border, and collapse border width to share a single border with the bar.
- Add standalone Target and Focus Cast Bars, tracking a unit's casts, channels, and empowers. Secret-safe, so they work on enemy casts where the timing is hidden.
- New bar text variables including `$targetCastingSpellName`, `$targetCastTimeRemaining`, and the `$focus` equivalents.
- Cast Bar, Target Cast Bar, and Focus Cast Bar ability icons are bar text anchor targets -- text can be positioned relative to the icon frame like any other bar.

### Localization

- [#795 - @MOSS099](#795) Updated translations for Simplified Chinese (zhCN).
- [#798 - @MOSS099](#798) Updated translations for Simplified Chinese (zhCN).

---

# 12.0.7.10-release (2026-07-19)
## General

- [#794](#794) Fix a Lua error preventing some bars from rendering updates.

### Cast Bar

- Add the option to color the Cast Bar by an enemy player target's class color, across all cast types. Sub-options limit it to while PvP is enabled or extend it to friendly players. Active Color Indicators still priority.

---

# 12.0.7.9-release (2026-07-19)
## General
### Cast Bar

- Fix the Cast Bar sometimes not showing after a loading screen.

---

# 12.0.7.8-release (2026-07-18)
## General
### Cast Bar

- Fix Cast Bar settings applying inconsistently on Druids across shapeshift forms and spec changes. The Cast Bar now follows the form's spec settings. Disable Switch bars based on shapeshift form on a spec to always use its own settings.
- Fix the Cast Bar collapsing to a sliver with bunched bar text after setting Shown to Never on a spec other than the form's governing spec.
- Fix the Blizzard cast bar reappearing, doubling up, or vanishing entirely after spec or form changes when Cast Bar settings differed between specs.
- Disable Blizzard Cast Bar now leaves the Blizzard cast bar alone when another addon is already managing it.

## Monk
### Brewmaster

- Add Bar End Cap support to the Stagger bar, including as a Color Indicator target.

---

# 12.0.7.7-release (2026-07-17)
## General
### Cast Bar

- [#791](#791) Fix stale bar text, channel tick markers, and latency/pushback overlays from the last shown cast appearing during that flash until a `/reload`.
- Fix the Cast Bar briefly showing and fading out after every finished cast when it was configured not to show (e.g. all Show Bar When conditions unchecked).
- When no Show Bar When options are checked, the Cast Bar is now fully disabled as if Never Show were checked: no cast tracking, no idle/inactive alpha display, and Disable Blizzard Cast Bar is ignored.

### Localization

- [#792 - @MOSS099](#792) Updated translations for Simplified Chinese (zhCN).

---

# 12.0.7.6-release (2026-07-16)
## General

- [#443](#443) Restore Bar End Caps: a configurable width and color overlay at the leading edge of a bar's fill, on every bar except secret cast-count bars.
- Add Bar End Cap as a Color Indicator target on every bar that has one. This takes priority over the cap's "Use Current Border Color" option, if enabled.

### Cast Bar

- Fix an issue with Warlock's channel tick markers logic being applied to all channeled ticks.

### Localization

- [#790 - @MOSS099](#790) Updated translations for Simplified Chinese (zhCN).

---

# 12.0.7.5-release (2026-07-15)
## General
### Cast Bar

- Adjust default Cast Bar fade delay and duration to be a bit smoother.

---

# 12.0.7.4-release (2026-07-15)
## General
### Bar Text

- Add a Prevent Text Overflow toggle: clamp bar text to its bound bar's width, truncating with an ellipsis instead of overflowing. No effect when bound to Screen.
- Add a Maximum Text Width slider (percentage of the bound bar's width, default 100%), shown when the toggle is on.

### Cast Bar

- Add a new Cast Bar for every specialization, covering standard, channeled, and empowered casts, with the same size, anchor, texture, color, and bar text options as every other bar.
- Visibility conditions (Casting, Channeling, Empowered, Always, Never), In Vehicle hide, active/inactive alpha, and fade.
- Latency and pushback overlays, with a Channel Tick Width control and optional Size Channel Ticks to Latency.
- Channel tick markers from a user-editable per-spell tick rate list, handling fixed-count, fixed-duration, and chained channels.
- Empower stage lines and per-level fill colors, with optional Fill Each Empower Level Separately (Windwalker Monk, Evoker, Blood Death Knight).
- Uninterruptible Border Color while a cast can't be interrupted.
- Bulk profession crafting (e.g. Create All) merged into one channel-style bar, with per-craft ticks and `$castSpellName` progress; toggle Merge Bulk Crafting.
- Bar text variables `$castTime`, `$castTimeRemaining`, `$castLatency`, `$castLatencyMs`, `$castPushback`, `$castSpellName`, `$castSpellId`, `$castInterruptible`, `$castUninterruptible`, and the `#casting` icon.
- Top-level Cast Bar options with global versions of every section, a Global Profile selector, per-spec follow-global, and Copy... between scopes.

### Color Indicators

- Add the Health Bar and Cast Bar as Color Indicator targets for every specialization.
- Health Bar: Border and Background.
- Cast Bar: Bar (Hardcast), Bar (Channeled), Border, Background, and Channeled Tick Color; an indicator on the fill or border outranks the uninterruptible colors.
- Gradient Colors (Secrets) can target either bar's Border and Background.

### Localization

- [#788 - @MOSS099](#788) Updated translations for Simplified Chinese (zhCN).

## Hunter
### Marksmanship

- Add new bar text variables for Double Tap tracking: `$doubleTapTime`, and icon `#doubleTap`.

### Survival

- Add support for Raptor Swipe as its own threshold line.

## Mage
### Fire

- Fix an issue where switching to Fire from Arcane or Frost would cause the Fire Blast bar to not show all of the charges.

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

]====]

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
