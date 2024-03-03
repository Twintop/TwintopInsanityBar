local _, TRB = ...
local L = TRB.Localization

-- General strings
L["TwintopsResourceBar"] = "Twintop's Resource Bar"
L["OK"] = "OK"
L["Author"] = "Author"
L["Version"] = "Version"
L["Released"] = "Released"
L["SupportedSpecs"] = "Supported Specs (Dragonflight)"

-- Options.lua
--- Global Options
L["BarTextInstructions"] = string.format("For more detailed information about Bar Text customization, see the TRB Wiki on GitHub.\n\n")
L["BarTextInstructions"] = string.format("%sFor conditional display (only if $VARIABLE is active/non-zero):\n    {$VARIABLE}[$VARIABLE is TRUE output]\n\n", L["BarTextInstructions"])
L["BarTextInstructions"] = string.format("%sBoolean AND (&), OR (|), NOT (!), and parenthises in logic for conditional display is supported:\n    {$A&$B}[Both are TRUE output]\n    {$A|$B}[One or both is TRUE output]\n    {!$A}[$A is FALSE output]\n    {!$A&($B|$C)}[$A is FALSE and $B or $C is TRUE output]\n\n", L["BarTextInstructions"])
L["BarTextInstructions"] = string.format("%sExpressions are also supported (+, -, *, /) and comparison symbols (>, >=, <, <=, =, !=):\n    {$VARIABLE*2>=$OTHERVAR}[$VARIABLE is at least twice as large as $OTHERVAR output]\n\n", L["BarTextInstructions"])
L["BarTextInstructions"] = string.format("%sIF/ELSE is supported:\n    {$VARIABLE}[$VARIABLE is TRUE output][$VARIABLE is FALSE output]\n    {$VARIABLE>2}[$VARIABLE is more than 2 output][$VARIABLE is less than 2 output]\n\n", L["BarTextInstructions"])
L["BarTextInstructions"] = string.format("%sIF/ELSE includes NOT support:\n    {!$VARIABLE}[$VARIABLE is FALSE output][$VARIABLE is TRUE output]\n\n", L["BarTextInstructions"])
L["BarTextInstructions"] = string.format("%sLogic can be nexted inside IF/ELSE blocks:\n    {$A}[$A is TRUE output][$A is FALSE and {$B}[$B is TRUE][$B is FALSE] output]\n\n", L["BarTextInstructions"])
L["BarTextInstructions"] = string.format("%sTo display icons use:\n    #ICONVARIABLENAME", L["BarTextInstructions"])
L["GlobalOptions"] = "Global Options"
L["TTD"] = "Time To Die"
L["SamplingRate"] = "Sampling Rate (seconds)"
L["SampleSize"] = "Sample Size"
L["TTDPrecision"] = "Time To Die Precision"
L["TimerPrecision"] = "Timer Precision"
L["TimerBelowPrecision"] = "Below X sec Time Precision"
L["TimerAbovePrecision"] = "Above X sec Time Precision"
L["TimerPrecisionThreshold"] = "Precision Threshold (seconds)"
L["CharacterPlayerSettings"] = "Character and Player Settings"
L["DataRefreshRate"] = "Character Data Refresh Rate (seconds)"
L["ReactionTimeLatency"] = "Player Reaction Time Latency (seconds)"
L["FrameStrata"] = "Frame Strata"
L["FrameStrataDescription"] = "Frame Strata Level to Draw Bar On"
L["AudioChannel"] = "Audio Channel"
L["AudioChannelDescription"] = "Audio Channel to use"
L["ExperimentalFeatures"] = "Experimental Features"
L["Support"] = "Support"
L["ExperimentalEnhancementShaman"] = string.format("%s %s support", L["ShamanEnhancement"], L["Shaman"])
L["ExperimentalEnhancementShamanTooltip"] = string.format("This will enable experimental %s %s support within the bar. If you change this setting and are currently logged in on a %s, you'll need to reload your UI before %s %s configuration options become available.", L["ShamanEnhancement"], L["Shaman"], L["Shaman"], L["ShamanEnhancement"], L["Shaman"])
L["ShowNewsPopup"] = "Show News Popup"

