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

TRB.Options.fonts = {}
TRB.Options.fonts.options = {}
TRB.Options.fonts.options.tabHighlightSmall = f1
TRB.Options.fonts.options.tabGreenSmall = f2
TRB.Options.fonts.options.tabNormalSmall = f3
TRB.Options.fonts.options.exportSpec = f4

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

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, nil, nil, yCoord)
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

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"])
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

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"])
	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, nil, nil, yCoord)
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

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, nil, nil, yCoord, true, L["ResourceComboPoints"])
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

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"], "notFull", true, L["ResourceComboPoints"], true, nil, customBars)
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
	
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, nil, nil, yCoord)
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

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, nil, nil, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["GlobalTextColorsHeader"], oUi.xCoord, yCoord)

	-- Global options panel - add bulk toggle checkbox for text colors
	yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllTextColors", "textColors", yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextPassive"], spec.colors.text.passive.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextSpending"], spec.colors.text.spending.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, nil, nil, yCoord)
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

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarSettings"], oUi.xCoord, yCoord)

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
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["TimerPrecision"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50
	title = L["TimerBelowPrecision"]
	controls.timersLowPrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.timers.precisionLow, 1, 0,
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
	controls.timersHighPrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.timers.precisionHigh, 1, 0,
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
	controls.timersPrecisionThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 600, TRB.Data.settings.core.timers.precisionThreshold, 0.1, 2,
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
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["CharacterPlayerSettings"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50

	title = L["DataRefreshRate"]
	controls.characterRefreshRate = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.05, 60, TRB.Data.settings.core.dataRefreshRate, 0.05, 2,
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
	controls.reactionTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.00, 1, TRB.Data.settings.core.reactionTime, 0.05, 2,
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
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FrameStrata"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	
	local strataDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_frameStrata", parent, "WowStyle1DropdownTemplate")
	strataDropdown:SetWidth(oUi.sliderWidth)
	strataDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FrameStrataDescription"], oUi.xCoord, yCoord)
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
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioChannel"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30


	local comboPointsAudioChannel = CreateFrame("DropdownButton", "TwintopResourceBar_frameAudioChannel", parent, "WowStyle1DropdownTemplate")
	comboPointsAudioChannel:SetWidth(oUi.sliderWidth)
	comboPointsAudioChannel.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioChannelDescription"], oUi.xCoord, yCoord)
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
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ExperimentalFeatures"], oUi.xCoord, yCoord)

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

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EditModeSettings"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.buttons.resetEditModeData = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetEditModeDataButton"], oUi.xCoord, yCoord, 200, 30)
	controls.buttons.resetEditModeData:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_ResetEditModeData")
	end)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetGlobalBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.buttons.resetGlobalBarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetGlobalBarText"], oUi.xCoord, yCoord, 250, 30)
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

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 10

	-- Build a lightweight cache object with global-applicable barTextVariables
	local globalCache = {
		barTextVariables = {
			icons = TRB.Functions.BarText:GetCommonIcons(),
			values = TRB.Functions.BarText:GetCommonValues({
				{ variable = "$resource", description = L["GlobalBarTextVariable_resource"], printInSettings = true, color = false },
				{ variable = "$resourceMax", description = L["GlobalBarTextVariable_resourceMax"], printInSettings = true, color = false },
				{ variable = "$casting", description = L["GlobalBarTextVariable_casting"], printInSettings = true, color = false },
				{ variable = "$comboPoints", description = L["GlobalBarTextVariable_comboPoints"] .. " " .. L["GlobalBarTextWarningComboPoints"], printInSettings = true, color = false },
				{ variable = "$comboPointsMax", description = L["GlobalBarTextVariable_comboPointsMax"] .. " " .. L["GlobalBarTextWarningComboPoints"], printInSettings = true, color = false },
			}),
		}
	}

	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, TRB.Data.settings.core, nil, nil, yCoord, globalCache)
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

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["GlobalOptions"], oUi.xCoord, yCoord - 5)

	-- Profile dropdown for core-scope settings. Replaces the legacy Import button.
	controls.profileDropdown = TRB.Functions.OptionsUi:BuildProfileDropdown(parent, yCoord - 10, "core", nil, nil, L["GlobalOptions"])

	yCoord = yCoord - 37

	-- Must assign controls before BuildTabGroup, since constructors read interfaceSettingsFrame.controls.global
	TRB.Frames.interfaceSettingsFrameContainer.controls.global = controls

	local tabDefinitions = {
		{ "resourceBar", L["TabResource"], oUi.tabWidth.small, ConstructResourceBarPanel },
		{ "comboPointsBar", L["TabComboPoints"], oUi.tabWidth.small, ConstructComboPointsBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, ConstructHealthBarPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, ConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, ConstructBarVisibilityPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, ConstructThresholdPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, ConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, ConstructGlobalBarTextPanel },
		{ "miscellaneous", L["TabMiscellaneous"], oUi.tabWidth.medium, ConstructMiscellaneousPanel },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, ConstructResetDefaultsPanel },
	}

	TRB.Functions.OptionsUi:BuildTabGroup(parent, "Global", tabDefinitions, yCoord)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
