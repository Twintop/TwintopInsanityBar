local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Monk = {}
TRB.Options.Monk.Brewmaster = {}
TRB.Options.Monk.Mistweaver = {}
TRB.Options.Monk.Windwalker = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.monk_brewmaster = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.monk_mistweaver = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.monk_windwalker = {}

local BREWMASTER_MAX_ENERGY = TRB.Data.maxResource.monk.brewmaster.energy
local WINDWALKER_MAX_ENERGY = TRB.Data.maxResource.monk.windwalker.energy



-- Brewmaster
---Loads default bar text settings for Brewmaster
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function BrewmasterLoadDefaultBarTextSettings(classic)
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
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$staggerPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "ComboPoint_1",
				relativeToFrameName = L["Stagger"]
			}
		},
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
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$stagger",
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
				relativeToFrame = "ComboPoint_1",
				relativeToFrameName = L["Stagger"]
			}
		},
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("niuzaoTime", "niuzao", classic, "CENTER", "RIGHT"))

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Monk.BrewmasterLoadDefaultBarTextSettings = BrewmasterLoadDefaultBarTextSettings

---Loads default settings for Brewmaster
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function BrewmasterLoadDefaultSettings(includeBarText, classic)
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
				cracklingJadeLightning = {
					enabled = false,
				},
				expelHarm = {
					enabled = true,
				},
				spinningCraneKick = {
					enabled = true,
				},
				tigerPalm = {
					enabled = true,
				},
				vivify = {
					enabled = false,
				},
				detox = {
					enabled = false,
				},
				disable = {
					enabled = false,
				},
				paralysis = {
					enabled = false,
				},
				soothingMist = {
					enabled = false,
				},
				kegSmash = {
					enabled = true,
				}
			},
			customThresholds = {},
			stagger = {
				medium = {
					enabled = true,
				},
				heavy = {
					enabled = true,
				},
				extreme = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = BREWMASTER_MAX_ENERGY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			stagger = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			invokeNiuzao = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = BREWMASTER_MAX_ENERGY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			stagger = TRB.Functions.Table:Merge(
				TRB.Functions.Settings:DefaultStaggerBarDimensions(classic),
				{ maxScale = 1.0 }
			),
		},
		colors = {
			text = {
				current = {
					color = "FFFFFF00"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFD59900"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
				stagger = { -- How $stagger/$staggerPercent text is colored ("bar"|"custom"|"none")
					mode = "bar",
					color = "FFFFFFFF"
				},
			},
			bar = {
				border = {
					color = "FFFFD300"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFFFF00",
					color2 = "FFFFFF00",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			bars = {
				stagger = {
					border = { color = "FF00FF98" },
					background = { color = "66000000" },
					endCap = TRB.Functions.Settings:DefaultEndCapColorEntry(),
					type = "step",
					low = {
						color = "FF85FF85",
						threshold = 0.0
					},
					medium = {
						color = "FFFFFAB8",
						threshold = 0.30
					},
					heavy = {
						color = "FFFF6B6B",
						threshold = 0.60
					},
					extreme = {
						color = "FFBB1111",
						threshold = 1.0
					}
				}
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = {
					"invokeNiuzaoEnd",
					"invokeNiuzao"
				},
				gradientOrder = {
					"borderOvercap"
				},
				indicatorColors = {
					invokeNiuzao = {
						color = "FF8B6914",
						color2 = "FF8B6914",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							energyBar = { bar = true, border = false, background = false }
						}
					},
					invokeNiuzaoEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							energyBar = { bar = true, border = false, background = false }
						}
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							energyBar = { bar = false, border = true, background = false }
						}
					}
				}
			},
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
		textures = TRB.Functions.Settings:DefaultTextures(false, nil, {
			TRB.Classes.BarTypeRegistry:GetInstance():Get("stagger"),
		}),
	}

	if includeBarText then
		settings.displayText.barText = BrewmasterLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Mistweaver
