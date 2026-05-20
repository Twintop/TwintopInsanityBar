---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Druid = TRB.Classes.Druid or {}

---@class TRB.Classes.Druid.DruidBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field public frenziedRegeneration TRB.Classes.SpellThreshold
---@field public ironfur TRB.Classes.SpellThreshold
---@field public ferociousBiteMinimum TRB.Classes.SpellComboPointThreshold
---@field public ferociousBiteMaximum TRB.Classes.SpellComboPointThreshold
---@field public shred TRB.Classes.SpellComboPointThreshold
---@field public rake TRB.Classes.SpellComboPointThreshold
---@field public rip TRB.Classes.SpellComboPointThreshold
---@field public maim TRB.Classes.SpellComboPointThreshold
TRB.Classes.Druid.DruidBaseSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Druid.DruidBaseSpells.__index = TRB.Classes.Druid.DruidBaseSpells

function TRB.Classes.Druid.DruidBaseSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), {__index = TRB.Classes.Druid.BalanceSpells})

    -- Bear Form abilities
    self.frenziedRegeneration = TRB.Classes.SpellThreshold:New({
        id = 22842,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "frenziedRegeneration",
        hasCooldown = true,
		rangeCheck = false,
        category = "defensive"
    })
    self.ironfur = TRB.Classes.SpellThreshold:New({
        id = 192081,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "ironfur",
		rangeCheck = false,
        category = "defensive"
    })

    -- Cat Form abilities
    self.ferociousBiteMinimum = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "ferociousBiteMinimum",
        isSnowflake = true,
        category = "offensive"
    })
    self.ferociousBiteMaximum = TRB.Classes.SpellComboPointThreshold:New({
        id = 22568,
        primaryResourceType = Enum.PowerType.Energy,
        primaryResourceTypeMod = 2,
        comboPoints = true,
        settingKey = "ferociousBiteMaximum",
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
    })
    self.shred = TRB.Classes.SpellComboPointThreshold:New({
        id = 5221,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shred",
        isClearcasting = true,
        category = "offensive"
    })
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
        baseline = true,
        category = "offensive"
    })
    self.rip = TRB.Classes.SpellComboPointThreshold:New({
        id = 1079,
        debuffId = 1079,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "rip",
        hasSnapshot = true,
        bonuses = {
            bloodtalons = true,
            tigersFury = true
        },
        isTalent = true,
        baseline = true,
        category = "offensive"
    })
    self.maim = TRB.Classes.SpellComboPointThreshold:New({
        id = 22570,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "maim",
        hasCooldown = true,
        cooldown = 20,
        isTalent = true,
        category = "utility"
    })

    return self
end


---@class TRB.Classes.Druid.BalanceSpells : TRB.Classes.Druid.DruidBaseSpells
---@field public moonfire TRB.Classes.SpellBase
---@field public starfire TRB.Classes.SpellBase
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
TRB.Classes.Druid.BalanceSpells = setmetatable({}, {__index = TRB.Classes.Druid.DruidBaseSpells})
TRB.Classes.Druid.BalanceSpells.__index = TRB.Classes.Druid.BalanceSpells

