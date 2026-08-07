local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Rogue = {}
TRB.Options.Rogue.Assassination = {}
TRB.Options.Rogue.Outlaw = {}
TRB.Options.Rogue.Subtlety = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_assassination = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_outlaw = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_subtlety = {}

local ASSASSINATION_MAX_ENERGY = TRB.Data.maxResource.rogue.assassination.energy
local OUTLAW_MAX_ENERGY = TRB.Data.maxResource.rogue.outlaw.energy
local SUBTLETY_MAX_ENERGY = TRB.Data.maxResource.rogue.subtlety.energy

---Loads default bar text settings for Assassination
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function AssassinationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Rogue.AssassinationLoadDefaultBarTextSettings = AssassinationLoadDefaultBarTextSettings

---Loads default settings for Assassination
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function AssassinationLoadDefaultSettings(includeBarText, classic)
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
				-- Rogue
				ambush = {
					enabled = true,
				},
				cheapShot = {
					enabled = false,
				},
				crimsonVial = {
					enabled = false,
				},
				distract = {
					enabled = false,
				},
				feint = {
					enabled = false,
				},
				gouge = {
					enabled = false,
				},
				kidneyShot = {
					enabled = false,
				},
				sap = {
					enabled = false,
				},
				shiv = {
					enabled = false,
				},
				sliceAndDice = {
					enabled = false,
				},
				-- Assassination
				crimsonTempest = {
					enabled = false,
				},
				envenom = {
					enabled = true,
				},
				fanOfKnives = {
					enabled = false,
				},
				garrote = {
					enabled = false,
				},
				kingsbane = {
					enabled = true,
				},
				mutilate = {
					enabled = true,
				},
				poisonedKnife = {
					enabled = false,
				},
				rupture = {
					enabled = false,
				},
				-- PvP					
				deathFromAbove = {
					enabled = false,
				},
				dismantle = {
					enabled = false,
				},
			},
			customThresholds = {},
		},
		maxResource = {
			value = ASSASSINATION_MAX_ENERGY,
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
			fixed = ASSASSINATION_MAX_ENERGY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
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
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				borderStealth = {
					color = "FF000000",
					enabled = true
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
				fiveComboPoints = {
					color = "FF99FF00",
					color2 = "FF99FF00",
					gradientDirection = "disabled",
					override = true
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
				echoingReprimand = {
					color = "FF68CCEF",
					color2 = "FF68CCEF",
					gradientDirection = "disabled"
				},
				sameColor = false,
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
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				echoingReprimand = {
					color = "FF68CCEF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = {
					"borderStealth"
				},
				gradientOrder = {
					"borderOvercap"
				},
				indicatorColors = {
					borderStealth = {
						color = "FF000000",
						enabled = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							comboPointsBar = { bar = false, border = false, background = false }
						}
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							comboPointsBar = { bar = false, border = false, background = false }
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
				color = { color = "FFFFFFFF" },
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
		settings.displayText.barText = AssassinationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Outlaw
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function OutlawLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Rogue.OutlawLoadDefaultBarTextSettings = OutlawLoadDefaultBarTextSettings

---Loads default settings for Outlaw
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function OutlawLoadDefaultSettings(includeBarText, classic)
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
			-- Rogue
				ambush = {
					enabled = true,
				},
				cheapShot = {
					enabled = false,
				},
				crimsonVial = {
					enabled = false,
				},
				distract = {
					enabled = false,
				},
				feint = {
					enabled = false,
				},
				gouge = {
					enabled = false,
				},
				kidneyShot = {
					enabled = false,
				},
				sap = {
					enabled = false,
				},
				shiv = {
					enabled = false,
				},
				sinisterStrike = {
					enabled = true,
				},
				sliceAndDice = {
					enabled = false,
				},
				-- Outlaw
				betweenTheEyes = {
					enabled = true,
				},
				bladeFlurry = {
					enabled = false,
				},
				dispatch = {
					enabled = true,
				},
				killingSpree = {
					enabled = false,
				},
				pistolShot = {
					enabled = false,
				},
				rollTheBones = {
					enabled = true,
				},
				-- PvP					
				deathFromAbove = {
					enabled = false,
				},
				dismantle = {
					enabled = false,
				},
				--Trickster
				coupDeGrace = {
					enabled = true,
				},
			},
			customThresholds = {},
		},
		maxResource = {
			value = OUTLAW_MAX_ENERGY,
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
			fixed = OUTLAW_MAX_ENERGY
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
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				borderStealth = {
					color = "FF000000",
					enabled = true
				},
				borderRtbBad = {
					color = "FFFF8888",
					enabled = true
				},
				borderRtbGood = {
					color = "FF00FF00",
					enabled = true
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
				fiveComboPoints = {
					color = "FF99FF00",
					color2 = "FF99FF00",
					gradientDirection = "disabled",
					override = true
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
				echoingReprimand = {
					color = "FF68CCEF",
					color2 = "FF68CCEF",
					gradientDirection = "disabled"
				},
				sameColor = false,
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
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				restlessBlades = {
					color = "FFFFFF00",
					enabled = true
				},
				echoingReprimand = {
					color = "FF68CCEF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
				shared = {
					nodeOrder = {
						"borderStealth"
					},
					gradientOrder = {
						"borderOvercap"
					},
					indicatorColors = {
						borderStealth = {
							color = "FF000000",
							enabled = true,
							targets = {
								energyBar = { bar = false, border = true, background = false },
								comboPointsBar = { bar = false, border = false, background = false }
							}
						},
						borderOvercap = {
							color = "FFFF0000",
							enabled = true,
							isGradient = true,
							targets = {
								energyBar = { bar = false, border = true, background = false },
								comboPointsBar = { bar = false, border = false, background = false }
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
				color = { color = "FFFFFFFF" },
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
		settings.displayText.barText = OutlawLoadDefaultBarTextSettings(classic)
	end

	return settings
end


---Loads default bar text settings for Subtlety
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function SubtletyLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Rogue.SubtletyLoadDefaultBarTextSettings = SubtletyLoadDefaultBarTextSettings

---Loads default settings for Subtlety
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function SubtletyLoadDefaultSettings(includeBarText, classic)
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
				-- Rogue
				-- Technically a Rogue ability but missing from Assassination and Outlaw
				cheapShot = {
					enabled = false,
				},
				crimsonVial = {
					enabled = false,
				},
				distract = {
					enabled = false,
				},
				eviscerate = {
					enabled = true,
				},
				feint = {
					enabled = false,
				},
				gouge = {
					enabled = false,
				},
				kidneyShot = {
					enabled = false,
				},
				sap = {
					enabled = false,
				},
				shiv = {
					enabled = false,
				},
				sliceAndDice = {
					enabled = false,
				},
				-- Subtlety
				backstab = {
					enabled = true,
				},
				blackPowder = {
					enabled = true,
				},
				gloomblade = {
					enabled = true,
				},
				goremawsBite = {
					enabled = true,
				},
				secretTechnique = {
					enabled = true,
				},
				shadowstrike = {
					enabled = true,
				},
				shurikenStorm = {
					enabled = true,
				},
				shurikenToss = {
					enabled = false,
				},
				-- PvP					
				deathFromAbove = {
					enabled = false,
				},
				dismantle = {
					enabled = false,
				},
				--Trickster
				coupDeGrace = {
					enabled = true,
				},
			},
			customThresholds = {},
		},
		maxResource = {
			value = SUBTLETY_MAX_ENERGY,
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
			fixed = SUBTLETY_MAX_ENERGY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
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
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				borderStealth = {
					color = "FF000000",
					enabled = true
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
				fiveComboPoints = {
					color = "FF99FF00",
					color2 = "FF99FF00",
					gradientDirection = "disabled",
					override = true
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
				echoingReprimand = {
					color = "FF68CCEF",
					color2 = "FF68CCEF",
					gradientDirection = "disabled"
				},
				shadowTechniques = {
					color = "FF431863",
					color2 = "FF431863",
					gradientDirection = "disabled"
				},
				sameColor = false,
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
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				echoingReprimand = {
					color = "FF68CCEF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = {
					"borderStealth"
				},
				gradientOrder = {
					"borderOvercap"
				},
				indicatorColors = {
					borderStealth = {
						color = "FF000000",
						enabled = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							comboPointsBar = { bar = false, border = false, background = false }
						}
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
							comboPointsBar = { bar = false, border = false, background = false }
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
				color = { color = "FFFFFFFF" },
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
		settings.displayText.barText = SubtletyLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Rogue
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.rogue.assassination = AssassinationLoadDefaultSettings(includeBarText, classic)
	settings.rogue.outlaw = OutlawLoadDefaultSettings(includeBarText, classic)
	settings.rogue.subtlety = SubtletyLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Rogue.LoadDefaultSettings = LoadDefaultSettings

--[[

Assassination Option Menus

]]

local function AssassinationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_assassination
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.assassination = AssassinationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.assassinationDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.assassination = AssassinationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.assassinationDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextSettings(true)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.assassinationDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextClassic")
	end)

	yCoord = yCoord - 40
end

local function AssassinationConstructEnergyBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], 1, ASSASSINATION_MAX_ENERGY)
end

local function AssassinationConstructComboPointsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.fiveComboPoints = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerFive"], spec.colors.comboPoints.fiveComboPoints, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local fiveComboPointsYCoord = yCoord
	f = controls.colors.comboPoints.fiveComboPoints
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "fiveComboPoints")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.fiveComboPoints, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.fiveComboPointOverride = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_fiveComboPointOverride", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fiveComboPointOverride
	f:SetPoint("TOPLEFT", oUi.xCoord, fiveComboPointsYCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxFiveOverride"])
	f.tooltip = L["ComboPointCheckboxFiveOverrideTooltip"]
	f:SetChecked(spec.colors.comboPoints.fiveComboPoints.override)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.fiveComboPoints.override = self:GetChecked()
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.echoingReprimand, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Rogue_Assassination_ComboPoints", "endCapComboPoints", L["EndCap"], 4, 1)
end

local function AssassinationConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 4, 1, yCoord)
end

local function AssassinationConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 4, 1, yCoord, true, L["ResourceComboPoints"])
end

local function AssassinationConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], "notFull", true, L["ResourceComboPoints"], true)
end

local function AssassinationConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 4, 1, yCoord, {
		barTargetLabels = {
			primary = L["ResourceEnergy"],
		},
		labels = {
			ambush = L["RogueAssassinationThresholdAmbush"],
			cheapShot = L["RogueAssassinationThresholdCheapShot"],
			crimsonVial = L["RogueAssassinationThresholdCrimsonVial"],
			distract = L["RogueAssassinationThresholdDistract"],
			feint = L["RogueAssassinationThresholdFeint"],
			gouge = L["RogueAssassinationThresholdGouge"],
			kidneyShot = L["RogueAssassinationThresholdKidneyShot"],
			sap = L["RogueAssassinationThresholdSap"],
			shiv = L["RogueAssassinationThresholdShiv"],
			sliceAndDice = L["RogueAssassinationThresholdSliceAndDice"],
			crimsonTempest = L["RogueAssassinationThresholdCrimsonTempest"],
			envenom = L["RogueAssassinationThresholdEnvenom"],
			fanOfKnives = L["RogueAssassinationThresholdFanOfKnives"],
			garrote = L["RogueAssassinationThresholdGarrote"],
			kingsbane = L["RogueAssassinationThresholdKingsbane"],
			mutilate = L["RogueAssassinationThresholdMutilate"],
			poisonedKnife = L["RogueAssassinationThresholdPoisonedKnife"],
			rupture = L["RogueAssassinationThresholdRupture"],
			deathFromAbove = L["RogueAssassinationThresholdDeathFromAbove"],
			dismantle = L["RogueAssassinationThresholdDismantle"],
		},
		tooltips = {
			ambush = L["RogueAssassinationThresholdAmbushTooltip"],
			cheapShot = L["RogueAssassinationThresholdCheapShotTooltip"],
			crimsonVial = L["RogueAssassinationThresholdCrimsonVialTooltip"],
			distract = L["RogueAssassinationThresholdDistractTooltip"],
			feint = L["RogueAssassinationThresholdFeintTooltip"],
			gouge = L["RogueAssassinationThresholdGougeTooltip"],
			kidneyShot = L["RogueAssassinationThresholdKidneyShotTooltip"],
			sap = L["RogueAssassinationThresholdSapTooltip"],
			shiv = L["RogueAssassinationThresholdShivTooltip"],
			sliceAndDice = L["RogueAssassinationThresholdSliceAndDiceTooltip"],
			crimsonTempest = L["RogueAssassinationThresholdCrimsonTempestTooltip"],
			envenom = L["RogueAssassinationThresholdEnvenomTooltip"],
			fanOfKnives = L["RogueAssassinationThresholdFanOfKnivesTooltip"],
			garrote = L["RogueAssassinationThresholdGarroteTooltip"],
			kingsbane = L["RogueAssassinationThresholdKingsbaneTooltip"],
			mutilate = L["RogueAssassinationThresholdMutilateTooltip"],
			poisonedKnife = L["RogueAssassinationThresholdPoisonedKnifeTooltip"],
			rupture = L["RogueAssassinationThresholdRuptureTooltip"],
			deathFromAbove = L["RogueAssassinationThresholdDeathFromAboveTooltip"],
			dismantle = L["RogueAssassinationThresholdDismantleTooltip"],
		},
	})
end

local function AssassinationConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	controls.colors.threshold = {}

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["RogueAssassinationColorPickerThresholdSpecial"],
			enabledCheckboxLocalization = L["RogueAssassinationColorPickerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueAssassinationColorPickerThresholdSpecialEnabledTooltip"]
		},
		{
			name = "echoingReprimand",
			colorLocalization = L["RogueAssassinationColorPickerThresholdEchoingReprimand"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueAssassinationColorPickerThresholdEchoingReprimandEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueAssassinationColorPickerThresholdEchoingReprimandEnabledTooltip"]
		}
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 1, yCoord)
end

local function AssassinationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 4, 1, yCoord)
	
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

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["RogueColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["RogueCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 4, 1, yCoord)
end

local function AssassinationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 4, 1, yCoord, cache)
end

local function AssassinationConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 4
	local specId = 1
	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_assassination
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "borderStealth", label = L["RogueCheckboxStealth"], tooltip = L["RogueIndicatorStealthTooltip"], colorLabel = L["RogueIndicatorStealthColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["RogueIndicatorBorderOvercap"], tooltip = L["RogueIndicatorOvercapTooltip"], colorLabel = L["RogueIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "energyBar", label = L["BarNameEnergyBar"] },
			{ key = "comboPointsBar", label = L["ResourceComboPoints"] },
		},
		ddNamePrefix = "TwintopResourceBar_Rogue_Assassination",
		overcapConfig = {
			primaryResourceString = L["ResourceEnergy"],
			primaryResourceMax = ASSASSINATION_MAX_ENERGY,
		},
	})

	yCoord = yCoord - 40
