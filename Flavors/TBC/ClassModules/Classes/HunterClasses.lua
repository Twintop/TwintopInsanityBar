local _, TRB = ...

-- Hunter (The Burning Crusade Classic): Mana; there is no Focus in this game.

---@class TRB.Classes.TBC.Hunter.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public volley TRB.Classes.SpellBase

---Adds the Hunter's channeled abilities to a new spell set; Mend Pet is a heal over time here, not a channel.
---@param spells TRB.Classes.TBC.Hunter.GeneralSpells
local function FillSpells(spells)
	spells.volley = TRB.Classes.SpellBase:New({
		id = 1510,
		rankIds = { 1510, 14294, 14295, 27022 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 6, tickCount = 6, firstTickAtStart = false },
	})
end

TRB.TBC.Templates.Classes:DefineClass("hunter", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})

-- The pet's power awaits in-game confirmation; it only picks the Pet Resource bar's default colors.
TRB.Classes.SpecDescriptor:DeclareForClass("hunter", { pet = { power = "FOCUS" }, rangedAttack = true })
