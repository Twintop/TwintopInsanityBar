local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Warrior = TRB.Classes.Warrior or {}

---@class TRB.Classes.Warrior.WarriorBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field public executeMinimum TRB.Classes.SpellThreshold -- Implemented by specializations
---@field public executeMaximum TRB.Classes.SpellThreshold -- Implemented by specializations
---@field public hamstring TRB.Classes.SpellThreshold
---@field public impendingVictory TRB.Classes.SpellThreshold
---@field public shieldBlock TRB.Classes.SpellThreshold
TRB.Classes.Warrior.WarriorBaseSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warrior.WarriorBaseSpells.__index = TRB.Classes.Warrior.WarriorBaseSpells

---Creates a new WarriorBaseSpells
---@return TRB.Classes.Warrior.WarriorBaseSpells
function TRB.Classes.Warrior.WarriorBaseSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warrior.WarriorBaseSpells) --[[@as TRB.Classes.Warrior.WarriorBaseSpells]]
	
	self.hamstring = TRB.Classes.SpellThreshold:New({
		id = 1715,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "hamstring",
		category = "utility",
		isTalent = false,
		baseline = true
	})
	self.impendingVictory = TRB.Classes.SpellThreshold:New({
		id = 202168,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "impendingVictory",
		category = "utility",
		isTalent = true,
		hasCooldown = true
	})
	self.shieldBlock = TRB.Classes.SpellThreshold:New({
		id = 2565,
		castId = 2565,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "shieldBlock",
		category = "defensive",
		buffId = 132404,
		isTalent = false,
		baseline = true,
		hasCooldown = true,
		rangeCheck = false,
		duration = 6
	})

    return self
end

---@class TRB.Classes.Warrior.ArmsSpells : TRB.Classes.Warrior.WarriorBaseSpells
---@field public improvedExecute TRB.Classes.SpellBase
---@field public slam TRB.Classes.SpellThreshold
---@field public whirlwind TRB.Classes.SpellThreshold
---@field public impendingVictory TRB.Classes.SpellThreshold
---@field public thunderClap TRB.Classes.SpellThreshold
---@field public mortalStrike TRB.Classes.SpellThreshold
---@field public rend TRB.Classes.SpellThreshold
---@field public cleave TRB.Classes.SpellThreshold
---@field public ignorePain TRB.Classes.SpellThreshold
TRB.Classes.Warrior.ArmsSpells = setmetatable({}, {__index = TRB.Classes.Warrior.WarriorBaseSpells})
TRB.Classes.Warrior.ArmsSpells.__index = TRB.Classes.Warrior.ArmsSpells

function TRB.Classes.Warrior.ArmsSpells:New()
	---@type TRB.Classes.Warrior.WarriorBaseSpells
	local base = TRB.Classes.Warrior.WarriorBaseSpells
	self = setmetatable(base:New(), TRB.Classes.Warrior.ArmsSpells) --[[@as TRB.Classes.Warrior.ArmsSpells]]
	--Warrior Class Baseline Abilities
	self.executeMinimum = TRB.Classes.SpellThreshold:New({
		id = 163201,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "minCost",
		settingKey = "executeMinimum",
		category = "execute",
		isTalent = false,
		baseline = true,
		hasCooldown = false,
		isSnowflake = true
	})
	self.executeMaximum = TRB.Classes.SpellThreshold:New({
		id = 163201,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "cost",
		settingKey = "executeMaximum",
		category = "execute",
		isTalent = false,
		baseline = true,
		hasCooldown = false,
		isSnowflake = true,
		canHaveAudioCue = false
	})
	self.slam = TRB.Classes.SpellThreshold:New({
		id = 1464,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		category = "offensive",
		isTalent = false,
		baseline = true,
		hasCooldown = false
	})
	self.whirlwind = TRB.Classes.SpellThreshold:New({
		id = 1680,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "whirlwind",
		category = "offensive",
		isTalent = false,
		baseline = true,
		isSnowflake = true
	})

	-- Arms Baseline Abilities

	-- Warrior Class Talents
	self.impendingVictory = TRB.Classes.SpellThreshold:New({
		id = 202168,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "impendingVictory",
		category = "utility",
		isTalent = true,
		hasCooldown = true
	})
	self.thunderClap = TRB.Classes.SpellThreshold:New({
		id = 6343,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "thunderClap",
		category = "offensive",
		isTalent = true,
		hasCooldown = true,
		rangeCheck = false
	})

	--Arms Talent abilities
	self.mortalStrike = TRB.Classes.SpellThreshold:New({
		id = 12294,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "mortalStrike",
		category = "offensive",
		isTalent = true,
		hasCooldown = true
	})
	self.improvedExecute = TRB.Classes.SpellBase:New({
		id = 316405,
		isTalent = true
	})
	self.rend = TRB.Classes.SpellThreshold:New({
		id = 772,
		debuffId = 388539,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "rend",
		category = "offensive",
		isTalent = true,
		hasCooldown = false,
		baseDuration = 15,
		pandemic = true
	})
	self.cleave = TRB.Classes.SpellThreshold:New({
		id = 845,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "cleave",
		category = "offensive",
		isTalent = true,
		hasCooldown = true,
		isSnowflake = true,
		rangeCheck = false
	})
	self.ignorePain = TRB.Classes.SpellThreshold:New({
		id = 190456,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "ignorePain",
		category = "defensive",
		isTalent = true,
		hasCooldown = true,
		duration = 11,
		rangeCheck = false
	})

	return self
