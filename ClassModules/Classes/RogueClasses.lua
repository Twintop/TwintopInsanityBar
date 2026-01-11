local _, TRB = ...
if TRB.Data.character.classId ~= 4 then --Only do this if we're on a Rogue!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Rogue = TRB.Classes.Rogue or {}

---@class TRB.Classes.Rogue.RogueBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field public subterfuge TRB.Classes.SpellBase
---@field public adrenalineRush TRB.Classes.SpellBase
---@field public echoingReprimand TRB.Classes.SpellBase
---@field public crimsonVial TRB.Classes.SpellThreshold
---@field public distract TRB.Classes.SpellThreshold
---@field public feint TRB.Classes.SpellThreshold
---@field public sap TRB.Classes.SpellThreshold
---@field public cheapShot TRB.Classes.SpellComboPointThreshold
---@field public kidneyShot TRB.Classes.SpellComboPointThreshold
---@field public sliceAndDice TRB.Classes.SpellComboPointThreshold
---@field public shiv TRB.Classes.SpellComboPointThreshold
---@field public gouge TRB.Classes.SpellComboPointThreshold
---@field public dismantle TRB.Classes.SpellThreshold
---@field public deathFromAbove TRB.Classes.SpellThreshold
TRB.Classes.Rogue.RogueBaseSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Rogue.RogueBaseSpells.__index = TRB.Classes.Rogue.RogueBaseSpells

---Creates a new RogueBaseSpells
---@return TRB.Classes.Rogue.RogueBaseSpells
function TRB.Classes.Rogue.RogueBaseSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Rogue.RogueBaseSpells) --[[@as TRB.Classes.Rogue.RogueBaseSpells]]

    -- Rogue Class Baseline Abilities
    self.cheapShot = TRB.Classes.SpellComboPointThreshold:New({
        id = 1833,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        stealth = true,
        settingKey = "cheapShot",
        baseline = true,
        isSnowflake = true
    })
    self.crimsonVial = TRB.Classes.SpellThreshold:New({
        id = 185311,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "crimsonVial",
        hasCooldown = true,
        cooldown = 30,
        baseline = true,
        rangeCheck = false
    })
    self.distract = TRB.Classes.SpellThreshold:New({
        id = 1725,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 0,
        settingKey = "distract",
        hasCooldown = true,
        cooldown = 30,
        baseline = true,
        rangeCheck = false
    })
    self.kidneyShot = TRB.Classes.SpellComboPointThreshold:New({
        id = 408,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "kidneyShot",
        hasCooldown = true,
        cooldown = 20,
        baseline = true
    })
    self.sliceAndDice = TRB.Classes.SpellComboPointThreshold:New({
        id = 315496,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "sliceAndDice",
        hasCooldown = false,
        isSnowflake = true,
        pandemicTimes = {
            12 * 0.3, -- 0 CP, show same as if we had 1
            12 * 0.3,
            18 * 0.3,
            24 * 0.3,
            30 * 0.3,
            36 * 0.3,
            42 * 0.3,
            48 * 0.3
        },
        baseline = true,
        rangeCheck = false
    })
    self.feint = TRB.Classes.SpellThreshold:New({
        id = 1966,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "feint",
        hasCooldown = true,
        cooldown = 15,
        hasCharges = true,
        isTalent = false,
        baseline = true,
        rangeCheck = false
    })

    --Rogue Talent Abilities
    self.shiv = TRB.Classes.SpellComboPointThreshold:New({
        id = 5938,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shiv",
        hasCooldown = true,
        isTalent = true
    })
    self.sap = TRB.Classes.SpellThreshold:New({ -- Baseline
        id = 6770,
        primaryResourceType = Enum.PowerType.Energy,
        stealth = true,
        settingKey = "sap",
        baseline = true
    })
    self.gouge = TRB.Classes.SpellComboPointThreshold:New({
        id = 1776,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "gouge",
        hasCooldown = true,
        cooldown = 15,
        isTalent = true
    })
    self.subterfuge = TRB.Classes.SpellBase:New({
        id = 115192,
        isTalent = true
    })

    self.adrenalineRush = TRB.Classes.SpellBase:New({
        id = 13750
    })

    -- PvP
    self.deathFromAbove = TRB.Classes.SpellComboPointThreshold:New({
        id = 269513,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "deathFromAbove",
        comboPoints = true,
        hasCooldown = true,
        isPvp = true
    })
    self.dismantle = TRB.Classes.SpellThreshold:New({
        id = 207777,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "dismantle",
        hasCooldown = true,
        isPvp = true
    })
    self.echoingReprimand = TRB.Classes.SpellBase:New({
        id = 470671
    })

    return self