---Loads default bar text settings for Mistweaver
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function MistweaverLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Monk.MistweaverLoadDefaultBarTextSettings = MistweaverLoadDefaultBarTextSettings

---Loads default settings for Mistweaver
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function MistweaverLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder = true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {},
			customThresholds = {}
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF4D4DFF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				}
			},
			bar = {
				border = {
					color = "FF000099"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF0000FF",
					color2 = "FF0000FF",
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
					"vivaciousVivification",
					"heartOfTheJadeSerpent",
					"heartOfTheJadeSerpentReady"
				},
				gradientOrder = {},
				indicatorColors = {
					vivaciousVivification = {
						color = "FF00FFBB",
						color2 = "FF00FFBB",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					},
					heartOfTheJadeSerpentReady = {
						color = "FF008461",
						color2 = "FF008461",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					},
					heartOfTheJadeSerpent = {
						color = "FF00FFBB",
						color2 = "FF00FFBB",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					}
				}
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
			innervate={
				name = L["Innervate"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = MistweaverLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Windwalker
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function WindwalkerLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Monk.WindwalkerLoadDefaultBarTextSettings = WindwalkerLoadDefaultBarTextSettings

---Loads default settings for Windwalker
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function WindwalkerLoadDefaultSettings(includeBarText, classic)
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
				cracklingJadeLightning = {
					enabled = false,
				},
				expelHarm = {
					enabled = true,
				},
				tigerPalm = {
					enabled = true,
				},
				vivify = {
					enabled = false,
				},
				detox = {
					enabled = false,
				},
				disable = {
					enabled = false,
				},
				paralysis = {
					enabled = false,
				},
				soothingMist = {
					enabled = false,
				},
			},
			customThresholds = {}
		},
		maxResource = {
			value = WINDWALKER_MAX_ENERGY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = WINDWALKER_MAX_ENERGY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFFFFF00"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFD59900"
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
					color = "FFFFD300"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFFFF00",
					color2 = "FFFFFF00",
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
					color = "FF00FF98"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFB5FFEB",
					color2 = "FFB5FFEB",
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
			shared = {
				nodeOrder = {
					"heartOfTheJadeSerpentReady",
					"heartOfTheJadeSerpent",
					"danceOfChiJi"
				},
				gradientOrder = {
					"borderOvercap"
				},
				indicatorColors = {
					danceOfChiJi = {
						color = "FF00FF00",
						color2 = "FF00FF00",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							chiBar = { bar = false, border = false, background = false }
						}
					},
					heartOfTheJadeSerpentReady = {
						color = "FF008461",
						color2 = "FF008461",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							chiBar = { bar = false, border = false, background = false }
						}
					},
					heartOfTheJadeSerpent = {
						color = "FF00FFBB",
						color2 = "FF00FFBB",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							chiBar = { bar = false, border = false, background = false }
						}
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							chiBar = { bar = false, border = false, background = false }
						}
					}
				}
			},
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
			danceOfChiJi={
				name = L["MonkWindwalkerAudioDanceOfChiJi"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			chiThreshold1={
				name = L["MonkAudioChiThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 3
				}
			},
			chiThreshold2={
				name = L["MonkAudioChiThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
			chiThreshold3={
				name = L["MonkAudioChiThreshold3"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 6
				}
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = WindwalkerLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Monk
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.monk.brewmaster = BrewmasterLoadDefaultSettings(includeBarText, classic)
	settings.monk.mistweaver = MistweaverLoadDefaultSettings(includeBarText, classic)
	settings.monk.windwalker = WindwalkerLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Monk.LoadDefaultSettings = LoadDefaultSettings



--[[

Brewmaster Option Menus

]]

local function BrewmasterConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.monk_brewmaster
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Monk_Brewmaster_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["MonkBrewmasterFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.monk.brewmaster = BrewmasterLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Brewmaster_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["MonkBrewmasterFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.monk.brewmaster = BrewmasterLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Brewmaster_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["MonkBrewmasterFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BrewmasterLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.brewmasterDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Brewmaster_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["MonkBrewmasterFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BrewmasterLoadDefaultBarTextSettings(true)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.brewmasterDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function BrewmasterConstructEnergyBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 10, 1, yCoord)

	yCoord = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], 1, BREWMASTER_MAX_ENERGY)
end

local function BrewmasterConstructStaggerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	-- Stagger bar dimensions using custom bar system
	local staggerBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("stagger")
	if staggerBarDef then
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 10, 1, yCoord, staggerBarDef, L["ResourceEnergy"])
	end

	-- Stagger bar colors using custom bar system
	yCoord = yCoord - 90
	if staggerBarDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 10, 1, yCoord, staggerBarDef)
	end

	yCoord = yCoord - 10
	-- Maximum Stagger Scale slider
	controls.staggerMaxScaleSlider = TRB.Functions.OptionsUi.Primitives:BuildPercentageSlider(parent, L["StaggerBarMaxScaleSlider"], 100, 1000, spec.bars.stagger.maxScale or 1.0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerMaxScaleSlider.tooltip = L["StaggerBarMaxScaleTooltip"]
	controls.staggerMaxScaleSlider:SetScript("OnValueChanged", function(self, value)
		local displayValue = TRB.Functions.Number:RoundTo(value, 0)
		self.EditBox:SetText(displayValue .. "%")
		-- Store as decimal (e.g., 100% -> 1.0, 200% -> 2.0)
		spec.bars.stagger.maxScale = value / 100
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(10, 1) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)
end

local function BrewmasterConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 10, 1, yCoord)
end

local function BrewmasterConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 1
	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "invokeNiuzaoEnd", label = L["MonkBrewmasterCheckboxInvokeNiuzaoEnd"], tooltip = L["MonkBrewmasterIndicatorInvokeNiuzaoEndTooltip"], colorLabel = L["MonkBrewmasterIndicatorInvokeNiuzaoEndColor"] },
			{ key = "invokeNiuzao", label = L["MonkBrewmasterCheckboxInvokeNiuzao"], tooltip = L["MonkBrewmasterIndicatorInvokeNiuzaoTooltip"], colorLabel = L["MonkBrewmasterIndicatorInvokeNiuzaoColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["MonkIndicatorBorderOvercap"], tooltip = L["MonkIndicatorOvercapTooltip"], colorLabel = L["MonkIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "energyBar", label = L["BarNameEnergyBar"] },
			{ key = "staggerBar", label = L["BarNameStaggerBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Monk_Brewmaster",
		excludedElements = {
			staggerBar = { bar = true },
		},
		endOfConfigs = {
			{
				endOfKey = "invokeNiuzao",
				sectionHeader = L["MonkBrewmasterEndOfInvokeNiuzaoConfigurationHeader"],
				gcdRadioLabel = L["MonkBrewmasterCheckboxInvokeNiuzaoGcds"],
				gcdSliderLabel = L["MonkBrewmasterInvokeNiuzaoGcds"],
				timeRadioLabel = L["MonkBrewmasterCheckboxInvokeNiuzaoTime"],
				timeSliderLabel = L["MonkBrewmasterInvokeNiuzaoTime"],
			},
		},
		overcapConfig = {
			primaryResourceString = L["ResourceEnergy"],
			primaryResourceMax = BREWMASTER_MAX_ENERGY,
		},
	})

	yCoord = yCoord - 40
end

local function BrewmasterConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	-- Pass stagger bar definition to include its textures in the standard texture section
	local staggerBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("stagger")
	local customBars = {}
	if staggerBarDef then
		table.insert(customBars, staggerBarDef)
	end
	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 10, 1, yCoord, false, nil, false, customBars)
end

local function BrewmasterConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	-- Primary, health, and stagger bar visibility
	local customBars = {}
	local staggerBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("stagger")
	if staggerBarDef then
		table.insert(customBars, staggerBarDef)
	end

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], nil, false, nil, true, nil, customBars)
end

