local _, TRB = ...
local L = TRB.Localization

TRB.Options = TRB.Options or {}

local oUi = TRB.Data.constants.optionsUi


local f1 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Highlight_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f1:SetFontObject(GameFontHighlightSmall)
local f2 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Green_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f2:SetFontObject(GameFontGreenSmall)
local f3 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Normal_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f3:SetFontObject(GameFontNormalSmall)
local f4 = CreateFont("TwintopResourceBar_OptionsMenu_Export_Spec_Color")
---@diagnostic disable-next-line: need-check-nil
f4:SetFontObject(GameFontWhite)
-- Red variants of the tab label fonts, used when a bar tab's bar is disabled (Visibility = Never).
local f5 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Red_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f5:SetFontObject(GameFontNormalSmall)
---@diagnostic disable-next-line: need-check-nil
f5:SetTextColor(1, 0, 0)
local f6 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Red_Highlight_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f6:SetFontObject(GameFontHighlightSmall)
---@diagnostic disable-next-line: need-check-nil
f6:SetTextColor(1, 0.35, 0.35)

TRB.Options.fonts = {}
TRB.Options.fonts.options = {}
TRB.Options.fonts.options.tabHighlightSmall = f1
TRB.Options.fonts.options.tabGreenSmall = f2
TRB.Options.fonts.options.tabNormalSmall = f3
TRB.Options.fonts.options.exportSpec = f4
TRB.Options.fonts.options.tabRedSmall = f5
TRB.Options.fonts.options.tabRedHighlightSmall = f6

TRB.Options.variables = {}
TRB.Options.variables.barTextInstructions = L["BarTextInstructions"]

---Constructs the primary resource bar dimensions panel in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructResourceBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, nil, nil, yCoord)
end

---Constructs the combo points bar dimensions panel in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructComboPointsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"])
end

---Constructs the health bar dimensions and color options panel in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"])
	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, nil, nil, yCoord)
end

---Constructs the bar textures options panel for resource, combo point, and health bars in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, nil, nil, yCoord, true, L["ResourceComboPoints"])
end

---Constructs the bar visibility and display options panel including custom bar (utility) visibility in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	local customBars = {}
	local utilityBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("utility")
	if utilityBarDef then
		table.insert(customBars, utilityBarDef)
	end

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"], "notFull", true, L["ResourceComboPoints"], true, nil, customBars)
end

---Constructs the threshold line color and icon options panel in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["ThresholdGenericSpecial"],
			enabledCheckboxLocalization = L["ThresholdGenericSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["ThresholdGenericSpecialEnabledTooltip"]
		}
	}
	
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, nil, nil, yCoord)
end

---Constructs the font, text color, and decimal precision options panel in the global options UI.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, nil, nil, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GlobalTextColorsHeader"], oUi.xCoord, yCoord)

	-- Global options panel - add bulk toggle checkbox for text colors
	yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllTextColors", "textColors", yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["GlobalColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["GlobalColorPickerTextCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["GlobalColorPickerTextPassive"], spec.colors.text.passive.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["GlobalColorPickerTextSpending"], spec.colors.text.spending.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["GlobalColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["GlobalColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["GlobalCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Global_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["GlobalCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, nil, nil, yCoord)
end

---Constructs the miscellaneous options panel including minimap icon, number abbreviation, timer precision, data refresh rate, frame strata, and audio channel settings.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructMiscellaneousPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5
	local f = nil

	local title = ""

	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarSettings"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.minimapIcon = CreateFrame("CheckButton", "TwintopResourceBar_CB_Minimap_Icon", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.minimapIcon
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	---@diagnostic disable-next-line: undefined-field
	getglobal(f:GetName() .. 'Text'):SetText(L["GlobalOptionsCheckboxMinimapIcon"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["GlobalOptionsCheckboxMinimapIconTooltip"]
	if TRB.Data.settings.core.minimap then
		f:SetChecked(not TRB.Data.settings.core.minimap.hide)
	else
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		if self:GetChecked() then
			TRB.Functions.MinimapButton:Show()
		else
			TRB.Functions.MinimapButton:Hide()
		end
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.numberAbbreviation = CreateFrame("CheckButton", "TwintopResourceBar_CB_Number_Abbreviation", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.numberAbbreviation
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	---@diagnostic disable-next-line: undefined-field
	getglobal(f:GetName() .. 'Text'):SetText(L["GlobalOptionsCheckboxNumberAbbreviation"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["GlobalOptionsCheckboxNumberAbbreviationTooltip"]
	f:SetChecked(TRB.Data.settings.core.numberAbbreviation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.numberAbbreviation = self:GetChecked()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	yCoord = yCoord - 30
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["TimerPrecision"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50
	title = L["TimerBelowPrecision"]
	controls.timersLowPrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.timers.precisionLow, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.timersLowPrecision:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		TRB.Data.settings.core.timers.precisionLow = value
	end)
	
	title = L["TimerAbovePrecision"]
	controls.timersHighPrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.timers.precisionHigh, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.timersHighPrecision:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		TRB.Data.settings.core.timers.precisionHigh = value
	end)


	yCoord = yCoord - 60
	title = L["TimerPrecisionThreshold"]
	controls.timersPrecisionThreshold = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 1, 600, TRB.Data.settings.core.timers.precisionThreshold, 0.1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.timersPrecisionThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		TRB.Data.settings.core.timers.precisionThreshold = value
	end)



	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CharacterPlayerSettings"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50

	title = L["DataRefreshRate"]
	controls.characterRefreshRate = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0.05, 60, TRB.Data.settings.core.dataRefreshRate, 0.05, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.characterRefreshRate:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		else
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		end

		self.EditBox:SetText(value)
		TRB.Data.settings.core.dataRefreshRate = value
	end)

	title = L["ReactionTimeLatency"]
	controls.reactionTime = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0.00, 1, TRB.Data.settings.core.reactionTime, 0.05, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.reactionTime:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		else
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		end

		self.EditBox:SetText(value)
		TRB.Data.settings.core.reactionTime = value
	end)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CooldownManagerSettings"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50

	title = L["CooldownManagerGracePeriod"]
	controls.cooldownManagerGracePeriod = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 60, TRB.Data.settings.core.cooldownManagerGracePeriod, 0.05, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.cooldownManagerGracePeriod:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		else
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		end

		self.EditBox:SetText(value)
		TRB.Data.settings.core.cooldownManagerGracePeriod = value
	end)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FrameStrata"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	
	local strataDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_frameStrata", parent, "WowStyle1DropdownTemplate")
	strataDropdown:SetWidth(oUi.sliderWidth)
	strataDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FrameStrataDescription"], oUi.xCoord, yCoord)
	strataDropdown.label.font:SetFontObject(GameFontNormal)
	
	local strata = {}
	strata[L["StrataBackground"]] = "BACKGROUND"
	strata[L["StrataLow"]] = "LOW"
	strata[L["StrataMedium"]] = "MEDIUM"
	strata[L["StrataHigh"]] = "HIGH"
	strata[L["StrataDialog"]] = "DIALOG"
	strata[L["StrataFullscreen"]] = "FULLSCREEN"
	strata[L["StrataFullscreenDialog"]] = "FULLSCREEN_DIALOG"
	strata[L["StrataTooltip"]] = "TOOLTIP"
	local strataList = {
		L["StrataBackground"],
		L["StrataLow"],
		L["StrataMedium"],
		L["StrataHigh"],
		L["StrataDialog"],
		L["StrataFullscreen"],
		L["StrataFullscreenDialog"],
		L["StrataTooltip"]
	}

	---Checks whether the given frame strata value matches the current strata setting.
	---@param value string The frame strata value to check
	---@return boolean
	local function StrataIsSelected(value)
		return value == TRB.Data.settings.core.strata.level
	end
	
	---Sets the selected frame strata level and applies it to all bar group containers and text frames.
	---@param newValue string The new frame strata level (e.g., "MEDIUM", "HIGH")
	local function StrataSetSelected(newValue)
		TRB.Data.settings.core.strata.level = newValue
		
		for k, v in pairs(strata) do
			if v == newValue then
				TRB.Data.settings.core.strata.name = k
			end
		end
		strataDropdown:SetDefaultText(TRB.Data.settings.core.strata.name)

		-- Apply strata to all BarGroups (primary, secondary, health, custom bars)
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if barGroups then
			for _, group in pairs(barGroups) do
				if type(group) == "table" and group.SetFrameStrata then
					group:SetFrameStrata(TRB.Data.settings.core.strata.level)
				end
			end
		end

		---@type Frame[]
		local textFrames = TRB.Frames.textFrames
		local entries = TRB.Functions.Table:Length(textFrames)
		if entries > 0 then
			for i = 1, entries do
				textFrames[i]:SetFrameStrata(TRB.Data.settings.core.strata.level)
			end
		end
	end

	---Generates the frame strata dropdown menu with radio button entries for each strata level.
	---@param dropdown DropdownButton The dropdown button frame being populated
	---@param rootDescription table The root menu description to add entries to
	local function StrataGenerator(dropdown, rootDescription)
		for k, v in pairs(strataList) do
			rootDescription:CreateRadio(v, StrataIsSelected, StrataSetSelected, strata[v])
		end
		rootDescription:SetScrollMode(400)
	end
	strataDropdown:SetupMenu(StrataGenerator)
	strataDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 60
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioChannel"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30


	local comboPointsAudioChannel = CreateFrame("DropdownButton", "TwintopResourceBar_frameAudioChannel", parent, "WowStyle1DropdownTemplate")
	comboPointsAudioChannel:SetWidth(oUi.sliderWidth)
	comboPointsAudioChannel.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioChannelDescription"], oUi.xCoord, yCoord)
	comboPointsAudioChannel.label.font:SetFontObject(GameFontNormal)
	
	local channel = {}
	channel[L["AudioChannelMaster"]] = L["AudioChannelMaster"]
	channel[L["AudioChannelSFX"]] = L["AudioChannelSFX"]
	channel[L["AudioChannelMusic"]] = L["AudioChannelMusic"]
	channel[L["AudioChannelAmbience"]] = L["AudioChannelAmbience"]
	channel[L["AudioChannelDialog"]] = L["AudioChannelDialog"]

	---Checks whether the given audio channel value matches the current audio channel setting.
	---@param value string The audio channel value to check
	---@return boolean
	local function AudioChannelIsSelected(value)
		return value == TRB.Data.settings.core.audio.channel.channel
	end
	
	---Sets the selected audio channel for addon sound playback.
	---@param newValue string The audio channel name (e.g., "Master", "SFX", "Music")
	local function AudioChannelSetSelected(newValue)
		TRB.Data.settings.core.audio.channel.channel = newValue
		TRB.Data.settings.core.audio.channel.name = newValue
	end

	---Generates the audio channel dropdown menu with radio button entries for each channel.
	---@param dropdown DropdownButton The dropdown button frame being populated
	---@param rootDescription table The root menu description to add entries to
	local function AudioChannelGenerator(dropdown, rootDescription)
		for k, v in pairs(channel) do
			rootDescription:CreateRadio(v, AudioChannelIsSelected, AudioChannelSetSelected, v)
		end
		rootDescription:SetScrollMode(400)
	end
	comboPointsAudioChannel:SetupMenu(AudioChannelGenerator)
	comboPointsAudioChannel:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 60
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ExperimentalFeatures"], oUi.xCoord, yCoord)

end

---Constructs the reset defaults panel with buttons to reset Edit Mode layout data and global bar text settings.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_ResetEditModeData"] = {
		text = L["ResetEditModeDataDialog"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.core.editMode.layouts = {}
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_ResetGlobalBarText"] = {
		text = L["ResetGlobalBarTextDialog"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			local newBarText = TRB.Functions.Settings:LoadDefaultGlobalBarTextSettings()
			controls.barTextFields.ResetTableValues(newBarText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EditModeSettings"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.buttons.resetEditModeData = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetEditModeDataButton"], oUi.xCoord, yCoord, 200, 30)
	controls.buttons.resetEditModeData:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_ResetEditModeData")
	end)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetGlobalBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.buttons.resetGlobalBarText = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetGlobalBarText"], oUi.xCoord, yCoord, 250, 30)
	controls.buttons.resetGlobalBarText:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_ResetGlobalBarText")
	end)
end

---Constructs the global bar text customization panel with the bar text editor, export button, and common bar text variables.
---@param parent Frame The parent frame to anchor UI elements to
local function ConstructGlobalBarTextPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 10

	-- Build a lightweight cache object with global-applicable barTextVariables
	local varCategory = TRB.Functions.BarText.VariableCategory
	local globalCache = {
		barTextVariables = {
			icons = TRB.Functions.BarText:GetCommonIcons(),
			values = TRB.Functions.BarText:GetCommonValues({
				{ variable = "$resource", description = L["GlobalBarTextVariable_resource"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$resourceMax", description = L["GlobalBarTextVariable_resourceMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$casting", description = L["GlobalBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$comboPoints", description = L["GlobalBarTextVariable_comboPoints"] .. " " .. L["GlobalBarTextWarningComboPoints"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$comboPointsMax", description = L["GlobalBarTextVariable_comboPointsMax"] .. " " .. L["GlobalBarTextWarningComboPoints"], printInSettings = true, color = false, category = varCategory.RESOURCES },
			}),
		}
	}

	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, TRB.Data.settings.core, nil, nil, yCoord, globalCache)
end

---Constructs the global options panel with all tab groups (resource bar, combo points, health, textures, visibility, thresholds, font/text, bar text, miscellaneous, reset defaults) and registers it with the addon's options frame.
local function ConstructGlobalOptionsPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.global or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}
	
	interfaceSettingsFrame.optionsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_General")
	TRB.Options.OptionsFrame:RegisterCategory("global", L["GlobalOptions"], interfaceSettingsFrame.optionsPanel)

	parent = interfaceSettingsFrame.optionsPanel

	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GlobalOptions"], oUi.xCoord, yCoord - 5)

	-- Profile dropdown for core-scope settings. Replaces the legacy Import button.
	controls.profileDropdown = TRB.Functions.OptionsUi.Profiles:BuildProfileDropdown(parent, yCoord - 10, "core", nil, nil, L["GlobalOptions"])

	yCoord = yCoord - 37

	-- Must assign controls before BuildTabGroup, since constructors read interfaceSettingsFrame.controls.global
	TRB.Frames.interfaceSettingsFrameContainer.controls.global = controls

	local tabDefinitions = {
		{ "resourceBar", L["TabResource"], oUi.tabWidth.small, ConstructResourceBarPanel, visibilityKey = "primary" },
		{ "comboPointsBar", L["TabComboPoints"], oUi.tabWidth.small, ConstructComboPointsBarPanel, visibilityKey = "secondary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, ConstructHealthBarPanel, visibilityKey = "health" },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, ConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, ConstructBarVisibilityPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, ConstructThresholdPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, ConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, ConstructGlobalBarTextPanel },
		{ "miscellaneous", L["TabMiscellaneous"], oUi.tabWidth.medium, ConstructMiscellaneousPanel },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, ConstructResetDefaultsPanel },
	}

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, "Global", tabDefinitions, yCoord)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
end

---Constructs the top-level Castbar options panel: global (core-scope) castbar settings in a tabbed
---screen like Global Options, including the same core-scope (Global) profile dropdown.
local function ConstructCastbarOptionsPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.castbarGlobal or {}
	interfaceSettingsFrame.controls.castbarGlobal = controls
	controls.colors = controls.colors or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.castbarPanel = CreateFrame("Frame", "TwintopResourceBar_Options_CastbarPanel")
	TRB.Options.OptionsFrame:RegisterCategory("castbar", L["TabCastbars"], interfaceSettingsFrame.castbarPanel)

	local parent = interfaceSettingsFrame.castbarPanel

	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarGlobalOptionsHeader"], oUi.xCoord, -5)

	-- Core-scope profile dropdown, same position as on Global Options.
	controls.profileDropdown = TRB.Functions.OptionsUi.Profiles:BuildProfileDropdown(parent, -10, "core", nil, nil, L["GlobalOptions"], "_Castbar")

	local tabDefinitions = {
		{ "castbar", L["ResourcePlayerCastbar"], oUi.tabWidth.small, function(scrollChild)
			TRB.Functions.OptionsUi.Castbar:ConstructPanel(scrollChild, nil, nil, true)
		end, visibilityKey = "castbar" },
		{ "target", L["ResourceTargetCastbar"], oUi.tabWidth.small, function(scrollChild)
			TRB.Functions.OptionsUi.TargetCastbar:ConstructPanel(scrollChild, nil, nil, "targetCastbar")
		end, visibilityKey = "targetCastbar" },
		{ "focus", L["ResourceFocusCastbar"], oUi.tabWidth.small, function(scrollChild)
			TRB.Functions.OptionsUi.TargetCastbar:ConstructPanel(scrollChild, nil, nil, "focusCastbar")
		end, visibilityKey = "focusCastbar" },
	}

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, "Castbar", tabDefinitions, -37)
end