end


---@class TRB.Classes.Rogue.AssassinationSpells : TRB.Classes.Rogue.RogueBaseSpells
---@field public improvedGarrote TRB.Classes.SpellBase
---@field public blindside TRB.Classes.SpellBase
---@field public ambush TRB.Classes.SpellComboPointThreshold
---@field public envenom TRB.Classes.SpellComboPointThreshold
---@field public fanOfKnives TRB.Classes.SpellComboPointThreshold
---@field public garrote TRB.Classes.SpellComboPointThreshold
---@field public mutilate TRB.Classes.SpellComboPointThreshold
---@field public poisonedKnife TRB.Classes.SpellComboPointThreshold
---@field public rupture TRB.Classes.SpellComboPointThreshold
---@field public crimsonTempest TRB.Classes.SpellComboPointThreshold
---@field public kingsbane TRB.Classes.SpellComboPointThreshold
TRB.Classes.Rogue.AssassinationSpells = setmetatable({}, {__index = TRB.Classes.Rogue.RogueBaseSpells})
TRB.Classes.Rogue.AssassinationSpells.__index = TRB.Classes.Rogue.AssassinationSpells

function TRB.Classes.Rogue.AssassinationSpells:New()
    ---@type TRB.Classes.Rogue.RogueBaseSpells
    local base = TRB.Classes.Rogue.RogueBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Rogue.AssassinationSpells) --[[@as TRB.Classes.Rogue.AssassinationSpells]]

    -- Rogue Class Baseline Abilities
    self.ambush = TRB.Classes.SpellComboPointThreshold:New({
        id = 8676,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        stealth = true,
        settingKey = "ambush",
        baseline = true
    })
    self.shiv.baseline = true
    self.shiv.hasCharges = true
    
    -- Assassination Baseline Abilities
    self.envenom = TRB.Classes.SpellComboPointThreshold:New({
        id = 32645,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "envenom",
        baseline = true
    })
    self.fanOfKnives = TRB.Classes.SpellComboPointThreshold:New({
        id = 51723,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "fanOfKnives",
        baseline = true,
        rangeCheck = false
    })
    self.garrote = TRB.Classes.SpellComboPointThreshold:New({
        id = 703,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "garrote",
        hasCooldown = true,
        cooldown = 6,
        baseDuration = 18,
        baseline = true,
        isSnowflake = true,
        pandemic = true
    })
    self.mutilate = TRB.Classes.SpellComboPointThreshold:New({
        id = 1329,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        settingKey = "mutilate",
        baseline = true,
        isSnowflake = true
    })
    self.poisonedKnife = TRB.Classes.SpellComboPointThreshold:New({
        id = 185565,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "poisonedKnife",
        baseline = true
    })
    self.rupture = TRB.Classes.SpellComboPointThreshold:New({
        id = 1943,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "rupture",
        pandemicTimes = {
            8 * 0.3, -- 0 CP, show same as if we had 1
            8 * 0.3,
            12 * 0.3,
            16 * 0.3,
            20 * 0.3,
            24 * 0.3,
            28 * 0.3,
            32 * 0.3,
        },
        baseline = true
    })

    self.crimsonTempest = TRB.Classes.SpellComboPointThreshold:New({
        id = 1247227,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "crimsonTempest",
        pandemicTimes = {
            6 * 0.3, -- 0 CP, show same as if we had 1
            6 * 0.3,
            8 * 0.3,
            10 * 0.3,
            12 * 0.3,
            14 * 0.3,
            16 * 0.3,
            18 * 0.3, -- Kyrian ability buff
        },
        isTalent = true,
        rangeCheck = false
    })
    self.improvedGarrote = TRB.Classes.SpellBase:New({
        id = 381632,
        stealthBuffId = 392401,
        buffId = 392403,
        isTalent = true
    })
    -- TODO: Add Doomblade as a bleed
    self.blindside = TRB.Classes.SpellBase:New({
        id = 121153,
        duration = 10,
        isTalent = true
    })
    self.kingsbane = TRB.Classes.SpellComboPointThreshold:New({
        id = 385627,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "kingsbane",
        hasCooldown = true,
        cooldown = 60,
        isTalent = true
    })

    return self
end


