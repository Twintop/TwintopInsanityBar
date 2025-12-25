local _, TRB = ...
if TRB.Data.character.classId ~= 2 then --Only do this if we're on an Paladin!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Paladin = TRB.Classes.Paladin or {}


---@class TRB.Classes.Paladin.HolySpells : TRB.Classes.Healer.HealerSpells
---@field public infusionOfLight TRB.Classes.SpellBase
TRB.Classes.Paladin.HolySpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Paladin.HolySpells.__index = TRB.Classes.Paladin.HolySpells

function TRB.Classes.Paladin.HolySpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Paladin.HolySpells) --[[@as TRB.Classes.Paladin.HolySpells]]
    -- Paladin Class Baseline Abilities

    -- Holy Baseline Abilities
    self.infusionOfLight = TRB.Classes.SpellBase:New({
        id = 54149,
        isTalent = false,
        baseline = true
    })

    -- Paladin Class Talents		
    
    -- Holy Spec Talents

    return self
end


---@class TRB.Classes.Paladin.ProtectionSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Paladin.ProtectionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Paladin.ProtectionSpells.__index = TRB.Classes.Paladin.ProtectionSpells

function TRB.Classes.Paladin.ProtectionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Paladin.ProtectionSpells) --[[@as TRB.Classes.Paladin.ProtectionSpells]]
    
    return self
end


---@class TRB.Classes.Paladin.RetributionSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Paladin.RetributionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Paladin.RetributionSpells.__index = TRB.Classes.Paladin.RetributionSpells

function TRB.Classes.Paladin.RetributionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Paladin.RetributionSpells) --[[@as TRB.Classes.Paladin.RetributionSpells]]
   
    return self
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
    barGroups.secondary = TRB.Classes.BarGroup:New(
        barGroups.primary:GetContainerFrame(),
        "TwintopResourceBarFrame_ComboPoint",
        5,
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
            isPrimary = true
        },
        secondary = {
            maxNodes = 5,
            isPrimary = false,
            resourceType = "HolyPower"
        }
    }
end