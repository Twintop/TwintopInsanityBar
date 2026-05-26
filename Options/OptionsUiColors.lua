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
	return 100/255, 225/255, 200/225
end

-- ============================================================================
-- Bar color options
-- ============================================================================

local gradientDirectionCycle = { "disabled", "horizontal", "vertical" }
local gradientDirectionAbbrevLabels = {
	disabled = L["GradientDirectionDisabledAbbrev"],
	horizontal = L["GradientDirectionHorizontalAbbrev"],
	vertical = L["GradientDirectionVerticalAbbrev"],
}

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

	controls.baseColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BaseColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, primaryResourceString, spec.colors.bar.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetFrame and node:GetFrame() or nil
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.base, self, classId, specId)
	end)

	if includeCastingOverlay ~= false then
		yCoord = yCoord - 30
		controls.colors.casting = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorCastingOverlay"], spec.colors.bar.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.casting, self, classId, specId)
		end)

		controls.checkBoxes.castingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.castingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorCastingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorCastingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.casting.enabled)
		controls.checkBoxes.castingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.casting.fullHeight == true,
			function(self)
				spec.colors.bar.casting.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.casting.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
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
		controls.colors.spending = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorSpendingOverlay"], spec.colors.bar.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.spending, self, classId, specId)
		end)

		controls.checkBoxes.spendingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spendingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorSpendingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorSpendingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.spending.enabled)
		controls.checkBoxes.spendingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.spending.fullHeight == true,
			function(self)
				spec.colors.bar.spending.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.spending.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	controls.colors.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerBorder"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetFrame and node:GetFrame()
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

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
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, primaryResourceString, spec.colors.bar.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetFrame and node:GetFrame() or nil
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.base, self, classId, specId)
	end)

	yCoord = yCoord - 30
	controls.colors.casting = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorCastingOverlay"], spec.colors.bar.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.casting
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.casting, self, classId, specId)
	end)

	controls.checkBoxes.castingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlay", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.castingOverlayEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["BarColorCastingOverlayCheckbox"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["BarColorCastingOverlayCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.casting.enabled)
	controls.checkBoxes.castingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlayFullHeight",
		oUi.xCoord,
		yCoord,
		spec.colors.bar.casting.fullHeight == true,
		function(self)
			spec.colors.bar.casting.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.casting.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	if includeSpendingOverlay then
		controls.colors.spending = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorSpendingOverlay"], spec.colors.bar.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.spending, self, classId, specId)
		end)

		controls.checkBoxes.spendingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spendingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorSpendingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorSpendingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.spending.enabled)
		controls.checkBoxes.spendingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.spending.fullHeight == true,
			function(self)
				spec.colors.bar.spending.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.spending.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
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

	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarBorderColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25
	controls.colors.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["BorderColorBase"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetFrame and node:GetFrame()
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
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

		controls.colors.borderOvercap = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["BorderColorOvercap"], primaryResourceString), spec.colors.bar.borderOvercap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
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
	controls.healthBarColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarColorHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalHealthBarColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_healthBarColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalHealthBarColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "healthBar")
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
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("healthBarColors")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "healthBarColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllHealthBarColors", "healthBarColors", yCoord)
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
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(
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
	controls.dropDown.absorbMode.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarAbsorbMode"], oUi.xCoord, yCoord)
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
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
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
	controls.colors.absorb = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealthBarAbsorbColor"], spec.colors.healthBar.absorb.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.absorb:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "absorb", "health")
	end)

	local absorbCheckboxY = yCoord - 20
	controls.checkBoxes.showAbsorb = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showAbsorb", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showAbsorb
	f:SetPoint("TOPLEFT", oUi.xCoord2, absorbCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowAbsorb"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowAbsorbTooltip"]
	f:SetChecked(spec.colors.healthBar.absorb.enabled)
	controls.checkBoxes.showAbsorbFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showAbsorbFullHeight",
		oUi.xCoord2,
		absorbCheckboxY,
		spec.colors.healthBar.absorb.fullHeight == true,
		function(self)
			spec.colors.healthBar.absorb.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showAbsorbFullHeight, spec.colors.healthBar.absorb.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.absorb.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showAbsorbFullHeight, spec.colors.healthBar.absorb.enabled)
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Incoming Heal Display Mode dropdown
	controls.dropDown.incomingHealMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_IncomingHealMode", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.incomingHealMode:SetWidth(oUi.sliderWidth)
	controls.dropDown.incomingHealMode.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarIncomingHealMode"], oUi.xCoord, yCoord)
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
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
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
	controls.colors.incomingHeal = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealthBarIncomingHealColor"], spec.colors.healthBar.incomingHeal.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.incomingHeal:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "incomingHeal", "health")
	end)

	local incomingHealCheckboxY = yCoord - 20
	controls.checkBoxes.showIncomingHeal = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showIncomingHeal", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showIncomingHeal
	f:SetPoint("TOPLEFT", oUi.xCoord2, incomingHealCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowIncomingHeal"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowIncomingHealTooltip"]
	f:SetChecked(spec.colors.healthBar.incomingHeal.enabled)
	controls.checkBoxes.showIncomingHealFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showIncomingHealFullHeight",
		oUi.xCoord2,
		incomingHealCheckboxY,
		spec.colors.healthBar.incomingHeal.fullHeight == true,
		function(self)
			spec.colors.healthBar.incomingHeal.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showIncomingHealFullHeight, spec.colors.healthBar.incomingHeal.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.incomingHeal.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showIncomingHealFullHeight, spec.colors.healthBar.incomingHeal.enabled)
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
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

	controls.staggerBarColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerBarColorHeader"], oUi.xCoord, yCoord)

	-- Color Transition Type dropdown
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.staggerColorCurveType = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_StaggerColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.staggerColorCurveType:SetWidth(oUi.sliderWidth)
	controls.dropDown.staggerColorCurveType.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerBarColorType"], oUi.xCoord, yCoord)
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
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
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
	controls.staggerThresholdMedium = TRB.Functions.OptionsUi:BuildSlider(parent, L["StaggerBarThresholdMedium"], 0, 1, spec.colors.comboPoints.medium.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdMedium.tooltip = L["StaggerBarThresholdMediumTooltip"]
	controls.staggerThresholdMedium:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.medium.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.medium.threshold = spec.colors.comboPoints.heavy.threshold
			controls.staggerThresholdMedium.EditBox:SetText(spec.colors.comboPoints.medium.threshold)
			controls.staggerThresholdMedium:SetValue(spec.colors.comboPoints.medium.threshold)
		end

		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Heavy Stagger Threshold Slider
	yCoord = yCoord - 60
	controls.staggerThresholdHeavy = TRB.Functions.OptionsUi:BuildSlider(parent, L["StaggerBarThresholdHeavy"], 0, 1, spec.colors.comboPoints.heavy.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdHeavy.tooltip = L["StaggerBarThresholdHeavyTooltip"]
	controls.staggerThresholdHeavy:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.heavy.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.heavy.threshold = spec.colors.comboPoints.medium.threshold
			controls.staggerThresholdHeavy.EditBox:SetText(spec.colors.comboPoints.heavy.threshold)
			controls.staggerThresholdHeavy:SetValue(spec.colors.comboPoints.heavy.threshold)
		end

		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)


	-- Light Stagger Color
	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.colors.comboPoints.light = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["StaggerBarColorLight"], spec.colors.comboPoints.light, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.light
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "light", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.light, self)
	end)

	-- Medium Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.medium = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["StaggerBarColorMedium"], spec.colors.comboPoints.medium, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.medium
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "medium", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.medium, self)
	end)

	-- Heavy Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.heavy = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["StaggerBarColorHeavy"], spec.colors.comboPoints.heavy, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.heavy
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "heavy", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.heavy, self)
	end)

	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBorder = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["StaggerBarColorBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBorder
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "border", "border", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBackground = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBackground
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
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

	controls.overcappingConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["OvercappingConfigurationHeader"], oUi.xCoord, yCoord)

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
	controls.overcapRelative = TRB.Functions.OptionsUi:BuildSlider(parent, title, -primaryResourceMax, 0, spec.overcap.relative, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapRelative:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
	controls.overcapFixed = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, primaryResourceMax, spec.overcap.fixed, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapFixed:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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

	controls.maxResourceConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MaxResourceHeader"], oUi.xCoord, yCoord)

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

	controls.maxResourceValue = TRB.Functions.OptionsUi:BuildSlider(parent, title, primaryResourceMin, primaryResourceMax, spec.maxResource.value, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.maxResourceValue:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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

	controls.colors[config.activeColorKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, config.activeColorLabel, spec.colors.bar[config.activeColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.activeColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.activeColorKey)
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

	controls.colors[config.endColorKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, config.endColorLabel, spec.colors.bar[config.endColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.endColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.endColorKey)
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

			controls.colors[colorConfig.key] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorConfig.colorLabel, spec.colors.bar[colorConfig.key].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = controls.colors[colorConfig.key]
			local capturedKey = colorConfig.key
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, capturedKey)
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

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, config.sectionHeader, oUi.xCoord, yCoord)

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

	controls["endOf" .. config.endOfKey .. "GCDs"] = TRB.Functions.OptionsUi:BuildSlider(parent, config.gcdSliderLabel, 0.5, gcdSliderMax, endOfSettings.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "GCDs"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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

	controls["endOf" .. config.endOfKey .. "Time"] = TRB.Functions.OptionsUi:BuildSlider(parent, config.timeSliderLabel, 0, timeSliderMax, endOfSettings.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "Time"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		endOfSettings.timeMax = value
	end)

	return yCoord
end


-- ============================================================================
-- Secondary and custom bar color options
-- ============================================================================
---Generates the optional partial-fill color controls for a secondary node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Colors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	spec.colors = spec.colors or {}
	spec.colors.comboPoints = spec.colors.comboPoints or {}
	spec.colors.comboPoints.regenerating = spec.colors.comboPoints.regenerating or TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false)

	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local frameName = "TwintopResourceBar_SecondaryPartialFillColor_" .. tostring(classId) .. "_" .. tostring(specId)
	controls.checkBoxes.secondaryPartialFillColor = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes.secondaryPartialFillColor
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondaryPartialFillColorCheckbox"], secondaryResourceString))
	checkBox.tooltip = string.format(L["SecondaryPartialFillColorCheckboxTooltip"], secondaryResourceString)
	checkBox:SetChecked(spec.colors.comboPoints.regenerating.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.regenerating.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.regenerating = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["SecondaryPartialFillColorPicker"], secondaryResourceString), spec.colors.comboPoints.regenerating, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.regenerating
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "regenerating")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.regenerating, self)
	end)

	return yCoord - 30
