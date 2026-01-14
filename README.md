# Twintop's Resource Bar

A multi-class resource bar, based on my (Twintop's) previous Shadow Priest Insanity Bar WeakAura set from Legion.

[![GitHub release](https://img.shields.io/github/release/Twintop/TwintopInsanityBar.svg?maxAge=3600)](https://github.com/Twintop/TwintopInsanityBar/releases)
[![MIT License](https://img.shields.io/github/license/Twintop/TwintopInsanityBar)](https://github.com/Twintop/TwintopInsanityBar/blob/shadowlands/LICENSE)

[![Issues](https://img.shields.io/github/issues-raw/Twintop/TwintopInsanityBar)](https://github.com/Twintop/TwintopInsanityBar/issues)
[![Issues](https://img.shields.io/github/issues-closed-raw/Twintop/TwintopInsanityBar?color=00CC00)](https://github.com/Twintop/TwintopInsanityBar/issues?q=is%3Aissue+is%3Aclosed)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Core?color=000000&label=Core)](https://github.com/Twintop/TwintopInsanityBar/labels/Core)

## Issues by Class

[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Death%20Knight?color=C41E3A&label=Death%20Knight)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Death%20Knight)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Demon%20Hunter?color=A330C9&label=Demon%20Hunter)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Demon%20Hunter)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Druid?color=FF7C0A&label=Druid)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Druid)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Evoker?color=33937F&label=Evoker)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Evoker)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Hunter?color=AAD372&label=Hunter)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Hunter)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Mage?color=3FC7EB&label=Mage)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Mage)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Monk?color=00FF98&label=Monk)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Monk)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Paladin?color=F48CBA&label=Paladin)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Paladin)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Priest?color=FFFFFF&label=Priest)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Priest)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Rogue?color=FFF468&label=Rogue)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Rogue)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Shaman?color=0070DD&label=Shaman)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Shaman)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Warlock?color=8788EE&label=Warlock)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Warlock)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Live-Warrior?color=C69B6D&label=Warrior)](https://github.com/Twintop/TwintopInsanityBar/labels/Live-Warrior)

---

## Overview

Twintop's Resource Bar (TRB) is a fully customizable resource bar addon that supports all 13 classes and 40 specialization in World of Warcraft. Whether you're tracking Rage, Mana, Energy, Insanity, or any other resource, TRB provides a unified interface with threshold markers, secondary resource tracking, health monitoring, and major cooldown timers.

The addon is designed to give you the information you need at a glance, with visual and audio cues to help you make split-second decisions during combat.

---

## Customization

TRB is built with customization at its core. Nearly every aspect of the addon can be tailored to fit your UI and playstyle.

### Bar Visibility

Every bar can be shown or hidden independently:

- Show bars always, only in combat, or never
- Hide individual bars (health, mana, secondary resources) per spec

### Size and Position

- Adjustable width and height for primary and secondary resource bars
- Pixel-precise positioning with horizontal and vertical offsets
- Drag-and-drop repositioning

### Colors

- Separate color settings for bar fill, border, and background
- Per-threshold colors: under resource threshold, over resource threshold, unusable, out of range
- State-based bar colors that change based on active buffs or procs
- Individual node coloring for secondary resources

### Textures and Fonts

- Full LibSharedMedia integration for custom textures and fonts
- Independent texture settings for primary bar, secondary nodes, and custom bars (Stagger, Mana, Defensives)
- Configurable font face, size, and color for all text elements

### Audio Notifications

- Customizable sound cues triggered by resource thresholds or proc events
- LibSharedMedia support for custom sounds
- Configurable audio output channel

### Bar Text

TRB features a powerful bar text system that lets you display exactly the information you want, where you want it. Create multiple text entries with independent positioning, fonts, and colors.

Use variables like `$resource`, `$comboPoints`, `$haste`, `$gcd`, and `$inCombatTime` to display live data, or `#casting` to show spell icons. Bar text also supports conditional logic with Boolean operators for dynamic displays.

For complete documentation on available variables and advanced formatting, check out the [Bar Text Customization Wiki](https://github.com/Twintop/TwintopInsanityBar/wiki/Bar-Text-Customization).

### Import and Export

Share your configuration with others or back up your settings:

- Export individual sections (colors, thresholds, fonts, audio) or entire spec configurations
- Import configurations from other players

---

## Features

### Primary Resource Bar

Every spec gets a primary resource bar that tracks your main resource (Mana, Rage, Energy, Focus, Runic Power, Fury, Insanity, Astral Power, or Maelstrom). The bar includes:

- **Threshold lines** showing the cost of your abilities, color-coded by availability
- **Predictive resource display** for some specs, showing expected resource gain from your current cast
- **Maximum display customization** allows the bar to fill to a lower value than your maximum resource; useful for specs like Assassination Rogue with threshold lines and very high maximum resource pools
- **Overcapping resource alert** change the bar border and resource text color when almost full on resources for specs with fast auto-regennerating resources (i.e. Rogues) and those with builder/spender playstyles (i.e. Shadow)

### Secondary Resource Nodes

Many specs have a secondary resource displayed as individual nodes above or below the primary bar:

- **Arcane Charges** (Arcane Mage)
- **Chi** (Windwalker Monk)
- **Combo Points** (Feral Druid, Assassination/Outlaw/Subtlety Rogue)
- **Essence** (Devastation/Preservation/Augmentation Evoker) - displayed with timer-based regeneration progress
- **Holy Power** (Holy/Protection/Retribution Paladin)
- **Maelstrom Weapon** (Enhancement Shaman) - 5 or 10 stacks
- **Runes** (Blood/Frost/Unholy Death Knight) - 6 individual runes with cooldown timers
- **Soul Fragments** (Vengeance/Devourer Demon Hunter)
- **Soul Shards** (Affliction/Demonology/Destruction Warlock) - Destruction displays partial fragments

### Health Bar

A dedicated health bar is available for all specs, providing an at-a-glance view of your current health with customizable color thresholds.

### Secondary Mana Bar

Some DPS specs that may need to off-heal in a pinch have a secondary mana bar available (disabled by default):

- Balance Druid
- Elemental Shaman
- Shadow Priest

### Stagger Bar (Brewmaster Monk)

Brewmaster Monks get a dedicated Stagger bar that displays current stagger damage as a percentage of maximum health. The bar includes configurable thresholds for Medium and Heavy stagger levels, with color transitions as stagger severity increases. Stagger levels and colors are set to Blizzard's defaults but can be freely customized to suit your preferences and needs.

### Defensives Bar (Protection Warrior)

Protection Warriors have a specialized Defensives bar that tracks the remaining duration of key defensive abilities:

- **Ignore Pain** duration remaining
- **Shield Block** duration remaining and available charges

### Major Cooldown Tracking

Many specs can track important buff status and timers via color changes and directly in bar text variables:

| Spec | Tracked Cooldowns |
| ------ | ------------------- |
| Shadow Priest | Voidform, Entropic Rift (including extensions remaining) |
| Balance Druid | Eclipse/Incarnation |
| Feral Druid | Berserk/Incarnation, including incoming combo point generation timing |
| Guardian Druid | Berserk/Incarnation |
| Restoration Druid | Efflorescence, Incarnation |
| Havoc/Vengeance/Devourer Demon Hunter | (Void) Metamorphosis |
| Beast Mastery Hunter | Beast Cleave, Bestial Wrath |
| Marksmanship Hunter | Trueshot |
| Elemental/Enhancement/Restoration Shaman | Ascendance |
| Augmentation Evoker | Ebon Might |

---

## Support

Found an issue? Report it on [GitHub](https://github.com/Twintop/TwintopInsanityBar/issues/) or join the discussion on [Discord](https://discord.gg/eThqxM78xm).
