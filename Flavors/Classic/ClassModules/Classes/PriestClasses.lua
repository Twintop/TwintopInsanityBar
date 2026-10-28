local _, TRB = ...

-- Priest (World of Warcraft Classic): Mana; there is no Insanity in this game.

---@class TRB.Classes.Classic.Priest.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public mindFlay TRB.Classes.SpellBase
---@field public starshards TRB.Classes.SpellBase

---Adds the Priest's channeled abilities to a new spell set.
---@param spells TRB.Classes.Classic.Priest.GeneralSpells
local function FillSpells(spells)
	spells.mindFlay = TRB.Classes.SpellBase:New({
		id = 15407,
		rankIds = { 15407, 17311, 17312, 17313, 17314, 18807 },
		isTalent = true,
		tickProfile = { mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
	})
	spells.starshards = TRB.Classes.SpellBase:New({
		id = 10797,
		rankIds = { 10797, 19296, 19299, 19302, 19303, 19304, 19305 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 6, tickCount = 6, firstTickAtStart = false },
	})
end

TRB.Classic.Templates.Classes:DefineClass("priest", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})

TRB.Classes.SpecDescriptor:DeclareForClass("priest", { rangedAttack = true })
