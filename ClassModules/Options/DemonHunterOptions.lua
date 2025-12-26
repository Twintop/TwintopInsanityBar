local _, TRB = ...
if TRB.Data.character.classId ~= 12 then --Only do this if we're on a Demon Hunter!
	return
end

local L = TRB.Localization
local oUi = TRB.Data.constants.optionsUi

TRB.Options.DemonHunter = {}
TRB.Options.DemonHunter.Havoc = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.devourer = {}

local HAVOC_MAX_FURY = 170
local VENGEANCE_MAX_FURY = 120
local DEVOURER_MAX_FURY = 140

local function HavocLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="", --{$ucTime}[$ucTime]",
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
			text="{$metamorphosisTime}[$metamorphosisTime]",
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
			text="{$casting}[$casting + ]$fury",
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
TRB.Options.DemonHunter.HavocLoadDefaultBarTextSimpleSettings = HavocLoadDefaultBarTextSimpleSettings

local function HavocLoadDefaultBarTextAdvancedSettings()
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
			text="{$metamorphosisTime}[#metamorphosis $metamorphosisTime #metamorphosis]",
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
			text="{$casting}[#casting$casting+]$fury",
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

local function HavocLoadDefaultSettings(includeBarText)
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
				relativeTo = "TOP",
				relativeToName = L["PositionAbove"],
				enabled=true,
				desaturated=true,
				xPos=0,
				yPos=-12,
				width=24,
				height=24
			},
			thresholdDictionary = {
				annihilation = {
					enabled = true,
				},
				bladeDance = {
					enabled = true,
				},
				chaosNova = {
					enabled = true,
				},
				chaosStrike = {
					enabled = true,
				},
				deathSweep = {
					enabled = true,
				},
				eyeBeam = {
					enabled = true,
				},
				-- Talents
				glaiveTempest = {
					enabled = true,
				},
				throwGlaive = {
					enabled = true,
				},
				felBarrage = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = HAVOC_MAX_FURY,
			enabled = false
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		endOfMetamorphosis = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
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
				}
			},
			bar = {
				border="FFA330C9",
				background="66000000",
				base="FFC942FD",
				metamorphosis="FF67F100",
				metamorphosisEnding="FFFF0000"
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
			textureLock=true
		}
	}

	if includeBarText then
		settings.displayText.barText = HavocLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function VengeanceLoadDefaultBarTextSimpleSettings()
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
			text="{$metamorphosisTime}[$metamorphosisTime]",
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
			text="{$casting}[$casting + ]$fury",
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
TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSimpleSettings = VengeanceLoadDefaultBarTextSimpleSettings

local function VengeanceLoadDefaultBarTextAdvancedSettings()
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
			text="{$metamorphosisTime}[#metamorphosis $metamorphosisTime #metamorphosis]",
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
			text="{$iaFury}[#ia$iaFury+]{$casting}[#casting$casting+]$fury",
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

local function VengeanceLoadDefaultSettings(includeBarText)
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
				soulCleave = {
					enabled = true,
				},
				chaosNova = {
					enabled = true,
				},
				-- Talents
				felDevastation = {
					enabled = true,
				},
				spiritBomb = {
					enabled = true,
				},
			}
		},
		maxResource = {
			value = VENGEANCE_MAX_FURY,
			enabled = false
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		endOfMetamorphosis = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
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
				}
			},
			bar = {
				border="FFA330C9",
				background="66000000",
				base="FFC942FD",
				metamorphosis = "FF67F100",
				metamorphosisEnding="FFFF0000",
			},
			comboPoints = {
				border="FF660088",
				background="66000000",
				base="FFC942FD",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false
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
		}
	}

	if includeBarText then
		settings.displayText.barText = VengeanceLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function DevourerLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$resource",
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
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$soulFragments",
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
				relativeToFrame = "ComboPoint_1",
				relativeToFrameName = L["SoulFragments"]
			}
		},
	}

	return textSettings
end
TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSimpleSettings = DevourerLoadDefaultBarTextSimpleSettings

local function DevourerLoadDefaultBarTextAdvancedSettings()
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
			text="{$casting}[#casting$casting+]$fury",
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

