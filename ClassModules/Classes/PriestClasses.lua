---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 5 then --Only do this if we're on a Priest!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Priest = TRB.Classes.Priest or {}

---@class TRB.Classes.Priest.HolyWordSpell : TRB.Classes.SpellBase
---@field public holyWordKey string? # Holy Word spell key that has its cooldown reduced on cast.
---@field public holyWordReduction number? # How much the associated Holy Word will have its cooldown reduced.
---@field public holyWordModifier number? # Modification of the reduction when included with related casts.
TRB.Classes.Priest.HolyWordSpell = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.Priest.HolyWordSpell.__index = TRB.Classes.Priest.HolyWordSpell

---Creates a new HolyWordSpell object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.Priest.HolyWordSpell
function TRB.Classes.Priest.HolyWordSpell:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local spellBase = TRB.Classes.SpellBase
    self = setmetatable(spellBase:New(spellAttributes), {__index = TRB.Classes.Priest.HolyWordSpell})

    table.insert(self.classTypes, "TRB.Classes.Priest.HolyWordSpell")
    
    self.holyWordModifier = 1
    self.holyWordReduction = 0

    for key, value in pairs(spellAttributes) do
        if  (key == "holyWordReduction" and type(value) == "number") or
            (key == "holyWordModifier"  and type(value) == "number") or
            (key == "holyWordKey") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end


---@class TRB.Classes.Priest.HealerSpells : TRB.Classes.Healer.HealerSpells
---@field public shadowWordPain TRB.Classes.SpellBase
---@field public shadowfiend TRB.Classes.SpellThreshold
---@field public surgeOfLight TRB.Classes.SpellBase
---@field public imbuedFrostweaveSlippers TRB.Classes.SpellBase
TRB.Classes.Priest.HealerSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Priest.HealerSpells.__index = TRB.Classes.Priest.HealerSpells

function TRB.Classes.Priest.HealerSpells:New()
       ---@type TRB.Classes.Healer.HealerSpells
       local base = TRB.Classes.Healer.HealerSpells
       self = setmetatable(base:New(), TRB.Classes.Priest.HealerSpells) --[[@as TRB.Classes.Priest.HealerSpells]]
   
       -- Priest Class Baseline Abilities
       self.shadowWordPain = TRB.Classes.SpellBase:New({
           id = 589,
           baseDuration = 16,
           pandemic = true,
           isTalent = false,
           baseline = true
       })

       -- Priest Talent Abilities
       self.shadowfiend = TRB.Classes.SpellThreshold:New({
           id = 34433,
           iconName = "spell_shadow_shadowfiend",
           energizeId = 343727,
           thresholdId = 8,
           settingKey = "shadowfiend",
           isTalent = true,
           baseline = false,
           resourcePercent = 0.005,
           duration = 15
       })
       self.surgeOfLight = TRB.Classes.SpellBase:New({
           id = 114255,
           duration = 20,
           isTalent = true
       })

    -- Imbued Frostweave Slippers
    self.imbuedFrostweaveSlippers = TRB.Classes.SpellBase:New({
        id = 419273,
        itemId = 207817,
        resourcePercent = 0.0006
    })

       return self
end


---@class TRB.Classes.Priest.DisciplineSpells : TRB.Classes.Priest.HealerSpells
---@field public atonement TRB.Classes.SpellBase
---@field public evangelism TRB.Classes.SpellBase
---@field public powerWordRadiance TRB.Classes.SpellBase
---@field public lightsPromise TRB.Classes.SpellBase
---@field public rapture TRB.Classes.SpellBase
---@field public shadowCovenant TRB.Classes.SpellBase
---@field public purgeTheWicked TRB.Classes.SpellBase
---@field public mindbender TRB.Classes.SpellBase
TRB.Classes.Priest.DisciplineSpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.DisciplineSpells.__index = TRB.Classes.Priest.DisciplineSpells

