local _, TRB = ...

-- World of Warcraft: Forever changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for World of Warcraft: Forever is in early development. Please report any issues via Discord or GitHub. Thanks!*

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

- Add a Maximum Bar Value override to the Rage and Energy bars.
- Fix the `$rage` overcap text color using ten times the maximum Rage.

## Warrior

- Fix the Rage bar's fill, threshold lines, and `$rageMax` using ten times the maximum Rage.

---

# 1.60.1.4-release (2026-10-03)
## Druid

- Add a Primal Bite threshold line on the Rage bar and the `#primalBite` bar text variable.
- Remove the Tiger's Fury threshold line and the `#tigersFury` bar text variable.

## Warrior

- Spearing Strike's threshold line only draws in Battle Stance.

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
