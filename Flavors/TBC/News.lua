local _, TRB = ...

-- The Burning Crusade Classic changelog shown by the News window (Core\Functions\News.lua renders it).
-- Markdown; newest release first.
TRB.Flavor.newsContent = [====[

*Twintop's Resource Bar for The Burning Crusade Classic is in early development. Please report any issues via Discord or GitHub. Thanks!*

---

# 2.5.6.2-release (2026-11-12)
## General
### Bar Visibility

- [#986](#986) Fix a mana spec's Primary Resource Value bar visibility condition being met at far less mana than the value set.
- [#986](#986) A mana spec's Primary Resource Value condition now goes up to 25,000.

### Color Indicators

- [#991](#991) A custom Color Indicator or Buff Alert by spell ID can follow your debuff on your target, such as a damage over time effect.

### Custom Bars

- [#991](#991) A custom bar can track the duration or stacks of a buff on you, or of your debuff on your target, by its spell ID, counting any rank of the spell.

## Mage

- [#981](#981) Add a new Arcane Blast bar, tracking your Arcane Blast stacks, with the `$arcaneBlastStacks`, `$arcaneBlastStacksMax`, `$arcaneBlastTime`, and `#arcaneBlast` bar text variables. It shows once you learn Arcane Blast.
- [#981](#981) Each Arcane Blast cast fills one of its three nodes and restarts its 8 second timer.
- [#981](#981) The Arcane Blast bar joins the bar text Relative to Frame and Color Indicator target lists, and adds an Arcane Blast Stacks source for audio cues.

---

# 2.5.6.1-release (2026-11-10)
## Druid

- [#970](#970) Improve bar and bar text update performance.

## Priest

- [#968](#968) Add Inner Fire tracking, with a Color Indicator and the `$innerFireStacks`, `$innerFireStacksMax`, `$innerFireTime`, and `#innerFire` bar text variables. The indicator has no targets by default.

## Rogue

- [#969](#969) Add Slice and Dice tracking, with active and ending Color Indicators and the `$sliceAndDiceTime` bar text variable. By default, the Energy bar fill turns red while Slice and Dice is down in combat and orange while it is ending.
- [#970](#970) Improve bar and bar text update performance.

---

# 2.5.6.0-release (2026-11-05)
## General

- [#930](#930)First build for The Burning Crusade Classic, with every class's primary resource bar plus the health, cast, Global Cooldown, mirror timer, and pet bars.
- [#930](#930) Hunters, Mages, Paladins, Priests, Shamans, and Warlocks use a Mana bar.
- [#930](#930) Bar text stat variables follow this game's stats.

### Audio Cues

- [#930](#930) Buff Alerts follow one of your buffs, at any rank, by its spell ID.

### Color Indicators

- [#930](#930) Custom Color Indicators can follow one of your buffs, at any rank, by its spell ID.

### Other Bars

- [#930](#930) Add new Main Hand Swing, Off Hand Swing, and Ranged Swing bars, tracking your auto attack swing timers, with `$mainHandSwingDuration`, `$mainHandSwingDurationRemaining`, `$offHandSwingDuration`, `$offHandSwingDurationRemaining`, `$rangedSwingDuration`, `$rangedSwingDurationRemaining`, `$rangedSwingReadyRemaining`, `$mainHandLocale`, `$offHandLocale`, and `$rangedLocale` bar text, set to Never Show by default.
- [#930](#930) Each bar fills by your next swing: Heroic Strike, Cleave, Maul, Raptor Strike, and Slam restart Main Hand Swing, casting pauses both melee bars, a parry shortens your next main hand swing, and Ranged Swing follows Auto Shot, wands, and Shoot and Throw.
- [#932](#932) Add a new Five Second Rule bar for every class that uses mana, tracking the pause in mana regeneration after you spend mana, with `$fiveSecondRuleDuration` and `$fiveSecondRuleDurationRemaining` bar text, set to Never Show by default.
- [#932](#932) The Five Second Rule bar sits along the inside bottom of the Mana bar, drains over the full five seconds, and can wait to appear until a set number of GCDs or seconds remain.

## Druid

- [#930](#930) Mana, Rage, Energy, and Combo Points are four separate bars, and the shapeshift form decides which show by default.
- [#930](#930) Threshold lines for Maul, Lacerate, Mangle (Bear), Demoralizing Roar, Bash, Challenging Roar, Swipe, and Feral Charge on the Rage bar, and for Claw, Mangle (Cat), Shred, Rake, Ravage, Pounce, Rip, Ferocious Bite, Maim, Cower, and Tiger's Fury on the Energy bar.

## Rogue

- [#930](#930) Energy and Combo Points bars, with threshold lines for every Energy ability.

## Shaman

- [#930](#930) Totems bar with one node per element, shown just above the main bar, and a Hide Blizzard's totem frame option.

## Warrior

- [#930](#930) Rage bar with threshold lines for every Rage ability, each shown only in the stances that can use it.

---
]====]
