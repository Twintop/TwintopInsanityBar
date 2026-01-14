---@diagnostic disable: undefined-field, undefined-global, redundant-parameter
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

local content = [====[
*Localization of the addon is still underway! If you have any interest in helping translate, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know. Thank you!*

# 12.0.0.0-beta12 (2026-01-14)
## [#462](#462) General

- Re-enable bar border and resource text overcap notifications via color change. Unfortunately, it is not possible to re-enable the audio cue at this time due to API limitations.

## Shaman
### [#484](#484) Enhancement

- Add an option to toggle the number of Maelstrom Weapon Combo Points UX elements between 5 and 10.
- Add a new color option for Maelstrom Weapon stacks 1-5.

---

# 12.0.0.0-beta11 (2026-01-12)
## [#462](#462) General

- There have been a large number of changes to what can be displayed as bar text due to the Addon Apocalypse in Midnight. As a result, to avoid broken bar text, all previous bar text has been reset to new defaults.

## Hunter
### [#474](#474) Beast Mastery

- Re-enable Beast Cleave bar border change and bar text variable `$beastCleaveTime`.
- Re-enable Bestial Wrath bar change and bar text variable `$bestialWrathTime`. This has changed from being a border color change to the Focus bar itself changing color. Added a second color change when Bestial Wrath is about to expire (configurable in the Options UI).
- Add support for Wailing Arrow via a threshold line.

### [#475](#475) Marksmanship

- Add support for Wailing Arrow via a threshold line.

## Monk
### [#477](#477) Mistweaver

- Re-enable Vivacious Vivification bar color change. Add support for both Rising Sun Kick and Rushing Wind Kick applying the buff.

---

# 12.0.0.0-beta10 (2026-01-10)
## General

- [#297](#297) Add an optional Mana Bar for Balance Druid, Shadow Priest, and Elemental Shaman. This includes default text and new bar text variables `$mana`, `$manaMax`, and `$manaPercent`.
- Lots of general cleanup of options menus.

## Evoker
### [#473](#473) Augmentation

- Add support for tracking Ebon Might, available via bar text as `$ebonMightTime`. While active, the primary (mana) bar will change color with a configurable color change at the end X GCDs/seconds away from expiring. Additionally, there is a third bar color change and optional audio cue when your current Ebon Might duration increasing hardcase ability will not complete in time.

## Monk
### [#494](#494) Brewmaster

- Convert the Stagger bar to use the new bar architecture. As a result, Global Settings for "Combo Points" will no longer affect the Stagger bar.

## Warrior
### [#489](#489) Protection

- Convert the Defensives bar to use the new bar architecture. As a result, Global Settings for "Combo Points" will no longer affect the Defensives bar.

---

# 12.0.0.0-beta09 (2026-01-05)
## General

- Fix an issue with the new health bar not having any text by default when upgrading. This won't affect users who already upgraded to `beta07` or `beta08` but will fix it for anyone upgrading going forward.

## Paladin
### Holy

- [#506](#506) Correct an issue where visibility options for the health bar were not being shown.

---

# 12.0.0.0-beta08 (2026-01-03)
## General

- Fix some Lua errors due to incorrect settings.

---

# 12.0.0.0-beta07 (2026-01-03)
## General

- [#505](#505) Add an optional player health bar, including new bar text variables `$health`, `$healthMax`, and `$healthPercent`.
- Modify the layout of the Textures section in the Options UI to group like textures together for easier navigation.
- Add new presets for bar size and bar text for all specializations; clean up existing outdated/unused presets.

## Demon Hunter
### [#467](#467) Vengeance

- Re-enable Soul Fragment tracking. The bar now tracks Soul Fragments with a workaround using threshold lines due to API limitations.

## Monk
### [#494](#494) Brewmaster

- Change Stagger tracking to use ColorCurve.
- Add a way to change thresholds for Medium and Heavy Stagger.
- Add threshold line toggles for Medium and Heavy Stagger levels.

## Priest
### [#465](#465) Discipline

- Update Surge of Light tracking mechanisms. Bar text variables have been removed as they no longer can provide accurate information due to API limitations.

### [#464](#464) Holy

- Re-enable Apotheosis tracking, including the `$apotheosisTime` bar text variable and bar color changes.
- Update Surge of Light tracking mechanisms. Bar text variables have been removed as they no longer can provide accurate information due to API limitations.

### [#463](#463) Shadow

- Re-enable Voidform tracking, including the `$vfTime` bar text variable and bar color changes.
- Remove workaround for Voidform Insanity gain on cast depending on talent selection.

---

# 12.0.0.0-beta06 (2025-12-29)
## General

- [#195 - NEW](#195) Allow primary and secondary bars to be independently shown either Always, In Combat, or Never.
- (FIX) For Bar Text variables that are based on `secret` values, always return false for a validity check to avoid Lua errors.

--- 

# 12.0.0.0-beta05 (2025-12-27)
## General

- [#297 - REFACTOR](#297) Completely rebuild the way bars are constructed, controlled, and rendered to allow for more flexibility and future features. Stay tuned!
- [#468 - REMOVE](#468) Remove Time To Die (TTD) tracking due to API limitations around target health. RIP.
- [#468 - FIX](#468) Fix an issue with Mana% being 1/100th the expected value.

--- 

# 12.0.0.0-beta04 (2025-12-24)
## General

- Update implementation for specs that use Mana% to match Blizzard's API changes.

### Localization

- Re-add the Google Translated localizations with updated strings.

## Rogue

- Re-enabled Charged Combo Points now that API limitations have been resolved.

## Shaman
### [#484](#484) Enhancement

- Re-enabled Maelstrom Weapon tracking via the Combo Points UX and bar text variables on PTR (12.0.0). For Beta (12.0.1), the UX is still disabled due to different API implementations available. Once the build updates past *64914* it will be re-enabled.

---

# 12.0.0.0-beta03 (2025-12-10)
## General

- Target both 12.0.0 (PTR) and 12.0.1 (Beta).

## Rogue

- Disable Charged Combo Points due to API limitations. These should return in a future update once the API allows for it.

### [#480](#480) Assassination

- Update Crimson Tempest threshold line to not require Combo Points to show as usable.
- Remove Echoing Reprimand.

### [#481](#481) Outlaw

- Remove Ghostly Strike.

### [#482](#482) Subtlety

- Remove Shuriken Tornado threshold line.

---

# 12.0.0.0-beta02 (2025-12-09)
## Death Knight
### [#499](#499) Blood

- Add threshold lines for abilities that require Runic Power: Death Coil, Death Strike, and Raise Ally.

### [#500](#500) Frost

- Add threshold lines for abilities that require Runic Power: Breath of Sindragosa, Death Coil, Death Strike, Frost Strike, and Glacial Advance.

### [#501](#501) Unholy

- Add threshold lines for abilities that require Runic Power: Death Coil, Death Strike, and Raise Ally.

## Druid
### [#469](#469) Feral

- Add threshold line support for Frantic Frenzy; remove Thrash.

## Hunter
### [#474](#474) Beast Mastery

- Add threshold line support for Wild Thrash.

### [#475](#475) Marksmanship

- Remove Bursting Shot and associated threshold line.

### [#476](#476) Survival

- Add threshold line support for Boomstick and Hatchet Toss.
- Remove threshold lines for Arcane Shot and Wildfire Bomb.
- Remove Steady Shot.

## Warrior

- Clean up Execute threshold lines and logic to display it.

---

# 12.0.0.0-beta01 (2025-12-07)
## General

- Add a way to track custom fixed-duration cooldowns.

## Druid
### [#468](#468) Balance

- Remove Whirling Stars modifiers.

### [#493](#493) Guardian

- Add threshold lines for Rage consuming abilities.
- Add support for Berserk and Incarnation: Guardian of Ursoc to trigger a bar color change and have bar text to show the remaining duration.

## Monk
### [#494](#494) Brewmaster

- Add customization options for Stagger bar colors.
- Add threshold lines for Energy consuming abilities.
- Add support for Jade Flash causing Crackling Jade Lightning to have a cooldown.
- Add Stagger Bar default text.

### [#478](#478) Windwalker

- Add Soothing Mist as a threshold line. Disabled by default.

---

# 12.0.0.0-alpha16 (2025-12-05)
## General

- Clean up dead code from specializations.
- Remove features that won't be returning due to API limitations: Overcap, End Cap, Casting Bar, Passive Bar, Regen, DoT tracking, potions, passive thresholds.
- Removed backward compatibility with older versions of the Bar from as far back as 7.3.5.
- Restore smooth bar update functionality using Blizzard's built-in methods.

### Localization

- Cleared existing Google Translated localizations as most of them are invalid or missing.

## Demon Hunter
### [#466](#466) Havoc

- Update Blind Fury to show generation of 30 per second.

## Druid
### [#468](#468) Balance

- Update Soul of the Forest's modifier to 40%.

### [#469](#469) Feral

- Restore original Combo Point UI implementation.
- Implement tracking of Berserk and Incarnation: Avatar of Ashamane.
- Fix Berserk's passive Combo Point generation.

## Evoker

- Restore original Essence implementation.
- Fix Essence passive generation.

## Mage
### [#502](#502) Arcane

- Change Arcane Charges UI implementation to match other original Combo Point/Essence/Chi/etc. UI implementations.

## Monk
### [#494](#494) Brewmaster

- Enhance Stagger tracking to color the bar, `$stagger`, and `$staggerPercent` based on current Stagger level.
- Format Stagger numbers using Blizzard's built-in large number abbreviations.

### [#478](#478) Windwalker

- Restore original Chi UI implementation.

## Paladin
### [#479](#479) Holy

- Restore original Holy Power UI implementation.

### [#497](#497) Protection and [#498](#498) Retribution

- Change Holy Power UI implementation to match other original Combo Point/Essence/Chi/etc. UI implementations.

## Priest
### [#463](#463) Shadow

- Update Mind Flay (2) and Halo (5) casted Insanity generation.

## Rogue

- Restore original Combo Point UI implementation.

## Warlock
### [#486](#486) Affliction

- Restore original Soul Shards UI implementation.

### [#495](#495) Demonology

- Change Soul Shards UI implementation to match other original Combo Point/Essence/Chi/etc. UI implementations.

### [#496](#496) Destruction

- Change Soul Shards UI implementation to match other original Combo Point/Essence/Chi/etc. UI implementations.
- Update Soul Shard bar text to show one decimal place.

--- 

# 12.0.0.0-alpha15 (2025-12-03)
## General

- As of this release, every specialization has some level of support in the addon!

## Mage
### [#502](#502) Arcane

- Add barebones support for Arcane, tracking Mana and Arcane Charges.

### [#503](#503) Fire and [#504](#504) Frost

- Add barebones support for Fire and Frost, tracking Mana.

## Monk
### [#494](#494) Brewmaster

- Add Stagger Bar with threshold lines for Medium and Heavy Stagger. More functionality coming soon.
- Fix a lack of default bar text.

--- 

# 12.0.0.0-alpha14 (2025-12-02)
## General

- Fix many import/export issues across newly added specializations.

## [#490](#490) Healers

- Disable bar border color changes for Potion of Chilled Clarity and Innervate. These may be readded in the future but have been disabled for now to avoid confusion.

## Death Knight
### [#499](#499) Blood, [#500](#500) Frost, and [#501](#501) Unholy

- Add barebones support for Blood, Frost, and Unholy, tracking Runic Power and Runes.
- Runes can be sorted by cooldown remaining or position.
- Bar text variables for the time remaining for each rune (`$rune1Time`) and if it is ready (`$rune1Ready`).

## Paladin

- Disable some invalid bar text variables.
- Clean up Option menus.

### [#498](#498) Retribution

- Fix issue with default bar settings not loading properly.

---

# 12.0.0.0-alpha13 (2025-11-30)
## Paladin
### [#479](#479) Holy

- Fix implementation to allow the bar to function in a minimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Restore functionality for tracking Holy Power with a workaround. This is placeholder behavior with Holy Power being part of single bar instead of individual UI elements.

### [#497](#497) Protection and [#498](#498) Retribution

- Add barebones support for Protection and Retribution, tracking Mana and Holy Power.
- Tracking Holy Power is currently being done with a workaround. This is placeholder behavior with Holy Power being part of single bar instead of individual UI elements.

## Shaman
### [#484](#484) Enhancement

- Remove experimental gating from Enhancement.

## Warlock
### [#495](#495) Demonology and [#496](#496) Destruction

- Add export buttons for Demonology and Destruction to the Import/Export screen.

## Warrior
### [#489](#489) Protection

- Remove experimental gating from Protection.
- Add export button for Protection to the Import/Export screen.

---

# 12.0.0.0-alpha12 (2025-11-23)
## [#462](#462) General

- RIP `COMBAT_LOG_EVENT_UNFILTERED`. It was commented out but all references to it have now been removed.

## Evoker
### [#471](#471) Devastation, [#472](#472) Preservation, and [#473](#473) Augmentation

- Fix implementation to allow the bar to function in a minimalist version for all three specializations.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Restore functionality for tracking Essence with a workaround. This is placeholder behavior with Essence being part of single bar instead of individual UI elements. For now, Essence regen is not displayed due to API limitations.

## Warlock
### [#486](#486) Affliction

- Fix implementation to allow the bar to function in a minimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Restore functionality for tracking Soul Shards with a workaround. This is placeholder behavior with Soul Shards being part of single bar instead of individual UI elements.

### [#495](#495) Demonology and [#496](#496) Destruction

- Add barebones support for Demonology and Destruction, tracking Mana and Soul Shards.
- Tracking Soul Shards is currently being done with a workaround. This is placeholder behavior with Soul Shards being part of single bar instead of individual UI elements.

---

# 12.0.0.0-alpha11 (2025-11-21)
## Druid
### [#469](#469) Feral

Clean up options menus to only show things that are functional.

## Monk
### [#494](#494) Brewmaster

- Add barebones support for Brewmaster, tracking Energy. Stagger coming Soon(tm).
- Options UI is...messy. Blame the vibecoder (aka me).

### [#478](#478) Windwalker

- Fix implementation to allow the bar to function in a minimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Restore functionality for tracking combo points with a workaround. This is placeholder behavior with combo points being part of single bar instead of individual UI elements.

## Rogue
### [#480](#480) Assassination, [#481](#481) Outlaw, and [#482](#482) Subtlety

- Fix implementation to allow the bar to function in a minimalist version for all three specializations.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Restore functionality for tracking combo points with a workaround. This is placeholder behavior with combo points being part of single bar instead of individual UI elements.

---

# 12.0.0.0-alpha10 (2025-11-19)
## [#462](#462) General

- Fix issues with importing and exporting settings configurations.

## Druid
### [#469](#469) Feral

- Fix implementation to allow the bar to function in a minimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Restore functionality for tracking combo points with a workaround. This is placeholder behavior with combo points being part of single bar instead of individual UI elements.
- Options UI _has not_ yet been cleaned up to only show functional features.

### [#493](#493) Guardian

- Add *bear*bones support for Guardian, tracking Rage.
- Options UI is...messy. Blame the vibecoder (aka me).

---

# 12.0.0.0-alpha09 (2025-11-18)
## Priest
### [#463](#463) Shadow

- Add support for tracking Screams of the Void via bar text variable `$sotvTime`.
- Add support for tracking Entropic Rift and its extension behavior via Darkening Horizon. This is available via bar text variables `$entropicRiftTime` and `$entropicRiftExtensionsRemaining`.
- Add an optional bar border color change when you have Entropic Rift active.
- Improve reliability of Mind Flay: Insanity tracking.

---

# 12.0.0.0-alpha08 (2025-11-17)0
## [#462](#462) General

- Restore some more granular bar value setting for non-secrets. This should help with showing timers as bars for certain abilities.
- Add a basic way of tracking buff auras in some situations.

## Warrior
### [#489](#489) Protection

- Restore Shield Block timer bar and bar text variables (including timer and charge counts).
- Restore Ignore Pain timer bar and bar text variables (timer only); add some rudimentary early loss of buff detection.
- Clean up options menus to only show things that are functional.

---

# 12.0.0.0-alpha07 (2025-11-16)
## Demon Hunter
### [#491](#491) Devourer

- Add support for Soul Fragments.
- Add Soul Fragments color change for when Void Metamorphosis is ready.
- Add Soul Fragments color change for when Collapsing Star is ready when in Void Metamorphosis.
- Adjust default bar text to be centered and include Soul Fragments.
- Fix an issue with exporting setting configurations.
- Add English localization entries for currently available feature strings.

---

# 12.0.0.0-alpha06 (2025-11-15)
## [#462](#462) General

- Enhance detection of procs or ability changes for tracking purposes.

## Demon Hunter
### [#491](#491) Devourer

- Add barebones support for Devourer, tracking Fury.
- Add threshold line for Void Ray. This will only show when Void Metamorphosis is not active.
- Add Metamorphosis tracking for bar color change. No duration is available due to API limitations, however the `$voidMeta` bar text variable has been added to indicate if Void Metamorphosis is active for Boolean logic purposes.

## Druid
### [#468](#468) Balance

- Fix an issue where Eclipse detection was not functioning consistently depending on the state of talents.

---

# 12.0.0.0-alpha05 (2025-11-14)
## [#462](#462) General

- Update large number abbreviations of resources (e.g. Mana) to use Blizzard's built-in methods that allow `secret`s to be passed into them. This has been configured to attempt to reproduce the previous 4-digit outputs as closely as possible but is not 100% identical.

## Shaman

- Fix implementations to allow the bar to function in a mimimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Clean up options menus to only show things that are functionable.

### [#483](#483) Elemental

- Restore Ascendance tracking. Add support for Preeminence.

### [#484](#484) Enhancement

- Disable Maelstrom Weapon UX elements. At the time, this is untrackable due to it being a buff and not a proper resource in the eyes of the API.
- Restore Ascendance tracking and add support for Doom Winds. Both of these use the `$ascendanceTime` bar text variable. Detection does not work when talented into Deeply Rooted Elements due to API limitations.

### [#485](#485) Restoration

- Restore Ascendance tracking. Add support for Preeminence.

---

# 12.0.0.0-alpha04 (2025-11-13)
## Druid
### [#468](#468) Balance

- Added support for Whirling Stars for calculating the duration of Eclipse when using Celestial Alignment or Incarnation: Chosen of Elune.
- Fixed an issue where Eclipse duration was not being calculated when talented into both Whirling Stars and incarnation: Chosen of Elune.
- Re-enable Soul of the Forest and Moon Guardian for predictive Astral Power from hardcasting.

## Hunter

- Fix implementations to allow the bar to function in a mimimalist version.
- Many features are disabled for now and new spells have (largely) not been implemented yet.
- Threshold likes work but are probably wrong/don't show correct use status/are missing abilities.

### [#474](#474) Beast Mastery

- Remove most of the old Barbed Shot tracking.
- Disable Bestial Wrath and Beast Cleave features until changes can be properly implemented.

### [#475](#475) Marksmanship

- Restore Trueshot tracking. Add support for Can't Miss, Won't Miss.

### [#476](#476) Survival

- Cull almost everything to reflect the changes made. You've got a Raptor Strike threshold line, what more do you *really* need?

---

# 12.0.0.0-alpha03 (2025-11-11)
## General

- [#462 - FIX](#462) The following specializations are now functional again to varying degrees:
<br/>&emsp;&ensp;- Demon Hunter: Havoc, Vengeance
<br/>&emsp;&ensp;- Druid: Balance, Restoration
<br/>&emsp;&ensp;- Monk: Mistweaver
<br/>&emsp;&ensp;- Priest: Discipline, Holy, Shadow
<br/>&emsp;&ensp;- Warrior: Arms, Fury
- [#462 - UPDATE](#462) Updated implementations for the following due to API changes:
<br/>&emsp;&ensp;- Continue to use `UnitPowerMax()` as it is no longer `secret`.
<br/>&emsp;&ensp;- Adjusted spell cast handling to avoid `secret` values from `UNIT_SPELLCAST_CHANNEL_*` events. This is likely a bug that will be fixed in a future beta build.
<br/>&emsp;&ensp;- Hide or manually override (disable) many options that are no longer functional due to API changes.
<br/>&emsp;&ensp;- Improve spell usable state detection.
<br/>&emsp;&ensp;- Update threshold line rendering to use some alternate approaches to avoid computations with `secret` values. 
<br/>&emsp;&ensp;- Disable all passive tracking and related threshold lines.
<br/>&emsp;&ensp;- Disable most bar and border color changes.
<br/>&emsp;&ensp;- Disable bar text variables that are no longer functional. Some of these ability icons remain for now.
<br/>&emsp;&ensp;- Remove DoT tracking.
<br/>&emsp;&ensp;- Adjusted default bar text to reflect current functionality.

### Healers

- [#490 - UPDATE](#490) Removed the following functionality due to API changes:
<br/>&emsp;&ensp;- Passive mana generation tracking from Symbol of Hope, Blessing of Winter, Innervate, Mana Tide Totem, Molten Radiance, and channeled mana potions.
<br/>&emsp;&ensp;- Mana potions and their cooldown tracking.
<br/>&emsp;&ensp;- Thresholds for spells that restore mana.
<br/>&emsp;&ensp;- Change mana text formatting to use Blizzard's built-in formatting of large numbers.

## Demon Hunter
### Havoc

- [#466 - UPDATE](#466) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Metamorphosis detection. This re-enabled bar color change, end of color change, bar text, and Metamorphosis specific threshold lines.
<br/>&emsp;&ensp;- Remove Fel Eruption.

### Vengeance

- [#467 - UPDATE](#467) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Disable Soul Fragment bars since they can no longer be easily tracked.
<br/>&emsp;&ensp;- Fix Metamorphosis detection. This re-enabled bar color change, end of color change, and bar text.
<br/>&emsp;&ensp;- Remove Fel Eruption.

## Druid
### Balance

- [#468 - UPDATE](#468) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Eclipse detection. This re-enabled bar color change, end of color change, and bar text for Eclipse (Solar), Eclipse (Lunar), Celestial Alignment, and Incarnation: Chosen of Elune.
<br/>&emsp;&ensp;- Boomkin Form detection is not presently working.

### Restoration

- [#470 - UPDATE](#470) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Incarnation: Tree of Life detection. This re-enabled bar color change, end of color change, and bar text.
<br/>&emsp;&ensp;- Fix and update Efflorescence detection. Add support for the new Lifetreading talent.

## Monk
### Mistweaver

- [#477 - UPDATE](#477) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Mana tea is disabled but may make a return.
<br/>&emsp;&ensp;- Vivacious Vivification and Spirit of the Jade Serpent detection is disabled but may make a return.

## Priest
### Discipline

- [#465 - UPDATE](#465) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Disable Power Word bars since they can no longer be easily tracked.

### Holy

- [#464 - UPDATE](#465) In addition to items listed above under **General** and **Healers**, the following changes have been made:
<br/>&emsp;&ensp;- Disable Holy Word bars since they can no longer be easily tracked.

### Shadow

- [#463 - UPDATE](#463) In addition to items listed above under **General**, the following changes have been made:
<br/>&emsp;&ensp;- Fix Mind Devourer detection. This re-enabled bar border color change, bar text, audio cues, and Shadow Word: Madness threshold lines color change.
<br/>&emsp;&ensp;- Fix Mind Flay: Insanity detection. This re-enabled bar border color change, audio cues, and bar text.
<br/>&emsp;&ensp;- Disable Voidform tracking for now since it can no longer be easily tracked. This may make a return in the future.

## Warrior
### Arms

- [#487 - UPDATE](#487) Barebones updates to make Arms functional again.

### Fury

- [#488 - UPDATE](#488) Barebones updates to make Fury functional again.

---

# 12.0.0.0-alpha02 (2025-10-27)
## General

- [#462 - FIX](#462) Disable smooth bar updates due to Lua errors with secrets.

---

# 12.0.0.0-alpha01 (2025-10-27)
## General

- [#462 - NEW](#462) Reports of my demise have been greatly exaggerated. The Resource Bar lives on!
- [#462 - NEW](#462) Most specs are still bricked, but I am working on unbricking them one at a time with Shadow Priest as the guinea pig.
- [#462 - UPDATE](#462) Strip out all calls to things related to specific targets and `UNIT_AURA`. 
- [#462 - UPDATE](#462) Change how max resource is determined to be based off of talents and hardcoded values.
- [#462 - UPDATE](#462) Adjust bar and threshold rendering to not do computations with `secret` values.

## Priest
### Shadow

- [#463 - UPDATE](#462) Strip out everything but Shadow Word: Madness and resource detection.
- [#463 - UPDATE](#462) Track if Voidtouched is talented and adjust the maximum resource accordingly.
- [#463 - UPDATE](#462) Clean up default bar text since most of the old variables don't work anymore (yet?).

]====]

local newsFrame = CreateFrame("Frame", "TRB_News_Frame", UIParent, "BackdropTemplate")
newsFrame:SetFrameStrata("DIALOG")
local isConstructed = false

function TRB.Functions.News:BuildNewsPopup()
	isConstructed = true
	TRB.Functions.News:Hide()
	---@diagnostic disable-next-line: missing-fields
	newsFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile =  "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	})
	newsFrame:SetBackdropColor(0, 0, 0, 0.5)
	newsFrame:SetWidth(650)
	newsFrame:SetHeight(480)
	newsFrame:SetPoint("CENTER", UIParent)

	local newsPanelParent = TRB.Functions.OptionsUi:CreateTabFrameContainer("TRB_News_Frame_Panel", newsFrame, 640, 410)
	local newsPanel = newsPanelParent.scrollFrame.scrollChild
	newsPanelParent:SetBackdropColor(0, 0, 0, 1)
	newsPanelParent:ClearAllPoints()
	newsPanelParent:SetPoint("TOPLEFT", 5, -30)

	TRB.Functions.OptionsUi:BuildSectionHeader(newsFrame, L["NewsHeaderTwintopsResourceBarUpdates"], oUi.xCoord, 0)
	local closeButton = TRB.Functions.OptionsUi:BuildButton(newsFrame, L["Close"], 510, -10, 100, 25)
	closeButton:ClearAllPoints()
	closeButton:SetPoint("BOTTOMRIGHT", -5, 5)
	closeButton:SetScript("OnClick", function(self, ...)
		TRB.Functions.News:Hide()
	end)

	---@type CheckButton
	local f = CreateFrame("CheckButton", "TwintopResourceBar_News_ShowAgain", newsFrame, "ChatConfigCheckButtonTemplate")
	f:SetPoint("BOTTOMLEFT", 5, 5)
	getglobal(f:GetName() .. 'Text'):SetText(L["NewsCheckboxShowOnNewVersion"])
---@diagnostic disable-next-line: inject-field
	f.tooltip = L["NewsCheckboxShowOnNewVersionTooltip"]
	f:SetChecked(TRB.Data.settings.core.news.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.news.enabled = self:GetChecked()
	end)

	local simpleHtml = CreateFrame("SimpleHTML", "TRB_News_HTML_Frame", newsPanel)
	simpleHtml:SetPoint("TOPLEFT", newsPanel, "TOPLEFT", 5, -5)
	simpleHtml:SetPoint("BOTTOMRIGHT", newsPanel, "BOTTOMRIGHT", 5, -35)
	simpleHtml:SetWidth(600)
	
---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h1", "SubzoneTextFont")
	simpleHtml:SetTextColor("h1", 0, 0.6, 1, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h2", "Fancy22Font")
	simpleHtml:SetTextColor("h2", 0, 1, 0, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("h3", "NumberFontNormalLarge")
	simpleHtml:SetTextColor("h3", 0, 0.8, 0.4, 1)

---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetFontObject("p", "GameFontNormal")
	simpleHtml:SetTextColor("p", 1, 1, 1, 1)

	simpleHtml:SetHyperlinkFormat("[|cff3399ff|H%s|h%s|h|r]")

	simpleHtml:SetScript("OnHyperlinkClick", 
		function(f, link, text, ...)
			if link=="window:close" then
				TRB.Functions.News:Hide()
			elseif link:match("https?://") then
				StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = text, url = link })
			elseif link:match("^#%d+$") then
				local issueId = string.sub(link, 2)
				local url = "https://github.com/Twintop/TwintopInsanityBar/issues/" .. issueId
				local titleText = string.format(L["NewsHyperlinkViewIssueOnGitHub"], link)
				StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = titleText, url = url })
			end 
		end)

	simpleHtml:SetScript("OnHyperlinkEnter", function(f) SetCursor("Interface\\CURSOR\\vehichleCursor.PNG") end)
---@diagnostic disable-next-line: param-type-mismatch
	simpleHtml:SetScript("OnHyperlinkLeave", function(f) SetCursor(nil)									 end)

	simpleHtml:SetText(LMD:ToHTML(content))
	-- ... and this is the popup it opens.
	StaticPopupDialogs["LIBMARKDOWNDEMOFRAME_URL"] = {
		OnShow = function(self, data)
			self:SetWidth(450)
			self.SetFormattedText(string.format(L["NewsHyperlinkGeneric"], data.title))
			self.GetEditBox():SetText(data.url)
			self.GetEditBox():SetAutoFocus(true)
			self.GetEditBox():HighlightText()
		end,
		OnAccept = function(self)
			self:Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		text = "",
		button1 = L["OK"],
		hasEditBox = true,
		hasWideEditBox = true,
		editBoxWidth = 400,
		timeout = 60,
		whileDead = true,
		closeButton = true,
		hideOnEscape = true
	}
end

function TRB.Functions.News:Hide()
	newsFrame:Hide()
end

function TRB.Functions.News:Show()
	if not isConstructed then
		TRB.Functions.News:BuildNewsPopup()
	end

	if TRB.Data.settings.core.news.lastUpdate ~= TRB.Details.addonVersion then
		TRB.Data.settings.core.news.lastUpdate = TRB.Details.addonVersion
	end
	newsFrame:Show()
end

function TRB.Functions.News:Init()
	if TRB.Data.settings.core.news.enabled and TRB.Data.settings.core.news.lastUpdate ~= TRB.Details.addonVersion then
		TRB.Functions.News:Show()
	end
end