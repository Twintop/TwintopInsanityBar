local _, TRB = ...
local L = TRB.Localization

TRB.Options = {}

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

local function ConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.core

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.global
	local yCoord = 5
	local f = nil

	local title = ""

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, nil, nil, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, nil, nil, yCoord, L["Resource"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, nil, nil, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
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

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Global_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["GlobalCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)
	
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
	f:SetChecked(TRB.Data.settings.core.smoothBarValueUpdates)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.smoothBarValueUpdates = self:GetChecked()
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

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab2", L["TabThresholds"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Global_Tab5", L["TabMiscellaneous"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, #tabs do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Global_LayoutPanel" .. i, parent)
		tabsheets[i]:Hide()
		tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.global = controls

	ConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	ConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	ConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--ShadowConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	ConstructMiscellaneousPanel(tabsheets[5].scrollFrame.scrollChild)
end

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
		controls.labels["export_" .. namePrefix] = TRB.Functions.OptionsUi:BuildLabel(parent, labelLocalization, oUi.xCoord, yCoord, 120, 20)
	elseif specId == nil then
		exportInnerMessage = L["ExportMessagePrefixAll"] .. " " .. classOrSpecLocalization .. " " .. L["ExportMessagePostfixSpecializations"]
		yCoord = yCoord - 35
		controls.labels["export_" .. namePrefix] = TRB.Functions.OptionsUi:BuildLabel(parent, labelLocalization, oUi.xCoord, yCoord, 120, 20)
	else
		exportInnerMessage = classOrSpecLocalization
		yCoord = yCoord - 25
		controls.labels["export_" .. namePrefix .. ""] = TRB.Functions.OptionsUi:BuildLabel(parent, labelLocalization, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)
	end

	if includeButtons then
		buttonOffset = oUi.xCoord + oUi.xPadding + 100
		controls.buttons["export_" .. namePrefix .. "_All"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAll"], buttonOffset, yCoord, 50, 20)
		controls.buttons["export_" .. namePrefix .. "_All"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. exportInnerMessage .. " " .. L["ExportMessagePostfixAll"] .. ".", classId, specId, true, true, true, true, true, false)
		end)

		buttonOffset = buttonOffset + buttonSpacing + 50
		controls["export_" .. namePrefix .. "_BarDisplay"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarDisplay"], buttonOffset, yCoord, 80, 20)
		controls["export_" .. namePrefix .. "_BarDisplay"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. exportInnerMessage .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", classId, specId, true, false, false, false, false, false)
		end)

		buttonOffset = buttonOffset + buttonSpacing + 80
		if includeThreshold then
			controls["export_" .. namePrefix .. "_Thresholds"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageThresholds"], buttonOffset, yCoord, 80, 20)
			controls["export_" .. namePrefix .. "_Thresholds"]:SetScript("OnClick", function(self, ...)
				TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. exportInnerMessage .. " " .. L["ExportMessagePostfixThresholds"] .. ".", classId, specId, false, true, false, false, false, false)
			end)
		end

		buttonOffset = buttonOffset + buttonSpacing + 80
		controls["export_" .. namePrefix .. "_FontAndText"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageFontText"], buttonOffset, yCoord, 90, 20)
		controls["export_" .. namePrefix .. "_FontAndText"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. exportInnerMessage .. " " .. L["ExportMessagePostfixFontText"] .. ".", classId, specId, false, false, true, false, false, false)
		end)

		buttonOffset = buttonOffset + buttonSpacing + 90
		if includeAudioTracking then
			controls["export_" .. namePrefix .. "_AudioAndTracking"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAudioTracking"], buttonOffset, yCoord, 120, 20)
			controls["export_" .. namePrefix .. "_AudioAndTracking"]:SetScript("OnClick", function(self, ...)
				TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. exportInnerMessage .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false,false, true, false, false)
			end)
		end

		buttonOffset = buttonOffset + buttonSpacing + 120
		controls["export_" .. namePrefix .. "_BarText"] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageBarText"], buttonOffset, yCoord, 70, 20)
		controls["export_" .. namePrefix .. "_BarText"]:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. exportInnerMessage .. " " .. L["ExportMessagePostfixBarText"] .. ".", classId, specId, false, false, false, false, true, false)
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
	parent.panel = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel", parent, 652, 555)
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

	buttonOffset = oUi.xCoord + oUi.xPadding + 100
	controls.buttons.exportButton_Everything = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageAllClassesSpecs"] .. " + " .. L["GlobalOptions"], buttonOffset, yCoord, 300, 20)
	controls.buttons.exportButton_Everything:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageAllClassesSpecs"] .. " + " .. L["GlobalOptions"] .. ".", nil, nil, true, false, true, true, true, true)
	end)

	buttonOffset = buttonOffset + buttonSpacing + 300
	controls.exportButton_All_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageGlobalOptionsOnly"], buttonOffset, yCoord, 200, 20)
	controls.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ExportMessageGlobalOptionsOnly"] .. ".", nil, -1, false, false, false, false, false, true)
	end)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, nil, nil, L["ExportMessageAllClassesSpecs"], L["ExportMessageAllClassesSpecs"])

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
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, nil, L["Hunter"], L["Hunter"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, 1, L["HunterBeastMastery"], L["HunterBeastMasteryFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, 2, L["HunterMarksmanship"], L["HunterMarksmanshipFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 3, 3, L["HunterSurvival"], L["HunterSurvivalFull"], true, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, nil, L["Mage"], L["Mage"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, 1, L["MageArcane"], L["MageArcaneFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, 2, L["MageFire"], L["MageFireFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 8, 3, L["MageFrost"], L["MageFrostFull"], false, false)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, nil, L["Monk"], L["Monk"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, 1, L["MonkBrewmaster"], L["MonkBrewmasterFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, 2, L["MonkMistweaver"], L["MonkMistweaverFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 10, 3, L["MonkWindwalker"], L["MonkWindwalkerFull"], true, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, nil, L["Paladin"], L["Paladin"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, 1, L["PaladinHoly"], L["PaladinHolyFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, 2, L["PaladinProtection"], L["PaladinProtectionFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 2, 3, L["PaladinRetribution"], L["PaladinRetributionFull"], false, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, nil, L["Priest"], L["Priest"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, 1, L["PriestDiscipline"], L["PriestDisciplineFull"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, 2, L["PriestHoly"], L["PriestHolyFull"], false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 5, 3, L["PriestShadow"], L["PriestShadowFull"])
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, nil, L["Rogue"], L["Rogue"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, 1, L["RogueAssassination"], L["RogueAssassinationFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, 2, L["RogueOutlaw"], L["RogueOutlawFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 4, 3, L["RogueSubtlety"], L["RogueSubtletyFull"], true, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, nil, L["Shaman"], L["Shaman"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, 1, L["ShamanElemental"], L["ShamanElementalFull"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, 2, L["ShamanEnhancement"], L["ShamanEnhancementFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 7, 3, L["ShamanRestoration"], L["ShamanRestorationFull"], false, false)
	
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, nil, L["Warlock"], L["Warlock"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, 1, L["WarlockAffliction"], L["WarlockAfflictionFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, 2, L["WarlockDemonology"], L["WarlockDemonologyFull"], false, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 9, 3, L["WarlockDestruction"], L["WarlockDestructionFull"], false, false)

	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, nil, L["Warrior"], L["Warrior"])
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, 1, L["WarriorArms"], L["WarriorArmsFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, 2, L["WarriorFury"], L["WarriorFuryFull"], true, false)
	yCoord = ConstructImportExportRow(parent, yCoord, controls, 1, 3, L["WarriorProtection"], L["WarriorProtectionFull"], true, false)
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
	local localeText2 = string.format(percentFormat, 10.06)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 11.90)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 100.00)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 12.25)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)
	localeText2 = localeText2 .. "\n" .. string.format(percentFormat, 0.40)

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


	yCoord = yCoord - 170
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