end

local function AssassinationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(4, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.rogue_assassination or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.assassinationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Assassination")
	TRB.Options.OptionsFrame:RegisterSpecPanel("rogue", "rogue_assassination", L["RogueAssassinationFull"], interfaceSettingsFrame.assassinationDisplayPanel)
	
	parent = interfaceSettingsFrame.assassinationDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["RogueAssassinationFull"],
		TRB.Data.settings.core.enabled.rogue, "assassination",
		"TwintopResourceBar_Rogue_Assassination_assassinationRogueEnabled", "assassinationRogueEnabled",
		"rogue", "assassination")

	local tabDefinitions = {
		{ "energyBar", L["TabEnergy"], oUi.tabWidth.small, AssassinationConstructEnergyBarPanel, visibilityKey = "primary" },
		{ "comboPointsBar", L["TabComboPoints"], oUi.tabWidth.small, AssassinationConstructComboPointsBarPanel, visibilityKey = "secondary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, AssassinationConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, AssassinationConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, AssassinationConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, AssassinationConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, AssassinationConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, AssassinationConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("rogue", "assassination", controls),
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("rogue", "assassination", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, AssassinationConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) AssassinationConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, AssassinationConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_assassination = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


--[[

Outlaw Option Menus

]]

local function OutlawConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_outlaw
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.outlaw = OutlawLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.outlawDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.outlaw = OutlawLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.outlawDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextSettings(true)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.outlawDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextClassic")
	end)

	yCoord = yCoord - 40
end

local function OutlawConstructEnergyBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"])

	--[[
	yCoord = yCoord - 30
	controls.colors.borderRtbGood = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["RogueOutlawColorPickerRollTheBonesHold"], spec.colors.bar.borderRtbGood, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.borderRtbGood
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderRtbGood")
	end)

	yCoord = yCoord - 30
	controls.colors.borderRtbBad = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["RogueOutlawColorPickerRollTheBonesUse"], spec.colors.bar.borderRtbBad, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.borderRtbBad
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderRtbBad")
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], 1, OUTLAW_MAX_ENERGY)
end

