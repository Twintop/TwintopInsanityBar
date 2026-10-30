local _, TRB = ...

-- Shaman (World of Warcraft Classic): Mana; there is no Maelstrom in this game.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Classic.Shaman.GeneralSpells:New after this call.
TRB.Classic.Templates.Classes:DefineClass("shaman", {
	general = "mana",
})

TRB.Classes.SpecDescriptor:DeclareForClass("shaman", { totems = { placement = "spec" } })
