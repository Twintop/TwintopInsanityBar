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

local function ConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"], "notFull", false, nil, nil, true, L["ResourceComboPoints"], true)
end

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

	local function StrataIsSelected(value)
		return value == TRB.Data.settings.core.strata.level
	end
	
	local function StrataSetSelected(newValue)
		TRB.Data.settings.core.strata.level = newValue
		
		for k, v in pairs(strata) do
			if v == newValue then
				TRB.Data.settings.core.strata.name = k
			end
		end
		strataDropdown:SetDefaultText(TRB.Data.settings.core.strata.name)

		-- Apply strata to BarGroups if available
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if barGroups then
			if barGroups.primary then
				barGroups.primary:GetContainerFrame():SetFrameStrata(TRB.Data.settings.core.strata.level)
			end
			if barGroups.secondary then
				barGroups.secondary:GetContainerFrame():SetFrameStrata(TRB.Data.settings.core.strata.level)
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

	local function AudioChannelIsSelected(value)
		return value == TRB.Data.settings.core.audio.channel.channel
	end
	
	local function AudioChannelSetSelected(newValue)
		TRB.Data.settings.core.audio.channel.channel = newValue
		TRB.Data.settings.core.audio.channel.name = newValue
	end

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

local function ConstructGlobalBarTextPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Global_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Global_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportGlobalBarTextPopup(L["GlobalBarTextExportMessage"])
	end)

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

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 479, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

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

---comment
---@param parent Frame
---@param yCoord integer
---@param controls table
---@param classId integer?
---@param specId integer?
---@param labelLocalization string
---@param classOrSpecLocalization string
---@param includeThreshold boolean?
---@param includeAudioTracking boolean?
---@param includeButtons boolean?
---@return integer
local function ConstructImportExportRow(parent, yCoord, controls, classId, specId, labelLocalization, classOrSpecLocalization, includeThreshold, includeAudioTracking, includeButtons)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local buttonOffset = 0
	local buttonSpacing = 2
	local exportInnerMessage = ""

	if includeThreshold == nil then
		includeThreshold = true
	end

	if includeAudioTracking == nil then
		includeAudioTracking = true
	end

	if includeButtons == nil then
		includeButtons = true
	end

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

