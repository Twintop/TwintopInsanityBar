local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 9 then --Only do this if we're on an Warlock!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Warlock = TRB.Classes.Warlock or {}

---@class TRB.Classes.Warlock.AfflictionSpells : TRB.Classes.SpecializationSpellsBase

TRB.Classes.Warlock.AfflictionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.AfflictionSpells.__index = TRB.Classes.Warlock.AfflictionSpells


function TRB.Classes.Warlock.AfflictionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.AfflictionSpells) --[[@as TRB.Classes.Warlock.AfflictionSpells]]


    return self
end
