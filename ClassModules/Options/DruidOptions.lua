local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Druid = {}
TRB.Options.Druid.Balance = {}
TRB.Options.Druid.Feral = {}
TRB.Options.Druid.Guardian = {}
TRB.Options.Druid.Restoration = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.druid_balance = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.druid_feral = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.druid_guardian = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.druid_restoration = {}

local BALANCE_MAX_ASTRAL_POWER = 140
local FERAL_MAX_ENERGY = 160
local GUARDIAN_MAX_RAGE = 100


---Loads default bar text settings for Balance
---@param baseSpecId number
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function SharedLoadDefaultBarTextSettings(baseSpecId, classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}
	if classic then
		table.insert(textSettings, {
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
			text="$energy",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=20,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "EnergyBar",
				relativeToFrameName = L["EnergyBar"]
			}
		})
		table.insert(textSettings, {
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
			text="$rage",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=20,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "RageBar",
				relativeToFrameName = L["RageBar"]
			}
		})
	else
		table.insert(textSettings,
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
			text="$energy",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "EnergyBar",
				relativeToFrameName = L["EnergyBar"]
			}
		})
		table.insert(textSettings,
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
			text="$rage",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "RageBar",
				relativeToFrameName = L["RageBar"]
			}
		})
	end

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("manaBar", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

--[[ 
	Balance Defaults
]]

---Loads default bar text settings for Balance
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function BalanceLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}
	

	if classic then
		table.insert(textSettings, {
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
			text="{$casting}[#casting$casting+]$astralPower",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=20,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "AstralPowerBar",
				relativeToFrameName = L["AstralPowerBar"]
			}
		})
		table.insert(textSettings, {
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
			text="{$eclipseTime}[#eclipse $eclipseTime]",
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
				relativeToFrame = "AstralPowerBar",
				relativeToFrameName = L["AstralPowerBar"]
			}
		})
	else
		table.insert(textSettings,
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
			text="$astralPower",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "AstralPowerBar",
				relativeToFrameName = L["AstralPowerBar"]
			}
		})
		table.insert(textSettings, {
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
			text="{$eclipseTime}[#eclipse $eclipseTime]",
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
				relativeToFrame = "AstralPowerBar",
				relativeToFrameName = L["AstralPowerBar"]
			}
		})
	end

	local sharedTextSettings = SharedLoadDefaultBarTextSettings(1, classic)
	for k,v in pairs(sharedTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Druid.BalanceLoadDefaultBarTextSettings = BalanceLoadDefaultBarTextSettings

---Loads default settings for Balance
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function BalanceLoadDefaultSettings(includeBarText, classic)
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
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			specProperties = {
				starsurgeThresholdOnlyOverShow = false,
			},
			thresholdDictionary = {
				starsurge = {
					enabled = true
				},
				starsurge2 = {
					enabled = true
				},
				starsurge3 = {
					enabled = true
				},
				starfall = {
					enabled = true
				},
			}
		},
		maxResource = {
			value = BALANCE_MAX_ASTRAL_POWER,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			mana = { neverShow = true, alwaysShow = false, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			enableFormSwitching = true,
			showComboPoints = false
		},
		endOf = {
			eclipse = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0, { celestialAlignmentOnly = false })
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = BALANCE_MAX_ASTRAL_POWER
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			mana = TRB.Functions.Settings:DefaultManaBarDimensions(classic),
		},
		colors = {
			text = {
				current = {
					color = "FFFFB668"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF00AA00"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				manaBar = {
					color = "FF0000FF"
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = { color = "FFC16920" },
				borderOvercap = { color = "FFFF0000", enabled = true },
				background = { color = "66000000" },
				base = {
					color = "FFFF7C0A",
					color2 = "FFFF7C0A",
					gradientDirection = "disabled"
				},
				lunar = {
					color = "FF144D72",
					color2 = "FF144D72",
					gradientDirection = "disabled",
					enabled = true
				},
				solar = {
					color = "FFFFEE00",
					color2 = "FFFFEE00",
					gradientDirection = "disabled",
					enabled = true
				},
				celestial = {
					color = "FF4A95CE",
					color2 = "FF4A95CE",
					gradientDirection = "disabled",
					enabled = true
				},
				eclipseEnd = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				flashSsEnabled=true,
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			bars = {
				mana = TRB.Functions.Settings:DefaultManaBarColors(),
			},
			threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				},
				starfallPandemic = {
					color = "FF8B0000"
				}
			},
			shared = {
				nodeOrder = {
					"eclipseEnd",
					"celestial",
					"solar",
					"lunar",
				},
				gradientOrder = {
					"borderOvercap",
				},
				indicatorColors = {
					eclipseEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							astralPowerBar = { bar = true, border = false, background = false },
						},
					},
					celestial = {
						color = "FF4A95CE",
						color2 = "FF4A95CE",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							astralPowerBar = { bar = true, border = false, background = false },
						},
					},
					solar = {
						color = "FFFFEE00",
						color2 = "FFFFEE00",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							astralPowerBar = { bar = true, border = false, background = false },
						},
					},
					lunar = {
						color = "FF144D72",
						color2 = "FF144D72",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							astralPowerBar = { bar = true, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							astralPowerBar = { bar = false, border = true, background = false },
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
			ssReady={
				name = L["DruidBalanceAudioStarsurgeReady"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			sfReady={
				name = L["DruidBalanceAudioStarfallReady"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(false, true),
	}

	if includeBarText then
		settings.displayText.barText = BalanceLoadDefaultBarTextSettings(classic)
	end

	return settings
end

--[[ 
	Feral Defaults
]]

---Loads extra default bar text settings for Feral
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FeralLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{$predatorRevealedNextCp=($comboPoints+1)&$comboPoints=0}[$predatorRevealedTickTime]{$incarnationNextCp=($comboPoints+1)&$comboPoints=0}[$incarnationTickTime]",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			name = "CP1",
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["ComboPoint1"],
				yPos = 0,
				relativeToFrame = "ComboPoint_1",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			fontSize = 14,
			color = { color = "ffffffff" },
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=1)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=0)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=1)||($incarnationNextCp=($comboPoints+2)&$comboPoints=0)}[$incarnationTickTime]",
			color = { color = "ffffffff" },
			name = "CP2",
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["ComboPoint2"],
				yPos = 0,
				relativeToFrame = "ComboPoint_2",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			fontSize = 14,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=2)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=1)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=2)||($incarnationNextCp=($comboPoints+2)&$comboPoints=1)}[$incarnationTickTime]",
			color = { color = "ffffffff" },
			name = "CP3",
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["ComboPoint3"],
				yPos = 0,
				relativeToFrame = "ComboPoint_3",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			fontSize = 14,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=3)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=2)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=3)||($incarnationNextCp=($comboPoints+2)&$comboPoints=2)}[$incarnationTickTime]",
			color = { color = "ffffffff" },
			name = "CP4",
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = -3,
				relativeToFrameName = L["ComboPoint4"],
				yPos = 0,
				relativeToFrame = "ComboPoint_4",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			fontSize = 14,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=4)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=3)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=4)||($incarnationNextCp=($comboPoints+2)&$comboPoints=3)}[$incarnationTickTime]",
			color = { color = "ffffffff" },
			name = "CP5",
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["ComboPoint5"],
				yPos = 0,
				relativeToFrame = "ComboPoint_5",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			fontSize = 14,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
		}
	}

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

