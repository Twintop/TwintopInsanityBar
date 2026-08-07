---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Colors = TRB.Functions.OptionsUi.Colors or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/255
end

-- ============================================================================
-- Bar color options
-- ============================================================================

---Generates the consolidated "Base Colors" panel: Resource color, Casting Overlay (optional), Border, and Unfilled bar background.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param includeCastingOverlay boolean? Whether to include the casting overlay color option (default true)
---@param includeSpendingOverlay boolean? Whether to include the spending overlay color option
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeCastingOverlay, includeSpendingOverlay)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.baseColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BaseColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, primaryResourceString, spec.colors.bar.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetFrame and node:GetFrame() or nil
		end
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.bar.base, self, classId, specId)
	end)

	if includeCastingOverlay ~= false then
		yCoord = yCoord - 30
		controls.colors.casting = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["BarColorCastingOverlay"], spec.colors.bar.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.bar.casting, self, classId, specId)
		end)

		controls.checkBoxes.castingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.castingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorCastingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorCastingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.casting.enabled)
		controls.checkBoxes.castingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.casting.fullHeight == true,
			function(self)
				spec.colors.bar.casting.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.casting.enabled = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	if includeSpendingOverlay then
		if includeCastingOverlay == false then
			yCoord = yCoord - 30
		end
		controls.colors.spending = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["BarColorSpendingOverlay"], spec.colors.bar.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.bar.spending, self, classId, specId)
		end)

		controls.checkBoxes.spendingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spendingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorSpendingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorSpendingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.spending.enabled)
		controls.checkBoxes.spendingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.spending.fullHeight == true,
			function(self)
				spec.colors.bar.spending.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.spending.enabled = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	controls.colors.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ColorPickerBorder"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetFrame and node:GetFrame()
		end
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetPrimaryBackdropFrame())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.bar, namePrefix .. "_Bar", "endCapBar", L["EndCap"], classId, specId)

	return yCoord
end


---Generates the bar color and color-changing options panel, including base bar color, casting overlay color, and optional spending overlay color.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param includeOvercap boolean Whether to include overcap-related color options
---@param includeSpendingOverlay boolean Whether to include the spending overlay color option
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateBarColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap, includeSpendingOverlay)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	controls.barColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, primaryResourceString, spec.colors.bar.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetFrame and node:GetFrame() or nil
		end
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.bar.base, self, classId, specId)
	end)

	yCoord = yCoord - 30
	controls.colors.casting = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["BarColorCastingOverlay"], spec.colors.bar.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.casting
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.bar.casting, self, classId, specId)
	end)

	controls.checkBoxes.castingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlay", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.castingOverlayEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["BarColorCastingOverlayCheckbox"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["BarColorCastingOverlayCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.casting.enabled)
	controls.checkBoxes.castingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlayFullHeight",
		oUi.xCoord,
		yCoord,
		spec.colors.bar.casting.fullHeight == true,
		function(self)
			spec.colors.bar.casting.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.casting.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	if includeSpendingOverlay then
		controls.colors.spending = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["BarColorSpendingOverlay"], spec.colors.bar.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.bar.spending, self, classId, specId)
		end)

		controls.checkBoxes.spendingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spendingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorSpendingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorSpendingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.spending.enabled)
		controls.checkBoxes.spendingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.spending.fullHeight == true,
			function(self)
				spec.colors.bar.spending.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.spending.enabled = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	return yCoord
end

---Generates the bar border color options panel, including base border color and optional overcap border color toggle and picker.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing bar border color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param includeOvercap boolean Whether to include the overcap border color option
---@param isHealer boolean? Whether the spec is a healer (reserved for future healer-specific options)
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateBarBorderColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.barColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarBorderColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25
	controls.colors.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["BorderColorBase"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetFrame and node:GetFrame()
		end
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
	end)

	if includeOvercap then
		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Border_Option_overcapBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BorderColorOvercapToggle"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["BorderColorOvercapToggleTooltip"], primaryResourceString)
		f:SetChecked(spec.colors.bar.borderOvercap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.borderOvercap.enabled = self:GetChecked()
		end)

		controls.colors.borderOvercap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["BorderColorOvercap"], primaryResourceString), spec.colors.bar.borderOvercap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)
	end

	if isHealer then
	end

	return yCoord