end

---Constructs a single import/export row with label and export buttons for a class, spec, or all-specs group.
---@param parent Frame
---@param yCoord integer
---@param controls table
---@param classId integer?
-- ─────────────────────────────────────────────────────────────────────
-- Alphabetically-ordered class/spec table for the profile manager grid.
-- classToken is the uppercase token used with GetClassColor().
-- ─────────────────────────────────────────────────────────────────────
local PROFILE_CLASSES_ALPHA = {
	{classId=6,  className="deathknight", token="DEATHKNIGHT", locKey="DeathKnight",
	 specs={{specId=1,specName="blood",       locKey="DeathKnightBlood"},
	        {specId=2,specName="frost",       locKey="DeathKnightFrost"},
	        {specId=3,specName="unholy",      locKey="DeathKnightUnholy"}}},
	{classId=12, className="demonhunter",  token="DEMONHUNTER",  locKey="DemonHunter",
	 specs={{specId=1,specName="havoc",       locKey="DemonHunterHavoc"},
	        {specId=2,specName="vengeance",   locKey="DemonHunterVengeance"},
	        {specId=3,specName="devourer",    locKey="DemonHunterDevourer"}}},
	{classId=11, className="druid",        token="DRUID",        locKey="Druid",
	 specs={{specId=1,specName="balance",     locKey="DruidBalance"},
	        {specId=2,specName="feral",       locKey="DruidFeral"},
	        {specId=3,specName="guardian",    locKey="DruidGuardian"},
	        {specId=4,specName="restoration", locKey="DruidRestoration"}}},
	{classId=13, className="evoker",       token="EVOKER",       locKey="Evoker",
	 specs={{specId=1,specName="devastation",  locKey="EvokerDevastation"},
	        {specId=2,specName="preservation", locKey="EvokerPreservation"},
	        {specId=3,specName="augmentation", locKey="EvokerAugmentation"}}},
	{classId=3,  className="hunter",       token="HUNTER",       locKey="Hunter",
	 specs={{specId=1,specName="beastmastery", locKey="HunterBeastMastery"},
	        {specId=2,specName="marksmanship", locKey="HunterMarksmanship"},
	        {specId=3,specName="survival",     locKey="HunterSurvival"}}},
	{classId=8,  className="mage",         token="MAGE",         locKey="Mage",
	 specs={{specId=1,specName="arcane",      locKey="MageArcane"},
	        {specId=2,specName="fire",        locKey="MageFire"},
	        {specId=3,specName="frost",       locKey="MageFrost"}}},
	{classId=10, className="monk",         token="MONK",         locKey="Monk",
	 specs={{specId=1,specName="brewmaster",  locKey="MonkBrewmaster"},
	        {specId=2,specName="mistweaver",  locKey="MonkMistweaver"},
	        {specId=3,specName="windwalker",  locKey="MonkWindwalker"}}},
	{classId=2,  className="paladin",      token="PALADIN",      locKey="Paladin",
	 specs={{specId=1,specName="holy",        locKey="PaladinHoly"},
	        {specId=2,specName="protection",  locKey="PaladinProtection"},
	        {specId=3,specName="retribution", locKey="PaladinRetribution"}}},
	{classId=5,  className="priest",       token="PRIEST",       locKey="Priest",
	 specs={{specId=1,specName="discipline",  locKey="PriestDiscipline"},
	        {specId=2,specName="holy",        locKey="PriestHoly"},
	        {specId=3,specName="shadow",      locKey="PriestShadow"}}},
	{classId=4,  className="rogue",        token="ROGUE",        locKey="Rogue",
	 specs={{specId=1,specName="assassination",locKey="RogueAssassination"},
	        {specId=2,specName="outlaw",      locKey="RogueOutlaw"},
	        {specId=3,specName="subtlety",    locKey="RogueSubtlety"}}},
	{classId=7,  className="shaman",       token="SHAMAN",       locKey="Shaman",
	 specs={{specId=1,specName="elemental",   locKey="ShamanElemental"},
	        {specId=2,specName="enhancement", locKey="ShamanEnhancement"},
	        {specId=3,specName="restoration", locKey="ShamanRestoration"}}},
	{classId=9,  className="warlock",      token="WARLOCK",      locKey="Warlock",
	 specs={{specId=1,specName="affliction",  locKey="WarlockAffliction"},
	        {specId=2,specName="demonology",  locKey="WarlockDemonology"},
	        {specId=3,specName="destruction", locKey="WarlockDestruction"}}},
	{classId=1,  className="warrior",      token="WARRIOR",      locKey="Warrior",
	 specs={{specId=1,specName="arms",        locKey="WarriorArms"},
	        {specId=2,specName="fury",        locKey="WarriorFury"},
	        {specId=3,specName="protection",  locKey="WarriorProtection"}}},
}

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
	topPanel.panel = TRB.Functions.OptionsUi:CreateTabFrameContainer(
		"TwintopResourceBar_ImportExport_LayoutPanel", topPanel)
	topPanel.panel:SetPoint("TOPLEFT", oUi.xCoord, -5)
	topPanel.panel:Show()

	local scrollChild = topPanel.panel.scrollFrame.scrollChild
	-- Pre-allocate scroll child height large enough for all content.
	scrollChild:SetHeight(1200)

	local parent = scrollChild
	local yCoord = 5

	-- ── Shared legacy popups (kept for bare-string import compatibility) ─
	StaticPopupDialogs["TwintopResourceBar_ImportError"] = {
		text = L["ImportErrorGenericMessage"],
		button1 = L["OK"],
		OnAccept = function(self)
			StaticPopup_Show("TwintopResourceBar_Import")
		end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}

	StaticPopupDialogs["TwintopResourceBar_ImportReload"] = {
		text = L["ImportReloadMessage"],
		button1 = L["OK"],
		OnAccept = function(self) C_UI.Reload() end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}

	StaticPopupDialogs["TwintopResourceBar_Import"] = {
		text = L["ImportMessage"],
		button1 = L["Import"],
		button2 = L["Cancel"],
		hasEditBox = true,
		hasWideEditBox = true,
		editBoxWidth = 500,
		OnAccept = function(self)
			local result = TRB.Functions.IO:Import(self:GetEditBox():GetText())
			if result then
				StaticPopup_Show("TwintopResourceBar_ImportReload")
			else
				StaticPopup_Show("TwintopResourceBar_ImportError")
			end
		end,
		EditBoxOnEnterPressed = function(self)
			local text = self:GetText()
			if type(text) == "string" and text ~= "" then
				self:GetParent().button1:Click()
			end
		end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}

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

	-- ── Section: Import ────────────────────────────────────────────────
	controls.importSection = TRB.Functions.OptionsUi:BuildSectionHeader(
		parent, L["ImportSettingsConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(
		parent, L["ImportExisting"], oUi.xCoord, yCoord, 300, 28)
	controls.buttons.importButton:SetScript("OnClick", function()
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	-- ── Section: Profiles ──────────────────────────────────────────────
	yCoord = yCoord - 45
	controls.profileSection = TRB.Functions.OptionsUi:BuildSectionHeader(
		parent, L["ProfileMgrProfilesHeader"], oUi.xCoord, yCoord)

	-- ── Profile table ──────────────────────────────────────────────────
	-- Layout: Name (dynamic) | Specs (46) | Global (46) | Delete (15)
	local tblSpecW  = 46
	local tblGlobW  = 46
	local tblDelW   = 15

	yCoord = yCoord - 25

	-- LibScrollingTable-based profile table (matches Bar Text styling).
	local profileTableColumns = {
		{
			["name"] = "Key",
			["width"] = 1,
			["align"] = "CENTER",
		},
		{
			["name"] = L["ProfileMgrColumnName"],
			["width"] = 300,
			["align"] = "LEFT",
		},
		{
			["name"] = L["ProfileMgrColumnSpecs"],
			["width"] = tblSpecW,
			["align"] = "CENTER",
		},
		{
			["name"] = L["ProfileMgrColumnGlobal"],
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

	local profileTableContainer = CreateFrame("Frame", "TwintopResourceBar_IE_ProfileTableContainer", parent, "BackdropTemplate")
	profileTableContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	profileTableContainer:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	profileTableContainer:SetHeight(35 + (IE_VISIBLE * 15))

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
	local UpdateProfileActionButtons

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
						{ profileName = profileName })
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

	yCoord = yCoord - profileTableContainer:GetHeight() - 8

	-- ── Profile-level action buttons (below table) ─────────────────────
	-- 5 buttons on one row, sized dynamically in UpdateProfileActionButtons
	-- to span the full table width with equal gaps. Seed with a reasonable
	-- width so first-layout sizing looks right before OnSizeChanged fires.
	local btnW = 140
	controls.buttons.renameProfile = TRB.Functions.OptionsUi:BuildButton(
		parent, L["ProfileMgrActionRename"], 0, yCoord, btnW, 26)
	controls.buttons.copyFull = TRB.Functions.OptionsUi:BuildButton(
		parent, L["ProfileMgrActionCopyFull"], 0, yCoord, btnW, 26)
	controls.buttons.copySelected = TRB.Functions.OptionsUi:BuildButton(
		parent, L["ProfileMgrActionCopySelected"], 0, yCoord, btnW, 26)
	controls.buttons.exportFull = TRB.Functions.OptionsUi:BuildButton(
		parent, L["ProfileMgrActionExportFull"], 0, yCoord, btnW, 26)
	controls.buttons.exportSelected = TRB.Functions.OptionsUi:BuildButton(
		parent, L["ProfileMgrActionExportSelected"], 0, yCoord, btnW, 26)

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
	noSelFS:SetText(L["ProfileMgrNoProfileSelected"])

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
			GameTooltip:SetText(tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
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
		local classLabel = L[classDef.locKey]

		local _, _, _, classColorHex = GetClassColor(classToken)
		local colStr = classColorHex and ("|c" .. classColorHex) or "|cffffffff"

		local hRow = CreateFrame("Frame", nil, detailContainer)
		hRow:SetPoint("TOPLEFT", detailContainer, "TOPLEFT", colX, baseY)
		hRow:SetWidth(IE_COL_W)
		hRow:SetHeight(IE_CLASS_H)

		local delBtn = BuildDeleteButton(hRow, CLS_DEL_X, -2)
		local expBtn = BuildExportButton(hRow, SPEC_EXP_X, -2)
		local cb = BuildCheckbox(hRow, SPEC_CB_X, -2)
		SetButtonTooltip(delBtn, string.format(L["ProfileMgrDeleteClassTooltipFormat"], classLabel))
		SetButtonTooltip(expBtn, string.format(L["ProfileMgrExportClassTooltipFormat"], classLabel))
		SetButtonTooltip(cb, string.format(L["ProfileMgrSelectClassTooltipFormat"], classLabel))
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
			local specLabel = L[spec.locKey]
			SetButtonTooltip(sDelBtn, string.format(L["ProfileMgrDeleteSpecTooltipFormat"], specLabel, classLabel))
			SetButtonTooltip(sExpBtn, string.format(L["ProfileMgrExportSpecTooltipFormat"], specLabel, classLabel))
			SetButtonTooltip(sCb, string.format(L["ProfileMgrSelectSpecTooltipFormat"], specLabel, classLabel))
			local sIcon = BuildIcon(specRow, SPEC_ICO_X, -2, 18)
			if GetSpecializationInfoForClassID then
				local _, _, _, iconId = GetSpecializationInfoForClassID(classDef.classId, spec.specId)
				if iconId then
					sIcon:SetTexture(iconId)
				end
			end
			local sLbl = BuildLabel(specRow, SPEC_LBL_X, -2,
				IE_COL_W - SPEC_LBL_X - 4, L[spec.locKey])

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
		SetButtonTooltip(delBtn, L["ProfileMgrDeleteGlobalTooltip"])
		SetButtonTooltip(expBtn, L["ProfileMgrExportGlobalTooltip"])
		SetButtonTooltip(cb, L["ProfileMgrSelectGlobalTooltip"])
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

		contentsHeader:SetText(string.format(L["ProfileMgrContentsHeaderFormat"], profileName))

		-- Reset checkbox state table
		checkboxState = { core = false }

		local Profiles = TRB.Functions.Profiles

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

		local function GetSpecPieceLabel(rowData)
			local specLabel = StripColorCodes(rowData.label:GetText() or rowData.specName)
			local classLabel = rowData.className
			local classRow = classRowData[rowData.className]
			if classRow ~= nil and classRow.label ~= nil then
				classLabel = StripColorCodes(classRow.label:GetText() or rowData.className)
			end
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
			local allSelected = hasAny
			for _, specName in ipairs(existingSpecs) do
				if not (checkboxState[className] and checkboxState[className][specName]) then
					allSelected = false
					break
				end
			end

			cd.frame:SetAlpha(hasAny and 1.0 or 0.55)
			cd.checkbox:SetChecked(allSelected)
			if hasAny then
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

	-- Initial state
	RefreshProfileTable()
	RefreshDetailGrid(nil)
	if UpdateProfileActionButtons ~= nil then
		UpdateProfileActionButtons()
	end

	-- Update total scroll child height
	local totalContentH = math.abs(yCoord) + math.abs(curY) + 60
	scrollChild:SetHeight(totalContentH)
end

if false then

	if classId == nil then
		exportInnerMessage = L["ExportMessagePrefixAll"] .. " " .. classOrSpecLocalization .. " " .. L["ExportMessagePostfixSpecializations"]
		yCoord = yCoord - 35
		controls.labels["export_" .. namePrefix] = TRB.Functions.OptionsUi:BuildLabel(parent, labelLocalization, oUi.xCoord, yCoord, 130, 20)
	elseif specId == nil then
		exportInnerMessage = L["ExportMessagePrefixAll"] .. " " .. classOrSpecLocalization .. " " .. L["ExportMessagePostfixSpecializations"]
		yCoord = yCoord - 35
		controls.labels["export_" .. namePrefix] = TRB.Functions.OptionsUi:BuildLabel(parent, labelLocalization, oUi.xCoord, yCoord, 130, 20)
	else
		exportInnerMessage = L["ExportMessagePrefix"] .. " " .. classOrSpecLocalization
		yCoord = yCoord - 25
		controls.labels["export_" .. namePrefix] = TRB.Functions.OptionsUi:BuildLabel(parent, labelLocalization, oUi.xCoord+oUi.xPadding, yCoord, 110, 20, TRB.Options.fonts.options.exportSpec)
	end

	if includeButtons then
		buttonOffset = oUi.xCoord + oUi.xPadding + 110
		controls.buttons["export_" .. namePrefix .. "_All"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 60, 20)
		controls.buttons["export_" .. namePrefix .. "_All"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(exportInnerMessage .. " " .. L["ExportMessagePostfixAll"] .. ".", classId, specId, true, true, true, true, true, false)
		end)

		buttonOffset = buttonOffset + buttonSpacing + 60
		controls["export_" .. namePrefix .. "_BarDisplay"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 90, 20)
		controls["export_" .. namePrefix .. "_BarDisplay"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(exportInnerMessage .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", classId, specId, true, false, false, false, false, false)
		end)

		buttonOffset = buttonOffset + buttonSpacing + 90
		if includeThreshold then
			controls["export_" .. namePrefix .. "_Thresholds"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageThresholds"], buttonOffset, yCoord, 90, 20)
			controls["export_" .. namePrefix .. "_Thresholds"]:SetScript("OnClick", function(self, ...)
				TRB.Functions.IO:ExportPopup(exportInnerMessage .. " " .. L["ExportMessagePostfixThresholds"] .. ".", classId, specId, false, true, false, false, false, false)
			end)
		end

		buttonOffset = buttonOffset + buttonSpacing + 90
		controls["export_" .. namePrefix .. "_FontAndText"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 100, 20)
		controls["export_" .. namePrefix .. "_FontAndText"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(exportInnerMessage .. " " .. L["ExportMessagePostfixFontText"] .. ".", classId, specId, false, false, true, false, false, false)
		end)

		buttonOffset = buttonOffset + buttonSpacing + 100
		if includeAudioTracking then
			controls["export_" .. namePrefix .. "_AudioAndTracking"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 130, 20)
			controls["export_" .. namePrefix .. "_AudioAndTracking"]:SetScript("OnClick", function(self, ...)
				TRB.Functions.IO:ExportPopup(exportInnerMessage .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
			end)
		end

		buttonOffset = buttonOffset + buttonSpacing + 130
		controls["export_" .. namePrefix .. "_BarText"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 80, 20)
		controls["export_" .. namePrefix .. "_BarText"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(exportInnerMessage .. " " .. L["ExportMessagePostfixBarText"] .. ".", classId, specId, false, false, false, false, true, false)
		end)
	end
	return yCoord
end

local function ConstructImportExportPanel_DELETED()
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames()
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.importExport or {}
	local yCoord = -5

	local specName = ""
	local buttonOffset = 0
	local buttonSpacing = 5

	interfaceSettingsFrame.importExportPanel = CreateFrame("Frame", "TwintopResourceBar_Options_ImportExport")
	TRB.Options.OptionsFrame:RegisterCategory("importExport", string.format("%s/%s", L["Import"], L["Export"]), interfaceSettingsFrame.importExportPanel)

	parent = interfaceSettingsFrame.importExportPanel
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format("%s/%s", L["Import"], L["Export"]), oUi.xCoord, yCoord)
	controls.labels = controls.labels or {}
	controls.buttons = controls.buttons or {}

	yCoord = yCoord - 30
	---@diagnostic disable-next-line: inject-field
	parent.panel = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel", parent)
	parent.panel:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	parent.panel:Show()

	parent = parent.panel.scrollFrame.scrollChild

	yCoord = 5
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ImportSettingsConfiguration"], oUi.xCoord, yCoord)


	StaticPopupDialogs["TwintopResourceBar_ImportError"] = {
		text = L["ImportErrorGenericMessage"],
		button1 = L["OK"],
		OnAccept = function(self)
			StaticPopup_Show("TwintopResourceBar_Import")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	StaticPopupDialogs["TwintopResourceBar_ImportReload"] = {
		text = L["ImportReloadMessage"],
		button1 = L["OK"],
		OnAccept = function(self)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	StaticPopupDialogs["TwintopResourceBar_Import"] = {
		text = L["ImportMessage"],
		button1 = L["Import"],
		button2 = L["Cancel"],
		hasEditBox = true,
		hasWideEditBox = true,
		editBoxWidth = 500,
		OnAccept = function(self)
			local result = false
			result = TRB.Functions.IO:Import(self:GetEditBox():GetText())

			if result >= 0 then
				StaticPopup_Show("TwintopResourceBar_ImportReload")
			else
				if result == -4 then
					StaticPopupDialogs["TwintopResourceBar_ImportError"].text = L["ImportErrorNoValidMessage"]
				else
					StaticPopupDialogs["TwintopResourceBar_ImportError"].text = L["ImportErrorGenericMessage"]
				end

				StaticPopup_Show("TwintopResourceBar_ImportError")
			end
		end,
		timeout = 0,
		whileDead = true,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		hideOnEscape = true,
		preferredIndex = 3
	}

	yCoord = yCoord - 40
	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ImportExisting"], oUi.xCoord, yCoord, 300, 30)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)


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
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		hideOnEscape = true,
		preferredIndex = 3
	}

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ExportSettingsConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 35

	buttonOffset = oUi.xCoord + oUi.xPadding + 110
	controls.buttons.exportButton_Everything = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAllClassesSpecs"] .. " + " .. L["GlobalOptions"], buttonOffset, yCoord, 340, 20)
	controls.buttons.exportButton_Everything:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " + " .. L["GlobalOptions"] .. ".", nil, nil, true, false, true, true, true, true)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 340
	controls.exportButton_All_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageGlobalOptionsOnly"], buttonOffset, yCoord, 220, 20)
	controls.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageGlobalOptionsOnly"] .. ".", nil, -1, false, false, false, false, false, true)
	end)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, nil, nil, L["ExportMessageAllClassesSpecs"], L["ExportMessageAllClassesSpecs"], true, true)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 6, nil, L["DeathKnight"], L["DeathKnight"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 6, 1, L["DeathKnightBlood"], L["DeathKnightBloodFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 6, 2, L["DeathKnightFrost"], L["DeathKnightFrostFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 6, 3, L["DeathKnightUnholy"], L["DeathKnightUnholyFull"], true, false)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 12, nil, L["DemonHunter"], L["DemonHunter"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 12, 1, L["DemonHunterHavoc"], L["DemonHunterHavocFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 12, 2, L["DemonHunterVengeance"], L["DemonHunterVengeanceFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 12, 3, L["DemonHunterDevourer"], L["DemonHunterDevourerFull"], true, false)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 11, nil, L["Druid"], L["Druid"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 11, 1, L["DruidBalance"], L["DruidBalanceFull"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 11, 2, L["DruidFeral"], L["DruidFeralFull"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 11, 3, L["DruidGuardian"], L["DruidGuardianFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 11, 4, L["DruidRestoration"], L["DruidRestorationFull"], false, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 13, nil, L["Evoker"], L["Evoker"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 13, 1, L["EvokerDevastation"], L["EvokerDevastationFull"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 13, 2, L["EvokerPreservation"], L["EvokerPreservationFull"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 13, 3, L["EvokerAugmentation"], L["EvokerAugmentationFull"], false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, nil, L["Hunter"], L["Hunter"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, 1, L["HunterBeastMastery"], L["HunterBeastMasteryFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, 2, L["HunterMarksmanship"], L["HunterMarksmanshipFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, 3, L["HunterSurvival"], L["HunterSurvivalFull"], true, true)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, nil, L["Mage"], L["Mage"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, 1, L["MageArcane"], L["MageArcaneFull"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, 2, L["MageFire"], L["MageFireFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, 3, L["MageFrost"], L["MageFrostFull"], false, true)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, nil, L["Monk"], L["Monk"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, 1, L["MonkBrewmaster"], L["MonkBrewmasterFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, 2, L["MonkMistweaver"], L["MonkMistweaverFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, 3, L["MonkWindwalker"], L["MonkWindwalkerFull"], true, true)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, nil, L["Paladin"], L["Paladin"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, 1, L["PaladinHoly"], L["PaladinHolyFull"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, 2, L["PaladinProtection"], L["PaladinProtectionFull"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, 3, L["PaladinRetribution"], L["PaladinRetributionFull"], false, true)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, nil, L["Priest"], L["Priest"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, 1, L["PriestDiscipline"], L["PriestDisciplineFull"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, 2, L["PriestHoly"], L["PriestHolyFull"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, 3, L["PriestShadow"], L["PriestShadowFull"])
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, nil, L["Rogue"], L["Rogue"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, 1, L["RogueAssassination"], L["RogueAssassinationFull"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, 2, L["RogueOutlaw"], L["RogueOutlawFull"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, 3, L["RogueSubtlety"], L["RogueSubtletyFull"], true, true)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, nil, L["Shaman"], L["Shaman"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, 1, L["ShamanElemental"], L["ShamanElementalFull"], true, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, 2, L["ShamanEnhancement"], L["ShamanEnhancementFull"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, 3, L["ShamanRestoration"], L["ShamanRestorationFull"], false, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, nil, L["Warlock"], L["Warlock"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, 1, L["WarlockAffliction"], L["WarlockAfflictionFull"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, 2, L["WarlockDemonology"], L["WarlockDemonologyFull"], false, true)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, 3, L["WarlockDestruction"], L["WarlockDestructionFull"], false, true)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, nil, L["Warrior"], L["Warrior"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, 1, L["WarriorArms"], L["WarriorArmsFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, 2, L["WarriorFury"], L["WarriorFuryFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, 3, L["WarriorProtection"], L["WarriorProtectionFull"], true, false)
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

	interfaceSettingsFrame.controls.barPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, TRB.Details.addonTitle, oUi.xCoord+oUi.xPadding, yCoord)

	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoAuthor = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, L["Author"] .. ":", TRB.Details.addonAuthor .. " - " .. TRB.Details.addonAuthorServer, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 15)
	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoVersion = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, L["Version"] .. ":", TRB.Details.addonVersion, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 15)
	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoReleased = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, L["Released"] .. ":", TRB.Details.addonReleaseDate, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 15)
	yCoord = yCoord - 40
	interfaceSettingsFrame.controls.labels.infoSupport = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, L["SupportedSpecs"] .. ":", TRB.Details.supportedSpecs, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 575, 15, 300)

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
	local localeText2 = string.format(percentFormat, 62.82)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 13.60)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 9.20)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.27)

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
	interfaceSettingsFrame.controls.labels.localization1 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "Localization" .. ":", localeText1, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 100, 15, 300)
	interfaceSettingsFrame.controls.labels.localization2 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "", localeText2, oUi.xCoord+(oUi.xPadding*2)+50, yCoord, 0, 100, 15, 300, "RIGHT")
	interfaceSettingsFrame.controls.labels.localization3 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "", localeText3, oUi.xCoord+(oUi.xPadding*2)+200, yCoord, 0, 375, 15, 300)
	interfaceSettingsFrame.controls.labels.localization4 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "", localeText4, oUi.xCoord+(oUi.xPadding*2)+200, yCoord, 0, 375, 15, 300, nil, [[Fonts\ARHei.TTF]])

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
	ConstructImportExportPanel()

	-- Register all class headers and spec nav entries (with nil panels).
	-- The active class's ConstructOptionsPanel will update its specs with real panels via RegisterSpecPanel.
	-- Non-active classes appear in the nav but have no panels until lazy loading is implemented.
	TRB.Options:RegisterAllClassSpecNavEntries()

	TRB.Options.OptionsFrame:RefreshNav()
end

--- Ordered list of all classes and their specs for nav registration.
--- Each entry stores the resolved localized string for class headers and spec labels.
---@type {classKey: string, classLabel: string, specs: {compositeKey: string, specLabel: string}[]}[]
local ALL_CLASS_SPECS = {
	{ classKey = "warrior", classLabel = L["Warrior"], specs = {
		{ compositeKey = "warrior_arms", specLabel = L["WarriorArmsFull"] },
		{ compositeKey = "warrior_fury", specLabel = L["WarriorFuryFull"] },
		{ compositeKey = "warrior_protection", specLabel = L["WarriorProtectionFull"] },
	}},
	{ classKey = "paladin", classLabel = L["Paladin"], specs = {
		{ compositeKey = "paladin_holy", specLabel = L["PaladinHolyFull"] },
		{ compositeKey = "paladin_protection", specLabel = L["PaladinProtectionFull"] },
		{ compositeKey = "paladin_retribution", specLabel = L["PaladinRetributionFull"] },
	}},
	{ classKey = "hunter", classLabel = L["Hunter"], specs = {
		{ compositeKey = "hunter_beastMastery", specLabel = L["HunterBeastMasteryFull"] },
		{ compositeKey = "hunter_marksmanship", specLabel = L["HunterMarksmanshipFull"] },
		{ compositeKey = "hunter_survival", specLabel = L["HunterSurvivalFull"] },
	}},
	{ classKey = "rogue", classLabel = L["Rogue"], specs = {
		{ compositeKey = "rogue_assassination", specLabel = L["RogueAssassinationFull"] },
		{ compositeKey = "rogue_outlaw", specLabel = L["RogueOutlawFull"] },
		{ compositeKey = "rogue_subtlety", specLabel = L["RogueSubtletyFull"] },
	}},
	{ classKey = "priest", classLabel = L["Priest"], specs = {
		{ compositeKey = "priest_discipline", specLabel = L["PriestDisciplineFull"] },
		{ compositeKey = "priest_holy", specLabel = L["PriestHolyFull"] },
		{ compositeKey = "priest_shadow", specLabel = L["PriestShadowFull"] },
	}},
	{ classKey = "deathknight", classLabel = L["DeathKnight"], specs = {
		{ compositeKey = "deathknight_blood", specLabel = L["DeathKnightBloodFull"] },
		{ compositeKey = "deathknight_frost", specLabel = L["DeathKnightFrostFull"] },
		{ compositeKey = "deathknight_unholy", specLabel = L["DeathKnightUnholyFull"] },
	}},
	{ classKey = "shaman", classLabel = L["Shaman"], specs = {
		{ compositeKey = "shaman_elemental", specLabel = L["ShamanElementalFull"] },
		{ compositeKey = "shaman_enhancement", specLabel = L["ShamanEnhancementFull"] },
		{ compositeKey = "shaman_restoration", specLabel = L["ShamanRestorationFull"] },
	}},
	{ classKey = "mage", classLabel = L["Mage"], specs = {
		{ compositeKey = "mage_arcane", specLabel = L["MageArcaneFull"] },
		{ compositeKey = "mage_fire", specLabel = L["MageFireFull"] },
		{ compositeKey = "mage_frost", specLabel = L["MageFrostFull"] },
	}},
	{ classKey = "warlock", classLabel = L["Warlock"], specs = {
		{ compositeKey = "warlock_affliction", specLabel = L["WarlockAfflictionFull"] },
		{ compositeKey = "warlock_demonology", specLabel = L["WarlockDemonologyFull"] },
		{ compositeKey = "warlock_destruction", specLabel = L["WarlockDestructionFull"] },
	}},
	{ classKey = "monk", classLabel = L["Monk"], specs = {
		{ compositeKey = "monk_brewmaster", specLabel = L["MonkBrewmasterFull"] },
		{ compositeKey = "monk_mistweaver", specLabel = L["MonkMistweaverFull"] },
		{ compositeKey = "monk_windwalker", specLabel = L["MonkWindwalkerFull"] },
	}},
	{ classKey = "druid", classLabel = L["Druid"], specs = {
		{ compositeKey = "druid_balance", specLabel = L["DruidBalanceFull"] },
		{ compositeKey = "druid_feral", specLabel = L["DruidFeralFull"] },
		{ compositeKey = "druid_guardian", specLabel = L["DruidGuardianFull"] },
		{ compositeKey = "druid_restoration", specLabel = L["DruidRestorationFull"] },
	}},
	{ classKey = "demonhunter", classLabel = L["DemonHunter"], specs = {
		{ compositeKey = "demonhunter_havoc", specLabel = L["DemonHunterHavocFull"] },
		{ compositeKey = "demonhunter_vengeance", specLabel = L["DemonHunterVengeanceFull"] },
		{ compositeKey = "demonhunter_devourer", specLabel = L["DemonHunterDevourerFull"] },
	}},
	{ classKey = "evoker", classLabel = L["Evoker"], specs = {
		{ compositeKey = "evoker_devastation", specLabel = L["EvokerDevastationFull"] },
		{ compositeKey = "evoker_preservation", specLabel = L["EvokerPreservationFull"] },
		{ compositeKey = "evoker_augmentation", specLabel = L["EvokerAugmentationFull"] },
	}},
}

--- Mapping from lowercase className to PascalCase options module key (e.g., TRB.Options.DeathKnight)
local CLASS_OPTIONS_MODULE = {
	deathknight = "DeathKnight",
	demonhunter = "DemonHunter",
	druid = "Druid",
	evoker = "Evoker",
	hunter = "Hunter",
	mage = "Mage",
	monk = "Monk",
	paladin = "Paladin",
	priest = "Priest",
	rogue = "Rogue",
	shaman = "Shaman",
	warlock = "Warlock",
	warrior = "Warrior",
}

---Lazily build all options panels for a class.
---Ensures specCache entries and settings exist, then calls the class's ConstructOptionsPanel.
---@param classKey string # Lowercase class key (e.g., "warrior")
function TRB.Options:BuildClassPanels(classKey)
	local moduleKey = CLASS_OPTIONS_MODULE[classKey]
	if not moduleKey or not TRB.Options[moduleKey] or not TRB.Options[moduleKey].ConstructOptionsPanel then
		return
	end

	-- Ensure specCache entries exist for all specs in this class
	for _, classDef in ipairs(ALL_CLASS_SPECS) do
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
	for i, classDef in ipairs(ALL_CLASS_SPECS) do
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
	TRB.Functions.OptionsUi:BuildLabel(parent, TRB.Options.variables.barTextInstructions, xCoord+5, yCoord, maxOptionsWidth-(2*(xCoord+5)), barTextInstructionsHeight, GameFontHighlight, "LEFT")
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
			TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.values[i].variable, cache.barTextVariables.values[i].description, xCoord, yCoord, 0, width, height)
			yCoord = yCoord - (height * 3) - 5
		end
	end

	local entries2 = TRB.Functions.Table:Length(cache.barTextVariables.pipe)
	for i=1, entries2 do
		if cache.barTextVariables.pipe[i].printInSettings == true then
			TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.pipe[i].variable, cache.barTextVariables.pipe[i].description, xCoord, yCoord, 0, width, height)
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
			TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.icons[i].variable, text .. cache.barTextVariables.icons[i].description, xCoord, yCoord, 0, width, height)
			yCoord = yCoord - (height * 3) - 5
		end
	end
end