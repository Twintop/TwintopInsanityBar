---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on a Evoker!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Evoker = TRB.Classes.Evoker or {}


---@class TRB.Classes.Evoker.DevastationSpells : TRB.Classes.SpecializationSpellsBase
---@field public essenceBurst TRB.Classes.SpellBase
---@field public meltArmor TRB.Classes.SpellBase
TRB.Classes.Evoker.DevastationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.DevastationSpells.__index = TRB.Classes.Evoker.DevastationSpells

function TRB.Classes.Evoker.DevastationSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Evoker.DevastationSpells) --[[@as TRB.Classes.Evoker.DevastationSpells]]

	self.essenceBurst = TRB.Classes.SpellBase:New({
		id = 359618,
		isBuff = true
	})

	-- Scalecommander
	self.meltArmor = TRB.Classes.SpellBase:New({
		id = 441172,
		talentId = 441176,
		isTalent = true
	})
	return self
end


---@class TRB.Classes.Evoker.PreservationSpells : TRB.Classes.Healer.HealerSpells
---@field public essenceBurst TRB.Classes.SpellBase
TRB.Classes.Evoker.PreservationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Evoker.PreservationSpells.__index = TRB.Classes.Evoker.PreservationSpells

function TRB.Classes.Evoker.PreservationSpells:New()
	---@type TRB.Classes.Healer.HealerSpells
	local base = TRB.Classes.Healer.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Evoker.PreservationSpells) --[[@as TRB.Classes.Evoker.PreservationSpells]]
	-- Evoker Class Talents		
	
	-- Preservation Spec Talents
	self.essenceBurst = TRB.Classes.SpellBase:New({
		id = 369299,
		isBuff = true
	})
	
	-- Chronowarden
	self.temporalBurst = TRB.Classes.SpellBase:New({
		id = 431698,
		isBuff = true
	})

	return self
end


---@class TRB.Classes.Evoker.AugmentationSpells : TRB.Classes.SpecializationSpellsBase
---@field public essenceBurst TRB.Classes.SpellBase
---@field public temporalBurst TRB.Classes.SpellBase
---@field public meltArmor TRB.Classes.SpellBase
TRB.Classes.Evoker.AugmentationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.AugmentationSpells.__index = TRB.Classes.Evoker.AugmentationSpells

function TRB.Classes.Evoker.AugmentationSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Evoker.AugmentationSpells) --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	self.essenceBurst = TRB.Classes.SpellBase:New({
		id = 392268,
		isBuff = true
	})
	
	-- Chronowarden
	self.temporalBurst = TRB.Classes.SpellBase:New({
		id = 431698,
		isBuff = true
	})

	-- Scalecommander
	self.meltArmor = TRB.Classes.SpellBase:New({
		id = 441172,
		talentId = 441176,
		isTalent = true
	})
	return self
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
    -- Primary Mana bar (1 node) + Essence (up to 6 nodes)

    -- Primary Mana bar (1 node)
    -- Primary bar groups are parented directly to UIParent for proper positioning
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Essence (up to 6 nodes for all specs)
    -- Secondary bars are parented to the primary's container
    barGroups.secondary = TRB.Classes.BarGroup:New(
        barGroups.primary:GetContainerFrame(),
        "TwintopResourceBarFrame_ComboPoint",
        6,
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
        }
    }
end