function TRB.Classes.Priest.DisciplineSpells:New()
    ---@type TRB.Classes.Priest.HealerSpells
    local base = TRB.Classes.Priest.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Priest.DisciplineSpells) --[[@as TRB.Classes.Priest.DisciplineSpells]]

    -- Priest Class Baseline Abilities
    self.shadowWordPain = TRB.Classes.SpellBase:New({
        id = 589,
        baseDuration = 16,
        pandemic = true,
        isTalent = false,
        baseline = true
    })

    self.shadowfiend.baseline = true
    
    -- Discipline Baseline Abilities

    -- Priest Talent Abilities

    -- Discipline Talent Abilities
    self.atonement = TRB.Classes.SpellBase:New({
        id = 194384,
        isTalent = true,
        isBuff = true,
        duration = 15
    })
    self.evangelism = TRB.Classes.SpellBase:New({
        id = 246287,
        atonementMod = 6
    })
    self.powerWordRadiance = TRB.Classes.SpellBase:New({
        id = 194509,
        isTalent = true,
        hasCharges = true
    })
    self.lightsPromise = TRB.Classes.SpellBase:New({
        id = 322115,
        isTalent = true
    })
    self.rapture = TRB.Classes.SpellBase:New({
        id = 47536,
        isTalent = true
    })
    self.shadowCovenant = TRB.Classes.SpellBase:New({
        id = 322105,
        talentId = 314867,
        isTalent = true
    })
    self.purgeTheWicked = TRB.Classes.SpellBase:New({
        id = 204213,
        talentId = 204197,
        baseDuration = 20,
        pandemic = true,
        isTalent = true,
    })
    self.mindbender = TRB.Classes.SpellThreshold:New({
        id = 123040,
        iconName = "spell_shadow_soulleech_3",
        energizeId = 123051,
        thresholdId = 9, -- Really piggybacking off of #8
        settingKey = "mindbender",
        isTalent = true,
        duration = 12,
        resourcePercent = 0.002
    })
    
    return self
end


---@class TRB.Classes.Priest.HolySpells : TRB.Classes.Priest.HealerSpells
---@field public flashHeal TRB.Classes.SpellBase
---@field public holyWordSerenity TRB.Classes.SpellBase
---@field public holyWordChastise TRB.Classes.SpellBase
---@field public holyWordSanctify TRB.Classes.SpellBase
---@field public resonantWords TRB.Classes.SpellBase
---@field public lightweaver TRB.Classes.SpellBase
---@field public miracleWorker TRB.Classes.SpellBase
---@field public divineConversation TRB.Classes.SpellBase
---@field public prayerFocus TRB.Classes.SpellBase
---@field public sacredReverence TRB.Classes.SpellBase
---@field public symbolOfHope TRB.Classes.SpellThreshold
---@field public smite TRB.Classes.Priest.HolyWordSpell
---@field public heal TRB.Classes.Priest.HolyWordSpell
---@field public prayerOfMending TRB.Classes.Priest.HolyWordSpell
---@field public renew TRB.Classes.Priest.HolyWordSpell
---@field public prayerOfHealing TRB.Classes.Priest.HolyWordSpell
---@field public holyFire TRB.Classes.Priest.HolyWordSpell
---@field public circleOfHealing TRB.Classes.Priest.HolyWordSpell
---@field public lightOfTheNaaru TRB.Classes.Priest.HolyWordSpell
---@field public harmoniousApparatus TRB.Classes.Priest.HolyWordSpell
---@field public apotheosis TRB.Classes.Priest.HolyWordSpell
TRB.Classes.Priest.HolySpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.HolySpells.__index = TRB.Classes.Priest.HolySpells

