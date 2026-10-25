local _, TRB = ...

-- Core changelog shown by the News window's Core tab (Core\Functions\News.lua renders it). Markdown; newest
-- first. Each section names the Live and Forever releases that carry it.
TRB.Details.coreNewsContent = [====[

# Live 12.1.5.7-release / Forever 1.60.1.14-release (2026-10-23)
## General

- [#213](#213) Remove unused color code.
- [#584](#584) A font, texture, or sound that isn't loaded keeps its setting instead of resetting to the default.
- [#584](#584) Bars, bar text, audio cues, and threshold sounds use the default in place of a font, texture, or sound until it loads, with no reload needed.
- [#584](#584) Options show a font, texture, or sound that isn't loaded with "(not loaded)" after its name.
- [#584](#584) Remove the chat messages about invalid fonts, textures, and sounds.
- [#584](#584) Remove unused audio dropdown and media lookup code from the options.
- [#865](#865) Fix the Health bar's fill briefly turning transparent while changing bar options.
- [#866](#866) Improve update performance of bars whose node order can be rearranged.
- [#870](#870) Fix an Action Button Glow taking its brightness from another glow's color when glows with different opacities start together.
- [#873](#873) Free the memory held for bar colors no longer in use on a specialization or bar layout change, instead of keeping it until a reload.
- [#875](#875) Remove unused color option code from the options.
- Fix the uninterruptible shield on the cast bars drawing under channel ticks and empower stage lines when its Shield Layer is set to Over.
- Fix the uninterruptible shield on the cast bars covering the ability icon when its Shield Layer is set to Over.

## Bar Text

- [#860](#860) Add a Bar Text tab to Cast Bars, Other Bars, Pet Bars, and Skyriding, listing only the bar text bound to the bars under each, in Global Options and for every specialization.
- [#860](#860) The Bar Text tab of Global Options and of each specialization no longer lists the bar text bound to the bars under Cast Bars, Other Bars, Pet Bars, and Skyriding.
- [#860](#860) Add a checkbox that also lists that bar text on the Bar Text tab of Global Options and of each specialization.
- [#860](#860) Add a Move to bar option to a bar text entry's copy menu.
- [#860](#860) A specialization's Bar Text tabs also list the Global Bar Text it displays.
- [#860](#860) Deleting Global Bar Text from a specialization's Bar Text tab warns that it is deleted for every specialization that uses it.

## Bar Textures

- [#861](#861) The Textures tab of Global Options and of each specialization is now a table of bars, with the selected bar's fill, border, background, and overlay textures below it.
- [#861](#861) Add a Textures tab to Cast Bars, Other Bars, Pet Bars, and Skyriding, listing only the bars under each, in Global Options and for every specialization.
- [#861](#861) The Textures tab of Global Options and of each specialization no longer lists the bars under Cast Bars, Other Bars, Pet Bars, and Skyriding.
- [#861](#861) Add a checkbox that also lists those bars on the Textures tab of Global Options and of each specialization.
- [#861](#861) Use global settings on the Textures tabs now works per bar.
- [#861](#861) The use global settings box on a Textures tab switches every bar it lists.
- [#861](#861) Remove the Global badge from the Textures tab's header.
- [#861](#861) Remove the Copy button beside the Textures tab's use global settings box.
- [#861](#861) The Utility bar, such as Angelic Feather, can use the textures set under Utility on Global Options' Textures tab, except where a specialization already changed its own.
- [#861](#861) Replace the single texture lock with separate locks for bar, border, background, and health overlay textures.
- [#861](#861) A texture that can't be changed says why when you hover over it: the lock that keeps it the same as another texture, or the bar using global settings.
- [#861](#861) A bar that uses global settings shows the textures from Global Options under a cover, with buttons to open them in Global Options or to customize the bar for this specialization.
- [#861](#861) Fix the Mana bar ignoring its own texture options; until they are set, it keeps the main bar's textures.

## Bar Visibility

- [#858](#858) Add a Visibility tab to Cast Bars, Other Bars, Pet Bars, and Skyriding, listing only the bars under each, in Global Options and for every specialization.
- [#858](#858) The Visibility tab of Global Options and of each specialization no longer lists the bars under Cast Bars, Other Bars, Pet Bars, and Skyriding.
- [#858](#858) Add a checkbox that also lists those bars on the Visibility tab of Global Options and of each specialization.
- [#858](#858) A bar tab's Configure Visibility link opens the Visibility tab of the group the bar belongs to.
- [#859](#859) Use global settings on the Visibility tabs now works per bar.
- [#859](#859) The use global settings box on a Visibility tab switches every bar it lists.
- [#859](#859) A bar on a Visibility tab that uses the global settings can be customized on its own.
- [#859](#859) Remove the Copy button beside the Visibility tab's use global settings box.
- [#859](#859) Fix the Visibility tab of Global Options naming the Utility bar Angelic Feather.
- [#859](#859) Add visibility presets, named sets of Show Bar When, Always Hide When, opacity, fade, and smoothing settings that bars can share.
- [#859](#859) Editing a visibility preset changes every bar that uses it.
- [#859](#859) Bars whose visibility settings match a preset exactly use that preset automatically.
- [#859](#859) Split the Visibility tab of Global Options into Bar Display and Manage Presets tabs.
- [#859](#859) Add, rename, edit, and delete visibility presets on the Manage Presets tab.
- [#859](#859) Add an Actions button to the Visibility tab to copy settings onto a bar from Global Options, another bar, or a preset, to use a preset, to go back to the global settings, or to save a bar's settings as a preset.
- [#859](#859) Add Apply to Bars to the Visibility tab to copy settings onto, use a preset for, or go back to the global settings for several bars at once.
- [#859](#859) Add an Enabled checkbox to the selected bar's settings on the Visibility tab, which turns the bar on or off, including while it uses a preset.
- [#859](#859) Fix the Visibility tab of Global Options listing the form conditions only while playing a class with forms.

## Color Indicators

- [#885](#885) Fix exported profiles leaving out a Color Indicator's minimum stacks setting, such as Resonant Energy's.

---

# Live 12.1.5.5-release / Forever 1.60.1.13-release (2026-10-23)
## General

- Fix switching profiles, or logging in on another character with a different profile, carrying settings such as custom threshold lines over from the previous profile.
- Fix deleting the active profile from a profile dropdown copying its settings into the profile that replaces it, or undoing a reset of the Default profile.
- Fix the End Cap sometimes leaving a sliver of the bar showing past it, most noticeably on the cast bars during long channels such as Fishing.

## Bar Text

- [#854](#854) Add `$movementSpeed` bar text, your current speed as a percentage of normal running speed, empty when the game hides it as a `secret` value while in combat.

---

# Live 12.1.5.5-release / Forever 1.60.1.13-release (2026-10-23)

Removed.

---

# Live 12.1.5.3-release / Forever 1.60.1.11-release (2026-10-21)
## General

- [#853](#853) Improve bar update performance, primarily around bar visibility, threshold lines, bar text, the Health bar, and the cast bars.
- [#853](#853) Fix bars with a Resource / Health Threshold visibility condition showing or hiding incorrectly while the bar flashes or fades.
- [#853](#853) Fix the Location / Instances visibility conditions staying wrong after leaving a garrison.
- [#853](#853) Fix audio cues and threshold line sounds playing for conditions already met after a login or specialization change.
- [#853](#853) Fix a proc's audio cue staying silent the first time it procs after you return to a specialization you left with it active.
- [#853](#853) Fix the Target Cast Bar and Focus Cast Bar sometimes keeping the uninterruptible fill color on a friendly unit's cast.
- [#853](#853) Remove the unused LibSmoothMove library.

## Localization

- [#852 - @MOSS099](#852) Updated translations for Simplified Chinese (zhCN).

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
