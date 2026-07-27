local _, TRB = ...

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
        isSnowflake = true,
        category = "offensive"
    })
    self.crimsonVial = TRB.Classes.SpellThreshold:New({
        id = 185311,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "crimsonVial",
        hasCooldown = true,
        cooldown = 30,
        baseline = true,
        rangeCheck = false,
        category = "defensive"
    })
    self.distract = TRB.Classes.SpellThreshold:New({
        id = 1725,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 0,
        settingKey = "distract",
        hasCooldown = true,
        cooldown = 30,
        baseline = true,
        rangeCheck = false,
        category = "utility"
    })
    self.kidneyShot = TRB.Classes.SpellComboPointThreshold:New({
        id = 408,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "kidneyShot",
        hasCooldown = true,
        cooldown = 20,
        baseline = true,
        category = "offensive"
    })
    self.sliceAndDice = TRB.Classes.SpellComboPointThreshold:New({
        id = 315496,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "sliceAndDice",
        hasCooldown = false,
        isSnowflake = true,
        baseline = true,
        rangeCheck = false,
        category = "offensive"
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
        rangeCheck = false,
        category = "defensive"
    })

    --Rogue Talent Abilities
    self.shiv = TRB.Classes.SpellComboPointThreshold:New({
        id = 5938,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shiv",
        hasCooldown = true,
        isTalent = true,
        category = "offensive"
    })
    self.sap = TRB.Classes.SpellThreshold:New({ -- Baseline
        id = 6770,
        primaryResourceType = Enum.PowerType.Energy,
        stealth = true,
        settingKey = "sap",
        baseline = true,
        category = "utility"
    })
    self.gouge = TRB.Classes.SpellComboPointThreshold:New({
        id = 1776,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "gouge",
        hasCooldown = true,
        cooldown = 15,
        isTalent = true,
        category = "utility"
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
        isPvp = true,
        category = "pvp"
    })
    self.dismantle = TRB.Classes.SpellThreshold:New({
        id = 207777,
        primaryResourceType = Enum.PowerType.Energy,
        settingKey = "dismantle",
        hasCooldown = true,
        isPvp = true,
        category = "pvp"
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
        baseline = true,
        category = "offensive"
    })
    self.shiv.baseline = true
    self.shiv.hasCharges = true
    
    -- Assassination Baseline Abilities
    self.envenom = TRB.Classes.SpellComboPointThreshold:New({
        id = 32645,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "envenom",
        baseline = true,
        category = "offensive"
    })
    self.fanOfKnives = TRB.Classes.SpellComboPointThreshold:New({
        id = 51723,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "fanOfKnives",
        baseline = true,
        rangeCheck = false,
        category = "offensive"
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
        pandemic = true,
        category = "offensive"
    })
    self.mutilate = TRB.Classes.SpellComboPointThreshold:New({
        id = 1329,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        settingKey = "mutilate",
        baseline = true,
        isSnowflake = true,
        category = "offensive"
    })
    self.poisonedKnife = TRB.Classes.SpellComboPointThreshold:New({
        id = 185565,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "poisonedKnife",
        baseline = true,
        category = "offensive"
    })
    self.rupture = TRB.Classes.SpellComboPointThreshold:New({
        id = 1943,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "rupture",
        baseline = true,
        category = "offensive"
    })

    self.crimsonTempest = TRB.Classes.SpellComboPointThreshold:New({
        id = 1247227,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "crimsonTempest",
        isTalent = true,
        rangeCheck = false,
        category = "offensive"
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
        isTalent = true,
        category = "offensive"
    })

    return self
end

---Fills barTextVariables for Assassination Rogue options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Rogue.AssassinationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Rogue.AssassinationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#blindside", icon = spells.blindside.icon, description = spells.blindside.name, printInSettings = true },
		{ variable = "#crimsonTempest", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = true },
		{ variable = "#ct", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = false },
		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#garrote", icon = spells.garrote.icon, description = spells.garrote.name, printInSettings = true },
		{ variable = "#rupture", icon = spells.rupture.icon, description = spells.rupture.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },

		{ variable = "$energy", description = L["RogueAssassinationBarTextVariable_energy"], printInSettings = true, color = false, secret = true },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true },
		{ variable = "$energyMax", description = L["RogueAssassinationBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueAssassinationBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueAssassinationBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

		--[[
		-- Proc
		{ variable = "$blindsideTime", description = L["RogueAssassinationBarTextVariable_blindsideTime"], printInSettings = true, color = false },]]
	})
end

---Gets built-in castbar channel tick profiles for Assassination, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Rogue.AssassinationSpells.GetCastbarTickProfiles()
	return {}
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
        baseline = true,
        category = "offensive"
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
        baseline = true,
        category = "offensive"
    })
    self.dispatch = TRB.Classes.SpellComboPointThreshold:New({
        id = 2098,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "dispatch",
        baseline = true,
        isSnowflake = true,
        category = "offensive"
    })
    self.pistolShot = TRB.Classes.SpellComboPointThreshold:New({
        id = 185763,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "pistolShot",
        hasCooldown = false,
        isSnowflake = true,
        baseline = true,
        category = "offensive"
    })
    self.sinisterStrike = TRB.Classes.SpellComboPointThreshold:New({
        id = 193315,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "sinisterStrike",
        hasCooldown = false,
        isSnowflake = true,
        baseline = true,
        category = "offensive"
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
        rangeCheck = false,
        category = "offensive"
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
        rangeCheck = false,
        category = "utility"
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
        rangeCheck = false,
        category = "offensive"
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
        isSnowflake = true,
        category = "offensive"
    })

    return self
end

