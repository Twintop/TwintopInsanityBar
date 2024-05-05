local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 1 then --Only do this if we're on a Warrior!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Warrior = TRB.Classes.Warrior or {}


---@class TRB.Classes.Warrior.ArmsSpells : TRB.Classes.SpecializationSpellsBase
---@field public charge TRB.Classes.SpellBase
---@field public deepWounds TRB.Classes.SpellBase
---@field public improvedExecute TRB.Classes.SpellBase
---@field public suddenDeath TRB.Classes.SpellBase
---@field public massacre TRB.Classes.SpellBase
---@field public bloodletting TRB.Classes.SpellBase
---@field public execute TRB.Classes.SpellThreshold
---@field public executeMinimum TRB.Classes.SpellThreshold
---@field public executeMaximum TRB.Classes.SpellThreshold
---@field public shieldBlock TRB.Classes.SpellThreshold
---@field public slam TRB.Classes.SpellThreshold
---@field public whirlwind TRB.Classes.SpellThreshold
---@field public impendingVictory TRB.Classes.SpellThreshold
---@field public thunderClap TRB.Classes.SpellThreshold
---@field public mortalStrike TRB.Classes.SpellThreshold
---@field public rend TRB.Classes.SpellThreshold
---@field public cleave TRB.Classes.SpellThreshold
---@field public ignorePain TRB.Classes.SpellThreshold
TRB.Classes.Warrior.ArmsSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warrior.ArmsSpells.__index = TRB.Classes.Warrior.ArmsSpells

function TRB.Classes.Warrior.ArmsSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warrior.ArmsSpells) --[[@as TRB.Classes.Warrior.ArmsSpells]]
    --Warrior Class Baseline Abilities
    self.charge = TRB.Classes.SpellBase:New({
        id = 100,
        resource = 20,
        isTalent = false,
        baseline = true,
    })
    self.execute = TRB.Classes.SpellThreshold:New({
        id = 163201,
        healthMinimum = 0.2,
        primaryResourceType = Enum.PowerType.Rage,
        primaryResourceTypeProperty = "minCost",
        thresholdId = 1,
        settingKey = "execute",
        isTalent = false,
        baseline = true,
        hasCooldown = true,
        isSnowflake = true
    })
    self.executeMinimum = TRB.Classes.SpellThreshold:New({
        id = 163201,
        healthMinimum = 0.2,
        primaryResourceType = Enum.PowerType.Rage,
        primaryResourceTypeProperty = "minCost",
        thresholdId = 2,
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
        thresholdId = 3,
        settingKey = "executeMaximum",
        isTalent = false,
        baseline = true,
        hasCooldown = false,
        isSnowflake = true
    })
    self.hamstring = TRB.Classes.SpellThreshold:New({
        id = 1715,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 4,
        settingKey = "hamstring",
        isTalent = false,
        baseline = true
    })
    self.shieldBlock = TRB.Classes.SpellThreshold:New({
        id = 2565,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 5,
        settingKey = "shieldBlock",
        isTalent = false,
        baseline = true,
        hasCooldown = true
    })
    self.slam = TRB.Classes.SpellThreshold:New({
        id = 1464,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 6,
        settingKey = "slam",
        isTalent = false,
        baseline = true,
        hasCooldown = false
    })
    self.whirlwind = TRB.Classes.SpellThreshold:New({
        id = 1680,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 7,
        settingKey = "whirlwind",
        isTalent = false,
        baseline = true
    })

    -- Arms Baseline Abilities
    self.deepWounds = TRB.Classes.SpellBase:New({
        id = 262115,
        baseDuration = 10,
        pandemic = true,
        pandemicTime = 3 --Refreshes add 12sec, capping at 15? --10 * 0.3				
    })

    -- Warrior Class Talents
    self.impendingVictory = TRB.Classes.SpellThreshold:New({
        id = 202168,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 8,
        settingKey = "impendingVictory",
        isTalent = true,
        hasCooldown = true
    })
    self.thunderClap = TRB.Classes.SpellThreshold:New({
        id = 396719,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 9,
        settingKey = "thunderClap",
        isTalent = true,
        hasCooldown = true
    })

    --Arms Talent abilities
    self.mortalStrike = TRB.Classes.SpellThreshold:New({
        id = 12294,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 10,
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
        thresholdId = 11,
        settingKey = "rend",
        isTalent = true,
        hasCooldown = false,
        baseDuration = 15,
        pandemic = true
    })
    self.cleave = TRB.Classes.SpellThreshold:New({
        id = 845,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 12,
        settingKey = "cleave",
        isTalent = true,
        hasCooldown = true
    })
    self.ignorePain = TRB.Classes.SpellThreshold:New({
        id = 190456,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 13,
        settingKey = "ignorePain",
        isTalent = true,
        hasCooldown = true,
        duration = 11
    })
    self.suddenDeath = TRB.Classes.SpellBase:New({
        id = 52437
    })
    self.massacre = TRB.Classes.SpellBase:New({
        id = 281001,
        healthMinimum = 0.35,
        isTalent = true
    })
    self.bloodletting = TRB.Classes.SpellBase:New({
        id = 383154,
        pandemicModifier = 6,
        isTalent = true
    })

    return self
