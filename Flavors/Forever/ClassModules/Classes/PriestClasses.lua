local _, TRB = ...

-- Priest (World of Warcraft: Forever): Mana on every specialization; there is no Insanity in this game.
-- The class template generates the spell sets, bar group factory and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Priest.<Spec>Spells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("priest", {
	discipline = "mana",
	holy = "mana",
	shadow = "mana",
})
