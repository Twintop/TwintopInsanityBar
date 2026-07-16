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
---@field public castbarDimensions boolean
---@field public castbarColors boolean
---@field public castbarOverlays boolean
---@field public castbarEmpower boolean
---@field public castbarText boolean

---@class TRB.Classes.Settings.SpecializationSettingsBase
---@field public bar TRB.Classes.Settings.PrimaryBar
---@field public barVisibilityThresholds table<string, trbBarVisibilityThresholdDefinition>?
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
---@field public thresholdDictionary { [string]: TRB.Classes.Settings.ThresholdDictionaryEntry }
---@field public customThresholds { [string]: TRB.Classes.Settings.CustomThresholdLine }

---@class TRB.Classes.Settings.CustomThresholdLine
---@field public guid string
---@field public name string
---@field public barTarget string
---@field public value number
---@field public valueMode string # "absolute" or "offset" (offset from the bar's maximum)
---@field public iconSourceType string # "spell", "item", "icon", or "none"
---@field public iconSourceId number
---@field public iconTexture string|number?

---@class TRB.Classes.Settings.ThresholdDictionaryEntry
---@field public enabled boolean
---@field public audio TRB.Classes.Settings.ThresholdDictionaryAudio
---@field public colors TRB.Classes.Settings.ThresholdDictionaryColors
---@field public icon TRB.Classes.Settings.ThresholdDictionaryIcon
---@field public line TRB.Classes.Settings.ThresholdDictionaryLine

---@class TRB.Classes.Settings.ThresholdDictionaryAudio
---@field public enabled boolean
---@field public sound string
---@field public soundName string

---@class TRB.Classes.Settings.ThresholdDictionaryColors
---@field public colorMode string?
---@field public staticColor TRB.Classes.Settings.ColorEntry?
---@field public under TRB.Classes.Settings.ColorModeEntry
---@field public over TRB.Classes.Settings.ColorModeEntry
---@field public unusable TRB.Classes.Settings.ColorModeEntry
---@field public outOfRange TRB.Classes.Settings.ColorOutOfRangeModeEntry

---@class TRB.Classes.Settings.ThresholdDictionaryIcon
---@field public enabled boolean
---@field public show boolean
---@field public width number
---@field public height number
---@field public xPos number
---@field public yPos number
---@field public relativeTo string?
---@field public desaturated boolean?
---@field public border number?

---@class TRB.Classes.Settings.ThresholdDictionaryLine
---@field public enabled boolean
---@field public width number
---@field public overlapBorder boolean?

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

---@class TRB.Classes.Settings.ColorGradientEntry : TRB.Classes.Settings.ColorEntry
---@field public color2 string
---@field public gradientDirection string -- "horizontal", "vertical", or "disabled"

---@class TRB.Classes.Settings.ColorModeEntry : TRB.Classes.Settings.ColorEntry
---@field public mode string -- "shared", "override", or "hidden"
---@field public enabled boolean? -- Deprecated: backward compat only

---@class TRB.Classes.Settings.ColorOutOfRangeModeEntry : TRB.Classes.Settings.ColorModeEntry
---@field public show boolean? -- Deprecated: legacy backward-compat; replaced by mode="hidden"

---@class TRB.Classes.Settings.ColorEnabledEntry : TRB.Classes.Settings.ColorEntry
---@field public enabled boolean

---@class TRB.Classes.Settings.ColorGradientEnabledEntry : TRB.Classes.Settings.ColorEnabledEntry
---@field public color2 string
---@field public gradientDirection string -- "horizontal", "vertical", or "disabled"
---@field public fullHeight boolean? # When true, overlay-capable entries extend through the bar border area vertically

---@class TRB.Classes.Settings.ColorShowEntry : TRB.Classes.Settings.ColorEnabledEntry