local function DevourerLoadDefaultSettings(includeBarText)
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
				relativeTo = "TOP",
				relativeToName = L["PositionAbove"],
				enabled=true,
				desaturated=true,
				xPos=0,
				yPos=-12,
				width=24,
				height=24
			},
			thresholdDictionary = {
				voidRay = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = DEVOURER_MAX_FURY,
			enabled = false
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		endOfMetamorphosis = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
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
				}
			},
			bar = {
				border="FFA330C9",
				background="66000000",
				base="FFC942FD",
				voidMetamorphosis = {
					color = "FF431863",
					enabled = true
				},
			},
			comboPoints = {
				border="FF660088",
				background="66000000",
				base="FFC942FD",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
				voidMetamorphosisReady = {
					color = "FF431863",
					enabled = true
				},
				collapsingStarReady = {
					color = "FF431863",
					enabled = true
				},
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
		}
	}

	if includeBarText then
		settings.displayText.barText = DevourerLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.demonhunter.havoc = HavocLoadDefaultSettings(includeBarText)
	settings.demonhunter.vengeance = VengeanceLoadDefaultSettings(includeBarText)
	settings.demonhunter.devourer = DevourerLoadDefaultSettings(includeBarText)
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.havoc
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
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DemonHunterHavocFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = HavocLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DemonHunterHavocFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = HavocLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
end

local function HavocConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.havoc
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 12, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 12, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 12, 1, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], "notEmpty", false)

	yCoord = yCoord - 100
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"])

	yCoord = yCoord - 30
	controls.colors.metamorphosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterHavocColorPickerMetamorphosis"], spec.colors.bar.metamorphosis, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.metamorphosis
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosis")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_EndOfMetamorphosisCheckbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosis
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocCheckboxEndOfMetamorphosis"])
	f.tooltip = L["DemonHunterHavocCheckboxEndOfMetamorphosisTooltip"]
	f:SetChecked(spec.endOfMetamorphosis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfMetamorphosis.enabled = self:GetChecked()
	end)

	controls.colors.metamorphosisEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterHavocColorPickerMetamorphosisEnding"], spec.colors.bar.metamorphosisEnding, 250, 25, oUi.xCoord2, yCoord)
	f = controls.colors.metamorphosisEnding
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], true, false)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterHavocEndOfMetamorphosisConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_EOT_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosisModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocCheckboxMetamorphosisGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfMetamorphosis.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(false)
		spec.endOfMetamorphosis.mode = "gcd"
	end)

	title = L["DemonHunterHavocMetamorphosisGcds"]
	controls.endOfMetamorphosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfMetamorphosis.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_EOT_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosisModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocCheckboxMetamorphosisTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfMetamorphosis.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(true)
		spec.endOfMetamorphosis.mode = "time"
	end)

	title = L["DemonHunterHavocMetamorphosisTime"]
	controls.endOfMetamorphosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfMetamorphosis.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], 1, HAVOC_MAX_FURY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
end

local function HavocConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.havoc
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DemonHunter_Havoc_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 12, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.bladeDanceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_bladeDance", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.bladeDanceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxBladeDashDeathSweep"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxBladeDashDeathSweepTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.bladeDance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.bladeDance.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.deathSweep.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.chaosNovaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosNova", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.chaosNovaThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxChaosNova"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxChaosNovaTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.chaosNova.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.chaosNova.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.chaosStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.chaosStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxChaosStrikeAnnihilation"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxChaosStrikeAnnihilationTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.chaosStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.chaosStrike.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.annihilation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.eyeBeamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_eyeBeam", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.eyeBeamThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxEyeBeam"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxEyeBeamTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.eyeBeam.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.eyeBeam.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.felBarrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_felBarrage", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.felBarrageThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxFelBarrage"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxFelBarrageTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.felBarrage.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.felBarrage.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.glaiveTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_glaiveTempest", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.glaiveTempestThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxGlaiveTempest"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxGlaiveTempestTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.glaiveTempest.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.glaiveTempest.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.throwGlaiveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_throwGlaive", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.throwGlaiveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterHavocThresholdCheckboxThrowGlaive"])
	f.tooltip = L["DemonHunterHavocThresholdCheckboxThrowGlaiveTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.throwGlaive.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.throwGlaive.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		--[[{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["DemonHunterHavocThresholdSpecial"],
			enabledCheckboxLocalization = L["DemonHunterHavocThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["DemonHunterHavocThresholdSpecialEnabledTooltip"]
		}]]
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 12, 1, yCoord, L["ResourceFury"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 1, yCoord)
end

local function HavocConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.havoc
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DemonHunter_Havoc_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 12, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 12, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterHavocTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 12, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterHavocTextColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterHavocTextColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterHavocColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 12, 1, yCoord)
end

