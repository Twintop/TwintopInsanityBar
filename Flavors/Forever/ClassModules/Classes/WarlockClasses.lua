local _, TRB = ...

-- Warlock (World of Warcraft: Forever): Mana; Soul Shards are items here, not a power type.

---@class TRB.Classes.Warlock.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public drainLife TRB.Classes.SpellBase
---@field public drainMana TRB.Classes.SpellBase
---@field public drainSoul TRB.Classes.SpellBase
---@field public healthFunnel TRB.Classes.SpellBase
---@field public hellfire TRB.Classes.SpellBase
---@field public rainOfFire TRB.Classes.SpellBase
---@field public wrack TRB.Classes.SpellBase
---@field public consumeShadows TRB.Classes.SpellBase

---Adds the Warlock's channeled abilities to a new spell set.
---@param spells TRB.Classes.Warlock.GeneralSpells
local function FillSpells(spells)
	spells.drainLife = TRB.Classes.SpellBase:New({
		id = 689,
		rankIds = { 689, 699, 709, 7651, 11699, 11700 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 5, tickCount = 5, firstTickAtStart = false },
	})
	spells.drainMana = TRB.Classes.SpellBase:New({
		id = 5138,
		rankIds = { 5138, 6226, 11703, 11704 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 5, tickCount = 5, firstTickAtStart = false },
	})
	spells.drainSoul = TRB.Classes.SpellBase:New({
		id = 1120,
		rankIds = { 1120, 8288, 8289, 11675 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 15, tickCount = 5, firstTickAtStart = false },
	})
	spells.healthFunnel = TRB.Classes.SpellBase:New({
		id = 755,
		rankIds = { 755, 3698, 3699, 3700, 11693, 11694, 11695 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 10, tickCount = 10, firstTickAtStart = false },
	})
	spells.hellfire = TRB.Classes.SpellBase:New({
		id = 1949,
		rankIds = { 1949, 11683, 11684 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 15, tickCount = 15, firstTickAtStart = false },
	})
	spells.rainOfFire = TRB.Classes.SpellBase:New({
		id = 5740,
		rankIds = { 5740, 6219, 11677, 11678 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 8, tickCount = 4, firstTickAtStart = false },
	})
	spells.wrack = TRB.Classes.SpellBase:New({
		id = 1316697,
		isTalent = true,
		tickProfile = { mode = "fixedCount", baseDuration = 6, tickCount = 6, firstTickAtStart = false },
	})
	-- The Voidwalker's channel, drawn on the Pet Cast Bar.
	spells.consumeShadows = TRB.Classes.SpellBase:New({
		id = 17767,
		rankIds = { 17767, 17850, 17851, 17852, 17853, 17854 },
		tickProfile = { mode = "fixedCount", baseDuration = 10, tickCount = 5, firstTickAtStart = false },
	})
end

TRB.Forever.Templates.Classes:DefineClass("warlock", {
	general = {
		archetype = "mana",
		spells = FillSpells,
	},
})

-- The pet's power awaits in-game confirmation; it only picks the Pet Resource bar's default colors.
TRB.Classes.SpecDescriptor:DeclareForClass("warlock", { pet = { power = "MANA" } })
