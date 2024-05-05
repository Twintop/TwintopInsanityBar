local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 12 then --Only do this if we're on a DemonHunter!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.DemonHunter = TRB.Classes.DemonHunter or {}


---@class TRB.Classes.DemonHunter.HavocSpells : TRB.Classes.SpecializationSpellsBase
---@field public immolationAura TRB.Classes.SpellBase
---@field public immolationAura1 TRB.Classes.SpellBase
---@field public immolationAura2 TRB.Classes.SpellBase
---@field public immolationAura3 TRB.Classes.SpellBase
---@field public immolationAura4 TRB.Classes.SpellBase
---@field public immolationAura5 TRB.Classes.SpellBase
---@field public immolationAura6 TRB.Classes.SpellBase
---@field public metamorphosis TRB.Classes.SpellBase
---@field public burningHatred TRB.Classes.SpellBase
---@field public felfireHeart TRB.Classes.SpellBase
---@field public blindFury TRB.Classes.SpellBase
---@field public unboundChaos TRB.Classes.SpellBase
---@field public tacticalRetreat TRB.Classes.SpellBase
---@field public chaosTheory TRB.Classes.SpellBase
---@field public throwGlaive TRB.Classes.SpellThreshold
---@field public bladeDance TRB.Classes.SpellThreshold
---@field public chaosStrike TRB.Classes.SpellThreshold
---@field public annihilation TRB.Classes.SpellThreshold
---@field public deathSweep TRB.Classes.SpellThreshold
---@field public chaosNova TRB.Classes.SpellThreshold
---@field public eyeBeam TRB.Classes.SpellThreshold
---@field public felEruption TRB.Classes.SpellThreshold
---@field public glaiveTempest TRB.Classes.SpellThreshold
---@field public felBarrage TRB.Classes.SpellThreshold
TRB.Classes.DemonHunter.HavocSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.HavocSpells.__index = TRB.Classes.DemonHunter.HavocSpells

function TRB.Classes.DemonHunter.HavocSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.DemonHunter.HavocSpells) --[[@as TRB.Classes.DemonHunter.HavocSpells]]
    --Demon Hunter Class Baseline Abilities
    self.immolationAura = TRB.Classes.SpellBase:New({
        id = 258920,
        resource = 20,
        cooldown = 30,
        isTalent = false,
        baseline = true
    })
    self.immolationAura1 = TRB.Classes.SpellBase:New({
        id = 427912,
    })
    self.immolationAura2 = TRB.Classes.SpellBase:New({
        id = 427913,
    })
    self.immolationAura3 = TRB.Classes.SpellBase:New({
        id = 427914,
    })
    self.immolationAura4 = TRB.Classes.SpellBase:New({
        id = 427915,
    })
    self.immolationAura5 = TRB.Classes.SpellBase:New({
        id = 427916,
    })
    self.immolationAura6 = TRB.Classes.SpellBase:New({
        id = 427917,
    })
    self.metamorphosis = TRB.Classes.SpellBase:New({
        id = 162264,
        isTalent = false,
        baseline = true
    })
    self.throwGlaive = TRB.Classes.SpellThreshold:New({
        id = 185123,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 9,
        settingKey = "throwGlaive",
        hasCooldown = true,
        hasCharges = true,
        isTalent = false,
        baseline = true
    })

    --Havoc Baseline Abilities
    self.bladeDance = TRB.Classes.SpellThreshold:New({
        id = 188499,
        primaryResourceType = Enum.PowerType.Fury,
        cooldown = 9,
        thresholdId = 2,
        settingKey = "bladeDance",
        hasCooldown = true,
        demonForm = false,
        isTalent = false,
        baseline = true
    })
    self.chaosStrike = TRB.Classes.SpellThreshold:New({
        id = 162794,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 4,
        settingKey = "chaosStrike",
        hasCooldown = false,
        isSnowflake = true,
        demonForm = false,
        isTalent = false,
        baseline = true
    })
    self.annihilation = TRB.Classes.SpellThreshold:New({
        id = 201427,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 1,
        settingKey = "annihilation",
        hasCooldown = false,
        demonForm = true,
        isTalent = false,
        baseline = true
    })
    self.deathSweep = TRB.Classes.SpellThreshold:New({
        id = 210152,
        primaryResourceType = Enum.PowerType.Fury,
        cooldown = 9,
        thresholdId = 5,
        settingKey = "deathSweep",
        hasCooldown = true,
        demonForm = true,
        isTalent = false,
        baseline = true
    })

    -- Demon Hunter Talent Abilities
    self.chaosNova = TRB.Classes.SpellThreshold:New({
        id = 179057,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 3,
        settingKey = "chaosNova",
        hasCooldown = true,
        isTalent = true
    })

    -- Havoc Talent Abilities
    self.eyeBeam = TRB.Classes.SpellThreshold:New({
        id = 198013,
        primaryResourceType = Enum.PowerType.Fury,
        duration = 2,
        thresholdId = 6,
        settingKey = "eyeBeam",
        hasCooldown = true,
        isTalent = true
    })
    self.burningHatred = TRB.Classes.SpellBase:New({
        id = 258922,
        talentId = 320374,
        resourcePerTick = 4,
        tickRate = 1,
        hasTicks = true,
        duration = 12,
        isTalent = true
    })
    self.felfireHeart = TRB.Classes.SpellBase:New({ --TODO: figure out how this plays with Burning Hatred
        id = 388109,
        duration = 4, -- These don't match what's seen on the PTR, should be 2,
        ticks = 4, --2,
        isTalent = true
    })
    self.felEruption = TRB.Classes.SpellThreshold:New({
        id = 211881,
        primaryResourceType = Enum.PowerType.Fury,
        cooldown = 30,
        thresholdId = 8,
        settingKey = "felEruption",
        hasCooldown = true,
        isTalent = false,
        baseline = true
    })
    self.blindFury = TRB.Classes.SpellBase:New({
        id = 203550,
        durationModifier = 1.5,
        tickRate = 0.1,
        resource = 4,
        isHasted = true,
        isTalent = true
    })
    self.glaiveTempest = TRB.Classes.SpellThreshold:New({
        id = 342817,
        primaryResourceType = Enum.PowerType.Fury,
        cooldown = 20,
        thresholdId = 7,
        settingKey = "glaiveTempest",
        hasCooldown = true,
        isTalent = true
    })
    self.unboundChaos = TRB.Classes.SpellBase:New({
        id = 347462,
        duration = 20
    })
    self.tacticalRetreat = TRB.Classes.SpellBase:New({
        id = 389890,
        resourcePerTick = 8,
        tickRate = 1,
        hasTicks = true,
        isTalent = true
    })
    self.chaosTheory = TRB.Classes.SpellBase:New({
        id = 390195
    })
    self.felBarrage = TRB.Classes.SpellThreshold:New({
        id = 258925,
        primaryResourceType = Enum.PowerType.Fury,
        cooldown = 90,
        thresholdId = 10,
        settingKey = "felBarrage",
        hasCooldown = true,
        isTalent = true
    })

    return self
