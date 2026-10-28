---@meta
-- Language server annotations for WoW Classic (Vanilla Era) client API that the retail annotations lack, checked against
-- Blizzard's Vanilla UI on Gethe/wow-ui-source's classic_era branch. Never loaded in game.

---Classic Era's FrameXML fills LOCALIZED_CLASS_NAMES_MALE with this; it has no LocalizedClassList.
---@param classTable table<string, string> # Filled with class file token -> localized class name
---@param isFemale boolean?
function FillLocalizedClassList(classTable, isFemale) end

---"Combo Points" on Classic Era, which has no COMBO_POINTS_POWER.
---@type string
TUTORIAL_TITLE61_ROGUE = ""

---@param isInspect boolean?
---@param isPet boolean?
---@return number numTabs
function GetNumTalentTabs(isInspect, isPet) end

---@param tabIndex number
---@param isInspect boolean?
---@param isPet boolean?
---@return number numTalents
function GetNumTalents(tabIndex, isInspect, isPet) end
