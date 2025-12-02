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