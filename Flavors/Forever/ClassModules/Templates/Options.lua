local _, TRB = ...
local L = TRB.Localization
local oUi = TRB.Data.constants.optionsUi

TRB.Forever = TRB.Forever or {}
TRB.Forever.Templates = TRB.Forever.Templates or {}
TRB.Forever.Templates.Options = {}

-- World of Warcraft: Forever class template, part 3 of 3 (the Options stage).
--
-- Installs TRB.Options.<Class> for a class from its DefineClass definition: the per-spec default
-- settings and default bar text factories the bootstrap, profiles and reset buttons call, and the
-- options panel with the standard tabs (resource bar, combo points where the archetype has them,
-- health bar, thresholds, custom thresholds, textures, visibility, font & text, bar text, reset). Loads
-- for every class so the cross-class options panel can show all of them.

---Default settings for one spec.
---@param classDef TRB.Forever.ClassDefinition
---@param spec TRB.Forever.SpecDefinition
---@param loadDefaultBarText fun(classic: boolean?): table
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSpecSettings(classDef, spec, loadDefaultBarText, includeBarText, classic)
	local archetype = spec.archetype
	local colors = archetype.colors
	local hasSecondary = archetype.secondary ~= nil
	local maxResource = spec.entry.resources[archetype.variable] or archetype.defaultMax

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
			thresholdDictionary = {},
			customThresholds = {},
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = { color = colors.textCurrent },
				casting = { color = colors.textCasting },
				passive = { color = colors.textPassive },
				overThreshold = { color = "FF00FF00", enabled = false },
				overcap = { color = "FFFF0000", enabled = true },
			},
			bar = {
				border = { color = colors.barBorder },
				borderOvercap = { color = "FFFF0000", enabled = true },
				background = { color = colors.barBackground },
				base = { color = colors.barBase, color2 = colors.barBase, gradientDirection = "disabled" },
				casting = { color = colors.textCasting, color2 = colors.textCasting, gradientDirection = "disabled", enabled = true },
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
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
		textures = TRB.Functions.Settings:DefaultTextures(hasSecondary),
	}

	if archetype.key ~= "mana" then
		settings.maxResource = { value = maxResource, enabled = false }
		settings.overcap = { mode = "relative", relative = 0, fixed = maxResource }
	end

	if hasSecondary then
		settings.comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic)
		settings.colors.comboPoints = {
			border = { color = colors.barBorder },
			background = { color = colors.barBackground },
			base = { color = colors.barBase, color2 = colors.barBase, gradientDirection = "disabled" },
			penultimate = { color = "FFFF9900", color2 = "FFFF9900", gradientDirection = "disabled" },
			final = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled" },
			sameColor = false,
		}
	end

	if includeBarText then
		settings.displayText.barText = loadDefaultBarText(classic)
	end

	return settings
end