end

---Generates the health bar color options panel, including threshold-based health colors, absorb overlay settings, and incoming heal overlay settings.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing health bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, classId, specId, yCoord)
	local L = TRB.Localization or {}
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	-- Build the header
	controls.healthBarColorSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealthBarColorHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalHealthBarColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_healthBarColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalHealthBarColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "healthBar")
		f.tooltip = L["CheckboxUseGlobalTooltip_HealthBarColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].healthBarColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].healthBarColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Character:UpdateHealthValues()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("healthBarColors")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "healthBarColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllHealthBarColors", "healthBarColors", yCoord)
	end

	yCoord = yCoord - 30

	-- Create a lightweight bar type definition-like object for Health Bar
	-- This allows us to use the generic threshold color function while keeping
	-- the Health Bar's settings at spec.colors.healthBar (not spec.colors.bars.health)
	-- IMPORTANT: Pass resolved localized strings, NOT localization keys
	local healthBarTypeDef = {
		key = "health",
		displayName = L["HealthBarThresholdDisplayName"],
		colorCurveType = "step",
		thresholdLevels = {
			{ key = "low", colorLabel = L["HealthBarColorLow"] },
			{ key = "medium", colorLabel = L["HealthBarColorMedium"], sliderLabel = L["HealthBarThresholdMedium"], sliderTooltip = L["HealthBarThresholdMediumTooltip"] },
			{ key = "high", colorLabel = L["HealthBarColorHigh"], sliderLabel = L["HealthBarThresholdHigh"], sliderTooltip = L["HealthBarThresholdHighTooltip"] }
		},
		colorTypeLabel = L["HealthBarColorType"],
		colorTypeStepLabel = L["HealthBarColorTypeStep"],
		colorTypeLinearLabel = L["HealthBarColorTypeLinear"],
		colorTypeNoneLabel = L["HealthBarColorTypeNone"],
		-- Custom GetColors to retrieve from spec.colors.healthBar instead of spec.colors.bars.health
		GetColors = function(self, specSettings)
			if specSettings and specSettings.colors then
				return specSettings.colors.healthBar
			end
			return nil
		end
	}

	-- Use the generic threshold color function with the Health Bar callback
	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarThresholdColorOptions(
		parent, controls, spec, classId, specId, yCoord, healthBarTypeDef,
		function()
			TRB.Functions.Character:UpdateHealthValues()
		end
	)

	yCoord = yCoord - 10
	-- Absorb Display Mode dropdown
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.absorbMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_AbsorbMode", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.absorbMode:SetWidth(oUi.sliderWidth)
	controls.dropDown.absorbMode.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealthBarAbsorbMode"], oUi.xCoord, yCoord)
	controls.dropDown.absorbMode.label.font:SetFontObject(GameFontNormal)
	---@diagnostic disable-next-line: inject-field
	controls.dropDown.absorbMode.label.font.tooltip = L["HealthBarAbsorbModeTooltip"]

	local function AbsorbModeIsSelected(value)
		return value == spec.colors.healthBar.absorb.mode
	end

	local function AbsorbModeGetDisplayName(value)
		if value == "appended" then
			return L["OverlayModeAppended"]
		elseif value == "appendedOverflow" then
			return L["OverlayModeAppendedOverflow"]
		elseif value == "inset" then
			return L["OverlayModeInset"]
		else
			return L["OverlayModeOverlay"]
		end
	end

	local function AbsorbModeSetSelected(newValue)
		spec.colors.healthBar.absorb.mode = newValue
		controls.dropDown.absorbMode:SetDefaultText(AbsorbModeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function AbsorbModeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["OverlayModeAppended"], AbsorbModeIsSelected, AbsorbModeSetSelected, "appended")
		rootDescription:CreateRadio(L["OverlayModeAppendedOverflow"], AbsorbModeIsSelected, AbsorbModeSetSelected, "appendedOverflow")
		rootDescription:CreateRadio(L["OverlayModeOverlay"], AbsorbModeIsSelected, AbsorbModeSetSelected, "overlay")
		rootDescription:CreateRadio(L["OverlayModeInset"], AbsorbModeIsSelected, AbsorbModeSetSelected, "inset")
	end

	controls.dropDown.absorbMode:SetupMenu(AbsorbModeGenerator)
	controls.dropDown.absorbMode:SetDefaultText(AbsorbModeGetDisplayName(spec.colors.healthBar.absorb.mode))
	controls.dropDown.absorbMode:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	yCoord = yCoord - 10

	controls.colors = controls.colors or {}
	controls.colors.absorb = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealthBarAbsorbColor"], spec.colors.healthBar.absorb.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.absorb:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "absorb", "health")
	end)

	local absorbCheckboxY = yCoord - 20
	controls.checkBoxes.showAbsorb = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showAbsorb", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showAbsorb
	f:SetPoint("TOPLEFT", oUi.xCoord2, absorbCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowAbsorb"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowAbsorbTooltip"]
	f:SetChecked(spec.colors.healthBar.absorb.enabled)
	controls.checkBoxes.showAbsorbFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showAbsorbFullHeight",
		oUi.xCoord2,
		absorbCheckboxY,
		spec.colors.healthBar.absorb.fullHeight == true,
		function(self)
			spec.colors.healthBar.absorb.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.showAbsorbFullHeight, spec.colors.healthBar.absorb.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.absorb.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.showAbsorbFullHeight, spec.colors.healthBar.absorb.enabled)
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Incoming Heal Display Mode dropdown
	controls.dropDown.incomingHealMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_IncomingHealMode", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.incomingHealMode:SetWidth(oUi.sliderWidth)
	controls.dropDown.incomingHealMode.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealthBarIncomingHealMode"], oUi.xCoord, yCoord)
	controls.dropDown.incomingHealMode.label.font:SetFontObject(GameFontNormal)
	---@diagnostic disable-next-line: inject-field
	controls.dropDown.incomingHealMode.label.font.tooltip = L["HealthBarIncomingHealModeTooltip"]

	local function IncomingHealModeIsSelected(value)
		return value == spec.colors.healthBar.incomingHeal.mode
	end

	local function IncomingHealModeGetDisplayName(value)
		if value == "appended" then
			return L["OverlayModeAppended"]
		elseif value == "appendedOverflow" then
			return L["OverlayModeAppendedOverflow"]
		elseif value == "inset" then
			return L["OverlayModeInset"]
		else
			return L["OverlayModeOverlay"]
		end
	end

	local function IncomingHealModeSetSelected(newValue)
		spec.colors.healthBar.incomingHeal.mode = newValue
		controls.dropDown.incomingHealMode:SetDefaultText(IncomingHealModeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function IncomingHealModeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["OverlayModeAppended"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "appended")
		rootDescription:CreateRadio(L["OverlayModeAppendedOverflow"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "appendedOverflow")
		rootDescription:CreateRadio(L["OverlayModeOverlay"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "overlay")
		rootDescription:CreateRadio(L["OverlayModeInset"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "inset")
	end

	controls.dropDown.incomingHealMode:SetupMenu(IncomingHealModeGenerator)
	controls.dropDown.incomingHealMode:SetDefaultText(IncomingHealModeGetDisplayName(spec.colors.healthBar.incomingHeal.mode))
	controls.dropDown.incomingHealMode:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	yCoord = yCoord - 10
	-- Incoming Heal Overlay
	controls.colors.incomingHeal = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealthBarIncomingHealColor"], spec.colors.healthBar.incomingHeal.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.incomingHeal:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "incomingHeal", "health")
	end)

	local incomingHealCheckboxY = yCoord - 20
	controls.checkBoxes.showIncomingHeal = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showIncomingHeal", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showIncomingHeal
	f:SetPoint("TOPLEFT", oUi.xCoord2, incomingHealCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowIncomingHeal"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowIncomingHealTooltip"]
	f:SetChecked(spec.colors.healthBar.incomingHeal.enabled)
	controls.checkBoxes.showIncomingHealFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showIncomingHealFullHeight",
		oUi.xCoord2,
		incomingHealCheckboxY,
		spec.colors.healthBar.incomingHeal.fullHeight == true,
		function(self)
			spec.colors.healthBar.incomingHeal.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.showIncomingHealFullHeight, spec.colors.healthBar.incomingHeal.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.incomingHeal.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.showIncomingHealFullHeight, spec.colors.healthBar.incomingHeal.enabled)
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Heal Absorb Display Mode dropdown
	controls.dropDown.healAbsorbMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_HealAbsorbMode", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.healAbsorbMode:SetWidth(oUi.sliderWidth)
	controls.dropDown.healAbsorbMode.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealthBarHealAbsorbMode"], oUi.xCoord, yCoord)
	controls.dropDown.healAbsorbMode.label.font:SetFontObject(GameFontNormal)
	---@diagnostic disable-next-line: inject-field
	controls.dropDown.healAbsorbMode.label.font.tooltip = L["HealthBarHealAbsorbModeTooltip"]

	local function HealAbsorbModeIsSelected(value)
		return value == spec.colors.healthBar.healAbsorb.mode
	end

	local function HealAbsorbModeGetDisplayName(value)
		if value == "appended" then
			return L["OverlayModeAppended"]
		elseif value == "appendedOverflow" then
			return L["OverlayModeAppendedOverflow"]
		elseif value == "inset" then
			return L["OverlayModeInset"]
		else
			return L["OverlayModeOverlay"]
		end
	end

	local function HealAbsorbModeSetSelected(newValue)
		spec.colors.healthBar.healAbsorb.mode = newValue
		controls.dropDown.healAbsorbMode:SetDefaultText(HealAbsorbModeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function HealAbsorbModeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["OverlayModeAppended"], HealAbsorbModeIsSelected, HealAbsorbModeSetSelected, "appended")
		rootDescription:CreateRadio(L["OverlayModeAppendedOverflow"], HealAbsorbModeIsSelected, HealAbsorbModeSetSelected, "appendedOverflow")
		rootDescription:CreateRadio(L["OverlayModeOverlay"], HealAbsorbModeIsSelected, HealAbsorbModeSetSelected, "overlay")
		rootDescription:CreateRadio(L["OverlayModeInset"], HealAbsorbModeIsSelected, HealAbsorbModeSetSelected, "inset")
	end

	controls.dropDown.healAbsorbMode:SetupMenu(HealAbsorbModeGenerator)
	controls.dropDown.healAbsorbMode:SetDefaultText(HealAbsorbModeGetDisplayName(spec.colors.healthBar.healAbsorb.mode))
	controls.dropDown.healAbsorbMode:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	yCoord = yCoord - 10
	-- Heal Absorb Overlay color picker
	controls.colors.healAbsorb = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealthBarHealAbsorbColor"], spec.colors.healthBar.healAbsorb.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.healAbsorb:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "healAbsorb", "health")
	end)

	local healAbsorbCheckboxY = yCoord - 20
	controls.checkBoxes.showHealAbsorb = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showHealAbsorb", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showHealAbsorb
	f:SetPoint("TOPLEFT", oUi.xCoord2, healAbsorbCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowHealAbsorb"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowHealAbsorbTooltip"]
	f:SetChecked(spec.colors.healthBar.healAbsorb.enabled)
	controls.checkBoxes.showHealAbsorbFullHeight, yCoord = TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showHealAbsorbFullHeight",
		oUi.xCoord2,
		healAbsorbCheckboxY,
		spec.colors.healthBar.healAbsorb.fullHeight == true,
		function(self)
			spec.colors.healthBar.healAbsorb.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.showHealAbsorbFullHeight, spec.colors.healthBar.healAbsorb.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.healAbsorb.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.showHealAbsorbFullHeight, spec.colors.healthBar.healAbsorb.enabled)
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	return yCoord - 30
end

