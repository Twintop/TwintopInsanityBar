local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Hunter = TRB.Classes.Hunter or {}

---@class TRB.Classes.Hunter.HunterBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field public revivePet TRB.Classes.SpellThreshold
---@field public wingClip TRB.Classes.SpellThreshold
---@field public scareBeast TRB.Classes.SpellThreshold
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
        baseline = true,
		rangeCheck = false
    })
    self.wingClip = TRB.Classes.SpellThreshold:New({
        id = 195645,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wingClip",
        baseline = true
    })
    self.scareBeast = TRB.Classes.SpellThreshold:New({
        id = 1513,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "scareBeast",
        isTalent = true
    })

    return self
end

---@class TRB.Classes.Hunter.BeastMasterySpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public bestialWrath TRB.Classes.SpellBase
---@field public beastCleave TRB.Classes.SpellBase
---@field public cobraShot TRB.Classes.SpellThreshold
---@field public killCommand TRB.Classes.SpellThreshold
---@field public blackArrow TRB.Classes.SpellThreshold
---@field public wildThrash TRB.Classes.SpellThreshold
---@field public wailingArrow TRB.Classes.SpellThreshold
---@field public direBeastHawk TRB.Classes.SpellThreshold
TRB.Classes.Hunter.BeastMasterySpells = setmetatable({}, {__index = TRB.Classes.Hunter.HunterBaseSpells})
TRB.Classes.Hunter.BeastMasterySpells.__index = TRB.Classes.Hunter.BeastMasterySpells

function TRB.Classes.Hunter.BeastMasterySpells:New()
    ---@type TRB.Classes.Hunter.HunterBaseSpells
    local base = TRB.Classes.Hunter.HunterBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Hunter.BeastMasterySpells) --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

    -- Beast Mastery Spec Baseline Abilities

    -- Beast Mastery Spec Talents
    self.cobraShot = TRB.Classes.SpellThreshold:New({
        id = 193455,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "cobraShot",
        killCommandCooldownReduction = 2,
        isTalent = true
    })
    self.bestialWrath = TRB.Classes.SpellBase:New({
        id = 19574,
        castId = 19574,
        isTalent = true,
        duration = 15
    })

    self.beastCleave = TRB.Classes.SpellBase:New({
        id = 268877,
        talentId = 115939,
        isTalent = true,
        duration = 8
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
    self.wildThrash = TRB.Classes.SpellThreshold:New({
        id = 1264359,
        castId = 1264359,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wildThrash",
        hasCooldown = true,
        isTalent = true,
        cooldown = 8
    })

    -- Dark Ranger
    self.blackArrow = TRB.Classes.SpellThreshold:New({
        id = 466930,
        talentId = 466932,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "blackArrow",
        healthMinimum = 0.2,
        healthMaximum = 0.8,
        hasCooldown = true,
        isTalent = true,
        isSnowflake = true,
        baseline = false
    })
    self.wailingDead = TRB.Classes.SpellBase:New({
        id = 1264290,
        isTalent = true
    })
    self.wailingArrow = TRB.Classes.SpellThreshold:New({
        id = 392060,
        talentId = 1264290, -- Use Wailing Dead's talent ID
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wailingArrow",
        isTalent = true,
        isSnowflake = true,
    })

    -- PvP
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

---Fills barTextVariables for Beast Mastery Hunter options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Hunter.BeastMasterySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Hunter.BeastMasterySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#beastCleave", icon = spells.beastCleave.icon, description = spells.beastCleave.name, printInSettings = true },
		{ variable = "#bestialWrath", icon = spells.bestialWrath.icon, description = spells.bestialWrath.name, printInSettings = true },
		{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = spells.cobraShot.name, printInSettings = true },
		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
	}
	specCacheEntry.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$focus", description = L["HunterBeastMasteryBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterBeastMasteryBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterBeastMasteryBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$beastCleaveTime", description = L["HunterBeastMasteryBarTextVariable_beastCleaveTime"], printInSettings = true, color = false },
		{ variable = "$bestialWrathTime", description = L["HunterBeastMasteryBarTextVariable_bestialWrathTime"], printInSettings = true, color = false }
	}