local function BrewmasterConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 10, 1, yCoord, {
		barTargetLabels = {
			primary = L["ResourceEnergy"],
		},
		labels = {
			cracklingJadeLightning = L["MonkBrewmasterThresholdCheckboxCracklingJadeLightning"],
			expelHarm = L["MonkBrewmasterThresholdCheckboxExpelHarm"],
			spinningCraneKick = L["MonkBrewmasterThresholdCheckboxSpinningCraneKick"],
			tigerPalm = L["MonkBrewmasterThresholdCheckboxTigerPalm"],
			vivify = L["MonkBrewmasterThresholdCheckboxVivify"],
			detox = L["MonkBrewmasterThresholdCheckboxDetox"],
			disable = L["MonkBrewmasterThresholdCheckboxDisable"],
			paralysis = L["MonkBrewmasterThresholdCheckboxParalysis"],
			soothingMist = L["MonkBrewmasterThresholdCheckboxSoothingMist"],
			kegSmash = L["MonkBrewmasterThresholdCheckboxKegSmash"],
		},
		tooltips = {
			expelHarm = L["MonkBrewmasterThresholdCheckboxExpelHarmTooltip"],
			kegSmash = L["MonkBrewmasterThresholdCheckboxKegSmashTooltip"],
			spinningCraneKick = L["MonkBrewmasterThresholdCheckboxSpinningCraneKickTooltip"],
			tigerPalm = L["MonkBrewmasterThresholdCheckboxTigerPalmTooltip"],
			cracklingJadeLightning = L["MonkBrewmasterThresholdCheckboxCracklingJadeLightningTooltip"],
			detox = L["MonkBrewmasterThresholdCheckboxDetoxTooltip"],
			disable = L["MonkBrewmasterThresholdCheckboxDisableTooltip"],
			paralysis = L["MonkBrewmasterThresholdCheckboxParalysisTooltip"],
			soothingMist = L["MonkBrewmasterThresholdCheckboxSoothingMistTooltip"],
			vivify = L["MonkBrewmasterThresholdCheckboxVivifyTooltip"],
		},
	})