---@class TRB.Classes.Rogue.OutlawSpells : TRB.Classes.Rogue.RogueBaseSpells
---@field public opportunity TRB.Classes.SpellBase
---@field public restlessBlades TRB.Classes.SpellBase
---@field public broadside TRB.Classes.SpellBase
---@field public buriedTreasure TRB.Classes.SpellBase
---@field public grandMelee TRB.Classes.SpellBase
---@field public ruthlessPrecision TRB.Classes.SpellBase
---@field public skullAndCrossbones TRB.Classes.SpellBase
---@field public trueBearing TRB.Classes.SpellBase
---@field public countTheOdds TRB.Classes.SpellBase
---@field public bladeRush TRB.Classes.SpellBase
---@field public keepItRolling TRB.Classes.SpellBase
---@field public escalatingBlade TRB.Classes.SpellBase
---@field public floatLikeAButterfly TRB.Classes.SpellBase
---@field public bladeFlurry TRB.Classes.SpellThreshold
---@field public rollTheBones TRB.Classes.SpellThreshold
---@field public deathFromAbove TRB.Classes.SpellThreshold
---@field public ambush TRB.Classes.SpellComboPointThreshold
---@field public betweenTheEyes TRB.Classes.SpellComboPointThreshold
---@field public dispatch TRB.Classes.SpellComboPointThreshold
---@field public pistolShot TRB.Classes.SpellComboPointThreshold
---@field public sinisterStrike TRB.Classes.SpellComboPointThreshold
---@field public coupDeGrace TRB.Classes.SpellComboPointThreshold
TRB.Classes.Rogue.OutlawSpells = setmetatable({}, {__index = TRB.Classes.Rogue.RogueBaseSpells})
TRB.Classes.Rogue.OutlawSpells.__index = TRB.Classes.Rogue.OutlawSpells

function TRB.Classes.Rogue.OutlawSpells:New()
    ---@type TRB.Classes.Rogue.RogueBaseSpells
    local base = TRB.Classes.Rogue.RogueBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Rogue.OutlawSpells) --[[@as TRB.Classes.Rogue.OutlawSpells]]

    -- Rogue Class Baseline Abilities
    self.ambush = TRB.Classes.SpellComboPointThreshold:New({
        id = 8676,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        stealth = true,
        settingKey = "ambush",
        baseline = true
    })
    
    -- Outlaw Baseline Abilities
    self.betweenTheEyes = TRB.Classes.SpellComboPointThreshold:New({
        id = 315341,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "betweenTheEyes",
        hasCooldown = true,
        isSnowflake = true,
        cooldown = 45,
        restlessBlades = true,
        baseline = true
    })
    self.dispatch = TRB.Classes.SpellComboPointThreshold:New({
        id = 2098,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "dispatch",
        baseline = true,
        isSnowflake = true
    })
    self.pistolShot = TRB.Classes.SpellComboPointThreshold:New({
        id = 185763,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "pistolShot",
        hasCooldown = false,
        isSnowflake = true,
        baseline = true
    })
    self.sinisterStrike = TRB.Classes.SpellComboPointThreshold:New({
        id = 193315,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "sinisterStrike",
        hasCooldown = false,
        isSnowflake = true,
        baseline = true
    })
    self.opportunity = TRB.Classes.SpellBase:New({
        id = 195627,
        baseline = true,
        isTalent = true
    })
    self.bladeFlurry = TRB.Classes.SpellThreshold:New({
        id = 13877,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "bladeFlurry",
        hasCooldown = true,
        cooldown = 30,
        restlessBlades = true,
        baseline = true,
        isTalent = true,
        rangeCheck = false
    })

    -- Outlaw Spec Abilities
    self.adrenalineRush.attributes.restlessBlades = true
    self.adrenalineRush.isTalent = true

    self.restlessBlades = TRB.Classes.SpellBase:New({
        id = 79096,
        isTalent = true
    })
    self.rollTheBones = TRB.Classes.SpellThreshold:New({
        id = 315508,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "rollTheBones",
        hasCooldown = true,
        cooldown = 45,
        restlessBlades = true,
        rangeCheck = false
    })

    -- Roll the Bones
    self.broadside = TRB.Classes.SpellBase:New({
        id = 193356,
    })
    self.buriedTreasure = TRB.Classes.SpellBase:New({
        id = 199600,
    })
    self.grandMelee = TRB.Classes.SpellBase:New({
        id = 193358,
    })
    self.ruthlessPrecision = TRB.Classes.SpellBase:New({
        id = 193357,
    })
    self.skullAndCrossbones = TRB.Classes.SpellBase:New({
        id = 199603,
    })
    self.trueBearing = TRB.Classes.SpellBase:New({
        id = 193359,
    })
    self.countTheOdds = TRB.Classes.SpellBase:New({
        id = 381982,
        duration = 5
    })
    self.bladeRush = TRB.Classes.SpellBase:New({
        id = 271877,
        isTalent = true,
        resource = 25,
        duration = 5,
        cooldown = 45,
        restlessBlades = true
    })
    self.keepItRolling = TRB.Classes.SpellBase:New({
        id = 381989,
        isTalent = true,
        duration = 30,
        cooldown = 60 * 7,
        restlessBlades = true
    })
    self.killingSpree = TRB.Classes.SpellComboPointThreshold:New({
        id = 51690,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "killingSpree",
        comboPoints = true,
        hasCooldown = true,
        isTalent = true,
        cooldown = 90,
        restlessBlades = true,
        rangeCheck = false
    })
    self.floatLikeAButterfly = TRB.Classes.SpellBase:New({
        id = 354897,
        isTalent = true
    })
    self.feint.attributes.restlessBlades = true
    self.feint.attributes.floatLikeAButterfly = true

    -- Trickster
    self.coupDeGrace = TRB.Classes.SpellComboPointThreshold:New({
        id = 441776,
        talentId = 441423,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "coupDeGrace",
        isTalent = true,
        isSnowflake = true
    })
    self.escalatingBlade = TRB.Classes.SpellBase:New({
        id = 441786,
        maxStacks = 4
    })

    return self
