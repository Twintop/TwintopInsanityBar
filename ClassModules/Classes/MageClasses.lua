local _, TRB = ...
if TRB.Data.character.classId ~= 8 then --Only do this if we're on an Mage!
	return
end

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


---@class TRB.Classes.Mage.FireSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Mage.FireSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.FireSpells.__index = TRB.Classes.Mage.FireSpells

function TRB.Classes.Mage.FireSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.FireSpells) --[[@as TRB.Classes.Mage.FireSpells]]
    
    return self
end


---@class TRB.Classes.Mage.FrostSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Mage.FrostSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.FrostSpells.__index = TRB.Classes.Mage.FrostSpells

function TRB.Classes.Mage.FrostSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.FrostSpells) --[[@as TRB.Classes.Mage.FrostSpells]]
   
    return self
end


--[[
    BarGroups Factory for Mage
    Creates the appropriate BarGroup instances for each Mage specialization.
    
    Arcane: Primary bar (N=1) + Arcane Charges (N=4)
    Fire: Primary bar (N=1) only
    Frost: Primary bar (N=1) only
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
        barGroups.secondary = TRB.Classes.BarGroup:New(
            barGroups.primary:GetContainerFrame(),
            "TwintopResourceBarFrame_ComboPoint",
            4,
            false -- not primary
        )

    elseif specId == 2 then -- Fire
        -- Primary mana bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

    elseif specId == 3 then -- Frost
        -- Primary mana bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
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
                isPrimary = true
            },
            secondary = {
                maxNodes = 4,
                isPrimary = false,
                resourceType = "ArcaneCharges"
            }
        }
    elseif specId == 2 then -- Fire
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            }
        }
    elseif specId == 3 then -- Frost
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            }
        }
    end

    return {}
end