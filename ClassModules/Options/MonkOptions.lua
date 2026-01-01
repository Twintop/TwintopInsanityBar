local _, TRB = ...
if TRB.Data.character.classId ~= 10 then --Only do this if we're on a Monk!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Monk = {}
TRB.Options.Monk.Brewmaster = {}
TRB.Options.Monk.Mistweaver = {}
TRB.Options.Monk.Windwalker = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.brewmaster = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = {}

local BREWMASTER_MAX_ENERGY = 100
local WINDWALKER_MAX_ENERGY = 150



-- Brewmaster
local function BrewmasterLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=18,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=18,
			color = "FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
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
			fontSize=18,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$stagger",
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
				relativeToFrame = "Stagger",
				relativeToFrameName = L["Stagger"]
			}
		},
	}

	return textSettings
end
TRB.Options.Monk.BrewmasterLoadDefaultBarTextSimpleSettings = BrewmasterLoadDefaultBarTextSimpleSettings

local function BrewmasterLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=22,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$stagger",
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
				relativeToFrame = "Stagger",
				relativeToFrameName = L["Stagger"]
			}
		},
	}

	return textSettings
end

local function BrewmasterLoadDefaultSettings(includeBarText)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = {
				showCooldown=true,
				border=2,
				relativeTo = "BOTTOM",
				relativeToName = L["PositionBelow"],
				enabled=true,
				desaturated=true,
				xPos=0,
				yPos=12,
				width=24,
				height=24
			},
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
			stagger = {
				medium = {
					enabled = true,
				},
				heavy = {
					enabled = true,
				}
			}
		},
		generation = {
			mode="gcd",
			gcds=1,
			time=1.5,
			enabled=true
		},
		maxResource = {
			value = BREWMASTER_MAX_ENERGY,
			enabled = false
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = {
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false
		},
		comboPoints = {
			width=25,
			height=13,
			xPos=0,
			yPos=4,
			border=1,
			spacing=14,
			relativeTo="TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth=true,
		},
		healthBar = {
			width=555,
			height=16,
			xPos=0,
			yPos=-4,
			border=2,
			spacing=0,
			relativeTo="BOTTOM",
			relativeToName = L["PositionBelowMiddle"],
			fullWidth=true,
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
				}
			},
			bar = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
			},
			comboPoints = {
				border="FF00FF98",
				background="66000000",
				type = "step",
				light = { color = "FF85FF85", threshold = 0.0 },
				medium = { color = "FFFFFAB8", threshold = 0.30 },
				heavy = { color = "FFFF6B6B", threshold = 0.60 }
			},
			healthBar = {
				border = { color = "FF008800" },
				background = { color = "66000000" },
				type = "step",
				low = { color = "FFFF0000", threshold = 0.0 },
				medium = { color = "FFFFFF00", threshold = 0.30 },
				high = { color = "FF00FF00", threshold = 0.70 }
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
				fontSize=18,
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
		},
		textures = {
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			resourceBar="Interface\\TargetingFrame\\UI-StatusBar",
			resourceBarName="Blizzard",
			textureLock=true,
			comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
			comboPointsBackgroundName="Blizzard Tooltip",
			comboPointsBorder="Interface\\Buttons\\WHITE8X8",
			comboPointsBorderName="1 Pixel",
			comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
			comboPointsBarName="Blizzard",
			healthBackground="Interface\\Tooltips\\UI-Tooltip-Background",
			healthBackgroundName="Blizzard Tooltip",
			healthBorder="Interface\\Buttons\\WHITE8X8",
			healthBorderName="1 Pixel",
			healthBar="Interface\\TargetingFrame\\UI-StatusBar",
			healthBarName="Blizzard",
		}
	}

	if includeBarText then
		settings.displayText.barText = BrewmasterLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

-- Mistweaver
local function MistweaverLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=16,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="",
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
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting + ]$mana/$manaMax $manaPercent%",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=16,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	}

	return textSettings
end
TRB.Options.Monk.MistweaverLoadDefaultBarTextSimpleSettings = MistweaverLoadDefaultBarTextSimpleSettings

