local _, TRB = ...
if TRB.Data.character.classId ~= 3 then --Only do this if we're on a Hunter!
	return
end
local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Hunter = {}
TRB.Options.Hunter.BeastMastery = {}
TRB.Options.Hunter.Marksmanship = {}
TRB.Options.Hunter.Survival = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.survival = {}

local BEAST_MASTERY_MAX_FOCUS = 100
local MARKSMANSHIP_MAX_FOCUS = 100
local SURVIVAL_MAX_FOCUS = 100

local function BeastMasteryLoadDefaultBarTextSimpleSettings()
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
			text="",--{$frenzyStacks}[$frenzyTime ($frenzyStacks)]",
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
			text="{$casting}[$casting + ]$focus",
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
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$haste% ($gcd)",
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
			text="",--{$frenzyStacks}[#frenzy$frenzyTime - $frenzyStacks#frenzy]",
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
			text="{$casting}[#casting$casting+]{$regen}[$regen+]$focus",
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
				revivePet = {
					enabled = false,
				},
				wingClip = {
					enabled = false,
				},
				killCommand = {
					enabled = true,
				},
				scareBeast = {
					enabled = false,
				},
				cobraShot = {
					enabled = true,
				},
				blackArrow = {
					enabled = true,
				},
				wildThrash = { -- New
					enabled = true,
				},
				direBeastHawk = {
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
			value = BEAST_MASTERY_MAX_FOCUS,
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
		colors = {
			text = {
				current = {
					color = "FFAB5124"
				},
				casting = {
					color = "FFFFFFFF"
				},
				spending = {
					color = "FF555555"
				},
				passive = {
					color = "FF005500"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				}
			},
			bar = {
				border="FFAB5124",
				borderbestialWrath="FF005500",
				background="66000000",
				base="FFFF8040",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
				bestialWrathEnabled=true,
				beastCleave = {
					color = "FF77FF77",
					enabled = true
				}
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
			beastCleaveDown={
				name = L["HunterBeastMasteryAudioBeastCleaveDown"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
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
		settings.displayText.barText = BeastMasteryLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function MarksmanshipLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
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
			text="{$casting}[$casting + ]$focus",
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
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$haste% ($gcd)",
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
			guid = TRB.Functions.String:Guid(),
			text="{$casting}[#casting$casting+]$focus",
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
				arcaneShot = {
					enabled = true,
				},
				revivePet = {
					enabled = false,
				},
				wingClip = {
					enabled = false,
				},
				scareBeast = {
					enabled = false,
				},
			killCommand = {
				enabled = true,
			},
				killShot = {
					enabled = true,
				},
				aimedShot = {
					enabled = true,
				},
				multiShot = {
					enabled = true,
				},
			blackArrow = {
				enabled = true,
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
			value = MARKSMANSHIP_MAX_FOCUS,
			enabled = false
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
					color = "FFAB5124"
				},
				casting = {
					color = "FFFFFFFF"
				},
				spending = {
					color = "FF555555"
				},
				passive = {
					color = "FF005500"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				}
			},
			bar = {
				border="FFAB5124",
				borderSteadyFocus="FFFFFF00",
				background="66000000",
				base="FFFF8040",
				trueshot="FF00B60E",
				trueshotEnding="FFFF0000",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
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
			textureLock=true
		}
	}

	if includeBarText then
		settings.displayText.barText = MarksmanshipLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function SurvivalLoadDefaultBarTextSimpleSettings()
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
			text="{$casting}[$casting + ]$focus",
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
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$haste% ($gcd)",
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
			text="{$casting}[#casting$casting+]{$regen}[$regen+]$focus",
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
				revivePet = {
					enabled = false,
				},
				wingClip = {
					enabled = false,
				},
				scareBeast = {
					enabled = false,
				},
				boomstick = {
					enabled = true,
				},
				hatchetToss = {
					enabled = true,
				},
				raptorStrike = {
					enabled = true,
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
			value = SURVIVAL_MAX_FOCUS,
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
		colors = {
			text = {
				current = {
					color = "FFAB5124"
				},
				casting = {
					color = "FFFFFFFF"
				},
				spending = {
					color = "FF555555"
				},
				passive = {
					color = "FF005500"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				}
			},
			bar = {
				border="FFAB5124",
				background="66000000",
				base="FFFF8040",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
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
			textureLock=true
		}
	}

	if includeBarText then
		settings.displayText.barText = SurvivalLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 1, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], "notFull", true, L["HunterBeastMasterybestialWrath"], L["HunterBeastMasterybestialWrath"])

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"])

	--[[yCoord = yCoord - 30
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
	end)]]

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], true, false)
	
	--[[yCoord = yCoord - 30
	controls.checkBoxes.bestialWrathBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Border_Option_bestialWrathChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.bestialWrathBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryCheckboxbestialWrath"])
	f.tooltip = L["HunterBeastMasteryCheckboxbestialWrathTooltip"]
	f:SetChecked(spec.colors.bar.bestialWrathEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.bestialWrathEnabled = self:GetChecked()
	end)

	controls.colors.borderbestialWrath = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterBeastMasteryColorPickerbestialWrath"], spec.colors.bar.borderbestialWrath, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderbestialWrath
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderbestialWrath")
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
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], 1, BEAST_MASTERY_MAX_FOCUS)
end