--- Import/Export
L["Import"] = "Import"
L["Export"] = "Export"
L["ImportSettingsConfiguration"] = "Import Settings Configuration"
L["ImportMessage"] = "Paste in a Twintop's Resource Bar configuration string to have that configuration be imported. Your UI will be reloaded automatically."
L["ImportErrorGenericMessage"] = "Twintop's Resource Bar import failed. Please check the settings configuration string that you entered and try again."
L["ImportErrorNoValidMessage"] = "Twintop's Resource Bar import failed. There were no valid classes, specs, or settings values found. Please check the settings configuration string that you entered and try again."
L["ImportReloadMessage"] = "Import successful. Please click OK to reload UI."
L["ImportExisting"] = "Import existing Settings Configuration string"
L["ExportSettingsConfiguration"] = "Export Settings Configuration"
L["ExportMessagePrefix"] = "Copy the string below to share your Twintop's Resource Bar configuration for"
L["ExportMessagePrefixAll"] = L["ExportMessagePrefix"] .. " all"
L["ExportMessageAll"] = "All"
L["ExportMessageBarDisplay"] = "Bar Display"
L["ExportMessageFontText"] = "Font & Text"
L["ExportMessageAudioTracking"] = "Audio & Tracking"
L["ExportMessageBarText"] = "Bar Text"
L["ExportMessageAllClassesSpecs"] = "All Classes/Specs"
L["ExportMessagePostfixSpecializations"] = "specializations"
L["ExportMessagePostfixAll_Function"] = function() return "(" .. L["ExportMessageAll"] .. ")" end
L["ExportMessagePostfixBarDisplay_Function"] = function() return "(" .. L["ExportMessageBarDisplay"] .. ")" end
L["ExportMessagePostfixFontText_Function"] = function() return "(" .. L["ExportMessageFontText"] .. ")" end
L["ExportMessagePostfixAudioTracking_Function"] = function() return "(" .. L["ExportMessageAudioTracking"] .. ")" end
L["ExportMessagePostfixBarText_Function"] = function() return "(" .. L["ExportMessageBarText"] .. ")" end
L["ExportMessageGlobalOptions"] = L["GlobalOptions"]
L["ExportMessageGlobalOptionsOnly"] = L["GlobalOptions"] .. " Only"

-- OptionsUi.lua
--- ToggleCheckboxOnOff
L["Enabled"] = "Enabled"
L["Disabled"] = "Disabled"
L["Abilities"] = "Abilities"
L["Items"] = "Items"

--- Abilities and items -- TODO: Pull this from spelldata
L["Innervate"] = "Innervate"
L["Shadowfiend"] = "Shadowfiend"
L["SymbolOfHope"] = "Symbol of Hope"
L["ConjuredChillglobe"] = "Conjured Chillglobe"
L["AeratedManaPotion"] = "Aerated Mana Potion"
L["PotionOfFrozenFocus"] = "Potion of Frozen Focus"
L["PotionOfChilledClarity"] = "Potion of Chilled Clarity"

--- GenerateBarDimensionsOptions
L["BarPositionSize"] = "Bar Position and Size"
L["BarWidth"] = "Bar Width"
L["BarHeight"] = "Bar Height"
L["BarHorizontalPosition"] = "Bar Horizontal Position"
L["BarVerticalPosition"] = "Bar Vertical Position"
L["BarBorderWidth"] = "Bar Border Width"
L["ThresholdLineWidth"] = "Threshold Line Width"
L["DragAndDropEnabled"] = "Drag & Drop Movement Enabled"
L["DragAndDropTooltip"] = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
L["PinToPRDEnabled"] = "Pin to Personal Resource Display"
L["PinToPRDTooltip"] = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."

