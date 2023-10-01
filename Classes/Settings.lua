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

---@class TRB.Classes.DisplayText
---@field public default TRB.Classes.DisplayTextDefault
---@field public barText TRB.Classes.DisplayTextEntry[]

---@class TRB.Classes.DisplayTextDefault
---@field public fontFace string
---@field public fontFaceName string
---@field public fontJustifyHorizontal string
---@field public fontJustifyHorizontalName string
---@field public fontSize integer
---@field public color string

---@class TRB.Classes.DisplayTextEntry : TRB.Classes.DisplayTextDefault
---@field public useDefaultFontFace boolean
---@field public useDefaultFontSize boolean
---@field public useDefaultFontColor boolean
---@field public name string
---@field public text string
---@field public guid string
---@field public position TRB.Classes.DisplayTextPosition

---@class TRB.Classes.DisplayTextPosition
---@field public xPos number
---@field public yPos number
---@field public relativeTo string
---@field public relativeToName string
---@field public relativeToFrame string
---@field public relativeToFrameName string