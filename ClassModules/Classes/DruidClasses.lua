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
---@field public moonkinForm TRB.Classes.SpellBase
---@field public sunfire TRB.Classes.SpellBase
---@field public wrath TRB.Classes.SpellBase
---@field public eclipse TRB.Classes.SpellBase
---@field public eclipseSolar TRB.Classes.SpellBase
---@field public eclipseLunar TRB.Classes.SpellBase
---@field public naturesBalance TRB.Classes.SpellBase
---@field public stellarFlare TRB.Classes.SpellBase
---@field public wildSurges TRB.Classes.SpellBase
---@field public starweaver TRB.Classes.SpellBase
---@field public starweaversWarp TRB.Classes.SpellBase
---@field public starweaversWeft TRB.Classes.SpellBase
---@field public celestialAlignment TRB.Classes.SpellBase
---@field public soulOfTheForest TRB.Classes.SpellBase
---@field public incarnationChosenOfElune TRB.Classes.SpellBase
---@field public furyOfElune TRB.Classes.SpellBase
---@field public newMoon TRB.Classes.SpellBase
---@field public halfMoon TRB.Classes.SpellBase
---@field public fullMoon TRB.Classes.SpellBase
---@field public sunderedFirmament TRB.Classes.SpellBase
---@field public astralCommunion TRB.Classes.SpellBase
---@field public touchTheCosmos TRB.Classes.SpellBase
---@field public boundlessMoonlight TRB.Classes.SpellBase
---@field public theEternalMoon TRB.Classes.SpellBase
---@field public theLightOfElune TRB.Classes.SpellBase
---@field public moonGuardian TRB.Classes.SpellBase
---@field public bounteousBloom TRB.Classes.SpellBase
---@field public forceOfNature TRB.Classes.SpellBase
---@field public twwSeason1SetBonus TRB.Classes.SpellBase
---@field public starsurge TRB.Classes.SpellThreshold
---@field public starsurge2 TRB.Classes.SpellThreshold
---@field public starsurge3 TRB.Classes.SpellThreshold
---@field public starfall TRB.Classes.SpellThreshold
TRB.Classes.Druid.BalanceSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.BalanceSpells.__index = TRB.Classes.Druid.BalanceSpells

