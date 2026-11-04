local _, TRB = ...

-- Priest (The Burning Crusade Classic): Mana; there is no Insanity in this game.

---@class TRB.Classes.TBC.Priest.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public mindFlay TRB.Classes.SpellBase

---Adds the Priest's channeled abilities to a new spell set; Starshards is a damage over time spell here, not a channel.
---@param spells TRB.Classes.TBC.Priest.GeneralSpells
local function FillSpells(spells)
	spells.mindFlay = TRB.Classes.SpellBase:New({
		id = 15407,
		rankIds = { 15407, 17311, 17312, 17313, 17314, 18807, 25387 },
		isTalent = true,
		tickProfile = { mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
	})
end

TRB.TBC.Templates.Classes:DefineClass("priest", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})

TRB.Classes.SpecDescriptor:DeclareForClass("priest", { rangedAttack = true })