---Loads default bar text settings for Feral
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FeralLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("berserkTime", "berserk", classic, "CENTER", "RIGHT"))

	local sharedTextSettings = SharedLoadDefaultBarTextSettings(2, classic)
	for k,v in pairs(sharedTextSettings) do table.insert(textSettings, v) end

	local extraTextSettings = FeralLoadExtraBarTextSettings(classic)
	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Druid.FeralLoadDefaultBarTextSettings = FeralLoadDefaultBarTextSettings

---Loads default settings for Feral
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function FeralLoadDefaultSettings(includeBarText, classic)
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
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
            thresholdDictionary = {
				feralFrenzy = {
					enabled = true,
				},
				franticFrenzy = {
					enabled = true,
				},
				ferociousBiteMaximum = {
					enabled = true,
				},
				ferociousBiteMinimum = {
					enabled = false,
				},
				frenziedRegeneration = {
					enabled = false,
				},
				maim = {
					enabled = false,
				},
				moonfire = {
					enabled = false,
				},
				primalWrath = {
					enabled = true,
				},
				rake = {
					enabled = false,
				},
				ravageMaximum = {
					enabled = true,
				},
				ravageMinimum = {
					enabled = false,
				},
				rip = {
					enabled = false,
				},
				shred = {
					enabled = false,
				},
				swipe = {
					enabled = false,
				},
            }
		},
		maxResource = {
			value = FERAL_MAX_ENERGY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			enableFormSwitching = true,
			showComboPoints = true
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = FERAL_MAX_ENERGY
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
				border = { color = "FFFF7C0A" },
				borderOvercap = { color = "FFFF0000", enabled = true },
				borderStealth = { color = "FF000000", enabled = true },
				background = { color = "66000000" },
				base = {
					color = "FFFFFF00",
					color2 = "FFFFFF00",
					gradientDirection = "disabled"
				},
				clearcasting = {
					color = "FF4A95CE",
					color2 = "FF4A95CE",
					gradientDirection = "disabled",
					enabled = true
				},
				maxBite = {
					color = "FF009900",
					color2 = "FF009900",
					gradientDirection = "disabled",
					enabled = true
				},
				apexPredator = {
					color = "FFE75480",
					color2 = "FFE75480",
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
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			comboPoints = {
				border = { color = "FFFF7C0A" },
				background = { color = "66000000" },
				base = {
					color = "FFFFFF00",
					color2 = "FFFFFF00",
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
				generation = true
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
			},
			shared = {
				nodeOrder = {
					"apexPredator",
					"ravage",
					"borderStealth",
				},
				gradientOrder = {
					"maxBite",
					"borderOvercap",
				},
				indicatorColors = {
					apexPredator = {
						color = "FFE75480",
						color2 = "FFE75480",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							energyBar = { bar = true, border = false, background = false },
						},
					},
					ravage = {
						color = "FFF4B183",
						color2 = "FFF4B183",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							comboPoints = { bar = true, border = false, background = false },
						},
					},
					borderStealth = {
						color = "FF000000",
						enabled = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
						},
					},
					maxBite = {
						color = "FF009900",
						enabled = true,
						isGradient = true,
						targets = {
							energyBar = { bar = true, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							energyBar = { bar = false, border = true, background = false },
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
			apexPredatorsCraving={
				name = L["DruidFeralAudioApexPredatorsCravingProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			comboPointThreshold1={
				name = L["DruidFeralAudioComboPointThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 3
				}
			},
			comboPointThreshold2={
				name = L["DruidFeralAudioComboPointThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}
	
	if includeBarText then
		settings.displayText.barText = FeralLoadDefaultBarTextSettings(classic)
	end

	return settings
end

--[[ 
	Guardian Defaults
]]

---Loads default bar text settings for Guardian
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function GuardianLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("berserkTime", "berserk", classic, "CENTER", "RIGHT"))

	local sharedTextSettings = SharedLoadDefaultBarTextSettings(3, classic)
	for k,v in pairs(sharedTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Druid.GuardianLoadDefaultBarTextSettings = GuardianLoadDefaultBarTextSettings

---Loads default settings for Guardian
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function GuardianLoadDefaultSettings(includeBarText, classic)
	local settings = {
		enabled = true,
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				ironfur = {
					enabled = true,
				},
				maul = {
					enabled = true,
				},
				maulKillingBlow = {
					enabled = true,
				},
				maulHarnessedRage = {
					enabled = true,
				},
				raze = {
					enabled = true,
				},
				razeKillingBlow = {
					enabled = true,
				},
				razeHarnessedRage = {
					enabled = true,
				},
				frenziedRegeneration = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = GUARDIAN_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			enableFormSwitching = true,
			showComboPoints = false
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = GUARDIAN_MAX_RAGE
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOf = {
			berserk = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		colors = {
			text = {
				current = {
					color = "FFFF0000"
				},
				passive = {
					color = "FFEA3C53"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FF800000",
					enabled = true
				},
			},
			bar = {
				border = { color = "FFC21807" },
				borderOvercap = { color = "FF800000", enabled = true },
				background = { color = "66000000" },
				base = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				berserk = {
					color = "FFFFCC55",
					color2 = "FFFFCC55",
					gradientDirection = "disabled",
					enabled = true
				},
				berserkEnd = {
					color = "FFFF5555",
					color2 = "FFFF5555",
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
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			shared = {
				nodeOrder = {
					"berserkEnd",
					"berserk",
				},
				gradientOrder = {
					"borderOvercap",
				},
				indicatorColors = {
					berserkEnd = {
						color = "FFFF5555",
						color2 = "FFFF5555",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							rageBar = { bar = true, border = false, background = false },
						},
					},
					berserk = {
						color = "FFFFCC55",
						color2 = "FFFFCC55",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							rageBar = { bar = true, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FF800000",
						enabled = true,
						isGradient = true,
						targets = {
							rageBar = { bar = false, border = true, background = false },
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
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = GuardianLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Restoration
---Loads default bar text settings for Restoration
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function RestorationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("incarnationTime", "incarnation", classic, "CENTER", "CENTER"))

	local sharedTextSettings = SharedLoadDefaultBarTextSettings(4, classic)
	for k,v in pairs(sharedTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Druid.RestorationLoadDefaultBarTextSettings = RestorationLoadDefaultBarTextSettings

---Loads default settings for Restoration
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function RestorationLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			enableFormSwitching = true,
			showComboPoints = false
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOf = {
			incarnation = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
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
				border = { color = "FF000099" },
				background = { color = "66000000" },
				base = {
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				noEfflorescence = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled",
					enabled = true
				},
				clearcasting = {
					color = "FF4A95CE",
					color2 = "FF4A95CE",
					gradientDirection = "disabled",
					enabled = true
				},
				incarnation = {
					color = "FF005500",
					color2 = "FF005500",
					gradientDirection = "disabled",
					enabled = true
				},
				incarnationEnd = {
					color = "FFDD5500",
					color2 = "FFDD5500",
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
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				}
			},
			shared = {
				nodeOrder = {
					"incarnationEnd",
					"incarnation",
					"noEfflorescence",
				},
				gradientOrder = {},
				indicatorColors = {
					incarnationEnd = {
						color = "FFDD5500",
						color2 = "FFDD5500",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
						},
					},
					incarnation = {
						color = "FF005500",
						color2 = "FF005500",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
						},
					},
					noEfflorescence = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
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
		settings.displayText.barText = RestorationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Druid
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.druid.balance = BalanceLoadDefaultSettings(includeBarText, classic)
	settings.druid.feral = FeralLoadDefaultSettings(includeBarText, classic)
	settings.druid.guardian = GuardianLoadDefaultSettings(includeBarText, classic)
	settings.druid.restoration = RestorationLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Druid.LoadDefaultSettings = LoadDefaultSettings

--[[

	Balance Option Menus

]]

local function BalanceConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.druid_balance
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Druid_Balance_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.balance = BalanceLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.balance = BalanceLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BalanceLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BalanceLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function BalanceConstructAstralPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], 1, BALANCE_MAX_ASTRAL_POWER)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateFlashOptions(parent, controls, spec, 11, 1, yCoord, L["DruidBalanceStarsurge"], L["DruidBalanceStarsurge"])
end

local function BalanceConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceAstralPower"])

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 11, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))
end

local function BalanceConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 1, yCoord)
end

local function BalanceConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, 11, 1, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "eclipseEnd",  label = L["DruidBalanceCheckboxEclipseEnding"],  tooltip = L["DruidBalanceIndicatorEclipseEndTooltip"],  colorLabel = L["DruidBalanceIndicatorEclipseEndColor"] },
			{ key = "celestial",   label = L["DruidBalanceCheckboxCelestial"],       tooltip = L["DruidBalanceIndicatorCelestialTooltip"],   colorLabel = L["DruidBalanceColorPickerCelestialAlignment"] },
			{ key = "solar",       label = L["DruidBalanceCheckboxSolar"],           tooltip = L["DruidBalanceIndicatorSolarTooltip"],       colorLabel = L["DruidBalanceColorPickerEclipseSolar"] },
			{ key = "lunar",       label = L["DruidBalanceCheckboxLunar"],           tooltip = L["DruidBalanceIndicatorLunarTooltip"],       colorLabel = L["DruidBalanceColorPickerEclipseLunar"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["CheckboxOvercap"], tooltip = L["DruidBalanceIndicatorBorderOvercapTooltip"], colorLabel = L["DruidBalanceIndicatorBorderOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "astralPowerBar", label = L["BarNameAstralPowerBar"] },
			{ key = "comboPoints",    label = L["BarNameComboPoints"] },
			{ key = "manaBar",        label = L["BarNameManaBar"] },
			{ key = "energyBar",      label = L["BarNameEnergyBar"] },
			{ key = "rageBar",        label = L["BarNameRageBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Druid_Balance",
		endOfConfigs = {
			{
				endOfKey = "eclipse",
				sectionHeader = L["DruidBalanceHeaderEndOfEclipseConfiguration"],
				gcdRadioLabel = L["DruidBalanceCheckboxEclipseGcds"],
				gcdSliderLabel = L["DruidBalanceEclipseGcds"],
				timeRadioLabel = L["DruidBalanceCheckboxEclipseTime"],
				timeSliderLabel = L["DruidBalanceEclipseTime"],
			},
		},
		overcapConfig = { primaryResourceString = L["ResourceAstralPower"], primaryResourceMax = BALANCE_MAX_ASTRAL_POWER },
	}))

	yCoord = yCoord - 40

	-- Celestial Alignment Only checkbox (Balance-specific: only show eclipse ending color during CA/IoCoE)
	local f = nil
	controls.checkBoxes.endOfEclipseOnly = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_EOE_CAO", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfEclipseOnly
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceCheckboxEndOfEclipseOnlyCelestial"])
	f.tooltip = L["DruidBalanceCheckboxEndOfEclipseOnlyCelestialTooltip"]
	f:SetChecked(spec.endOf.eclipse.celestialAlignmentOnly)
	f:SetScript("OnClick", function(self, ...)
		spec.endOf.eclipse.celestialAlignmentOnly = self:GetChecked()
	end)

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_balance = controls
end

local function BalanceConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 1, yCoord, false, nil, true)
end

local function BalanceConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5
	local f = nil

	yCoord = yCoord - 5
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 1) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	controls.checkBoxes.showComboPoints = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_ShowComboPoints", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showComboPoints
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxShowComboPoints"])
	f.tooltip = L["DruidCheckboxShowComboPointsTooltip"]
	f:SetChecked(spec.displayBar.showComboPoints)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.showComboPoints = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 1) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:FillSpecializationCacheSettings("druid", "balance")
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:RefreshWrapperPositioning()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Functions.Bar:HideResourceBar()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	yCoord = yCoord - 25
	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], "balance", true, L["ResourceComboPoints"], true, true)
end

local function BalanceConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Balance_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Druid_Balance_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 11, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.sfThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starfallEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sfThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarfall"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarfallTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.starfall.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.starfall.enabled = self:GetChecked()

		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local thresholds = primaryNode:GetThresholds()
				if thresholds and thresholds[4] then
					if spec.thresholds.thresholdDictionary.starfall.enabled then
						thresholds[4]:Show()
					else
						thresholds[4]:Hide()
					end
				end
			end
		end
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ssThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurgeEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarsurge"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarsurgeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.starsurge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.starsurge.enabled = self:GetChecked()

		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local thresholds = primaryNode:GetThresholds()
				if thresholds and thresholds[1] then
					if spec.thresholds.thresholdDictionary.starsurge.enabled then
						thresholds[1]:Show()
					else
						thresholds[1]:Hide()
					end
				end
			end
		end
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ssThreshold2Show = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurge2Enabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThreshold2Show
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarsurge2x"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarsurge2xTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.starsurge2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.starsurge2.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ssThreshold3Show = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurge3Enabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThreshold3Show
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarsurge3x"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarsurge3xTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.starsurge3.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.starsurge3.enabled = self:GetChecked()
	end)
	yCoord = yCoord - 25
	controls.checkBoxes.ssThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurgeOnlyOver", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThresholdOnlyOverShow
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxOnlyCurrentNext"])
	f.tooltip = L["DruidBalanceThresholdCheckboxOnlyCurrentNextTooltip"]
	f:SetChecked(spec.thresholds.specProperties.starsurgeThresholdOnlyOverShow)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.specProperties.starsurgeThresholdOnlyOverShow = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		--[[{
			name = "starfallPandemic",
			colorLocalization = L["DruidBalanceThresholdStarfallPandemic"]
		}]]
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], true, true, false, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 1, yCoord)
end

local function BalanceConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Balance_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Druid_Balance_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidBalanceTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_Druid_Balance_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidBalanceCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_Druid_Balance_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidBalanceCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	spec.colors.text.manaBar = spec.colors.text.manaBar or { color = "FF0000FF" }
	controls.colors.text.manaBar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ManaBarTextColor"], spec.colors.text.manaBar.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.manaBar
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "manaBar")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 11, 1, yCoord)
end

local function BalanceConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 11
	local specId = 1
	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5

	controls.buttons.exportButton_Druid_Balance_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Druid_Balance_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "ssReady", spec, classId, specId, yCoord, L["DruidBalanceAudioStarsurgeCheckbox"], L["DruidBalanceAudioStarsurgeCheckboxTooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "sfReady", spec, classId, specId, yCoord, L["DruidBalanceAudioStarfallCheckbox"], L["DruidBalanceAudioStarfallCheckboxTooltip"])

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "starweaversReady", spec, classId, specId, yCoord, L["DruidBalanceAudioStarweaverCheckbox"], L["DruidBalanceAudioStarweaverCheckboxTooltip"])
end

local function BalanceConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_balance
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Balance_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Druid_Balance_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 1, yCoord, cache)
end

local function BalanceConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(11, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.druid_balance or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.balanceDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Balance")
	TRB.Options.OptionsFrame:RegisterSpecPanel("druid", "druid_balance", L["DruidBalanceFull"], interfaceSettingsFrame.balanceDisplayPanel)

	parent = interfaceSettingsFrame.balanceDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DruidBalanceFull"],
		TRB.Data.settings.core.enabled.druid, "balance",
		"TwintopResourceBar_Druid_Balance_balanceDruidEnabled", "balanceDruidEnabled",
		"exportButton_Druid_Balance_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 1, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_balance = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "astralPowerBar", label = L["TabAstralPower"], width = oUi.tabWidth.small, constructor = BalanceConstructAstralPowerBarPanel },
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = BalanceConstructManaBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = BalanceConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = BalanceConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = BalanceConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = BalanceConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = BalanceConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = BalanceConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = BalanceConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) BalanceConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = BalanceConstructResetDefaultsPanel },
	}, yCoord)
