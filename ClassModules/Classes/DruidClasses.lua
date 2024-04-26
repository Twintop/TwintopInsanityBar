---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 11 then --Only do this if we're on a Druid!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Druid = TRB.Classes.Druid or {}


---@class TRB.Classes.Druid.BalanceSpells : TRB.Classes.SpecializationSpellsBase
---@field public moonfire TRB.Classes.SpellBase
---@field public starfire TRB.Classes.SpellBase
---@field public starsurge TRB.Classes.SpellThreshold
---@field public starsurge2 TRB.Classes.SpellThreshold
---@field public starsurge3 TRB.Classes.SpellThreshold
---@field public moonkinForm TRB.Classes.SpellBase
---@field public sunfire TRB.Classes.SpellBase
---@field public wrath TRB.Classes.SpellBase
---@field public eclipse TRB.Classes.SpellBase
---@field public eclipseSolar TRB.Classes.SpellBase
---@field public eclipseLunar TRB.Classes.SpellBase
---@field public naturesBalance TRB.Classes.SpellBase
---@field public starfall TRB.Classes.SpellThreshold
---@field public stellarFlare TRB.Classes.SpellBase
---@field public wildSurges TRB.Classes.SpellBase
---@field public rattleTheStars TRB.Classes.SpellBase
---@field public starweaver TRB.Classes.SpellBase
---@field public starweaversWarp TRB.Classes.SpellBase
---@field public starweaversWeft TRB.Classes.SpellBase
---@field public celestialAlignment TRB.Classes.SpellBase
---@field public primordialArcanicPulsar TRB.Classes.SpellBase
---@field public soulOfTheForest TRB.Classes.SpellBase
---@field public incarnationChosenOfElune TRB.Classes.SpellBase
---@field public elunesGuidance TRB.Classes.SpellBase
---@field public furyOfElune TRB.Classes.SpellBase
---@field public newMoon TRB.Classes.SpellBase
---@field public halfMoon TRB.Classes.SpellBase
---@field public fullMoon TRB.Classes.SpellBase
---@field public sunderedFirmament TRB.Classes.SpellBase
---@field public touchTheCosmos TRB.Classes.SpellBase
TRB.Classes.Druid.BalanceSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.BalanceSpells.__index = TRB.Classes.Druid.BalanceSpells

