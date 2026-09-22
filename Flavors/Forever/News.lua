local _, TRB = ...

-- World of Warcraft: Forever changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for World of Warcraft: Forever is in early development. Please report any issues via Discord or GitHub. Thanks!*

---

# 1.60.1.1-release (2026-09-21)
## Warrior

- Threshold lines on the Rage bar for Heroic Strike, Cleave, Rend, Thunder Clap, Overpower, Execute, Sunder Armor, Revenge, Slam, Whirlwind, Shield Slam, Mortal Strike, Bloodthirst, Death Wish, Sweeping Strikes, Spearing Strike, Hamstring, Shield Bash, Intercept, Pummel, Battle Shout, Demoralizing Shout, Intimidating Shout, Disarm, Concussion Blow, Piercing Howl, Shield Block, Challenging Shout, and Mocking Blow, on the Thresholds tab. A stance-restricted ability only draws its line in a stance that can cast it.
- Bar text icon variables for every one of those abilities.
- `/trb stance` reports the stance the addon reads.

## Rogue

- Threshold lines on the Energy bar for Sinister Strike, Backstab, Mutilate, Hemorrhage, Ghostly Strike, Ambush, Garrote, Cheap Shot, Gouge, Riposte, Eviscerate, Rupture, Slice and Dice, Kidney Shot, Expose Armor, Venom, Feint, Sap, Kick, Distract, Blind, and Blade Flurry, on the Thresholds tab. Ambush, Garrote, Cheap Shot, and Sap only draw while stealthed.
- Bar text variables `$inStealth`, `#ambush`, `#backstab`, `#cheapShot`, `#eviscerate`, `#exposeArmor`, `#garrote`, `#gouge`, `#hemorrhage`, `#kick`, `#kidneyShot`, `#mutilate`, `#rupture`, `#sinisterStrike`, and `#sliceAndDice`.

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