end


--[[

Feral Option Menus

]]

local function FeralConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.druid_feral
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Druid_Feral_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DruidFeralFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.feral = FeralLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DruidFeralFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.feral = FeralLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DruidFeralFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FeralLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DruidFeralFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FeralLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FeralConstructEnergyBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], 1, FERAL_MAX_ENERGY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_feral = controls
end

local function FeralConstructComboPointsBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)

	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.checkBoxes.generationComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_comboPointsGeneration", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.generationComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralCheckboxShowIncomingGeneration"])
	f.tooltip = L["DruidFeralCheckboxShowIncomingGeneration"]
	f:SetChecked(spec.colors.comboPoints.generation)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.generation = self:GetChecked()
	end)

	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)
end

local function FeralConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 2, yCoord)
end

local function FeralConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, 11, 2, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "apexPredator",   label = L["DruidFeralCheckboxApexPredator"],  tooltip = L["DruidFeralIndicatorApexPredatorTooltip"],    colorLabel = L["DruidFeralIndicatorApexPredatorColor"] },
			{ key = "ravage",        label = L["DruidFeralCheckboxRavage"],        tooltip = L["DruidFeralIndicatorRavageTooltip"],          colorLabel = L["DruidFeralIndicatorRavageColor"] },
			{ key = "borderStealth",  label = L["CheckboxBorderStealth"],           tooltip = L["DruidFeralIndicatorBorderStealthTooltip"],   colorLabel = L["DruidFeralIndicatorBorderStealthColor"] },
		},
		gradientDefs = {
			{ key = "maxBite",       label = L["DruidFeralCheckboxMaxBite"],        tooltip = L["DruidFeralIndicatorMaxBiteTooltip"],         colorLabel = L["DruidFeralIndicatorMaxBiteColor"] },
			{ key = "borderOvercap", label = L["CheckboxOvercap"],                  tooltip = L["DruidFeralIndicatorBorderOvercapTooltip"],   colorLabel = L["DruidFeralIndicatorBorderOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "energyBar",    label = L["BarNameEnergyBar"] },
			{ key = "comboPoints",  label = L["BarNameComboPoints"] },
			{ key = "manaBar",      label = L["BarNameManaBar"] },
			{ key = "rageBar",      label = L["BarNameRageBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Druid_Feral",
		overcapConfig = { primaryResourceString = L["ResourceEnergy"], primaryResourceMax = FERAL_MAX_ENERGY },
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_feral = controls
end

local function FeralConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 2, yCoord, true)
end

local function FeralConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5
	local f = nil

	yCoord = yCoord - 5
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 2) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:ResetCaches()
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	controls.checkBoxes.showComboPoints = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Checkbox_ShowComboPoints", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showComboPoints
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxShowComboPoints"])
	f.tooltip = L["DruidCheckboxShowComboPointsTooltip"]
	f:SetChecked(spec.displayBar.showComboPoints)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.showComboPoints = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 2) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:FillSpecializationCacheSettings("druid", "feral")
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:RefreshWrapperPositioning()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Functions.Bar:HideResourceBar()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	yCoord = yCoord - 25
	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], "notFull", true, L["ResourceComboPoints"], true)
