local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Thresholds = TRB.Functions.OptionsUi.Thresholds or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Threshold option panels
-- ============================================================================

---The choices for how a charge spell's recharge draws on its icon while charges are left.
---@return { value: string, label: string }[]
function TRB.Functions.OptionsUi.Thresholds:GetIconRechargeModeOptions()
	return {
		{ value = "full", label = L["ThresholdIconRechargeModeFull"] },
		{ value = "edge", label = L["ThresholdIconRechargeModeEdge"] },
		{ value = "hidden", label = L["ThresholdIconRechargeModeHidden"] },
	}
end

---Generates the threshold line icon position and dimension options panel, including icon size, border, position, threshold line width, and overlap settings.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing threshold icon configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	yCoord = yCoord - 30
	controls.abilityThresholdSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdLinePositionHeader"], oUi.xCoord, yCoord)
	local sectionHeader = controls.abilityThresholdSection

	local useGlobalCheckbox = nil
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdIcons = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdIcons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdIcons
		useGlobalCheckbox = f
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdIcons"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("thresholdIcons")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "thresholdIcons")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdIcons", "thresholdIcons", yCoord)
	end

	yCoord = yCoord - 20
	local thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconRelativeTo", parent, "WowStyle1DropdownTemplate")
	thresholdIconRelativeTo:SetWidth(oUi.sliderWidth)
	thresholdIconRelativeTo.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdIconRelativePosition"], oUi.xCoord, yCoord)
	thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)

	local relativeTo = {}
	relativeTo[L["ThresholdIconPositionAboveLeft"]] = "TOP"
	relativeTo[L["PositionMiddle"]] = "CENTER"
	relativeTo[L["ThresholdIconPositionBelowRight"]] = "BOTTOM"
	local relativeToList = {
		L["ThresholdIconPositionAboveLeft"],
		L["PositionMiddle"],
		L["ThresholdIconPositionBelowRight"]
	}
	for label, value in pairs(relativeTo) do
		if value == spec.thresholds.icons.relativeTo then
			thresholdIconRelativeTo:SetDefaultText(label)
			break
		end
	end

	local function RelativeToIsSelected(value)
		return value == spec.thresholds.icons.relativeTo
	end

	local function RelativeToSetSelected(newValue)
		spec.thresholds.icons.relativeTo = newValue

		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec.thresholds.icons.relativeToName = k
				break
			end
		end
		thresholdIconRelativeTo:SetDefaultText(spec.thresholds.icons.relativeToName)

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	thresholdIconRelativeTo:SetupMenu(RelativeToGenerator)
	thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShow"])
	f.tooltip = L["ThresholdIconShowTooltip"]
	f:SetChecked(spec.thresholds.icons.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.enabled = self:GetChecked()

		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)
		controls.refreshThresholdIconCooldownStates()

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconDesaturated
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconDesaturate"])
	f.tooltip = L["ThresholdIconDesaturateTooltip"]
	f:SetChecked(spec.thresholds.icons.desaturated)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.desaturated = self:GetChecked()

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

	yCoord = yCoord - 100
	title = L["ThresholdIconWidth"]
	controls.thresholdIconWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.width = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.thresholds.icons.border)

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconHeight"]
	controls.thresholdIconHeight = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.height = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.thresholds.icons.border)

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)


	title = L["ThresholdIconHorizontal"]
	yCoord = yCoord - 60
	controls.thresholdIconHorizontal = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.xPos = value

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconVertical"]
	controls.thresholdIconVertical = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.yPos = value

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

	title = L["ThresholdIconBorderWidth"]
	yCoord = yCoord - 60
	controls.thresholdIconBorderWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.border = value

		local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
		local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

		controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
		controls.thresholdIconHeight.MinLabel:SetText(tostring(minsliderHeight))
		controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
		controls.thresholdIconWidth.MinLabel:SetText(tostring(minsliderWidth))

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdLineWidth"]
	controls.thresholdWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 1, 10, spec.thresholds.properties.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.properties.width = value

		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.properties.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.properties.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines()
	end)

	controls.checkBoxes.thresholdIconExtendLine = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdIconExtendLine", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconExtendLine
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconExtendLine"])
	f.tooltip = L["ThresholdIconExtendLineTooltip"]
	f:SetChecked(spec.thresholds.icons.extendLineToIcon)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.extendLineToIcon = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines()
	end)

	local function RedrawIfLive()
		if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end

	local function RefreshOverlapControlStates()
		local mode = spec.thresholds.icons.overlapMode
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls.thresholdIconOverlapSpacing, mode ~= "off")
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls.thresholdIconOverlapMaxRows, mode == "stagger")
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls.thresholdIconOverlapAllowance, mode ~= "off")
	end

	yCoord = yCoord - 20
	local overlapModeOptions = {
		{ value = "off", label = L["ThresholdIconOverlapModeOff"] },
		{ value = "stagger", label = L["ThresholdIconOverlapModeStagger"] },
		{ value = "topOnly", label = L["ThresholdIconOverlapModeTopOnly"] },
	}
	controls.thresholdIconOverlapMode = TRB.Functions.OptionsUi.Primitives:BuildDropdown(parent, "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconOverlapMode", L["ThresholdIconOverlapMode"], overlapModeOptions,
		function() return spec.thresholds.icons.overlapMode end,
		function(value)
			spec.thresholds.icons.overlapMode = value
			RefreshOverlapControlStates()
			RedrawIfLive()
		end,
		oUi.xCoord, yCoord)

	controls.thresholdIconOverlapSpacing = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["ThresholdIconOverlapSpacing"], 0, 20, spec.thresholds.icons.overlapSpacing, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord - 30)
	controls.thresholdIconOverlapSpacing:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.overlapSpacing = value
		RedrawIfLive()
	end)

	yCoord = yCoord - 80
	controls.thresholdIconOverlapMaxRows = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["ThresholdIconOverlapMaxRows"], 1, 10, spec.thresholds.icons.overlapMaxRows, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconOverlapMaxRows:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.overlapMaxRows = value
		RedrawIfLive()
	end)

	controls.thresholdIconOverlapAllowance = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["ThresholdIconOverlapAllowance"], 0, 90, spec.thresholds.icons.overlapAllowance, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconOverlapAllowance:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.overlapAllowance = value
		RedrawIfLive()
	end)

	RefreshOverlapControlStates()

	local function RefreshCooldownControlStates()
		local icons = spec.thresholds.icons
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconShowCooldown, icons.enabled)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconShowCooldownText, icons.enabled)
		TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(controls.thresholdIconRechargeMode, icons.enabled and (icons.showCooldown or icons.showCooldownText))
	end
	controls.refreshThresholdIconCooldownStates = RefreshCooldownControlStates

	yCoord = yCoord - 40
	controls.checkBoxes.thresholdIconShowCooldown = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconShowCooldown", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconShowCooldown
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShowCooldown"])
	f.tooltip = L["ThresholdIconShowCooldownTooltip"]
	f:SetChecked(spec.thresholds.icons.showCooldown)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.showCooldown = self:GetChecked()
		RefreshCooldownControlStates()
		RedrawIfLive()
	end)

	controls.checkBoxes.thresholdIconShowCooldownText = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconShowCooldownText", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconShowCooldownText
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShowCooldownText"])
	f.tooltip = L["ThresholdIconShowCooldownTextTooltip"]
	f:SetChecked(spec.thresholds.icons.showCooldownText)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.showCooldownText = self:GetChecked()
		RefreshCooldownControlStates()
		RedrawIfLive()
	end)

	yCoord = yCoord - 20
	controls.thresholdIconRechargeMode =TRB.Functions.OptionsUi.Primitives:BuildDropdown(parent, "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconRechargeMode", L["ThresholdIconRechargeMode"], TRB.Functions.OptionsUi.Thresholds:GetIconRechargeModeOptions(),
		function() return spec.thresholds.icons.rechargeMode end,
		function(value)
			spec.thresholds.icons.rechargeMode = value
			RedrawIfLive()
		end,
		oUi.xCoord, yCoord)

	RefreshCooldownControlStates()

	-- The returned row is the recharge dropdown's label, so the cover reaches past the dropdown below it.
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(useGlobalCheckbox, sectionHeader, yCoord - 60)

	return yCoord