---Builds the reset-defaults tab for one spec.
---@param classDef TRB.Forever.ClassDefinition
---@param spec TRB.Forever.SpecDefinition
---@param loadDefaultSettings fun(includeBarText: boolean?, classic: boolean?): table
---@param loadDefaultBarText fun(classic: boolean?): table
---@return fun(parent: Frame)
local function BuildResetDefaultsPanel(classDef, spec, loadDefaultSettings, loadDefaultBarText)
	local className = classDef.className
	local specName = spec.entry.specName
	local compositeKey = spec.entry.compositeKey
	local fullLabel = L[spec.entry.specLocaleKey .. "Full"]
	local popupPrefix = "TwintopResourceBar_" .. classDef.classModuleName .. "_" .. spec.specPascal .. "_"

	return function(parent)
		if parent == nil then
			return
		end
		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls[compositeKey]
		local yCoord = 5

		local function resetBarText(classic)
			local settings = TRB.Data.settings[className][specName]
			settings.displayText.barText = loadDefaultBarText(classic)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer[specName .. "DisplayPanel"], "barText")
			controls.barTextFields.ResetTableValues(settings.displayText.barText)
		end

		StaticPopupDialogs[popupPrefix .. "Reset"] = {
			text = string.format(L["ResetBarDialog"], fullLabel),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings[className][specName] = loadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
		}
		StaticPopupDialogs[popupPrefix .. "ResetClassic"] = {
			text = string.format(L["ResetBarClassicDialog"], fullLabel),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings[className][specName] = loadDefaultSettings(true, true)
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
	end
end

---Builds the combo point tab for a spec with a secondary bar.
---@param classDef TRB.Forever.ClassDefinition
---@param spec TRB.Forever.SpecDefinition
---@return fun(parent: Frame)
local function BuildComboPointsPanel(classDef, spec)
	local classId, specId = classDef.classId, spec.entry.specId
	local compositeKey = spec.entry.compositeKey
	local resourceName = L[spec.archetype.nameKey]
	local secondaryName = L[spec.archetype.secondary.nameKey]
	local namePrefix = classDef.classModuleName .. "_" .. spec.specPascal

	return function(parent)
		if parent == nil then
			return
		end
		local specSettings = TRB.Data.settings[classDef.className][spec.entry.specName]
		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls[compositeKey]
		local yCoord = 5

		yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord, resourceName, secondaryName)

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
		gradientPicker("base", secondaryName)
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

		yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, specSettings.colors.comboPoints, namePrefix .. "_ComboPoints", "endCapComboPoints", L["EndCap"], classId, specId)
	end
end

