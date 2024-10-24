local _, TRB = ...

local locale = GetLocale()

if locale == "enGB" then
    local L = TRB.Localization
    
    L["OK"] = "OK"
    L["Author"] = "Author"
    L["Version"] = "Version"
    L["Released"] = "Released"
    L["SupportedSpecs"] = "Supported Specs (Dragonflight)"
    L["ExportMessagePostfixSpecializations"] = "specialisations"
    L["BarColorsChangingHeader"] = "Bar Colours + Changing"
    L["BarBorderColorsChangingHeader"] = "Bar Border Colours + Changing"
    L["BorderColorOvercapToggle"] = "Change border colour when overcapping"
    L["BorderColorOvercapToggleTooltip"] = "This will change the bar's border colour when your current hardcast spell will result in overcapping %s (as configured)."
    L["BorderColorInnervateToggleTooltip"] = "This will change the bar border colour when you have Innervate."
    L["BorderColorPotionOfChilledClarityToggleTooltip"] = "This will change the bar border colour when you have Potion of Chilled Clarity's effect."
    L["DefaultFontColor"] = "Default Font Colour"
    L["FontColor"] = "Font Colour"
    L["UseDefaultFontColor"] = "Use default Font Colour"
    L["UseDefaultFontColorTooltip"] = "This will make this bar text area use the default font colour instead of the font colour chosen above."
    L["PositionAboveMiddle"] = "Above - Centre"
    L["PositionBelowMiddle"] = "Below - Centre"
    L["PositionCenter"] = "Centre"
    L["ThresholdOutOfRangeCheckbox"] = "Change threshold line colour when out of range?"
    L["ThresholdOutOfRangeCheckboxTooltip"] = "When checked, while in combat threshold lines will change colour when you are unable to use the ability due to being out of range of your current target."
    L["BarDisplayTextCustomizationHeader"] = "Bar Display Text Customisation"
    L["ExportSpecialization"] = "Export Specialisation"
    L["DemonHunterHavocCheckboxEndOfMetamorphosis"] = "Change bar colour at the end of Metamorphosis"
    L["DemonHunterHavocCheckboxEndOfMetamorphosisTooltip"] = "Changes the bar colour when Metamorphosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["DemonHunterHavocTextColorsHeader"] = "Fury Text Colours"
    L["DemonHunterHavocCheckboxThresholdOverTooltip"] = "This will change the Fury text colour when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
    L["DemonHunterHavocCheckboxThresholdOvercapTooltip"] = "This will change the Fury text colour when your next builder ability will result in overcapping maximum Fury."
    L["DemonHunterVengeanceCheckboxEndOfMetamorphosis"] = "Change bar colour at the end of Metamorphosis"
    L["DemonHunterVengeanceCheckboxEndOfMetamorphosisTooltip"] = "Changes the bar colour when Metamorphosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["DemonHunterVengeanceHeaderSoulFragmentColors"] = "Soul Fragment Colours"
    L["DemonHunterVengeanceCheckboxUseHighestSoulFragmentColorForAll"] = "Use highest Soul Fragment colour for all?"
    L["DemonHunterVengeanceCheckboxUseHighestSoulFragmentColorForAllTooltip"] = "When checked, the highest Soul Fragment's colour will be used for all Soul Fragments. E.g., if you have maximum 5 Soul Fragments and currently have 4, the Penultimate colour will be used for all Soul Fragments instead of just the second to last."
    L["DemonHunterVengeanceTextColorsHeader"] = "Fury Text Colours"
    L["DemonHunterVengeanceCheckboxThresholdOverTooltip"] = "This will change the Fury text colour when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
    L["DemonHunterVengeanceCheckboxThresholdOvercapTooltip"] = "This will change the Fury text colour when your next builder ability will result in overcapping maximum Fury."
    L["DotChangeColorCheckbox"] = "Change total DoT counter and DoT timer colour based on DoT status?"
    L["ColorPickerStealth"] = "Border colour when you are stealth (via any ability or proc)"
    L["ComboPointColorsHeader"] = "Combo Point Colours"
    L["ComboPointCheckboxUseHighestForAll"] = "Use highest Combo Point colour for all?"
    L["ComboPointCheckboxUseHighestForAllTooltip"] = "When checked, the highest Combo Point's colour will be used for all Combo Points. E.g., if you have maximum 5 Combo Points and currently have 4, the Penultimate colour will be used for all Combo Points instead of just the second to last."
    L["EnergyTextColorsHeader"] = "Energy Text Colours"
    L["CheckboxThresholdOverTooltip"] = "This will change the Energy text colour when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
    L["CheckboxThresholdOvercapTooltip"] = "This will change the Energy text colour when your current energy is above the overcapping maximum Energy value."
    L["HealerManaTextColorsHeader"] = "Mana Text Colours"
    L["DPSManaTextColorsHeader"] = "Mana Text Colours"
    L["DruidBalanceCheckboxEndOfEclipse"] = "Change bar colour at the end of Eclipse"
    L["DruidBalanceCheckboxEndOfEclipseTooltip"] = "Changes the bar colour when Eclipse is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["DruidBalanceCheckboxEndOfEclipseOnlyCelestialTooltip"] = "Only changes the bar colour when you are exiting an Eclipse from Celestial Alignment or Incarnation: Chosen of Elune."
    L["DruidBalanceTextColorsHeader"] = "Astral Power Text Colours"
    L["DruidBalanceCheckboxThresholdOverTooltip"] = "This will change the Astral Power text colour when you are able to cast Starsurge or Starfall"
    L["DruidBalanceCheckboxThresholdOvercapTooltip"] = "This will change the Astral Power text colour when your current hardcast spell will result in overcapping Astral Power (as configured)."
    L["DruidFeralCheckboxEnablePredatorRevealed"] = "Enable Predator Revealed (T30 4P) colour"
    L["DruidFeralCheckboxEnablePredatorRevealedTooltip"] = "When checked, the next incoming Combo Point and any subsequent unfilled Combo Points that will generate from your Predator Revealed (T30 4P) proc will be a different colour bar, background, and border colour (as specified to the right)."
    L["DruidFeralCheckboxAlwaysDefaultBackgroundTooltip"] = "When checked, unfilled Combo Points will always use the 'Unfilled Combo Point background' colour above for their background. Borders will still change colour depending on Predator Revealed settings."
    L["DruidFeralThresholdCheckboxBleedColor"] = "Use different colours for Bleed snapshots?"
    L["DruidFeralThresholdCheckboxBleedColorTooltip"] = "When checked, threshold lines for Rake, Rip, Thrash, and Moonfire (if Lunar Inspiration is talented) will have their threshold lines coloured based on if the current buffs are better, worse, or the same damage (or the bleed is not on the target) instead of based on available Energy or Combo Points. The colours used are set in the 'Bleed Snapshotting' section under the 'Font & Text' tab."
    L["DruidFeralThresholdCheckboxFerociousBiteTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Ferocious Bite. If you do not have any Combo Points, will be coloured as 'unusable'. Will move along the bar between the current minimum and maximum Energy cost amounts."
    L["DruidFeralThresholdCheckboxFerociousBiteMinimumTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Ferocious Bite at its minimum Energy cost. If you do not have any Combo Points, will be coloured as 'unusable'."
    L["DruidFeralThresholdCheckboxFerociousBiteMaximumTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Ferocious Bite at its maximum Energy cost. If you do not have any Combo Points, will be coloured as 'unusable'."
    L["DruidFeralThresholdCheckboxMaimTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Maim. If on cooldown or you do not have any Combo Points, will be coloured as 'unusable'."
    L["DruidFeralThresholdCheckboxPrimalWrathTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Primal Wrath. If you do not have any Combo Points, will be coloured as 'unusable'."
    L["DruidFeralThresholdCheckboxRipTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Rip. If you do not have any Combo Points, will be coloured as 'unusable'."
    L["DruidFeralBleedChecboxChangeDotColorTooltip"] = "When checked, the colour of total Bleeds (and Moonfire, if talented) up counters and Bleed timers will change based on whether or not the current snapshotted damage values are better, worse, or the same vs. your current damage buffs."
    L["DruidRestorationCheckboxIncarnationEnd"] = "Change bar colour at the end of Incarnation"
    L["DruidRestorationCheckboxIncarnationEndTooltip"] = "Changes the bar colour when Incarnation is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["EvokerCheckboxEssenceBurstStack1Tooltip"] = "This will change the bar border colour when you have 1 stack of Essence Burst."
    L["EvokerCheckboxEssenceBurstStack2Tooltip"] = "This will change the bar border colour when you have 2 stacks of Essence Burst."
    L["EvokerEssenceColorsHeader"] = "Essence Colours"
    L["EvokerEssenceCheckboxUseHighestForAll"] = "Use highest Essence colour for all?"
    L["EvokerEssenceCheckboxUseHighestForAllTooltip"] = "When checked, the highest Essence's colour will be used for all Essence. E.g., if you have maximum 5 Essence and currently have 4, the Penultimate colour will be used for all Essence instead of just the second to last."
    L["HunterTextColorsHeader"] = "Focus Text Colours"
    L["HunterCheckboxThresholdOverTooltip"] = "This will change the Focus text colour when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
    L["HunterCheckboxThresholdOvercapTooltip"] = "This will change the Focus text colour when your current focus or a hardcast spell will result in overcapping maximum Focus."
    L["HunterBeastMasteryColorPickerBeastialWrath"] = "Border colour when you can use Beastial Wrath"
    L["HunterBeastMasteryCheckboxBeastialWrathTooltip"] = "This will change the bar's border colour when Beastial Wrath is usable. This takes precedence over Beast Cleave's colour."
    L["HunterBeastMasteryCheckboxBeastCleaveTooltip"] = "This will change the bar border colour when the Beast Cleave effect is active, either via Beast Cleave it self or Call of the Wild being active with Bloody Frenzy."
    L["HunterBeastMasteryThresholdCheckboxKillShotTooltip"] = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range. If on cooldown or has 0 charges available, will be coloured as 'unusable'."
    L["HunterBeastMasteryThresholdCheckboxWailingArrowTooltip"] = "This will show the vertical line on the bar denoting how much Focus is required to use Wailing Arrow. If on cooldown will be coloured as 'unusable'."
    L["HunterMarksmanshipCheckboxEndOfTrueshot"] = "Change bar colour at the end of Trueshot"
    L["HunterMarksmanshipCheckboxEndOfTrueshotTooltip"] = "Changes the bar colour when Trueshot is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["HunterMarksmanshipCheckboxSteadyFocus"] = "Steady Focus colour change enabled"
    L["HunterMarksmanshipCheckboxSteadyFocusTooltip"] = "Changes the bar border colour when your Steady Focus buff is not up or is expiring in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["HunterMarksmanshipThresholdCheckboxAimedShotTooltip"] = "This will show the vertical line on the bar denoting how much Focus is required to use Aimed Shot. If there are 0 charges available, will be coloured as 'unusable'."
    L["HunterMarksmanshipThresholdCheckboxKillShotTooltip"] = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range. If on cooldown or has 0 charges available, will be coloured as 'unusable'."
    L["HunterMarksmanshipThresholdCheckboxWailingArrowTooltip"] = "This will show the vertical line on the bar denoting how much Focus is required to use Wailing Arrow. If on cooldown will be coloured as 'unusable'."
    L["HunterSurvivalCheckboxEndOfCoordinatedAssult"] = "Change colour at the end of Coordinated Assault"
    L["HunterSurvivalCheckboxEndOfCoordinatedAssultTooltip"] = "Changes the bar colour when Coordinated Assault is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["HunterSurvivalThresholdCheckboxKillShotTooltip"] = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range. If on cooldown or has 0 charges available, will be coloured as 'unusable'."
    L["ChiColorsHeader"] = "Chi Colours"
    L["ChiCheckboxUseHighestForAll"] = "Use highest Chi colour for all?"
    L["ChiCheckboxUseHighestForAllTooltip"] = "When checked, the highest Chi's colour will be used for all Chi. E.g., if you have maximum 5 Chi and currently have 4, the Penultimate colour will be used for all Chi instead of just the second to last."
    L["MonkMistweaverCheckboxVivify"] = "Instant Vivify colour change enabled"
    L["MonkMistweaverCheckboxVivifyTooltip"] = "This will change the bar colour when Vivify is able to be cast instantly due to a the effect of Vivacious Vivification being active."
    L["MonkMistweaverCheckboxManaTeaTooltip"] = "This will change the bar border colour when the cost of spells is reduced due to Mana Tea being active."
    L["MonkWindwalkerCheckboxSerenityEnd"] = "Change bar colour at the end of Serenity"
    L["MonkWindwalkerCheckboxSerenityEndTooltip"] = "Changes the bar colour when Serenity is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["MonkWindwalkerCheckboxMarkOfTheCraneTracking"] = "Change total Mark of the Crane counter and Mark of the Crane timer colour based on time remaining?"
    L["MonkWindwalkerCheckboxMarkOfTheCraneTrackingTooltip"] = "When checked, the colour of total Mark of the Crane debuffs up counters and timers will change based on whether or not Mark of the Crane is on the current target."
    L["DotChangeColorCheckboxTooltip"] = "When checked, the colour of total DoTs up counters and DoT timers (%s) will change based on whether or not the DoT is on the current target."
    L["PriestCheckboxSurgeOfLight1Tooltip"] = "This will change the bar border colour when you have 1 stack of Surge of Light."
    L["PriestCheckboxSurgeOfLight2Tooltip"] = "This will change the bar border colour when you have 2 stacks of Surge of Light."
    L["PriestDisciplineCheckboxRaptureEnd"] = "Change bar colour at the end of Rapture"
    L["PriestDisciplineCheckboxRaptureEndTooltip"] = "Changes the bar colour when Rapture is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["PriestDisciplineCheckboxShadowCovenantTooltip"] = "This will change the bar border colour when you have Shadow Covenant."
    L["PriestDisciplinePowerWordColorsHeader"] = "Power Word Colours"
    L["PriestHolyCheckboxHolyWordChastise"] = "Enable Holy Word: Chastise cooldown colour"
    L["PriestHolyCheckboxHolyWordChastiseTooltip"] = "This will change the mana bar colour when your current cast will complete the cooldown of Holy Word: Chastise."
    L["PriestHolyCheckboxHolyWordSanctify"] = "Enable Holy Word: Sanctify cooldown colour"
    L["PriestHolyCheckboxHolyWordSanctifyTooltip"] = "This will change the mana bar colour when your current cast will complete the cooldown of Holy Word: Sanctify."
    L["PriestHolyCheckboxHolyWordSerenity"] = "Enable Holy Word: Serenity cooldown colour"
    L["PriestHolyCheckboxHolyWordSerenityTooltip"] = "This will change the mana bar colour when your current cast will complete the cooldown of Holy Word: Serenity."
    L["PriestHolyCheckboxApotheosisEnd"] = "Change bar colour at the end of Apotheosis"
    L["PriestHolyCheckboxApotheosisEndTooltip"] = "Changes the bar colour when Apotheosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["PriestHolyCheckboxResonantWordsTooltip"] = "This will change the bar border colour when you have Resonant Words."
    L["PriestHolyCheckboxLightweaverTooltip"] = "This will change the bar border colour when you have any stacks of Lightweaver."
    L["PriestHolyHolyWordColorsHeader"] = "Holy Word Colours"
    L["PriestHolyColorPickerCompleteHolyWordCooldown"] = "Colour when your cast will complete the related Holy Word cooldown"
    L["PriestHolyCheckboxCompleteHolyWordCooldown"] = "Complete cooldown colour change?"
    L["PriestHolyCheckboxCompleteHolyWordCooldownTooltip"] = "When checked, when the hardcasting of a spell will cause its related Holy Word to finish coming off of cooldown, that associated Holy Word bar will change to this colour as an indication."
    L["PriestHolyColorPickerSacredReverence"] = "Colour when this Holy Word will not consume a charge when cast"
    L["PriestHolyCheckboxSacredReverence"] = "Sacred Reverence (T31 4P) colour change?"
    L["PriestHolyCheckboxSacredReverenceTooltip"] = "When checked, the highest completed Holy Word: Sanctify and Holy Word: Serenity will be changed to this colour if you have a stack of Sacred Reverence (T31 4P) causing the next cast to not consume a charge. If you have two stacks, up to two off cooldown charges will be this colour."
    L["PriestShadowCheckboxVoidformEnd"] = "VF/DA colour change when ending enabled"
    L["PriestShadowCheckboxVoidformEndTooltip"] = "Changes the bar colour when Voidform / Dark Ascension is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["PriestShadowCheckboxInstantMindBlast"] = "Instant Mind Blast colour change enabled"
    L["PriestShadowCheckboxInstantMindBlastTooltip"] = "This will change the bar colour when Mind Blast is able to be cast instantly due to a Shadowy Insight proc."
    L["PriestShadowCheckboxMindFlayInsanityTooltip"] = "This will change the bar border colour when you are able to cast Mind Flay: Insanity / Mind Spike: Insanity"
    L["PriestShadowCheckboxDeathspeakerTooltip"] = "This will change the bar border colour when you are able to cast Shadow Word: Death with the Deathspeaker proc effect active."
    L["PriestShadowCheckboxMindDevourerTooltip"] = "This will change the bar border colour when you are able to cast Devouring Plague for 0 Insanity cost via a Mind Devourer proc."
    L["PriestShadowTextColorsHeader"] = "Insanity Text Colours"
    L["PriestShadowCheckboxThresholdOverTooltip"] = "This will change the Insanity text colour when you are able to cast Devouring Plague"
    L["PriestShadowCheckboxThresholdOvercapTooltip"] = "This will change the Insanity text colour when your current hardcast spell will result in overcapping Insanity (as configured)."
    L["PriestShadowHeaderHasteThreshold"] = "Haste Threshold Colours in Voidform"
    L["ShamanManaCheckboxAscendanceEnd"] = "Ascendance colour change when ending enabled"
    L["ShamanManaCheckboxAscendanceEndTooltip"] = "Changes the bar colour when Ascendance is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["ShamanElementalCheckboxAscendanceEnd"] = "Ascendance colour change when ending enabled"
    L["ShamanElementalCheckboxAscendanceEndTooltip"] = "Changes the bar colour when Ascendance is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
    L["ShamanElementalCheckboxPrimalFractureTooltip"] = "This will change the bar border colour when you have the Primal Fracture (T30 4P) buff."
    L["ShamanElementalTextColorsHeader"] = "Maelstrom Text Colours"
    L["ShamanElementalCheckboxThresholdOverTooltip"] = "This will change the Maelstrom text colour when you are able to cast Earth Shock or Earthquake"
    L["ShamanElementalCheckboxThresholdOvercapTooltip"] = "This will change the Maelstrom text colour when your current hardcast spell will result in overcapping Maelstrom (as configured)."
    L["MaelstromWeaponColorsHeader"] = "Maelstrom Weapon Colours"
    L["MaelstromWeaponCheckboxUseHighestForAll"] = "Use highest Maelstrom Weapon colour for all?"
    L["MaelstromWeaponCheckboxUseHighestForAllTooltip"] = "When checked, the highest Maelstrom Weapon's colour will be used for all Maelstrom Weapon. E.g., if you have maximum 10 Maelstrom Weapon and currently have 9, the Penultimate colour will be used for all Maelstrom Weapon instead of just the second to last."
    L["WarriorTextColorsHeader"] = "Rage Text Colours"
    L["WarriorCheckboxThresholdOverTooltip"] = "This will change the Rage text colour when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
    L["WarriorCheckboxThresholdOvercapTooltip"] = "This will change the Rage text colour when your current hardcast spell will result in overcapping maximum Rage."
    L["RogueColorPickerSeratedBoneSpike"] = "Change colour for Serrated Bone Spike generation?"
    L["RogueColorPickerSeratedBoneSpikeTooltip"] = "When checked, any unfilled combo points that will generate on your next use of Serrated Bone Spike will be a different background and border colour (as specified above)."
    L["RogueDotChangeColorCheckbox"] = "Change total DoT counter, DoT timer, and Slice and Dice colour based on time remaining?"
    L["RogueDotChangeColorCheckboxTooltip"] = "When checked, the colour of total DoTs up counters, DoT timers, and Slice and Dice's timer will change based on whether or not the DoT is on the current target."
    L["RogueAssassinationCheckboxAlwaysDefaultBackground"] = "When checked, unfilled combo points will always use the 'Unfilled Combo Point background' colour above for their background. Borders will still change colour depending on Echoing Reprimand and Serrated Bone Spike settings."
    L["RogueAssassinationThresholdSerratedBoneSpikeTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Serrated Bone Spike. If no available charges, will be coloured as 'unusable'."
    L["RogueAssassinationThresholdCrimsonTempestTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Crimson Tempest. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueAssassinationThresholdEnvenomTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Envenom. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueAssassinationThresholdKidneyShotTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot. Only visible when in Stealth or usable via Sepsis or Subterfuge. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueAssassinationThresholdSliceAndDiceTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueAssassinationThresholdRuptureTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Rupture. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueAssassinationThresholdDeathFromAboveTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Death From Above. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawColorPickerRollTheBonesHold"] = "Border colour when you should not use Roll the Bones (keep current rolls)"
    L["RogueOutlawColorPickerRollTheBonesUse"] = "Border colour when you should use Roll the Bones (not up or should reroll)"
    L["RogueOutlawCheckboxAlwaysDefaultBackgroundTooltip"] = "When checked, unfilled combo points will always use the 'Unfilled Combo Point background' colour above for their background. Borders will still change colour depending on Echoing Reprimand settings."
    L["RogueOutlawThresholdDreadbladesTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Dreadblades. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawThresholdBetweenTheEyesTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Between the Eyes. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawThresholdDispatchTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Dispatch. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawThresholdKidneyShotTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot. Only visible when in Stealth or usable via Sepsis or Subterfuge. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawThresholdKillingSpreeTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Killing Spree. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawThresholdSliceAndDiceTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueOutlawThresholdDeathFromAboveTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Death From Above. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyColorPickerShadowcraft"] = "Border colour when Shadowcraft will grant full Combo Points after using a finisher"
    L["RogueSubtletyCheckboxAlwaysDefaultBackgroundTooltip"] = "When checked, unfilled combo points will always use the 'Unfilled Combo Point background' colour above for their background. Borders will still change colour depending on Echoing Reprimand settings."
    L["RogueSubtletyThresholdBlackPowderTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Black Powder. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyThresholdEviscerateTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Eviscerate. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyThresholdKidneyShotTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot. Only visible when in Stealth or usable via Sepsis or Subterfuge. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyThresholdSliceAndDiceTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyThresholdRuptureTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Rupture. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyThresholdSecretTechniqueTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Secret Technique. If you do not have any combo points, will be coloured as 'unusable'."
    L["RogueSubtletyThresholdDeathFromAboveTooltip"] = "This will show the vertical line on the bar denoting how much Energy is required to use Death From Above. If on cooldown or if you do not have any combo points, will be coloured as 'unusable'."
    L["BarTextVariableVers"] = "Current Versatility % (damage increase/offencive)"
    L["BarTextVariableVersDefense"] = "Current Versatility % (damage reduction/defencive)"
    L["DruidRestorationBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["DruidRestorationBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["EvokerPreservationBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["EvokerPreservationBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["MonkMistweaverBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["MonkMistweaverBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["PriestDisciplineBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["PriestDisciplineBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["PriestHolyBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["PriestHolyBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["ShamanRestorationBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["ShamanRestorationBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["Localization"] = "Localisation"
    L["PaladinHolyPowerColorsHeader"] = "Holy Power Colours"
    L["PaladinHolyPowerCheckboxUseHighestForAll"] = "Use highest Holy Power colour for all?"
    L["PaladinHolyPowerCheckboxUseHighestForAllTooltip"] = "When checked, the highest Holy Power's colour will be used for all Holy Power. E.g., if you have maximum 5 Holy Power and currently have 4, the Penultimate colour will be used for all Holy Power instead of just the second to last."
    L["PaladinHolyCheckboxInfusionOfLightStack1Tooltip"] = "This will change the bar border colour when you have 1 stack of Infusion of Light."
    L["PaladinHolyCheckboxInfusionOfLightStack2Tooltip"] = "This will change the bar border colour when you have 2 stacks of Infusion of Light."
    L["PaladinHolyBarTextVariable_channeledMana"] = "Mana while channelling of Potion of Frozen Focus"
    L["PaladinHolyBarTextVariable_potionOfFrozenFocusTicks"] = "Number of ticks left channelling Potion of Frozen Focus"
    L["WarlockSoulShardsColorsHeader"] = "Soul Shards Colours"
    L["WarlockSoulShardsCheckboxUseHighestForAll"] = "Use highest Soul Shard colour for all?"
    L["WarlockManaTextColorsHeader"] = "Mana Text Colours"
    L["CannibalizeIfForsaken"] = "Cannibalise (if Forsaken)"
    L["EvokerDevastationCheckboxMeltArmor"] = "Change bar colour when Melt Armor is active"
    L["EvokerDevastationCheckboxMeltArmorTooltip"] = "Changes the bar colour when Melt Armor is active on your current target."
    L["EvokerAugmentationCheckboxMeltArmor"] = "Change bar colour when Melt Armor is active"
    L["EvokerAugmentationCheckboxMeltArmorTooltip"] = "Changes the bar colour when Melt Armor is active on your current target."
    L["MonkMistweaverCheckboxHeartOfTheJadeSerpentReadyTooltip"] = "This will change the bar border colour when you can use Sheilun's Gift right now to trigger Heart of the Jade Serpent."
    L["MonkWindwalkerCheckboxHeartOfTheJadeSerpentReadyTooltip"] = "This will change the bar border colour when you can use Strike of the Windlord right now to trigger Heart of the Jade Serpent."
    L["MonkWindwalkerCheckboxHeartOfTheJadeSerpentTooltip"] = "This will change the bar border colour when you have Heart of the Jade Serpent active."
    L["EvokerPreservationCheckboxTemporalBurst"] = "Change bar colour when Temporal Burst is active"
    L["EvokerPreservationCheckboxTemporalBurstTooltip"] = "Changes the bar colour when you have the Temporal Burst buff"
    L["EvokerAugmentationCheckboxTemporalBurst"] = "Change bar colour when Temporal Burst is active"
    L["EvokerAugmentationCheckboxTemporalBurstTooltip"] = "Changes the bar colour when you have the Temporal Burst buff"
end