local function MistweaverLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="",--{$potionCooldown}[#slumberingSoulSerum $potionCooldown] ",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting+]$mana/$manaMax $manaPercent%",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=16,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	}

	return textSettings
end

local function MistweaverLoadDefaultSettings(includeBarText)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = {
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false
		},
		healthBar = {
			width=555,
			height=16,
			xPos=0,
			yPos=-4,
			border=2,
			spacing=0,
			relativeTo="BOTTOM",
			relativeToName = L["PositionBelowMiddle"],
			fullWidth=true,
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
			bar={
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				vivaciousVivification = {
					color = "FF00FFBB",
					enabled = true
				},
				sheilunsGiftMax = {
					color = "FFFFD080",
					enabled = true
				},
				heartOfTheJadeSerpentReady = {
					color = "FF008461",
					enabled = true
				},
				heartOfTheJadeSerpent = {
					color = "FF00FFBB",
					enabled = true
				},
			},
			healthBar = {
				border = { color = "FF008800" },
				background = { color = "66000000" },
				type = "step",
				low = { color = "FFFF0000", threshold = 0.0 },
				medium = { color = "FFFFFF00", threshold = 0.30 },
				high = { color = "FF00FF00", threshold = 0.70 }
			}
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=18,
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
		textures={
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			resourceBar="Interface\\TargetingFrame\\UI-StatusBar",
			resourceBarName="Blizzard",
			textureLock=true,
			healthBackground="Interface\\Tooltips\\UI-Tooltip-Background",
			healthBackgroundName="Blizzard Tooltip",
			healthBorder="Interface\\Buttons\\WHITE8X8",
			healthBorderName="1 Pixel",
			healthBar="Interface\\TargetingFrame\\UI-StatusBar",
			healthBarName="Blizzard",
		}
	}

	if includeBarText then
		settings.displayText.barText = MistweaverLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function WindwalkerLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=18,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="{$danceOfChiJiTime}[$danceOfChiJiTime]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=18,
			color = "FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
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
			fontSize=18,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	}

	return textSettings
end
TRB.Options.Monk.WindwalkerLoadDefaultBarTextSimpleSettings = WindwalkerLoadDefaultBarTextSimpleSettings

local function WindwalkerLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="{$danceOfChiJiTime}[$danceOfChiJiTime]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=22,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	}

	return textSettings
end

local function WindwalkerLoadDefaultSettings(includeBarText)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = {
				showCooldown=true,
				border=2,
				relativeTo = "BOTTOM",
				relativeToName = L["PositionBelow"],
				enabled=true,
				desaturated=true,
				xPos=0,
				yPos=12,
				width=24,
				height=24
			},
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
			}
		},
		generation = {
			mode="gcd",
			gcds=1,
			time=1.5,
			enabled=true
		},
		maxResource = {
			value = WINDWALKER_MAX_ENERGY,
			enabled = false
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = {
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false
		},
		comboPoints = {
			width=25,
			height=13,
			xPos=0,
			yPos=4,
			border=1,
			spacing=14,
			relativeTo="TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth=true,
		},
		healthBar = {
			width=555,
			height=16,
			xPos=0,
			yPos=-4,
			border=2,
			spacing=0,
			relativeTo="BOTTOM",
			relativeToName = L["PositionBelowMiddle"],
			fullWidth=true,
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
				}
			},
			bar = {
				border="FFFFD300",
				borderChiJi="FF00FF00",
				background="66000000",
				base="FFFFFF00",
				heartOfTheJadeSerpentReady = {
					color = "FF008461",
					enabled = true
				},
				heartOfTheJadeSerpent = {
					color = "FF00FFBB",
					enabled = true
				},
			},
			comboPoints = {
				border="FF00FF98",
				background="66000000",
				base="FFB5FFEB",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false
			},
			healthBar = {
				border = { color = "FF008800" },
				background = { color = "66000000" },
				type = "step",
				low = { color = "FFFF0000", threshold = 0.0 },
				medium = { color = "FFFFFF00", threshold = 0.30 },
				high = { color = "FF00FF00", threshold = 0.70 }
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
				fontSize=18,
				color = "FFFFFFFF",
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
		},
		textures = {
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			resourceBar="Interface\\TargetingFrame\\UI-StatusBar",
			resourceBarName="Blizzard",
			textureLock=true,
			comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
			comboPointsBackgroundName="Blizzard Tooltip",
			comboPointsBorder="Interface\\Buttons\\WHITE8X8",
			comboPointsBorderName="1 Pixel",
			comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
			comboPointsBarName="Blizzard",
			healthBackground="Interface\\Tooltips\\UI-Tooltip-Background",
			healthBackgroundName="Blizzard Tooltip",
			healthBorder="Interface\\Buttons\\WHITE8X8",
			healthBorderName="1 Pixel",
			healthBar="Interface\\TargetingFrame\\UI-StatusBar",
			healthBarName="Blizzard",
		}
	}

	if includeBarText then
		settings.displayText.barText = WindwalkerLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.monk.brewmaster = BrewmasterLoadDefaultSettings(includeBarText)
	settings.monk.mistweaver = MistweaverLoadDefaultSettings(includeBarText)
	settings.monk.windwalker = WindwalkerLoadDefaultSettings(includeBarText)
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.brewmaster
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
	StaticPopupDialogs["TwintopResourceBar_Monk_Brewmaster_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["MonkBrewmasterFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BrewmasterLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Brewmaster_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["MonkBrewmasterFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BrewmasterLoadDefaultBarTextAdvancedSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 150, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Brewmaster_ResetBarTextAdvanced")
	end)
