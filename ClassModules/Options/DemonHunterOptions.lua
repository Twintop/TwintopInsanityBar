local _, TRB = ...

local L = TRB.Localization
local oUi = TRB.Data.constants.optionsUi

TRB.Options.DemonHunter = {}
TRB.Options.DemonHunter.Havoc = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_devourer = {}

local HAVOC_MAX_FURY = 170
local VENGEANCE_MAX_FURY = 120
local DEVOURER_MAX_FURY = 140

---Loads shared default bar text settings for Demon Hunter
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function SharedLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$metamorphosisTime>0}[#meta$metamorphosisTime]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

---Loads default bar text settings for Havoc
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HavocLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local sharedSettings = SharedLoadDefaultBarTextSettings(classic)
	for k,v in pairs(sharedSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.DemonHunter.HavocLoadDefaultBarTextSettings = HavocLoadDefaultBarTextSettings

---Loads default settings for Havoc
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function HavocLoadDefaultSettings(includeBarText, classic)
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
				abyssalGaze = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				annihilation = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				bladeDance = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				chaosNova = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(false),
				chaosStrike = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				deathSweep = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				eyeBeam = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				throwGlaive = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(false),
			},
			customThresholds = {}
		},
		maxResource = {
			value = HAVOC_MAX_FURY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			metamorphosis = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = HAVOC_MAX_FURY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFC942FD"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF660066"
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
					color = "FFA330C9"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFC942FD",
					color2 = "FFC942FD",
					gradientDirection = "disabled"
				},
				metamorphosis = {
					color = "FF67F100",
					color2 = "FF67F100",
					gradientDirection = "disabled",
					enabled = true
				},
				metamorphosisEnd = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
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
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			shared = {
				nodeOrder = {
					"metamorphosisEnd",
					"metamorphosis",
				},
				gradientOrder = {
					"borderOvercap",
				},
				indicatorColors = {
					metamorphosisEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = true, border = false, background = false },
						},
					},
					metamorphosis = {
						color = "FF67F100",
						color2 = "FF67F100",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = true, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							furyBar = { bar = false, border = true, background = false },
						},
					},
				},
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
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = HavocLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Vengeance
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function VengeanceLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local sharedSettings = SharedLoadDefaultBarTextSettings(classic)
	for k,v in pairs(sharedSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSettings = VengeanceLoadDefaultBarTextSettings

---Loads default settings for Vengeance
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function VengeanceLoadDefaultSettings(includeBarText, classic)
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
				soulCleave = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				chaosNova = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				-- Talents
				felDevastation = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				spiritBomb = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
			},
			customThresholds = {}
		},
		maxResource = {
			value = VENGEANCE_MAX_FURY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			metamorphosis = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = VENGEANCE_MAX_FURY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFC942FD"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF660066"
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
					color = "FFA330C9"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFC942FD",
					color2 = "FFC942FD",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF4C0065"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF9800D4",
					color2 = "FF9800D4",
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
				sameColor=false
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
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			shared = {
				nodeOrder = {
					"metamorphosisEnd",
					"metamorphosis",
				},
				gradientOrder = {
					"borderOvercap",
				},
				indicatorColors = {
					metamorphosisEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = true, border = false, background = false },
							soulFragmentsBar = { bar = false, border = false, background = false },
						},
					},
					metamorphosis = {
						color = "FF67F100",
						color2 = "FF67F100",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = true, border = false, background = false },
							soulFragmentsBar = { bar = false, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							furyBar = { bar = false, border = true, background = false },
							soulFragmentsBar = { bar = false, border = false, background = false },
						},
					},
				},
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
		settings.displayText.barText = VengeanceLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Devourer
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DevourerLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$soulFragments",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "ComboPoint_1",
				relativeToFrameName = L["SoulFragments"]
			}
		},
	}

	local sharedSettings = SharedLoadDefaultBarTextSettings(classic)
	for k,v in pairs(sharedSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSettings = DevourerLoadDefaultBarTextSettings

---Loads default settings for Devourer
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function DevourerLoadDefaultSettings(includeBarText, classic)
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
				voidRay = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
				collapsingStarThreshold = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true),
			},
			customThresholds = {}
		},
		maxResource = {
			value = DEVOURER_MAX_FURY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			metamorphosis = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = DEVOURER_MAX_FURY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFC942FD"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF660066"
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
					color = "FFA330C9"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFC942FD",
					color2 = "FFC942FD",
					gradientDirection = "disabled"
				},
				voidMetamorphosis = {
					color = "FF431863",
					color2 = "FF431863",
					gradientDirection = "disabled",
					enabled = true
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF660088"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF9800FF",
					color2 = "FF9800FF",
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
				sameColor=false,
				voidMetamorphosisReady = {
					color = "FF431863",
					color2 = "FF431863",
					gradientDirection = "disabled",
					enabled = true
				},
				collapsingStar = {
					color = "FF443FAD",
					color2 = "FF443FAD",
					gradientDirection = "disabled"
				},
				collapsingStarReady = {
					color = "FF431863",
					color2 = "FF431863",
					gradientDirection = "disabled",
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
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			shared = {
				nodeOrder = {
					"voidMetamorphosisReady",
					"collapsingStarReady",
					"voidMetamorphosis",
					"voidRayReady",
				},
				gradientOrder = {
					"borderOvercap",
				},
				indicatorColors = {
					voidMetamorphosisReady = {
						color = "FF431863",
						color2 = "FF431863",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = false, border = false, background = false },
							soulFragmentsBar = { bar = true, border = false, background = false },
						},
					},
					collapsingStarReady = {
						color = "FF431863",
						color2 = "FF431863",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = false, border = false, background = false },
							soulFragmentsBar = { bar = true, border = false, background = false },
						},
					},
					voidMetamorphosis = {
						color = "FF431863",
						color2 = "FF431863",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = true, border = false, background = false },
							soulFragmentsBar = { bar = false, border = false, background = false },
						},
					},
					voidRayReady = {
						color = "FF008B8B",
						color2 = "FF008B8B",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							furyBar = { bar = true, border = false, background = false },
							soulFragmentsBar = { bar = false, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							furyBar = { bar = false, border = true, background = false },
							soulFragmentsBar = { bar = false, border = false, background = false },
						},
					},
				},
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
		settings.displayText.barText = DevourerLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Demon Hunter
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.demonhunter.havoc = HavocLoadDefaultSettings(includeBarText, classic)
	settings.demonhunter.vengeance = VengeanceLoadDefaultSettings(includeBarText, classic)
	settings.demonhunter.devourer = DevourerLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.DemonHunter.LoadDefaultSettings = LoadDefaultSettings