end


---@class TRB.Classes.Hunter.MarksmanshipSpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public steadyShot TRB.Classes.SpellBase
---@field public rapidFire TRB.Classes.SpellBase
---@field public trueshot TRB.Classes.SpellBase
---@field public cantMissWontMiss TRB.Classes.SpellBase
---@field public arcaneShot TRB.Classes.SpellThreshold
---@field public aimedShot TRB.Classes.SpellThreshold
---@field public multiShot TRB.Classes.SpellThreshold
---@field public blackArrow TRB.Classes.SpellThreshold
---@field public killShot TRB.Classes.SpellThreshold
---@field public wailingArrow TRB.Classes.SpellThreshold
TRB.Classes.Hunter.MarksmanshipSpells = setmetatable({}, {__index = TRB.Classes.Hunter.HunterBaseSpells})
TRB.Classes.Hunter.MarksmanshipSpells.__index = TRB.Classes.Hunter.MarksmanshipSpells

function TRB.Classes.Hunter.MarksmanshipSpells:New()
    ---@type TRB.Classes.Hunter.HunterBaseSpells
    local base = TRB.Classes.Hunter.HunterBaseSpells
    self = setmetatable(base:New(), TRB.Classes.Hunter.MarksmanshipSpells) --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

    -- Hunter Talent Abilities

    -- Marksmanship Spec Baseline Abilities
    self.steadyShot = TRB.Classes.SpellBase:New({
        id = 56641,
        resource = 10,
        baseline = true
    })
    self.arcaneShot = TRB.Classes.SpellThreshold:New({
        id = 185358,
        iconName = "ability_impalingbolt",
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "arcaneShot",
        baseline = true
    })
    self.multiShot = TRB.Classes.SpellThreshold:New({
        id = 257620,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "multiShot",
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
    self.rapidFire = TRB.Classes.SpellBase:New({
        id = 257044,
        resource = 1,
        shots = 7,
        duration = 2, --On cast then every 1/3 sec, hasted
        isTalent = true
    })
    self.trueshot = TRB.Classes.SpellBase:New({
        id = 288613,
        castId = 288613,
        resourcePercent = 1.5,
        isTalent = true,
        duration = 15
    })
    self.killShot = TRB.Classes.SpellThreshold:New({
        id = 53351,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "killShot",
        healthMinimum = 0.2,
        hasCooldown = true,
        isSnowflake = true
    })

    -- Dark Ranger
    self.blackArrow = TRB.Classes.SpellThreshold:New({
        id = 466930,
        talentId = 466932,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "blackArrow",
        healthMinimum = 0.2,
        healthMaximum = 0.8,
        hasCooldown = true,
        isTalent = true,
        isSnowflake = true,
        baseline = false -- When subTreeActive = true
    })
    self.wailingDead = TRB.Classes.SpellBase:New({
        id = 1264290,
        isTalent = true
    })
    self.wailingArrow = TRB.Classes.SpellThreshold:New({
        id = 392060,
        talentId = 1264290, -- Use Wailing Dead's talent ID
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wailingArrow",
        isTalent = true,
        isSnowflake = true,
    })

    -- Sentinel
    self.cantMissWontMiss = TRB.Classes.SpellThreshold:New({
        id = 1253830,
        isTalent = true,
        duration = 4
    })

    return self
end

---Fills barTextVariables for Marksmanship Hunter options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Hunter.MarksmanshipSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Hunter.MarksmanshipSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#aimedShot", icon = spells.aimedShot.icon, description = spells.aimedShot.name, printInSettings = true },
		{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = spells.arcaneShot.name, printInSettings = true },
		{ variable = "#killShot", icon = spells.killShot.icon, description = spells.killShot.name, printInSettings = true },
		{ variable = "#multiShot", icon = spells.multiShot.icon, description = spells.multiShot.name, printInSettings = true },
		{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = spells.rapidFire.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = spells.steadyShot.name, printInSettings = true },
		{ variable = "#trueshot", icon = spells.trueshot.icon, description = spells.trueshot.name, printInSettings = true }
	}
	specCacheEntry.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$focus", description = L["HunterMarksmanshipBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterMarksmanshipBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterMarksmanshipBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$trueshotTime", description = L["HunterMarksmanshipBarTextVariable_trueshotTime"], printInSettings = true, color = false },
	}
