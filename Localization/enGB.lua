local _, TRB = ...

local locale = GetLocale()

if locale == "enGB" then
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
    L["BarTextInstructions"] = string.format("For more detailed information about Bar Text customisation, see the TRB Wiki on GitHub.\n\n")
    L["BarTextInstructions"] = string.format("%sFor conditional display (only if $VARIABLE is active/non-zero):\n    {$VARIABLE}[$VARIABLE is TRUE output]\n\n", L["BarTextInstructions"])
    L["BarTextInstructions"] = string.format("%sBoolean AND (&), OR (|), NOT (!), and parenthises in logic for conditional display is supported:\n    {$A&$B}[Both are TRUE output]\n    {$A|$B}[One or both is TRUE output]\n    {!$A}[$A is FALSE output]\n    {!$A&($B|$C)}[$A is FALSE and $B or $C is TRUE output]\n\n", L["BarTextInstructions"])
    L["BarTextInstructions"] = string.format("%sExpressions are also supported (+, -, *, /) and comparison symbols (>, >=, <, <=, =, !=):\n    {$VARIABLE*2>=$OTHERVAR}[$VARIABLE is at least twice as large as $OTHERVAR output]\n\n", L["BarTextInstructions"])
    L["BarTextInstructions"] = string.format("%sIF/ELSE is supported:\n    {$VARIABLE}[$VARIABLE is TRUE output][$VARIABLE is FALSE output]\n    {$VARIABLE>2}[$VARIABLE is more than 2 output][$VARIABLE is less than 2 output]\n\n", L["BarTextInstructions"])
    L["BarTextInstructions"] = string.format("%sIF/ELSE includes NOT support:\n    {!$VARIABLE}[$VARIABLE is FALSE output][$VARIABLE is TRUE output]\n\n", L["BarTextInstructions"])
    L["BarTextInstructions"] = string.format("%sLogic can be nexted inside IF/ELSE blocks:\n    {$A}[$A is TRUE output][$A is FALSE and {$B}[$B is TRUE][$B is FALSE] output]\n\n", L["BarTextInstructions"])
    L["BarTextInstructions"] = string.format("%sTo display icons use:\n    #ICONVARIABLENAME", L["BarTextInstructions"])
    
    --- Import/Export
    L["ExportMessagePostfixSpecializations"] = "specialisations"
end