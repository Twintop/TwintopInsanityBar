---@diagnostic disable: undefined-field, undefined-global, redundant-parameter
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

local content = [====[
*Localization of the addon is underway! If you're interested in helping translate, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know. Thank you!*

# 10.2.7.0-release (2024-05-07)
## General

- [#386 - REFACTOR (Twintop)](#386) Overhaul how spell data is stored and used under the hood.
- [#386 - REFACTOR (Twintop)](#386) Clean up unneeded spells, snapshots, and special threshold code as a result of refactors.
- (FIX (Twintop)) Prevent Lua errors from occuring when on a Dragonriding mount and on an unsupported class (Death Knight, Mage, or Warlock).

### Healers

- (FIX (Twintop)) Ensure the passive mana generation lines for Potion of Frozen Focus and Potion of Chilled Clarity render properly.

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

----

# 10.1.7.6-release (2023-10-15)
## General

- [#87 - FIX](#87) Fix an issue where adding a new bar text area and then deleting a bar text area would cause one of the remaining bar text areas to be hidden from the UI.

----

# 10.1.7.5-release (2023-10-13)
## General

- [#87 - NEW](#87) Bar text has been massively improved!
<br/>&emsp;&ensp;- You are no longer limited to three fixed bar text areas (left, center, and right). Now you can create and position an unlimited number of bar text areas.
<br/>&emsp;&ensp;- Bar text areas can now be bound to any of the Resource Bar's UI elements (main Resource Bar, specific Combo Points/Chi/Essence) or to the overall game screen. Additionally, what part of the UI element (e.g. top left, center, bottom, etc.) and positional offsets are allowed.
<br/>&emsp;&ensp;- Default values for the Font Face, Font Size, and Font Color can be set and enabled on a per-text area basis.
<br/>&emsp;&ensp;- Font horizontal alignment (justify) on a per-text area basis to ensure that your text displays out in the correct direction.
<br/>&emsp;&ensp;- Full conditional logic support for all bar text areas.
<br/>&emsp;&ensp;- Enable or disable individual bar text areas from being shown.
<br/>&emsp;&ensp;- The previous limit of 20 variables/icons per bar text area has been increased to 1000.
<br/>&emsp;&ensp;- Import/Export options updated to reflect the above changes.
<br/>&emsp;&ensp;- Existing bar text configurations will be forward-ported to use this new system. Some specializations will also have new bar text areas added with default text.
- [#87 - UPDATE](#87) Various bar text variables have been introduced for logic purposes. Specifics are included for each class or specialization below.
- [#330 - REFACTOR](#330) Change how Talents are stored and accessed.
- (REFACTOR) Standardize resource names under the hood.

## Druid
### Feral

- [#87 - NEW](#87) Bar text related enhancements:
<br/>&emsp;&ensp;- Bar text "Bound to Bar" options include each specific Combo Point in addition to the Main Resource Bar and Screen.
<br/>&emsp;&ensp;- Bar text has been added to all Combo Points bars. This text shows a timer for how long is remaining until that specific Combo Point will finish generating when it is the next to be charged from either Incarnation: King of the Jungle's buff or a Predator Revealed proc.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$incarnationTicks` -- Number of remaining ticks / incoming Combo Points from your Incarnation: Kinf of the Jungle buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$incarnationTickTime` -- Time until the next tick / Combo Point generation from your Incarnation: Kinf of the Jungle buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$incarnationNextCp` -- The next Combo Point number that will be generated when your King of the Jungle buff is active
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedNextCp` -- The next Combo Point number that will be generated when your Predator Revealed proc is active
- [#87 - FIX](#87) Allow for passive and regen values for Energy to be properly tracked as bar text.
- [#87 - FIX](#87) Show correct number of Combo Points with the `$comboPoints` bar text variable.
- [#87 - UPDATE](#87) Make the Combo Point bars span the full width of the Main Resource Bar by default.

## Evoker

- [#87 - NEW](#87) Bar text related enhancements:
<br/>&emsp;&ensp;- Bar text "Bound to Bar" options include each specific Essence in addition to the Main Resource Bar and Screen.
<br/>&emsp;&ensp;- Bar text has been added to all Essence bars. This text shows a timer for how long is remaining until the next Essence will finish regenning on the currently regenning Essence.
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$essenceRegenTime` -- Remaining time until your next Essence finishes regenerating

### Preservation

- [#87 - NEW](#87) Bar text related enhancements:
<br/>&emsp;&ensp;- Devastation was missing some Essence related bar text variables. These have been added.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$essence`, `$comboPoints` -- Current Essence
<br/>&emsp;&ensp;&emsp;&ensp;- `$essenceMax`, `$comboPointsMax` -- Maximum Essence

## Monk
### Windwalker

- [#87 - NEW](#87) Bar text related enhancements:
<br/>&emsp;&ensp;- Bar text "Bound to Bar" options include each specific Chi in addition to the Main Resource Bar and Screen.
- [#87 - FIX](#87) Show correct number of Chi with the `$chi` and `$comboPoints` bar text variables.
- [#87 - UPDATE](#87) Make the Chi bars span the full width of the Main Resource Bar by default.

## Hunter

- [#87 - FIX](#87) Fix passive focus bar text tracking to not report as a valid variable when disabled.

### Beast Mastery

- (FIX) Prevent Lua error when logging in as Beast Mastery.

## Priest
### Holy

- [#87 - NEW](#87) Bar text related enhancements:
<br/>&emsp;&ensp;- Bar text "Bound to Bar" options include each specific Holy Word charge in addition to the Main Resource Bar and Screen.
<br/>&emsp;&ensp;- Bar text has been added to all Holy Word bars. This text shows a timer for how long is remaining until that specific Holy Word charge will finish recharging.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$hwSanctifyCharges`, `$sanctifyCharges`, `$holyWordSanctifyCharges` -- Number of charges left on Holy Word: Sanctify
<br/>&emsp;&ensp;&emsp;&ensp;- `$hwSerenityCharges`, `$serenityCharges`, `$holyWordSerenityCharges` -- Number of charges left on Holy Word: Serenity
- [#87 - UPDATE](#87) Make the Holy Word bars span the full width of the Main Resource Bar by default.

## Rogue

- [#87 - NEW](#87) Bar text related enhancements:
<br/>&emsp;&ensp;- Bar text "Bound to Bar" options include each specific Chi in addition to the Main Resource Bar and Screen.
- [#87 - FIX](#87) Show correct number of Combo Points with the `$comboPoints` bar text variable.
- [#87 - UPDATE](#87) Make the Combo Point bars span the full width of the Main Resource Bar by default.

## Shaman
### Enhancement
- [#87 - FIX](#87) Show correct number of Maelstrom with the `$maelstromWeapon` and `$comboPoints` bar text variables.

----

# 10.1.7.4-release (2023-09-20)

## Priest
### Holy

- (FIX) When switching from another spec back to Holy, ensure the Holy Word bars are displayed.

----

# 10.1.7.3-release (2023-09-20)

## Priest

- (FIX) Prevent the Holy Word bars from appearing alongside the bar for Discipline or Shadow.

----

# 10.1.7.2-release (2023-09-18)
## Evoker

- [#259](#259)[#280](#280)[#312](#312) Add support for Essence Burst to Devastation, Preservation, and Augmentation
<br/>&emsp;&ensp;- Tracks the current stacks and time remaining on the Essence Burst buff, including Essence Attunement increasing maximum stacks.
<br/>&emsp;&ensp;- Optional bar border color change when the buff is active
<br/>&emsp;&ensp;- Optional audio cue when a buff stack is gained
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#eb` or `#essenceBurst` -- Essence Burst buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$ebTime` -- time remaining on Essence Burst buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$ebStacks` -- stacks on the Essence Burst buff

### Devastation

- [#259 - UPDATE](#259) Adjust default Bar and Essence dimensions.

### Preservation

- [#280 - NEW](#280) Preservation Evoker moved out of Experimental and is now available and enabled by default.
<br/>&emsp;&ensp;- Tracks Mana and Essence as resources.
<br/>&emsp;&ensp;- Tracks Essence Burst stacks and allows for border color changes, audio cues, and bar text.
<br/>&emsp;&ensp;- Threshold lines denoting how much mana will be restored from using an Aerated Mana Potion, Potion of Frozen Focus, or Conjured Chillglobe.
<br/>&emsp;&ensp;- Mana regeneration support for:
<br/>&emsp;&ensp;&emsp;&ensp;- Symbol of Hope (Holy Priest)
<br/>&emsp;&ensp;&emsp;&ensp;- Innervate (Druid)
<br/>&emsp;&ensp;&emsp;&ensp;- Mana Tide Totem (Restoration Shaman)
<br/>&emsp;&ensp;&emsp;&ensp;- Potion of Frozen Focus
<br/>&emsp;&ensp;&emsp;&ensp;- Potion of Chilled Clarity
<br/>&emsp;&ensp;&emsp;&ensp;- Molten Radiance
<br/>&emsp;&ensp;&emsp;&ensp;- Emerald Communion

### Augmentation

- [#312 - UPDATE](#312) Adjust default Bar and Essence dimensions.

## Priest
### Discipline

- (FIX) Update settings screens to be more consistent.

### Holy

- [#325 - NEW](#325) Add bars to track the cooldown status of Holy Words in a similar style to Combo Points for other specs.
<br/>&emsp;&ensp;- Control which Holy Words are tracked.
<br/>&emsp;&ensp;- Change color of the Holy Word bar when your current cast will bring it off cooldown.
<br/>&emsp;&ensp;- Independent of the main bar changing color/configuration for Holy Word cooldowns.
<br/>&emsp;&ensp;- Supports Miracle Worker, showing the appropriate number of charges available for each Holy Word.
- (FIX) Update settings screens to be more consistent.

----

# 10.1.7.1-release (2023-09-16)
## General

- [#54 - NEW](#54) Don't show the resource bar when you are in an active Pet Battle or on a Flight Path.
- [#323 - REFACTOR](#323) More enhancements, clean up, and standardize how buff, cooldown, and computed data is stored and handled.
<br/>&emsp;&ensp;- The following specializations are included in this update:
<br/>&emsp;&ensp;&emsp;&ensp;- **Evoker** - Devastation, Preservation, Augmentation
<br/>&emsp;&ensp;&emsp;&ensp;- **Hunter** - Beast Mastery, Marksmanship, Survival
<br/>&emsp;&ensp;&emsp;&ensp;- **Monk** - Mistweaver, Windwalker
<br/>&emsp;&ensp;&emsp;&ensp;- **Rogue** - Assassination, Outlaw
<br/>&emsp;&ensp;&emsp;&ensp;- **Shaman** - Elemental, Enhancement, Restoration
<br/>&emsp;&ensp;&emsp;&ensp;- **Warrior** - Arms, Fury
- [#323 - REFACTOR](#323) General linting and cleanups.
- [#323 - REFACTOR](#323) Favor a standardized tick-based resource generation class instead of custom solutions. Some abilities (Barbed Shot, Idol of C'Thun, Rapid Fire, and Eye Beam) continue to use their own special solutions.
- [#323 - FIX](#323) Restore cooldown progress swirl on threshold icons.
- [#323 - FIX](#323) Don't trigger threshold cooldown coloring and icon progress swirl from GCD locked abilities.

## Druid
### Balance

- (FIX) Update Touch the Cosmos's Astral Power reduction to be -5.

## Warrior

- (NEW) Add Blood and Thunder support for Thunder Clap.
- (CLEANUP) Remove Victory Rush spell data.

### Arms

- (FIX) Correct Whirlwind's base Rage cost.

### Fury

- (CLEANUP) Remove obsolete Bladestorm code.

----

# 10.1.7.0-release (2023-09-05)
## General

- [#323 - REFACTOR](#323) More enhancements, clean up, and standardize how buff, cooldown, and computed data is stored and handled.
<br/>&emsp;&ensp;- The following specializations are included in this update:
<br/>&emsp;&ensp;&emsp;&ensp;- **Demon Hunter** - Havoc

## Priest
### Shadow

- (FIX) Fix an issue with Mind Flay: Insanity/Mind Spike: Insanity buff duration being shorter than expected.

----

# 10.1.5.4-release (2023-08-26)
## General

- [#219 - FIX](#219) Fix NPC Id for Iridikron in Dawn of the Infinite. 

## Druid
### Feral

- (FIX) Fix LUA error when entering Prowl from Incarnation being used.

----

# 10.1.5.3-release (2023-07-25)
## General

- [#219 - UPDATE](#219) Add Time To Die override for Iridikron in Dawn of the Infinite. 
<br/>&emsp;&ensp;- Iridikron -- 85%

## Priest
### Healers

- [#328 - NEW](#328) Add support for extra passive mana regen by Imbued Frostweave Slippers. While equipped, mana regen used for determining things like mana regenerated while channeling Symbol of Hope.

----

# 10.1.5.2-release (2023-07-19)
## Druid
### Balance

- (FIX) Remove spammy debug output to chat whenever Starfall has a combat log event.

----

# 10.1.5.1-release (2023-07-13)
## Priest
### Discipline and Holy

- (FIX) Correct a LUA error when Mana Tide Totem is used by a party or raid member.
    
----

# 10.1.5.0-release (2023-07-11)
## Evoker
### Augmentation

- This feature is EXPERIMENTAL and is not enabled by default. To enable Augmentation Evoker support, go to the main "General" options menu for Twintop's Resource Bar and check "Augmentation Evoker support" under the "Experimental Features" section.<br/>
- [#312 - EXPERIMENTAL](#312) Minimalist implementation for Augmentation Evoker, tracking Essence and Mana (to a much lesser extent). Presently displays Essence in a similar fashion as Combo Points or Chi, but shows the refill status in the currently regenerating node.

## Druid
### Balance

- (FIX) Update Primordial Arcanic Pulsar spell IDs.

---

# 10.1.0.13-release (2023-06-10)
## General
### Healers

- [#323 - REFACTOR](#323) Move Innervate, Mana Tide Totem, Molten Radiance, Potion of Chilled Clarity, Potion of Frozen Focus, and Symbol of Hope implementations to the new shared class system and apply them to all healing specializations for consistancy.
- [#323 - REFACTOR](#323) Update Symbol of Hope detection and calculations to always use the casting Priest's buff data.

## Shaman
### Restoration

- (NEW) Add Resonant Waters detection to Mana Tide Totem when used by the player.

----

# 10.1.0.12-release (2023-05-31)
## Priest

- (FIX) Fix some bar text variable logic checks from providing inaccurate values.

### Shadow

- (FIX) Adjust how `$ysRemainingStacks` is determined to be a valid bar text variable, away from stack count and to check if the player is talented in to Idol of Yogg-Saron.

----

# 10.1.0.11-release (2023-05-30)
## Priest
### Holy

- (FIX) Fix an issue where another Priest's Symbol of Hope would cause incorrect data to be shown in the passive generation parts of the bar and bar text.

----

# 10.1.0.10-release (2023-05-29)
## Priest

- (FIX) Fix an issue where bar text would not be updated when tracking Shadow Word: Pain.

----

# 10.1.0.9-release (2023-05-29)
## General

- [#219 - NEW](#219) Add custom Time To Die health percentage for Ragnaros in Firelands at 10% in Normal 10/25 or Timewalking modes.
- [#323 - REFACTOR](#323) Additional backend cleanup around targets, debuffs, and cooldown tracking. Changes are still limited to the Priest module for now.
- [#324 - EXPERIMENTAL](#324) Experimental support for Discipline Priest.

### Healers

- (FIX) Correct some inconsistent behavior around threshold lines and potion usage.
- (FIX) Ensure threshold icons for potions and items are always rendered if enabled.

## Priest
### Discipline

- This feature is EXPERIMENTAL and is not enabled by default. To enable Discipline Priest support, go to the main "General" options menu for Twintop's Resource Bar and check "Discipline Priest support" under the "Experimental Features" section.
- [#324 - EXPERIMENTAL](#324) Experimental implementation for Discipline Priest, tracking Mana. Currently supports the same generic healer tracking capabilities as the other supported healing specializations: Innervate, Mana Tide Totem, Symbol of Hope, mana potions, Chillglobe, etc. Additional support has been added for mana regeneration via Shadowfiend/Mindbender, DoT tracking of Shadow Word: Pain/Purge the Wicked, and Surge of Light procs.

### Holy

- (UPDATE) Correct Symbol of Hope mana regen per tick percentage.

### Shadow

- (FIX) Update Twist of Fate spellId to enable proper tracking again.

----

# 10.1.0.8-release (2023-05-25)
## General

- [#323 - REFACTOR](#323) More enhancements, clean up, and standardize how buff, cooldown, and computed data is stored and handled.
<br/>&emsp;&ensp;- The following specializations are included in this update:
<br/>&emsp;&ensp;&emsp;&ensp;- **Priest** - Holy, Shadow

## Priest
### Holy

- [#323 - FIX](#323) Fix errors being thrown when a potion threshold line is enabled and is on cooldown.
- [#323 - FIX](#323) Only show the Shadowfiend threshold line when it matches configured settings.
- (UPDATE) Improve accuracy of Symbol of Hope predicted mana regen.

### Shadow

- (FIX) Play the Deathspeaker audio cue more than one time per session if enabled.

----

# 10.1.0.7-release (2023-05-24)
## General

- (FIX) Remove spammy debug printing.

----

# 10.1.0.6-release (2023-05-24)
## General

- [#323 - REFACTOR](#323) Further clean up and standardize how buff, cooldown, and computed data is stored and handled.
<br/>&emsp;&ensp;- The following specializations are included in this update:
<br/>&emsp;&ensp;&emsp;&ensp;- **Priest** - Holy, Shadow


## Priest
### Holy

- (FIX) Resolve an issue where settings from the Restoration Druid implementation would be used instead of from Holy Priest.

### Shadow

- [#322 - FIX](#322) Fix Auspicious Spirits tracking that broke during last refactor.

----

# 10.1.0.5-release (2023-05-22)
## General

- [#322 - REFACTOR](#322) Further clean up and standardize how debuff tracking is handled from the combat log.

## Rogue
### Assassination

- [#319 - FIX](#319) Remove debug printing around Serrated Bone Spike.

----

# 10.1.0.4-release (2023-05-22)
## General

- [#314 - REFACTOR](#314) Overhauled how targets and debuff tracking works to make it more modular and generic.

## Monk
### Windwalker

- [#318 - FIX](#318) Fix an issue where Mark of the Crane wouldn't be properly tracked from Blackout Kick with the Shadowboxing Treads talent.

## Priest
### Shadow

- [#317 - PR - st-htmn](#317) Add support for Idol of Yogg-Saron.
<br/>&emsp;&ensp;- Thanks go out to *st-htmn* for adding this functionality!
<br/>&emsp;&ensp;- Tracks the current stacks and time remaining on the Idol of Yogg-Saron buff and the time left on Thing From Beyond once spawned.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#ys` or `#idolOfYoggSaron` -- Idol of Yogg-Saron buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `#tfb` or `#thingFromBeyond` -- Thing From Beyond buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$ysTime` -- time remaining on the Idol of Yogg-Saron buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$ysStacks` -- stacks on the Idol of Yogg-Saron buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$ysRemainingStacks ` -- stacks required for Idol of Yogg-Saron to spawn a Thing From Beyond
<br/>&emsp;&ensp;&emsp;&ensp;- `$tfbTime` -- time remaining on a spawned Thing From Beyond

## Rogue
### Assassination

- [#319 - FIX](#319) Update the debuff ID for Serrated Bone Spike.

### Outlaw

- [#320 - FIX](#320) Correct some issues with bar text for poisons.

## Shaman
### Enhancement

- [#283 - FIX](#283) Hide the Maelstrom UI when switching from Enhancemnt to Elemental or Restoration.

----

# 10.1.0.3-release (2023-05-16)
## General

- [#311 - NEW](#311) Add Time To Die overrides for The Lost Dwarves in Uldaman: Legacy of Tyr 
<br/>&emsp;&ensp;- Olaf, Baelog, and Eric "The Swift" -- 10%

## Druid
### Balance

- [#310 - HOTFIX](#310) T29 4P adjustment: Entering Eclipse makes your next Starsurge or Starfall cost 10 less Astral Power (was 5).

----

# 10.1.0.2-release (2023-05-09)
## Druid
### Balance

- [#310 - HOTFIX](#310) Wrath Astral Power generation reduced to 8 (was 10).

## Monk
### Mistweaver

- [#305 - NEW](#305) Add support for Vivacious Vivification.
<br/>&emsp;&ensp;- Optional bar color change when the effect is active, denoting that Vivify can be cast instantly.
- [#306 - NEW](#306) Add support for Mana Tea.
<br/>&emsp;&ensp;- Optional bar border color change when the buff is up.
<br/>&emsp;&ensp;- New bar text icon and variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `#manaTea` -- buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$mtTime` or `$manaTeaTime` -- total time remaining on the buff

## Windwalker

- [#275 - FIX](#275) Only show Detox's threshold as on cooldown when Detox actually removes a disease or poison.

## Priest
### Shadow

- [#302 - NEW](#302) Add an optional audio cue for when you gain a Deathspeaker proc.
- [#309 - FIX](#309) Ensure Mind Spike: Insanity shows incoming casting Insanity.

----

# 10.1.0.1-release (2023-05-04)
## General

- [#307 - FIX](#307) Fix `$overcap` (and various spec-specific aliases) bar text to pull from the current character's specialization settings.

## Priest
### Holy

- [#308 - FIX](#308) Fix passive incoming mana regen from Shadowfiend not displaying.

----

# 10.1.0.0-release (2023-05-02)
## General

- [#292 - UPDATE](#292) Add `IconTexture` to TOC. This shows the addon's icon/logo in the AddOn List menu in game.
- [#298 - FIX](#298) Fix an issue where PvP ability threshold lines would show up when enabled even if you weren't talented in to the associated PvP Talent.
<br/>&emsp;&ensp;- This fix applies to: Devastation Evokers, Beast Mastery Hunters, Marksmanship Hunters, Assassination Rogues, and Outlaw Rogues.
- [#300 - UPDATE](#300) Greatly improve resource overcap support and customization.
<br/>&emsp;&ensp;- In addition to the existing "fixed" mode, an additional configuration option to set the overcap amount relative to your maximum resource has been added and set as the default behavior.
<br/>&emsp;&ensp;- Bar border and resource text will not change to the overcap color while out of combat.
- [#301 - UPDATE](#301) Update the options UI for all specs to split bar color and bar border color in to separate sections. Relocate some enabling toggles to these sections from elsewhere in the options menus.

### Healers

- [#303 - NEW](#303) Add support for the new trinket *Rashok's Molten Heart* and the proc effect, *Molten Radiance*'s, mana regen.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#mr`, `#moltenRadiance` -- spell icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$mrTime` -- total time remaining on the proc
<br/>&emsp;&ensp;&emsp;&ensp;- `$mrMana` -- total remaining incoming mana from the proc

## Druid
### Balance

- [#292 - UPDATE](#292) 10.1.0 changes:
<br/>&emsp;&ensp;- Update the Astral Power generation of New Moon, Half Moon, and Full Moon.
<br/>&emsp;&ensp;- Baseline Astral Power adjustments for Wrath, Starfire, and Stellar Flare.
<br/>&emsp;&ensp;- Soul of the Forest only increases Wrath's incoming Astral Power by 50%.
<br/>&emsp;&ensp;- Nature's Balance passive Astral Power generation values updated.
<br/>&emsp;&ensp;- Elune's Guidance Astral Power reduction to Starsurge and Starfall updated.
- [#294 - UPDATE](#294) Adjust how Touch the Cosmos (T29 4P bonus) is implemented to match changes in 10.1.0.

### Feral

- [#292 - UPDATE](#292) 10.1.0 changes:
<br/>&emsp;&ensp;- Relentless Predator's Energy modifier for Ferocious Bite updated to 80% (was 60%).
- [#292 - NEW] Add support for Berserking / Incarnation: Avatar of Ashamane passively generating Combo Points.
<br/>&emsp;&ensp;- While the buff is active, show the progress towards the next Combo Point as a filling bar on the next available Combo Point.
- [#292 - NEW](#292) Add support for Predator Revealed (T30 4P).
<br/>&emsp;&ensp;- When a proc occurs, show the progress towards the next Combo Point as a filling bar on the next available Combo Point.
<br/>&emsp;&ensp;- Custom color available to denote which Combo Points are incoming from this proc.
<br/>&emsp;&ensp;- When Berserking / Incarnation: Avatar of Ashamane is active, the order of filling Combo Points will be from soonest to last.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#predatorRevealed` -- spell icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedTime` -- total time remaining on the buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedTicks` -- total remaining ticks / Combo Points to be generated
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedTickTime` -- time until the next tick occurs / Combo Point is generated

## Hunter
### Beast Mastery

- [#299 - NEW](#299) Add support for Beast Cleave.
<br/>&emsp;&ensp;- Change the bar's border color when the Beast Cleave effect is active either via Beast Cleave, or, Call of the Wild with Bloody Frenzy also talented.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#beastCleave` -- ability icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$beastCleaveTime` -- total time remaining on the effect (Beast Cleave or Call of the Wild w/Bloody Frenzy, whichever is greater)
- (FIX) Fix Beastial Wrath being usable border color change notification.

## Monk
### Mistweaver

- [#292 - NEW](#292) Add support for Mistweaver's T30 2P proc effect, *Soulfang Infusion*, which gives passive mana regeneration.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#si`, `#soulfangInfusion` -- spell icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$siTime` -- total time remaining on the proc
<br/>&emsp;&ensp;&emsp;&ensp;- `$siTicks` -- total remaining ticks of mana regen from the proc
<br/>&emsp;&ensp;&emsp;&ensp;- `$siMana` -- total remaining incoming mana from the proc

## Priest
### Shadow

- [#292 - UPDATE](#292) 10.1.0 changes:
<br/>&emsp;&ensp;- Remove old spells/abilities: Dark Void, Mind Sear, Surge of Darkness, Piercing Shadows, Death and Madness (incoming over time).
<br/>&emsp;&ensp;- Baseline Insanity adjustments for Void Torrent, Mind Flay: Insanity, Auspicious Spirits, Void Bolt, Shadowfiend (swing), Mindbender (swing), Void Tendril (tick), and Void Lasher (tick).
<br/>&emsp;&ensp;- Remove Mind Melt from granting an instant Mind Blast.
<br/>&emsp;&ensp;- Remove "spending" bar color config.
<br/>&emsp;&ensp;- Remove all references to Mind Sear.
<br/>&emsp;&ensp;- Add support for Devouring Plague's Insanity cost being modified by Distorted Reality and Mind's Eye.
<br/>&emsp;&ensp;- Voidtouched support works automagically, allowing maximum Insanity to be 150.
<br/>&emsp;&ensp;- Update Auspicious Spirits predicted incoming Insanity to match the formula in SimulationCraft.
- [#292 - NEW](#292) Added extra threshold lines for Devouring Plague, similar to Starsurge threshold lines for Balance Druids. These are separately toggleable at 2x and 3x the cost with an additional option to only show the next available threshold line.
- [#292 - NEW](#292) Mind Flay: Insanity tracking has been extended to include Mind Spike: Insanity and keep track of stacks of the buff.
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$mfiStacks` -- number of stacks of the buff
- [#302 - NEW](#302) Add support for tracking Deathspeaker procs:
<br/>&emsp;&ensp;- Optional bar border color change when the buff is up. This superceeds the Mind Flay: Insanity / Mind Spike: Insanity border color change.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#swd`, `#shadowWordDeath`, `#deathspeaker` -- buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$deathspeakerTime` -- total time remaining on the buff

## Shaman
### Elemental

- [#292 - NEW](#292) Added support for Primal Fracture (T30 4P bonus):
<br/>&emsp;&ensp;- Optional bar border color change when the buff is up.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#primalFracture` - buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$pfTime` -- total time remaining on the buff

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