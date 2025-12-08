local _, TRB = ...
if TRB.Data.character.classId ~= 6 then --Only do this if we're on a Death Knight!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

local barContainerFrame = TRB.Frames.barContainerFrame

TRB.Options.DeathKnight = {}
TRB.Options.DeathKnight.Blood = {}
TRB.Options.DeathKnight.Frost = {}
TRB.Options.DeathKnight.Unholy = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.blood = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.frost = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.unholy = {}

local BLOOD_MAX_RUNIC_POWER = 125
local FROST_MAX_RUNIC_POWER = 110
local UNHOLY_MAX_RUNIC_POWER = 100

local function DeathKnightLoadExtraBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune1Time}[$rune1Time]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Rune1"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune1"],
				yPos = 0,
				relativeToFrame = "ComboPoint_1",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune2Time}[$rune2Time]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Rune2"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune2"],
				yPos = 0,
				relativeToFrame = "ComboPoint_2",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune3Time}[$rune3Time]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Rune3"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune3"],
				yPos = 0,
				relativeToFrame = "ComboPoint_3",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune4Time}[$rune4Time]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Rune4"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune4"],
				yPos = 0,
				relativeToFrame = "ComboPoint_4",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune5Time}[$rune5Time]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Rune5"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune5"],
				yPos = 0,
				relativeToFrame = "ComboPoint_5",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune6Time}[$rune6Time]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Rune6"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune6"],
				yPos = 0,
				relativeToFrame = "ComboPoint_6",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		}
	}

	return textSettings
end

-- Blood
local function BloodLoadDefaultBarTextSimpleSettings()
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
			text="$runicPower",
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

	local extraTextSettings = DeathKnightLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.DeathKnight.BloodLoadDefaultBarTextSimpleSettings = BloodLoadDefaultBarTextSimpleSettings