end


---@class TRB.Classes.DemonHunter.VengeanceSpells : TRB.Classes.SpecializationSpellsBase
---@field public soulFragments TRB.Classes.SpellBase
---@field public immolationAura TRB.Classes.SpellBase
---@field public metamorphosis TRB.Classes.SpellBase
---@field public soulCleave TRB.Classes.SpellThreshold
---@field public chaosNova TRB.Classes.SpellThreshold
---@field public felDevastation TRB.Classes.SpellThreshold
---@field public spiritBomb TRB.Classes.SpellThreshold
---@field public soulFurnace TRB.Classes.SpellBase
TRB.Classes.DemonHunter.VengeanceSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.VengeanceSpells.__index = TRB.Classes.DemonHunter.VengeanceSpells

function TRB.Classes.DemonHunter.VengeanceSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.DemonHunter.VengeanceSpells) --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

    --Resource
    self.soulFragments = TRB.Classes.SpellBase:New({
        id = 203981,
        attributes = {},
        maxResource = 5
    })

    --Demon Hunter Class Baseline Abilities
    self.immolationAura = TRB.Classes.SpellBase:New({
        id = 258920,
        resourcePerTick = 2,
        tickRate = 1,
        hasTicks = true,
        isTalent = false,
        baseline = true
    })
    self.metamorphosis = TRB.Classes.SpellBase:New({
        id = 187827,
        isTalent = false,
        baseline = true
    })

    --Vengeance Baseline Abilities
    self.soulCleave = TRB.Classes.SpellThreshold:New({
        id = 228477,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 1,
        settingKey = "soulCleave",
        isTalent = false,
        baseline = true,
        isSnowflake = true
    })

    -- Demon Hunter Talent Abilities
    self.chaosNova = TRB.Classes.SpellThreshold:New({
        id = 179057,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 2,
        settingKey = "chaosNova",
        hasCooldown = true,
        isTalent = true
    })

    -- Vengeance Talent Abilities
    self.felDevastation = TRB.Classes.SpellThreshold:New({
        id = 212084,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 3,
        settingKey = "felDevastation",
        hasCooldown = true,
        isTalent = true
    })
    self.spiritBomb = TRB.Classes.SpellComboPointThreshold:New({
        id = 247454,
        primaryResourceType = Enum.PowerType.Fury,
        thresholdId = 4,
        settingKey = "spiritBomb",
        comboPoints = true,
        isTalent = true,
        isSnowflake = true
    })
    self.soulFurnace = TRB.Classes.SpellBase:New({
        id = 391172,
        isTalent = true
    })

    return self
end