---Constructs the top-level Other Bars options panel: global (core-scope) settings for the GCD bar and
---the Fatigue/Breath/Death/Feign Death mirror timers, in a tabbed screen like the Castbar one.
local function ConstructOtherBarsOptionsPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.core or {}
	interfaceSettingsFrame.controls.core = controls
	controls.colors = controls.colors or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.otherBarsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_OtherBarsPanel")
	TRB.Options.OptionsFrame:RegisterCategory("otherBars", L["TabOtherBars"], interfaceSettingsFrame.otherBarsPanel)

	local parent = interfaceSettingsFrame.otherBarsPanel

	controls.otherBarsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OtherBarsGlobalOptionsHeader"], oUi.xCoord, -5)

	-- Core-scope profile dropdown, same position as on Global Options.
	controls.otherBarsProfileDropdown = TRB.Functions.OptionsUi.Profiles:BuildProfileDropdown(parent, -10, "core", nil, nil, L["GlobalOptions"], "_OtherBars")

	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local tabDefinitions = {}
	-- nil classId is the global scope, which excludes the Hunter-only Feign Death bar.
	for _, barKey in ipairs(registry:GetOtherBarKeys(nil)) do
		local barDef = registry:Get(barKey)
		if barDef ~= nil then
			local capturedKey = barKey
			tabDefinitions[#tabDefinitions + 1] = {
				capturedKey,
				barDef.displayName,
				oUi.tabWidth.small,
				function(scrollChild)
					TRB.Functions.OptionsUi.OtherBars:ConstructPanel(scrollChild, nil, nil, capturedKey)
				end,
				visibilityKey = capturedKey,
			}
		end
	end

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, "OtherBars", tabDefinitions, -37)
end

