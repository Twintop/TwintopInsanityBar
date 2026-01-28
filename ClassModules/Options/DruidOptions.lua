local _, TRB = ...
if TRB.Data.character.classId ~= 11 then --Only do this if we're on a Druid!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Druid = {}
TRB.Options.Druid.Balance = {}
TRB.Options.Druid.Feral = {}
TRB.Options.Druid.Guardian = {}
TRB.Options.Druid.Restoration = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.balance = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.feral = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.guardian = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = {}

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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$energy",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=20,
			color = "FFFFFFFF",
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$rage",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=20,
			color = "FFFFFFFF",
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$energy",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = "FFFFFFFF",
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$rage",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = "FFFFFFFF",
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
	return textSettings
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting+]$astralPower",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=20,
			color = "FFFFFFFF",
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="{$eclipseTime}[#eclipse $eclipseTime]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=14,
			color = "FFFFFFFF",
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$astralPower",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = "FFFFFFFF",
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$eclipseTime}[#eclipse $eclipseTime]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			color = "FFFFFFFF",
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
	return textSettings
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
			icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
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
			primary = "always",
			secondary = "always",
			health = "always",
			mana = "never",
			dragonriding = true,
			enableFormSwitching = true
		},
		endOfEclipse = {
			enabled=true,
			celestialAlignmentOnly=false,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
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
				border="FFC16920",
				overcapEnabled=true,
				borderOvercap="FFFF0000",
				background="66000000",
				base="FFFF7C0A",
				lunar="FF144D72",
				solar="FFFFEE00",
				celestial="FF4A95CE",
				eclipse1GCD="FFFF0000",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				flashSsEnabled=true,
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
			}
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
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
			starweaversReady={
				name = L["DruidBalanceAudioStarweaverReady"],
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
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{$predatorRevealedNextCp=($comboPoints+1)&$comboPoints=0}[$predatorRevealedTickTime]{$incarnationNextCp=($comboPoints+1)&$comboPoints=0}[$incarnationTickTime]",
			fontFaceName = "Friz Quadrata TT",
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
			color = "ffffffff",
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=1)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=0)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=1)||($incarnationNextCp=($comboPoints+2)&$comboPoints=0)}[$incarnationTickTime]",
			color = "ffffffff",
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
			fontFaceName = "Friz Quadrata TT",
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=2)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=1)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=2)||($incarnationNextCp=($comboPoints+2)&$comboPoints=1)}[$incarnationTickTime]",
			color = "ffffffff",
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
			fontFaceName = "Friz Quadrata TT",
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=3)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=2)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=3)||($incarnationNextCp=($comboPoints+2)&$comboPoints=2)}[$incarnationTickTime]",
			color = "ffffffff",
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
			fontFaceName = "Friz Quadrata TT",
		},
		{
			enabled = true,
			useDefaultFontColor = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=4)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=3)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=4)||($incarnationNextCp=($comboPoints+2)&$comboPoints=3)}[$incarnationTickTime]",
			color = "ffffffff",
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
			fontFaceName = "Friz Quadrata TT",
		}
	}

	return textSettings
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
	return textSettings
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
			icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
            thresholdDictionary = {
				brutalSlash = {
					enabled = false,
				},
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
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true,
			enableFormSwitching = true
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
				border="FFFF7C0A",
				overcapEnabled=true,
				borderOvercap="FFFF0000",
				borderStealth="FF000000",
				background="66000000",
				base="FFFFFF00",
				clearcasting="FF4A95CE",
				maxBite="FF009900",
				apexPredator="FFE75480"
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			comboPoints = {
				border="FFFF7C0A",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
				consistentUnfilledColor = false,
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
			}
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
			apexPredatorsCraving={
				name = L["DruidFeralAudioApexPredatorsCravingProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			}
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
	return textSettings
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
			icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
			thresholdDictionary = {
				ironfur = {
					enabled = true,
				},
				maul = {
					enabled = true,
				},
				raze = {
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
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true,
			enableFormSwitching = true
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = GUARDIAN_MAX_RAGE
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOfBerserk = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
		colors = {
			text = {
				current = {
					color = "FFFF0000"
				},
				casting = {
					color = "FFFFFFFF"
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
				border="FFC21807",
				overcapEnabled=true,
				borderOvercap="FF800000",
				background="66000000",
				base="FFFF0000",
				berserk = {
					color = "FFFFCC55",
				},
				berserkEnd = {
					color = "FFFF5555",
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
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
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
	return textSettings
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
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true,
			enableFormSwitching = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOfIncarnation = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
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
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				noEfflorescence="FFFF0000",
				clearcasting="FF4A95CE",
				incarnation="FF005500",
				incarnationEnd="FFDD5500"
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			threshold = {
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				}
			}
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.balance
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

local function BalanceConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.balance
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Balance_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Balance_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceAstralPower"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 1, yCoord, false, nil, true)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], "balance", true, L["DruidBalanceStarsurge"], L["DruidBalanceStarsurge"], false, nil, true, true)

	yCoord = yCoord - 70
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		-- Clear all caches before rebuilding
		TRB.Functions.Character:ResetCaches()
		TRB.Data.cache.colors.border = {}
		TRB.Data.cache.colors.backdrop = {}
		-- Destroy and recreate bar groups to add/remove secondary bar
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
		local settings = TRB.Data.specCache[TRB.Data.character.specName].settings
		TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
		-- Force re-apply layout and appearance to ensure secondary bar gets Feral settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
			TRB.Functions.Class:CheckCharacter()
		end
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		TRB.Functions.Character:ResetColorCaches()
		TRB.Data.cache.values.frame = {}
		TRB.Functions.BarText:CreateBarTextFrames(11, 1)
	end)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"])

	yCoord = yCoord - 30
	controls.colors.solar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerEclipseSolar"], spec.colors.bar.solar, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.solar
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "solar")
	end)

	yCoord = yCoord - 30
	controls.colors.lunar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerEclipseLunar"], spec.colors.bar.lunar, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.lunar
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "lunar")
	end)

	yCoord = yCoord - 30
	controls.colors.celestial = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerCelestialAlignment"], spec.colors.bar.celestial, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.celestial
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "celestial")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfEclipse = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_EOE", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfEclipse
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceCheckboxEndOfEclipse"])
	f.tooltip = L["DruidBalanceCheckboxEndOfEclipseTooltip"]
	f:SetChecked(spec.endOfEclipse.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfEclipse.enabled = self:GetChecked()
	end)
	controls.checkBoxes.endOfEclipseOnly = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_EOE_CAO", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfEclipseOnly
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceCheckboxEndOfEclipseOnlyCelestial"])
	f.tooltip = L["DruidBalanceCheckboxEndOfEclipseOnlyCelestialTooltip"]
	f:SetChecked(spec.endOfEclipse.celestialAlignmentOnly)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfEclipse.celestialAlignmentOnly = self:GetChecked()
	end)

	controls.colors.eclipse1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerEndOfEclipse"], spec.colors.bar.eclipse1GCD, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.eclipse1GCD
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "eclipse1GCD")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 11, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidBalanceHeaderEndOfEclipseConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfEclipseModeGCDs = CreateFrame("CheckButton", "TRB_EOE_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfEclipseModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceCheckboxEclipseGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfEclipse.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfEclipseModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfEclipseModeTime:SetChecked(false)
		spec.endOfEclipse.mode = "gcd"
	end)

	title = L["DruidBalanceEclipseGcds"]
	controls.endOfEclipseGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 15, spec.endOfEclipse.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfEclipseGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfEclipse.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfEclipseModeTime = CreateFrame("CheckButton", "TRB_EOE_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfEclipseModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceCheckboxEclipseTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfEclipse.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfEclipseModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfEclipseModeTime:SetChecked(true)
		spec.endOfEclipse.mode = "time"
	end)

	title = L["DruidBalanceEclipseTime"]
	controls.endOfEclipseTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 20, spec.endOfEclipse.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfEclipseTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfEclipse.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], BALANCE_MAX_ASTRAL_POWER)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], 1, BALANCE_MAX_ASTRAL_POWER)