local function HavocConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 12
	local specId = 1
	local spec = TRB.Data.settings.demonhunter.havoc

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.havoc
	local yCoord = 5

	controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function HavocConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.havoc
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.havoc
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DemonHunter_Havoc_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 12, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 12, 1, yCoord, cache)
end

local function HavocConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(12, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.havoc or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.havocDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Havoc", UIParent)
	interfaceSettingsFrame.havocDisplayPanel.name = L["DemonHunterHavoc"].. " " .. L["DemonHunter"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.havocDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["havoc"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.havocDisplayPanel, L["DemonHunterHavocFull"])
	
	parent = interfaceSettingsFrame.havocDisplayPanel

	controls.buttons = controls.buttons or {}

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterHavoc"].. " " .. L["DemonHunter"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.havocDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_havocDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.havocDemonHunterEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DemonHunterHavocFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.havoc)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.demonhunter.havoc = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_DemonHunter_Havoc_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterHavocFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 12, 1, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls

	HavocConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	HavocConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	HavocConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	HavocConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	HavocConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	HavocConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

--[[

Vengeance Option Menus

]]

local function VengeanceConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance
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
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DemonHunterVengeanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = VengeanceLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DemonHunterVengeanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = VengeanceLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls
end

local function VengeanceConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.vengeance
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DemonHunter_Vengeance_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Vengeance_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 12, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 12, 2, yCoord)

	--yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"]), L["ResourceSoulFragments"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 12, 2, yCoord)--, true, L["ResourceSoulFragments"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], "notEmpty", false)

	yCoord = yCoord - 100
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"])

	yCoord = yCoord - 30
	controls.colors.metamorphosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerMetamorphosis"], spec.colors.bar.metamorphosis, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.metamorphosis
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosis")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_EndOfMetamorphosisCheckbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosis
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceCheckboxEndOfMetamorphosis"])
	f.tooltip = L["DemonHunterVengeanceCheckboxEndOfMetamorphosisTooltip"]
	f:SetChecked(spec.endOfMetamorphosis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfMetamorphosis.enabled = self:GetChecked()
	end)

	controls.colors.metamorphosisEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerMetamorphosisEnding"], spec.colors.bar.metamorphosisEnding, 250, 25, oUi.xCoord2, yCoord)
	f = controls.colors.metamorphosisEnding
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], true, false)

	--[[yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterVengeanceHeaderSoulFragmentColors"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceFury"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerSoulFragmentBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerSoulFragmentPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerSoulFragmentFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceCheckboxUseHighestSoulFragmentColorForAll"])
	f.tooltip = L["DemonHunterVengeanceCheckboxUseHighestSoulFragmentColorForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerUnfilledSoulFragmentBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)]]

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterVengeanceEndOfMetamorphosisConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_EOT_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosisModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceCheckboxMetamorphosisGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfMetamorphosis.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(false)
		spec.endOfMetamorphosis.mode = "gcd"
	end)

	title = L["DemonHunterVengeanceMetamorphosisGcds"]
	controls.endOfMetamorphosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfMetamorphosis.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_EOT_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosisModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceCheckboxMetamorphosisTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfMetamorphosis.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(true)
		spec.endOfMetamorphosis.mode = "time"
	end)

	title = L["DemonHunterVengeanceMetamorphosisTime"]
	controls.endOfMetamorphosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfMetamorphosis.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], 1, VENGEANCE_MAX_FURY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls
end

