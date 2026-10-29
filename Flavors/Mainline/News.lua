local _, TRB = ...

-- Mainline changelog shown by the News window (Core\Functions\News.lua renders it). Markdown; newest
-- release first. Each flavor ships its own changelog because their class rosters and release lines differ.
TRB.Flavor.newsContent = [====[

*Localization of the addon is still underway! If you have any interest in helping translate, please [join the Discord server](https://discord.gg/eThqxM78xm) and let Twintop know. Thank you!*

---

# 12.1.5.8-release (2026-10-29)
## General
### Skyriding

- [#905](#905) Fix the Skyriding bars turning back on after answering No to the Skyriding bars prompt, in profiles that are reset, made with Use Baseline, or imported from strings exported before 12.1.5.4-release.

## Death Knight
### Blood

- [#279](#279) Fix the Raise Ally threshold line not showing its cooldown.

### Frost

- [#279](#279) The Glacial Advance threshold line is on by default and is never out of range.
- [#279](#279) Remove the Breath of Sindragosa threshold line's separate cooldown timer.

### Unholy

- [#279](#279) Fix the Raise Ally and Zombify threshold lines not showing their cooldowns.
- [#279](#279) The Epidemic threshold line is never out of range.
- [#279](#279) Remove unused Unholy Assault spell data.

## Demon Hunter
### Vengeance

- [#279](#279) Fix the Spirit Bomb threshold line not showing its cooldown.

### Devourer

- [#279](#279) Fix the Collapsing Star threshold line using the wrong spell.

## Druid

- Fix Balance, Guardian, and Restoration threshold lines getting stuck in or out of range in Cat Form when only Feral is set to recolor or hide out of range lines.

### Feral

- [#279](#279) The Primal Wrath threshold line is never out of range.

### Guardian

- [#279](#279) Fix the Frenzied Regeneration threshold line not tracking Innate Resolve's second charge.

### Restoration

- [#279](#279) Fix the Frenzied Regeneration threshold line not tracking Call of the Elder Druid's second charge.

## Hunter
### Beast Mastery

- [#279](#279) Fix the Kill Command threshold line not tracking Alpha Predator's second charge.
- [#279](#279) The Dire Beast: Hawk threshold line is never out of range.

### Marksmanship

- [#279](#279) Fix the Black Arrow and Kill Shot threshold lines not tracking Deadeye's second charge.
- [#279](#279) Remove the Explosive Shot threshold line's separate cooldown timer.

### Survival

- [#279](#279) The Boomstick threshold line follows Boomstick's range.
- [#279](#279) Remove the Flamefang Pitch threshold line.

## Monk
### Brewmaster

- [#279](#279) Fix the Detox threshold line showing a cooldown after a cast that dispels nothing.
- [#279](#279) Fix the Keg Smash threshold line not showing its cooldown.
- [#279](#279) The Tiger Palm threshold line follows Tiger Palm's range.
- [#279](#279) The Tiger Palm threshold line hides with Press the Advantage, which replaces Tiger Palm.
- [#279](#279) Remove the Crackling Jade Lightning, Detox, Expel Harm, and Paralysis threshold lines' separate cooldown timers.
- [#279](#279) Remove unused Ancient Arts and Jade Flash spell data.
- Fix threshold lines getting stuck in or out of range after a loading screen, talent change, or specialization change.

### Windwalker

- Fix threshold lines getting stuck in or out of range after a loading screen, talent change, or specialization change.

## Rogue

- [#279](#279) Fix the Cheap Shot threshold line not showing its cooldown.

### Assassination

- [#279](#279) Remove the Shiv threshold line's charge tracking.

### Outlaw

- [#279](#279) Fix the Restless Blades threshold line color not showing.
- [#279](#279) Fix the Roll the Bones threshold line and `#rollTheBones` icon using an old version of the ability.
- [#895](#895) Remove Broadside, Buried Treasure, Grand Melee, Ruthless Precision, Skull and Crossbones, and True Bearing tracking and the `#broadside`, `#buriedTreasure`, `#grandMelee`, `#ruthlessPrecision`, `#skullAndCrossbones`, and `#trueBearing` icons.
- [#895](#895) Remove the special ability threshold line color from Sinister Strike for Skull and Crossbones and from Between the Eyes for Ruthless Precision.

### Subtlety

- [#279](#279) Fix the Cheap Shot threshold line not tracking Shot in the Dark's second charge.
- [#279](#279) Fix the Goremaw's Bite threshold line using the wrong spell.
- [#909](#909) Remove the Shadow Techniques stored combo point color from the combo point bar.

## Warrior

- [#279](#279) Remove Shield Block's separate cooldown refresh.

### Arms

- [#279](#279) Fix the Execute threshold lines not tracking Execute's cooldown without Improved Execute.
- [#279](#279) The Whirlwind threshold line is never out of range.
- [#279](#279) Remove the Ignore Pain threshold line.
- Fix the Execute threshold lines hiding while you're short on Rage or channeling, such as Demolish.

### Fury

- [#279](#279) Fix the Execute threshold lines using Massacre's version of the ability.
- Fix the Execute (Maximum) threshold line never showing with Improved Execute.

### Protection

- [#279](#279) Remove the Rend threshold line and `#rend` icon.
- Fix the Execute threshold lines hiding while you're short on Rage or channeling, such as Demolish.

---

# 12.1.5.7-release (2026-10-25)
## General
### Skyriding

- Fix the Skyriding bars staying hidden until a reload after answering the Skyriding bars prompt as a Balance, Feral, or Guardian Druid.

## Death Knight
### Blood

- [#872](#872) Fix the Bone Shield bar's End Cap keeping its own color, with Only non-default border colors checked, while a gradient Color Indicator recolors the border.

## Druid

- [#871](#871) Fix `$energy`, `$rage`, and `$astralPower` bar text losing the overcap color while the resource holds steady, such as at cap.
- [#871](#871) Fix `$resource` and `$resourceMax` bar text switching to the specialization's own resource while in another form, such as Energy while in Bear Form.
- [#871](#871) Fix Balance's Energy and Rage bar text disappearing after entering or leaving combat in Cat Form or Bear Form.

## Mage
### Arcane

- [#584](#584) Fix the Arcane Salvo bar's stack ranges keeping their own texture when Use the same bar texture for all bars is checked.

### Frost

- Fix Fingers of Frost losing count when Ice Lance is queued behind Glacial Spike, leaving its Color Indicators on with no charges up, or off with one up.
- Fingers of Frost tracking corrects itself when a charge is gained as you spend one.

## Monk
### Brewmaster

- [#867](#867) Improve Stagger bar and stagger bar text update performance.

### Windwalker

- [#885](#885) Add Hit Combo tracking, with a Hit Combo Color Indicator, Hit Combo stack Audio Cues, the `$hitComboStacks` and `$hitComboTime` bar text variables, and the `#hitCombo` icon. The indicator defaults to the Energy bar border, and only turns on at the stack count set on the Indicator Colors tab.

## Priest
### Discipline

- [#584](#584) Fix the Power Word Radiance checkbox redrawing the bars with this specialization's settings while they use the global settings.
- Surge of Light tracking corrects itself when a stack is gained as you spend one.

### Holy

- Surge of Light tracking corrects itself when a stack is gained as you spend one.

### Shadow

- [#888](#888) Fix a Lua error from casting Shadow Word: Madness just as Voidform ends, with Ancient Madness talented.
- [#888](#888) Fix Halo and Power Surge briefly restarting Voidform when they land just as it ends, with Sustained Potency talented.

## Shaman
### Enhancement

- [#584](#584) Fix the Maelstrom Weapon compressed view checkbox redrawing the bar with this specialization's settings while it uses the global settings.

---

# 12.1.5.6-release (2026-10-23)
## General
### Skyriding

- Fix choosing No on the Skyriding bars prompt leaving them enabled for specializations not using the global Visibility settings.
- Existing users are asked again, with an option to leave their settings as they are.

---

# 12.1.5.5-release (2026-10-23)
## General
### Skyriding

- [#854](#854) Add new Skyriding Speed, Skyriding Charges, Whirling Surge, and Second Wind bars on a new Skyriding tab, with `$skyridingSpeed`, `$skyridingCharges`, `$skyridingChargesMax`, `$skyridingChargeTime`, `$whirlingSurgeTime`, `$secondWindCharges`, `$secondWindChargesMax`, `$secondWindTime`, `$thrillOfTheSkies`, `$groundSkimming`, `$staticChargeStacks`, and `$staticChargeTime` bar text and `#surgeForward`, `#whirlingSurge`, `#lightningRush`, `#secondWind`, `#thrillOfTheSkies`, `#groundSkimming`, and `#staticCharge` icons, shown while Skyriding except Second Wind, which is set to Never Show by default.
- [#854](#854) Skyriding Speed fills toward your zone's top speed, Skyriding Charges and Second Wind fill one segment per charge, and Whirling Surge fills as its cooldown, or Lightning Rush's, runs out.
- [#854](#854) They join the bar text Relative to Frame list, with each recharging charge as a target of its own, but not the Color Indicator or custom threshold line lists.
- [#854](#854) Existing users are asked once whether to enable the Skyriding bars.

---

# 12.1.5.5-release (2026-10-23)

Removed.

---

# 12.1.5.3-release (2026-10-21)
## Priest
### Holy

- [#853](#853) Fix Holy Word custom threshold lines sitting at the wrong position while a Holy Word recharges.

---

# 12.1.5.2-release (2026-10-15)
## General
### Audio Cues

- [#849](#849) Add an Audio Cues tab for every Death Knight specialization, every Demon Hunter specialization, Guardian and Restoration Druid, Marksmanship Hunter, Brewmaster and Mistweaver Monk, Restoration Shaman, and Arms and Fury Warrior.

## Demon Hunter
### Devourer

- [#850](#850) The Collapsing Star threshold audio cue plays while the Soul Fragments bar or its threshold line is hidden.

## Druid
### Balance

- [#850](#850) The Starsurge Ready and Starfall Ready audio cues play while the Astral Power bar is hidden, and in every form.

### Feral

- [#850](#850) The Apex Predator's Craving Proc audio cue plays while the Energy bar is hidden, and in every form.

## Evoker

- [#850](#850) The Essence threshold audio cues play while every bar is hidden.

## Paladin

- [#849](#849) Remove the Holy Power threshold alerts' separate in-combat check.

### Holy

- [#850](#850) The Infusion of Light audio cue plays while every bar is hidden.

## Priest
### Holy

- [#849](#849) Remove the Holy Word audio cues' separate in-combat check.

### Shadow

- [#850](#850) The Shadow Word: Madness Ready and Mind Devourer Proc audio cues play while the Insanity bar is hidden.

## Rogue

- [#849](#849) Remove the Combo Point threshold alerts' separate in-combat check.

## Shaman
### Elemental

- [#850](#850) The Earth Shock Ready audio cue plays while the Maelstrom bar is hidden.

## Warlock

- [#849](#849) Remove the Soul Shard threshold alerts' separate in-combat check.

---

# 12.1.5.1-release (2026-10-14)
## Demon Hunter
### Devourer

- [#847](#847) Fix Color Indicators not coloring the Soul Fragments bar's End Cap.

## Priest
### Holy

- [#847](#847) Fix Color Indicators not coloring the Mana, Holy Words, and Lightweaver bars' End Caps.
- [#847](#847) The Holy Words bar shows an End Cap for each Holy Word instead of one for the whole bar.
- [#847](#847) Replace the Holy Words bar's End Cap Color Indicator target with End Cap (Serenity), End Cap (Sanctify), and End Cap (Chastise), and move existing End Cap targets to all three.

## Shaman
### Enhancement

- [#847](#847) Fix Color Indicators not coloring the Maelstrom Weapon bar's End Cap.

## Warrior
### Fury

- [#847](#847) Fix Color Indicators not coloring the Rage bar's End Cap.
- [#847](#847) Fix the Enrage Color Indicator not coloring the Whirlwind bar.
- [#847](#847) The Rage bar follows the Color Indicator priority order between Enrage and Zero Stacks.
- [#847](#847) Remove the Rage and Whirlwind bars' separate Enrage and Zero Stacks color handling.

### Protection

- [#847](#847) Fix Color Indicators not coloring the Rage bar's End Cap.
- [#847](#847) Fix the Violent Outburst Color Indicator not coloring the Ignore Pain and Shield Block bars.
- [#847](#847) Remove the Rage bar's separate Color Indicator handling.

---

# 12.1.5.0-release (2026-10-12)
## Druid
### Balance

- Add a Touch the Cosmos Color Indicator, for when Starsurge or Starfall is free to cast. It targets the Astral Power bar border by default.

## Mage
### Fire

- [#763](#763) Add Combustion tracking, with active and ending Color Indicators, the `$combustionTime` bar text variable, and the `#combustion` icon. The indicators target the Mana bar fill by default.
- [#763](#763) Add a default `$combustionTime` bar text entry for new and reset bar text.
- [#763](#763) Add Hot Streak tracking, with a Color Indicator, an audio cue, the `$hotStreakTime` bar text variable, and the `#hotStreak` icon. The indicator targets the Mana bar border by default.
- [#763](#763) Add Heating Up tracking, with a Color Indicator, an audio cue, the `$heatingUpTime` bar text variable, and the `#heatingUp` icon. The indicator targets the Mana bar border by default.
- [#763](#763) Add Frostfire Empowerment tracking, with a Color Indicator, an audio cue, the `$frostfireEmpowermentTime` bar text variable, and the `#frostfireEmpowerment` icon. The indicator targets the Mana bar border by default.

### Frost

- [#763](#763) Add Frostfire Empowerment tracking, with a Color Indicator, an audio cue, the `$frostfireEmpowermentTime` bar text variable, and the `#frostfireEmpowerment` icon. The indicator targets the Mana bar border by default.

## Paladin
### Retribution

- [#822](#822) Add Execution Sentence tracking, with a Color Indicator, the `$esTime` bar text variable, and the `#es` icon. The indicator targets the Holy Power border by default.
- [#822](#822) Add Judge, Jury and Executioner tracking, with the `$jjeTime` bar text variable and the `#jje` icon.
- [#822](#822) Add a Refunded Holy Power color, marking the 3 Holy Power your next spender refunds while Judge, Jury and Executioner is active at 3 or more Holy Power.
- Add Avenging Wrath tracking, with active and ending Color Indicators, an audio cue, the `$awTime` bar text variable, and the `#aw` icon. The indicators target the Holy Power border by default.
- Add Avenging Wrath Source dropdowns for the Color Indicators and the audio cue, choosing between Avenging Wrath casts, Radiant Glory, or both.

## Shaman
### Elemental

- [#841](#841) Add Tempest tracking, with 1 and 2 charge Color Indicators and audio cues, the `$tempestStacks`, `$tempestStacksMax`, and `$tempestTime` bar text variables, and the `#tempest` icon. The indicators target the Maelstrom bar border by default. The 2 charge indicator and cue, `$tempestStacks`, and `$tempestTime` require CDM to be enabled and Tempest to be actively tracked.
- [#841](#841) Add the `$stormkeeperStacks`, `$stormkeeperStacksMax`, and `$stormkeeperTime` bar text variables.
- [#841](#841) Predict the Maelstrom a Tempest cast generates when Stormwell and Arc Discharge are talented and Stormkeeper is down.
- [#841](#841) Midnight Season One 4-Piece: Account for the extra Stormkeeper charge and the higher charge cap.
- Fix a Lua error when casting Stormkeeper.

### Enhancement

- [#841](#841) Add Tempest tracking, with 1 and 2 charge Color Indicators and audio cues, the `$tempestStacks`, `$tempestStacksMax`, and `$tempestTime` bar text variables, and the `#tempest` icon. The indicators target the Maelstrom Weapon bar border by default. The 2 charge indicator and cue, `$tempestStacks`, and `$tempestTime` require CDM to be enabled and Tempest to be actively tracked.

---

# 12.1.0.19-release (2026-10-10)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 12.1.0.18-release (2026-10-09)
## General
### Core Changes

- See [Core Changes](tab:core).

## Druid
### Guardian

- Fix the Cast Bar and other bars moving out of place outside Bear Form.

---

# 12.1.0.17-release (2026-10-07)
## General
### Core Changes

- See [Core Changes](tab:core).

### Cast Bars

- Add channel tick markers for bandages and Regeneratin'.

## Death Knight
### Blood

- [#836](#836) Add the `$boneShieldTime` bar text variable. Requires CDM to be enabled and Bone Shield to be actively tracked.

### Unholy

- Fix `$runicCorruptionTime` not counting down out of combat while all runes are ready.

## Demon Hunter
### Havoc

- Fix Eye Beam and Abyssal Gaze channel tick markers not matching Blind Fury's rank.

### Vengeance

- Fix Fel Devastation's channel tick markers not adding ticks with haste.

## Druid
### Balance

- Fix Convoke the Spirits channel tick markers ignoring Astral Insight.
- Fix `$starfallTime` and `$starfallNextStackTime` not counting down out of combat.

### Feral

- Fix `$halazzisFuryTime` not counting down out of combat.

### Guardian

- Fix Convoke the Spirits channel tick markers ignoring Astral Insight.
- Add channel tick markers for Emerald Slumber.
- Fix `$ironfurTime` and `$ironfurNextStackTime` not counting down out of combat.

### Restoration

- Fix Tranquility showing 6 channel tick markers instead of 7, the first at the start of the channel.

## Evoker
### Devastation

- Fix Disintegrate channel tick markers ignoring Azure Celerity and missing the tick at the start of the channel.

### Preservation

- Fix Disintegrate channel tick markers missing the tick at the start of the channel.

### Augmentation

- Fix Disintegrate channel tick markers missing the tick at the start of the channel.

## Hunter

- Add Pet Cast Bar channel tick markers for Froststorm Breath, Burrow Attack, and Feast.

### Marksmanship

- Fix `$doubleTapTime` not counting down out of combat.

## Mage
### Arcane

- [#838](#838) Add Clearcasting tracking, with 1, 2, and 3 stack Color Indicators and audio cues, the `$clearcastingStacks`, `$clearcastingStacksMax`, and `$clearcastingTime` bar text variables, and the `#clearcasting` icon. The indicators target the Mana bar border by default, and `$clearcastingTime` requires CDM to be enabled and Clearcasting to be actively tracked.
- Add Prismatic Bolt tracking, with a Color Indicator, an audio cue, the `$prismaticBoltTime` bar text variable, and the `#prismaticBolt` icon. The indicator targets the Mana bar border by default.
- Add Overpowered Missiles tracking, with a Color Indicator, an audio cue, the `$overpoweredMissilesTime` bar text variable, and the `#overpoweredMissiles` icon. The indicator targets the Mana bar border by default, above Prismatic Bolt and Clearcasting, and `$overpoweredMissilesTime` requires CDM to be enabled and Overpowered Missiles to be actively tracked.
- Fix `$arcaneSurgeTime` not counting down out of combat.
- Add channel tick markers for Evocation and Arcanosphere.
- Fix Kleptomania showing 8 channel tick markers instead of 9, the first at the start of the channel.

### Frost

- Add Pet Cast Bar channel tick markers for Water Jet.
- Fix `$brainFreezeTime` not counting down out of combat.

## Monk

- Fix Spinning Crane Kick channel tick markers missing the tick at the start of the channel.

### Brewmaster

- Fix Spinning Crane Kick not showing channel tick markers.

### Mistweaver

- Add channel tick markers for Celestial Conduit.

### Windwalker

- Add channel tick markers for Fists of Fury and Celestial Conduit.

## Priest
### Discipline

- Add channel tick markers for Ultimate Penitence.
- Fix `$voidShieldTime` and `$harshDisciplineTime` not counting down out of combat.

## Warlock

- Add channel tick markers for Health Funnel.
- Fix `$shardInstabilityTime`, `$demonicCoreTime`, `$doaTime`, `$infernalBoltTime`, and `$ruinationTime` not counting down out of combat.

### Demonology

- [#840](#840) Add Demonic Art tracking, with a Color Indicator, an audio cue, the `$demonicArtTime` bar text variable, and the `#demonicArt` icon. The indicator targets the Soul Shard borders by default, above Demonic Core. Requires CDM to be enabled and Demonic Art (listed as Diabolic Ritual) to be actively tracked.
- Add the `$diabolicRitualTime` bar text variable and the `#diabolicRitual` icon. Requires CDM to be enabled and Diabolic Ritual to be actively tracked.

## Warrior
### Protection

- Fix `$voTime` not counting down out of combat.

---

# 12.1.0.16-release (2026-10-06)
## General
### Core Changes

- See [Core Changes](tab:core).

### Pet Bars

- [#551](#551) Available to every Hunter and Warlock specialization, Unholy Death Knight, and Frost Mage. Hidden without Unbreakable Bond on Marksmanship, or Summon Water Elemental on Frost.

## Druid
### Guardian

- Fix the Ironfur bar not following its anchor outside Bear Form.

---

# 12.1.0.15-release (2026-10-03)
## General
### Core Changes

- See [Core Changes](tab:core).

---

# 12.1.0.14-release (2026-09-29)
## Rogue
### Assassination

- Cheap Shot's threshold line uses the below color when it can't be cast.

### Outlaw

- Cheap Shot's threshold line uses the below color when it can't be cast.
- Fix threshold lines for stealth abilities ignoring Use Global colors while Subterfuge is active.

## Shaman
### Elemental

- Add a new Elemental Blast Buffs bar, tracking the time remaining on each Elemental Blast buff, with default `$ebCritTime`, `$ebHasteTime`, and `$ebMasteryTime` bar text. Requires CDM to be enabled and the buffs to be actively tracked to function. Set to Never Show by default; enable it under Bar Visibility.
- Each buff fills its own node, and nodes can be reordered or disabled. Hidden without Elemental Blast talented.
- Joins the bar text Relative to Frame and Color Indicator target lists. Does not offer End Cap, Smooth, or custom thresholds.

## Warrior
### Fury

- Threshold lines for abilities on cooldown use the unusable color.

---

# 12.1.0.13-release (2026-09-28)
## General

- Fix deleted default bar text for the Bone Shield, Coagulating Blood, Shatter, Arcane Salvo, Ebon Might, Enrage, and Ironfur bars being added back on the next login.

## Evoker
### Devastation

- Add a new Dragonrage bar, tracking the time remaining on Dragonrage, with a default `$dragonrageTime` bar text. Set to Never Show by default; enable it under Bar Visibility.
- The bar's scale is Dragonrage's full duration, including time added by Animosity.
- Joins the bar text Relative to Frame and Color Indicator target lists. Does not offer custom thresholds.

## Priest

- Fix the Angelic Feather bar being called Utility in bar anchoring, Edit Mode, and Global Options Bar Visibility.

## Warrior
### Fury

- Fix the Whirlwind charge bar text being added a second time on a new install.

---

# 12.1.0.12-release (2026-09-20)
## General

- Refactor the addon to be a bit more flavor agnostic. From now on, only changes relating to the mainline flavor will be listed here. Changes that impact the Core infrastructure will go in the new Core news tab.

### Core Changes

- See [Core Changes](tab:core).

---

# 12.1.0.11-release (2026-09-20)
## General

- [#837](#837) Fixed an issue where predictive resource spending would not show up for Mana bar users.
- Fix Color Indicators added in a newer version sometimes missing from the Color Indicator Priority list when the saved list still carried an indicator that no longer exists.

### Localization

- [#839 - @MOSS099](#839) Updated translations for Simplified Chinese (zhCN).

## Priest
### Shadow

- [#828](#828) Fix Resonant Energy color indicator not always being added to the list on version update.

## Shaman
### Elemental

- Add predictive resource generation for Stormkeeper when talented into Stormwell.
- Add predictive resource spending for hardcasted Elemental Blast.

## Warlock
### Demonology

- Fix Ruination always predicting a Soul Shard gain. It now only predicts the refunded Soul Shard while Dominion of Argus is active and talented at 4/4.

---

# 12.1.0.10-release (2026-09-09)
## General
### Localization

- [#829 - @MOSS099](#829) Updated translations for Simplified Chinese (zhCN).
- [#835 - @MOSS099](#835) Updated translations for Simplified Chinese (zhCN).

## Druid

- Fix Combo Point audio cues never firing outside the Feral specialization. They are configured on Feral's Audio Cues tab and apply to all specializations.

## Mage
### Arcane

- [#833](#833) Ensure that Arcane Salvo's maximum stack count is 20 when Spellfire Salvo is not talented.

### Frost

- [#834](#834) Change Shatter color at Ice Lance stacks now marks 6, 12, and 18 when Polished Focus is talented.
- [#834](#834) Add two Shatter custom indicators, each recoloring a single stack of your choosing and set to Disabled, Spellslinger Only, Frostfire Only, or Enabled. The first defaults to stack 12 for Frostfire.

## Priest
### Shadow

- [#828](#828) Add Resonant Energy tracking, with a Resonant Energy Color Indicator, the `$resonantEnergyStacks` and `$resonantEnergyTime` bar text variables, and the `#resonantEnergy` icon. The indicator defaults to the Insanity bar border, and only turns on at the stack count set on the Indicator Colors tab.
- [#829](#829) Add Void Volley stack tracking, with the `$voidVolleyCharges` and `$voidVolleyTime` bar text variables and `#vv` icon.

---

# 12.1.0.9-release (2026-09-03)
## General

- [#745](#745) Add a Glows tab to Global Options: named glow definitions, each with a style (Pixel Glow, Autocast Shine, Action Button Glow, Proc Glow), its own settings and a live preview.
- [#745](#745) Add Border Glow as a Color Indicator target on every bar, with a submenu that runs any number of the defined glows at once. A glow set to always use its own color takes that color instead of the indicator's, and is marked in the list.
- Fix the End Cap trailing a couple of pixels behind the fill edge on the cast bars, and on any other bar the client animates, which left a sliver of the bar showing past the cap.

### Localization

- [#826 - @MOSS099](#826) Updated translations for Simplified Chinese (zhCN).
- [#827 - @MOSS099](#827) Updated translations for Simplified Chinese (zhCN).

---

# 12.1.0.8-release (2026-09-02)
## General

- Single-node bars whose value is a secret stack count now offer End Cap options. For now, only affects the Coagulating Blood bar for Blood Death Knights.
- Ensure the "Smooth Bar Animation" option works correctly on class-specific bars, such as Icicles, Shatter and Arcane Charges.

### Localization

- [#818 - @MOSS099](#818) Updated translations for Simplified Chinese (zhCN).
- [#824 - @MOSS099](#824) Updated translations for Simplified Chinese (zhCN).

## Death Knight

- Add Rune (Regenerating) as a Color Indicator target, covering the runes currently recharging. The Rune target is now Rune (Off Cooldown) and covers only the runes that are ready.

### Blood

- [#815](#815) Add a Vampiric Strike Color Indicator, active while Vampiric Strike is replacing Heart Strike or Scourge Strike. Defaults to the Runic Power bar border.

### Unholy

- [#815](#815) Add a Runic Corruption Color Indicator, the `$runicCorruptionTime` bar text variable and the `#runicCorruption` icon. Color Indicator change targets Rune (Regenerating) by default. Requires Runic Corruption in the Cooldown Manager's Tracked Buffs.
- [#815](#815) Add a Vampiric Strike Color Indicator, active while Vampiric Strike is replacing Heart Strike or Scourge Strike. Defaults to the Runic Power bar border.

## Druid
### Guardian

- [#765](#765) Add a new Ironfur bar, tracking each Ironfur application on its own timer, with a threshold line per application that slides along the bar as it expires. Adds the `$ironfurStacks`, `$ironfurTime` and `$ironfurNextStackTime` bar text variables and the `#ironfur` icon.
- [#765](#765) Fill is the time until every application has expired. Scale is set on each Ironfur cast, holding at a longer application's duration while it is still running. Ursoc's Endurance and Guardian of Elune are included in each application's duration.

## Mage
### Arcane

- [#820](#820) Add Arcane Surge tracking, with Arcane Surge and Arcane Surge Ending Color Indicators, the `$arcaneSurgeTime` bar text variable and the `#arcaneSurge` icon. Both indicators target the Mana bar fill by default, and new profiles show the timer in the middle of the Mana bar.
- [#820](#820) The tracked duration includes the Savor the Moment extension for the Spellfire Spheres the cast consumed.
- [#820](#820) Add the Indicator Colors tab to Arcane, along with Mana and Arcane Charges as Color Indicator targets.
- [#821](#821) Add a new Arcane Salvo bar, tracking your current stacks. Adds the `$arcaneSalvoStacks` and `$arcaneSalvoStacksMax` bar text variables and the `#arcaneSalvo` icon. Shown by default above the Arcane Charges bar, and hidden entirely without the Arcane Salvo talent.
- [#821](#821) The whole fill recolors as you reach each range, with five ranges on the Arcane Salvo tab. Ranges start at 0, 12 and 25 by default; the other two are off by default.
- [#821](#821) Joins the bar text Relative to Frame and Color Indicator target lists. Its threshold lines use a fixed color rather than switching over and under.

### Fire

- [#825](#825) Fix the Fire Blast recharge fill always using Charge 1's color when "Use partial fill color" is unchecked. It now uses the color of the charge that is refilling.

---

# 12.1.0.7-release (2026-08-25)
## General

- [#817](#817) Improve bar update performance, primarily around threshold lines and bar text.

### Localization

- [#816 - @MOSS099](#816) Updated translations for Simplified Chinese (zhCN).

## Mage
### Fire

- [#763](#763) Fix the Fire Blast recharge fill and timer text showing on the last charge node instead of the one refilling.
- [#763](#763) Add Fire Blast (Recharging Charge) as a bar text Relative to Frame target, now used by the default charge timer text.

---

# 12.1.0.6-release (2026-08-24)
## General
### Cast Bars

- Fix bar text blanking the moment a cast ended, leaving the Player, Target and Focus cast bars on screen with no text while they faded out. The bar text when the cast finishes now persists until the bar is gone.

## Druid
### Balance

- Add tracking of individual Starfall casts via the new bar text variables `$starfallStacks`, `$starfallTime` and `$starfallNextStackTime`.

## Priest
### Holy

- Fix Apotheosis cast out of combat with Sustained Potency ticking down immediately instead of starting paused, which dropped the Holy Word cooldown reduction bonus early.
- Fix Surge of Light gained partway through a Flash Heal, Benediction or Prayer of Healing counting as if it had empowered that cast, applying Energy Cycle and Spiritwell cooldown reduction it had not earned. Surge of Light expiring mid-cast no longer counts either.
- Adjust logic tracking for Power Words to improve accuracy of the cooldown remaining.

### Shadow

- Fix Voidform cast out of combat with Sustained Potency ticking down immediately instead of starting paused.

---

# 12.1.0.5-release (2026-08-19)
## General

- Adjust some event hooks to be more tightly scoped to just the `player` where possible.

### Localization

- [#814 - @MOSS099](#814) Updated translations for Simplified Chinese (zhCN).

---

# 12.1.0.4-release (2026-08-18)
## General
### Cast Bars

- Add `Show tooltip on hover` to the icon options on the Player, Target and Focus cast bars. On by default.

### Localization

- [#812 - @MOSS099](#812) Updated translations for Simplified Chinese (zhCN).
- [#813 - @MOSS099](#813) Updated translations for Simplified Chinese (zhCN).

## Mage
### Frost

- [#809](#809) Add Fingers of Frost and Brain Freeze Audio Cues. Fingers of Frost has separate cues for reaching 1 and 2 charges; the 2 charge cue wins when a proc takes you straight to two. The 1 charge cue offers `Also play when dropping to this value`, for spending your second charge back down to one. All three cues are off by default.
- [#809](#809) Add a Fingers of Frost (2 Charges) Color Indicator, taking priority over Fingers of Frost. Defaults to the Mana bar border.

## Priest
### Discipline

- Surge of Light tracking no longer requires the CDM.
- Add the `$surgeOfLightStacksMax` and `$surgeOfLightTime` bar text variables and the `#surgeOfLight` icon.
- Add a Surge of Light (2 Stacks) Color Indicator, taking priority over Surge of Light.
- Add a Surge of Light (2 Stacks) Audio Cue. The existing Surge of Light cue is now the 1 stack cue and offers `Also play when dropping to this value`.

### Holy

- Surge of Light tracking no longer requires the CDM.
- Add the `$surgeOfLightStacksMax` and `$surgeOfLightTime` bar text variables and the `#surgeOfLight` icon.
- Add a Surge of Light (2 Stacks) Color Indicator, taking priority over Surge of Light.
- Add a Surge of Light (2 Stacks) Audio Cue. The existing Surge of Light cue is now the 1 stack cue and offers `Also play when dropping to this value`.

---

# 12.1.0.3-release (2026-08-17)
## General
### Cast Bars

- Fix width, height, border and text precision changes not applying while a Use Global Settings section was enabled.
- Fix bar text freezing mid-cast and never clearing afterward when every other bar was set to Never Show.
- Fix bar text hiding while the bar was still on screen fading out or resting at Always Show.
- Show a placeholder in the icon's strip between casts instead of an empty gap.

---

# 12.1.0.2-release (2026-08-17)
## General

### Edit Mode

- [#810 - @EricaPomme](#810) Reduce the CPU cost of bars anchored to Cooldown Manager frames.

### Localization

- [#811 - @MOSS099](#811) Updated translations for Simplified Chinese (zhCN).

## Evoker
### Augmentation

- Fix the Ebon Might bar never filling when Ebon Might is tracked in the Cooldown Manager's Tracked Buffs category. Only Tracked Bars entries expose a readable remaining time; the fill is now driven by the aura engine instead, which does not care which category the spell sits in.
- Remove End Cap support from the Ebon Might bar. The cap anchors to the fill's leading edge, and an engine-driven fill edge cannot be anchored to from addon code.
- Fix the Ebon Might bar ignoring its gradient color. The render path was handed only the first color, so the second and the gradient direction never reached the bar.

## Mage
### Frost

- [#809](#809) Add Fingers of Frost tracking. Bar text variables `$fingersOfFrostStacks`, `$fingersOfFrostStacksMax` and `$fingersOfFrostTime`, plus the `#fingersOfFrost` icon.
- [#809](#809) Add Brain Freeze tracking. Bar text variable `$brainFreezeTime`, plus the `#brainFreeze` icon. `$brainFreezeTime` requires Brain Freeze to be tracked in the CDM's buff viewers.
- [#809](#809) A Color Indicators tab for Frost, with Fingers of Frost and Brain Freeze entries. Both default to the Mana bar border, with Brain Freeze taking priority.

## Warrior
### Fury

- [#808](#808) Add a new Enrage bar, tracking the time remaining on Enrage. Requires CDM to be enabled and Enrage to be actively tracked to function. Set to Never Show by default; enable it under Bar Visibility.

---

# 12.1.0.1-release (2026-08-14)
## General
### Cast Bars

- [#806](#806) Ensure that player cast bar Bar Text appears immediately when a cast starts instead of lagging several frames behind.
- [#806](#806) Fix an issue where the Blizzard player cast bar would flicker back into visibility briefly when beginning a cast.

### Edit Mode

- Fix bars not previewing in Edit Mode even though the Edit Mode container was sized to include them. Every bar now re-resolves its visibility as Edit Mode opens instead of keeping whatever it was rendering beforehand.
- Fix the Global Cooldown, Fatigue, Breath, Feign Death and cast bars previewing in Edit Mode while disabled, drawing outside the Edit Mode container.
- Hand those same bars back to their own rendering as Edit Mode closes, so an Edit Mode preview can no longer be left behind on screen.

### Localization

- [#805 - @MOSS099](#805) Updated translations for Simplified Chinese (zhCN).

## Evoker
### Augmentation

- [#807](#807) Fix Ebon Might tracking, which read its duration from the aura and went dead when aura data became secret. It now reads from the CDM and requires Ebon Might to be tracked there. The bar, its Color Indicator entry, and `$ebonMightTime` carry the CDM badge.
- [#807](#807) Remove the End of Ebon Might Configuration section, the "Ebon Might is Ending" and "Cast Won't Extend" Ebon Might Color Indicators, the Ebon Might ending audio cue, and custom threshold support for the Ebon Might bar. Each compared the remaining duration against a threshold, which a `secret` value cannot do. Replacements are being considered but no ETA on a replacement.
- [#807](#807) Custom threshold line support has been removed from the Ebon Might bar as it is no longer possible to reliably place them.
- [#807](#807) Fixed an error where casting Emerald Blossom could throw a Lua error.

---

# 12.1.0.0-release (2026-08-10)
## General

- Add a version check that, when enabled in the TOC, will prevent the addon from loading if the client version does not match one of the versions listed in the TOC. This is to prevent people from accidentally updating to a version of the addon that is not compatible with their client version.
- Remove the Aura Caching system since, with 12.1 API changes, it never returns usable (non-`secret`) data.
- Integrate with the Cooldown Manager (CDM) as a supplemental source of data for abilities, buffs, and debuffs. Abilities that used to read Aura data directly now read from the CDM.
- Settings and bar text variables that are fed by the Cooldown Manager now carry a **CDM** badge, with a tooltip explaining that the ability it tracks has to be added to one of the Cooldown Manager's viewers before a value can be shown.
- Add a Cooldown Manager value when unavailable option under Global Options -> Miscellaneous -> Bar Settings, choosing what a CDM fed bar text variable shows while the Cooldown Manager has no value for it -- because the ability was never added to a viewer, or its group is hidden. Choose Nothing (the default), `??`, or zero.
- Refactor how set bonus detection is handled to be more generic.
- Bars that are anchored to another bar now always draw on top of the bar they are attached to, so a bar can no longer be hidden behind its parent.
- Colors: the Health Bar gains a **Single (Class Color)** color option, painting the bar in your current class's color.
- Color Indicators: the bar/element target dropdowns are now a fixed height with a scrollbar, instead of running off the bottom of the screen when a spec has many bars.

### Audio Cues

- Rebuild the Audio Cues tab. The old "Audio & Tracking" tab is now **Audio Cues**, and lists every cue for the specialization in a sortable table showing its type, what triggers it, and the sound it plays, with a detail editor below.
- Specializations with a countable resource can now have **as many threshold cues as you want**, each with its own value and sound, instead of a fixed set. Available for Combo Points (Feral, all Rogue specs), Chi, Holy Power, Soul Shards, Arcane Charges, Icicles, Essence, Maelstrom Weapon stacks, Tip of the Spear stacks, and Lightweaver stacks.
- Threshold cues gain an **Also play when dropping to this value** option, so a cue can fire on the way back down as well as on the way up.
- Every built-in cue now describes exactly what triggers it, both in the table and in its detail pane.
- Audio cues you have deleted or changed no longer come back on the next load.

### Bar Settings

- Every bar's settings tab now has a pinned header with an **Enabled** checkbox, a shortcut for setting that bar's visibility to Never Show without leaving the tab. The header also summarises when the bar currently shows and links straight to the Visibility tab.
- A disabled bar's tab label is now shown in red, so it is obvious from the tab strip without opening the tab.
- Bars whose visibility is being driven by Global Options say so in the header instead of silently ignoring the checkbox.

### Bar Text

- [#802 - @Ignitetheskywow](#802) Font Outline is now a multiselect dropdown. Outline and Thick Outline still replace each other, but either can be combined with Monochrome and the new Slug style, and None clears the rest.
- The bar text variable list is now grouped into **Stats**, **Resources**, **Abilities**, **Other**, and **Cast Bars** sections.
- Add a **CDM** column to the variable list, marking variables whose value comes from Blizzard's Cooldown Manager and which render as `??` until the ability they track is added to one of its viewers.
- Hovering a variable in the list now shows its name and full description, instead of having to select the row.
- Fix bar text labeling to correctly denote bar text variables that are `secret` values, and clarify that a secret value cannot be used with comparison operators in bar text logic.
- Fix bare `{$variable}` checks never evaluating true for Clearcasting, Double Tap, Holy Word: Sanctify charges, Dominion of Argus, Whirlwind, Violent Outburst, and Enrage.

### Cast Bar

- Fix an empty Target or Focus Cast Bar flashing on screen after an interrupt.
- Fix the Target and Focus Cast Bar lingering after a hardcast finished, until the unit's next spell replaced it.
- Fix bar text anchored to the Target or Focus Cast Bar disappearing during the fade out, and on an idle Always Show bar.
- Fix the Target and Focus Cast Bars flickering during spec switches, bar reconstruction, and login.
- Add support for channel ticks to be modified by set bonuses.

### Localization

- [#803 - @MOSS099](#803) Updated translations for Simplified Chinese (zhCN).

### Other Bars

- [#79](#79) Add a new **Other Bars** screen with three optional timer bars available to every specialization -- **Global Cooldown**, **Fatigue**, and **Breath** -- plus a **Feign Death** bar for Hunters. Each has its own dimensions, anchoring, colors, textures, visibility rules, and bar text.
- The Global Cooldown, Fatigue, and Breath bars can be configured globally for every specialization at once, or on a per specialization basis. Feign Death is configured per Hunter specialization, as no other class can use it.
- The Global Cooldown bar can either drain a full bar down or grow an empty one up as the global cooldown elapses.
- The Fatigue, Breath, and Feign Death bars can each hide Blizzard's own version of that timer while they are shown.
- Add a Duration Decimal Precision option for the Global Cooldown bar's timer text. The mirror timers read as mm:ss and have no decimals to configure.
- New bar text variables: `$gcdDuration`, `$gcdDurationRemaining`, `$fatigueDuration`, `$fatigueDurationRemaining`, `$breathDuration`, and `$breathDurationRemaining`, plus `$feignDeathDuration` and `$feignDeathDurationRemaining` for Hunters.
- Each bar comes with a bar text entry for its remaining time already set up. The Global Cooldown's starts disabled, since its bar is thin and recycles constantly; enable it on the Bar Text screen if you want it.

## Death Knight
### Blood

- The Coagulating Blood bar can use an End Cap again. End caps were being suppressed on every bar fed by a secret value, but only multi-segment bars need that -- on a single bar the cap marks its own fill edge and is knowable.

- [#801](#801) Add a new Coagulating Blood bar, tracking your current stacks where each stack is 1% damage reduction, with an optional maximum value override so the bar and its threshold lines scale to the cap you actually reach. Adds the `$coagulatingBloodStacks` and `$coagulatingBloodStacksMax` bar text variables. Requires CDM to be enabled and Coagulating Blood to be actively tracked to function. On upgrade it starts with your Bone Shield bar's visibility settings, rather than appearing unannounced.

## Druid
### Feral

- Midnight Season Two 2-Piece: Add tracking for the Halazzi's Fury damage buff gained when Berserk / Incarnation: Avatar of Ashamane ends (1 second per Combo Point spent during it), shown as a new Color Indicator. Adds a bar text timer variable `$halazzisFuryTime` and an icon (`#halazzisFury`).
- Midnight Season Two 4-Piece: Account for the additional 10 seconds of duration granted to Berserk / Incarnation: Avatar of Ashamane.

## Evoker

- Essence Burst tracking now uses the CDM. Requires CDM to be enabled and Essence Burst to be actively tracked to function.

## Hunter
### Beast Mastery

- Update Beast Cleave's duration to 10 seconds.

## Mage
### Arcane

- Midnight Season Two 2-Piece: Increase the number of ticks when channeling Arcane Missiles by 1.

### Frost

- [#653](#653) Add a new Shatter bar, tracking the stacks of Shatter on your current target, up to 20. Adds the `$shatterStacks` and `$shatterStacksMax` bar text variables and an icon (`#shatter`). Requires CDM to be enabled and Shatter to be actively tracked to function. On upgrade it starts with your Icicles bar's visibility settings, rather than appearing unannounced.

## Paladin

- Divine Purpose tracking now uses the CDM. Requires CDM to be enabled and Divine Purpose to be actively tracked to function.

## Priest
### Discipline

- Surge of Light tracking now uses the CDM. Requires CDM to be enabled and Surge of Light to be actively tracked to function.

### Holy

- Surge of Light tracking now uses the CDM. Requires CDM to be enabled and Surge of Light to be actively tracked to function.

### Shadow

- Improved Voidform no longer grants bonus Insanity.
- Update Ancient Madness's extension behavior for Voidform.

## Rogue
### Outlaw

- Remove Count the Odds tracking and the `$rtbTemporaryCount` bar text variable.

## Shaman
### Elemental

- Power of the Maelstrom no longer grants bonus Maelstrom from Lightning Bolt and Chain Lightning.

## Warlock
### Affliction

- Shard Instability tracking now uses the CDM. Requires CDM to be enabled and Shard Instability to be actively tracked to function.

### Demonology

- Demonic Core tracking now uses the CDM. Requires CDM to be enabled and Demonic Core to be actively tracked to function.

## Warrior
### Fury

- Restore Enrage tracking, now fed by the CDM. Adds an `$enrageTime` bar text variable and an Enrage Color Indicator. Requires CDM to be enabled and Enrage to be actively tracked to function.

### Protection

- Ignore Pain tracking now uses the CDM. Requires CDM to be enabled and Ignore Pain to be actively tracked to function.

]====]