-- Localized labels for the profile/nav catalogs. Identity comes from
-- TRB.Data.specRegistry; this table only keeps literal localization lookups.
local PROFILE_LABELS_BY_CLASS = {
	warrior = { classLabel = L["Warrior"], specs = { arms = { label = L["WarriorArms"], fullLabel = L["WarriorArmsFull"] }, fury = { label = L["WarriorFury"], fullLabel = L["WarriorFuryFull"] }, protection = { label = L["WarriorProtection"], fullLabel = L["WarriorProtectionFull"] } } },
	paladin = { classLabel = L["Paladin"], specs = { holy = { label = L["PaladinHoly"], fullLabel = L["PaladinHolyFull"] }, protection = { label = L["PaladinProtection"], fullLabel = L["PaladinProtectionFull"] }, retribution = { label = L["PaladinRetribution"], fullLabel = L["PaladinRetributionFull"] } } },
	hunter = { classLabel = L["Hunter"], specs = { beastMastery = { label = L["HunterBeastMastery"], fullLabel = L["HunterBeastMasteryFull"] }, marksmanship = { label = L["HunterMarksmanship"], fullLabel = L["HunterMarksmanshipFull"] }, survival = { label = L["HunterSurvival"], fullLabel = L["HunterSurvivalFull"] } } },
	rogue = { classLabel = L["Rogue"], specs = { assassination = { label = L["RogueAssassination"], fullLabel = L["RogueAssassinationFull"] }, outlaw = { label = L["RogueOutlaw"], fullLabel = L["RogueOutlawFull"] }, subtlety = { label = L["RogueSubtlety"], fullLabel = L["RogueSubtletyFull"] } } },
	priest = { classLabel = L["Priest"], specs = { discipline = { label = L["PriestDiscipline"], fullLabel = L["PriestDisciplineFull"] }, holy = { label = L["PriestHoly"], fullLabel = L["PriestHolyFull"] }, shadow = { label = L["PriestShadow"], fullLabel = L["PriestShadowFull"] } } },
	deathknight = { classLabel = L["DeathKnight"], specs = { blood = { label = L["DeathKnightBlood"], fullLabel = L["DeathKnightBloodFull"] }, frost = { label = L["DeathKnightFrost"], fullLabel = L["DeathKnightFrostFull"] }, unholy = { label = L["DeathKnightUnholy"], fullLabel = L["DeathKnightUnholyFull"] } } },
	shaman = { classLabel = L["Shaman"], specs = { elemental = { label = L["ShamanElemental"], fullLabel = L["ShamanElementalFull"] }, enhancement = { label = L["ShamanEnhancement"], fullLabel = L["ShamanEnhancementFull"] }, restoration = { label = L["ShamanRestoration"], fullLabel = L["ShamanRestorationFull"] } } },
	mage = { classLabel = L["Mage"], specs = { arcane = { label = L["MageArcane"], fullLabel = L["MageArcaneFull"] }, fire = { label = L["MageFire"], fullLabel = L["MageFireFull"] }, frost = { label = L["MageFrost"], fullLabel = L["MageFrostFull"] } } },
	warlock = { classLabel = L["Warlock"], specs = { affliction = { label = L["WarlockAffliction"], fullLabel = L["WarlockAfflictionFull"] }, demonology = { label = L["WarlockDemonology"], fullLabel = L["WarlockDemonologyFull"] }, destruction = { label = L["WarlockDestruction"], fullLabel = L["WarlockDestructionFull"] } } },
	monk = { classLabel = L["Monk"], specs = { brewmaster = { label = L["MonkBrewmaster"], fullLabel = L["MonkBrewmasterFull"] }, mistweaver = { label = L["MonkMistweaver"], fullLabel = L["MonkMistweaverFull"] }, windwalker = { label = L["MonkWindwalker"], fullLabel = L["MonkWindwalkerFull"] } } },
	druid = { classLabel = L["Druid"], specs = { balance = { label = L["DruidBalance"], fullLabel = L["DruidBalanceFull"] }, feral = { label = L["DruidFeral"], fullLabel = L["DruidFeralFull"] }, guardian = { label = L["DruidGuardian"], fullLabel = L["DruidGuardianFull"] }, restoration = { label = L["DruidRestoration"], fullLabel = L["DruidRestorationFull"] } } },
	demonhunter = { classLabel = L["DemonHunter"], specs = { havoc = { label = L["DemonHunterHavoc"], fullLabel = L["DemonHunterHavocFull"] }, vengeance = { label = L["DemonHunterVengeance"], fullLabel = L["DemonHunterVengeanceFull"] }, devourer = { label = L["DemonHunterDevourer"], fullLabel = L["DemonHunterDevourerFull"] } } },
	evoker = { classLabel = L["Evoker"], specs = { devastation = { label = L["EvokerDevastation"], fullLabel = L["EvokerDevastationFull"] }, preservation = { label = L["EvokerPreservation"], fullLabel = L["EvokerPreservationFull"] }, augmentation = { label = L["EvokerAugmentation"], fullLabel = L["EvokerAugmentationFull"] } } },
}

local function BuildProfileClassCatalog()
	local catalog = {}
	for _, classEntry in ipairs(TRB.Functions.Character:GetClassRegistryEntriesOrdered()) do
		local classLabels = PROFILE_LABELS_BY_CLASS[classEntry.className]
		if classLabels ~= nil then
			local classDef = {
				classId = classEntry.classId,
				className = classEntry.className,
				token = classEntry.classToken,
				classLabel = classLabels.classLabel,
				specs = {},
			}
			for _, specEntry in ipairs(classEntry.specs) do
				local specLabels = classLabels.specs[specEntry.specName]
				if specLabels ~= nil then
					table.insert(classDef.specs, {
						specId = specEntry.specId,
						specName = specEntry.specName,
						compositeKey = specEntry.compositeKey,
						specLabel = specLabels.label,
						specFullLabel = specLabels.fullLabel,
					})
				end
			end
			table.insert(catalog, classDef)
		end
	end
	table.sort(catalog, function(a, b) return a.classLabel < b.classLabel end)
	return catalog
end

local PROFILE_CLASSES_ALPHA = BuildProfileClassCatalog()

-- Row and layout constants for the profile manager grid.
local IE_HEADER_H  = 22  -- column-header row height
local IE_ROW_H     = 22  -- profile-table data row height
local IE_VISIBLE   = 5   -- visible rows in the profile table
local IE_COL_W     = 190 -- class/spec column width (three columns)
local IE_COL_GAP   = 10  -- gap between class/spec columns
local IE_GRID_COLS = 3   -- number of class/spec columns
local IE_CLASS_H   = 24  -- class-header row height within the grid
local IE_SPEC_H    = 22  -- spec row height within the grid
local IE_PAIR_GAP  = 8   -- vertical gap between class blocks

