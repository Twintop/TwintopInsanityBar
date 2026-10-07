local _, TRB = ...

-- Priest (World of Warcraft: Forever): Mana; there is no Insanity in this game.

---@class TRB.Classes.Priest.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public mindFlay TRB.Classes.SpellBase
---@field public penance TRB.Classes.SpellBase
---@field public penanceDamage TRB.Classes.SpellBase
---@field public penanceHeal TRB.Classes.SpellBase
---@field public starshards TRB.Classes.SpellBase

---Adds the Priest's channeled abilities to a new spell set.
---@param spells TRB.Classes.Priest.GeneralSpells
local function FillSpells(spells)
	spells.mindFlay = TRB.Classes.SpellBase:New({
		id = 15407,
		rankIds = { 15407, 17311, 17312, 17313, 17314, 18807 },
		isTalent = true,
		tickProfile = { mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
	})
	-- Which ID the channel events report is unconfirmed, so the cast and both channel auras carry the profile.
	local penanceTicks = { mode = "fixedCount", baseDuration = 2, tickCount = 3, firstTickAtStart = true }
	spells.penance = TRB.Classes.SpellBase:New({
		id = 402174,
		rankIds = { 402174, 1240720, 1240721, 1316995 },
		isTalent = true,
		tickProfile = penanceTicks,
	})
	spells.penanceDamage = TRB.Classes.SpellBase:New({
		id = 402261,
		rankIds = { 402261, 1240734, 1240736, 1316994 },
		tickProfile = penanceTicks,
	})
	spells.penanceHeal = TRB.Classes.SpellBase:New({
		id = 402277,
		rankIds = { 402277, 1240732, 1240733, 1316992 },
		tickProfile = penanceTicks,
	})
	spells.starshards = TRB.Classes.SpellBase:New({
		id = 10797,
		rankIds = { 10797, 19296, 19299, 19302, 19303, 19304, 19305 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 6, tickCount = 6, firstTickAtStart = false },
	})
end

TRB.Forever.Templates.Classes:DefineClass("priest", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})