function TRB.Classes.Druid.BalanceSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Druid.BalanceSpells) --[[@as TRB.Classes.Druid.BalanceSpells]]
    -- Druid Class Baseline Abilities
    self.moonfire = TRB.Classes.SpellBase:New({
        id = 164812,
        resource = 6,
        pandemic = true,
        pandemicTime = 22 * 0.3,
        baseline = true
    })

    -- Druid Class Talents
    self.starfire = TRB.Classes.SpellBase:New({
        id = 194153,
        resource = 10,
        baseline = true,
        isTalent = true
    })
    self.starsurge = TRB.Classes.SpellThreshold:New({
        id = 78674,
        texture = "",
        resource = -40,
        thresholdId = 1,
        settingKey = "starsurge",
        isTalent = true,
        baseline = true,
        isSnowflake = true
    })
    self.starsurge2 = TRB.Classes.SpellThreshold:New({
        id = 78674,
        texture = "",
        resource = -80,
        thresholdId = 2,
        settingKey = "starsurge2",
        isTalent = true,
        baseline = true,
        isSnowflake = true
    })
    self.starsurge3 = TRB.Classes.SpellThreshold:New({
        id = 78674,
        texture = "",
        resource = -120,
        thresholdId = 3,
        settingKey = "starsurge3",
        isTalent = true,
        baseline = true,
        isSnowflake = true
    })
    self.moonkinForm = TRB.Classes.SpellBase:New({
        id = 24858,
        isTalent = true
    })
    self.sunfire = TRB.Classes.SpellBase:New({
        id = 164815,
        resource = 6,
        pandemic = true,
        pandemicTime = 18 * 0.3,
        isTalent = true
    })

    -- Balance Spec Baseline Abilities
    self.wrath = TRB.Classes.SpellBase:New({
        id = 190984,
        resource = 8
    })

    -- Balance Spec Talents
    self.eclipse = TRB.Classes.SpellBase:New({
        id = 79577,
        isTalent = true
    })
    self.eclipseSolar = TRB.Classes.SpellBase:New({
        id = 48517,
    })
    self.eclipseLunar = TRB.Classes.SpellBase:New({
        id = 48518,
    })
    self.naturesBalance = TRB.Classes.SpellBase:New({
        id = 202430,
        resource = 2,
        outOfCombatResource = 6,
        tickRate = 3,
        isTalent = true
    })
    self.starfall = TRB.Classes.SpellThreshold:New({
        id = 191034,
        texture = "",
        resource = -50,
        thresholdId = 4,
        settingKey = "starfall",
        pandemic = true,
        pandemicTime = 8 * 0.3,
        isTalent = true,
        isSnowflake = true
    })
    self.stellarFlare = TRB.Classes.SpellBase:New({
        id = 202347,
        resource = 10,
        pandemic = true,
        pandemicTime = 24 * 0.3,
        isTalent = true
    })
    self.wildSurges = TRB.Classes.SpellBase:New({
        id = 406890,
        isTalent = true,
        resourceMod = 2
    })
    self.rattleTheStars = TRB.Classes.SpellBase:New({
        id = 393954,
        resourceMod = -0.10,
        isTalent = true
    })
    self.starweaver = TRB.Classes.SpellBase:New({
        id = 393940,
        isTalent = true
    })
    self.starweaversWarp = TRB.Classes.SpellBase:New({ --Free Starfall
        id = 393942,
    })
    self.starweaversWeft = TRB.Classes.SpellBase:New({ --Free Starsurge
        id = 393944,
    })
    self.celestialAlignment = TRB.Classes.SpellBase:New({
        id = 194223,
        isTalent = true
    })
    self.primordialArcanicPulsar = TRB.Classes.SpellBase:New({
        id = 393961,
        talentId = 393960,
        maxResource = 600,
        isTalent = true
    })
    self.soulOfTheForest = TRB.Classes.SpellBase:New({
        id = 114107,
        modifier = {
            wrath = 0.3,
            starfire = 0.2
        },
        isTalent = true
    })
    -- TODO: Add Wild Mushroom + associated tracking
    self.incarnationChosenOfElune = TRB.Classes.SpellBase:New({
        id = 102560,
        talentId = 394013,
        isTalent = true
    })
    self.elunesGuidance = TRB.Classes.SpellBase:New({
        id = 393991,
        modifierStarsurge = -8,
        modifierStarfall = -10,
        isTalent = true
    })
    self.furyOfElune = TRB.Classes.SpellBase:New({
        id = 202770,
        duration = 8,
        resourcePerTick = 2.5,
        hasTicks = true,
        tickRate = 0.5,
        isTalent = true
    })
    self.newMoon = TRB.Classes.SpellBase:New({
        id = 274281,
        resource = 12,
        recharge = 20,
        isTalent = true
    })
    self.halfMoon = TRB.Classes.SpellBase:New({
        id = 274282,
        resource = 24
    })
    self.fullMoon = TRB.Classes.SpellBase:New({
        id = 274283,
        resource = 50
    })
    self.sunderedFirmament = TRB.Classes.SpellBase:New({
        id = 394094,
        buffId = 394108,
        hasTicks = true,
        resourcePerTick = 0.5,
        tickRate = 0.5,
        isTalent = true
    })
    self.touchTheCosmos = TRB.Classes.SpellBase:New({ -- T29 4P
        id = 394414,
        resourceMod = -15
    })

    return self
end