---Constructs the profile-centric Import/Export panel.
local function ConstructImportExportPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.importExport or {}
	interfaceSettingsFrame.controls.importExport = controls
	controls.labels   = controls.labels   or {}
	controls.buttons  = controls.buttons  or {}

	-- ── Top-level panel frame ──────────────────────────────────────────
	interfaceSettingsFrame.importExportPanel = CreateFrame("Frame", "TwintopResourceBar_Options_ImportExport")
	TRB.Options.OptionsFrame:RegisterCategory("importExport",
		string.format("%s/%s", L["Import"], L["Export"]),
		interfaceSettingsFrame.importExportPanel)

	local topPanel = interfaceSettingsFrame.importExportPanel

	-- Outer scroll container
	topPanel.panel = TRB.Functions.OptionsUi.Tabs:CreateTabFrameContainer(
		"TwintopResourceBar_ImportExport_LayoutPanel", topPanel)
	topPanel.panel:SetPoint("TOPLEFT", oUi.xCoord, -5)
	topPanel.panel:Show()

	local scrollChild = topPanel.panel.scrollFrame.scrollChild
	-- Pre-allocate scroll child height large enough for all content.
	scrollChild:SetHeight(1200)

	local parent = scrollChild
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Export"] = {
		text = "",
		button1 = L["Close"],
		hasEditBox = true,
		hasWideEditBox = true,
		editBoxWidth = 400,
		timeout = 0,
		whileDead = true,
		OnShow = function(self, data)
			self:SetWidth(450)
			self:SetFormattedText(data.message)
			self:GetEditBox():SetText(data.exportString)
			self:GetEditBox():SetAutoFocus(true)
			self:GetEditBox():HighlightText()
		end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		hideOnEscape = true,
		preferredIndex = 3,
	}

	-- ── Section: Profiles ──────────────────────────────────────────────
	controls.profileSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(
		parent, L["ProfileManagerProfilesHeader"], oUi.xCoord, yCoord)

	-- ── Profile table ──────────────────────────────────────────────────
	-- Layout: Name (dynamic) | Specs (46) | Global (46) | Delete (15)
	local tblSpecW  = 46
	local tblGlobW  = 46
	local tblDelW   = 15

	yCoord = yCoord - 33

	-- LibScrollingTable-based profile table (matches Bar Text styling).
	local profileTableColumns = {
		{
			["name"] = "Key",
			["width"] = 1,
			["align"] = "CENTER",
		},
		{
			["name"] = L["ProfileManagerColumnName"],
			["width"] = 300,
			["align"] = "LEFT",
		},
		{
			["name"] = L["ProfileManagerColumnSpecs"],
			["width"] = tblSpecW,
			["align"] = "CENTER",
		},
		{
			["name"] = L["ProfileManagerColumnGlobal"],
			["width"] = tblGlobW,
			["align"] = "CENTER",
		},
		{
			["name"] = "",
			["width"] = tblDelW,
			["align"] = "CENTER",
			["color"] = {
				["r"] = 1,
				["g"] = 0,
				["b"] = 0,
				["a"] = 1,
			},
		},
	}

	local RefreshImportExportView
	local profileTableContainer = CreateFrame("Frame", "TwintopResourceBar_IE_ProfileTableContainer", parent, "BackdropTemplate")
	profileTableContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	profileTableContainer:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	profileTableContainer:SetHeight(35 + (IE_VISIBLE * 15))

	controls.buttons.importProfile = TRB.Functions.OptionsUi.Primitives:BuildButton(
		parent, L["ProfileManagerActionImport"], 0, 0, 140, 22)
	controls.buttons.importProfile:ClearAllPoints()
	controls.buttons.importProfile:SetPoint("TOPRIGHT", profileTableContainer, "TOPRIGHT", 0, 30)
	controls.buttons.importProfile:SetScript("OnClick", function()
		TRB.Functions.OptionsUi.ProfilePopups:ShowProfileImportPopup(function()
			if RefreshImportExportView ~= nil then
				RefreshImportExportView()
			end
		end)
	end)

	local UpdateProfileActionButtons
	local profileScrollingTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(
		profileTableColumns, IE_VISIBLE, 15, nil, profileTableContainer, false, false)

	-- Dynamically resize "Name" column (index 2) to fill available width
	profileTableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = profileTableColumns[1].width + profileTableColumns[3].width + profileTableColumns[4].width + profileTableColumns[5].width
		local newNameWidth = math.max(200, w - fixedWidth - 30) -- 30 for internal padding/scrollbar
		profileTableColumns[2].width = newNameWidth
		profileScrollingTable:SetDisplayCols(profileTableColumns)
		if UpdateProfileActionButtons ~= nil then
			UpdateProfileActionButtons()
		end
	end)

	-- State for profile table and detail grid
	local selectedProfile = nil
	local checkboxState   = {}  -- { core=bool, [className]={ [specName]=bool } }

	-- Forward declarations for mutual recursion
	local RefreshProfileTable
	local RefreshDetailGrid
	local detailContainer

	-- ── Profile table refresh ──────────────────────────────────────────
	RefreshProfileTable = function()
		local names = TRB.Functions.Profiles:GetProfileNames()
		local selectedProfileStillExists = (selectedProfile == nil)
		if selectedProfile ~= nil then
			for _, profileName in ipairs(names) do
				if profileName == selectedProfile then
					selectedProfileStillExists = true
					break
				end
			end
			if not selectedProfileStillExists then
				selectedProfile = nil
				if RefreshDetailGrid ~= nil then
					RefreshDetailGrid(nil)
				end
			end
		end

		local dataTable = {}
		local selectedRealRow = nil
		for i, profileName in ipairs(names) do
			local specCount = TRB.Functions.Profiles:GetProfileSpecCount(profileName)
			local hasCore   = TRB.Functions.Profiles:ProfileHasCore(profileName)
			local isDefault = (profileName == TRB.Functions.Profiles.DEFAULT_NAME)
			dataTable[i] = {
				cols = {
					{ value = profileName },
					{ value = profileName },
					{ value = tostring(specCount) },
					{ value = hasCore and CreateAtlasMarkup("common-icon-checkmark", 14, 14) or "" },
					{ value = isDefault and "" or "X" },
				},
			}
			if profileName == selectedProfile then
				selectedRealRow = i
			end
		end
		profileScrollingTable:SetData(dataTable)
		profileScrollingTable:EnableSelection(true)
		if selectedRealRow ~= nil then
			profileScrollingTable:SetSelection(selectedRealRow)
		end

		if UpdateProfileActionButtons ~= nil then
			UpdateProfileActionButtons()
		end
	end

	profileScrollingTable:RegisterEvents({
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" and realrow ~= nil and realrow > 0 then
				local profileName = data[realrow].cols[1].value
				local isDefault = (profileName == TRB.Functions.Profiles.DEFAULT_NAME)

				if column == 5 and not isDefault then
					StaticPopup_Show("TwintopResourceBar_Profile_DeleteProfile_Confirm", nil, nil,
						{
							profileName = profileName,
							onComplete = function()
								if RefreshImportExportView ~= nil then
									RefreshImportExportView()
								end
							end,
						})
				else
					selectedProfile = profileName
					if RefreshDetailGrid ~= nil then
						RefreshDetailGrid(profileName)
					end
					if UpdateProfileActionButtons ~= nil then
						UpdateProfileActionButtons()
					end
				end
			end
		end,
	})

	yCoord = yCoord - profileTableContainer:GetHeight() + 10

	-- ── Profile-level action buttons (below table) ─────────────────────
	-- 5 buttons on one row, sized dynamically in UpdateProfileActionButtons
	-- to span the full table width with equal gaps. Seed with a reasonable
	-- width so first-layout sizing looks right before OnSizeChanged fires.
	local btnW = 140
	controls.buttons.renameProfile = TRB.Functions.OptionsUi.Primitives:BuildButton(
		parent, L["ProfileManagerActionRename"], 0, yCoord, btnW, 26)
	controls.buttons.copyFull = TRB.Functions.OptionsUi.Primitives:BuildButton(
		parent, L["ProfileManagerActionCopyFull"], 0, yCoord, btnW, 26)
	controls.buttons.copySelected = TRB.Functions.OptionsUi.Primitives:BuildButton(
		parent, L["ProfileManagerActionCopySelected"], 0, yCoord, btnW, 26)
	controls.buttons.exportFull = TRB.Functions.OptionsUi.Primitives:BuildButton(
		parent, L["ProfileManagerActionExportFull"], 0, yCoord, btnW, 26)
	controls.buttons.exportSelected = TRB.Functions.OptionsUi.Primitives:BuildButton(
		parent, L["ProfileManagerActionExportSelected"], 0, yCoord, btnW, 26)

	-- ── Action button handlers ─────────────────────────────────────
	controls.buttons.renameProfile:SetScript("OnClick", function()
		if selectedProfile == nil then return end
		StaticPopup_Show("TwintopResourceBar_Profile_RenameBarWide_Name", nil, nil, {
			profileName = selectedProfile,
			onComplete  = function(newName)
				selectedProfile = newName
				RefreshProfileTable()
				RefreshDetailGrid(newName)
			end,
		})
	end)

	controls.buttons.copyFull:SetScript("OnClick", function()
		if selectedProfile == nil then return end
		StaticPopup_Show("TwintopResourceBar_Profile_CopyBarWide_Name", nil, nil, {
			profileName = selectedProfile,
			mode        = "full",
			onComplete  = function(newName)
				RefreshProfileTable()
			end,
		})
	end)

	controls.buttons.copySelected:SetScript("OnClick", function()
		if selectedProfile == nil then return end
		StaticPopup_Show("TwintopResourceBar_Profile_CopyBarWide_Name", nil, nil, {
			profileName = selectedProfile,
			mode        = "selected",
			selection   = checkboxState,
			onComplete  = function(newName)
				RefreshProfileTable()
			end,
		})
	end)

	controls.buttons.exportFull:SetScript("OnClick", function()
		if selectedProfile == nil then return end
		local output, err = TRB.Functions.IO:ExportFullProfile(selectedProfile)
		if output == nil then
			local msg = (err == -2) and L["ProfileImportErrorEmpty"] or L["ProfileImportErrorGeneric"]
			StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
			return
		end
		StaticPopup_Show("TwintopResourceBar_Export", nil, nil, {
			message      = string.format(L["ProfileExportMessageFormat"], selectedProfile),
			exportString = output,
		})
	end)

	controls.buttons.exportSelected:SetScript("OnClick", function()
		if selectedProfile == nil then return end
		local output, err = TRB.Functions.IO:ExportProfileSelection(selectedProfile, checkboxState or {})
		if output == nil then
			local msg = (err == -2) and L["ProfileImportErrorEmpty"] or L["ProfileImportErrorGeneric"]
			StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
			return
		end
		StaticPopup_Show("TwintopResourceBar_Export", nil, nil, {
			message      = string.format(L["ProfileExportMessageFormat"], selectedProfile),
			exportString = output,
		})
	end)

	local detailTopYWithButtons = yCoord - 34
	local detailTopYWithoutButtons = yCoord

	-- ── Detail grid container ──────────────────────────────────────────
	-- "no profile selected" placeholder
	local noSelLabel = CreateFrame("Frame", nil, parent)
	noSelLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, detailTopYWithoutButtons)
	noSelLabel:SetWidth(590)
	noSelLabel:SetHeight(28)
	local noSelFS = noSelLabel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	noSelFS:SetAllPoints()
	noSelFS:SetJustifyH("CENTER")
	noSelFS:SetText(L["ProfileManagerNoProfileSelected"])

	-- Container for the actual class/spec grid (shown when a profile is selected)
	detailContainer = CreateFrame("Frame", nil, parent)
	detailContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, detailTopYWithoutButtons)
	detailContainer:SetWidth(590)
	detailContainer:SetHeight(900)
	detailContainer:Hide()

	-- "Profile Contents: NAME" header inside the container
	local contentsHeader = detailContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	contentsHeader:SetPoint("TOPLEFT", detailContainer, "TOPLEFT", 0, -2)
	contentsHeader:SetWidth(590)
	contentsHeader:SetHeight(24)
	contentsHeader:SetJustifyH("LEFT")

	-- ── Build class/spec rows (pre-built, state updated on profile change) ─
	-- Each row stores: frame, deleteBtn, exportBtn, checkbox, icon, label
	local classRowData = {}   -- [className] = { frame, delBtn, ... }
	local specRowData  = {}   -- [className.."_"..specName] = { frame, delBtn, exportBtn, cb, icon }
	local globalRowData

	local gridYStart = -26  -- below the contents-header inside detailContainer
	local colXOffsets = {}
	for colIndex = 1, IE_GRID_COLS do
		colXOffsets[colIndex] = (colIndex - 1) * (IE_COL_W + IE_COL_GAP)
	end

	local function SetButtonTooltip(frame, tooltipText)
		if frame == nil or tooltipText == nil or tooltipText == "" then
			return
		end
		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltipText, 1, 1, 1, nil, true)
			GameTooltip:Show()
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	local function GetDeleteClassTooltip(profileName, classLabel)
		if profileName == TRB.Functions.Profiles.DEFAULT_NAME then
			return string.format(L["ProfileManagerResetClassTooltipFormat"], classLabel)
		end
		return string.format(L["ProfileManagerDeleteClassTooltipFormat"], classLabel)
	end

	local function GetDeleteSpecTooltip(profileName, specLabel, classLabel)
		if profileName == TRB.Functions.Profiles.DEFAULT_NAME then
			return string.format(L["ProfileManagerResetSpecTooltipFormat"], specLabel, classLabel)
		end
		return string.format(L["ProfileManagerDeleteSpecTooltipFormat"], specLabel, classLabel)
	end

	local function GetDeleteGlobalTooltip(profileName)
		if profileName == TRB.Functions.Profiles.DEFAULT_NAME then
			return L["ProfileManagerResetGlobalTooltip"]
		end
		return L["ProfileManagerDeleteGlobalTooltip"]
	end

	local function BuildDeleteButton(parent, xOff, yOff)
		local btn = CreateFrame("Button", nil, parent)
		btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
		btn:SetWidth(18)
		btn:SetHeight(18)
		btn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		btn:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
		btn:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
		btn:GetNormalTexture():SetVertexColor(1, 0.3, 0.3)
		return btn
	end

	local function BuildExportButton(parent, xOff, yOff)
		local btn = CreateFrame("Button", nil, parent)
		btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
		btn:SetWidth(18)
		btn:SetHeight(18)
		btn:SetNormalTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
		btn:SetPushedTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
		btn:SetHighlightTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
		local pushed = btn:GetPushedTexture()
		if pushed then
			pushed:SetVertexColor(0.7, 0.7, 0.7)
		end
		local hl = btn:GetHighlightTexture()
		if hl then
			hl:SetBlendMode("ADD")
			hl:SetAlpha(0.4)
		end
		return btn
	end

	local function BuildCheckbox(parent, xOff, yOff)
		local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
		cb:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff + 1)
		cb:SetWidth(18)
		cb:SetHeight(18)
		return cb
	end

	local function BuildIcon(parent, xOff, yOff, size)
		local tex = parent:CreateTexture(nil, "OVERLAY")
		tex:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
		tex:SetWidth(size or 18)
		tex:SetHeight(size or 18)
		return tex
	end

	local function BuildLabel(parentF, xOff, yOff, w, txt, fontObj, height)
		local fs = parentF:CreateFontString(nil, "OVERLAY", fontObj or "GameFontHighlightSmall")
		fs:SetPoint("TOPLEFT", parentF, "TOPLEFT", xOff, yOff)
		fs:SetWidth(w)
		fs:SetHeight(height or 18)
		fs:SetJustifyH("LEFT")
		fs:SetText(txt)
		return fs
	end

	local function SetActionButtonEnabled(button, enabled)
		if enabled then
			button:Enable()
			button:SetAlpha(1.0)
		else
			button:Disable()
			button:SetAlpha(0.35)
		end
		if button.text then
			button.text:SetAlpha(enabled and 1.0 or 0.45)
		end
	end

	local function StripColorCodes(text)
		if type(text) ~= "string" then
			return ""
		end
		return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	end

	-- SPEC row button x-offsets (relative to column frame)
	local SPEC_INDENT = 8
	local SPEC_DEL_X  = SPEC_INDENT
	local SPEC_EXP_X  = SPEC_INDENT + 22
	local SPEC_CB_X   = SPEC_INDENT + 44
	local SPEC_ICO_X  = SPEC_INDENT + 64
	local SPEC_LBL_X  = SPEC_INDENT + 86
	local GLOBAL_LBL_X = SPEC_ICO_X

	-- CLASS row button x-offsets (aligned with spec buttons; only icon+label are indented)
	local CLS_DEL_X  = SPEC_DEL_X
	local CLS_ICO_X  = SPEC_ICO_X
	local CLS_LBL_X  = SPEC_LBL_X

	local curY = gridYStart

	local function BuildClassBlock(classDef, colX, baseY)
		if classDef == nil then return 0 end
		local className  = classDef.className
		local classToken = classDef.token
		local classLabel = classDef.classLabel

		local _, _, _, classColorHex = GetClassColor(classToken)
		local colStr = classColorHex and ("|c" .. classColorHex) or "|cffffffff"

		local hRow = CreateFrame("Frame", nil, detailContainer)
		hRow:SetPoint("TOPLEFT", detailContainer, "TOPLEFT", colX, baseY)
		hRow:SetWidth(IE_COL_W)
		hRow:SetHeight(IE_CLASS_H)

		local delBtn = BuildDeleteButton(hRow, CLS_DEL_X, -2)
		local expBtn = BuildExportButton(hRow, SPEC_EXP_X, -2)
		local cb = BuildCheckbox(hRow, SPEC_CB_X, -2)
		SetButtonTooltip(delBtn, string.format(L["ProfileManagerDeleteClassTooltipFormat"], classLabel))
		SetButtonTooltip(expBtn, string.format(L["ProfileManagerExportClassTooltipFormat"], classLabel))
		SetButtonTooltip(cb, string.format(L["ProfileManagerSelectClassTooltipFormat"], classLabel))
		local clsIcon = BuildIcon(hRow, CLS_ICO_X, -2, 18)
		clsIcon:SetAtlas("classicon-" .. className, false)
		local lbl = BuildLabel(hRow, CLS_LBL_X, -1, IE_COL_W - CLS_LBL_X - 4,
			colStr .. classLabel .. "|r", "GameFontNormal", 20)

		classRowData[className] = {
			frame = hRow,
			delBtn = delBtn,
			exportBtn = expBtn,
			checkbox = cb,
			iconTex = clsIcon,
			label = lbl,
			classId = classDef.classId,
			classDef = classDef,
		}

		local blockH = IE_CLASS_H
		for _, spec in ipairs(classDef.specs) do
			local specRow = CreateFrame("Frame", nil, detailContainer)
			specRow:SetPoint("TOPLEFT", detailContainer, "TOPLEFT", colX, baseY - blockH)
			specRow:SetWidth(IE_COL_W)
			specRow:SetHeight(IE_SPEC_H)

			local sDelBtn = BuildDeleteButton(specRow, SPEC_DEL_X, -2)
			local sExpBtn = BuildExportButton(specRow, SPEC_EXP_X, -2)
			local sCb = BuildCheckbox(specRow, SPEC_CB_X, -2)
			local specLabel = spec.specLabel
			SetButtonTooltip(sDelBtn, string.format(L["ProfileManagerDeleteSpecTooltipFormat"], specLabel, classLabel))
			SetButtonTooltip(sExpBtn, string.format(L["ProfileManagerExportSpecTooltipFormat"], specLabel, classLabel))
			SetButtonTooltip(sCb, string.format(L["ProfileManagerSelectSpecTooltipFormat"], specLabel, classLabel))
			local sIcon = BuildIcon(specRow, SPEC_ICO_X, -2, 18)
			if GetSpecializationInfoForClassID then
				local _, _, _, iconId = GetSpecializationInfoForClassID(classDef.classId, spec.specId)
				if iconId then
					sIcon:SetTexture(iconId)
				end
			end
			local sLbl = BuildLabel(specRow, SPEC_LBL_X, -2,
				IE_COL_W - SPEC_LBL_X - 4, specLabel)

			local key = className .. "_" .. spec.specName
			specRowData[key] = {
				frame = specRow,
				delBtn = sDelBtn,
				exportBtn = sExpBtn,
				checkbox = sCb,
				iconTex = sIcon,
				label = sLbl,
				className = className,
				specName = spec.specName,
				classId = classDef.classId,
				specId = spec.specId,
			}
			blockH = blockH + IE_SPEC_H
		end

		return blockH
	end

	local function BuildGlobalBlock(colX, baseY, width)
		local row = CreateFrame("Frame", nil, detailContainer)
		row:SetPoint("TOPLEFT", detailContainer, "TOPLEFT", colX, baseY)
		row:SetWidth(width or IE_COL_W)
		row:SetHeight(IE_CLASS_H)

		local delBtn = BuildDeleteButton(row, SPEC_DEL_X, -2)
		local expBtn = BuildExportButton(row, SPEC_EXP_X, -2)
		local cb = BuildCheckbox(row, SPEC_CB_X, -2)
		SetButtonTooltip(delBtn, L["ProfileManagerDeleteGlobalTooltip"])
		SetButtonTooltip(expBtn, L["ProfileManagerExportGlobalTooltip"])
		SetButtonTooltip(cb, L["ProfileManagerSelectGlobalTooltip"])
		local lbl = BuildLabel(row, GLOBAL_LBL_X, -1, (width or IE_COL_W) - GLOBAL_LBL_X - 4,
			L["ProfileScopeLabelGlobal"], "GameFontNormal", 20)

		globalRowData = {
			frame = row,
			delBtn = delBtn,
			exportBtn = expBtn,
			checkbox = cb,
			label = lbl,
		}

		return IE_CLASS_H
	end

	-- ── Global Default row (full-width, above the class grid) ──────────
	local gridFullWidth = (IE_COL_W * IE_GRID_COLS) + (IE_COL_GAP * (IE_GRID_COLS - 1))
	local globalBlockH = BuildGlobalBlock(0, curY, gridFullWidth)
	curY = curY - globalBlockH - IE_PAIR_GAP

	local layoutBlocks = {}
	for _, classDef in ipairs(PROFILE_CLASSES_ALPHA) do
		layoutBlocks[#layoutBlocks + 1] = {
			kind = "class",
			classDef = classDef,
		}
	end

	for blockIndex = 1, #layoutBlocks, IE_GRID_COLS do
		local rowH = 0
		for colIndex = 1, IE_GRID_COLS do
			local block = layoutBlocks[blockIndex + colIndex - 1]
			if block ~= nil then
				local blockH
				if block.kind == "class" then
					blockH = BuildClassBlock(block.classDef, colXOffsets[colIndex], curY)
				end
				if blockH > rowH then
					rowH = blockH
				end
			end
		end
		curY = curY - rowH - IE_PAIR_GAP
	end

	-- Adjust container height to match actual content
	detailContainer:SetHeight(math.abs(curY) + 20)

	UpdateProfileActionButtons = function()
		local hasSelection = selectedProfile ~= nil
		local isDefault = hasSelection and (selectedProfile == TRB.Functions.Profiles.DEFAULT_NAME)
		local canRename = hasSelection and not isDefault

		local allButtons = {
			controls.buttons.renameProfile,
			controls.buttons.copyFull,
			controls.buttons.copySelected,
			controls.buttons.exportFull,
			controls.buttons.exportSelected,
		}
		for _, btn in ipairs(allButtons) do
			if hasSelection then
				btn:Show()
			else
				btn:Hide()
			end
		end

		controls.buttons.renameProfile:SetEnabled(canRename)
		controls.buttons.copyFull:SetEnabled(hasSelection)
		controls.buttons.copySelected:SetEnabled(hasSelection)
		controls.buttons.exportFull:SetEnabled(hasSelection)
		controls.buttons.exportSelected:SetEnabled(hasSelection)

		-- Single row: 5 buttons sized to fill the table width with a small
		-- fixed gap between each. Dynamic sizing keeps the layout clean at
		-- any container width and gives room for longer localized labels.
		local tableWidth = profileTableContainer:GetWidth()
		local buttons = {
			controls.buttons.renameProfile,
			controls.buttons.copyFull,
			controls.buttons.copySelected,
			controls.buttons.exportFull,
			controls.buttons.exportSelected,
		}
		local count = #buttons
		local gap = 6
		local bw = math.max(60, math.floor((tableWidth - gap * (count - 1)) / count))
		for i, btn in ipairs(buttons) do
			btn:SetWidth(bw)
			local x = (i - 1) * (bw + gap)
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", profileTableContainer, "BOTTOMLEFT", x, -8)
		end

		noSelLabel:ClearAllPoints()
		detailContainer:ClearAllPoints()
		if hasSelection then
			noSelLabel:SetPoint("TOPLEFT", controls.buttons.renameProfile, "BOTTOMLEFT", 0, -8)
			detailContainer:SetPoint("TOPLEFT", controls.buttons.renameProfile, "BOTTOMLEFT", 0, -8)
		else
			noSelLabel:SetPoint("TOPLEFT", profileTableContainer, "BOTTOMLEFT", 0, -8)
			detailContainer:SetPoint("TOPLEFT", profileTableContainer, "BOTTOMLEFT", 0, -8)
		end
	end

	-- ── RefreshDetailGrid: update row states for a given profile ───────
	RefreshDetailGrid = function(profileName)
		if UpdateProfileActionButtons ~= nil then
			UpdateProfileActionButtons()
		end
		if profileName == nil then
			noSelLabel:Show()
			detailContainer:Hide()
			return
		end
		noSelLabel:Hide()
		detailContainer:Show()

		contentsHeader:SetText(string.format(L["ProfileManagerContentsHeaderFormat"], profileName))

		-- Reset checkbox state table
		checkboxState = { core = false }

		local Profiles = TRB.Functions.Profiles

		local function GetClassLabel(className)
			local classRow = classRowData[className]
			if classRow ~= nil and classRow.label ~= nil then
				return StripColorCodes(classRow.label:GetText() or className)
			end
			return className
		end

		local function GetExistingClassSpecs(className)
			local cd = classRowData[className]
			local existingSpecs = {}
			if cd and cd.classDef then
				for _, spec in ipairs(cd.classDef.specs) do
					if Profiles:ProfileExistsForSpec(profileName, className, spec.specName) then
						existingSpecs[#existingSpecs + 1] = spec.specName
					end
				end
			end
			return existingSpecs
		end

		local function IsClassComplete(className)
			local cd = classRowData[className]
			if cd == nil or cd.classDef == nil then
				return false
			end
			local existingSpecs = GetExistingClassSpecs(className)
			return #existingSpecs == #cd.classDef.specs
		end

		local function GetSpecPieceLabel(rowData)
			local specLabel = StripColorCodes(rowData.label:GetText() or rowData.specName)
			local classLabel = GetClassLabel(rowData.className)
			if classLabel ~= nil and classLabel ~= "" then
				return string.format("%s %s", specLabel, classLabel)
			end
			return specLabel
		end

		local function UpdateClassCheckboxState(className)
			local cd = classRowData[className]
			if cd == nil then
				return
			end

			local existingSpecs = GetExistingClassSpecs(className)
			local hasAny = #existingSpecs > 0
			local classIsComplete = hasAny and IsClassComplete(className)
			local allSelected = classIsComplete
			if allSelected then
				for _, spec in ipairs(cd.classDef.specs) do
					if not (checkboxState[className] and checkboxState[className][spec.specName]) then
						allSelected = false
						break
					end
				end
			end
			if not allSelected then
				cd.checkbox:SetChecked(false)
			else
				cd.checkbox:SetChecked(true)
			end

			cd.frame:SetAlpha(hasAny and 1.0 or 0.55)
			cd.checkbox:SetAlpha(classIsComplete and 1.0 or 0.55)
			if classIsComplete then
				cd.checkbox:Enable()
			else
				cd.checkbox:Disable()
			end
			SetActionButtonEnabled(cd.delBtn, hasAny)
			SetActionButtonEnabled(cd.exportBtn, hasAny)
		end

		-- Update spec rows
		for key, rd in pairs(specRowData) do
			local exists = Profiles:ProfileExistsForSpec(profileName, rd.className, rd.specName)
			local alpha  = exists and 1.0 or 0.55
			local specLabel = StripColorCodes(rd.label:GetText() or rd.specName)
			local classLabel = GetClassLabel(rd.className)
			SetButtonTooltip(rd.delBtn, GetDeleteSpecTooltip(profileName, specLabel, classLabel))

			rd.frame:SetAlpha(alpha)
			rd.checkbox:SetChecked(exists)
			if exists then
				rd.checkbox:Enable()
			else
				rd.checkbox:Disable()
			end
			if not checkboxState[rd.className] then
				checkboxState[rd.className] = {}
			end
			checkboxState[rd.className][rd.specName] = exists

			-- Delete button
			if exists then
				SetActionButtonEnabled(rd.delBtn, true)
				rd.delBtn:SetScript("OnClick", function()
					StaticPopup_Show("TwintopResourceBar_Profile_DeletePiece_Confirm", nil, nil, {
						profileName = profileName,
						className   = rd.className,
						specName    = rd.specName,
						pieceLabel  = GetSpecPieceLabel(rd),
						onComplete  = function()
							RefreshDetailGrid(selectedProfile)
						end,
					})
				end)
			else
				SetActionButtonEnabled(rd.delBtn, false)
				rd.delBtn:SetScript("OnClick", nil)
			end

			-- Export button
			if exists then
				SetActionButtonEnabled(rd.exportBtn, true)
				rd.exportBtn:SetScript("OnClick", function()
					local classId, specId = rd.classId, rd.specId
					StaticPopup_Show("TwintopResourceBar_Profile_ExportIncludeCore", nil, nil, {
						profileName = profileName,
						classId     = classId,
						specId      = specId,
						pieceLabel  = GetSpecPieceLabel(rd),
					})
				end)
			else
				SetActionButtonEnabled(rd.exportBtn, false)
				rd.exportBtn:SetScript("OnClick", nil)
			end

			-- Checkbox toggle updates checkboxState
			rd.checkbox:SetScript("OnClick", function(self)
				if not checkboxState[rd.className] then
					checkboxState[rd.className] = {}
				end
				checkboxState[rd.className][rd.specName] = self:GetChecked()
				UpdateClassCheckboxState(rd.className)
			end)
		end

		-- Update class-header delete/export/selection controls
		for className, cd in pairs(classRowData) do
			local existingSpecs = GetExistingClassSpecs(className)
			local classHasAny = #existingSpecs > 0
			local classIsComplete = classHasAny and IsClassComplete(className)
			local classLabel = StripColorCodes(cd.label:GetText() or className)
			SetButtonTooltip(cd.delBtn, GetDeleteClassTooltip(profileName, classLabel))
			if classHasAny then
				SetActionButtonEnabled(cd.delBtn, true)
				cd.delBtn:SetScript("OnClick", function()
					local pieceLabel = StripColorCodes(cd.label:GetText() or className)
					StaticPopup_Show("TwintopResourceBar_Profile_DeletePiece_Confirm", nil, nil, {
						profileName = profileName,
						className   = className,
						pieceLabel  = pieceLabel,
						onComplete  = function()
							RefreshDetailGrid(selectedProfile)
						end,
					})
				end)
				SetActionButtonEnabled(cd.exportBtn, true)
				cd.exportBtn:SetScript("OnClick", function()
					local pieceLabel = StripColorCodes(cd.label:GetText() or className)
					StaticPopup_Show("TwintopResourceBar_Profile_ExportIncludeCore", nil, nil, {
						profileName = profileName,
						classId = cd.classId,
						pieceLabel = pieceLabel,
					})
				end)
				if classIsComplete then
					cd.checkbox:Enable()
					cd.checkbox:SetScript("OnClick", function(self)
						local checked = self:GetChecked() == true
						checkboxState[className] = checkboxState[className] or {}
						for _, specName in ipairs(existingSpecs) do
							checkboxState[className][specName] = checked
							local rd = specRowData[className .. "_" .. specName]
							if rd ~= nil then
								rd.checkbox:SetChecked(checked)
							end
						end
						UpdateClassCheckboxState(className)
					end)
				else
					cd.checkbox:SetChecked(false)
					cd.checkbox:Disable()
					cd.checkbox:SetScript("OnClick", nil)
				end
			else
				SetActionButtonEnabled(cd.delBtn, false)
				cd.delBtn:SetScript("OnClick", nil)
				SetActionButtonEnabled(cd.exportBtn, false)
				cd.exportBtn:SetScript("OnClick", nil)
				cd.checkbox:SetChecked(false)
				cd.checkbox:Disable()
				cd.checkbox:SetScript("OnClick", nil)
			end
			UpdateClassCheckboxState(className)
		end

		-- Global Options row
		local hasCore = Profiles:ProfileHasCore(profileName)
		checkboxState.core = hasCore
		SetButtonTooltip(globalRowData.delBtn, GetDeleteGlobalTooltip(profileName))
		globalRowData.frame:SetAlpha(hasCore and 1.0 or 0.55)
		globalRowData.checkbox:SetChecked(hasCore)
		if hasCore then
			globalRowData.checkbox:Enable()
		else
			globalRowData.checkbox:Disable()
		end
		globalRowData.checkbox:SetScript("OnClick", function(self)
			checkboxState.core = self:GetChecked()
		end)
		if hasCore then
			SetActionButtonEnabled(globalRowData.delBtn, true)
			globalRowData.delBtn:SetScript("OnClick", function()
				StaticPopup_Show("TwintopResourceBar_Profile_DeletePiece_Confirm", nil, nil, {
					profileName = profileName,
					isCore      = true,
					onComplete  = function()
						RefreshDetailGrid(selectedProfile)
					end,
				})
			end)
			SetActionButtonEnabled(globalRowData.exportBtn, true)
			globalRowData.exportBtn:SetScript("OnClick", function()
				local output, err = TRB.Functions.IO:ExportCoreProfile(profileName)
				if output == nil then
					local msg = (err == -2) and L["ProfileImportErrorEmpty"] or L["ProfileImportErrorGeneric"]
					StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
					return
				end
				StaticPopup_Show("TwintopResourceBar_Export", nil, nil, {
					message      = string.format(L["ProfileExportMessageTargetFormat"], L["ProfileScopeLabelGlobal"], profileName),
					exportString = output,
				})
			end)
		else
			SetActionButtonEnabled(globalRowData.delBtn, false)
			globalRowData.delBtn:SetScript("OnClick", nil)
			SetActionButtonEnabled(globalRowData.exportBtn, false)
			globalRowData.exportBtn:SetScript("OnClick", nil)
		end
	end

	RefreshImportExportView = function()
		RefreshProfileTable()
		RefreshDetailGrid(selectedProfile)
		if UpdateProfileActionButtons ~= nil then
			UpdateProfileActionButtons()
		end
	end

	-- Initial state
	RefreshImportExportView()

	topPanel:HookScript("OnShow", function()
		RefreshImportExportView()
	end)

	-- Update total scroll child height
	local totalContentH = math.abs(yCoord) + math.abs(curY) + 60
	scrollChild:SetHeight(totalContentH)
end

---Builds a single "default profile" row: a label on the left and a dropdown
---on the right that lets the user pick which profile to use as the default
---for the given scope. Returns the dropdown and the next y offset.
---@param parent Frame
---@param yCoord number
---@param rowLabel string
---@param scope "core"|"spec"
---@param className string?
---@param specName string?
---@param iconArg (string|number)? # atlas name (string) or texture file id (number)
---@param iconIsAtlas boolean? # true if iconArg is an atlas name
---@return DropdownButton dropdown, number nextY
local function BuildProfileDefaultRow(parent, yCoord, rowLabel, scope, className, specName, iconArg, iconIsAtlas)
	local labelFrame = CreateFrame("Frame", nil, parent)
	labelFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord + oUi.xPadding * 2, yCoord)
	labelFrame:SetSize(320, 22)

	local iconOffset = 0
	if iconArg ~= nil then
		local iconTex = labelFrame:CreateTexture(nil, "ARTWORK")
		iconTex:SetPoint("LEFT", labelFrame, "LEFT", 0, 0)
		iconTex:SetSize(20, 20)
		if iconIsAtlas then
			iconTex:SetAtlas(iconArg, false)
		else
			iconTex:SetTexture(iconArg)
		end
		iconOffset = 24
	end

	local labelText = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	labelText:SetPoint("LEFT", labelFrame, "LEFT", iconOffset, 0)
	labelText:SetJustifyH("LEFT")
	labelText:SetText(rowLabel)

	local namePrefix = "TwintopResourceBar_ProfileDefaults_"
	if scope == "core" then
		namePrefix = namePrefix .. "Core"
	else
		namePrefix = namePrefix .. tostring(className) .. "_" .. tostring(specName)
	end

	local dropdown = CreateFrame("DropdownButton", namePrefix, parent, "WowStyle1DropdownTemplate")
	dropdown:SetPoint("TOPLEFT", labelFrame, "TOPRIGHT", 0, 4)
	dropdown:SetWidth(240)

	local function GetCurrent()
		if scope == "core" then
			return TRB.Functions.Profiles:GetDefaultCoreProfileName() or TRB.Functions.Profiles.DEFAULT_NAME
		end
		return TRB.Functions.Profiles:GetDefaultSpecProfileName(className, specName) or TRB.Functions.Profiles.DEFAULT_NAME
	end

	local function IsSelected(value)
		return value == GetCurrent()
	end

	local function SetSelected(value)
		if scope == "core" then
			TRB.Functions.Profiles:SetDefaultCoreProfileName(value)
		else
			TRB.Functions.Profiles:SetDefaultSpecProfileName(className, specName, value)
		end
		if dropdown.UpdateButtonText then
			dropdown:UpdateButtonText()
		end
	end

	local function Generator(_, rootDescription)
		local names
		if scope == "core" then
			names = TRB.Functions.Profiles:ListCoreProfileNames()
		else
			names = TRB.Functions.Profiles:ListSpecProfileNames(className, specName)
		end
		for _, profileName in ipairs(names) do
			rootDescription:CreateRadio(profileName, IsSelected, SetSelected, profileName)
		end
	end

	dropdown.GeneratorFunction = Generator
	dropdown:SetupMenu(Generator)

	local function UpdateButtonText()
		local activeName = GetCurrent()
		local text = string.format(L["ProfileDropdownButtonFormat"], activeName)
		if type(dropdown.SetDefaultText) == "function" then
			dropdown:SetDefaultText(text)
		elseif dropdown.Text ~= nil and type(dropdown.Text.SetText) == "function" then
			dropdown.Text:SetText(text)
		end
	end
	dropdown.UpdateButtonText = UpdateButtonText
	UpdateButtonText()

	dropdown:HookScript("OnHide", UpdateButtonText)
	dropdown:HookScript("OnShow", function()
		if dropdown.SetupMenu and dropdown.GeneratorFunction then
			dropdown:SetupMenu(dropdown.GeneratorFunction)
		end
		UpdateButtonText()
	end)

	return dropdown, yCoord - 30
