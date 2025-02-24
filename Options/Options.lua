local _, TRB = ...
local L = TRB.Localization

TRB.Options = {}

local oUi = TRB.Data.constants.optionsUi
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

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

local function ConstructEnabledForSpecsPanel(parent)
	if parent == nil then
		return
	end

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
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextCasting"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerTextSpending"], spec.colors.text.spending.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["GlobalColorPickerOvercap"], spec.colors.text.overcap.color, 300, 25, oUi.xCoord2, yCoord)
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

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["GlobalCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)
	
	local dotVariables = "e.g. $swpTime/$swpCount"
	yCoord = TRB.Functions.OptionsUi:GenerateDefaultDotOptions(parent, controls, spec, nil, nil, yCoord, L["DotChangeColorCheckbox"], string.format(L["DotChangeColorCheckboxTooltip"], dotVariables))

	local title = ""
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, nil, nil, yCoord)

	title = L["GlobalResourceDecimalPrecision"]
	controls.precisionResource = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, spec.precision.resource, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.precisionResource:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.resource = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
	end)
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
	controls.checkBoxes.smoothBar = CreateFrame("CheckButton", "TwintopResourceBar_CB_Smooth_Bar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.smoothBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	---@diagnostic disable-next-line: undefined-field
	getglobal(f:GetName() .. 'Text'):SetText(L["GlobalOptionsCheckboxSmoothBar"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["GlobalOptionsCheckboxSmoothBarTooltip"]
	f:SetChecked(TRB.Data.settings.core.bar.smooth)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.bar.smooth = self:GetChecked()
		TRB.Functions.Bar:UpdateSmoothBar()
	end)

	yCoord = yCoord - 30
	
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["TTD"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50

	title = L["SamplingRate"]
	controls.ttdSamplingRate = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.05, 2, TRB.Data.settings.core.ttd.sampleRate, 0.05, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.ttdSamplingRate:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		else
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		end

		self.EditBox:SetText(value)
		TRB.Data.settings.core.ttd.sampleRate = value
	end)

	title = L["SampleSize"]
	controls.ttdSampleSize = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 1000, TRB.Data.settings.core.ttd.numEntries, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.ttdSampleSize:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)
		TRB.Data.settings.core.ttd.numEntries = value
	end)

	yCoord = yCoord - 60
	title = L["TTDPrecision"]
	controls.ttdPrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.ttd.precision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.ttdPrecision:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		TRB.Data.settings.core.ttd.precision = value
	end)

	yCoord = yCoord - 40
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
	
	title = L["TimerBelowPrecision"]
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

	-- Create the dropdown, and configure its appearance
---@diagnostic disable-next-line: undefined-field
	controls.dropDown.strata = LibDD:Create_UIDropDownMenu("TwintopResourceBar_FrameStrata", parent)
	controls.dropDown.strata.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FrameStrataDescription"], oUi.xCoord, yCoord)
	controls.dropDown.strata.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.strata:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.strata, oUi.dropdownWidth)
	---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_SetText(controls.dropDown.strata, TRB.Data.settings.core.strata.name)
	---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.strata, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.strata, function(self, level, menuList)
		local entries = 25
		---@diagnostic disable-next-line: undefined-field
		local info = LibDD:UIDropDownMenu_CreateInfo()
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

		for k, v in pairs(strataList) do
			info.text = v
			info.value = strata[v]
			info.checked = strata[v] == TRB.Data.settings.core.strata.level
			info.func = self.SetValue
			info.arg1 = strata[v]
			info.arg2 = v
			---@diagnostic disable-next-line: undefined-field
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end)

	function controls.dropDown.strata:SetValue(newValue, newName)
		TRB.Data.settings.core.strata.level = newValue
		TRB.Data.settings.core.strata.name = newName
		TRB.Frames.barContainerFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		TRB.Frames.barBorderFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		TRB.Frames.resourceFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		TRB.Frames.castingFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		TRB.Frames.passiveFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		---@type Frame[]
		local textFrames = TRB.Frames.textFrames
		local entries = TRB.Functions.Table:Length(textFrames)
		if entries > 0 then
			for i = 1, entries do
				textFrames[i]:SetFrameStrata(TRB.Data.settings.core.strata.level)
			end
		end
		---@diagnostic disable-next-line: undefined-field
		LibDD:UIDropDownMenu_SetText(controls.dropDown.strata, newName)
		CloseDropDownMenus()
	end


	yCoord = yCoord - 60
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioChannel"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30

	-- Create the dropdown, and configure its appearance
