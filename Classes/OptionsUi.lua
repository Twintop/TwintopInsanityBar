---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.OptionsUi = TRB.Classes.OptionsUi or {}

---@class TRB.Classes.OptionsUi.Color
---@field public name string
---@field public colorLocalization string
---@field public colorScript function?
---@field public hasEnabledCheckbox boolean?
---@field public enabledCheckboxLocalization string?
---@field public enabledCheckboxTooltipLocalization string?

---A single flat or gradient indicator definition for the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.IndicatorDef
---@field public key string Indicator key matching the entry in colors.shared.indicatorColors
---@field public label string Localized checkbox/dropdown display name
---@field public tooltip string Localized tooltip text (bar-agnostic)
---@field public colorLabel string Localized color picker label (bar-agnostic)

---A bar target that indicators can be assigned to.
---@class TRB.Classes.OptionsUi.BarTargetDef
---@field public key string Bar key (e.g., "furyBar", "insanityBar", "manaBar")
---@field public label string Localized bar display name

---End-of-buff configuration for a single buff tracked by the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.EndOfConfig
---@field public endOfKey string Key matching endOf.* in spec settings
---@field public sectionHeader string Localized section header text
---@field public gcdRadioLabel string Localized label for the GCD radio button
---@field public gcdSliderLabel string Localized label for the GCD slider
---@field public timeRadioLabel string Localized label for the time radio button
---@field public timeSliderLabel string Localized label for the time slider

---Overcap configuration for the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.OvercapConfig
---@field public primaryResourceString string Localized primary resource name (e.g., L["ResourceFury"])
---@field public primaryResourceMax number Maximum value of the primary resource

---Configuration for GenerateIndicatorColorsPanel.
---@class TRB.Classes.OptionsUi.IndicatorColorsPanelConfig
---@field public indicatorDefs TRB.Classes.OptionsUi.IndicatorDef[] Flat indicator definitions
---@field public gradientDefs TRB.Classes.OptionsUi.IndicatorDef[]? Gradient indicator definitions (default: {})
---@field public barTargetDefs TRB.Classes.OptionsUi.BarTargetDef[] Bar targets
---@field public excludedElements table<string, table<string, boolean>>? Map of barKey -> { elementKey = true } to exclude from ALL indicator dropdowns (flat and gradient)
---@field public gradientExcludedElements table<string, table<string, boolean>>? Map of barKey -> { elementKey = true } to exclude from gradient dropdowns only
---@field public ddNamePrefix string Unique prefix for dropdown frame names (e.g., "TwintopResourceBar_Priest_Shadow")
---@field public endOfConfigs TRB.Classes.OptionsUi.EndOfConfig[]? List of EndOf configuration entries
---@field public overcapConfig TRB.Classes.OptionsUi.OvercapConfig? Overcap configuration
TRB.Classes.OptionsUi.IndicatorColorsPanelConfig = {}
TRB.Classes.OptionsUi.IndicatorColorsPanelConfig.__index = TRB.Classes.OptionsUi.IndicatorColorsPanelConfig

---Creates a new IndicatorColorsPanelConfig.
---@param data TRB.Classes.OptionsUi.IndicatorColorsPanelConfig
---@return TRB.Classes.OptionsUi.IndicatorColorsPanelConfig
function TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New(data)
	local obj = setmetatable({}, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig)
	obj.indicatorDefs = data.indicatorDefs
	obj.gradientDefs = data.gradientDefs
	obj.barTargetDefs = data.barTargetDefs
	obj.excludedElements = data.excludedElements
	obj.gradientExcludedElements = data.gradientExcludedElements
	obj.ddNamePrefix = data.ddNamePrefix
	obj.endOfConfigs = data.endOfConfigs
	obj.overcapConfig = data.overcapConfig
	return obj
end