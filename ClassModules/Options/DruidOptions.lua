local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 11 then --Only do this if we're on a Druid!
	return
end

local L = TRB.Localization
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local oUi = TRB.Data.constants.optionsUi

local barContainerFrame = TRB.Frames.barContainerFrame
local castingFrame = TRB.Frames.castingFrame

local passiveFrame = TRB.Frames.passiveFrame

TRB.Options.Druid = {}
TRB.Options.Druid.Balance = {}
TRB.Options.Druid.Feral = {}
TRB.Options.Druid.Guardian = {}
TRB.Options.Druid.Restoration = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.balance = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.feral = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.guardian = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = {}

--[[ 
	Balance Defaults
]]

local function BalanceLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="$haste%",
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
			text="{$eclipse}[$eclipseTime sec.]",
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
			text="{$casting}[$casting + ]{$passive}[$passive + ]$astralPower",
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
TRB.Options.Druid.BalanceLoadDefaultBarTextSimpleSettings = BalanceLoadDefaultBarTextSimpleSettings

local function BalanceLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="#sunfire $sunfireCount    {$talentStellarFlare}[#stellarFlare $stellarFlareCount    ]$haste% ($gcd)||n#moonfire $moonfireCount     {$talentStellarFlare}[          ]{$ttd}[TTD: $ttd]",
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
			text="{$eclipse}[#eclipse $eclipseTime #eclipse]",
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
			text="{$casting}[#casting$casting+]{$passive}[$passive+]$astralPower",
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