---@diagnostic disable-next-line: undefined-field
	controls.dropDown.audioChannel = LibDD:Create_UIDropDownMenu("TwintopResourceBar_FrameAudioChannel", parent)
	controls.dropDown.audioChannel.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioChannelDescription"], oUi.xCoord, yCoord)
	controls.dropDown.audioChannel.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.audioChannel:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.audioChannel, oUi.dropdownWidth)
	---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_SetText(controls.dropDown.audioChannel, TRB.Data.settings.core.audio.channel.name)
	---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.audioChannel, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
---@diagnostic disable-next-line: undefined-field
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.audioChannel, function(self, level, menuList)
		local entries = 25
		---@diagnostic disable-next-line: undefined-field
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local channel = {}
		channel[L["AudioChannelMaster"]] = L["AudioChannelMaster"]
		channel[L["AudioChannelSFX"]] = L["AudioChannelSFX"]
		channel[L["AudioChannelMusic"]] = L["AudioChannelMusic"]
		channel[L["AudioChannelAmbience"]] = L["AudioChannelAmbience"]
		channel[L["AudioChannelDialog"]] = L["AudioChannelDialog"]

		for k, v in pairs(channel) do
			info.text = v
			info.value = channel[v]
			info.checked = channel[v] == TRB.Data.settings.core.audio.channel.channel
			info.func = self.SetValue
			info.arg1 = channel[v]
			info.arg2 = v
			---@diagnostic disable-next-line: undefined-field
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end)

	function controls.dropDown.audioChannel:SetValue(newValue, newName)
		TRB.Data.settings.core.audio.channel.channel = newValue
		TRB.Data.settings.core.audio.channel.name = newName
		---@diagnostic disable-next-line: undefined-field
		LibDD:UIDropDownMenu_SetText(controls.dropDown.audioChannel, newName)
		CloseDropDownMenus()
	end

	yCoord = yCoord - 60
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ExperimentalFeatures"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.experimentalShamanEnhancement = CreateFrame("CheckButton", "TwintopResourceBar_CB_Experimental_Shaman_Enhancement", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.experimentalShamanEnhancement
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	---@diagnostic disable-next-line: undefined-field
	getglobal(f:GetName() .. 'Text'):SetText(L["ExperimentalEnhancementShaman"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ExperimentalEnhancementShamanTooltip"]
	f:SetChecked(TRB.Data.settings.core.experimental.specs.shaman.enhancement)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.experimental.specs.shaman.enhancement = self:GetChecked()
	end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls = controls
end

local function ConstructGlobalOptionsPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls.global = interfaceSettingsFrame.controls.global or {}
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}
	
	interfaceSettingsFrame.optionsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_General", UIParent)
	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.optionsPanel.name = L["GlobalOptions"]
	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.optionsPanel.parent = parent.name
	TRB.Details.addonCategory.global, _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.optionsPanel, L["GlobalOptions"])

	parent = interfaceSettingsFrame.optionsPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["GlobalOptions"], oUi.xCoord, yCoord-5)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	--[[
		TODO: Exporting of Globals
	controls.buttons.exportButton_Priest_Shadow_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["GlobalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 3, true, true, true, true, false)
	end)
	]]

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab6", L["TabMiscellaneous"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, #tabs do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Global_LayoutPanel" .. i, parent)
		tabsheets[i]:Hide()
		tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	end

	tabsheets[5]:Show()
	tabsheets[5].selected = true
	tabs[5]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[5]
	parent.lastTabId = 5

	--ConstructEnabledForSpecsPanel(tabsheets[1].scrollFrame.scrollChild)
	ConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	--ShadowConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	--ShadowConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	--ShadowConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	ConstructMiscellaneousPanel(tabsheets[5].scrollFrame.scrollChild)
end