end

local function BalanceConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.balance
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Balance_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
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

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 1, yCoord)
end

local function BalanceConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.balance
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Balance_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Balance_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidBalanceTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextCasting"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerOvercap"], spec.colors.text.overcap.color, 300, 25, oUi.xCoord2, yCoord)
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
	controls.colors.text.manaBar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ManaBarTextColor"], spec.colors.text.manaBar.color, 300, 25, oUi.xCoord, yCoord)
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
	local controls = interfaceSettingsFrame.controls.balance
	local yCoord = 5

	controls.buttons.exportButton_Druid_Balance_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.balance
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Balance_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.balance or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.balanceDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Balance", UIParent)
	interfaceSettingsFrame.balanceDisplayPanel.name = L["DruidBalanceFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.balanceDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["balance"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.balanceDisplayPanel, L["DruidBalanceFull"])

	parent = interfaceSettingsFrame.balanceDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidBalanceFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.balanceDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_balanceDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.balanceDruidEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DruidBalanceFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.druid.balance)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.druid.balance = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.balanceDruidEnabled, TRB.Data.settings.core.enabled.druid.balance, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.balanceDruidEnabled, TRB.Data.settings.core.enabled.druid.balance, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Druid_Balance_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Druid_Balance_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 1, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls

	BalanceConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	BalanceConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	BalanceConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	BalanceConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	BalanceConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	BalanceConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Feral Option Menus

]]

