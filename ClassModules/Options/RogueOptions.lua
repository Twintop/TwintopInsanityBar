local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 4 then --Only do this if we're on a Rogue!
	return
end

local L = TRB.Localization
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local oUi = TRB.Data.constants.optionsUi

local barContainerFrame = TRB.Frames.barContainerFrame
local passiveFrame = TRB.Frames.passiveFrame

TRB.Options.Rogue = {}
TRB.Options.Rogue.Assassination = {}
TRB.Options.Rogue.Outlaw = {}
TRB.Options.Rogue.Subtlety = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = {}

local function AssassinationLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
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
			text="{$sadTime}[$sadTime]",
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
			text="{$passive}[$passive + ]$energy",
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
TRB.Options.Rogue.AssassinationLoadDefaultBarTextSimpleSettings = AssassinationLoadDefaultBarTextSimpleSettings

local function AssassinationLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="#garrote $garroteCount {$garroteTime}[ $garroteTime]{$isNecrolord}[{!$garroteTime}[       ]  #serratedBoneSpike $sbsCount]||n#rupture $ruptureCount {$ruptureTime}[ $ruptureTime] {$ttd}[{!$ruptureTime}[      ]  TTD: $ttd]",
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
			text="{$sadTime}[#sad $sadTime #sad]|n{$blindsideTime}[#blindside $blindsideTime #blindside]",
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