local function ConstructImportExportPanel()
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.importExport or {}
	local yCoord = -5

	local specName = ""
	local buttonOffset = 0
	local buttonSpacing = 5

	interfaceSettingsFrame.importExportPanel = CreateFrame("Frame", "TwintopResourceBar_Options_ImportExport", UIParent)
	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.importExportPanel.name = string.format("%s/%s", L["Import"], L["Export"])
	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.importExportPanel.parent = parent.name
	TRB.Details.addonCategory.io, _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.importExportPanel, string.format("%s/%s", L["Import"], L["Export"]))

	parent = interfaceSettingsFrame.importExportPanel
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format("%s/%s", L["Import"], L["Export"]), oUi.xCoord, yCoord)
	controls.labels = controls.labels or {}
	controls.buttons = controls.buttons or {}

	yCoord = yCoord - 30
	---@diagnostic disable-next-line: inject-field
	parent.panel = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Options_General_LayoutPanel", parent, 652, 555)
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
			result = TRB.Functions.IO:Import(self.editBox:GetText())

			if result >= 0 then
				StaticPopup_Show("TwintopResourceBar_ImportReload")
			else
				if result == -3 then
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
			self.text:SetFormattedText(data.message)
			self.editBox:SetText(data.exportString)
            self.editBox:SetAutoFocus(true)
            self.editBox:HighlightText()
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

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Everything = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAllClassesSpecs"] .. " + " .. L["GlobalOptions"], buttonOffset, yCoord, 230, 20)
	controls.buttons.exportButton_Everything:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " + " .. L["GlobalOptions"] .. ".", nil, nil, true, true, true, true, true)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 230
	controls.exportButton_All_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageGlobalOptionsOnly"], buttonOffset, yCoord, 200, 20)
	controls.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageGlobalOptionsOnly"] .. ".", nil, -1, false, false, false, false, true)
	end)

	yCoord = yCoord - 35
	controls.labels.druid = TRB.Functions.OptionsUi:BuildLabel(parent, L["ExportMessageAllClassesSpecs"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_All_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_All_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " " .. L["ExportMessagePostfixAll"] .. ".", nil, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_All_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", nil, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_All_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_All_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", nil, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_All_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_All_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", nil, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_All_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_All_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", nil, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 35
	controls.labels.demonhunter = TRB.Functions.OptionsUi:BuildLabel(parent, L["DemonHunter"], oUi.xCoord, yCoord, 120, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_DemonHunter_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_DemonHunter_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["DemonHunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 12, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_DemonHunter_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_DemonHunter_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["DemonHunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 12, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_DemonHunter_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_DemonHunter_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["DemonHunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 12, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_DemonHunter_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_DemonHunter_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["DemonHunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 12, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_DemonHunter_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_DemonHunter_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["DemonHunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 12, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["DemonHunterHavoc"]
	controls.labels.demonhunterHavoc = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_DemonHunter_Havoc_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 12, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_DemonHunter_Havoc_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_DemonHunter_Havoc_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 12, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_DemonHunter_Havoc_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_DemonHunter_Havoc_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 12, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_DemonHunter_Havoc_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_DemonHunter_Havoc_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 12, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_DemonHunter_Havoc_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_DemonHunter_Havoc_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 12, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["DemonHunterVengeance"]
	controls.labels.demonhunterVengeance = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_DemonHunter_Vengeance_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_DemonHunter_Vengeance_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 12, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_DemonHunter_Vengeance_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_DemonHunter_Vengeance_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 12, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_DemonHunter_Vengeance_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_DemonHunter_Vengeance_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 12, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_DemonHunter_Vengeance_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_DemonHunter_Vengeance_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 12, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_DemonHunter_Vengeance_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_DemonHunter_Vengeance_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 12, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 35
	controls.labels.druid = TRB.Functions.OptionsUi:BuildLabel(parent, L["Druid"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Druid_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Druid_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Druid"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Druid_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Druid_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Druid"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Druid_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Druid_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Druid"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Druid_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Druid_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Druid"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Druid_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Druid_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Druid"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["DruidBalance"]
	controls.labels.druidBalance = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Druid_Balance_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Druid_Balance_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Druid_Balance_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Druid_Balance_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Druid_Balance_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Druid_Balance_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Druid_Balance_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Druid_Balance_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Druid_Balance_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Druid_Balance_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["DruidFeral"]
	controls.labels.druidFeral = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Druid_Feral_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Druid_Feral_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Druid_Feral_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Druid_Feral_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Druid_Feral_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Druid_Feral_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Druid_Feral_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Druid_Feral_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Druid_Feral_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Druid_Feral_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["DruidRestoration"]
	controls.labels.druidRestoration = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Druid_Restoration_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Druid_Restoration_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 4, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Druid_Restoration_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Druid_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 4, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Druid_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Druid_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 4, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Druid_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Druid_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 4, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Druid_Restoration_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Druid_Restoration_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 4, false, false, false, true, false)
	end)

	yCoord = yCoord - 35
	controls.labels.evoker = TRB.Functions.OptionsUi:BuildLabel(parent, L["Evoker"], oUi.xCoord, yCoord, 110, 20)
	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	
	controls.buttons.exportButton_Evoker_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Evoker_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Evoker"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Evoker_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Evoker_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Evoker"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Evoker_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Evoker_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Evoker"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Evoker_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Evoker_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Evoker"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 13, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Evoker_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Evoker_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Evoker"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["EvokerDevastation"]
	controls.labels.druidDevastation = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Evoker_Devastation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Evoker_Devastation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Evoker_Devastation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Evoker_Devastation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Evoker_Devastation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Evoker_Devastation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Evoker_Devastation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Evoker_Devastation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 13, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Evoker_Devastation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Evoker_Devastation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["EvokerPreservation"]
	controls.labels.druidPreservation = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Evoker_Preservation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Evoker_Preservation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Evoker_Preservation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Evoker_Preservation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Evoker_Preservation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Evoker_Preservation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Evoker_Preservation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Evoker_Preservation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 13, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Evoker_Preservation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Evoker_Preservation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["EvokerAugmentation"]
	controls.labels.druidAugmentation = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Evoker_Augmentation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Evoker_Augmentation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 3, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Evoker_Augmentation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Evoker_Augmentation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 3, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Evoker_Augmentation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Evoker_Augmentation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 3, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Evoker_Augmentation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Evoker_Augmentation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 13, 3, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Evoker_Augmentation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Evoker_Augmentation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 3, false, false, false, true, false)
	end)

	yCoord = yCoord - 35
	controls.labels.hunter = TRB.Functions.OptionsUi:BuildLabel(parent, L["Hunter"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Hunter_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Hunter_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Hunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Hunter_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Hunter_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Hunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Hunter_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Hunter_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Hunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Hunter_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Hunter_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Hunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Hunter_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Hunter_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Hunter"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, nil, false, false, false, true, false)
	end)


	yCoord = yCoord - 25
	specName = L["HunterBeastMastery"]
	controls.labels.hunterBeastMastery = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Hunter_BeastMastery_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Hunter_BeastMastery_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Hunter_BeastMastery_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["HunterMarksmanship"]
	controls.labels.hunterMarksmanship = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Hunter_Marksmanship_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Hunter_Marksmanship_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Hunter_Marksmanship_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Hunter_Marksmanship_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Hunter_Marksmanship_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["HunterSurvival"]
	controls.labels.hunterSurvival = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Hunter_Survival_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Hunter_Survival_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 3, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Hunter_Survival_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Hunter_Survival_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 3, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Hunter_Survival_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 3, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Hunter_Survival_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, 3, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Hunter_Survival_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 3, false, false, false, true, false)
	end)
	

	yCoord = yCoord - 35
	controls.labels.monk = TRB.Functions.OptionsUi:BuildLabel(parent, L["Monk"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Monk_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Monk_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Monk"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Monk_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Monk_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Monk"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Monk_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Monk_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Monk"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Monk_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Monk_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Monk"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 10, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Monk_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Monk_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Monk"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["MonkMistweaver"]
	controls.labels.monkMistweaver = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Monk_Mistweaver_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Monk_Mistweaver_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Monk_Mistweaver_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Monk_Mistweaver_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Monk_Mistweaver_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Monk_Mistweaver_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Monk_Mistweaver_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Monk_Mistweaver_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 10, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Monk_Mistweaver_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Monk_Mistweaver_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["MonkWindwalker"]
	controls.labels.monkWindwalker = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Monk_Windwalker_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Monk_Windwalker_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 3, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Monk_Windwalker_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Monk_Windwalker_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 3, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Monk_Windwalker_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Monk_Windwalker_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 3, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Monk_Windwalker_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Monk_Windwalker_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 10, 3, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Monk_Windwalker_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Monk_Windwalker_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 3, false, false, false, true, false)
	end)
	

	yCoord = yCoord - 35
	controls.labels.Paladin = TRB.Functions.OptionsUi:BuildLabel(parent, L["Paladin"], oUi.xCoord, yCoord, 110, 20)
	buttonOffset = oUi.xCoord + oUi.xPadding + 100

	yCoord = yCoord - 25
	specName = L["PaladinHoly"]
	controls.labels.druidHoly = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Paladin_Holy_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Paladin_Holy_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PaladinHolyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 2, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Paladin_Holy_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Paladin_Holy_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PaladinHolyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 2, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Paladin_Holy_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Paladin_Holy_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PaladinHolyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 2, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Paladin_Holy_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Paladin_Holy_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PaladinHolyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 2, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Paladin_Holy_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Paladin_Holy_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PaladinHolyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 2, 1, false, false, false, true, false)
	end)


	yCoord = yCoord - 35
	controls.labels.priest = TRB.Functions.OptionsUi:BuildLabel(parent, L["Priest"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Priest_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Priest_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Priest"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Priest_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Priest_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Priest"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Priest_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Priest_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Priest"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Priest_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Priest_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Priest"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Priest_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Priest_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Priest"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["PriestDiscipline"]
	controls.labels.priestDiscipline = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)
	
	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Priest_Discipline_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Priest_Discipline_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 1, true, true, true, true, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Priest_Discipline_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Priest_Discipline_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 1, true, false, false, false, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Priest_Discipline_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Priest_Discipline_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 1, false, true, false, false, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Priest_Discipline_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Priest_Discipline_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, 1, false, false, true, false, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Priest_Discipline_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Priest_Discipline_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["PriestHoly"]
	controls.labels.priestHoly = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Priest_Holy_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Priest_Holy_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Priest_Holy_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Priest_Holy_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Priest_Holy_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Priest_Holy_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Priest_Holy_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Priest_Holy_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Priest_Holy_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Priest_Holy_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["PriestShadow"]
	controls.labels.priestShadow = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Priest_Shadow_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 3, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Priest_Shadow_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Priest_Shadow_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 3, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Priest_Shadow_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 3, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Priest_Shadow_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Priest_Shadow_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, 3, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Priest_Shadow_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Priest_Shadow_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 3, false, false, false, true, false)
	end)

	yCoord = yCoord - 35
	controls.labels.rogue = TRB.Functions.OptionsUi:BuildLabel(parent, L["Rogue"], oUi.xCoord, yCoord, 110, 20)
	
	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Rogue_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Rogue_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Rogue"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Rogue_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Rogue_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Rogue"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Rogue_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Rogue_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Rogue"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Rogue_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Rogue_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Rogue"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Rogue_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Rogue_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Rogue"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["RogueAssassination"]
	controls.labels.rogueAssassination = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Rogue_Assassination_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Rogue_Assassination_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Rogue_Assassination_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Rogue_Assassination_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Rogue_Assassination_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Rogue_Assassination_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Rogue_Assassination_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Rogue_Assassination_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Rogue_Assassination_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Rogue_Assassination_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 1, false, false, false, true, false)
	end)


	yCoord = yCoord - 25
	specName = L["RogueOutlaw"]
	controls.labels.rogueOutlaw = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Rogue_Outlaw_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Rogue_Outlaw_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Rogue_Outlaw_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Rogue_Outlaw_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Rogue_Outlaw_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Rogue_Outlaw_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Rogue_Outlaw_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Rogue_Outlaw_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Rogue_Outlaw_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Rogue_Outlaw_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["RogueSubtlety"]
	controls.labels.rogueSubtlety = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Rogue_Subtlety_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Rogue_Subtlety_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 3, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Rogue_Subtlety_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Rogue_Subtlety_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 3, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Rogue_Subtlety_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Rogue_Subtlety_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 3, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Rogue_Subtlety_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Rogue_Subtlety_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, 3, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Rogue_Subtlety_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Rogue_Subtlety_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 3, false, false, false, true, false)
	end)

	yCoord = yCoord - 35
	controls.labels.shaman = TRB.Functions.OptionsUi:BuildLabel(parent, L["Shaman"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Shaman_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Shaman_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Shaman"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Shaman_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Shaman_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Shaman"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Shaman_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Shaman_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Shaman"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Shaman_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Shaman_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Shaman"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Shaman_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Shaman_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Shaman"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["ShamanElemental"]
	controls.labels.shamanElemental = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Shaman_Elemental_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Shaman_Elemental_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Shaman_Elemental_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Shaman_Elemental_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Shaman_Elemental_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Shaman_Elemental_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Shaman_Elemental_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Shaman_Elemental_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Shaman_Elemental_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 1, false, false, false, true, false)
	end)

	if TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		yCoord = yCoord - 25
		specName = L["ShamanEnhancement"]
		controls.labels.shamanEnhancement = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)
		
		buttonOffset = oUi.xCoord + oUi.xPadding + 100
		controls.buttons.exportButton_Shaman_Enhancement_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
		controls.buttons.exportButton_Shaman_Enhancement_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 2, true, true, true, true, false)
		end)
		
		buttonOffset = buttonOffset + buttonSpacing + 50
		controls.exportButton_Shaman_Enhancement_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
		controls.exportButton_Shaman_Enhancement_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 2, true, false, false, false, false)
		end)
		
		buttonOffset = buttonOffset + buttonSpacing + 80
		controls.exportButton_Shaman_Enhancement_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
		controls.exportButton_Shaman_Enhancement_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 2, false, true, false, false, false)
		end)
		
		buttonOffset = buttonOffset + buttonSpacing + 90
		controls.exportButton_Shaman_Enhancement_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
		controls.exportButton_Shaman_Enhancement_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 2, false, false, true, false, false)
		end)
		
		buttonOffset = buttonOffset + buttonSpacing + 120
		controls.exportButton_Shaman_Enhancement_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
		controls.exportButton_Shaman_Enhancement_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 2, false, false, false, true, false)
		end)
	end

	yCoord = yCoord - 25
	specName = L["ShamanRestoration"]
	controls.labels.shamanRestoration = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Shaman_Restoration_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Shaman_Restoration_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 3, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Shaman_Restoration_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Shaman_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 3, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Shaman_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Shaman_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 3, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Shaman_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Shaman_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 3, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Shaman_Restoration_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Shaman_Restoration_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 3, false, false, false, true, false)
	end)


	yCoord = yCoord - 35
	controls.labels.warlock = TRB.Functions.OptionsUi:BuildLabel(parent, L["Warlock"], oUi.xCoord, yCoord, 110, 20)

	yCoord = yCoord - 25
	specName = L["WarlockAffliction"]
	controls.labels.warlockAffliction = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)
	
	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Shaman_Enhancement_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Shaman_Enhancement_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 9, 1, true, true, true, true, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Shaman_Enhancement_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Shaman_Enhancement_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 9, 1, true, false, false, false, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Shaman_Enhancement_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Shaman_Enhancement_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 9, 1, false, true, false, false, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Shaman_Enhancement_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Shaman_Enhancement_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 9, 1, false, false, true, false, false)
	end)
	
	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Shaman_Enhancement_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Shaman_Enhancement_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 9, 1, false, false, false, true, false)
	end)


	yCoord = yCoord - 35
	controls.labels.warrior = TRB.Functions.OptionsUi:BuildLabel(parent, L["Warrior"], oUi.xCoord, yCoord, 110, 20)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Warrior_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Warrior_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Warrior"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, nil, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Warrior_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Warrior_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Warrior"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, nil, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Warrior_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Warrior_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Warrior"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, nil, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Warrior_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Warrior_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Warrior"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 1, nil, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Warrior_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Warrior_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessagePrefixAll"] .. " " .. L["Warrior"] .. " " .. L["ExportMessagePostfixSpecializations"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, nil, false, false, false, true, false)
	end)

	yCoord = yCoord - 25
	specName = L["WarriorArms"]
	controls.labels.warriorArms = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Warrior_Arms_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Warrior_Arms_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 1, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Warrior_Arms_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Warrior_Arms_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 1, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Warrior_Arms_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Warrior_Arms_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 1, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Warrior_Arms_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Warrior_Arms_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 1, 1, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Warrior_Arms_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Warrior_Arms_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 1, false, false, false, true, false)
	end)


	yCoord = yCoord - 25
	specName = L["WarriorFury"]
	controls.labels.warriorFury = TRB.Functions.OptionsUi:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Warrior_Fury_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
	controls.buttons.exportButton_Warrior_Fury_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 2, true, true, true, true, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 50
	controls.exportButton_Warrior_Fury_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
	controls.exportButton_Warrior_Fury_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 2, true, false, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 80
	controls.exportButton_Warrior_Fury_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
	controls.exportButton_Warrior_Fury_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 2, false, true, false, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 90
	controls.exportButton_Warrior_Fury_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
	controls.exportButton_Warrior_Fury_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 1, 2, false, false, true, false, false)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 120
	controls.exportButton_Warrior_Fury_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
	controls.exportButton_Warrior_Fury_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 2, false, false, false, true, false)
	end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.importExport = controls
