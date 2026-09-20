local _, TRB = ...

-- World of Warcraft: Forever changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for World of Warcraft: Forever is in early development. Class support starts as a resource bar (plus health, cast, and cooldown bars) for every class; ability tracking, thresholds, and bar text variables are added class by class as the beta reveals what the game exposes.*

---

# 1.0.0.0-alpha (2026-09-16)
## General

- First build for World of Warcraft: Forever. All nine classes are supported with a primary resource bar (Mana, Rage, or Energy), Combo Points for Rogues, plus the health bar, cast bars, Global Cooldown bar, and mirror timer bars shared with the main game's version of the addon. Druids start on Mana in every form.
- Bar text stat variables follow this game's character sheet: `$spirit`, `$ap`, `$rap`, `$crit`, `$rangedCrit`, `$spellCrit`, `$hit`, `$rangedHit`, `$spellHit`, `$haste`, `$meleeHaste`, `$rangedHaste`, `$expertise`, `$armorPen`, `$spellPower` (plus `$spellPowerHoly` through `$spellPowerArcane`), `$healingPower`, `$spellPenetration`, `$mp5`, `$mp5NotCasting`, `$defense`, `$dodge`, `$parry`, `$block`, `$blockValue`, `$armor`, and `$resistArcane` through `$resistShadow`. Mastery, Versatility, and rating variables do not exist here.

---
]====]
