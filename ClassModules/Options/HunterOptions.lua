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

local BEAST_MASTERY_MAX_FOCUS = TRB.Data.maxResource.hunter.beastMastery.focus
local MARKSMANSHIP_MAX_FOCUS = TRB.Data.maxResource.hunter.marksmanship.focus
local SURVIVAL_MAX_FOCUS = TRB.Data.maxResource.hunter.survival.focus

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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			},
			customThresholds = {}
		},
		maxResource = {
			value = BEAST_MASTERY_MAX_FOCUS,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
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
					color = "FFFF8040",
					color2 = "FFFF8040",
					gradientDirection = "disabled"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			shared = {
				nodeOrder = { "bestialWrathEnd", "beastCleave", "bestialWrath" },
				gradientOrder = { "borderOvercap" },
				indicatorColors = {
					bestialWrath = {
						color = "FF005500",
						color2 = "FF005500",
						gradientDirection = "disabled",
						enabled = true,
						targets = { focusBar = { bar = true, border = false, background = false } }
					},
					bestialWrathEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = { focusBar = { bar = true, border = false, background = false } }
					},
					beastCleave = {
						color = "FF77FF77",
						color2 = "FF77FF77",
						gradientDirection = "disabled",
						enabled = true,
						targets = { focusBar = { bar = false, border = true, background = false } }
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = { focusBar = { bar = false, border = true, background = false } }
					},
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
				explosiveShot = {
					enabled = true,
				},
			},
			customThresholds = {}
		},
		maxResource = {
			value = MARKSMANSHIP_MAX_FOCUS,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
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
					color = "FFFF8040",
					color2 = "FFFF8040",
					gradientDirection = "disabled"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
				spending = {
					color = "FFAAAAAA",
					color2 = "FFAAAAAA",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			shared = {
				nodeOrder = { "trueshotEnd", "trueshot" },
				gradientOrder = { "borderOvercap" },
				indicatorColors = {
					trueshot = {
						color = "FF00B60E",
						color2 = "FF00B60E",
						gradientDirection = "disabled",
						enabled = true,
						targets = { focusBar = { bar = true, border = false, background = false } }
					},
					trueshotEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = { focusBar = { bar = true, border = false, background = false } }
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = { focusBar = { bar = false, border = true, background = false } }
					},
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
				flamefangPitch = {
					enabled = true,
				},
				hatchetToss = {
					enabled = true,
				},
				raptorStrike = {
					enabled = true,
				},
				raptorSwipe = {
					enabled = true,
				},
			},
			customThresholds = {}
		},
		maxResource = {
			value = SURVIVAL_MAX_FOCUS,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
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
					color = "FFFF8040",
					color2 = "FFFF8040",
					gradientDirection = "disabled"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			shared = {
				nodeOrder = { "takedownEnd", "takedown" },
				gradientOrder = { "borderOvercap" },
				indicatorColors = {
					takedown = {
						color = "FF005500",
						color2 = "FF005500",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							focusBar = { bar = true, border = false, background = false },
							tipOfTheSpearBar = { bar = false, border = false, background = false },
						}
					},
					takedownEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							focusBar = { bar = true, border = false, background = false },
							tipOfTheSpearBar = { bar = false, border = false, background = false },
						}
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							focusBar = { bar = false, border = true, background = false },
							tipOfTheSpearBar = { bar = false, border = false, background = false },
						}
					},
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
				base = {
					color = "FFFF8040",
					color2 = "FFFF8040",
					gradientDirection = "disabled"
				},
				penultimate = {
					color = "FFFF9900",
					color2 = "FFFF9900",
					gradientDirection = "disabled"
				},
				final = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.beastMasteryDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.beastMasteryDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], 1, BEAST_MASTERY_MAX_FOCUS)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Textures:GenerateFlashOptions(parent, controls, spec, 3, 1, yCoord, L["HunterBeastMasteryBestialWrath"], L["HunterBeastMasteryBestialWrath"])
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 3, 1, yCoord)
end

