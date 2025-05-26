local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on a Evoker!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

local barContainerFrame = TRB.Frames.barContainerFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame

TRB.Options.Evoker = {}
TRB.Options.Evoker.Devastation = {}
TRB.Options.Evoker.Preservation = {}
TRB.Options.Evoker.Augmentation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = {}

local function EvokerLoadExtraBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid=TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=0}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Essence1"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence1"],
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
			guid=TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=1}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Essence2"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence2"],
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
			guid=TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=2}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Essence3"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence3"],
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
			guid=TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=3}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Essence4"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence4"],
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
			guid=TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=4}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Essence5"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence5"],
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
			guid=TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=5}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
			name = L["Essence6"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence6"],
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

-- Devastation
local function DevastationLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
			text="{$passive}[$passive + ]",
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

	local extraTextSettings = EvokerLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.Evoker.DevastationLoadDefaultBarTextSimpleSettings = DevastationLoadDefaultBarTextSimpleSettings

local function DevastationLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$ttd}[||nTTD: $ttd]",
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
			text="$mana",
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

	local extraTextSettings = EvokerLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function DevastationLoadDefaultSettings(includeBarText)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		generation = {
			mode="gcd",
			gcds=1,
			time=1.5,
			enabled=true
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		bar = {
			width=555,
			height=16,
			xPos=0,
			yPos=-215,
			border=2,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false
		},
		comboPoints = {
			width=25,
			height=16,
			xPos=0,
			yPos=4,
			border=2,
			spacing=14,
			relativeTo="TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth=true,
		},
		colors = {
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
				passive="FF8080FF",
				essenceBurst = {
					color = "FFFCE58E",
					enabled = true
				},
				essenceBurst2 = {
					color = "FFAF9942",
					enabled = true
				},
				meltArmor={
					color = "FFFF9900",
					enabled = true
				},
				showPassive=false,
				showCasting=true
			},
			comboPoints = {
				border="FF246759",
				background="66000000",
				base="FF33937F",
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
				outOfRange = {
					color = "FF440000",
					enabled = true
				}
			},
			endCap = {
				base = {
					color = "FFFFFFFF",
					enabled = false,
					width = 2
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
			essenceBurst={
				name = L["EvokerAudioEssenceBurstStack1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			essenceBurst2={
				name = L["EvokerAudioEssenceBurstStack2"],
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
			passiveBar="Interface\\TargetingFrame\\UI-StatusBar",
			passiveBarName="Blizzard",
			castingBar="Interface\\TargetingFrame\\UI-StatusBar",
			castingBarName="Blizzard",
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
		settings.displayText.barText = DevastationLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

-- Preservation
local function PreservationLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting + ]{$passive}[$passive + ]$mana/$manaMax $manaPercent%",
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

	local extraTextSettings = EvokerLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.Evoker.PreservationLoadDefaultBarTextSimpleSettings = PreservationLoadDefaultBarTextSimpleSettings

local function PreservationLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$potionCooldown}[#slumberingSoulSerum $potionCooldown] ",
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting+]{$passive}[$passive+]$mana/$manaMax $manaPercent%",
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

	local extraTextSettings = EvokerLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function PreservationLoadDefaultSettings(includeBarText)
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
				algariManaPotionRank1 = {
					enabled = false,
				},
				algariManaPotionRank2 = {
					enabled = false,
				},
				algariManaPotionRank3 = {
					enabled = true,
				},
				cavedwellersDelightRank1 = {
					enabled = false,
				},
				cavedwellersDelightRank2 = {
					enabled = false,
				},
				cavedwellersDelightRank3 = {
					enabled = true,
				},
				slumberingSoulSerumRank1 = {
					enabled = false,
				},
				slumberingSoulSerumRank2 = {
					enabled = false,
				},
				slumberingSoulSerumRank3 = {
					enabled = true,
				},
			},
			potionCooldown = {
				enabled=true,
				mode="time",
				gcdsMax=40,
				timeMax=60
			},
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
		passiveGeneration = {
			innervate = true,
			manaTideTotem = true,
			symbolOfHope = true,
			blessingOfWinter = true
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
				innervate="FF00FF00",
				potionOfChilledClarity="FF9EC51E",
				spending="FFFFFFFF",
				passive="FF8080FF",
				innervateBorderChange=true,
				potionOfChilledClarityBorderChange=true,
				essenceBurst = {
					color = "FFFCE58E",
					enabled = true
				},
				essenceBurst2 = {
					color = "FFAF9942",
					enabled = true
				},
				temporalBurst={
					color = "FFFCE58E",
					enabled = true
				},
				showPassive=true,
				showCasting=true
			},
			comboPoints = {
				border="FF246759",
				background="66000000",
				base="FF33937F",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false
			},
			threshold = {
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				},
				passive = {
					color = "FF8080FF"
				}
			},
			endCap = {
				base = {
					color = "FFFFFFFF",
					enabled = false,
					width = 2
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
			innervate={
				name = L["Innervate"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			essenceBurst={
				name = L["EvokerAudioEssenceBurstStack1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			essenceBurst2={
				name = L["EvokerAudioEssenceBurstStack2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures={
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			resourceBar="Interface\\TargetingFrame\\UI-StatusBar",
			resourceBarName="Blizzard",
			passiveBar="Interface\\TargetingFrame\\UI-StatusBar",
			passiveBarName="Blizzard",
			castingBar="Interface\\TargetingFrame\\UI-StatusBar",
			castingBarName="Blizzard",
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
		settings.displayText.barText = PreservationLoadDefaultBarTextSimpleSettings()
	end

	return settings
end


-- Augmentation
local function AugmentationLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
			text="$mana",
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

	local extraTextSettings = EvokerLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.Evoker.AugmentationLoadDefaultBarTextSimpleSettings = AugmentationLoadDefaultBarTextSimpleSettings

local function AugmentationLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$ttd}[||nTTD: $ttd]",
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
			text="$mana",
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

	local extraTextSettings = EvokerLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function AugmentationLoadDefaultSettings(includeBarText)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		bar = {
			width=555,
			height=16,
			xPos=0,
			yPos=-215,
			border=2,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false
		},
		comboPoints = {
			width=25,
			height=16,
			xPos=0,
			yPos=4,
			border=2,
			spacing=14,
			relativeTo="TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth=true,
		},
		colors = {
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
				passive="FF8080FF",
				essenceBurst = {
					color = "FFFCE58E",
					enabled = true
				},
				essenceBurst2 = {
					color = "FFAF9942",
					enabled = true
				},
				meltArmor={
					color = "FFFF9900",
					enabled = true
				},
				temporalBurst={
					color = "FFFCE58E",
					enabled = true
				},
				showPassive=false,
				showCasting=true
			},
			comboPoints = {
				border="FF246759",
				background="66000000",
				base="FF33937F",
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
				outOfRange = {
					color = "FF440000",
					enabled = true
				}
			},
			endCap = {
				base = {
					color = "FFFFFFFF",
					enabled = false,
					width = 2
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
			essenceBurst={
				name = L["EvokerAudioEssenceBurstStack1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			essenceBurst2={
				name = L["EvokerAudioEssenceBurstStack2"],
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
			passiveBar="Interface\\TargetingFrame\\UI-StatusBar",
			passiveBarName="Blizzard",
			castingBar="Interface\\TargetingFrame\\UI-StatusBar",
			castingBarName="Blizzard",
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
		settings.displayText.barText = AugmentationLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.evoker.devastation = DevastationLoadDefaultSettings(includeBarText)
	settings.evoker.preservation = PreservationLoadDefaultSettings(includeBarText)
	settings.evoker.augmentation = AugmentationLoadDefaultSettings(includeBarText)
	return settings
end
TRB.Options.Evoker.LoadDefaultSettings = LoadDefaultSettings

--[[

Devastation Option Menus

]]


local function DevastationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.devastation
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["EvokerDevastationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.devastation = DevastationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["EvokerDevastationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DevastationLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["EvokerDevastation"]), L["Evoker"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DevastationLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls
end

local function DevastationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Devastation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 1, yCoord, true, L["ResourceEssence"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.meltArmor = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerDevastationColorPickerMeltArmor"], spec.colors.bar.meltArmor.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.meltArmor
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "meltArmor")
	end)

	controls.checkBoxes.meltArmor = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_Checkbox_meltArmor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.meltArmor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerDevastationCheckboxMeltArmor"])
	f.tooltip = L["EvokerDevastationCheckboxMeltArmorTooltip"]
	f:SetChecked(spec.colors.bar.meltArmor.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.meltArmor.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndCapOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], false, false)
	
	yCoord = yCoord - 30
	controls.checkBoxes.essenceBurstBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_Threshold_Option_essenceBurstBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.essenceBurstBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAudioEssenceBurstStack1"])
	f.tooltip = L["EvokerCheckboxEssenceBurstStack1Tooltip"]
	f:SetChecked(spec.colors.bar.essenceBurst.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.essenceBurst.enabled = self:GetChecked()
	end)

	controls.colors.essenceBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBurstStack1"], spec.colors.bar.essenceBurst.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.essenceBurst
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.essenceBurst2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_Threshold_Option_essenceBurst2BorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.essenceBurst2BorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAudioEssenceBurstStack2"])
	f.tooltip = L["EvokerCheckboxEssenceBurstStack2Tooltip"]
	f:SetChecked(spec.colors.bar.essenceBurst2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.essenceBurst2.enabled = self:GetChecked()
	end)

	controls.colors.essenceBurst2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBurstStack2"], spec.colors.bar.essenceBurst2.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.essenceBurst2
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst2")
	end)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)		

	TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls
end

local function DevastationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Devastation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 1, yCoord)
end

local function DevastationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 1
	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5

	controls.buttons.exportButton_Evoker_Devastation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "essenceBurst", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurstStack1"], L["EvokerAudioCheckboxEssenceBurstStack1Tooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "essenceBurst2", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurstStack2"], L["EvokerAudioCheckboxEssenceBurstStack2Tooltip"])
end

local function DevastationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Evoker_Devastation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 1, yCoord, cache)
end

local function DevastationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.devastation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.devastationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Devastation", UIParent)
	interfaceSettingsFrame.devastationDisplayPanel.name = L["EvokerDevastationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.devastationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["devastation"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.devastationDisplayPanel, L["EvokerDevastationFull"])

	parent = interfaceSettingsFrame.devastationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerDevastationFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.devastationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_devastationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.devastationEvokerEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["EvokerDevastationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.evoker.devastation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.evoker.devastation = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devastationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.devastation, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devastationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.devastation, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Evoker_Devastation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Evoker_Devastation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 1, true, true, true, true, true, false)
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
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines. Don't let this tab be made/rendered.
		]]
		if i == 2 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls

	DevastationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--DevastationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	DevastationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	DevastationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	DevastationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	DevastationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Preservation Option Menus

]]

local function PreservationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.preservation
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.preservation = PreservationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = PreservationLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = PreservationLoadDefaultBarTextAdvancedSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[
	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = PreservationLoadDefaultBarTextNarrowAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = controls
end

local function PreservationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Preservation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 2, yCoord, true, L["ResourceEssence"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"])
	
	yCoord = yCoord - 30
	controls.colors.temporalBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerPreservationColorPickerTemporalBurst"], spec.colors.bar.temporalBurst.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.temporalBurst
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "temporalBurst")
	end)

	controls.checkBoxes.temporalBurst = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Checkbox_temporalBurst", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.temporalBurst
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerPreservationCheckboxTemporalBurst"])
	f.tooltip = L["EvokerPreservationCheckboxTemporalBurstTooltip"]
	f:SetChecked(spec.colors.bar.temporalBurst.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.temporalBurst.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showCastingBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
	f.tooltip = L["ShowCastingBarCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.showCasting)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.showCasting = self:GetChecked()
	end)

	controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCasting"], spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame)
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndCapOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], false, true)
	
	yCoord = yCoord - 30
	controls.checkBoxes.essenceBurstBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Threshold_Option_essenceBurstBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.essenceBurstBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAudioEssenceBurstStack1"])
	f.tooltip = L["EvokerCheckboxEssenceBurstStack1Tooltip"]
	f:SetChecked(spec.colors.bar.essenceBurst.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.essenceBurst.enabled = self:GetChecked()
	end)

	controls.colors.essenceBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBurstStack1"], spec.colors.bar.essenceBurst.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.essenceBurst
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.essenceBurst2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Threshold_Option_essenceBurst2BorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.essenceBurst2BorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAudioEssenceBurstStack2"])
	f.tooltip = L["EvokerCheckboxEssenceBurstStack2Tooltip"]
	f:SetChecked(spec.colors.bar.essenceBurst2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.essenceBurst2.enabled = self:GetChecked()
	end)

	controls.colors.essenceBurst2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBurstStack2"], spec.colors.bar.essenceBurst2.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.essenceBurst2
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst2")
	end)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)
end

local function PreservationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Evoker_Preservation_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 13, 2, false, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 13, 2, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 13, 2, yCoord, true)

	yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 13, 2, yCoord)
