# Twintop's Resource Bar

A multi-class resource bar, based on my (Twintop's) previous Shadow Priest Insanity Bar WeakAura set from Legion.

[![GitHub release](https://img.shields.io/github/release/Twintop/TwintopInsanityBar.svg?maxAge=3600)](https://github.com/Twintop/TwintopInsanityBar/releases)
[![MIT License](https://img.shields.io/github/license/Twintop/TwintopInsanityBar)](https://github.com/Twintop/TwintopInsanityBar/blob/shadowlands/LICENSE)

[![Issues](https://img.shields.io/github/issues-raw/Twintop/TwintopInsanityBar)](https://github.com/Twintop/TwintopInsanityBar/issues)
[![Issues](https://img.shields.io/github/issues-closed-raw/Twintop/TwintopInsanityBar?color=00CC00)](https://github.com/Twintop/TwintopInsanityBar/issues?q=is%3Aissue+is%3Aclosed)
[![Issues](https://img.shields.io/github/issues/Twintop/TwintopInsanityBar/Core?color=000000&label=Core)](https://github.com/Twintop/TwintopInsanityBar/labels/Core)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X71U2S88)

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
- Anchor bars to other bars for automatic relative positioning, or position each bar independently
- Position bars via Edit Mode or classic X/Y offset settings

### Colors

- Separate color settings for bar fill, border, and background
- Per-threshold colors: under resource threshold, over resource threshold, unusable, out of range
- State-based bar colors that change based on active buffs or procs, each individually toggleable
- Individual node coloring for secondary resources
- Global color settings that apply across all specializations (e.g., Health Bar colors)

### Textures and Fonts

- Full LibSharedMedia integration for custom textures and fonts
- Independent texture settings for primary bar, secondary nodes, and custom bars (Stagger, Mana, Defensives)
- Configurable font face, size, and color for all text elements

### Audio Notifications

- Customizable sound cues triggered by resource thresholds or proc events
- Secondary resource audio cues (Combo Points, Holy Power, Soul Shards, Chi, Arcane Charges, Maelstrom Weapon) that fire independently of bar visibility, triggering only during combat
- LibSharedMedia support for custom sounds
- Configurable audio output channel

### Bar Text

TRB features a powerful bar text system that lets you display exactly the information you want, where you want it. Create multiple text entries with independent positioning, fonts, and colors.

Use variables like `$resource`, `$comboPoints`, `$haste`, `$gcd`, and `$inCombatTime` to display live data, or `#casting` to show spell icons. Bar text also supports conditional logic with Boolean operators for dynamic displays.

The bar text editor includes a searchable variable browser with descriptions and icons, allowing you to find and insert variables directly at the cursor position. Full undo/redo support is available via standard Ctrl+Z and Ctrl+Shift+Z (or Ctrl+Y) keyboard shortcuts.

For complete documentation on available variables and advanced formatting, check out the [Bar Text Customization Wiki](https://github.com/Twintop/TwintopInsanityBar/wiki/Bar-Text-Customization).

### Import and Export

Share your configuration with others or back up your settings:

- Export individual sections (colors, thresholds, fonts, audio) or entire spec configurations
- Import configurations from other players
- Compressed export strings using Blizzard's `C_EncodingUtil` with Deflate compression for smaller sizes (legacy import strings remain compatible)

### Options Window

- Dedicated movable options window accessible via `/trb` or the minimap button
- Access and modify any class specialization's settings regardless of your current class
- Lazy-loaded settings panels to reduce memory usage
- Options organized across multiple focused tabs for easier navigation

### Global Settings

- Apply common settings across all classes and specializations from the "Global Options" screen
- Changes are immediately reflected across all specializations
- Includes Health Bar colors, and more
- Per-bar smooth animation settings instead of a single global toggle
- Optional abbreviated number formatting (e.g., 10.0K, 1.5M) for large numbers across all bars

---

## Features

### Edit Mode Integration

Full integration with WoW's native Edit Mode system, allowing you to position and manage the resource bar alongside other UI elements:

- **Per-Layout Settings** - Edit Mode configuration is saved separately for each HUD layout, so you can have different positions and settings for each
- **Free Position Mode** - Place the bar anywhere on screen with drag-and-drop positioning while in Edit Mode
- **Per-Bar Edit Mode Control** - Any bar anchored to the screen can be independently controlled by Edit Mode, including anchoring to the Cooldown Manager
- **Bar-to-Bar Anchoring** - Anchor bars to other bars for automatic relative positioning instead of using manual X/Y offsets from the Primary Resource Bar
- **Anchor to Cooldown Manager** - Optionally anchor any screen-anchored bar above or below Blizzard's Cooldown Manager Essential Abilities frame
- **Match Cooldown Manager Width** - When anchored to the Cooldown Manager, optionally match its width for a cohesive look
- **Vertical Offset** - Fine-tune vertical spacing when anchored to the Cooldown Manager
- **Reset Edit Mode Data** - Clear all stored Edit Mode layout data from the "Reset Defaults" tab in Global Options

### Primary Resource Bar

Every spec gets a primary resource bar that tracks your main resource (Mana, Rage, Energy, Focus, Runic Power, Fury, Insanity, Astral Power, or Maelstrom). The bar includes:

- **Threshold lines** showing the cost of your abilities, color-coded by availability
- **Predictive cast resource overlay** for some specs, showing expected resource changes during your current cast as an overlay on the bar or via bar text
- **Maximum display customization** allows the bar to fill to a lower value than your maximum resource; useful for specs like Assassination Rogue with threshold lines and very high maximum resource pools
- **Overcapping resource alert** change the bar border and resource text color when almost full on resources for specs with fast auto-regennerating resources (i.e. Rogues) and those with builder/spender playstyles (i.e. Shadow)

### Secondary Resource Nodes

Many specs have a secondary resource displayed as individual nodes above or below the primary bar:

- **Arcane Charges** (Arcane Mage)
- **Chi** (Windwalker Monk)
- **Combo Points** (Feral Druid, Assassination/Outlaw/Subtlety Rogue)
- **Essence** (Devastation/Preservation/Augmentation Evoker) - displayed with timer-based regeneration progress
- **Holy Power** (Holy/Protection/Retribution Paladin)
- **Icicles** (Frost Mage) - up to 5 stacks
- **Holy Words** (Holy Priest) - individually toggleable cooldown nodes for Holy Word: Serenity, Sanctify, and Chastise with real-time cooldown progress and CDR tracking
- **Maelstrom Weapon** (Enhancement Shaman) - 5 or 10 stacks
- **Power Words** (Discipline Priest) - cooldown nodes for Power Word: Radiance with real-time cooldown progress
- **Runes** (Blood/Frost/Unholy Death Knight) - 6 individual runes with cooldown timers
- **Soul Fragments** (Vengeance/Devourer Demon Hunter)
- **Soul Shards** (Affliction/Demonology/Destruction Warlock) - Destruction displays partial fragments
- **Tip of the Spear** (Survival Hunter) - up to 3 stacks with duration timer
- **Whirlwind Charges** (Fury Warrior) - 4 charges with cooldown remaining

### Health Bar

A dedicated health bar is available for all specs, providing an at-a-glance view of your current health with customizable color thresholds. An optional absorb shield overlay displays your current absorb amount on the health bar with three display modes:

- **Overlay (from left)** - renders the absorb amount as a semi-transparent overlay on top of the health bar, filling from the left edge
- **Appended** - extends the absorb shield visually past the end of your current health fill, clipped to the bar's right edge
- **Overlay (from right / inset)** - fills leftward from the end of your current health, overlapping the health bar from right to left

The absorb overlay has its own configurable texture and color, and the current absorb amount is available as a bar text variable (`$absorb`).

### Druid Shapeshifting

Switch between Astral Power, Energy + Combo Points, Rage, and Mana bars to match your current Druid shapeshift form -- including unique bar text and threshold lines.

### Void Metamorphosis and Collapsing Star Bar

Devourer Demon Hunter have a bar that tracks both Void Metamorphosis and Collapsing Star, based on current buffs, in addition to a Fury bar.

### Secondary Mana Bar

Some DPS specs that may need to off-heal in a pinch have a secondary mana bar available (disabled by default):

- Balance Druid
- Elemental Shaman
- Shadow Priest

### Stagger Bar (Brewmaster Monk)

Brewmaster Monks get a dedicated Stagger bar that displays current stagger damage as a percentage of maximum health. The bar includes configurable thresholds for Medium, Heavy, and Extremely Heavy stagger levels, with color transitions as stagger severity increases. The maximum stagger percentage displayed by the bar can be set above 100% of maximum health. Stagger levels and colors are set to Blizzard's defaults but can be freely customized to suit your preferences and needs.

### Defensives Bar (Protection Warrior)

Protection Warriors have a specialized Defensives bar that tracks the remaining duration of key defensive abilities:

- **Ignore Pain** duration and absorption amount remaining
- **Shield Block** duration remaining and available charges

### Major Cooldown Tracking

Many specs can track important buff status and timers via color changes and directly in bar text variables:

| Spec | Tracked Cooldowns |
| ------ | ------------------- |
| Havoc/Vengeance/Devourer Demon Hunter | (Void) Metamorphosis |
| Balance Druid | Eclipse/Incarnation |
| Feral Druid | Berserk/Incarnation, including incoming combo point generation timing |
| Guardian Druid | Berserk/Incarnation |
| Restoration Druid | Efflorescence, Incarnation |
| Augmentation Evoker | Ebon Might |
| Devastation Evoker | Dragonrage |
| Beast Mastery Hunter | Beast Cleave, Bestial Wrath |
| Marksmanship Hunter | Trueshot |
| Survival Hunter | Takedown |
| Brewmaster Monk | Invoke Niuzao, the Black Ox |
| Discipline Priest | Power Word: Radiance |
| Holy Priest | Apotheosis, Holy Word cooldown reduction tracking |
| Shadow Priest | Voidform, Entropic Rift (including extensions remaining) |
| Elemental/Enhancement/Restoration Shaman | Ascendance |

---

## Localization

TRB is being actively translated into multiple languages. Current progress:

- **German (deDE)** - Complete
- **Simplified Chinese (zhCN)** - Complete

If you're interested in helping translate TRB into other languages, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know!

---

## Support

Found an issue? Report it on [GitHub](https://github.com/Twintop/TwintopInsanityBar/issues/) or join the discussion on [Discord](https://discord.gg/eThqxM78xm).