---Fills barTextVariables for Outlaw Rogue options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Rogue.OutlawSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Rogue.OutlawSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#adrenalineRush", icon = spells.adrenalineRush.icon, description = spells.adrenalineRush.name, printInSettings = true },
		{ variable = "#betweenTheEyes", icon = spells.betweenTheEyes.icon, description = spells.betweenTheEyes.name, printInSettings = true },
		{ variable = "#bladeFlurry", icon = spells.bladeFlurry.icon, description = spells.bladeFlurry.name, printInSettings = true },
		{ variable = "#bladeRush", icon = spells.bladeRush.icon, description = spells.bladeRush.name, printInSettings = true },
		{ variable = "#broadside", icon = spells.broadside.icon, description = spells.broadside.name, printInSettings = true },
		{ variable = "#buriedTreasure", icon = spells.buriedTreasure.icon, description = spells.buriedTreasure.name, printInSettings = true },
		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dispatch", icon = spells.dispatch.icon, description = spells.dispatch.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#grandMelee", icon = spells.grandMelee.icon, description = spells.grandMelee.name, printInSettings = true },
		{ variable = "#opportunity", icon = spells.opportunity.icon, description = spells.opportunity.name, printInSettings = true },
		{ variable = "#pistolShot", icon = spells.pistolShot.icon, description = spells.pistolShot.name, printInSettings = true },
		{ variable = "#rollTheBones", icon = spells.rollTheBones.icon, description = spells.rollTheBones.name, printInSettings = true },
		{ variable = "#ruthlessPrecision", icon = spells.ruthlessPrecision.icon, description = spells.ruthlessPrecision.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#sinisterStrike", icon = spells.sinisterStrike.icon, description = spells.sinisterStrike.name, printInSettings = true },
		{ variable = "#skullAndCrossbones", icon = spells.skullAndCrossbones.icon, description = spells.skullAndCrossbones.name, printInSettings = true },
		{ variable = "#trueBearing", icon = spells.trueBearing.icon, description = spells.trueBearing.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueOutlawBarTextVariable_energy"], printInSettings = true, color = false, secret = true },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true },
		{ variable = "$energyMax", description = L["RogueOutlawBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueOutlawBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueOutlawBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Outlaw, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Rogue.OutlawSpells.GetCastbarTickProfiles()
	return {
		-- Killing Spree
		[51690] = { mode = "fixedCount", baseTickRate = 0.5, tickCountSource = "comboPointsSpent", bonusTicksPerChargedPoint = 2 },
    }
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
        isSnowflake = true,
        category = "offensive"
    })

    -- Subtlety Baseline Abilities
    self.backstab = TRB.Classes.SpellComboPointThreshold:New({
        id = 53,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "backstab",
        baseline = true,
        isSnowflake = true,
        category = "offensive"
    })
    self.blackPowder = TRB.Classes.SpellComboPointThreshold:New({
        id = 319175,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "blackPowder",
        baseline = true,
        isSnowflake = true,
        category = "offensive"
    })
    self.shadowstrike = TRB.Classes.SpellComboPointThreshold:New({
        id = 185438,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 2,
        stealth = true,
        settingKey = "shadowstrike",
        baseline = true,
        category = "offensive"
    })
    self.shurikenStorm = TRB.Classes.SpellComboPointThreshold:New({
        id = 197835,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shurikenStorm",
        baseline = true,
        isSnowflake = true,
        rangeCheck = false,
        category = "offensive"
    })
    self.shurikenToss = TRB.Classes.SpellComboPointThreshold:New({
        id = 114014,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 1,
        settingKey = "shurikenToss",
        baseline = true,
        category = "offensive"
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
        isSnowflake = true,
        category = "offensive"
    })
    self.secretTechnique = TRB.Classes.SpellComboPointThreshold:New({
        id = 280719,
        primaryResourceType = Enum.PowerType.Energy,
        comboPoints = true,
        settingKey = "secretTechnique",
        hasCooldown = true,
        baseline = true,
        category = "offensive"
    })
    self.goremawsBite = TRB.Classes.SpellComboPointThreshold:New({
        id = 426593,
        talentId = 426591,
        primaryResourceType = Enum.PowerType.Energy,
        comboPointsGenerated = 3,
        settingKey = "goremawsBite",
        hasCooldown = true,
        isTalent = true,
        category = "offensive"
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
        isSnowflake = true,
        category = "offensive"
    })
       
    return self
end

---Fills barTextVariables for Subtlety Rogue options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Rogue.SubtletySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Rogue.SubtletySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#flagellation", icon = spells.flagellation.icon, description = spells.flagellation.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#shadowTechniques", icon = spells.shadowTechniques.icon, description = spells.shadowTechniques.name, printInSettings = true },
		{ variable = "#sod", icon = spells.symbolsOfDeath.icon, description = spells.symbolsOfDeath.name, printInSettings = true },
		{ variable = "#symbolsOfDeath", icon = spells.symbolsOfDeath.icon, description = spells.symbolsOfDeath.name, printInSettings = false },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueSubtletyBarTextVariable_energy"], printInSettings = true, color = false, secret = true },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true },
		{ variable = "$energyMax", description = L["RogueSubtletyBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueSubtletyBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueSubtletyBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Subtlety, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Rogue.SubtletySpells.GetCastbarTickProfiles()
	return {}
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
            isPrimary = true,
            resourceType = "Energy"
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

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["rogue_assassination"] = TRB.Classes.Rogue.AssassinationSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["rogue_outlaw"] = TRB.Classes.Rogue.OutlawSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["rogue_subtlety"] = TRB.Classes.Rogue.SubtletySpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["rogue_assassination"] = TRB.Classes.Rogue.AssassinationSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["rogue_outlaw"] = TRB.Classes.Rogue.OutlawSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["rogue_subtlety"] = TRB.Classes.Rogue.SubtletySpells.GetCastbarTickProfiles