--[[

Havoc Option Menus

]]

local function HavocConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DemonHunterHavocFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.demonhunter.havoc = HavocLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DemonHunterHavocFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.demonhunter.havoc = HavocLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DemonHunterHavocFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = HavocLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DemonHunterHavocFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = HavocLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function HavocConstructFuryBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 12, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], 1, HAVOC_MAX_FURY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = controls
end

local function HavocConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 12, 1, yCoord)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = controls
end

local function HavocConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 12, 1, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "metamorphosisEnd",  label = L["DemonHunterHavocColorPickerMetamorphosisEnd"],  tooltip = L["DemonHunterHavocIndicatorMetamorphosisEndTooltip"],  colorLabel = L["DemonHunterHavocIndicatorMetamorphosisEndColor"] },
			{ key = "metamorphosis",     label = L["DemonHunterHavocCheckboxMetamorphosis"],         tooltip = L["DemonHunterHavocIndicatorMetamorphosisTooltip"],     colorLabel = L["DemonHunterHavocIndicatorMetamorphosisColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap",     label = L["DemonHunterHavocCheckboxOvercap"],               tooltip = L["DemonHunterHavocIndicatorOvercapTooltip"],           colorLabel = L["DemonHunterHavocIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "furyBar", label = L["BarNameFuryBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_DemonHunter_Havoc",
		endOfConfigs = {
			{
				endOfKey = "metamorphosis",
				sectionHeader = L["DemonHunterHavocEndOfMetamorphosisConfigurationHeader"],
				gcdRadioLabel = L["DemonHunterHavocCheckboxMetamorphosisGcds"],
				gcdSliderLabel = L["DemonHunterHavocMetamorphosisGcds"],
				timeRadioLabel = L["DemonHunterHavocCheckboxMetamorphosisTime"],
				timeSliderLabel = L["DemonHunterHavocMetamorphosisTime"],
			},
		},
		overcapConfig = { primaryResourceString = L["ResourceFury"], primaryResourceMax = HAVOC_MAX_FURY },
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = controls
end

local function HavocConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 12, 1, yCoord, false)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = controls
end

local function HavocConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], "notEmpty", false, nil, true)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = controls
end