end

function TRB.Options:ConstructOptionsPanel()
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

	local newsButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ShowNewsPopup"], 510, yCoord, 200, 40)
	newsButton:ClearAllPoints()
	newsButton:SetPoint("TOPRIGHT", yCoord, 5)
    newsButton:SetScript("OnClick", function(self, ...)
        TRB.Functions.News:Show()
    end)

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
	local localeText2 = string.format(percentFormat, 10.63)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 10.82)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 13.04)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.43)

	local localeText3 = "unfung; Google Translate"
	localeText3 = localeText3 .. "\n" .. "Twintop"
	localeText3 = localeText3 .. "\n" .. "Twintop"
	localeText3 = localeText3 .. "\n" .. "Traductor de Google — Se necesita traductor!"
	localeText3 = localeText3 .. "\n" .. "Traductor de Google — Se necesita traductor!"
	localeText3 = localeText3 .. "\n" .. "Koroshy; Google Translate"
	localeText3 = localeText3 .. "\n" .. "Google Translate — Traduttore necessario!"
	localeText3 = localeText3 .. "\n" .. "Google 번역 — 번역기가 필요합니다!"
	localeText3 = localeText3 .. "\n" .. "Google Tradutor — Precisa-se de tradutor!"
	localeText3 = localeText3 .. "\n" .. "Google Tradutor — Precisa-se de tradutor!"
	localeText3 = localeText3 .. "\n" .. "Google Translate — Требуется переводчик!"
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
	localeText4 = localeText4 .. "\n" .. "谷歌翻译 — 需要翻译！"
	localeText4 = localeText4 .. "\n" .. "谷歌翻譯 — 需要翻譯！"


	yCoord = yCoord - 150
	interfaceSettingsFrame.controls.labels.localization1 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "Localization" .. ":", localeText1, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 100, 15, 300)
	interfaceSettingsFrame.controls.labels.localization2 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "", localeText2, oUi.xCoord+(oUi.xPadding*2)+50, yCoord, 0, 100, 15, 300, "RIGHT")
	interfaceSettingsFrame.controls.labels.localization3 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "", localeText3, oUi.xCoord+(oUi.xPadding*2)+200, yCoord, 0, 375, 15, 300)
	interfaceSettingsFrame.controls.labels.localization4 = TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, "", localeText4, oUi.xCoord+(oUi.xPadding*2)+200, yCoord, 0, 375, 15, 300, nil, [[Fonts\ARHei.TTF]])

	yCoord = yCoord - 140

	---@diagnostic disable-next-line: inject-field
	interfaceSettingsFrame.panel.yCoord = yCoord
	TRB.Details.addonCategory = {}
	TRB.Details.addonCategory.specs = {}
	TRB.Details.addonCategory.main, _ = Settings.RegisterCanvasLayoutCategory(interfaceSettingsFrame.panel, L["TwintopsResourceBar"])
	Settings.RegisterAddOnCategory(TRB.Details.addonCategory.main)

	ConstructGlobalOptionsPanel()
	ConstructImportExportPanel()
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