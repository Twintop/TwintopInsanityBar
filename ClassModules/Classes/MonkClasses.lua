---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 10 then --Only do this if we're on a Monk!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Monk = TRB.Classes.Monk or {}

--[[
    ********************
    ***** Mana Tea *****
    ********************
    ]]

---@class TRB.Classes.Monk.ManaTea : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
---@field private manaTeaRegenSnapshot TRB.Classes.Snapshot
---@field private energizingBrewSpell TRB.Classes.SpellBase
---@field private talents TRB.Classes.Talents
TRB.Classes.Monk.ManaTea = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Monk.ManaTea.__index = TRB.Classes.Monk.ManaTea

---Creates a new Mana Tea object
---@param spell table # Spell we are snapshotting, in this case Mana Tea
---@param manaTeaRegenSnapshot TRB.Classes.Snapshot # Snapshot of manaTeaRegen used by the rest of the Mistweaver implementation
---@param energizingBrewSpell TRB.Classes.SpellBase # Energizing Brew spell, for reference data
---@param talents TRB.Classes.Talents # Talents object for Mistweaver
---@return TRB.Classes.Monk.ManaTea
function TRB.Classes.Monk.ManaTea:New(spell, manaTeaRegenSnapshot, energizingBrewSpell, talents)
    ---@type TRB.Classes.Healer.HealerRegenBase
    local snapshot = TRB.Classes.Healer.HealerRegenBase
    local self = setmetatable(snapshot:New(spell), TRB.Classes.Monk.ManaTea)
    self:Reset()
    self.attributes = {}
    self.manaTeaRegenSnapshot = manaTeaRegenSnapshot
    self.energizingBrewSpell = energizingBrewSpell
    self.talents = talents
    return self
end

---Updates Mana Tea's values
function TRB.Classes.Monk.ManaTea:Update()
    if self.manaTeaRegenSnapshot.buff.isActive then
        self.mana = self:GetMaxManaReturn()
    else
        self.mana = 0
    end
end

function TRB.Classes.Monk.ManaTea:GetMaxManaReturn()
    local gcd = TRB.Functions.Character:GetCurrentGCDTime()
    local resourcePerTick = self.spell.resourcePerTick
    local tickRate = self.spell.tickRate

    if self.talents:IsTalentActive(self.energizingBrewSpell) then
        resourcePerTick = resourcePerTick * self.energizingBrewSpell.resourcePerTickMod
        tickRate = tickRate * self.energizingBrewSpell.tickRateMod
    end
    return (TRB.Data.snapshotData.attributes.manaRegen * tickRate * (self.buff.applications * (gcd / 1.5))) + (self.buff.applications * resourcePerTick * TRB.Data.character.maxResource)
end


---@class TRB.Classes.Monk.MistweaverSpells : TRB.Classes.Healer.HealerSpells
---@field public soothingMist TRB.Classes.SpellBase
---@field public vivaciousVivification TRB.Classes.SpellBase
---@field public manaTea TRB.Classes.SpellBase
---@field public energizingBrew TRB.Classes.SpellBase
---@field public sheilunsGift TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpent TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpentStacks TRB.Classes.SpellBase
---@field public manaTeaCharges TRB.Classes.SpellThreshold
---@field public cannibalize TRB.Classes.SpellThreshold
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
        primaryResourceType = Enum.PowerType.Mana,
        primaryResourceTypeProperty = "costPerSec"
    })
    self.vivaciousVivification = TRB.Classes.SpellBase:New({
        id = 392883,
    })

    -- Mistweaver Spec Talents
    self.manaTea = TRB.Classes.SpellBase:New({
        id = 197908,
        talentId = 115869,
        isTalent = true
    })
    self.manaTeaRegen = TRB.Classes.SpellBase:New({
        id = 115294,
        talentId = 115869,
        isTalent = true
    })
    self.manaTeaCharges = TRB.Classes.SpellThreshold:New({
        id = 115867,
        talentId = 115869,
        hasTicks = true,
        tickRate = 0.5, -- hasted
        resourcePerTick = 0.021,
        settingKey = "manaTeaCharges",
        primaryResourceType = Enum.PowerType.Mana,
        isSnowflake = true,
    })
    self.energizingBrew = TRB.Classes.SpellBase:New({
        id = 422031,
        isTalent = true,
        resourcePerTickMod = 1.2,
        tickRateMod = 0.5
    })
    self.sheilunsGift = TRB.Classes.SpellBase:New({
        id = 399491,
        isTalent = true,
        hasCastCount = true,
        maxCastCount = 10
    })
    self.shaohaosLessons = TRB.Classes.SpellBase:New({
        id = 400089,
        isTalent = true,
        maxStacksMod = -10
    })

    -- Conduit of the Celestials
    self.heartOfTheJadeSerpent = TRB.Classes.SpellBase:New({
        id = 443421,
        talentId = 443294,
        isTalent = true,
        isBuff = true
    })
    self.heartOfTheJadeSerpentStacks = TRB.Classes.SpellBase:New({
        id = 443506,
        talentId = 443294,
        isTalent = true,
        isBuff = true,
        hasStacks = true,
        maxStacks = 20
    })

    -- Racials
    self.cannibalize = TRB.Classes.SpellThreshold:New({
        id = 20577,
        buffId = 20578,
        baseline = true,
        resourcePerTick = 0.07,
        duration = 10,
        hasTicks = true,
        tickRate = 2,
        settingKey = "cannibalize",
        primaryResourceType = Enum.PowerType.Mana,
        isSnowflake = true,
        hasCooldown = true
    })

    return self