end

---Fills barTextVariables for Arms Warrior options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warrior.ArmsSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warrior.ArmsSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#cleave", icon = spells.cleave.icon, description = spells.cleave.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		{ variable = "#mortalStrike", icon = spells.mortalStrike.icon, description = spells.mortalStrike.name, printInSettings = true },
		{ variable = "#rend", icon = spells.rend.icon, description = spells.rend.name, printInSettings = true },
		{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = spells.shieldBlock.name, printInSettings = true },
		{ variable = "#slam", icon = spells.slam.icon, description = spells.slam.name, printInSettings = true },
		{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = spells.whirlwind.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$rage", description = L["WarriorArmsBarTextVariable_rage"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$rageMax", description = L["WarriorArmsBarTextVariable_rageMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
	})
end

---Gets built-in castbar channel tick profiles for Arms, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Warrior.ArmsSpells.GetCastbarTickProfiles()
	return {
		-- Demolish: 3 hits landing on a 4-tick rhythm, skipping the 3rd. No tick at start, no chaining.
		[436358] = { mode = "fixedCount", baseDuration = 2, tickCount = 4, skipTicks = { 3 } },
	}
end


---@class TRB.Classes.Warrior.FurySpells : TRB.Classes.Warrior.WarriorBaseSpells
---@field public improvedWhirlwind TRB.Classes.SpellBase
---@field public unhinged TRB.Classes.SpellBase
---@field public enrage TRB.Classes.SpellBase
---@field public improvedExecute TRB.Classes.SpellBase
---@field public bladestorm TRB.Classes.SpellBase
---@field public slam TRB.Classes.SpellThreshold
---@field public impendingVictory TRB.Classes.SpellThreshold
---@field public thunderClap TRB.Classes.SpellThreshold
---@field public rampage TRB.Classes.SpellThreshold
TRB.Classes.Warrior.FurySpells = setmetatable({}, {__index = TRB.Classes.Warrior.WarriorBaseSpells})
TRB.Classes.Warrior.FurySpells.__index = TRB.Classes.Warrior.FurySpells

