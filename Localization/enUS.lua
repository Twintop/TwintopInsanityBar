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
L["SampingRate"] = "Sampling Rate (seconds)"
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