--- GenerateComboPointDimensionsOptions
L["SecondaryPositionAndSize"] = "%s Position and Size"
L["SecondaryWidth"] = "%s Width"
L["SecondaryHeight"] = "%s Height"
L["SecondaryHorizontalPosition"] = "%s Horizontal Position (Relative)"
L["SecondaryVerticalPosition"] = "%s Vertical Position (Relative)"
L["SecondaryBorderWidth"] = "%s Border Width"
L["SecondaryRelativeTo"] = "Relative Position of %s to %s Bar"
L["SecondaryFullBarWidth"] = "%s are full bar width?"
L["SecondaryFullBarWidthTooltip"] = "Makes the %s bars take up the same total width of the bar, spaced according to %s Spacing (above). The horizontal position adjustment will be ignored and the width of %s bars will be automatically calculated and will ignore the value set above."

--- GenerateBarTexturesOptions
L["BarAndSecondardTexturesHeader"] = "Bar and %s Textures"
L["BarTexturesHeader"] = "Bar Textures"
L["MainBarTexture"] = "Main Bar Texture"
L["CastingBarTexture"] = "Casting Bar Texture"
L["PassiveBarTexture"] = "Passive Bar Texture"
L["SecondaryBarTexture"] = "%s Bar Texture"
L["StatusBarTextures"] = "Status Bar Textures"
L["UseSameTexture"] = "Use the same texture for all bars?"
L["UseSameTextureTooltip"] = "This will lock the texture for each part of the bar to be the same."
L["BorderTexture"] = "Border Texture"
L["SecondaryBorderTexture"] = "%s Border Texture"
L["BorderTextures"] = "Border Textures"
L["BackgroundTexture"] = "Background (Empty Bar) Texture"
L["SecondaryBackgroundTexture"] = "%s Background (Empty Bar) Texture"
L["BackgroundTextures"] = "Background Textures"
L["TextureLock"] = "Use the same texture for all bars, borders, and backgrounds (respectively)"
L["TextureLockTooltip"] = "This will lock the texture for each type of texture to be the same for all parts of the bar. E.g.: All bar textures will be the same, all border textures will be the same, and all background textures will be the same."

--- GenerateBarDisplayOptions
L["BarDisplayHeader"] = "Bar Display"
L["FlashAlpha"] = "%s Flash Alpha"
L["FlashPeriod"] = "%s Flash Period (sec)"
L["ShowBarAlways"] = "Always show bar"
L["ShowBarNotZero"] = "Show bar when %s > 0"
L["ShowBarNotZeroNotFull"] = "Show bar when %s is not full."
L["ShowBarNotZeroBalance"] = "Show bar when AP > 0 (or < 50 w/NB)"
L["ShowBarCombat"] = "Only show bar in combat"
L["ShowBarNever"] = "Never show bar (run in background)"
L["FlashBar"] = "Flash bar when %s is usable"
L["FlashBarTooltip"] = "This will flash the bar when %s can be cast."

--- GenerateThresholdLineIconsOptions
L["ThresholdIconRelativePosition"] = "Relative Position of Threshold Line Icons"
L["ThresholdIconShow"] = "Show ability icons for threshold lines?"
L["ThresholdIconShowTooltip"] = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
L["ThresholdIconDesaturate"] = "Desaturate icons when not usable"
L["ThresholdIconDesaturateTooltip"] = "When checked, icons will be desaturated when an ability is not usable (on cooldown, below minimum resource, lacking other requirements, etc.)."
L["ThresholdIconWidth"] = "Threshold Icon Width"
L["ThresholdIconHeight"] = "Threshold Icon Height"
L["ThresholdIconHorizontal"] = "Threshold Icon Horizontal Position (Relative)"
L["ThresholdIconVertical"] = "Threshold Icon Vertical Position (Relative)"
L["ThresholdIconBorderWidth"] = "Threshold Icon Border Width"

