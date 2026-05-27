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

Twintop's Resource Bar (TRB) is a fully customizable resource bar addon that supports all 13 classes and 40 specializations in World of Warcraft. Whether you're tracking Rage, Mana, Energy, Insanity, or any other resource, TRB provides a unified interface with threshold markers, secondary resource tracking, health monitoring, and major cooldown timers.

The addon is designed to give you the information you need at a glance, with visual and audio cues to help you make split-second decisions during combat.

---

## Customization

TRB is built with customization at its core. Nearly every aspect of the addon can be tailored to fit your UI and playstyle.

### Bar Visibility

Every bar can be shown or hidden independently with granular, mix-and-match visibility conditions:

- Combat state: In Combat, In Vehicle
- Mount state: Is Mounted (Any), Ground Mount, Skyriding, Steady Flight
- Target state: Friendly Target, Hostile Target
- Group state: In Group, In Raid Group
- Instance state: In Instance, In Dungeon, In Raid Instance, In Delve, In Battleground, In Arena
- PvP state: PvP Flagged
- Resource and health thresholds (percentage or raw value), including the secondary Mana bar for Shadow Priest, Balance Druid, and Elemental Shaman
- Per-bar opacity and fade-out configuration
- Always-hide overrides that take precedence over other visibility settings when specific conditions are met
- Hidden bars maintain their layout height so other bars don't shift position

### Size and Position

- Adjustable width and height for primary and secondary resource bars
- Pixel-precise positioning with horizontal and vertical offsets
- Anchor bars to other bars for automatic relative positioning, or position each bar independently
- Position bars via Edit Mode or classic X/Y offset settings
- Per-bar Fill Direction: Left to Right, Right to Left, Top to Bottom, or Bottom to Top, allowing any bar or bar group to be oriented horizontally or vertically
- Independent Growth Direction for multi-node bars so groups like Warrior Defensives can place each bar on its own row regardless of fill direction
- Optionally match an anchor bar's (or Edit Mode frame's) height in addition to its width for a cohesive layout

### Colors

- Separate color settings for bar fill, border, and background
- Indicator Color System: state-based color changes that can target any combination of bars and elements (fill, border, background) with configurable priority ordering
- Optional gradient color transitions for bar fills and casting overlays
- Per-threshold colors: under resource threshold, over resource threshold, unusable, out of range -- each overridable per-threshold with static or per-state colors
- Per-threshold visibility overrides (e.g., hide when unusable)
- Individual node coloring for secondary resources, with per-stack distinct color options for bars like Holy Power (1-5), Soul Shards (1-5), Whirlwind Charges (1 vs. 2 charges, plus an optional 0-charge background), and the 5th Maelstrom Weapon stack
- Dedicated color option for the partial-fill portion of bars with time-based or fragment-based generation (Evoker Essence, Feral Druid Combo Points, Destruction Warlock Soul Shards)
- Node border overlap option for multi-node bars (Combo Points, Runes, etc.)
- Optional full-bar-height overlays (casting, spending, absorb, incoming heal) that extend across the border for a flush appearance
- Global color settings that apply across all specializations (e.g., Health Bar colors)

### Textures and Fonts

- Full LibSharedMedia integration for custom textures and fonts
- Independent texture settings for primary bar, secondary nodes, and custom bars (Stagger, Mana, Defensives)
- Configurable font face, size, color, outline, and shadow for all text elements

### Audio Notifications

- Customizable sound cues triggered by resource thresholds or proc events
- Per-threshold audio cues that play when a threshold becomes usable
- Secondary resource audio cues (Combo Points, Holy Power, Soul Shards, Chi, Arcane Charges, Maelstrom Weapon) that fire independently of bar visibility, triggering only during combat
- Proc and cooldown audio cues for key abilities and buffs, including Benediction procs (Holy Priest), Lightweaver stacks (configurable trigger threshold plus an optional drop-off warning), Holy Word: Chastise/Serenity/Sanctify coming off cooldown per charge, Surge of Light (with optional Spiritwell-only restriction), Dance of Chi-Ji, Earthquake/Elemental Blast usability, Divine Purpose, and more
- LibSharedMedia support for custom sounds
- Configurable audio output channel

### Bar Text

TRB features a powerful bar text system that lets you display exactly the information you want, where you want it. Create multiple text entries with independent positioning, fonts, and colors. Bar text entries use shared font settings by default; per-entry overrides are available for full control.

Global Bar Text entries can be configured in the Global Options "Bar Text" tab and shared across all specializations. Each specialization has an opt-in toggle to prepend global entries before its own.

Use variables like `$resource`, `$comboPoints`, `$haste`, `$gcd`, and `$inCombatTime` to display live data, or `#casting` to show spell icons. Bar text also supports conditional logic with Boolean operators for dynamic displays.

