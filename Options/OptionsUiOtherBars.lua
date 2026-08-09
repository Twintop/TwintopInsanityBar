---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.OtherBars = TRB.Functions.OptionsUi.OtherBars or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

--[[
	Other Bars options panel. One builder, parameterized by barKey ("gcd" / "fatigue" / "breath" /
	"feignDeath"). Edits the given spec's per-spec settings, or core when classId/specId are nil.
	Per-section "Use Global" toggles mirror the cast bars: Dimensions and Colors each copy their
	slice from core independently.

	These bars have no icon, no overlays and no cast states -- a timer runs or it doesn't -- so the panel
	is just dimensions, colors, and the one behaviour option each kind needs.
]]

---Reapplies layout + appearance so option changes show immediately. Recomposes the active spec's cache
---first, for the same reason the cast bar panels do: the render reads the composed cache, which is
---rebuilt fresh whenever a Use Global category is on, so a raw edit only lands after a re-fill.
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
	TRB.Functions.OtherBars:RefreshVisibility()
end

---Builds one section's global-settings row: a "Use global settings" checkbox with shortcut link and
---Copy... button on spec panels, or a bulk all-specs toggle (with Copy...) on the Global panel. Mirrors
---the cast bar panels' rows.
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
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(cb, settingDef and settingDef.tabKey or "gcd", "otherBars")
		cb.tooltip = L["CheckboxUseGlobalTooltipOtherBars"]
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

---Constructs the appearance options for one Other Bar within a spec.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param barKey string # "gcd", "fatigue", "breath" or "feignDeath"
function TRB.Functions.OptionsUi.OtherBars:ConstructPanel(parent, classId, specId, barKey)
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

	local barDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(barKey)
	local barSettings = spec.bars and spec.bars[barKey]
	local colors = spec.colors and spec.colors.bars and spec.colors.bars[barKey]
	if barDef == nil or barSettings == nil or colors == nil then
		return
	end

	local controlsKey = (classId == nil) and "core" or (classNameLower .. "_" .. specName)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[controlsKey] = interfaceSettingsFrame.controls[controlsKey] or {}
	local controls = interfaceSettingsFrame.controls[controlsKey]
	controls[barKey] = controls[barKey] or {}
	local cc = controls[barKey]
	cc.fill = {}

	local namePrefix = "TwintopResourceBar_" .. controlsKey .. "_" .. barKey
	local yCoord = 5

	-- A class-scoped bar (Feign Death) has no global counterpart, so it gets no Use Global rows -- its
	-- specs own it outright. Every other Other Bar has the usual Dimensions / Colors global sections.
	local hasGlobalScope = TRB.Classes.BarTypeRegistry:IsGlobalScopeBar(barKey)

	-- Dimensions / anchoring. Fatigue is a screen-anchored root by default and the other mirror timers
	-- chain below it, but every one of them is freely re-anchorable here.
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, barDef.displayName, hasGlobalScope and (barKey .. "Dimensions") or nil)
	yCoord = yCoord - 60

	-- Colors: fill / border / background / end cap.
	controls[barKey .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OtherBarsColorsHeader"], oUi.xCoord, yCoord)
	if hasGlobalScope then
		yCoord = BuildUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, barKey .. "Colors", yCoord)
	end
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "bar", L["OtherBarsColorFill"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId)
	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colors, controlsKey .. "_" .. barKey, "endCap_" .. barKey, L["EndCap"], classId, specId)
	yCoord = yCoord - 40

	-- Behaviour: one option each. The GCD picks its fill direction; a mirror timer decides whether to
	-- take Blizzard's own bar off screen.
	controls[barKey .. "BehaviorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OtherBarsBehaviorHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	if barKey == "gcd" then
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_timerDirection", L["GcdBarGrowInstead"], L["GcdBarGrowInsteadTooltip"], yCoord,
			function() return barSettings.timerDirection == "fill" end,
			function(v)
				barSettings.timerDirection = v and "fill" or "deplete"
				ReapplyBars()
			end)
	else
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_disableBlizzardBar", L["MirrorTimerDisableBlizzard"], L["MirrorTimerDisableBlizzardTooltip"], yCoord,
			function() return barSettings.disableBlizzardBar end,
			function(v)
				barSettings.disableBlizzardBar = v
				ReapplyBars()
				TRB.Functions.OtherBars:UpdateBlizzardMirrorTimerVisibility()
			end)
	end
	yCoord = yCoord - 40

	-- Decimal places for the GCD's $gcdDuration / $gcdDurationRemaining bar text variables. The mirror
	-- timers run for minutes and render as mm:ss, so they have no decimals to configure.
	if barKey == "gcd" then
		cc.durationPrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["OtherBarsDurationPrecision"], 0, 3, barSettings.durationPrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		cc.durationPrecision:SetScript("OnValueChanged", function(sliderFrame, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			sliderFrame.EditBox:SetText(value)
			barSettings.durationPrecision = value
			ReapplyBars()
		end)
		yCoord = yCoord - 60
	end

	return yCoord
end
