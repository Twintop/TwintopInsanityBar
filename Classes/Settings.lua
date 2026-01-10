---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Settings = TRB.Classes.Settings or {}

---@class TRB.Classes.Settings.SpecializationGlobalEnabled
---@field public bar boolean
---@field public comboPoints boolean
---@field public healthBar boolean
---@field public thresholdIcons boolean
---@field public displayBar boolean
---@field public displayText boolean
---@field public textColors boolean
---@field public thresholdColors boolean
---@field public healthBarColors boolean
---@field public precision boolean
---@field public textures boolean

---@class TRB.Classes.Settings.SpecializationSettingsBase
---@field public bar TRB.Classes.Settings.PrimaryBar
---@field public colors TRB.Classes.Settings.Colors
---@field public comboPoints TRB.Classes.Settings.SecondaryBar
---@field public healthBar TRB.Classes.Settings.SecondaryBar
---@field public bars TRB.Classes.Settings.SecondaryBar[]?
---@field public displayBar table?
---@field public displayText TRB.Classes.Settings.DisplayText
---@field public textures table?
---@field public thresholds TRB.Classes.Settings.Thresholds?
---@field public precision TRB.Classes.Settings.Precision
---@field public audio { string: TRB.Classes.Settings.Audio }
---@field public maxResource table?

---@class TRB.Classes.Settings.Core : TRB.Classes.Settings.SpecializationSettingsBase
---@field public colors TRB.Classes.Settings.ColorsCore
---@field public dataRefreshRate number
---@field public reactionTime number
---@field public smoothBarValueUpdates boolean
---@field public news table
---@field public strata table
---@field public timers table
---@field public thresholds table
---@field public displayBar table
---@field public global table
---@field public enabled table
---@field public experimental table

---@class TRB.Classes.Settings.Thresholds
---@field public properties TRB.Classes.Settings.ThresholdProperties
---@field public icons TRB.Classes.Settings.ThresholdIcons
---@field public specProperties table?
---@field public thresholdDictionary { string: table }

---@class TRB.Classes.Settings.ThresholdProperties
---@field public width number
---@field public overlapBorder boolean

---@class TRB.Classes.Settings.ThresholdIcons
---@field public showCooldown boolean
---@field public border number
---@field public relativeTo string
---@field public relativeToName string
---@field public enabled boolean
---@field public desaturated boolean
---@field public xPos number
---@field public yPos number
---@field public width number
---@field public height number

---@class TRB.Classes.Settings.Precision
---@field public secondary integer
---@field public resource integer

---@class TRB.Classes.Settings.ColorEntry
---@field public color string

---@class TRB.Classes.Settings.ColorEnabledEntry : TRB.Classes.Settings.ColorEntry
---@field public enabled boolean

---@class TRB.Classes.Settings.ColorShowEntry : TRB.Classes.Settings.ColorEnabledEntry

---@class TRB.Classes.Settings.ColorThresholdEntry : TRB.Classes.Settings.ColorEntry
---@field public threshold number

---@class TRB.Classes.Settings.TextColors
---@field public current TRB.Classes.Settings.ColorEnabledEntry
---@field public casting TRB.Classes.Settings.ColorEnabledEntry
---@field public spending TRB.Classes.Settings.ColorEnabledEntry
---@field public passive TRB.Classes.Settings.ColorEnabledEntry
---@field public overThreshold TRB.Classes.Settings.ColorEnabledEntry
---@field public manaBar TRB.Classes.Settings.ColorEntry?

---@class TRB.Classes.Settings.ThresholdColors
---@field public under TRB.Classes.Settings.ColorEntry
---@field public over TRB.Classes.Settings.ColorEntry
---@field public unusable TRB.Classes.Settings.ColorShowEntry
---@field public special TRB.Classes.Settings.ColorEntry
---@field public outOfRange TRB.Classes.Settings.ColorShowEntry

---@class TRB.Classes.Settings.GenericBarColorsBase
---@field public bar TRB.Classes.Settings.ColorEntry
---@field public border TRB.Classes.Settings.ColorEntry
---@field public background TRB.Classes.Settings.ColorEntry

---@class TRB.Classes.Settings.HealthBarColors
---@field public border string
---@field public background string
---@field public type trbBarColorType
---@field public low TRB.Classes.Settings.ColorThresholdEntry
---@field public medium TRB.Classes.Settings.ColorThresholdEntry
---@field public high TRB.Classes.Settings.ColorThresholdEntry

---@class TRB.Classes.Settings.Colors
---@field public text TRB.Classes.Settings.TextColors
---@field public bar table
---@field public comboPoints table
---@field public bars table
---@field public healthBar TRB.Classes.Settings.HealthBarColors
---@field public threshold TRB.Classes.Settings.ThresholdColors|{ [string]: TRB.Classes.Settings.ColorEnabledEntry }

---@class TRB.Classes.Settings.ColorsCore : TRB.Classes.Settings.Colors

---@class TRB.Classes.Settings.PrimaryBar
---@field public width number
---@field public height number
---@field public xPos number
---@field public yPos number
---@field public border integer
---@field public dragAndDrop boolean
---@field public pinToPersonalResourceDisplay boolean

---@class TRB.Classes.Settings.SecondaryBar
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

---@class TRB.Classes.Settings.Audio
---@field public name string
---@field public enabled boolean
---@field public sound string
---@field public soundName string

---@class TRB.Classes.Settings.GenericTrackingOverX
---@field public enabled boolean
---@field public mode string --Really should make this an enum of gcd/seconds
---@field public gcdsMax number
---@field public timeMax number

---@alias trbBarVisibility
---| '"always"' # Always show the bar
---| '"combat"' # Only show the bar in combat
---| '"never"' # Never show the bar

---@alias trbBarColorType
---| '"step"' # Step colors
---| '"linear"' # Linear colors
---| '"none"' # Only use a single color