function TRB.Classes.Druid.BalanceSpells:New()
    ---@type TRB.Classes.Druid.DruidBaseSpells
    local base = TRB.Classes.Druid.DruidBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Druid.BalanceSpells) --[[@as TRB.Classes.Druid.BalanceSpells]]
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
        isSnowflake = true,
        category = "offensive"
    })
    self.starsurge2 = TRB.Classes.SpellThreshold:New({
        id = 78674,
        primaryResourceType = Enum.PowerType.LunarPower,
        primaryResourceTypeMod = 2,
        settingKey = "starsurge2",
        isTalent = true,
        baseline = true,
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
    })
    self.starsurge3 = TRB.Classes.SpellThreshold:New({
        id = 78674,
        primaryResourceType = Enum.PowerType.LunarPower,
        primaryResourceTypeMod = 3,
        settingKey = "starsurge3",
        isTalent = true,
        baseline = true,
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
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
        rangeCheck = false,
        category = "offensive"
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

---Fills barTextVariables for Balance Druid options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Druid.BalanceSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Druid.BalanceSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#wrath", icon = spells.wrath.icon, description = spells.wrath.name, printInSettings = true },
		{ variable = "#starfire", icon = spells.starfire.icon, description = spells.starfire.name, printInSettings = true },
		
		{ variable = "#starsurge", icon = spells.starsurge.icon, description = spells.starsurge.name, printInSettings = true },
		{ variable = "#starfall", icon = spells.fullMoon.icon, description = spells.fullMoon.name, printInSettings = true },

		{ variable = "#eclipse", icon = string.format(L["DruidBalanceIcon_eclipse"], spells.incarnationChosenOfElune.icon, spells.celestialAlignment.icon, spells.eclipseSolar.icon, spells.eclipseLunar.icon), description = L["DruidBalanceIconDescription_eclipse"], printInSettings = true },
		{ variable = "#celestialAlignment", icon = spells.celestialAlignment.icon, description = spells.celestialAlignment.name, printInSettings = true },			
		{ variable = "#icoe", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = true },			
		{ variable = "#coe", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
		{ variable = "#incarnation", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
		{ variable = "#incarnationChosenOfElune", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
		{ variable = "#solar", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = true },
		{ variable = "#eclipseSolar", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = false },
		{ variable = "#solarEclipse", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = false },
		{ variable = "#lunar", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = true },
		{ variable = "#eclipseLunar", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = false },
		{ variable = "#lunarEclipse", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = false },
		
		{ variable = "#soulOfTheForest", icon = spells.soulOfTheForest.icon, description = spells.soulOfTheForest.name, printInSettings = true },
		
		{ variable = "#stellarFlare", icon = spells.stellarFlare.icon, description = spells.stellarFlare.name, printInSettings = true },

		{ variable = "#newMoon", icon = spells.newMoon.icon, description = spells.newMoon.name, printInSettings = true },
		{ variable = "#halfMoon", icon = spells.halfMoon.icon, description = spells.halfMoon.name, printInSettings = true },
		{ variable = "#fullMoon", icon = spells.fullMoon.icon, description = spells.fullMoon.name, printInSettings = true },
		{ variable = "#moon", icon = string.format(L["DruidBalanceIcon_moon"], spells.newMoon.icon, spells.halfMoon.icon, spells.fullMoon.icon), description = L["DruidBalanceIconDescription_moon"], printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$astralPower", description = L["DruidBalanceBarTextVariable_astralPower"], printInSettings = true, color = false },
		{ variable = "$astralPowerMax", description = L["DruidBalanceBarTextVariable_astralPowerMax"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DruidRestorationBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
		{ variable = "$rage", description = L["DruidGuardianBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$rageMax", description = L["DruidGuardianBarTextVariable_rageMax"], printInSettings = true, color = false },

		{ variable = "$eclipse", description = L["DruidBalanceBarTextVariable_eclipse"], printInSettings = true, color = false },
		{ variable = "$eclipseTime", description = L["DruidBalanceBarTextVariable_eclipseTime"], printInSettings = true, color = false },
		{ variable = "$lunar", description = L["DruidBalanceBarTextVariable_lunar"], printInSettings = true, color = false },
		{ variable = "$lunarEclipse", description = "", printInSettings = false, color = false },
		{ variable = "$eclipseLunar", description = "", printInSettings = false, color = false },
		{ variable = "$solar", description = L["DruidBalanceBarTextVariable_solar"], printInSettings = true, color = false },
		{ variable = "$solarEclipse", description = "", printInSettings = false, color = false },
		{ variable = "$eclipseSolar", description = "", printInSettings = false, color = false },
		{ variable = "$celestialAlignment", description = L["DruidBalanceBarTextVariable_celestialAlignment"], printInSettings = true, color = false },
		
		{ variable = "$starsurgeUsable", description = L["DruidBalanceBarTextVariable_starsurgeUsable"], printInSettings = true, color = false },
		{ variable = "$starfallUsable", description = L["DruidBalanceBarTextVariable_starfallUsable"], printInSettings = true, color = false },
	})
end


---@class TRB.Classes.Druid.FeralSpells : TRB.Classes.Druid.DruidBaseSpells
---@field public clearcasting TRB.Classes.SpellBase
---@field public lunarInspiration TRB.Classes.SpellBase
---@field public berserk TRB.Classes.SpellBase
---@field public incarnationAvatarOfAshamane TRB.Classes.SpellBase
---@field public circleOfLifeAndDeath TRB.Classes.SpellBase
---@field public apexPredatorsCraving TRB.Classes.SpellBase
---@field public empoweredShapeshifting TRB.Classes.SpellBase
---@field public swipe TRB.Classes.SpellComboPointThreshold
---@field public primalWrath TRB.Classes.SpellComboPointThreshold
---@field public moonfire TRB.Classes.SpellComboPointThreshold
---@field public feralFrenzy TRB.Classes.SpellComboPointThreshold
---@field public franticFrenzy TRB.Classes.SpellComboPointThreshold
---@field public ravageMinimum TRB.Classes.SpellComboPointThreshold
---@field public ravageMaximum TRB.Classes.SpellComboPointThreshold
---@field public frenziedRegeneration TRB.Classes.SpellComboPointThreshold
TRB.Classes.Druid.FeralSpells = setmetatable({}, {__index = TRB.Classes.Druid.DruidBaseSpells})
TRB.Classes.Druid.FeralSpells.__index = TRB.Classes.Druid.FeralSpells

function TRB.Classes.Druid.FeralSpells:New()
    ---@type TRB.Classes.Druid.DruidBaseSpells
    local base = TRB.Classes.Druid.DruidBaseSpells
    self = setmetatable(base:New(),  TRB.Classes.Druid.FeralSpells) --[[@as TRB.Classes.Druid.FeralSpells]]

    -- Feral Spec Baseline Abilities
    self.swipe = TRB.Classes.SpellComboPointThreshold:New({
        id = 106785,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "swipe",
        isSnowflake = true,
        isTalent = false,
        baseline = true,
        rangeCheck = false,
        category = "offensive"
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
        isTalent = true,
        category = "offensive"
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
        },
        category = "offensive"
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
    self.feralFrenzy = TRB.Classes.SpellComboPointThreshold:New({
        id = 274837,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 5,
        settingKey = "feralFrenzy",
        isTalent = true,
        hasCooldown = true,
        isSnowflake = true,
        category = "offensive"
    })
    self.franticFrenzy = TRB.Classes.SpellComboPointThreshold:New({
        id = 1243807,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 5,
        settingKey = "franticFrenzy",
        isTalent = true,
        hasCooldown = true,
        isSnowflake = true,
        rangeCheck = false,
        category = "offensive"
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
        isSnowflake = true,
        category = "offensive"
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
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
    })
    self.frenziedRegeneration = TRB.Classes.SpellThreshold:New({
        id = 22842,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "frenziedRegeneration",
        hasCooldown = true,
        isSnowflake = true, -- Only usable in Catform with Empowered Shapeshifting
		rangeCheck = false,
        category = "defensive"
    })

    return self
end

---Fills barTextVariables for Feral Druid options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Druid.FeralSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Druid.FeralSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#apexPredatorsCraving", icon = spells.apexPredatorsCraving.icon, description = spells.apexPredatorsCraving.name, printInSettings = true },
		{ variable = "#berserk", icon = spells.berserk.icon, description = spells.berserk.name, printInSettings = true },
		{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
		{ variable = "#feralFrenzy", icon = spells.feralFrenzy.icon, description = spells.feralFrenzy.name, printInSettings = true },
		{ variable = "#ferociousBite", icon = spells.ferociousBiteMinimum.icon, description = spells.ferociousBiteMinimum.name, printInSettings = true },
		{ variable = "#incarnation", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = true },
		{ variable = "#incarnationAvatarOfAshamane", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = false },
		{ variable = "#lunarInspiration", icon = spells.lunarInspiration.icon, description = spells.lunarInspiration.name, printInSettings = true },
		{ variable = "#maim", icon = spells.maim.icon, description = spells.maim.name, printInSettings = true },
		{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
		{ variable = "#primalWrath", icon = spells.primalWrath.icon, description = spells.primalWrath.name, printInSettings = true },
		{ variable = "#rake", icon = spells.rake.icon, description = spells.rake.name, printInSettings = true },
		{ variable = "#ravage", icon = spells.ravageMinimum.icon, description = spells.ravageMinimum.name, printInSettings = true },
		{ variable = "#rip", icon = spells.rip.icon, description = spells.rip.name, printInSettings = true },
		{ variable = "#shred", icon = spells.shred.icon, description = spells.shred.name, printInSettings = true },
		{ variable = "#swipe", icon = spells.swipe.icon, description = spells.swipe.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },
        { variable = "$ravageActive", description = "", printInSettings = false, color = false },

		{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DruidRestorationBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
		{ variable = "$rage", description = L["DruidGuardianBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$rageMax", description = L["DruidGuardianBarTextVariable_rageMax"], printInSettings = true, color = false },
		
		{ variable = "$berserkTime", description = L["DruidFeralBarTextVariable_berserkTime"], printInSettings = true, color = false },
		{ variable = "$incarnationTime", description = "", printInSettings = false, color = false },
		{ variable = "$incarnationTicks", description = L["DruidFeralBarTextVariable_incarnationTicks"], printInSettings = true, color = false },
		{ variable = "$incarnationTickTime", description = L["DruidFeralBarTextVariable_incarnationTickTime"], printInSettings = true, color = false },
		{ variable = "$incarnationNextCp", description = L["DruidFeralBarTextVariable_incarnationNextCp"], printInSettings = true, color = false },

		{ variable = "$clearcastingActive", description = L["DruidFeralBarTextVariable_clearcastingActive"], printInSettings = true, color = false },
	})
end


---@class TRB.Classes.Druid.GuardianSpells : TRB.Classes.Druid.DruidBaseSpells
---@field public berserk TRB.Classes.SpellBase
---@field public incarnationGuardianOfUrsoc TRB.Classes.SpellBase
---@field public harnessedRage TRB.Classes.SpellBase
---@field public killingBlow TRB.Classes.SpellBase
---@field public maul TRB.Classes.SpellThreshold
---@field public maulKillingBlow TRB.Classes.SpellThreshold
---@field public maulHarnessedRage TRB.Classes.SpellThreshold
---@field public raze TRB.Classes.SpellThreshold
---@field public razeKillingBlow TRB.Classes.SpellThreshold
---@field public razeHarnessedRage TRB.Classes.SpellThreshold
TRB.Classes.Druid.GuardianSpells = setmetatable({}, {__index = TRB.Classes.Druid.DruidBaseSpells})
TRB.Classes.Druid.GuardianSpells.__index = TRB.Classes.Druid.GuardianSpells

function TRB.Classes.Druid.GuardianSpells:New()
    ---@type TRB.Classes.Druid.DruidBaseSpells
    local base = TRB.Classes.Druid.DruidBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Druid.GuardianSpells) --[[@as TRB.Classes.Druid.GuardianSpells]]

    self.maul = TRB.Classes.SpellThreshold:New({
        id = 6807,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "maul",
        isSnowflake = true,
        category = "offensive"
    })
    self.maulKillingBlow = TRB.Classes.SpellThreshold:New({
        id = 6807,
        spellId = 1252994,
        useSpellIcon = true,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "maulKillingBlow",
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
    })
    self.maulHarnessedRage = TRB.Classes.SpellThreshold:New({
        id = 6807,
        spellId = 1253035,
        useSpellIcon = true,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "maulHarnessedRage",
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
    })
    self.raze = TRB.Classes.SpellThreshold:New({
        id = 400254,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "raze",
        category = "offensive"
    })
    self.razeKillingBlow = TRB.Classes.SpellThreshold:New({
        id = 400254,
        spellId = 1252994,
        useSpellIcon = true,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "razeKillingBlow",
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
    })
    self.razeHarnessedRage = TRB.Classes.SpellThreshold:New({
        id = 400254,
        spellId = 1253035,
        useSpellIcon = true,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Rage,
        settingKey = "razeHarnessedRage",
        isSnowflake = true,
        category = "offensive",
        canHaveAudioCue = false
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
    self.harnessedRage = TRB.Classes.SpellBase:New({
        id = 1253035,
        isTalent = true,
        resourceMod = 2
    })
    self.killingBlow = TRB.Classes.SpellBase:New({
        id = 1252994,
        isTalent = true,
        resourceMod = 20
    })

    return self
end

---Fills barTextVariables for Guardian Druid options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Druid.GuardianSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Druid.GuardianSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#berserk", icon = spells.berserk.icon, description = spells.berserk.name, printInSettings = true },
	})

	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
		{ variable = "$rage", description = L["DruidGuardianBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$rageMax", description = L["DruidGuardianBarTextVariable_rageMax"], printInSettings = true, color = false },
		
		{ variable = "$berserkTime", description = L["DruidGuardianBarTextVariable_berserkTime"], printInSettings = true, color = false },
		{ variable = "$incarnationTime", description = "", printInSettings = false, color = false },
	})
end


---@class TRB.Classes.Druid.RestorationSpells : TRB.Classes.Healer.HealerSpells, TRB.Classes.Druid.DruidBaseSpells
---@field public efflorescence TRB.Classes.SpellBase
---@field public lifetreading TRB.Classes.SpellBase
---@field public lifebloom TRB.Classes.SpellBase
---@field public incarnationTreeOfLife TRB.Classes.SpellBase
---@field public cenariusGuidance TRB.Classes.SpellBase
---@field public clearcasting TRB.Classes.SpellBase
TRB.Classes.Druid.RestorationSpells = setmetatable({}, {__index = TRB.Classes.Druid.DruidBaseSpells})
TRB.Classes.Druid.RestorationSpells.__index = TRB.Classes.Druid.RestorationSpells

function TRB.Classes.Druid.RestorationSpells:New()
    ---@type TRB.Classes.Druid.DruidBaseSpells
    local druidBase = TRB.Classes.Druid.DruidBaseSpells
    self = setmetatable(druidBase:New(), TRB.Classes.Druid.RestorationSpells) --[[@as TRB.Classes.Druid.RestorationSpells]]
    
    -- Mixin HealerSpells abilities
    local healerSpells = TRB.Classes.Healer.HealerSpells:New()
    for k, v in pairs(healerSpells) do
        if self[k] == nil then -- Don't override DruidBaseSpells abilities
            self[k] = v
        end
    end

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

---Fills barTextVariables for Restoration Druid options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Druid.RestorationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Druid.RestorationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#efflorescence", icon = spells.efflorescence.icon, description = spells.efflorescence.name, printInSettings = true },
		{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
		{ variable = "#incarnation", icon = spells.incarnationTreeOfLife.icon, description = spells.incarnationTreeOfLife.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DruidRestorationBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
		{ variable = "$rage", description = L["DruidGuardianBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$rageMax", description = L["DruidGuardianBarTextVariable_rageMax"], printInSettings = true, color = false },

		{ variable = "$incarnationTime", description = L["DruidRestorationBarTextVariable_incarnationTime"], printInSettings = true, color = false },

		{ variable = "$clearcastingActive", description = L["DruidRestorationBarTextVariable_clearcastingActive"], printInSettings = true, color = false },

		{ variable = "$efflorescenceTime", description = L["DruidRestorationBarTextVariable_efflorescenceTime"], printInSettings = true, color = false },
	})
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
    
    -- Check if form switching is enabled for non-Feral specs
    local specNames = { [1] = "balance", [2] = "feral", [3] = "guardian", [4] = "restoration" }
    local specName = specNames[specId]
    local druidSettings = TRB.Data.settings and TRB.Data.settings.druid and TRB.Data.settings.druid[specName]
    -- enableFormSwitching defaults to true. Only skip secondary bar if explicitly set to false.
    local enableFormSwitching = true
    if druidSettings and druidSettings.displayBar and druidSettings.displayBar.enableFormSwitching == false then
        enableFormSwitching = false
    end

    -- showComboPoints allows specs to display combo points (Feral defaults to true, others to false)
    local showComboPoints = false
    if druidSettings and druidSettings.displayBar and druidSettings.displayBar.showComboPoints then
        showComboPoints = true
    end
    
    -- Create secondary bar when showComboPoints is enabled (or not explicitly disabled for Feral),
    -- or when form switching could require it.
    local createSecondary = (specId == 2 and showComboPoints ~= false) or enableFormSwitching or showComboPoints

    if specId == 1 then -- Balance
        -- Primary Astral Power bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Combo Points (5 nodes) - for form-based switching to Cat form
        if createSecondary then
            barGroups.secondary = TRB.Classes.BarGroup:New(
                UIParent,
                "TwintopResourceBarFrame_ComboPoint",
                5,
                false -- not primary
            )
        end

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

        -- Combo Points (5 nodes) - for form-based switching to Cat form
        if createSecondary then
            barGroups.secondary = TRB.Classes.BarGroup:New(
                UIParent,
                "TwintopResourceBarFrame_ComboPoint",
                5,
                false -- not primary
            )
        end

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

        -- Combo Points (5 nodes) - for form-based switching to Cat form
        if createSecondary then
            barGroups.secondary = TRB.Classes.BarGroup:New(
                UIParent,
                "TwintopResourceBarFrame_ComboPoint",
                5,
                false -- not primary
            )
        end

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
            secondary = {
                maxNodes = 5,
                isPrimary = false,
                resourceType = "ComboPoints"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            },
            mana = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Mana"
            },
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
    elseif specId == 4 then -- Restoration
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
    end

    return {}
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["druid_balance"] = TRB.Classes.Druid.BalanceSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["druid_feral"] = TRB.Classes.Druid.FeralSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["druid_guardian"] = TRB.Classes.Druid.GuardianSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["druid_restoration"] = TRB.Classes.Druid.RestorationSpells.FillBarTextVariables