end

local function FeralConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Feral_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Druid_Feral_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 11, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord
		
	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.feralFrenzyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_feralfrenzy", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feralFrenzyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFeralFrenzyFranticFrenzy"])
	f.tooltip = L["DruidFeralThresholdCheckboxFeralFrenzyFranticFrenzyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.feralFrenzy.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.feralFrenzy.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.franticFrenzy.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.moonfireThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_moonfire", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.moonfireThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxMoonfire"])
	f.tooltip = L["DruidFeralThresholdCheckboxMoonfireTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.moonfire.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.moonfire.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.rakeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_rake", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rakeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxRake"])
	f.tooltip = L["DruidFeralThresholdCheckboxRakeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rake.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rake.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.shredThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_shred", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shredThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxShred"])
	f.tooltip = L["DruidFeralThresholdCheckboxShredTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shred.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shred.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.swipeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_swipe", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.swipeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxSwipe"])
	f.tooltip = L["DruidFeralThresholdCheckboxSwipeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.swipe.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.swipe.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25

	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.labels.ferociousBite = TRB.Functions.OptionsUi:BuildLabel(parent, L["DruidFeralThresholdLabelFerociousBite"], oUi.xCoord2, yCoord2, 300, 20, GameFontWhite)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.ferociousBiteMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBiteMinimum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ferociousBiteMinimumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFerociousBiteMinimum"])
	f.tooltip = L["DruidFeralThresholdCheckboxFerociousBiteMinimumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ferociousBiteMinimum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ferociousBiteMinimum.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.ravageMinimum.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.ferociousBiteMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBiteMaximum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ferociousBiteMaximumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFerociousBiteMaximum"])
	f.tooltip = L["DruidFeralThresholdCheckboxFerociousBiteMaximumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ferociousBiteMaximum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ferociousBiteMaximum.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.ravageMaximum.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.maimThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_maim", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maimThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxMaim"])
	f.tooltip = L["DruidFeralThresholdCheckboxMaimTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.maim.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.maim.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.primalWrathThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_primalWrath", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.primalWrathThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxPrimalWrath"])
	f.tooltip = L["DruidFeralThresholdCheckboxPrimalWrathTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.primalWrath.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.primalWrath.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.ripThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_rip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ripThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxRip"])
	f.tooltip = L["DruidFeralThresholdCheckboxRipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rip.enabled = self:GetChecked()
	end)

	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.frenziedRegenerationThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_frenziedRegeneration", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.frenziedRegenerationThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFrenziedRegeneration"])
	f.tooltip = L["DruidFeralThresholdCheckboxFrenziedRegenerationTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.frenziedRegeneration.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.frenziedRegeneration.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 2, yCoord)
end

local function FeralConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Feral_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Druid_Feral_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 11, 2, yCoord)
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidFeralCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 120
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 11, 2, yCoord)
end

local function FeralConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 11
	local specId = 2
	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Feral_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Druid_Feral_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "apexPredatorsCraving", spec, classId, specId, yCoord, L["DruidFeralCheckboxApexPredatorsCravingProc"], L["DruidFeralCheckboxApexPredatorsCravingProcTooltip"])

	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "comboPointThreshold1", spec, classId, specId, yCoord, L["DruidFeralAudioCheckboxComboPointThreshold1"], L["DruidFeralAudioCheckboxComboPointThreshold1Tooltip"])

	controls.comboPointThreshold1Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["DruidFeralComboPointThresholdSliderTitle"], 0, 5, spec.audio["comboPointThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.comboPointThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["comboPointThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "comboPointThreshold2", spec, classId, specId, yCoord, L["DruidFeralAudioCheckboxComboPointThreshold2"], L["DruidFeralAudioCheckboxComboPointThreshold2Tooltip"])

	controls.comboPointThreshold2Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["DruidFeralComboPointThresholdSliderTitle"], 0, 5, spec.audio["comboPointThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.comboPointThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["comboPointThreshold2"].configuration.thresholdValue = value
	end)
