---@meta
-- Language server annotations for WoW Classic (Vanilla Era) client API that the retail annotations lack, checked against
-- Blizzard's Vanilla talent frame on Gethe/wow-ui-source's classic_era branch. Never loaded in game.

---@param isInspect boolean?
---@param isPet boolean?
---@return number numTabs
function GetNumTalentTabs(isInspect, isPet) end

---@param tabIndex number
---@param isInspect boolean?
---@param isPet boolean?
---@return number numTalents
function GetNumTalents(tabIndex, isInspect, isPet) end
