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
		rangeCheck = false,
        category = "utility"
    })
    self.wingClip = TRB.Classes.SpellThreshold:New({
        id = 195645,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wingClip",
        baseline = true,
        category = "utility"
    })
    self.scareBeast = TRB.Classes.SpellThreshold:New({
        id = 1513,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "scareBeast",
        isTalent = true,
        category = "utility"
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
        isTalent = true,
        category = "offensive"
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
        duration = 10
    })
    self.killCommand = TRB.Classes.SpellThreshold:New({
        id = 34026,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "killCommand",
        hasCooldown = true,
        isTalent = true,
        baseline = false,
        isSnowflake = true,
        category = "offensive"
    })
    self.wildThrash = TRB.Classes.SpellThreshold:New({
        id = 1264359,
        castId = 1264359,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "wildThrash",
        hasCooldown = true,
        isTalent = true,
        cooldown = 8,
        category = "offensive"
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
        baseline = false,
        category = "offensive"
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
        category = "offensive"
    })

    -- PvP
    self.direBeastHawk = TRB.Classes.SpellThreshold:New({
        id = 208652,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "direBeastHawk",
        hasCooldown = true,
        cooldown = 30,
        isPvp = true,
        category = "offensive"
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

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#beastCleave", icon = spells.beastCleave.icon, description = spells.beastCleave.name, printInSettings = true },
		{ variable = "#bestialWrath", icon = spells.bestialWrath.icon, description = spells.bestialWrath.name, printInSettings = true },
		{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = spells.cobraShot.name, printInSettings = true },
		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$focus", description = L["HunterBeastMasteryBarTextVariable_focus"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$focusMax", description = L["HunterBeastMasteryBarTextVariable_focusMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["HunterBeastMasteryBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$beastCleaveTime", description = L["HunterBeastMasteryBarTextVariable_beastCleaveTime"], printInSettings = true, color = false },
		{ variable = "$bestialWrathTime", description = L["HunterBeastMasteryBarTextVariable_bestialWrathTime"], printInSettings = true, color = false },

		-- Feign Death bar timer. Hunter-only, so it is declared here rather than in the shared pool.
		{ variable = "$feignDeathDuration", description = L["BarTextVariableFeignDeathDuration"], printInSettings = true, color = false, category = varCategory.OTHER, booleanCheck = true },
		{ variable = "$feignDeathDurationRemaining", description = L["BarTextVariableFeignDeathDurationRemaining"], printInSettings = true, color = false, category = varCategory.OTHER, booleanCheck = true }
	})
end

---Gets built-in castbar channel tick profiles for Beast Mastery, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Hunter.BeastMasterySpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Hunter.MarksmanshipSpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public steadyShot TRB.Classes.SpellBase
---@field public rapidFire TRB.Classes.SpellBase
---@field public quickDraw TRB.Classes.SpellBase
---@field public doubleTap TRB.Classes.SpellBase
---@field public volley TRB.Classes.SpellBase
---@field public trueshot TRB.Classes.SpellBase
---@field public cantMissWontMiss TRB.Classes.SpellBase
---@field public invigoratingPulse TRB.Classes.SpellBase
---@field public arcaneShot TRB.Classes.SpellThreshold
---@field public aimedShot TRB.Classes.SpellThreshold
---@field public multiShot TRB.Classes.SpellThreshold
---@field public blackArrow TRB.Classes.SpellThreshold
---@field public killShot TRB.Classes.SpellThreshold
---@field public wailingArrow TRB.Classes.SpellThreshold
---@field public explosiveShot TRB.Classes.SpellThreshold
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
        resource = 20,
        baseline = true
    })
    self.arcaneShot = TRB.Classes.SpellThreshold:New({
        id = 185358,
        iconName = "ability_impalingbolt",
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "arcaneShot",
        baseline = true,
        category = "offensive"
    })
    self.multiShot = TRB.Classes.SpellThreshold:New({
        id = 257620,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "multiShot",
        baseline = true,
        category = "offensive"
    })

    -- Marksmanship Spec Talents
    self.aimedShot = TRB.Classes.SpellThreshold:New({
        id = 19434,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "aimedShot",
        hasCooldown = true,
        isSnowflake = true,
        isTalent = true,
        hasCharges = true,
        category = "offensive"
    })
    self.rapidFire = TRB.Classes.SpellBase:New({
        id = 257044,
        resource = 1,
        shots = 7,
        duration = 2, --On cast then every 1/3 sec, hasted
        isTalent = true
    })
    -- Quick Draw: Rapid Fire fires 3 more shots over the same channel
    self.quickDraw = TRB.Classes.SpellBase:New({
        id = 459794,
        bonusShots = 3,
        isTalent = true
    })
    -- Double Tap: Trueshot and Volley buff the next Rapid Fire to fire 80% more shots
    self.doubleTap = TRB.Classes.SpellBase:New({
        id = 260402,
        talentId = 473370,
        shotsMultiplier = 1.8,
        duration = 15,
        isTalent = true
    })
    -- Volley: applies Double Tap, alongside Trueshot
    self.volley = TRB.Classes.SpellBase:New({
        id = 260243,
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
        isSnowflake = true,
        category = "execute"
    })
    self.explosiveShot = TRB.Classes.SpellThreshold:New({
        id = 212431,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "explosiveShot",
        hasCooldown = true,
        cooldown = 30,
        isTalent = true,
        category = "offensive"
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
        baseline = false, -- When subTreeActive = true
        category = "offensive"
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
        category = "offensive"
    })

    -- Sentinel
    self.cantMissWontMiss = TRB.Classes.SpellThreshold:New({
        id = 1253830,
        isTalent = true,
        duration = 2
    })
    self.invigoratingPulse = TRB.Classes.SpellBase:New({
        id = 450379,
        isTalent = true,
        resourceMod = 5
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

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#aimedShot", icon = spells.aimedShot.icon, description = spells.aimedShot.name, printInSettings = true },
		{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = spells.arcaneShot.name, printInSettings = true },
		{ variable = "#doubleTap", icon = spells.doubleTap.icon, description = spells.doubleTap.name, printInSettings = true },
		{ variable = "#explosiveShot", icon = spells.explosiveShot.icon, description = spells.explosiveShot.name, printInSettings = true },
		{ variable = "#killShot", icon = spells.killShot.icon, description = spells.killShot.name, printInSettings = true },
		{ variable = "#multiShot", icon = spells.multiShot.icon, description = spells.multiShot.name, printInSettings = true },
		{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = spells.rapidFire.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = spells.steadyShot.name, printInSettings = true },
		{ variable = "#trueshot", icon = spells.trueshot.icon, description = spells.trueshot.name, printInSettings = true }
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$focus", description = L["HunterMarksmanshipBarTextVariable_focus"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$focusMax", description = L["HunterMarksmanshipBarTextVariable_focusMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["HunterMarksmanshipBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$trueshotTime", description = L["HunterMarksmanshipBarTextVariable_trueshotTime"], printInSettings = true, color = false },
		{ variable = "$doubleTapTime", description = L["HunterMarksmanshipBarTextVariable_doubleTapTime"], printInSettings = true, color = false },

		-- Feign Death bar timer. Hunter-only, so it is declared here rather than in the shared pool.
		{ variable = "$feignDeathDuration", description = L["BarTextVariableFeignDeathDuration"], printInSettings = true, color = false, category = varCategory.OTHER, booleanCheck = true },
		{ variable = "$feignDeathDurationRemaining", description = L["BarTextVariableFeignDeathDurationRemaining"], printInSettings = true, color = false, category = varCategory.OTHER, booleanCheck = true }
	})
end

---Gets built-in castbar channel tick profiles for Marksmanship, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Hunter.MarksmanshipSpells.GetCastbarTickProfiles()
	return {
		-- Rapid Fire: 7 shots baseline over 2s, one on cast then every 1/3s; Quick Draw and Double Tap
		-- shots come from tick modifiers.
		[257044] = { mode = "fixedCount", baseDuration = 2, tickCount = 7, firstTickAtStart = true },
    }
end

---Gets built-in castbar tick modifiers for Marksmanship (talent/buff-conditional bonus ticks), keyed by
---channel spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.CastbarTickModifier[]>
function TRB.Classes.Hunter.MarksmanshipSpells.GetCastbarTickModifiers()
	return {
		-- Rapid Fire
		[257044] = {
			-- Quick Draw: +3 shots while talented, over the same channel
			{ talentId = 459794, bonusTicks = 3 },
			-- Double Tap: Trueshot/Volley buff this Rapid Fire into 80% more shots
			{ talentId = 473370, buffId = 260402, tickMultiplier = 1.8 },
		},
	}
end


---@class TRB.Classes.Hunter.SurvivalSpells : TRB.Classes.Hunter.HunterBaseSpells
---@field public killCommand TRB.Classes.SpellBase
---@field public wildfireBomb TRB.Classes.SpellBase
---@field public takedown TRB.Classes.SpellBase
---@field public tipOfTheSpear TRB.Classes.SpellBase
---@field public cantMissWontMiss TRB.Classes.SpellBase
---@field public boomstick TRB.Classes.SpellThreshold
---@field public hatchetToss TRB.Classes.SpellThreshold
---@field public raptorStrike TRB.Classes.SpellThreshold
---@field public raptorSwipe TRB.Classes.SpellThreshold
---@field public raptorSwipeTalent1 TRB.Classes.SpellBase
---@field public raptorSwipeTalent2 TRB.Classes.SpellBase
---@field public raptorSwipeTalent3 TRB.Classes.SpellBase
---@field public flamefangPitch TRB.Classes.SpellThreshold
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
        rangeCheck = false,
        category = "offensive"
    })
    -- TODO: Implement Boomstick cooldown to also incorporate Lethal Calibration
    self.hatchetToss = TRB.Classes.SpellThreshold:New({
        id = 193265,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "hatchetToss",
        baseline = true,
        category = "offensive"
    })
    self.raptorStrike = TRB.Classes.SpellThreshold:New({
        id = 186270,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "raptorStrike",
        isTalent = true,
        category = "offensive",
        isSnowflake = true
    })
    self.raptorSwipe = TRB.Classes.SpellThreshold:New({
        id = 1262293,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "raptorSwipe",
        category = "offensive",
        isSnowflake = true,
        rangeCheck = false
    })
    self.raptorSwipeTalent1 = TRB.Classes.SpellBase:New({
        talentId = 1259003,
    })
    self.raptorSwipeTalent2 = TRB.Classes.SpellBase:New({
        talentId = 1259017,
    })
    self.raptorSwipeTalent3 = TRB.Classes.SpellBase:New({
        talentId = 1259019,
    })
    self.flamefangPitch = TRB.Classes.SpellThreshold:New({
        id = 1251592,
        primaryResourceType = Enum.PowerType.Focus,
        settingKey = "flamefangPitch",
        isTalent = true,
        category = "offensive",
        rangeCheck = false,
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
    self.tipOfTheSpear = TRB.Classes.SpellBase:New({
        id = 260286,
        talentId = 260285,
        isTalent = true,
        maxStacks = 3,
        duration = 10
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

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = spells.raptorStrike.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#takedown", icon = spells.takedown.icon, description = spells.takedown.name, printInSettings = true },
		{ variable = "#tipOfTheSpear", icon = spells.tipOfTheSpear.icon, description = spells.tipOfTheSpear.name, printInSettings = true },
		{ variable = "#wildfireBomb", icon = spells.wildfireBomb.icon, description = spells.wildfireBomb.name, printInSettings = true },
		{ variable = "#wingClip", icon = spells.wingClip.icon, description = spells.wingClip.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$focus", description = L["HunterSurvivalBarTextVariable_focus"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$focusMax", description = L["HunterSurvivalBarTextVariable_focusMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["HunterSurvivalBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$tipOfTheSpear", description = L["HunterSurvivalBarTextVariable_tipOfTheSpear"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$tipOfTheSpearMax", description = L["HunterSurvivalBarTextVariable_tipOfTheSpearMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$totsTime", description = L["HunterSurvivalBarTextVariable_totsTime"], printInSettings = true, color = false },
		{ variable = "$takedownTime", description = L["HunterSurvivalBarTextVariable_takedownTime"], printInSettings = true, color = false },

		-- Feign Death bar timer. Hunter-only, so it is declared here rather than in the shared pool.
		{ variable = "$feignDeathDuration", description = L["BarTextVariableFeignDeathDuration"], printInSettings = true, color = false, category = varCategory.OTHER, booleanCheck = true },
		{ variable = "$feignDeathDurationRemaining", description = L["BarTextVariableFeignDeathDurationRemaining"], printInSettings = true, color = false, category = varCategory.OTHER, booleanCheck = true }
	})
end

---Gets built-in castbar channel tick profiles for Survival, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Hunter.SurvivalSpells.GetCastbarTickProfiles()
	return {
		-- Boomstick: constant tick count, duration shrinks with haste.
		[1261193] = { mode = "fixedCount", baseDuration = 3.0, tickCount = 4, firstTickAtStart = true },
        -- Mending Bandage
		[212640] = { mode = "fixedCount", baseDuration = 6.0, tickCount = 6 },
	}
end


--[[
    BarGroups Factory for Hunter
    Creates the appropriate BarGroup instances for each Hunter specialization.
    
    Beast Mastery: Primary bar (N=1) only
    Marksmanship: Primary bar (N=1) only
    Survival: Primary bar (N=1) + Secondary bar (N=3, Tip of the Spear stacks)
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

    -- Primary Focus bar (1 node)
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Survival has a secondary resource bar (Tip of the Spear stacks, 3 nodes)
    if specId == 3 then
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            3,
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

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Hunter.BarGroupsFactory:GetSpecConfiguration(specId)
    local config = {
        primary = {
            maxNodes = 1,
            isPrimary = true,
            resourceType = "Focus"
        },
        health = {
            maxNodes = 1,
            isPrimary = false,
            resourceType = "Health"
        }
    }

    if specId == 3 then -- Survival: Tip of the Spear stacks
        config.secondary = {
            maxNodes = 3,
            isPrimary = false,
            resourceType = "TipOfTheSpear"
        }
    end

    return config
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["hunter_beastMastery"] = TRB.Classes.Hunter.BeastMasterySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["hunter_marksmanship"] = TRB.Classes.Hunter.MarksmanshipSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["hunter_survival"] = TRB.Classes.Hunter.SurvivalSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["hunter_survival"] = TRB.Classes.Hunter.SurvivalSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["hunter_beastMastery"] = TRB.Classes.Hunter.BeastMasterySpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["hunter_marksmanship"] = TRB.Classes.Hunter.MarksmanshipSpells.GetCastbarTickProfiles

-- Register built-in castbar tick modifiers (talent/buff-conditional bonus ticks)
TRB.Data.castbarTickModifiersRegistry = TRB.Data.castbarTickModifiersRegistry or {}
TRB.Data.castbarTickModifiersRegistry["hunter_marksmanship"] = TRB.Classes.Hunter.MarksmanshipSpells.GetCastbarTickModifiers

-- Register audio cue vocabularies
do
	local L = TRB.Localization

	TRB.Functions.AudioCues:Register("hunter_survival", {
		counters = {
			{
				id = "tipOfTheSpear",
				label = L["HunterSurvivalAudioCueSourceTots"],
				description = L["HunterSurvivalAudioCueSourceTotsDescription"],
				sliderLabel = L["HunterSurvivalTotsThresholdSliderTitle"],
				defaultName = L["HunterSurvivalAudioCueTotsDefaultName"],
				min = 0,
				max = 3,
				step = 1,
				decimals = 0,
				compare = "atLeast",
				requiresCombat = true,
				legacyIds = { "totsThreshold1" },
				defaultCues = {
					{
						id = "totsThreshold1",
						name = L["HunterSurvivalAudioTotsThreshold1"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 3,
					},
				},
			},
		},
	})
end
