local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Warlock = TRB.Classes.Warlock or {}

---@class TRB.Classes.Warlock.AfflictionSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Warlock.AfflictionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.AfflictionSpells.__index = TRB.Classes.Warlock.AfflictionSpells

function TRB.Classes.Warlock.AfflictionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.AfflictionSpells) --[[@as TRB.Classes.Warlock.AfflictionSpells]]

    -- Warlock Class Baseline Abilities

    -- Affliction Baseline Abilities 
    

    -- Warlock Talent Abilities


    -- Affliction Talent Abilities

    -- Hellcaller

    -- Soul Harvester

    return self
end

---Fills barTextVariables for Affliction Warlock options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warlock.AfflictionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warlock.AfflictionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

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

		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["WarlockAfflictionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockAfflictionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockAfflictionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["WarlockAfflictionBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$soulShards", description = L["WarlockAfflictionBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockAfflictionBarTextVariable_soulShardsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

---@class TRB.Classes.Warlock.DemonologySpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Warlock.DemonologySpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.DemonologySpells.__index = TRB.Classes.Warlock.DemonologySpells

function TRB.Classes.Warlock.DemonologySpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.DemonologySpells) --[[@as TRB.Classes.Warlock.DemonologySpells]]


    return self
end

---Fills barTextVariables for Demonology Warlock options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warlock.DemonologySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warlock.DemonologySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

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

		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["WarlockDemonologyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockDemonologyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockDemonologyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["WarlockDemonologyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$soulShards", description = L["WarlockDemonologyBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockDemonologyBarTextVariable_soulShardsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end


---@class TRB.Classes.Warlock.DestructionSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Warlock.DestructionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.DestructionSpells.__index = TRB.Classes.Warlock.DestructionSpells

function TRB.Classes.Warlock.DestructionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.DestructionSpells) --[[@as TRB.Classes.Warlock.DestructionSpells]]


    return self
end

---Fills barTextVariables for Destruction Warlock options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warlock.DestructionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warlock.DestructionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

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

		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },
		
		{ variable = "$mana", description = L["WarlockDestructionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$manaPercent", description = L["WarlockDestructionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["WarlockDestructionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$casting", description = L["WarlockDestructionBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$soulShards", description = L["WarlockDestructionBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockDestructionBarTextVariable_soulShardsMax"], printInSettings = true, color = false },

		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
	}
end


--[[
    BarGroups Factory for Warlock
    Creates the appropriate BarGroup instances for each Warlock specialization.
    
    All specs use Soul Shards as secondary resource:
    Affliction: Primary bar (N=1) + Soul Shards (N=5) - binary fill
    Demonology: Primary bar (N=1) + Soul Shards (N=5) - binary fill
    Destruction: Primary bar (N=1) + Soul Shards (N=5) - percentage fill (partial shards)
]]

---@class TRB.Classes.Warlock.BarGroupsFactory
TRB.Classes.Warlock.BarGroupsFactory = {}
TRB.Classes.Warlock.BarGroupsFactory.__index = TRB.Classes.Warlock.BarGroupsFactory

---Creates BarGroup instances for the specified Warlock specialization
---@param specId integer # 1=Affliction, 2=Demonology, 3=Destruction
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary mana bar (1 node)
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Soul Shards (5 nodes) - all specs use secondary resource
    -- Secondary bars are parented to UIParent for independent visibility
    barGroups.secondary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_ComboPoint",
        5,
        false -- not primary
    )

    -- Health bar
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
function TRB.Classes.Warlock.BarGroupsFactory:GetSpecConfiguration(specId)
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true
        },
        secondary = {
            maxNodes = 5,
            isPrimary = false,
            resourceType = "SoulShards"
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
TRB.Data.barTextVariablesRegistry["warlock_affliction"] = TRB.Classes.Warlock.AfflictionSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["warlock_demonology"] = TRB.Classes.Warlock.DemonologySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["warlock_destruction"] = TRB.Classes.Warlock.DestructionSpells.FillBarTextVariables