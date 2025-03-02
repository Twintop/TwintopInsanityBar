---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Settings = TRB.Classes.Settings or {}

---@class TRB.Classes.Settings.SpecializationGlobalEnabled
---@field public bar boolean
---@field public comboPoints boolean
---@field public displayText boolean
---@field public textColors boolean
---@field public dotColors boolean
---@field public precision boolean

---@class TRB.Classes.Settings.SpecializationSettingsBase
---@field public bar TRB.Casses.Settings.Bar
---@field public colors TRB.Classes.Settings.Colors
---@field public comboPoints TRB.Casses.Settings.ComboPoints
---@field public displayBar table?
---@field public displayText TRB.Classes.Settings.DisplayText
---@field public textures table?
---@field public thresholds table?
---@field public precision TRB.Classes.Settings.Precision

---@class TRB.Classes.Settings.Core : TRB.Classes.Settings.SpecializationSettingsBase
---@field public dataRefreshRate number
---@field public reactionTime number
---@field public smoothBarValueUpdates boolean
---@field public news table
---@field public ttd table
---@field public audio table
---@field public strata table
---@field public timers table
---@field public thresholds table
---@field public displayBar table
---@field public global table
---@field public enabled table
---@field public experimental table

---@class TRB.Classes.Settings.Precision
---@field public secondary integer
---@field public resource integer

---@class TRB.Classes.Settings.Colors
---@field public text table
---@field public bar table
---@field public comboPoints table
---@field public threshold table

---@class TRB.Casses.Settings.Bar
---@field public width number
---@field public height number
---@field public xPos number
---@field public yPos number
---@field public border integer
---@field public dragAndDrop boolean
---@field public pinToPersonalResourceDisplay boolean

---@class TRB.Casses.Settings.ComboPoints
---@field public width number
---@field public height number
---@field public xPos number
---@field public yPos number
---@field public border integer
---@field public spacing integer
---@field public relativeTo string
---@field public relativeToName string
---@field public fullWidth boolean

---@class TRB.Classes.Settings.DisplayText
---@field public default TRB.Classes.Settings.DisplayTextDefault
---@field public barText TRB.Classes.Settings.DisplayTextEntry[]

---@class TRB.Classes.Settings.DisplayTextDefault
---@field public fontFace string
---@field public fontFaceName string
---@field public fontJustifyHorizontal string
---@field public fontJustifyHorizontalName string
---@field public fontSize integer
---@field public color string

---@class TRB.Classes.Settings.DisplayTextEntry : TRB.Classes.Settings.DisplayTextDefault
---@field public useDefaultFontFace boolean
---@field public useDefaultFontSize boolean
---@field public useDefaultFontColor boolean
---@field public enabled boolean
---@field public name string
---@field public text string
---@field public guid string
---@field public position TRB.Classes.Settings.DisplayTextPosition

---@class TRB.Classes.Settings.DisplayTextPosition
---@field public xPos number
---@field public yPos number
---@field public relativeTo string
---@field public relativeToName string
---@field public relativeToFrame string
---@field public relativeToFrameName string