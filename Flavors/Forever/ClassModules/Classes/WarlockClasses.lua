local _, TRB = ...

-- Warlock (World of Warcraft: Forever): Mana; Soul Shards are items here, not a power type.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Warlock.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("warlock", {
	general = "mana",
})