end


---@class TRB.Classes.Monk.WindwalkerSpells : TRB.Classes.SpecializationSpellsBase
---@field public markOfTheCrane TRB.Classes.SpellBase
---@field public touchOfDeath TRB.Classes.SpellBase
---@field public paralysisRank2 TRB.Classes.SpellBase
---@field public strikeOfTheWindlord TRB.Classes.SpellBase
---@field public danceOfChiJi TRB.Classes.SpellBase
---@field public combatWisdom TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpent TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpentReady TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpentStacks TRB.Classes.SpellBase
---@field public flurryCharge TRB.Classes.SpellBase
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
        settingKey = "cracklingJadeLightning",
        isTalent = false,
        baseline = true
    })
    self.expelHarm = TRB.Classes.SpellComboPointThreshold:New({
        id = 322101,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "expelHarm",
        hasCooldown = true,
        cooldown = 15,
        isTalent = false,
        baseline = true,
        isSnowflake = true
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
        settingKey = "vivify",
        isTalent = false,
        baseline = true
    })

    -- Windwalker Spec Baseline Abilities

    -- Monk Class Talents
    self.combatWisdom = TRB.Classes.SpellBase:New({
        id = 121817,
        isTalent = true
    })
    self.risingSunKick = TRB.Classes.SpellComboPoint:New({
        id = 107428,
        comboPoints = 2,
        isTalent = true,
        baseline = true
    })
    self.detox = TRB.Classes.SpellThreshold:New({
        id = 218164,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "detox",
        hasCooldown = true,
        cooldown = 8,
        isTalent = true,
        baseline = true -- TODO: Check this in a future build
    })
    self.disable = TRB.Classes.SpellThreshold:New({
        id = 116095,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "disable",
        hasCooldown = false,
        isTalent = true
    })
    self.paralysis = TRB.Classes.SpellThreshold:New({
        id = 115078,
        primaryResourceType = Enum.PowerType.Energy,
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

    -- Conduit of the Celestials
    self.heartOfTheJadeSerpent = TRB.Classes.SpellBase:New({
        id = 443421,
        talentId = 443294,
        isTalent = true,
        isBuff = true
    })
    self.heartOfTheJadeSerpentReady = TRB.Classes.SpellBase:New({
        id = 456368,
        talentId = 443294,
        isTalent = true,
        isBuff = true
    })
    self.heartOfTheJadeSerpentStacks = TRB.Classes.SpellBase:New({
        id = 443424,
        talentId = 443294,
        isTalent = true,
        isBuff = true,
        hasStacks = true,
        maxStacks = 45
    })

    -- Shado-Pan
    self.flurryCharge = TRB.Classes.SpellBase:New({
        id = 451021,
        talentId = 450615,
        isTalent = true,
        isBuff = true,
        hasStacks = true
    })

    return self
end