---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Thresholds = TRB.Functions.OptionsUi.Thresholds or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/225
end

-- ============================================================================
-- Threshold option panels
-- ============================================================================

---Generates the threshold line icon position and dimension options panel, including icon size, border, position, threshold line width, and overlap settings.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing threshold icon configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param isHealer boolean? Whether the spec is a healer (affects global setting handling)
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	yCoord = yCoord - 30
	controls.abilityThresholdSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdLinePositionHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdIcons = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdIcons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdIcons
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdIcons"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, isHealer)
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconShowTooltip"]
	f:SetChecked(spec.thresholds.icons.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.enabled = self:GetChecked()

		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconDesaturated
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconDesaturate"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconDesaturateTooltip"]
	f:SetChecked(spec.thresholds.icons.desaturated)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.desaturated = self:GetChecked()

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
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

	if classId == nil and specId == nil then
		controls.abilityThresholdSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdLineColorsForDpsAndTanksHeader"], oUi.xCoord, yCoord)
	else
		controls.abilityThresholdSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)
	end

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("thresholdColors")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "thresholdColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdColors", "thresholdColors", yCoord)
	end

	if under == true then
		yCoord = yCoord - 30
		controls.colors.threshold.under = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], localizationResource), spec.colors.threshold.under.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)
	end

	if over == true then
		yCoord = yCoord - 30
		controls.colors.threshold.over = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], localizationResource), spec.colors.threshold.over.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)
	end

	if unusable == true then
		yCoord = yCoord - 30
		controls.colors.threshold.unusable = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ThresholdUnusable"], spec.colors.threshold.unusable.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)
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
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
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
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)
	end

	if custom ~= nil and #custom > 0 then
		for _, value in pairs(custom) do
			yCoord, _, _ = TRB.Functions.OptionsUi.ColorPickers:BuildColorPickerWithEnable(parent, yCoord, controls, "threshold", spec.colors.threshold, namePrefix, value)
		end
	end

	return yCoord
end

