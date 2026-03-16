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
---@field public globalBarText boolean
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
---@field public health integer
---@field public secondary integer
---@field public resource integer
---@field public mana integer?

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
---@field public overcap TRB.Classes.Settings.ColorEnabledEntry
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

---@class TRB.Classes.Settings.HealthBarOverlayColorEntry : TRB.Classes.Settings.ColorEntry
---@field public enabled boolean
---@field public mode trbOverlayMode

---@class TRB.Classes.Settings.HealthBarColors
---@field public border TRB.Classes.Settings.ColorEntry
---@field public background TRB.Classes.Settings.ColorEntry
---@field public absorb TRB.Classes.Settings.HealthBarOverlayColorEntry
---@field public incomingHeal TRB.Classes.Settings.HealthBarOverlayColorEntry
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
---@field public anchor TRB.Classes.Settings.BarAnchor? # Only used when this bar is NOT the base bar

---@class TRB.Classes.Settings.SecondaryBar
---@field public width number
---@field public height number
---@field public border integer
---@field public spacing integer
---@field public anchor TRB.Classes.Settings.BarAnchor? # New anchor system
---@field public xPos number # @deprecated Use anchor.xOffset instead
---@field public yPos number # @deprecated Use anchor.yOffset instead
---@field public relativeTo string # @deprecated Use anchor.anchorPoint/attachPoint instead
---@field public relativeToName string # @deprecated Display label for legacy relativeTo
---@field public fullWidth boolean # @deprecated Use anchor.matchWidth instead

---@class TRB.Classes.Settings.DisplayText
---@field public default TRB.Classes.Settings.DisplayTextDefault
---@field public barText TRB.Classes.Settings.DisplayTextEntry[]
---@field public globalBarTextCount integer?
---@field public migrations table?

---@class TRB.Classes.Settings.DisplayTextDefault
---@field public fontFace string
---@field public fontFaceName string
---@field public fontJustifyHorizontal string
---@field public fontJustifyHorizontalName string
---@field public fontSize integer
---@field public color TRB.Classes.Settings.ColorEntry
---@field public fontOutline string # SetFont flags: "", "OUTLINE", "THICKOUTLINE", "MONOCHROME", "OUTLINE, MONOCHROME", "THICKOUTLINE, MONOCHROME"
---@field public fontOutlineName string # Localized display name for the outline option
---@field public fontShadow TRB.Classes.Settings.FontShadow

---@class TRB.Classes.Settings.FontShadow
---@field public enabled boolean
---@field public color string # ARGB hex color, e.g. "FF000000"
---@field public xOffset number
---@field public yOffset number

---@class TRB.Classes.Settings.DisplayTextEntry : TRB.Classes.Settings.DisplayTextDefault
---@field public useDefaultFontFace boolean
---@field public useDefaultFontSize boolean
---@field public useDefaultFontColor boolean
---@field public useDefaultFontOutline boolean
---@field public useDefaultFontShadow boolean
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
---@field public configuration table?

---Defines how a bar is anchored to another bar in the anchor tree.
---@class TRB.Classes.Settings.BarAnchor
---@field public barKey string # Key of the target bar: "primary", "secondary", "health", "utility", or any BarTypeRegistry key
---@field public anchorPoint string # Point on the TARGET bar (TOPLEFT|TOP|TOPRIGHT|LEFT|CENTER|RIGHT|BOTTOMLEFT|BOTTOM|BOTTOMRIGHT)
---@field public attachPoint string # Point on THIS bar that touches the anchor point
---@field public xOffset number # Horizontal pixel offset from the anchor point
---@field public yOffset number # Vertical pixel offset from the anchor point
---@field public matchWidth boolean # If true, this bar's width matches the anchor bar's effective width

