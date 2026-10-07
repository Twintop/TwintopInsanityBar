local _, TRB = ...

-- Hunter (World of Warcraft: Forever): Mana; there is no Focus in this game.

---@class TRB.Classes.Hunter.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public volley TRB.Classes.SpellBase
---@field public mendPet TRB.Classes.SpellBase

---Adds the Hunter's channeled abilities to a new spell set.
---@param spells TRB.Classes.Hunter.GeneralSpells
local function FillSpells(spells)
	spells.volley = TRB.Classes.SpellBase:New({
		id = 1510,
		rankIds = { 1510, 14294, 14295 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 6, tickCount = 6, firstTickAtStart = false },
	})
	spells.mendPet = TRB.Classes.SpellBase:New({
		id = 136,
		rankIds = { 136, 3111, 3661, 3662, 13542, 13543, 13544 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 5, tickCount = 5, firstTickAtStart = false },
	})
end

TRB.Forever.Templates.Classes:DefineClass("hunter", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})

-- The pet's power awaits in-game confirmation; it only picks the Pet Resource bar's default colors.
TRB.Classes.SpecDescriptor:DeclareForClass("hunter", { pet = { power = "FOCUS" } })
