local _, TRB = ...

-- Shaman (World of Warcraft: Forever): Mana; there is no Maelstrom in this game.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Shaman.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("shaman", {
	general = "mana",
})
