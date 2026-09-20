local _, TRB = ...
local L = TRB.Localization
local oUi = TRB.Data.constants.optionsUi

-- Druid options (World of Warcraft: Forever): default settings, default bar text, and the options panel for the
-- Mana, Rage, Energy, and Combo Point bars.

TRB.Options = TRB.Options or {}
TRB.Options.Druid = TRB.Options.Druid or {}

local className, specName, compositeKey, classId, specId = "druid", "general", "druid_general", 11, 1
local namePrefix = "Druid_General"
local fullLabel = L["DruidGeneralFull"]
local formBars = {
	{ key = "rage", tabKey = "rageBar", label = L["TabRage"], resourceName = L["ResourceRage"], frame = "RageBar", frameName = L["RageBar"], variable = "$rage" },
	{ key = "energy", tabKey = "energyBar", label = L["TabEnergy"], resourceName = L["ResourceEnergy"], frame = "EnergyBar", frameName = L["EnergyBar"], variable = "$energy" },
}

---The registered form bar types, in options order.
---@return TRB.Classes.BarTypeDefinition[]
local function GetFormBarTypes()
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local types = {}
	for _, formBar in ipairs(formBars) do
		types[#types + 1] = registry:Get(formBar.key)
	end
	return types
end

---Default bar text: the Mana text on the primary bar plus one centered text per form bar.
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function LoadDefaultBarTextSettings(classic)
	local textSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for _, formBar in ipairs(formBars) do
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = formBar.frameName,
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = formBar.variable,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize = 16,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = formBar.frame,
				relativeToFrameName = formBar.frameName,
			},
		})
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Druid.GeneralLoadDefaultBarTextSettings = LoadDefaultBarTextSettings

---Default settings.
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	-- Each bar hides by default in the forms that cannot use its resource; the user can untick any of them.
	local visibility = function(smooth, hiddenInForms)
		local hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()
		for _, key in ipairs(hiddenInForms or {}) do
			hideConditions[key] = true
		end
		return { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = hideConditions, smooth = smooth, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 }
	end
	local notBear = { "isDruidHumanoidForm", "isDruidTravelFormAny", "isDruidCatForm", "isDruidMoonkinForm" }
	local notCat = { "isDruidHumanoidForm", "isDruidTravelFormAny", "isDruidBearForm", "isDruidMoonkinForm" }
	local comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic)
	comboPoints.anchor.barKey = "energy"

	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1,
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder = true,
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				maul = { enabled = true },
				demoralizingRoar = { enabled = true },
				bash = { enabled = true },
				challengingRoar = { enabled = false },
				frenziedRegeneration = { enabled = true },
				swipe = { enabled = true },
				feralCharge = { enabled = false },
				claw = { enabled = true },
				shred = { enabled = true },
				rake = { enabled = true },
				ravage = { enabled = true },
				pounce = { enabled = false },
				rip = { enabled = true },
				ferociousBite = { enabled = true },
				cower = { enabled = false },
				tigersFury = { enabled = true },
			},
			customThresholds = {},
		},
		displayBar = {
			primary = visibility(true, { "isDruidCatForm", "isDruidBearForm", "isDruidMoonkinForm" }),
			rage = visibility(true, notBear),
			energy = visibility(true, notCat),
			secondary = visibility(false, notCat),
			health = visibility(true),
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			rage = TRB.Functions.Settings:DefaultDruidFormBarDimensions(classic),
			energy = TRB.Functions.Settings:DefaultDruidFormBarDimensions(classic),
		},
		comboPoints = comboPoints,
		colors = {
			text = {
				current = { color = "FF4D4DFF" },
				rage = { color = "FFFF0000" },
				energy = { color = "FFFFFF00" },
				casting = { color = "FFFFFFFF" },
				passive = { color = "FF8080FF" },
				overThreshold = { color = "FF00FF00", enabled = false },
				overcap = { color = "FFFF0000", enabled = true },
			},
			bar = {
				border = { color = "FF000099" },
				borderOvercap = { color = "FFFF0000", enabled = true },
				background = { color = "66000000" },
				base = { color = "FF0000FF", color2 = "FF0000FF", gradientDirection = "disabled" },
				casting = { color = "FFFFFFFF", color2 = "FFFFFFFF", gradientDirection = "disabled", enabled = true },
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			bars = {
				rage = TRB.Functions.Settings:DefaultDruidRageBarColors(),
				energy = TRB.Functions.Settings:DefaultDruidEnergyBarColors(),
			},
			comboPoints = {
				border = { color = "FFFFD300" },
				background = { color = "66000000" },
				base = { color = "FFFFFF00", color2 = "FFFFFF00", gradientDirection = "disabled" },
				penultimate = { color = "FFFF9900", color2 = "FFFF9900", gradientDirection = "disabled" },
				final = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled" },
				sameColor = false,
			},
			threshold = {
				under = { color = "FFFFFFFF" },
				over = { color = "FF00FF00" },
				unusable = { color = "FFFF0000" },
				special = { color = "FFFF00FF", enabled = true },
				outOfRange = { color = "FF440000", enabled = true, show = true },
			},
			shared = {
				nodeOrder = {},
				gradientOrder = {},
				indicatorColors = {},
			},
		},
		displayText = {
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize = 14,
				color = { color = "FFFFFFFF" },
				fontOutline = "OUTLINE",
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			},
			barText = {},
		},
		audio = {},
		textures = TRB.Functions.Settings:DefaultTextures(true, false, GetFormBarTypes()),
	}

	if includeBarText then
		settings.displayText.barText = LoadDefaultBarTextSettings(classic)
	end

	return settings