end

local function BrewmasterConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5
	local f = nil


	-- Stagger Levels section
	controls.staggerLevelsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["StaggerLevelsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.staggerMediumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_staggerMedium", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.staggerMediumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["StaggerLevelMediumCheckbox"])
	f.tooltip = L["StaggerLevelMediumTooltip"]
	f:SetChecked(spec.thresholds.stagger.medium.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.stagger.medium.enabled = self:GetChecked()
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(10, 1) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	controls.checkBoxes.staggerHeavyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_staggerHeavy", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.staggerHeavyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["StaggerLevelHeavyCheckbox"])
	f.tooltip = L["StaggerLevelHeavyTooltip"]
	f:SetChecked(spec.thresholds.stagger.heavy.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.stagger.heavy.enabled = self:GetChecked()
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(10, 1) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.staggerExtremeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_staggerExtreme", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.staggerExtremeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["StaggerLevelExtremeCheckbox"])
	f.tooltip = L["StaggerLevelExtremeTooltip"]
	f:SetChecked(spec.thresholds.stagger.extreme.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.stagger.extreme.enabled = self:GetChecked()
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(10, 1) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 1, yCoord)
end

local function BrewmasterConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 10, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 10, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkBrewmasterColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkBrewmasterColorPickerCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)	

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkBrewmasterColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkBrewmasterColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["MonkBrewmasterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["MonkBrewmasterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	-- Stagger text color section
	local staggerText = spec.colors.text.stagger

	yCoord = yCoord - 40
	controls.staggerTextColorSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MonkBrewmasterStaggerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	local staggerModeLabels = {
		bar = L["MonkBrewmasterStaggerTextColorModeBar"],
		custom = L["MonkBrewmasterStaggerTextColorModeCustom"],
		none = L["MonkBrewmasterStaggerTextColorModeNone"]
	}

	controls.dropDown = controls.dropDown or {}
	controls.dropDown.staggerTextColorMode = CreateFrame("DropdownButton", "TwintopResourceBar_Monk_Brewmaster_StaggerTextColorMode", parent, "WowStyle1DropdownTemplate")
	local staggerModeDropdown = controls.dropDown.staggerTextColorMode
	staggerModeDropdown:SetWidth(oUi.sliderWidth)
	staggerModeDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MonkBrewmasterStaggerTextColorMode"], oUi.xCoord, yCoord)
	staggerModeDropdown.label.font:SetFontObject(GameFontNormal)

	controls.colors.text.staggerCustom = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkBrewmasterStaggerTextColorCustom"], staggerText.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord-30)
	f = controls.colors.text.staggerCustom
	f:SetScript("OnMouseDown", function(self, button, ...)
		-- staggerText.color is a direct hex string, so address it with key "color"
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, staggerText, { color = controls.colors.text.staggerCustom }, "color")
	end)

	local function StaggerModeUpdateSwatch()
		if staggerText.mode == "custom" then
			controls.colors.text.staggerCustom:Show()
		else
			controls.colors.text.staggerCustom:Hide()
		end
	end

	local function StaggerModeIsSelected(value)
		return value == staggerText.mode
	end

	local function StaggerModeSetSelected(newValue)
		staggerText.mode = newValue
		staggerModeDropdown:SetDefaultText(staggerModeLabels[newValue])
		StaggerModeUpdateSwatch()
		TRB.Data.lookupDirty = true
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end

	local function StaggerModeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(staggerModeLabels.bar, StaggerModeIsSelected, StaggerModeSetSelected, "bar")
		rootDescription:CreateRadio(staggerModeLabels.custom, StaggerModeIsSelected, StaggerModeSetSelected, "custom")
		rootDescription:CreateRadio(staggerModeLabels.none, StaggerModeIsSelected, StaggerModeSetSelected, "none")
	end

	staggerModeDropdown:SetupMenu(StaggerModeGenerator)
	staggerModeDropdown:SetDefaultText(staggerModeLabels[staggerText.mode] or staggerModeLabels.bar)
	staggerModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	StaggerModeUpdateSwatch()

	yCoord = yCoord - 60

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 10, 1, yCoord)
end

