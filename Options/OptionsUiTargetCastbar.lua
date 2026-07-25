---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.TargetCastbar = TRB.Functions.OptionsUi.TargetCastbar or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

--[[
	Target/Focus Cast Bar options panel. One builder, parameterized by unitKey ("targetCastbar" /
	"focusCastbar"). Edits the given spec's per-spec settings, or core when classId/specId are nil. Per-
	section "Use Global" toggles mirror the player cast bar -- Dimensions, Colors, and Empower each copy
	their slice from core independently. Secret-safe render, so there are no tick/latency/pushback overlay controls -- only the
	elements the secret-safe path supports: fill/name/icon/countdown/cast-time, interrupt color, and
	empower stage boundary lines (stage percentages come back plain even for a secret cast).
]]

---Reapplies layout + appearance so option changes show immediately. Recomposes the active spec's cache
---first: the render reads the composed cache, whose target/focus bar tables are rebuilt fresh (and thus
---disconnected from the raw settings just edited) whenever any Use Global category is on -- so a raw edit
---only reaches the render after a re-fill. The re-fill is also what carries a global/core edit down to the
---active spec. Without it, bar-setting edits (precision, class color, empower) silently no-op.
local function ReapplyBars()
	local char = TRB.Data.character
	if char ~= nil and char.className ~= nil and char.specName ~= nil
		and char.compositeKey ~= nil and TRB.Data.specCache[char.compositeKey] ~= nil then
		TRB.Functions.Character:FillSpecializationCacheSettings(char.className, char.specName)
		if TRB.Frames.barGroups ~= nil then
			local settings = TRB.Data.specCache[char.compositeKey].settings
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		end
	end
	TRB.Data.lookupDirty = true
end

