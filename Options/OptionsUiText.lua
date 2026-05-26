---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Text = TRB.Functions.OptionsUi.Text or {}
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

	controls.textDisplayDefaultSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DefaultBarTextFontSettingsHeader"], oUi.xCoord, yCoord)

	-- Show informational notice about how default font settings work
	yCoord = yCoord - 30
	controls.defaultFontNotice = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	controls.defaultFontNotice:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	controls.defaultFontNotice:SetWidth(550)
	controls.defaultFontNotice:SetJustifyH("LEFT")
	controls.defaultFontNotice:SetText("|cFFCCCCCC" .. L["DefaultFontSettingsNotice"] .. "|r")

	if specId ~= nil and classId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobal = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_displayText", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobal
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "fontText")
		f.tooltip = L["CheckboxUseGlobalTooltip_Font"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayText)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("displayText")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "displayText")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayText", "displayText", yCoord)
	end
	yCoord = yCoord - 30

	local fontPairs = TRB.Functions.OptionsUi.Media:GetFontPairs()
	local fontPairsByName = TRB.Functions.OptionsUi.Media:GetFontPairsByName()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFaceDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	local function FontFaceIsSelected(value)
		return value == spec.displayText.default.fontFace
	end

	local function FontFaceSetSelected(newValue)
		spec.displayText.default.fontFace = newValue
		spec.displayText.default.fontFaceName = fontPairsByName[newValue]
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, spec.displayText.default.fontOutline or "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 10
	controls.colors.text.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DefaultFontColor"], spec.displayText.default.color.color,
																		oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.color
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.displayText.default, controls.colors.text, "color")
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- Font Shadow section
	yCoord = yCoord - 30

	controls.colors.text.fontShadowColor = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["FontSharedShadowColor"],
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
			TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
				local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
				controls.colors.text.fontShadowColor.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
				spec.displayText.default.fontShadow.color = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
				TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			end)
		end
	end)

	yCoord = yCoord - 50
	title = L["DefaultFontSize"]
	controls.fontSizeDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.default.fontSize, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontSizeDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.displayText.default.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- Font Outline dropdown
	local fontOutlineOptions = {
		{ label = L["FontOutlineNone"], value = "" },
		{ label = L["FontOutlineOutline"], value = "OUTLINE" },
		{ label = L["FontOutlineThickOutline"], value = "THICKOUTLINE" },
		{ label = L["FontOutlineMonochrome"], value = "MONOCHROME" },
		{ label = L["FontOutlineOutlineMonochrome"], value = "OUTLINE, MONOCHROME" },
		{ label = L["FontOutlineThickOutlineMonochrome"], value = "THICKOUTLINE, MONOCHROME" },
	}
	local fontOutlineLookup = {}
	for _, opt in ipairs(fontOutlineOptions) do
		fontOutlineLookup[opt.value] = opt.label
	end

	local barTextFontOutline = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontOutlineDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontOutline:SetWidth(oUi.sliderWidth)
	barTextFontOutline.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DefaultFontOutline"], oUi.xCoord2, yCoord+25)
	barTextFontOutline.label.font:SetFontObject(GameFontNormal)

	local function FontOutlineIsSelected(value)
		return value == (spec.displayText.default.fontOutline or "OUTLINE")
	end

	local function FontOutlineSetSelected(newValue)
		spec.displayText.default.fontOutline = newValue
		spec.displayText.default.fontOutlineName = fontOutlineLookup[newValue] or L["FontOutlineOutline"]
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontOutlineGenerator(dropdown, rootDescription)
		for _, opt in ipairs(fontOutlineOptions) do
			rootDescription:CreateRadio(opt.label, FontOutlineIsSelected, FontOutlineSetSelected, opt.value)
		end
	end
	barTextFontOutline:SetupMenu(FontOutlineGenerator)
	barTextFontOutline:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-5)

	yCoord = yCoord - 50
	title = L["FontShadowXOffset"]
	controls.fontShadowXOffsetDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, -10, 10,
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.xOffset) or 1, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontShadowXOffsetDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		if spec.displayText.default.fontShadow == nil then
			spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		spec.displayText.default.fontShadow.xOffset = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	title = L["FontShadowYOffset"]
	controls.fontShadowYOffsetDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, -10, 10,
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.yOffset) or -1, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.fontShadowYOffsetDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		if spec.displayText.default.fontShadow == nil then
			spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		spec.displayText.default.fontShadow.yOffset = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

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
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "fontText")
	f.tooltip = L["CheckboxUseGlobalTooltip_TextColors"]
	f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textColors)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.global[lowerClassName][specName].textColors = self:GetChecked()
		TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("textColors")
	end)
	TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "textColors")

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
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 25
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalPrecision = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_precision", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalPrecision
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "fontText")
		f.tooltip = L["CheckboxUseGlobalTooltip_Precision"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].precision)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].precision = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Data.snapshotData.attributes.cacheRefresh = true
			TRB.Data.lookupDirty = true
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("precision")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "precision")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllPrecision", "precision", yCoord)
		yCoord = yCoord + 25 -- Offset adjustment for consistency with per-spec layout
	end
	yCoord = yCoord - 50

	title = L["SecondaryDecimalPrecision"]
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.secondary, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.secondary = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
		TRB.Data.lookupDirty = true
		TRB.Functions.Character:RecomputeFormattedValues()
	end)

	if (classId == nil and specId == nil) or -- Global
		(classId == 2) or -- Paladin
		(classId == 5) or -- Priest
		(classId == 7) or -- Shaman
		(classId == 8) or -- Mage
		(classId == 9) or -- Warlock
		(classId == 10 and specId == 2) or -- Monk Mistweaver
		(classId == 11) or -- Druid
		(classId == 13) -- Evoker
		then
		title = L["ManaDecimalPrecision"]
		controls.precisionMana = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.mana, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.precisionMana:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
	controls.precisionHealth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.health, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionHealth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.health = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
		TRB.Data.lookupDirty = true
		TRB.Functions.Character:RecomputeFormattedValues()
	end)


	return yCoord