function TRB.Classes.Priest.HolySpells:New()
    ---@type TRB.Classes.Priest.HealerSpells
    local base = TRB.Classes.Priest.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Priest.HolySpells) --[[@as TRB.Classes.Priest.HolySpells]]

    -- Priest Class Baseline Abilities
    self.flashHeal = TRB.Classes.Priest.HolyWordSpell:New({
        id = 2061,
        holyWordKey = "holyWordSerenity",
        holyWordReduction = 6,
        isTalent = false,
        baseline = true
    })
    self.smite = TRB.Classes.Priest.HolyWordSpell:New({
        id = 585,
        holyWordKey = "holyWordChastise",
        holyWordReduction = 4,
        isTalent = false,
        baseline = true
    })

    -- Holy Baseline Abilities
    self.heal = TRB.Classes.Priest.HolyWordSpell:New({
        id = 2060,
        holyWordKey = "holyWordSerenity",
        holyWordReduction = 6,
        isTalent = false,
        baseline = true
    })

    self.prayerOfMending = TRB.Classes.Priest.HolyWordSpell:New({
        id = 33076,
        holyWordKey = "holyWordSerenity",
        holyWordReduction = 2, -- Per rank of Harmonious Apparatus
        isTalent = true,
        baseline = true
    })
    self.renew = TRB.Classes.Priest.HolyWordSpell:New({
        id = 139,
        holyWordKey = "holyWordSanctify",
        holyWordReduction = 2,
        isTalent = true,
        baseline = true
    })

    -- Holy Talent Abilities
    self.holyWordSerenity = TRB.Classes.SpellBase:New({
        id = 2050,
        duration = 60,
        hasCharges = true
    })
    self.prayerOfHealing = TRB.Classes.Priest.HolyWordSpell:New({
        id = 596,
        holyWordKey = "holyWordSanctify",
        holyWordReduction = 6,
        isTalent = true
    })
    self.holyWordChastise = TRB.Classes.SpellBase:New({
        id = 88625,
        duration = 60,
        isTalent = true
    })
    self.holyWordSanctify = TRB.Classes.SpellBase:New({
        id = 34861,
        duration = 60,
        isTalent = true,
        hasCharges = true
    })
    self.holyFire = TRB.Classes.Priest.HolyWordSpell:New({
        id = 14914,
        holyWordKey = "holyWordChastise",
        holyWordReduction = 2, -- Per rank of Harmonious Apparatus
        isTalent = true
    })
    self.circleOfHealing = TRB.Classes.Priest.HolyWordSpell:New({
        id = 204883,
        holyWordKey = "holyWordSanctify",
        holyWordReduction = 2, -- Per rank of Harmonious Apparatus
        isTalent = true
    })
    self.symbolOfHope = TRB.Classes.SpellThreshold:New({
        id = 64901,
        duration = 4.0, --Hasted
        resourcePercent = 0.02,
        thresholdId = 9,
        settingKey = "symbolOfHope",
        ticks = 4,
        tickId = 265144,
        isTalent = true
    })
    self.lightOfTheNaaru = TRB.Classes.Priest.HolyWordSpell:New({
        id = 196985,
        holyWordModifier = 0.1, -- Per rank
        isTalent = true
    })
    self.harmoniousApparatus = TRB.Classes.Priest.HolyWordSpell:New({
        id = 196985,
        holyWordModifier = 0.1, -- Per rank
        isTalent = true
    })
    self.apotheosis = TRB.Classes.Priest.HolyWordSpell:New({
        id = 200183,
        holyWordModifier = 4, -- 300% more
        duration = 20,
        isTalent = true
    })
    self.resonantWords = TRB.Classes.SpellBase:New({
        id = 372313,
        talentId = 372309,
        isTalent = true
    })
    self.lightweaver = TRB.Classes.SpellBase:New({
        id = 390993,
        talentId = 390992,
        isTalent = true
    })
    self.miracleWorker = TRB.Classes.SpellBase:New({
        id = 235587,
        isTalent = true
    })

    -- Imbued Frostweave Slippers
    self.imbuedFrostweaveSlippers = TRB.Classes.SpellBase:New({
        id = 419273,
        itemId = 207817,
        resourcePercent = 0.0006
    })

    -- Set Bonuses
    self.divineConversation = TRB.Classes.SpellBase:New({ -- T28 4P
        id = 363727,
        reduction = 15,
        reductionPvp = 10
    })
    self.prayerFocus = TRB.Classes.SpellBase:New({ -- T29 2P
        id = 394729,
        holyWordReduction = 2
    })
    self.sacredReverence = TRB.Classes.SpellBase:New({ -- T31 4P
        id = 423510,
    })

    return self
end


