local _, TRB = ...

-- Rogue (World of Warcraft: Forever): Energy plus Combo Points on every specialization (the second specialization is Combat here).
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Rogue.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("rogue", {
	assassination = "energyComboPoints",
	combat = "energyComboPoints",
	subtlety = "energyComboPoints",
})
