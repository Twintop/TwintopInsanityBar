local _, TRB = ...
local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Hunter = {}
TRB.Options.Hunter.BeastMastery = {}
TRB.Options.Hunter.Marksmanship = {}
TRB.Options.Hunter.Survival = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_beastMastery = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_marksmanship = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_survival = {}

local BEAST_MASTERY_MAX_FOCUS = 100
local MARKSMANSHIP_MAX_FOCUS = 100
local SURVIVAL_MAX_FOCUS = 100

---Loads default bar text settings for Beast Mastery
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function BeastMasteryLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("bestialWrathTime", "bestialWrath", classic, "CENTER", "RIGHT"))

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSettings = BeastMasteryLoadDefaultBarTextSettings

---Loads default settings for Beast Mastery
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function BeastMasteryLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				revivePet = {
					enabled = false,
				},
				wingClip = {
					enabled = false,
				},
				killCommand = {
					enabled = true,
				},
				scareBeast = {
					enabled = false,
				},
				cobraShot = {
					enabled = false,
				},
				blackArrow = {
					enabled = true,
				},
				wildThrash = {
					enabled = true,
				},
				wailingArrow = {
					enabled = true,
				},
				direBeastHawk = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = BEAST_MASTERY_MAX_FOCUS,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			bestialWrath = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0),
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = BEAST_MASTERY_MAX_FOCUS
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFAB5124"
				},
				casting = {
					color = "FFFFFFFF"
				},
				spending = {
					color = "FF555555"
				},
				passive = {
					color = "FF005500"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FFAB5124"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF8040"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				beastCleave = {
					color = "FF77FF77",
					enabled = true
				},
				bestialWrath = {
					color = "FF005500",
					enabled = true
				},
				bestialWrathEnd = {
					color = "FFFF0000"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			}
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = {
					color = "FFFFFFFF"
				},
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = {
					enabled = false,
					color = "FF000000",
					xOffset = 1,
					yOffset = -1,
				},
			},
			barText = {}
		},
		audio = {
			beastCleaveDown={
				name = L["HunterBeastMasteryAudioBeastCleaveDown"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = BeastMasteryLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Marksmanship
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function MarksmanshipLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("trueshotTime", "trueshot", classic, "CENTER", "RIGHT"))

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSettings = MarksmanshipLoadDefaultBarTextSettings

---Loads default settings for Marksmanship
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function MarksmanshipLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				arcaneShot = {
					enabled = true,
				},
				revivePet = {
					enabled = false,
				},
				wingClip = {
					enabled = false,
				},
				scareBeast = {
					enabled = false,
				},
				killShot = {
					enabled = true,
				},
				aimedShot = {
					enabled = true,
				},
				multiShot = {
					enabled = true,
				},
				blackArrow = {
					enabled = true,
				},
				wailingArrow = {
					enabled = true,
				},
			}
		},
		maxResource = {
			value = MARKSMANSHIP_MAX_FOCUS,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			trueshot = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0),
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = MARKSMANSHIP_MAX_FOCUS
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFAB5124"
				},
				casting = {
					color = "FFFFFFFF"
				},
				spending = {
					color = "FF555555"
				},
				passive = {
					color = "FF005500"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FFAB5124"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF8040"
				},
				trueshot = {
					color = "FF00B60E",
					enabled = true
				},
				trueshotEnd = {
					color = "FFFF0000"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
				spending = {
					color = "FFAAAAAA",
					enabled = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			}
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = {
					color = "FFFFFFFF"
				},
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = {
					enabled = false,
					color = "FF000000",
					xOffset = 1,
					yOffset = -1,
				},
			},
			barText = {}
		},
		audio = {
		},
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = MarksmanshipLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Survival
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function SurvivalLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("takedownTime", "takedown", classic, "CENTER", "RIGHT"))

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Hunter.SurvivalLoadDefaultBarTextSettings = SurvivalLoadDefaultBarTextSettings