local function OutlawConstructComboPointsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.fiveComboPoints = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerFive"], spec.colors.comboPoints.fiveComboPoints, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local fiveComboPointsYCoord = yCoord
	f = controls.colors.comboPoints.fiveComboPoints
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "fiveComboPoints")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.fiveComboPoints, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.fiveComboPointOverride = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_fiveComboPointOverride", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fiveComboPointOverride
	f:SetPoint("TOPLEFT", oUi.xCoord, fiveComboPointsYCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxFiveOverride"])
	f.tooltip = L["ComboPointCheckboxFiveOverrideTooltip"]
	f:SetChecked(spec.colors.comboPoints.fiveComboPoints.override)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.fiveComboPoints.override = self:GetChecked()
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.echoingReprimand, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Rogue_Outlaw_ComboPoints", "endCapComboPoints", L["EndCap"], 4, 2)
end

local function OutlawConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 4, 2, yCoord)
end

local function OutlawConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 4, 2, yCoord, true, L["ResourceComboPoints"])
end

local function OutlawConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], "notFull", true, L["ResourceComboPoints"], true)
end

local function OutlawConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 4, 2, yCoord, {
		barTargetLabels = {
			primary = L["ResourceEnergy"],
		},
		labels = {
			ambush = L["RogueOutlawThresholdAmbush"],
			cheapShot = L["RogueOutlawThresholdCheapShot"],
			crimsonVial = L["RogueOutlawThresholdCrimsonVial"],
			distract = L["RogueOutlawThresholdDistract"],
			feint = L["RogueOutlawThresholdFeint"],
			gouge = L["RogueOutlawThresholdGouge"],
			kidneyShot = L["RogueOutlawThresholdKidneyShot"],
			sap = L["RogueOutlawThresholdSap"],
			shiv = L["RogueOutlawThresholdShiv"],
			sinisterStrike = L["RogueOutlawThresholdSinisterStrike"],
			sliceAndDice = L["RogueOutlawThresholdSliceAndDice"],
			betweenTheEyes = L["RogueOutlawThresholdBetweenTheEyes"],
			bladeFlurry = L["RogueOutlawThresholdBladeFlurry"],
			dispatch = L["RogueOutlawThresholdDispatch"],
			coupDeGrace = L["RogueOutlawThresholdCoupDeGrace"],
			killingSpree = L["RogueOutlawThresholdKillingSpree"],
			pistolShot = L["RogueOutlawThresholdPistolShot"],
			rollTheBones = L["RogueOutlawThresholdRollTheBones"],
			deathFromAbove = L["RogueOutlawThresholdDeathFromAbove"],
			dismantle = L["RogueOutlawThresholdDismantle"],
		},
		tooltips = {
			ambush = L["RogueOutlawThresholdAmbushTooltip"],
			cheapShot = L["RogueOutlawThresholdCheapShotTooltip"],
			crimsonVial = L["RogueOutlawThresholdCrimsonVialTooltip"],
			distract = L["RogueOutlawThresholdDistractTooltip"],
			feint = L["RogueOutlawThresholdFeintTooltip"],
			gouge = L["RogueOutlawThresholdGougeTooltip"],
			kidneyShot = L["RogueOutlawThresholdKidneyShotTooltip"],
			sap = L["RogueOutlawThresholdSapTooltip"],
			shiv = L["RogueOutlawThresholdShivTooltip"],
			sinisterStrike = L["RogueOutlawThresholdSinisterStrikeTooltip"],
			sliceAndDice = L["RogueOutlawThresholdSliceAndDiceTooltip"],
			betweenTheEyes = L["RogueOutlawThresholdBetweenTheEyesTooltip"],
			bladeFlurry = L["RogueOutlawThresholdBladeFlurryTooltip"],
			dispatch = L["RogueOutlawThresholdDispatchTooltip"],
			coupDeGrace = L["RogueOutlawThresholdCoupDeGraceTooltip"],
			killingSpree = L["RogueOutlawThresholdKillingSpreeTooltip"],
			pistolShot = L["RogueOutlawThresholdPistolShotTooltip"],
			rollTheBones = L["RogueOutlawThresholdRollTheBonesTooltip"],
			deathFromAbove = L["RogueOutlawThresholdDeathFromAboveTooltip"],
			dismantle = L["RogueOutlawThresholdDismantleTooltip"],
		},
	})
