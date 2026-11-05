local _, TRB = ...

-- The Burning Crusade Classic changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for The Burning Crusade Classic is in early development. Please report any issues via Discord or GitHub. Thanks!*

---

# 2.5.6.0-release (2026-11-05)
## General

- First build for The Burning Crusade Classic, with every class's primary resource bar plus the health, cast, Global Cooldown, mirror timer, and pet bars.
- Hunters, Mages, Paladins, Priests, Shamans, and Warlocks use a Mana bar.
- Bar text stat variables follow this game's stats.

### Audio Cues

- Buff Alerts follow one of your buffs, at any rank, by its spell ID.

### Color Indicators

- Custom Color Indicators can follow one of your buffs, at any rank, by its spell ID.

### Other Bars

- Add new Main Hand Swing, Off Hand Swing, and Ranged Swing bars, tracking your auto attack swing timers, with `$mainHandSwingDuration`, `$mainHandSwingDurationRemaining`, `$offHandSwingDuration`, `$offHandSwingDurationRemaining`, `$rangedSwingDuration`, `$rangedSwingDurationRemaining`, `$rangedSwingReadyRemaining`, `$mainHandLocale`, `$offHandLocale`, and `$rangedLocale` bar text, set to Never Show by default.
- Each bar fills by your next swing: Heroic Strike, Cleave, Maul, Raptor Strike, and Slam restart Main Hand Swing, casting pauses both melee bars, a parry shortens your next main hand swing, and Ranged Swing follows Auto Shot, wands, and Shoot and Throw.
- [#932](#932) Add a new Five Second Rule bar for every class that uses mana, tracking the pause in mana regeneration after you spend mana, with `$fiveSecondRuleDuration` and `$fiveSecondRuleDurationRemaining` bar text, set to Never Show by default.
- [#932](#932) It sits along the inside bottom of the Mana bar, drains over the full five seconds, and can wait to appear until a set number of GCDs or seconds remain.

## Druid

- Mana, Rage, Energy, and Combo Points are four separate bars, and the shapeshift form decides which show by default.
- Threshold lines for Maul, Lacerate, Mangle (Bear), Demoralizing Roar, Bash, Challenging Roar, Swipe, and Feral Charge on the Rage bar, and for Claw, Mangle (Cat), Shred, Rake, Ravage, Pounce, Rip, Ferocious Bite, Maim, Cower, and Tiger's Fury on the Energy bar.

## Rogue

- Energy and Combo Points bars, with threshold lines for every Energy ability.

## Shaman

- Totems bar with one node per element, shown just above the main bar, and a Hide Blizzard's totem frame option.

## Warrior

- Rage bar with threshold lines for every Rage ability, each shown only in the stances that can use it.

---
]====]