local function BrewmasterConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5
	local f = nil


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
end

local function BrewmasterConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_brewmaster
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 10, 1, yCoord, cache)
end

local function BrewmasterConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(10, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.monk_brewmaster or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.brewmasterDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Brewmaster")
	TRB.Options.OptionsFrame:RegisterSpecPanel("monk", "monk_brewmaster", L["MonkBrewmasterFull"], interfaceSettingsFrame.brewmasterDisplayPanel)
	
	parent = interfaceSettingsFrame.brewmasterDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["MonkBrewmasterFull"],
		TRB.Data.settings.core.enabled.monk, "brewmaster",
		"TwintopResourceBar_Monk_Brewmaster_brewmasterMonkEnabled", "brewmasterMonkEnabled",
		"monk", "brewmaster")

	local tabDefinitions = {
		{ "energyBar", L["TabEnergy"], oUi.tabWidth.small, BrewmasterConstructEnergyBarPanel, visibilityKey = "primary" },
		{ "staggerBar", L["TabStagger"], oUi.tabWidth.small, BrewmasterConstructStaggerBarPanel, visibilityKey = "stagger" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, BrewmasterConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, BrewmasterConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, BrewmasterConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, BrewmasterConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, BrewmasterConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, BrewmasterConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("monk", "brewmaster", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, BrewmasterConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) BrewmasterConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, BrewmasterConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.monk_brewmaster = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


--[[

Mistweaver Option Menus

]]

local function MistweaverConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.monk_mistweaver
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.monk.mistweaver = MistweaverLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.monk.mistweaver = MistweaverLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MistweaverLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.mistweaverDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MistweaverLoadDefaultBarTextSettings(true)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.mistweaverDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function MistweaverConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 10, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"])

	--[[	
	yCoord = yCoord - 30
	controls.checkBoxes.heartOfTheJadeSerpentReady = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_heartOfTheJadeSerpentReady", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.heartOfTheJadeSerpentReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxHeartOfTheJadeSerpentReady"])
	f.tooltip = L["MonkMistweaverCheckboxHeartOfTheJadeSerpentReadyTooltip"]
	f:SetChecked(spec.colors.bar.heartOfTheJadeSerpentReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.heartOfTheJadeSerpentReady.enabled = self:GetChecked()
	end)

	controls.colors.heartOfTheJadeSerpentReady = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkMistweaverColorPickerHeartOfTheJadeSerpentReady"], spec.colors.bar.heartOfTheJadeSerpentReady.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.heartOfTheJadeSerpentReady
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "heartOfTheJadeSerpentReady")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.heartOfTheJadeSerpent = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_heartOfTheJadeSerpent", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.heartOfTheJadeSerpent
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxHeartOfTheJadeSerpent"])
	f.tooltip = L["MonkMistweaverCheckboxHeartOfTheJadeSerpentTooltip"]
	f:SetChecked(spec.colors.bar.heartOfTheJadeSerpent.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.heartOfTheJadeSerpent.enabled = self:GetChecked()
	end)

	controls.colors.heartOfTheJadeSerpent = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkMistweaverColorPickerHeartOfTheJadeSerpent"], spec.colors.bar.heartOfTheJadeSerpent.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.heartOfTheJadeSerpent
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "heartOfTheJadeSerpent")
	end)]]