local function BalanceLoadDefaultSettings(includeBarText)
	local settings = {
		hastePrecision=2,
		resourcePrecision=0,
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
			starsurgeThresholdOnlyOverShow = false,
			starsurge = { -- 1
				enabled = true
			},
			starsurge2 = { -- 2
				enabled = true
			},
			starsurge3 = { -- 3
				enabled = true
			},
			starfall = { -- 4
				enabled = true
			},
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		endOfEclipse = {
			enabled=true,
			celestialAlignmentOnly=false,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
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
		colors = {
			text = {
				current="FFFFB668",
				casting="FFFFFFFF",
				passive="FF00AA00",
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
				border="FFC16920",
				borderOvercap="FFFF0000",
				background="66000000",
				base="FFFF7C0A",
				lunar="FF144D72",
				solar="FFFFEE00",
				celestial="FF4A95CE",
				casting="FFFFFFFF",
				passive="FF006600",
				eclipse1GCD="FFFF0000",
				moonkinFormMissing="FFFF0000",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				flashSsEnabled=true,
				overcapEnabled=true
			},
			threshold = {
				under="FFFFFFFF",
				over="FF00FF00",
				starfallPandemic="FF8B0000",
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
			overcap={
				name = L["Overcap"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			}
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
			textureLock=true
		}
	}

	if includeBarText then
		settings.displayText.barText = BalanceLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

--[[ 
	Feral Defaults
]]

local function FeralLoadExtraBarTextSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			useDefaultFontColor = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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
			guid=TRB.Functions.String:Guid(),
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

local function FeralLoadDefaultBarTextSimpleSettings()
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
			text="{$casting}[$casting + ]{$passive}[$passive + ]$resource",
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

	local extraTextSettings = FeralLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.Druid.FeralLoadDefaultBarTextSimpleSettings = FeralLoadDefaultBarTextSimpleSettings

local function FeralLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="#rake $rakeCount    #thrash $thrashCount||n#rip $ripCount    {$lunarInspiration}[#moonfire $moonfireCount]",
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
			text="{$casting}[#casting$casting+]{$passive}[$passive+]$resource",
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

	local extraTextSettings = FeralLoadExtraBarTextSettings()

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end

local function FeralLoadDefaultSettings(includeBarText)
	local settings = {
		hastePrecision=2,
		thresholds = {
			width = 2,
			overlapBorder=true,
			outOfRange=true,
			bleedColors=true,
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
			rake = {
				enabled = true, -- 1
			},
			thrash = {
				enabled = true, -- 2
			},
			swipe = {
				enabled = false, -- 3
			},
			rip = {
				enabled = true, -- 4
			},
			maim = {
				enabled = false, -- 5
			},
			ferociousBite = {
				enabled = true, -- 6
			},
			ferociousBiteMinimum = {
				enabled = false -- 7
			},
			ferociousBiteMaximum = {
				enabled = true -- 8
			},
			shred = {
				enabled = true, -- 9
			},
			primalWrath = {
				enabled = true, -- 10
			},
			moonfire = {
				enabled = true, -- 11
			},
			brutalSlash = {
				enabled = true, -- 12
			},
			feralFrenzy = {
				enabled = true, -- 13
			},
		},
		generation = {
			mode="gcd",
			gcds=1,
			time=1.5,
			enabled=true
		},
		overcap={
			mode="relative",
			relative=0,
			fixed=100
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
			generation = true,
			spec={
				predatorRevealedColor = true
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
					same="FFFFFFFF",
					down="FFFF8888",
					worse="FFFF33BB",
					better="FF009955"
				}
			},
			bar = {
				border="FFFF7C0A",
				borderOvercap="FFFF0000",
				borderStealth="FF000000",
				background="66000000",
				base="FFFFFF00",
				clearcasting="FF4A95CE",
				maxBite="FF009900",
				apexPredator="FFE75480",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF9F4500",
				overcapEnabled=true,
			},
			comboPoints = {
				border="FFFF7C0A",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				predatorRevealed="FF009900",
				sameColor=false
			},
			threshold = {
				under="FFFFFFFF",
				over="FF00FF00",
				unusable="FFFF0000",
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
			apexPredatorsCraving={
				name = L["DruidFeralAudioApexPredatorsCravingProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			}
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
		settings.displayText.barText = FeralLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

-- Restoration
local function RestorationLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$efflorescenceTime}[$efflorescenceTime]",
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

	return textSettings
end
TRB.Options.Druid.RestorationLoadDefaultBarTextSimpleSettings = RestorationLoadDefaultBarTextSimpleSettings

local function RestorationLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$potionCooldown}[#potionOfFrozenFocus $potionCooldown] ",
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
			text="{$efflorescenceTime}[#efflorescence $efflorescenceTime #efflorescence]",
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

	return textSettings
end

local function RestorationLoadDefaultSettings(includeBarText)
	local settings = {
		hastePrecision=2,
		thresholds = {
			width = 2,
			overlapBorder=true,
			outOfRange=true,
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
			aeratedManaPotionRank1 = {
				enabled = false, -- 1
			},
			aeratedManaPotionRank2 = {
				enabled = false, -- 2
			},
			aeratedManaPotionRank3 = {
				enabled = true, -- 3
			},
			potionOfFrozenFocusRank1 = {
				enabled = false, -- 4
			},
			potionOfFrozenFocusRank2 = {
				enabled = false, -- 5
			},
			potionOfFrozenFocusRank3 = {
				enabled = true, -- 6
			},
			conjuredChillglobe = {
				enabled = true, -- 7
				cooldown = true
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
			pinToPersonalResourceDisplay=false,
			showPassive=true,
			showCasting=true
		},
		passiveGeneration = {
			innervate = true,
			manaTideTotem = true,
			symbolOfHope = true,
			blessingOfWinter = true
		},
		endOfIncarnation = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
		colors={
			text={
				current="FF4D4DFF",
				casting="FFFFFFFF",
				passive="FF8080FF",
				dots={
					enabled=true,
					up="FFFFFFFF",
					down="FFFF0000",
					pandemic="FFFFFF00"
				}
			},
			bar={
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				noEfflorescence="FFFF0000",
				clearcasting="FF4A95CE",
				incarnation="FF005500",
				incarnationEnd="FFDD5500",
				innervate="FF00FF00",
				potionOfChilledClarity="FF9EC51E",
				spending="FFFFFFFF",
				passive="FF8080FF",
				innervateBorderChange=true,
				potionOfChilledClarityBorderChange=true
			},
			threshold={
				unusable="FFFF0000",
				over="FF00FF00",
				mindbender="FF8080FF",
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
		audio={
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
			passiveBar="Interface\\TargetingFrame\\UI-StatusBar",
			passiveBarName="Blizzard",
			castingBar="Interface\\TargetingFrame\\UI-StatusBar",
			castingBarName="Blizzard",
			textureLock=true
		}
	}

	if includeBarText then
		settings.displayText.barText = RestorationLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Options.LoadDefaultSettings()

	settings.druid.balance = BalanceLoadDefaultSettings(includeBarText)
	settings.druid.feral = FeralLoadDefaultSettings(includeBarText)
	settings.druid.restoration = RestorationLoadDefaultSettings(includeBarText)
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
	StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BalanceLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BalanceLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["DruidBalanceFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BalanceLoadDefaultBarTextNarrowAdvancedSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}]]

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 150, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 1, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord)


	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 1, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], "balance", true, L["DruidBalanceStarsurge"], L["DruidBalanceStarsurge"])

	yCoord = yCoord - 100
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
	controls.colors.moonkinFormMissing = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerMoonkinMissing"], spec.colors.bar.moonkinFormMissing, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.moonkinFormMissing
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "moonkinFormMissing")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showCastingBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
	f.tooltip = L["ShowCastingBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showCasting)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showCasting = self:GetChecked()
	end)

	controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerCasting"], spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 1)
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], true, false)

	yCoord = yCoord - 40
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceAstralPower"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceAstralPower"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
	f = controls.colors.threshold.over
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
	end)

	controls.colors.threshold.starfallPandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceThresholdStarfallPandemic"], spec.colors.threshold.starfallPandemic, 300, 25, oUi.xCoord2, yCoord-60)
	f = controls.colors.threshold.starfallPandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "starfallPandemic")
	end)

	controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.outOfRange
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
	end)

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)


	controls.checkBoxes.sfThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starfallEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sfThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarfall"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarfallTooltip"]
	f:SetChecked(spec.thresholds.starfall.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.starfall.enabled = self:GetChecked()

		if spec.thresholds.starfall.enabled then
			TRB.Frames.resourceFrame.thresholds[4]:Show()
		else
			TRB.Frames.resourceFrame.thresholds[4]:Hide()
		end
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ssThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurgeEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarsurge"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarsurgeTooltip"]
	f:SetChecked(spec.thresholds.starsurge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.starsurge.enabled = self:GetChecked()

		if spec.thresholds.starsurge.enabled then
			TRB.Frames.resourceFrame.thresholds[1]:Show()
		else
			TRB.Frames.resourceFrame.thresholds[1]:Hide()
		end
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.ssThreshold2Show = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurge2Enabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThreshold2Show
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarsurge2x"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarsurge2xTooltip"]
	f:SetChecked(spec.thresholds.starsurge2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.starsurge2.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.ssThreshold3Show = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurge3Enabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThreshold3Show
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxStarsurge3x"])
	f.tooltip = L["DruidBalanceThresholdCheckboxStarsurge3xTooltip"]
	f:SetChecked(spec.thresholds.starsurge3.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.starsurge3.enabled = self:GetChecked()
	end)
	yCoord = yCoord - 20
	controls.checkBoxes.ssThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurgeOnlyOver", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssThresholdOnlyOverShow
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceThresholdCheckboxOnlyCurrentNext"])
	f.tooltip = L["DruidBalanceThresholdCheckboxOnlyCurrentNextTooltip"]
	f:SetChecked(spec.thresholds.starsurgeThresholdOnlyOverShow)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.starsurgeThresholdOnlyOverShow = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = yCoord - 50

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 1, yCoord)

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
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 11, 1, yCoord, L["ResourceAstralPower"], 100)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 1, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidBalanceTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextCurrent"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextCasting"], spec.colors.text.casting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerTextPassive"], spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerThresholdOver"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidBalanceColorPickerOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidBalanceCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_Druid_Balance_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DruidBalanceCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
	f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$sunfireCount/$sunfireTime, $moonfireCount/$moonfireTime, $stellarFlareCount/$stellarFlareTime")
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

	title = L["DruidBalanceAstralPowerDecimalPrecision"]
	controls.resourcePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 1, spec.resourcePrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.resourcePrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.resourcePrecision = value
	end)

	TRB.Frames.interfaceSettingsFrame = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
