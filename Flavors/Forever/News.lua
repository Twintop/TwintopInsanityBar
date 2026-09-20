local _, TRB = ...

-- World of Warcraft: Forever changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for World of Warcraft: Forever is in early development. Class support starts as a resource bar (plus health, cast, and cooldown bars) for every class; ability tracking, thresholds, and bar text variables are added class by class as the beta reveals what the game exposes.*

---

# 1.60.1.0-alpha01 (2026-09-20)
## General

- First build for World of Warcraft: Forever. All nine classes are supported with a primary resource bar (Mana, Rage, or Energy), Combo Points for Rogues, plus the health bar, cast bars, Global Cooldown bar, and mirror timer bars shared with the main game's version of the addon.
- Bar text stat variables follow this game's character sheet: `$spirit`, `$ap`, `$rap`, `$crit`, `$rangedCrit`, `$spellCrit`, `$hit`, `$rangedHit`, `$spellHit`, `$haste`, `$meleeHaste`, `$rangedHaste`, `$expertise`, `$armorPen`, `$spellPower` (plus `$spellPowerHoly` through `$spellPowerArcane`), `$healingPower`, `$spellPenetration`, `$mp5`, `$mp5NotCasting`, `$defense`, `$dodge`, `$parry`, `$block`, `$blockValue`, `$armor`, and `$resistArcane` through `$resistShadow`. Mastery, Versatility, and rating variables do not exist here.

## Druid

- Mana, Rage, Energy, and Combo Points are four separate bars, each with its own dimensions, colors, textures, and visibility settings. By default the Always Hide Bar When form conditions hide Mana in Cat, Bear, and Moonkin Form, Rage outside Bear Form, and Energy and Combo Points outside Cat Form.
- Threshold lines for Maul, Demoralizing Roar, Bash, Challenging Roar, Frenzied Regeneration, Swipe, and Feral Charge on the Rage bar, and for Claw, Shred, Rake, Ravage, Pounce, Rip, Ferocious Bite, Cower, and Tiger's Fury on the Energy bar.
- Bar text variables `$mana`, `$manaMax`, `$manaPercent`, `$casting`, `$rage`, `$rageMax`, `$energy`, `$energyMax`, `$comboPoints`, `$comboPointsMax`, and `$inStealth`; Rage Bar, Energy Bar, and each Combo Point are bar text Relative to Frame targets. Mana, Rage, and Energy text each have their own color on the Font & Text tab.
- Bar Visibility and Combo Points start with Use Global off.

---
]====]