---Installs TRB.Options.<Class> for one class.
---@param className string
function TRB.Forever.Templates.Options:Install(className)
	local classDef = TRB.Forever.Classes[className]
	assert(classDef ~= nil, "TwintopInsanityBar: Forever options install for undefined class '" .. tostring(className) .. "'")
	local moduleName = classDef.classModuleName
	local classId = classDef.classId

	local options = TRB.Options[moduleName] or {}
	TRB.Options[moduleName] = options

	local specConstructors = {}

	for _, spec in ipairs(classDef.specOrder) do
		local specName = spec.entry.specName
		local specId = spec.entry.specId
		local compositeKey = spec.entry.compositeKey
		local archetype = spec.archetype
		local resourceName = L[archetype.nameKey]
		local hasSecondary = archetype.secondary ~= nil
		local fullLabel = L[spec.entry.specLocaleKey .. "Full"]

		options[spec.specPascal] = {}
		TRB.Frames.interfaceSettingsFrameContainer.controls[compositeKey] = {}

		---Default bar text: the archetype's resource text plus the shared global entries.
		---@param classic boolean?
		---@return TRB.Classes.Settings.DisplayTextEntry[]
		local function loadDefaultBarText(classic)
			local textSettings = {}
			local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings(archetype.defaultText, classic)
			for _, entry in ipairs(globalTextSettings) do
				textSettings[#textSettings + 1] = entry
			end
			return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
		end
		options[spec.specPascal .. "LoadDefaultBarTextSettings"] = loadDefaultBarText

		local function loadDefaultSettings(includeBarText, classic)
			return LoadDefaultSpecSettings(classDef, spec, loadDefaultBarText, includeBarText, classic)
		end
		options[spec.specPascal .. "LoadDefaultSettings"] = loadDefaultSettings

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

		local resourceBarPanel = withSpec(function(parent, specSettings, controls)
			local yCoord = 5
			yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord)
			yCoord = yCoord - 40
			yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, specSettings, classId, specId, yCoord, resourceName)
			if specSettings.maxResource ~= nil then
				yCoord = yCoord - 40
				TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, specSettings, classId, specId, yCoord, resourceName, 1, specSettings.maxResource.value)
			end
		end)

		local healthBarPanel = withSpec(function(parent, specSettings, controls)
			local yCoord = 5
			yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, specSettings, classId, specId, yCoord, resourceName)
			yCoord = yCoord - 60
			TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, specSettings, classId, specId, yCoord)
		end)

		local thresholdSettingsPanel = withSpec(function(parent, specSettings, controls)
			local yCoord = 5
			yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, specSettings, classId, specId, yCoord, resourceName, true, true, true, true, {})
			yCoord = yCoord - 40
			TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, specSettings, classId, specId, yCoord)
		end)

		local texturesPanel = withSpec(function(parent, specSettings, controls)
			TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, specSettings, classId, specId, 5, hasSecondary, hasSecondary and L[archetype.secondary.nameKey] or nil)
		end)

		local visibilityPanel = withSpec(function(parent, specSettings, controls)
			TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, specSettings, classId, specId, 5, resourceName, "notFull", hasSecondary, hasSecondary and L[archetype.secondary.nameKey] or nil, true)
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
			textPicker("current", string.format(L["ForeverColorPickerCurrentResource"], resourceName), oUi.xCoord)
			textPicker("casting", string.format(L["ForeverColorPickerCastingResource"], resourceName), oUi.xCoord2)
			TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, specSettings, classId, specId, yCoord)
		end)

		local barTextPanel = function(parent, cache)
			if parent == nil then
				return
			end
			local specSettings = TRB.Data.settings[className][specName]
			local controls = TRB.Frames.interfaceSettingsFrameContainer.controls[compositeKey]
			TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, 5)
			TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, specSettings, classId, specId, -25, cache)
		end

		local resetDefaultsPanel = BuildResetDefaultsPanel(classDef, spec, loadDefaultSettings, loadDefaultBarText)
		local comboPointsPanel = hasSecondary and BuildComboPointsPanel(classDef, spec) or nil

		specConstructors[#specConstructors + 1] = function(cache)
			local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
			local controls = interfaceSettingsFrame.controls[compositeKey] or {}
			controls.colors = { text = {} }
			controls.labels = {}
			controls.textbox = {}
			controls.checkBoxes = {}
			controls.dropDown = {}
			controls.buttons = controls.buttons or {}

			local panel = CreateFrame("Frame", "TwintopResourceBar_Options_" .. moduleName .. "_" .. spec.specPascal)
			interfaceSettingsFrame[specName .. "DisplayPanel"] = panel
			TRB.Options.OptionsFrame:RegisterSpecPanel(className, compositeKey, fullLabel, panel)

			local yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(panel, controls, fullLabel,
				TRB.Data.settings.core.enabled[className], specName,
				"TwintopResourceBar_" .. moduleName .. "_" .. spec.specPascal .. "_enabled", specName .. moduleName .. "Enabled",
				className, specName)

			local tabDefinitions = {
				{ "resourceBar", resourceName, oUi.tabWidth.small, resourceBarPanel, visibilityKey = "primary" },
			}
			if comboPointsPanel ~= nil then
				tabDefinitions[#tabDefinitions + 1] = { "comboPoints", L[archetype.secondary.nameKey], oUi.tabWidth.medium, comboPointsPanel, visibilityKey = "secondary" }
			end
			tabDefinitions[#tabDefinitions + 1] = { "healthBar", L["TabHealth"], oUi.tabWidth.small, healthBarPanel, visibilityKey = "health" }
			tabDefinitions[#tabDefinitions + 1] = { "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, thresholdSettingsPanel }
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
	end

	---Loads default settings for the whole class.
	---@param includeBarText boolean?
	---@param classic boolean?
	---@return table
	function options.LoadDefaultSettings(includeBarText, classic)
		local settings = TRB.Functions.Settings:LoadDefaultSettings()
		for _, spec in ipairs(classDef.specOrder) do
			settings[className][spec.entry.specName] = options[spec.specPascal .. "LoadDefaultSettings"](includeBarText, classic)
		end
		return settings
	end

	---Builds every spec panel of the class.
	---@param specCache table<string, TRB.Classes.SpecCache>
	function options.ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		TRB.Options.OptionsFrame:RegisterClassHeader(className, L[moduleName])
		for i, spec in ipairs(classDef.specOrder) do
			specConstructors[i](specCache[spec.entry.compositeKey])
		end
		TRB.Options.OptionsFrame:RefreshNav()
	end
end