end

local function BrewmasterConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.brewmaster
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Monk_Brewmaster_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Brewmaster_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkBrewmasterFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 10, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], L["ResourceStagger"], false)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 10, 1, yCoord, true, L["ResourceStagger"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], nil, false, nil, nil, true, L["ResourceStagger"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], false, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateStaggerBarColorOptions(parent, controls, spec, 10, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 10, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], 1, WINDWALKER_MAX_ENERGY)
end

local function BrewmasterConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.brewmaster
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Monk_Brewmaster_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Brewmaster_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkBrewmasterFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 10, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20
	controls.checkBoxes.expelHarmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_expelHarm", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.expelHarmThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxExpelHarm"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxExpelHarmTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.expelHarm.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.expelHarm.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.kegSmashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_kegSmash", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kegSmashThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxKegSmash"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxKegSmashTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.kegSmash.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.kegSmash.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.spinningCraneKickThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_spinningCraneKick", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.spinningCraneKickThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxSpinningCraneKick"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxSpinningCraneKickTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.spinningCraneKick.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.spinningCraneKick.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.tigerPalmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_tigerPalm", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.tigerPalmThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxTigerPalm"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxTigerPalmTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.tigerPalm.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.tigerPalm.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.cracklingJadeLightningThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_cracklingJadeLightning", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cracklingJadeLightningThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxCracklingJadeLightning"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxCracklingJadeLightningTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cracklingJadeLightning.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cracklingJadeLightning.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.detoxThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_detox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.detoxThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxDetox"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxDetoxTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.detox.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.detox.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.disableThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_disable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.disableThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxDisable"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxDisableTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.disable.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.disable.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.paralysisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_paralysis", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.paralysisThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxParalysis"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxParalysisTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.paralysis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.paralysis.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.soothingMistThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_soothingMist", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.soothingMistThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxSoothingMist"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxSoothingMistTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.soothingMist.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.soothingMist.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.vivifyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_vivify", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.vivifyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkBrewmasterThresholdCheckboxVivify"])
	f.tooltip = L["MonkBrewmasterThresholdCheckboxVivifyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.vivify.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.vivify.enabled = self:GetChecked()
	end)

	yCoord = yCoord2

	-- Stagger Levels section
	yCoord = yCoord - 40
	controls.staggerLevelsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerLevelsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.staggerMediumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_Threshold_Option_staggerMedium", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.staggerMediumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["StaggerLevelMediumCheckbox"])
	f.tooltip = L["StaggerLevelMediumTooltip"]
	f:SetChecked(spec.thresholds.stagger.medium.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.stagger.medium.enabled = self:GetChecked()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
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
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 10, 1, yCoord, L["ResourceEnergy"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 1, yCoord)

	controls.colors.threshold = {}
end

local function BrewmasterConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.brewmaster
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Monk_Brewmaster_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Brewmaster_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkBrewmasterFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 10, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 10, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkBrewmasterColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkBrewmasterColorPickerCasting"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkBrewmasterColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 10, 1, yCoord)
end

local function BrewmasterConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.brewmaster
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Monk_Brewmaster_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Brewmaster_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkBrewmasterFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 10, 1, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
end

local function BrewmasterConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.brewmaster
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.brewmaster
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Monk_Brewmaster_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Brewmaster_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkBrewmasterFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 10, 1, yCoord, cache)
end

