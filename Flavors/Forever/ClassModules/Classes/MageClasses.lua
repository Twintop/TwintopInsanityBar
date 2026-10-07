local _, TRB = ...

-- Mage (World of Warcraft: Forever): Mana; there are no Arcane Charges in this game.

---@class TRB.Classes.Mage.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public arcaneMissiles TRB.Classes.SpellBase
---@field public blizzard TRB.Classes.SpellBase
---@field public evocation TRB.Classes.SpellBase

---Adds the Mage's channeled abilities to a new spell set.
---@param spells TRB.Classes.Mage.GeneralSpells
local function FillSpells(spells)
	-- Ranks 1 and 2 fire three and four missiles; every later rank fires five.
	local fiveMissiles = { mode = "fixedCount", baseDuration = 5, tickCount = 5, firstTickAtStart = false }
	spells.arcaneMissiles = TRB.Classes.SpellBase:New({
		id = 5143,
		rankIds = { 5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345 },
		baseline = true,
		rankTickProfiles = {
			{ mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
			{ mode = "fixedCount", baseDuration = 4, tickCount = 4, firstTickAtStart = false },
			fiveMissiles, fiveMissiles, fiveMissiles, fiveMissiles, fiveMissiles, fiveMissiles,
		},
	})
	spells.blizzard = TRB.Classes.SpellBase:New({
		id = 10,
		rankIds = { 10, 6141, 8427, 10185, 10186, 10187 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 8, tickCount = 8, firstTickAtStart = false },
	})
	spells.evocation = TRB.Classes.SpellBase:New({
		id = 12051,
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 8, tickCount = 8, firstTickAtStart = false },
	})
end

TRB.Forever.Templates.Classes:DefineClass("mage", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})
