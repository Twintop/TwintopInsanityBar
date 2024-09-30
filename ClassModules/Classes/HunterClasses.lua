local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 3 then --Only do this if we're on a Hunter!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Hunter = TRB.Classes.Hunter or {}

---@class TRB.Classes.Hunter.HunterBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field public concussiveShot TRB.Classes.SpellBase
---@field public serpentSting TRB.Classes.SpellBase
---@field public revivePet TRB.Classes.SpellThreshold
---@field public wingClip TRB.Classes.SpellThreshold
---@field public killShot TRB.Classes.SpellThreshold
---@field public scareBeast TRB.Classes.SpellThreshold
---@field public explosiveShot TRB.Classes.SpellThreshold
TRB.Classes.Hunter.HunterBaseSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Hunter.HunterBaseSpells.__index = TRB.Classes.Hunter.HunterBaseSpells

---Creates a new HunterBaseSpells
---@return TRB.Classes.Hunter.HunterBaseSpells
function TRB.Classes.Hunter.HunterBaseSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Hunter.HunterBaseSpells) --[[@as TRB.Classes.Hunter.HunterBaseSpells]]
    
    -- Hunter Class Baseline Abilities
    self.revivePet = TRB.Classes.SpellThreshold:New({
        id = 982,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "revivePet",
        baseline = true
    })
    self.wingClip = TRB.Classes.SpellThreshold:New({
        id = 195645,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wingClip",
        baseline = true
    })
    self.concussiveShot = TRB.Classes.SpellBase:New({
        id = 5116,
        isTalent = true
    })
    self.killShot = TRB.Classes.SpellThreshold:New({
        id = 53351,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "killShot",
        healthMinimum = 0.2,
        hasCooldown = true,
        isSnowflake = true
    })
    self.scareBeast = TRB.Classes.SpellThreshold:New({
        id = 1513,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "scareBeast"
    })
    self.explosiveShot = TRB.Classes.SpellThreshold:New({
        id = 212431,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "explosiveShot",
        hasCooldown = true,
        cooldown = 30,
        isTalent = true
    })
    self.serpentSting = TRB.Classes.SpellBase:New({
        id = 271788,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "serpentSting",
        isTalent = true,
        baseDuration = 18
    })

    return self
end

---@class TRB.Classes.Hunter.BeastMasterySpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public barbedShot TRB.Classes.SpellBase
---@field public savagery TRB.Classes.SpellBase
---@field public frenzy TRB.Classes.SpellBase
---@field public cobraSting TRB.Classes.SpellBase
---@field public beastialWrath TRB.Classes.SpellBase
---@field public barbedWrath TRB.Classes.SpellBase
---@field public scentOfBlood TRB.Classes.SpellBase
---@field public beastCleave TRB.Classes.SpellBase
---@field public callOfTheWild TRB.Classes.SpellBase
---@field public bloodFrenzy TRB.Classes.SpellBase
---@field public huntersPrey TRB.Classes.SpellBase
---@field public barrage TRB.Classes.SpellThreshold
---@field public cobraShot TRB.Classes.SpellThreshold
---@field public killCommand TRB.Classes.SpellThreshold
---@field public multiShot TRB.Classes.SpellThreshold
---@field public blackArrow TRB.Classes.SpellThreshold
---@field public direBeastBasilisk TRB.Classes.SpellThreshold
---@field public direBeastHawk TRB.Classes.SpellThreshold
TRB.Classes.Hunter.BeastMasterySpells = setmetatable({}, {__index = TRB.Classes.Hunter.HunterBaseSpells})
TRB.Classes.Hunter.BeastMasterySpells.__index = TRB.Classes.Hunter.BeastMasterySpells

