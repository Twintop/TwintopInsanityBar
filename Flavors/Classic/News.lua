local _, TRB = ...

-- World of Warcraft Classic changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for World of Warcraft Classic is in early development. Please report any issues via Discord or GitHub. Thanks!*

---

# 1.15.9.0-alpha (2026-10-28)
## General

- First build for World of Warcraft Classic. Every class gets its primary resource bar plus the health, cast, Global Cooldown, mirror timer, and pet bars.
- Hunters, Mages, Paladins, Priests, Shamans, and Warlocks use a Mana bar.
- Bar text stat variables follow this game's stats.

## Druid

- Mana, Rage, Energy, and Combo Points are four separate bars, and the shapeshift form decides which show by default.
- Threshold lines for Maul, Demoralizing Roar, Bash, Challenging Roar, Frenzied Regeneration, Swipe, and Feral Charge on the Rage bar, and for Claw, Shred, Rake, Ravage, Pounce, Rip, Ferocious Bite, Cower, and Tiger's Fury on the Energy bar.

## Rogue

- Energy and Combo Points bars, with threshold lines for every Energy ability.

## Warrior

- Rage bar with threshold lines for every Rage ability, each shown only in the stances that can use it.

---
]====]
