local _, TRB = ...

local locale = GetLocale()

if locale == "deDE" then
    local L = TRB.Localization
    
    -- General strings
    L["TwintopsResourceBar"] = "Twintop's Resource Bar" --"Twintops Ressourcenleiste"
    L["OK"] = "OK"
    L["Author"] = "Autor"
    L["Version"] = "Version"
    L["Released"] = "Veröffentlicht"
    L["SupportedSpecs"] = "Unterstützte Spezialisierungen (Dragonflight)"
    
    L["BarTextInstructions1"] = "Für weitere Informationen über die Leisten Text Anpassungen, gehe in das TRB Wiki im GitHub.\n\n"
    L["BarTextInstructions2"] = "Fur bedingte Darstellung (nur wenn $VARIABLE aktiv/nicht Null):\n {$VARIABLE}[$VARIABLE ist TRUE output]\n\n"
    L["BarTextInstructions3"] = "Boolean AND (&), OR (|), NOT (!), und Klammern, werden für die bedingte Darstellung unterstützt:\n {$A&$B}[Beide sind TRUE output]\n {$A|$B}[Eine oder beide sind TRUE output]\n {!$A}[$A ist FALSE output]\n {!$A&($B|$C)}[$A ist FALSE und $B oder $C ist TRUE output]\n\n"
    L["BarTextInstructions4"] = "Ausdrücke (+, -, *, /) und Vergleichssymbole (>, >=, <, <=, =, !=) werden auch unterstützt:\n {$VARIABLE*2>=$OTHERVAR}[$VARIABLE ist mindestens doppelt so groß wie $OTHERVAR output]"
    L["BarTextInstructions5"] = "IF/ELSE wird unterstützt:\n {$VARIABLE}[$VARIABLE ist TRUE output][$VARIABLE ist FALSE output]\n {$VARIABLE>2}[$VARIABLE ist größer als 2 output][$VARIABLE ist kleiner als 2 output]\n\n"
    L["BarTextInstructions6"] = "IF/ELSE unterstützt NOT:\n {!$VARIABLE}[$VARIABLE ist FALSE output][$VARIABLE ist TRUE output]\n\n"
    L["BarTextInstructions7"] = "Logic can be nexted in IF/ELSE Blöcken:\n {$A}[$A ist TRUE output][$A ist FALSE und {$B}[$B ist TRUE][$B ist FALSE] output]\n\n"
    L["BarTextInstructions8"] = "Um Icons anzuzeigen, benutze:\n #ICONVARIABLENAME"
end