local function BeastMasteryConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.beastMastery
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_BeastMastery_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 3, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20
	controls.checkBoxes.blackArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_blackArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blackArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxBlackArrow"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxBlackArrowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.blackArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.blackArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cobraShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_cobraShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cobraShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxCobraShot"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxCobraShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cobraShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cobraShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killCommandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxKillCommand"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxKillCommandTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.killCommand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.killCommand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.wildThrashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wildThrash", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wildThrashThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxWildThrash"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxWildThrashTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wildThrash.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wildThrash.enabled = self:GetChecked()
	end)


	controls.labels.petAndUtility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revivePet.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.scareBeast.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wingClip.enabled = self:GetChecked()
	end)
	
	yCoord2 = yCoord2 - 25
	controls.labels.pvpthreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.direBeastHawkThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_direBeastHawk", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.direBeastHawkThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterBeastMasteryThresholdCheckboxDireBeastHawk"])
	f.tooltip = L["HunterBeastMasteryThresholdCheckboxDireBeastHawkTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.direBeastHawk.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.direBeastHawk.enabled = self:GetChecked()
	end)

	yCoord = math.min(yCoord, yCoord2)
	
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 1, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 1, yCoord)
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 3, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 1, yCoord)
end

local function BeastMasteryConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 1
	local spec = TRB.Data.settings.hunter.beastMastery

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.beastMastery
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "beastCleaveDown", spec, classId, specId, yCoord, L["HunterBeastMasteryAudioCheckboxBeastCleaveDown"], L["HunterBeastMasteryAudioCheckboxBeastCleaveDownTooltip"])
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 1, yCoord, cache)
end

local function BeastMasteryConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(3, 1)
	local namePrefix = className .. "_" .. specName
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
	TRB.Details.addonCategory.specs["beastMastery"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.beastMasteryDisplayPanel, L["HunterBeastMasteryFull"])

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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterBeastMasteryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 1, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls

	BeastMasteryConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	BeastMasteryConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	BeastMasteryConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	BeastMasteryConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	BeastMasteryConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	BeastMasteryConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 2, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"])

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
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], true, false)

	--[[yCoord = yCoord - 30
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
	end)]]

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

	--[[yCoord = yCoord - 40
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
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], 1, MARKSMANSHIP_MAX_FOCUS)

	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
end

local function MarksmanshipConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.marksmanship
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_Marksmanship_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 3, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.aimedShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aimedShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.aimedShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxAimedShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxAimedShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.aimedShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.aimedShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.arcaneShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxArcaneShotChimeraShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.arcaneShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.arcaneShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.blackArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_blackArrow", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blackArrowThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxBlackArrow"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxBlackArrowTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.blackArrow.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.blackArrow.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killCommandThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxKillCommand"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxKillCommandTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.killCommand.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.killCommand.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxKillShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxKillShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.killShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.killShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.multiShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterMarksmanshipThresholdCheckboxMultiShot"])
	f.tooltip = L["HunterMarksmanshipThresholdCheckboxMultiShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.multiShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.multiShot.enabled = self:GetChecked()
	end)


	controls.labels.petAndUtility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revivePet.enabled = self:GetChecked()
	end)
	
	yCoord2 = yCoord2 - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.scareBeast.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wingClip.enabled = self:GetChecked()
	end)

	yCoord = math.min(yCoord, yCoord2)
	
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 2, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 2, yCoord)
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 3, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingBuilder"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 2, yCoord)
end