---@class TRB.Classes.Settings.AnchorTreeNode
---@field public barKey string # Key of this bar
---@field public anchor TRB.Classes.Settings.BarAnchor? # Anchor settings (nil for base bar)
---@field public children TRB.Classes.Settings.AnchorTreeNode[] # Child bars anchored to this bar
---@field public barGroup TRB.Classes.BarGroup? # Runtime reference to the BarGroup
---@field public barSettings table? # Runtime reference to the bar's settings table
---@field public width number? # Effective width (for bounding box calculations)
---@field public height number? # Effective height (for bounding box calculations)

---@class TRB.Classes.Settings.GenericTrackingOverX
---@field public enabled boolean
---@field public mode string --Really should make this an enum of gcd/seconds
---@field public gcdsMax number
---@field public timeMax number

---@alias trbBarVisibility
---| '"always"' # Always show the bar
---| '"combat"' # Only show the bar in combat
---| '"never"' # Never show the bar

---@class trbBarVisibilityConditions
---@field public inCombat boolean? # Show when the player is in combat
---@field public inVehicle boolean? # Show when the player is in a vehicle
---@field public hasFriendlyTarget boolean? # Show when the player has a friendly target
---@field public hasUnfriendlyTarget boolean? # Show when the player has an unfriendly target
---@field public isMountedAny boolean? # Show when the player is mounted (any mount)
---@field public isMountedGround boolean? # Show when the player is on a ground mount (mounted + not flying)
---@field public isSkyriding boolean? # Show when the player is skyriding
---@field public isSteadyFlight boolean? # Show when the player is on a steady flight mount (non-skyriding, flying)
---@field public inGroup boolean? # Show when the player is in a group (party or raid)
---@field public inRaid boolean? # Show when the player is in a raid group
---@field public inInstance boolean? # Show when the player is in any instance (catch-all)
---@field public inDungeon boolean? # Show when the player is in a 5-man dungeon
---@field public inRaidInstance boolean? # Show when the player is in a raid instance
---@field public inBattleground boolean? # Show when the player is in a battleground
---@field public inArena boolean? # Show when the player is in an arena
---@field public inDelve boolean? # Show when the player is in a delve
---@field public isPvpFlagged boolean? # Show when the player is PVP flagged
---@field public isWarMode boolean? # Show when War Mode is enabled

---@class trbBarVisibilitySetting
---@field public neverShow boolean # When true, the bar is unconditionally hidden regardless of conditions
---@field public alwaysShow boolean # When true, the bar is unconditionally shown (overrides conditions but not neverShow). Independent of individual conditions.
---@field public conditions trbBarVisibilityConditions # OR-combined conditions evaluated when alwaysShow is false
---@field public smooth boolean
---@field public activeAlpha number # Opacity (0–100) when visibility conditions are met. Default 100.
---@field public inactiveAlpha number # Opacity (0–100) when visibility conditions are NOT met. 0 = fully hidden. Default 0.
---@field public fadeDuration number # Seconds to fade out to inactive opacity. 0 = instant. Default 0.
---@field public fadeDelay number # Seconds to wait before starting the fade out. 0 = immediate. Default 0.
---@field public resourceConditionType string? # Type of resource/health threshold condition: "none", "resourcePercent", "resourceValue", "healthPercent", "healthValue"
---@field public resourceConditionOperator string? # Comparison operator: ">=", ">", "<=", "<", "==", "!="
---@field public resourceConditionValue number? # Threshold value for the resource/health condition
---@field public visibility trbBarVisibility? # DEPRECATED: Legacy field, migrated to neverShow+conditions

---@alias trbOverlayMode
---| '"overlay"' # Fills from the left edge of the bar up to the overlay amount
---| '"appended"' # Visually appends the overlay region to the right of the current health fill
---| '"inset"' # Reverse-fill from the health fill's trailing edge going leftward

---@class trbHealthBarVisibilitySetting : trbBarVisibilitySetting

---@alias trbBarColorType
---| '"step"' # Step colors
---| '"linear"' # Linear colors
---| '"none"' # Only use a single color