---@class TRB.Classes.Priest.ShadowSpells : TRB.Classes.SpecializationSpellsBase
---@field public mindBlast TRB.Classes.SpellBase
---@field public shadowWordPain TRB.Classes.SpellBase
---@field public mindFlay TRB.Classes.SpellBase
---@field public vampiricTouch TRB.Classes.SpellBase
---@field public voidBolt TRB.Classes.SpellBase
---@field public shadowfiend TRB.Classes.SpellBase
---@field public massDispel TRB.Classes.SpellBase
---@field public twistOfFate TRB.Classes.SpellBase
---@field public halo TRB.Classes.SpellBase
---@field public mindgames TRB.Classes.SpellBase
---@field public shadowyApparition TRB.Classes.SpellBase
---@field public auspiciousSpirits TRB.Classes.SpellBase
---@field public misery TRB.Classes.SpellBase
---@field public hallucinations TRB.Classes.SpellBase
---@field public voidEruption TRB.Classes.SpellBase
---@field public voidform TRB.Classes.SpellBase
---@field public darkAscension TRB.Classes.SpellBase
---@field public mindSpike TRB.Classes.SpellBase
---@field public surgeOfInsanity TRB.Classes.SpellBase
---@field public mindFlayInsanity TRB.Classes.SpellBase
---@field public mindSpikeInsanity TRB.Classes.SpellBase
---@field public deathspeaker TRB.Classes.SpellBase
---@field public voidTorrent TRB.Classes.SpellBase
---@field public shadowCrash TRB.Classes.SpellBase
---@field public shadowyInsight TRB.Classes.SpellBase
---@field public mindMelt TRB.Classes.SpellBase
---@field public mindbender TRB.Classes.SpellBase
---@field public devouredDespair TRB.Classes.SpellBase
---@field public mindDevourer TRB.Classes.SpellBase
---@field public idolOfCthun TRB.Classes.SpellBase
---@field public idolOfCthun_Tendril TRB.Classes.SpellBase
---@field public idolOfCthun_Lasher TRB.Classes.SpellBase
---@field public lashOfInsanity_Tendril TRB.Classes.SpellBase
---@field public lashOfInsanity_Lasher TRB.Classes.SpellBase
---@field public idolOfYoggSaron TRB.Classes.SpellBase
---@field public thingFromBeyond TRB.Classes.SpellBase
---@field public deathsTorment TRB.Classes.SpellBase
---@field public devouringPlague TRB.Classes.SpellThreshold
---@field public devouringPlague2 TRB.Classes.SpellThreshold
---@field public devouringPlague3 TRB.Classes.SpellThreshold
TRB.Classes.Priest.ShadowSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Priest.ShadowSpells.__index = TRB.Classes.Priest.ShadowSpells