---@class TRB.Classes.Druid.FeralSpells : TRB.Classes.SpecializationSpellsBase
---@field public shadowmeld TRB.Classes.SpellBase
---@field public catForm TRB.Classes.SpellBase
---@field public rake TRB.Classes.SpellComboPointThreshold
---@field public thrash TRB.Classes.SpellComboPointThreshold
---@field public rip TRB.Classes.SpellComboPointThreshold
---@field public maim TRB.Classes.SpellComboPointThreshold
---@field public sunfire TRB.Classes.SpellBase
---@field public ferociousBite TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMinimum TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMaximum TRB.Classes.SpellComboPointThreshold
---@field public prowl TRB.Classes.SpellBase
---@field public shred TRB.Classes.SpellComboPointThreshold
---@field public swipe TRB.Classes.SpellComboPointThreshold
---@field public tigersFury TRB.Classes.SpellBase
---@field public omenOfClarity TRB.Classes.SpellBase
---@field public momentOfClarity TRB.Classes.SpellBase
---@field public clearcasting TRB.Classes.SpellBase
---@field public primalWrath TRB.Classes.SpellComboPointThreshold
---@field public lunarInspiration TRB.Classes.SpellBase
---@field public moonfire TRB.Classes.SpellComboPointThreshold
---@field public suddenAmbush TRB.Classes.SpellBase
---@field public berserk TRB.Classes.SpellBase
---@field public predatorySwiftness TRB.Classes.SpellBase
---@field public brutalSlash TRB.Classes.SpellComboPointThreshold
---@field public carnivorousInstinct TRB.Classes.SpellBase
---@field public bloodtalons TRB.Classes.SpellThreshold
---@field public feralFrenzy TRB.Classes.SpellComboPointThreshold
---@field public incarnationAvatarOfAshamane TRB.Classes.SpellBase
---@field public relentlessPredator TRB.Classes.SpellBase
---@field public circleOfLifeAndDeath TRB.Classes.SpellBase
---@field public apexPredatorsCraving TRB.Classes.SpellBase
---@field public predatorRevealed TRB.Classes.SpellBase
TRB.Classes.Druid.FeralSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.FeralSpells.__index = TRB.Classes.Druid.FeralSpells