local function FeralConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.feral
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

local function FeralConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.feral
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Feral_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Feral_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 2, yCoord, true)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], "notFull", false, nil, nil, true, L["ResourceComboPoints"], true)

	yCoord = yCoord - 70
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		-- Clear all caches before rebuilding
		TRB.Functions.Character:ResetCaches()
		-- Destroy and recreate bar groups to add/remove secondary bar
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
		local settings = TRB.Data.specCache[TRB.Data.character.specName].settings
		TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
		-- Force re-apply layout and appearance to ensure secondary bar gets Feral settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
			TRB.Functions.Class:CheckCharacter()
		end
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		TRB.Functions.Character:ResetColorCaches()
		TRB.Data.cache.values.frame = {}
		TRB.Functions.BarText:CreateBarTextFrames(11, 2)
	end)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.clearcasting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerClearcasting"], spec.colors.bar.clearcasting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.clearcasting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "clearcasting")
	end)

	yCoord = yCoord - 30
	controls.colors.maxBite = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerMaxBite"], spec.colors.bar.maxBite, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.maxBite
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "maxBite")
	end)

	yCoord = yCoord - 30
	controls.colors.apexPredator = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerApexPredatorsCraving"], spec.colors.bar.apexPredator, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.apexPredator
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "apexPredator")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)
	
	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], true, false)

	yCoord = yCoord - 30
	controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerStealth"], spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderStealth
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
	end)

	yCoord = yCoord - 40
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

	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
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

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["DruidFeralCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], FERAL_MAX_ENERGY)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], 1, FERAL_MAX_ENERGY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
end

local function FeralConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.feral
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Feral_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Feral_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 11, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord
		
	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.brutalSlashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_brutalSlash", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.brutalSlashThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxBrutalSlash"])
	f.tooltip = L["DruidFeralThresholdCheckboxBrutalSlashTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.brutalSlash.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.brutalSlash.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.feralFrenzyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_feralfrenzy", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feralFrenzyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFeralFrenzy"])
	f.tooltip = L["DruidFeralThresholdCheckboxFeralFrenzyTooltip"]
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

	controls.labels.ferociousBite = TRB.Functions.OptionsUi:BuildLabel(parent, L["DruidFeralThresholdCheckboxFerociousBite"], oUi.xCoord2, yCoord2, 300, 20, GameFontWhite)

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

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 2, yCoord)
end

local function FeralConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.feral
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Feral_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Feral_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 11, 2, yCoord)
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerOvercap"], spec.colors.text.overcap.color, 300, 25, oUi.xCoord2, yCoord)
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
	local controls = interfaceSettingsFrame.controls.feral
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Feral_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Feral_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "apexPredatorsCraving", spec, classId, specId, yCoord, L["DruidFeralCheckboxApexPredatorsCravingProc"], L["DruidFeralCheckboxApexPredatorsCravingProcTooltip"])
end

local function FeralConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.feral
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Feral_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.feral or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.feralDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Feral", UIParent)
	interfaceSettingsFrame.feralDisplayPanel.name = L["DruidFeralFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.feralDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["feral"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.feralDisplayPanel, L["DruidFeralFull"])

	parent = interfaceSettingsFrame.feralDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidFeralFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.feralDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_feralDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feralDruidEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DruidFeralFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.druid.feral)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.druid.feral = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.feralDruidEnabled, TRB.Data.settings.core.enabled.druid.feral, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.feralDruidEnabled, TRB.Data.settings.core.enabled.druid.feral, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Druid_Feral_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Druid_Feral_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 2, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls

	FeralConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	FeralConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	FeralConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	FeralConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	FeralConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	FeralConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

--[[

Guardian Druid

]]

local function GuardianConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.guardian
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

