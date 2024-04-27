local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 3 then --Only do this if we're on a Hunter!
	return
end
local L = TRB.Localization
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local oUi = TRB.Data.constants.optionsUi

local barContainerFrame = TRB.Frames.barContainerFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame

TRB.Options.Hunter = {}
TRB.Options.Hunter.BeastMastery = {}
TRB.Options.Hunter.Marksmanship = {}
TRB.Options.Hunter.Survival = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.survival = {}

local function BeastMasteryLoadDefaultBarTextSimpleSettings()
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
			text="{$frenzyStacks}[$frenzyTime ($frenzyStacks)]",
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
			text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
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
TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSimpleSettings = BeastMasteryLoadDefaultBarTextSimpleSettings

local function BeastMasteryLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="$haste% ($gcd)||n{$ttd}[TTD: $ttd] ",
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
			text="{$frenzyStacks}[#frenzy$frenzyTime - $frenzyStacks#frenzy]",
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
			text="{$casting}[#casting$casting+]{$barbedShotFocus}[#barbedShot$barbedShotFocus+]{$regen}[$regen+]$focus",
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

local function BeastMasteryLoadDefaultSettings(includeBarText)
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
			arcaneShot = {
				enabled = false, -- 1
			},
			revivePet = {
				enabled = false, -- 2
			},
			wingClip = {
				enabled = false, -- 3
			},
			killCommand = {
				enabled = true, -- 4
			},
			killShot = {
				enabled = true, -- 5
			},
			scareBeast = {
				enabled = false, -- 6
			},
			explosiveShot = {
				enabled = true, -- 7
			},
			barrage = {
				enabled = true, -- 8
			},
			serpentSting = {
				enabled = true, -- 9
			},
			cobraShot = {
				enabled = true, -- 10
			},
			multiShot = {
				enabled = true, -- 11
			},
			aMurderOfCrows = {
				enabled = true, -- 12
			},
			wailingArrow = {
				enabled = true, -- 13
			},
			direBeastBasilisk = {
				enabled = true, -- 14
			},
			direBeastHawk = {
				enabled = true, -- 15
			}
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
		colors = {
			text = {
				current="FFAB5124",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF005500",
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
				border="FFAB5124",
				borderOvercap="FFFF0000",
				borderBeastialWrath="FF005500",
				background="66000000",
				base="FFFF8040",
				frenzyUse="FF00B60E",
				frenzyHold="FFFF0000",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF005500",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				overcapEnabled=true,
				beastialWrathEnabled=true,
				beastCleave = {
					color = "FF77FF77",
					enabled = true
				},
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
			killShot={
				name = L["HunterAudioKillShotReady"],
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
		settings.displayText.barText = BeastMasteryLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function MarksmanshipLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$trueshotTime}[$trueshotTime sec]",
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
			text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
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
TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSimpleSettings = MarksmanshipLoadDefaultBarTextSimpleSettings

local function MarksmanshipLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$serpentSting}[#serpentSting $ssCount   ]$haste% ($gcd)||n{$serpentSting}[          ]{$ttd}[TTD: $ttd][ ] ",
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
			text="{$trueshotTime}[#trueshot $trueshotTime #trueshot]",
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
			text="{$casting}[#casting$casting+]{$passive}[$passive+]$focus",
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

local function MarksmanshipLoadDefaultSettings(includeBarText)
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
			arcaneShot = {
				enabled = true, -- 1
			},
			revivePet = {
				enabled = false, -- 2
			},
			wingClip = {
				enabled = false, -- 3
			},
			killCommand = {
				enabled = true, -- 4
			},
			killShot = {
				enabled = true, -- 5
			},
			scareBeast = {
				enabled = false, -- 6
			},
			explosiveShot = {
				enabled = true, -- 7
			},
			barrage = {
				enabled = true, -- 8
			},
			serpentSting = {
				enabled = true, -- 9
			},
			aimedShot = {
				enabled = true, -- 10
			},
			chimaeraShot = {
				enabled = true -- 11
			},
			multiShot = {
				enabled = true, -- 12
			},
			burstingShot = {
				enabled = true, -- 13
			},
			wailingArrow = {
				enabled = true, -- 14
			},
			sniperShot = {
				enabled = true, -- 15
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
		endOfTrueshot = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
		steadyFocus = {
			enabled=true,
			mode="gcd",
			gcdsMax=3,
			timeMax=4.5
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
				current="FFAB5124",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF005500",
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
				border="FFAB5124",
				borderOvercap="FFFF0000",
				borderSteadyFocus="FFFFFF00",
				background="66000000",
				base="FFFF8040",
				trueshot="FF00B60E",
				trueshotEnding="FFFF0000",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF005500",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				overcapEnabled=true
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
			aimedShot={
				name = L["HunterMarksmanshipAudioAimedShotCapping"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"],
				mode="gcd",
				gcds=1,
				time=1.5
			},
			lockAndLoad={
				name = L["HunterMarksmanshipAudioLockAndLoadProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			overcap={
				name = L["Overcap"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			secretsOfTheUnblinkingVigil={
				name = L["HunterMarksmanshipAudioUnblinkingVigilProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			killShot={
				name = L["HunterAudioKillShotReady"],
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
		settings.displayText.barText = MarksmanshipLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function SurvivalLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="{$coordinatedAssaultTime}[$coordinatedAssaultTime sec]",
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
			text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
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
TRB.Options.Hunter.SurvivalLoadDefaultBarTextSimpleSettings = SurvivalLoadDefaultBarTextSimpleSettings

local function SurvivalLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="#serpentSting $ssCount   $haste% ($gcd)||n {$ttd}[TTD: $ttd][ ] ",
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
			text="{$coordinatedAssaultTime}[#coordinatedAssault $coordinatedAssaultTime #coordinatedAssault]",
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
			text="{$casting}[#casting$casting+]{$toeFocus}[#termsOfEngagement$toeFocus+]{$regen}[$regen+]$focus",
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

local function SurvivalLoadDefaultSettings(includeBarText)
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
			arcaneShot = {
				enabled = false, -- 1
			},
			revivePet = {
				enabled = false, -- 2
			},
			wingClip = {
				enabled = false, -- 3
			},
			--[[killCommand = {
				enabled = true, -- 4
			},]]
			killShot = {
				enabled = true, -- 5
			},
			scareBeast = {
				enabled = false, -- 6
			},
			explosiveShot = {
				enabled = true, -- 7
			},
			barrage = {
				enabled = true, -- 8
			},
			serpentSting = {
				enabled = true, -- 9
			},
			raptorStrike = {
				enabled = true, -- 10
			},
			carve = {
				enabled = true, -- 11
			},
			butchery = {
				enabled = true, -- 12
			},
			mongooseBite = {
				enabled = true, -- 4, but really 13
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
		endOfCoordinatedAssault = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
		overcap={
			mode="relative",
			relative=0,
			fixed=120
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
				current="FFAB5124",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF005500",
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
				border="FFAB5124",
				borderOvercap="FFFF0000",
				background="66000000",
				base="FFFF8040",
				coordinatedAssault="FF00B60E",
				coordinatedAssaultEnding="FFFF0000",
				casting="FFFFFFFF",
				spending="FF555555",
				passive="FF005500",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				overcapEnabled=true
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
			killShot={
				name = L["HunterAudioKillShotReady"],
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
		settings.displayText.barText = SurvivalLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Options.LoadDefaultSettings()

	settings.hunter.beastMastery = BeastMasteryLoadDefaultSettings(includeBarText)
	settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings(includeBarText)
	settings.hunter.survival = SurvivalLoadDefaultSettings(includeBarText)
	return settings
end
TRB.Options.Hunter.LoadDefaultSettings = LoadDefaultSettings

--[[

Beast Mastery Option Menus

]]

local function BeastMasteryConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.beastMastery = BeastMasteryLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BeastMasteryLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BeastMasteryLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["HunterBeastMasteryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BeastMasteryLoadDefaultBarTextNarrowAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
end

local function BeastMasteryConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.beastMastery
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 1, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 1, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], "notFull", true, L["HunterBeastMasteryBeastialWrath"], L["HunterBeastMasteryBeastialWrath"])

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 30
	controls.colors.frenzyUse = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerBarbedShotUse"], spec.colors.bar.frenzyUse, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.frenzyUse
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "frenzyUse")
	end)

	yCoord = yCoord - 30
	controls.colors.frenzyHold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerBarbedShotHold"], spec.colors.bar.frenzyHold, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.frenzyHold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "frenzyHold")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], true, false)
	
	yCoord = yCoord - 30		
	controls.checkBoxes.beastialWrathBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Border_Option_beastialWrathChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.beastialWrathBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryCheckboxBeastialWrath"])
	f.tooltip = L["HunterBeastMasteryCheckboxBeastialWrathTooltip"]
	f:SetChecked(spec.colors.bar.beastialWrathEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.beastialWrathEnabled = self:GetChecked()
	end)

	controls.colors.borderBeastialWrath = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerBeastialWrath"], spec.colors.bar.borderBeastialWrath, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderBeastialWrath
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderBeastialWrath")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.beastCleaveBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Border_Option_beastCleaveChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.beastCleaveBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryCheckboxBeastCleave"])
	f.tooltip = L["HunterBeastMasteryCheckboxBeastCleaveTooltip"]
	f:SetChecked(spec.colors.bar.beastCleave.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.beastCleave.enabled = self:GetChecked()
	end)

	controls.colors.beastCleave = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerBeastCleave"], spec.colors.bar.beastCleave.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.beastCleave
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "beastCleave")
	end)

	yCoord = yCoord - 40
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceFocus"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceFocus"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
	f = controls.colors.threshold.over
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
	end)

	controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnsuable"], spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
	f = controls.colors.threshold.unusable
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
	end)

	--[[
	controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, "(T28) Cobra Shot's damage is buffed", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.special
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
	end)]]

	controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.threshold.outOfRange
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
	end)

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)
			
	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.arcaneShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxArcaneShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxArcaneShotTooltip"]
	f:SetChecked(spec.thresholds.arcaneShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.arcaneShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.aMurderOfCrowsThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxMurderOfCrows"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxMurderOfCrowsTooltip"]
	f:SetChecked(spec.thresholds.aMurderOfCrows.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.aMurderOfCrows.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.barrageThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxBarrage"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxBarrageTooltip"]
	f:SetChecked(spec.thresholds.barrage.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.barrage.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cobraShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_cobraShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cobraShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxCobraShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxCobraShotTooltip"]
	f:SetChecked(spec.thresholds.cobraShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.cobraShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.explosiveShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.explosiveShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxExplosiveShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxExplosiveShotTooltip"]
	f:SetChecked(spec.thresholds.explosiveShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.explosiveShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killCommandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxKillCommand"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxKillCommandTooltip"]
	f:SetChecked(spec.thresholds.killCommand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.killCommand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxKillShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxKillShotTooltip"]
	f:SetChecked(spec.thresholds.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.killShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.multiShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxMultiShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxMultiShotTooltip"]
	f:SetChecked(spec.thresholds.multiShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.multiShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.serpentStingThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxSerpentSting"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxSerpentStingTooltip"]
	f:SetChecked(spec.thresholds.serpentSting.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.serpentSting.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wailingArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wailingArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wailingArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxWailingArrow"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxWailingArrowTooltip"]
	f:SetChecked(spec.thresholds.wailingArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.wailingArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.petAndUtility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.revivePet.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.scareBeast.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.wingClip.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.labels.pvpthreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.direBeastBasiliskThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_direBeastBasilisk", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.direBeastBasiliskThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxDireBeastBasilisk"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxDireBeastBasiliskTooltip"]
	f:SetChecked(spec.thresholds.direBeastBasilisk.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.direBeastBasilisk.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.direBeastHawkThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_direBeastHawk", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.direBeastHawkThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxDireBeastHawk"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxDireBeastHawkTooltip"]
	f:SetChecked(spec.thresholds.direBeastHawk.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.direBeastHawk.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], 120)

	TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
end

local function BeastMasteryConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.beastMastery
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_BeastMastery_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 1, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerPassive"], spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
	f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$ssCount/$ssTime")
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

	--[[controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.pandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
	end)]]

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-60)--90)
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

	TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
end

local function BeastMasteryConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.beastMastery
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, 1, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterAudioCheckboxKillShot"])
	f.tooltip = L["HunterAudioCheckboxKillShotTooltip"]
	f:SetChecked(spec.audio.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.killShot.enabled = self:GetChecked()

		if spec.audio.killShot.enabled then
			PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.killShotAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_BeastMastery_killShot_Audio", parent)
	controls.dropDown.killShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.killShotAudio, spec.audio.killShot.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.killShotAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.killShotAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.killShot.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.killShotAudio:SetValue(newValue, newName)
		spec.audio.killShot.sound = newValue
		spec.audio.killShot.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
		CloseDropDownMenus()
		PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceFocus"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceFocus"])
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_BeastMastery_overcapAudio", parent)
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
		PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	yCoord = yCoord - 60
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterPassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackFocusRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegen"])
	f.tooltip = L["HunterCheckboxTrackFocusRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.focusGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
		controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
		spec.generation.mode = "gcd"
	end)

	title = L["HunterTrackFocusRegenFocusGcds"] 
	controls.focusGenerationGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.generation.gcds = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.focusGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
		controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
		spec.generation.mode = "time"
	end)

	title = L["HunterTrackFocusRegenFocusTime"]
	controls.focusGenerationTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.generation.time = value
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
end

local function BeastMasteryConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.beastMastery
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Hunter_BeastMastery_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 1, yCoord, cache)
end