---Loads default settings for Survival
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function SurvivalLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				revivePet = {
					enabled = false,
				},
				wingClip = {
					enabled = false,
				},
				scareBeast = {
					enabled = false,
				},
				boomstick = {
					enabled = true,
				},
				hatchetToss = {
					enabled = true,
				},
				raptorStrike = {
					enabled = true,
				},
			}
		},
		maxResource = {
			value = SURVIVAL_MAX_FOCUS,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			takedown = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0),
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = SURVIVAL_MAX_FOCUS
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFAB5124"
				},
				casting = {
					color = "FFFFFFFF"
				},
				spending = {
					color = "FF555555"
				},
				passive = {
					color = "FF005500"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FFAB5124"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF8040"
				},
				takedown = {
					color = "FF005500",
					enabled = true
				},
				takedownEnd = {
					color = "FFFF0000"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			comboPoints = {
				border = { color = "FFAB5124" },
				background = { color = "66000000" },
				base = { color = "FFFF8040" },
				penultimate = { color = "FFFF9900" },
				final = { color = "FFFF0000" },
				sameColor = false,
			},
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = {
					color = "FFFFFFFF"
				},
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = {
					enabled = false,
					color = "FF000000",
					xOffset = 1,
					yOffset = -1,
				},
			},
			barText = {}
		},
		audio = {
			totsThreshold1 = {
				name = L["HunterSurvivalAudioTotsThreshold1"],
				enabled = false,
				sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 3,
				},
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = SurvivalLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Hunter
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.hunter.beastMastery = BeastMasteryLoadDefaultSettings(includeBarText, classic)
	settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings(includeBarText, classic)
	settings.hunter.survival = SurvivalLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Hunter.LoadDefaultSettings = LoadDefaultSettings

--[[

Beast Mastery Option Menus

]]

local function BeastMasteryConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_beastMastery
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.beastMastery = BeastMasteryLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.beastMastery = BeastMasteryLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BeastMasteryLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BeastMasteryLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function BeastMasteryConstructFocusBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, 3, 1, yCoord, {
		endOfKey = "bestialWrath",
		activeColorKey = "bestialWrath",
		endColorKey = "bestialWrathEnd",
		checkboxLabel = L["HunterBeastMasteryCheckboxBestialWrath"],
		checkboxTooltip = L["HunterBeastMasteryCheckboxBestialWrathTooltip"],
		activeColorLabel = L["HunterBeastMasteryColorPickerBestialWrath"],
		endCheckboxLabel = L["HunterBeastMasteryCheckboxBestialWrathEnd"],
		endCheckboxTooltip = L["HunterBeastMasteryCheckboxBestialWrathEndTooltip"],
		endColorLabel = L["HunterBeastMasteryColorPickerBestialWrathEnd"],
	})

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], true, false)

	yCoord = yCoord - 30
	controls.checkBoxes.beastCleaveBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Border_Option_beastCleaveChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.beastCleaveBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryCheckboxBeastCleave"])
	f.tooltip = L["HunterBeastMasteryCheckboxBeastCleaveTooltip"]
	f:SetChecked(spec.colors.bar.beastCleave.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.beastCleave.enabled = self:GetChecked()
	end)

	controls.colors.beastCleave = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerBeastCleave"], spec.colors.bar.beastCleave.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.beastCleave
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "beastCleave")
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, 3, 1, yCoord, {
		endOfKey = "bestialWrath",
		sectionHeader = L["HunterBeastMasteryHeaderEndOfBestialWrathConfiguration"],
		gcdRadioLabel = L["HunterBeastMasteryCheckboxBestialWrathGcds"],
		gcdSliderLabel = L["HunterBeastMasteryBestialWrathGcds"],
		timeRadioLabel = L["HunterBeastMasteryCheckboxBestialWrathTime"],
		timeSliderLabel = L["HunterBeastMasteryBestialWrathTime"],
	})

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], BEAST_MASTERY_MAX_FOCUS)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], 1, BEAST_MASTERY_MAX_FOCUS)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateFlashOptions(parent, controls, spec, 3, 1, yCoord, L["HunterBeastMasteryBestialWrath"], L["HunterBeastMasteryBestialWrath"])
end

local function BeastMasteryConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 3, 1, yCoord)
end

local function BeastMasteryConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 1, yCoord, false)
end

local function BeastMasteryConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], "notFull", false, nil, true)
end

