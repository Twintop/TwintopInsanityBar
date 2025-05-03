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

# 11.1.5.2-release (2025-05-??)
## Hunter
### Survival

- [#441 - NEW (Koroshy)](#440) Add optional border color change when Explosive Shot is usable.

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

---

# 11.0.7.7-release (2025-01-28)
## General

- [#418 - FIX](#418) Fix overly aggressive caching of primary and secondary stats for bar text.

---

# 11.0.7.6-release (2025-01-24)
## Evoker
### Preservation

- (FIX) Fix Lua errors when constructing the bar.

## Monk
### Mistweaver

- (FIX) Fix Lua errors when constructing the bar.

---

# 11.0.7.5-release (2025-01-24)
## General

- [#417 - REFACTOR](#417) Further optimizations:
<br/>&emsp;&ensp;- Cache ability resource costs. Cache persists until a buff/debuff changes on the player.
<br/>&emsp;&ensp;- Cache computed buff durations. Cache persists until the next frame is rendered.
<br/>&emsp;&ensp;- Cache bar text output of primary and secondary stats. Cache persists until a buff/debuff changes on the player.
<br/>&emsp;&ensp;- Improve existing cache of class and specialization info.
- (FIX) Fix corner case where a setting color's stored RGBA hexdecimal value is not exactly 8 digits long.

## Warlock
### Affliction

- (FIX) Respect the Enable/Disable for Specialization setting toggle for Affliction.

---

# 11.0.7.4-release (2025-01-10)
## General

- [#417 - REFACTOR](#417) Further optimizations:
<br/>&emsp;&ensp;- Add additional caching to previously processed bar text logic strings.
<br/>&emsp;&ensp;- Prefer events over polling for several character statuses/properties.
<br/>&emsp;&ensp;- Remove redundant bar update calls.
<br/>&emsp;&ensp;- Rate limit more bar operations to the same 20Hz used by the UI updates.
- (FIX) Fix an issue where primary and secondary stat values for bar text were not updating when changing gear.

---

# 11.0.7.3-release (2025-01-04)

## Priest
### Shadow

- (FIX) Fix Lua errors when using Shadowfiend.

---

# 11.0.7.2-release (2025-01-04)
## General

- [#417 - REFACTOR](#417) Reduce the number of frame modification calls the bar makes frame to frame.
<br/>&emsp;&ensp;- Cache threshold line positions, colors, visibility, and icons.
<br/>&emsp;&ensp;- Cache bar and combo point values and colors.
<br/>&emsp;&ensp;- This change reduces overall CPU usage required for the entire bar by between 25%-50% depending on specialization.

## Druid
### Balance

- (FIX) Correct an issue with Astral Communion's Lunar Power reduction in threshold calculations.

## Priest
### Discipline

- (FIX) Show the cooldown swirl on Mindbender and Voidwraith's threshold icon.

---

# 11.0.7.1-release (2024-12-30)
## General

- [#417 - REFACTOR](#417) Add caching to bar text logic parsing.
<br/>&emsp;&ensp;- This change reduces the CPU usage required for bar text by up to 90%.
<br/>&emsp;&ensp;- Users with complicated or bar text logic should see addon CPU reduction by upwards of 50% (i.e. Shadow Priest using `Full Advanced` preset).

---

# 11.0.7.0-release (2024-12-28)
## General

- [#388 - NEW](#388) Affliction Warlock is no longer flagged as experimental and is now available and enabled by default.

## Warlock
### Affliction

- [#388 - NEW](#388) Add support for tracking Shadow Embrace.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$shadowEmbraceMaxStacks` - Maximum possible number of stacks of Shadow Embrace on a target
<br/>&emsp;&ensp;&emsp;&ensp;- `$shadowEmbraceStacks` - Number of stacks of Shadow Embrace on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$shadowEmbraceTime` - Time remaining on Shadow Embrace on your current target
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#shadowEmbrace` - Shadow Embrace
- [#388 - NEW](#388) Add support for tracking Malign Omen.
<br/>&emsp;&ensp;- Soul Shards will have their fill and background color change to reflect the Malign Omen effect is active when consumed/generated next.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$malignOmenStacks` - Number of stacks of Malign Omen
<br/>&emsp;&ensp;&emsp;&ensp;- `$malignOmenTime` - Time remaining on your Malign Omen buff
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#malignOmen` - Malign Omen
- [#388 - NEW](#388) Add support for tracking Succulent Soul.
<br/>&emsp;&ensp;- Soul Shards will have their border color change to reflect the Succulent Soul effect is active when consumed/generated next.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$succulentSoulStacks` - Number of stacks of Succulent Soul
<br/>&emsp;&ensp;&emsp;&ensp;- `$succulentSoulTime` - Time remaining on your Succulent Soul buff
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#succulentSoul` - Succulent Soul
- [#388 - NEW](#388) Add support for tracking Nightfall stacks.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$shadowEmbraceStacks` - Number of stacks of Nightfall
<br/>&emsp;&ensp;- New audio cue:
<br/>&emsp;&ensp;&emsp;&ensp;- When you gain Nightfall.
- [#388 - NEW](#388) Add support for audio cues for Tormented Crescendo procs.
<br/>&emsp;&ensp;- New audio cues:
<br/>&emsp;&ensp;&emsp;&ensp;- When you gain 1 stack of Tormented Crescendo.
<br/>&emsp;&ensp;&emsp;&ensp;- When you gain 2 stacks of Tormented Crescendo.

---

# 11.0.5.4-release (2024-12-15)
## Priest
### Shadow

- (FIX) Further adjustments for Spell IDs for Mind Flay: Insanity and Mind Spike: Insanity.

## Warlock
### Affliction

- [#388 - NEW](#388) Add support for tracking the number of stacks of Agony
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$agonyStacks` - Number of stacks of Agony on your current target
- [#388 - NEW](#388) Add support for Wither tracking. As Wither replaces Corruption, the existing bar text variables for Corruption will work for both.
<br/>&emsp;&ensp;- New bar text icon:
<br/>&emsp;&ensp;&emsp;&ensp;- `#wither` - Wither

---

# 11.0.5.3-release (2024-12-12)
## General

- [#405 - NEW](#405) Add Global Bar Setting support for default font face, default font size, and default font color.

## Priest
### Shadow

- (FIX) Correct the Spell ID for Mind Flay: Insanity.

## Warlock
### Affliction

- [#415 - NEW (Koroshy)](#414) Add support for tracking Nightfall and Tormented Crescendo procs.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$nightfallTime` - Time remaining on Nightfall
<br/>&emsp;&ensp;&emsp;&ensp;- `$tormentedCrescendoTime` - Time remaining on Tormented Crescendo
<br/>&emsp;&ensp;&emsp;&ensp;- `$tormentedCrescendoStacks` - Number of stacks of Tormented Crescendo
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#nightfall` - Nightfall
<br/>&emsp;&ensp;&emsp;&ensp;- `#tormentedCrescendo` - Tormented Crescendo
- [#415 - NEW (Koroshy)](#415) Add support for tracking Agony, Corruption, Haunt, Phantom Singularity, Soul Rot, and Vile Taint on targets.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$agonyTime` - Time remaining on Agony on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$agonyCount` - Number of Agonys active on targets
<br/>&emsp;&ensp;&emsp;&ensp;- `$corruptionTime` - Time remaining on Corruption on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$corruptionCount` - Number of Corruptions active on targets
<br/>&emsp;&ensp;&emsp;&ensp;- `$hauntTime` - Time remaining on Haunt on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$hauntCount` - Number of Haunts active on targets
<br/>&emsp;&ensp;&emsp;&ensp;- `$phantomSingularityTime` - Time remaining on Phantom Singularity on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$soulRotTime` - Time remaining on Soul Rot on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$soulRotCount` - Number of Soul Rot active on targets
<br/>&emsp;&ensp;&emsp;&ensp;- `$unstableAfflictionTime` - Time remaining on Unstable Affliction on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$vileTaintTime` - Time remaining on Vile Tain on your current target
<br/>&emsp;&ensp;&emsp;&ensp;- `$vileTaintCount` - Number of Vile Taints active on targets
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#agony` - Agony
<br/>&emsp;&ensp;&emsp;&ensp;- `#corruption` - Corruption
<br/>&emsp;&ensp;&emsp;&ensp;- `#haunt` - Haunt
<br/>&emsp;&ensp;&emsp;&ensp;- `#phantomSingularity` - Phantom Singularity
<br/>&emsp;&ensp;&emsp;&ensp;- `#soulRot` - Soul Rot
<br/>&emsp;&ensp;&emsp;&ensp;- `#unstableAffliction` - Unstable Affliction
<br/>&emsp;&ensp;&emsp;&ensp;- `#vileTaint` - Vile Taint

---

# 11.0.5.2-release (2024-11-15)
## General

- [#401 - UPDATE](#401) Significantly reduce the amount of manual buff tracking done across all specializations.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$starlordTime` - Time remaining on Starlord
<br/>&emsp;&ensp;&emsp;&ensp;- `$starlordStacks` - Number of stacks of Starlord
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#starlord` - Starlord

## Druid
### Balance

- [#411 - NEW (Koroshy)](#411) Add support for tracking Starlord.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$starlordTime` - Time remaining on Starlord
<br/>&emsp;&ensp;&emsp;&ensp;- `$starlordStacks` - Number of stacks of Starlord
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#starlord` - Starlord
- [#412 - NEW (Koroshy)](#412) Add support for tracking Dreamburst
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$dreamburstTime` - Time remaining on Dreamburst
<br/>&emsp;&ensp;&emsp;&ensp;- `$dreamburstStacks` - Number of stacks of Dreamburst
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#dreamburst` - Dreamburst

## Monk

- (FIX) Fix an issue with bar text logic not being properly applied.

## Paladin
### Holy

- (FIX) Fix an issue with hardcasted mana costs of abilities not being displayed.

## Priest
### Holy

- [#413 - NEW](#413) Add support for tracking Answered Prayers.
<br/>&emsp;&ensp;- New bar text variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `$answeredPrayersStacks` - Number of stacks of Answered Prayers
<br/>&emsp;&ensp;&emsp;&ensp;- `$answeredPrayersMaxStacks` - Maximum number of stacks of Answered Prayers required for Apotheosis to be gained
<br/>&emsp;&ensp;&emsp;&ensp;- `$answeredPrayersRemainingStacks` - Number of additional stacks of Answered Prayers needed before Apotheosis will be gained
<br/>&emsp;&ensp;- New bar text icons:
<br/>&emsp;&ensp;&emsp;&ensp;- `#answeredPrayers` - Answered Prayers

---

# 11.0.5.1-release (2024-11-05)
## General

- [#406 - UPDATE](#406) Add Time To Die overrides additions/updates for the following enemies:
<br/>&emsp;&ensp;- Isle of Dorn - Kordac -- 5%

## Hunter
### Marksmanship

- [#404 - UPDATE](#406) Add support for Improved Steady Shot's focus generation.

## Rogue

- [#404 - UPDATE](#404) Change the behavior of existing Echoing Reprimand to now show Supercharged combo points instead.

## Shaman
### Elemental

- [#404 - UPDATE](#404) Change Icefury's Maelstrom gain calculations.

---

# 11.0.5.0-release (2024-10-23)
## Druid
### Balance

- [#404 - UPDATE](#404) Change Touch the Cosmos to rely on a single buff.
- [#404 - UPDATE](#404) Change Astral Communion to now lower the cost of Starfall or Starsurge.

## Hunter
### Beast Mastery

- [#404 - UPDATE](#404) Black Arrow threshold line now replaces Kill Shot and is available above 80% target health, below 20% target health, or when a Deathblow proc occurs.

### Marksmanship

- [#404 - UPDATE](#404) Black Arrow threshold line now replaces Kill Shot and is available above 80% target health, below 20% target health, or when a Deathblow proc occurs.

## Priest
### Shadow

- (FIX - Koroshy) Add missing localization text for Resonant Energy.

## Rogue
### Subtlety

- [#404 - UPDATE](#404) Sepsis removed.

## Shaman
### Elemental

- [#404 - UPDATE](#404) Remove Lava Beam and Flow of Power.

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