function TRB.Classes.Warrior.FurySpells:New()
	---@type TRB.Classes.Warrior.WarriorBaseSpells
	local base = TRB.Classes.Warrior.WarriorBaseSpells
	self = setmetatable(base:New(), TRB.Classes.Warrior.FurySpells) --[[@as TRB.Classes.Warrior.FurySpells]]
	--Warrior base abilities
	self.execute = TRB.Classes.SpellThreshold:New({
		id = 280735,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "minCost",
		settingKey = "execute",
		category = "execute",
		isTalent = false,
		baseline = true,
		hasCooldown = true,
		isSnowflake = true
	})
	self.executeMinimum = TRB.Classes.SpellThreshold:New({
		id = 280735,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "minCost",
		settingKey = "executeMinimum",
		category = "execute",
		isTalent = false,
		baseline = true,
		hasCooldown = true,
		isSnowflake = true
	})
	self.executeMaximum = TRB.Classes.SpellThreshold:New({
		id = 280735,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "cost",
		settingKey = "executeMaximum",
		category = "execute",
		isTalent = false,
		baseline = true,
		hasCooldown = true,
		isSnowflake = true,
		canHaveAudioCue = false
	})
	self.slam = TRB.Classes.SpellThreshold:New({
		id = 1464,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		category = "offensive",
		isTalent = false,
		baseline = true,
		hasCooldown = false
	})
	self.improvedWhirlwind = TRB.Classes.SpellBase:New({
		id = 85739,
		talentId = 12950,
		isTalent = true,
		duration = 20,
		maxStacks = 4,
		builderIds = {
			[190411] = true,	-- Whirlwind
		},
		spenderIds = {
			[5308] = true,		-- Execute
			[23881] = true, 	-- Bloodthirst
			[85288] = true, 	-- Raging Blow
			[184367] = true,	-- Rampage
			[202168] = true,	-- Impending Victory
			[280735] = true, 	-- Execute
			[335096] = true,	-- Bloodbath
			[335097] = true,	-- Crushing Blow
		}
	})
	
	--Fury base abilities
	-- id is the passive the Cooldown Manager keys its buff entry by; buffId is the aura that lands.
	self.enrage = TRB.Classes.SpellBase:New({
		id = 184361,
		buffId = 184362,
		isTalent = false,
		baseline = true,
	})

	-- Warrior Class Talents
	self.impendingVictory = TRB.Classes.SpellThreshold:New({
		id = 202168,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "impendingVictory",
		category = "utility",
		isTalent = true,
		hasCooldown = true
	})
	self.thunderClap = TRB.Classes.SpellThreshold:New({
		id = 6343,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "thunderClap",
		category = "offensive",
		isTalent = true,
		hasCooldown = true,
		isSnowflake = true,
		rangeCheck = false
	})

	-- Fury Talent abilities
	
	--Talents
	self.rampage = TRB.Classes.SpellThreshold:New({
		id = 184367,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "rampage",
		category = "offensive",
		isTalent = true,
		hasCooldown = false
	})
	self.improvedExecute = TRB.Classes.SpellBase:New({
		id = 316402,
		isTalent = true
	})
	self.suddenDeath = TRB.Classes.SpellBase:New({
		id = 280776,
		isTalent = true
	})
	
	self.bladestorm = TRB.Classes.SpellBase:New({
		id = 446035,
		talentId = 227847,
		isTalent = true,
		duration = 4, -- hasted
		isHasted = true
	})

	-- Mountain Thane	
	self.crashingThunder = TRB.Classes.SpellBase:New({
		id = 436707,
		isTalent = true,
		builderIds = {
			[6343] = true, 	-- Thunder Clap
			[435222] = true	-- Thunder Blast
		},
	})

	-- Slayer
	self.unhinged = TRB.Classes.SpellBase:New({
		id = 386628,
		isTalent = true
	})

	return self
end

