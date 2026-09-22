local _, TRB = ...

-- Warrior (World of Warcraft: Forever): Rage. Loads in the Classes stage, before Core's Functions,
-- so nothing here calls TRB.Functions.

-- A threshold's `stances` set hides its line outside those stances; Warrior.lua resolves the active one.
local battle = { battle = true }
local defensive = { defensive = true }
local berserker = { berserker = true }
local battleBerserker = { battle = true, berserker = true }
local battleDefensive = { battle = true, defensive = true }

---@class TRB.Classes.Warrior.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public heroicStrike TRB.Classes.SpellThreshold
---@field public cleave TRB.Classes.SpellThreshold
---@field public rend TRB.Classes.SpellThreshold
---@field public thunderClap TRB.Classes.SpellThreshold
---@field public overpower TRB.Classes.SpellThreshold
---@field public execute TRB.Classes.SpellThreshold
---@field public sunderArmor TRB.Classes.SpellThreshold
---@field public revenge TRB.Classes.SpellThreshold
---@field public slam TRB.Classes.SpellThreshold
---@field public whirlwind TRB.Classes.SpellThreshold
---@field public shieldSlam TRB.Classes.SpellThreshold
---@field public mortalStrike TRB.Classes.SpellThreshold
---@field public bloodthirst TRB.Classes.SpellThreshold
---@field public deathWish TRB.Classes.SpellThreshold
---@field public sweepingStrikes TRB.Classes.SpellThreshold
---@field public spearingStrike TRB.Classes.SpellThreshold
---@field public hamstring TRB.Classes.SpellThreshold
---@field public shieldBash TRB.Classes.SpellThreshold
---@field public intercept TRB.Classes.SpellThreshold
---@field public pummel TRB.Classes.SpellThreshold
---@field public battleShout TRB.Classes.SpellThreshold
---@field public demoralizingShout TRB.Classes.SpellThreshold
---@field public intimidatingShout TRB.Classes.SpellThreshold
---@field public disarm TRB.Classes.SpellThreshold
---@field public concussionBlow TRB.Classes.SpellThreshold
---@field public piercingHowl TRB.Classes.SpellThreshold
---@field public shieldBlock TRB.Classes.SpellThreshold
---@field public challengingShout TRB.Classes.SpellThreshold
---@field public mockingBlow TRB.Classes.SpellThreshold

