local _, TRB = ...

-- Warrior (World of Warcraft: Forever): Rage on every specialization.
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Warrior.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("warrior", {
	arms = "rage",
	fury = "rage",
	protection = "rage",
})
