local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 2 then --Only do this if we're on an Paladin!
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