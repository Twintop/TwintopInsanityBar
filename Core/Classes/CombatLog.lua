---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.CombatLogEntry = {}

---@class TRB.Classes.CombatLogEntry
---@field public type trbAuraEventType
---@field public sourceGuid string
---@field public sourceName string
---@field public destinationGuid string
---@field public destinationFlags number
---@field public spellId integer


---Gets the most recent combat log event and returns an object containing the combat log contents we care about.
---@return TRB.Classes.CombatLogEntry
function TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
    ---@type TRB.Classes.CombatLogEntry
    ---@diagnostic disable-next-line: missing-fields
    local entry = {}

    ---@diagnostic disable-next-line: assign-type-mismatch
    _, entry.type, _, entry.sourceGuid, entry.sourceName, _, _, entry.destinationGuid, _, entry.destinationFlags, _, entry.spellId, _ = CombatLogGetCurrentEventInfo()
    return entry
end