---Generates the Brewmaster Monk stagger bar color options panel, including light/medium/heavy threshold colors, color transition type, threshold sliders, border, and background colors.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing stagger bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateStaggerBarColorOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.staggerBarColorSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["StaggerBarColorHeader"], oUi.xCoord, yCoord)

	-- Color Transition Type dropdown
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.staggerColorCurveType = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_StaggerColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.staggerColorCurveType:SetWidth(oUi.sliderWidth)
	controls.dropDown.staggerColorCurveType.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["StaggerBarColorType"], oUi.xCoord, yCoord)
	controls.dropDown.staggerColorCurveType.label.font:SetFontObject(GameFontNormal)

	local function StaggerColorCurveTypeIsSelected(value)
		return value == spec.colors.comboPoints.type
	end

	local function StaggerColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return L["StaggerBarColorTypeStep"]
		elseif value == "linear" then
			return L["StaggerBarColorTypeLinear"]
		else
			return L["StaggerBarColorTypeNone"]
		end
	end

	local function StaggerColorCurveTypeSetSelected(newValue)
		spec.colors.comboPoints.type = newValue
		controls.dropDown.staggerColorCurveType:SetDefaultText(StaggerColorCurveTypeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function StaggerColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["StaggerBarColorTypeStep"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(L["StaggerBarColorTypeLinear"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(L["StaggerBarColorTypeNone"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "none")
	end

	controls.dropDown.staggerColorCurveType:SetupMenu(StaggerColorCurveTypeGenerator)
	controls.dropDown.staggerColorCurveType:SetDefaultText(StaggerColorCurveTypeGetDisplayName(spec.colors.comboPoints.type))
	controls.dropDown.staggerColorCurveType:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)


	-- Medium Stagger Threshold Slider
	yCoord = yCoord - 80
	controls.staggerThresholdMedium = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["StaggerBarThresholdMedium"], 0, 1, spec.colors.comboPoints.medium.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdMedium.tooltip = L["StaggerBarThresholdMediumTooltip"]
	controls.staggerThresholdMedium:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.medium.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.medium.threshold = spec.colors.comboPoints.heavy.threshold
			controls.staggerThresholdMedium.EditBox:SetText(spec.colors.comboPoints.medium.threshold)
			controls.staggerThresholdMedium:SetValue(spec.colors.comboPoints.medium.threshold)
		end

		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Heavy Stagger Threshold Slider
	yCoord = yCoord - 60
	controls.staggerThresholdHeavy = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["StaggerBarThresholdHeavy"], 0, 1, spec.colors.comboPoints.heavy.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdHeavy.tooltip = L["StaggerBarThresholdHeavyTooltip"]
	controls.staggerThresholdHeavy:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.heavy.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.heavy.threshold = spec.colors.comboPoints.medium.threshold
			controls.staggerThresholdHeavy.EditBox:SetText(spec.colors.comboPoints.heavy.threshold)
			controls.staggerThresholdHeavy:SetValue(spec.colors.comboPoints.heavy.threshold)
		end

		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)


	-- Light Stagger Color
	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.colors.comboPoints.light = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["StaggerBarColorLight"], spec.colors.comboPoints.light, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.light
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "light", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.light, self)
	end)

	-- Medium Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.medium = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["StaggerBarColorMedium"], spec.colors.comboPoints.medium, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.medium
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "medium", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.medium, self)
	end)

	-- Heavy Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.heavy = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["StaggerBarColorHeavy"], spec.colors.comboPoints.heavy, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.heavy
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "heavy", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.heavy, self)
	end)

	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBorder = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["StaggerBarColorBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBorder
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "border", "border", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBackground = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBackground
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord2 - 20

	return yCoord
end

---Generates the overcapping configuration panel with relative offset and fixed value modes for determining the overcap threshold.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing overcap configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param primaryResourceMax number The maximum value of the primary resource
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.overcappingConfiguration = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OvercappingConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.overcapModeRelative = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Relative", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeRelative
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapRelativeOffset"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "relative" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(true)
		controls.checkBoxes.overcapModeFixed:SetChecked(false)
		spec.overcap.mode = "relative"
	end)

	title = string.format(L["OvercapRelativeOffsetAmount"], primaryResourceString)
	controls.overcapRelative = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, -primaryResourceMax, 0, spec.overcap.relative, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapRelative:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.relative = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.overcapModeFixed = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Fixed", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeFixed
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapFixedValue"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "fixed" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(false)
		controls.checkBoxes.overcapModeFixed:SetChecked(true)
		spec.overcap.mode = "fixed"
	end)

	title = string.format(L["OvercapAbove"], primaryResourceString)
	controls.overcapFixed = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, primaryResourceMax, spec.overcap.fixed, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapFixed:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.fixed = value
	end)

	return yCoord
