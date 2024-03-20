local _, TRB = ...

local locale = GetLocale()

if locale == "frFR" then
    local L = TRB.Localization

    L["OK"] = "D'accord"
    L["Cancel"] = "Annuler"
    L["Close"] = "Fermer"
    L["Yes"] = "Oui"
    L["No"] = "Non"
    L["Author"] = "Auteur"
    L["Version"] = "Version"
    L["Released"] = "Date de sortie"
    L["SupportedSpecs"] = "Spécialisations prises en charge (Dragonflight)"
    L["Experimental"] = "Expérimental"
    L["Minimal"] = "Minimal"
    L["ExperimentalMinimal"] = "Expérimental/Minimal"
    L["BarTextInstructions1"] = "Pour plus d'informations détaillées à propos des customisations de barres de texte, visiter le Wiki sur Github"
    L["BarTextInstructions8"] = "Pour afficher les icônes utilisez:\n #ICONVARIABLENAME"
    L["GlobalOptions"] = "Options globales"
    L["TTD"] = "Temps de Tuer"
    L["SamplingRate"] = "Taux d'échantillonnage (secondes)"
    L["SampleSize"] = "Taille d'échantillonnage"
    L["TTDPrecision"] = "Précision du Temps de Tuer"
    L["TimerPrecision"] = "Précision du temps"
end