local function BeastMasteryConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 1
	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "bestialWrathEnd", label = L["HunterBeastMasteryCheckboxBestialWrathEnd"], tooltip = L["HunterBeastMasteryIndicatorBestialWrathEndTooltip"], colorLabel = L["HunterBeastMasteryIndicatorBestialWrathEndColor"] },
			{ key = "bestialWrath", label = L["HunterBeastMasteryCheckboxBestialWrath"], tooltip = L["HunterBeastMasteryIndicatorBestialWrathTooltip"], colorLabel = L["HunterBeastMasteryIndicatorBestialWrathColor"] },
			{ key = "beastCleave", label = L["HunterBeastMasteryCheckboxBeastCleave"], tooltip = L["HunterBeastMasteryIndicatorBeastCleaveTooltip"], colorLabel = L["HunterBeastMasteryIndicatorBeastCleaveColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["HunterIndicatorBorderOvercap"], tooltip = L["HunterIndicatorOvercapTooltip"], colorLabel = L["HunterIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "focusBar", label = L["BarNameFocusBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Hunter_BeastMastery",
		endOfConfigs = {
			{
				endOfKey = "bestialWrath",
				sectionHeader = L["HunterBeastMasteryHeaderEndOfBestialWrathConfiguration"],
				gcdRadioLabel = L["HunterBeastMasteryCheckboxBestialWrathGcds"],
				gcdSliderLabel = L["HunterBeastMasteryBestialWrathGcds"],
				timeRadioLabel = L["HunterBeastMasteryCheckboxBestialWrathTime"],
				timeSliderLabel = L["HunterBeastMasteryBestialWrathTime"],
			},
		},
		overcapConfig = {
			primaryResourceString = L["ResourceFocus"],
			primaryResourceMax = BEAST_MASTERY_MAX_FOCUS,
		},
	})

	yCoord = yCoord - 40
end

local function BeastMasteryConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 3, 1, yCoord, false)
end

local function BeastMasteryConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], "notFull", false, nil, true)
end

local function BeastMasteryConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 3, 1, yCoord, {
		barTargetLabels = {
			primary = L["ResourceFocus"],
		},
		labels = {
			revivePet = L["HunterThresholdCheckboxRevivePet"],
			wingClip = L["HunterThresholdCheckboxWingClip"],
			scareBeast = L["HunterThresholdCheckboxScareBeast"],
			killCommand = L["HunterBeastMasteryThresholdCheckboxKillCommand"],
			cobraShot = L["HunterBeastMasteryThresholdCheckboxCobraShot"],
			blackArrow = L["HunterBeastMasteryThresholdCheckboxBlackArrow"],
			wildThrash = L["HunterBeastMasteryThresholdCheckboxWildThrash"],
			wailingArrow = L["HunterBeastMasteryThresholdCheckboxWailingArrow"],
			direBeastHawk = L["HunterBeastMasteryThresholdCheckboxDireBeastHawk"],
		},
		tooltips = {
			blackArrow = L["HunterBeastMasteryThresholdCheckboxBlackArrowTooltip"],
			cobraShot = L["HunterBeastMasteryThresholdCheckboxCobraShotTooltip"],
			killCommand = L["HunterBeastMasteryThresholdCheckboxKillCommandTooltip"],
			wailingArrow = L["HunterBeastMasteryThresholdCheckboxWailingArrowTooltip"],
			wildThrash = L["HunterBeastMasteryThresholdCheckboxWildThrashTooltip"],
			direBeastHawk = L["HunterBeastMasteryThresholdCheckboxDireBeastHawkTooltip"],
			revivePet = L["HunterThresholdCheckboxRevivePetTooltip"],
			scareBeast = L["HunterThresholdCheckboxScareBeastTooltip"],
			wingClip = L["HunterThresholdCheckboxWingClipTooltip"],
		},
	})
end

local function BeastMasteryConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5


	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 1, yCoord)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 3, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 1, yCoord)
end

local function BeastMasteryConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_beastMastery
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 3, 1, yCoord, cache)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["HunterBeastMasteryFull"],
		TRB.Data.settings.core.enabled.hunter, "beastMastery",
		"TwintopResourceBar_Hunter_BeastMastery_beastMasteryHunterEnabled", "beastMasteryHunterEnabled",
		"hunter", "beastMastery")

	local tabDefinitions = {
		{ "focusBar", L["TabFocus"], oUi.tabWidth.small, BeastMasteryConstructFocusBarPanel, visibilityKey = "primary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, BeastMasteryConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, BeastMasteryConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, BeastMasteryConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, BeastMasteryConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, BeastMasteryConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, BeastMasteryConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("hunter", "beastMastery", controls),
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("hunter", "beastMastery", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, BeastMasteryConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) BeastMasteryConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, BeastMasteryConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_beastMastery = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.marksmanshipDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.marksmanshipDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], nil, true)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], 1, MARKSMANSHIP_MAX_FOCUS)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 3, 2, yCoord)
end

