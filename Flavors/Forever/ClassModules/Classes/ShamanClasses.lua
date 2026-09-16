local _, TRB = ...

-- Shaman (World of Warcraft: Forever): Mana on every specialization; there is no Maelstrom in this game.
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Shaman.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("shaman", {
	elemental = "mana",
	enhancement = "mana",
	restoration = "mana",
})
