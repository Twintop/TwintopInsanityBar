local _, TRB = ...

-- Rogue (World of Warcraft: Forever): Energy plus Combo Points. Loads in the Classes stage, before
-- Core's Functions, so nothing here calls TRB.Functions.

---@class TRB.Classes.Rogue.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public sinisterStrike TRB.Classes.SpellComboPointThreshold
---@field public backstab TRB.Classes.SpellComboPointThreshold
---@field public mutilate TRB.Classes.SpellComboPointThreshold
---@field public hemorrhage TRB.Classes.SpellComboPointThreshold
---@field public ghostlyStrike TRB.Classes.SpellComboPointThreshold
---@field public ambush TRB.Classes.SpellComboPointThreshold
---@field public garrote TRB.Classes.SpellComboPointThreshold
---@field public cheapShot TRB.Classes.SpellComboPointThreshold
---@field public gouge TRB.Classes.SpellComboPointThreshold
---@field public riposte TRB.Classes.SpellThreshold
---@field public eviscerate TRB.Classes.SpellComboPointThreshold
---@field public rupture TRB.Classes.SpellComboPointThreshold
---@field public sliceAndDice TRB.Classes.SpellComboPointThreshold
---@field public kidneyShot TRB.Classes.SpellComboPointThreshold
---@field public exposeArmor TRB.Classes.SpellComboPointThreshold
---@field public venom TRB.Classes.SpellComboPointThreshold
---@field public feint TRB.Classes.SpellThreshold
---@field public sap TRB.Classes.SpellThreshold
---@field public kick TRB.Classes.SpellThreshold
---@field public distract TRB.Classes.SpellThreshold
---@field public blind TRB.Classes.SpellThreshold
---@field public bladeFlurry TRB.Classes.SpellThreshold

---Adds the Rogue's Energy-spending abilities to a new spell set.
---@param spells TRB.Classes.Rogue.GeneralSpells
local function FillSpells(spells)
	-- Combo point generators
	spells.sinisterStrike = TRB.Classes.SpellComboPointThreshold:New({
		id = 1752,
		rankIds = { 1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "sinisterStrike",
		baseline = true,
		category = "offensive",
	})
	spells.backstab = TRB.Classes.SpellComboPointThreshold:New({
		id = 53,
		rankIds = { 53, 2589, 2590, 2591, 8721, 11279, 11280, 11281, 25300 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "backstab",
		baseline = true,
		category = "offensive",
	})
	spells.mutilate = TRB.Classes.SpellComboPointThreshold:New({
		id = 1310707,
		rankIds = { 1310707, 399956, 1241582, 1241584 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 2,
		settingKey = "mutilate",
		isTalent = true,
		category = "offensive",
	})
	spells.hemorrhage = TRB.Classes.SpellComboPointThreshold:New({
		id = 16511,
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "hemorrhage",
		isTalent = true,
		category = "offensive",
	})
	spells.ghostlyStrike = TRB.Classes.SpellComboPointThreshold:New({
		id = 14278,
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "ghostlyStrike",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
	})
	spells.ambush = TRB.Classes.SpellComboPointThreshold:New({
		id = 8676,
		rankIds = { 8676, 8724, 8725, 11267, 11268, 11269 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "ambush",
		baseline = true,
		stealth = true,
		category = "offensive",
	})
	spells.garrote = TRB.Classes.SpellComboPointThreshold:New({
		id = 703,
		rankIds = { 703, 8631, 8632, 8633, 11289, 11290 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "garrote",
		baseline = true,
		stealth = true,
		category = "offensive",
	})
	spells.cheapShot = TRB.Classes.SpellComboPointThreshold:New({
		id = 1833,
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 2,
		settingKey = "cheapShot",
		baseline = true,
		stealth = true,
		category = "offensive",
	})
	spells.gouge = TRB.Classes.SpellComboPointThreshold:New({
		id = 1776,
		rankIds = { 1776, 1777, 8629, 11285, 11286 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "gouge",
		baseline = true,
		hasCooldown = true,
		category = "utility",
	})
	spells.riposte = TRB.Classes.SpellThreshold:New({
		id = 14251,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "riposte",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
	})

	-- Finishing moves
	spells.eviscerate = TRB.Classes.SpellComboPointThreshold:New({
		id = 2098,
		rankIds = { 2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "eviscerate",
		baseline = true,
		category = "offensive",
	})
	spells.rupture = TRB.Classes.SpellComboPointThreshold:New({
		id = 1943,
		rankIds = { 1943, 8639, 8640, 11273, 11274, 11275 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "rupture",
		baseline = true,
		category = "offensive",
	})
	spells.sliceAndDice = TRB.Classes.SpellComboPointThreshold:New({
		id = 5171,
		rankIds = { 5171, 6774 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "sliceAndDice",
		baseline = true,
		rangeCheck = false,
		category = "offensive",
	})
	spells.kidneyShot = TRB.Classes.SpellComboPointThreshold:New({
		id = 408,
		rankIds = { 408, 8643 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "kidneyShot",
		baseline = true,
		hasCooldown = true,
		category = "offensive",
	})
	spells.exposeArmor = TRB.Classes.SpellComboPointThreshold:New({
		id = 8647,
		rankIds = { 8647, 8649, 8650, 11197, 11198 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "exposeArmor",
		baseline = true,
		category = "offensive",
	})
	spells.venom = TRB.Classes.SpellComboPointThreshold:New({
		id = 1310703,
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "venom",
		isTalent = true,
		rangeCheck = false,
		category = "offensive",
	})

	-- Utility and defensive
	spells.feint = TRB.Classes.SpellThreshold:New({
		id = 1966,
		rankIds = { 1966, 6768, 8637, 11303, 25302 },
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "feint",
		baseline = true,
		hasCooldown = true,
		rangeCheck = false,
		category = "defensive",
	})
	spells.sap = TRB.Classes.SpellThreshold:New({
		id = 6770,
		rankIds = { 6770, 2070, 11297 },
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "sap",
		baseline = true,
		stealth = true,
		category = "utility",
	})
	spells.kick = TRB.Classes.SpellThreshold:New({
		id = 1766,
		rankIds = { 1766, 1767, 1768, 1769 },
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "kick",
		baseline = true,
		hasCooldown = true,
		category = "utility",
	})
	spells.distract = TRB.Classes.SpellThreshold:New({
		id = 1725,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "distract",
		baseline = true,
		hasCooldown = true,
		rangeCheck = false,
		category = "utility",
	})
	spells.blind = TRB.Classes.SpellThreshold:New({
		id = 2094,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "blind",
		baseline = true,
		hasCooldown = true,
		category = "utility",
	})
	spells.bladeFlurry = TRB.Classes.SpellThreshold:New({
		id = 13877,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "bladeFlurry",
		isTalent = true,
		hasCooldown = true,
		rangeCheck = false,
		category = "offensive",
	})
end

TRB.Forever.Templates.Classes:DefineClass("rogue", {
	general = {
		archetype = "energyComboPoints",
		stealth = true,
		icons = {
			"ambush", "backstab", "cheapShot", "eviscerate", "exposeArmor", "garrote", "gouge",
			"hemorrhage", "kick", "kidneyShot", "mutilate", "rupture", "sinisterStrike", "sliceAndDice",
		},
		spells = FillSpells,
	},
})