end

local function OutlawConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	controls.colors.threshold = {}

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["RogueOutlawColorPickerThresholdSpecial"],
			enabledCheckboxLocalization = L["RogueOutlawColorPickerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueOutlawColorPickerThresholdSpecialEnabledTooltip"]
		},
		{
			name = "restlessBlades",
			hasEnabledCheckbox = true,
			colorLocalization = L["RogueOutlawColorPickerThresholdRestlessBlades"],
			enabledCheckboxLocalization = L["RogueOutlawColorPickerThresholdRestlessBladesEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueOutlawColorPickerThresholdRestlessBladesEnabledTooltip"]
		},
		{
			name = "echoingReprimand",
			colorLocalization = L["RogueOutlawColorPickerThresholdEchoingReprimand"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueOutlawColorPickerThresholdEchoingReprimandEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueOutlawColorPickerThresholdEchoingReprimandEnabledTooltip"]
		}
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 2, yCoord)
end

local function OutlawConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 4, 2, yCoord)
	
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

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["RogueColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["RogueCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 4, 2, yCoord)
end

local function OutlawConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 4, 2, yCoord, cache)
end

local function OutlawConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 4
	local specId = 2
	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_outlaw
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "borderStealth", label = L["RogueCheckboxStealth"], tooltip = L["RogueIndicatorStealthTooltip"], colorLabel = L["RogueIndicatorStealthColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["RogueIndicatorBorderOvercap"], tooltip = L["RogueIndicatorOvercapTooltip"], colorLabel = L["RogueIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "energyBar", label = L["BarNameEnergyBar"] },
			{ key = "comboPointsBar", label = L["ResourceComboPoints"] },
		},
		ddNamePrefix = "TwintopResourceBar_Rogue_Outlaw",
		overcapConfig = {
			primaryResourceString = L["ResourceEnergy"],
			primaryResourceMax = OUTLAW_MAX_ENERGY,
		},
	})

	yCoord = yCoord - 40