local function MarksmanshipConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 2
	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "trueshotEnd", label = L["HunterMarksmanshipCheckboxEndOfTrueshot"], tooltip = L["HunterMarksmanshipIndicatorTrueshotEndTooltip"], colorLabel = L["HunterMarksmanshipIndicatorTrueshotEndColor"] },
			{ key = "trueshot", label = L["HunterMarksmanshipCheckboxTrueshot"], tooltip = L["HunterMarksmanshipIndicatorTrueshotTooltip"], colorLabel = L["HunterMarksmanshipIndicatorTrueshotColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["HunterIndicatorBorderOvercap"], tooltip = L["HunterIndicatorOvercapTooltip"], colorLabel = L["HunterIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "focusBar", label = L["BarNameFocusBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Hunter_Marksmanship",
		endOfConfigs = {
			{
				endOfKey = "trueshot",
				sectionHeader = L["HunterMarksmanshipHeaderEndOfTrueshotConfiguration"],
				gcdRadioLabel = L["HunterMarksmanshipCheckboxTrueshotGcds"],
				gcdSliderLabel = L["HunterMarksmanshipTrueshotGcds"],
				timeRadioLabel = L["HunterMarksmanshipCheckboxTrueshotTime"],
				timeSliderLabel = L["HunterMarksmanshipTrueshotTime"],
			},
		},
		overcapConfig = {
			primaryResourceString = L["ResourceFocus"],
			primaryResourceMax = MARKSMANSHIP_MAX_FOCUS,
		},
	})

	yCoord = yCoord - 40
end

local function MarksmanshipConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 3, 2, yCoord, false)
end

local function MarksmanshipConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], "notFull", false, nil, true)
end

local function MarksmanshipConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 3, 2, yCoord, {
		labels = {
			arcaneShot = L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShot"],
			revivePet = L["HunterThresholdCheckboxRevivePet"],
			wingClip = L["HunterThresholdCheckboxWingClip"],
			scareBeast = L["HunterThresholdCheckboxScareBeast"],
			killShot = L["HunterMarksmanshipThresholdCheckboxKillShot"],
			aimedShot = L["HunterMarksmanshipThresholdCheckboxAimedShot"],
			multiShot = L["HunterMarksmanshipThresholdCheckboxMultiShot"],
			blackArrow = L["HunterMarksmanshipThresholdCheckboxBlackArrow"],
			wailingArrow = L["HunterMarksmanshipThresholdCheckboxWailingArrow"],
			explosiveShot = L["HunterMarksmanshipThresholdCheckboxExplosiveShot"],
		},
		barTargetLabels = {
			primary = L["ResourceFocus"],
		},
		tooltips = {
			aimedShot = L["HunterMarksmanshipThresholdCheckboxAimedShotTooltip"],
			arcaneShot = L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShotTooltip"],
			blackArrow = L["HunterMarksmanshipThresholdCheckboxBlackArrowTooltip"],
			explosiveShot = L["HunterMarksmanshipThresholdCheckboxExplosiveShotTooltip"],
			killShot = L["HunterMarksmanshipThresholdCheckboxKillShotTooltip"],
			multiShot = L["HunterMarksmanshipThresholdCheckboxMultiShotTooltip"],
			wailingArrow = L["HunterMarksmanshipThresholdCheckboxWailingArrowTooltip"],
			revivePet = L["HunterThresholdCheckboxRevivePetTooltip"],
			scareBeast = L["HunterThresholdCheckboxScareBeastTooltip"],
			wingClip = L["HunterThresholdCheckboxWingClipTooltip"],
		},
	})
end

local function MarksmanshipConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5


	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 2, yCoord)
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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 3, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerTextCastingBuilder"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.spending = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 2, yCoord)
end