local function HavocConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5
	controls.colors.threshold = {}
	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 12, 1, yCoord, {
		barTargetLabels = { primary = L["ResourceFury"] },
		labels = {
			bladeDance = L["DemonHunterHavocThresholdCheckboxBladeDance"],
			deathSweep = L["DemonHunterHavocThresholdCheckboxDeathSweep"],
			chaosStrike = L["DemonHunterHavocThresholdCheckboxChaosStrike"],
			annihilation = L["DemonHunterHavocThresholdCheckboxAnnihilation"],
			eyeBeam = L["DemonHunterHavocThresholdCheckboxEyeBeam"],
			abyssalGaze = L["DemonHunterHavocThresholdCheckboxAbyssalGaze"],
			chaosNova = L["DemonHunterHavocThresholdCheckboxChaosNova"],
			throwGlaive = L["DemonHunterHavocThresholdCheckboxThrowGlaive"],
		},
		tooltips = {
			bladeDance = L["DemonHunterHavocThresholdCheckboxBladeDanceTooltip"],
			deathSweep = L["DemonHunterHavocThresholdCheckboxDeathSweepTooltip"],
			chaosNova = L["DemonHunterHavocThresholdCheckboxChaosNovaTooltip"],
			chaosStrike = L["DemonHunterHavocThresholdCheckboxChaosStrikeTooltip"],
			annihilation = L["DemonHunterHavocThresholdCheckboxAnnihilationTooltip"],
			eyeBeam = L["DemonHunterHavocThresholdCheckboxEyeBeamTooltip"],
			abyssalGaze = L["DemonHunterHavocThresholdCheckboxAbyssalGazeTooltip"],
			throwGlaive = L["DemonHunterHavocThresholdCheckboxThrowGlaiveTooltip"],
		},
	})
end

local function HavocConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5


	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 1, yCoord)
end

local function HavocConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 12, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DemonHunterHavocTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 12, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterHavocTextColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterHavocColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DemonHunterHavocCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DemonHunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 12, 1, yCoord)
end

local function HavocConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 12
	local specId = 1
	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function HavocConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 12, 1, yCoord, cache)
end

local function HavocConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(12, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.demonhunter_havoc or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.havocDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Havoc")
	TRB.Options.OptionsFrame:RegisterSpecPanel("demonhunter", "demonhunter_havoc", L["DemonHunterHavocFull"], interfaceSettingsFrame.havocDisplayPanel)
	
	parent = interfaceSettingsFrame.havocDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["DemonHunterHavocFull"],
		TRB.Data.settings.core.enabled.demonhunter, "havoc",
		"TwintopResourceBar_DemonHunter_Havoc_havocDemonHunterEnabled", "havocDemonHunterEnabled",
		"demonhunter", "havoc")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_havoc = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "furyBar", label = L["TabFury"], width = oUi.tabWidth.small, constructor = HavocConstructFuryBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = HavocConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = HavocConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = HavocConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = HavocConstructBarVisibilityPanel },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = HavocConstructThresholdSettingsPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = HavocConstructThresholdListPanel, isManualScrollFrame = true },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = HavocConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) HavocConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = HavocConstructResetDefaultsPanel },
	}, yCoord)
