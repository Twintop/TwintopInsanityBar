local _, TRB = ...

-- Paladin (World of Warcraft: Forever): Mana; there is no Holy Power in this game.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Paladin.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("paladin", {
	general = "mana",
})
