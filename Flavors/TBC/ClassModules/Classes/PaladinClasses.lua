local _, TRB = ...

-- Paladin (The Burning Crusade Classic): Mana; there is no Holy Power in this game.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.TBC.Paladin.GeneralSpells:New after this call.
TRB.TBC.Templates.Classes:DefineClass("paladin", {
	general = "mana",
})