end
TRB.Options.Druid.GeneralLoadDefaultSettings = LoadDefaultSettings

---Loads default settings for the whole class.
---@param includeBarText boolean?
---@param classic boolean?
---@return table
function TRB.Options.Druid.LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()
	settings[className][specName] = LoadDefaultSettings(includeBarText, classic)
	return settings
end

---Wraps a tab builder with the spec settings and controls.
---@param build fun(parent: Frame, specSettings: table, controls: table, ...)
---@return fun(parent: Frame?, ...)
local function withSpec(build)
	return function(parent, ...)
		if parent == nil then
			return
		end
		local specSettings = TRB.Data.settings[className][specName]
		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls[compositeKey]
		build(parent, specSettings, controls, ...)
	end
end

local manaBarPanel = withSpec(function(parent, specSettings, controls)
	local yCoord = 5
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord)
	yCoord = yCoord - 40
	TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, specSettings, classId, specId, yCoord, L["ResourceMana"])
end)

---Builds the tab of one form bar: its dimensions and colors.
---@param formBar table
---@return fun(parent: Frame?)
local function BuildFormBarPanel(formBar)
	return withSpec(function(parent, specSettings, controls)
		local barTypeDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(formBar.key)
		local yCoord = 5
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord, barTypeDef, L["ResourceMana"])
		yCoord = yCoord - 90
		TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, specSettings, classId, specId, yCoord, barTypeDef)
	end)
end

local comboPointsPanel = withSpec(function(parent, specSettings, controls)
	local yCoord = 5
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	local function gradientPicker(key, label)
		yCoord = yCoord - 30
		local picker = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, label, specSettings.colors.comboPoints[key], oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		controls.colors.comboPoints[key] = picker
		picker.Swatch1:SetScript("OnMouseDown", function(_, button)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, specSettings.colors.comboPoints, controls.colors.comboPoints, key)
		end)
		picker.Swatch2:SetScript("OnMouseDown", function(self, button)
			TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, specSettings.colors.comboPoints[key], self)
		end)
	end
	gradientPicker("base", L["ResourceComboPoints"])
	gradientPicker("penultimate", L["ComboPointColorPickerPenultimate"])
	gradientPicker("final", L["ComboPointColorPickerFinal"])

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	local f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. "Text"):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(specSettings.comboPoints.sameColor)
	f:SetScript("OnClick", function(self)
		specSettings.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], specSettings.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.comboPoints.border:SetScript("OnMouseDown", function(_, button)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, specSettings.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], specSettings.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.comboPoints.background:SetScript("OnMouseDown", function(_, button)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, specSettings.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, specSettings.colors.comboPoints, namePrefix .. "_ComboPoints", "endCapComboPoints", L["EndCap"], classId, specId)
