---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.SharedSpecSetting
---@field public bar table?
---@field public colors table?
---@field public comboPoints table?
---@field public displayBar table?
---@field public displayText table?
---@field public textures table?
---@field public thresholds table?
TRB.Classes.SharedSpecSetting = {}
TRB.Classes.SharedSpecSetting.__index = TRB.Classes.SharedSpecSetting

---Creates a new SharedSpecSetting object
---@return TRB.Classes.SharedSpecSetting
function TRB.Classes.SharedSpecSetting:New()
    local self = {}
    setmetatable(self, TRB.Classes.SharedSpecSetting)
    
    self.bar = nil
    self.colors = nil
    self.comboPoints = nil
    self.displayBar = nil
    self.displayText = nil
    self.textures = nil
    self.thresholds = nil

    return self
end

---@class TRB.Classes.GlobalSpecSetting : TRB.Classes.SharedSpecSetting
---@field public font table?
---@field public specEnable boolean
TRB.Classes.GlobalSpecSetting = setmetatable({}, {__index = TRB.Classes.SharedSpecSetting})
TRB.Classes.GlobalSpecSetting.__index = TRB.Classes.GlobalSpecSetting

---Creates a new GlobalSpecSetting object
---@param specEnable boolean # Is the global spec setting enabled for this spec
---@return TRB.Classes.GlobalSpecSetting|TRB.Classes.SharedSpecSetting
function TRB.Classes.GlobalSpecSetting:New(specEnable)
    ---@type TRB.Classes.SharedSpecSetting
    local sharedSpecSetting = TRB.Classes.SharedSpecSetting
    local self = setmetatable(sharedSpecSetting:New(), TRB.Classes.GlobalSpecSetting)
    self.font = nil
    self.specEnable = specEnable
    return self
end