local function BeastMasteryConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_BeastMastery_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Hunter_BeastMastery_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 3, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20
	controls.checkBoxes.blackArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_blackArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blackArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxBlackArrow"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxBlackArrowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.blackArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.blackArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cobraShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_cobraShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cobraShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxCobraShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxCobraShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cobraShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cobraShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killCommandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxKillCommand"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxKillCommandTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.killCommand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.killCommand.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.wailingArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wailingArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wailingArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxWailingArrow"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxWailingArrowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wailingArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wailingArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wildThrashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wildThrash", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wildThrashThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxWildThrash"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxWildThrashTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wildThrash.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wildThrash.enabled = self:GetChecked()
	end)


	controls.labels.petAndUtility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revivePet.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.scareBeast.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wingClip.enabled = self:GetChecked()
	end)
	
	yCoord2 = yCoord2 - 25
	controls.labels.pvpthreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.direBeastHawkThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_direBeastHawk", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.direBeastHawkThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxDireBeastHawk"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxDireBeastHawkTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.direBeastHawk.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.direBeastHawk.enabled = self:GetChecked()
	end)

	yCoord = math.min(yCoord, yCoord2)
	
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 1, yCoord)
end

local function BeastMasteryConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_BeastMastery_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 3, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 1, yCoord)
end

local function BeastMasteryConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 1
	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "beastCleaveDown", spec, classId, specId, yCoord, L["HunterBeastMasteryAudioCheckboxBeastCleaveDown"], L["HunterBeastMasteryAudioCheckboxBeastCleaveDownTooltip"])
end

local function BeastMasteryConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Hunter_BeastMastery_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 1, yCoord, cache)
end

local function BeastMasteryConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(3, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.beastMasteryDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_BeastMastery")
	TRB.Options.OptionsFrame:RegisterSpecPanel("hunter", "hunter_beastMastery", L["HunterBeastMasteryFull"], interfaceSettingsFrame.beastMasteryDisplayPanel)

	parent = interfaceSettingsFrame.beastMasteryDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["HunterBeastMasteryFull"],
		TRB.Data.settings.core.enabled.hunter, "beastMastery",
		"TwintopResourceBar_Hunter_BeastMastery_beastMasteryHunterEnabled", "beastMasteryHunterEnabled",
		"exportButton_Hunter_BeastMastery_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 1, true, true, true, true, true, false)
		end)

	local tabDefinitions = {
		{ "focusBar", L["TabFocus"], oUi.tabWidth.small, BeastMasteryConstructFocusBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, BeastMasteryConstructHealthBarPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, BeastMasteryConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, BeastMasteryConstructBarVisibilityPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, BeastMasteryConstructThresholdPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, BeastMasteryConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, BeastMasteryConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) BeastMasteryConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, BeastMasteryConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_beastMastery = controls

	TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

--[[

Marksmanship Option Menus

]]

local function MarksmanshipConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_marksmanship
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MarksmanshipLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MarksmanshipLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function MarksmanshipConstructFocusBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], nil, true)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, 3, 2, yCoord, {
		endOfKey = "trueshot",
		activeColorKey = "trueshot",
		endColorKey = "trueshotEnd",
		checkboxLabel = L["HunterMarksmanshipCheckboxTrueshot"],
		checkboxTooltip = L["HunterMarksmanshipCheckboxTrueshotTooltip"],
		activeColorLabel = L["HunterMarksmanshipColorPickerTrueshot"],
		endCheckboxLabel = L["HunterMarksmanshipCheckboxEndOfTrueshot"],
		endCheckboxTooltip = L["HunterMarksmanshipCheckboxEndOfTrueshotTooltip"],
		endColorLabel = L["HunterMarksmanshipColorPickerTrueshotEnd"],
	})

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, 3, 2, yCoord, {
		endOfKey = "trueshot",
		sectionHeader = L["HunterMarksmanshipHeaderEndOfTrueshotConfiguration"],
		gcdRadioLabel = L["HunterMarksmanshipCheckboxTrueshotGcds"],
		gcdSliderLabel = L["HunterMarksmanshipTrueshotGcds"],
		timeRadioLabel = L["HunterMarksmanshipCheckboxTrueshotTime"],
		timeSliderLabel = L["HunterMarksmanshipTrueshotTime"],
	})

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], MARKSMANSHIP_MAX_FOCUS)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], 1, MARKSMANSHIP_MAX_FOCUS)
end

local function MarksmanshipConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 3, 2, yCoord)
end

local function MarksmanshipConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 2, yCoord, false)
end

local function MarksmanshipConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], "notFull", false, nil, true)
end

