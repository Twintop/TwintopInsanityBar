---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = {}
-- Global settings toggles and copy-menu implementations live in Options\OptionsUiGlobalSettings.lua.
function TRB.Functions.OptionsUi:IsEditingActiveSpec(...)
	return self.GlobalSettings:IsEditingActiveSpec(...)
end

function TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(...)
	return self.GlobalSettings:BuildBulkGlobalToggleCheckbox(...)
end

function TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox(...)
	return self.GlobalSettings:RefreshBulkGlobalToggleCheckbox(...)
end

function TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(...)
	return self.GlobalSettings:BuildUseGlobalShortcutLink(...)
end

function TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(...)
	return self.GlobalSettings:BuildUseGlobalCopyButton(...)
end

function TRB.Functions.OptionsUi:BuildGlobalBulkCopyButton(...)
	return self.GlobalSettings:BuildGlobalBulkCopyButton(...)
end

-- Primitive UI builders and color-picker helpers live in Options\OptionsUiPrimitives.lua.
function TRB.Functions.OptionsUi:BuildSlider(...)
	return self.Primitives:BuildSlider(...)
end

function TRB.Functions.OptionsUi:BuildPercentageSlider(...)
	return self.Primitives:BuildPercentageSlider(...)
end

function TRB.Functions.OptionsUi:BuildTextBox(...)
	return self.Primitives:BuildTextBox(...)
end

function TRB.Functions.OptionsUi:EditBoxSetTextMinMax(...)
	return self.Primitives:EditBoxSetTextMinMax(...)
end

function TRB.Functions.OptionsUi:ShowColorPicker(...)
	return self.Primitives:ShowColorPicker(...)
end

function TRB.Functions.OptionsUi:ExtractColorFromColorPicker(...)
	return self.Primitives:ExtractColorFromColorPicker(...)
end

function TRB.Functions.OptionsUi:ColorOnMouseDown(...)
	return self.Primitives:ColorOnMouseDown(...)
end

function TRB.Functions.OptionsUi:GetPrimaryBackdropFrame(...)
	return self.Primitives:GetPrimaryBackdropFrame(...)
end

function TRB.Functions.OptionsUi:GetSecondaryBackdropFrames(...)
	return self.Primitives:GetSecondaryBackdropFrames(...)
end

function TRB.Functions.OptionsUi:GetHealthBackdropFrame(...)
	return self.Primitives:GetHealthBackdropFrame(...)
end

function TRB.Functions.OptionsUi:BuildColorPicker(...)
	return self.Primitives:BuildColorPicker(...)
end

function TRB.Functions.OptionsUi:BuildGradientColorPicker(...)
	return self.Primitives:BuildGradientColorPicker(...)
end

function TRB.Functions.OptionsUi:GradientColor2OnMouseDown(...)
	return self.Primitives:GradientColor2OnMouseDown(...)
end

function TRB.Functions.OptionsUi:BuildColorPickerWithEnable(...)
	return self.Primitives:BuildColorPickerWithEnable(...)
end

function TRB.Functions.OptionsUi:BuildSectionHeader(...)
	return self.Primitives:BuildSectionHeader(...)
end

function TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(...)
	return self.Primitives:BuildDisplayTextHelpEntry(...)
end

function TRB.Functions.OptionsUi:BuildButton(...)
	return self.Primitives:BuildButton(...)
end

function TRB.Functions.OptionsUi:BuildExportButton(...)
	return self.Primitives:BuildExportButton(...)
end

-- ============================================================================
-- Profile management dropdown (Phase 2B + 2C)
-- Profile dropdown and profile popup implementations live in Options\OptionsUiProfiles.lua.
function TRB.Functions.OptionsUi:ShowProfileImportPopup(...)
	return self.Profiles:ShowProfileImportPopup(...)
end

function TRB.Functions.OptionsUi:BuildProfileDropdown(...)
	return self.Profiles:BuildProfileDropdown(...)
end

function TRB.Functions.OptionsUi:BuildSpecTitleRow(...)
	return self.Profiles:BuildSpecTitleRow(...)
end

function TRB.Functions.OptionsUi:BuildLabel(...)
	return self.Primitives:BuildLabel(...)
end

-- Tab and tab-container implementations live in Options\OptionsUiTabs.lua.
function TRB.Functions.OptionsUi:CreateScrollFrameContainer(...)
	return self.Tabs:CreateScrollFrameContainer(...)
end

function TRB.Functions.OptionsUi:CreateTabFrameContainer(...)
	return self.Tabs:CreateTabFrameContainer(...)
end

function TRB.Functions.OptionsUi:HideAllBarTextVariablesPanels(...)
	return self.Tabs:HideAllBarTextVariablesPanels(...)
end

function TRB.Functions.OptionsUi:ActivateBarTextVariablesPanel(...)
	return self.Tabs:ActivateBarTextVariablesPanel(...)
end

function TRB.Functions.OptionsUi:SwitchTab(...)
	return self.Tabs.SwitchTab(...)
end

function TRB.Functions.OptionsUi:CreateTab(...)
	return self.Tabs:CreateTab(...)
end

function TRB.Functions.OptionsUi:SwitchToTabByClassSpec(...)
	return self.Tabs:SwitchToTabByClassSpec(...)
end

function TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(...)
	return self.Tabs:SwitchToBarTextTabByClassSpec(...)
end

function TRB.Functions.OptionsUi:BuildTabGroup(...)
	return self.Tabs:BuildTabGroup(...)
end

-- Bar text editor helpers live in Options\OptionsUiBarText.lua.
function TRB.Functions.OptionsUi:CreateVariablesSidePanel(...)
	return self.BarText:CreateVariablesSidePanel(...)
end

