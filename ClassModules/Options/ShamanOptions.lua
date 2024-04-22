local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
	local L = TRB.Localization
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame

	TRB.Options.Shaman = {}
	TRB.Options.Shaman.Elemental = {}
	TRB.Options.Shaman.Enhancement = {}
	TRB.Options.Shaman.Restoration = {}

	TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = {}

	-- Elemental

	local function ElementalLoadDefaultBarTextSimpleSettings()
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$maelstrom",
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
	TRB.Options.Shaman.ElementalLoadDefaultBarTextSimpleSettings = ElementalLoadDefaultBarTextSimpleSettings

	local function ElementalLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="#flameShock $fsCount    $haste% ($gcd)||n{$ifStacks}[#frostShock $ifStacks][       ]    {$ttd}[TTD: $ttd]",
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
				text="{$casting}[#casting$casting+]{$passive}[$passive+]$maelstrom",
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

	local function ElementalLoadDefaultSettings(includeBarText)
		local settings = {
			hastePrecision=2,
			thresholds = {
				width = 2,
				overlapBorder=true,
				outOfRange=true,
				icons = {
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
				earthShock = { -- 1
					enabled = true,
				},
				earthquake = { -- 2
					enabled = true,
				},
				elementalBlast = { -- 3
					enabled = true,
				},
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfAscendance = {
				enabled=true,
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
					currentMaelstrom="FF6563E0",
					castingMaelstrom="FFFFFFFF",
					passiveMaelstrom="FF995BDD",
					overcapMaelstrom="FFFF0000",
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
					border="FF00008D",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FF0055FF",
					casting="FFFFFFFF",
					passive="FF995BDD",
					earthShock="FF00096A",
					inAscendance="FFFA8128",
					inAscendance1GCD="FFFF0000",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true,
					primalFracture = {
						color = "FFFF9900",
						enabled = true
					}
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					echoesOfGreatSundering="FFFF00FF",
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
				esReady={
					name = L["ShamanElementalAudioEarthShockReady"],
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
			settings.displayText.barText = ElementalLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	-- Enhancement
	local function EnhancementLoadDefaultBarTextSimpleSettings()
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
				text="{$ascendanceTime}[#ascendance $ascendanceTime]",
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
				fontSize=13,
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
	TRB.Options.Shaman.EnhancementLoadDefaultBarTextSimpleSettings = EnhancementLoadDefaultBarTextSimpleSettings
	
	local function EnhancementLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="#flameShock $fsCount {$ttd}[   TTD: $ttd]",
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
				text="{$ascendanceTime}[#ascendance $ascendanceTime #ascendance]",
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
				fontSize=13,
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

	local function EnhancementLoadDefaultSettings(includeBarText)
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
				--[[aeratedManaPotionRank1 = {
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
				},]]
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
				neverShow=false
			},
			bar = {
				width=555,
				height=11,
				xPos=0,
				yPos=-215,
				border=1,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=false,
				showCasting=true
			},
			comboPoints = {
				width=25,
				height=21,
				xPos=0,
				yPos=4,
				border=2,
				spacing=14,
				relativeTo="TOP",
				relativeToName = L["PositionAboveMiddle"],
				fullWidth=true,
			},
			endOfAscendance = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			colors = {
				text = {
					current="FF4D4DFF",
					casting="FFFFFFFF",
					spending="FFFFFFFF",
					passive="FF8080FF",
					dots={
						enabled=true,
						up="FFFFFFFF",
						down="FFFF0000",
						pandemic="FFFFFF00"
					}
				},
				bar = {
					border="FF000099",
					background="66000000",
					base="FF0000FF",
					passive="FF8080FF",
					inAscendance="FFFA8128",
					inAscendance1GCD="FFFF0000",
				},
				comboPoints = {
					border="ff0071df",
					background="66000000",
					base="ff55e2ff",
					penultimate="FFFF9900",
					final="FFFF0000",
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
			settings.displayText.barText = EnhancementLoadDefaultBarTextSimpleSettings()
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

		return textSettings
	end
	TRB.Options.Shaman.RestorationLoadDefaultBarTextSimpleSettings = RestorationLoadDefaultBarTextSimpleSettings

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
				neverShow=false
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
			endOfAscendance = {
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
					innervate="FF00FF00",
					potionOfChilledClarity="FF9EC51E",
					spending="FFFFFFFF",
					passive="FF8080FF",
					inAscendance="FFFA8128",
					inAscendance1GCD="FFFF0000",
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
		settings.shaman.elemental = ElementalLoadDefaultSettings(includeBarText)
		settings.shaman.enhancement = EnhancementLoadDefaultSettings(includeBarText)
		settings.shaman.restoration = RestorationLoadDefaultSettings(includeBarText)

		return settings
	end
	TRB.Options.Shaman.LoadDefaultSettings = LoadDefaultSettings

	--[[

	Elemental Option Menus

	]]


	local function ElementalConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.elemental

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.elemental
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["ShamanElementalFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.shaman.elemental = ElementalLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["ShamanElementalFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ElementalLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["ShamanElementalFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ElementalLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.elemental

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Elemental_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 1, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], "notEmpty", true, L["ShamanElementalEarthShockElementalBlast"], L["ShamanElementalEarthShockElementalBlastAbbreviation"])

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"])

		yCoord = yCoord - 30
		controls.colors.earthShock = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerEarthShock"], spec.colors.bar.earthShock, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.earthShock
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "earthShock")
		end)

		yCoord = yCoord - 30
		controls.colors.inAscendance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerAscendance"], spec.colors.bar.inAscendance, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inAscendance		
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfAscendance = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Checkbox_EOA", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfAscendance
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalCheckboxAscendanceEnd"])
		f.tooltip = L["ShamanElementalCheckboxAscendanceEndTooltip"]
		f:SetChecked(spec.endOfAscendance.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfAscendance.enabled = self:GetChecked()
		end)

		controls.colors.inAscendance1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerAscendanceEnd"], spec.colors.bar.inAscendance1GCD, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inAscendance1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance1GCD")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
		f.tooltip = L["ShowCastingBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerCasting"], spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
		f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], true, false)
		
		yCoord = yCoord - 30
		controls.checkBoxes.primalFractureBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Border_Option_primalFractureBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.primalFractureBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalCheckboxPrimalFracture"])
		f.tooltip = L["ShamanElementalCheckboxPrimalFractureTooltip"]
		f:SetChecked(spec.colors.bar.primalFracture.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.primalFracture.enabled = self:GetChecked()
		end)

		controls.colors.primalFracture = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerPrimalFracture"], spec.colors.bar.primalFracture.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.primalFracture
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "primalFracture")
		end)

		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceMaelstrom"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceMaelstrom"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.echoesOfGreatSundering = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalThresholdColorPickerEchoesOfGreatSundering"], spec.colors.threshold.echoesOfGreatSundering, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.echoesOfGreatSundering
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "echoesOfGreatSundering")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
		f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.earthShockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Threshold_Option_earthShock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.earthShockThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalThresholdEarthShock"])
		f.tooltip = L["ShamanElementalThresholdEarthShockTooltip"]
		f:SetChecked(spec.thresholds.earthShock.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.earthShock.enabled = self:GetChecked()
			spec.thresholds.elementalBlast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.earthquakeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Threshold_Option_earthquake", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.earthquakeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalThresholdEarthquake"])
		f.tooltip = L["ShamanElementalThresholdEarthquakeTooltip"]
		f:SetChecked(spec.thresholds.earthquake.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.earthquake.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		yCoord = yCoord - 25
		yCoord = yCoord - 25
		yCoord = yCoord - 25
		yCoord = yCoord - 50

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 7, 1, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanHeaderEndOfAscendanceConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfAscendanceModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_EOFA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfAscendanceModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		
		if spec.endOfAscendance.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfAscendanceModeTime:SetChecked(false)
			spec.endOfAscendance.mode = "gcd"
		end)

		title = L["ShamanAscendanceGcds"]
		controls.endOfAscendanceGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfAscendance.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfAscendanceGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfAscendance.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfAscendanceModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_EOFA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfAscendanceModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		
		if spec.endOfAscendance.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfAscendanceModeTime:SetChecked(true)
			spec.endOfAscendance.mode = "time"
		end)

		title = L["ShamanAscendanceTime"]
		controls.endOfAscendanceTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfAscendance.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfAscendanceTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfAscendance.timeMax = value
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], 150)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.elemental

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
		local yCoord = 5
		local f = nil

		controls.buttons.exportButton_Shaman_Elemental_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanElementalTextColorsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.currentMaelstrom = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextCurrent"], spec.colors.text.currentMaelstrom, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.currentMaelstrom
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "currentMaelstrom")
		end)

		controls.colors.text.castingMaelstrom = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextCasting"], spec.colors.text.castingMaelstrom, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.castingMaelstrom
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "castingMaelstrom")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passiveMaelstrom = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextPassive"], spec.colors.text.passiveMaelstrom, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passiveMaelstrom
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passiveMaelstrom")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerThresholdOver"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcapMaelstrom = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerOvercap"], spec.colors.text.overcapMaelstrom, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcapMaelstrom
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcapMaelstrom")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["ShamanElementalCheckboxThresholdOverTooltip"]
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["ShamanElementalCheckboxThresholdOvercapTooltip"]
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$fsCount/$fsTime")
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

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.elemental

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.esReady = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_CB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esReady
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalAudioCheckboxEarthShock"])
		f.tooltip = L["ShamanElementalAudioCheckboxEarthShockTooltip"]
		f:SetChecked(spec.audio.esReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.esReady.enabled = self:GetChecked()
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.esReadyAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Shaman_Elemental_esReadyAudio", parent)
		controls.dropDown.esReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.esReadyAudio, oUi.dropdownWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.esReadyAudio, spec.audio.esReady.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.esReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.esReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.esReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.esReadyAudio:SetValue(newValue, newName)
			spec.audio.esReady.sound = newValue
			spec.audio.esReady.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.esReadyAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.esReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceMaelstrom"]))
		f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceMaelstrom"])
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Shaman_Elemental_overcapAudio", parent)
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
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.elemental
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Shaman_Elemental_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 7, 1, yCoord, cache)
	end

	local function ElementalConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls
		local yCoord = 0
		local f = nil
		interfaceSettingsFrame.elementalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Elemental", UIParent)
		interfaceSettingsFrame.elementalDisplayPanel.name = L["ShamanElementalFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.elementalDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.elementalDisplayPanel, "ElementalL["Shaman"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.elementalDisplayPanel)

		parent = interfaceSettingsFrame.elementalDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanElementalFull"], oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.elementalShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_elementalShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.elementalShamanEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["ShamanElementalFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.shaman.elemental)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.shaman.elemental = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.elementalShamanEnabled, TRB.Data.settings.core.enabled.shaman.elemental, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.elementalShamanEnabled, TRB.Data.settings.core.enabled.shaman.elemental, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Shaman_Elemental_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Shaman_Elemental_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab1", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Shaman_Elemental_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls

		ElementalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		ElementalConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		ElementalConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		ElementalConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		ElementalConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	
	--[[

	Enhancement Option Menus

	]]

	
	local function EnhancementConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.enhancement

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["ShamanEnhancementFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.shaman.enhancement = EnhancementLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["ShamanEnhancementFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = EnhancementLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["ShamanEnhancementFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = EnhancementLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
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
			StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = controls
	end

	local function EnhancementConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.enhancement

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.enhancement
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Enhancement_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Enhancement_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], L["ResourceMaelstromWeapon"])

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 2, yCoord, true, L["ResourceMaelstromWeapon"])

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"])

		yCoord = yCoord - 30
		controls.colors.inAscendance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendance"], spec.colors.bar.inAscendance, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inAscendance
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfAscendance = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_Checkbox_EOA", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfAscendance
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanManaCheckboxAscendanceEnd"])
		f.tooltip = L["ShamanManaCheckboxAscendanceEndTooltip"]
		f:SetChecked(spec.endOfAscendance.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfAscendance.enabled = self:GetChecked()
		end)

		controls.colors.inAscendance1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendanceEnd"], spec.colors.bar.inAscendance1GCD, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inAscendance1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance1GCD")
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], false, false)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanEnhancementMaelstromWeaponColorsHeader"], oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceMaelstromWeapon"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MaelstromWeaponCheckboxUseHighestForAll"])
		f.tooltip = L["MaelstromWeaponCheckboxUseHighestForAllTooltip"]
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)
		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanHeaderEndOfAscendanceConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfAscendanceModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_EOFA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfAscendanceModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		
		if spec.endOfAscendance.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfAscendanceModeTime:SetChecked(false)
			spec.endOfAscendance.mode = "gcd"
		end)

		title = L["ShamanAscendanceGcds"]
		controls.endOfAscendanceGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfAscendance.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfAscendanceGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfAscendance.gcdsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.endOfAscendanceModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_EOFA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfAscendanceModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		
		if spec.endOfAscendance.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfAscendanceModeTime:SetChecked(true)
			spec.endOfAscendance.mode = "time"
		end)

		title = L["ShamanAscendanceTime"]
		controls.endOfAscendanceTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfAscendance.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfAscendanceTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfAscendance.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = controls
	end

	local function EnhancementConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.enhancement

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.enhancement
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Enhancement_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Enhancement_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 2, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		yCoord = yCoord - 30
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

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)
		
		yCoord = yCoord - 25
		
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$fsCount/$fsTime")
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = controls
	end

	local function EnhancementConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.enhancement

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.enhancement
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Enhancement_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Enhancement_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = controls
	end

	local function EnhancementConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.enhancement
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.enhancement
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Shaman_Enhancement_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Enhancement_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 7, 2, yCoord, cache)
	end

	local function EnhancementConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.enhancement or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.enhancementDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Enhancement", UIParent)
		interfaceSettingsFrame.enhancementDisplayPanel.name = L["ShamanEnhancementFull"]
	---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.enhancementDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.enhancementDisplayPanel, "EnhancementL["Shaman"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.enhancementDisplayPanel)

		parent = interfaceSettingsFrame.enhancementDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanEnhancementFull"], oUi.xCoord, yCoord-5)

		controls.checkBoxes.enhancementShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_enhancementShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.enhancementShamanEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["ShamanEnhancementFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.shaman.enhancement)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.shaman.enhancement = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.enhancementShamanEnabled, TRB.Data.settings.core.enabled.shaman.enhancement, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.enhancementShamanEnabled, TRB.Data.settings.core.enabled.shaman.enhancement, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Shaman_Enhancement_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Shaman_Enhancement_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Enhancement_Tab2", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Enhancement_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Enhancement_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Enhancement_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Enhancement_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do 
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Shaman_Enhancement_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = controls

		EnhancementConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		EnhancementConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		EnhancementConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		EnhancementConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		EnhancementConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--	Restoration Option Menus

	local function RestorationConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.restoration

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.restoration
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["ShamanRestorationFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.shaman.restoration = RestorationLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["ShamanRestorationFull"]),
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
		StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["ShamanRestorationFull"]),
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
		StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetBarTextNarrowAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["ShamanRestorationFull"]),
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
			StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
	end

	local function RestorationConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Restoration_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 3, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 3, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 3, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"], "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"])

		yCoord = yCoord - 30
		controls.colors.inAscendance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendance"], spec.colors.bar.inAscendance, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inAscendance		
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfAscendance = CreateFrame("CheckButton", "TwintopsResourceBar_Shaman_Restoration_EndOfAscendance_Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfAscendance
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanManaCheckboxAscendanceEnd"])
		f.tooltip = L["ShamanManaCheckboxAscendanceEndTooltip"]
		f:SetChecked(spec.endOfAscendance.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfAscendance.enabled = self:GetChecked()
		end)
		
		controls.colors.inAscendance1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendanceEnd"], spec.colors.bar.inAscendance1GCD, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inAscendance1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance1GCD")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 3)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 3)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"], false, true)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 7, 3, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 7, 3, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 7, 3, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanHeaderEndOfAscendanceConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfAscendanceModeGCDs = CreateFrame("CheckButton", "TwintopsResourceBar_Shaman_Restoration_EndOfAscendance_Mode_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfAscendanceModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		
		if spec.endOfAscendance.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfAscendanceModeTime:SetChecked(false)
			spec.endOfAscendance.mode = "gcd"
		end)

		title = L["ShamanAscendanceGcds"]
		controls.endOfAscendanceGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfAscendance.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfAscendanceGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfAscendance.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfAscendanceModeTime = CreateFrame("CheckButton", "TwintopsResourceBar_Shaman_Restoration_EndOfAscendance_Mode_Time", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfAscendanceModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		
		if spec.endOfAscendance.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfAscendanceModeTime:SetChecked(true)
			spec.endOfAscendance.mode = "time"
		end)

		title = L["ShamanAscendanceTime"]
		controls.endOfAscendanceTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfAscendance.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfAscendanceTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfAscendance.timeMax = value
		end)
		
		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
	end

	local function RestorationConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.shaman.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 3, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 3, yCoord)

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

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$fsCount/$fsTime")
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

		local spec = TRB.Data.settings.shaman.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Shaman_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Shaman_Restoration_Innervate_Audio", parent)
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
		controls.checkBoxes.blessingOfWinterRegen = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_BlessingOfWinterMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.blessingOfWinterRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackBlessingOfWinter"])
		f.tooltip = L["HealerCheckboxTrackBlessingOfWinterTooltip"]
		f:SetChecked(spec.passiveGeneration.blessingOfWinter)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.blessingOfWinter = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackInnervate"])
		f.tooltip = L["HealerCheckboxTrackInnervateTooltip"]
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackManaTideTotem"])
		f.tooltip = L["HealerCheckboxTrackManaTideTotemTooltip"]
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
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

		local spec = TRB.Data.settings.shaman.restoration
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
		controls.buttons.exportButton_Shaman_Restoration_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Restoration_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 7, 3, yCoord, cache)
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

		interfaceSettingsFrame.restorationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Restoration", UIParent)
		interfaceSettingsFrame.restorationDisplayPanel.name = L["ShamanRestorationFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.restorationDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.restorationDisplayPanel, L["ShamanRestorationFull"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.restorationDisplayPanel)

		parent = interfaceSettingsFrame.restorationDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanRestorationFull"], oUi.xCoord, yCoord-5)
		
		controls.checkBoxes.restorationShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_restorationShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.restorationShamanEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["ShamanRestorationFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.shaman.restoration)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.shaman.restoration = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.restorationShamanEnabled, TRB.Data.settings.core.enabled.shaman.restoration, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.restorationShamanEnabled, TRB.Data.settings.core.enabled.shaman.restoration, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Shaman_Restoration_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Shaman_Restoration_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Restoration_Tab1", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Restoration_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Restoration_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Restoration_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Shaman_Restoration_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Shaman_Restoration_LayoutPanel" .. i, parent)
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
		ElementalConstructOptionsPanel(specCache.elemental)
		
		if TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			EnhancementConstructOptionsPanel(specCache.enhancement)
		end

		RestorationConstructOptionsPanel(specCache.restoration)
	end
	TRB.Options.Shaman.ConstructOptionsPanel = ConstructOptionsPanel
end