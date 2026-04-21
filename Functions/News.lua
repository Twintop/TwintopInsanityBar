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

# 12.0.5.1-release (2026-04-22)
## General

- Fix an issue where bar profiles would reset to defaults for other classes.

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

---

# 12.0.1.57-release (2026-04-18)
## General

- Fix an issue where importing settings would sometimes reset bar anchoring to defaults when the bar was anchored to "Screen".
- Fix an issue where bar text would incorrectly be tied to the primary resource bar's visibility even when the text was bound to another bar or "screen".

### Localization

- [#737](#737) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Druid
### Feral

- [#738](#738) Re-enable the color indicator for when you have a Clearcasting proc active and add a new logic-only bar text variable `$clearcastingActive` for conditional bar text logic.

### Restoration

- [#738](#738) Re-enable the color indicator for when you have a Clearcasting proc active and add a new logic-only bar text variable `$clearcastingActive` for conditional bar text logic.

## Paladin

- Add new color indicator, audio cue, and bar text variable for when you have a Divine Purpose proc active.

---

# 12.0.1.56-release (2026-04-11)
## General

- Guard against stale resource type caches when switching specializations.

### Localization

- Restore some missing localization strings that were incorrectly flagged as unused.

## Priest
### Holy

- Fix an issue where the remaining duration of Apotheosis doesn't properly pause when exiting combat (with Sustained Potency).
- Fix an issue where casting Halo while Apotheosis is in a paused (via Sustained Potency) state resets the duration of Apotheosis back to full instead of adding time to the remaining duration.

### Shadow

- Fix an issue where the remaining duration of Voidform doesn't properly pause when exiting combat (with Sustained Potency).
- Fix an issue where casting Halo while Voidform is in a paused (via Sustained Potency) state resets the duration of Voidform back to full instead of adding time to the remaining duration.

---

# 12.0.1.55-release (2026-04-10)
## General
### Localization

- [#736](#736) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Priest
### Holy

- Fix an issue where banked Sustained Potency stacks would not increase the duration of Apotheosis.

### Shadow

- Fix an issue where banked Sustained Potency stacks would not increase the duration of Voidform.

---

# 12.0.1.54-release (2026-04-09)
## General

- [#279](#279) Fix ColorCurve-based thresholds (e.g., Shadow Word: Madness x2) not respecting per-threshold "Hide" visibility overrides. Hidden states now use a fully transparent color baked into the curve.
- [#735](#735) Fix various default values for individual thresholds not being displayed accurately.

---

# 12.0.1.53-release (2026-04-09)
## General

- [#734](#734) Overhaul the Thresholds options tab for all specializations. Thresholds are now displayed in a sortable, searchable table with columns for icon, name, category, bar target, audio cue, and enabled status.
- [#734](#734) Add a detail panel below the threshold table that appears when a threshold is selected, allowing per-threshold configuration without navigating away.
- [#603](#603) Add per-threshold color override options. Each threshold line can now use a static color or override the default over, under, and unusable colors individually.
- [#279](#279) Add per-threshold color visibility overrides. This allows a threshold line to be hidden when the threshold is e.g. unusable.
- [#734](#734) Add per-threshold icon display override options including icon visibility, position relative to the threshold line, size, and border width.
- [#605](#605) Add per-threshold audio cue options. Select a sound to play when a threshold becomes usable. Thresholds tied to secret resource values (e.g., Execute at max Rage) do not support audio cues.
- [#734](#734) Add a new Threshold Shared Settings tab for configuring default threshold colors, line dimensions, and icon defaults that apply across all thresholds for a specialization.

## Demon Hunter
### Devourer

- Revert threshold fix from 12.0.1.51-release. Collapsing Star and Void Ray threshold line visibility is now driven by Void Metamorphosis buff state again, as using the Collapsing Star buff caused the bar to flip modes prematurely when the application count reached zero.

---

# 12.0.1.52-release (2026-04-06)
## Priest
### Holy

- Fix an issue where Power Surge + Halo cooldown reduction completing a Holy Word charge would prevent the next charge from starting its recharge timer.

---

# 12.0.1.51-release (2026-04-06)
## Demon Hunter
### Devourer

- Fix an issue where sometimes the Collapsing Star threshold line would continue to be shown even after exiting Void Metamorphosis.
- Fix an issue where sometimes the Void Ray threshold line would not be shown even after exiting Void Metamorphosis.

## Druid
### Feral

- Fix Lua errors when the "Max Bite" coloring was supposed to be applied to the Energy Bar.
- Exclude Mana and Rage bars from being color indicator targets for Ferocious Bite max damage.

---

# 12.0.1.50-release (2026-04-05)
## General

- [#625](#625) Add optional gradient color support for bar fills and casting overlays.

### Localization

- [#733](#733) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Death Knight
### Blood

- Add optional new color indicators for Bone Shield when talented into Ossuary: one for the building range (1-5 stacks) and one for the threshold stack (5 stacks).

## Priest

- Add some new detection methods for tracking the M+5 affix Voidbinding debuff (CDR). This should even out tracking of Holy Words and Power Words for Holy and Discipline, respectively.

### Shadow

- Fix the base passive Insanity generation of Mind Flay (2 -> 3 per tick).

---

# 12.0.1.49-release (2026-04-02)
## General

- Ensure all specs have the defaults/placeholder values for the new color indications options so there are no Lua errors when opening options.

### Localization

- [#731](#731) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.1.48-release (2026-04-02)
## General

- [#152](#152) Fix some issues with settings migration that could result in resets and Lua errors.

## Death Knight

- [#152](#152) Migrated Blood, Frost, and Unholy to the new bar color change system.

## Shaman

- [#152](#152) Migrated Elemental, Enhancement, and Restoration to the new bar color change system.

## Warrior

- [#152](#152) Migrated Arms, Fury, and Protection to the new bar color change system.

---

# 12.0.1.47-release (2026-04-02)
## General
### Localization

- [#727](#727) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Druid
### Feral

- [#568](#568) Restore Ravage proc tracking, add a new Ravage color indicator, and add the logic-only bar text variable `$ravageActive` for conditional bar text logic.

## Hunter

- [#152](#152) Migrated Beast Mastery, Marksmanship, and Survival to the new bar color change system.

## Mage

- [#152](#152) Migrated Arcane, Fire, and Frost to the new bar color change system.

## Monk

- [#152](#152) Migrated Brewmaster, Mistweaver, and Windwalker to the new bar color change system.

## Paladin

- [#152](#152) Migrated Holy, Protection, and Retribution to the new bar color change system.

## Rogue

- [#152](#152) Migrated Assassination, Outlaw, and Subtlety to the new bar color change system.

## Warlock

- [#152](#152) Migrated Affliction, Demonology, and Destruction to the new bar color change system.

---

# 12.0.1.46-release (2026-03-31)
## General

- [#152](#152) Bar color changes have leveled up! You can now choose which bar(s), which part(s) of bars, and priority order of color change notifications. This is rolling out to specializations as I have time to implement it. When specializations are migrated I'll call it out as an entry in this news section.

### Localization

- [#724](#724) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Demon Hunter

- [#152](#152) Migrated Havoc, Vengeance, and Devourer to the new bar color change system.

### Devourer

- Added a new color change option for when Void Ray is ready to be used while not in Metamorphosis.

## Druid

- [#152](#152) Migrated Balance, Feral, Guardian, and Restoration to the new bar color change system.

## Evoker

- [#152](#152) Migrated Devastation, Preservation, and Augmentation to the new bar color change system.

## Priest

- [#152](#152) Migrated Discipline, Holy, and Shadow to the new bar color change system.

### Discipline

- Add Void Shield (Master the Darkness buff) proc tracking via bar border color change and new bar text variable `$voidShieldTime`.

---

# 12.0.1.45-release (2026-03-30)
## Evoker

- Allow the Essence Burst color change on Essence border to change even when the Mana bar's visibility is set to "Never Show" for Devastation and Preservation.

## Priest
### Shadow

- Restore "Instant Mind Blast Cast" bar color change when you have a Shadowy Insight proc.

---

# 12.0.1.44-release (2026-03-30)
## Evoker

- [#573](#573) Allow Essence Burst's border color change to apply to any combination of Essence, Mana, and Ebon Might (for Augmentation) bar borders instead of only Mana.

### Augmentation

- [#522](#522) Add a separate Ebon Might bar that tracks the duration remaining of Ebon Might; includes existing bar color changes. Update default behavior with the mana bar to disable these changes there by default.

---

# 12.0.1.43-release (2026-03-25)
## General

- Fix Lua errors for Devourer and Enhancement due to recent under the hood changes.
- Prevent bar text values going stale under certain visibility conditions.

---

# 12.0.1.42-release (2026-03-25)
## General

- [#719](#719) Fix bar strata not being applied to all elements.
- [#720](#720) Add "container" bar text anchor areas for multi-node bars (Combo Points, Runes, Soul Shards, etc.), allowing bar text to be anchored to the bar group as a whole instead of individual nodes.
- [#720](#720) Fix bar text variables flyout not always showing or hiding correctly when switching tabs or specializations.
- [#720](#720) Fix dynamically hidden bars (e.g. visibility conditions not met) causing other bars to shift position. Dynamically hidden bars now maintain their layout height as an invisible scaffold.

### Localization

- [#718](#718) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Death Knight
### Blood

- [#610](#610) Add a new Bone Shield bar showing current stacks (up to 12 nodes). Disabled by default. 
- [#610](#610) Add `$boneShieldStacks`, `$boneShieldStacksMax`, and `#boneShield` bar text variables.

## Warrior
### Protection

- [#548](#548) Fix an issue where sometimes Ignore Pain wouldn't track properly due to gaining Seeing Red (Violent Outburst) at the same time. Violent Outburst causing Ignore Pain to proc is still not directly supported.
- [#656](#656) Add a new "Ignore Pain (Absorb)" bar to the Defensives bar group showing the absorb stack count (0-100). The existing Ignore Pain bar is now labeled "Ignore Pain (Time)".
- Swap the value of `$ignorePainAbsorb` to be the stack count instead of the (now `secret` and unreachable) absorb amount.

---

# 12.0.1.41-release (2026-03-23)
## General

- New bar text entries now default to using the shared font settings instead of creating per-entry overrides.
- When a bar text entry is configured to use a shared font setting, the corresponding per-entry control is now disabled and grayed out for clarity.
- When a bar text entry is disabled its name in the table will now be colored red to make it more clear at a glance.
- Applied the new shared-first default behavior to all built-in default bar text layouts, including specialization-specific hard-coded defaults.
- Add "Settings Source" to the Visibility tab's "Bar Display" selection table to clarify whether the visibility settings for each bar are being controlled by the specialization-specific settings or via global options. Gray out rows that are currently being controlled by global options to make it more clear at a glance.
- Change the specialization name in the menu to be colored red when the bar is disabled for that specialization.
- Fix an issue where the "Have enough Resource" bar text color change would not update correctly for Demon Hunters, Druids, Hunters, Monks, Rogues, and Warriors.
- Fix an issue where "Fixed Resource Value" overcap bar border colors would not respect the value selected.

## Priest

- Fix some visibility inconsistencies with the utility bar when using Global Options for bar visibility.

### Discipline

- Add `$surgeOfLight` logic-only bar text variable for use in conditionals.

### Holy

- Add an optional audio cue when Benediction procs, replacing your next Flash Heal cast. Disabled by default.
- Add an optional mana bar color change while Benediction is active. Enabled by default.
- Add an optional Lightweaver bar background indicator on the next unfilled node while Benediction is active. Enabled by default.
- Add `$benediction` and `$surgeOfLight` logic-only bar text variables for use in conditionals.

## Warrior
### Fury

- Fix an issue where the Whirlwind bar would not appear after changing specializations even though it would still take up space and show bar text.

### Protection

- Fix an issue where the bar text for Shield Block and Ignore Pain would be shown on the incorrect bar after switching specializations.

---

# 12.0.1.40-release (2026-03-19)
## General

- Fix an issue where some manually tracked buffs with stacks wouldn't have their durations refresh correctly.

### Localization

- [#716](#716) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

---

# 12.0.1.39-release (2026-03-18)
## Warrior
### Fury

- Fix Lua errors for new bar users due to Whirlwind under the hood changes.

---

# 12.0.1.38-release (2026-03-17)
## General

- Fix an issue where Lua errors may occur after zoning.

### Localization

- [#715](#715) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Priest
### Holy

- [#706](#706) Add an optional restriction for the Surge of Light audio cue to only play when the Spiritwell talent is active.
- [#707](#707) Add audio cue options for when Holy Word: Chastise, Serenity, and Sanctify come off cooldown (per-charge). These only play during combat.
- [#708](#708) Add an optional Lightweaver buff stacks bar, disabled by default. This bar will show each available stack of Lightweaver as separate nodes with bar text showing how many stacks you currently have and the remaining duration on the buff.
- [#709](#709) Update Lightweaver audio cues to add a second cue and change it to be configurable for how many Lightweaver stacks are required to trigger it.
- [#714](#714) Add a new Lightweaver audio cue that will fire when your buff is about to drop off within the next X seconds (as configured).

## Shaman
### Elemental

- Don't let Earthquake being usable trigger the Elemental Blast usable audio cue or bar flashing indication.
- Add a new optional bar color change for when you have enough Maelstrom to use Earthquake. If both this and Earth Shock/Elemental Blast usable color are enabled, Earthquake's color change will only appear when Elemental Blast is talented.

## Warrior
### Fury

- [#714](#714) Fix an issue where sometimes the Whirlwind bar text would go stale and not update while out of combat.

### Protection

- [#714](#714) Fix an issue where sometimes the Shield Block or Ignore Pain bar text would go stale and not update while out of combat.

---

# 12.0.1.37-release (2026-03-17)
## General

- [#544](#544) Add font outline and shadow options for bar text.
- [#529](#529) Add new visibility conditions for bars based on resource and health thresholds (percentage or raw value).

### Localization

- [#705](#705) Updated translations for Simplified Chinese (zhCN) by M.O.S.S! Thank you so much for your help!

## Priest
### Holy

- [#704](#704) Allow the Holy Words Bars to be reordered.

## Shaman
### Enhancement

- Add a dedicated color for the 5th Maelstrom Weapon stack node.

## Warrior
### Protection

- [#656](#656) Allow each of the Defensive Bars to be enabled/disabled independently and reordered.

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
