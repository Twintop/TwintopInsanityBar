local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.DeathKnight = TRB.Classes.DeathKnight or {}

---@class TRB.Classes.DeathKnight.DeathKnightBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field deathCoil TRB.Classes.SpellThreshold
---@field deathStrike TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.DeathKnightBaseSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DeathKnight.DeathKnightBaseSpells.__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells

function TRB.Classes.DeathKnight.DeathKnightBaseSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    self = setmetatable(TRB.Classes.SpecializationSpellsBase:New(), TRB.Classes.DeathKnight.DeathKnightBaseSpells) --[[@as TRB.Classes.DeathKnight.DeathKnightBaseSpells]]

    -- Baseline
    self.deathCoil = TRB.Classes.SpellThreshold:New({
        id = 47541,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "deathCoil",
        isTalent = false,
        baseline = true
    })

    -- Class Talents
    self.deathStrike = TRB.Classes.SpellThreshold:New({
        id = 49998,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "deathStrike",
        isTalent = true
    })

    return self
end

---@class TRB.Classes.DeathKnight.BloodSpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field raiseAlly TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.BloodSpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.BloodSpells.__index = TRB.Classes.DeathKnight.BloodSpells

function TRB.Classes.DeathKnight.BloodSpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.BloodSpells) --[[@as TRB.Classes.DeathKnight.BloodSpells]]
    -- Death Knight Class Baseline Abilities
    self.raiseAlly = TRB.Classes.SpellThreshold:New({
        id = 61999,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "raiseAlly",
        isTalent = false,
        baseline = true
    })

    -- Blood Baseline Abilities

    -- Death Knight Class Talents
    
    -- Blood Spec Talents

    self.deathStrike.baseline = true
    return self
end

---Fills barTextVariables for Blood Death Knight options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DeathKnight.BloodSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DeathKnight.BloodSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
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

		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false },
	}
end


---@class TRB.Classes.DeathKnight.FrostSpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field breathOfSindragosa TRB.Classes.SpellThreshold
---@field frostStrike TRB.Classes.SpellThreshold
---@field glacialAdvance TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.FrostSpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.FrostSpells.__index = TRB.Classes.DeathKnight.FrostSpells

function TRB.Classes.DeathKnight.FrostSpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.FrostSpells) --[[@as TRB.Classes.DeathKnight.FrostSpells]]

    self.breathOfSindragosa = TRB.Classes.SpellThreshold:New({
        id = 1249658,
        castId = 1249658,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "breathOfSindragosa",
        isTalent = true,
        rangeCheck = false,
        hasCooldown = true,
        cooldown = 90
    })
    self.frostStrike = TRB.Classes.SpellThreshold:New({
        id = 49143,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "frostStrike",
        isTalent = true
    })
    self.glacialAdvance = TRB.Classes.SpellThreshold:New({
        id = 194913,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "glacialAdvance",
        baseline = true
    })

    return self
end

---Fills barTextVariables for Frost Death Knight options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DeathKnight.FrostSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DeathKnight.FrostSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
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

		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false },
	}
end


---@class TRB.Classes.DeathKnight.UnholySpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field raiseAlly TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.UnholySpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.UnholySpells.__index = TRB.Classes.DeathKnight.UnholySpells

function TRB.Classes.DeathKnight.UnholySpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.UnholySpells) --[[@as TRB.Classes.DeathKnight.UnholySpells]]
    
    self.raiseAlly = TRB.Classes.SpellThreshold:New({
        id = 61999,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "raiseAlly",
        isTalent = false,
        baseline = true
    })

    return self
end

---Fills barTextVariables for Unholy Death Knight options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DeathKnight.UnholySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DeathKnight.UnholySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
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

		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false },
	}
end


--[[
    BarGroups Factory for Death Knight
    Creates the appropriate BarGroup instances for each Death Knight specialization.
    
    All specs: Primary bar (N=1) for Runic Power + Runes (N=6)
]]

---@class TRB.Classes.DeathKnight.BarGroupsFactory
TRB.Classes.DeathKnight.BarGroupsFactory = {}
TRB.Classes.DeathKnight.BarGroupsFactory.__index = TRB.Classes.DeathKnight.BarGroupsFactory

---Creates BarGroup instances for the specified Death Knight specialization
---@param specId integer # 1=Blood, 2=Frost, 3=Unholy
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- All Death Knight specs have the same bar structure:
    -- Primary Runic Power bar (1 node) + Runes (6 nodes)

    -- Primary Runic Power bar (1 node)
    -- Primary bar groups are parented directly to UIParent for proper positioning
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Runes (6 nodes for all specs)
    -- Secondary bars are parented to UIParent for independent visibility
    barGroups.secondary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_ComboPoint",
        6,
        false -- not primary
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
function TRB.Classes.DeathKnight.BarGroupsFactory:GetSpecConfiguration(specId)
    -- All Death Knight specs have the same configuration
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true
        },
        secondary = {
            maxNodes = 6,
            isPrimary = false,
            resourceType = "Runes"
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
TRB.Data.barTextVariablesRegistry["deathknight_blood"] = TRB.Classes.DeathKnight.BloodSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["deathknight_frost"] = TRB.Classes.DeathKnight.FrostSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["deathknight_unholy"] = TRB.Classes.DeathKnight.UnholySpells.FillBarTextVariables