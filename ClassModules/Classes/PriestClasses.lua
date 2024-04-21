---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Priest = TRB.Classes.Priest or {}

---@class TRB.Classes.Priest.HolyWordSpell : TRB.Classes.SpellBase
---@field public holyWordKey string? # Holy Word spell key that has its cooldown reduced on cast.
---@field public holyWordReduction number? # How much the associated Holy Word will have its cooldown reduced.
---@field public holyWordModifier number? # Modification of the reduction when included with related casts.
TRB.Classes.Priest.HolyWordSpell = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.Priest.HolyWordSpell.__index = TRB.Classes.Priest.HolyWordSpell

---Creates a new HolyWordSpell object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.Priest.HolyWordSpell
function TRB.Classes.Priest.HolyWordSpell:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local spellBase = TRB.Classes.SpellBase
    local self = setmetatable(spellBase:New(spellAttributes), TRB.Classes.SpellBase)
    
    self.holyWordModifier = 1
    self.holyWordReduction = 0

    for key, value in pairs(spellAttributes) do
        if  (key == "holyWordReduction" and type(value) == "number") or
            (key == "holyWordModifier"  and type(value) == "number") or
            (key == "holyWordKey") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end