local function BrewmasterConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(10, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.brewmaster or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.brewmasterDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Brewmaster", UIParent)
	interfaceSettingsFrame.brewmasterDisplayPanel.name = L["MonkBrewmasterFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.brewmasterDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["brewmaster"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.brewmasterDisplayPanel, L["MonkBrewmasterFull"])
	
	parent = interfaceSettingsFrame.brewmasterDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkBrewmasterFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.brewmasterMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Brewmaster_brewmasterMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.brewmasterMonkEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["MonkBrewmasterFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.monk.brewmaster)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.monk.brewmaster = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.brewmasterMonkEnabled, TRB.Data.settings.core.enabled.monk.brewmaster, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.brewmasterMonkEnabled, TRB.Data.settings.core.enabled.monk.brewmaster, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Monk_Brewmaster_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Monk_Brewmaster_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkBrewmasterFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 1, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.brewmaster = controls

	BrewmasterConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	BrewmasterConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	BrewmasterConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	BrewmasterConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	BrewmasterConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	BrewmasterConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Mistweaver Option Menus

]]

local function MistweaverConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver
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
	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MistweaverLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MistweaverLoadDefaultBarTextAdvancedSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[
	StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["MonkMistweaverFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MistweaverLoadDefaultBarTextNarrowAdvancedSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	]]

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 150, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
end

local function MistweaverConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mistweaver
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Monk_Mistweaver_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Mistweaver_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 10, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 10, 2, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, false, nil, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.checkBoxes.vivaciousVivification = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_vivaciousVivification", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.vivaciousVivification
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxVivify"])
	f.tooltip = L["MonkMistweaverCheckboxVivifyTooltip"]
	f:SetChecked(spec.colors.bar.vivaciousVivification.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.vivaciousVivification.enabled = self:GetChecked()
	end)

	controls.colors.vivaciousVivification = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerVivify"], spec.colors.bar.vivaciousVivification.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.vivaciousVivification
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "vivaciousVivification")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"], false, true)

	--[[yCoord = yCoord - 30
	controls.checkBoxes.manaTeaBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Border_Option_manaTeaBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.manaTeaBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxManaTea"])
	f.tooltip = L["MonkMistweaverCheckboxManaTeaTooltip"]
	f:SetChecked(spec.colors.bar.manaTea.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.manaTea.enabled = self:GetChecked()
	end)

	controls.colors.manaTea = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerManaTea"], spec.colors.bar.manaTea.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.manaTea
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "manaTea")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sheilunsGiftMax = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_sheilunsGiftMax", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sheilunsGiftMax
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxSheilunsGiftMax"])
	f.tooltip = L["MonkMistweaverCheckboxSheilunsGiftMaxTooltip"]
	f:SetChecked(spec.colors.bar.sheilunsGiftMax.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.sheilunsGiftMax.enabled = self:GetChecked()
	end)

	controls.colors.sheilunsGiftMax = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerSheilunsGiftMax"], spec.colors.bar.sheilunsGiftMax.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.sheilunsGiftMax
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "sheilunsGiftMax")
	end)
	
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

	controls.colors.heartOfTheJadeSerpentReady = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerHeartOfTheJadeSerpentReady"], spec.colors.bar.heartOfTheJadeSerpentReady.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.heartOfTheJadeSerpentReady
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "heartOfTheJadeSerpentReady")
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

	controls.colors.heartOfTheJadeSerpent = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerHeartOfTheJadeSerpent"], spec.colors.bar.heartOfTheJadeSerpent.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.heartOfTheJadeSerpent
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "heartOfTheJadeSerpent")
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 10, 2, yCoord)
end

