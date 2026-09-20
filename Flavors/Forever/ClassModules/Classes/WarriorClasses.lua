local _, TRB = ...

-- Warrior (World of Warcraft: Forever): Rage.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Warrior.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("warrior", {
	general = "rage",
})