end

local function FeralConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_feral
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Feral_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Druid_Feral_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 2, yCoord, cache)
end

local function FeralConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(11, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.druid_feral or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.feralDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Feral")
	TRB.Options.OptionsFrame:RegisterSpecPanel("druid", "druid_feral", L["DruidFeralFull"], interfaceSettingsFrame.feralDisplayPanel)

	parent = interfaceSettingsFrame.feralDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DruidFeralFull"],
		TRB.Data.settings.core.enabled.druid, "feral",
		"TwintopResourceBar_Druid_Feral_feralDruidEnabled", "feralDruidEnabled",
		"exportButton_Druid_Feral_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 2, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_feral = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "energyBar", label = L["TabEnergy"], width = oUi.tabWidth.small, constructor = FeralConstructEnergyBarPanel },
		{ key = "comboPointsBar", label = L["TabComboPoints"], width = oUi.tabWidth.small, constructor = FeralConstructComboPointsBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = FeralConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = FeralConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = FeralConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = FeralConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = FeralConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = FeralConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = FeralConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) FeralConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = FeralConstructResetDefaultsPanel },
	}, yCoord)
end

--[[

Guardian Druid

]]

local function GuardianConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.druid_guardian
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Druid_Guardian_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DruidGuardianFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.guardian = GuardianLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Guardian_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DruidGuardianFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.guardian = GuardianLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Guardian_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DruidGuardianFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = GuardianLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Guardian_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DruidGuardianFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = GuardianLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Druid_Guardian_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Guardian_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Guardian_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Guardian_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function GuardianConstructRageBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], 1, GUARDIAN_MAX_RAGE)

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_guardian = controls
end