function TRB.Classes.Priest.ShadowSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Priest.ShadowSpells) --[[@as TRB.Classes.Priest.ShadowSpells]]

    -- Priest Class Baseline Abilities
    self.mindBlast = TRB.Classes.SpellBase:New({
        id = 8092,
        resource = 6,
        isTalent = false,
        baseline = true,
        hasCharges = true
    })
    self.shadowWordPain = TRB.Classes.SpellBase:New({
        id = 589,
        resource = 3,
        baseDuration = 16,
        pandemic = true,
        isTalent = false,
        baseline = true,
        miseryPandemic = 21,
        miseryPandemicTime = 21 * 0.3,
    })

    -- Shadow Baseline Abilities
    self.mindFlay = TRB.Classes.SpellBase:New({
        id = 15407,
        resource = 2,
        isTalent = false,
        baseline = true
    })
    self.vampiricTouch = TRB.Classes.SpellBase:New({
        id = 34914,
        resource = 4,
        baseDuration = 21,
        pandemic = true,
        isTalent = false,
        baseline = true
    })
    self.voidBolt = TRB.Classes.SpellBase:New({
        id = 205448,
        resource = 10,
        isTalent = false,
        baseline = true
    })


    -- Priest Talent Abilities			
    self.shadowfiend = TRB.Classes.SpellBase:New({
        id = 34433,
        iconName = "spell_shadow_shadowfiend",
        energizeId = 279420,
        resource = 2,
        isTalent = true,
        baseline = true
    })
    self.massDispel = TRB.Classes.SpellBase:New({
        id = 32375,
        isTalent = true
    })
    self.twistOfFate = TRB.Classes.SpellBase:New({
        id = 390978,
        isTalent = true
    })
    self.halo = TRB.Classes.SpellBase:New({
        id = 120644,
        isTalent = true,
        resource = 10
    })
    self.mindgames = TRB.Classes.SpellBase:New({
        id = 375901,
        isTalent = true,
        resource = 10
    })


    -- Shadow Talent Abilities			
    self.devouringPlague = TRB.Classes.SpellThreshold:New({
        id = 335467,
        primaryResourceType = Enum.PowerType.Insanity,
        thresholdId = 1,
        settingKey = "devouringPlague",
        isTalent = true,
        isSnowflake = true
    })
    self.devouringPlague2 = TRB.Classes.SpellThreshold:New({
        id = 335467,
        primaryResourceType = Enum.PowerType.Insanity,
        primaryResourceTypeMod = 2,
        thresholdId = 2,
        settingKey = "devouringPlague2",
        isTalent = true,
        isSnowflake = true
    })
    self.devouringPlague3 = TRB.Classes.SpellThreshold:New({
        id = 335467,
        primaryResourceType = Enum.PowerType.Insanity,
        primaryResourceTypeMod = 3,
        thresholdId = 3,
        settingKey = "devouringPlague3",
        isTalent = true,
        isSnowflake = true
    })
    self.shadowyApparition = TRB.Classes.SpellBase:New({
        id = 341491,
        isTalent = true
    })
    self.auspiciousSpirits = TRB.Classes.SpellBase:New({
        id = 155271,
        idSpawn = 341263,
        idImpact = 413231,
        resource = 1,
        targetChance = function(num)
            if num == 0 then
                return 0
            else
                return 0.8*(num^(-0.8))
            end
        end,
        isTalent = true
    })
    self.misery = TRB.Classes.SpellBase:New({
        id = 238558,
        isTalent = true
    })
    self.hallucinations = TRB.Classes.SpellBase:New({
        id = 280752,
        resource = 4,
        isTalent = true
    })
    self.voidEruption = TRB.Classes.SpellBase:New({
        id = 228260,
        isTalent = true
    })
    self.voidform = TRB.Classes.SpellBase:New({
        id = 194249,
        isTalent = true
    })
    self.darkAscension = TRB.Classes.SpellBase:New({
        id = 391109,
        resource = 30,
        isTalent = true
    })
    self.mindSpike = TRB.Classes.SpellBase:New({
        id = 73510,
        resource = 4,
        isTalent = true
    })
    self.surgeOfInsanity = TRB.Classes.SpellBase:New({
        id = 391399,
        isTalent = true
    })
    self.mindFlayInsanity = TRB.Classes.SpellBase:New({
        id = 391403,
        buffId = 391401,
        resource = 4,
        isTalent = true
    })
    self.mindSpikeInsanity = TRB.Classes.SpellBase:New({
        id = 407466,
        buffId = 407468,
        talentId = 391403,
        resource = 8,
        isTalent = true
    })
    self.deathspeaker = TRB.Classes.SpellBase:New({
        id = 392507,
        buffId = 392511,
        isTalent = true
    })
    self.voidTorrent = TRB.Classes.SpellBase:New({
        id = 263165,
        resource = 6,
        isTalent = true
    })
    self.shadowCrash = TRB.Classes.SpellBase:New({
        id = 205385,
        resource = 6,
        isTalent = true
    })
    self.shadowyInsight = TRB.Classes.SpellBase:New({
        id = 375981,
        isTalent = true
    })
    self.mindMelt = TRB.Classes.SpellBase:New({
        id = 391092,
        isTalent = true
    })
    self.mindbender = TRB.Classes.SpellBase:New({
        id = 200174,
        iconName = "spell_shadow_soulleech_3",
        energizeId = 200010,
        resource = 2,
        isTalent = true
    })
    self.devouredDespair = TRB.Classes.SpellBase:New({ -- Idol of Y'Shaarj proc
        id = 373317,
        resource = 5,
        resourcePerTick = 5,
        tickRate = 1,
        hasTicks = true
    })
    self.mindDevourer = TRB.Classes.SpellBase:New({
        id = 373202,
        buffId = 373204,
        isTalent = true
    })
    self.idolOfCthun = TRB.Classes.SpellBase:New({
        id = 377349,
    })
    self.idolOfCthun_Tendril = TRB.Classes.SpellBase:New({
        id = 377355,
        tickId = 193473,
    })
    self.idolOfCthun_Lasher = TRB.Classes.SpellBase:New({
        id = 377357,
        tickId = 394979,
    })
    self.lashOfInsanity_Tendril = TRB.Classes.SpellBase:New({
        id = 344838,
        resource = 1,
        duration = 15,
        ticks = 15,
        tickDuration = 1
    })
    self.lashOfInsanity_Lasher = TRB.Classes.SpellBase:New({
        id = 344838, --Doesn't actually exist / unused?
        resource = 1,
        duration = 15,
        ticks = 15,
        tickDuration = 1
    })
    self.idolOfYoggSaron = TRB.Classes.SpellBase:New({
        id = 373276,
        talentId = 373273,
        isTalent = true,
        requiredStacks = 25
    })
    self.thingFromBeyond = TRB.Classes.SpellBase:New({
        id = 373277,
        isTalent = true,
        duration = 20
    })
    self.deathsTorment = TRB.Classes.SpellBase:New({ -- T31 4P
        id = 423726,
        maxStacks = 12
    })

    return self
end