end


---@class TRB.Classes.Warrior.FurySpells : TRB.Classes.SpecializationSpellsBase
---@field public charge TRB.Classes.SpellBase
---@field public whirlwind TRB.Classes.SpellBase
---@field public enrage TRB.Classes.SpellBase
---@field public improvedExecute TRB.Classes.SpellBase
---@field public suddenDeath TRB.Classes.SpellBase
---@field public massacre TRB.Classes.SpellBase
---@field public ravager TRB.Classes.SpellBase
---@field public stormOfSteel TRB.Classes.SpellBase
---@field public execute TRB.Classes.SpellThreshold
---@field public executeMinimum TRB.Classes.SpellThreshold
---@field public executeMaximum TRB.Classes.SpellThreshold
---@field public hamstring TRB.Classes.SpellThreshold
---@field public shieldBlock TRB.Classes.SpellThreshold
---@field public slam TRB.Classes.SpellThreshold
---@field public impendingVictory TRB.Classes.SpellThreshold
---@field public thunderClap TRB.Classes.SpellThreshold
---@field public rampage TRB.Classes.SpellThreshold
TRB.Classes.Warrior.FurySpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warrior.FurySpells.__index = TRB.Classes.Warrior.FurySpells

function TRB.Classes.Warrior.FurySpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warrior.FurySpells) --[[@as TRB.Classes.Warrior.FurySpells]]
	--Warrior base abilities
    self.charge = TRB.Classes.SpellBase:New({
        id = 100,
        resource = 20,
        isTalent = false,
        baseline = true,
    })
    self.execute = TRB.Classes.SpellThreshold:New({
        id = 280735,
        healthMinimum = 0.2,
        primaryResourceType = Enum.PowerType.Rage,
        primaryResourceTypeProperty = "minCost",
        thresholdId = 1,
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
        thresholdId = 2,
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
        thresholdId = 3,
        settingKey = "executeMaximum",
        isTalent = false,
        baseline = true,
        hasCooldown = true,
        isSnowflake = true
    })
    self.hamstring = TRB.Classes.SpellThreshold:New({
        id = 1715,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 4,
        settingKey = "hamstring",
        isTalent = false,
        baseline = true
    })
    self.shieldBlock = TRB.Classes.SpellThreshold:New({
        id = 2565,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 5,
        settingKey = "shieldBlock",
        isTalent = false,
        baseline = true,
        hasCooldown = true
    })
    self.slam = TRB.Classes.SpellThreshold:New({
        id = 1464,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 6,
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
        thresholdId = 7,
        settingKey = "impendingVictory",
        isTalent = true,
        hasCooldown = true
    })
    self.thunderClap = TRB.Classes.SpellThreshold:New({
        id = 396719,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 8,
        settingKey = "thunderClap",
        isTalent = true,
        hasCooldown = true
    })

    -- Fury Talent abilities
    
    --Talents
    self.rampage = TRB.Classes.SpellThreshold:New({
        id = 184367,
        primaryResourceType = Enum.PowerType.Rage,
        thresholdId = 9,
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
    self.massacre = TRB.Classes.SpellBase:New({
        id = 206315,
        isTalent = true,
        healthMinimum = 0.35
    })
    self.ravager = TRB.Classes.SpellBase:New({
        id = 228920,
        hasTicks = true,
        tickRate = 2,
        duration = 12,
        resourcePerTick = 10,
        energizeId = 334934
    })
    self.stormOfSteel = TRB.Classes.SpellBase:New({
        id = 382953,
        resourcePerTick = 10,
        charges = 2,
        isTalent = true
    })

    return self
end