end

---Generates the maximum resource override configuration panel with an enable checkbox and a slider for setting a custom max resource value.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing max resource configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param primaryResourceMin number The minimum allowed value for the max resource slider
---@param primaryResourceMax number The maximum allowed value for the max resource slider
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMin, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.maxResourceConfiguration = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MaxResourceHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	title = string.format(L["MaxResourceValue"], primaryResourceString)
	controls.checkBoxes.maxResourceEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_maxResourceEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maxResourceEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MaxResourceEnabled"])
	f.tooltip = L["MaxResourceEnabledTooltip"]
	f:SetChecked(spec.maxResource.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.maxResource.enabled = self:GetChecked()
	end)

	controls.maxResourceValue = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, primaryResourceMin, primaryResourceMax, spec.maxResource.value, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.maxResourceValue:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.maxResource.value = value
		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			if TRB.Frames.barGroups ~= nil and TRB.Data.character.compositeKey then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end
	end)

	return yCoord
end

---Generates the maximum value override panel for a custom bar, mirroring GenerateMaxResourceOptions
---but scoped to the bar's own settings (`spec.bars[barKey].maxResource`) instead of the primary resource.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing the bars table
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param barKey string The custom bar's registry key (e.g. "coagulatingBlood")
---@param resourceString string The localized name of the bar's resource
---@param minValue number The minimum allowed value for the slider
---@param maxValue number The maximum allowed value for the slider
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Colors:GenerateCustomBarMaxValueOptions(parent, controls, spec, classId, specId, yCoord, barKey, resourceString, minValue, maxValue)
	local barSettings = spec.bars and spec.bars[barKey]
	if barSettings == nil or barSettings.maxResource == nil then
		return yCoord
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barKey
	local f = nil

	controls.checkBoxes = controls.checkBoxes or {}
	controls[barKey .. "MaxResourceConfiguration"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MaxResourceHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes[barKey .. "MaxResourceEnabled"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_maxResourceEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[barKey .. "MaxResourceEnabled"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MaxResourceEnabled"])
	f.tooltip = L["MaxResourceEnabledTooltip"]
	f:SetChecked(barSettings.maxResource.enabled)
	f:SetScript("OnClick", function(self, ...)
		barSettings.maxResource.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Colors:RefreshCustomBarMaxValue(classId, specId)
	end)

	controls[barKey .. "MaxResourceValue"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["MaxResourceValue"], resourceString), minValue, maxValue, barSettings.maxResource.value, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barKey .. "MaxResourceValue"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		barSettings.maxResource.value = value
		TRB.Functions.OptionsUi.Colors:RefreshCustomBarMaxValue(classId, specId)
	end)

	return yCoord
end

---Pushes a custom bar max value change to the live bar, when the edited spec is the active one.
---@param classId integer?
---@param specId integer?
function TRB.Functions.OptionsUi.Colors:RefreshCustomBarMaxValue(classId, specId)
	if classId ~= nil and specId ~= nil and (classId ~= TRB.Data.character.classId or specId ~= TRB.Data.character.specId) then
		return
	end

	if TRB.Frames.barGroups ~= nil and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Generates the "End Of" buff color options UI (active buff color checkbox + color picker, ending color checkbox + color picker)
---@param parent Frame # The parent frame
---@param controls table # The controls table
---@param spec table # The spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Current Y coordinate
---@param config table # Configuration table with: endOfKey, activeColorKey, endColorKey, checkboxLabel, checkboxTooltip, activeColorLabel, endColorLabel, additionalColors (optional)
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi.Colors:GenerateEndOfColorOptions(parent, controls, spec, classId, specId, yCoord, config)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	-- Active buff color checkbox + color picker
	controls.checkBoxes = controls.checkBoxes or {}
	controls.colors = controls.colors or {}

	controls.checkBoxes[config.activeColorKey .. "BarChange"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. config.activeColorKey .. "Change", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[config.activeColorKey .. "BarChange"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.checkboxLabel)
	f.tooltip = config.checkboxTooltip
	f:SetChecked(spec.colors.bar[config.activeColorKey].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar[config.activeColorKey].enabled = self:GetChecked()
	end)

	controls.colors[config.activeColorKey] = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, config.activeColorLabel, spec.colors.bar[config.activeColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.activeColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.activeColorKey)
	end)

	-- End of buff color checkbox + color picker
	yCoord = yCoord - 30
	controls.checkBoxes["endOf" .. config.endOfKey] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. config.endOfKey .. "ColorChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.endCheckboxLabel)
	f.tooltip = config.endCheckboxTooltip
	f:SetChecked(spec.endOf[config.endOfKey].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOf[config.endOfKey].enabled = self:GetChecked()
	end)

	controls.colors[config.endColorKey] = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, config.endColorLabel, spec.colors.bar[config.endColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.endColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.endColorKey)
	end)

	-- Additional colors (optional)
	if config.additionalColors ~= nil then
		for _, colorConfig in ipairs(config.additionalColors) do
			yCoord = yCoord - 30
			controls.checkBoxes[colorConfig.key .. "Change"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. colorConfig.key .. "Change", parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes[colorConfig.key .. "Change"]
			f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(f:GetName() .. 'Text'):SetText(colorConfig.checkboxLabel)
			f.tooltip = colorConfig.checkboxTooltip
			f:SetChecked(spec.colors.bar[colorConfig.key].enabled)
			f:SetScript("OnClick", function(self, ...)
				spec.colors.bar[colorConfig.key].enabled = self:GetChecked()
			end)

			controls.colors[colorConfig.key] = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, colorConfig.colorLabel, spec.colors.bar[colorConfig.key].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = controls.colors[colorConfig.key]
			local capturedKey = colorConfig.key
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, capturedKey)
			end)
		end
	end

	return yCoord
