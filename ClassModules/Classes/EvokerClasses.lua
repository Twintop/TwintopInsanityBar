---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Evoker = TRB.Classes.Evoker or {}


---@class TRB.Classes.Evoker.DevastationSpells : TRB.Classes.SpecializationSpellsBase
---@field public dragonrage TRB.Classes.SpellBase
---@field public animosity TRB.Classes.SpellBase
---@field public fireBreath TRB.Classes.SpellBase
---@field public eternitySurge TRB.Classes.SpellBase
TRB.Classes.Evoker.DevastationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.DevastationSpells.__index = TRB.Classes.Evoker.DevastationSpells

function TRB.Classes.Evoker.DevastationSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Evoker.DevastationSpells) --[[@as TRB.Classes.Evoker.DevastationSpells]]
    
    self.essenceBurst = TRB.Classes.SpellBase:New({
        id = 359618
    })
	
    -- Devastation Spec Talents
	self.dragonrage = TRB.Classes.SpellBase:New({
		id = 375087,
		isTalent = true,
		isBuff = true,
		hasCooldown = true,
		cooldown = 120,
		duration = 18
	})
	self.animosity = TRB.Classes.SpellBase:New({
		id = 375797,
		isTalent = true,
		durationMod = 5,
		durationPerCastMod = 0.75
	})
	self.fireBreath = TRB.Classes.SpellBase:New({
		id = 382266,
		baseline = true
	})
	self.eternitySurge = TRB.Classes.SpellBase:New({
		id = 382411,
		talentId = 359073,
		isTalent = true
	})

	return self
end

---Fills barTextVariables for Devastation Evoker options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Evoker.DevastationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Evoker.DevastationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		{ variable = "#dragonrage", icon = spells.dragonrage.icon, description = spells.dragonrage.name, printInSettings = true },
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

		{ variable = "$mana", description = L["EvokerDevastationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerDevastationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerDevastationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$essence", description = L["EvokerDevastationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerDevastationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerDevastationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },

		{ variable = "$dragonrageTime", description = L["EvokerDevastationBarTextVariable_dragonrageTime"], printInSettings = true, color = false },
	}
end


---@class TRB.Classes.Evoker.PreservationSpells : TRB.Classes.Healer.HealerSpells
TRB.Classes.Evoker.PreservationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Evoker.PreservationSpells.__index = TRB.Classes.Evoker.PreservationSpells

function TRB.Classes.Evoker.PreservationSpells:New()
	---@type TRB.Classes.Healer.HealerSpells
	local base = TRB.Classes.Healer.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Evoker.PreservationSpells) --[[@as TRB.Classes.Evoker.PreservationSpells]]
    
    self.essenceBurst = TRB.Classes.SpellBase:New({
        id = 369299
    })
	
    --[[self.eruption = TRB.Classes.SpellBase:New({
        id = 395160,
        isTalent = true,
        primaryResourceType = Enum.PowerType.Essence,
        settingKey = "eruption",
    })]]

    -- Evoker Class Talents		
	
	-- Preservation Spec Talents
    
	-- Chronowarden

	return self
end

---Fills barTextVariables for Preservation Evoker options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Evoker.PreservationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Evoker.PreservationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

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

		{ variable = "$mana", description = L["EvokerPreservationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerPreservationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerPreservationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["EvokerPreservationBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$essence", description = L["EvokerPreservationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerPreservationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerPreservationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end


---@class TRB.Classes.Evoker.AugmentationSpells : TRB.Classes.SpecializationSpellsBase
---@field public ebonMight TRB.Classes.SpellBase
---@field public eruption TRB.Classes.SpellBase
---@field public emeraldBlossom TRB.Classes.SpellBase
---@field public dreamOfSpring TRB.Classes.SpellBase
TRB.Classes.Evoker.AugmentationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.AugmentationSpells.__index = TRB.Classes.Evoker.AugmentationSpells

function TRB.Classes.Evoker.AugmentationSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Evoker.AugmentationSpells) --[[@as TRB.Classes.Evoker.AugmentationSpells]]

    self.essenceBurst = TRB.Classes.SpellBase:New({
        id = 392268
    })

    self.ebonMight = TRB.Classes.SpellBase:New({
        id = 395296,
        talentId = 395152,
        isBuff = true,
        isTalent = true
    })
	self.eruption = TRB.Classes.SpellBase:New({
        id = 395160,
        isTalent = true
    })

    self.emeraldBlossom = TRB.Classes.SpellBase:New({
        id = 355913,
        baseline = true,
    })
    self.dreamOfSpring = TRB.Classes.SpellBase:New({
        id = 414969,
        isTalent = true
    })
	-- Chronowarden
	return self
end

---Fills barTextVariables for Augmentation Evoker options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Evoker.AugmentationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Evoker.AugmentationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	specCacheEntry.barTextVariables.icons = {
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#ebonMight", icon = spells.ebonMight.icon, description = spells.ebonMight.name, printInSettings = true },
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

		{ variable = "$mana", description = L["EvokerAugmentationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerAugmentationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerAugmentationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$essence", description = L["EvokerAugmentationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerAugmentationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerAugmentationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },

		{ variable = "$ebonMightTime", description = L["EvokerAugmentationBarTextVariable_ebonMightTime"], printInSettings = true, color = false },
	}
end


--[[
    BarGroups Factory for Evoker
    Creates the appropriate BarGroup instances for each Evoker specialization.
    
    All specs use Mana as primary resource and Essence as secondary resource.
    Devastation: Primary bar (N=1) + Essence (N=5-6)
    Preservation: Primary bar (N=1) + Essence (N=5-6)
    Augmentation: Primary bar (N=1) + Essence (N=5-6)
]]

---@class TRB.Classes.Evoker.BarGroupsFactory
TRB.Classes.Evoker.BarGroupsFactory = {}
TRB.Classes.Evoker.BarGroupsFactory.__index = TRB.Classes.Evoker.BarGroupsFactory

---Creates BarGroup instances for the specified Evoker specialization
---@param specId integer # 1=Devastation, 2=Preservation, 3=Augmentation
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(specId)
    local barGroups = {}

    -- All Evoker specs have the same bar structure:
    -- Primary Mana bar (1 node) + Essence (up to 6 nodes) + Health (1 node)

    -- Primary Mana bar (1 node)
    -- Primary bar groups are parented directly to UIParent for proper positioning
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Essence (up to 6 nodes for all specs)
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
function TRB.Classes.Evoker.BarGroupsFactory:GetSpecConfiguration(specId)
    -- All Evoker specs have the same configuration
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true
        },
        secondary = {
            maxNodes = 6,
            isPrimary = false,
            resourceType = "Essence"
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
TRB.Data.barTextVariablesRegistry["evoker_devastation"] = TRB.Classes.Evoker.DevastationSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["evoker_preservation"] = TRB.Classes.Evoker.PreservationSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["evoker_augmentation"] = TRB.Classes.Evoker.AugmentationSpells.FillBarTextVariables