local function AssassinationLoadDefaultSettings(includeBarText)
	local settings = {
		hastePrecision=2,
		thresholds = {
			width = 2,
			overlapBorder=true,
			outOfRange=true,
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
			-- Rogue
			ambush = { --
				enabled = true, -- 1
			},
			cheapShot = { --
				enabled = false, -- 2
			},
			crimsonVial = { --
				enabled = true, -- 3
			},
			distract = { --
				enabled = false, -- 4
			},
			kidneyShot = { --
				enabled = false, -- 5
			},
			sliceAndDice = { --
				enabled = true, -- 6
			},
			feint = { --
				enabled = true, -- 7
			},
			-- Rogue Talents
			shiv = { --
				enabled = false, -- 8
			},
			sap = { --
				enabled = false, -- 9
			},
			gouge = { --
				enabled = false, -- 10
			},
			echoingReprimand = { --
				enabled = true, -- 11
			},
			-- Assassination
			envenom = { --
				enabled = true, -- 12
			},
			fanOfKnives = { --
				enabled = true, -- 13
			},
			garrote = { --
				enabled = true, -- 14
			},
			mutilate = { --
				enabled = true, -- 15
			},
			poisonedKnife = { --
				enabled = false, -- 16
			},
			rupture = { --
				enabled = true, -- 17
			},
			-- Assassination Talents
			crimsonTempest = { --
				enabled = true, -- 18
			},
			serratedBoneSpike = { --
				enabled = true, -- 19
			},
			sepsis = { --
				enabled = true, -- 20
			},
			kingsbane = { --
				enabled = true, -- 21
			},
			-- PvP					
			deathFromAbove = {
				enabled = false, -- 22
			},
			dismantle = {
				enabled = false, -- 23
			},
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
		overcap={
			mode="relative",
			relative=0,
			fixed=100
		},
		bar = {
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false,
			showPassive=true,
			showCasting=true
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
			consistentUnfilledColor = false,
			spec={
				serratedBoneSpikeColor = true
			}
		},
		colors = {
			text = {
				current="FFFFFF00",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FFD59900",
				overcap="FFFF0000",
				overThreshold="FF00FF00",
				overThresholdEnabled=false,
				overcapEnabled=true,
				dots={
					enabled=true,
					up="FFFFFFFF",
					down="FFFF0000",
					pandemic="FFFFFF00"
				}
			},
			bar = {
				border="FFFFD300",
				borderOvercap="FFFF0000",
				borderStealth="FF000000",
				background="66000000",
				base="FFFFFF00",
				noSliceAndDice="FFFF0000",
				sliceAndDicePandemic="FFFF9900",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF9F4500",
				overcapEnabled=true,
			},
			comboPoints = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				echoingReprimand="FF68CCEF",
				serratedBoneSpike="FF40BF40",
				sameColor=false
			},
			threshold = {
				under="FFFFFFFF",
				over="FF00FF00",
				unusable="FFFF0000",
				special="FFFF00FF",
				outOfRange="FF440000"
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
			overcap={
				name = L["Overcap"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			blindside={
				name = L["RogueAssassinationAudioBlindsideProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			sepsis={
				name = L["RogueAudioSepsisProc"],
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
		settings.displayText.barText = AssassinationLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function OutlawLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$rtbBuffTime}[#rollTheBones $rtbBuffTime]",
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
			text="{$sadTime}[#sliceAndDice $sadTime]",
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
			text="{$passive}[$passive + ]$energy",
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
TRB.Options.Rogue.OutlawLoadDefaultBarTextSimpleSettings = OutlawLoadDefaultBarTextSimpleSettings

local function OutlawLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$rtbBuffTime}[#rollTheBones $rtbBuffTime #rollTheBones]{$ttd}[||nTTD: $ttd]",
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
			text="{$sadTime}[#sad $sadTime #sad]",
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

local function OutlawLoadDefaultSettings(includeBarText)
	local settings = {
		hastePrecision=2,
		thresholds = {
			width = 2,
			overlapBorder=true,
			outOfRange=true,
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
			-- Rogue
			ambush = { --
				enabled = true, -- 1
			},
			cheapShot = { --
				enabled = false, -- 2
			},
			crimsonVial = { --
				enabled = true, -- 3
			},
			distract = { --
				enabled = false, -- 4
			},
			kidneyShot = { --
				enabled = false, -- 5
			},
			sliceAndDice = { --
				enabled = true, -- 6
			},
			feint = { --
				enabled = true, -- 7
			},
			-- Rogue Talents
			shiv = { --
				enabled = false, -- 8
			},
			sap = { --
				enabled = false, -- 9
			},
			gouge = { --
				enabled = false, -- 10
			},
			echoingReprimand = { --
				enabled = true, -- 11
			},
			-- Outlaw
			betweenTheEyes = {
				enabled = true, -- 12
			},
			dispatch = {
				enabled = true, -- 13
			},
			pistolShot = {
				enabled = true, -- 14
			},
			sinisterStrike = {
				enabled = true, -- 15
			},
			bladeFlurry = {
				enabled = true, -- 16
			},
			rollTheBones = {
				enabled = true, -- 17
			},
			sepsis = { --
				enabled = true, -- 18
			},
			ghostlyStrike = {
				enabled = true, -- 19
			},
			dreadblades = {
				enabled = true, -- 20
			},
			killingSpree = {
				enabled = true, -- 21
			},
			-- PvP					
			deathFromAbove = {
				enabled = false, -- 22
			},
			dismantle = {
				enabled = false, -- 23
			},
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
		overcap={
			mode="relative",
			relative=0,
			fixed=100
		},
		bar = {
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false,
			showPassive=true,
			showCasting=true
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
			consistentUnfilledColor = false
		},
		colors = {
			text = {
				current="FFFFFF00",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FFD59900",
				overcap="FFFF0000",
				overThreshold="FF00FF00",
				overThresholdEnabled=false,
				overcapEnabled=true,
				dots={
					enabled=true,
					up="FFFFFFFF",
					down="FFFF0000",
					pandemic="FFFFFF00"
				}
			},
			bar = {
				border="FFFFD300",
				borderOvercap="FFFF0000",
				borderStealth="FF000000",
				borderRtbBad="FFFF8888",
				borderRtbGood="FF00FF00",
				background="66000000",
				base="FFFFFF00",
				noSliceAndDice="FFFF0000",
				sliceAndDicePandemic="FFFF9900",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF9F4500",
				overcapEnabled=true,
			},
			comboPoints = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				echoingReprimand="FF68CCEF",
				sameColor=false
			},
			threshold = {
				under="FFFFFFFF",
				over="FF00FF00",
				unusable="FFFF0000",
				special="FFFF00FF",
				restlessBlades="FFFFFF00",
				outOfRange="FF440000"
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
			overcap={
				name = L["Overcap"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			opportunity={
				name = L["RogueOutlawAudioOpportunityProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			sepsis={
				name = L["RogueAudioSepsisProc"],
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
		settings.displayText.barText = OutlawLoadDefaultBarTextSimpleSettings()
	end

	return settings
end


local function SubtletyLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
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
			text="{$sadTime}[#sliceAndDice $sadTime]",
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
			text="{$passive}[$passive + ]$energy",
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
TRB.Options.Rogue.SubtletyLoadDefaultBarTextSimpleSettings = SubtletyLoadDefaultBarTextSimpleSettings

local function SubtletyLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="#shadowTechniques $shadowTechniquesCount    #rupture $ruptureCount {$ruptureTime}[ $ruptureTime]||n{$ttd}[TTD: $ttd] ",
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
			text="{$sadTime}[#sad $sadTime #sad]|n{$sodTime}[#sod $sodTime #sod] ",
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

local function SubtletyLoadDefaultSettings(includeBarText)
	local settings = {
		hastePrecision=2,
		thresholds = {
			width = 2,
			overlapBorder=true,
			outOfRange=true,
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
			-- Rogue
			-- Technically a Rogue ability but missing from Assassination and Outlaw
			eviscerate = {
				enabled = true, -- 1
			},
			cheapShot = {
				enabled = false, -- 2
			},
			crimsonVial = {
				enabled = true, -- 3
			},
			distract = {
				enabled = false, -- 4
			},
			kidneyShot = {
				enabled = false, -- 5
			},
			sliceAndDice = {
				enabled = true, -- 6
			},
			feint = {
				enabled = true, -- 7
			},
			-- Rogue Talents
			shiv = {
				enabled = false, -- 8
			},
			sap = {
				enabled = false, -- 9
			},
			gouge = {
				enabled = false, -- 10
			},
			echoingReprimand = {
				enabled = true, -- 11
			},
			-- Subtlety
			backstab = {
				enabled = true, -- 12
			},
			blackPowder = {
				enabled = true, -- 13
			},
			rupture = {
				enabled = true, -- 14
			},
			shadowstrike = {
				enabled = true, -- 15
			},
			shurikenStorm = {
				enabled = true, -- 16
			},
			shurikenToss = {
				enabled = true, -- 17
			},
			gloomblade = { --
				enabled = true, -- 18
			},
			secretTechnique = {
				enabled = true, -- 19
			},
			shurikenTornado = {
				enabled = true, -- 20
			},
			sepsis = {
				enabled = true, -- 21
			},
			goremawsBite = {
				enabled = true, -- 22
			},
			-- PvP					
			deathFromAbove = {
				enabled = false, -- 23
			},
			dismantle = {
				enabled = false, -- 24
			},
			shadowyDuel = {
				enabled = false, -- 25
			},
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
		overcap={
			mode="relative",
			relative=0,
			fixed=100
		},
		bar = {
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false,
			showPassive=true,
			showCasting=true
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
			consistentUnfilledColor = false
		},
		colors = {
			text = {
				current="FFFFFF00",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FFD59900",
				overcap="FFFF0000",
				overThreshold="FF00FF00",
				overThresholdEnabled=false,
				overcapEnabled=true,
				dots={
					enabled=true,
					up="FFFFFFFF",
					down="FFFF0000",
					pandemic="FFFFFF00"
				}
			},
			bar = {
				border="FFFFD300",
				borderOvercap="FFFF0000",
				borderStealth="FF000000",
				borderShadowcraft = "FF431863",
				background="66000000",
				base="FFFFFF00",
				noSliceAndDice="FFFF0000",
				sliceAndDicePandemic="FFFF9900",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF9F4500",
				overcapEnabled=true,
			},
			comboPoints = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				echoingReprimand="FF68CCEF",
				shadowTechniques="FF431863",
				sameColor=false
			},
			threshold = {
				under="FFFFFFFF",
				over="FF00FF00",
				unusable="FFFF0000",
				special="FFFF00FF",
				restlessBlades="FFFFFF00",
				outOfRange="FF440000"
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
			overcap={
				name = L["Overcap"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			sepsis={
				name = L["RogueAudioSepsisProc"],
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
		settings.displayText.barText = SubtletyLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Options.LoadDefaultSettings()

	settings.rogue.assassination = AssassinationLoadDefaultSettings(includeBarText)
	settings.rogue.outlaw = OutlawLoadDefaultSettings(includeBarText)
	settings.rogue.subtlety = SubtletyLoadDefaultSettings(includeBarText)
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.assassination
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
			spec.displayText.barText = AssassinationLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
end

local function AssassinationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Assassination_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 1, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 1, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.sliceAndDicePandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerSliceAndDicePandemic"], spec.colors.bar.sliceAndDicePandemic, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.sliceAndDicePandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "sliceAndDicePandemic")
	end)

	yCoord = yCoord - 30
	controls.colors.noSliceAndDice = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerSliceAndDiceDown"], spec.colors.bar.noSliceAndDice, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.noSliceAndDice
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noSliceAndDice")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], true, false)

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
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	controls.colors.comboPoints.serratedBoneSpike = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueAssassinationColorPickerSerratedBoneSpike"], spec.colors.comboPoints.serratedBoneSpike, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.serratedBoneSpike
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "serratedBoneSpike")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["RogueCheckboxAlwaysDefaultBackground"]
	f:SetChecked(spec.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.serratedBoneSpikeComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSerratedBoneSpikeColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.serratedBoneSpikeComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueColorPickerSeratedBoneSpike"])
	f.tooltip = L["RogueColorPickerSeratedBoneSpikeTooltip"]
	f:SetChecked(spec.comboPoints.spec.serratedBoneSpikeColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.spec.serratedBoneSpikeColor = self:GetChecked()
	end)

	yCoord = yCoord - 40

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceEnergy"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceEnergy"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
	f = controls.colors.threshold.over
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
	end)

	controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnsuable"], spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
	f = controls.colors.threshold.unusable
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
	end)

	controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueAssassinationColorPickerThresholdSpecial"], spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.special
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
	end)

	controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
	f = controls.colors.threshold.outOfRange
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
	end)

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)
	
	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ambushThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdAmbush"])
	f.tooltip = L["RogueAssassinationThresholdAmbushTooltip"]
	f:SetChecked(spec.thresholds.ambush.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.ambush.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cheapShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdCheapShot"])
	f.tooltip = L["RogueAssassinationThresholdCheapShotTooltip"]
	f:SetChecked(spec.thresholds.cheapShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.cheapShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.echoingReprimandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_echoingReprimand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.echoingReprimandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdEchoingReprimand"])
	f.tooltip = L["RogueAssassinationThresholdEchoingReprimandTooltip"]
	f:SetChecked(spec.thresholds.echoingReprimand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.echoingReprimand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.fanOfKnivesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_fanOfKnives", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fanOfKnivesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdFanOfKnives"])
	f.tooltip = L["RogueAssassinationThresholdFanOfKnivesTooltip"]
	f:SetChecked(spec.thresholds.fanOfKnives.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.fanOfKnives.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.garroteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_garrote", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.garroteThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdGarrote"])
	f.tooltip = L["RogueAssassinationThresholdGarroteTooltip"]
	f:SetChecked(spec.thresholds.garrote.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.garrote.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.gougeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdGouge"])
	f.tooltip = L["RogueAssassinationThresholdGougeTooltip"]
	f:SetChecked(spec.thresholds.gouge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.gouge.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.kingsbaneThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kingsbane", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kingsbaneThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdKingsbane"])
	f.tooltip = L["RogueAssassinationThresholdKingsbaneTooltip"]
	f:SetChecked(spec.thresholds.kingsbane.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.kingsbane.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.mutilateThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_mutilate", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mutilateThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdMutilate"])
	f.tooltip = L["RogueAssassinationThresholdMutilateTooltip"]
	f:SetChecked(spec.thresholds.mutilate.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.mutilate.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.poisonedKnifeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_poisonedKnife", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.poisonedKnifeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdPoisonedKnife"])
	f.tooltip = L["RogueAssassinationThresholdPoisonedKnifeTooltip"]
	f:SetChecked(spec.thresholds.poisonedKnife.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.poisonedKnife.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sepsisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sepsis", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sepsisThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdSepsis"])
	f.tooltip = L["RogueAssassinationThresholdSepsisTooltip"]
	f:SetChecked(spec.thresholds.sepsis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sepsis.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.serratedBoneSpikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_serratedBoneSpike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.serratedBoneSpikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdSerratedBoneSpike"])
	f.tooltip = L["RogueAssassinationThresholdSerratedBoneSpikeTooltip"]
	f:SetChecked(spec.thresholds.serratedBoneSpike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.serratedBoneSpike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shivThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdShiv"])
	f.tooltip = L["RogueAssassinationThresholdShivTooltip"]
	f:SetChecked(spec.thresholds.shiv.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shiv.enabled = self:GetChecked()
	end)


	yCoord = yCoord - 25
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.crimsonTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonTempest", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonTempestThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdCrimsonTempest"])
	f.tooltip = L["RogueAssassinationThresholdCrimsonTempestTooltip"]
	f:SetChecked(spec.thresholds.crimsonTempest.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.crimsonTempest.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.envenomThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_envenom", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.envenomThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdEnvenom"])
	f.tooltip = L["RogueAssassinationThresholdEnvenomTooltip"]
	f:SetChecked(spec.thresholds.envenom.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.envenom.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kidneyShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdKidneyShot"])
	f.tooltip = L["RogueAssassinationThresholdKidneyShotTooltip"]
	f:SetChecked(spec.thresholds.kidneyShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.kidneyShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sliceAndDiceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdSliceAndDice"])
	f.tooltip = L["RogueAssassinationThresholdSliceAndDiceTooltip"]
	f:SetChecked(spec.thresholds.sliceAndDice.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sliceAndDice.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ruptureThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_rupture", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ruptureThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdRupture"])
	f.tooltip = L["RogueAssassinationThresholdRuptureTooltip"]
	f:SetChecked(spec.thresholds.rupture.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.rupture.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25		
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonVialThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdCrimsonVial"])
	f.tooltip = L["RogueAssassinationThresholdCrimsonVialTooltip"]
	f:SetChecked(spec.thresholds.crimsonVial.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.crimsonVial.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.distractThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDistract"])
	f.tooltip = L["RogueAssassinationThresholdDistractTooltip"]
	f:SetChecked(spec.thresholds.distract.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.distract.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feintThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdFeint"])
	f.tooltip = L["RogueAssassinationThresholdFeintTooltip"]
	f:SetChecked(spec.thresholds.feint.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.feint.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdSap"])
	f.tooltip = L["RogueAssassinationThresholdSapTooltip"]
	f:SetChecked(spec.thresholds.sap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sap.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathFromAboveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDeathFromAbove"])
	f.tooltip = L["RogueAssassinationThresholdDeathFromAboveTooltip"]
	f:SetChecked(spec.thresholds.deathFromAbove.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.deathFromAbove.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dismantleThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDismantle"])
	f.tooltip = L["RogueAssassinationThresholdDismantleTooltip"]
	f:SetChecked(spec.thresholds.dismantle.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.dismantle.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], 170)

	TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
end

local function AssassinationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Assassination_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 1, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerPassiveEnergy"], spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergyAboveOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)
	

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueDotChangeColorCheckbox"])
	f.tooltip = L["RogueDotChangeColorCheckboxTooltip"]
	f:SetChecked(spec.colors.text.dots.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.dots.enabled = self:GetChecked()
	end)

	controls.colors.dots = {}

	controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerActive"], spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
	f = controls.colors.dots.up
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
	end)

	controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.pandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
	end)

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
	f = controls.colors.dots.down
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
	end)


	yCoord = yCoord - 130
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50
	title = L["SecondaryDecimalPrecision"]
	controls.hastePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.hastePrecision = value
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
end

local function AssassinationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, 1, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.blindsideAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_blindside_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blindsideAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationAudioCheckboxBlindsideProc"])
	f.tooltip = L["RogueAssassinationAudioCheckboxBlindsideProcTooltip"]
	f:SetChecked(spec.audio.blindside.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.blindside.enabled = self:GetChecked()

		if spec.audio.blindside.enabled then
			PlaySoundFile(spec.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.blindsideAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Assassination_blindside_Audio", parent)
	controls.dropDown.blindsideAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.blindsideAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.blindsideAudio, spec.audio.blindside.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.blindsideAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.blindsideAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.blindside.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.blindsideAudio:SetValue(newValue, newName)
		spec.audio.blindside.sound = newValue
		spec.audio.blindside.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.blindsideAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceEnergy"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceEnergy"])
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Assassination_overcapAudio", parent)
	controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.overcap.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.overcapAudio:SetValue(newValue, newName)
		spec.audio.overcap.sound = newValue
		spec.audio.overcap.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	
	yCoord = yCoord - 60
	controls.checkBoxes.sepsisAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_sepsis_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sepsisAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAudioCheckboxSepsisProc"])
	f.tooltip = L["RogueAudioCheckboxSepsisProcTooltip"]
	f:SetChecked(spec.audio.sepsis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.sepsis.enabled = self:GetChecked()

		if spec.audio.sepsis.enabled then
			PlaySoundFile(spec.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.sepsisAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Assassination_sepsis_Audio", parent)
	controls.dropDown.sepsisAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.sepsisAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.sepsisAudio, spec.audio.sepsis.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.sepsisAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.sepsisAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else  
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.sepsis.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.sepsisAudio:SetValue(newValue, newName)
		spec.audio.sepsis.sound = newValue
		spec.audio.sepsis.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.sepsisAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
	end
	yCoord = yCoord - 60
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackEnergyRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegen"])
	f.tooltip = L["CheckboxTrackEnergyRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = L["RogueCheckboxEnergyRegenGcdsTooltip"]
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
	controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = L["RogueCheckboxEnergyRegenTimeTooltip"]
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
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
end

local function AssassinationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Rogue_Assassination_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 4, 1, yCoord, cache)
end

local function AssassinationConstructOptionsPanel(cache)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.assassination or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.assassinationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Assassination", UIParent)
	interfaceSettingsFrame.assassinationDisplayPanel.name = L["RogueAssassinationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.assassinationDisplayPanel.parent = parent.name
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.assassinationDisplayPanel, L["RogueAssassinationFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.assassinationDisplayPanel)

	parent = interfaceSettingsFrame.assassinationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["RogueAssassinationFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.assassinationRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_assassinationRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.assassinationRogueEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["RogueAssassinationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.rogue.assassination)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.rogue.assassination = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Rogue_Assassination_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Rogue_Assassination_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 1, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Rogue_Assassination_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls

	AssassinationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	AssassinationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	AssassinationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	AssassinationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	AssassinationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end


--[[

Outlaw Option Menus

]]

local function OutlawConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw
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
			spec.displayText.barText = OutlawLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextSimple")
	end)

	yCoord = yCoord - 40
	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
end

local function OutlawConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Outlaw_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 2, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 2, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.sliceAndDicePandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerSliceAndDicePandemic"], spec.colors.bar.sliceAndDicePandemic, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.sliceAndDicePandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "sliceAndDicePandemic")
	end)

	yCoord = yCoord - 30
	controls.colors.noSliceAndDice = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerSliceAndDiceDown"], spec.colors.bar.noSliceAndDice, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.noSliceAndDice
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noSliceAndDice")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], true, false)

	yCoord = yCoord - 30
	controls.colors.borderRtbGood = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueOutlawColorPickerRollTheBonesHold"], spec.colors.bar.borderRtbGood, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderRtbGood
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderRtbGood")
	end)

	yCoord = yCoord - 30
	controls.colors.borderRtbBad = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueOutlawColorPickerRollTheBonesUse"], spec.colors.bar.borderRtbBad, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderRtbBad
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderRtbBad")
	end)

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
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["RogueOutlawCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)


	yCoord = yCoord - 40

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceEnergy"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceEnergy"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
	f = controls.colors.threshold.over
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
	end)

	controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnsuable"], spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
	f = controls.colors.threshold.unusable
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
	end)

	controls.colors.threshold.restlessBlades = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueAssassinationColorPickerThresholdRestlessBlades"], spec.colors.threshold.restlessBlades, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.restlessBlades
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "restlessBlades")
	end)

	controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueAssassinationColorPickerThresholdSpecial"], spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-120)
	f = controls.colors.threshold.special
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
	end)

	controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-150)
	f = controls.colors.threshold.outOfRange
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
	end)

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-180)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-200)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)
	
	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ambushThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdAmbush"])
	f.tooltip = L["RogueOutlawThresholdAmbushTooltip"]
	f:SetChecked(spec.thresholds.ambush.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.ambush.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cheapShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdCheapShot"])
	f.tooltip = L["RogueOutlawThresholdCheapShotTooltip"]
	f:SetChecked(spec.thresholds.cheapShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.cheapShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dreadbladesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dreadblades", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dreadbladesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDreadblades"])
	f.tooltip = L["RogueOutlawThresholdDreadbladesTooltip"]
	f:SetChecked(spec.thresholds.dreadblades.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.dreadblades.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.echoingReprimandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_echoingRep", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.echoingReprimandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdEchoingReprimand"])
	f.tooltip = L["RogueOutlawThresholdEchoingReprimandTooltip"]
	f:SetChecked(spec.thresholds.echoingReprimand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.echoingReprimand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ghostlyStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_ghostlyStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ghostlyStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdGhostlyStrike"])
	f.tooltip = L["RogueOutlawThresholdGhostlyStrikeTooltip"]
	f:SetChecked(spec.thresholds.ghostlyStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.ghostlyStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.gougeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdGouge"])
	f.tooltip = L["RogueOutlawThresholdGougeTooltip"]
	f:SetChecked(spec.thresholds.gouge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.gouge.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.pistolShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_pistolShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.pistolShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdPistolShot"])
	f.tooltip = L["RogueOutlawThresholdPistolShotTooltip"]
	f:SetChecked(spec.thresholds.pistolShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.pistolShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sepsisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sepsis", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sepsisThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSepsis"])
	f.tooltip = L["RogueOutlawThresholdSepsisTooltip"]
	f:SetChecked(spec.thresholds.sepsis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sepsis.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shivThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdShiv"])
	f.tooltip = L["RogueOutlawThresholdShivTooltip"]
	f:SetChecked(spec.thresholds.shiv.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shiv.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sinisterStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sinisterStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sinisterStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSinisterStrike"])
	f.tooltip = L["RogueOutlawThresholdSinisterStrikeTooltip"]
	f:SetChecked(spec.thresholds.sinisterStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sinisterStrike.enabled = self:GetChecked()
	end)


	yCoord = yCoord - 25
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.betweenTheEyesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_betweenTheEyes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.betweenTheEyesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdBetweenTheEyes"])
	f.tooltip = L["RogueOutlawThresholdBetweenTheEyesTooltip"]
	f:SetChecked(spec.thresholds.betweenTheEyes.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.betweenTheEyes.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dispatchThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dispatch", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dispatchThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDispatch"])
	f.tooltip = L["RogueOutlawThresholdDispatchTooltip"]
	f:SetChecked(spec.thresholds.dispatch.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.dispatch.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kidneyShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdKidneyShot"])
	f.tooltip = L["RogueOutlawThresholdKidneyShotTooltip"]
	f:SetChecked(spec.thresholds.kidneyShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.kidneyShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killingSpreeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_killingSpree", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killingSpreeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdKillingSpree"])
	f.tooltip = L["RogueOutlawThresholdKillingSpreeTooltip"]
	f:SetChecked(spec.thresholds.killingSpree.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.killingSpree.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sliceAndDiceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSliceAndDice"])
	f.tooltip = L["RogueOutlawThresholdSliceAndDiceTooltip"]
	f:SetChecked(spec.thresholds.sliceAndDice.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sliceAndDice.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25		
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.bladeFlurryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_bladeFlurry", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.bladeFlurryThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdBladeFlurry"])
	f.tooltip = L["RogueOutlawThresholdBladeFlurryTooltip"]
	f:SetChecked(spec.thresholds.bladeFlurry.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.bladeFlurry.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonVialThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdCrimsonVial"])
	f.tooltip = L["RogueOutlawThresholdCrimsonVialTooltip"]
	f:SetChecked(spec.thresholds.crimsonVial.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.crimsonVial.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.distractThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDistract"])
	f.tooltip = L["RogueOutlawThresholdDistractTooltip"]
	f:SetChecked(spec.thresholds.distract.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.distract.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feintThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdFeint"])
	f.tooltip = L["RogueOutlawThresholdFeintTooltip"]
	f:SetChecked(spec.thresholds.feint.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.feint.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.rollTheBonesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_rollTheBones", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rollTheBonesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdRollTheBones"])
	f.tooltip = L["RogueOutlawThresholdRollTheBonesTooltip"]
	f:SetChecked(spec.thresholds.rollTheBones.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.rollTheBones.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSap"])
	f.tooltip = L["RogueOutlawThresholdSapTooltip"]
	f:SetChecked(spec.thresholds.sap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sap.enabled = self:GetChecked()
	end)
	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathFromAboveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDeathFromAbove"])
	f.tooltip = L["RogueOutlawThresholdDeathFromAboveTooltip"]
	f:SetChecked(spec.thresholds.deathFromAbove.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.deathFromAbove.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dismantleThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDismantle"])
	f.tooltip = L["RogueAssassinationThresholdDismantleTooltip"]
	f:SetChecked(spec.thresholds.dismantle.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.dismantle.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], 170)

	TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
end

local function OutlawConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Outlaw_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 2, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerPassiveEnergy"], spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergyAboveOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)
	

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueDotChangeColorCheckbox"])
	f.tooltip = L["RogueDotChangeColorCheckboxTooltip"]
	f:SetChecked(spec.colors.text.dots.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.dots.enabled = self:GetChecked()
	end)

	controls.colors.dots = {}

	controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerActive"], spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
	f = controls.colors.dots.up
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
	end)

	controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.pandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
	end)

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
	f = controls.colors.dots.down
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
	end)


	yCoord = yCoord - 130
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50
	title = L["SecondaryDecimalPrecision"]
	controls.hastePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.hastePrecision = value
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
end

local function OutlawConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, 2, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.opportunityAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_opportunity_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.opportunityAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawAudioCheckboxOpportunityProc"])
	f.tooltip = L["RogueOutlawAudioCheckboxOpportunityProcTooltip"]
	f:SetChecked(spec.audio.opportunity.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.opportunity.enabled = self:GetChecked()

		if spec.audio.opportunity.enabled then
			PlaySoundFile(spec.audio.opportunity.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.opportunityAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Outlaw_opportunity_Audio", parent)
	controls.dropDown.opportunityAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.opportunityAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.opportunityAudio, spec.audio.opportunity.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.opportunityAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.opportunityAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.opportunity.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.opportunityAudio:SetValue(newValue, newName)
		spec.audio.opportunity.sound = newValue
		spec.audio.opportunity.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.opportunityAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.opportunity.sound, TRB.Data.settings.core.audio.channel.channel)
	end		

	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceEnergy"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceEnergy"])
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Outlaw_overcapAudio", parent)
	controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.overcap.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.overcapAudio:SetValue(newValue, newName)
		spec.audio.overcap.sound = newValue
		spec.audio.overcap.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	
	yCoord = yCoord - 60
	controls.checkBoxes.sepsisAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_sepsis_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sepsisAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAudioCheckboxSepsisProc"])
	f.tooltip = L["RogueAudioCheckboxSepsisProcTooltip"]
	f:SetChecked(spec.audio.sepsis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.sepsis.enabled = self:GetChecked()

		if spec.audio.sepsis.enabled then
			PlaySoundFile(spec.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.sepsisAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Outlaw_sepsis_Audio", parent)
	controls.dropDown.sepsisAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.sepsisAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.sepsisAudio, spec.audio.sepsis.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.sepsisAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.sepsisAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else  
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.sepsis.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.sepsisAudio:SetValue(newValue, newName)
		spec.audio.sepsis.sound = newValue
		spec.audio.sepsis.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.sepsisAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
	end
	yCoord = yCoord - 60
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackEnergyRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegen"])
	f.tooltip = L["CheckboxTrackEnergyRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = L["RogueCheckboxEnergyRegenGcdsTooltip"]
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
	controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = L["RogueCheckboxEnergyRegenTimeTooltip"]
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
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
end

local function OutlawConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Rogue_Outlaw_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 4, 2, yCoord, cache)
end

local function OutlawConstructOptionsPanel(cache)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.outlaw or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.outlawDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Outlaw", UIParent)
	interfaceSettingsFrame.outlawDisplayPanel.name = L["RogueOutlawFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.outlawDisplayPanel.parent = parent.name
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.outlawDisplayPanel, "OutlawL["Rogue"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.outlawDisplayPanel)

	parent = interfaceSettingsFrame.outlawDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["RogueOutlawFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.outlawRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_outlawRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.outlawRogueEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["RogueOutlawFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.rogue.outlaw)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.rogue.outlaw = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Rogue_Outlaw_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Rogue_Outlaw_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 2, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Rogue_Outlaw_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls

	OutlawConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	OutlawConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	OutlawConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	OutlawConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	OutlawConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end

--[[

Subtlety Option Menus

]]

local function SubtletyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety
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
			spec.displayText.barText = SubtletyLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
end

local function SubtletyConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Subtlety_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 1, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 3, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.sliceAndDicePandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerSliceAndDicePandemic"], spec.colors.bar.sliceAndDicePandemic, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.sliceAndDicePandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "sliceAndDicePandemic")
	end)

	yCoord = yCoord - 30
	controls.colors.noSliceAndDice = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerSliceAndDiceDown"], spec.colors.bar.noSliceAndDice, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.noSliceAndDice
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noSliceAndDice")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], true, false)

	yCoord = yCoord - 30
	controls.colors.borderShadowcraft = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueSubtletyColorPickerShadowcraft"], spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderShadowcraft
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderShadowcraft")
	end)

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
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	controls.colors.comboPoints.shadowTechniques = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueSubtletyColorPickerShadowTechniques"], spec.colors.comboPoints.shadowTechniques, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.shadowTechniques
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "shadowTechniques")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["RogueSubtletyCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	yCoord = yCoord - 40

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceEnergy"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceEnergy"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
	f = controls.colors.threshold.over
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
	end)

	controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnsuable"], spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
	f = controls.colors.threshold.unusable
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
	end)

	controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueSubtletyColorPickerThresholdSpecial"], spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.special
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
	end)

	controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
	f = controls.colors.threshold.outOfRange
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
	end)

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)
	
	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.backstabThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_backstab", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.backstabThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdBackstab"])
	f.tooltip = L["RogueSubtletyThresholdBackstabTooltip"]
	f:SetChecked(spec.thresholds.backstab.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.backstab.enabled = self:GetChecked()
		spec.thresholds.gloomblade.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cheapShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdCheapShot"])
	f.tooltip = L["RogueSubtletyThresholdCheapShotTooltip"]
	f:SetChecked(spec.thresholds.cheapShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.cheapShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.echoingReprimandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_echoingReprimand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.echoingReprimandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdEchoingReprimand"])
	f.tooltip = L["RogueSubtletyThresholdEchoingReprimandTooltip"]
	f:SetChecked(spec.thresholds.echoingReprimand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.echoingReprimand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.goremawsBiteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_goremawsbite", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.goremawsBiteThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdGoremawsBite"])
	f.tooltip = L["RogueSubtletyThresholdGoremawsBiteTooltip"]
	f:SetChecked(spec.thresholds.goremawsBite.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.goremawsBite.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.gougeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdGouge"])
	f.tooltip = L["RogueSubtletyThresholdGougeTooltip"]
	f:SetChecked(spec.thresholds.gouge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.gouge.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sepsisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sepsis", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sepsisThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSepsis"])
	f.tooltip = L["RogueSubtletyThresholdSepsisTooltip"]
	f:SetChecked(spec.thresholds.sepsis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sepsis.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shadowstrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shadowstrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowstrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShadowStrike"])
	f.tooltip = L["RogueSubtletyThresholdShadowStrikeTooltip"]
	f:SetChecked(spec.thresholds.shadowstrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shadowstrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shivThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShiv"])
	f.tooltip = L["RogueSubtletyThresholdShivTooltip"]
	f:SetChecked(spec.thresholds.shiv.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shiv.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shurikenStormThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenStorm", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shurikenStormThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShurikenStorm"])
	f.tooltip = L["RogueSubtletyThresholdShurikenStormTooltip"]
	f:SetChecked(spec.thresholds.shurikenStorm.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shurikenStorm.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shurikenTornadoThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenTornado", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shurikenTornadoThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShurikenTornado"])
	f.tooltip = L["RogueSubtletyThresholdShurikenTornadoTooltip"]
	f:SetChecked(spec.thresholds.shurikenTornado.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shurikenTornado.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shurikenTossThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenToss", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shurikenTossThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShurikenToss"])
	f.tooltip = L["RogueSubtletyThresholdShurikenTossTooltip"]
	f:SetChecked(spec.thresholds.shurikenToss.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shurikenToss.enabled = self:GetChecked()
	end)


	yCoord = yCoord - 25
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.blackPowderThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_blackPowder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blackPowderThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Black Powder")
	f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Black Powder. If you do not have any combo points, will be colored as 'unusable'."
	f:SetChecked(spec.thresholds.blackPowder.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.blackPowder.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.eviscerateThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_eviscerate", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.eviscerateThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Eviscerate")
	f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Eviscerate. If you do not have any combo points, will be colored as 'unusable'."
	f:SetChecked(spec.thresholds.eviscerate.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.eviscerate.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kidneyShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdKidneyShot"])
	f.tooltip = L["RogueSubtletyThresholdKidneyShotTooltip"]
	f:SetChecked(spec.thresholds.kidneyShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.kidneyShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sliceAndDiceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSliceAndDice"])
	f.tooltip = L["RogueSubtletyThresholdSliceAndDiceTooltip"]
	f:SetChecked(spec.thresholds.sliceAndDice.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sliceAndDice.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ruptureThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_rupture", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ruptureThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdRupture"])
	f.tooltip = L["RogueSubtletyThresholdRuptureTooltip"]
	f:SetChecked(spec.thresholds.rupture.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.rupture.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.secretTechniqueThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_secretTechnique", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.secretTechniqueThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSecretTechnique"])
	f.tooltip = L["RogueSubtletyThresholdSecretTechniqueTooltip"]
	f:SetChecked(spec.thresholds.secretTechnique.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.secretTechnique.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonVialThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdCrimsonVial"])
	f.tooltip = L["RogueSubtletyThresholdCrimsonVialTooltip"]
	f:SetChecked(spec.thresholds.crimsonVial.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.crimsonVial.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.distractThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdDistract"])
	f.tooltip = L["RogueSubtletyThresholdDistractTooltip"]
	f:SetChecked(spec.thresholds.distract.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.distract.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feintThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdFeint"])
	f.tooltip = L["RogueSubtletyThresholdFeintTooltip"]
	f:SetChecked(spec.thresholds.feint.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.feint.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSap"])
	f.tooltip = L["RogueSubtletyThresholdSapTooltip"]
	f:SetChecked(spec.thresholds.sap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sap.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathFromAboveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdDeathFromAbove"])
	f.tooltip = L["RogueSubtletyThresholdDeathFromAboveTooltip"]
	f:SetChecked(spec.thresholds.deathFromAbove.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.deathFromAbove.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dismantleThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdDismantle"])
	f.tooltip = L["RogueSubtletyThresholdDismantleTooltip"]
	f:SetChecked(spec.thresholds.dismantle.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.dismantle.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shadowyDuelThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shadowyDuel", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowyDuelThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Shadowy Duel")
	f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shadowy Duel."
	f:SetChecked(spec.thresholds.shadowyDuel.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shadowyDuel.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], 170)

	TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
end

local function SubtletyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Subtlety_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 3, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerPassiveEnergy"], spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergyAboveOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)
	

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueDotChangeColorCheckbox"])
	f.tooltip = L["RogueDotChangeColorCheckboxTooltip"]
	f:SetChecked(spec.colors.text.dots.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.dots.enabled = self:GetChecked()
	end)

	controls.colors.dots = {}

	controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerActive"], spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
	f = controls.colors.dots.up
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
	end)

	controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.pandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
	end)

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
	f = controls.colors.dots.down
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
	end)


	yCoord = yCoord - 130
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50
	title = L["SecondaryDecimalPrecision"]
	controls.hastePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.hastePrecision = value
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
end

local function SubtletyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 4, 3, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceEnergy"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceEnergy"])
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Subtlety_overcapAudio", parent)
	controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.overcap.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.overcapAudio:SetValue(newValue, newName)
		spec.audio.overcap.sound = newValue
		spec.audio.overcap.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	
	yCoord = yCoord - 60
	controls.checkBoxes.sepsisAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_sepsis_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sepsisAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAudioCheckboxSepsisProc"])
	f.tooltip = L["RogueAudioCheckboxSepsisProcTooltip"]
	f:SetChecked(spec.audio.sepsis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.sepsis.enabled = self:GetChecked()

		if spec.audio.sepsis.enabled then
			PlaySoundFile(spec.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.sepsisAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Subtlety_sepsis_Audio", parent)
	controls.dropDown.sepsisAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.sepsisAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.sepsisAudio, spec.audio.sepsis.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.sepsisAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.sepsisAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else  
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.sepsis.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.sepsisAudio:SetValue(newValue, newName)
		spec.audio.sepsis.sound = newValue
		spec.audio.sepsis.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.sepsisAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
	end
	yCoord = yCoord - 60
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackEnergyRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegen"])
	f.tooltip = L["CheckboxTrackEnergyRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = L["RogueCheckboxEnergyRegenGcdsTooltip"]
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
	controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.energyGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = L["RogueCheckboxEnergyRegenTimeTooltip"]
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
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
end

local function SubtletyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Rogue_Subtlety_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 3, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 4, 3, yCoord, cache)
end

local function SubtletyConstructOptionsPanel(cache)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.subtlety or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.subtletyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Subtlety", UIParent)
	interfaceSettingsFrame.subtletyDisplayPanel.name = L["RogueSubtletyFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.subtletyDisplayPanel.parent = parent.name
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.subtletyDisplayPanel, L["RogueSubtletyFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.subtletyDisplayPanel)

	parent = interfaceSettingsFrame.subtletyDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["RogueSubtletyFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.subtletyRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_subtletyRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.subtletyRogueEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["RogueSubtletyFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.rogue.subtlety)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.rogue.subtlety = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Rogue_Subtlety_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Rogue_Subtlety_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 3, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Rogue_Subtlety_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls

	SubtletyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	SubtletyConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	SubtletyConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	SubtletyConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	SubtletyConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	AssassinationConstructOptionsPanel(specCache.assassination)
	OutlawConstructOptionsPanel(specCache.outlaw)
	SubtletyConstructOptionsPanel(specCache.subtlety)
end
TRB.Options.Rogue.ConstructOptionsPanel = ConstructOptionsPanel