end

---Builds a class-section header for the Profile Defaults panel: a classicon
---atlas plus a class-coloured label. Returns the frame and the next y offset.
---@param parent Frame
---@param yCoord number
---@param classToken string # uppercase class token (e.g. "DEATHKNIGHT")
---@param className string # lowercase class key used by `classicon-<name>` atlas
---@param classLabel string
---@return Frame headerFrame, number nextY
local function BuildProfileDefaultsClassHeader(parent, yCoord, classToken, className, classLabel)
	local headerFrame = CreateFrame("Frame", nil, parent)
	headerFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	headerFrame:SetSize(500, 26)

	local iconTex = headerFrame:CreateTexture(nil, "ARTWORK")
	iconTex:SetPoint("LEFT", headerFrame, "LEFT", 0, 0)
	iconTex:SetSize(22, 22)
	iconTex:SetAtlas("classicon-" .. className, false)

	local _, _, _, classColorHex = GetClassColor(classToken)
	local colStr = classColorHex and ("|c" .. classColorHex) or "|cffffffff"

	local headerText = headerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerText:SetPoint("LEFT", iconTex, "RIGHT", 6, 0)
	headerText:SetJustifyH("LEFT")
	headerText:SetText(colStr .. classLabel .. "|r")

	return headerFrame, yCoord - 28