end

local function PreservationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Preservation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 13, 2, yCoord)

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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 2, yCoord)
end

local function PreservationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 2
	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Evoker_Preservation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "innervate", spec, classId, specId, yCoord, L["HealerAudioCheckboxInnervate"], L["HealerAudioCheckboxInnervateTooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "essenceBurst", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurstStack1"], L["EvokerAudioCheckboxEssenceBurstStack1Tooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "essenceBurst2", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurstStack2"], L["EvokerAudioCheckboxEssenceBurstStack2Tooltip"])
	
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerPassiveExternalManaGenerationTrackingHeader"], oUi.xCoord, yCoord)
			
	yCoord = yCoord - 30
	controls.checkBoxes.blessingOfWinterRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_BlessingOfWinterMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blessingOfWinterRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackBlessingOfWinter"])
	f.tooltip = L["HealerCheckboxTrackBlessingOfWinterTooltip"]
	f:SetChecked(spec.passiveGeneration.blessingOfWinter)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.blessingOfWinter = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.innervateRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackInnervate"])
	f.tooltip = L["HealerCheckboxTrackInnervateTooltip"]
	f:SetChecked(spec.passiveGeneration.innervate)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.innervate = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.manaTideTotemRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackManaTideTotem"])
	f.tooltip = L["HealerCheckboxTrackManaTideTotemTooltip"]
	f:SetChecked(spec.passiveGeneration.manaTideTotem)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.manaTideTotem = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.symbolOfHopeRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackSymbolOfHope"])
	f.tooltip = L["HealerCheckboxTrackSymbolOfHopeTooltip"]
	f:SetChecked(spec.passiveGeneration.symbolOfHope)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.symbolOfHope = self:GetChecked()
	end)
