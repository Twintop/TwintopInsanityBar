local _, TRB = ...
if TRB.Data.character.classId ~= 6 then --Only do this if we're on an Death Knight!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.DeathKnight = TRB.Classes.DeathKnight or {}


---@class TRB.Classes.DeathKnight.BloodSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.DeathKnight.BloodSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DeathKnight.BloodSpells.__index = TRB.Classes.DeathKnight.BloodSpells

function TRB.Classes.DeathKnight.BloodSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.BloodSpells) --[[@as TRB.Classes.DeathKnight.BloodSpells]]
    -- Death Knight Class Baseline Abilities

    -- Blood Baseline Abilities
    self.infusionOfLight = TRB.Classes.SpellBase:New({
        id = 54149,
        isTalent = false,
        baseline = true
    })

    -- Death Knight Class Talents
    
    -- Blood Spec Talents

    return self
end


---@class TRB.Classes.DeathKnight.FrostSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.DeathKnight.FrostSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DeathKnight.FrostSpells.__index = TRB.Classes.DeathKnight.FrostSpells

function TRB.Classes.DeathKnight.FrostSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.FrostSpells) --[[@as TRB.Classes.DeathKnight.FrostSpells]]
    
    return self
end


---@class TRB.Classes.DeathKnight.UnholySpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.DeathKnight.UnholySpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DeathKnight.UnholySpells.__index = TRB.Classes.DeathKnight.UnholySpells

function TRB.Classes.DeathKnight.UnholySpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.UnholySpells) --[[@as TRB.Classes.DeathKnight.UnholySpells]]
   
    return self
end