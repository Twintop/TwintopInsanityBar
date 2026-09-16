local _, TRB = ...

-- Warlock (World of Warcraft: Forever): Mana on every specialization; Soul Shards are items here, not a power type.
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Warlock.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("warlock", {
	affliction = "mana",
	demonology = "mana",
	destruction = "mana",
})
