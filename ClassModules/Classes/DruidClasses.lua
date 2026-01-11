---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
if TRB.Data.character.classId ~= 11 then --Only do this if we're on a Druid!
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
---@field public eclipseSolar TRB.Classes.SpellBase
---@field public eclipseLunar TRB.Classes.SpellBase
---@field public celestialAlignment TRB.Classes.SpellBase
---@field public incarnationChosenOfElune TRB.Classes.SpellBase
---@field public stellarFlare TRB.Classes.SpellBase
---@field public wildSurges TRB.Classes.SpellBase
---@field public soulOfTheForest TRB.Classes.SpellBase
---@field public newMoon TRB.Classes.SpellBase
---@field public halfMoon TRB.Classes.SpellBase
---@field public fullMoon TRB.Classes.SpellBase
---@field public boundlessMoonlight TRB.Classes.SpellBase
---@field public theEternalMoon TRB.Classes.SpellBase
---@field public moonGuardian TRB.Classes.SpellBase
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
        isTalent = true,
        baseline = true
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
        baseline = true,
        rangeCheck = false
    })

    -- Balance Spec Talents
    self.eclipseSolar = TRB.Classes.SpellBase:New({
        id = 48517,
        castId = 1233346,
        duration = 15
    })
    self.eclipseLunar = TRB.Classes.SpellBase:New({
        id = 48518,
        castId = 1233272,
        duration = 15
    })
    self.celestialAlignment = TRB.Classes.SpellBase:New({
        id = 383410,
        talentId = 194223,
        castId = 383410,
        isTalent = true,
        duration = 15
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
    self.soulOfTheForest = TRB.Classes.SpellBase:New({
        id = 114107,
        modifier = {
            wrath = 0.4,
            starfire = 0.4
        },
        isTalent = true
    })
    self.incarnationChosenOfElune = TRB.Classes.SpellBase:New({
        id = 102560,
        talentId = 394013,
        castId = 390414,
        isTalent = true,
        duration = 20
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
    self.moonGuardian = TRB.Classes.SpellBase:New({
        id = 429520,
        isTalent = true,
        resourceMod = 2
    })
    --Set Bonuses

    return self
end


---@class TRB.Classes.Druid.FeralSpells : TRB.Classes.SpecializationSpellsBase
---@field public clearcasting TRB.Classes.SpellBase
---@field public lunarInspiration TRB.Classes.SpellBase
---@field public berserk TRB.Classes.SpellBase
---@field public incarnationAvatarOfAshamane TRB.Classes.SpellBase
---@field public circleOfLifeAndDeath TRB.Classes.SpellBase
---@field public apexPredatorsCraving TRB.Classes.SpellBase
---@field public empoweredShapeshifting TRB.Classes.SpellBase
---@field public rake TRB.Classes.SpellComboPointThreshold
---@field public rip TRB.Classes.SpellComboPointThreshold
---@field public maim TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMinimum TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMaximum TRB.Classes.SpellComboPointThreshold
---@field public shred TRB.Classes.SpellComboPointThreshold
---@field public swipe TRB.Classes.SpellComboPointThreshold
---@field public primalWrath TRB.Classes.SpellComboPointThreshold
---@field public moonfire TRB.Classes.SpellComboPointThreshold
---@field public brutalSlash TRB.Classes.SpellComboPointThreshold
---@field public feralFrenzy TRB.Classes.SpellComboPointThreshold
---@field public franticFrenzy TRB.Classes.SpellComboPointThreshold
---@field public ravageMinimum TRB.Classes.SpellComboPointThreshold
---@field public ravageMaximum TRB.Classes.SpellComboPointThreshold
---@field public frenziedRegeneration TRB.Classes.SpellComboPointThreshold
TRB.Classes.Druid.FeralSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.FeralSpells.__index = TRB.Classes.Druid.FeralSpells

function TRB.Classes.Druid.FeralSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(),  {__index = TRB.Classes.Druid.FeralSpells})

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

    -- Feral Spec Baseline Abilities
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
    self.berserk = TRB.Classes.SpellBase:New({
        id = 106951,
        castId = 106951,
        isTalent = true,
        energizeId = 343216,
        tickRate = 1.5,
        duration = 15,
        offset = 0
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
    self.feralFrenzy = TRB.Classes.SpellComboPointThreshold:New({
        id = 274837,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 5,
        settingKey = "feralFrenzy",
        isTalent = true,
        hasCooldown = true,
        isSnowflake = true
    })
    self.franticFrenzy = TRB.Classes.SpellComboPointThreshold:New({
        id = 1243807,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 5,
        settingKey = "franticFrenzy",
        isTalent = true,
        hasCooldown = true,
        isSnowflake = true,
        rangeCheck = false
    })
    self.incarnationAvatarOfAshamane = TRB.Classes.SpellBase:New({
        id = 102543,
        castId = 102558,
        castId2 = 102543,
        isTalent = true,
        tickRate = 1.5,
        duration = 20,
        offset = 0.5
    })
    self.circleOfLifeAndDeath = TRB.Classes.SpellBase:New({
        id = 391969,
        isTalent = true,
        modifier = 0.75
    })
    self.apexPredatorsCraving = TRB.Classes.SpellBase:New({
        id = 391882
    })
    -- Druid of the Claw
    self.empoweredShapeshifting = TRB.Classes.SpellBase:New({
        id = 441689,
        isTalent = true
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
    self.frenziedRegeneration = TRB.Classes.SpellThreshold:New({
        id = 22842,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "frenziedRegeneration",
        hasCooldown = true,
        isSnowflake = true, -- Only usable in Catform with Empowered Shapeshifting
		rangeCheck = false
    })

    return self
end


---@class TRB.Classes.Druid.GuardianSpells : TRB.Classes.SpecializationSpellsBase
---@field public berserk TRB.Classes.SpellBase
---@field public incarnationGuardianOfUrsoc TRB.Classes.SpellBase
---@field public frenziedRegeneration TRB.Classes.SpellThreshold
---@field public ironfur TRB.Classes.SpellThreshold
---@field public maul TRB.Classes.SpellThreshold
---@field public raze TRB.Classes.SpellThreshold
TRB.Classes.Druid.GuardianSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.GuardianSpells.__index = TRB.Classes.Druid.GuardianSpells

function TRB.Classes.Druid.GuardianSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), {__index = TRB.Classes.Druid.GuardianSpells})

    
    self.frenziedRegeneration = TRB.Classes.SpellThreshold:New({
        id = 22842,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "frenziedRegeneration",
        hasCooldown = true,
		rangeCheck = false
    })
    self.ironfur = TRB.Classes.SpellThreshold:New({
        id = 192081,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "ironfur",
		rangeCheck = false
    })
    self.maul = TRB.Classes.SpellThreshold:New({
        id = 6807,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "maul",
        isSnowflake = true
    })
    self.raze = TRB.Classes.SpellThreshold:New({
        id = 400254,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "raze"
    })
    self.berserk = TRB.Classes.SpellBase:New({
        id = 50334,
        castId = 50334,
        isTalent = true,
        duration = 15
    })
    self.incarnationGuardianOfUrsoc = TRB.Classes.SpellBase:New({
        id = 102558,
        castId = 102558,
        isTalent = true,
        duration = 30
    })

    return self
end


---@class TRB.Classes.Druid.RestorationSpells : TRB.Classes.Healer.HealerSpells
---@field public efflorescence TRB.Classes.SpellBase
---@field public lifetreading TRB.Classes.SpellBase
---@field public lifebloom TRB.Classes.SpellBase
---@field public incarnationTreeOfLife TRB.Classes.SpellBase
---@field public cenariusGuidance TRB.Classes.SpellBase
---@field public clearcasting TRB.Classes.SpellBase
TRB.Classes.Druid.RestorationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Druid.RestorationSpells.__index = TRB.Classes.Druid.RestorationSpells

function TRB.Classes.Druid.RestorationSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), {__index = TRB.Classes.Druid.RestorationSpells})

    -- Restoration Spec Talents
    self.efflorescence = TRB.Classes.SpellBase:New({
        id = 145205,
        castId = 145205,
        duration = 30,
        isTalent = true
    })
    self.lifetreading = TRB.Classes.SpellBase:New({
        id = 1217941,
        isTalent = true
    })
    self.lifebloom = TRB.Classes.SpellBase:New({
        id = 33763,
        castId = 33763,
        isTalent = true
    })
    self.incarnationTreeOfLife = TRB.Classes.SpellBase:New({
        id = 117679,
        castId = 33891,
        isTalent = true,
        duration = 30
    })
    self.cenariusGuidance = TRB.Classes.SpellBase:New({
        id = 393371,
        isTalent = true
    })
    self.clearcasting = TRB.Classes.SpellBase:New({
        id = 16870
    })

    return self
end

--[[
    BarGroups Factory for Druid
    Creates the appropriate BarGroup instances for each Druid specialization.
    
    Balance: Primary bar (N=1) only
    Feral: Primary bar (N=1) + Combo Points (N=5, can be 6 with talents)
    Guardian: Primary bar (N=1) only
    Restoration: Primary bar (N=1) only
]]

---@class TRB.Classes.Druid.BarGroupsFactory
TRB.Classes.Druid.BarGroupsFactory = {}
TRB.Classes.Druid.BarGroupsFactory.__index = TRB.Classes.Druid.BarGroupsFactory

---Creates BarGroup instances for the specified Druid specialization
---@param specId integer # 1=Balance, 2=Feral, 3=Guardian, 4=Restoration
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(specId)
    local barGroups = {}

    if specId == 1 then -- Balance
        -- Primary Astral Power bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

        -- Mana bar (1 node) - optional secondary mana display for Balance
        barGroups.mana = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Mana",
            1,
            false -- not primary
        )

    elseif specId == 2 then -- Feral
        -- Primary Energy bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Combo Points (5 nodes by default, can be 6 with talents)
        -- Secondary bars are parented to UIParent for independent visibility
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            5,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 3 then -- Guardian
        -- Primary Rage bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 4 then -- Restoration
        -- Primary Mana bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )
    end

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Druid.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Balance
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
    elseif specId == 2 then -- Feral
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            secondary = {
                maxNodes = 5,
                isPrimary = false,
                resourceType = "ComboPoints"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 3 then -- Guardian
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
    elseif specId == 4 then -- Restoration
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

    return {}
end