local function GuardianConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 3, yCoord)
end

local function GuardianConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, 11, 3, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "berserkEnd",    label = L["DruidGuardianCheckboxBerserkEnding"],  tooltip = L["DruidGuardianIndicatorBerserkEndTooltip"],      colorLabel = L["DruidGuardianIndicatorBerserkEndColor"] },
			{ key = "berserk",       label = L["DruidGuardianCheckboxBerserkActive"],  tooltip = L["DruidGuardianIndicatorBerserkTooltip"],         colorLabel = L["DruidGuardianIndicatorBerserkColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["CheckboxOvercap"],                     tooltip = L["DruidGuardianIndicatorBorderOvercapTooltip"],   colorLabel = L["DruidGuardianIndicatorBorderOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "rageBar",      label = L["BarNameRageBar"] },
			{ key = "comboPoints",  label = L["BarNameComboPoints"] },
			{ key = "manaBar",      label = L["BarNameManaBar"] },
			{ key = "energyBar",    label = L["BarNameEnergyBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Druid_Guardian",
		endOfConfigs = {
			{
				endOfKey = "berserk",
				sectionHeader = L["DruidGuardianEndOfBerserkConfigurationHeader"],
				gcdRadioLabel = L["DruidGuardianCheckboxBerserkGcds"],
				gcdSliderLabel = L["DruidGuardianBerserkGcds"],
				timeRadioLabel = L["DruidGuardianCheckboxBerserkTime"],
				timeSliderLabel = L["DruidGuardianBerserkTime"],
			},
		},
		overcapConfig = { primaryResourceString = L["ResourceRage"], primaryResourceMax = GUARDIAN_MAX_RAGE },
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_guardian = controls
end

local function GuardianConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 3, yCoord, false)
end

local function GuardianConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5
	local f = nil

	yCoord = yCoord - 5
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 3) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	controls.checkBoxes.showComboPoints = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Checkbox_ShowComboPoints", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showComboPoints
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxShowComboPoints"])
	f.tooltip = L["DruidCheckboxShowComboPointsTooltip"]
	f:SetChecked(spec.displayBar.showComboPoints)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.showComboPoints = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 3) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:FillSpecializationCacheSettings("druid", "guardian")
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:RefreshWrapperPositioning()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Functions.Bar:HideResourceBar()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	yCoord = yCoord - 25
	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], "guardian", true, L["ResourceComboPoints"], true)