local function ConstructImportExportPanel()
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
	local localeText2 = string.format(percentFormat, 85.66)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 15.48)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 11.57)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 97.94)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.33)

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
--- Each entry maps to the correct localization keys for class headers and spec labels.
---@type {classKey: string, classLocKey: string, specs: {compositeKey: string, locFullKey: string}[]}[]
local ALL_CLASS_SPECS = {
	{ classKey = "warrior", classLocKey = "Warrior", specs = {
		{ compositeKey = "warrior_arms", locFullKey = "WarriorArmsFull" },
		{ compositeKey = "warrior_fury", locFullKey = "WarriorFuryFull" },
		{ compositeKey = "warrior_protection", locFullKey = "WarriorProtectionFull" },
	}},
	{ classKey = "paladin", classLocKey = "Paladin", specs = {
		{ compositeKey = "paladin_holy", locFullKey = "PaladinHolyFull" },
		{ compositeKey = "paladin_protection", locFullKey = "PaladinProtectionFull" },
		{ compositeKey = "paladin_retribution", locFullKey = "PaladinRetributionFull" },
	}},
	{ classKey = "hunter", classLocKey = "Hunter", specs = {
		{ compositeKey = "hunter_beastMastery", locFullKey = "HunterBeastMasteryFull" },
		{ compositeKey = "hunter_marksmanship", locFullKey = "HunterMarksmanshipFull" },
		{ compositeKey = "hunter_survival", locFullKey = "HunterSurvivalFull" },
	}},
	{ classKey = "rogue", classLocKey = "Rogue", specs = {
		{ compositeKey = "rogue_assassination", locFullKey = "RogueAssassinationFull" },
		{ compositeKey = "rogue_outlaw", locFullKey = "RogueOutlawFull" },
		{ compositeKey = "rogue_subtlety", locFullKey = "RogueSubtletyFull" },
	}},
	{ classKey = "priest", classLocKey = "Priest", specs = {
		{ compositeKey = "priest_discipline", locFullKey = "PriestDisciplineFull" },
		{ compositeKey = "priest_holy", locFullKey = "PriestHolyFull" },
		{ compositeKey = "priest_shadow", locFullKey = "PriestShadowFull" },
	}},
	{ classKey = "deathknight", classLocKey = "DeathKnight", specs = {
		{ compositeKey = "deathknight_blood", locFullKey = "DeathKnightBloodFull" },
		{ compositeKey = "deathknight_frost", locFullKey = "DeathKnightFrostFull" },
		{ compositeKey = "deathknight_unholy", locFullKey = "DeathKnightUnholyFull" },
	}},
	{ classKey = "shaman", classLocKey = "Shaman", specs = {
		{ compositeKey = "shaman_elemental", locFullKey = "ShamanElementalFull" },
		{ compositeKey = "shaman_enhancement", locFullKey = "ShamanEnhancementFull" },
		{ compositeKey = "shaman_restoration", locFullKey = "ShamanRestorationFull" },
	}},
	{ classKey = "mage", classLocKey = "Mage", specs = {
		{ compositeKey = "mage_arcane", locFullKey = "MageArcaneFull" },
		{ compositeKey = "mage_fire", locFullKey = "MageFireFull" },
		{ compositeKey = "mage_frost", locFullKey = "MageFrostFull" },
	}},
	{ classKey = "warlock", classLocKey = "Warlock", specs = {
		{ compositeKey = "warlock_affliction", locFullKey = "WarlockAfflictionFull" },
		{ compositeKey = "warlock_demonology", locFullKey = "WarlockDemonologyFull" },
		{ compositeKey = "warlock_destruction", locFullKey = "WarlockDestructionFull" },
	}},
	{ classKey = "monk", classLocKey = "Monk", specs = {
		{ compositeKey = "monk_brewmaster", locFullKey = "MonkBrewmasterFull" },
		{ compositeKey = "monk_mistweaver", locFullKey = "MonkMistweaverFull" },
		{ compositeKey = "monk_windwalker", locFullKey = "MonkWindwalkerFull" },
	}},
	{ classKey = "druid", classLocKey = "Druid", specs = {
		{ compositeKey = "druid_balance", locFullKey = "DruidBalanceFull" },
		{ compositeKey = "druid_feral", locFullKey = "DruidFeralFull" },
		{ compositeKey = "druid_guardian", locFullKey = "DruidGuardianFull" },
		{ compositeKey = "druid_restoration", locFullKey = "DruidRestorationFull" },
	}},
	{ classKey = "demonhunter", classLocKey = "DemonHunter", specs = {
		{ compositeKey = "demonhunter_havoc", locFullKey = "DemonHunterHavocFull" },
		{ compositeKey = "demonhunter_vengeance", locFullKey = "DemonHunterVengeanceFull" },
		{ compositeKey = "demonhunter_devourer", locFullKey = "DemonHunterDevourerFull" },
	}},
	{ classKey = "evoker", classLocKey = "Evoker", specs = {
		{ compositeKey = "evoker_devastation", locFullKey = "EvokerDevastationFull" },
		{ compositeKey = "evoker_preservation", locFullKey = "EvokerPreservationFull" },
		{ compositeKey = "evoker_augmentation", locFullKey = "EvokerAugmentationFull" },
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
		return L[a.classLocKey] < L[b.classLocKey]
	end)

	for _, classDef in ipairs(sorted) do
		TRB.Options.OptionsFrame:RegisterClassHeader(classDef.classKey, L[classDef.classLocKey])

		-- Create a builder that lazily constructs all spec panels for this class
		local classKeyCapture = classDef.classKey
		local builder = function()
			TRB.Options:BuildClassPanels(classKeyCapture)
		end

		for _, specDef in ipairs(classDef.specs) do
			TRB.Options.OptionsFrame:RegisterSpecPanel(classDef.classKey, specDef.compositeKey, L[specDef.locFullKey], nil, builder)
		end
	end
end

function TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
	local maxOptionsWidth = 550
	local barTextInstructionsHeight = 400
	TRB.Functions.OptionsUi:BuildLabel(parent, TRB.Options.variables.barTextInstructions, xCoord+5, yCoord, maxOptionsWidth-(2*(xCoord+5)), barTextInstructionsHeight, GameFontHighlight, "LEFT")
end


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