---@class TRB.Classes.Settings.EndCapColorEntry : TRB.Classes.Settings.ColorEnabledEntry
---@field public width integer # Fill-axis width of the end cap band in pixels
---@field public useBorderColor boolean # When true, the cap tracks the bar's live border color
---@field public useBorderColorExceptDefault boolean # When true, only non-default border colors override the cap color

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
---@field public fullHeight boolean? # When true, this overlay extends through the bar border area vertically

---@class TRB.Classes.Settings.HealthBarColors
---@field public border TRB.Classes.Settings.ColorEntry
---@field public background TRB.Classes.Settings.ColorEntry
---@field public absorb TRB.Classes.Settings.HealthBarOverlayColorEntry
---@field public incomingHeal TRB.Classes.Settings.HealthBarOverlayColorEntry
---@field public endCap TRB.Classes.Settings.EndCapColorEntry?
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

---@alias trbFillDirection
---| '"leftRight"' # Fill from left to right (default horizontal)
---| '"rightLeft"' # Fill from right to left (reverse horizontal)
---| '"bottomTop"' # Fill from bottom to top (vertical)
---| '"topBottom"' # Fill from top to bottom (reverse vertical)

---@class TRB.Classes.Settings.PrimaryBar
---@field public width number
---@field public height number
---@field public xPos number
---@field public yPos number
---@field public border integer
---@field public fillDirection trbFillDirection # Fill direction for the bar's StatusBar
---@field public anchor TRB.Classes.Settings.BarAnchor? # Only used when this bar is NOT the base bar

---@class TRB.Classes.Settings.SecondaryBar
---@field public width number
---@field public height number
---@field public border integer
---@field public spacing integer
---@field public fillDirection trbFillDirection # Fill direction for the bar's StatusBar
---@field public growthDirection trbFillDirection? # Growth direction for multi-node bars (independent from fill)
---@field public anchor TRB.Classes.Settings.BarAnchor? # New anchor system
---@field public xPos number # @deprecated Use anchor.xOffset instead
---@field public yPos number # @deprecated Use anchor.yOffset instead
---@field public relativeTo string # @deprecated Use anchor.anchorPoint/attachPoint instead
---@field public relativeToName string # @deprecated Display label for legacy relativeTo
---@field public fullWidth boolean # @deprecated Use anchor.matchWidth instead

---How a channel's tick markers scale with haste.
---@alias trbCastbarTickMode
---| '"fixedCount"' # Tick count stays constant; channel duration shrinks with haste (e.g. Mind Flay)
---| '"fixedRate"'  # Channel duration is fixed; tick rate scales with haste, final partial tick (e.g. Void Torrent)
---| '"pandemic"'   # Like fixedCount, but also fires one extra PARTIAL tick at the channel end covering the leftover phase after the last full beat (e.g. Drain Life/Drain Soul/Malefic Grasp)

---Where a fixedCount profile's tick count comes from when it varies per cast.
---@alias trbCastbarTickCountSource
---| '"comboPointsSpent"' # One tick per combo point the finisher consumes (e.g. Killing Spree)

---A built-in or user-configured channel tick profile, stored per spellId under CastbarBar.tickProfiles.
---baseDuration/baseTickRate are UNHASTED seconds; the render scales them by GCD-inferred haste.
---@class TRB.Classes.Settings.CastbarTickProfile
---@field public mode trbCastbarTickMode
---@field public baseDuration number? # Unhasted channel duration in seconds; derived per cast (baseTickRate * tickCount) when tickCountSource is set
---@field public tickCount integer? # fixedCount only: number of ticks across the channel
---@field public baseTickRate number? # fixedRate only: unhasted seconds between ticks. Also fixedCount with tickCountSource, where it only feeds the derived baseDuration
---@field public tickCountSource trbCastbarTickCountSource? # fixedCount only: resolves tickCount at each channel start instead of using a static tickCount
---@field public bonusTicksPerChargedPoint integer? # tickCountSource "comboPointsSpent" only: extra ticks when the finisher spends a supercharged combo point (one per cast, however many are charged)
---@field public firstTickAtStart boolean? # Whether a tick also lands at t=0
---@field public skipTicks integer[]? # Rhythm ticks that never fire (1-based; tick 1 is the one at t=R, excluding any firstTickAtStart mark). Spacing still comes from the full rhythm, e.g. Demolish hits on 3 of a 4-tick rhythm
---@field public chains boolean? # Whether a leftover partial-tick phase carries into a chained channel of the same spell

