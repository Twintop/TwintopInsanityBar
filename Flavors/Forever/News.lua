local _, TRB = ...

-- World of Warcraft: Forever changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for World of Warcraft: Forever is in early development. Please report any issues via Discord or GitHub. Thanks!*

---

# 1.60.1.19-release (2026-11-12)
## General
### Bar Visibility

- [#986](#986) Fix a mana spec's Primary Resource Value bar visibility condition being met at far less mana than the value set.
- [#986](#986) A mana spec's Primary Resource Value condition now goes up to 15,000.

### Color Indicators

- [#993](#993) A custom Color Indicator or Buff Alert on a buff or debuff under Not Displayed now works when its ability is in Essential Cooldowns or Utility Cooldowns, such as a damage over time effect on your target.

### Custom Bars

- [#992](#992) A custom bar can track the cooldown, recharge, or charges of an ability in your Cooldown Manager, including the ones under Not Displayed.
- [#993](#993) A custom bar can track the duration or stacks of a buff, enemy debuff, trinket buff, or combat potion buff in your Cooldown Manager.
- [#993](#993) A buff in Tracked Bars keeps End Cap and Smooth on its custom bar. One in Tracked Buffs fills without them, and one that isn't displayed needs Always Show.

## Mage

- [#981](#981) Add a new Arcane Blast bar, tracking your Arcane Blast stacks, with the `$arcaneBlastStacks`, `$arcaneBlastStacksMax`, `$arcaneBlastTime`, and `#arcaneBlast` bar text variables. It shows once you take the Arcane Blast talent.
- [#981](#981) Each Arcane Blast cast fills one of its four nodes, and the stacks end 18 seconds after the first cast.
- [#981](#981) The Arcane Blast bar joins the bar text Relative to Frame and Color Indicator target lists, and adds an Arcane Blast Stacks source for audio cues.

---

# 1.60.1.18-release (2026-11-10)
## Druid

- [#970](#970) Improve bar and bar text update performance.

## Priest

- [#968](#968) Add Inner Fire tracking, with a Color Indicator and the `$innerFireStacks`, `$innerFireStacksMax`, `$innerFireTime`, and `#innerFire` bar text variables. The indicator has no targets by default.

## Rogue

- [#969](#969) Add a Death Mark threshold line on the Energy bar and the `#deathMark` bar text variable.
- [#969](#969) Add Slice and Dice tracking, with active and ending Color Indicators and the `$sliceAndDiceTime` bar text variable. By default, the Energy bar fill turns red while Slice and Dice is down in combat and orange while it is ending.
- [#969](#969) Remove the Venom threshold line.
- [#969](#969) Fix the Mutilate threshold line and the `#mutilate` bar text variable.
- [#970](#970) Improve bar and bar text update performance.

---

# 1.60.1.17-release (2026-11-05)
## General
### Color Indicators

- [#831](#831) Built-in gradient colors can be removed, and added back or copied with a new Add Built-in Gradient Color button.
- [#831](#831) Where two gradient colors target the same bar element, the higher one in the list is used.

### Other Bars

- [#932](#932) Add a new Five Second Rule bar for every class that uses mana, tracking the pause in mana regeneration after you spend mana, with `$fiveSecondRuleDuration` and `$fiveSecondRuleDurationRemaining` bar text, set to Never Show by default.
- [#932](#932) The Five Second Rule bar sits along the inside bottom of the Mana bar, drains over the full five seconds, and can wait to appear until a set number of GCDs or seconds remain.

---

# 1.60.1.16-release (2026-11-03)
## Druid

- [#921](#921) Add a Lacerate threshold line on the Rage bar and the `#lacerate` bar text variable.

---

# 1.60.1.15-release (2026-10-29)
## General
### Thresholds

- [#279](#279) Remove the threshold lines' separate cooldown refresh.

## Druid

- [#279](#279) Remove the Frenzied Regeneration threshold line.

## Rogue

- [#279](#279) The Feint, Slice and Dice, and Venom threshold lines follow their range.

---

# 1.60.1.14-release (2026-10-25)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 1.60.1.13-release (2026-10-23)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 1.60.1.12-release (2026-10-23)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 1.60.1.11-release (2026-10-21)
## General
### Other Bars

- Ranged Swing switches to new Held by Movement fill and background colors while moving delays your next shot, and stays up empty past the end of its swing until the shot can fire. On by default for Hunter, Mage, Priest, Rogue, Warlock, and Warrior.
- Ranged Swing's Show Bar When list adds Held by Movement, on by default.
- Add `$rangedSwingReadyRemaining` bar text, the time until your next ranged attack can fire, including the time standing still it needs after you move.
- Fix Open Global Other Bars Settings in the Blizzard Swing Timers section of Off Hand Swing and Ranged Swing opening the Main Hand Swing tab.

---

# 1.60.1.10-release (2026-10-15)
## General

- Fix changing gear not updating the primary resource bar's maximum.

### Audio Cues

- [#849](#849) Add an Audio Cues tab for Hunter, Mage, Paladin, Priest, Shaman, Warlock, and Warrior.
- [#850](#850) Thresholds tab audio cues play while their bar is hidden.

---

# 1.60.1.9-release (2026-10-14)
## General
### Color Indicators

- [#773](#773) Add a Color Indicators tab for Hunter, Mage, Paladin, Priest, Shaman, and Warlock.

---

# 1.60.1.8-release (2026-10-12)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 1.60.1.7-release (2026-10-10)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 1.60.1.6-release (2026-10-09)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 1.60.1.5-release (2026-10-07)
## General
### Cast Bars

- Add channel tick markers for bandages, Cannibalize, and Rapid Regeneration.

## Druid

- Add channel tick markers for Tranquility and Hurricane.

## Hunter

- Add channel tick markers for Volley and Mend Pet.

## Mage

- Add channel tick markers for Arcane Missiles, Blizzard, and Evocation.

## Priest

- Add channel tick markers for Mind Flay, Penance, and Starshards.

## Warlock

- Add channel tick markers for Drain Life, Drain Mana, Drain Soul, Health Funnel, Hellfire, Rain of Fire, and Wrack.
- Add Pet Cast Bar channel tick markers for Consume Shadows.

---

# 1.60.1.4-release (2026-10-06)
## General
### Core Changes

- See [Core Changes](tab:core).

### Pet Bars

- [#551](#551) Available to Hunters and Warlocks.

### Other Bars

- [#844](#844) Add new Main Hand Swing, Off Hand Swing, and Ranged Swing bars, tracking your auto attack swing timers, with `$mainHandSwingDuration`, `$mainHandSwingDurationRemaining`, `$offHandSwingDuration`, `$offHandSwingDurationRemaining`, `$rangedSwingDuration`, `$rangedSwingDurationRemaining`, `$mainHandLocale`, `$offHandLocale`, and `$rangedLocale` bar text. Set to Never Show by default; enable them under Bar Visibility, where their Show Bar When lists add the General, Mounted, Social, Location, and PvP conditions, and Main Hand Swing's Always Hide Bar When list adds Item not equipped.
- Each bar grows to full by your next swing, or drains, scaled to your weapon speed. Main Hand Swing always shows; Off Hand Swing and Ranged Swing need a weapon in their slot.
- All three join the bar text Relative to Frame list, have no threshold lines or Smooth Bar Animation, and share one option to hide Blizzard's swing timers.

## Druid

- Add a Primal Bite threshold line on the Rage bar and the `#primalBite` bar text variable.
- Remove the Tiger's Fury threshold line and the `#tigersFury` bar text variable.
- Add a Maximum Bar Value override to the Rage and Energy bars.
- Fix the `$rage` overcap text color using ten times the maximum Rage.

## Warrior

- Spearing Strike's threshold line only draws in Battle Stance.
- Fix the Rage bar's fill, threshold lines, and `$rageMax` using ten times the maximum Rage.

---

# 1.60.1.3-release (2026-10-03)
## General

- Fix the Flavor check from preventing the addon from loading.

---

# 1.60.1.2-release (2026-09-29)
## General

- Fix a Lua error when enabling Edit Mode for a bar group.

---

# 1.60.1.1-release (2026-09-28)
## General

- Combo Points for Rogues and Druids are enabled.

## Druid

- Add Color Indicators tab with Stealth, plus Rage and Energy Overcap gradients that each target only their own bar and have their own overcap threshold.
- Add Font & Text colors for Rage and Energy text, set separately, when an enabled threshold ability on that bar is usable and when that resource is at or above its overcap threshold.
- Add Audio Cues tab with Combo Point threshold cues at 3 and 5, both off.
- Finisher threshold lines use the below color, not unusable, when you have Combo Points but not enough Energy.

## Rogue

- Add Threshold lines on the Energy bar for Sinister Strike, Backstab, Mutilate, Hemorrhage, Ghostly Strike, Ambush, Garrote, Cheap Shot, Gouge, Riposte, Eviscerate, Rupture, Slice and Dice, Kidney Shot, Expose Armor, Venom, Feint, Sap, Kick, Distract, Blind, and Blade Flurry, on the Thresholds tab. Ambush, Garrote, Cheap Shot, and Sap only draw while stealthed.
- Add Bar text variables `$inStealth`, `#ambush`, `#backstab`, `#cheapShot`, `#eviscerate`, `#exposeArmor`, `#garrote`, `#gouge`, `#hemorrhage`, `#kick`, `#kidneyShot`, `#mutilate`, `#rupture`, `#sinisterStrike`, and `#sliceAndDice`.
- Add Color Indicators tab with Stealth and an Overcap gradient.
- Add Font & Text colors for Energy text when an enabled threshold ability is usable and when Energy is at or above the overcap threshold.
- Add Audio Cues tab with Combo Point threshold cues at 3 and 5, both off.
- Maximum Energy Value, Relative Energy Offset Amount, and Overcap Above Energy sliders reach 110 Energy.

## Warrior

- Add Threshold lines on the Rage bar for Heroic Strike, Cleave, Rend, Thunder Clap, Overpower, Execute, Sunder Armor, Revenge, Slam, Whirlwind, Shield Slam, Mortal Strike, Bloodthirst, Death Wish, Sweeping Strikes, Spearing Strike, Hamstring, Shield Bash, Intercept, Pummel, Battle Shout, Demoralizing Shout, Intimidating Shout, Disarm, Concussion Blow, Piercing Howl, Shield Block, Challenging Shout, and Mocking Blow, on the Thresholds tab. A stance-restricted ability only draws its line in a stance that can cast it.
- Add Bar text icon variables for every one of those abilities.
- Add Color Indicators tab with an Overcap gradient.
- Add Font & Text colors for Rage text when an enabled threshold ability is usable and when Rage is at or above the overcap threshold.

---

# 1.60.1.0-release (2026-09-20)
## General

- First build for World of Warcraft: Forever. All nine classes are supported with a primary resource bar (Mana, Rage, or Energy), Combo Points for Rogues, plus the health bar, cast bars, Global Cooldown bar, and mirror timer bars shared with the main game's version of the addon.
- Threshold lines for abilities for those that can use them will be added Soon (tm).
- **NOTE:** Combo Points for Rogues and Druids are disabled due to a bug where they return as `secret`. Blizzard is aware of this and I'll update the addon when they fix it.
- Bar text stat variables follow this game's character sheet: `$spirit`, `$ap`, `$rap`, `$crit`, `$rangedCrit`, `$spellCrit`, `$hit`, `$rangedHit`, `$spellHit`, `$haste`, `$meleeHaste`, `$rangedHaste`, `$expertise`, `$armorPen`, `$spellPower` (plus `$spellPowerHoly` through `$spellPowerArcane`), `$healingPower`, `$spellPenetration`, `$mp5`, `$mp5NotCasting`, `$defense`, `$dodge`, `$parry`, `$block`, `$blockValue`, `$armor`, and `$resistArcane` through `$resistShadow`. Mastery, Versatility, and rating variables do not exist here.

## Druid

- Mana, Rage, Energy, and Combo Points are four separate bars, each with its own dimensions, colors, textures, and visibility settings. By default the Always Hide Bar When form conditions hide Mana in Cat, Bear, and Moonkin Form, Rage outside Bear Form, and Energy and Combo Points outside Cat Form.
- Threshold lines for Maul, Demoralizing Roar, Bash, Challenging Roar, Frenzied Regeneration, Swipe, and Feral Charge on the Rage bar, and for Claw, Shred, Rake, Ravage, Pounce, Rip, Ferocious Bite, Cower, and Tiger's Fury on the Energy bar.
- Bar text variables `$mana`, `$manaMax`, `$manaPercent`, `$casting`, `$rage`, `$rageMax`, `$energy`, `$energyMax`, `$comboPoints`, `$comboPointsMax`, and `$inStealth`; Rage Bar, Energy Bar, and each Combo Point are bar text Relative to Frame targets. Mana, Rage, and Energy text each have their own color on the Font & Text tab.
- Bar Visibility and Combo Points start with Use Global off.

---
]====]
