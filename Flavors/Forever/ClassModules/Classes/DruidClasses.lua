local _, TRB = ...

-- Druid (World of Warcraft: Forever): starts on Mana. TO DESIGN: the power type follows the shapeshift form (Energy plus Combo
-- Points in Cat Form, Rage in Bear Form), which the single-archetype template cannot express yet.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Druid.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("druid", {
	general = "mana",
})