end

---Creates an audio cue option row with an enable checkbox and a sound selection dropdown for a named audio trigger.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param name string The key name of the audio option in spec.audio (e.g., "overcap")
---@param spec table The spec settings table containing audio configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param localization string The localized label text for the checkbox
---@param localizationTooltip string The localized tooltip text for the checkbox
---@param defaultValue any Reserved for future use
---@param maximumValue any Reserved for future use
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, name, spec, classId, specId, yCoord, localization, localizationTooltip, defaultValue, maximumValue)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	controls.checkBoxes[name] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Checkbox", parent, "ChatConfigCheckButtonTemplate")

	local f = controls.checkBoxes[name]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(localization)
	f.tooltip = localizationTooltip
	f:SetChecked(spec.audio[name].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio[name].enabled = self:GetChecked()
		if spec.audio[name].enabled then
			PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)
	TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)

	yCoord = yCoord - 60
	return yCoord
end

---Creates a sound file selection dropdown for a named audio trigger, populated from LibSharedMedia sound entries.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param name string The key name of the audio option in spec.audio (e.g., "overcap")
---@param spec table The spec settings table containing audio configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for vertical positioning of the dropdown
function TRB.Functions.OptionsUi.Text:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)
	local soundPairs = TRB.Functions.OptionsUi.Media:GetSoundPairs()
	local soundPairsByName = TRB.Functions.OptionsUi.Media:GetSoundPairsByName()
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	controls.dropDown = controls.dropDown or {}

	controls.dropDown[name .. "Audio"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Audio", parent, "WowStyle1DropdownTemplate")
	local dd = controls.dropDown[name .. "Audio"]
	dd:SetWidth(oUi.sliderWidth)
	dd:SetDefaultText(spec.audio[name].soundName)
	local function IsSelected(value)
		return value == spec.audio[name].sound
	end

	local function SetSelected(newValue)
		spec.audio[name].sound = newValue
		spec.audio[name].soundName = soundPairsByName[newValue]
		dd:SetDefaultText(spec.audio[name].soundName)
		PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
	end

	local function Generator(dropdown, rootDescription)
		for k, v in pairs(soundPairs) do
			rootDescription:CreateRadio(v[1], IsSelected, SetSelected, v[2])
		end
		rootDescription:SetScrollMode(400)

	end
	dd:SetupMenu(Generator)
	dd:SetPoint("TOPLEFT", oUi.xPadding2, yCoord-20)
end

