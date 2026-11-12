local _, TRB = ...

-- Core changelog shown by the News window's Core tab (Core\Functions\News.lua renders it). Markdown; newest
-- first. Titles name the Live, Forever, Classic, and TBC releases; the tab keeps only the running flavor's.
TRB.Details.coreNewsContent = [====[

# Live 12.1.5.13-release / Forever 1.60.1.19-release / Classic 1.15.9.4-release / TBC 2.5.6.2-release (2026-11-10)
## General

- [#974](#974) Update LibEditMode to version 19.
- [#982](#982) Fix memory use growing with every loading screen, specialization change, and talent change.
- [#983](#983) Remove the `/trb fill` command.
- [#985](#985) Move each game version's resource names, spells, and shapeshift form conditions from the shared code into that version's own files.
- [#985](#985) Remove `Character:ClassHasForms`.
- Move the remaining class bar colors, bar text variable types, and build check from the shared code into each game version.
- Remove the shared code's redundant bar hiding when a specialization is disabled.
- Update LibSimpleHTMLMarkdown to version 1.0.3.

## Edit Mode

- [#974](#974) Add X and Y position entry for the selected bar in Edit Mode.
- [#974](#974) Bars dragged in Edit Mode snap to the grid, the screen edges and center, other Edit Mode frames, and other bars.
- [#974](#974) Add Snap to Grid and Snap to Frames to each bar's Edit Mode settings, both on by default.
- [#974](#974) Gray out a bar's Horizontal Position and Vertical Position options while Edit Mode positions it.
- [#974](#974) Gray out a bar's Width or Height option while it matches its anchor's width or height.
- [#974](#974) In Edit Mode, each Bar Text Area shows its name and each bar shows an icon where it is attached, as in Preview Mode.
- [#976](#976) Fix bar text drawing behind its bar in Edit Mode.
- [#976](#976) Fix the Other Bars and the Target and Focus Cast Bars disappearing in Edit Mode and Preview Mode.

## Localization

- [#978 - @MOSS099](#978) Updated translations for Simplified Chinese (zhCN).
- [#980 - @MOSS099](#980) Updated translations for Simplified Chinese (zhCN).
- [#984 - @MOSS099](#984) Updated translations for Simplified Chinese (zhCN).

## Preview Mode

- [#973](#973) Add a Preview Mode checkbox to the top of the options window, showing every bar that isn't set to Never Show, with each Bar Text Area showing its name.
- [#973](#973) In Preview Mode, drag a bar to move it and every bar anchored with it. Bars positioned using Edit Mode are grayed out and can't be dragged.
- [#973](#973) In Preview Mode, each bar shows an icon where it is attached, and clicking a bar opens the options that position it.
- [#973](#973) Preview Mode ends when the options window closes, Edit Mode opens, or you enter combat.

---

# Live 12.1.5.11-release / Forever 1.60.1.18-release / Classic 1.15.9.3-release / TBC 2.5.6.1-release (2026-11-10)
## General

- [#935](#935) Improve bar text update performance, primarily out of combat and during casts.
- [#936](#936) Improve update performance of bars with multiple nodes, custom threshold lines, and bar text.
- [#937](#937) Improve bar text update performance, primarily for timers, totems, pets, stats, and health.
- [#937](#937) Fix bar text keeping its old format after a Timer Precision or Number Abbreviation change until its value next changed.
- [#938](#938) Improve bar update performance, primarily around bars with multiple nodes, End Caps, and overlays.
- [#939](#939) Improve bar text update performance, primarily for bar text on bars that aren't showing.
- [#941](#941) Improve update performance of the cast bars, Other Bars, Skyriding bars, and bars fading in or out.
- [#943](#943) Improve update performance of threshold lines, primarily custom threshold lines.
- [#944](#944) Improve update performance of bar colors, the health and pet bars, and bars filled by a buff's duration.
- [#946](#946) Improve bar text update performance, primarily for bar text with conditions.
- [#956](#956) Improve Color Indicator performance.
- [#959](#959) Improve bar text update performance in combat.
- [#959](#959) Fix a buff or proc's bar text timer sometimes staying on screen after it ended, until something else changed.
- [#964](#964) Fix casting, spending, absorb, and incoming heal overlays drawing over the bar's top and bottom border at some UI scales.
- [#970](#970) Improve threshold line update performance.
- [#970](#970) Remove unused target health percent code.

## Color Indicators

- [#942](#942) Fix a Color Indicator that turns on mid-cast not recoloring the Target and Focus Cast Bars' border until the next cast.
- [#965](#965) Built-in Color Indicators and gradient colors get an Edit button, whose Change Source switches the row to another built-in and keeps its color and targets.
- [#965](#965) Add a Not Active option to the Edit button, turning a Color Indicator on while its condition is not met.
- [#969](#969) Add an Only In Combat option to the Edit button, turning a Color Indicator on only while you are in combat.
- [#971](#971) Add Only In Combat to gradient colors' Edit button.
- [#971](#971) Built-in Color Indicators and gradient colors that only showed in combat use Only In Combat instead, on by default.

## Localization

- [#933 - @MOSS099](#933) Updated translations for Simplified Chinese (zhCN).
- [#967 - @MOSS099](#967) Updated translations for Simplified Chinese (zhCN).

## Pet Bars

- [#962](#962) Fix `$petName` showing Unknown for a newly summoned pet.

---

# Live 12.1.5.10-release / Forever 1.60.1.17-release / Classic 1.15.9.2-release / TBC 2.5.6.0-release (2026-11-05)
## Bar Visibility

- [#932](#932) Add Out of Combat to Show Bar When, and In Combat and Out of Combat to Always Hide Bar When, on every bar except the cast bars and Skyriding bars.

## Color Indicators

- [#831](#831) Built-in Color Indicators can be removed, and added back with a new Add Built-in Color Indicator button.
- [#831](#831) Add Built-in Color Indicator can also add more copies of a built-in Color Indicator, each with its own color, targets, and priority.

## Localization

- [#928 - @MOSS099](#928) Updated translations for Simplified Chinese (zhCN).
- [#931 - @MOSS099](#931) Updated translations for Simplified Chinese (zhCN).

---

# Live 12.1.5.9-release / Forever 1.60.1.16-release / Classic 1.15.9.1-release (2026-11-03)
## General

- [#916](#916) Add a Use class color option to the Cast Bar, coloring casts, channels, and uninterruptible casts with your class color.
- [#916](#916) Add a Use class color option to the Cast Bar's Empower Level Colors, coloring empowered casts with your class color.
- Replace the LibMarkdown library with LibSimpleHTMLMarkdown.

## Localization

- [#923 - @MOSS099](#923) Updated translations for Simplified Chinese (zhCN).

## Pet Bars

- [#916](#916) Add a Use class color option to the Pet Cast Bar, coloring its casts, channels, and uninterruptible casts with your class color.
- [#916](#916) Add a Single (Class Color) color type to Pet Health.

## Totems

- [#527](#527) Add a new Totems bar, tracking each totem's icon and time left, with `$totem1Name`, `$totem1Time`, and `#totem1` for each slot (`$fireTotemName`, `$fireTotemTime`, and `#fireTotem` for each element on Forever and Classic). On Live it shows while a totem is up on a specialization where it has its own tab; new installs show it, and existing installs are asked the first time they log in on one. On Forever and Classic it is always shown there, just above the main bar. On Live every other specialization has it under Other Bars, set to Never Show.
- [#527](#527) Live shows four nodes, growing to eight as more totems are up. Forever and Classic show one node per element, each in its own color, and keep the bar's settings and text on each specialization, with none in Global Options. A totem turns the Ending color as it is about to expire. On Live and Forever, a Hide Blizzard's totem frame option hides the default totem icons.
- [#527](#527) Each totem slot is a bar text Relative to Frame target, and the Totems bar's border, background, and End Cap are Color Indicator targets. The Totems bar has no Smooth option and no threshold lines.

---

# Live 12.1.5.8-release / Forever 1.60.1.15-release / Classic 1.15.9.0-release (2026-10-29)
## General

- [#914](#914) The News window's Core tab titles each release with this game's version alone, and leaves out releases from before this game was supported.
- Fix the End Cap still leaving a sliver of the bar showing past it during long channels such as Fishing.
- Fix the End Cap narrowing as the Target and Focus Cast Bars near full.

## Color Indicators

- [#515](#515) Custom Color Indicators can follow a threshold line, from a Threshold Line menu beside Buffs (CDM) on specializations with threshold lines.
- [#515](#515) A threshold line's Color Indicator turns on while its ability is usable, unusable, on cooldown, out of range, or in range, or whenever you know it, for a line set to Static.
- [#515](#515) A threshold line's Color Indicator uses the line's color for its state, and In Range uses the Usable color.
- [#515](#515) Threshold lines that change color in steps, such as Shadow Word: Madness (x2), and custom thresholds aren't offered.

## Localization

- [#889 - @MOSS099](#889) Updated translations for Simplified Chinese (zhCN).
- [#897 - @MOSS099](#897) Updated translations for Simplified Chinese (zhCN).
- [#901 - @MOSS099](#901) Updated translations for Simplified Chinese (zhCN).
- [#903 - @MOSS099](#903) Updated translations for Simplified Chinese (zhCN).
- [#906 - @MOSS099](#906) Updated translations for Simplified Chinese (zhCN).
- [#915 - @MOSS099](#915) Updated translations for Simplified Chinese (zhCN).

## Thresholds

- [#279](#279) Fix threshold lines not using the unusable color while their ability is on cooldown.
- [#279](#279) Fix threshold icons not showing their ability's cooldown, or the recharge of an ability with charges.
- [#279](#279) Threshold lines for abilities with no range, such as Spinning Crane Kick (Brewmaster) and Black Powder, are never out of range.
- [#279](#279) Improve threshold line update performance for abilities with a cooldown.
- [#279](#279) Improve threshold line update performance with no target.
- [#279](#279) Add Show cooldown swipe on icons, Show cooldown time on icons, and While an Ability with Charges Recharges options, shared and to each threshold.
- [#279](#279) Add a Threshold Line Behavior section, with its own use global settings, and a Track ability cooldowns option, shared and to each threshold.
- [#279](#279) Grayed-out threshold options say why in their tooltip.
- [#279](#279) Add a Hide while on cooldown option to Threshold Line Behavior, shared and to each threshold, that shows the line again with a set number of GCDs or seconds left.
- [#279](#279) Add a Hide with no valid target option to Threshold Line Behavior, shared and to each threshold, in combat only or always.
- [#333](#333) Add a When Threshold Icons Overlap option: Stagger into rows moves overlapping icons onto rows away from the bar, and Show highest priority only hides an icon that overlaps a higher-priority one.
- [#333](#333) Stagger into rows has spacing and maximum row options; icons that don't fit are hidden.
- [#333](#333) Add an Allowed Icon Overlap option, letting overlapping icons cover each other by up to that share of their size before they move.
- [#333](#333) Add an Extend threshold lines to their icons option.
- [#333](#333) Add Icon Priority, Never hide this icon, and Ignore overlapping icons options to each threshold and custom threshold.
- [#333](#333) Icon Priority decides which overlapping icon stays nearest the bar or visible, and which draws on top when icons are left to overlap.
- [#890](#890) Fix custom threshold icons on a vertical bar other than the main resource bar being placed as if the bar were horizontal.
- Fix threshold lines getting stuck in or out of range after switching from a specialization that Twintop's Resource Bar isn't enabled for.
- Fix threshold lines getting stuck in or out of range after checking or unchecking use global settings for Threshold Line Colors.
- Fix PvP talent threshold lines not showing when you pick the talent or PvP talents turn on after logging in.

---

# Live 12.1.5.7-release / Forever 1.60.1.14-release (2026-10-25)
## General

- [#213](#213) Remove unused color code.
- [#584](#584) A font, texture, or sound that isn't loaded keeps its setting instead of resetting to the default.
- [#584](#584) Bars, bar text, audio cues, and threshold sounds use the default in place of a font, texture, or sound until it loads, with no reload needed.
- [#584](#584) Options show a font, texture, or sound that isn't loaded with "(not loaded)" after its name.
- [#584](#584) Remove the chat messages about invalid fonts, textures, and sounds.
- [#584](#584) Remove unused audio dropdown and media lookup code from the options.
- [#865](#865) Fix the Health bar's fill briefly turning transparent while changing bar options.
- [#866](#866) Improve update performance of bars whose node order can be rearranged.
- [#868](#868) Improve the player cast bar's update performance during empowered casts.
- [#868](#868) Fix the player cast bar's End Cap not lining up with the fill's edge during empowered casts with Fill Each Empower Level Separately on.
- [#869](#869) Improve bar update performance, primarily around Color Indicators, glows, overlays, threshold lines, and the Health bar's colors.
- [#870](#870) Fix an Action Button Glow taking its brightness from another glow's color when glows with different opacities start together.
- [#873](#873) Free the memory held for bar colors no longer in use on a specialization or bar layout change, instead of keeping it until a reload.
- [#875](#875) Remove unused color option code from the options.
- Fix the uninterruptible shield on the cast bars drawing under channel ticks and empower stage lines when its Shield Layer is set to Over.
- Fix the uninterruptible shield on the cast bars covering the ability icon when its Shield Layer is set to Over.
- Fix the cast bars showing the last cast's latency zone, ticks, and empower stage lines when they reappear idle after hiding.

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

## Localization

- [#857 - @MOSS099](#857) Updated translations for Simplified Chinese (zhCN).

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