end

local function MistweaverConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 2
	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "vivaciousVivification", label = L["MonkMistweaverCheckboxVivify"], tooltip = L["MonkMistweaverIndicatorVivaciousVivificationTooltip"], colorLabel = L["MonkMistweaverIndicatorVivaciousVivificationColor"] },
			--{ key = "heartOfTheJadeSerpent", label = L["MonkMistweaverCheckboxHeartOfTheJadeSerpent"], tooltip = L["MonkMistweaverIndicatorHeartOfTheJadeSerpentTooltip"], colorLabel = L["MonkMistweaverIndicatorHeartOfTheJadeSerpentColor"] },
			--{ key = "heartOfTheJadeSerpentReady", label = L["MonkMistweaverCheckboxHeartOfTheJadeSerpentReady"], tooltip = L["MonkMistweaverIndicatorHeartOfTheJadeSerpentReadyTooltip"], colorLabel = L["MonkMistweaverIndicatorHeartOfTheJadeSerpentReadyColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Monk_Mistweaver",
	})

	yCoord = yCoord - 40
end

local function MistweaverConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 10, 2, yCoord)
end

local function MistweaverConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 10, 2, yCoord, false)
end

local function MistweaverConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"], "notFull", false, nil, true)
end

local function MistweaverConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5
	local f = nil

end

local function MistweaverConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 10, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 10, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 10, 2, yCoord)
end

local function MistweaverConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 2
	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5
	local f = nil


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function MistweaverConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 10, 2, yCoord, cache)
end

local function MistweaverConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_mistweaver
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 2, yCoord)
end

local function MistweaverConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(10, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.monk_mistweaver or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.mistweaverDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Mistweaver")
	TRB.Options.OptionsFrame:RegisterSpecPanel("monk", "monk_mistweaver", L["MonkMistweaverFull"], interfaceSettingsFrame.mistweaverDisplayPanel)
	
	parent = interfaceSettingsFrame.mistweaverDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["MonkMistweaverFull"],
		TRB.Data.settings.core.enabled.monk, "mistweaver",
		"TwintopResourceBar_Monk_Mistweaver_mistweaverMonkEnabled", "mistweaverMonkEnabled",
		"monk", "mistweaver")

	local tabDefinitions = {
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, MistweaverConstructManaBarPanel, visibilityKey = "primary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, MistweaverConstructHealthBarPanel, visibilityKey = "health" },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, MistweaverConstructThresholdSettingsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("monk", "mistweaver", controls),
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, MistweaverConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, MistweaverConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, MistweaverConstructBarVisibilityPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, MistweaverConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) MistweaverConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, MistweaverConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.monk_mistweaver = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