---Fills barTextVariables for Fury Warrior options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warrior.FurySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warrior.FurySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#bladestorm", icon = spells.bladestorm.icon, description = spells.bladestorm.name, printInSettings = true },
		{ variable = "#enrage", icon = spells.enrage.icon, description = spells.enrage.name, printInSettings = true },
		{ variable = "#execute", icon = spells.execute.icon, description = spells.execute.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = spells.shieldBlock.name, printInSettings = true },
		{ variable = "#slam", icon = spells.slam.icon, description = spells.slam.name, printInSettings = true },
		{ variable = "#whirlwind", icon = spells.improvedWhirlwind.icon, description = spells.improvedWhirlwind.name, printInSettings = true }
	})

	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$rage", description = L["WarriorFuryBarTextVariable_rage"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$rageMax", description = L["WarriorFuryBarTextVariable_rageMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		{ variable = "$wwCharges", description = L["WarriorFuryBarTextVariable_wwCharges"], printInSettings = true, color = false },
		{ variable = "$whirlwindCharges", description = "", printInSettings = false, color = false },

		{ variable = "$wwTime", description = L["WarriorFuryBarTextVariable_wwTime"], printInSettings = true, color = false },
		{ variable = "$whirlwindTime", description = "", printInSettings = false, color = false },

		{ variable = "$enrageTime", description = L["WarriorFuryBarTextVariable_enrageTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
	})
end

---Gets built-in castbar channel tick profiles for Fury, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Warrior.FurySpells.GetCastbarTickProfiles()
	return {}
end

---@class TRB.Classes.Warrior.ProtectionSpells : TRB.Classes.Warrior.WarriorBaseSpells
---@field public enduringDefenses TRB.Classes.SpellBase
---@field public shieldCharge TRB.Classes.SpellBase
---@field public heavyRepercussions TRB.Classes.SpellBase
---@field public shieldSlam TRB.Classes.SpellBase
---@field public violentOutburst TRB.Classes.SpellBase
---@field public ignorePain TRB.Classes.SpellThreshold
---@field public rend TRB.Classes.SpellThreshold
---@field public revenge TRB.Classes.SpellThreshold
---@field public slam TRB.Classes.SpellThreshold
---@field public whirlwind TRB.Classes.SpellThreshold
TRB.Classes.Warrior.ProtectionSpells = setmetatable({}, {__index = TRB.Classes.Warrior.WarriorBaseSpells})
TRB.Classes.Warrior.ProtectionSpells.__index = TRB.Classes.Warrior.ProtectionSpells

function TRB.Classes.Warrior.ProtectionSpells:New()
	---@type TRB.Classes.Warrior.WarriorBaseSpells
	local base = TRB.Classes.Warrior.WarriorBaseSpells
	self = setmetatable(base:New(), TRB.Classes.Warrior.ProtectionSpells) --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	--Warrior base abilities	

	self.executeMinimum = TRB.Classes.SpellThreshold:New({
		id = 163201,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "minCost",
		settingKey = "executeMinimum",
		category = "execute",
		isTalent = false,
		baseline = true,
		isSnowflake = true
	})
	self.executeMaximum = TRB.Classes.SpellThreshold:New({
		id = 163201,
		healthMinimum = 0.2,
		primaryResourceType = Enum.PowerType.Rage,
		primaryResourceTypeProperty = "cost",
		settingKey = "executeMaximum",
		category = "execute",
		isTalent = false,
		baseline = true,
		isSnowflake = true,
		canHaveAudioCue = false
	})

	self.shieldBlock.hasCharges = true

	self.slam = TRB.Classes.SpellThreshold:New({
		id = 1464,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		category = "offensive",
		isTalent = false,
		baseline = true
	})
	self.whirlwind = TRB.Classes.SpellThreshold:New({
		id = 1680,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "whirlwind",
		category = "offensive",
		isTalent = false,
		baseline = true,
		rangeCheck = false
	})

	-- Protection Abilites
	self.enduringDefenses = TRB.Classes.SpellBase:New({
		id = 386027,
		isTalent = true,
		durationModPerRank = 1
	})
	self.shieldCharge = TRB.Classes.SpellBase:New({
		id = 385952,
		castId = 385954,
		isTalent = true
	})
	self.heavyRepercussions = TRB.Classes.SpellBase:New({
		id = 203177,
		isTalent = true,
		durationMod = 1
	})
	self.shieldSlam = TRB.Classes.SpellBase:New({
		id = 23922,
		isTalent = false,
		baseline = true
	})

	self.suddenDeath = TRB.Classes.SpellBase:New({
		id = 52437,
		talentId = 29725,
		isTalent = true
	})
	self.ignorePain = TRB.Classes.SpellThreshold:New({
		id = 190456,
		castId = 190456,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "ignorePain",
		category = "defensive",
		isTalent = true,
		hasCooldown = true,
		duration = 12,
		rangeCheck = false,
		---@type TRB.Classes.BuffCustomProperty[]
		customPropertyDefinitions = {
			TRB.Classes.BuffCustomProperty:New(1, "number", "absorb", 1)
		}
	})
	self.rend = TRB.Classes.SpellThreshold:New({
		id = 388539,
		talentId = 394062,
		debuffId = 388539,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "rend",
		category = "offensive",
		isTalent = true,
		baseDuration = 15,
		pandemic = true
	})
	self.revenge = TRB.Classes.SpellThreshold:New({
		id = 6572,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "revenge",
		category = "offensive",
		isTalent = true,
		rangeCheck = false
	})

	self.violentOutburst = TRB.Classes.SpellBase:New({
		id = 386478,
		talentId = 386477,
		isTalent = true,
		duration = 30
	})


	return self
end

---Fills barTextVariables for Protection Warrior options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warrior.ProtectionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warrior.ProtectionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#ignorePain", icon = spells.ignorePain.icon, description = spells.ignorePain.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		{ variable = "#rend", icon = spells.rend.icon, description = spells.rend.name, printInSettings = true },
		{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = spells.shieldBlock.name, printInSettings = true },
		{ variable = "#slam", icon = spells.slam.icon, description = spells.slam.name, printInSettings = true },
		{ variable = "#suddenDeath", icon = spells.suddenDeath.icon, description = spells.suddenDeath.name, printInSettings = true },
		{ variable = "#violentOutburst", icon = spells.violentOutburst.icon, description = spells.violentOutburst.name, printInSettings = true }
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$rage", description = L["WarriorProtectionBarTextVariable_rage"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$rageMax", description = L["WarriorProtectionBarTextVariable_rageMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		
		{ variable = "$ignorePainTime", description = L["WarriorProtectionBarTextVariable_ignorePainTime"], printInSettings = true, color = false },
		-- Absorb pool has no source but the Cooldown Manager; the time above is snapshot-driven.
		{ variable = "$ignorePainAbsorb", description = L["WarriorProtectionBarTextVariable_ignorePainAbsorb"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },

		{ variable = "$shieldBlockTime", description = L["WarriorProtectionBarTextVariable_shieldBlockTime"], printInSettings = true, color = false },
		{ variable = "$shieldBlockCharges", description = L["WarriorProtectionBarTextVariable_shieldBlockCharges"], printInSettings = true, color = false, secret = true },
		{ variable = "$shieldBlockMaxCharges", description = L["WarriorProtectionBarTextVariable_shieldBlockMaxCharges"], printInSettings = true, color = false, secret = true },

		{ variable = "$voTime", description = L["WarriorProtectionBarTextVariable_voTime"], printInSettings = true, color = false },
		{ variable = "$violentOutburstTime", description = "", printInSettings = false, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Protection, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Warrior.ProtectionSpells.GetCastbarTickProfiles()
	return {
		-- Demolish: 3 hits landing on a 4-tick rhythm, skipping the 3rd. No tick at start, no chaining.
		[436358] = { mode = "fixedCount", baseDuration = 2, tickCount = 4, skipTicks = { 3 } },
	}
end


--[[
    BarGroups Factory for Warrior
    Creates the appropriate BarGroup instances for each Warrior specialization.
    
    Arms: Primary bar (N=1) only
    Fury: Primary bar (N=1) only
    Protection: Primary bar (N=1) + Defensive Buffs (N=2) for Shield Block and Ignore Pain
]]

---@class TRB.Classes.Warrior.BarGroupsFactory
TRB.Classes.Warrior.BarGroupsFactory = {}
TRB.Classes.Warrior.BarGroupsFactory.__index = TRB.Classes.Warrior.BarGroupsFactory

---Creates BarGroup instances for the specified Warrior specialization
---@param specId integer # 1=Arms, 2=Fury, 3=Protection
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary Rage bar (1 node) - all specs
    -- Primary bar groups are parented directly to UIParent for proper positioning
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Protection has defensives bar for defensive buffs (Shield Block + Ignore Pain)
    -- Defensives bars are parented to UIParent for independent visibility
    if specId == 3 then
        barGroups.defensives = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Defensives",
            3, -- Ignore Pain (Time), Ignore Pain (Absorb), Shield Block
            false -- not primary
        )
    end

    -- Fury has Whirlwind stacks bar (4 nodes) via secondary, plus a stand-alone Enrage bar
    if specId == 2 then
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Secondary",
            4,
            false
        )
        barGroups.enrage = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Enrage",
            1,
            false -- not primary
        )
    end

    -- Health bar (1 node) - all specs
    barGroups.health = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_Health",
        1,
        false -- not primary
    )

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Warrior.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 3 then -- Protection
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Rage"
            },
            defensives = {
                maxNodes = 3,
                isPrimary = false,
				resourceType = "DefensiveBuffs",
				allowContainerAnchor = false
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 2 then -- Fury
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Rage"
            },
            secondary = {
                maxNodes = 4,
                isPrimary = false,
                resourceType = "WhirlwindCharges"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    else -- Arms
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Rage"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    end
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["warrior_arms"] = TRB.Classes.Warrior.ArmsSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["warrior_fury"] = TRB.Classes.Warrior.FurySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["warrior_protection"] = TRB.Classes.Warrior.ProtectionSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["warrior_arms"] = TRB.Classes.Warrior.ArmsSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["warrior_fury"] = TRB.Classes.Warrior.FurySpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["warrior_protection"] = TRB.Classes.Warrior.ProtectionSpells.GetCastbarTickProfiles

-- Register audio cue vocabularies
do
	local L = TRB.Localization

	TRB.Functions.AudioCues:Register("warrior_protection", {
		builtIns = {
			{
				id = "violentOutburst",
				label = L["WarriorAudioViolentOutburstProc"],
				trigger = L["WarriorAudioTriggerViolentOutburst"],
				tooltip = L["WarriorAudioCheckboxViolentOutburstTooltip"],
			},
		},
	})
end
