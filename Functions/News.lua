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

# 12.0.1.37-release (2026-03-16)
## General

- [#544](#544) Add font outline and shadow options for bar text.

---

# 12.0.1.36-release (2026-03-15)
## General

- [#519](#519) Allow incoming healing and absorbs to overflow off the right side of the health bar.
- [#664](#664) Adjust bar border width calculation to be more consistent and less restrictive.
- Fix another issue where if all of the bar text areas for a specialization were removed, the addon would restore defaults on the next login.
- Fix issues with border width collapsing not always applying correctly without a reload.

## Druid
### Guardian

- [#694](#694) Add new threshold lines for Maul/Raze when talented into Harnessed Rage and Killing Blow, respectively.

## Warlock

- [#701](#701) Allow Soul Shards to each have their own color instead of just 1-3, 4, and 5.

---

# 12.0.1.35-release (2026-03-14)
## General

- [#696](#696) Allow bar groups that are made up of many individual nodes (e.g. Combo Points) to be configured to have their node borders overlap each other.
- Ensure that Secondary Bars also use Global Options for bar visibility when enabled.
- Fix an issue where trying to reset bar text to defaults when you had no current bar text entries would cause Lua errors.

### Localization

- [#697](#697), [#699](#699) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.1.34-release (2026-03-14)
## General

- [#529](#529) Update Visibility tab layout to be more space efficient to allow for more options.
- [#529](#529) Add new opacity and fade-out configuration options per-bar.
- [#529](#529) Relocated the "Bar Flash" options out of the "Visibility" tab for Balance Druid, Beast Mastery Hunter, Shadow Priest, and Elemental Shaman. This is now found at the bottom of their respective primary bar tabs, e.g. "Insanity" for Shadow Priest.
- Fix an issue where if all of the bar text areas for a specialization (or globally) were removed, the addon would restore defaults on the next login.

---

# 12.0.1.33-release (2026-03-12)
## General
### Localization

- [#693](#693) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Evoker
### Devastation

- Fix an issue where completing an empowered cast with high latency during/after Dragonrage could cause a Lua error.

---

# 12.0.1.32-release (2026-03-11)
## General

- [#529](#529) Add additional visibility checks: Is Mounted (Any), Ground Mount, Skyriding, Steady Flight, In Group, In Raid Group, In Instance, In Dungeon, In Raid Instance, In Delve, In Battleground, In Arena, and PvP Flagged.
- Fix some options not applying immediately when changed in settings.

## Priest
### Holy

- Ensure that Benediction casts also apply Lightweaver when talented.

---

# 12.0.1.31-release (2026-03-11)
## General

- Fix an issue where sometimes color caching would fail due to stale max resource values being 0.

### Localization

- [#691](#691) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Monk
### Brewmaster

- Fix an issue where sometimes Stagger threshold lines would show up outside of the Stagger Bar instead of being hidden.

---

# 12.0.1.30-release (2026-03-10)
## General

- [#529](#529) Fix primary bar rendering when the "Is Mounted" visibility condition is enabled and the player mounts.
- [#529](#529) Fix bar text going stale when a bar goes from a hidden state to a visible state.
- [#529](#529) Improve the visibility dropdown menus to be more user friendly and informative.

## Demon Hunter
### Vengeance

- [#689](#689) Fix an issue where Soul Fragments were being treated as not `secret` values.

---

# 12.0.1.29-release (2026-03-10)
## General

- [#529](#529) Add more granular bar visibility options per bar. Instead of "Never", "In Combat", and "Always", you can now mix and match between any of several conditions including "In Vehicle", "Is Mounted", "Friendly Target", and "Hostile Target". More coming soon!
- Fix an issue where if the Primary Resource Bar was set to "Never Show", it would hide all bars instead of just the Primary Resource Bar.

---

# 12.0.1.28-release (2026-03-09)
## General
### Behind the Scenes

- [#687](#687) Make additional significant performance optimizations throughout the bar's frame-to-frame code.

### Localization

- [#686](#686) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Priest

- Fix an issue where the Angelic Feather bar would not follow selected visibility options when using Global Options for bar visibility.

---

# 12.0.1.27-release (2026-03-08)
## General
### Behind the Scenes

- [#684](#684) Make significant performance optimizations throughout the bar text update process, including caching of formatted attribute values and avoiding computing unused values. This should result in a significant reduction in CPU usage from bar text updates, especially for classes with a large number of variables in their bar text.

### Localization

- [#682](#682) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Devourer

- [#680](#680) Add bar text support for Rolling Torment via `$rollingTormentFury`, which will show the expected amount of Fury to be gained via the Rolling Torment talent when Collapsing Star ends, and `#rollingTorment` for an icon.

## Druid
### Guardian

- [#683](#683) Restore the ability to change and disable the Overcap bar border color in options.

## Warrior
### Fury

- [#679](#679) Separate the Whirlwind Charge color for 1 charge and 2 charges into distinct color options instead of sharing a single color. The default for 1 charge is now a slightly lighter yellow.
- [#679](#679) Add an optional different background color for Whirlwind Charge nodes when at 0 charges. This can be disabled via a checkbox in the Whirlwind tab of the Fury options.

---

# 12.0.1.26-release (2026-03-06)
## Druid

- [#560](#560) Allow Combo Points to be shown in all shapeshift forms instead of just Cat Form. This is controlled by a new checkbox option in the Druid options.
- [#560](#560) Added a per-specialization visibility option for Combo Points.
- [#677](#677) Fix an issue where Combo Points were appearing when they shouldn't be and without the correct colors/textures.

## Warrior
### Protection

- [#665](#665) Fix an issue where specific ability usage would result in Shield Charge duration not being properly applied.

---

# 12.0.1.25-release (2026-03-05)
## General
### Behind the Scenes

- Refactor how individual bars handle their visibility to be more consistent and generic. This is precursor work to adding more visibility options.

### Localization

- [#675](#675) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Vengeance

- Fix an issue with Soul Fragments bar nodes completely filling when gaining any Soul Fragment.

---

# 12.0.1.24-release (2026-03-05)
## General

- [#671](#671) Add Global Bar Text support. You can now configure bar text entries in the Global Options "Bar Text" tab that are shared across all specializations.
- [#671](#671) Each specialization has a "Use global settings" checkbox on its Bar Text tab to opt in. When enabled, global bar text entries are prepended before the specialization's own entries.
- [#671](#671) Global bar text entries support universal variables like `$resource`, `$resourceMax`, `$casting`, `$comboPoints`, and `$comboPointsMax`, plus all common stat/health variables.
- [#671](#671) Added export/import support for global bar text settings.

## Priest

- [#526](#526) Add support for tracking Angelic Feather charges and cooldown. This is represented as its own separate bar node group that can be positioned, sized, and styled like any other bar. New bar text variables include: `$afTime`, `$afCharges`, and `$afMaxCharges`. This is disabled by default.

### Holy

- Include extra CDR from Prayer of Healing when talented into Spiritwell and Energy Cycle.
- Include a temporary bug support fix a bug with Spiritwell + Energy Cycle + Ultimate Serenity granting an extra 2 seconds of CDR.

---

# 12.0.1.23-release (2026-03-03)
## General

- Fix a Lua error when having your specialization forcibly changed by accepting a random dungeon queue with a different role.

### Localization

- [#669](#669) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Druid

- [#670](#670) Fix a Lua error when applying combo point bar appearance for non-Feral Druid specs during initialization, caused by accessing Feral's combo point color settings before they were fully populated.

## Priest
### Holy

- Include Benediction in cooldown reduction tracking for Holy Word: Serenity.
- Restore support for Lightweaver tracking via bar border color change and bar text variables, `$lightweaverTime` and `$lightweaverStacks`.

---

# 12.0.1.22-release (2026-03-02)
## Priest
### Holy

- Include Prayer of Mending and Holy Nova in cooldown reduction tracking for Holy Words.
- Prevent the Holy Word: Sanctify cooldown reduction from being misattributed when talented into Ultimate Serenity.

---

# 12.0.1.21-release (2026-03-02)
## General

- When handling spell cast info, guard against spells that don't have any iconID supplied via the API.

## Druid
### Feral

- [#666](#666) Restore correct usability threshold line color for Bite/Ravage's max Energy cost.
- [#666](#666) In addition to requiring 5 Combo Points, only show the "Max Bite" color when at or above 50 Energy, not just when Bite/Ravage is at any usable Energy level.
- [#666](#666) Remove outdated references to Brutal Slash.

## Evoker
### Devastation

- Fix an issue where the Dragonrage buff would sometimes not be extended (with Animosity talented) due to spellIDs being changed by other talents.

## Monk
### Windwalker

- [#663](#663) Add options to Windwalker Monk's settings to allow the display control of Heart of the Jade Serpent's border color changes.
- [#668](#668) Restore support for Heart of the Jade Serpent triggering ability ready and buff active border color changes. Add Whirling Dragon Punch to Strike of the Windlord as potential triggers.
- [#668](#668) Restore Dance of Chi-Ji proc detection, allowing for bar border color change and audio cues to return.

## Paladin

- [#662](#662) Add independent color options for the 2nd and 3rd Holy Power bars.

## Warrior

- [#666](#666) Restore correct usability threshold line color for Execute's max Rage cost.

---

# 12.0.1.20-release (2026-03-01)
## Monk
### Brewmaster

- Fix an issue where the bar would disappear whenever an Bring Me Another (2/4 or higher) apex talent proc would occur.

## Priest
### Shadow

- Fix the the Insanity generation value of Void Blast while talented into the Void Infusion talent.

---


# 12.0.1.19-release (2026-02-28)
## General

- Add guards to prevent Lua errors when determining if threshold-based abilities are active.

---

# 12.0.1.18-release (2026-02-28)
## General

- Fix an issue with the castbar overlay not working for some long time users of the bar.

---

# 12.0.1.17-release (2026-02-26)
## General
### Localization

- [#660](#660) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.1.16-release (2026-02-26)
## General

- [#659](#659) Add support for tracking incoming heals as an optional overlay on the health bar and via a new `$incomingHeal` bar text.
- Fix a Lua error that could occur when tracking some durations.

### Localization

- [#658](#658) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Priest
### Holy

- Fix an issue where spells that would complete the cooldown of a Holy Word would sometimes light up the wrong node.

## Warrior
### Protection

*NOTE:* **Blizzard made a change in this week's build that causes the absorb amount from "Ignore Pain" to be unobtainable. This has caused the `$ignorePainAbsorb` bar text variable to always appear as `0` even when it is active. At this point it is unclear whether or not the underlying change that prevents this detection was introduced on purpose or is just a bug. As a result, I am leaving the bartext variable in place for now. If seeing the `0` value annoys you, you can remove it by modifying the Bar Text string.**

---

# 12.0.1.15-release (2026-02-26)
## General

- [#655](#655) Enhance the Edit Mode implementation to support more sophisticated anchoring, additional Cooldown Manager frames, and any frame by name.

---

# 12.0.1.14-release (2026-02-25)
## General

- [#650](#650) Restore support for showing the incoming/outgoing Primary resource from hardcasted spells as a separate colored bar section.

### Localization

- [#648](#648), [#651](#651) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Death Knight
### Unholy

- Add a threshold line option for Epidemic.

## Demon Hunter
### Havoc

- Fix the predicted incoming Fury from Eye Beam/Abyssal Gaze with Blind Fury talented.

### Devourer

- Add incoming Fury generation from hardcasts of Consume.

## Hunter
### Survival

- [#654](#654) Add support for tracking Tip of the Spear as a separate bar section, similar to Arcane Charges.

*NOTE:* **This will automatically begin tracking properly once Blizzard releases their data fix to allow the Tip of the Spear buff to not be treated as** `secret`**.**

## Mage
### Frost

- [#537](#537) Add support for tracking Icicles as a separate bar section, similar to Arcane Charges.

*NOTE:* **This will automatically begin tracking properly once Blizzard releases their data fix to allow the Icicles buff to not be treated as** `secret`**.**

---

# 12.0.1.13-release (2026-02-25)
## General

- [#602](#602) Add support for absorption shields to be shown on the Health Bar or with the bar text variable `$absorb`. The absorb overlay can be configured to be shown appended to the end of the current health bar, as an overlay from the left (start) of the bar, or as an overlay starting from the right (current) as an inlay.

### Localization

- [#644](#644), [#646](#646) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Warrior
### Fury

- [#645](#645) Add support for tracking Whirlwind stacks from Improved Whirlwind as a secondary resource bar set. New bar text variables have been added to show the number of charges (`$wwCharges`) and time remaining (`$wwTime`) on the buff.

---

# 12.0.1.12-release (2026-02-24)
## Priest
### Discipline

- [#508](#508) Fix an issue where Evangelism would improperly "spend" a charge when cast.

---

# 12.0.1.11-release (2026-02-23)
## General

- Fix bar text on the resource bar not updating after using the "Reset Bar Text" buttons.

### Localization

- [#641](#641) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Havoc

- [#642](#642) Add support for Metamorphosis extensions via Fury spent while talented into Shattered Destiny.
- [#642](#642) Show Abyssal Gaze as a threshold line instead of Eye Beam when in Demon Form and talented into Demonic Intensity (Fel-Scarred).

## Priest
### Discipline

- [#508](#508) Restore the ability to track and show the status of Power Words (Radiance) in its own bar group. Features returning include: charges, cooldown remaining, and bar text.
- [#508](#508) Add default Power Word bar text to show the remaining cooldown of its respective Power Word.

### Holy

- [#508](#508) Add default Holy Word bar text to show the remaining cooldown of its respective Holy Word.

---

# 12.0.1.10-release (2026-02-23)
## General

- [#639](#639) Fix an issue where global bar text color options could sometimes cause Lua errors.

### Localization

- [#638](#638) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Warrior
### Protection

- [#640](#640) Fix Lua errors due to Shield Block charges and `secret` values.

---

# 12.0.1.9-release (2026-02-23)
## General

- [#590](#590) Refactor how bars are generated to reduce the number of frames required.
- Upgrade LibDbIcon.

### Localization

- [#632](#632), [#636](#636) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Vengeance

- [#634](#634) Restore (almost all) original Soul Fragment functionality -- individual nodes instead of a single bar with thresholds, distinct colors for each node, and allow bar text areas to be placed in each.

## Priest
### Holy

- [#508](#508) Restore the ability to track and show the status of Holy Words in its own bar group. Features returning include: charges, cooldown remaining, bar text, and color changes when your current hardcast will complete the cooldown of its associated Holy Word.
- Add Eternal Sanctity support for extending the duration of Apotheosis.

---

# 12.0.1.8-release (2026-02-21)
## General

- [#628](#628) Add support for indivudal bars to be anchored to other bars instead of using an X/Y offset from the Primary Resource Bar.
- [#628](#628) Allow any bar that is anchored to the "Screen" (`UIParent`) to also be independently controlled by Edit Mode for positioning, including anchoring to the Cooldown Manager's Essential frame.
- [#624](#624) Reduce bar flickering when setting up upon login, specialization, or talent changes.
- [#626](#626) Fix inconsistent bar text updates when some UI elements are disabled.
- [#630](#630) Allow Health Bar colors to be controlled by a global setting.
- Fix Lua errors from the Reset Default Bar Text buttons.

### Localization

- [#623](#623) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!
- Clean up some old references to "Devouring Plague" to properly refer to "Shadow Word: Madness".

## Demon Hunter
### Havoc

- Fix an issue with Metamorphosis tracking when talented into Demonic and not talented into Blind Fury.
- Fix an issue with Metamorphosis duration extensions not correctly including the base channel duration of Eye Beam with Demonic talented.

### Vengeance

- Add Untethered Rage talent support for extending/triggering Metamorphosis.
- Add support for Metamorphosis via Last Resort procs.

---

# 12.0.1.7-release (2026-02-17)
## General

- [#313](#313) Upgrade the Bar Text Variables flyout to have a searchable list of variables with descriptions and icons. Add the option to insert the current variable into the Bar Text editor at the current cursor position.
- Add undo/redo functionality to the Bar Text editor with standard Ctrl+Z and Ctrl+Shift+Z (or Ctrl+Y) keyboard shortcuts.
- Add an option to enable or disable abbreviated number formatting (e.g. 10.0K, 1.5M) for large numbers across all bars.
- Fix news popup from blending in with the options window.

### Localization

- [#621](#621) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Hunter
### Marksmanship

- [#614](#614) Reduced the Trueshot extension from Cant't Miss, Won't Miss from 4 seconds to 2 seconds to match hotfix changes.

---

# 12.0.1.6-release (2026-02-16)
## Druid
### Feral

- [#619](#619) Fix an issue where the bar text duration for Incarnation: Avatar of Ashamane / Berserk would always display as 0.0 seconds.

---

# 12.0.1.5-release (2026-02-16)
## General

- Fix an issue where global options for bar and combo point dimensions/positions were incorrectly being reset to default values.

---

# 12.0.1.4-release (2026-02-15)
## General

- Fix a regression with bar spacing not accounting for hidden bars when anchored to the Cooldown Manager in Edit Mode.

---

# 12.0.1.3-release (2026-02-15)
## General

- [#352](#352) Allow for any class specialization's settings to be accessed and modified, regardless of what the current class is.
- [#352](#352) Make the options window lazy load settings for a spec only when they are accessed. This will reduce the amount of memory consumed by the addon in most circumstances.
- [#577](#577) Allow for each bar type to have its own smooth bar setting instead of a single global setting for all bars. By default, "Combo Point" style bars will have this disabled while the other bars will match the previous global setting value.

### Localization

- [#615](#615) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Warlock
### Destruction

- Fix an issue where sometimes the penultimate Soul Shard color would not be applied when the "Same Color" option was enabled.

---

# 12.0.1.2-release (2026-02-14)
## General

- [#352](#352) Reorganize options menus to spread out and group options across more tabs to make them easier to navigate.
- Fix an issue where attempting to use `secret` values in Boolean bar text logic would cause Lua errors and stop the addon from working completely.
- Add a checkbox toggle to control minimap button visibility.

### Localization

- [#609](#609) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Rogue
### Outlaw and Subtlety

- [#611](#611) Fix how Coup de Grace is tracked and what controls when its threshold line is shown.

## Warlock
### Destruction

- [#612](#612) Fix an issue with importing Destruction-only settings strings.

## Warrior
### Protection

- Re-enable tracking of Ignore Pain absorbtion via `$ignorePainAbsorb` bar text variable.

---

# 12.0.1.1-release (2026-02-12)
## General

- [#352](#352) Add a new dedicated movable options window. Access it via `/trb` or the new minimap button.
- Add a minimap button for quick access to the options window. Toggle it with `/trb minimap show` and `/trb minimap hide`.
- Remove legacy drag and drop bar positioning. Use Edit Mode instead.

### Localization

- [#606](#606) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.1.0-release (2026-02-11)
## General

- [#582](#582) All secondary resource audio cues (Holy Power, Combo Points, Soul Shards, Chi, Arcane Charges, Maelstrom Weapon) now fire independently of bar visibility and only trigger during combat.
- Update LibEditMode to version 15.

## Druid
### Feral

- [#582](#582) Add two new audio cues for when Combo Points are at or above a configured threshold. These default to 3 and 5 Combo Points.

## Mage
### Arcane

- [#582](#582) Add two new audio cues for when Arcane Charges are at or above a configured threshold. These default to 2 and 4 Arcane Charges.

## Monk
### Windwalker

- [#582](#582) Add three new audio cues for when Chi is at or above a configured threshold. These default to 3, 5, and 6 Chi.

## Paladin

- Add a 3rd Holy Power threshold audio cue.

## Rogue

- [#582](#582) Add two new audio cues for when Combo Points are at or above a configured threshold. These default to 3 and 5 Combo Points.

## Shaman
### Enhancement

- [#582](#582) Add two new audio cues for when Maelstrom Weapon stacks are at or above a configured threshold. These default to 5 and 10 Maelstrom Weapon stacks.

## Warlock

- [#582](#582) Add two new audio cues for when Soul Shards are at or above a configured threshold. These default to 3 and 5 Soul Shards. Destruction supports fractional (0.1) precision.

## Warrior
### Protection

- [#604](#604) Fix an issue with tracking when Ignore Pain is removed.

---

# 12.0.0.22-release (2026-02-09)
## General

- [#597](#597) Standardized color settings across all class modules.
- [#597](#597) Added enable/disable checkboxes for proc and buff bar color changes that previously could not be toggled independently. See below for specifics by specialization.
- [#538](#538) Standardize `endOf` buff expiration settings.
- [#599](#599) Fix the "ability usable" bar text color change option for most threshold specializations.
- Fixed combo point threshold repositioning to use the correct width settings.
- Adjust abbreviations of numbers to be locale aware.

## Demon Hunter
### Havoc and Vengeance

- [#597](#597) Add checkbox to enable/disable Metamorphosis bar color change.

## Druid
### Balance

- [#597](#597) Add checkboxes to enable/disable Solar Eclipse, Lunar Eclipse, and Celestial Alignment bar color changes.

### Feral

- [#597](#597) Add checkboxes to Max Damage Ferocious Bite and Apex Predator's Craving bar color changes.
- [#597](#597) Add checkbox to enable/disable Stealth border color change.

### Restoration

- [#597](#597) Add checkboxes to enable/disable No Efflorescence and Incarnation: Tree of Life bar color changes.

## Hunter
### Marksmanship

- [#597](#597) Add checkbox to enable/disable Trueshot bar color change.

## Priest
### Holy

- [#597](#597) Add checkbox to enable/disable Apotheosis bar color change.

### Shadow

- [#597](#597) Add checkboxes to enable/disable Voidform and Shadow Word: Madness usable bar color changes.

## Rogue

- [#597](#597) Add checkbox to enable/disable Stealth border color change.

### Subtlety

- [#597](#597) Add checkbox to enable/disable Shadowcraft border color change.

## Shaman
### Elemental

- [#597](#597) Add checkboxes to enable/disable Earth Shock/Elemental Blast threshold and Ascendance bar color changes.

### Enhancement and Restoration

- [#597](#597) Add checkbox to enable/disable Ascendance bar color change.

---

# 12.0.0.21-release (2026-02-05)
## General

- [#596](#596) Fix an issue with secondary resource nodes not adjusting to be the correct width when talents change while using Edit Mode.

---

# 12.0.0.20-release (2026-02-04)
## General

- [#516](#516) Add checkbox to enable/disable a global setting for all classes and specializations. This is available from the "Global Options" screen. Changes are immediately reflected across all specializations.
- [#528](#528) Fix Edit Mode positioning issues when loading in or changing specializations. Thanks to Supra for help with debugging.

### Localization

- [#594](#594) Completed translation coverage for German (deDE) by Triplehxh! Thank you so much for your help!
- [#595](#595) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Vengeance

- [#514](#514) Update method of tracking Soul Fragments to be event driven.

---

# 12.0.0.19-release (2026-02-02)
## General

- Add additional protections to stop Lua errors when talents are not yet loaded.

---

# 12.0.0.18-release (2026-02-02)
## General

- Fix an issue where talents wouldn't load correctly, causing Lua errors.

### Localization

- [#589](#589) Improved translation coverage for German (deDE) by SanTM! Thank you so much for your help!

---

# 12.0.0.17-release (2026-02-02)
## General

- [#588](#588) Fix an issue where bars would still appear even when the specialization was disabled in settings.

### Localization

- [#585](#585) Complete translation added for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter
### Vengeance

- [#586](#586) Fix an issue where the segments for Soul Fragments would not render correctly when automatically matching the width of the Cooldown Manager in Edit Mode.

### Devourer

- [#587](#587) When not talented into Collapsing Star, change the value of `$soulFragments` to be blank and prevent the Collapsing Star threshold line from displaying.

---

# 12.0.0.16-release (2026-01-31)
## General

- [#578](#578) Fix an issue with default and supported font settings for non-Latin based languages.
- Stop the `/trb` command from attempting to execute while in combat as it will always result in Lua errors and fail.
- Make some adjustments to Edit Mode positioning when changing primary visibility settings.

## Druid
### Balance

- [#579](#579) Fix an issue with playing Starsurge or Starfall ready audio cues.

---

# 12.0.0.15-release (2026-01-30)
## Druid
### Balance

- [#509](#509) Restore, via a workaround, the ability to shade the 2x and 3x Starsurge threshold lines as usable when you have an appropriate amount of Astral Power.

### Guardian

- [#575](#575) Fix Berserk bar color change giving a Lua error.
- Add checkbox to enable/disable the Berserk bar color change.

## Paladin
### Holy

- [#559](#559) Add optional bar border color change and audio cue when Infusion of Light is active.

## Priest
### Shadow

- [#509](#509) Restore, via a workaround, the ability to shade the 2x and 3x Shadow Word: Madness threshold lines as usable when you have an appropriate amount of Insanity.

## Rogue
### Assassination

- [#574](#574) Fix threshold options layout to prevent overlapping. (Koroshy)

---

# 12.0.0.14-release (2026-01-30)
## General

- [#572](#572) Add a new "Reset Edit Mode Data" button under the "Reset Defaults" tab in Global Options, allowing you to clear all stored Edit Mode layout data for the bar.

## Druid

- [#570](#570) Fix Lua errors when switching specializations.

## Monk
### Brewmaster

- [#520](#520) Add support for an "Extremely Heavy Stagger" threshold and color to the Stagger bar.
- [#520](#520) Add support for setting the maximum stagger percentage represented by the bar to be greater than 100% of maximum health.
- Fix an issue where the Stagger bar would not display thresholds correctly when using Edit Mode and setting the bar to be the same width as the Cooldown Manager.

---

# 12.0.0.13-release (2026-01-29)
## General

- [#571](#571) Fix positioning errors when using classic X/Y positioning.
- [#571](#571) Fix visibility issues when the Primary Resource Bar is set to "Never" and the Secondary or Health Bar is set to "Always".

## Priest
### Shadow

- Fix Improved Voidform talent ID.

---

# 12.0.0.12-release (2026-01-29)
## General

- Fix an issue with health bar sizing not updating when changing settings.
- [#528](#528) Fix a bug with how bars are positioned when Edit Mode is disabled.
- Upgrade LibEditMode to version 14.

### Localization

- [#567](#567) Update some strings to improve behavioral clarity around bar font settings.
- Remove the Google Translate generated localizations due to continued poor quality. If you're interested in helping with translations, please join the [Discord server](https://discord.gg/eThqxM78xm) and let Twintop know!

## Death Knight

- [#564](#564) Add additional gaurds around Rune cooldown calculations to prevent Lua errors.

## Druid

- [#528](#528) Fix various issues with with how and where bars would be positioned when changing shapeshifting options with Edit Mode enabled and different bar visibility settings.

---

# 12.0.0.11-release (2026-01-28)
## General

- [#528](#528) Add Edit Mode options to bind the bar position to the Cooldown Manager's Essential frame and match its width.
- [#528](#528) Show all bars available to the current spec that are sometimes or always visible while in Edit Mode.

## Demon Hunter
### Devourer

- [#563](#563) Add Surrender to the Void talent support, increasing maximum Soul Fragments by 50 in PvP.

---

# 12.0.0.10-release (2026-01-27)
## Death Knight

- [#558](#558) Prevent Lua errors during Rune cooldown tracking when the API returns unexpected secret values.

## Demon Hunter
### Devourer

- [#550](#550) Fix an issue where Soul Fragment tracking would become stuck when switching talents.

## Druid

- [#561](#561) Fix an issue where switching forms with Edit Mode enabled would cause the bar to change position.

---

# 12.0.0.9-release (2026-01-27)
## General

- [#528](#528) Add Edit Mode integration for bar positioning. When enabled for a layout, Edit Mode will control the bar's position instead of per-spec or global settings. This can be toggled via Edit Mode per layout.

## Evoker

- [#524](#524) Re-enable Essence Burst detection. This allows for bar border color change and audio cue to function again. The border color change is enabled by default, whereas the audio cue is disabled by default.

## Priest
### Discipline and Holy

- Modify method for detecting Surge of Light procs.

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

	local newsPanelParent = TRB.Functions.OptionsUi:CreateTabFrameContainer("TRB_News_Frame_Panel", newsFrame, 640, 410)
	local newsPanel = newsPanelParent.scrollFrame.scrollChild
	newsPanelParent:SetBackdropColor(0, 0, 0, 1)
	newsPanelParent:ClearAllPoints()
	newsPanelParent:SetPoint("TOPLEFT", 5, -30)

	TRB.Functions.OptionsUi:BuildSectionHeader(newsFrame, L["NewsHeaderTwintopsResourceBarUpdates"], oUi.xCoord, 0)

	local closeX = CreateFrame("Button", nil, newsFrame, "UIPanelCloseButton")
	closeX:SetPoint("TOPRIGHT", newsFrame, "TOPRIGHT", -2, -2)
	closeX:SetScript("OnClick", function()
		TRB.Functions.News:Hide()
	end)

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