end


---@class TRB.Classes.Rogue.SubtletySpells : TRB.Classes.Rogue.RogueBaseSpells
---@field public shadowTechniques TRB.Classes.SpellBase
---@field public symbolsOfDeath TRB.Classes.SpellBase
---@field public shadowBlades TRB.Classes.SpellBase
---@field public shotInTheDark TRB.Classes.SpellBase
---@field public flagellation TRB.Classes.SpellBase
---@field public silentStorm TRB.Classes.SpellBase
---@field public finalityBlackPowder TRB.Classes.SpellBase
---@field public finalityEviscerate TRB.Classes.SpellBase
---@field public finalityRupture TRB.Classes.SpellBase
---@field public shadowcraft TRB.Classes.SpellBase
---@field public inevitability TRB.Classes.SpellBase
---@field public shadowDance TRB.Classes.SpellBase
---@field public gloomblade TRB.Classes.SpellThreshold
---@field public eviscerate TRB.Classes.SpellComboPointThreshold
---@field public backstab TRB.Classes.SpellComboPointThreshold
---@field public blackPowder TRB.Classes.SpellComboPointThreshold
---@field public shadowstrike TRB.Classes.SpellComboPointThreshold
---@field public shurikenStorm TRB.Classes.SpellComboPointThreshold
---@field public shurikenToss TRB.Classes.SpellComboPointThreshold
---@field public secretTechnique TRB.Classes.SpellComboPointThreshold
---@field public goremawsBite TRB.Classes.SpellComboPointThreshold
---@field public killingSpree TRB.Classes.SpellComboPointThreshold
TRB.Classes.Rogue.SubtletySpells = setmetatable({}, {__index = TRB.Classes.Rogue.RogueBaseSpells})
TRB.Classes.Rogue.SubtletySpells.__index = TRB.Classes.Rogue.SubtletySpells