---Builds one section's global-settings row: a "Use global settings" checkbox with shortcut link and
---Copy... button on spec panels, or a bulk all-specs toggle (with Copy...) on the Global panel. Keyed
---by the per-section setting (e.g. "targetCastbarColors"). Mirrors the player cast bar's rows.
---@return number yCoord
local function BuildUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, settingKey, yCoord)
	local settingKeyUpper = settingKey:gsub("^%l", string.upper)
	if classId ~= nil then
		yCoord = yCoord - 30
		local classToken = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		controls.checkBoxes = controls.checkBoxes or {}
		local cb = CreateFrame("CheckButton", "TwintopResourceBar_" .. classToken .. "_" .. specName .. "_useGlobal_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
		controls.checkBoxes["useGlobal" .. settingKeyUpper] = cb
		cb:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		local settingDef = TRB.Functions.OptionsUi.GlobalSettings:GetGlobalSettingDefinition(settingKey)
		getglobal(cb:GetName() .. 'Text'):SetText(settingDef and settingDef.useGlobalLabel or L["CheckboxUseGlobal"])
		getglobal(cb:GetName() .. 'Text'):SetTextColor(100/255, 225/255, 200/255)
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(cb, "castbar", "castbar")
		cb.tooltip = L["CheckboxUseGlobalTooltip_" .. settingKeyUpper]
		cb:SetChecked(TRB.Data.settings.core.global[classNameLower][specName][settingKey])
		cb:SetScript("OnClick", function(self)
			TRB.Data.settings.core.global[classNameLower][specName][settingKey] = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(classNameLower, specName)
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
			TRB.Data.lookupDirty = true
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(settingKey)
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(cb, classId, specId, settingKey)
	else
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKeyUpper, settingKey, yCoord)
	end
	return yCoord
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

	-- Dimensions / anchoring (standalone screen-anchored root by default). Per-section "Use Global" toggles
	-- mirror the player cast bar: this one covers Dimensions (position/size/icon); Colors and Empower each
	-- have their own below (see the <unit>CastbarDimensions/Colors/Empower global-setting definitions).
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, resourceLabel, unitKey .. "Dimensions")
	yCoord = yCoord - 60

	-- Side ability icon.
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarIconOptions(parent, controls, spec, classId, specId, yCoord, barDef)
	yCoord = yCoord - 20

	-- Colors: fill/interrupt/border/background, under the "Colors" per-section global toggle. Optional
	-- colors follow the standard row layout -- enable checkbox in the left column, color swatch in the
	-- right -- like the player cast bar's overlay colors; always-applied colors are plain swatch rows.
	-- (Spell name / cast time / remaining are shown via the standard Bar Text editor anchored to this bar.)
	controls[unitKey .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["TargetCastbarColorsHeader"], oUi.xCoord, yCoord)
	yCoord = BuildUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, unitKey .. "Colors", yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "bar", L["CastbarColorCast"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "channel", L["CastbarColorChannel"], yCoord, classId, specId)
	yCoord = yCoord - 30

	-- Interrupt coloring: enable checkbox + uninterruptible fill swatch on one row; the hostile-only
	-- modifier nests below it (indented, tighter gap) and is disabled while interrupt coloring is off; the
	-- uninterruptible border swatch (gated by the same enable) shares the modifier's row.
	local interruptHostileCb
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_interruptColor", L["TargetCastbarInterruptColor"], L["TargetCastbarInterruptColorTooltip"], yCoord,
		function() return barSettings.interruptColor end,
		function(v)
			barSettings.interruptColor = v
			if interruptHostileCb ~= nil then
				TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(interruptHostileCb, v)
			end
			ReapplyBars()
		end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "uninterruptible", L["CastbarColorUninterruptible"], yCoord, classId, specId)
	-- Hostile-only modifier: nested 20px below the parent checkbox and indented 20px right. It does NOT
	-- advance the swatch grid, so the border swatch keeps its normal 30px spacing below the fill swatch.
	interruptHostileCb = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_interruptHostileOnly", L["TargetCastbarInterruptHostileOnly"], L["TargetCastbarInterruptHostileOnlyTooltip"], yCoord - 20,
		function() return barSettings.interruptHostileOnly end, function(v) barSettings.interruptHostileOnly = v; ReapplyBars() end)
	interruptHostileCb:ClearAllPoints()
	interruptHostileCb:SetPoint("TOPLEFT", oUi.xCoord + 20, yCoord - 20)
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(interruptHostileCb, barSettings.interruptColor ~= false)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "uninterruptibleBorder", L["CastbarColorUninterruptibleBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId)
	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colors, controlsKey .. "_" .. unitKey, "endCap_" .. unitKey, L["EndCap"], classId, specId)
	yCoord = yCoord - 40

	-- Empower: distinct fill color for empowered casts + stage boundary lines, under the "Empower"
	-- per-section global toggle. Stage-lines row = enable checkbox + line-color swatch; width slider below.
	controls[unitKey .. "EmpowerSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["TargetCastbarEmpowerHeader"], oUi.xCoord, yCoord)
	yCoord = BuildUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, unitKey .. "Empower", yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "empower", L["CastbarColorEmpower"], yCoord, classId, specId)
	yCoord = yCoord - 30
	local empowerWidthSlider
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_showEmpowerStages", L["TargetCastbarShowEmpowerStages"], L["TargetCastbarShowEmpowerStagesTooltip"], yCoord,
		function() return barSettings.showEmpowerStages end,
		function(v)
			barSettings.showEmpowerStages = v
			if empowerWidthSlider ~= nil then
				TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(empowerWidthSlider, v)
			end
			ReapplyBars()
		end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "empowerStageLine", L["TargetCastbarEmpowerStageLineColor"], yCoord, classId, specId)
	yCoord = yCoord - 40
	empowerWidthSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["TargetCastbarEmpowerStageLineWidth"], 1, 10, barSettings.empowerStageLineWidth, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	cc.empowerStageLineWidth = empowerWidthSlider
	empowerWidthSlider:SetScript("OnValueChanged", function(sliderFrame, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
		barSettings.empowerStageLineWidth = value
		ReapplyBars()
	end)
	TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(empowerWidthSlider, barSettings.showEmpowerStages ~= false)
	yCoord = yCoord - 50

	-- Additional Settings: color the fill by the monitored unit's class color + cast time/duration text
	-- precision, under their own per-section global toggle (same layout as the player cast bar's section).
	local unitNoun = (unitKey == "focusCastbar") and L["ResourceFocus"] or L["ResourceTarget"]
	controls[unitKey .. "AdditionalSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarTimersHeader"], oUi.xCoord, yCoord)
	yCoord = BuildUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, unitKey .. "Text", yCoord)
	yCoord = yCoord - 30

	-- Class color: recolor the fill by the monitored unit's class (enemy players by default). Two indented
	-- sub-options gate it to PvP contexts and extend it to friendly players; both gray out while off.
	local classColorSubs = {}
	local function RefreshClassColorStates()
		local enabled = barSettings.classColor == true
		for _, cb in ipairs(classColorSubs) do
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(cb, enabled)
		end
	end
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_classColor", string.format(L["TargetCastbarClassColor"], unitNoun), string.format(L["TargetCastbarClassColorTooltip"], unitNoun, unitNoun), yCoord,
		function() return barSettings.classColor end,
		function(v)
			barSettings.classColor = v
			ReapplyBars()
			RefreshClassColorStates()
		end)
	yCoord = yCoord - 20
	local pvpOnlyCb = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_classColorPvpOnly", L["CastbarTargetClassColorPvpOnly"], L["CastbarTargetClassColorPvpOnlyTooltip"], yCoord,
		function() return barSettings.classColorPvpOnly end,
		function(v) barSettings.classColorPvpOnly = v; ReapplyBars() end)
	pvpOnlyCb:SetPoint("TOPLEFT", oUi.xCoord + 20, yCoord)
	classColorSubs[#classColorSubs + 1] = pvpOnlyCb
	yCoord = yCoord - 20
	local friendlyCb = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_classColorFriendly", L["TargetCastbarClassColorFriendly"], string.format(L["TargetCastbarClassColorFriendlyTooltip"], unitNoun), yCoord,
		function() return barSettings.classColorFriendly end,
		function(v) barSettings.classColorFriendly = v; ReapplyBars() end)
	friendlyCb:SetPoint("TOPLEFT", oUi.xCoord + 20, yCoord)
	classColorSubs[#classColorSubs + 1] = friendlyCb
	RefreshClassColorStates()
	yCoord = yCoord - 40

	-- Cast time + duration decimal precision (0-3), side by side.
	local function BuildPrecisionSlider(label, key, xCoord)
		local slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, label, 0, 3, barSettings[key], 1, 0,
			oUi.sliderWidth, oUi.sliderHeight, xCoord, yCoord)
		slider:SetScript("OnValueChanged", function(sliderFrame, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			sliderFrame.EditBox:SetText(value)
			barSettings[key] = value
			ReapplyBars()
		end)
		return slider
	end
	cc.castTimePrecision = BuildPrecisionSlider(L["CastbarCastTimePrecision"], "castTimePrecision", oUi.xCoord)
	cc.durationPrecision = BuildPrecisionSlider(L["CastbarDurationPrecision"], "durationPrecision", oUi.xCoord2)
	yCoord = yCoord - 60

	return yCoord
end