end

local function BalanceConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.balance

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.balance
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Balance_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Balance_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 1, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.ssReady = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_CB_Starsurge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ssReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceAudioStarsurgeCheckbox"])
	f.tooltip = L["DruidBalanceAudioStarsurgeCheckboxTooltip"]
---@diagnostic disable-next-line: undefined-field
	f:SetChecked(spec.audio.ssReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.ssReady.enabled = self:GetChecked()

		if spec.audio.ssReady.enabled then
			PlaySoundFile(spec.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.ssReadyAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Balance_ssReadyAudio", parent)
	controls.dropDown.ssReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.ssReadyAudio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.ssReadyAudio, spec.audio.ssReady.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.ssReadyAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.ssReadyAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.ssReady.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.ssReadyAudio:SetValue(newValue, newName)
		spec.audio.ssReady.sound = newValue
		spec.audio.ssReady.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.ssReadyAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.sfReady = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_CB_Starfall_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sfReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceAudioStarfallCheckbox"])
	f.tooltip = L["DruidBalanceAudioStarfallCheckboxTooltip"]
---@diagnostic disable-next-line: undefined-field
	f:SetChecked(spec.audio.sfReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.sfReady.enabled = self:GetChecked()

		if spec.audio.sfReady.enabled then
			PlaySoundFile(spec.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.sfReadyAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Balance_sfReadyAudio", parent)
	controls.dropDown.sfReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.sfReadyAudio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.sfReadyAudio, spec.audio.sfReady.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.sfReadyAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.sfReadyAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.sfReady.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.sfReadyAudio:SetValue(newValue, newName)
		spec.audio.sfReady.sound = newValue
		spec.audio.sfReady.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.sfReadyAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.starweaversReady = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_CB_starweavers_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.starweaversReady
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidBalanceAudioStarweaverCheckbox"])
	f.tooltip = L["DruidBalanceAudioStarweaverCheckboxTooltip"]
---@diagnostic disable-next-line: undefined-field
	f:SetChecked(spec.audio.starweaversReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.starweaversReady.enabled = self:GetChecked()

		if spec.audio.starweaversReady.enabled then
			PlaySoundFile(spec.audio.starweaversReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.starweaversReadyAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Balance_starweaversReadyAudio", parent)
	controls.dropDown.starweaversReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.starweaversReadyAudio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.starweaversReadyAudio, spec.audio.starweaversReady.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.starweaversReadyAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.starweaversReadyAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.starweaversReady.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.starweaversReadyAudio:SetValue(newValue, newName)
		spec.audio.starweaversReady.sound = newValue
		spec.audio.starweaversReady.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.starweaversReadyAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.starweaversReady.sound, TRB.Data.settings.core.audio.channel.channel)
	end



	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_CB_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceAstralPower"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceAstralPower"])
---@diagnostic disable-next-line: undefined-field
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Balance_overcapAudio", parent)
	controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.sliderWidth)
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

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 1, yCoord, cache)
end

local function BalanceConstructOptionsPanel(cache)
			
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
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.balanceDisplayPanel, L["DruidBalanceFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.balanceDisplayPanel)

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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidBalanceFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 1, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Druid_Balance_LayoutPanel" .. i, parent)
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
	BalanceConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	BalanceConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	BalanceConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	BalanceConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
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
	local f = nil

	local title = ""

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
	StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DruidFeralFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FeralLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DruidFeralFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FeralLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 2, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 2, yCoord, true)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], "notFull", false)

	yCoord = yCoord - 100
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
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
	f:SetChecked(spec.comboPoints.generation)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.generation = self:GetChecked()
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
	controls.checkBoxes.t30ComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_comboPointsT30", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.t30ComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralCheckboxEnablePredatorRevealed"])
	f.tooltip = L["DruidFeralCheckboxEnablePredatorRevealedTooltip"]
	f:SetChecked(spec.comboPoints.spec.predatorRevealedColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.spec.predatorRevealedColor = self:GetChecked()
	end)

	controls.colors.comboPoints.predatorRevealed = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralColorPickerPredatorRevealed"], spec.colors.comboPoints.predatorRevealed, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.predatorRevealed
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "predatorRevealed")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["DruidFeralCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
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

	controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.outOfRange
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
	end)

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)

	controls.checkBoxes.thresholdBleedColors = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdBleedColors", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdBleedColors
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-160)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxBleedColor"])
	f.tooltip = L["DruidFeralThresholdCheckboxBleedColorTooltip"]
	f:SetChecked(spec.thresholds.bleedColors)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.bleedColors = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)
	
	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.brutalSlashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_brutalSlash", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.brutalSlashThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxBrutalSlash"])
	f.tooltip = L["DruidFeralThresholdCheckboxBrutalSlashTooltip"]
	f:SetChecked(spec.thresholds.brutalSlash.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.brutalSlash.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.feralFrenzyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_feralfrenzy", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feralFrenzyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFeralFrenzy"])
	f.tooltip = L["DruidFeralThresholdCheckboxFeralFrenzyTooltip"]
	f:SetChecked(spec.thresholds.feralFrenzy.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.feralFrenzy.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.moonfireThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_moonfire", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.moonfireThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxMoonfire"])
	f.tooltip = L["DruidFeralThresholdCheckboxMoonfireTooltip"]
	f:SetChecked(spec.thresholds.moonfire.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.moonfire.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.rakeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_rake", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rakeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxRake"])
	f.tooltip = L["DruidFeralThresholdCheckboxRakeTooltip"]
	f:SetChecked(spec.thresholds.rake.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.rake.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.shredThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_shred", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shredThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxShred"])
	f.tooltip = L["DruidFeralThresholdCheckboxShredTooltip"]
	f:SetChecked(spec.thresholds.shred.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.shred.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.swipeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_swipe", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.swipeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxSwipe"])
	f.tooltip = L["DruidFeralThresholdCheckboxSwipeTooltip"]
	f:SetChecked(spec.thresholds.swipe.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.swipe.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.thrashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_thrash", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thrashThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxThrash"])
	f.tooltip = L["DruidFeralThresholdCheckboxThrashTooltip"]
	f:SetChecked(spec.thresholds.thrash.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thrash.enabled = self:GetChecked()
	end)


	yCoord = yCoord - 25
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.ferociousBiteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBite", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ferociousBiteThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFerociousBite"])
	f.tooltip = L["DruidFeralThresholdCheckboxFerociousBiteTooltip"]
	f:SetChecked(spec.thresholds.ferociousBite.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.ferociousBite.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ferociousBiteMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBiteMinimum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ferociousBiteMinimumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFerociousBiteMinimum"])
	f.tooltip = L["DruidFeralThresholdCheckboxFerociousBiteMinimumTooltip"]
	f:SetChecked(spec.thresholds.ferociousBiteMinimum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.ferociousBiteMinimum.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ferociousBiteMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBiteMaximum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ferociousBiteMaximumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxFerociousBiteMaximum"])
	f.tooltip = L["DruidFeralThresholdCheckboxFerociousBiteMaximumTooltip"]
	f:SetChecked(spec.thresholds.ferociousBiteMaximum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.ferociousBiteMaximum.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.maimThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_maim", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maimThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxMaim"])
	f.tooltip = L["DruidFeralThresholdCheckboxMaimTooltip"]
	f:SetChecked(spec.thresholds.maim.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.maim.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.primalWrathThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_primalWrath", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.primalWrathThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxPrimalWrath"])
	f.tooltip = L["DruidFeralThresholdCheckboxPrimalWrathTooltip"]
	f:SetChecked(spec.thresholds.primalWrath.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.primalWrath.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ripThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_rip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ripThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralThresholdCheckboxRip"])
	f.tooltip = L["DruidFeralThresholdCheckboxRipTooltip"]
	f:SetChecked(spec.thresholds.rip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.rip.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 11, 2, yCoord, L["ResourceEnergy"], 160)

	TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 2, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 2, yCoord)

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

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)
	

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DruidFeralBleedSnapshottingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25
	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralBleedChecboxChangeDotColor"])
	f.tooltip = L["DruidFeralBleedChecboxChangeDotColorTooltip"]
	f:SetChecked(spec.colors.text.dots.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.dots.enabled = self:GetChecked()
	end)

	controls.colors.dots = {}

	controls.colors.dots.same = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralBleedColorPickerBleedSame"], spec.colors.text.dots.same, 300, 25, oUi.xCoord, yCoord-30)
	f = controls.colors.dots.same
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "same")
	end)

	controls.colors.dots.worse = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralBleedColorPickerBleedWorse"], spec.colors.text.dots.worse, 300, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.worse
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "worse")
	end)

	controls.colors.dots.better = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralBleedColorPickerBleedBetter"], spec.colors.text.dots.better, 550, 25, oUi.xCoord, yCoord-90)
	f = controls.colors.dots.better
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "better")
	end)

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidFeralBleedColorPickerBleedNotActive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-120)
	f = controls.colors.dots.down
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
	end)


	yCoord = yCoord - 150
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

	TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