--[[

Windwalker Option Menus

]]

local function WindwalkerConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.monk_windwalker
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["MonkWindwalkerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.monk.windwalker = WindwalkerLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["MonkWindwalkerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.monk.windwalker = WindwalkerLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["MonkWindwalkerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = WindwalkerLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.windwalkerDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["MonkWindwalkerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = WindwalkerLoadDefaultBarTextSettings(true)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.windwalkerDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function WindwalkerConstructEnergyBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 10, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"])
	
	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], 1, WINDWALKER_MAX_ENERGY)
end

local function WindwalkerConstructChiPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], L["ResourceChi"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ChiColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceChi"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ChiColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ChiColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ChiCheckboxUseHighestForAll"])
	f.tooltip = L["ChiCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ChiColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ChiColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Monk_Windwalker_ComboPoints", "endCapComboPoints", L["EndCap"], 10, 3)
end

local function WindwalkerConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 10, 3, yCoord)
end

local function WindwalkerConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 3
	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "danceOfChiJi", label = L["MonkWindwalkerCheckboxDanceOfChiJi"], tooltip = L["MonkWindwalkerIndicatorDanceOfChiJiTooltip"], colorLabel = L["MonkWindwalkerIndicatorDanceOfChiJiColor"] },
			{ key = "heartOfTheJadeSerpent", label = L["MonkWindwalkerCheckboxHeartOfTheJadeSerpent"], tooltip = L["MonkWindwalkerIndicatorHeartOfTheJadeSerpentTooltip"], colorLabel = L["MonkWindwalkerIndicatorHeartOfTheJadeSerpentColor"] },
			{ key = "heartOfTheJadeSerpentReady", label = L["MonkWindwalkerCheckboxHeartOfTheJadeSerpentReady"], tooltip = L["MonkWindwalkerIndicatorHeartOfTheJadeSerpentReadyTooltip"], colorLabel = L["MonkWindwalkerIndicatorHeartOfTheJadeSerpentReadyColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["MonkIndicatorBorderOvercap"], tooltip = L["MonkIndicatorOvercapTooltip"], colorLabel = L["MonkIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "energyBar", label = L["BarNameEnergyBar"] },
				{ key = "chiBar", label = L["ResourceChi"] },
		},
		ddNamePrefix = "TwintopResourceBar_Monk_Windwalker",
		overcapConfig = {
			primaryResourceString = L["ResourceEnergy"],
			primaryResourceMax = WINDWALKER_MAX_ENERGY,
		},
	})

	yCoord = yCoord - 40
end

local function WindwalkerConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 10, 3, yCoord, true, L["ResourceChi"])
end

local function WindwalkerConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], "notFull", true, L["ResourceChi"], true)
end

local function WindwalkerConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 10, 3, yCoord, {
		barTargetLabels = {
			primary = L["ResourceEnergy"],
		},
		labels = {
			cracklingJadeLightning = L["MonkWindwalkerThresholdCheckboxCracklingJadeLightning"],
			expelHarm = L["MonkWindwalkerThresholdCheckboxExpelHarm"],
			tigerPalm = L["MonkWindwalkerThresholdCheckboxTigerPalm"],
			vivify = L["MonkWindwalkerThresholdCheckboxVivify"],
			detox = L["MonkWindwalkerThresholdCheckboxDetox"],
			disable = L["MonkWindwalkerThresholdCheckboxDisable"],
			paralysis = L["MonkWindwalkerThresholdCheckboxParalysis"],
			soothingMist = L["MonkWindwalkerThresholdCheckboxSoothingMist"],
		},
		tooltips = {
			expelHarm = L["MonkWindwalkerThresholdCheckboxExpelHarmTooltip"],
			tigerPalm = L["MonkWindwalkerThresholdCheckboxTigerPalmTooltip"],
			cracklingJadeLightning = L["MonkWindwalkerThresholdCheckboxCracklingJadeLightningTooltip"],
			detox = L["MonkWindwalkerThresholdCheckboxDetoxTooltip"],
			disable = L["MonkWindwalkerThresholdCheckboxDisableTooltip"],
			paralysis = L["MonkWindwalkerThresholdCheckboxParalysisTooltip"],
			soothingMist = L["MonkWindwalkerThresholdCheckboxSoothingMistTooltip"],
			vivify = L["MonkWindwalkerThresholdCheckboxVivifyTooltip"],
		},
	})