---Castbar bar settings: SecondaryBar dimensions plus the castbar's behavior flags and per-spell tick
---profiles. Visibility/enabling lives in displayBar.castbar (castbar-specific show/hide conditions).
---@class TRB.Classes.Settings.CastbarBar : TRB.Classes.Settings.SecondaryBar
---@field public showTicks boolean # Draw channel tick lines
---@field public tickWidth number # Width in pixels of channel tick and empower stage boundary lines
---@field public tickLatencyWidth boolean # Widen channel tick marks to the latency fraction (toward higher time remaining) instead of fixed-width lines
---@field public showLatency boolean # Draw the latency safe-zone overlay
---@field public showPushback boolean # Draw the pushback overlay
---@field public showEmpowerStages boolean # Draw empower stage boundary lines
---@field public empowerSegmentedFill boolean # Fill each empower level's segment in its own color at once (vs. recoloring the whole bar)
---@field public castTimePrecision integer # Decimal places (0-3) for $castTimeRemaining
---@field public durationPrecision integer # Decimal places (0-3) for $castTime
---@field public latencyPrecision integer # Decimal places (0-3) for $castLatency and $castPushback
---@field public disableBlizzardCastbar boolean # Detach the default Blizzard cast bar while the addon castbar is enabled
---@field public mergeTradeskill boolean # Merge bulk crafting's repeated craft casts into one channel-style bar
---@field public tickProfiles table<integer, TRB.Classes.Settings.CastbarTickProfile> # Channel tick profiles keyed by spellId

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
---@field public constrainToParent boolean # Clamp the text width to the bound frame (ignored when bound to Screen)
---@field public maxWidthPercent number # Max text width as a percentage (0-100) of the bound frame's width
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
---@field public matchWidth boolean # If true, bar width matches anchor's width
---@field public matchHeight boolean # If true, bar height matches anchor's height

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
---@field public isSkyriding boolean? # Show when mounted on a skyriding-capable mount in a skyriding-enabled area
---@field public isSkyridingFlying boolean? # Show when actively skyriding (mounted, skyriding-capable, and flying)
---@field public isSteadyFlight boolean? # Show when mounted and in real (non-gliding) flight (false while skyriding-gliding)
---@field public isSteadyFlightFlying boolean? # Show when mounted and in real (non-gliding) flight (same as isSteadyFlight; steady flight only exists while airborne)
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
---@field public isDruidHumanoidForm boolean? # Show when the Druid player is in humanoid form
---@field public isDruidTravelFormAny boolean? # Show when the Druid player is in any travel form variant
---@field public isDruidStagForm boolean? # Show when the Druid player is in stag/ground travel form
---@field public isDruidFlightForm boolean? # Show when the Druid player is in steady flight form
---@field public isDruidSwiftFlightForm boolean? # Show when the Druid player is in skyriding flight form
---@field public isDruidAquaticForm boolean? # Show when the Druid player is in aquatic form
---@field public isDruidCatForm boolean? # Show when the Druid player is in cat form
---@field public isDruidBearForm boolean? # Show when the Druid player is in bear form
---@field public isDruidMoonkinForm boolean? # Show when the Druid player is in moonkin form