local function MistweaverConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mistweaver
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Monk_Mistweaver_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Mistweaver_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 10, 2, false, true, false, false, false, false)
	end)
end

local function MistweaverConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mistweaver
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Monk_Mistweaver_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Mistweaver_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 10, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 10, 2, yCoord)
	
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

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerPassiveMana"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 10, 2, yCoord)
end

local function MistweaverConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 2
	local spec = TRB.Data.settings.monk.mistweaver

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mistweaver
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Monk_Mistweaver_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Mistweaver_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function MistweaverConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.mistweaver
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mistweaver
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Monk_Mistweaver_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Mistweaver_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 10, 2, yCoord, cache)
end

local function MistweaverConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(10, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.mistweaver or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.mistweaverDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Mistweaver", UIParent)
	interfaceSettingsFrame.mistweaverDisplayPanel.name = L["MonkMistweaverFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.mistweaverDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["mistweaver"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.mistweaverDisplayPanel, L["MonkMistweaverFull"])
	
	parent = interfaceSettingsFrame.mistweaverDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkMistweaverFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.mistweaverMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_mistweaverMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mistweaverMonkEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["MonkMistweaverFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.monk.mistweaver)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.monk.mistweaver = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.mistweaverMonkEnabled, TRB.Data.settings.core.enabled.monk.mistweaver, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.mistweaverMonkEnabled, TRB.Data.settings.core.enabled.monk.mistweaver, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Monk_Mistweaver_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Monk_Mistweaver_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls

	MistweaverConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	MistweaverConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	MistweaverConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	MistweaverConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	MistweaverConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	MistweaverConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Windwalker Option Menus

]]

local function WindwalkerConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker
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
	StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["MonkWindwalkerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = WindwalkerLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["MonkWindwalkerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = WindwalkerLoadDefaultBarTextAdvancedSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 150, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
end

local function WindwalkerConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.windwalker
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Monk_Windwalker_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Windwalker_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 10, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], L["ResourceChi"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 10, 3, yCoord, true, L["ResourceChi"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], "notFull", false, nil, nil, true, L["ResourceChi"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], true, false)

	--[[yCoord = yCoord - 30
	controls.colors.borderChiJi = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerDanceOfChiJi"], spec.colors.bar.borderChiJi, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderChiJi
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderChiJi")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.heartOfTheJadeSerpentReady = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Checkbox_heartOfTheJadeSerpentReady", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.heartOfTheJadeSerpentReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxHeartOfTheJadeSerpentReady"])
	f.tooltip = L["MonkWindwalkerCheckboxHeartOfTheJadeSerpentReadyTooltip"]
	f:SetChecked(spec.colors.bar.heartOfTheJadeSerpentReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.heartOfTheJadeSerpentReady.enabled = self:GetChecked()
	end)

	controls.colors.heartOfTheJadeSerpentReady = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerHeartOfTheJadeSerpentReady"], spec.colors.bar.heartOfTheJadeSerpentReady.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.heartOfTheJadeSerpentReady
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "heartOfTheJadeSerpentReady")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.heartOfTheJadeSerpent = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Checkbox_heartOfTheJadeSerpent", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.heartOfTheJadeSerpent
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxHeartOfTheJadeSerpent"])
	f.tooltip = L["MonkWindwalkerCheckboxHeartOfTheJadeSerpentTooltip"]
	f:SetChecked(spec.colors.bar.heartOfTheJadeSerpent.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.heartOfTheJadeSerpent.enabled = self:GetChecked()
	end)

	controls.colors.heartOfTheJadeSerpent = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerHeartOfTheJadeSerpent"], spec.colors.bar.heartOfTheJadeSerpent.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.heartOfTheJadeSerpent
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "heartOfTheJadeSerpent")
	end)]]

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ChiColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceChi"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ChiCheckboxUseHighestForAll"])
	f.tooltip = L["ChiCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 10, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], 1, WINDWALKER_MAX_ENERGY)
end

local function WindwalkerConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.windwalker
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Monk_Windwalker_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Windwalker_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 10, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20
	controls.checkBoxes.expelHarmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_expelHarm", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.expelHarmThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxExpelHarm"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxExpelHarmTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.expelHarm.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.expelHarm.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.tigerPalmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_tigerPalm", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.tigerPalmThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxTigerPalm"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxTigerPalmTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.tigerPalm.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.tigerPalm.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.cracklingJadeLightningThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_cracklingJadeLightning", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cracklingJadeLightningThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxCracklingJadeLightning"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxCracklingJadeLightningTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cracklingJadeLightning.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cracklingJadeLightning.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.detoxThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_detox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.detoxThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxDetox"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxDetoxTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.detox.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.detox.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.disableThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_disable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.disableThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxDisable"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxDisableTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.disable.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.disable.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.paralysisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_paralysis", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.paralysisThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxParalysis"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxParalysisTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.paralysis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.paralysis.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.soothingMistThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_soothingMist", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.soothingMistThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxSoothingMist"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxSoothingMistTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.soothingMist.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.soothingMist.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.vivifyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_vivify", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.vivifyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxVivify"])
	f.tooltip = L["MonkWindwalkerThresholdCheckboxVivifyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.vivify.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.vivify.enabled = self:GetChecked()
	end)

	yCoord = yCoord2

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 3, yCoord)
end