end

local function WindwalkerConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5


	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 3, yCoord)
end

local function WindwalkerConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 10, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 10, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MonkColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["MonkCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 10, 3, yCoord)
end

local function WindwalkerConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 3
	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5
	local f = nil

	local title = ""


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "danceOfChiJi", spec, classId, specId, yCoord, L["MonkWindwalkerCheckboxDanceOfChiJi"], L["MonkWindwalkerCheckboxDanceOfChiJiTooltip"])

	local yCoord2 = yCoord - 20
	
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "chiThreshold1", spec, classId, specId, yCoord, L["MonkAudioCheckboxChiThreshold1"], L["MonkAudioCheckboxChiThreshold1Tooltip"])

	controls.chiThreshold1Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["MonkChiThresholdSliderTitle"], 0, 6, spec.audio["chiThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.chiThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["chiThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "chiThreshold2", spec, classId, specId, yCoord, L["MonkAudioCheckboxChiThreshold2"], L["MonkAudioCheckboxChiThreshold2Tooltip"])

	controls.chiThreshold2Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["MonkChiThresholdSliderTitle"], 0, 6, spec.audio["chiThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.chiThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["chiThreshold2"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "chiThreshold3", spec, classId, specId, yCoord, L["MonkAudioCheckboxChiThreshold3"], L["MonkAudioCheckboxChiThreshold3Tooltip"])

	controls.chiThreshold3Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["MonkChiThresholdSliderTitle"], 0, 6, spec.audio["chiThreshold3"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.chiThreshold3Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["chiThreshold3"].configuration.thresholdValue = value
	end)
end

local function WindwalkerConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.monk_windwalker
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 10, 3, yCoord, cache)
end

local function WindwalkerConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(10, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.monk_windwalker or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.windwalkerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Windwalker")
	TRB.Options.OptionsFrame:RegisterSpecPanel("monk", "monk_windwalker", L["MonkWindwalkerFull"], interfaceSettingsFrame.windwalkerDisplayPanel)
	
	parent = interfaceSettingsFrame.windwalkerDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["MonkWindwalkerFull"],
		TRB.Data.settings.core.enabled.monk, "windwalker",
		"TwintopResourceBar_Monk_Windwalker_windwalkerMonkEnabled", "windwalkerMonkEnabled",
		"monk", "windwalker")

	local tabDefinitions = {
		{ "energyBar", L["TabEnergy"], oUi.tabWidth.small, WindwalkerConstructEnergyBarPanel, visibilityKey = "primary" },
		{ "chiBar", L["TabChi"], oUi.tabWidth.small, WindwalkerConstructChiPanel, visibilityKey = "secondary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, WindwalkerConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, WindwalkerConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, WindwalkerConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, WindwalkerConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.large, WindwalkerConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, WindwalkerConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("monk", "windwalker", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, WindwalkerConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, WindwalkerConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) WindwalkerConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, WindwalkerConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.monk_windwalker = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("monk", L["Monk"])
	BrewmasterConstructOptionsPanel(specCache.monk_brewmaster)
	MistweaverConstructOptionsPanel(specCache.monk_mistweaver)
	WindwalkerConstructOptionsPanel(specCache.monk_windwalker)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Monk.ConstructOptionsPanel = ConstructOptionsPanel