end

--[[

Vengeance Option Menus

]]

local function VengeanceConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DemonHunterVengeanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.demonhunter.vengeance = VengeanceLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DemonHunterVengeanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.demonhunter.vengeance = VengeanceLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DemonHunterVengeanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = VengeanceLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DemonHunterVengeanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = VengeanceLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function VengeanceConstructFuryBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 12, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], 1, VENGEANCE_MAX_FURY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls
end

local function VengeanceConstructSoulFragmentsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], L["ResourceSoulFragments"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DemonHunterVengeanceHeaderSoulFragmentColors"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceSoulFragments"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["DemonHunterVengeanceColorPickerSoulFragmentPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["DemonHunterVengeanceColorPickerSoulFragmentFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerSoulFragmentBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerUnfilledSoulFragmentBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls
end

local function VengeanceConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 12, 2, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "metamorphosisEnd",  label = L["DemonHunterVengeanceColorPickerMetamorphosisEnd"],  tooltip = L["DemonHunterVengeanceIndicatorMetamorphosisEndTooltip"],  colorLabel = L["DemonHunterVengeanceIndicatorMetamorphosisEndColor"] },
			{ key = "metamorphosis",     label = L["DemonHunterVengeanceCheckboxMetamorphosis"],         tooltip = L["DemonHunterVengeanceIndicatorMetamorphosisTooltip"],     colorLabel = L["DemonHunterVengeanceIndicatorMetamorphosisColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap",     label = L["DemonHunterVengeanceCheckboxOvercap"],               tooltip = L["DemonHunterVengeanceIndicatorOvercapTooltip"],           colorLabel = L["DemonHunterVengeanceIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "furyBar", label = L["BarNameFuryBar"] },
			{ key = "soulFragmentsBar", label = L["BarNameSoulFragmentsBar"] },
		},
		gradientExcludedElements = {
			soulFragmentsBar = { bar = true },
		},
		ddNamePrefix = "TwintopResourceBar_DemonHunter_Vengeance",
		endOfConfigs = {
			{
				endOfKey = "metamorphosis",
				sectionHeader = L["DemonHunterVengeanceEndOfMetamorphosisConfigurationHeader"],
				gcdRadioLabel = L["DemonHunterVengeanceCheckboxMetamorphosisGcds"],
				gcdSliderLabel = L["DemonHunterVengeanceMetamorphosisGcds"],
				timeRadioLabel = L["DemonHunterVengeanceCheckboxMetamorphosisTime"],
				timeSliderLabel = L["DemonHunterVengeanceMetamorphosisTime"],
			},
		},
		overcapConfig = { primaryResourceString = L["ResourceFury"], primaryResourceMax = VENGEANCE_MAX_FURY },
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls
end

local function VengeanceConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 12, 2, yCoord)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls
end

local function VengeanceConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 12, 2, yCoord, true, L["ResourceSoulFragments"])

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls
end

local function VengeanceConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], "notEmpty", true, L["ResourceSoulFragments"], true)

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls
end

local function VengeanceConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5
	controls.colors.threshold = {}
	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 12, 2, yCoord, {
		barTargetLabels = { primary = L["ResourceFury"] },
		labels = {
			soulCleave = L["DemonHunterVengeanceThresholdCheckboxSoulCleave"],
			chaosNova = L["DemonHunterVengeanceThresholdCheckboxChaosNova"],
			felDevastation = L["DemonHunterVengeanceThresholdCheckboxFelDevastation"],
			spiritBomb = L["DemonHunterVengeanceThresholdCheckboxSpiritBomb"],
		},
		tooltips = {
			chaosNova = L["DemonHunterVengeanceThresholdCheckboxChaosNovaTooltip"],
			felDevastation = L["DemonHunterVengeanceThresholdCheckboxFelDevastationTooltip"],
			soulCleave = L["DemonHunterVengeanceThresholdCheckboxSoulCleaveTooltip"],
			spiritBomb = L["DemonHunterVengeanceThresholdCheckboxSpiritBombTooltip"],
		},
	})