local function GuardianConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.guardian
	local yCoord = 5
	local f = nil
	local title = ""

	controls.buttons.exportButton_Druid_Guardian_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Guardian_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 3, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], "guardian", false, nil, nil, false, nil, true)

	yCoord = yCoord - 70
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		-- Clear all caches before rebuilding
		TRB.Functions.Character:ResetCaches()
		TRB.Data.cache.colors.border = {}
		TRB.Data.cache.colors.backdrop = {}
		-- Destroy and recreate bar groups to add/remove secondary bar
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
		local settings = TRB.Data.specCache[TRB.Data.character.specName].settings
		TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
		-- Force re-apply layout and appearance to ensure secondary bar gets Feral settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
			TRB.Functions.Class:CheckCharacter()
		end
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		TRB.Functions.Character:ResetColorCaches()
		TRB.Data.cache.values.frame = {}
		TRB.Functions.BarText:CreateBarTextFrames(11, 3)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"])	

	yCoord = yCoord - 30
	controls.colors.incarnation = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianColorPickerIncarnation"], spec.colors.bar.berserk.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.incarnation
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "incarnation")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfBerserk = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_endOfBerserk_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfBerserk
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianCheckboxBerserkEnd"])
	f.tooltip = L["DruidGuardianCheckboxBerserkEndTooltip"]
	f:SetChecked(spec.endOfBerserk.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfBerserk.enabled = self:GetChecked()
	end)

	controls.colors.berserkEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianColorPickerBerserkEnd"], spec.colors.bar.berserkEnd.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.berserkEnd
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "berserkEnd")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], false, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 3, yCoord)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidGuardianEndOfBerserkConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfBerserkModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_EOI_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfBerserkModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianCheckboxBerserkGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfBerserk.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfBerserkModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfBerserkModeTime:SetChecked(false)
		spec.endOfBerserk.mode = "gcd"
	end)

	title = L["DruidGuardianBerserkGcds"]
	controls.endOfBerserkGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfBerserk.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfBerserkGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfBerserk.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfBerserkModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_EOI_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfBerserkModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidGuardianCheckboxBerserkTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfBerserk.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfBerserkModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfBerserkModeTime:SetChecked(true)
		spec.endOfBerserk.mode = "time"
	end)

	title = L["DruidGuardianBerserkTime"]
	controls.endOfBerserkTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfBerserk.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfBerserkTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfBerserk.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], GUARDIAN_MAX_RAGE)

	yCoord = yCoord - 25
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], 1, GUARDIAN_MAX_RAGE)

	TRB.Frames.interfaceSettingsFrameContainer.controls.guardian = controls
end

local function GuardianConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.guardian
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Guardian_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
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

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 11, 3, yCoord, L["ResourceRage"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 3, yCoord)
end

local function GuardianConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.guardian
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Guardian_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Guardian_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidGuardianTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianTextColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianTextColorPickerOverThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidGuardianColorPickerOvercap"], spec.colors.text.overcap.color, 300, 25, oUi.xCoord2, yCoord)
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

	TRB.Frames.interfaceSettingsFrameContainer.controls.guardian = controls
end

local function GuardianConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.guardian

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.guardian
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Guardian_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.guardian
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Guardian_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.guardian or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.guardianDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Guardian", UIParent)
	interfaceSettingsFrame.guardianDisplayPanel.name = L["DruidGuardianFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.guardianDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["guardian"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.guardianDisplayPanel, L["DruidGuardianFull"])

	parent = interfaceSettingsFrame.guardianDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidGuardianFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.guardianDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Guardian_guardianDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.guardianDruidEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DruidGuardianFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.druid.guardian)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.druid.guardian = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.guardianDruidEnabled, TRB.Data.settings.core.enabled.druid.guardian, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.guardianDruidEnabled, TRB.Data.settings.core.enabled.druid.guardian, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Druid_Guardian_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Druid_Guardian_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidGuardianFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 3, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	--[[
		This spec doesn't use Audio & Tracking options. Make the width 1 instead of 120
	]]
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 1, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Audio & Tracking options. Don't let this tab be made/rendered.
		]]
		if i == 4 then
			tabs[i]:Hide()
		else
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		end
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.guardian = controls

	GuardianConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	GuardianConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	GuardianConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--GuardianConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	GuardianConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	GuardianConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

--[[

Restoration Druid

]]

local function RestorationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.restoration
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

