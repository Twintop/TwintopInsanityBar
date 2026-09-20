local _, TRB = ...

-- Rogue (World of Warcraft: Forever): Energy plus Combo Points.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Rogue.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("rogue", {
	general = "energyComboPoints",
})