function TRB.Classes.Hunter.BeastMasterySpells:New()
    ---@type TRB.Classes.Hunter.HunterBaseSpells
    local base = TRB.Classes.Hunter.HunterBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Hunter.BeastMasterySpells) --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

    -- Hunter Talent Abilities	
    self.killShot.baseline = true

    -- Beast Mastery Spec Baseline Abilities

    -- Beast Mastery Spec Talents	
    self.barrage = TRB.Classes.SpellThreshold:New({
        id = 120360,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "barrage",
        isTalent = true,
        hasCooldown = true,
        cooldown = 20
    })
    self.cobraShot = TRB.Classes.SpellThreshold:New({
        id = 193455,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "cobraShot",
        killCommandCooldownReduction = 2,
        isTalent = true
    })
    self.multiShot = TRB.Classes.SpellThreshold:New({
        id = 2643,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "multiShot",
        isTalent = true
    })
    self.barbedShot = TRB.Classes.SpellBase:New({
        id = 217200,
        buffIdList = {
            246152,
            246851,
            246852,
            246853,
            246854
        },
        resource = 5,
        ticks = 4,
        duration = 8,
        hasCharges = true,
        hasCooldown = true,
        isTalent = true
    })
    self.savagery = TRB.Classes.SpellBase:New({
        id = 424557,
        isTalent = true,
        duration = 2
    })
    self.frenzy = TRB.Classes.SpellBase:New({
        id = 272790,
        duration = 8
    })
    self.cobraSting = TRB.Classes.SpellBase:New({
        id = 392296,
        isTalent = true
    })
    self.beastialWrath = TRB.Classes.SpellBase:New({
        id = 19574,
        isTalent = true
    })
    self.barbedWrath = TRB.Classes.SpellBase:New({
        id = 19574,
        beastialWrathCooldownReduction = 12,
        isTalent = true
    })
    self.scentOfBlood = TRB.Classes.SpellBase:New({
        id = 193532,
        isTalent = true
    })
    self.beastCleave = TRB.Classes.SpellBase:New({
        id = 115939,
        buffId = 268877,
        isTalent = true
    })
    self.callOfTheWild = TRB.Classes.SpellBase:New({
        id = 359844,
        isTalent = true
    })
    self.bloodFrenzy = TRB.Classes.SpellBase:New({
        id = 407412,
        isTalent = true
    })
    self.killCommand = TRB.Classes.SpellThreshold:New({
        id = 34026,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "killCommand",
        hasCooldown = true,
        isTalent = true,
        baseline = false,
        isSnowflake = true
    })
    self.huntersPrey = TRB.Classes.SpellBase:New({
        id = 378215,
        talentId = 378210,
        isTalent = true,
        isBuff = true
    })

    -- Dark Ranger
    self.blackArrow = TRB.Classes.SpellThreshold:New({
        id = 430703,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "blackArrow",
        hasCooldown = true,
        isTalent = true,
        baseline = false -- When subTreeActive = true
    })

    -- PvP
    self.direBeastBasilisk = TRB.Classes.SpellThreshold:New({
        id = 205691,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "direBeastBasilisk",
        hasCooldown = true,
        cooldown = 120,
        isPvp = true,
    })
    self.direBeastHawk = TRB.Classes.SpellThreshold:New({
        id = 208652,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "direBeastHawk",
        hasCooldown = true,
        cooldown = 30,
        isPvp = true,
    })

    return self
end


---@class TRB.Classes.Hunter.MarksmanshipSpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public steadyShot TRB.Classes.SpellBase
---@field public improvedSteadyShot TRB.Classes.SpellBase
---@field public rapidFire TRB.Classes.SpellBase
---@field public deathblow TRB.Classes.SpellBase
---@field public steadyFocus TRB.Classes.SpellBase
---@field public trueshot TRB.Classes.SpellBase
---@field public lockAndLoad TRB.Classes.SpellBase
---@field public arcaneShot TRB.Classes.SpellThreshold
---@field public aimedShot TRB.Classes.SpellThreshold
---@field public barrage TRB.Classes.SpellThreshold
---@field public chimaeraShot TRB.Classes.SpellThreshold
---@field public multiShot TRB.Classes.SpellThreshold
---@field public burstingShot TRB.Classes.SpellThreshold
---@field public wailingArrow TRB.Classes.SpellThreshold
---@field public blackArrow TRB.Classes.SpellThreshold
---@field public sniperShot TRB.Classes.SpellThreshold
TRB.Classes.Hunter.MarksmanshipSpells = setmetatable({}, {__index = TRB.Classes.Hunter.HunterBaseSpells})
TRB.Classes.Hunter.MarksmanshipSpells.__index = TRB.Classes.Hunter.MarksmanshipSpells

function TRB.Classes.Hunter.MarksmanshipSpells:New()
    ---@type TRB.Classes.Hunter.HunterBaseSpells
    local base = TRB.Classes.Hunter.HunterBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Hunter.MarksmanshipSpells) --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

    -- Hunter Talent Abilities	
    self.killShot.baseline = true

    -- Marksmanship Spec Baseline Abilities
    self.steadyShot = TRB.Classes.SpellBase:New({
        id = 56641,
        resource = 0,
        baseline = true
    })
    self.arcaneShot = TRB.Classes.SpellThreshold:New({
        id = 185358,
        iconName = "ability_impalingbolt",
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "arcaneShot",
        baseline = true
    })

    -- Marksmanship Spec Talents
    self.aimedShot = TRB.Classes.SpellThreshold:New({
        id = 19434,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "aimedShot",
        hasCooldown = true,
        isSnowflake = true,
        isTalent = true,
        hasCharges = true
    })
    self.barrage = TRB.Classes.SpellThreshold:New({
        id = 120360,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "barrage",
        isTalent = true,
        hasCooldown = true,
        cooldown = 20
    })
    self.improvedSteadyShot = TRB.Classes.SpellBase:New({
        id = 321018,
        resource = 10,
        isTalent = true
    })
    self.rapidFire = TRB.Classes.SpellBase:New({
        id = 257044,
        resource = 1,
        shots = 7,
        duration = 2, --On cast then every 1/3 sec, hasted
        isTalent = true
    })
    self.chimaeraShot = TRB.Classes.SpellThreshold:New({
        id = 342049,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "chimaeraShot",
        isTalent = true
    })
    self.deathblow = TRB.Classes.SpellBase:New({
        id = 378770,
        talentId = 378769,
        isTalent = true,
        isBuff = true
    })
    self.multiShot = TRB.Classes.SpellThreshold:New({
        id = 257620,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "multiShot",
        isTalent = true
    })
    self.burstingShot = TRB.Classes.SpellThreshold:New({
        id = 186387,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "burstingShot",
        hasCooldown = true,
        isTalent = true
    })
    self.steadyFocus = TRB.Classes.SpellBase:New({
        id = 193534,
        talentId = 193533,
        duration = 15,
        isTalent = true
    })
    self.trueshot = TRB.Classes.SpellBase:New({
        id = 288613,
        resourcePercent = 1.5,
        isTalent = true
    })

    -- TODO: Bulletstorm support?
    self.lockAndLoad = TRB.Classes.SpellBase:New({
        id = 194594,
        isTalent = true
    })

    self.wailingArrow = TRB.Classes.SpellThreshold:New({
        id = 355589,
        talentId = 459806,
        aimedShotOverrideId = 392060,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wailingArrow",
        hasCooldown = true,
        cooldown = 60,
        isTalent = true,
        isSnowflake = true
    })

    -- Dark Ranger
    self.blackArrow = TRB.Classes.SpellThreshold:New({
        id = 430703,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "blackArrow",
        hasCooldown = true,
        isTalent = true,
        baseline = false
    })

    -- PvP
    self.sniperShot = TRB.Classes.SpellThreshold:New({
        id = 203155,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "sniperShot",
        hasCooldown = true,
        cooldown = 10,
        isPvp = true,
    })

    return self
