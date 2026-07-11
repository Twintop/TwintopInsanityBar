local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Paladin = TRB.Classes.Paladin or {}


---@class TRB.Classes.Paladin.HolySpells : TRB.Classes.Healer.HealerSpells
---@field flashOfLight TRB.Classes.SpellBase
---@field divinePurpose TRB.Classes.SpellBase
---@field holyLight TRB.Classes.SpellBase
TRB.Classes.Paladin.HolySpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Paladin.HolySpells.__index = TRB.Classes.Paladin.HolySpells

function TRB.Classes.Paladin.HolySpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Paladin.HolySpells) --[[@as TRB.Classes.Paladin.HolySpells]]

    self.flashOfLight = TRB.Classes.SpellBase:New({
        id = 19750,
        baseline = true,
		resource = 1
    })

    self.divinePurpose = TRB.Classes.SpellBase:New({
        id = 223819,
        isBuff = true
    })

	self.holyLight = TRB.Classes.SpellBase:New({
		id = 82326,
		resource = 1
	})

    return self
end

---Fills barTextVariables for Holy Paladin options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Paladin.HolySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Paladin.HolySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#flashOfLight", icon = spells.flashOfLight.icon, description = spells.flashOfLight.name, printInSettings = true },
		{ variable = "#holyLight", icon = spells.holyLight.icon, description = spells.holyLight.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$castingHolyPower", description = L["PaladinHolyBarTextVariable_castingHolyPower"], printInSettings = true, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerPlusCasting", description = L["PaladinHolyBarTextVariable_holyPowerPlusCasting"], printInSettings = true, color = false },
		{ variable = "$comboPointsPlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$divinePurposeActive", description = L["PaladinBarTextVariable_divinePurposeActive"], printInSettings = false, color = false },
		{ variable = "$divinePurposeStacks", description = L["PaladinBarTextVariable_divinePurposeStacks"], printInSettings = false, color = false },
		{ variable = "$divinePurposeTime", description = L["PaladinBarTextVariable_divinePurposeTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Holy, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Paladin.HolySpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Paladin.ProtectionSpells : TRB.Classes.SpecializationSpellsBase
---@field flashOfLight TRB.Classes.SpellBase
---@field divinePurpose TRB.Classes.SpellBase
TRB.Classes.Paladin.ProtectionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Paladin.ProtectionSpells.__index = TRB.Classes.Paladin.ProtectionSpells

function TRB.Classes.Paladin.ProtectionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Paladin.ProtectionSpells) --[[@as TRB.Classes.Paladin.ProtectionSpells]]

	self.flashOfLight = TRB.Classes.SpellBase:New({
		id = 19750,
		baseline = true
	})

	self.divinePurpose = TRB.Classes.SpellBase:New({
		id = 223819,
		isBuff = true
	})
    
    return self
end

---Fills barTextVariables for Protection Paladin options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Paladin.ProtectionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Paladin.ProtectionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$divinePurposeActive", description = L["PaladinBarTextVariable_divinePurposeActive"], printInSettings = false, color = false },
		{ variable = "$divinePurposeStacks", description = L["PaladinBarTextVariable_divinePurposeStacks"], printInSettings = false, color = false },
		{ variable = "$divinePurposeTime", description = L["PaladinBarTextVariable_divinePurposeTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Protection, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Paladin.ProtectionSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Paladin.RetributionSpells : TRB.Classes.SpecializationSpellsBase
---@field divinePurpose TRB.Classes.SpellBase
TRB.Classes.Paladin.RetributionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Paladin.RetributionSpells.__index = TRB.Classes.Paladin.RetributionSpells

function TRB.Classes.Paladin.RetributionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Paladin.RetributionSpells) --[[@as TRB.Classes.Paladin.RetributionSpells]]

    self.divinePurpose = TRB.Classes.SpellBase:New({
        id = 223819,
        isBuff = true
    })
   
    return self
end

---Fills barTextVariables for Retribution Paladin options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Paladin.RetributionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Paladin.RetributionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$divinePurposeActive", description = L["PaladinBarTextVariable_divinePurposeActive"], printInSettings = false, color = false },
		{ variable = "$divinePurposeStacks", description = L["PaladinBarTextVariable_divinePurposeStacks"], printInSettings = false, color = false },
		{ variable = "$divinePurposeTime", description = L["PaladinBarTextVariable_divinePurposeTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Retribution, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Paladin.RetributionSpells.GetCastbarTickProfiles()
	return {}
end


--[[
    BarGroups Factory for Paladin
    Creates the appropriate BarGroup instances for each Paladin specialization.
    
    Holy: Primary bar (N=1) + Holy Power (N=5)
    Protection: Primary bar (N=1) + Holy Power (N=5)
    Retribution: Primary bar (N=1) + Holy Power (N=5)
]]

---@class TRB.Classes.Paladin.BarGroupsFactory
TRB.Classes.Paladin.BarGroupsFactory = {}
TRB.Classes.Paladin.BarGroupsFactory.__index = TRB.Classes.Paladin.BarGroupsFactory

---Creates BarGroup instances for the specified Paladin specialization
---@param specId integer # 1=Holy, 2=Protection, 3=Retribution
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary mana bar (1 node) - all specs use mana
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Holy Power (5 nodes) - all Paladin specs use Holy Power
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
function TRB.Classes.Paladin.BarGroupsFactory:GetSpecConfiguration(specId)
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true,
            resourceType = "Mana"
        },
        secondary = {
            maxNodes = 5,
            isPrimary = false,
            resourceType = "HolyPower"
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
TRB.Data.barTextVariablesRegistry["paladin_holy"] = TRB.Classes.Paladin.HolySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["paladin_protection"] = TRB.Classes.Paladin.ProtectionSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["paladin_retribution"] = TRB.Classes.Paladin.RetributionSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["paladin_holy"] = TRB.Classes.Paladin.HolySpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["paladin_protection"] = TRB.Classes.Paladin.ProtectionSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["paladin_retribution"] = TRB.Classes.Paladin.RetributionSpells.GetCastbarTickProfiles