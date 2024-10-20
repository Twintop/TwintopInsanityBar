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

# 11.0.5.0-release (2024-10-22)
## General

## Priest
### Shadow

- (FIX - Koroshy) Add missing localization text for Resonant Energy.

## Rogue
### Subtlety

- [#404 - UPDATE](#404) Sepsis removed.

---

# 11.0.2.10-release (2024-10-15)
## General

- [#406 - UPDATE](#406) Add Time To Die overrides additions/updates for the following enemies:
<br/>&emsp;&ensp;- The Dawnbreaker - Rasha'nan -- 60%

---

# 11.0.2.9-release (2024-10-14)
## General

- [#406 - UPDATE](#406) Add Time To Die overrides additions/updates for the following enemies:
<br/>&emsp;&ensp;- Delves - Reno Jackson -- 33.3%
<br/>&emsp;&ensp;- Delves - Sir Finley Mrrgglton -- 33.3%
- [#407 - FIX](#407) Put some safety rails around the duration of bar pulsing options to stop invalid values (and the Lua errors that love them) from being set.

---

# 11.0.2.8-release (2024-10-11)
## General

- [#406 - UPDATE](#406) Add Time To Die overrides additions/updates for the following enemies:
<br/>&emsp;&ensp;- Isle of Dorn - Queensguard Zirix -- 85%
<br/>&emsp;&ensp;- Theater Troupe - Wanderer Ida -- 30%
<br/>&emsp;&ensp;- Delves - Reno Jackson -- 34%
<br/>&emsp;&ensp;- Skittering Breach - Speaker Xanventh -- 66% then 50%
<br/>&emsp;&ensp;- Darkflame Cleft - The Darkness -- fix NPC ID
<br/>&emsp;&ensp;- Grim Batol - Valiona -- 50.5%
<br/>&emsp;&ensp;- The Dawnbreaker - Rasha'nan -- 59%
- (UPDATE) Update LibSharedMedia-3.0 to revision 151.

## Hunter

- (FIX) Correct the logic around Kill Shot being labeled as usable.

### Beast Mastery

- (FIX) Remove Arcane Shot from being a threshold line.

## Priest
### Shadow

- [#405 - REFACTOR](#405) Standardize settings in preparation for more Global Bar Settings.

## Shaman
### Elemental

- [#405 - REFACTOR](#405) Standardize settings in preparation for more Global Bar Settings.

---

# 11.0.2.7-release (2024-09-11)
## General

- (UPDATE (Twintop)) Improve cleaning up of aura tracking data when changing specializations or talents.

## Druid

- (FIX (Twintop)) Fix Lua errors as Guardian Druid.

---

# 11.0.2.6-release (2024-09-08)
## General

- [#403 - UPDATE (Twintop)](#403) Add Time To Die overrides for the following enemies:
<br/>&emsp;&ensp;- Darkflame Cleft - The Darkness -- 44.5%
<br/>&emsp;&ensp;- The Dawnbreaker - Rasha'nan -- 59.5%

## Monk
### Mistweaver

- (FIX (Twintop)) Prevent a Lua error when tracking Mana Tea mana regen with Energizing Brew talented.

---

# 11.0.2.5-release (2024-08-25)
## General

- (FIX (Twintop)) Stop debug printing from happening on some classes.

---

# 11.0.2.4-release (2024-08-23)
## General

- (FIX (Twintop)) Fix Lua errors when switching to an unsupported or disabled specialization.

---

# 11.0.2.3-release (2024-08-22)
## Druid
### Balance

- [#398 - UPDATE (Twintop)](#398) Add support for Balance's The War Within Season 1 4-piece set bonus.

---

# 11.0.2.2-release (2024-08-20)
## General

- [#342 - UPDATE (Twintop)](#342) Change how the bar handles updating buffs and debuffs to use `UNIT_AURA` instead of polling every frame. Memory usage should be 50-80% lower depending on specialization.

## Healers

- [#382 - UPDATE (Twintop)](#382) Update short number notation. Healers should no longer see e.g. `12.3k/2.5m` and instead see `12.34k/2500k`.
- [#382 - UPDATE (Twintop)](#382) Update potions from Dragonflight to The War Within. As a result, default potion thresholds have also been reset.

## Hunter
### Marksmanship

- (FIX) Avoid a Lua error when using Steady Shot without Improved Steady Shot talented.

## Priest

- (FIX) Properly track Shadowfiend/Mindbender/Voidwraith when Glyph of the Sha is enabled.

---

# 11.0.2.1-release (2024-08-13)
## General

- (UPDATE (Twintop)) Update localizations.

## Priest

- [#402 - FIX (Twintop)](#402) Fix an issue where Shadowfiend bar text would cause Lua errors if you had disabled tracking Insanity or Mana gain from Shadowfiend.

---

# 11.0.2.0-release (2024-08-13)
## Druid
### Balance 

- [#359 - NEW (Twintop)](#359) Add support for Boundless Moonlight, modifying Full Moon.
- [#359 - NEW (Twintop)](#359) Add support for The Eternal Moon, modifying New Moon, Half Moon, and Fury of Elune.
- [#359 - NEW (Twintop)](#359) Add support for The Light of Elune.
- [#359 - NEW (Twintop)](#359) Add support for Bounteous Bloom.
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$bbAstralPower` - Incoming Astral Power from your Bounteos Bloom.
<br/>&emsp;&ensp;&emsp;&ensp;- `$bbTicks` - Number of ticks remaining.
<br/>&emsp;&ensp;&emsp;&ensp;- `$bbTime` - Time remaining on your Bounteous Bloom.
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#bb`, `#boundlessBloom` - Bounteous Bloom
- [#359 - UPDATE (Twintop)](#359) Combine Sundered Firmament bar text variable data with Fury of Elune.

### Feral 

- [#360 - NEW (Twintop)](#360) Add support for Ravage, modifying Ferocious Bite.
- [#360 - NEW (Twintop)](#360) Add support for Frenzied Regeneration in Catform with Empowered Shapeshifting, showing a threshold line when usable.

## Priest

- (NEW (Twintop)) Add a bar text variable, `$sfCount`, that shows the current number of Shadowfiends/Mindbenders/Voidwraiths spawned.

### Discipline

- [#371 - NEW (Twintop)](#371) Add support for tracking Entropic Rift.
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$entropicRiftTime` - Time remaining on your Entropic Rift.
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#entropicRift` - Entropic Rift

### Shadow

- [#373 - NEW (Twintop)](#373) Add support for tracking Entropic Rift.
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$entropicRiftTime` - Time remaining on your Entropic Rift.
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#entropicRift` - Entropic Rift

## Rogue
### Outlaw

- [#375 - NEW (Twintop)](#375) Add support for Coup de Grace as a threshold line, replacing Dispatch.

### Subtlety

- [#376 - NEW (Twintop)](#376) Add support for Coup de Grace as a threshold line, replacing Eviscerate.

## Warrior
### Fury

- [#371 - NEW (Twintop)](#381) Add support for Crashing Thunder.

---

# 11.0.2.0-beta01 (2024-08-05)

## Druid
### Balance 

- [#359 - UPDATE (Twintop)](#359) Astral Communion now generates 25 Astral Power.

## Priest
### Discipline

- [#371 - NEW (Twintop)](#371) Add support for Depth of Shadows -- multiple Shadowfiends/Mindbenders spawned at once. The existing variables that track remaining GCDs, swings, or time will now report back the highest amount between all active spawns. Mana generation will be the total amount over the period selected for all active spawns.
- [#371 - FIX (Twintop)](#371) Force the Mindbender threshold line to obey the same choice in display as Shadowfiend.

### Shadow

- [#373 - NEW (Twintop)](#373) Add support for Depth of Shadows -- multiple Shadowfiends/Mindbenders spawned at once. The existing variables that track remaining GCDs, swings, or time will now report back the highest amount between all active spawns. Insanity generation will be the total amount over the period selected for all active spawns.
- [#373 - UPDATE (Twintop)](#373) Mind Spike: Insanity now generates 12 Insanity.
- [#373 - UPDATE (Twintop)](#373) Idol of C'thun tentacles now deal damage, and generate Insanity, every 1.5 seconds.

## Warlock
### Affliction

- (FIX (Koroshy)) Fix options menu loading.

---

# 11.0.0.2-release (2024-07-31)
## General

- (FIX (Twintop)) Fix Lua errors caused by malformed localization strings.

---

# 11.0.0.1-release (2024-07-23)
## General

- [#356 - UPDATE (Twintop)](#356) Updated all supported specs for The War Within prepatch. See alpha release patchnotes below for a more detailed list of changes.
- (UPDATE) Update localizations to include new and updated strings.

## Druid
### Balance

- [#359 - UPDATE (Twintop)](#359) Updates to reflect the state of Balance in prepatch:
<br/>&emsp;&ensp;- Added
<br/>&emsp;&ensp;&emsp;&ensp;- Touch the Cosmos
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Starsurge threshold lines and the Starfall threshold line will light up if you have enough Touch the Cosmos procs, Starweaver's procs, and/or Astral Power to use the ability.

---

# 11.0.0.0-alpha09 (2024-07-22)
## Druid
### Balance

- [#359 - UPDATE (Twintop)](#359) Updates to reflect the state of Balance in beta:
<br/>&emsp;&ensp;- Added
<br/>&emsp;&ensp;&emsp;&ensp;- Astral Communion
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Wrath and Starfire will show the extra incoming Astral Power if that cast will trigger an Eclipse.
<br/>&emsp;&ensp;&emsp;&ensp;- Moon Guardian
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Increase amount of Astral Power generated by Starfire hardcasts.
<br/>&emsp;&ensp;- Removed
<br/>&emsp;&ensp;&emsp;&ensp;- Primordial Arcanic Pulsar
<br/>&emsp;&ensp;- Updated:
<br/>&emsp;&ensp;&emsp;&ensp;- Astral Power generation of the following abilities: Starfire, Wrath, Stellar Flare, Soul of the Forest, New Moon, Half Moon, Full Moon.


## Rogue
### Assassination

- [#374 - UPDATE (Twintop)](#374) Updates to reflect the state of Assassination in beta:
<br/>&emsp;&ensp;- Removed
<br/>&emsp;&ensp;&emsp;&ensp;- Shadow Dance
<br/>&emsp;&ensp;&emsp;&ensp;- Sepsis
<br/>&emsp;&ensp;- Updated
<br/>&emsp;&ensp;&emsp;&ensp;- Serrated Bone Spike
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Combo Points, border, and background now change color to show how many Combo Points will be generated if you use Rupture.

### Outlaw

- [#375 - UPDATE (Twintop)](#375) Updates to reflect the state of Outlaw in beta:
<br/>&emsp;&ensp;- Removed
<br/>&emsp;&ensp;&emsp;&ensp;- Shadow Dance
<br/>&emsp;&ensp;&emsp;&ensp;- Sepsis

### Subtlety

- [#376 - UPDATE (Twintop)](#376) Updates to reflect the state of Subtlety in beta:
<br/>&emsp;&ensp;- Updated
<br/>&emsp;&ensp; - Shadow Dance is now baseline.

## Shaman
### Elemental

- [#377 - UPDATE (Twintop)](#377) Updates to reflect the state of Elemental in beta:
<br/>&emsp;&ensp;- Updated:
<br/>&emsp;&ensp;&emsp;&ensp;- Maelstrom generation of the following abilities: Lighting Bolt, Lava Burst, Chain Lightning, Frost Shock, Icefury, Flow of Power.
<br/>&emsp;&ensp;&emsp;&ensp;- Icefury spell id and behavior.

## Warrior
### Arms

- [#380 - UPDATE (Twintop)](#380) Updates to reflect the state of Arms in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Storm of Swords
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track this to show the Cleave or Whirlwind thresholds as usable regardless of current Rage.
<br/>&emsp;&ensp;- Updated:
<br/>&emsp;&ensp;&emsp;&ensp;- Cleave and Whirlwind
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Mutually exclusive and share the same threshold configuration.

---

# 11.0.0.0-alpha08 (2024-07-13)
## Demon Hunter
### Havoc

- [#357 - UPDATE (Twintop)](#357) Updates to reflect the state of Havoc in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Warblade's Hunger
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Chaos Strike threshold line has the "special" coloring while active.

## Evoker
### Augmentation

- [#364 - UPDATE (Twintop)](#364) Updates to reflect the state of Augmentation in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Temporal Burst support, applied via Tip the Scales.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track when the buff is up allow for the mana bar to change color while active.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$temporalBurstTime` - Time remaining on your Temporal Burst buff.
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#temporalBurst` - Temporal Burst

### Preservation

- [#363 - UPDATE (Twintop)](#363) Updates to reflect the state of Preservation in beta:
<br/>&emsp;&ensp;- Added:
<br/>&emsp;&ensp;&emsp;&ensp;- Temporal Burst support, applied via Tip the Scales.
<br/>&emsp;&ensp;&emsp;&ensp;&emsp;&ensp;- Track when the buff is up allow for the mana bar to change color while active.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$temporalBurstTime` - Time remaining on your Temporal Burst buff.
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#temporalBurst` - Temporal Burst

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