local function RestorationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Restoration_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 4, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 4, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"], "notFull", false, nil, nil, false, nil, true)

	yCoord = yCoord - 70
	controls.checkBoxes.enableFormSwitching = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Checkbox_FormSwitching", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enableFormSwitching
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidCheckboxEnableFormSwitching"])
	f.tooltip = L["DruidCheckboxEnableFormSwitchingTooltip"]
	f:SetChecked(spec.displayBar.enableFormSwitching)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.enableFormSwitching = self:GetChecked()
		-- Clear all caches before rebuilding
		TRB.Functions.Character:ResetCaches()
		TRB.Data.cache.colors.border = {}
		TRB.Data.cache.colors.backdrop = {}
		-- Destroy and recreate bar groups to add/remove secondary bar
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
		local settings = TRB.Data.specCache[TRB.Data.character.specName].settings
		TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
		-- Force re-apply layout and appearance to ensure secondary bar gets Feral settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
			TRB.Functions.Class:CheckCharacter()
		end
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		TRB.Functions.Character:ResetColorCaches()
		TRB.Data.cache.values.frame = {}
		TRB.Functions.BarText:CreateBarTextFrames(11, 4)
	end)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.noEfflorescence = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidRestorationColorPickerNoEfflorescence"], spec.colors.bar.noEfflorescence, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.noEfflorescence
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noEfflorescence")
	end)

	--[[yCoord = yCoord - 30
	controls.colors.clearcasting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidRestorationColorPickerClearcasting"], spec.colors.bar.clearcasting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.clearcasting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "clearcasting")
	end)]]

	yCoord = yCoord - 30
	controls.colors.incarnation = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidRestorationColorPickerIncarnation"], spec.colors.bar.incarnation, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.incarnation
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "incarnation")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfIncarnation = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_EOI_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfIncarnation
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidRestorationCheckboxIncarnationEnd"])
	f.tooltip = L["DruidRestorationCheckboxIncarnationEndTooltip"]
	f:SetChecked(spec.endOfIncarnation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfIncarnation.enabled = self:GetChecked()
	end)

	controls.colors.incarnationEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidRestorationColorPickerIncarnationEnd"], spec.colors.bar.incarnationEnd, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.incarnationEnd
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "incarnationEnd")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"], false, true)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 11, 4, yCoord)
	
	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidRestorationEndOfIncarnationConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfIncarnationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_EOI_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfIncarnationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidRestorationCheckboxIncarnationGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfIncarnation.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfIncarnationModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfIncarnationModeTime:SetChecked(false)
		spec.endOfIncarnation.mode = "gcd"
	end)

	title = L["DruidRestorationIncarnationGcds"]
	controls.endOfIncarnationGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfIncarnation.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfIncarnationGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfIncarnation.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfIncarnationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_EOI_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfIncarnationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidRestorationCheckboxIncarnationTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfIncarnation.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfIncarnationModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfIncarnationModeTime:SetChecked(true)
		spec.endOfIncarnation.mode = "time"
	end)

	title = L["DruidRestorationIncarnationTime"]
	controls.endOfIncarnationTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfIncarnation.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfIncarnationTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfIncarnation.timeMax = value
	end)
end

local function RestorationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil
end

local function RestorationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 4, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
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
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Druid_Restoration_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
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
	local controls = interfaceSettingsFrame.controls.restoration or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.restorationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Restoration", UIParent)
	interfaceSettingsFrame.restorationDisplayPanel.name = L["DruidRestorationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.restorationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["restoration"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.restorationDisplayPanel, L["DruidRestorationFull"])

	parent = interfaceSettingsFrame.restorationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidRestorationFull"], oUi.xCoord, yCoord-5)
	
	controls.checkBoxes.restorationDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_restorationDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.restorationDruidEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DruidRestorationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.druid.restoration)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.druid.restoration = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.restorationDruidEnabled, TRB.Data.settings.core.enabled.druid.restoration, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.restorationDruidEnabled, TRB.Data.settings.core.enabled.druid.restoration, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Druid_Restoration_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Druid_Restoration_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 4, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	--[[
		This spec doesn't use Threshold Lines. Make the width 1 instead of 100
	]]
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 1, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	--[[
		This spec doesn't use Audio & Tracking options. Make the width 1 instead of 120
	]]
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 1, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines or Audio & Tracking options. Don't let these tabs be made/rendered.
		]]
		if i == 2 or i == 4 then
			tabs[i]:Hide()
		else
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		end
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls

	RestorationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--RestorationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	RestorationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--RestorationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	RestorationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	RestorationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	BalanceConstructOptionsPanel(specCache.balance)
	FeralConstructOptionsPanel(specCache.feral)
	GuardianConstructOptionsPanel(specCache.guardian)
	RestorationConstructOptionsPanel(specCache.restoration)
end
TRB.Options.Druid.ConstructOptionsPanel = ConstructOptionsPanel