function TRB.Classes.Druid.BalanceSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), {__index = TRB.Classes.Druid.BalanceSpells})
    -- Druid Class Baseline Abilities
    self.moonfire = TRB.Classes.SpellBase:New({
        id = 164812,
        resource = 6,
        pandemic = true,
        baseDuration = 22,
        baseline = true
    })

    -- Druid Class Talents
    self.starfire = TRB.Classes.SpellBase:New({
        id = 194153,
        resource = 8,
        baseline = true,
        isTalent = true,
        hasCastCount = true
    })
    self.starsurge = TRB.Classes.SpellThreshold:New({
        id = 78674,
        primaryResourceType = Enum.PowerType.LunarPower,
        settingKey = "starsurge",
        isTalent = true,
        baseline = true,
        isSnowflake = true
    })
    self.starsurge2 = TRB.Classes.SpellThreshold:New({
        id = 78674,
        primaryResourceType = Enum.PowerType.LunarPower,
        primaryResourceTypeMod = 2,
        settingKey = "starsurge2",
        isTalent = true,
        baseline = true,
        isSnowflake = true
    })
    self.starsurge3 = TRB.Classes.SpellThreshold:New({
        id = 78674,
        primaryResourceType = Enum.PowerType.LunarPower,
        primaryResourceTypeMod = 3,
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
        baseDuration = 18,
        isTalent = true
    })

    -- Balance Spec Baseline Abilities
    self.wrath = TRB.Classes.SpellBase:New({
        id = 190984,
        resource = 6,
        hasCastCount = true
    })
    self.starfall = TRB.Classes.SpellThreshold:New({
        id = 191034,
        primaryResourceType = Enum.PowerType.LunarPower,
        settingKey = "starfall",
        pandemic = true,
        baseDuration = 8,
        isSnowflake = true,
        baseline = true
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
    self.stellarFlare = TRB.Classes.SpellBase:New({
        id = 202347,
        resource = 12,
        pandemic = true,
        baseDuration = 24,
        isTalent = true
    })
    self.wildSurges = TRB.Classes.SpellBase:New({
        id = 406890,
        isTalent = true,
        resourceMod = 2
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
    self.soulOfTheForest = TRB.Classes.SpellBase:New({
        id = 114107,
        modifier = {
            wrath = 0.6,
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
        resource = 10,
        recharge = 20,
        isTalent = true,
        theEternalMoon = 1
    })
    self.halfMoon = TRB.Classes.SpellBase:New({
        id = 274282,
        resource = 20,
        theEternalMoon = 1
    })
    self.fullMoon = TRB.Classes.SpellBase:New({
        id = 274283,
        resource = 40,
        boundlessMoonlight = 2
    })
    self.sunderedFirmament = TRB.Classes.SpellBase:New({
        id = 394094,
        buffId = 394108,
        hasTicks = true,
        resourcePerTick = TRB.Functions.Number:RoundTo(2.5 * 0.25, 1, "floor", true),
        tickRate = 0.5,
        isTalent = true
    })
    self.astralCommunion = TRB.Classes.SpellBase:New({
        id = 450599,
        resourceMod = -15
    })
    self.touchTheCosmos = TRB.Classes.SpellBase:New({
        id = 450360
    })

    -- Elune's Chosen
    self.boundlessMoonlight = TRB.Classes.SpellBase:New({
        id = 424058,
        isTalent = true,
        resourceMod = 3
    })
    self.theEternalMoon = TRB.Classes.SpellBase:New({
        id = 424058,
        isTalent = true,
        moonResourceMod = 3,
        furyResourceMod = 6
    })
    self.theLightOfElune = TRB.Classes.SpellBase:New({
        id = 428655,
        isTalent = true,
        duration = 3,
        resourcePerTick = 2.5,
        hasTicks = true,
        tickRate = 0.5
    })
    self.moonGuardian = TRB.Classes.SpellBase:New({
        id = 429520,
        isTalent = true,
        resourceMod = 2
    })

    -- Keeper of the Grove
    self.forceOfNature = TRB.Classes.SpellBase:New({
        id = 205636,
        isTalent = true,
        duration = 10,
        resourcePerTick = 30, -- 10 * 3 treants
        hasTicks = true,
        tickRate = 2
    })
    self.bounteousBloom = TRB.Classes.SpellBase:New({
        id = 429215,
        isTalent = true
    })

    --Set Bonuses
    self.twwSeason1SetBonus = TRB.Classes.SpellBase:New({
        headId = 212056,
        shoulderId = 212054,
        chestId = 212059,
        handId = 212057,
        legId = 212055,
        resourceModWrath = 2,
        resourceModStarfire = 5
    })

    return self
end


---@class TRB.Classes.Druid.FeralSpells : TRB.Classes.SpecializationSpellsBase
---@field public shadowmeld TRB.Classes.SpellBase
---@field public catForm TRB.Classes.SpellBase
---@field public sunfire TRB.Classes.SpellBase
---@field public prowl TRB.Classes.SpellBase
---@field public tigersFury TRB.Classes.SpellBase
---@field public momentOfClarity TRB.Classes.SpellBase
---@field public clearcasting TRB.Classes.SpellBase
---@field public lunarInspiration TRB.Classes.SpellBase
---@field public suddenAmbush TRB.Classes.SpellBase
---@field public berserk TRB.Classes.SpellBase
---@field public carnivorousInstinct TRB.Classes.SpellBase
---@field public bloodtalons TRB.Classes.SpellBase
---@field public incarnationAvatarOfAshamane TRB.Classes.SpellBase
---@field public circleOfLifeAndDeath TRB.Classes.SpellBase
---@field public apexPredatorsCraving TRB.Classes.SpellBase
---@field public predatorRevealed TRB.Classes.SpellBase
---@field public rake TRB.Classes.SpellComboPointThreshold
---@field public thrash TRB.Classes.SpellComboPointThreshold
---@field public rip TRB.Classes.SpellComboPointThreshold
---@field public maim TRB.Classes.SpellComboPointThreshold
---@field public ferociousBite TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMinimum TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMaximum TRB.Classes.SpellComboPointThreshold
---@field public shred TRB.Classes.SpellComboPointThreshold
---@field public swipe TRB.Classes.SpellComboPointThreshold
---@field public primalWrath TRB.Classes.SpellComboPointThreshold
---@field public moonfire TRB.Classes.SpellComboPointThreshold
---@field public brutalSlash TRB.Classes.SpellComboPointThreshold
---@field public feralFrenzy TRB.Classes.SpellComboPointThreshold
---@field public ravage TRB.Classes.SpellComboPointThreshold
---@field public ravageMinimum TRB.Classes.SpellComboPointThreshold
---@field public ravageMaximum TRB.Classes.SpellComboPointThreshold
---@field public frenziedRegeneration TRB.Classes.SpellComboPointThreshold
TRB.Classes.Druid.FeralSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.FeralSpells.__index = TRB.Classes.Druid.FeralSpells

function TRB.Classes.Druid.FeralSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(),  {__index = TRB.Classes.Druid.FeralSpells})

    -- Racial abilities
    self.shadowmeld = TRB.Classes.SpellBase:New({
        id = 58984
    })

    -- Druid Class Baseline Abilities
    self.catForm = TRB.Classes.SpellBase:New({
        id = 768,
        baseline = true
    })

    -- Druid Class Talents
    self.rake = TRB.Classes.SpellComboPointThreshold:New({
        id = 1822,
        debuffId = 155722,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "rake",
        hasSnapshot = true,
        pandemic = true,
        baseDuration = 15,
        bonuses = {
            stealth = true,
            tigersFury = true
        },
        isTalent = true,
        baseline = true
    })
    self.thrash = TRB.Classes.SpellComboPointThreshold:New({
        id = 106830,
        debuffId = 405233,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "thrash",
        hasSnapshot = true,
        pandemic = true,
        baseDuration = 15,
        bonuses = {
            momentOfClarity = true,
            tigersFury = true
        },
        isTalent = true
    })
    self.rip = TRB.Classes.SpellComboPointThreshold:New({
        id = 1079,
        debuffId = 1079,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
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
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "maim",
        hasCooldown = true,
        cooldown = 20,
        isTalent = true
    })
    self.sunfire = TRB.Classes.SpellBase:New({
        id = 164815,
        resource = 2,
        pandemic = true,
        baseDuration = 13.5,
        isTalent = true
    })

    -- Feral Spec Baseline Abilities
    self.ferociousBite = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "ferociousBite",
        isSnowflake = true -- Really between 25-50 energy
    })
    self.ferociousBiteMinimum = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "ferociousBiteMinimum",
        isSnowflake = true
    })
    self.ferociousBiteMaximum = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        primaryResourceType = Enum.PowerType.Energy,
        primaryResourceTypeMod = 2,
        comboPoints = true,
        settingKey = "ferociousBiteMaximum",
        isSnowflake = true
    })
    self.prowl = TRB.Classes.SpellBase:New({
        id = 5215,
        idIncarnation = 102547,
        modifier = 1.6
    })
    self.shred = TRB.Classes.SpellComboPointThreshold:New({
        id = 5221,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shred",
        isClearcasting = true
    })
    self.swipe = TRB.Classes.SpellComboPointThreshold:New({
        id = 106785,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "swipe",
        isSnowflake = true,
        isTalent = false,
        baseline = true
    })

    -- Feral Spec Talents
    self.tigersFury = TRB.Classes.SpellBase:New({
        id = 5217,
        modifier = 1.15,
        hasCooldown = true,
        isTalent = true
    })
    self.momentOfClarity = TRB.Classes.SpellBase:New({
        id = 236068,
        modifier = 1.15,
        isTalent = true
    })
    self.clearcasting = TRB.Classes.SpellBase:New({
        id = 135700
    })
    self.primalWrath = TRB.Classes.SpellComboPointThreshold:New({
        id = 285381,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "primalWrath",
        isTalent = true
    })
    self.lunarInspiration = TRB.Classes.SpellBase:New({
        id = 155580,
        isTalent = true
    })
    self.moonfire = TRB.Classes.SpellComboPointThreshold:New({
        id = 155625,
        debuffId = 155625,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "moonfire",
        isSnowflake = true,
        hasSnapshot = true,
        pandemic = true,
        baseDuration = 16,
        bonuses = {
            tigersFury = true
        }
    })
    self.suddenAmbush = TRB.Classes.SpellBase:New({
        id = 384667,
        isTalent = true
    })
    self.berserk = TRB.Classes.SpellBase:New({
        id = 106951,
        isTalent = true,
        energizeId = 343216,
        tickRate = 1.5
    })
    self.brutalSlash = TRB.Classes.SpellComboPointThreshold:New({
        id = 202028,
        cooldown = 8,
        isHasted = true,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "brutalSlash",
        isSnowflake = true,
        isTalent = true,
        hasCooldown = true,
        isClearcasting = true,
        hasCharges = true
    })
    self.carnivorousInstinct = TRB.Classes.SpellBase:New({
        id = 390902,
        modifierPerStack = 0.06,
        isTalent = true
    })
    self.bloodtalons = TRB.Classes.SpellBase:New({
        id = 145152,
        window = 4,
        isTalent = true,
        --isSnowflake = true,
        modifier = 1.25
    })
    self.feralFrenzy = TRB.Classes.SpellComboPointThreshold:New({
        id = 274837,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 5,
        settingKey = "feralFrenzy",
        isTalent = true,
        hasCooldown = true
    })
    self.incarnationAvatarOfAshamane = TRB.Classes.SpellBase:New({
        id = 102543
    })
    self.circleOfLifeAndDeath = TRB.Classes.SpellBase:New({
        id = 391969,
        isTalent = true,
        modifier = 0.75
    })
    self.apexPredatorsCraving = TRB.Classes.SpellBase:New({
        id = 391882
    })
    -- T30 4P
    self.predatorRevealed = TRB.Classes.SpellBase:New({
        id = 408468,
        energizeId = 411344,
        tickRate = 2.0,
        spellKey = "predatorRevealed"
    })

    -- Druid of the Claw
    self.ravage = TRB.Classes.SpellComboPointThreshold:New({
        id = 441591,
        buffId = 441585,
        talentId = 441583,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "ravage",
        isSnowflake = true -- Really between 25-50 energy
    })
    self.ravageMinimum = TRB.Classes.SpellComboPointThreshold:New({
        id = 441591,
        buffId = 441585,
        talentId = 441583,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "ravageMinimum",
        isSnowflake = true
    })
    self.ravageMaximum = TRB.Classes.SpellComboPointThreshold:New({
        id = 441591,
        buffId = 441585,
        talentId = 441583,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Energy,
        primaryResourceTypeMod = 2,
        comboPoints = true,
        settingKey = "ravageMaximum",
        isSnowflake = true
    })
    self.empoweredShapeshifting = TRB.Classes.SpellBase:New({
        id = 441689,
        isTalent = true
    })
    self.frenziedRegeneration = TRB.Classes.SpellThreshold:New({
        id = 22842,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "frenziedRegeneration",
        hasCooldown = true,
        isSnowflake = true -- Only usable in Catform with Empowered Shapeshifting
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
    self = setmetatable(base:New(), {__index = TRB.Classes.Druid.RestorationSpells})

    -- Druid Class Baseline Abilities
    self.moonfire = TRB.Classes.SpellBase:New({
        id = 164812,
        resource = 2,
        pandemic = true,
        baseDuration = 16
    })

    -- Druid Class Talents
    self.sunfire = TRB.Classes.SpellBase:New({
        id = 164815,
        isTalent = true,
        pandemic = true,
        baseDuration = 12
    })

    -- Restoration Spec Baseline Abilities
    -- Restoration Spec Talents
    self.efflorescence = TRB.Classes.SpellBase:New({
        id = 145205,
        duration = 30,
        isTalent = true
    })
    self.incarnationTreeOfLife = TRB.Classes.SpellBase:New({
        id = 117679
    })
    self.cenariusGuidance = TRB.Classes.SpellBase:New({
        id = 393371,
        isTalent = true
    })
    self.reforestation = TRB.Classes.SpellBase:New({
        id = 392360
    })
    self.clearcasting = TRB.Classes.SpellBase:New({
        id = 16870
    })

    return self
end