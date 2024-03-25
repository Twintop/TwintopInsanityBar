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
    L["UseDefaultFontColorTooltip"] = "This will make this bar text area use the default font colour instead of the font color chosen above."
    L["PositionAboveMiddle"] = "Above - Centre"
    L["PositionBelowMiddle"] = "Below - Centre"
    L["PositionCenter"] = "Centre"
end