local function MarksmanshipConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 2
	local spec = TRB.Data.settings.hunter.marksmanship

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.marksmanship
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--[[yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "aimedShot", spec, classId, specId, yCoord, L["HunterMarksmanshipCheckboxAimedShot"], L["HunterMarksmanshipCheckboxAimedShotTooltip"])
	
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
	yCoord = yCoord - 60]]

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "lockAndLoad", spec, classId, specId, yCoord, L["HunterMarksmanshipCheckboxLockAndLoad"], L["HunterMarksmanshipCheckboxLockAndLoadTooltip"])

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "killShot", spec, classId, specId, yCoord, L["HunterAudioCheckboxKillShot"], L["HunterAudioCheckboxKillShotTooltip"])

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "secretsOfTheUnblinkingVigil", spec, classId, specId, yCoord, L["HunterMarksmanshipCheckboxUnblinkingVigil"], L["HunterMarksmanshipCheckboxUnblinkingVigilTooltip"])
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 2, yCoord, cache)
end

local function MarksmanshipConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(3, 2)
	local namePrefix = className .. "_" .. specName
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
	TRB.Details.addonCategory.specs["marksmanship"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.marksmanshipDisplayPanel, L["HunterMarksmanshipFull"])

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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterMarksmanshipFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls

	MarksmanshipConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	MarksmanshipConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	MarksmanshipConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	MarksmanshipConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	MarksmanshipConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	MarksmanshipConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
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
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 3, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 3, 3, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], true, false)

	--[[yCoord = yCoord - 30
	controls.checkBoxes.explosiveShot = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Border_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.explosiveShot
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalCheckboxExplosiveShot"] )
	f.tooltip = L["HunterSurvivalCheckboxExplosiveShotTooltip"]
	f:SetChecked(spec.colors.bar.explosiveShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.explosiveShot.enabled = self:GetChecked()
	end)

	controls.colors.explosiveShot = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterSurvivalColorPickerExplosiveShot"], spec.colors.bar.explosiveShot.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.explosiveShot
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "explosiveShot")
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], 1, SURVIVAL_MAX_FOCUS)

	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
end

local function SurvivalConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.survival
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Hunter_BeastMastery_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_BeastMastery_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 3, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryDamageDealing"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.boomstickThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_boomstick", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.boomstickThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxBoomstick"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxBoomstickTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.boomstick.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.boomstick.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.hatchetTossThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_hatchetToss", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.hatchetTossThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxHatchetToss"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxHatchetTossTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.hatchetToss.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.hatchetToss.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raptorStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_raptorStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raptorStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterSurvivalThresholdCheckboxRaptorStrike"])
	f.tooltip = L["HunterSurvivalThresholdCheckboxRaptorStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.raptorStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.raptorStrike.enabled = self:GetChecked()
	end)

	controls.labels.damageDealing = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPetAndUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revivePetThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxRevivePet"])
	f.tooltip = L["HunterThresholdCheckboxRevivePetTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revivePet.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revivePet.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.scareBeastThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxScareBeast"])
	f.tooltip = L["HunterThresholdCheckboxScareBeastTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.scareBeast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.scareBeast.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.wingClipThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["HunterThresholdCheckboxWingClip"])
	f.tooltip = L["HunterThresholdCheckboxWingClipTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.wingClip.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.wingClip.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 3, 3, yCoord, L["ResourceFocus"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 3, 3, yCoord)
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 3, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 3, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HunterTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 3, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerTextCastingSpender"], spec.colors.text.spending.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerPassive"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HunterColorPickerHaveEnoughFocusToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["HunterCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 3, 3, yCoord)
end

local function SurvivalConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 3
	local specId = 3
	local spec = TRB.Data.settings.hunter.survival

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.survival
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Hunter_Survival_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 3, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 3, 3, yCoord, cache)
end

local function SurvivalConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(3, 3)
	local namePrefix = className .. "_" .. specName
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
	TRB.Details.addonCategory.specs["survival"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.survivalDisplayPanel, L["HunterSurvivalFull"])
	
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
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["HunterSurvivalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 3, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls

	SurvivalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	SurvivalConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	SurvivalConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	SurvivalConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	SurvivalConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	SurvivalConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	BeastMasteryConstructOptionsPanel(specCache.beastMastery)
	MarksmanshipConstructOptionsPanel(specCache.marksmanship)
	SurvivalConstructOptionsPanel(specCache.survival)
end
TRB.Options.Hunter.ConstructOptionsPanel = ConstructOptionsPanel