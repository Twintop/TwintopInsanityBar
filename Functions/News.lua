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

# 10.2.7.5-release (2024-05-11)
## General

- [#389 - EXPERIMENTAL (Koroshy, Twintop)](#389) Experimental support for Affliction Warlock.

### Localization

- [#8 - UPDATE (Twintop)](#8) Include missing Holy Paladin localization for bar text variables.

## Warlock
### Affliction

- This feature is EXPERIMENTAL and is not enabled by default. To enable Affliction Warlock support, go to the main "General" options menu for Twintop's Resource Bar and check "Affliction Warlock support" under the "Experimental Features" section.
- [#389 - EXPERIMENTAL (Koroshy, Twintop)](#389) Experimental implementation for Affliction Warlock, tracking Mana on the main Resource Bar and Soul Shards via the Combo Points bars. Currently supports only the baseline tracking of these resources and associated bar text. More to come!

---

# 10.2.7.4-release (2024-05-09)
## Hunter

- [#386 - FIX (Twintop)](#386) Fix threshold line creation and subsequent Lua errors and warning chat window spam.

---

# 10.2.7.3-release (2024-05-09)
## Priest
### Holy

- [#385 - FIX (Twintop)](#385) Update Harmonious Apparatus to be Voice of Harmony and fix bar color change when the current cast will take the associated Holy Word spell off cooldown.

---

# 10.2.7.2-release (2024-05-08)
## General

- (FIX (Twintop)) Fix bar and primary resource color change when you have enough primary resource to use an ability. Specifically affected specs: Balance Druid, Shadow Priest, and Elemental Shaman.

---

# 10.2.7.1-release (2024-05-08)
## General

- (FIX (Twintop)) Remove debug printing to chat frame.

## Paladin
### Holy

- (FIX (Twintop)) Fix lua errors related to Daybreak's threshold line.

---

# 10.2.7.0-release (2024-05-07)
## General

- [#386 - REFACTOR (Twintop)](#386) Overhaul how spell data is stored and used under the hood.
- [#386 - REFACTOR (Twintop)](#386) Clean up unneeded spells, snapshots, and special threshold code as a result of refactors.
- (FIX (Twintop)) Prevent Lua errors from occuring when on a Dragonriding mount and on an unsupported class (Death Knight, Mage, or Warlock).

### Healers

- (FIX (Twintop)) Ensure the passive mana generation lines for Potion of Frozen Focus and Potion of Chilled Clarity render properly.

### Localization

- [#8 - UPDATE (Koroshy)](#8) Add more French (frFR) localizations.

## Demon Hunter
### Vengeance

- (FIX (Twintop)) Correctly show Spirit Bomb's threshold line as unusable when you have 0 Soul Fragments.

## Hunter

- (FIX (Twintop)) Fix Explosive Shot threshold line's cooldown status.

## Paladin
### Holy

- (FIX (Twintop)) Fix Daybreak threshold line's cooldown status.

---

# 10.2.6.10-release (2024-04-23)
## General

- [#383 - NEW (Twintop)](#383) Add a new option to hide the Resource Bar while on a Dragonriding mount. This is located under the "Bar Display" section of the "Bar Display" tab on a per-specialization basis.

## Druid
### Balance

- (UPDATE (Twintop)) Update interaction and implementation of Touch the Cosmos (S4 4P buff) to be more reliable.

---

# 10.2.6.9-release (2024-04-20)
## Localization

- [#8 - UPDATE (Koroshy)](#8) Add more French (frFR) localizations.

## Priest

- [#336 - FIX (Twintop)](#336) Respect disabling of mana/Insanity gain tracking for Shadowfiend and Mindbender in a few places the setting was being overlooked.

### Shadow

- [#336 - FIX (Twintop)](#336) Correct Mindbender predictive incoming Insanity when Devoured Despair proc is active.

---

# 10.2.6.8-release (2024-04-18)
## Rogue

- (FIX (Twintop)) Fix LUA errors from a bad API call.
- (FIX (Twintop)) Fix threshold position being incorrect.

---

# 10.2.6.7-release (2024-04-15)
## General

- [#349 - NEW (Twintop)](#344) Add support for Holy Paladin, tracking Mana and Holy Power.
<br/>&emsp;&ensp;- Holy Power colors for the border and fill, including different colors of the penultimate and final combo point.<br/>&emsp;&ensp;- Threshold lines denoting how much mana will be restored from using an Aerated Mana Potion, Potion of Frozen Focus, or Conjured Chillglobe.
<br/>&emsp;&ensp;- Timer, stack count, bar border color changes, and audio cues for Infusion of Light stacks.
<br/>&emsp;&ensp;- Bar Text variables and icons for customization.
<br/>&emsp;&ensp;- Importing and Exporting support.
<br/>&emsp;&ensp;- Mana regeneration support for:
<br/>&emsp;&ensp;&emsp;&ensp;- Symbol of Hope (Holy Priest)
<br/>&emsp;&ensp;&emsp;&ensp;- Innervate (Druid)
<br/>&emsp;&ensp;&emsp;&ensp;- Mana Tide Totem (Restoration Shaman)
<br/>&emsp;&ensp;&emsp;&ensp;- Blessing of Winter (Holy Paladin)
<br/>&emsp;&ensp;&emsp;&ensp;- Potion of Frozen Focus
<br/>&emsp;&ensp;&emsp;&ensp;- Potion of Chilled Clarity
<br/>&emsp;&ensp;&emsp;&ensp;- Molten Radiance
<br/>&emsp;&ensp;&emsp;&ensp;- Daybreak
- (FIX (Twintop)) Prevent Combo Points, Maelstrom Weapon, Soul Fragments, Holy Words, Power Words, and Essence from not being properly filled in.
- (FIX (Twintop)) Correct inconsistencies with stack tracking of buffs.

## Healers

- [#353 - NEW (Twintop)](#353) Add passive mana generation tracking from Blessing of Winter.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#bow` or `#blessingOfWinter` -- Blessing of Winter buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$bowMana` -- how much mana will be returned over the remaining duration of Blessing of Winter buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$bowTime` -- how long is left on Blessing of Winter buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$bowTicks` -- how many ticks of mana regen remain on Blessing of Winter buff
- (FIX (Twintop)) Prevent the passive mana gain threshold line and passive bar from continuing to show when a Symbol of Hope cast completes.

## Localization

- [#351 - NEW (Twintop)](#351) Add default Google Translate localizations for all supported languages. Human-sourced translations will take precidence over these entries where available.

## Druid
### Restoration

- (FIX (Twintop)) Prevent LUA errors when using Incarnation: Tree of Life.

## Paladin
### Holy

- [NEW - #349 (Twintop)](#349) Add support for Holy Paladin, tracking Mana and Holy Power.

---

# 10.2.6.6-release (2024-04-07)
## General

- [#8 - FIX (Twintop)](#8) Fix various bar text variable and bar text icon inaccuracies throughout the addon.
- [#348 - NEW (Twintop, Koroshy)](#348) Add an option to have resource bar values update with a smooth animation, enabled by default.

### Healers

- [#346 - FIX (Twintop)](#346) Fix Lua errors when logging in for the first time with Conjured Chillglobe equipped.

### Localization

- [#8 - COMPLETE (Twintop)](#8) All existing text strings in the Bar should now be localizable!
- [#8 - UPDATE (Twintop)](#8) Add localization strings for Rogues, Shamans, Warriors, bar text variables, bar text icons, and the News popup.
- [#8 - UPDATE (Twintop)](#8) Add more British English (enGB) localisations.
- [#8 - UPDATE (Koroshy)](#8) Add more French (frFR) localizations.


---

# 10.2.6.5-release (2024-04-01)
## General
### Healers

- [#346 - UPDATE (Twintop)](#346) Add support for Dragonflight Season 4 versions of Conjured Chillglobe.

### Localization

- [#8 - FIX (Twintop)](#8) Prevent Lua errors from occurring when a LibSharedMedia resource is invalid.
- [#8 - UPDATE (Twintop)](#8) Add localization strings for Demon Hunters, Druids, Evokers, Hunters, Monks, Priests, shared healer fields, shared Combo Point fields, and various class resources.
- [#8 - UPDATE (unfug)](#8) Add more German (deDE) localizations.
- [#8 - UPDATE (Twintop)](#8) Add more British English (enGB) localisations.
- [#8 - UPDATE (Koroshy)](#8) Add more French (frFR) localizations.

## Priest
### Shadow

- [#347 - NEW (Koroshy)](#347) Add bar border color change when there is a Mind Devourer proc.

---

# 10.2.6.4-release (2024-03-26)
## General

- [#8 - UPDATE](#8) Add more German (deDE) localizations from **unfug**.
- [#8 - UPDATE](#8) Add more British English (enGB) localisations from **Twintop**.
- [#8 - UPDATE](#8) Add more French (frFR) localizations from **Koroshy**.

## Priest
### Holy

- (FIX) Fix Shadowfiend and Symbol of Hope threshold lines for confusing themselves with one another.
- (FIX) Fix Symbol of Hope shown mana % slider not remembering a previously configured value.

---

# 10.2.6.3-release (2024-03-21)
## General

- [#8 - UPDATE](#8) Add more German (deDE) localizations from **unfug**.
- [#8 - UPDATE](#8) Add more French (frFR) localizations from **Koroshy**.

## Demon Hunter

- [#344 - FIX](#344) Prevent Soul Fragments from showing while your specialization is Havoc.

---

# 10.2.6.2-release (2024-03-20)
## General

- [#8 - UPDATE](#8) Simplify some localization strings formats.
- [#8 - UPDATE](#8) Add initial German (deDE) localization from **unfug**.
- [#345 - UPDATE](#345) Update mana regen values for existing Conjured Chillglobes from Dragonflight season 1.

## Druid
### Balance

- [#345 - UPDATE](#345) Update Vault of the Incarnates (T29 4P) Astral Power reduction to -15 (was -5).

---

# 10.2.6.1-release (2024-03-19)
## Demon Hunter
### Vengeance

- [#344 - FIX](#344) Ensure all Soul Fragment configuration options are shown.

---

# 10.2.6.0-release (2024-03-19)
## General

- [#8 - NEW](#8) Add more localization strings for shared options UI components.
- [#344 - NEW](#344) Add support for Vengeance Demon Hunter, tracking Fury and Soul Fragments.
<br/>&emsp;&ensp;- Soul Fragment colors for the border and fill, including different colors of the penultimate and final combo point.
<br/>&emsp;&ensp;- Configurable threshold lines for Chaos Nova, Fel Devastation, Soul Cleave, and Spirit Bomb. Additionally, Soul Furnace buff tracking will highlight Soul Cleave and Spirit Bomb in a different color when they will deal extra damage.
<br/>&emsp;&ensp;- Bar color change when Metamorphosis is active and when it is close to ending.
<br/>&emsp;&ensp;- Passive Fury generation from Immolation Aura.
<br/>&emsp;&ensp;- Timers for Metamorphosis and Immolation Aura time remaining.
<br/>&emsp;&ensp;- Bar Text variables and icons for customization.
<br/>&emsp;&ensp;- Importing and Exporting support.
- (FIX) Improve bar text parsing for icon names.

## Demon Hunter
### Havoc

- (FIX) Correct Fel Barrage threshold line toggle.
- (FIX) Include End of Metamorphosis configuration when exporting settings.

### Vengeance

- [NEW - #344](#344) Add support for Vengeance Demon Hunter, tracking Fury and Soul Fragments.

## Druid
### Restoration

- (FIX) Include Restoration Druid as a valid target spec for importing settings.

---

# 10.2.5.4-release (2024-03-03)
## General

- [#339 - FIX](#339) Fix various buff stack counts from not being properly tracked. See specifics for each specialization below.
- (FIX) Prevent some calculations that require a target from failing even when you do have a valid target.

## Druid
### Feral

- [#339 - FIX](#339) Fix application tracking for Bloodtalons and Moment of Clarity.

### Restoration

- [#339 - FIX](#339) Fix application tracking for Reforestation.

## Evoker

- [#339 - FIX](#339) Fix application tracking for Essence Burst.

## Hunter
### Beast Mastery

- [#339 - FIX](#339) Fix application tracking for Frenzy.

## Priest
### Discipline

- [#339 - FIX](#339) Fix application tracking for Surge of Light.

### Holy

- [#339 - FIX](#339) Fix application tracking for Lightweaver, Sacred Reverence, and Surge of Light.

### Shadow

- [#339 - FIX](#339) Fix application tracking for Death's Torment, Idol of Yogg-Saron, Mind Melt, and Surge of Insanity.

## Shaman
### Elemental

- [#339 - FIX](#339) Fix application tracking for Icefury and Stormkeeper.

## Warrior
### Fury

- [#339 - FIX](#339) Fix application tracking for Whirlwind.
- (FIX) Fix Execute thresholds not being displayed at correct times.

---

# 10.2.5.3-release (2024-03-02)
## General

- [#8 - NEW](#8) Localization of the options menus has begun *(finally)*! While few actual translations are available as of yet, some areas that now support localization include:
<br/>&emsp;&ensp;- Global Options
<br/>&emsp;&ensp;- Import/Export
<br/>&emsp;&ensp;- Shared Options UI components, i.e. bar position, bar style, combo points.
- [#259 - NEW](#259) Devastation Evoker moved out of Experimental and is now available and enabled by default.
<br/>&emsp;&ensp;- Implementation is still fairly minimal, if you have any requests please let me know!
<br/>&emsp;&ensp;- Tracks Essence and Mana as resources.
<br/>&emsp;&ensp;- Shows current regen state and time remaining for Essence.
<br/>&emsp;&ensp;- Tracks Essence Burst, allowing for bar border color changes, bar text, and audio cues.
<br/>&emsp;&ensp;- Bar Text variables and icons for customization.
- [#312 - NEW](#312) Augmentation Evoker moved out of Experimental and is now available and enabled by default.
<br/>&emsp;&ensp;- Implementation is still fairly minimal, if you have any requests please let me know!
<br/>&emsp;&ensp;- Tracks Essence and Mana as resources.
<br/>&emsp;&ensp;- Shows current regen state and time remaining for Essence.
<br/>&emsp;&ensp;- Tracks Essence Burst, allowing for bar border color changes, bar text, and audio cues.
<br/>&emsp;&ensp;- Bar Text variables and icons for customization.

## Rogue
### Subtlety

- [#341 - FIX](#341) Fix issues with Subtlety default bar text not being loaded and causing Lua errors.

---

# 10.2.5.2-release (2024-02-29)
## General

- [#343 - FIX](#343) Allow target tracking, including Time To Die calculations and DoT status, to continue even when dead.
- (FIX) Fix errors when attempting to change the base bar border color.

## Rogue
### Subtlety

- [#341 - NEW](#341) Add threshold color change support for abilities buffed by Finality.
- [#341 - NEW](#341) Add threshold color change support for Shuriken Storm when buffed by Silent Storm.
- [#341 - NEW](#341) Add Symbols of Death tracking.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#sod` or `#symbolsOfDeath` -- Symbols of Death buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$sodTime` or `$symbolsOfDeathTime` -- how long is left on Symbols of Death buff
- [#341 - NEW](#341) Add bar border color change when Shadowcraft will proc on your next finishing move use.

---

# 10.2.5.1-release (2024-02-20)
## General

- [#285 - NEW](#285) Add support for Subtlety Rogue, tracking Energy and Combo Points.
<br/>&emsp;&ensp;- Combo Point colors for the border and fill, including different colors of the penultimate and final combo point.
<br/>&emsp;&ensp;&emsp;&ensp;- Extra colors to show extra gains from Shadow Techniques or bonus finisher effects from Echoing Reprimand.
<br/>&emsp;&ensp;- Configurable threshold lines for all builders, finishers, utility, and PvP abilities. Some threshold lines have extra logic to determine when they are shown, e.g. only while Stealthed or with an appropriate buff that allows them to be used.
<br/>&emsp;&ensp;- Bar color change when Slice and Dice is not up or is within the pandemic refresh window (based on current number of Combo Points).
<br/>&emsp;&ensp;- Counts of current total applications poisons out on targets.
<br/>&emsp;&ensp;- Timers for poisons, Flagellation buff, and Slice and Dice remaining.
<br/>&emsp;&ensp;- Bar Text variables and icons for customization.
<br/>&emsp;&ensp;- Importing and Exporting support.
<br/>&emsp;&ensp;- Further enhancements will be coming in subsequent releases as part of [#341](#341).
- [#340 - NEW](#340) Add a global customization for how much precision to show in timers in bar text. Three new options allow you to configure a "high" and "low" timer amount and vary the precision at some changeover point.
<br/>&emsp;&ensp;- Example: I want 0 decimals shown for long duration timers and 1 decimal shown for short duration timers. If my changeover point is 5 seconds, above 5 seconds I will not see any decimals (i.e, `9`) and below 5 seconds I will see 1 decimal (i.e., `4.6`).
- [#339 - FIX](#339) Fix memory leaks due to Blizzard APIs (`UnitBuff` and `UnitDebuff`) becoming deprecated. More adjustments are in the works to further improve the bar's memory usage.

## Hunter
### Beast Mastery

- (FIX) Correctly track the Frenzy buff on the Hunter's pet.

## Rogue

- (FIX) Don't show Echoing Reprimand threshold line when it is enabled and you are not talented in to it.
- (FIX) Show Gouge threshold as being unusable while on cooldown.

### Assassination

- (FIX) Correct LUA error, and bar behavior, when using Sepsis.

### Subtlety

- [NEW - #285](#285) Add support for Subtlety Rogue, tracking Energy and Combo Points.

----

# 10.2.5.0-release (2024-01-16)
## General

- (UPDATE) Update TOC for patch 10.2.5.
- (UPDATE) Adjust how color pickers work to match API changes in 10.2.5.

## Rogue
### Assassination

- (FIX) Correct LUA error, and bar behavior, when using Sepsis.

## Warrior

- (UPDATE) Remove Spear of Bastion (now Champion's Spear) references as they are not used for any calculations or data display.

----

# 10.2.0.3-release (2023-12-29)
## General

- (FIX) Correct an issue where bar text defaults would not be created on a new installation.
- (HOUSEKEEPING) Adjust linting.

## Shaman

- (FIX) Fix an issue where the Shaman module may not load correctly if the Enhancement experimental feature was disabled.

----

# 10.2.0.2-release (2023-12-26)
## General

- [#324 - NEW](#324) Discipline Priest moved out of Experimental and is now available and enabled by default.
<br/>&emsp;&ensp;- Tracks Mana and Power Word: Solace as resources.
<br/>&emsp;&ensp;- Tracks Rapture, allowing for bar color changes and bar text.
<br/>&emsp;&ensp;- Tracks Shadow Covenant, allowing for bar border color changes and bar text.
<br/>&emsp;&ensp;- Tracks Surge of Light stacks and allows for border color changes, audio cues, and bar text.
<br/>&emsp;&ensp;- Tracks Atonement buffs with bar text.
<br/>&emsp;&ensp;- Tracks Shadow Word: Pain / Purge the Wicked debuffs with bar text.
<br/>&emsp;&ensp;- Threshold lines denoting how much mana will be restored from using an Aerated Mana Potion, Potion of Frozen Focus, or Conjured Chillglobe.
<br/>&emsp;&ensp;- Mana regeneration support for:
<br/>&emsp;&ensp;&emsp;&ensp;- Symbol of Hope (Holy Priest)
<br/>&emsp;&ensp;&emsp;&ensp;- Innervate (Druid)
<br/>&emsp;&ensp;&emsp;&ensp;- Mana Tide Totem (Restoration Shaman)
<br/>&emsp;&ensp;&emsp;&ensp;- Shadowfiend and Mindbender
<br/>&emsp;&ensp;&emsp;&ensp;- Potion of Frozen Focus
<br/>&emsp;&ensp;&emsp;&ensp;- Potion of Chilled Clarity
<br/>&emsp;&ensp;&emsp;&ensp;- Molten Radiance

## Priest
### Discipline

- [#324 - NEW](#324) Add Atonement tracking support.
<br/>&emsp;&ensp;- This behaves in a similar way as Mark of the Crane does for Windwalker where you can track the total number out, duration remaining on your current target, and the maximum and minimum remaining time on all buffs out.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#atonement` -- Atonement buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$atonementCount` -- total number of active Atonements out
<br/>&emsp;&ensp;&emsp;&ensp;- `$atonementTime` -- how long is left on your target's Atonements buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$atonementMinTime` -- how long is left on your oldest Atonements buff across all targets
<br/>&emsp;&ensp;&emsp;&ensp;- `$atonementMaxTime` -- how long is left on your most recently cast Atonement buff across all targets

### Holy

- [#335 - NEW](#335) Add Symbol of Hope threshold line showing how much mana will be gained by using it. Includes configuration options to show the line when on cooldown and how much remaining mana percent you should have before showing.
- (FIX) Include Holy Word settings when exporting bar configuration.

### Shadow

- [#334 - NEW](#334) Add Death's Torment (T31 4P bonus) support.
<br/>&emsp;&ensp;- Optional bar border color changes and audio cues when at max stacks or a lower number of stacks that can be configured between 1 - 11.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#deathsTorment` -- Death's Torment buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$deathsTormentStacks` -- current number of stacks of the Death's Torment buff

----

# 10.2.0.1-release (2023-11-21)
## General

- [#219 - UPDATE](#219) Add custom Time To Die override for the new world boss, Aurostor, at 20%.
- (FIX) Fix `$ttd` and `$ttdSeconds` always returning `false` when used as logic variables.
- (FIX) Fix imports failing when not containing Evoker data.

## Priest
### Discipline (experimental)

- [#324 - NEW](#324) Add Power Word: Radiance cooldown bars in a similar style to the Holy Word cooldown bars for Holy Priest.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#pwRadiance`, `#powerWordRadiance` -- Power Word: Radiance ability icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$pwRadianceTime`, `$radianceTime`, `$powerWordRadianceTime` -- time remaining on Power Word: Radiance's cooldown for the current charge
<br/>&emsp;&ensp;&emsp;&ensp;- `$pwRadianceCharges`, `$radianceCharges`, `$powerWordRadianceCharges` -- current number of available charges of Power Word: Radiance
- [#324 - NEW](#324) Add Rapture support.
<br/>&emsp;&ensp;- Bar color change while active with a second color change based on time or GCDs remaining.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#rapture` -- Rapture ability icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$raptureTime` -- time remaining on Rapture's buff
- [#324 - NEW](#324) Add Shadow Covenant support.
<br/>&emsp;&ensp;- Bar border color change while active.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#sc`, `#shadowCovenant` -- Shadow Covenant ability icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$scTime`, `$shadowCovenantTime` -- time remaining on Shadow Covenant's buff
- [#324 - FIX](#324) Fix importing to recognize Discipline Priest import strings.

### Holy

- (FIX) Add safeguards around the Holy Word bars to prevent occasional LUA errors.

## Shaman
### Elemental

- (FIX) Ensure that bar border overcap color changes always occur if enabled.

----

# 10.2.0.0-release (2023-11-07)
## General
### Healers

- [#329 - UPDATE](#329) Symbol of Hope restores 2% mana per tick.

## Demon Hunter
### Havoc

- [#329 - NEW](#329) Add support for A Fire Inside.
- [#329 - NEW](#329) Add support for Fel Barrage.
<br/>&emsp;&ensp;- New threshold line that will show up when enabled and talented.
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#felBarrage` -- Fel Barrage icon
- [#329 - UPDATE](#329) Update Burning Hatred to generate 4 Fury per tick.
- [#329 - UPDATE](#329) Update Chaos Nova's cost to 25 Fury.

## Druid
### Balance

- [#329 - UPDATE](#329) Rattle the Stars now reduces the Astral Power cost of Starsurge and Starfall by 10%.

### Feral

- [#329 - UPDATE](#329) Relentless Predator's Energy cost reduction is now 10%

## Hunter
### Beast Mastery

- [#329 - NEW](#329) Add Savagery support.
- [#329 - UPDATE](#329) Remove Aspect of the Wild.

### Marksmanship

- [#329 - UPDATE](#329) Actively refresh Trueshot duration remaining.

## Priest
### Holy

- [#329 - NEW](#329) Add Holy Word color change support for Sacred Reverence (T31 4P) procs.
<br/>&emsp;&ensp;- Holy Word: Sanctify and Holy Word: Serenity will change colors based on the number of stacks of the buff you have, and, if you are able to cast the associated spell.
<br/>&emsp;&ensp;- This color change denotes that the cast will not consume a charge of the associated Holy Word.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#sacredReverence` -- Sacred Reverence buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$sacredReverenceStacks` -- stacks on Sacred Reverence buff
- (FIX) Respect the disabling of "Complete cooldown color change?" configuration option for Holy Words.

### Shadow

- [#329 - UPDATE](#329) Update Mind Flay: Insanity's generation to 4 Insanity per tick.
- [#329 - UPDATE](#329) Update Mind Spike: Insanity's generation to 8 Insanity.

## Rogue

- [#329 - NEW](#329) Add Shadow Dance as a trigger to show stealth threshold lines.
- [#329 - UPDATE](#329) Feint now has charges.
- [#329 - UPDATE](#329) Shiv's cost increased to 30 Energy.

### Assassination

- [#329 - UPDATE](#329) Update Crimson Tempest's duration per combo point spent.
- [#329 - UPDATE](#329) Remove Exsanguinate as the active version has no on-use Energy cost now.
- [#329 - UPDATE](#329) Add Vicious Venoms support to increase the Energy cost of Mutilate and Ambush by 5/10.

### Outlaw

- [#329 - NEW](#329) Add Subterfuge as a trigger to show stealth threshold lines.
- [#329 - NEW](#329) Add Underhanded Upper Hand as a trigger to show stealth threshold lines.
- [#329 - UPDATE](#329) Add Killing Spree threshold line.

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