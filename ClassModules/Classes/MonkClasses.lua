---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 10 then --Only do this if we're on a Monk!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Monk = TRB.Classes.Monk or {}


---@class TRB.Classes.Monk.MistweaverSpells : TRB.Classes.Healer.HealerSpells
---@field public soothingMist TRB.Classes.SpellBase
---@field public vivaciousVivification TRB.Classes.SpellBase
---@field public manaTea TRB.Classes.SpellBase
---@field public soulfangInfusion TRB.Classes.SpellBase
TRB.Classes.Monk.MistweaverSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Monk.MistweaverSpells.__index = TRB.Classes.Monk.MistweaverSpells

function TRB.Classes.Monk.MistweaverSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Monk.MistweaverSpells) --[[@as TRB.Classes.Monk.MistweaverSpells]]

    -- Monk Class Talents		
    self.soothingMist = TRB.Classes.SpellBase:New({
        id = 115175,
        isTalent = true,
        baseline = true,
        primaryResourceType = Enum.PowerType.Mana,
        primaryResourceTypeProperty = "costPerSec"
    })
    self.vivaciousVivification = TRB.Classes.SpellBase:New({
        id = 392883,
    })

    -- Mistweaver Spec Talents
    self.manaTea = TRB.Classes.SpellBase:New({
        id = 197908,
        isTalent = true
    })

    -- Tier Bonuses
    self.soulfangInfusion = TRB.Classes.SpellBase:New({ -- T30 2P
        id = 410007,
        ticks = 3,
        hasTicks = true,
        tickRate = 1,
        resourcePerTick = 0.01, --1% max mana. fill manually
        duration = 3
    })

    return self
end


---@class TRB.Classes.Monk.WindwalkerSpells : TRB.Classes.SpecializationSpellsBase
---@field public markOfTheCrane TRB.Classes.SpellBase
---@field public touchOfDeath TRB.Classes.SpellBase
---@field public paralysisRank2 TRB.Classes.SpellBase
---@field public strikeOfTheWindlord TRB.Classes.SpellBase
---@field public danceOfChiJi TRB.Classes.SpellBase
---@field public serenity TRB.Classes.SpellBase
---@field public blackoutKick TRB.Classes.SpellComboPoint
---@field public spinningCraneKick TRB.Classes.SpellComboPoint
---@field public risingSunKick TRB.Classes.SpellComboPoint
---@field public fistsOfFury TRB.Classes.SpellComboPoint
---@field public cracklingJadeLightning TRB.Classes.SpellThreshold
---@field public vivify TRB.Classes.SpellThreshold
---@field public detox TRB.Classes.SpellThreshold
---@field public disable TRB.Classes.SpellThreshold
---@field public paralysis TRB.Classes.SpellThreshold
---@field public expelHarm TRB.Classes.SpellComboPointThreshold
---@field public tigerPalm TRB.Classes.SpellComboPointThreshold
TRB.Classes.Monk.WindwalkerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Monk.WindwalkerSpells.__index = TRB.Classes.Monk.WindwalkerSpells

function TRB.Classes.Monk.WindwalkerSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Monk.WindwalkerSpells) --[[@as TRB.Classes.Monk.WindwalkerSpells]]

    -- Monk Class Baseline Abilities
    self.blackoutKick = TRB.Classes.SpellComboPoint:New({
        id = 100784,
        comboPoints = 1,
        isTalent = false,
        baseline = true
    })
    self.cracklingJadeLightning = TRB.Classes.SpellThreshold:New({
        id = 117952,
        primaryResourceType = Enum.PowerType.Energy,
        thresholdId = 1,
        settingKey = "cracklingJadeLightning",
        isTalent = false,
        baseline = true
    })
    self.expelHarm = TRB.Classes.SpellComboPointThreshold:New({
        id = 322101,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        thresholdId = 2,
        settingKey = "expelHarm",
        hasCooldown = true,
        cooldown = 15,
        isTalent = false,
        baseline = true
    })
    self.markOfTheCrane = TRB.Classes.SpellBase:New({
        id = 228287,
        duration = 20,
        isTalent = false,
        baseline = true
    })
    self.spinningCraneKick = TRB.Classes.SpellComboPoint:New({
        id = 101546,
        comboPoints = 2,
        isTalent = false,
        baseline = true
    })
    self.tigerPalm = TRB.Classes.SpellComboPointThreshold:New({
        id = 100780,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        thresholdId = 3,
        settingKey = "tigerPalm",
        isTalent = false,
        baseline = true
    })
    self.touchOfDeath = TRB.Classes.SpellBase:New({
        id = 322109,
        healthPercent = 0.35,
        eliteHealthPercent = 0.15,
        isTalent = false,
        baseline = true
    })
    self.vivify = TRB.Classes.SpellThreshold:New({
        id = 116670,
        primaryResourceType = Enum.PowerType.Energy,
        thresholdId = 4,
        settingKey = "vivify",
        isTalent = false,
        baseline = true
    })

    -- Windwalker Spec Baseline Abilities

    -- Monk Class Talents
    self.risingSunKick = TRB.Classes.SpellComboPoint:New({
        id = 107428,
        comboPoints = 2,
        isTalent = true,
        baseline = true
    })
    self.detox = TRB.Classes.SpellThreshold:New({
        id = 218164,
        primaryResourceType = Enum.PowerType.Energy,
        thresholdId = 5,
        settingKey = "detox",
        hasCooldown = true,
        cooldown = 8,
        isTalent = true,
        baseline = true -- TODO: Check this in a future build
    })
    self.disable = TRB.Classes.SpellThreshold:New({
        id = 116095,
        primaryResourceType = Enum.PowerType.Energy,
        thresholdId = 6,
        settingKey = "disable",
        hasCooldown = false,
        isTalent = true
    })
    self.paralysis = TRB.Classes.SpellThreshold:New({
        id = 115078,
        primaryResourceType = Enum.PowerType.Energy,
        thresholdId = 7,
        settingKey = "paralysis",
        hasCooldown = true,
        cooldown = 45,
        isTalent = true,
    })
    self.paralysisRank2 = TRB.Classes.SpellBase:New({
        id = 344359,
        cooldownMod = -15,
        isTalent = true,
    })

    -- Windwalker Spec Talent Abilities

    self.fistsOfFury = TRB.Classes.SpellComboPoint:New({
        id = 113656,
        comboPoints = 3,
        isTalent = true
    })

    -- Talents
    self.strikeOfTheWindlord = TRB.Classes.SpellBase:New({
        id = 392983,
        hasCooldown = true,
        isTalent = true,
        cooldown = 40
    })
    self.danceOfChiJi = TRB.Classes.SpellBase:New({
        id = 325202,
        isTalent = true
    })
    self.serenity = TRB.Classes.SpellBase:New({
        id = 152173,
        isTalent = true
    })

    return self
end