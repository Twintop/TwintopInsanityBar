---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.SpecCache
---@field public Global_TwintopResourceBar table
---@field public barTextVariables table
---@field public character table
---@field public settings TRB.Classes.SharedSpecSetting
---@field public spellsData TRB.Classes.SpellsData
---@field public snapshotData TRB.Classes.SnapshotData
---@field public talents TRB.Classes.Talents
TRB.Classes.SpecCache = {}
TRB.Classes.SpecCache.__index = TRB.Classes.SpecCache

---Create a new SpecCache
---@param snapshotDataAttributes table? # Custom attributes to be tracked by SnapshotData
---@return TRB.Classes.SpecCache
function TRB.Classes.SpecCache:New(snapshotDataAttributes)
    local self = {}
    setmetatable(self, TRB.Classes.SpecCache)
    
    self.Global_TwintopResourceBar = {}
    self.barTextVariables = {
        icons = {},
        values = {}
    }
    self.character = {}
    self.settings = {}
    self.spellsData = TRB.Classes.SpellsData:New()
    self.snapshotData = TRB.Classes.SnapshotData:New(snapshotDataAttributes)
    self.talents = TRB.Classes.Talents:New()

    return self
end