function TRB.Classes.Druid.FeralSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Druid.FeralSpells) --[[@as TRB.Classes.Druid.FeralSpells]]

    -- Racial abilities
    self.shadowmeld = TRB.Classes.SpellBase:New({
        id = 58984,
        name = "",
        icon = ""
    })

    -- Druid Class Baseline Abilities
    self.catForm = TRB.Classes.SpellBase:New({
        id = 768,
        name = "",
        icon = "",
        baseline = true
    })

    -- Druid Class Talents
    self.rake = TRB.Classes.SpellComboPointThreshold:New({
        id = 155722,
        name = "",
        icon = "",
        resource = -35,
        comboPointsGenerated = 1,
        texture = "",
        thresholdId = 1,
        settingKey = "rake",
        hasSnapshot = true,
        pandemic = true,
        pandemicTime = 15 * 0.3,
        bonuses = {
            stealth = true,
            tigersFury = true
        },
        isTalent = true,
        baseline = true
    })
    self.thrash = TRB.Classes.SpellComboPointThreshold:New({
        id = 405233,
        talentId = 106830,
        name = "",
        icon = "",
        resource = -40,
        comboPointsGenerated = 1,
        thresholdId = 2,
        texture = "",
        settingKey = "thrash",
        hasSnapshot = true,
        pandemic = true,
        pandemicTime = 15 * 0.3,
        bonuses = {
            momentOfClarity = true,
            tigersFury = true
        },
        isTalent = true
    })
    self.rip = TRB.Classes.SpellComboPointThreshold:New({
        id = 1079,
        name = "",
        icon = "",
        resource = -20,
        comboPoints = true,
        thresholdId = 4,
        texture = "",
        settingKey = "rip",
        hasSnapshot = true,
        pandemicTimes = {
            8 * 0.3, -- 0 CP, show same as if we had 1
            8 * 0.3,
            12 * 0.3,
            16 * 0.3,
            20 * 0.3,
            24 * 0.3
        },
        bonuses = {
            bloodtalons = true,
            tigersFury = true
        },
        isTalent = true,
        baseline = true
    })
    self.maim = TRB.Classes.SpellComboPointThreshold:New({
        id = 22570,
        name = "",
        icon = "",
        resource = -30,
        comboPoints = true,
        texture = "",
        thresholdId = 5,
        settingKey = "maim",
        hasCooldown = true,
        cooldown = 20,
        isTalent = true
    })
    self.sunfire = TRB.Classes.SpellBase:New({
        id = 164815,
        name = "",
        icon = "",
        resource = 2,
        pandemic = true,
        pandemicTime = 13.5 * 0.3,
        isTalent = true
    })

    -- Feral Spec Baseline Abilities
    self.ferociousBite = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        name = "",
        icon = "",
        resource = -25,
        resourceMax = -50,
        comboPoints = true,
        texture = "",
        thresholdId = 6,
        settingKey = "ferociousBite",
        isSnowflake = true, -- Really between 25-50 energy, minus Relentless Predator
        relentlessPredator = true
    })
    self.ferociousBiteMinimum = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        name = "",
        icon = "",
        resource = -25,
        comboPoints = true,
        texture = "",
        thresholdId = 7,
        settingKey = "ferociousBiteMinimum",
        isSnowflake = true,
        relentlessPredator = true
    })
    self.ferociousBiteMaximum = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        name = "",
        icon = "",
        resource = -50,
        comboPoints = true,
        texture = "",
        thresholdId = 8,
        settingKey = "ferociousBiteMaximum",
        isSnowflake = true,
        relentlessPredator = true
    })
    self.prowl = TRB.Classes.SpellBase:New({
        id = 5215,
        name = "",
        icon = "",
        idIncarnation = 102547,
        modifier = 1.6
    })
    self.shred = TRB.Classes.SpellComboPointThreshold:New({
        id = 5221,
        name = "",
        icon = "",
        resource = -40,
        comboPointsGenerated = 1,
        texture = "",
        thresholdId = 9,
        settingKey = "shred",
        isClearcasting = true
    })
    self.swipe = TRB.Classes.SpellComboPointThreshold:New({
        id = 106785,
        name = "",
        icon = "",
        resource = -35,
        comboPointsGenerated = 1,
        thresholdId = 3,
        texture = "",
        settingKey = "swipe",
        isSnowflake = true,
        isTalent = false,
        baseline = true
    })

    -- Feral Spec Talents
    self.tigersFury = TRB.Classes.SpellBase:New({
        id = 5217,
        name = "",
        icon = "",
        modifier = 1.15,
        hasCooldown = true,
        isTalent = true
    })
    self.omenOfClarity = TRB.Classes.SpellBase:New({
        id = 16864,
        name = "",
        icon = "",
        isTalent = true
    })
    self.momentOfClarity = TRB.Classes.SpellBase:New({
        id = 236068,
        name = "",
        icon = "",
        modifier = 1.15,
        isTalent = true
    })
    self.clearcasting = TRB.Classes.SpellBase:New({
        id = 135700,
        name = "",
        icon = ""
    })
    self.primalWrath = TRB.Classes.SpellComboPointThreshold:New({
        id = 285381,
        name = "",
        icon = "",
        resource = -20,
        comboPoints = true,
        thresholdId = 10,
        texture = "",
        settingKey = "primalWrath",
        isTalent = true
    })
    self.lunarInspiration = TRB.Classes.SpellBase:New({
        id = 155580,
        name = "",
        icon = "",
        isTalent = true
    })
    self.moonfire = TRB.Classes.SpellComboPointThreshold:New({
        id = 155625,
        name = "",
        icon = "",
        resource = -30,
        comboPointsGenerated = 1,
        thresholdId = 11,
        texture = "",
        settingKey = "moonfire",
        isSnowflake = true,
        hasSnapshot = true,
        pandemic = true,
        pandemicTime = 16 * 0.3,
        bonuses = {
            tigersFury = true
        }
    })
    self.suddenAmbush = TRB.Classes.SpellBase:New({
        id = 384667,
        name = "",
        icon = "",
        isTalent = true
    })
    self.berserk = TRB.Classes.SpellBase:New({
        id = 106951,
        name = "",
        icon = "",
        isTalent = true,
        energizeId = 343216,
        tickRate = 1.5
    })
    self.predatorySwiftness = TRB.Classes.SpellBase:New({
        id = 69369,
        name = "",
        icon = "",
        isTalent = true
    })
    self.brutalSlash = TRB.Classes.SpellComboPointThreshold:New({
        id = 202028,
        name = "",
        icon = "",
        cooldown = 8,
        isHasted = true,
        resource = -25,
        comboPointsGenerated = 1,
        thresholdId = 12,
        texture = "",
        settingKey = "brutalSlash",
        isSnowflake = true,
        isTalent = true,
        hasCooldown = true,
        isClearcasting = true,
        hasCharges = true
    })
    self.carnivorousInstinct = TRB.Classes.SpellBase:New({
        id = 390902,
        name = "",
        icon = "",
        modifierPerStack = 0.06,
        isTalent = true
    })
    self.bloodtalons = TRB.Classes.SpellThreshold:New({
        id = 145152,
        name = "",
        icon = "",
        window = 4,
        resource = -80, --Make this dynamic
        thresholdId = 13,
        texture = "",
        settingKey = "bloodtalons",
        isTalent = true,
        --isSnowflake = true,
        modifier = 1.25
    })
    self.feralFrenzy = TRB.Classes.SpellComboPointThreshold:New({
        id = 274837,
        name = "",
        icon = "",
        resource = -25,
        comboPointsGenerated = 5,
        thresholdId = 14,
        texture = "",
        settingKey = "feralFrenzy",
        isTalent = true,
        hasCooldown = true
    })
    self.incarnationAvatarOfAshamane = TRB.Classes.SpellBase:New({
        id = 102543,
        name = "",
        icon = "",
        resourceMod = 0.8
    })
    self.relentlessPredator = TRB.Classes.SpellBase:New({
        id = 393771,
        name = "",
        icon = "",
        isTalent = true,
        resourceMod = 0.9
    })
    self.circleOfLifeAndDeath = TRB.Classes.SpellBase:New({
        id = 391969,
        name = "",
        icon = "",
        isTalent = true,
        modifier = 0.75
    })
    self.apexPredatorsCraving = TRB.Classes.SpellBase:New({
        id = 391882,
        name = "",
        icon = ""
    })
    -- T30 4P
    self.predatorRevealed = TRB.Classes.SpellBase:New({
        id = 408468,
        name = "",
        icon = "",
        energizeId = 411344,
        tickRate = 2.0,
        spellKey = "predatorRevealed"
    })

    return self