For multi-node bars (Combo Points, Runes, Soul Shards, etc.), bar text can be anchored to the bar group as a whole or to individual nodes.

The bar text editor includes a searchable variable browser with descriptions and icons, allowing you to find and insert variables directly at the cursor position. Full undo/redo support is available via standard Ctrl+Z and Ctrl+Shift+Z (or Ctrl+Y) keyboard shortcuts.

For complete documentation on available variables and advanced formatting, check out the [Bar Text Customization Wiki](https://github.com/Twintop/TwintopInsanityBar/wiki/Bar-Text-Customization).

### Import and Export

Share your configuration with others or back up your settings:

- Export individual sections (colors, thresholds, fonts, audio) or entire spec configurations
- Import configurations from other players
- Compressed export strings using Blizzard's `C_EncodingUtil` with Deflate compression for smaller sizes (legacy import strings remain compatible)
- "Copy..." buttons on supported settings sections let you copy shared settings between profiles, specializations, and Global Options without exporting and re-importing
- Native Wago Profile Import/Export API support for one-click sharing through the Wago Companion app

### Profiles

- Per-specialization profiles, groupable into named profile sets for easy sharing across characters and specs
- Configurable on a per-specialization and per-character basis with a default fallback profile
- Dedicated profiles for Global Options, with one active at a time that applies to every specialization using global settings

### Options Window

- Dedicated movable options window accessible via `/trb` or the minimap button
- Toggle the minimap button with `/trb minimap show` and `/trb minimap hide`
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
- **Anchor to Any Frame** - Anchor bars to any named frame in addition to the Cooldown Manager
- **Match Cooldown Manager Width** - When anchored to the Cooldown Manager, optionally match its width for a cohesive look
- **Vertical Offset** - Fine-tune vertical spacing when anchored to the Cooldown Manager
- **Reset Edit Mode Data** - Clear all stored Edit Mode layout data from the "Reset Defaults" tab in Global Options

### Primary Resource Bar

Every spec gets a primary resource bar that tracks your main resource (Mana, Rage, Energy, Focus, Runic Power, Fury, Insanity, Astral Power, or Maelstrom). The bar includes:

- **Threshold lines** showing the cost of your abilities, color-coded by availability. See the Threshold Lines section below for full details.
- **Predictive cast resource overlay** for some specs, showing expected resource changes during your current cast as an overlay on the bar or via bar text
- **Maximum display customization** allows the bar to fill to a lower value than your maximum resource; useful for specs like Assassination Rogue with threshold lines and very high maximum resource pools
- **Overcapping resource alert** change the bar border and resource text color when almost full on resources for specs with fast auto-regennerating resources (i.e. Rogues) and those with builder/spender playstyles (i.e. Shadow)

### Threshold Lines

Threshold lines mark the resource cost of your abilities on the primary bar, color-coded by whether the ability is currently usable. Every threshold for a specialization is managed from a single sortable, searchable table with columns for icon, name, category, bar target, audio cue, and enabled status. Selecting a row opens a detail panel below the table for editing without navigating away.

Per-threshold options include:

- **Color overrides** -- use a static color, or independently override the default Under, Over, Unusable, and Out of Range colors for that specific threshold
- **Visibility overrides** -- hide a threshold line entirely under specific states (for example, hide when unusable) instead of relying on color alone
- **Icon display** -- toggle the icon, position it relative to the line, and adjust its size and border width
- **Audio cues** -- choose a sound to play when the threshold becomes usable (thresholds tied to `secret` resource values, such as Execute at max Rage, don't support audio cues)
- **Enable/disable** -- turn individual thresholds on or off without removing them

A dedicated **Threshold Shared Settings** tab sets the default threshold colors, line dimensions, and icon defaults that apply to every threshold for the specialization, giving you a single place to restyle them all at once while still allowing per-threshold overrides.

### Secondary Resource Nodes

Many specs have a secondary resource displayed as individual nodes above or below the primary bar:

- **Arcane Charges** (Arcane Mage)
- **Bone Shield** (Blood Death Knight) - up to 12 nodes, disabled by default
- **Chi** (Windwalker Monk)
- **Combo Points** (Feral Druid, Assassination/Outlaw/Subtlety Rogue)
- **Ebon Might** (Augmentation Evoker) - separate bar tracking remaining duration
- **Essence** (Devastation/Preservation/Augmentation Evoker) - displayed with timer-based regeneration progress
- **Fire Blast Charges** (Fire Mage) - per-node recharge timers with bar text and color options for each node and the partial recharge fill
- **Holy Power** (Holy/Protection/Retribution Paladin)
- **Icicles** (Frost Mage) - up to 5 stacks
- **Holy Words** (Holy Priest) - individually toggleable and reorderable cooldown nodes for Holy Word: Serenity, Sanctify, and Chastise with real-time cooldown progress and CDR tracking
- **Lightweaver** (Holy Priest) - per-stack nodes with duration timer, disabled by default. Includes an optional background indicator on the next unfilled node while Benediction is active.
- **Maelstrom Weapon** (Enhancement Shaman) - 5 or 10 stacks with a dedicated color for the 5th stack
- **Power Words** (Discipline Priest) - cooldown nodes for Power Word: Radiance with real-time cooldown progress
- **Runes** (Blood/Frost/Unholy Death Knight) - 6 individual runes with cooldown timers
- **Soul Fragments** (Vengeance/Devourer Demon Hunter)
- **Soul Shards** (Affliction/Demonology/Destruction Warlock) - Destruction displays partial fragments
- **Tip of the Spear** (Survival Hunter) - up to 3 stacks with duration timer
- **Whirlwind Charges** (Fury Warrior) - up to 4 charges with separate colors for 1-charge and 2-charge states, optional 0-charge background color, and cooldown remaining

### Utility Resource Bars

Some specs have utility bars that track non-combat or situational abilities as their own bar group, independent of the primary and secondary resource bars. These are disabled by default.

- **Angelic Feather** (Priest) - charges and cooldown

More utility resource bars are coming soon!

### Health Bar

A dedicated health bar is available for all specs, providing an at-a-glance view of your current health with customizable color thresholds. An optional absorb shield overlay displays your current absorb amount on the health bar with four display modes:

- **Overlay (from left)** - renders the absorb amount as a semi-transparent overlay on top of the health bar, filling from the left edge
- **Appended** - extends the absorb shield visually past the end of your current health fill, clipped to the bar's right edge
- **Appended (Overflow)** - same as Appended, but allows the overlay to extend past the bar's right edge when the absorb amount exceeds maximum health
- **Overlay (from right / inset)** - fills leftward from the end of your current health, overlapping the health bar from right to left

The absorb overlay has its own configurable texture and color, and the current absorb amount is available as a bar text variable (`$absorb`).

An optional incoming heals overlay displays predicted incoming healing on the health bar, with the value available as a bar text variable (`$incomingHeal`).

### Druid Shapeshifting

Switch between Astral Power, Energy + Combo Points, Rage, and Mana bars to match your current Druid shapeshift form -- including unique bar text and threshold lines. Combo Points can be displayed in all shapeshift forms with per-specialization visibility control.

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

Protection Warriors have a specialized Defensives bar that tracks the remaining duration of key defensive abilities. Each Defensive bar can be enabled or disabled independently and reordered.

- **Ignore Pain (Time)** -- duration remaining
- **Ignore Pain (Absorb)** -- absorb stack count (0–100)
- **Shield Block** -- duration remaining and available charges

### Major Cooldown Tracking

Many specs can track important buff status and timers via color changes and directly in bar text variables:

| Spec | Tracked Cooldowns |
| ------ | ------------------- |
| Havoc Demon Hunter | Metamorphosis |
| Vengeance Demon Hunter | Metamorphosis |
| Devourer Demon Hunter | Void Metamorphosis, Rolling Torment Fury prediction |
| Balance Druid | Eclipse/Incarnation |
| Feral Druid | Berserk/Incarnation (including incoming combo point generation timing), Clearcasting, Ravage |
| Guardian Druid | Berserk/Incarnation |
| Restoration Druid | Efflorescence, Incarnation, Clearcasting |
| Augmentation Evoker | Ebon Might |
| Devastation Evoker | Dragonrage |
| Beast Mastery Hunter | Beast Cleave, Bestial Wrath |
| Marksmanship Hunter | Trueshot |
| Survival Hunter | Takedown |
| Brewmaster Monk | Invoke Niuzao, the Black Ox |
| Mistweaver Monk | Instant Vivify (Sheilun's Gift, Serene Surge) |
| Windwalker Monk | Heart of the Jade Serpent, Dance of Chi-Ji |
| Holy/Protection/Retribution Paladin | Divine Purpose |
| Discipline Priest | Power Word: Radiance, Void Shield, Surge of Light |
| Holy Priest | Apotheosis, Benediction, Lightweaver, Surge of Light, Holy Word cooldown reduction tracking |
| Shadow Priest | Voidform, Entropic Rift (including extensions remaining), Shadowy Insight (Instant Mind Blast) |
| Elemental Shaman | Ascendance, Earthquake/Elemental Blast usability |
| Enhancement Shaman | Ascendance |
| Restoration Shaman | Ascendance |

---

## Localization

TRB is being actively translated into multiple languages. Current progress:

- **Simplified Chinese (zhCN)** - 100%
- **German (deDE)** - 57%
- **French (frFR)** - 8%

If you're interested in helping translate TRB into other languages, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know!

---

## Support

Found an issue? Report it on [GitHub](https://github.com/Twintop/TwintopInsanityBar/issues/) or join the discussion on [Discord](https://discord.gg/eThqxM78xm).