local function MarksmanshipConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_Marksmanship_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Hunter_Marksmanship_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 3, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.aimedShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aimedShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.aimedShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxAimedShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxAimedShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.aimedShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.aimedShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.arcaneShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.arcaneShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.arcaneShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.blackArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_blackArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blackArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxBlackArrow"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxBlackArrowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.blackArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.blackArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxKillShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxKillShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.killShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.multiShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxMultiShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxMultiShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.multiShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.multiShot.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.wailingArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_wailingArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wailingArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxWailingArrow"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxWailingArrowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wailingArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wailingArrow.enabled = self:GetChecked()
	end)

	controls.labels.petAndUtility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revivePet.enabled = self:GetChecked()
	end)
	
	yCoord2 = yCoord2 - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.scareBeast.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wingClip.enabled = self:GetChecked()
	end)

	yCoord = math.min(yCoord, yCoord2)
	
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 2, yCoord)
end

local function MarksmanshipConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Marksmanship_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 3, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingBuilder"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 2, yCoord)
end

local function MarksmanshipConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 2
	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--[[yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "aimedShot", spec, classId, specId, yCoord, L["HunterMarksmanshipCheckboxAimedShot"], L["HunterMarksmanshipCheckboxAimedShotTooltip"])
	
	controls.checkBoxes.aimedShotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.aimedShotModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxAimedShotGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.audio.aimedShot.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.aimedShotModeGCDs:SetChecked(true)
		controls.checkBoxes.aimedShotModeTime:SetChecked(false)
		spec.audio.aimedShot.mode = "gcd"
	end)

	title = L["HunterMarksmanshipAimedShotGcds"]
	controls.aimedShotGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 6, spec.audio.aimedShot.gcds, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.aimedShotGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.audio.aimedShot.gcds = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.aimedShotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.aimedShotModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxAimedShotTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.audio.aimedShot.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.aimedShotModeGCDs:SetChecked(false)
		controls.checkBoxes.aimedShotModeTime:SetChecked(true)
		spec.audio.aimedShot.mode = "time"
	end)

	title = L["HunterMarksmanshipAimedShotTime"]
	controls.aimedShotTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 12, spec.audio.aimedShot.time, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.aimedShotTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.audio.aimedShot.time = value
	end)
	yCoord = yCoord - 60]]
end

local function MarksmanshipConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Hunter_Marksmanship_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 2, yCoord, cache)
end

local function MarksmanshipConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(3, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.marksmanshipDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Marksmanship")
	TRB.Options.OptionsFrame:RegisterSpecPanel("hunter", "hunter_marksmanship", L["HunterMarksmanshipFull"], interfaceSettingsFrame.marksmanshipDisplayPanel)

	parent = interfaceSettingsFrame.marksmanshipDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["HunterMarksmanshipFull"],
		TRB.Data.settings.core.enabled.hunter, "marksmanship",
		"TwintopResourceBar_Hunter_Marksmanship_marksmanshipHunterEnabled", "marksmanshipHunterEnabled",
		"exportButton_Hunter_Marksmanship_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 2, true, true, true, true, true, false)
		end)

	local tabDefinitions = {
		{ "focusBar", L["TabFocus"], oUi.tabWidth.small, MarksmanshipConstructFocusBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, MarksmanshipConstructHealthBarPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, MarksmanshipConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, MarksmanshipConstructBarVisibilityPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, MarksmanshipConstructThresholdPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, MarksmanshipConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) MarksmanshipConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, MarksmanshipConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_marksmanship = controls

	TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

--[[

Survival Options Menus

]]


local function SurvivalConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_survival
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.survival = SurvivalLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.survival = SurvivalLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SurvivalLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SurvivalLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function SurvivalConstructFocusBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, 3, 3, yCoord, {
		endOfKey = "takedown",
		activeColorKey = "takedown",
		endColorKey = "takedownEnd",
		checkboxLabel = L["HunterSurvivalCheckboxTakedown"],
		checkboxTooltip = L["HunterSurvivalCheckboxTakedownTooltip"],
		activeColorLabel = L["HunterSurvivalColorPickerTakedown"],
		endCheckboxLabel = L["HunterSurvivalCheckboxTakedownEnd"],
		endCheckboxTooltip = L["HunterSurvivalCheckboxTakedownEndTooltip"],
		endColorLabel = L["HunterSurvivalColorPickerTakedownEnd"],
	})

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, 3, 3, yCoord, {
		endOfKey = "takedown",
		sectionHeader = L["HunterSurvivalHeaderEndOfTakedownConfiguration"],
		gcdRadioLabel = L["HunterSurvivalCheckboxTakedownGcds"],
		gcdSliderLabel = L["HunterSurvivalTakedownGcds"],
		timeRadioLabel = L["HunterSurvivalCheckboxTakedownTime"],
		timeSliderLabel = L["HunterSurvivalTakedownTime"],
	})

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], SURVIVAL_MAX_FOCUS)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], 1, SURVIVAL_MAX_FOCUS)
end

local function SurvivalConstructTipOfTheSpearBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], L["ResourceTipOfTheSpear"])

	yCoord = yCoord - 60
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterSurvivalTipOfTheSpearColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerBase"], spec.colors.comboPoints.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerPenultimate"], spec.colors.comboPoints.penultimate.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerFinal"], spec.colors.comboPoints.final.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalCheckboxTipOfTheSpearSameColor"])
	f.tooltip = L["HunterSurvivalCheckboxTipOfTheSpearSameColorTooltip"]
	f:SetChecked(spec.colors.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sameColor = self:GetChecked()
	end)
end

local function SurvivalConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 3, 3, yCoord)
end

local function SurvivalConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 3, yCoord, true, L["ResourceTipOfTheSpear"])
end

local function SurvivalConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], "notFull", true, L["ResourceTipOfTheSpear"], true)
end

local function SurvivalConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_Survival_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Hunter_Survival_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 3, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.boomstickThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_boomstick", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.boomstickThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxBoomstick"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxBoomstickTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.boomstick.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.boomstick.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.hatchetTossThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_hatchetToss", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.hatchetTossThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxHatchetToss"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxHatchetTossTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.hatchetToss.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.hatchetToss.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raptorStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_raptorStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raptorStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxRaptorStrike"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxRaptorStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.raptorStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.raptorStrike.enabled = self:GetChecked()
	end)

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revivePet.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.scareBeast.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wingClip.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 3, yCoord)
end

local function SurvivalConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Survival_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 3, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 3, yCoord)
end

local function SurvivalConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 3
	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_Survival_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "totsThreshold1", spec, classId, specId, yCoord, L["HunterSurvivalAudioCheckboxTotsThreshold1"], L["HunterSurvivalAudioCheckboxTotsThreshold1Tooltip"])

	controls.totsThreshold1Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["HunterSurvivalTotsThresholdSliderTitle"], 0, 3, spec.audio["totsThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.totsThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["totsThreshold1"].configuration.thresholdValue = value
	end)
end

local function SurvivalConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Hunter_Survival_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 3, yCoord, cache)
end

local function SurvivalConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(3, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.hunter_survival or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}		
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.survivalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Survival")
	TRB.Options.OptionsFrame:RegisterSpecPanel("hunter", "hunter_survival", L["HunterSurvivalFull"], interfaceSettingsFrame.survivalDisplayPanel)
	
	parent = interfaceSettingsFrame.survivalDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["HunterSurvivalFull"],
		TRB.Data.settings.core.enabled.hunter, "survival",
		"TwintopResourceBar_Hunter_Survival_survivalHunterEnabled", "survivalHunterEnabled",
		"exportButton_Hunter_Survival_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 3, true, true, true, true, true, false)
		end)

	local tabDefinitions = {
		{ "focusBar", L["TabFocus"], oUi.tabWidth.small, SurvivalConstructFocusBarPanel },
		{ "tipOfTheSpearBar", L["TabTipOfTheSpear"], oUi.tabWidth.small, SurvivalConstructTipOfTheSpearBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, SurvivalConstructHealthBarPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, SurvivalConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, SurvivalConstructBarVisibilityPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, SurvivalConstructThresholdPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, SurvivalConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, SurvivalConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) SurvivalConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, SurvivalConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_survival = controls

	TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("hunter", L["Hunter"])
	BeastMasteryConstructOptionsPanel(specCache.hunter_beastMastery)
	MarksmanshipConstructOptionsPanel(specCache.hunter_marksmanship)
	SurvivalConstructOptionsPanel(specCache.hunter_survival)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Hunter.ConstructOptionsPanel = ConstructOptionsPanel