local function VengeanceConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.vengeance
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DemonHunter_Havoc_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Havoc_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 12, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.chaosNovaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_chaosNova", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.chaosNovaThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceThresholdCheckboxChaosNova"])
	f.tooltip = L["DemonHunterVengeanceThresholdCheckboxChaosNovaTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.chaosNova.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.chaosNova.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.felDevastationThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_felDevastation", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.felDevastationThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceThresholdCheckboxFelDevastation"])
	f.tooltip = L["DemonHunterVengeanceThresholdCheckboxFelDevastationTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.felDevastation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.felDevastation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.soulCleaveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_soulCleave", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.soulCleaveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceThresholdCheckboxSoulCleave"])
	f.tooltip = L["DemonHunterVengeanceThresholdCheckboxSoulCleaveTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.soulCleave.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.soulCleave.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.spiritBombThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_spiritBomb", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.spiritBombThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterVengeanceThresholdCheckboxSpiritBomb"])
	f.tooltip = L["DemonHunterVengeanceThresholdCheckboxSpiritBombTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.spiritBomb.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.spiritBomb.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		--[[{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["DemonHunterVengeanceThresholdSpecial"],
			enabledCheckboxLocalization = L["DemonHunterVengeanceThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["DemonHunterVengeanceThresholdSpecialEnabledTooltip"]
		}]]
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 12, 2, yCoord, L["ResourceFury"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 2, yCoord)
end

local function VengeanceConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.vengeance
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DemonHunter_Vengeance_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Vengeance_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 12, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 12, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterVengeanceTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 12, 2, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceTextColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceTextColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterVengeanceColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 12, 2, yCoord)
end

local function VengeanceConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 12
	local specId = 2
	local spec = TRB.Data.settings.demonhunter.vengeance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.vengeance
	local yCoord = 5

	controls.buttons.exportButton_DemonHunter_Vengeance_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Vengeance_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function VengeanceConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.vengeance
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.vengeance
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DemonHunter_Vengeance_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Vengeance_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 12, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 12, 2, yCoord, cache)
end

local function VengeanceConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(12, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.vengeance or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.vengeanceDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Vengeance", UIParent)
	interfaceSettingsFrame.vengeanceDisplayPanel.name = L["DemonHunterVengeance"].. " " .. L["DemonHunter"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.vengeanceDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["vengeance"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.vengeanceDisplayPanel, L["DemonHunterVengeanceFull"])
	
	parent = interfaceSettingsFrame.vengeanceDisplayPanel

	controls.buttons = controls.buttons or {}

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterVengeance"].. " " .. L["DemonHunter"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.vengeanceDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_vengeanceDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.vengeanceDemonHunterEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DemonHunterVengeanceFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.vengeance)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.demonhunter.vengeance = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.vengeanceDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.vengeance, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.vengeanceDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.vengeance, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_DemonHunter_Vengeance_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_DemonHunter_Vengeance_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterVengeanceFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 12, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls

	VengeanceConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	VengeanceConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	VengeanceConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	VengeanceConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	VengeanceConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	VengeanceConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

--[[

Devourer Option Menus

]]

local function DevourerConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.devourer
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
			spec.displayText.barText = DevourerLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DemonHunter_Devourer_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DemonHunterDevourerFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DevourerLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Devourer_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Devourer_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DemonHunter_Devourer_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.devourer = controls
end

local function DevourerConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devourer
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DemonHunter_Devourer_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Devourer_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterDevourerFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 12, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 12, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], L["ResourceSoulFragments"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 12, 3, yCoord, true, L["ResourceSoulFragments"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], "notEmpty", false)

	yCoord = yCoord - 100
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"])

	yCoord = yCoord - 30
	controls.checkBoxes.voidMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_Checkbox_VoidMetamorphosis", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.voidMetamorphosis
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerCheckboxVoidMetamorphosis"])
	f.tooltip = L["DemonHunterDevourerCheckboxVoidMetamorphosisTooltip"]
	f:SetChecked(spec.colors.bar.voidMetamorphosis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.voidMetamorphosis.enabled = self:GetChecked()
	end)

	controls.colors.voidMetamorphosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerMetamorphosis"], spec.colors.bar.voidMetamorphosis.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.voidMetamorphosis
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "voidMetamorphosis")
	end)

	--[[yCoord = yCoord - 30
	controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_EndOfMetamorphosisCheckbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosis
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerCheckboxEndOfMetamorphosis"])
	f.tooltip = L["DemonHunterDevourerCheckboxEndOfMetamorphosisTooltip"]
	f:SetChecked(spec.endOfMetamorphosis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfMetamorphosis.enabled = self:GetChecked()
	end)

	controls.colors.metamorphosisEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerMetamorphosisEnding"], spec.colors.bar.metamorphosisEnding, 250, 25, oUi.xCoord2, yCoord)
	f = controls.colors.metamorphosisEnding
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
	end)]]

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], true, false)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterDevourerHeaderSoulFragmentColors"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceFury"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.voidMetamorphosisReady = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_Checkbox_VoidMetamorphosisReady", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.voidMetamorphosisReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerCheckboxVoidMetamorphosisReady"])
	f.tooltip = L["DemonHunterDevourerCheckboxVoidMetamorphosisReadyTooltip"]
	f:SetChecked(spec.colors.comboPoints.voidMetamorphosisReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.voidMetamorphosisReady.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.voidMetamorphosisReady = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerSoulFragmentVoidMetamorphosisReady"], spec.colors.comboPoints.voidMetamorphosisReady.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.voidMetamorphosisReady
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "voidMetamorphosisReady")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.collapsingStarReady = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_Checkbox_CollapsingStarReady", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.collapsingStarReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerCheckboxCollapsingStarReady"])
	f.tooltip = L["DemonHunterDevourerCheckboxCollapsingStarReadyTooltip"]
	f:SetChecked(spec.colors.comboPoints.collapsingStarReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.collapsingStarReady.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.collapsingStarReady = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerSoulFragmentCollapsingStarReady"], spec.colors.comboPoints.collapsingStarReady.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.collapsingStarReady
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "collapsingStarReady")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerSoulFragmentBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)


	--[[yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterDevourerEndOfMetamorphosisConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_EOT_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosisModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerCheckboxMetamorphosisGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfMetamorphosis.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(false)
		spec.endOfMetamorphosis.mode = "gcd"
	end)

	title = L["DemonHunterDevourerMetamorphosisGcds"]
	controls.endOfMetamorphosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfMetamorphosis.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_EOT_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfMetamorphosisModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerCheckboxMetamorphosisTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfMetamorphosis.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(true)
		spec.endOfMetamorphosis.mode = "time"
	end)

	title = L["DemonHunterDevourerMetamorphosisTime"]
	controls.endOfMetamorphosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfMetamorphosis.timeMax = value
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], 1, DEVOURER_MAX_FURY)

	TRB.Frames.interfaceSettingsFrameContainer.controls.devourer = controls