end

local function OutlawConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(4, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.rogue_outlaw or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.outlawDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Outlaw")
	TRB.Options.OptionsFrame:RegisterSpecPanel("rogue", "rogue_outlaw", L["RogueOutlawFull"], interfaceSettingsFrame.outlawDisplayPanel)
	
	parent = interfaceSettingsFrame.outlawDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["RogueOutlawFull"],
		TRB.Data.settings.core.enabled.rogue, "outlaw",
		"TwintopResourceBar_Rogue_Outlaw_outlawRogueEnabled", "outlawRogueEnabled",
		"rogue", "outlaw")

	local tabDefinitions = {
		{ "energyBar", L["TabEnergy"], oUi.tabWidth.small, OutlawConstructEnergyBarPanel, visibilityKey = "primary" },
		{ "comboPointsBar", L["TabComboPoints"], oUi.tabWidth.small, OutlawConstructComboPointsBarPanel, visibilityKey = "secondary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, OutlawConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, OutlawConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, OutlawConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, OutlawConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, OutlawConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, OutlawConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("rogue", "outlaw", controls),
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("rogue", "outlaw", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, OutlawConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) OutlawConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, OutlawConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_outlaw = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

--[[

Subtlety Option Menus

]]

local function SubtletyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_subtlety
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.subtlety = SubtletyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.subtletyDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.subtlety = SubtletyLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextSettings()
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.subtletyDisplayPanel, "barText")
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextSettings(true)
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.subtletyDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextClassic")
	end)

	yCoord = yCoord - 40
