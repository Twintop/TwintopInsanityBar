local _, TRB = ...

-- Core changelog shown by the News window's Core tab (Core\Functions\News.lua renders it). Markdown; newest
-- first. Each section names the Live and Forever releases that carry it.
TRB.Details.coreNewsContent = [====[

# Live 12.1.5.3-release / Forever 1.60.1.11-release (2026-10-18)
## General

- [#853](#853) Improve bar update performance, primarily around bar visibility, threshold lines, bar text, the Health bar, and the cast bars.
- [#853](#853) Fix bars with a Resource / Health Threshold visibility condition showing or hiding incorrectly while the bar flashes or fades.
- [#853](#853) Fix the Location / Instances visibility conditions staying wrong after leaving a garrison.
- [#853](#853) Fix audio cues and threshold line sounds playing for conditions already met after a login, loading screen, or specialization or talent change.
- [#853](#853) Fix the Target Cast Bar and Focus Cast Bar sometimes keeping the uninterruptible fill color on a friendly unit's cast.
- [#853](#853) Remove the unused LibSmoothMove library.

---

# Live 12.1.5.2-release / Forever 1.60.1.10-release (2026-10-15)
## General

- Fix the primary resource bar still sometimes keeping its old maximum after your maximum resource changes.

## Audio Cues

- [#849](#849) Add New Audio Cue can add Buff Alerts, which play when a buff tracked by your Cooldown Manager becomes active.
- [#849](#849) Add a Play out of combat option to every audio cue, including those on the Thresholds tab, unchecked for cues that only played in combat.
- [#849](#849) A combat-only threshold alert no longer plays when combat starts for a threshold reached out of combat.
- [#849](#849) Remove the Trigger On title from the Add New Audio Cue menu.
- [#850](#850) Thresholds tab audio cues play while their bar is hidden.

## Localization

- [#848 - @MOSS099](#848) Updated translations for Simplified Chinese (zhCN).
- [#851 - @MOSS099](#851) Updated translations for Simplified Chinese (zhCN).

---

# Live 12.1.5.1-release / Forever 1.60.1.9-release (2026-10-14)
## General

- [#847](#847) Long color option labels wrap to a second line instead of pushing their CDM or Custom badge out of view.

## Color Indicators

- [#773](#773) Add custom Color Indicators, with Add New Custom Color Indicator, Edit, and Remove buttons on every Color Indicators tab.
- [#773](#773) Custom Color Indicators can follow buffs, debuffs on your target, trinket buffs, and the combat potion buff from your Cooldown Manager layout, and can target any bar other Color Indicators can.
- [#773](#773) A custom Color Indicator whose entry isn't displayed in the Cooldown Manager, or whose talent or trinket buff you don't have, shows a Custom - Not Tracked badge and stays off.
- [#773](#773) Custom Color Indicators can only be added or changed while playing the class and specialization they belong to.

---

# Live 12.1.5.0-release / Forever 1.60.1.8-release (2026-10-12)
## General

- Fix the end cap drawing over channel ticks and empower stage lines on the Cast Bar, Pet Cast Bar, and Target Cast Bar.
- Color Indicator target menus show how many glows each bar's Border Glow has selected.

---

# Live 12.1.0.19-release / Forever 1.60.1.7-release (2026-10-10)
## General

- Remove a debug message that printed to chat whenever your maximum resource changed.

---

# Live 12.1.0.18-release / Forever 1.60.1.6-release (2026-10-09)
## General

- Fix `$castSpellName` and `$petCastSpellName` showing a generic channeling label instead of the spell's name for some channels.
- Fix the primary resource bar keeping its old maximum after your maximum resource changes.

## Localization

- [#846 - @MOSS099](#846) Updated translations for Simplified Chinese (zhCN).

---

# Live 12.1.0.17-release / Forever 1.60.1.5-release (2026-10-07)
## Pet Bars

- The Pet Cast Bar shows channel ticks, with Show Channel Ticks, Channel Tick Color, and Channel Tick Width options, and Color Indicators can target its Channeled Tick Color.

## General

- Every specialization's Color Indicators can target the Cast Bar's Channeled Tick Color.
- Fix predictive resource spending not updating when a hardcast's cost changes partway through the cast.
- Widen the News window.

## Localization

- [#845 - @MOSS099](#845) Updated translations for Simplified Chinese (zhCN).

---

# Live 12.1.0.16-release / Forever 1.60.1.4-release (2026-10-06)
## Pet Bars

- [#551](#551) Add new Pet Resource and Pet Health bars on a new Pet Bars tab, and a new Pet Cast Bar under Cast Bars, tracking your pet, with `$petName`, `$petState`, `$petHealth`, `$petHealthMax`, `$petHealthPercent`, `$petResource`, `$petResourceMax`, `$petResourcePercent`, `$petResourceName`, `$petCastSpellName`, `$petCastTime`, `$petCastTimeRemaining`, `$petCastPushback`, `$petCastSpellId`, `$petCastInterruptible`, and `$petCastUninterruptible` bar text and a `#petCasting` icon. Set to Never Show by default; enable them under Bar Visibility, where the pet bars' Show Bar When and Always Hide Bar When lists add Pet is alive, Pet is dead, and No pet, and their thresholds add Pet Health % and Pet Resource %.
- Pet Resource fills with whichever resource your pet uses, and Pet Health with Low, Medium, and High health colors.
- All three join the bar text Relative to Frame, Color Indicator, and custom threshold target lists.

## Other Bars

- [#844](#844) The Global Cooldown bar's Show Bar When list adds the General, Mounted, Social, Location, and PvP conditions.
- `$gcdDuration` and `$gcdDurationRemaining` read 0, and `$fatigueDuration`, `$fatigueDurationRemaining`, `$breathDuration`, `$breathDurationRemaining`, `$feignDeathDuration`, and `$feignDeathDurationRemaining` read 00:00, instead of blank while their timer is not running.
- Bar text stays shown while an idle Other Bar is on screen.
- Bar text anchored to an Other Bar holds its last value while that bar fades out.

## General

- Fix custom threshold lines changing color at the wrong value on a bar with a Maximum Bar Value override.
- Custom threshold lines in Offset mode count back from the resource's maximum, not the Maximum Bar Value override.

---

# Live 12.1.0.15-release / Forever 1.60.1.3-release (2026-10-03)
## Localization

- [#842 - @MOSS099](#842) Updated translations for Simplified Chinese (zhCN).

---

# Live 12.1.0.14-release / Forever 1.60.1.2-release (2026-09-29)

- Fix bar text and threshold icon positions rotating with a spec's own Fill Direction instead of the direction its bar displays, such as while Use global settings is checked.
- Update LibEditMode to version 18.
- Spec panels cover and badge sections using global settings, and each Enable for all specializations box shows how many specs use it.
- Fix global threshold line colors and textures not always applying, and spec textures overwriting the global ones.
- Rename Threshold Line Colors for DPS and Tanks to Threshold Line Colors, and fix the Brewmaster Energy bar's Base Colors header spacing.
- Built-in threshold lines for every specialization share one renderer.
- A threshold line whose cost equals the bar's maximum is now drawn.

---

# Live 12.1.0.13-release / Forever 1.60.1.1-release (2026-09-22)

- Fix the End Cap sitting a couple of pixels short of the fill's leading edge on the cast bars, the Global Cooldown bar, and any other bar the client animates.
- Bar anchoring, bar text Relative to Frame, custom threshold, and Color Indicator target lists share one order: Screen, the primary bar, the secondary bar and its nodes, spec bars A to Z, Health, Cast Bar, Target Cast Bar, Focus Cast Bar, then Other Bars A to Z.
- Bar anchoring, bar text, and custom thresholds name the primary and secondary bars after their resource, e.g. Insanity Bar, including on existing bar text entries.

---

# Live 12.1.0.12-release / Forever 1.0.0.0-alpha (2026-09-20)

- Every specialization starts with its Use Global toggles on, apart from Font & Text. Global Options drives a fresh install until a toggle is unticked; existing settings keep their toggles.
- The cast bar shows a cast's display name, e.g. `Opening` instead of `Opening - No Text`.
- A fresh install starts with the Target and Focus Cast Bar text entries.
- Bars hidden by a runtime condition (a shapeshift form, In Combat) no longer reappear after changing any bar's anchor, size, or offset.

---
]====]