end

---Generates partial-fill color controls for a custom multi-node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition Custom bar definition
---@param resourceString string Localized resource/spell name for display labels
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Colors:GenerateCustomBarPartialFillColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, resourceString)
	local colorSettings = barTypeDef:GetColors(spec)
	if colorSettings == nil then
		return yCoord
	end

	colorSettings.regenerating = colorSettings.regenerating or TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false)

	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local colorControls = controls.colors.bars[barTypeDef.key]
	local frameName = "TwintopResourceBar_CustomBarPartialFillColor_" .. barTypeDef.key .. "_" .. tostring(classId) .. "_" .. tostring(specId)
	controls.checkBoxes[barTypeDef.key .. "PartialFillColor"] = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes[barTypeDef.key .. "PartialFillColor"]
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondaryPartialFillColorCheckbox"], resourceString))
	checkBox.tooltip = string.format(L["SecondaryPartialFillColorCheckboxTooltip"], resourceString)
	checkBox:SetChecked(colorSettings.regenerating.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		colorSettings.regenerating.enabled = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	colorControls.regenerating = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["SecondaryPartialFillColorPicker"], resourceString), colorSettings.regenerating, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = colorControls.regenerating
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "regenerating", nil, nil, classId, specId)
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.regenerating, self, classId, specId)
	end)

	return yCoord - 30