--- GeneratePotionOnCooldownConfigurationOptions
L["PotionCooldownConfigurationHeader"] = "Potion on Cooldown Configuration"
L["PotionThresholdShow"] = "Show potion threshold lines when potion is on cooldown"
L["PotionThresholdShowTooltip"] = "Shows the potion threshold lines while potion use is still on cooldown. Configure below how far in advance to have the lines be visible, between 0 - 300 seconds (300 being effectively 'always visible')."
L["PotionThresholdShowGCDs"] = "CDs left on Potion cooldown"
L["PotionThresholdShowGCDsSlider"] = "Potion Cooldown GCDs - 0.75sec Floor"
L["PotionThresholdShowTime"] = "Time left on Potion cooldown"
L["PotionThresholdShowTimeSlider"] = "Potion Cooldown Time Remaining"

--- Thresholds

L["ThresholdLinesHeader"] = "Threshold Lines"
L["ThresholdLinesOverlap"] = "Threshold lines overlap bar border?"
L["ThresholdLinesOverlapTooltip"] = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
L["ThresholdShowWhileOnCooldown"] = "Show while on cooldown?"

--- GenerateThresholdLinesForHealers
L["ThresholdHealerOver"] = "Mana gain from potions and items (when usable)"
L["ThresholdHealerOver2"] = "Mana gain from potions, items, and abilities (when usable)"
L["ThresholdHealerUnusable"] = "Mana potion or item on cooldown"
L["ThresholdHealerPassive"] = "Passive mana gain per source"
L["ThresholdHealerPotionTooltipBase"] = "This will show the vertical line on the bar denoting how much Mana you will gain if you use |5"
L["AeratedManaPotionRank3"] = "27,600 mana"
L["AeratedManaPotionRank2"] = "24,000 mana"
L["AeratedManaPotionRank1"] = "20,869 mana"
L["PotionOfFrozenFocusRank3"] = "48,300 mana + regen"
L["PotionOfFrozenFocusRank2"] = "42,000 mana + regen"
L["PotionOfFrozenFocusRank1"] = "36,531 mana + regen"
L["ThresholdHealerShowWhileOnCooldownTooltipWithAbility"] = "Show the %s threshold line when the ability is on cooldown."
L["ThresholdHealerShowWhileOnCooldownTooltipWithItem"] = "Show the %s threshold line when the item is on cooldown."
L["ThresholdHealerToggleAbility"] = "This will show the vertical line on the bar denoting how much Mana you will gain if you use %s."
L["ThresholdHealerSymbolOfHopeManaPercent"] = "Min. mana% remaining before showing Symbol of Hope"
L["ThresholdHealerToggleConjuredChillglobe"] = "This will show the vertical line on the bar denoting how much Mana you will gain if you use the Conjured Chillglobe trinket. Only shown below 65% mana."

--- GenerateBarColorOptions
L["BarColorsChangingHeader"] = "Bar Colors + Changing"

--- GenerateBarBorderColorOptions
L["BarBorderColorsChangingHeader"] = "Bar Border Colors + Changing"
L["BorderColorBase"] = "Border is normal/base border"
L["BorderColorOvercap"] = "Border when your current hardcast will overcap %s"
L["BorderColorOvercapToggle"] = "Change border color when overcapping"
L["BorderColorOvercapToggleTooltip"] = "This will change the bar's border color when your current hardcast spell will result in overcapping %s (as configured)."
L["BorderColorInnervate"] = "Border when you have Innervate"
L["BorderColorInnervateToggleTooltip"] = "This will change the bar border color when you have Innervate."
L["BorderColorPotionOfChilledClarity"] = "Border when you have Potion of Chilled Clarity's effect"
L["BorderColorPotionOfChilledClarityToggleTooltip"] = "This will change the bar border color when you have Potion of Chilled Clarity's effect."

--- GenerateOvercapOptions
L["OvercappingConfigurationHeader"] = "Overcapping Configuration"
L["OvercapRelativeOffset"] = "Relative %s Offset from Maximum"
L["OvercapRelativeOffsetAmount"] = "Relative %s Offset Amount"
L["OvercapFixedValue"] = "Fixed %s Value"
L["OvercapAbove"] = "Overcap Above %s"

--- GenerateDefaultFontOptions