end

---Constructs the Profile Defaults panel. Shows one dropdown per spec (plus one
---for Global Options) to pick which profile a new character uses on first
---login, before the user assigns a per-character profile.
local function ConstructProfileDefaultsPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.profileDefaults or {}
	interfaceSettingsFrame.controls.profileDefaults = controls
	controls.dropDowns = controls.dropDowns or {}

	interfaceSettingsFrame.profileDefaultsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_ProfileDefaults")
	TRB.Options.OptionsFrame:RegisterCategory("profileDefaults",
		L["ProfileDefaults"],
		interfaceSettingsFrame.profileDefaultsPanel)

	local topPanel = interfaceSettingsFrame.profileDefaultsPanel

	topPanel.panel = TRB.Functions.OptionsUi.Tabs:CreateTabFrameContainer(
		"TwintopResourceBar_ProfileDefaults_LayoutPanel", topPanel)
	topPanel.panel:SetPoint("TOPLEFT", oUi.xCoord, -5)
	topPanel.panel:Show()

	local scrollChild = topPanel.panel.scrollFrame.scrollChild
	local parent = scrollChild
	local yCoord = 5

	controls.header = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(
		parent, L["ProfileDefaultsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	local descriptionFrame = CreateFrame("Frame", nil, parent)
	descriptionFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	descriptionFrame:SetSize(600, 40)
	local descriptionText = descriptionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	descriptionText:SetPoint("TOPLEFT", descriptionFrame, "TOPLEFT", 0, 0)
	descriptionText:SetWidth(600)
	descriptionText:SetJustifyH("LEFT")
	descriptionText:SetText(L["ProfileDefaultsDescription"])
	yCoord = yCoord - 45

	-- Global Options row (uses the TRB addon icon).
	controls.dropDowns.core, yCoord = BuildProfileDefaultRow(
		parent, yCoord, L["GlobalOptions"], "core", nil, nil, 1386550, false)
	yCoord = yCoord - 10

	-- Per-class section with one row per spec, ordered alphabetically by class name.
	for _, classDef in ipairs(PROFILE_CLASSES_ALPHA) do
		controls["classHeader_" .. classDef.className] = BuildProfileDefaultsClassHeader(
			parent, yCoord, classDef.token, classDef.className, classDef.classLabel)
		yCoord = yCoord - 28

		controls.dropDowns[classDef.className] = controls.dropDowns[classDef.className] or {}
		for _, specDef in ipairs(classDef.specs) do
			local specIconId
			if GetSpecializationInfoForClassID then
				local _, _, _, iconId = GetSpecializationInfoForClassID(classDef.classId, specDef.specId)
				specIconId = iconId
			end
			controls.dropDowns[classDef.className][specDef.specName], yCoord = BuildProfileDefaultRow(
				parent, yCoord, specDef.specFullLabel,
				"spec", classDef.className, specDef.specName,
				specIconId, false)
		end
		yCoord = yCoord - 10
	end

	-- Re-read current defaults when the panel is shown so dropdowns reflect
	-- any CRUD operations that happened while another panel was visible.
	topPanel:HookScript("OnShow", function()
		local function RefreshRow(dropdown)
			if dropdown == nil then return end
			if dropdown.SetupMenu and dropdown.GeneratorFunction then
				dropdown:SetupMenu(dropdown.GeneratorFunction)
			end
			if dropdown.UpdateButtonText then
				dropdown:UpdateButtonText()
			end
		end
		RefreshRow(controls.dropDowns.core)
		for classKey, specs in pairs(controls.dropDowns) do
			if classKey ~= "core" and type(specs) == "table" then
				for _, dd in pairs(specs) do
					RefreshRow(dd)
				end
			end
		end
	end)

	scrollChild:SetHeight(math.abs(yCoord) + 60)
end


---Constructs the top-level addon options panel, registers it with Blizzard's settings UI, and builds the global options, import/export, and class/spec navigation entries. Idempotent: only executes once.
function TRB.Options:ConstructOptionsPanel()
	-- Idempotency guard: this function is called by every class module's ConstructOptionsPanel.
	-- Only execute once; subsequent calls are no-ops.
	if TRB.Options._globalPanelConstructed then
		return
	end
	TRB.Options._globalPanelConstructed = true

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls = {}
	local controls = interfaceSettingsFrame.controls
	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.panel = CreateFrame("Frame", "TwintopResourceBarPanel")
	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.panel.name = L["TwintopsResourceBar"]
	interfaceSettingsFrame.panel:HookScript("OnShow", function(self)
	end)
	local parent = interfaceSettingsFrame.panel
	local yCoord = -5

	interfaceSettingsFrame.controls.barPositionSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, TRB.Details.addonTitle, oUi.xCoord+oUi.xPadding, yCoord)

	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoAuthor = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, L["Author"] .. ":", TRB.Details.addonAuthor .. " - " .. TRB.Details.addonAuthorServer, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 15)
	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoVersion = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, L["Version"] .. ":", TRB.Details.addonVersion, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 15)
	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoReleased = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, L["Released"] .. ":", TRB.Details.addonReleaseDate, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 15)
	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoSupport = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, L["SupportedSpecs"] .. ":", TRB.Details.supportedSpecs, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 300)

	local flagPathTemplate = "|TInterface\\AddOns\\TwintopInsanityBar\\Images\\Flags\\%s.tga:0|t   %s"
	local localeText1 = string.format(flagPathTemplate, "deDE", "deDE")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "enGB", "enGB")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "enUS", "enUS")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "esES", "esES")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "esMX", "esMX")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "frFR", "frFR")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "itIT", "itIT")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "koKR", "koKR")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "ptBR", "ptBR")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "ptPT", "ptPT")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "ruRU", "ruRU")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "zhCN", "zhCN")
	localeText1 = localeText1 .. "\n" .. string.format(flagPathTemplate, "zhTW", "zhTW")

	local percentFormat = "%3.2f%%"
	local localeText2 = string.format(percentFormat, 57.07)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 12.91)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 8.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.25)

	local localeText3 = "Triplehxh, SanTM, unfung"
	localeText3 = localeText3 .. "\n" .. "Twintop"
	localeText3 = localeText3 .. "\n" .. "Twintop"
	localeText3 = localeText3 .. "\n" .. "Se necesita traductor!"
	localeText3 = localeText3 .. "\n" .. "Se necesita traductor!"
	localeText3 = localeText3 .. "\n" .. "Koroshy"
	localeText3 = localeText3 .. "\n" .. "Traduttore necessario!"
	localeText3 = localeText3 .. "\n" .. "번역기가 필요합니다!"
	localeText3 = localeText3 .. "\n" .. "Precisa-se de tradutor!"
	localeText3 = localeText3 .. "\n" .. "Precisa-se de tradutor!"
	localeText3 = localeText3 .. "\n" .. "Требуется переводчик!"
	localeText3 = localeText3 .. "\n" .. " "
	localeText3 = localeText3 .. "\n" .. " "

	local localeText4 = " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. " "
	localeText4 = localeText4 .. "\n" .. "M.O.S.S"
	localeText4 = localeText4 .. "\n" .. "需要翻譯！"


	yCoord = yCoord - 180
	interfaceSettingsFrame.controls.labels.localization1 = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, "Localization" .. ":", localeText1, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 100, 15, 300)
	interfaceSettingsFrame.controls.labels.localization2 = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, "", localeText2, oUi.xCoord+(oUi.xPadding*2)+50, yCoord, 0, 100, 15, 300, "RIGHT")
	interfaceSettingsFrame.controls.labels.localization3 = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, "", localeText3, oUi.xCoord+(oUi.xPadding*2)+200, yCoord, 0, 375, 15, 300)
	interfaceSettingsFrame.controls.labels.localization4 = TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, "", localeText4, oUi.xCoord+(oUi.xPadding*2)+200, yCoord, 0, 375, 15, 300, nil, [[Fonts\ARHei.TTF]])

	yCoord = yCoord - 140

	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.panel.yCoord = yCoord
	TRB.Details.addonCategory = TRB.Details.addonCategory or {}
	TRB.Details.addonCategory.specs = TRB.Details.addonCategory.specs or {}

	-- Register the info panel with the standalone options frame (always at bottom of nav)
	TRB.Options.OptionsFrame:RegisterBottomCategory("main", L["AboutTwintopsResourceBar"], interfaceSettingsFrame.panel)

	-- Create a minimal stub in Blizzard's addon settings
	local blizzardStub = CreateFrame("Frame", "TwintopResourceBarPanel_BlizzardStub")
	local stubTitle = blizzardStub:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	stubTitle:SetPoint("TOPLEFT", 16, -16)
	stubTitle:SetText(L["TwintopsResourceBar"])
	local stubDesc = blizzardStub:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	stubDesc:SetPoint("TOPLEFT", stubTitle, "BOTTOMLEFT", 0, -8)
	stubDesc:SetText(L["OpenTRBOptionsDescription"])
	local stubButton = CreateFrame("Button", nil, blizzardStub, "UIPanelButtonTemplate")
	stubButton:SetSize(260, 30)
	stubButton:SetPoint("TOPLEFT", stubDesc, "BOTTOMLEFT", 0, -12)
	stubButton:SetText(L["OpenTRBOptions"])
	stubButton:SetScript("OnClick", function()
		TRB.Options.OptionsFrame:Show()
	end)
	TRB.Details.addonCategory.main, _ = Settings.RegisterCanvasLayoutCategory(blizzardStub, L["TwintopsResourceBar"])
	Settings.RegisterAddOnCategory(TRB.Details.addonCategory.main)

	ConstructGlobalOptionsPanel()
	ConstructCastbarOptionsPanel()
	ConstructOtherBarsOptionsPanel()
	ConstructImportExportPanel()
	ConstructProfileDefaultsPanel()

	-- Register all class headers and spec nav entries (with nil panels).
	-- The active class's ConstructOptionsPanel will update its specs with real panels via RegisterSpecPanel.
	-- Non-active classes appear in the nav but have no panels until lazy loading is implemented.
	TRB.Options:RegisterAllClassSpecNavEntries()

	TRB.Options.OptionsFrame:RefreshNav()