end

---Generates Threshold Line color options for the specialization, including custom colors if provided.
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer?
---@param specId integer?
---@param yCoord number
---@param localizationResource string
---@param under boolean?
---@param over boolean?
---@param unusable boolean?
---@param outOfRange boolean?
---@param custom TRB.Classes.OptionsUi.Color[]?
---@return number
function TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, classId, specId, yCoord, localizationResource, under, over, unusable, outOfRange, custom)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.colors.threshold = controls.colors.threshold or {}

	controls.abilityThresholdSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)

	local sectionHeader = controls.abilityThresholdSection
	local useGlobalCheckbox = nil
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		useGlobalCheckbox = f
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) then
				TRB.Functions.Character:RefreshSpellRangeCheckUpdate()
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("thresholdColors")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "thresholdColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdColors", "thresholdColors", yCoord)
	end

	-- The cover stops above the first custom color that stays per spec.
	local globalRowsBottomY = nil

	-- Threshold Color Indicators show these colors, on this spec or every spec using Global Options.
	local function SyncIndicatorColors()
		TRB.Functions.Threshold:SyncAllIndicatorColors()
	end

	if under == true then
		yCoord = yCoord - 30
		controls.colors.threshold.under = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], localizationResource), spec.colors.threshold.under.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under", nil, nil, nil, nil, SyncIndicatorColors)
		end)
		globalRowsBottomY = yCoord - 30
	end

	if over == true then
		yCoord = yCoord - 30
		controls.colors.threshold.over = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], localizationResource), spec.colors.threshold.over.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over", nil, nil, nil, nil, SyncIndicatorColors)
		end)
		globalRowsBottomY = yCoord - 30
	end

	if unusable == true then
		yCoord = yCoord - 30
		controls.colors.threshold.unusable = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ThresholdUnusable"], spec.colors.threshold.unusable.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable", nil, nil, nil, nil, SyncIndicatorColors)
		end)
		globalRowsBottomY = yCoord - 30
	end

	if outOfRange == true then
		yCoord = yCoord - 30
		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord+10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeShowCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeShowCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.show)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.show = self:GetChecked()

			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)
			-- Global colors can reach the live spec through a form's spec too, so the Global panel always refreshes.
			if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or (classId == nil and specId == nil) then
				TRB.Functions.Character:RefreshSpellRangeCheckUpdate()
			end
		end)

		controls.checkBoxes.thresholdOutOfRangeColorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRangeColorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRangeColorEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.enabled = self:GetChecked()
			-- Global colors can reach the live spec through a form's spec too, so the Global panel always refreshes.
			if TRB.Functions.Character:IsPanelForLiveSpec(classId, specId) or (classId == nil and specId == nil) then
				TRB.Functions.Character:RefreshSpellRangeCheckUpdate()
			end
		end)

		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange", nil, nil, nil, nil, SyncIndicatorColors)
		end)
		globalRowsBottomY = yCoord - 30
	end

	if custom ~= nil and #custom > 0 then
		local specRowBuilt = false
		for _, value in ipairs(custom) do
			yCoord, _, _ = TRB.Functions.OptionsUi.ColorPickers:BuildColorPickerWithEnable(parent, yCoord, controls, "threshold", spec.colors.threshold, namePrefix, value)
			specRowBuilt = specRowBuilt or not tContains(TRB.Data.constants.globalThresholdColorKeys, value.name)
			if not specRowBuilt then
				globalRowsBottomY = yCoord - 30
			end
		end
	end

	if globalRowsBottomY ~= nil then
		TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(useGlobalCheckbox, sectionHeader, globalRowsBottomY)
	end

	return yCoord
end