end


---@class TRB.Classes.Druid.RestorationSpells : TRB.Classes.Healer.HealerSpells
---@field public moonfire TRB.Classes.SpellBase
---@field public sunfire TRB.Classes.SpellBase
---@field public efflorescence TRB.Classes.SpellBase
---@field public incarnationTreeOfLife TRB.Classes.SpellBase
---@field public cenariusGuidance TRB.Classes.SpellBase
---@field public reforestation TRB.Classes.SpellBase
---@field public clearcasting TRB.Classes.SpellBase
TRB.Classes.Druid.RestorationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Druid.RestorationSpells.__index = TRB.Classes.Druid.RestorationSpells

function TRB.Classes.Druid.RestorationSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Druid.RestorationSpells) --[[@as TRB.Classes.Druid.RestorationSpells]]

    -- Druid Class Baseline Abilities
    self.moonfire = TRB.Classes.SpellBase:New({
        id = 164812,
        name = "",
        icon = "",
        resource = 2,
        pandemic = true,
        pandemicTime = 16 * 0.3
    })

    -- Druid Class Talents
    self.sunfire = TRB.Classes.SpellBase:New({
        id = 164815,
        name = "",
        icon = "",
        isTalent = true,
        pandemic = true,
        pandemicTime = 12 * 0.3
    })

    -- Restoration Spec Baseline Abilities
    -- Restoration Spec Talents
    self.efflorescence = TRB.Classes.SpellBase:New({
        id = 145205,
        name = "",
        icon = "",
        duration = 30,
        isTalent = true
    })
    self.incarnationTreeOfLife = TRB.Classes.SpellBase:New({
        id = 117679,
        name = "",
        icon = ""
    })
    self.cenariusGuidance = TRB.Classes.SpellBase:New({
        id = 393371,
        name = "",
        icon = "",
        isTalent = true
    })
    self.reforestation = TRB.Classes.SpellBase:New({
        id = 392360,
        name = "",
        icon = "",
        --isTalent = true
    })
    self.clearcasting = TRB.Classes.SpellBase:New({
        id = 16870,
        name = "",
        icon = ""
    })

    return self
end