local function BeastMasteryConstructOptionsPanel(cache)
	
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.beastMastery or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.beastMasteryDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_BeastMastery", UIParent)
	interfaceSettingsFrame.beastMasteryDisplayPanel.name = L["HunterBeastMasteryFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.beastMasteryDisplayPanel.parent = parent.name
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.beastMasteryDisplayPanel, L["HunterBeastMasteryFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.beastMasteryDisplayPanel)

	parent = interfaceSettingsFrame.beastMasteryDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterBeastMasteryFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.beastMasteryHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_beastMasteryHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.beastMasteryHunterEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["HunterBeastMasteryFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.hunter.beastMastery)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.hunter.beastMastery = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.beastMasteryHunterEnabled, TRB.Data.settings.core.enabled.hunter.beastMastery, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.beastMasteryHunterEnabled, TRB.Data.settings.core.enabled.hunter.beastMastery, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 1, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Hunter_BeastMastery_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls

	BeastMasteryConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	BeastMasteryConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	BeastMasteryConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	BeastMasteryConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	BeastMasteryConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end

--[[

Marksmanship Option Menus

]]

local function MarksmanshipConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MarksmanshipLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MarksmanshipLoadDefaultBarTextAdvancedSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["HunterMarksmanshipFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = MarksmanshipLoadDefaultBarTextNarrowAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
end

local function MarksmanshipConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.marksmanship
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 2, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 2, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 2, yCoord, "Fury")

	yCoord = yCoord - 30
	controls.colors.trueshot = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterMarksmanshipColorPickerTrueshot"], spec.colors.bar.trueshot, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.trueshot
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "trueshot")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfTrueshot = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfTrueshot
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxEndOfTrueshot"])
	f.tooltip = L["HunterMarksmanshipCheckboxEndOfTrueshotTooltip"]
	f:SetChecked(spec.endOfTrueshot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfTrueshot.enabled = self:GetChecked()
	end)

	controls.colors.trueshotEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterMarksmanshipColorPickerTrueshotEnd"], spec.colors.bar.trueshotEnding, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.trueshotEnding
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "trueshotEnding")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showCastingBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
	f.tooltip = L["ShowCastingBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showCasting)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showCasting = self:GetChecked()
	end)

	controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCastingBuilder"], spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 2)
	end)

	yCoord = yCoord - 30
	controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCastingSpender"], spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerBarPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], true, false)

	yCoord = yCoord - 30
	controls.checkBoxes.steadyFocus = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_steadyFocus_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.steadyFocus
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxSteadyFocus"])
	f.tooltip = L["HunterMarksmanshipCheckboxSteadyFocusTooltip"]
	f:SetChecked(spec.steadyFocus.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.steadyFocus.enabled = self:GetChecked()
	end)
	
	controls.colors.borderSteadyFocus = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterMarksmanshipColorPickerSteadyFocus"], spec.colors.bar.borderSteadyFocus, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderSteadyFocus
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderSteadyFocus")
	end)

	yCoord = yCoord - 40
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceFocus"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceFocus"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
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

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)
			
	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.aimedShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aimedShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.aimedShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxAimedShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxAimedShotTooltip"]
	f:SetChecked(spec.thresholds.aimedShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.aimedShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.arcaneShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShotTooltip"]
	f:SetChecked(spec.thresholds.arcaneShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.arcaneShot.enabled = self:GetChecked()
		spec.thresholds.chimaeraShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.barrageThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxBarrage"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxBarrageTooltip"]
	f:SetChecked(spec.thresholds.barrage.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.barrage.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.burstingShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_burstingShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.burstingShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxBurstingShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxBurstingShotTooltip"]
	f:SetChecked(spec.thresholds.burstingShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.burstingShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.explosiveShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.explosiveShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxExplosiveShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxExplosiveShotTooltip"]
	f:SetChecked(spec.thresholds.explosiveShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.explosiveShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killCommandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxKillCommand"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxKillCommandTooltip"]
	f:SetChecked(spec.thresholds.killCommand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.killCommand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxKillShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxKillShotTooltip"]
	f:SetChecked(spec.thresholds.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.killShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.multiShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxMultiShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxMultiShotTooltip"]
	f:SetChecked(spec.thresholds.multiShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.multiShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.serpentStingThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxSerpentSting"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxSerpentStingTooltip"]
	f:SetChecked(spec.thresholds.serpentSting.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.serpentSting.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wailingArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_wailingArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wailingArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxWailingArrow"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxWailingArrowTooltip"]
	f:SetChecked(spec.thresholds.wailingArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.wailingArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.petAndUtility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.revivePet.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.scareBeast.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.wingClip.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.sniperShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_sniperShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sniperShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxSniperShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxSniperShotTooltip"]
	f:SetChecked(spec.thresholds.sniperShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.sniperShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterMarksmanshipHeaderEndOfTrueshotConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfTrueshotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfTrueshotModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxTrueshotGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfTrueshot.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfTrueshotModeTime:SetChecked(false)
		spec.endOfTrueshot.mode = "gcd"
	end)

	title = L["HunterMarksmanshipTrueshotGcds"]
	controls.endOfTrueshotGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfTrueshot.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfTrueshotGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfTrueshot.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfTrueshotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfTrueshotModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxTrueshotTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfTrueshot.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfTrueshotModeTime:SetChecked(true)
		spec.endOfTrueshot.mode = "time"
	end)

	title = L["HunterMarksmanshipTrueshotTime"]
	controls.endOfTrueshotTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfTrueshot.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfTrueshotTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfTrueshot.timeMax = value
	end)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterMarksmanshipHeaderSteadyFocusExpiration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.steadyFocusModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_steadyFocus_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.steadyFocusModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxSteadyFocusGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.steadyFocus.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.steadyFocusModeGCDs:SetChecked(true)
		controls.checkBoxes.steadyFocusModeTime:SetChecked(false)
		spec.steadyFocus.mode = "gcd"
	end)

	title = L["HunterMarksmanshipSteadyFocusGcds"]
	controls.steadyFocusGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 30, spec.steadyFocus.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.steadyFocusGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.steadyFocus.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes.steadyFocusModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_steadyFocus_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.steadyFocusModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxSteadyFocusTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.steadyFocus.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.steadyFocusModeGCDs:SetChecked(false)
		controls.checkBoxes.steadyFocusModeTime:SetChecked(true)
		spec.steadyFocus.mode = "time"
	end)

	title = L["HunterMarksmanshipSteadyFocusTime"]
	controls.steadyFocusTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.steadyFocus.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.steadyFocusTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.steadyFocus.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], 120)

	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