end

---Generates the "End Of" buff configuration options UI (GCD/Time radio buttons and sliders)
---@param parent Frame # The parent frame
---@param controls table # The controls table
---@param spec table # The spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Current Y coordinate
---@param config table # Configuration table with: endOfKey, sectionHeader, gcdRadioLabel, gcdSliderLabel, timeRadioLabel, timeSliderLabel, gcdSliderMax (optional), timeSliderMax (optional)
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi.Colors:GenerateEndOfConfigurationOptions(parent, controls, spec, classId, specId, yCoord, config)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	local endOfSettings = spec.endOf[config.endOfKey]
	local gcdSliderMax = config.gcdSliderMax or 30
	local timeSliderMax = config.timeSliderMax or 15

	controls.checkBoxes = controls.checkBoxes or {}

	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, config.sectionHeader, oUi.xCoord, yCoord)

	yCoord = yCoord - 40

	controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_endOf" .. config.endOfKey .. "_modeGCDs", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.gcdRadioLabel)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if endOfSettings.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]:SetChecked(true)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]:SetChecked(false)
		endOfSettings.mode = "gcd"
	end)

	controls["endOf" .. config.endOfKey .. "GCDs"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, config.gcdSliderLabel, 0.5, gcdSliderMax, endOfSettings.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "GCDs"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		endOfSettings.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_endOf" .. config.endOfKey .. "_modeTime", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.timeRadioLabel)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if endOfSettings.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]:SetChecked(false)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]:SetChecked(true)
		endOfSettings.mode = "time"
	end)

	controls["endOf" .. config.endOfKey .. "Time"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, config.timeSliderLabel, 0, timeSliderMax, endOfSettings.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "Time"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		endOfSettings.timeMax = value
	end)

	return yCoord
end
