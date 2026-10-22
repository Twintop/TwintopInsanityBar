local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Skyriding = TRB.Functions.OptionsUi.Skyriding or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- One builder for every Skyriding bar: Dimensions and Colors, each with its own Use Global row.

---Reapplies layout and appearance so an edit shows at once, recomposing the active spec's cache first since a
---Use Global section rebuilds it.
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
	TRB.Functions.Skyriding:RefreshVisibility()
end

-- Per bar, its fill colors in panel order; the first is the bar's main `bar` fill. An optional color has an
-- enable checkbox on its row.
local fillRows = {
	skyridingSpeed = {
		{ key = "bar", label = L["OtherBarsColorFill"] },
		{ key = "thrillOfTheSkies", label = L["SkyridingColorThrillOfTheSkies"],
			enableLabel = L["SkyridingColorThrillOfTheSkiesEnable"], enableTooltip = L["SkyridingColorThrillOfTheSkiesEnableTooltip"] },
		{ key = "groundSkimming", label = L["SkyridingColorGroundSkimming"],
			enableLabel = L["SkyridingColorGroundSkimmingEnable"], enableTooltip = L["SkyridingColorGroundSkimmingEnableTooltip"] },
	},
	skyridingCharges = {
		{ key = "bar", label = L["SkyridingColorCharge"] },
		{ key = "recharging", label = L["SkyridingColorRechargingCharge"] },
	},
	whirlingSurge = {
		{ key = "bar", label = L["SkyridingColorRecharging"] },
		{ key = "ready", label = L["SkyridingColorReady"] },
		{ key = "unusable", label = L["SkyridingColorLightningRushUnusable"],
			enableLabel = L["SkyridingColorLightningRushUnusableEnable"], enableTooltip = L["SkyridingColorLightningRushUnusableEnableTooltip"] },
	},
	secondWind = {
		{ key = "bar", label = L["SkyridingColorCharge"] },
		{ key = "recharging", label = L["SkyridingColorRechargingCharge"] },
	},
}

---Constructs the options for one Skyriding bar within a spec.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param barKey string # "skyridingSpeed", "skyridingCharges", "whirlingSurge" or "secondWind"
function TRB.Functions.OptionsUi.Skyriding:ConstructPanel(parent, classId, specId, barKey)
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
	local colors = spec.colors and spec.colors.bars and spec.colors.bars[barKey]
	if barDef == nil or spec.bars == nil or spec.bars[barKey] == nil or colors == nil then
		return
	end

	local controlsKey = (classId == nil) and "core" or (classNameLower .. "_" .. specName)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[controlsKey] = interfaceSettingsFrame.controls[controlsKey] or {}
	local controls = interfaceSettingsFrame.controls[controlsKey]
	controls[barKey] = controls[barKey] or {}
	local cc = controls[barKey]
	cc.fill = {}

	local yCoord = 5
	local dimensionsKey = barKey .. "Dimensions"
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, barDef.displayName, dimensionsKey)
	-- The row looks its tooltip up by a built name, which the orphan scan can't see, so it gets a literal one.
	local dimensionsCheckbox = controls.checkBoxes and controls.checkBoxes["useGlobal" .. dimensionsKey:gsub("^%l", string.upper)]
	if dimensionsCheckbox ~= nil then
		dimensionsCheckbox.tooltip = L["CheckboxUseGlobalTooltipSkyridingDimensions"]
	end
	yCoord = yCoord - 60

	controls[barKey .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OtherBarsColorsHeader"], oUi.xCoord, yCoord)
	local colorsCheckbox
	yCoord, colorsCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, barKey .. "Colors", yCoord, { tooltip = L["CheckboxUseGlobalTooltipSkyriding"] })
	for _, row in ipairs(fillRows[barKey]) do
		yCoord = yCoord - 30
		local key = row.key
		if row.enableLabel ~= nil then
			TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, "TwintopResourceBar_" .. controlsKey .. "_" .. barKey .. "_" .. key .. "Enable", row.enableLabel, row.enableTooltip, yCoord,
				function() return colors[key].enabled end, function(v) colors[key].enabled = v ReapplyBars() end)
		end
		TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorRow(parent, cc.fill, colors, key, row.label, yCoord, classId, specId, ReapplyBars)
	end
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId, ReapplyBars)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId, ReapplyBars)
	-- These bars have no Color Indicators, so a border color is never anything but its default.
	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colors, controlsKey .. "_" .. barKey, "endCap_" .. barKey, L["EndCap"], classId, specId,
		{ hideExceptDefault = true })
	if colors.passiveSpeedCap ~= nil then
		yCoord = yCoord - 20
		yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colors, controlsKey .. "_" .. barKey .. "_passiveSpeedCap", "passiveSpeedCap_" .. barKey,
			L["SkyridingColorPassiveSpeedCap"], classId, specId, {
				entryKey = "passiveSpeedCap",
				enabledLabel = L["SkyridingColorPassiveSpeedCapEnable"],
				enabledTooltip = L["SkyridingColorPassiveSpeedCapEnableTooltip"],
				useBorderColorTooltip = L["SkyridingPassiveSpeedCapUseBorderColorTooltip"],
				widthLabel = L["ThresholdDetailLineWidth"],
				hideExceptDefault = true,
			})
	end
	yCoord = yCoord - 40
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(colorsCheckbox, controls[barKey .. "ColorSection"], yCoord)

	return yCoord
end