end

local function MarksmanshipConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.marksmanship
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Marksmanship_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 2, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingBuilder"], spec.colors.text.casting, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerPassive"], spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
	f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$ssCount/$ssTime")
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

	--[[controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.pandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
	end)]]

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-60)--90)
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

	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
end

local function MarksmanshipConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.marksmanship
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, 2, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.aimedShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_aimedShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.aimedShotAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxAimedShot"])
	f.tooltip = L["HunterMarksmanshipCheckboxAimedShotTooltip"]
	f:SetChecked(spec.audio.aimedShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.aimedShot.enabled = self:GetChecked()

		if spec.audio.aimedShot.enabled then
			PlaySoundFile(spec.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.aimedShotAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Marksmanship_aimedShot_Audio", parent)
	controls.dropDown.aimedShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.aimedShotAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, spec.audio.aimedShot.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.aimedShotAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.aimedShotAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.aimedShot.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.aimedShotAudio:SetValue(newValue, newName)
		spec.audio.aimedShot.sound = newValue
		spec.audio.aimedShot.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	
	yCoord = yCoord - 60
	controls.checkBoxes.aimedShotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.aimedShotModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxAimedShotGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.audio.aimedShot.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.aimedShotModeGCDs:SetChecked(true)
		controls.checkBoxes.aimedShotModeTime:SetChecked(false)
		spec.audio.aimedShot.mode = "gcd"
	end)

	title = L["HunterMarksmanshipAimedShotGcds"]
	controls.aimedShotGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 6, spec.audio.aimedShot.gcds, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.aimedShotGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.audio.aimedShot.gcds = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.aimedShotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.aimedShotModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxAimedShotTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.audio.aimedShot.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.aimedShotModeGCDs:SetChecked(false)
		controls.checkBoxes.aimedShotModeTime:SetChecked(true)
		spec.audio.aimedShot.mode = "time"
	end)

	title = L["HunterMarksmanshipAimedShotTime"]
	controls.aimedShotTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 12, spec.audio.aimedShot.time, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.aimedShotTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.audio.aimedShot.time = value
	end)



	yCoord = yCoord - 50
	controls.checkBoxes.lockAndLoadAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_lockAndLoad_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.lockAndLoadAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxLockAndLoad"])
	f.tooltip = L["HunterMarksmanshipCheckboxLockAndLoadTooltip"]
	f:SetChecked(spec.audio.lockAndLoad.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.lockAndLoad.enabled = self:GetChecked()

		if spec.audio.lockAndLoad.enabled then
			PlaySoundFile(spec.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.lockAndLoadAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Marksmanship_lockAndLoad_Audio", parent)
	controls.dropDown.lockAndLoadAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.lockAndLoadAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, spec.audio.lockAndLoad.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.lockAndLoadAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.lockAndLoadAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.lockAndLoad.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.lockAndLoadAudio:SetValue(newValue, newName)
		spec.audio.lockAndLoad.sound = newValue
		spec.audio.lockAndLoad.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterAudioCheckboxKillShot"])
	f.tooltip = L["HunterAudioCheckboxKillShotTooltip"]
	f:SetChecked(spec.audio.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.killShot.enabled = self:GetChecked()

		if spec.audio.killShot.enabled then
			PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.killShotAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Marksmanship_killShot_Audio", parent)
	controls.dropDown.killShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.killShotAudio, spec.audio.killShot.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.killShotAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.killShotAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.killShot.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.killShotAudio:SetValue(newValue, newName)
		spec.audio.killShot.sound = newValue
		spec.audio.killShot.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceFocus"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceFocus"])
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Marksmanship_overcapAudio", parent)
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
	controls.checkBoxes.secretsOfTheUnblinkingVigilAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_secretsOfTheUnblinkingVigil_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.secretsOfTheUnblinkingVigilAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipCheckboxUnblinkingVigil"])
	f.tooltip = L["HunterMarksmanshipCheckboxUnblinkingVigilTooltip"]
	f:SetChecked(spec.audio.secretsOfTheUnblinkingVigil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.secretsOfTheUnblinkingVigil.enabled = self:GetChecked()

		if spec.audio.secretsOfTheUnblinkingVigil.enabled then
			PlaySoundFile(spec.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.secretsOfTheUnblinkingVigilAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Marksmanship_secretsOfTheUnblinkingVigilAudio", parent)
	controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.secretsOfTheUnblinkingVigilAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, spec.audio.secretsOfTheUnblinkingVigil.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.secretsOfTheUnblinkingVigilAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.secretsOfTheUnblinkingVigil.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetValue(newValue, newName)
		spec.audio.secretsOfTheUnblinkingVigil.sound = newValue
		spec.audio.secretsOfTheUnblinkingVigil.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterPassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackFocusRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegen"])
	f.tooltip = L["HunterCheckboxTrackFocusRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)


	yCoord = yCoord - 40
	controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.focusGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
		controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
		spec.generation.mode = "gcd"
	end)

	title = L["HunterTrackFocusRegenFocusGcds"]
	controls.focusGenerationGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.generation.gcds = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.focusGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
		controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
		spec.generation.mode = "time"
	end)

	title = L["HunterTrackFocusRegenFocusTime"]
	controls.focusGenerationTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.generation.time = value
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
end

local function MarksmanshipConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.marksmanship
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Hunter_Marksmanship_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 2, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 2, yCoord, cache)
end

local function MarksmanshipConstructOptionsPanel(cache)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.marksmanship or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.marksmanshipDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Marksmanship", UIParent)
	interfaceSettingsFrame.marksmanshipDisplayPanel.name = L["HunterMarksmanshipFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.marksmanshipDisplayPanel.parent = parent.name
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.marksmanshipDisplayPanel, L["HunterMarksmanshipFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.marksmanshipDisplayPanel)

	parent = interfaceSettingsFrame.marksmanshipDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterMarksmanshipFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.marksmanshipHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_marksmanshipHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.marksmanshipHunterEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["HunterMarksmanshipFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.hunter.marksmanship)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.hunter.marksmanship = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.marksmanshipHunterEnabled, TRB.Data.settings.core.enabled.hunter.marksmanship, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.marksmanshipHunterEnabled, TRB.Data.settings.core.enabled.hunter.marksmanship, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Hunter_Marksmanship_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 2, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Hunter_Marksmanship_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls

	MarksmanshipConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	MarksmanshipConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	MarksmanshipConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	MarksmanshipConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	MarksmanshipConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end

--[[

Survival Options Menus

]]


local function SurvivalConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.survival
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.hunter.survival = SurvivalLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SurvivalLoadDefaultBarTextSimpleSettings()
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["HunterSurvivalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SurvivalLoadDefaultBarTextAdvancedSettings()
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
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
end

local function SurvivalConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.survival
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Survival_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Survival_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 3, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 3, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 30
	controls.colors.coordinatedAssault = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalColorPickerCoordinatedAssult"], spec.colors.bar.coordinatedAssault, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.coordinatedAssault
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "coordinatedAssault")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfCoordinatedAssault = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfCoordinatedAssault
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalCheckboxEndOfCoordinatedAssult"])
	f.tooltip = L["HunterSurvivalCheckboxEndOfCoordinatedAssultTooltip"]
	f:SetChecked(spec.endOfCoordinatedAssault.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfCoordinatedAssault.enabled = self:GetChecked()
	end)

	controls.colors.coordinatedAssaultEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalColorPickerEndOfCoordinatedAssult"], spec.colors.bar.coordinatedAssaultEnding, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.coordinatedAssaultEnding
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "coordinatedAssaultEnding")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showCastingBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
	f.tooltip = L["ShowCastingBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showCasting)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showCasting = self:GetChecked()
	end)

	controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCastingSpender"], spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerBarPassive"], spec.colors.bar.passive, 525, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 3)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], true, false)

	yCoord = yCoord - 40
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 25
	controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceFocus"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.threshold.under
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
	end)

	controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceFocus"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
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

	controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOutOfRange
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
	f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
	f:SetChecked(spec.thresholds.outOfRange)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.outOfRange = self:GetChecked()
	end)

	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines(spec)
	end)

			
	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.arcaneShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxArcaneShot"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxArcaneShotTooltip"]
	f:SetChecked(spec.thresholds.arcaneShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.arcaneShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.barrageThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxBarrage"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxBarrageTooltip"]
	f:SetChecked(spec.thresholds.butchery.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.barrage.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.butcheryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_butchery", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.butcheryThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxButchery"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxButcheryTooltip"]
	f:SetChecked(spec.thresholds.butchery.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.butchery.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.carveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_carve", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.carveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxCarve"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxCarveTooltip"]
	f:SetChecked(spec.thresholds.carve.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.carve.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.explosiveShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.explosiveShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxExplosiveShot"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxExplosiveShotTooltip"]
	f:SetChecked(spec.thresholds.explosiveShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.explosiveShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxKillShot"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxKillShotTooltip"]
	f:SetChecked(spec.thresholds.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.killShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raptorStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_raptorStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raptorStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxRaptorStrikeMongooseBite"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxRaptorStrikeMongooseBiteTooltip"]
	f:SetChecked(spec.thresholds.raptorStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.raptorStrike.enabled = self:GetChecked()
		spec.thresholds.mongooseBite.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.serpentStingThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdSerpentStingCheckbox"])
	f.tooltip = L["HunterSurvivalThresholdSerpentStingCheckboxTooltip"]
	f:SetChecked(spec.thresholds.serpentSting.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.serpentSting.enabled = self:GetChecked()
	end)
			
	yCoord = yCoord - 25
	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.revivePet.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.scareBeast.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.wingClip.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterSurvivalHeaderEndOfCoordinatedAssaultConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfCoordinatedAssaultModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfCoordinatedAssaultModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalCheckboxCoordinatedAssaultGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfCoordinatedAssault.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(false)
		spec.endOfCoordinatedAssault.mode = "gcd"
	end)

	title = L["HunterSurvivalCoordinatedAssaultGcds"]
	controls.endOfCoordinatedAssaultGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfCoordinatedAssault.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfCoordinatedAssaultGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfCoordinatedAssault.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes.endOfCoordinatedAssaultModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfCoordinatedAssaultModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalCheckboxCoordinatedAssaultTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfCoordinatedAssault.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(true)
		spec.endOfCoordinatedAssault.mode = "time"
	end)

	title = L["HunterSurvivalCoordinatedAssaultTime"]
	controls.endOfCoordinatedAssaultTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfCoordinatedAssault.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfCoordinatedAssaultTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfCoordinatedAssault.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], 120)

	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