local function MarksmanshipConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_marksmanship
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 3, 2, yCoord, cache)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["HunterMarksmanshipFull"],
		TRB.Data.settings.core.enabled.hunter, "marksmanship",
		"TwintopResourceBar_Hunter_Marksmanship_marksmanshipHunterEnabled", "marksmanshipHunterEnabled",
		"hunter", "marksmanship")

	local tabDefinitions = {
		{ "focusBar", L["TabFocus"], oUi.tabWidth.small, MarksmanshipConstructFocusBarPanel, visibilityKey = "primary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, MarksmanshipConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, MarksmanshipConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, MarksmanshipConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, MarksmanshipConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, MarksmanshipConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, MarksmanshipConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("hunter", "marksmanship", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, MarksmanshipConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) MarksmanshipConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, MarksmanshipConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_marksmanship = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.survivalDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.survivalDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], 1, SURVIVAL_MAX_FOCUS)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], L["ResourceTipOfTheSpear"])

	yCoord = yCoord - 60
	controls.barColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HunterSurvivalTipOfTheSpearColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerBase"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalCheckboxTipOfTheSpearSameColor"])
	f.tooltip = L["HunterSurvivalCheckboxTipOfTheSpearSameColorTooltip"]
	f:SetChecked(spec.colors.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterSurvivalTipOfTheSpearColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Hunter_Survival_ComboPoints", "endCapComboPoints", L["EndCap"], 3, 3)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 3, 3, yCoord)
end

local function SurvivalConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 3
	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "takedownEnd", label = L["HunterSurvivalCheckboxTakedownEnd"], tooltip = L["HunterSurvivalIndicatorTakedownEndTooltip"], colorLabel = L["HunterSurvivalIndicatorTakedownEndColor"] },
			{ key = "takedown", label = L["HunterSurvivalCheckboxTakedown"], tooltip = L["HunterSurvivalIndicatorTakedownTooltip"], colorLabel = L["HunterSurvivalIndicatorTakedownColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["HunterIndicatorBorderOvercap"], tooltip = L["HunterIndicatorOvercapTooltip"], colorLabel = L["HunterIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "focusBar", label = L["BarNameFocusBar"] },
			{ key = "tipOfTheSpearBar", label = L["ResourceTipOfTheSpear"] },
		},
		ddNamePrefix = "TwintopResourceBar_Hunter_Survival",
		endOfConfigs = {
			{
				endOfKey = "takedown",
				sectionHeader = L["HunterSurvivalHeaderEndOfTakedownConfiguration"],
				gcdRadioLabel = L["HunterSurvivalCheckboxTakedownGcds"],
				gcdSliderLabel = L["HunterSurvivalTakedownGcds"],
				timeRadioLabel = L["HunterSurvivalCheckboxTakedownTime"],
				timeSliderLabel = L["HunterSurvivalTakedownTime"],
			},
		},
		overcapConfig = {
			primaryResourceString = L["ResourceFocus"],
			primaryResourceMax = SURVIVAL_MAX_FOCUS,
		},
	})

	yCoord = yCoord - 40
end

local function SurvivalConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 3, 3, yCoord, true, L["ResourceTipOfTheSpear"])
end

local function SurvivalConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], "notFull", true, L["ResourceTipOfTheSpear"], true)
end

local function SurvivalConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 3, 3, yCoord, {
		barTargetLabels = {
			primary = L["ResourceFocus"],
		},
		labels = {
			revivePet = L["HunterThresholdCheckboxRevivePet"],
			wingClip = L["HunterThresholdCheckboxWingClip"],
			scareBeast = L["HunterThresholdCheckboxScareBeast"],
			boomstick = L["HunterSurvivalThresholdCheckboxBoomstick"],
			hatchetToss = L["HunterSurvivalThresholdCheckboxHatchetToss"],
			raptorStrike = L["HunterSurvivalThresholdCheckboxRaptorStrike"],
		},
		tooltips = {
			boomstick = L["HunterSurvivalThresholdCheckboxBoomstickTooltip"],
			hatchetToss = L["HunterSurvivalThresholdCheckboxHatchetTossTooltip"],
			raptorStrike = L["HunterSurvivalThresholdCheckboxRaptorStrikeTooltip"],
			revivePet = L["HunterThresholdCheckboxRevivePetTooltip"],
			scareBeast = L["HunterThresholdCheckboxScareBeastTooltip"],
			wingClip = L["HunterThresholdCheckboxWingClipTooltip"],
		},
	})
end

local function SurvivalConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5


	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 3, yCoord)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 3, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 3, yCoord)
end

local function SurvivalConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.hunter_survival
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 3, 3, yCoord, cache)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["HunterSurvivalFull"],
		TRB.Data.settings.core.enabled.hunter, "survival",
		"TwintopResourceBar_Hunter_Survival_survivalHunterEnabled", "survivalHunterEnabled",
		"hunter", "survival")

	local tabDefinitions = {
		{ "focusBar", L["TabFocus"], oUi.tabWidth.small, SurvivalConstructFocusBarPanel, visibilityKey = "primary" },
		{ "tipOfTheSpearBar", L["TabTipOfTheSpear"], oUi.tabWidth.small, SurvivalConstructTipOfTheSpearBarPanel, visibilityKey = "secondary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, SurvivalConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, SurvivalConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, SurvivalConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, SurvivalConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, SurvivalConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, SurvivalConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("hunter", "survival", controls),
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("hunter", "survival", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, SurvivalConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) SurvivalConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, SurvivalConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.hunter_survival = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
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