end

local function SubtletyConstructEnergyBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], 1, SUBTLETY_MAX_ENERGY)
end

local function SubtletyConstructComboPointsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.fiveComboPoints = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerFive"], spec.colors.comboPoints.fiveComboPoints, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local fiveComboPointsYCoord = yCoord
	f = controls.colors.comboPoints.fiveComboPoints
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "fiveComboPoints")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.fiveComboPoints, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	--[[controls.colors.comboPoints.shadowTechniques = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["RogueSubtletyColorPickerShadowTechniques"], spec.colors.comboPoints.shadowTechniques, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.shadowTechniques
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "shadowTechniques")
	end)]]

	controls.checkBoxes.fiveComboPointOverride = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_fiveComboPointOverride", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fiveComboPointOverride
	f:SetPoint("TOPLEFT", oUi.xCoord, fiveComboPointsYCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxFiveOverride"])
	f.tooltip = L["ComboPointCheckboxFiveOverrideTooltip"]
	f:SetChecked(spec.colors.comboPoints.fiveComboPoints.override)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.fiveComboPoints.override = self:GetChecked()
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.echoingReprimand, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Rogue_Subtlety_ComboPoints", "endCapComboPoints", L["EndCap"], 4, 3)
end

local function SubtletyConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 4, 3, yCoord)
end

