local _, TRB = ...

-- Druid (World of Warcraft: Forever): Three specializations: Balance and Restoration on Mana, Feral on Energy plus Combo Points. TO CONFIRM in beta: Feral covers both Cat Form and Bear Form here, so bear form Rage (and the form switching the mainline Druid has) is still to be designed once the beta shows how forms and power types report.
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Druid.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("druid", {
	balance = "mana",
	feral = "energyComboPoints",
	restoration = "mana",
})