local function BloodLoadDefaultBarTextAdvancedSettings()
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
			text="$runicPower",
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
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function BloodLoadDefaultSettings(includeBarText)
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
				deathCoil = {
					enabled = true
				},
				deathStrike = {
					enabled = true
				},
				raiseAlly = {
					enabled = true
				}
			}
		},
		maxResource = {
			value = BLOOD_MAX_RUNIC_POWER,
			enabled = false
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
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
		colors={
			text = {
				current = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				}
			},
			bar={
				border="FF009ABD",
				background="66000000",
				base="FF00D1FF",
			},
			comboPoints = {
				border="FF980002",
				background="66000000",
				base="FFC41E3A",
				cooldown="FFCCCCCC",
				sortRunes = true
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
		textures={
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
		settings.displayText.barText = BloodLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

-- Frost
local function FrostLoadDefaultBarTextSimpleSettings()
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
			text="$runicPower",
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
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.DeathKnight.FrostLoadDefaultBarTextSimpleSettings = FrostLoadDefaultBarTextSimpleSettings

local function FrostLoadDefaultBarTextAdvancedSettings()
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
			text="$runicPower",
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
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function FrostLoadDefaultSettings(includeBarText)
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
				deathCoil = {
					enabled = true
				},
				deathStrike = {
					enabled = true
				},
				breathOfSindragosa = {
					enabled = true
				},
				frostStrike = {
					enabled = true
				},
				glacialAdvance = {
					enabled = true
				}
			}
		},
		maxResource = {
			value = FROST_MAX_RUNIC_POWER,
			enabled = false
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
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
		colors={
			text = {
				current = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				}
			},
			bar={
				border="FF009ABD",
				background="66000000",
				base="FF00D1FF",
			},
			comboPoints = {
				border="FF006BAD",
				background="66000000",
				base="FF368BC1",
				cooldown="FFCCCCCC",
				sortRunes = true
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
		textures={
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
		settings.displayText.barText = FrostLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function UnholyLoadDefaultBarTextSimpleSettings()
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
			text="$runicPower",
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
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.DeathKnight.UnholyLoadDefaultBarTextSimpleSettings = UnholyLoadDefaultBarTextSimpleSettings

local function UnholyLoadDefaultBarTextAdvancedSettings()
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
			text="$runicPower",
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
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function UnholyLoadDefaultSettings(includeBarText)
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
				deathCoil = {
					enabled = true
				},
				deathStrike = {
					enabled = true
				},
				raiseAlly = {
					enabled = true
				}
			}
		},
		maxResource = {
			value = UNHOLY_MAX_RUNIC_POWER,
			enabled = false
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
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
		colors={
			text = {
				current = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				}
			},
			bar={
				border="FF009ABD",
				background="66000000",
				base="FF00D1FF",
			},
			comboPoints = {
				border="FF12721A",
				background="66000000",
				base="FFA6FF49",
				cooldown="FFCCCCCC",
				sortRunes = true
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
		textures={
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
		settings.displayText.barText = UnholyLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.deathknight.blood = BloodLoadDefaultSettings(includeBarText)
	settings.deathknight.frost = FrostLoadDefaultSettings(includeBarText)
	settings.deathknight.unholy = UnholyLoadDefaultSettings(includeBarText)
	return settings
end
TRB.Options.DeathKnight.LoadDefaultSettings = LoadDefaultSettings


--[[

Blood Option Menus

]]

local function BloodConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.blood
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.blood = BloodLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BloodLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BloodLoadDefaultBarTextAdvancedSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BloodLoadDefaultBarTextNarrowAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.blood = controls
end

local function BloodConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.blood
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Blood_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Blood_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 6, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 6, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], L["ResourceRunes"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 6, 1, yCoord, true, L["ResourceRunes"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], "notEmpty", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], true, false)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceRunes"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerRunesBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.cooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerCooldown"], spec.colors.comboPoints.cooldown, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.cooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "cooldown")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sortRunesComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_comboPointsSortRunes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sortRunesComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxSortRunes"])
	f.tooltip = L["DeathKnightRunesCheckboxSortRunesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sortRunes)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sortRunes = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], 1, BLOOD_MAX_RUNIC_POWER)
end

local function BloodConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.blood
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Blood_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Blood_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 6, 1, false, true, false, false, false, false)
	end)

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.deathCoilThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_Threshold_Option_deathCoil", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathCoilThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathCoil"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathCoilTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathCoil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathCoil.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_Threshold_Option_deathStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathStrike"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raiseAllyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_Threshold_Option_raiseAlly", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raiseAllyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxRaiseAlly"])
	f.tooltip = L["DeathKnightThresholdCheckboxRaiseAllyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.raiseAlly.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.raiseAlly.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 6, 1, yCoord)
end

local function BloodConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.blood
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DeathKnight_Blood_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Blood_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 6, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 6, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerRunicPowerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 6, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCurrentRunicPower"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCastingRunicPower"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	--[[yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerPassiveRunicPower"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)]]

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 6, 1, yCoord)
end

local function BloodConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 6
	local specId = 1
	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.blood
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Blood_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Blood_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function BloodConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.blood
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DeathKnight_Blood_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Blood_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 6, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 6, 1, yCoord, cache)
end

local function BloodConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(6, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.blood or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.bloodDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DeathKnight_Blood", UIParent)
	interfaceSettingsFrame.bloodDisplayPanel.name = L["DeathKnightBloodFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.bloodDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["blood"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.bloodDisplayPanel, L["DeathKnightBloodFull"])
	
	parent = interfaceSettingsFrame.bloodDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightBloodFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.bloodDeathKnightEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_bloodDeathKnightEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.bloodDeathKnightEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DeathKnightBloodFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.deathknight.blood)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.deathknight.blood = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.bloodDeathKnightEnabled, TRB.Data.settings.core.enabled.deathknight.blood, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.bloodDeathKnightEnabled, TRB.Data.settings.core.enabled.deathknight.blood, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_DeathKnight_Blood_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_DeathKnight_Blood_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 6, 1, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.blood = controls

	BloodConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	BloodConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	BloodConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	BloodConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	BloodConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	BloodConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


-- Frost Option Menus
local function FrostConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.frost
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DeathKnightFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.frost = FrostLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DeathKnightFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FrostLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DeathKnightFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FrostLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.frost = controls
end

local function FrostConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.frost
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Frost_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Frost_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 6, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 6, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], L["ResourceRunes"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 6, 2, yCoord, true, L["ResourceRunes"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], "notEmpty", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], true, false)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceRunes"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerRunesBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.cooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerCooldown"], spec.colors.comboPoints.cooldown, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.cooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "cooldown")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sortRunesComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_comboPointsSortRunes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sortRunesComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxSortRunes"])
	f.tooltip = L["DeathKnightRunesCheckboxSortRunesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sortRunes)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sortRunes = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], 1, FROST_MAX_RUNIC_POWER)
end

local function FrostConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.frost
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Frost_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Frost_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 6, 2, false, true, false, false, false, false)
	end)

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.breathOfSindragosaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_breathOfSindragosa", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.breathOfSindragosaThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightFrostThresholdCheckboxBreathOfSindragosa"])
	f.tooltip = L["DeathKnightFrostThresholdCheckboxBreathOfSindragosaTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.breathOfSindragosa.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.breathOfSindragosa.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathCoilThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_deathCoil", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathCoilThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathCoil"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathCoilTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathCoil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathCoil.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_deathStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathStrike"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.frostStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_frostStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.frostStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightFrostThresholdCheckboxFrostStrike"])
	f.tooltip = L["DeathKnightFrostThresholdCheckboxFrostStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.frostStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.frostStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.glacialAdvanceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_glacialAdvance", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.glacialAdvanceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightFrostThresholdCheckboxGlacialAdvance"])
	f.tooltip = L["DeathKnightFrostThresholdCheckboxGlacialAdvanceTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.glacialAdvance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.glacialAdvance.enabled = self:GetChecked()
	end)


	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 6, 2, yCoord)
end

local function FrostConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.frost
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DeathKnight_Frost_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Frost_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 6, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 6, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightFrostRunicPowerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 6, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightFrostColorPickerCurrentRunicPower"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightFrostColorPickerCastingRunicPower"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	--[[yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightFrostColorPickerPassiveRunicPower"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)]]

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 6, 2, yCoord)
end

local function FrostConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 6
	local specId = 2
	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.frost
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Frost_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Frost_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function FrostConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.frost
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DeathKnight_Frost_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Frost_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 6, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 6, 2, yCoord, cache)
end

local function FrostConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(6, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.frost or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.frostDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DeathKnight_Frost", UIParent)
	interfaceSettingsFrame.frostDisplayPanel.name = L["DeathKnightFrostFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.frostDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["frost"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.frostDisplayPanel, L["DeathKnightFrostFull"])
	
	parent = interfaceSettingsFrame.frostDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightFrostFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.frostDeathKnightEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_frostDeathKnightEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.frostDeathKnightEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DeathKnightFrostFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.deathknight.frost)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.deathknight.frost = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.frostDeathKnightEnabled, TRB.Data.settings.core.enabled.deathknight.frost, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.frostDeathKnightEnabled, TRB.Data.settings.core.enabled.deathknight.frost, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_DeathKnight_Frost_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_DeathKnight_Frost_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 6, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.frost = controls

	FrostConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	FrostConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	FrostConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	FrostConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	FrostConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	FrostConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

-- Unholy Option Menus
local function UnholyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.unholy
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.unholy = UnholyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = UnholyLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = UnholyLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.unholy = controls
end

local function UnholyConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.unholy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Unholy_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Unholy_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 6, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 6, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], L["ResourceRunes"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 6, 3, yCoord, true, L["ResourceRunes"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], "notEmpty", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], true, false)
	

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceRunes"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerRunesBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.cooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerCooldown"], spec.colors.comboPoints.cooldown, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.cooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "cooldown")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sortRunesComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_comboPointsSortRunes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sortRunesComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxSortRunes"])
	f.tooltip = L["DeathKnightRunesCheckboxSortRunesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sortRunes)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sortRunes = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], 1, UNHOLY_MAX_RUNIC_POWER)
end

local function UnholyConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.unholy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Unholy_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Unholy_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 6, 3, false, true, false, false, false, false)
	end)

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30

	controls.checkBoxes.deathCoilThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_deathCoil", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathCoilThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathCoil"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathCoilTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathCoil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathCoil.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_deathStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathStrike"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raiseAllyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_raiseAlly", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raiseAllyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxRaiseAlly"])
	f.tooltip = L["DeathKnightThresholdCheckboxRaiseAllyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.raiseAlly.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.raiseAlly.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 6, 3, yCoord)
end

local function UnholyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.unholy
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DeathKnight_Unholy_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Unholy_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 6, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 6, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightUnholyRunicPowerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 6, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightUnholyColorPickerCurrentRunicPower"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightUnholyColorPickerCastingRunicPower"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 6, 3, yCoord)
end

