---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 13 then --Only do this if we're on a Evoker!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Evoker = TRB.Classes.Evoker or {}


---@class TRB.Classes.Evoker.DevastationSpells : TRB.Classes.SpecializationSpellsBase
---@field public essenceBurst TRB.Classes.SpellBase
TRB.Classes.Evoker.DevastationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.DevastationSpells.__index = TRB.Classes.Evoker.DevastationSpells

function TRB.Classes.Evoker.DevastationSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Evoker.DevastationSpells) --[[@as TRB.Classes.Evoker.DevastationSpells]]

    self.essenceBurst = TRB.Classes.SpellBase:New({
        id = 359618
    })
    return self
end


---@class TRB.Classes.Evoker.PreservationSpells : TRB.Classes.Healer.HealerSpells
---@field public emeraldCommunion TRB.Classes.SpellBase
---@field public essenceBurst TRB.Classes.SpellBase
TRB.Classes.Evoker.PreservationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Evoker.PreservationSpells.__index = TRB.Classes.Evoker.PreservationSpells

function TRB.Classes.Evoker.PreservationSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Evoker.PreservationSpells) --[[@as TRB.Classes.Evoker.PreservationSpells]]
    -- Evoker Class Talents		
	
    -- Preservation Spec Talents			
    --TODO: Make this a proper threshold, like Shadowfiend
    self.emeraldCommunion = TRB.Classes.SpellBase:New({
        id = 370960,
        duration = 5.0, --Hasted
        resourcePerTick = 0.02,
        tickRate = 1,
        isTalent = true
    })
    self.essenceBurst = TRB.Classes.SpellBase:New({
        id = 369299,
    })

    return self
end


---@class TRB.Classes.Evoker.AugmentationSpells : TRB.Classes.SpecializationSpellsBase
---@field public essenceBurst TRB.Classes.SpellBase
TRB.Classes.Evoker.AugmentationSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Evoker.AugmentationSpells.__index = TRB.Classes.Evoker.AugmentationSpells

function TRB.Classes.Evoker.AugmentationSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Evoker.AugmentationSpells) --[[@as TRB.Classes.Evoker.AugmentationSpells]]

    self.essenceBurst = TRB.Classes.SpellBase:New({
        id = 359618
    })
    return self
end