end)

local healthBarPanel = withSpec(function(parent, specSettings, controls)
	local yCoord = 5
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord, L["ResourceMana"])
	yCoord = yCoord - 60
	TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, specSettings, classId, specId, yCoord)
end)

local thresholdSettingsPanel = withSpec(function(parent, specSettings, controls)
	local yCoord = 5
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, specSettings, classId, specId, yCoord, L["ResourceMana"], true, true, true, true, {})
	yCoord = yCoord - 40
	TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, specSettings, classId, specId, yCoord)
end)

local thresholdListPanel = withSpec(function(parent, specSettings, controls)
	TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, specSettings, classId, specId, 5, {
		barTargetLabels = {
			rage = L["ResourceRage"],
			energy = L["ResourceEnergy"],
		},
	})
end)

local texturesPanel = withSpec(function(parent, specSettings, controls)
	TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, specSettings, classId, specId, 5, true, L["ResourceComboPoints"], false, GetFormBarTypes())
end)

local visibilityPanel = withSpec(function(parent, specSettings, controls)
	TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, specSettings, classId, specId, 5, L["ResourceMana"], "notFull", true, L["ResourceComboPoints"], true, nil, GetFormBarTypes())
end)

local fontTextPanel = withSpec(function(parent, specSettings, controls)
	local yCoord = 5
	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, specSettings, classId, specId, yCoord)
	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ForeverTextColorsHeader"], oUi.xCoord, yCoord)
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, specSettings, classId, specId, yCoord)

	yCoord = yCoord - 30
	local function textPicker(key, label, x)
		local picker = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, label, specSettings.colors.text[key].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, x, yCoord)
		controls.colors.text[key] = picker
		picker:SetScript("OnMouseDown", function(_, button)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, specSettings.colors.text, controls.colors.text, key)
		end)
	end
	textPicker("current", string.format(L["ForeverColorPickerCurrentResource"], L["ResourceMana"]), oUi.xCoord)
	textPicker("casting", string.format(L["ForeverColorPickerCastingResource"], L["ResourceMana"]), oUi.xCoord2)
	yCoord = yCoord - 30
	textPicker("rage", string.format(L["ForeverColorPickerCurrentResource"], L["ResourceRage"]), oUi.xCoord)
	textPicker("energy", string.format(L["ForeverColorPickerCurrentResource"], L["ResourceEnergy"]), oUi.xCoord2)
	TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, specSettings, classId, specId, yCoord)
end)

local function barTextPanel(parent, cache)
	if parent == nil then
		return
	end
	local specSettings = TRB.Data.settings[className][specName]
	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls[compositeKey]
	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, 5)
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, specSettings, classId, specId, -25, cache)
end