end

local function PreservationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Evoker_Preservation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 2, yCoord, cache)
end

local function PreservationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.preservation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.preservationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Preservation", UIParent)
	interfaceSettingsFrame.preservationDisplayPanel.name = L["EvokerPreservationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.preservationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["preservation"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.preservationDisplayPanel, L["EvokerPreservationFull"])

	parent = interfaceSettingsFrame.preservationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerPreservationFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.preservationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_preservationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.preservationEvokerEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["EvokerPreservationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.evoker.preservation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.evoker.preservation = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.preservationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.preservation, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.preservationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.preservation, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Evoker_Preservation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Evoker_Preservation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = controls

	PreservationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	PreservationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	PreservationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	PreservationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	PreservationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	PreservationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end




--[[

Augmentation Option Menus

]]


local function AugmentationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.augmentation = AugmentationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AugmentationLoadDefaultBarTextSimpleSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AugmentationLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls
end

local function AugmentationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Augmentation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 3, yCoord, true, L["ResourceEssence"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.meltArmor = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerAugmentationColorPickerMeltArmor"], spec.colors.bar.meltArmor.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.meltArmor
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "meltArmor")
	end)

	controls.checkBoxes.meltArmor = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Checkbox_meltArmor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.meltArmor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationCheckboxMeltArmor"])
	f.tooltip = L["EvokerAugmentationCheckboxMeltArmorTooltip"]
	f:SetChecked(spec.colors.bar.meltArmor.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.meltArmor.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.colors.temporalBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerAugmentationColorPickerTemporalBurst"], spec.colors.bar.temporalBurst.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.temporalBurst
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "temporalBurst")
	end)

	controls.checkBoxes.temporalBurst = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Checkbox_temporalBurst", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.temporalBurst
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationCheckboxTemporalBurst"])
	f.tooltip = L["EvokerAugmentationCheckboxTemporalBurstTooltip"]
	f:SetChecked(spec.colors.bar.temporalBurst.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.temporalBurst.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndCapOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], false, false)
	
	yCoord = yCoord - 30
	controls.checkBoxes.essenceBurstBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Threshold_Option_essenceBurstBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.essenceBurstBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAudioEssenceBurstStack1"])
	f.tooltip = L["EvokerCheckboxEssenceBurstStack1Tooltip"]
	f:SetChecked(spec.colors.bar.essenceBurst.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.essenceBurst.enabled = self:GetChecked()
	end)

	controls.colors.essenceBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBurstStack1"], spec.colors.bar.essenceBurst.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.essenceBurst
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.essenceBurst2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Threshold_Option_essenceBurst2BorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.essenceBurst2BorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAudioEssenceBurstStack2"])
	f.tooltip = L["EvokerCheckboxEssenceBurstStack2Tooltip"]
	f:SetChecked(spec.colors.bar.essenceBurst2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.essenceBurst2.enabled = self:GetChecked()
	end)

	controls.colors.essenceBurst2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBurstStack2"], spec.colors.bar.essenceBurst2.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.essenceBurst2
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst2")
	end)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls
end

local function AugmentationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Augmentation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 13, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 3, yCoord)
end

local function AugmentationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 3
	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5

	controls.buttons.exportButton_Evoker_Augmentation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "essenceBurst", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurstStack1"], L["EvokerAudioCheckboxEssenceBurstStack1Tooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "essenceBurst2", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurstStack2"], L["EvokerAudioCheckboxEssenceBurstStack2Tooltip"])
end

local function AugmentationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Evoker_Augmentation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 3, yCoord, cache)
end

local function AugmentationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.augmentation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.augmentationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Augmentation", UIParent)
	interfaceSettingsFrame.augmentationDisplayPanel.name = L["EvokerAugmentationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.augmentationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["augmentation"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.augmentationDisplayPanel, L["EvokerAugmentationFull"])

	parent = interfaceSettingsFrame.augmentationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerAugmentationFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.augmentationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_augmentationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.augmentationEvokerEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["EvokerAugmentationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.evoker.augmentation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.evoker.augmentation = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.augmentationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.augmentation, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.augmentationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.augmentation, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Evoker_Augmentation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Evoker_Augmentation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 3, true, true, true, true, true, false)
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
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines. Don't let this tab be made/rendered.
		]]
		if i == 2 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls

	AugmentationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--AugmentationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	AugmentationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	AugmentationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	AugmentationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	AugmentationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	
	DevastationConstructOptionsPanel(specCache.devastation)
	PreservationConstructOptionsPanel(specCache.preservation)
	AugmentationConstructOptionsPanel(specCache.augmentation)
end
TRB.Options.Evoker.ConstructOptionsPanel = ConstructOptionsPanel