end

local function FeralConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.feral

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.feral
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Druid_Feral_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Feral_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 2, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.apcAudio = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_apc_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.apcAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DruidFeralCheckboxApexPredatorsCravingProc"])
	f.tooltip = L["DruidFeralCheckboxApexPredatorsCravingProcTooltip"]
	f:SetChecked(spec.audio.apexPredatorsCraving.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.apexPredatorsCraving.enabled = self:GetChecked()

		if spec.audio.apexPredatorsCraving.enabled then
			PlaySoundFile(spec.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.apcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Feral_apexPredatorsCraving_Audio", parent)
	controls.dropDown.apcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.apcAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.apcAudio, spec.audio.apexPredatorsCraving.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.apcAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.apcAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.apexPredatorsCraving.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.apcAudio:SetValue(newValue, newName)
		spec.audio.apexPredatorsCraving.sound = newValue
		spec.audio.apexPredatorsCraving.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.apcAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
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
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Feral_overcapAudio", parent)
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
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackEnergyRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegen"])
	f.tooltip = L["CheckboxTrackEnergyRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_PFG_GCD", parent, "UIRadioButtonTemplate")
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
	controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_PFG_TIME", parent, "UIRadioButtonTemplate")
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
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 2, yCoord, cache)
end

local function FeralConstructOptionsPanel(cache)
			
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
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.feralDisplayPanel, L["DruidFeralFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.feralDisplayPanel)

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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidFeralFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 2, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Druid_Feral_LayoutPanel" .. i, parent)
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
	FeralConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	FeralConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	FeralConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	FeralConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
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
	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[
	StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["DruidRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextNarrowAdvancedSettings()
			C_UI.Reload()
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
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 11, 4, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 11, 4, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"], "notFull", false)


	yCoord = yCoord - 100
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.noEfflorescence = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidRestorationColorPickerNoEfflorescence"], spec.colors.bar.noEfflorescence, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.noEfflorescence
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noEfflorescence")
	end)

	yCoord = yCoord - 30
	controls.colors.clearcasting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DruidRestorationColorPickerClearcasting"], spec.colors.bar.clearcasting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.clearcasting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "clearcasting")
	end)

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
	controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showCastingBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
	f.tooltip = L["ShowCastingBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showCasting)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showCasting = self:GetChecked()
	end)

	controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCasting"], spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 4)
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 4)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 4)
	end)


	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 11, 4, yCoord, L["ResourceMana"], false, true)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 11, 4, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 11, 4, yCoord)
	
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 11, 4, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 11, 4, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerPassiveMana"], spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
	f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$moonfireCount/$moonfireTime, $sunfireCount/$sunfireTime)")
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

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
end

