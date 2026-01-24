---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on a Evoker!
	return
end
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


---@class TRB.Classes.Evoker.PreservationSpells : TRB.Classes.Healer.HealerSpells
TRB.Classes.Evoker.PreservationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Evoker.PreservationSpells.__index = TRB.Classes.Evoker.PreservationSpells

function TRB.Classes.Evoker.PreservationSpells:New()
	---@type TRB.Classes.Healer.HealerSpells
	local base = TRB.Classes.Healer.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Evoker.PreservationSpells) --[[@as TRB.Classes.Evoker.PreservationSpells]]
	-- Evoker Class Talents		
	
	-- Preservation Spec Talents
    
	-- Chronowarden

	return self
end


---@class TRB.Classes.Evoker.AugmentationSpells : TRB.Classes.SpecializationSpellsBase
---@field public ebonMight TRB.Classes.SpellBase
---@field public erruption TRB.Classes.SpellBase
---@field public emeraldBlossom TRB.Classes.SpellBase
---@field public dreamOfSpring TRB.Classes.SpellBase
TRB.Classes.Evoker.AugmentationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.AugmentationSpells.__index = TRB.Classes.Evoker.AugmentationSpells

function TRB.Classes.Evoker.AugmentationSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Evoker.AugmentationSpells) --[[@as TRB.Classes.Evoker.AugmentationSpells]]

    self.ebonMight = TRB.Classes.SpellBase:New({
        id = 395296,
        talentId = 395152,
        isBuff = true,
        isTalent = true
    })
	self.erruption = TRB.Classes.SpellBase:New({
        id = 395160,
        isTalent = true
    })

    self.emeraldBlossom = TRB.Classes.SpellBase:New({
        id = 355913,
        baseline = true
    })
    self.dreamOfSpring = TRB.Classes.SpellBase:New({
        id = 414969,
        isTalent = true
    })
	-- Chronowarden
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