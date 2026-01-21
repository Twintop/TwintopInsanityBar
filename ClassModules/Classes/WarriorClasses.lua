local _, TRB = ...
if TRB.Data.character.classId ~= 1 then --Only do this if we're on a Warrior!
	return
end

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
		isTalent = false,
		baseline = true
	})
	self.impendingVictory = TRB.Classes.SpellThreshold:New({
		id = 202168,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "impendingVictory",
		isTalent = true,
		hasCooldown = true
	})
	self.shieldBlock = TRB.Classes.SpellThreshold:New({
		id = 2565,
		castId = 2565,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "shieldBlock",
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
		isTalent = false,
		baseline = true,
		hasCooldown = false,
		isSnowflake = true
	})
	self.slam = TRB.Classes.SpellThreshold:New({
		id = 1464,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		isTalent = false,
		baseline = true,
		hasCooldown = false
	})
	self.whirlwind = TRB.Classes.SpellThreshold:New({
		id = 1680,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "whirlwind",
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
		isTalent = true,
		hasCooldown = true
	})
	self.thunderClap = TRB.Classes.SpellThreshold:New({
		id = 6343,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "thunderClap",
		isTalent = true,
		hasCooldown = true,
		rangeCheck = false
	})

	--Arms Talent abilities
	self.mortalStrike = TRB.Classes.SpellThreshold:New({
		id = 12294,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "mortalStrike",
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
		isTalent = true,
		hasCooldown = false,
		baseDuration = 15,
		pandemic = true
	})
	self.cleave = TRB.Classes.SpellThreshold:New({
		id = 845,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "cleave",
		isTalent = true,
		hasCooldown = true,
		isSnowflake = true,
		rangeCheck = false
	})
	self.ignorePain = TRB.Classes.SpellThreshold:New({
		id = 190456,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "ignorePain",
		isTalent = true,
		hasCooldown = true,
		duration = 11,
		rangeCheck = false
	})

	return self
end


---@class TRB.Classes.Warrior.FurySpells : TRB.Classes.Warrior.WarriorBaseSpells
---@field public whirlwind TRB.Classes.SpellBase
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
		isTalent = false,
		baseline = true,
		hasCooldown = true,
		isSnowflake = true
	})
	self.slam = TRB.Classes.SpellThreshold:New({
		id = 1464,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		isTalent = false,
		baseline = true,
		hasCooldown = false
	})
	self.whirlwind = TRB.Classes.SpellBase:New({
		id = 85739, --buff ID
	})
	
	--Fury base abilities
	self.enrage = TRB.Classes.SpellBase:New({
		id = 184362,
		isTalent = false,
		baseline = true,
	})

	-- Warrior Class Talents
	self.impendingVictory = TRB.Classes.SpellThreshold:New({
		id = 202168,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "impendingVictory",
		isTalent = true,
		hasCooldown = true
	})
	self.thunderClap = TRB.Classes.SpellThreshold:New({
		id = 6343,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "thunderClap",
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
		id = 227847,
		hasTicks = true,
		tickRate = 1,
		duration = 4,
		resourcePerTick = 10,
		energizeId = 50622,
		isHasted = true
	})

	-- Mountain Thane	
	self.crashingThunder = TRB.Classes.SpellBase:New({
		id = 436707,
		isTalent = true
	})

	return self
end

---@class TRB.Classes.Warrior.ProtectionSpells : TRB.Classes.Warrior.WarriorBaseSpells
---@field public enduringDefenses TRB.Classes.SpellBase
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
		isTalent = false,
		baseline = true,
		isSnowflake = true
	})

	self.shieldBlock.hasCharges = true

	self.slam = TRB.Classes.SpellThreshold:New({
		id = 1464,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "slam",
		isTalent = false,
		baseline = true
	})
	self.whirlwind = TRB.Classes.SpellThreshold:New({
		id = 1680,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "whirlwind",
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
		isTalent = true,
		baseDuration = 15,
		pandemic = true
	})
	self.revenge = TRB.Classes.SpellThreshold:New({
		id = 6572,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "revenge",
		isTalent = true,
		rangeCheck = false
	})

	return self
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
            2, -- Shield Block and Ignore Pain
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
                isPrimary = true
            },
            defensives = {
                maxNodes = 2,
                isPrimary = false,
                resourceType = "DefensiveBuffs"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    else -- Arms and Fury
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    end
end