end

local function VengeanceConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5


	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 2, yCoord)
end

local function VengeanceConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 12, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DemonHunterVengeanceTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 12, 2, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterVengeanceTextColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DemonHunterVengeanceCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DemonHunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 12, 2, yCoord)
end

local function VengeanceConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 12
	local specId = 2
	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function VengeanceConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 12, 2, yCoord, cache)
end

local function VengeanceConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(12, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.demonhunter_vengeance or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.vengeanceDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Vengeance")
	TRB.Options.OptionsFrame:RegisterSpecPanel("demonhunter", "demonhunter_vengeance", L["DemonHunterVengeanceFull"], interfaceSettingsFrame.vengeanceDisplayPanel)
	
	parent = interfaceSettingsFrame.vengeanceDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["DemonHunterVengeanceFull"],
		TRB.Data.settings.core.enabled.demonhunter, "vengeance",
		"TwintopResourceBar_DemonHunter_Vengeance_vengeanceDemonHunterEnabled", "vengeanceDemonHunterEnabled",
		"demonhunter", "vengeance")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_vengeance = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "furyBar", label = L["TabFury"], width = oUi.tabWidth.small, constructor = VengeanceConstructFuryBarPanel },
		{ key = "soulFragmentsBar", label = L["TabSoulFragments"], width = oUi.tabWidth.small, constructor = VengeanceConstructSoulFragmentsBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = VengeanceConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = VengeanceConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = VengeanceConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = VengeanceConstructBarVisibilityPanel },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = VengeanceConstructThresholdSettingsPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = VengeanceConstructThresholdListPanel, isManualScrollFrame = true },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = VengeanceConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) VengeanceConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = VengeanceConstructResetDefaultsPanel },
	}, yCoord)
end

--[[

Devourer Option Menus

]]

local function DevourerConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_devourer
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Devourer_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DemonHunterDevourerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.demonhunter.devourer = DevourerLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Devourer_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DemonHunterDevourerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DevourerLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 150, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Devourer_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Devourer_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40
end

local function DevourerConstructFuryBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 12, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], 1, DEVOURER_MAX_FURY)
end

local function DevourerConstructSoulFragmentsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], L["ResourceSoulFragments"], false)

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DemonHunterDevourerHeaderSoulFragmentColors"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceSoulFragments"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.collapsingStar = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceCollapsingStar"], spec.colors.comboPoints.collapsingStar, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.collapsingStar
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "collapsingStar")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.collapsingStar, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerSoulFragmentBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerUnfilledSoulFragmentBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function DevourerConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 12, 3, yCoord)
end

local function DevourerConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 12, 3, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "voidMetamorphosisReady", label = L["DemonHunterDevourerCheckboxVoidMetamorphosisReady"], tooltip = L["DemonHunterDevourerIndicatorVoidMetamorphosisReadyTooltip"], colorLabel = L["DemonHunterDevourerIndicatorVoidMetamorphosisReadyColor"] },
			{ key = "collapsingStarReady",    label = L["DemonHunterDevourerCheckboxCollapsingStarReady"],    tooltip = L["DemonHunterDevourerIndicatorCollapsingStarReadyTooltip"], colorLabel = L["DemonHunterDevourerIndicatorCollapsingStarReadyColor"] },
			{ key = "voidMetamorphosis",      label = L["DemonHunterDevourerCheckboxVoidMetamorphosis"],      tooltip = L["DemonHunterDevourerIndicatorVoidMetamorphosisTooltip"],  colorLabel = L["DemonHunterDevourerIndicatorVoidMetamorphosisColor"] },
			{ key = "voidRayReady",           label = L["DemonHunterDevourerCheckboxVoidRayReady"],             tooltip = L["DemonHunterDevourerIndicatorVoidRayReadyTooltip"],       colorLabel = L["DemonHunterDevourerIndicatorVoidRayReadyColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["DemonHunterDevourerCheckboxOvercap"], tooltip = L["DemonHunterDevourerIndicatorOvercapTooltip"], colorLabel = L["DemonHunterDevourerIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "furyBar", label = L["BarNameFuryBar"] },
			{ key = "soulFragmentsBar", label = L["BarNameSoulFragmentsBar"] },
		},
		gradientExcludedElements = {
			soulFragmentsBar = { bar = true },
		},
		ddNamePrefix = "TwintopResourceBar_DemonHunter_Devourer",
		overcapConfig = { primaryResourceString = L["ResourceFury"], primaryResourceMax = DEVOURER_MAX_FURY },
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_devourer = controls
end

