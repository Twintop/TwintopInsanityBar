local _, TRB = ...

-- Mage (World of Warcraft: Forever): Mana on every specialization; there are no Arcane Charges in this game.
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Mage.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("mage", {
	arcane = "mana",
	fire = "mana",
	frost = "mana",
})