local function SubtletyConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 4, 3, yCoord, true, L["ResourceComboPoints"])
end

local function SubtletyConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], "notFull", true, L["ResourceComboPoints"], true)
end

local function SubtletyConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 4, 3, yCoord, {
		barTargetLabels = {
			primary = L["ResourceEnergy"],
		},
		labels = {
			cheapShot = L["RogueSubtletyThresholdCheapShot"],
			crimsonVial = L["RogueSubtletyThresholdCrimsonVial"],
			distract = L["RogueSubtletyThresholdDistract"],
			eviscerate = L["RogueSubtletyThresholdEviscerate"],
			coupDeGrace = L["RogueSubtletyThresholdCoupDeGrace"],
			feint = L["RogueSubtletyThresholdFeint"],
			gouge = L["RogueSubtletyThresholdGouge"],
			kidneyShot = L["RogueSubtletyThresholdKidneyShot"],
			sap = L["RogueSubtletyThresholdSap"],
			shiv = L["RogueSubtletyThresholdShiv"],
			sliceAndDice = L["RogueSubtletyThresholdSliceAndDice"],
			backstab = L["RogueSubtletyThresholdCheckboxBackstab"],
			gloomblade = L["RogueSubtletyThresholdGloomblade"],
			blackPowder = L["RogueSubtletyThresholdBlackPowder"],
			goremawsBite = L["RogueSubtletyThresholdGoremawsBite"],
			secretTechnique = L["RogueSubtletyThresholdSecretTechnique"],
			shadowstrike = L["RogueSubtletyThresholdShadowStrike"],
			shurikenStorm = L["RogueSubtletyThresholdShurikenStorm"],
			shurikenToss = L["RogueSubtletyThresholdShurikenToss"],
			deathFromAbove = L["RogueSubtletyThresholdDeathFromAbove"],
			dismantle = L["RogueSubtletyThresholdDismantle"],
		},
		tooltips = {
			cheapShot = L["RogueSubtletyThresholdCheapShotTooltip"],
			crimsonVial = L["RogueSubtletyThresholdCrimsonVialTooltip"],
			distract = L["RogueSubtletyThresholdDistractTooltip"],
			eviscerate = L["RogueSubtletyThresholdEviscerateTooltip"],
			coupDeGrace = L["RogueSubtletyThresholdCoupDeGraceTooltip"],
			feint = L["RogueSubtletyThresholdFeintTooltip"],
			gouge = L["RogueSubtletyThresholdGougeTooltip"],
			kidneyShot = L["RogueSubtletyThresholdKidneyShotTooltip"],
			sap = L["RogueSubtletyThresholdSapTooltip"],
			shiv = L["RogueSubtletyThresholdShivTooltip"],
			sliceAndDice = L["RogueSubtletyThresholdSliceAndDiceTooltip"],
			backstab = L["RogueSubtletyThresholdCheckboxBackstabTooltip"],
			gloomblade = L["RogueSubtletyThresholdGloombladeTooltip"],
			blackPowder = L["RogueSubtletyThresholdBlackPowderTooltip"],
			goremawsBite = L["RogueSubtletyThresholdGoremawsBiteTooltip"],
			secretTechnique = L["RogueSubtletyThresholdSecretTechniqueTooltip"],
			shadowstrike = L["RogueSubtletyThresholdShadowStrikeTooltip"],
			shurikenStorm = L["RogueSubtletyThresholdShurikenStormTooltip"],
			shurikenToss = L["RogueSubtletyThresholdShurikenTossTooltip"],
			deathFromAbove = L["RogueSubtletyThresholdDeathFromAboveTooltip"],
			dismantle = L["RogueSubtletyThresholdDismantleTooltip"],
		},
	})
