local _, TRB = ...

-- Core changelog shown by the News window's Core tab (Core\Functions\News.lua renders it). Markdown; newest
-- first. Each section names the Live and Forever releases that carry it.
TRB.Details.coreNewsContent = [====[

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