end

--- Ordered list of all classes and their specs for nav registration.
--- Each entry stores the resolved localized string for class headers and spec labels.
--- Exposed on TRB.Data so other modules (OptionsUi copy menus, etc.) can reuse it
--- instead of duplicating class/spec metadata.
---@type {classKey: string, classLabel: string, specs: {compositeKey: string, specLabel: string}[]}[]
TRB.Data.allClassSpecs = {}
for _, classDef in ipairs(PROFILE_CLASSES_ALPHA) do
	local specs = {}
	for _, specDef in ipairs(classDef.specs) do
		table.insert(specs, {
			compositeKey = specDef.compositeKey,
			specLabel = specDef.specFullLabel,
		})
	end
	table.insert(TRB.Data.allClassSpecs, {
		classKey = classDef.className,
		classLabel = classDef.classLabel,
		specs = specs,
	})
end

---Lazily build all options panels for a class.
---Ensures specCache entries and settings exist, then calls the class's ConstructOptionsPanel.
---@param classKey string # Lowercase class key (e.g., "warrior")
function TRB.Options:BuildClassPanels(classKey)
	local moduleKey = TRB.Functions.Character:GetClassModuleName(classKey)
	if not moduleKey or not TRB.Options[moduleKey] or not TRB.Options[moduleKey].ConstructOptionsPanel then
		return
	end

	-- Ensure specCache entries exist for all specs in this class
	for _, classDef in ipairs(TRB.Data.allClassSpecs) do
		if classDef.classKey == classKey then
			for _, specDef in ipairs(classDef.specs) do
				TRB.Functions.Character:EnsureSpecCache(specDef.compositeKey)
			end
			break
		end
	end

	-- Build all panels for this class.
	-- The class constructor calls TRB.Options:ConstructOptionsPanel() internally (idempotent no-op),
	-- then builds per-spec panels and registers them via RegisterSpecPanel.
	TRB.Options[moduleKey].ConstructOptionsPanel(TRB.Data.specCache)