local function UnholyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 6
	local specId = 3
	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.unholy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Unholy_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Unholy_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function UnholyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.unholy
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DeathKnight_Unholy_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_DeathKnight_Unholy_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 6, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 6, 3, yCoord, cache)
end

local function UnholyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(6, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.unholy or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.unholyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DeathKnight_Unholy", UIParent)
	interfaceSettingsFrame.unholyDisplayPanel.name = L["DeathKnightUnholyFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.unholyDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["unholy"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.unholyDisplayPanel, L["DeathKnightUnholyFull"])
	
	parent = interfaceSettingsFrame.unholyDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightUnholyFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.unholyDeathKnightEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_unholyDeathKnightEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.unholyDeathKnightEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["DeathKnightUnholyFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.deathknight.unholy)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.deathknight.unholy = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.unholyDeathKnightEnabled, TRB.Data.settings.core.enabled.deathknight.unholy, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.unholyDeathKnightEnabled, TRB.Data.settings.core.enabled.deathknight.unholy, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_DeathKnight_Unholy_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_DeathKnight_Unholy_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 6, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.unholy = controls

	UnholyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	UnholyConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	UnholyConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	UnholyConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	UnholyConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	UnholyConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	
	BloodConstructOptionsPanel(specCache.blood)
	FrostConstructOptionsPanel(specCache.frost)
	UnholyConstructOptionsPanel(specCache.unholy)
end
TRB.Options.DeathKnight.ConstructOptionsPanel = ConstructOptionsPanel