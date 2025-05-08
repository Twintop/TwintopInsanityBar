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