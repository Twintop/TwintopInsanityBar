---@meta
-- Language server annotations for The Burning Crusade Classic client API that the retail and Classic Era annotations lack,
-- checked against Blizzard's TBC UI on Gethe/wow-ui-source's classic_anniversary branch. Never loaded in game.

---The character sheet's Defense: the base skill and the bonus from gear and talents.
---@param unit UnitToken
---@return number base
---@return number modifier
function UnitDefense(unit) end
