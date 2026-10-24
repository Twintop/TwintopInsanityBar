local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Text = TRB.Functions.OptionsUi.Text or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Text, font, precision, and audio options
-- ============================================================================

---Generates the default bar text font settings panel, including font face dropdown, default font color picker, and font size slider with optional global toggle.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing display text font configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.dropDown.fonts = {}

	controls.textDisplayDefaultSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DefaultBarTextFontSettingsHeader"], oUi.xCoord, yCoord)

	-- Show informational notice about how default font settings work
	yCoord = yCoord - 30
	controls.defaultFontNotice = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	controls.defaultFontNotice:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	controls.defaultFontNotice:SetWidth(550)
	controls.defaultFontNotice:SetJustifyH("LEFT")
	controls.defaultFontNotice:SetText("|cFFCCCCCC" .. L["DefaultFontSettingsNotice"] .. "|r")

	local useGlobalCheckbox = nil
	if specId ~= nil and classId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobal = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_displayText", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobal
		useGlobalCheckbox = f
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "fontText")
		f.tooltip = L["CheckboxUseGlobalTooltip_Font"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayText)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("displayText")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "displayText")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayText", "displayText", yCoord)
	end
	yCoord = yCoord - 30

	local fontPairs = TRB.Functions.OptionsUi.Media:GetFontPairs()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFaceDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	-- By name, since a saved path can be stale and several names can share one file.
	local function FontFaceIsSelected(pair)
		return pair[1] == spec.displayText.default.fontFaceName
	end

	local function FontFaceSetSelected(pair)
		spec.displayText.default.fontFace = pair[2]
		spec.displayText.default.fontFaceName = pair[1]
		barTextFontFace:SetDefaultText(pair[1])
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for _, v in ipairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v)
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, spec.displayText.default.fontOutline or "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	local function RefreshFontFaceLabel()
		barTextFontFace:SetDefaultText(TRB.Functions.LibSharedMedia:GetDisplayName("font", spec.displayText.default.fontFaceName) or TRB.Data.constants.defaultSettings.fonts.fontFaceName)
	end
	RefreshFontFaceLabel()
	TRB.Functions.OptionsUi.Media:SetLabelRefresher(barTextFontFace, RefreshFontFaceLabel)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 10
	controls.colors.text.color = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DefaultFontColor"], spec.displayText.default.color.color,
																		oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.color
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.displayText.default, controls.colors.text, "color")
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- Font Shadow section
	yCoord = yCoord - 30

	controls.colors.text.fontShadowColor = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["FontSharedShadowColor"],
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.color) or "FF000000",
		oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.fontShadowColor
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			if spec.displayText.default.fontShadow == nil then
				spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
			end
			local colorString = spec.displayText.default.fontShadow.color or "FF000000"
			local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
			TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, 1-a, function(color)
				local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
				controls.colors.text.fontShadowColor.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
				spec.displayText.default.fontShadow.color = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
				TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			end)
		end
	end)

	yCoord = yCoord - 50
	title = L["DefaultFontSize"]
	controls.fontSizeDefault = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 6, 72, spec.displayText.default.fontSize, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontSizeDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		spec.displayText.default.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- Font Outline dropdown
	TRB.Functions.OptionsUi.Primitives:BuildFontOutlineDropdown(parent, "TwintopResourceBar_" .. namePrefix .. "_fontOutlineDefault",
		L["DefaultFontOutline"],
		function()
			return spec.displayText.default.fontOutline
		end,
		function(newValue)
			spec.displayText.default.fontOutline = newValue
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end,
		oUi.xCoord2, yCoord+25)

	yCoord = yCoord - 50
	title = L["FontShadowXOffset"]
	controls.fontShadowXOffsetDefault = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, -10, 10,
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.xOffset) or 1, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontShadowXOffsetDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		if spec.displayText.default.fontShadow == nil then
			spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		spec.displayText.default.fontShadow.xOffset = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	title = L["FontShadowYOffset"]
	controls.fontShadowYOffsetDefault = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, -10, 10,
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.yOffset) or -1, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.fontShadowYOffsetDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		if spec.displayText.default.fontShadow == nil then
			spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		spec.displayText.default.fontShadow.yOffset = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- The returned row is the shadow offset sliders' top, so the cover reaches past their edit boxes.
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(useGlobalCheckbox, controls.textDisplayDefaultSection, yCoord - 40)

	return yCoord
end

---Generates the "Use Global" checkbox for text color settings, allowing a spec to inherit global text colors.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing text color configuration
---@param classId integer The class ID
---@param specId integer The spec ID
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	local lowerClassName = string.lower(className)
	controls.checkBoxes.useGlobalTextColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_textColors", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.useGlobalTextColors
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "fontText")
	f.tooltip = L["CheckboxUseGlobalTooltip_TextColors"]
	f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textColors)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.global[lowerClassName][specName].textColors = self:GetChecked()
		TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("textColors")
	end)
	TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "textColors")
	-- Every caller builds its text colors header as textDisplaySection just before this.
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalBadge(f, controls.textDisplaySection, L["UseGlobalBadgeTooltipTextColors"])

	return yCoord
end

---Generates the decimal precision configuration panel with sliders for secondary resource, mana, and health display precision, plus an optional global toggle.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing precision configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)
	local useGlobalCheckbox = nil
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 25
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalPrecision = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_precision", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalPrecision
		useGlobalCheckbox = f
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "fontText")
		f.tooltip = L["CheckboxUseGlobalTooltip_Precision"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].precision)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].precision = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Data.snapshotData.attributes.cacheRefresh = true
			TRB.Data.lookupDirty = true
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("precision")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "precision")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllPrecision", "precision", yCoord)
		yCoord = yCoord + 25 -- Offset adjustment for consistency with per-spec layout
	end
	yCoord = yCoord - 50

	title = L["SecondaryDecimalPrecision"]
	controls.precisionSecondary = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 10, spec.precision.secondary, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.secondary = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
		TRB.Data.lookupDirty = true
		TRB.Functions.Character:RecomputeFormattedValues()
	end)

	-- Mana precision applies to the Global panel and to specs whose descriptor declares a mana bar.
	local panelDescriptor = TRB.Functions.Character:GetSpecDescriptor(classId, specId)
	if (classId == nil and specId == nil) or (panelDescriptor ~= nil and panelDescriptor.manaBar == true) then
		title = L["ManaDecimalPrecision"]
		controls.precisionMana = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 10, spec.precision.mana, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.precisionMana:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.precision.mana = value
			TRB.Data.snapshotData.attributes.cacheRefresh = true
			TRB.Data.lookupDirty = true
			TRB.Functions.Character:RecomputeFormattedValues()
		end)
	end

	yCoord = yCoord - 60

	title = L["HealthDecimalPrecision"]
	controls.precisionHealth = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 10, spec.precision.health, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionHealth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.health = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
		TRB.Data.lookupDirty = true
		TRB.Functions.Character:RecomputeFormattedValues()
	end)

	-- The returned row is the Health slider's top, so the cover reaches past its edit box.
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(useGlobalCheckbox, controls.textDisplaySection, yCoord - 40)

	return yCoord
end