end

local function SurvivalConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.survival
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Survival_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 3, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerPassive"], spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThresholdEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThresholdEnabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcapEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcapEnabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25

	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
	f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$ssCount/$ssTime")
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

	--[[controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
	f = controls.colors.dots.pandemic
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
	end)]]

	controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-60)--90)
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

	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
end

local function SurvivalConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.survival
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Survival_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 3, 3, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterAudioCheckboxKillShot"])
	f.tooltip = L["HunterAudioCheckboxKillShotTooltip"]
	f:SetChecked(spec.audio.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.killShot.enabled = self:GetChecked()

		if spec.audio.killShot.enabled then
			PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.killShotAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Survival_killShot_Audio", parent)
	controls.dropDown.killShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, oUi.dropdownWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.killShotAudio, spec.audio.killShot.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.killShotAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.killShotAudio, function(self, level, menuList)
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
					info.checked = sounds[v] == spec.audio.killShot.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.killShotAudio:SetValue(newValue, newName)
		spec.audio.killShot.sound = newValue
		spec.audio.killShot.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
		CloseDropDownMenus()
		PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
	end

	yCoord = yCoord - 60
	controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapAudio
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceFocus"]))
	f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceFocus"])
	f:SetChecked(spec.audio.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.overcap.enabled = self:GetChecked()

		if spec.audio.overcap.enabled then
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Hunter_Survival_overcapAudio", parent)
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
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterPassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.trackFocusRegen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegen"])
	f.tooltip = L["HunterCheckboxTrackFocusRegenTooltip"]
	f:SetChecked(spec.generation.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.generation.enabled = self:GetChecked()
	end)


	yCoord = yCoord - 40
	controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_PFG_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.focusGenerationModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegenGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
		controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
		spec.generation.mode = "gcd"
	end)

	title = L["HunterTrackFocusRegenFocusGcds"]
	controls.focusGenerationGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.generation.gcds = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_PFG_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.focusGenerationModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterCheckboxTrackFocusRegenTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.generation.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
		controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
		spec.generation.mode = "time"
	end)

	title = L["HunterTrackFocusRegenFocusTime"]
	controls.focusGenerationTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.generation.time = value
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
end