---Adds the Warrior's Rage-spending abilities to a new spell set.
---@param spells TRB.Classes.Warrior.GeneralSpells
local function FillSpells(spells)
	-- Offensive
	spells.heroicStrike = TRB.Classes.SpellThreshold:New({
		id = 78,
		rankIds = { 78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "heroicStrike",
		baseline = true,
		category = "offensive",
	})
	spells.cleave = TRB.Classes.SpellThreshold:New({
		id = 845,
		rankIds = { 845, 7369, 11608, 11609, 20569 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "cleave",
		baseline = true,
		category = "offensive",
	})
	spells.rend = TRB.Classes.SpellThreshold:New({
		id = 772,
		rankIds = { 772, 6546, 6547, 6548, 11572, 11573, 11574 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "rend",
		baseline = true,
		stances = battleDefensive,
		category = "offensive",
	})
	spells.thunderClap = TRB.Classes.SpellThreshold:New({
		id = 6343,
		rankIds = { 6343, 8198, 8204, 8205, 11580, 11581 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "thunderClap",
		baseline = true,
		hasCooldown = true,
		stances = battleDefensive,
		rangeCheck = false,
		category = "offensive",
	})
	spells.overpower = TRB.Classes.SpellThreshold:New({
		id = 7384,
		rankIds = { 7384, 7887, 11584, 11585 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "overpower",
		baseline = true,
		hasCooldown = true,
		stances = battle,
		category = "offensive",
	})
	spells.execute = TRB.Classes.SpellThreshold:New({
		id = 5308,
		rankIds = { 5308, 20658, 20660, 20661, 20662 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "execute",
		baseline = true,
		stances = battleBerserker,
		category = "execute",
	})
	spells.sunderArmor = TRB.Classes.SpellThreshold:New({
		id = 7386,
		rankIds = { 7386, 7405, 8380, 11596, 11597 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "sunderArmor",
		baseline = true,
		category = "offensive",
	})
	spells.revenge = TRB.Classes.SpellThreshold:New({
		id = 6572,
		rankIds = { 6572, 6574, 7379, 11600, 11601, 25288 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "revenge",
		baseline = true,
		hasCooldown = true,
		stances = defensive,
		category = "offensive",
	})
	spells.slam = TRB.Classes.SpellThreshold:New({
		id = 1240193,
		rankIds = { 1240193, 1464, 8820, 11604, 11605 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		baseline = true,
		hasCooldown = true,
		category = "offensive",
	})
	spells.whirlwind = TRB.Classes.SpellThreshold:New({
		id = 1680,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "whirlwind",
		baseline = true,
		hasCooldown = true,
		stances = berserker,
		rangeCheck = false,
		category = "offensive",
	})
	spells.shieldSlam = TRB.Classes.SpellThreshold:New({
		id = 23922,
		rankIds = { 23922, 23923, 23924, 23925 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "shieldSlam",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
	})
	spells.mortalStrike = TRB.Classes.SpellThreshold:New({
		id = 12294,
		rankIds = { 12294, 21551, 21552, 21553 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "mortalStrike",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
	})
	spells.bloodthirst = TRB.Classes.SpellThreshold:New({
		id = 23881,
		rankIds = { 23881, 23892, 23893, 23894 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "bloodthirst",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
	})
	spells.deathWish = TRB.Classes.SpellThreshold:New({
		id = 12328,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "deathWish",
		isTalent = true,
		hasCooldown = true,
		rangeCheck = false,
		category = "offensive",
	})
	spells.sweepingStrikes = TRB.Classes.SpellThreshold:New({
		id = 12292,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "sweepingStrikes",
		isTalent = true,
		hasCooldown = true,
		stances = battle,
		rangeCheck = false,
		category = "offensive",
	})
	spells.spearingStrike = TRB.Classes.SpellThreshold:New({
		id = 1310222,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "spearingStrike",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
	})

	-- Utility
	spells.hamstring = TRB.Classes.SpellThreshold:New({
		id = 1715,
		rankIds = { 1715, 7372, 7373 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "hamstring",
		baseline = true,
		stances = battleBerserker,
		category = "utility",
	})
	spells.shieldBash = TRB.Classes.SpellThreshold:New({
		id = 72,
		rankIds = { 72, 1671, 1672 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "shieldBash",
		baseline = true,
		hasCooldown = true,
		stances = battleDefensive,
		category = "utility",
	})
	spells.intercept = TRB.Classes.SpellThreshold:New({
		id = 20252,
		rankIds = { 20252, 20616, 20617 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "intercept",
		baseline = true,
		hasCooldown = true,
		stances = berserker,
		category = "utility",
	})
	spells.pummel = TRB.Classes.SpellThreshold:New({
		id = 6552,
		rankIds = { 6552, 6554 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "pummel",
		baseline = true,
		hasCooldown = true,
		stances = berserker,
		category = "utility",
	})
	spells.battleShout = TRB.Classes.SpellThreshold:New({
		id = 6673,
		rankIds = { 6673, 5242, 6192, 11549, 11550, 11551, 25289 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "battleShout",
		baseline = true,
		rangeCheck = false,
		category = "utility",
	})
	spells.demoralizingShout = TRB.Classes.SpellThreshold:New({
		id = 1160,
		rankIds = { 1160, 6190, 11554, 11555, 11556 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "demoralizingShout",
		baseline = true,
		rangeCheck = false,
		category = "utility",
	})
	spells.intimidatingShout = TRB.Classes.SpellThreshold:New({
		id = 5246,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "intimidatingShout",
		baseline = true,
		hasCooldown = true,
		category = "utility",
	})
	spells.disarm = TRB.Classes.SpellThreshold:New({
		id = 676,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "disarm",
		baseline = true,
		hasCooldown = true,
		stances = defensive,
		category = "utility",
	})
	spells.concussionBlow = TRB.Classes.SpellThreshold:New({
		id = 12809,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "concussionBlow",
		isTalent = true,
		hasCooldown = true,
		category = "utility",
	})
	spells.piercingHowl = TRB.Classes.SpellThreshold:New({
		id = 12323,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "piercingHowl",
		isTalent = true,
		rangeCheck = false,
		category = "utility",
	})

	-- Defensive
	spells.shieldBlock = TRB.Classes.SpellThreshold:New({
		id = 2565,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "shieldBlock",
		baseline = true,
		hasCooldown = true,
		stances = defensive,
		rangeCheck = false,
		category = "defensive",
	})
	spells.challengingShout = TRB.Classes.SpellThreshold:New({
		id = 1161,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "challengingShout",
		baseline = true,
		hasCooldown = true,
		rangeCheck = false,
		category = "defensive",
	})
	spells.mockingBlow = TRB.Classes.SpellThreshold:New({
		id = 694,
		rankIds = { 694, 7400, 7402, 20559, 20560 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "mockingBlow",
		baseline = true,
		hasCooldown = true,
		stances = battle,
		category = "defensive",
	})
end

TRB.Forever.Templates.Classes:DefineClass("warrior", {
	general = {
		archetype = "rage",
		icons = {
			"battleShout", "bloodthirst", "challengingShout", "cleave", "concussionBlow", "deathWish",
			"demoralizingShout", "disarm", "execute", "hamstring", "heroicStrike", "intercept",
			"intimidatingShout", "mockingBlow", "mortalStrike", "overpower", "piercingHowl", "pummel",
			"rend", "revenge", "shieldBash", "shieldBlock", "shieldSlam", "slam", "spearingStrike",
			"sunderArmor", "sweepingStrikes", "thunderClap", "whirlwind",
		},
		spells = FillSpells,
	},
})
