---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.TargetCastbar = TRB.Functions.OptionsUi.TargetCastbar or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

--[[
	Target/Focus Cast Bar options panel. One builder, parameterized by unitKey ("targetCastbar" /
	"focusCastbar"). Edits the given spec's per-spec settings directly (no use-global copy layer yet).
	Secret-safe render, so there are no tick/latency/pushback/empower overlay controls -- only the
	elements the secret-safe path supports: fill/name/icon/countdown/cast-time and interrupt color.
]]

---Reapplies layout + appearance so option changes show immediately.
local function ReapplyBars()
	if TRB.Frames.barGroups ~= nil and TRB.Data.character.compositeKey
		and TRB.Data.specCache[TRB.Data.character.compositeKey] then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
	end
	TRB.Data.lookupDirty = true
end

---Constructs the appearance options for one unit's cast bar within a spec.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param unitKey string # "targetCastbar" or "focusCastbar"
function TRB.Functions.OptionsUi.TargetCastbar:ConstructPanel(parent, classId, specId, unitKey)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec
	if classId == nil then
		spec = TRB.Data.settings.core
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
	end
	if spec == nil then
		return
	end

	local barDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(unitKey)
	local barSettings = spec.bars and spec.bars[unitKey]
	local colors = spec.colors and spec.colors.bars and spec.colors.bars[unitKey]
	if barDef == nil or barSettings == nil or colors == nil then
		return
	end

	local controlsKey = (classId == nil) and "core" or (classNameLower .. "_" .. specName)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[controlsKey] = interfaceSettingsFrame.controls[controlsKey] or {}
	local controls = interfaceSettingsFrame.controls[controlsKey]
	controls[unitKey] = controls[unitKey] or {}
	local cc = controls[unitKey]
	cc.fill = {}

	local namePrefix = "TwintopResourceBar_" .. controlsKey .. "_" .. unitKey
	local resourceLabel = (unitKey == "focusCastbar") and L["ResourceFocusCastbar"] or L["ResourceTargetCastbar"]
	local yCoord = 5

	-- Dimensions / anchoring (standalone screen-anchored root by default). No use-global key.
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, resourceLabel)
	yCoord = yCoord - 60

	-- Side ability icon.
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarIconOptions(parent, controls, spec, classId, specId, yCoord, barDef)
	yCoord = yCoord - 20

	-- Interrupt coloring (spell name / cast time / remaining are shown via the standard Bar Text editor,
	-- anchored to this bar).
	controls[unitKey .. "InterruptSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["TargetCastbarInterruptHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_interruptColor", L["TargetCastbarInterruptColor"], L["TargetCastbarInterruptColorTooltip"], yCoord,
		function() return barSettings.interruptColor end, function(v) barSettings.interruptColor = v; ReapplyBars() end)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_interruptHostileOnly", L["TargetCastbarInterruptHostileOnly"], L["TargetCastbarInterruptHostileOnlyTooltip"], yCoord,
		function() return barSettings.interruptHostileOnly end, function(v) barSettings.interruptHostileOnly = v; ReapplyBars() end)
	yCoord = yCoord - 40

	-- Fill / border colors.
	controls[unitKey .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["TargetCastbarColorsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "bar", L["CastbarColorCast"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "channel", L["CastbarColorChannel"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "uninterruptible", L["CastbarColorUninterruptible"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId)
	yCoord = yCoord - 40

	return yCoord
end