function TRB.Functions.OptionsUi:CreateBarTextInputPanel(...)
	return self.BarText:CreateBarTextInputPanel(...)
end

-- Texture dropdown helpers live in Options\OptionsUiTextures.lua.
function TRB.Functions.OptionsUi:CreateLsmDropdown(...)
	return self.Textures:CreateLsmDropdown(...)
end

-- Widget enable/disable helpers live in Options\OptionsUiPrimitives.lua.
function TRB.Functions.OptionsUi:ToggleCheckboxEnabled(...)
	return self.Primitives:ToggleCheckboxEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleSliderEnabled(...)
	return self.Primitives:ToggleSliderEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleDropdownEnabled(...)
	return self.Primitives:ToggleDropdownEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleColorPickerEnabled(...)
	return self.Primitives:ToggleColorPickerEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleCheckboxOnOff(...)
	return self.Primitives:ToggleCheckboxOnOff(...)
end

-- Bar layout and dimension option generators live in Options\OptionsUiLayout.lua.
function TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(...)
	return self.Layout:GenerateBarDimensionsOptions(...)
end

function TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(...)
	return self.Layout:GenerateAncillaryBarDimensionsOptions(...)
end

function TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(...)
	return self.Layout:GenerateComboPointDimensionsOptions(...)
end

-- Secondary and custom bar color option generators live in Options\OptionsUiColors.lua.
function TRB.Functions.OptionsUi:GenerateSecondaryPartialFillColorOptions(...)
	return self.Colors:GenerateSecondaryPartialFillColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateCustomBarPartialFillColorOptions(...)
	return self.Colors:GenerateCustomBarPartialFillColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateSecondaryCastingOverlayOptions(...)
	return self.Colors:GenerateSecondaryCastingOverlayOptions(...)
end

function TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(...)
	return self.Layout:GenerateHealthBarDimensionsOptions(...)
end

function TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(...)
	return self.Layout:GenerateCustomBarDimensionsOptions(...)
end

function TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(...)
	return self.Colors:GenerateCustomBarColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(...)
	return self.Colors:GenerateCustomBarThresholdColorOptions(...)
end

-- Texture option generators live in Options\OptionsUiTextures.lua.
function TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(...)
	return self.Textures:UpdateStatusbarDropdowns(...)
end

function TRB.Functions.OptionsUi:UpdateOverlayDropdowns(...)
	return self.Textures:UpdateOverlayDropdowns(...)
end

function TRB.Functions.OptionsUi:GenerateBarTexturesOptions(...)
	return self.Textures:GenerateBarTexturesOptions(...)
end

function TRB.Functions.OptionsUi:GenerateFlashOptions(...)
	return self.Textures:GenerateFlashOptions(...)
end

-- Bar visibility option generators live in Options\OptionsUiVisibility.lua.
function TRB.Functions.OptionsUi:CreateBarVisibilityThresholdTypes(...)
	return self.Visibility:CreateBarVisibilityThresholdTypes(...)
end

function TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(...)
	return self.Visibility:GenerateBarVisibilityOptions(...)
end

-- Threshold option generators live in Options\OptionsUiThresholds.lua.
function TRB.Functions.OptionsUi:GenerateThresholdListPanel(...)
	return self.Thresholds:GenerateThresholdListPanel(...)
end

function TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(...)
	return self.Thresholds:GenerateThresholdLineIconsOptions(...)
end

function TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(...)
	return self.Thresholds:GenerateThresholdLineColorOptions(...)
end

-- Bar color option generators live in Options\OptionsUiColors.lua.
function TRB.Functions.OptionsUi:GenerateBaseColorsOptions(...)
	return self.Colors:GenerateBaseColorsOptions(...)
end

-- Indicator color option generator lives in Options\OptionsUiIndicators.lua.
function TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(...)
	return self.Indicators:GenerateIndicatorColorsPanel(...)
end

function TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(...)
	return self.Indicators:BuildOverlayFullHeightCheckbox(...)
end

function TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(...)
	return self.Indicators:RefreshOverlayGeometryPreview(...)
end

function TRB.Functions.OptionsUi:GenerateBarColorOptions(...)
	return self.Colors:GenerateBarColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(...)
	return self.Colors:GenerateBarBorderColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(...)
	return self.Colors:GenerateHealthBarColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateStaggerBarColorOptions(...)
	return self.Colors:GenerateStaggerBarColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateOvercapOptions(...)
	return self.Colors:GenerateOvercapOptions(...)
end

function TRB.Functions.OptionsUi:GenerateMaxResourceOptions(...)
	return self.Colors:GenerateMaxResourceOptions(...)
end

function TRB.Functions.OptionsUi:GenerateEndOfColorOptions(...)
	return self.Colors:GenerateEndOfColorOptions(...)
end

function TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(...)
	return self.Colors:GenerateEndOfConfigurationOptions(...)
end

-- Text, font, precision, and audio option generators live in Options\OptionsUiText.lua.
function TRB.Functions.OptionsUi:GenerateDefaultFontOptions(...)
	return self.Text:GenerateDefaultFontOptions(...)
end

function TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(...)
	return self.Text:GenerateUseDefaultTextColors(...)
end

function TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(...)
	return self.Text:GenerateUseDefaultDecimalPrecision(...)
end

function TRB.Functions.OptionsUi:CreateAudioOption(...)
	return self.Text:CreateAudioOption(...)
end

function TRB.Functions.OptionsUi:CreateAudioDropDown(...)
	return self.Text:CreateAudioDropDown(...)
end

-- Bar text editor generator lives in Options\OptionsUiBarText.lua.
function TRB.Functions.OptionsUi:GenerateBarTextEditor(...)
return self.BarText:GenerateBarTextEditor(...)
end