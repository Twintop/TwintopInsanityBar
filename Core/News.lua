local _, TRB = ...

-- Core changelog shown by the News window's Core tab (Core\Functions\News.lua renders it). Markdown; newest
-- first. Each section names the Live and Forever releases that carry it.
TRB.Details.coreNewsContent = [====[

# Live 12.1.0.18-release / Forever 1.60.1.6-release (2026-10-08)
## General

- Fix `$castSpellName` and `$petCastSpellName` showing a generic channeling label instead of the spell's name for some channels.

## Localization

- [#845 - @MOSS099](#846) Updated translations for Simplified Chinese (zhCN).

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