end


---@class TRB.Classes.Hunter.SurvivalSpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public killCommand TRB.Classes.SpellBase
---@field public guerrillaTactics TRB.Classes.SpellBase
---@field public harpoon TRB.Classes.SpellBase
---@field public termsOfEngagement TRB.Classes.SpellBase
---@field public flankingStrike TRB.Classes.SpellBase
---@field public coordinatedAssault TRB.Classes.SpellBase
---@field public bombardier TRB.Classes.SpellBase
---@field public arcaneShot TRB.Classes.SpellThreshold
---@field public wildfireBomb TRB.Classes.SpellThreshold
---@field public raptorStrike TRB.Classes.SpellThreshold
---@field public butchery TRB.Classes.SpellThreshold
---@field public mongooseBite TRB.Classes.SpellThreshold
TRB.Classes.Hunter.SurvivalSpells = setmetatable({}, {__index = TRB.Classes.Hunter.HunterBaseSpells})
TRB.Classes.Hunter.SurvivalSpells.__index = TRB.Classes.Hunter.SurvivalSpells

function TRB.Classes.Hunter.SurvivalSpells:New()
    ---@type TRB.Classes.Hunter.HunterBaseSpells
    local base = TRB.Classes.Hunter.HunterBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Hunter.SurvivalSpells) --[[@as TRB.Classes.Hunter.SurvivalSpells]]
    
    -- Hunter Talent Abilities	
    self.killCommand = TRB.Classes.SpellBase:New({
        id = 34026,
        resource = 15,
        isSnowflake = true,
        hasCooldown = true,
        baseline = true,
        isTalent = true
    })

    -- Survival Spec Baseline Abilities
    self.arcaneShot = TRB.Classes.SpellThreshold:New({
        id = 185358,
        iconName = "ability_impalingbolt",
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "arcaneShot",
        baseline = true
    })

    -- Survival Spec Talents
    self.raptorStrike = TRB.Classes.SpellThreshold:New({
        id = 186270,
        primaryResourceType = Enum.PowerType.Focus,
        isSnowflake = true,
        settingKey = "raptorStrike",
        isTalent = true
    })
    self.guerrillaTactics = TRB.Classes.SpellBase:New({
        id = 264332,
        isTalent = true
    })
    self.wildfireBomb = TRB.Classes.SpellThreshold:New({
        id = 259495,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wildfireBomb",
        isTalent = true,
        hasCharges = true,
        hasCooldown = true
    })
    self.harpoon = TRB.Classes.SpellBase:New({
        id = 190925,
        isTalent = true
    })
    self.termsOfEngagement = TRB.Classes.SpellBase:New({
        id = 265898,
        hasTicks = true,
        resourcePerTick = 2,
        tickRate = 1,
        isTalent = true
    })
    self.butchery = TRB.Classes.SpellThreshold:New({
        id = 212436,
        primaryResourceType = Enum.PowerType.Focus,
        isTalent = true,
        hasCooldown = true,
        hasCharges = true,
        settingKey = "butchery"
    })
    self.mongooseBite = TRB.Classes.SpellThreshold:New({
        id = 259387,
        primaryResourceType = Enum.PowerType.Focus,
        isSnowflake = true,
        settingKey = "mongooseBite",
        isTalent = true
    })
    self.flankingStrike = TRB.Classes.SpellBase:New({
        id = 269751,
        resource = 30,
        hasCooldown = true,
        isTalent = true
    })
    self.coordinatedAssault = TRB.Classes.SpellBase:New({
        id = 360952,
        isTalent = true
    })
    self.bombardier = TRB.Classes.SpellBase:New({
        id = 459859,
        hasCharges = true
    })

    self.explosiveShot.isSnowflake = true

    return self
end