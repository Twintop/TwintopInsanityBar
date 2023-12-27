---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.CombatLogEntry = {}

---@class TRB.Classes.CombatLogEntry
---@field public type trbAuraEventType
---@field public sourceGuid string
---@field public sourceName string
---@field public destinationGuid string
---@field public spellId integer


function TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
    ---@type TRB.Classes.CombatLogEntry
---@diagnostic disable-next-line: missing-fields
    local entry = {}

---@diagnostic disable-next-line: assign-type-mismatch
    _, entry.type, _, entry.sourceGuid, entry.sourceName, _, _, entry.destinationGuid, _, _, _, entry.spellId, _ = CombatLogGetCurrentEventInfo()

    return entry
end