end

local function SubtletyConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	controls.colors.threshold = {}

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			colorLocalization = L["RogueSubtletyColorPickerThresholdSpecial"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueSubtletyColorPickerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueSubtletyColorPickerThresholdSpecialEnabledTooltip"]
		},
		{
			name = "echoingReprimand",
			colorLocalization = L["RogueSubtletyColorPickerThresholdEchoingReprimand"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueSubtletyColorPickerThresholdEchoingReprimandEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueSubtletyColorPickerThresholdEchoingReprimandEnabledTooltip"]
		}
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 3, yCoord)
end

local function SubtletyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 4, 3, yCoord)
	
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

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["RogueColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["RogueCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 4, 3, yCoord)
end

local function SubtletyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 4, 3, yCoord, cache)
end

local function SubtletyConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 4
	local specId = 3
	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.rogue_subtlety
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "borderStealth", label = L["RogueCheckboxStealth"], tooltip = L["RogueIndicatorStealthTooltip"], colorLabel = L["RogueIndicatorStealthColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["RogueIndicatorBorderOvercap"], tooltip = L["RogueIndicatorOvercapTooltip"], colorLabel = L["RogueIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "energyBar", label = L["BarNameEnergyBar"] },
			{ key = "comboPointsBar", label = L["ResourceComboPoints"] },
		},
		ddNamePrefix = "TwintopResourceBar_Rogue_Subtlety",
		overcapConfig = {
			primaryResourceString = L["ResourceEnergy"],
			primaryResourceMax = SUBTLETY_MAX_ENERGY,
		},
	})

	yCoord = yCoord - 40
end

local function SubtletyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(4, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.rogue_subtlety or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.subtletyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Subtlety")
	TRB.Options.OptionsFrame:RegisterSpecPanel("rogue", "rogue_subtlety", L["RogueSubtletyFull"], interfaceSettingsFrame.subtletyDisplayPanel)

	parent = interfaceSettingsFrame.subtletyDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["RogueSubtletyFull"],
		TRB.Data.settings.core.enabled.rogue, "subtlety",
		"TwintopResourceBar_Rogue_Subtlety_subtletyRogueEnabled", "subtletyRogueEnabled",
		"rogue", "subtlety")

	local tabDefinitions = {
		{ "energyBar", L["TabEnergy"], oUi.tabWidth.small, SubtletyConstructEnergyBarPanel, visibilityKey = "primary" },
		{ "comboPointsBar", L["TabComboPoints"], oUi.tabWidth.small, SubtletyConstructComboPointsBarPanel, visibilityKey = "secondary" },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, SubtletyConstructHealthBarPanel, visibilityKey = "health" },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, SubtletyConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, SubtletyConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, SubtletyConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, SubtletyConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, SubtletyConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("rogue", "subtlety", controls),
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("rogue", "subtlety", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, SubtletyConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) SubtletyConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, SubtletyConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.rogue_subtlety = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("rogue", L["Rogue"])
	AssassinationConstructOptionsPanel(specCache.rogue_assassination)
	OutlawConstructOptionsPanel(specCache.rogue_outlaw)
	SubtletyConstructOptionsPanel(specCache.rogue_subtlety)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Rogue.ConstructOptionsPanel = ConstructOptionsPanel