end

local function GuardianConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Guardian_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarDisplay"], yCoord-5)
	controls.buttons.exportButton_Druid_Guardian_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 11, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.frenziedRegenerationThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Threshold_Option_frenziedRegeneration", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.frenziedRegenerationThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianThresholdCheckboxFrenziedRegeneration"])
	f.tooltip = L["DruidGuardianThresholdCheckboxFrenziedRegenerationTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.frenziedRegeneration.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.frenziedRegeneration.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ironfurThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Threshold_Option_ironfur", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ironfurThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianThresholdCheckboxIronfur"])
	f.tooltip = L["DruidGuardianThresholdCheckboxIronfurTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ironfur.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ironfur.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.maulThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Threshold_Option_maul", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maulThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianThresholdCheckboxMaulRaze"])
	f.tooltip = L["DruidGuardianThresholdCheckboxMaulRazeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.maul.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.maul.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.raze.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.maulKillingBlowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Threshold_Option_maulKillingBlow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maulKillingBlowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianThresholdCheckboxMaulRazeKillingBlow"])
	f.tooltip = L["DruidGuardianThresholdCheckboxMaulRazeKillingBlowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.maulKillingBlow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.maulKillingBlow.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.razeKillingBlow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.maulHarnessedRageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Threshold_Option_maulHarnessedRage", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maulHarnessedRageThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianThresholdCheckboxMaulRazeHarnessedRage"])
	f.tooltip = L["DruidGuardianThresholdCheckboxMaulRazeHarnessedRageTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.maulHarnessedRage.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.maulHarnessedRage.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.razeHarnessedRage.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 3, yCoord)
end

local function GuardianConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Guardian_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Druid_Guardian_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidGuardianTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianTextColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianTextColorPickerOverThreshold"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_OverThreshold_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidGuardianCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_OvercapText_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidGuardianCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 11, 3, yCoord)

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_guardian = controls
end

local function GuardianConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Guardian_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Druid_Guardian_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 3, false, false, false, true, false, false)
	end)

	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
end

local function GuardianConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_guardian
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Guardian_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Druid_Guardian_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	local spec = TRB.Data.settings.druid.guardian
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 3, yCoord, cache)
end

