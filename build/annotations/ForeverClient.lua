---@meta
-- Language server annotations for WoW Forever client API that the retail annotations lack, checked against the
-- generated API docs on Gethe/wow-ui-source's forever branch. Never loaded in game.

WOW_PROJECT_CAMELOT = 18

---@param unit UnitToken
---@return number base
---@return number modifier
function UnitDefenseSkill(unit) end

---@param unit UnitToken
---@param damageClass Enum.Damageclass
---@return number baseResistance
---@return number realResistance
---@return number effectiveResistance
---@return number bonusResistance
function UnitResistance(unit, damageClass) end

---@return number result
function GetRangedHitModifier() end

---@return number result
function GetArmorPenetration() end