local function WindwalkerConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.windwalker
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Monk_Windwalker_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Windwalker_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 10, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 10, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerPassiveEnergy"], spec.colors.text.passive.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 10, 3, yCoord)
end

local function WindwalkerConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 10
	local specId = 3
	local spec = TRB.Data.settings.monk.windwalker

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.windwalker
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "danceOfChiJi", spec, classId, specId, yCoord, L["MonkWindwalkerCheckboxDanceOfChiJi"], L["MonkWindwalkerCheckboxDanceOfChiJiTooltip"])

	--[[controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackEnergyRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegen"])
	f.tooltip = L["CheckboxTrackEnergyRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
		controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
		spec.generation.mode = "gcd"
	end)

	title = L["TrackEnergyRegenEnergyGcds"]
	controls.energyGenerationGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.energyGenerationGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.generation.gcds = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
		controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
		spec.generation.mode = "time"
	end)

	title = L["TrackEnergyRegenEnergyTime"]
	controls.energyGenerationTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.energyGenerationTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.generation.time = value
	end)]]
end

local function WindwalkerConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.monk.windwalker
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.windwalker
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Monk_Windwalker_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Monk_Windwalker_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 10, 3, yCoord, cache)
end

local function WindwalkerConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(10, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.windwalker or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.windwalkerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Windwalker", UIParent)
	interfaceSettingsFrame.windwalkerDisplayPanel.name = L["MonkWindwalkerFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.windwalkerDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["windwalker"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.windwalkerDisplayPanel, L["MonkWindwalkerFull"])
	
	parent = interfaceSettingsFrame.windwalkerDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkWindwalkerFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.windwalkerMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_windwalkerMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.windwalkerMonkEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["MonkWindwalkerFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.monk.windwalker)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.monk.windwalker = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Monk_Windwalker_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Monk_Windwalker_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls

	WindwalkerConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	WindwalkerConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	WindwalkerConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	WindwalkerConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	WindwalkerConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	WindwalkerConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	BrewmasterConstructOptionsPanel(specCache.brewmaster)
	MistweaverConstructOptionsPanel(specCache.mistweaver)
	WindwalkerConstructOptionsPanel(specCache.windwalker)
end
TRB.Options.Monk.ConstructOptionsPanel = ConstructOptionsPanel