local _, TRB = ...

-- Shaman (The Burning Crusade Classic): Mana; there is no Maelstrom in this game.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.TBC.Shaman.GeneralSpells:New after this call.
TRB.TBC.Templates.Classes:DefineClass("shaman", {
	general = "mana",
})

TRB.Classes.SpecDescriptor:DeclareForClass("shaman", { totems = { placement = "spec", builtIn = true } })