function TRB.Classes.Rogue.SubtletySpells:New()
    ---@type TRB.Classes.Rogue.RogueBaseSpells
    local base = TRB.Classes.Rogue.RogueBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Rogue.SubtletySpells) --[[@as TRB.Classes.Rogue.SubtletySpells]]

    self.eviscerate = TRB.Classes.SpellComboPointThreshold:New({ -- This is technically a Rogue ability but is missing from the other specs
        id = 196819,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "eviscerate",
        baseline = true,
        isSnowflake = true
    })

    -- Subtlety Baseline Abilities
    self.backstab = TRB.Classes.SpellComboPointThreshold:New({
        id = 53,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "backstab",
        baseline = true,
        isSnowflake = true
    })
    self.blackPowder = TRB.Classes.SpellComboPointThreshold:New({
        id = 319175,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "blackPowder",
        baseline = true,
        isSnowflake = true
    })
    self.shadowstrike = TRB.Classes.SpellComboPointThreshold:New({
        id = 185438,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        stealth = true,
        settingKey = "shadowstrike",
        baseline = true
    })
    self.shurikenStorm = TRB.Classes.SpellComboPointThreshold:New({
        id = 197835,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shurikenStorm",
        baseline = true,
        isSnowflake = true,
        rangeCheck = false
    })
    self.shurikenToss = TRB.Classes.SpellComboPointThreshold:New({
        id = 114014,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shurikenToss",
        baseline = true
    })
    self.shadowTechniques = TRB.Classes.SpellBase:New({
        id = 196911
    })
    self.symbolsOfDeath = TRB.Classes.SpellBase:New({
        id = 212283,
        baseline = true
    })
    self.shadowDance = TRB.Classes.SpellBase:New({
        id = 185422,
        baseline = true
    })

    -- Subtlety Spec Abilities		
    --TODO: Do something with this tracking!	
    self.shadowBlades = TRB.Classes.SpellBase:New({
        id = 121471,
        isTalent = true
    })
    self.gloomblade = TRB.Classes.SpellThreshold:New({
        id = 200758,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "gloomblade",
        isTalent = true,
        isSnowflake = true
    })
    self.secretTechnique = TRB.Classes.SpellComboPointThreshold:New({
        id = 280719,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "secretTechnique",
        hasCooldown = true,
        baseline = true
    })
    self.goremawsBite = TRB.Classes.SpellComboPointThreshold:New({
        id = 426593,
        talentId = 426591,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 3,
        settingKey = "goremawsBite",
        hasCooldown = true,
        isTalent = true
    })
    self.shotInTheDark = TRB.Classes.SpellBase:New({
        id = 257506,
        isTalent = true
    })
    self.flagellation = TRB.Classes.SpellBase:New({
        id = 384631,
        isTalent = true
    })
    self.silentStorm = TRB.Classes.SpellBase:New({
        id = 385727,
    })
    self.finalityBlackPowder = TRB.Classes.SpellBase:New({
        id = 385948,
    })
    self.finalityEviscerate = TRB.Classes.SpellBase:New({
        id = 385949,
    })
    self.finalityRupture = TRB.Classes.SpellBase:New({
        id = 385951,
    })
    self.shadowcraft = TRB.Classes.SpellBase:New({
        id = 426594,
        isTalent = true
    })
    self.inevitability = TRB.Classes.SpellBase:New({
        id = 382512,
        isTalent = true
    })
    -- Trickster
    self.coupDeGrace = TRB.Classes.SpellComboPointThreshold:New({
        id = 441776,
        talentId = 441423,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "coupDeGrace",
        isTalent = true,
        isSnowflake = true
    })
    self.escalatingBlade = TRB.Classes.SpellBase:New({
        id = 441786,
        maxStacks = 4
    })
       
    return self
end


--[[
    BarGroups Factory for Rogue
    Creates the appropriate BarGroup instances for each Rogue specialization.
    
    All Rogue specs use:
    - Primary bar (N=1): Energy
    - Secondary bar (N=5-7): Combo Points
]]

---@class TRB.Classes.Rogue.BarGroupsFactory
TRB.Classes.Rogue.BarGroupsFactory = {}
TRB.Classes.Rogue.BarGroupsFactory.__index = TRB.Classes.Rogue.BarGroupsFactory

---Creates BarGroup instances for the specified Rogue specialization
---@param specId integer # 1=Assassination, 2=Outlaw, 3=Subtlety
---@param parentFrame Frame # The parent frame for the primary bar group (typically UIParent)
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary Energy bar (1 node) - all specs
    barGroups.primary = TRB.Classes.BarGroup:New(
        parentFrame,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Combo Points (5 nodes by default, can be up to 7 with talents) - all specs
    -- Secondary bars are parented to UIParent for independent visibility
    barGroups.secondary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_ComboPoint",
        5,
        false -- not primary
    )

    -- Health bar (1 node)
    barGroups.health = TRB.Classes.BarGroup:New(
        parentFrame or UIParent,
        "TwintopResourceBarFrame_Health",
        1,
        false -- not primary
    )

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Rogue.BarGroupsFactory:GetSpecConfiguration(specId)
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true
        },
        secondary = {
            maxNodes = 7, -- Max possible with talents
            isPrimary = false,
            resourceType = "ComboPoints"
        },
        health = {
            maxNodes = 1,
            isPrimary = false,
            resourceType = "Health"
        }
    }
end