end

---Generates casting overlay color controls for a secondary node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Colors:GenerateSecondaryCastingOverlayOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	spec.colors = spec.colors or {}
	spec.colors.comboPoints = spec.colors.comboPoints or {}
	spec.colors.comboPoints.casting = spec.colors.comboPoints.casting or TRB.Functions.Settings:DefaultSecondaryCastingOverlayColor(true)

	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local frameName = "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SecondaryCastingOverlay"

	controls.colors.comboPoints.casting = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["SecondaryCastingOverlayColorPicker"], secondaryResourceString), spec.colors.comboPoints.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.casting
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "casting")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.casting, self, classId, specId)
	end)

	controls.checkBoxes.secondaryCastingOverlayEnabled = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes.secondaryCastingOverlayEnabled
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondaryCastingOverlayCheckbox"], secondaryResourceString))
	checkBox.tooltip = string.format(L["SecondaryCastingOverlayCheckboxTooltip"], secondaryResourceString)
	checkBox:SetChecked(spec.colors.comboPoints.casting.enabled)
	controls.checkBoxes.secondaryCastingOverlayFullHeight = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SecondaryCastingOverlayFullHeight", parent, "ChatConfigCheckButtonTemplate")
	local fullHeightCheckBox = controls.checkBoxes.secondaryCastingOverlayFullHeight
	fullHeightCheckBox:SetPoint("TOPLEFT", oUi.xCoord + (oUi.xPadding * 2), yCoord - 18)
	getglobal(fullHeightCheckBox:GetName() .. 'Text'):SetText(L["OverlayFullHeightCheckbox"])
	fullHeightCheckBox.tooltip = L["OverlayFullHeightCheckboxTooltip"]
	fullHeightCheckBox:SetChecked(spec.colors.comboPoints.casting.fullHeight == true)
	fullHeightCheckBox:SetScript("OnClick", function(self)
		spec.colors.comboPoints.casting.fullHeight = self:GetChecked()
		TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
	end)
	yCoord = yCoord - 45
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.secondaryCastingOverlayFullHeight, spec.colors.comboPoints.casting.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.casting.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.secondaryCastingOverlayFullHeight, spec.colors.comboPoints.casting.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	return yCoord
end