end

local function DevourerConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devourer
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DemonHunter_Devourer_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Devourer_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterDevourerFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 12, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	
	yCoord = yCoord - 30
	controls.checkBoxes.voidRayThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_Threshold_Option_voidRay", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.voidRayThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DemonHunterDevourerThresholdCheckboxVoidRay"])
	f.tooltip = L["DemonHunterDevourerThresholdCheckboxVoidRayTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.voidRay.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.voidRay.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		--[[{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["DemonHunterDevourerThresholdSpecial"],
			enabledCheckboxLocalization = L["DemonHunterDevourerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["DemonHunterDevourerThresholdSpecialEnabledTooltip"]
		}]]
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 12, 3, yCoord, L["ResourceFury"], true, true, true, false, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 3, yCoord)
end

local function DevourerConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devourer
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DemonHunter_Devourer_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Devourer_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterDevourerFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 12, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 12, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterDevourerTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 12, 3, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerTextColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	--[[controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerTextColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)]]

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DemonHunterDevourerColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 12, 3, yCoord)
end

local function DevourerConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 12
	local specId = 1
	local spec = TRB.Data.settings.demonhunter.devourer

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devourer
	local yCoord = 5

	controls.buttons.exportButton_DemonHunter_Devourer_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Devourer_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterDevourerFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function DevourerConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.demonhunter.devourer
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devourer
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DemonHunter_Devourer_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DemonHunter_Devourer_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterDevourerFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 12, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 12, 3, yCoord, cache)
end

local function DevourerConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(12, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.devourer or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.devourerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Devourer", UIParent)
	interfaceSettingsFrame.devourerDisplayPanel.name = L["DemonHunterDevourer"].. " " .. L["DemonHunter"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.devourerDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["devourer"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.devourerDisplayPanel, L["DemonHunterDevourerFull"])
	
	parent = interfaceSettingsFrame.devourerDisplayPanel

	controls.buttons = controls.buttons or {}

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DemonHunterDevourer"].. " " .. L["DemonHunter"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.devourerDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Devourer_devourerDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.devourerDemonHunterEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DemonHunterDevourerFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.devourer)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.demonhunter.devourer = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devourerDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.devourer, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devourerDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.devourer, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_DemonHunter_Devourer_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_DemonHunter_Devourer_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DemonHunterDevourerFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 12, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.devourer = controls

	DevourerConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	DevourerConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	DevourerConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	DevourerConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	DevourerConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	DevourerConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	HavocConstructOptionsPanel(specCache.havoc)
	VengeanceConstructOptionsPanel(specCache.vengeance)
	DevourerConstructOptionsPanel(specCache.devourer)
end
TRB.Options.DemonHunter.ConstructOptionsPanel = ConstructOptionsPanel