local function SurvivalConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.survival
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Hunter_Survival_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 3, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 3, yCoord, cache)
end

local function SurvivalConstructOptionsPanel(cache)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.survival or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}		
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.survivalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Survival", UIParent)
	interfaceSettingsFrame.survivalDisplayPanel.name = L["HunterSurvivalFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.survivalDisplayPanel.parent = parent.name
	--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.survivalDisplayPanel, L["HunterSurvivalFull"])
	InterfaceOptions_AddCategory(interfaceSettingsFrame.survivalDisplayPanel)

	parent = interfaceSettingsFrame.survivalDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterSurvivalFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.survivalHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_survivalHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.survivalHunterEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["HunterSurvivalFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.hunter.survival)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.hunter.survival = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.survivalHunterEnabled, TRB.Data.settings.core.enabled.hunter.survival, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.survivalHunterEnabled, TRB.Data.settings.core.enabled.hunter.survival, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Hunter_Survival_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Hunter_Survival_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 3, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab2", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do 
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Hunter_Survival_LayoutPanel" .. i, parent)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls

	SurvivalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	SurvivalConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	SurvivalConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	SurvivalConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	SurvivalConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	BeastMasteryConstructOptionsPanel(specCache.beastMastery)
	MarksmanshipConstructOptionsPanel(specCache.marksmanship)
	SurvivalConstructOptionsPanel(specCache.survival)
end
TRB.Options.Hunter.ConstructOptionsPanel = ConstructOptionsPanel