---Generates color options for a custom bar with simple bar/border/background colors
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Colors:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, afterNodesCallback)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil

	-- Get the color settings from the nested structure
	local colorSettings = barTypeDef:GetColors(spec)
	if not colorSettings then
		return yCoord
	end

	local displayName = barTypeDef.displayName

	-- Section header
	local headerText = string.format(L["CustomBarColorHeader"], displayName)
	controls[barTypeDef.key .. "ColorSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]

	-- For threshold-based color bars (like Stagger), use the threshold color UI
	if barTypeDef.colorCurveType == "step" or barTypeDef.colorCurveType == "linear" then
		return TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	end

	-- Simple bar/border/background colors
	-- Bar Color

	if colorSettings.bar then
		if type(colorSettings.bar) == "table" and colorSettings.bar.color2 then
			colorControls.bar = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), colorSettings.bar, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", nil, nil, classId, specId)
			end)
			f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.bar, self, classId, specId)
			end)
		else
			local barColorValue = type(colorSettings.bar) == "table" and colorSettings.bar.color or colorSettings.bar
			colorControls.bar = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), barColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", nil, nil, classId, specId)
			end)
		end
		yCoord = yCoord - 30
	end

	-- Per-node colors (for multi-node bars like Warrior defensives)
	if barTypeDef.nodeColors and colorSettings.nodeColors then
		colorControls.nodeColors = colorControls.nodeColors or {}

		-- Build a key-to-config lookup from the definition
		local nodeConfigByKey = {}
		for _, nc in ipairs(barTypeDef.nodeColors) do
			nodeConfigByKey[nc.key] = nc
		end

		-- Get ordered keys (respects user-defined nodeOrder when hasOrdering is true)
		-- Sanitize: drop any stale/unknown keys so a single bad entry can't hide valid nodes
		local rawOrderedKeys = barTypeDef:GetOrderedNodeKeys(colorSettings)
		local orderedKeys = {}
		for _, k in ipairs(rawOrderedKeys) do
			if nodeConfigByKey[k] and colorSettings.nodeColors[k] then
				orderedKeys[#orderedKeys + 1] = k
			end
		end

		-- Track row frames so arrow callbacks can swap visual contents in-place
		local rowFrames = {} -- rowFrames[i] = { key, checkbox, colorPicker, upBtn, downBtn }

		---Refreshes the contents of a single row to reflect the node at orderedKeys[rowIndex]
		local function RefreshRow(rowIndex)
			local row = rowFrames[rowIndex]
			if not row then return end
			local nk = orderedKeys[rowIndex]
			local nc = nodeConfigByKey[nk]
			local ncs = colorSettings.nodeColors[nk]
			row.key = nk
			if row.checkbox then
				row.checkbox:SetChecked(ncs and ncs.enabled)
				getglobal(row.checkbox:GetName() .. 'Text'):SetText(nc.displayName)
				row.checkbox.tooltip = nc.tooltip or nc.displayName
			end
			if row.label then
				row.label:SetText(nc.displayName)
			end
			if row.colorPicker and ncs then
				local ncsColor = type(ncs) == "table" and ncs.color or ncs
				row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(ncsColor, true))
				if row.colorPicker.Swatch2 and type(ncs) == "table" and ncs.color2 then
					row.colorPicker.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(ncs.color2, true))
					local gradDir = ncs.gradientDirection or "disabled"
					if gradDir == "disabled" then
						row.colorPicker.Swatch2:SetAlpha(0.35)
						row.colorPicker.Swatch2:EnableMouse(false)
					else
						row.colorPicker.Swatch2:SetAlpha(1.0)
						row.colorPicker.Swatch2:EnableMouse(true)
					end
				end
				if row.colorPicker.DirectionButton and type(ncs) == "table" then
					local gradDir = ncs.gradientDirection or "disabled"
					row.colorPicker.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
				end
				if row.colorPicker.Font then
					row.colorPicker.Font:SetText(nc.colorLabel or nc.displayName)
				end
			end
			-- Arrow enabled state
			if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
			if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedKeys) end
		end

		---Triggers bar layout + appearance rebuild after enable/order change
		local function RebuildBarAfterNodeChange()
			if barTypeDef.onChangeCallback then
				barTypeDef.onChangeCallback()
			end
			if TRB.Frames.barGroups ~= nil then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
				-- Re-parent bar text frames to reflect new node order
				TRB.Functions.BarText:CreateBarTextFrames()
				-- CreateBarTextFrames clears font strings as part of rebuilding/re-parenting.
				-- Force a repaint so enabled entries immediately repopulate on their new anchors.
				TRB.Data.lookupDirty = true
				TRB.Functions.BarText:UpdateResourceBarText(settings, true)
			end
		end

		---Swaps two adjacent entries in orderedKeys and the nodeOrder setting, then refreshes both rows
		local function SwapNodes(indexA, indexB)
			-- Swap in the live ordered keys
			orderedKeys[indexA], orderedKeys[indexB] = orderedKeys[indexB], orderedKeys[indexA]
			-- Persist to settings
			colorSettings.nodeOrder = colorSettings.nodeOrder or {}
			for i, k in ipairs(orderedKeys) do
				colorSettings.nodeOrder[i] = k
			end
			RefreshRow(indexA)
			RefreshRow(indexB)
			RebuildBarAfterNodeChange()
		end

		-- Determine if sameColor checkbox should be placed inline with a specific node
		local sameColorPlacedInline = false
		local showSameColor = barTypeDef.hasSameColor and barTypeDef.nodeColors and #barTypeDef.nodeColors >= 2
		local sameColorTargetKey = nil
		if showSameColor then
			sameColorTargetKey = barTypeDef.sameColorNodeKey or barTypeDef.nodeColors[#barTypeDef.nodeColors].key
		end

		for rowIndex, nodeKey in ipairs(orderedKeys) do
			local nodeConfig = nodeConfigByKey[nodeKey]
			local nodeDisplayName = nodeConfig.displayName
			local nodeColorLabel = nodeConfig.colorLabel or nodeDisplayName
			local nodeColorSettings = colorSettings.nodeColors[nodeKey]
			local capturedRowIdx = rowIndex

			if nodeColorSettings then
				colorControls.nodeColors[nodeKey] = colorControls.nodeColors[nodeKey] or {}
				local nodeControls = colorControls.nodeColors[nodeKey]
				local row = { key = nodeKey }

				-- Reorder arrows (if ordering is enabled and there are 2+ nodes)
				local arrowXOffset = oUi.xCoord
				if barTypeDef.hasOrdering and #orderedKeys > 1 then
					local upTooltipTitle = L["NodeOrderMoveUp"]
					local upTooltipBody = barTypeDef.orderUpTooltip
					local downTooltipTitle = L["NodeOrderMoveDown"]
					local downTooltipBody = barTypeDef.orderDownTooltip

					-- Up arrow (texture-based)
					local upBtn = CreateFrame("Button", nil, parent)
					upBtn:SetSize(20, 20)
					upBtn:SetPoint("TOPLEFT", arrowXOffset, yCoord)
					upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
					upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
					upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
					upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
					upBtn:SetEnabled(rowIndex > 1)
					upBtn:SetScript("OnClick", function()
						SwapNodes(capturedRowIdx - 1, capturedRowIdx)
					end)
					upBtn:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(upTooltipTitle, 1, 1, 1)
						if upTooltipBody then
							GameTooltip:AddLine(upTooltipBody, nil, nil, nil, true)
						end
						GameTooltip:Show()
					end)
					upBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
					row.upBtn = upBtn

					-- Down arrow (texture-based)
					local downBtn = CreateFrame("Button", nil, parent)
					downBtn:SetSize(20, 20)
					downBtn:SetPoint("TOPLEFT", arrowXOffset + 22, yCoord)
					downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
					downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
					downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
					downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
					downBtn:SetEnabled(rowIndex < #orderedKeys)
					downBtn:SetScript("OnClick", function()
						SwapNodes(capturedRowIdx, capturedRowIdx + 1)
					end)
					downBtn:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(downTooltipTitle, 1, 1, 1)
						if downTooltipBody then
							GameTooltip:AddLine(downTooltipBody, nil, nil, nil, true)
						end
						GameTooltip:Show()
					end)
					downBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
					row.downBtn = downBtn

					arrowXOffset = arrowXOffset + 46
				end

				if nodeConfig.hasEnabled then
					-- Build checkbox and color picker manually for node with enable option
					-- Create enable checkbox
					local checkboxName = "TwintopResourceBar_" .. namePrefix .. "_" .. nodeKey .. "_Enabled"
					nodeControls.enabled = CreateFrame("CheckButton", checkboxName, parent, "ChatConfigCheckButtonTemplate")
					local fCheckbox = nodeControls.enabled
					fCheckbox:SetPoint("TOPLEFT", arrowXOffset, yCoord)
					getglobal(fCheckbox:GetName() .. 'Text'):SetText(nodeDisplayName)
					fCheckbox.tooltip = nodeConfig.tooltip or nodeDisplayName
					fCheckbox:SetChecked(nodeColorSettings.enabled)
					-- Dereference via orderedKeys at click-time to survive arrow reordering
					fCheckbox:SetScript("OnClick", function(self, ...)
						local currentKey = orderedKeys[capturedRowIdx]
						colorSettings.nodeColors[currentKey].enabled = self:GetChecked()
						RebuildBarAfterNodeChange()
					end)
					row.checkbox = fCheckbox

					-- Create color picker (dereference via orderedKeys at click-time for settings, but use
					-- nodeControls for the controls table so the callback updates THIS row's swatch frame)
					if type(nodeColorSettings) == "table" and nodeColorSettings.color2 then
						nodeControls.color = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, nodeColorLabel, nodeColorSettings, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
						f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.nodeColors[currentKey], self, classId, specId)
						end)
						f.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
							if mouseButton == "LeftButton" then
								local currentKey = orderedKeys[capturedRowIdx]
								local currentColorEntry = colorSettings.nodeColors[currentKey]
								local currentIdx = 1
								for idx, dir in ipairs(gradientDirectionCycle) do
									if dir == currentColorEntry.gradientDirection then
										currentIdx = idx
										break
									end
								end
								local nextIdx = (currentIdx % #gradientDirectionCycle) + 1
								currentColorEntry.gradientDirection = gradientDirectionCycle[nextIdx]
								local gradDir = currentColorEntry.gradientDirection
								local swatch2 = self:GetParent().Swatch2
								if gradDir == "disabled" then
									swatch2:SetAlpha(0.35)
									swatch2:EnableMouse(false)
								else
									swatch2:SetAlpha(1.0)
									swatch2:EnableMouse(true)
								end
								self.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
								TRB.Data.cache.colors.gradient = {}
								TRB.Data.cache.colors.bar = {}
								if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
									TRB.Data.lookupDirty = true
									TRB.Functions.Class:TriggerResourceBarUpdates()
								end
							end
						end)
					else
						nodeControls.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, nodeColorLabel, nodeColorSettings.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
					end
					row.colorPicker = nodeControls.color
				else
					-- Place sameColor checkbox inline on the left if this row matches the target node
					if showSameColor and not sameColorPlacedInline and (nodeKey == sameColorTargetKey) then
						local sameColorCheckboxName = "TwintopResourceBar_" .. namePrefix .. "_sameColor"
						colorControls.sameColor = CreateFrame("CheckButton", sameColorCheckboxName, parent, "ChatConfigCheckButtonTemplate")
						local fSameColor = colorControls.sameColor
						fSameColor:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
						getglobal(fSameColor:GetName() .. 'Text'):SetText(string.format(L["CustomBarCheckboxSameColor"], displayName))
						fSameColor.tooltip = string.format(L["CustomBarCheckboxSameColorTooltip"], displayName)
						fSameColor:SetChecked(colorSettings.sameColor)
						fSameColor:SetScript("OnClick", function(self, ...)
							colorSettings.sameColor = self:GetChecked()
						end)
						sameColorPlacedInline = true
					end

					-- Simple color picker without enable checkbox (dereference via orderedKeys at click-time for
					-- settings, but use nodeControls for the controls table so the callback updates THIS row's swatch)
					if type(nodeColorSettings) == "table" and nodeColorSettings.color2 then
						nodeControls.color = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, nodeColorLabel, nodeColorSettings, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
						f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.nodeColors[currentKey], self, classId, specId)
						end)
						f.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
							if mouseButton == "LeftButton" then
								local currentKey = orderedKeys[capturedRowIdx]
								local currentColorEntry = colorSettings.nodeColors[currentKey]
								local currentIdx = 1
								for idx, dir in ipairs(gradientDirectionCycle) do
									if dir == currentColorEntry.gradientDirection then
										currentIdx = idx
										break
									end
								end
								local nextIdx = (currentIdx % #gradientDirectionCycle) + 1
								currentColorEntry.gradientDirection = gradientDirectionCycle[nextIdx]
								local gradDir = currentColorEntry.gradientDirection
								local swatch2 = self:GetParent().Swatch2
								if gradDir == "disabled" then
									swatch2:SetAlpha(0.35)
									swatch2:EnableMouse(false)
								else
									swatch2:SetAlpha(1.0)
									swatch2:EnableMouse(true)
								end
								self.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
								TRB.Data.cache.colors.gradient = {}
								TRB.Data.cache.colors.bar = {}
								if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
									TRB.Data.lookupDirty = true
									TRB.Functions.Class:TriggerResourceBarUpdates()
								end
							end
						end)
					else
						local nodeColorValue = type(nodeColorSettings) == "table" and nodeColorSettings.color or nodeColorSettings
						nodeControls.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, nodeColorLabel, nodeColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
					end
					row.colorPicker = nodeControls.color
				end
				rowFrames[rowIndex] = row
				yCoord = yCoord - 30
			end
		end

		-- Fallback: if sameColor checkbox wasn't placed inline (e.g., target node has hasEnabled), place on its own row
		if showSameColor and not sameColorPlacedInline then
			local sameColorCheckboxName = "TwintopResourceBar_" .. namePrefix .. "_sameColor"
			colorControls.sameColor = CreateFrame("CheckButton", sameColorCheckboxName, parent, "ChatConfigCheckButtonTemplate")
			local fSameColor = colorControls.sameColor
			fSameColor:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(fSameColor:GetName() .. 'Text'):SetText(string.format(L["CustomBarCheckboxSameColor"], displayName))
			fSameColor.tooltip = string.format(L["CustomBarCheckboxSameColorTooltip"], displayName)
			fSameColor:SetChecked(colorSettings.sameColor)
			fSameColor:SetScript("OnClick", function(self, ...)
				colorSettings.sameColor = self:GetChecked()
			end)
			yCoord = yCoord - 30
		end
	end

	-- Extra content between node colors and border (e.g., Holy Words complete cooldown)
	if afterNodesCallback then
		yCoord = afterNodesCallback(parent, yCoord)
	end

	-- Border Color
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", nil, nil, classId, specId)
		end)
		yCoord = yCoord - 30
	end

	-- Background Color
	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", nil, nil, classId, specId)
		end)
		yCoord = yCoord - 30
	end

	return yCoord
