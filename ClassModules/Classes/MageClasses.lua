local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Mage = TRB.Classes.Mage or {}


---@class TRB.Classes.Mage.ArcaneSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Mage.ArcaneSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.ArcaneSpells.__index = TRB.Classes.Mage.ArcaneSpells

function TRB.Classes.Mage.ArcaneSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.ArcaneSpells) --[[@as TRB.Classes.Mage.ArcaneSpells]]
    -- Mage Class Baseline Abilities

    -- Arcane Baseline Abilities

    -- Mage Class Talents
    
    -- Arcane Spec Talents

    return self
end

---Fills barTextVariables for Arcane Mage options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mage.ArcaneSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mage.ArcaneSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MageBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MageBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MageBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MageBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$arcaneCharges", description = L["MageArcaneBarTextVariable_arcaneCharges"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$arcaneChargesMax", description = L["MageArcaneBarTextVariable_arcaneChargesMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	})
end


---@class TRB.Classes.Mage.FireSpells : TRB.Classes.SpecializationSpellsBase
---@field fireBlast TRB.Classes.SpellBase
---@field flameOn TRB.Classes.SpellBase
---@field ferventFlickering TRB.Classes.SpellBase
TRB.Classes.Mage.FireSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.FireSpells.__index = TRB.Classes.Mage.FireSpells

function TRB.Classes.Mage.FireSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.FireSpells) --[[@as TRB.Classes.Mage.FireSpells]]
    
    self.fireBlast = TRB.Classes.SpellBase:New({
        id = 108853,
        talentId = 1246833,
        isTalent = true,
        hasCharges = true
    })

    -- Flame On: grants +1 Fire Blast charge
    self.flameOn = TRB.Classes.SpellBase:New({
        id = 205029,
        talentId = 205029,
        isTalent = true,
    })

    -- Fervent Flickering: grants +1 Fire Blast charge
    self.ferventFlickering = TRB.Classes.SpellBase:New({
        id = 387044,
        talentId = 387044,
        isTalent = true,
    })

    return self
end

---Fills barTextVariables for Fire Mage options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mage.FireSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mage.FireSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MageBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MageBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MageBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MageBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$fireBlastCharges", description = L["MageFireBarTextVariable_fireBlastCharges"], printInSettings = true, color = false },
        { variable = "$fbCharges", description = "", printInSettings = false, color = false },
        { variable = "$fireBlastChargesMax", description = L["MageFireBarTextVariable_fireBlastChargesMax"], printInSettings = true, color = false },
        { variable = "$fbChargesMax", description = "", printInSettings = false, color = false },
		{ variable = "$fireBlastTime", description = L["MageFireBarTextVariable_fireBlastTime"], printInSettings = true, color = false },
		{ variable = "$fbTime", description = "", printInSettings = false, color = false },
	})
end


---@class TRB.Classes.Mage.FrostSpells : TRB.Classes.SpecializationSpellsBase
---@field icicles TRB.Classes.SpellBase
TRB.Classes.Mage.FrostSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.FrostSpells.__index = TRB.Classes.Mage.FrostSpells

function TRB.Classes.Mage.FrostSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.FrostSpells) --[[@as TRB.Classes.Mage.FrostSpells]]

    self.icicles = TRB.Classes.SpellBase:New({
        id = 205473,
        talentId = 1246832,
        isTalent = true,
        maxStacks = 5
    })

    return self
end

---Fills barTextVariables for Frost Mage options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mage.FrostSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mage.FrostSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MageBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MageBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MageBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MageBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$icicles", description = L["MageFrostBarTextVariable_icicles"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$iciclesMax", description = L["MageFrostBarTextVariable_iciclesMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	})
end


--[[
    BarGroups Factory for Mage
    Creates the appropriate BarGroup instances for each Mage specialization.
    
    Arcane: Primary bar (N=1) + Arcane Charges (N=4)
    Fire: Primary bar (N=1) + Fire Blast Charges (N=3)
    Frost: Primary bar (N=1) + Icicles (N=5)
]]

---@class TRB.Classes.Mage.BarGroupsFactory
TRB.Classes.Mage.BarGroupsFactory = {}
TRB.Classes.Mage.BarGroupsFactory.__index = TRB.Classes.Mage.BarGroupsFactory

---Creates BarGroup instances for the specified Mage specialization
---@param specId integer # 1=Arcane, 2=Fire, 3=Frost
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Mage.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    if specId == 1 then -- Arcane
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Arcane Charges (4 nodes)
        -- Secondary bars are parented to UIParent for independent visibility
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            4,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 2 then -- Fire
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Fire Blast Charges (up to 3 nodes: 1 base + 2 from talents)
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            3,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 3 then -- Frost
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Icicles (5 nodes)
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
    end

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Mage.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Arcane
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 4,
                isPrimary = false,
                resourceType = "ArcaneCharges"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 2 then -- Fire
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 3,
                isPrimary = false,
                resourceType = "FireBlastCharges"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 3 then -- Frost
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 5,
                isPrimary = false,
                resourceType = "Icicles"
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
TRB.Data.barTextVariablesRegistry["mage_arcane"] = TRB.Classes.Mage.ArcaneSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["mage_fire"] = TRB.Classes.Mage.FireSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["mage_frost"] = TRB.Classes.Mage.FrostSpells.FillBarTextVariables