local resetDefaultsPanel = withSpec(function(parent, _, controls)
	local popupPrefix = "TwintopResourceBar_" .. namePrefix .. "_"
	local yCoord = 5

	local function resetBarText(classic)
		local settings = TRB.Data.settings[className][specName]
		settings.displayText.barText = LoadDefaultBarTextSettings(classic)
		TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer[specName .. "DisplayPanel"], "barText")
		controls.barTextFields.ResetTableValues(settings.displayText.barText)
	end

	StaticPopupDialogs[popupPrefix .. "Reset"] = {
		text = string.format(L["ResetBarDialog"], fullLabel),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings[className][specName] = LoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}
	StaticPopupDialogs[popupPrefix .. "ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], fullLabel),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings[className][specName] = LoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}
	StaticPopupDialogs[popupPrefix .. "ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], fullLabel),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function() resetBarText(false) end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}
	StaticPopupDialogs[popupPrefix .. "ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], fullLabel),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function() resetBarText(true) end,
		timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function() StaticPopup_Show(popupPrefix .. "Reset") end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function() StaticPopup_Show(popupPrefix .. "ResetClassic") end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function() StaticPopup_Show(popupPrefix .. "ResetBarTextCompact") end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function() StaticPopup_Show(popupPrefix .. "ResetBarTextClassic") end)
end)

---Builds the Druid options panel.
---@param cache TRB.Classes.SpecCache
local function ConstructSpecPanel(cache)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls[compositeKey] or {}
	controls.colors = { text = {} }
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	local panel = CreateFrame("Frame", "TwintopResourceBar_Options_" .. namePrefix)
	interfaceSettingsFrame[specName .. "DisplayPanel"] = panel
	TRB.Options.OptionsFrame:RegisterSpecPanel(className, compositeKey, fullLabel, panel)

	local yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(panel, controls, fullLabel,
		TRB.Data.settings.core.enabled[className], specName,
		"TwintopResourceBar_" .. namePrefix .. "_enabled", specName .. "DruidEnabled",
		className, specName)

	local tabDefinitions = {
		{ "resourceBar", L["TabMana"], oUi.tabWidth.small, manaBarPanel, visibilityKey = "primary" },
	}
	for _, formBar in ipairs(formBars) do
		tabDefinitions[#tabDefinitions + 1] = { formBar.tabKey, formBar.label, oUi.tabWidth.small, BuildFormBarPanel(formBar), visibilityKey = formBar.key }
	end
	tabDefinitions[#tabDefinitions + 1] = { "comboPoints", L["TabComboPoints"], oUi.tabWidth.medium, comboPointsPanel, visibilityKey = "secondary" }
	tabDefinitions[#tabDefinitions + 1] = { "healthBar", L["TabHealth"], oUi.tabWidth.small, healthBarPanel, visibilityKey = "health" }
	tabDefinitions[#tabDefinitions + 1] = { "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, thresholdSettingsPanel }
	tabDefinitions[#tabDefinitions + 1] = { "thresholds", L["TabThresholds"], oUi.tabWidth.large, thresholdListPanel, true }
	tabDefinitions[#tabDefinitions + 1] = TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition(className, specName, controls)
	tabDefinitions[#tabDefinitions + 1] = { "barTextures", L["TabTextures"], oUi.tabWidth.small, texturesPanel }
	tabDefinitions[#tabDefinitions + 1] = { "barVisibility", L["TabVisibility"], oUi.tabWidth.small, visibilityPanel }
	tabDefinitions[#tabDefinitions + 1] = { "fontText", L["TabFontText"], oUi.tabWidth.medium, fontTextPanel }
	tabDefinitions[#tabDefinitions + 1] = { "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) barTextPanel(scrollChild, cache) end }
	tabDefinitions[#tabDefinitions + 1] = { "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, resetDefaultsPanel }

	interfaceSettingsFrame.controls[compositeKey] = controls
	-- BuildTabGroup recognizes a spec panel by its classToken_specName prefix; that earns it the Cast Bars and Other Bars tabs and spec-scoped tab headers.
	local tabClassName, tabSpecName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(panel, tabClassName .. "_" .. tabSpecName, tabDefinitions, yCoord)
end

---Builds the Druid options panel.
---@param specCache table<string, TRB.Classes.SpecCache>
function TRB.Options.Druid.ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader(className, L["Druid"])
	ConstructSpecPanel(specCache[compositeKey])
	TRB.Options.OptionsFrame:RefreshNav()
end