end

---Generates color options for a custom bar with threshold-based colors (step/linear)
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@param onChangeCallback function? # Optional callback to call after changes (overrides barTypeDef.onChangeCallback)
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Colors:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, onChangeCallback)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil

	-- Get the color settings from the nested structure
	local colorSettings = barTypeDef:GetColors(spec)
	if not colorSettings then
		return yCoord
	end

	-- Determine the callback to use (parameter overrides definition)
	local changeCallback = onChangeCallback or barTypeDef.onChangeCallback

	---Triggers a resource bar update and optional change callback after a threshold color setting is modified.
	local function triggerChange()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
		if changeCallback then
			changeCallback()
		end
	end

	local displayName = barTypeDef.displayName

	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]

	-- Get localized strings from barTypeDef (resolved at registration time, with fallbacks to generic labels)
	local colorTypeLabel = barTypeDef.colorTypeLabel or L["ColorType"]
	local colorTypeStepLabel = barTypeDef.colorTypeStepLabel or L["ColorTypeStep"]
	local colorTypeLinearLabel = barTypeDef.colorTypeLinearLabel or L["ColorTypeLinear"]
	local colorTypeNoneLabel = barTypeDef.colorTypeNoneLabel or L["ColorTypeNone"]

	-- Color Transition Type dropdown
	-- Note: yCoord already positioned at header row, so dropdown label goes here
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown[barTypeDef.key .. "ColorCurveType"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetWidth(oUi.sliderWidth)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, colorTypeLabel, oUi.xCoord, yCoord)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the current color curve type.
	---@param value string The color curve type to check ("step", "linear", or "none")
	---@return boolean
	local function ColorCurveTypeIsSelected(value)
		return value == colorSettings.type
	end

	---Returns the localized display name for a color curve type value.
	---@param value string The color curve type ("step", "linear", or "none")
	---@return string
	local function ColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return colorTypeStepLabel
		elseif value == "linear" then
			return colorTypeLinearLabel
		else
			return colorTypeNoneLabel
		end
	end

	---Sets the color curve type to a new value, updates the dropdown text, and triggers a change callback.
	---@param newValue string The new color curve type ("step", "linear", or "none")
	local function ColorCurveTypeSetSelected(newValue)
		colorSettings.type = newValue
		controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(newValue))
		triggerChange()
	end

	---Populates the dropdown menu with color curve type options (step, linear, none).
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function ColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(colorTypeStepLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(colorTypeLinearLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(colorTypeNoneLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "none")
	end

	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetupMenu(ColorCurveTypeGenerator)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(colorSettings.type))
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	-- Advance yCoord past the dropdown (dropdown + its label takes about 50 units)
	yCoord = yCoord - 80

	-- Get threshold levels from definition (required for threshold-based bars)
	local thresholdLevels = barTypeDef.thresholdLevels
	if not thresholdLevels or #thresholdLevels == 0 then
		-- Early exit if no threshold levels defined
		return yCoord
	end

	-- Build threshold sliders (skip first one - no slider needed for base/low)
	-- Use percentage sliders: display percentages, store as decimals
	-- Default max is 100%, but can be overridden by barTypeDef.maxThresholdPercent (e.g., 1000 for stagger)
	local maxThresholdPercent = barTypeDef.maxThresholdPercent or 100
	for i, thresholdLevel in ipairs(thresholdLevels) do
		local thresholdKey = thresholdLevel.key
		if i > 1 and colorSettings[thresholdKey] and colorSettings[thresholdKey].threshold ~= nil then
			-- Use resolved sliderLabel string from thresholdLevel, or fall back to generic formatted label
			local sliderLabel = thresholdLevel.sliderLabel or string.format(L["CustomBarThreshold"], displayName, thresholdKey:gsub("^%l", string.upper))
			controls[barTypeDef.key .. thresholdKey .. "Threshold"] = TRB.Functions.OptionsUi:BuildPercentageSlider(parent, sliderLabel,
				0, maxThresholdPercent, colorSettings[thresholdKey].threshold, 1, 0,
				oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
			if thresholdLevel.sliderTooltip then
				controls[barTypeDef.key .. thresholdKey .. "Threshold"].tooltip = thresholdLevel.sliderTooltip
			end
			controls[barTypeDef.key .. thresholdKey .. "Threshold"]:SetScript("OnValueChanged", function(self, value)
				-- Slider value is in percentage (0-maxThresholdPercent), store as decimal
				local displayValue = TRB.Functions.Number:RoundTo(value, 0)
				self.EditBox:SetText(displayValue .. "%")
				colorSettings[thresholdKey].threshold = value / 100
				triggerChange()
			end)
			yCoord = yCoord - 60
		end
	end

	-- Build color pickers for each threshold
	local gradientTooltip = barTypeDef.gradientTooltipNote
	for _, thresholdLevel in ipairs(thresholdLevels) do
		local thresholdKey = thresholdLevel.key
		if colorSettings[thresholdKey] and colorSettings[thresholdKey].color then
			-- Use resolved colorLabel string from thresholdLevel
			local colorLabel = thresholdLevel.colorLabel
			if type(colorSettings[thresholdKey]) == "table" and colorSettings[thresholdKey].color2 then
				colorControls[thresholdKey] = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, colorLabel, colorSettings[thresholdKey], oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2, gradientTooltip)
				f = colorControls[thresholdKey]
				f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, nil, nil, classId, specId)
				end)
				f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
						TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings[thresholdKey], self, classId, specId)
				end)
			else
				colorControls[thresholdKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorLabel, colorSettings[thresholdKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
				f = colorControls[thresholdKey]
				f:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, nil, nil, classId, specId)
				end)
			end
			yCoord2 = yCoord2 - 30
		end
	end

	-- Border and background colors
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", nil, nil, classId, specId)
		end)
		yCoord2 = yCoord2 - 30
	end

	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", nil, nil, classId, specId)
		end)
		yCoord2 = yCoord2 - 30
	end

	return math.min(yCoord, yCoord2)
end