local function DevourerConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 12, 3, yCoord, true, L["ResourceSoulFragments"])
end

local function DevourerConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], "notEmpty", true, L["ResourceSoulFragments"], true)
end

local function DevourerConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5
	controls.colors.threshold = {}
	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 12, 3, yCoord, {
		barTargetLabels = {
			primary = L["ResourceFury"],
			secondary = L["ResourceCollapsingStar"],
		},
		labels = {
			voidRay = L["DemonHunterDevourerThresholdCheckboxVoidRay"],
			collapsingStarThreshold = L["DemonHunterDevourerThresholdCheckboxCollapsingStar"],
		},
		tooltips = {
			collapsingStarThreshold = L["DemonHunterDevourerThresholdCheckboxCollapsingStarTooltip"],
			voidRay = L["DemonHunterDevourerThresholdCheckboxVoidRayTooltip"],
		},
	})
end

local function DevourerConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5


	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], true, true, true, false, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 3, yCoord)
end

local function DevourerConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 12, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DemonHunterDevourerTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 12, 3, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterDevourerTextColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DemonHunterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DemonHunterDevourerCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DemonHunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 12, 3, yCoord)
end

local function DevourerConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 12
	local specId = 1
	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function DevourerConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 12, 3, yCoord, cache)
end

local function DevourerConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(12, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.demonhunter_devourer or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.devourerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Devourer")
	TRB.Options.OptionsFrame:RegisterSpecPanel("demonhunter", "demonhunter_devourer", L["DemonHunterDevourerFull"], interfaceSettingsFrame.devourerDisplayPanel)
	
	parent = interfaceSettingsFrame.devourerDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["DemonHunterDevourerFull"],
		TRB.Data.settings.core.enabled.demonhunter, "devourer",
		"TwintopResourceBar_DemonHunter_Devourer_devourerDemonHunterEnabled", "devourerDemonHunterEnabled",
		"demonhunter", "devourer")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.demonhunter_devourer = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "furyBar", label = L["TabFury"], width = oUi.tabWidth.small, constructor = DevourerConstructFuryBarPanel },
		{ key = "soulFragmentsBar", label = L["TabSoulFragmentsCollapsingStar"], width = oUi.tabWidth.xlarge, constructor = DevourerConstructSoulFragmentsBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = DevourerConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = DevourerConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = DevourerConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = DevourerConstructBarVisibilityPanel },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = DevourerConstructThresholdSettingsPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = DevourerConstructThresholdListPanel, isManualScrollFrame = true },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = DevourerConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) DevourerConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = DevourerConstructResetDefaultsPanel },
	}, yCoord)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("demonhunter", L["DemonHunter"])
	HavocConstructOptionsPanel(specCache.demonhunter_havoc)
	VengeanceConstructOptionsPanel(specCache.demonhunter_vengeance)
	DevourerConstructOptionsPanel(specCache.demonhunter_devourer)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.DemonHunter.ConstructOptionsPanel = ConstructOptionsPanel