end

---Register all class headers and spec nav entries in the options frame.
---Classes are sorted alphabetically by their localized name.
---Specs within each class remain in specializationId order.
---Each spec gets a lazy builder that constructs all panels for its class on first click.
function TRB.Options:RegisterAllClassSpecNavEntries()
	local L = TRB.Localization

	-- Build a sorted shallow copy so classes appear alphabetically by localized name
	local sorted = {}
	for i, classDef in ipairs(TRB.Data.allClassSpecs) do
		sorted[i] = classDef
	end
	table.sort(sorted, function(a, b)
		return a.classLabel < b.classLabel
	end)

	for _, classDef in ipairs(sorted) do
		TRB.Options.OptionsFrame:RegisterClassHeader(classDef.classKey, classDef.classLabel)

		-- Create a builder that lazily constructs all spec panels for this class
		local classKeyCapture = classDef.classKey
		local builder = function()
			TRB.Options:BuildClassPanels(classKeyCapture)
		end

		for _, specDef in ipairs(classDef.specs) do
			TRB.Options.OptionsFrame:RegisterSpecPanel(classDef.classKey, specDef.compositeKey, specDef.specLabel, nil, builder)
		end
	end
end

---Creates and displays the bar text customization instructions label in the given parent frame.
---@param parent Frame The parent frame to anchor the instructions label to
---@param xCoord number The x-coordinate offset for positioning the label
---@param yCoord number The y-coordinate offset for positioning the label
function TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
	local maxOptionsWidth = 550
	local barTextInstructionsHeight = 400
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, TRB.Options.variables.barTextInstructions, xCoord+5, yCoord, maxOptionsWidth-(2*(xCoord+5)), barTextInstructionsHeight, GameFontHighlight, "LEFT")
end


---Creates and displays help entries for all bar text variables (values, pipes, and icons) from the given spec cache.
---@param cache table The spec cache containing barTextVariables with values, pipe, and icons arrays
---@param parent Frame The parent frame to anchor the help entries to
---@param xCoord number The x-coordinate offset for positioning the entries
---@param yCoord number The y-coordinate offset for positioning the entries
function TRB.Options:CreateBarTextVariables(cache, parent, xCoord, yCoord)
	local height = 15
	local width = 260
	local entries1 = TRB.Functions.Table:Length(cache.barTextVariables.values)
	for i=1, entries1 do
		if cache.barTextVariables.values[i].printInSettings == true then
			TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.values[i].variable, cache.barTextVariables.values[i].description, xCoord, yCoord, 0, width, height)
			yCoord = yCoord - (height * 3) - 5
		end
	end

	local entries2 = TRB.Functions.Table:Length(cache.barTextVariables.pipe)
	for i=1, entries2 do
		if cache.barTextVariables.pipe[i].printInSettings == true then
			TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.pipe[i].variable, cache.barTextVariables.pipe[i].description, xCoord, yCoord, 0, width, height)
			yCoord = yCoord - (height * 3) - 5
		end
	end

	---------

	local entries3 = TRB.Functions.Table:Length(cache.barTextVariables.icons)
	for i=1, entries3 do
		if cache.barTextVariables.icons[i].printInSettings == true then
			local text = ""
			if cache.barTextVariables.icons[i].icon ~= "" then
				text = cache.barTextVariables.icons[i].icon .. " "
			end
			TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.icons[i].variable, text .. cache.barTextVariables.icons[i].description, xCoord, yCoord, 0, width, height)
			yCoord = yCoord - (height * 3) - 5
		end
	end
end