end


---@class TRB.Classes.Hunter.SurvivalSpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public killCommand TRB.Classes.SpellBase
---@field public wildfireBomb TRB.Classes.SpellBase
---@field public takedown TRB.Classes.SpellBase
---@field public cantMissWontMiss TRB.Classes.SpellBase
---@field public boomstick TRB.Classes.SpellThreshold
---@field public hatchetToss TRB.Classes.SpellThreshold
---@field public raptorStrike TRB.Classes.SpellThreshold
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

    -- Survival Spec Talents
    self.boomstick = TRB.Classes.SpellThreshold:New({
        id = 1261193,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "boomstick",
        isTalent = true,
        hasCooldown = true,
        cooldown = 45,
        rangeCheck = false
    })
    -- TODO: Implement Boomstick cooldown to also incorporate Lethal Calibration
    self.hatchetToss = TRB.Classes.SpellThreshold:New({
        id = 193265,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "hatchetToss",
        baseline = true
    })
    self.raptorStrike = TRB.Classes.SpellThreshold:New({
        id = 186270,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "raptorStrike",
        isTalent = true
    })
    self.wildfireBomb = TRB.Classes.SpellThreshold:New({
        id = 259495,
        isTalent = true,
        hasCharges = true,
        hasCooldown = true
    })
    self.takedown = TRB.Classes.SpellBase:New({
        id = 1250646,
        isTalent = true,
        duration = 8,
    })

    -- Sentinel
    self.cantMissWontMiss = TRB.Classes.SpellThreshold:New({
        id = 1253830,
        isTalent = true,
        duration = 2
    })

    return self
end

---Fills barTextVariables for Survival Hunter options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Hunter.SurvivalSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Hunter.SurvivalSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = spells.raptorStrike.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#takedown", icon = spells.takedown.icon, description = spells.takedown.name, printInSettings = true },
		{ variable = "#wildfireBomb", icon = spells.wildfireBomb.icon, description = spells.wildfireBomb.name, printInSettings = true },
		{ variable = "#wingClip", icon = spells.wingClip.icon, description = spells.wingClip.name, printInSettings = true },
	}
	specCacheEntry.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$focus", description = L["HunterSurvivalBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterSurvivalBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterSurvivalBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$takedownTime", description = L["HunterSurvivalBarTextVariable_takedownTime"], printInSettings = true, color = false },
	}
end


--[[
    BarGroups Factory for Hunter
    Creates the appropriate BarGroup instances for each Hunter specialization.
    
    Beast Mastery: Primary bar (N=1) only
    Marksmanship: Primary bar (N=1) only
    Survival: Primary bar (N=1) only
    
    Note: Hunters do not have a secondary resource display (no combo points, runes, etc.)
]]

---@class TRB.Classes.Hunter.BarGroupsFactory
TRB.Classes.Hunter.BarGroupsFactory = {}
TRB.Classes.Hunter.BarGroupsFactory.__index = TRB.Classes.Hunter.BarGroupsFactory

---Creates BarGroup instances for the specified Hunter specialization
---@param specId integer # 1=Beast Mastery, 2=Marksmanship, 3=Survival
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- All Hunter specs only have a primary Focus bar (1 node), no secondary resource
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

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Hunter.BarGroupsFactory:GetSpecConfiguration(specId)
    -- All Hunter specs have the same configuration: primary bar and health bar
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

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["hunter_beastMastery"] = TRB.Classes.Hunter.BeastMasterySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["hunter_marksmanship"] = TRB.Classes.Hunter.MarksmanshipSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["hunter_survival"] = TRB.Classes.Hunter.SurvivalSpells.FillBarTextVariables