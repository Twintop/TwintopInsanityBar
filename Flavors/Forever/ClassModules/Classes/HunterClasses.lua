local _, TRB = ...

-- Hunter (World of Warcraft: Forever): Mana; there is no Focus in this game.
-- The class template generates the spell sets, bar group factory, and spec descriptors from these
-- archetypes; add abilities by extending TRB.Classes.Hunter.GeneralSpells:New after this call.
TRB.Forever.Templates.Classes:DefineClass("hunter", {
	general = "mana",
})

-- The pet's power awaits in-game confirmation; it only picks the Pet Resource bar's default colors.
TRB.Classes.SpecDescriptor:DeclareForClass("hunter", { pet = { power = "FOCUS" } })