---@class trbBarVisibilityHideConditions
---@field public isMountedAny boolean? # Hide when the player is mounted (any mount)
---@field public isMountedGround boolean? # Hide when the player is on a ground mount (mounted + not flying)
---@field public isMountedFlying boolean? # Hide when mounted and in real (non-gliding) flight
---@field public isSteadyFlight boolean? # DEPRECATED: migrated to isMountedFlying
---@field public isSteadyFlightFlying boolean? # Hide when mounted and in real (non-gliding) flight (same as isMountedFlying; steady flight only exists while airborne)
---@field public isSkyriding boolean? # Hide when mounted on a skyriding-capable mount in a skyriding-enabled area
---@field public isSkyridingFlying boolean? # Hide when actively skyriding (mounted, skyriding-capable, and flying)
---@field public isDruidHumanoidForm boolean? # Hide when the Druid player is in humanoid form
---@field public isDruidTravelFormAny boolean? # Hide when the Druid player is in any travel form variant
---@field public isDruidStagForm boolean? # Hide when the Druid player is in stag/ground travel form
---@field public isDruidFlightForm boolean? # Hide when the Druid player is in steady flight form
---@field public isDruidSwiftFlightForm boolean? # Hide when the Druid player is in skyriding flight form
---@field public isDruidAquaticForm boolean? # Hide when the Druid player is in aquatic form
---@field public isDruidCatForm boolean? # Hide when the Druid player is in cat form
---@field public isDruidBearForm boolean? # Hide when the Druid player is in bear form
---@field public isDruidMoonkinForm boolean? # Hide when the Druid player is in moonkin form
---@field public inVehicle boolean? # Hide when the player is in a vehicle
---@field public inPetBattle boolean? # Hide when the player is in a pet battle
---@field public onTaxi boolean? # Hide when the player is on a flight path

---@class trbBarVisibilitySetting
---@field public neverShow boolean # When true, the bar is unconditionally hidden regardless of conditions
---@field public alwaysShow boolean # When true, the bar is unconditionally shown (overrides conditions but not neverShow). Independent of individual conditions.
---@field public conditions trbBarVisibilityConditions # OR-combined conditions evaluated when alwaysShow is false
---@field public hideConditions trbBarVisibilityHideConditions # OR-combined hard-hide conditions that override alwaysShow, normal show conditions, and threshold visibility
---@field public smooth boolean
---@field public activeAlpha number # Opacity (0–100) when visibility conditions are met. Default 100.
---@field public inactiveAlpha number # Opacity (0–100) when visibility conditions are NOT met. 0 = fully hidden. Default 0.
---@field public fadeDuration number # Seconds to fade out to inactive opacity. 0 = instant. Default 0.
---@field public fadeDelay number # Seconds to wait before starting the fade out. 0 = immediate. Default 0.
---@field public resourceConditionType string? # Type of threshold condition: "none", "resourcePercent", "resourceValue", "manaPercent", "manaValue", "healthPercent", "healthValue"
---@field public resourceConditionOperator string? # Comparison operator: ">=", ">", "<=", "<", "==", "!="
---@field public resourceConditionValue number? # Threshold value for the selected visibility condition
---@field public visibility trbBarVisibility? # DEPRECATED: Legacy field, migrated to neverShow+conditions

---@class trbBarVisibilityThresholdDefinition
---@field public valueType string # Threshold value interpretation: "percent" or "value"
---@field public powerType number? # Enum.PowerType value used with UnitPowerPercent for power-based thresholds
---@field public maxValue number? # Normalization max for value thresholds

---@alias trbOverlayMode
---| '"overlay"' # Fills from the left edge of the bar up to the overlay amount
---| '"appended"' # Visually appends the overlay region to the right of the current health fill
---| '"appendedOverflow"' # Appended mode that can visually extend beyond the bar's right boundary
---| '"inset"' # Reverse-fill from the health fill's trailing edge going leftward

---@class trbHealthBarVisibilitySetting : trbBarVisibilitySetting

---@alias trbBarColorType
---| '"step"' # Step colors
---| '"linear"' # Linear colors
---| '"none"' # Only use a single color