local function RestorationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.druid.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Druid_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Druid_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 11, 4, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.innervate
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerAudioCheckboxInnervate"])
	f.tooltip = L["HealerAudioCheckboxInnervateTooltip"]
	f:SetChecked(spec.audio.innervate.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.innervate.enabled = self:GetChecked()

		if spec.audio.innervate.enabled then
			PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Druid_Restoration_Innervate_Audio", parent)
	controls.dropDown.innervateAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.innervateAudio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.innervateAudio, spec.audio.innervate.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.innervateAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.innervateAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.innervate.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.innervateAudio:SetValue(newValue, newName)
		spec.audio.innervate.sound = newValue
		spec.audio.innervate.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.innervateAudio, newName)
		CloseDropDownMenus()
		---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
	end
	
	yCoord = yCoord - 60
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerPassiveExternalManaGenerationTrackingHeader"], oUi.xCoord, yCoord)
			
	yCoord = yCoord - 30
	controls.checkBoxes.blessingOfWinterRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_BlessingOfWinterMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blessingOfWinterRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackBlessingOfWinter"])
	f.tooltip = L["HealerCheckboxTrackBlessingOfWinterTooltip"]
	f:SetChecked(spec.passiveGeneration.blessingOfWinter)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.blessingOfWinter = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.innervateRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackInnervate"])
	f.tooltip = L["HealerCheckboxTrackInnervateTooltip"]
	f:SetChecked(spec.passiveGeneration.innervate)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.innervate = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.manaTideTotemRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackManaTideTotem"])
	f.tooltip = L["HealerCheckboxTrackManaTideTotemTooltip"]
	f:SetChecked(spec.passiveGeneration.manaTideTotem)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.manaTideTotem = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.symbolOfHopeRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackSymbolOfHope"])
	f.tooltip = L["HealerCheckboxTrackSymbolOfHopeTooltip"]
	f:SetChecked(spec.passiveGeneration.symbolOfHope)
	f:SetScript("OnClick", function(self, ...)
		spec.passiveGeneration.symbolOfHope = self:GetChecked()
	end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 11, 4, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 11, 4, yCoord, cache)
end

local function RestorationConstructOptionsPanel(cache)
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
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.restorationDisplayPanel, L["DruidRestorationFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.restorationDisplayPanel)

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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DruidRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 11, 4, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Druid_Restoration_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls

	RestorationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	RestorationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	RestorationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	RestorationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	RestorationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	BalanceConstructOptionsPanel(specCache.balance)
	FeralConstructOptionsPanel(specCache.feral)
	RestorationConstructOptionsPanel(specCache.restoration)
end
TRB.Options.Druid.ConstructOptionsPanel = ConstructOptionsPanel