local function GuardianConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(11, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.druid_guardian or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.guardianDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Guardian")
	TRB.Options.OptionsFrame:RegisterSpecPanel("druid", "druid_guardian", L["DruidGuardianFull"], interfaceSettingsFrame.guardianDisplayPanel)

	parent = interfaceSettingsFrame.guardianDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DruidGuardianFull"],
		TRB.Data.settings.core.enabled.druid, "guardian",
		"TwintopResourceBar_Druid_Guardian_guardianDruidEnabled", "guardianDruidEnabled",
		"exportButton_Druid_Guardian_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 3, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_guardian = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "rageBar", label = L["TabRage"], width = oUi.tabWidth.small, constructor = GuardianConstructRageBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = GuardianConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = GuardianConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = GuardianConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = GuardianConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = GuardianConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = GuardianConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) GuardianConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = GuardianConstructResetDefaultsPanel },
	}, yCoord)
end

--[[

Restoration Druid

]]

local function RestorationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.druid_restoration
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.restoration = RestorationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.druid.restoration = RestorationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function RestorationConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"])
end

local function RestorationConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 4, yCoord)
end

local function RestorationConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, 11, 4, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "incarnationEnd",    label = L["DruidRestorationCheckboxIncarnationEnding"],  tooltip = L["DruidRestorationIndicatorIncarnationEndTooltip"],      colorLabel = L["DruidRestorationIndicatorIncarnationEndColor"] },
			{ key = "incarnation",       label = L["DruidRestorationCheckboxIncarnation"],        tooltip = L["DruidRestorationIndicatorIncarnationTooltip"],         colorLabel = L["DruidRestorationIndicatorIncarnationColor"] },
			{ key = "noEfflorescence",   label = L["DruidRestorationCheckboxNoEfflorescence"],    tooltip = L["DruidRestorationIndicatorNoEfflorescenceTooltip"],     colorLabel = L["DruidRestorationIndicatorNoEfflorescenceColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar",      label = L["BarNameManaBar"] },
			{ key = "comboPoints",  label = L["BarNameComboPoints"] },
			{ key = "energyBar",    label = L["BarNameEnergyBar"] },
			{ key = "rageBar",      label = L["BarNameRageBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Druid_Restoration",
		endOfConfigs = {
			{
				endOfKey = "incarnation",
				sectionHeader = L["DruidRestorationEndOfIncarnationConfigurationHeader"],
				gcdRadioLabel = L["DruidRestorationCheckboxIncarnationGcds"],
				gcdSliderLabel = L["DruidRestorationIncarnationGcds"],
				timeRadioLabel = L["DruidRestorationCheckboxIncarnationTime"],
				timeSliderLabel = L["DruidRestorationIncarnationTime"],
			},
		},
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_restoration = controls
end

local function RestorationConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 4, yCoord, false)
end

local function RestorationConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5
	local f = nil

	yCoord = yCoord - 5
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 4) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	controls.checkBoxes.showComboPoints = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Checkbox_ShowComboPoints", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showComboPoints
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxShowComboPoints"])
	f.tooltip = L["DruidCheckboxShowComboPointsTooltip"]
	f:SetChecked(spec.displayBar.showComboPoints)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.showComboPoints = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(11, 4) then
			-- Clear all caches before rebuilding
			TRB.Functions.Character:FillSpecializationCacheSettings("druid", "restoration")
			TRB.Functions.Character:ResetCaches()
			TRB.Data.cache.colors.border = {}
			TRB.Data.cache.colors.backdrop = {}
			-- Destroy and recreate bar groups to add/remove secondary bar
			TRB.Functions.Bar:DestroyBarGroups()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:RefreshWrapperPositioning()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Functions.Bar:HideResourceBar()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
			TRB.Functions.Character:ResetColorCaches()
			TRB.Data.cache.values.frame = {}
		end
	end)

	yCoord = yCoord - 25
	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"], "notFull", true, L["ResourceComboPoints"], true)
end

local function RestorationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5
	local f = nil
end

local function RestorationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Druid_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 4, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 11, 4, yCoord)
end

local function RestorationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 11
	local specId = 4
	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Druid_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function RestorationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.druid_restoration
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Restoration_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Druid_Restoration_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 4, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 4, yCoord, cache)
end

local function RestorationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(11, 4)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.druid_restoration or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.restorationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Restoration")
	TRB.Options.OptionsFrame:RegisterSpecPanel("druid", "druid_restoration", L["DruidRestorationFull"], interfaceSettingsFrame.restorationDisplayPanel)

	parent = interfaceSettingsFrame.restorationDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DruidRestorationFull"],
		TRB.Data.settings.core.enabled.druid, "restoration",
		"TwintopResourceBar_Druid_Restoration_restorationDruidEnabled", "restorationDruidEnabled",
		"exportButton_Druid_Restoration_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 4, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.druid_restoration = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = RestorationConstructManaBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = RestorationConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = RestorationConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = RestorationConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = RestorationConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = RestorationConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) RestorationConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = RestorationConstructResetDefaultsPanel },
	}, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("druid", L["Druid"])
	BalanceConstructOptionsPanel(specCache.druid_balance)
	FeralConstructOptionsPanel(specCache.druid_feral)
	GuardianConstructOptionsPanel(specCache.druid_guardian)
	RestorationConstructOptionsPanel(specCache.druid_restoration)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Druid.ConstructOptionsPanel = ConstructOptionsPanel
