---@diagnostic disable: undefined-field
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
	local L = TRB.Localization
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame

	TRB.Options.Priest = {}
	TRB.Options.Priest.Discipline = {}
	TRB.Options.Priest.Holy = {}
	TRB.Options.Priest.Shadow = {}


	local function DisciplineLoadExtraBarTextSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				fontFace = "Fonts\\FRIZQT__.TTF",
				useDefaultFontFace = false,
				guid=TRB.Functions.String:Guid(),
				fontJustifyHorizontalName = L["PositionLeft"],
				text = "{$pwRadianceTime&$hwSerenityCharges=0}[$pwRadianceTime]",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 14,
				name = "PW Radiance 1",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = L["PowerWordRadianceCharge1"],
					yPos = 0,
					relativeToFrame = "PowerWord_Radiance_1",
				},
				fontJustifyHorizontal = "LEFT",
				useDefaultFontSize = false,
				color = "ffffffff",
				enabled = true,
			},
			{
				useDefaultFontColor = false,
				fontFace = "Fonts\\FRIZQT__.TTF",
				useDefaultFontFace = false,
				guid=TRB.Functions.String:Guid(),
				fontJustifyHorizontalName = L["PositionLeft"],
				text = "{$pwRadianceTime&$hwSerenityCharges=1}[$pwRadianceTime]",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 14,
				name = "PW Radiance 2",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName =  L["PowerWordRadianceCharge2"],
					yPos = 0,
					relativeToFrame = "PowerWord_Radiance_2",
				},
				fontJustifyHorizontal = "LEFT",
				useDefaultFontSize = false,
				color = "ffffffff",
				enabled = true,
			},
		}

		return textSettings
	end


	local function DisciplineLoadDefaultBarTextSimpleSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="$atonementCount",
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
				text="{$raptureTime}[$raptureTime]",
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
				text="{$casting}[#casting$casting + ]{$passive}[$passive + ]$mana/$manaMax $manaPercent%",
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

		local extraTextSettings = DisciplineLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end
	TRB.Options.Priest.DisciplineLoadDefaultBarTextSimpleSettings = DisciplineLoadDefaultBarTextSimpleSettings

	local function DisciplineLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="#atonement $atonementCount ($atonementMinTime)||n{$potionCooldown}[#potionOfFrozenFocus $potionCooldown] ",
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
				text="{$raptureTime}[#rapture$raptureTime#rapture]||n{$scTime}[#sc$scTime#sc]",
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

		local extraTextSettings = DisciplineLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end

	local function DisciplineLoadDefaultSettings(includeBarText)
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
				shadowfiend = {
					enabled = true, -- 8
					cooldown = false
				},
				mindbender = {
					enabled = true, -- 9
					cooldown = false
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
			endOfRapture = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			shadowfiend={
				mode="time",
				swingsMax=4,
				gcdsMax=2,
				timeMax=15.0,
				enabled=true
			},
			passiveGeneration = {
				innervate = true,
				manaTideTotem = true,
				symbolOfHope = true,
				blessingOfWinter = true
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
					surgeOfLight1="FFFCE58E",
					surgeOfLight2="FFAF9942",
					shadowCovenant="FFC4A5E2",
					rapture="FFFADA5E",
					raptureEnd="FFFF0000",
					spending="FFFFFFFF",
					passive="FF8080FF",
					surgeOfLightBorderChange1=true,
					surgeOfLightBorderChange2=true,
					shadowCovenantBorderChange=true,
					innervateBorderChange=true,
					potionOfChilledClarityBorderChange=true,
				},
				comboPoints = {
					border="FF000099",
					base="FF000099", --required for generic combo point code
					background="66000000",
					powerWordRadiance="FFFFDD22",
					powerWordRadianceEnabled = true
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
				},
				surgeOfLight={
					name = L["PriestAudioSurgeOfLight1"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"]
				},
				surgeOfLight2={
					name = L["PriestAudioSurgeOfLight2"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName = L["LSMSoundAirHorn"]
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
			settings.displayText.barText = DisciplineLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end


	local function HolyLoadExtraBarTextSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				fontFace = "Fonts\\FRIZQT__.TTF",
				useDefaultFontFace = false,
				guid=TRB.Functions.String:Guid(),
				fontJustifyHorizontalName = L["PositionLeft"],
				text = "{$hwSerenityTime&$hwSerenityCharges=0}[$hwSerenityTime]",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 14,
				name = "HW Serenity 1",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = L["HolyWordSerenityCharge1"],
					yPos = 0,
					relativeToFrame = "HolyWord_Serenity_1",
				},
				fontJustifyHorizontal = "LEFT",
				useDefaultFontSize = false,
				color = "ffffffff",
				enabled = true,
			},
			{
				enabled = true,
				fontFace = "Fonts\\FRIZQT__.TTF",
				useDefaultFontFace = false,
				guid=TRB.Functions.String:Guid(),
				fontJustifyHorizontalName = L["PositionLeft"],
				text = "{$hwSerenityTime&$hwSerenityCharges=1}[$hwSerenityTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "HW Serenity 2",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = L["HolyWordSerenityCharge2"],
					yPos = 0,
					relativeToFrame = "HolyWord_Serenity_2",
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
				text = "{$hwSanctifyTime&$hwSanctifyCharges=0}[$hwSanctifyTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "HW Sanctify 1",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = L["HolyWordSanctifyCharge1"],
					yPos = 0,
					relativeToFrame = "HolyWord_Sanctify_1",
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
				text = "{$hwSanctifyTime&$hwSanctifyCharges=1}[$hwSanctifyTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "HW Sanctify 2",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = L["HolyWordSanctifyCharge2"],
					yPos = 0,
					relativeToFrame = "HolyWord_Sanctify_2",
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
				text = "{$hwChastiseTime}[$hwChastiseTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "HW Chastise",
				position = {
					relativeToName = L["PositionCenter"],
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = L["HolyWordChastiseCharge1"],
					yPos = 0,
					relativeToFrame = "HolyWord_Chastise_1",
				},
				fontJustifyHorizontal = "LEFT",
				useDefaultFontSize = false,
				fontFaceName = "Friz Quadrata TT",
				useDefaultFontColor = false,
			}
		}

		return textSettings
	end

	local function HolyLoadDefaultBarTextSimpleSettings()
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
				text="{$apotheosisTime}[$apotheosisTime]",
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
				text="{$casting}[#casting$casting + ]{$passive}[$passive + ]$mana/$manaMax $manaPercent%",
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

		local extraTextSettings = HolyLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end
	TRB.Options.Priest.HolyLoadDefaultBarTextSimpleSettings = HolyLoadDefaultBarTextSimpleSettings

	local function HolyLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="{$hwSanctifyTime}[#hwSanctify $hwSanctifyTime][          ]    {$potionCooldown}[#potionOfFrozenFocus $potionCooldown]||n{$hwSerenityTime}[#hwSerenity $hwSerenityTime] ",
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
				text="{$apotheosisTime}[#apotheosis $apotheosisTime #apotheosis]",
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

		local extraTextSettings = HolyLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end

	local function HolyLoadDefaultSettings(includeBarText)
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
				shadowfiend = {
					enabled = true, -- 8
					cooldown = false
				},
				symbolOfHope = {
					enabled = true, -- 9
					cooldown = false,
					minimumManaPercent = 25
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
				showCasting=true,
				holyWordChastiseEnabled=false,
				holyWordSanctifyEnabled=true,
				holyWordSerenityEnabled=true
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
			endOfApotheosis = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			shadowfiend={
				mode="time",
				swingsMax=4,
				gcdsMax=2,
				timeMax=15.0,
				enabled=true
			},
			passiveGeneration = {
				innervate = true,
				manaTideTotem = true,
				symbolOfHope = true,
				blessingOfWinter = true
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
					apotheosis="FFFADA5E",
					apotheosisEnd="FFFF0000",
					holyWordChastise="FFAAFFAA",
					holyWordSanctify="FF55FF55",
					holyWordSerenity="FF00FF00",
					surgeOfLight1="FFFCE58E",
					surgeOfLight2="FFAF9942",
					resonantWords="FFAA00FF",
					lightweaver="FF00FFFF",
					spending="FFFFFFFF",
					passive="FF8080FF",
					surgeOfLightBorderChange1=true,
					surgeOfLightBorderChange2=true,
					innervateBorderChange=true,
					resonantWordsBorderChange=true,
					lightweaverBorderChange=true,
					potionOfChilledClarityBorderChange=true,
				},
				comboPoints = {
					border="FF000099",
					base="FF000099", --required for generic combo point code
					background="66000000",
					holyWordSerenity="FF00DDDD",
					holyWordSerenityEnabled = true,
					holyWordSanctify="FFFFDD22",
					holyWordSanctifyEnabled = true,
					holyWordChastise="FFFF8080",
					holyWordChastiseEnabled = true,
					completeCooldown="FF00B500",
					completeCooldownEnabled=true,
					sacredReverence="FF90FF64",
					sacredReverenceEnabled=true
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
				},
				surgeOfLight={
					name = L["PriestAudioSurgeOfLight1"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"]
				},
				surgeOfLight2={
					name = L["PriestAudioSurgeOfLight2"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName = L["LSMSoundAirHorn"]
				},
				resonantWords={
					name = L["PriestHolyAudioResonantWords"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName = L["LSMSoundAirHorn"]
				},
				lightweaver={
					name = L["PriestHolyAudioLightweaver"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName = L["LSMSoundAirHorn"]
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
			settings.displayText.barText = HolyLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function ShadowLoadDefaultBarTextSimpleSettings()
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
				text="{$vfTime}[$vfTime]",
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$insanity%",
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
	TRB.Options.Priest.ShadowLoadDefaultBarTextSimpleSettings = ShadowLoadDefaultBarTextSimpleSettings

	local function ShadowLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="#swp $swpCount   #dp $dpCount   $haste% ($gcd)||n#vt $vtCount   {$cttvEquipped}[#loi $ecttvCount][       ]   {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize = 13,
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
				guid=TRB.Functions.String:Guid(),
				name = L["PositionMiddle"],
				text="{$mdTime}[#mDev $mdTime #mDev{$vfTime||$mfiTime}[||n]]{$mfiTime}[#mfi $mfiTime #mfi{$vfTime}[||n]]{$vfTime}[$vfTime]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = L["PositionCenter"],
				fontSize = 13,
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
				guid=TRB.Functions.String:Guid(),
				name = L["PositionRight"],
				text="{$casting}[#casting$casting+]{$asCount}[#as$asInsanity+]{$mbInsanity}[#mindbender$mbInsanity+]{$loiInsanity}[#loi$loiInsanity+]$insanity",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize = 22,
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

	local function ShadowLoadDefaultBarTextNarrowAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="#swp $swpCount   $haste% ($gcd)||n#vt $vtCount   {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize = 13,
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
				name = L["PositionMiddle"],
				guid=TRB.Functions.String:Guid(),
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				text="{$mdTime}[#mDev $mdTime #mDev{$vfTime}[||n]]{$vfTime}[$vfTime]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = L["PositionCenter"],
				fontSize = 13,
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
				text="{$casting}[#casting$casting+]{$passive}[$passive+]$insanity",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize = 22,
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

	local function ShadowLoadDefaultSettings(includeBarText)
		local settings = {
			hasteApproachingThreshold=135,
			hasteThreshold=140,
			hastePrecision=2,
			resourcePrecision=0,
			auspiciousSpiritsTracker=true,
			voidTendrilTracker=true,
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
				devouringPlagueThresholdOnlyOverShow = false,
				devouringPlague = { -- 1
					enabled = true,
				},
				devouringPlague2 = { -- 2
					enabled = true,
				},
				devouringPlague3 = { -- 3
					enabled = true,
				}
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
			mindbender={ --TODO: Rename this shadowfiend to be consistent with Discipline and Holy
				mode="gcd",
				swingsMax=4,
				gcdsMax=2,
				timeMax=3.0,
				enabled=true
			},
			endOfVoidform = {
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
			deathsTorment={
				stacks = 9
			},
			colors={
				text={
					currentInsanity="FFC2A3E0",
					castingInsanity="FFFFFFFF",
					passiveInsanity="FFDF00FF",
					overcapInsanity="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
					hasteBelow="FFFFFFFF",
					hasteApproaching="FFFFFF00",
					hasteAbove="FF00FF00",
					dots={
						enabled=true,
						up="FFFFFFFF",
						down="FFFF0000",
						pandemic="FFFFFF00"
					}
				},
				bar={
					border="FF431863",
					borderOvercap="FFFF0000",
					borderMindFlayInsanity="FF00FF00",
					deathspeaker = {
						color = "FFFF9900",
						enabled = true
					},
					background="66000000",
					base="FF763BAF",
					devouringPlagueUsable="FF5C2F89",
					devouringPlagueUsableCasting="FFFFFFFF",
					instantMindBlast={
						color = "FFC2A3E0",
						enabled = true
					},
					deathsTorment = {
						color = "FFFCACAC",
						enabled = true
					},
					deathsTormentMax = {
						color = "FFFF4040",
						enabled = true
					},
					mindDevourer = {
						color = "FF00C3FF",
						enabled = true,
					},
					inVoidform="FF431863",
					inVoidform1GCD="FFFF0000",
					casting="FFFFFFFF",
					passive="FFDF00FF",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true,
					mindFlayInsanityBorderChange=true
				},
				threshold={
					under="FFFFFFFF",
					over="FF00FF00",
					mindbender="FFFF11FF",
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
				overcap={
					name = L["Overcap"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName = L["LSMSoundAirHorn"]
				},
				mdProc={
					name = L["PriestShadowAudioMindDevourer"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"]
				},
				dpReady={
					name = L["PriestShadowAudioDevouringPlague"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"]
				},
				deathspeaker={
					name = L["PriestShadowAudioDeathspeaker"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"]
				},
				deathsTorment={
					name = L["PriestShadowAudioDeathsTorment"],
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"]
				},
				deathsTormentMax={
					name = L["PriestShadowAudioDeathsTormentMax"],
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
			settings.displayText.barText = ShadowLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function LoadDefaultSettings(includeBarText)
		local settings = TRB.Options.LoadDefaultSettings()
		settings.priest.discipline = DisciplineLoadDefaultSettings(includeBarText)
		settings.priest.holy = HolyLoadDefaultSettings(includeBarText)
		settings.priest.shadow = ShadowLoadDefaultSettings(includeBarText)
		return settings
	end
	TRB.Options.Priest.LoadDefaultSettings = LoadDefaultSettings


	--[[

	Discipline Option Menus

	]]


	local function DisciplineConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.discipline
		local yCoord = 5

		local spec = TRB.Data.settings.priest.discipline

		StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["PriestDisciplineFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.priest.discipline = DisciplineLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["PriestDisciplineFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = DisciplineLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["PriestDisciplineFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = DisciplineLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Priest_Discipline_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""

		controls.buttons.exportButton_Priest_Discipline_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], L["PriestDisciplinePowerWords"])

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 1, yCoord, true)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], "notFull", false)

		yCoord = yCoord - 90
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])
		

		yCoord = yCoord - 30
		controls.colors.inRapture = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPickerRapture"], spec.colors.bar.rapture, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inRapture
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "rapture")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfRapture = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Rapture", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfRapture
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxRaptureEnd"])
		f.tooltip = L["PriestDisciplineCheckboxRaptureEndTooltip"]
		f:SetChecked(spec.endOfRapture.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfRapture.enabled = self:GetChecked()
		end)

		controls.colors.inRaptureEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPickerRaptureEnd"], spec.colors.bar.raptureEnd, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inRaptureEnd
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "raptureEnd")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], false, true)
		
		yCoord = yCoord - 30
		controls.checkBoxes.shadowCovenantBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_shadowCovenantEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowCovenantBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxShadowCovenant"])
		f.tooltip = L["PriestDisciplineCheckboxShadowCovenantTooltip"]
		f:SetChecked(spec.colors.bar.shadowCovenantBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.shadowCovenantBorderChange = self:GetChecked()
			TRB.Functions.BarText:CreateBarTextFrames(spec)
		end)
		
		controls.colors.shadowCovenant = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPickerShadowCovenant"], spec.colors.bar.shadowCovenant, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.shadowCovenant
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "shadowCovenant")
		end)

		controls.colors.surgeOfLight1 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight1"], spec.colors.bar.surgeOfLight1, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.surgeOfLight1
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight1")
		end)
						
		controls.colors.surgeOfLight2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight2"], spec.colors.bar.surgeOfLight2, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.surgeOfLight2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight2")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight1BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Threshold_Option_surgeOfLight1BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight1BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestCheckboxSurgeOfLight1"])
		f.tooltip = L["PriestCheckboxSurgeOfLight1Tooltip"]
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange1)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange1 = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Threshold_Option_surgeOfLight2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestCheckboxSurgeOfLight2"])
		f.tooltip = L["PriestCheckboxSurgeOfLight2Tooltip"]
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange2)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange2 = self:GetChecked()
		end)
		

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestDisciplinePowerWordColorsHeader"], oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSerenityComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_powerWordRadianceComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSerenityComboPointEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxEnablePowerWordRadiance"])
		f.tooltip = L["PriestDisciplineCheckboxEnablePowerWordRadianceTooltip"]
		f:SetChecked(spec.colors.comboPoints.powerWordRadianceEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.comboPoints.powerWordRadianceEnabled = self:GetChecked()
			TRB.Functions.BarText:CreateBarTextFrames(spec)
		end)

		controls.colors.comboPoints.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordRadiance"], spec.colors.comboPoints.powerWordRadiance, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.holyWordSerenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "powerWordRadiance")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordUnfilled"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 5, 1, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 1, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 5, 1, yCoord)
		
		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestDisciplineHeaderEndOfRaptureConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfRaptureModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Rapture_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfRaptureModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxRaptureGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfRapture.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfRaptureModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfRaptureModeTime:SetChecked(false)
			spec.endOfRapture.mode = "gcd"
		end)

		title = L["PriestDisciplineRaptureGcds"]
		controls.endOfRaptureGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfRapture.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfRaptureGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfRapture.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfRaptureModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Rapture_Time", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfRaptureModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxRaptureTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfRapture.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfRaptureModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfRaptureModeTime:SetChecked(true)
			spec.endOfRapture.mode = "time"
		end)

		title = L["PriestDisciplineRaptureTime"]
		controls.endOfRaptureTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfRapture.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfRaptureTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfRapture.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""

		controls.buttons.exportButton_Priest_Discipline_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 1, yCoord)

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
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$swpCount/$swpTime")
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""

		controls.buttons.exportButton_Priest_Discipline_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Discipline_Innervate_Audio", parent)
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
		controls.checkBoxes.surgeOfLight = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_SurgeOfLightCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestAudioCheckboxSurgeOfLight1"])
		f.tooltip = L["PriestAudioCheckboxSurgeOfLight1Tooltip"]
		f:SetChecked(spec.audio.surgeOfLight.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight.enabled = self:GetChecked()

			if spec.audio.surgeOfLight.enabled then
				PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLightAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Discipline_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLightAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLightAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, spec.audio.surgeOfLight.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLightAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLightAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.surgeOfLight.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLightAudio:SetValue(newValue, newName)
			spec.audio.surgeOfLight.sound = newValue
			spec.audio.surgeOfLight.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.surgeOfLight2 = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_SurgeOfLight2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestAudioCheckboxSurgeOfLight2"])
		f.tooltip = L["PriestAudioCheckboxSurgeOfLight2Tooltip"]
		f:SetChecked(spec.audio.surgeOfLight2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight2.enabled = self:GetChecked()

			if spec.audio.surgeOfLight2.enabled then
				PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLight2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Discipline_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLight2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLight2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, spec.audio.surgeOfLight2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLight2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLight2Audio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.surgeOfLight2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLight2Audio:SetValue(newValue, newName)
			spec.audio.surgeOfLight2.sound = newValue
			spec.audio.surgeOfLight2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerPassiveExternalManaGenerationTrackingHeader"], oUi.xCoord, yCoord)
				
		yCoord = yCoord - 30
		controls.checkBoxes.blessingOfWinterRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_BlessingOfWinterMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.blessingOfWinterRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackBlessingOfWinter"])
		f.tooltip = L["HealerCheckboxTrackBlessingOfWinterTooltip"]
		f:SetChecked(spec.passiveGeneration.blessingOfWinter)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.blessingOfWinter = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackInnervate"])
		f.tooltip = L["HealerCheckboxTrackInnervateTooltip"]
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackManaTideTotem"])
		f.tooltip = L["HealerCheckboxTrackManaTideTotemTooltip"]
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackSymbolOfHope"])
		f.tooltip = L["HealerCheckboxTrackSymbolOfHopeTooltip"]
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHeaderShadowfiendMindbenderTracking"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiend = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Shadowfiend_Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowfiend
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxTrackShadowfiendManaGain"])
		f.tooltip = L["PriestDisciplineCheckboxTrackShadowfiendManaGainTooltip"]
		f:SetChecked(spec.shadowfiend.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.shadowfiend.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiendModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ShadowfiendMode_GCDs", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxShadowfiendGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.shadowfiend.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(true)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "gcd"
		end)

		title = L["PriestDisciplineShadowfiendGcds"]
		controls.shadowfiendGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.gcdsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeSwings = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ShadowfiendMode_Swings", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeSwings
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxShadowfiendSwings"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.shadowfiend.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(true)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "swing"
		end)

		title = L["PriestDisciplineShadowfiendSwings"]
		controls.shadowfiendSwings = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.swingsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendSwings:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.swingsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ShadowfiendMode_Time", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxShadowfiendTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.shadowfiend.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(true)
			spec.shadowfiend.mode = "time"
		end)

		title = L["PriestDisciplineShadowfiendTime"]
		controls.shadowfiendTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.shadowfiend.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.shadowfiend.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.discipline
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
		controls.buttons.exportButton_Priest_Discipline_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 5, 1, yCoord, cache)
	end

	local function DisciplineConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.discipline or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.disciplineDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Discipline", UIParent)
		interfaceSettingsFrame.disciplineDisplayPanel.name = L["PriestDisciplineFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.disciplineDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.disciplineDisplayPanel, "DisciplineL["Priest"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.disciplineDisplayPanel)

		parent = interfaceSettingsFrame.disciplineDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestDisciplineFull"], oUi.xCoord, yCoord-5)
		
		controls.checkBoxes.disciplinePriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.disciplinePriestEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["PriestDisciplineFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.priest.discipline)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.priest.discipline = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.disciplinePriestEnabled, TRB.Data.settings.core.enabled.priest.discipline, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.disciplinePriestEnabled, TRB.Data.settings.core.enabled.priest.discipline, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Priest_Discipline_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Priest_Discipline_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab1", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Priest_Discipline_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls

		DisciplineConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		DisciplineConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		DisciplineConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		DisciplineConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		DisciplineConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end




	--[[

	Holy Option Menus

	]]

	local function HolyConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.holy
		local yCoord = 5

		local spec = TRB.Data.settings.priest.holy

		StaticPopupDialogs["TwintopResourceBar_Priest_Holy_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["PriestHolyFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.priest.holy = HolyLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["PriestHolyFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = HolyLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["PriestHolyFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = HolyLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Priest_Holy_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""

		controls.buttons.exportButton_Priest_Holy_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], L["PriestHolyHolyWords"])

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 2, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], "notFull", false)

		yCoord = yCoord - 90
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])
		
		yCoord = yCoord - 30
		controls.checkBoxes.holyWordChastiseEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordChastiseEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordChastiseEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordChastise"])
		f.tooltip = L["PriestHolyCheckboxHolyWordChastiseTooltip"]
		f:SetChecked(spec.bar.holyWordChastiseEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.holyWordChastiseEnabled = self:GetChecked()
		end)

		controls.colors.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordChastise"], spec.colors.bar.holyWordChastise, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.holyWordChastise
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "holyWordChastise")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSanctifyEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSanctifyEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSanctifyEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordSanctify"])
		f.tooltip = L["PriestHolyCheckboxHolyWordSanctifyTooltip"]
		f:SetChecked(spec.bar.holyWordSanctifyEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.holyWordSanctifyEnabled = self:GetChecked()
		end)

		controls.colors.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSanctify"], spec.colors.bar.holyWordSanctify, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.holyWordSanctify
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "holyWordSanctify")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSerenityEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSerenityEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSerenityEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordSerenity"])
		f.tooltip = L["PriestHolyCheckboxHolyWordSerenityTooltip"]
		f:SetChecked(spec.bar.holyWordSerenityEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.holyWordSerenityEnabled = self:GetChecked()
		end)

		controls.colors.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSerenity"], spec.colors.bar.holyWordSerenity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.holyWordSerenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "holyWordSerenity")
		end)

		yCoord = yCoord - 30
		controls.colors.inApotheosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerApotheosis"], spec.colors.bar.apotheosis, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inApotheosis
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "apotheosis")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfApotheosis = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfApotheosis
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosisEnd"])
		f.tooltip = L["PriestHolyCheckboxApotheosisEndTooltip"]
		f:SetChecked(spec.endOfApotheosis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfApotheosis.enabled = self:GetChecked()
		end)

		controls.colors.inApotheosisEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerApotheosisEnd"], spec.colors.bar.apotheosisEnd, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inApotheosisEnd
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "apotheosisEnd")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], false, true)

		controls.colors.surgeOfLight1 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight1"], spec.colors.bar.surgeOfLight1, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.surgeOfLight1
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight1")
		end)
						
		controls.colors.surgeOfLight2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight2"], spec.colors.bar.surgeOfLight2, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.surgeOfLight2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight2")
		end)

		controls.colors.resonantWords = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerResonantWords"], spec.colors.bar.resonantWords, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.resonantWords
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "resonantWords")
		end)

		controls.colors.lightweaver = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerLightweaver"], spec.colors.bar.lightweaver, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.lightweaver
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "lightweaver")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight1BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_surgeOfLight1BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight1BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestCheckboxSurgeOfLight1"])
		f.tooltip = L["PriestCheckboxSurgeOfLight1Tooltip"]
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange1)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange1 = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_surgeOfLight2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestCheckboxSurgeOfLight2"])
		f.tooltip = L["PriestCheckboxSurgeOfLight2Tooltip"]
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange2)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange2 = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.resonantWordsBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_resonantWordsBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.resonantWordsBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxResonantWords"])
		f.tooltip = L["PriestHolyCheckboxResonantWordsTooltip"]
		f:SetChecked(spec.colors.bar.resonantWordsBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.resonantWordsBorderChange = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.lightweaverBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_lightweaverBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lightweaverBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxLightweaver"])
		f.tooltip = L["PriestHolyCheckboxLightweaverTooltip"]
		f:SetChecked(spec.colors.bar.lightweaverBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.lightweaverBorderChange = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHolyHolyWordColorsHeader"], oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSerenityComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSerenityComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSerenityComboPointEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxEnableHolyWordSerenity"])
		f.tooltip = L["PriestHolyCheckboxEnableHolyWordSerenityTooltip"]
		f:SetChecked(spec.colors.comboPoints.holyWordSerenityEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.comboPoints.holyWordSerenityEnabled = self:GetChecked()
			TRB.Functions.BarText:CreateBarTextFrames(spec)
		end)

		controls.colors.comboPoints.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSerenity"], spec.colors.comboPoints.holyWordSerenity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.holyWordSerenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "holyWordSerenity")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSanctifyComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSanctifyComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSanctifyComboPointEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxEnableHolyWordSanctify"])
		f.tooltip = L["PriestHolyCheckboxEnableHolyWordSanctifyTooltip"]
		f:SetChecked(spec.colors.comboPoints.holyWordSanctifyEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.comboPoints.holyWordSanctifyEnabled = self:GetChecked()
			TRB.Functions.BarText:CreateBarTextFrames(spec)
		end)

		controls.colors.comboPoints.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSanctify"], spec.colors.comboPoints.holyWordSanctify, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.holyWordSanctify
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "holyWordSanctify")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.holyWordChastiseComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordChastiseComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordChastiseComboPointEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxEnableHolyWordChastise"])
		f.tooltip = L["PriestHolyCheckboxEnableHolyWordChastiseTooltip"]
		f:SetChecked(spec.colors.comboPoints.holyWordChastiseEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.comboPoints.holyWordChastiseEnabled = self:GetChecked()
			TRB.Functions.BarText:CreateBarTextFrames(spec)
		end)

		controls.colors.comboPoints.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordChastise"], spec.colors.comboPoints.holyWordChastise, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.holyWordChastise
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "holyWordChastise")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.completeCooldownEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_completeCooldownEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.completeCooldownEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxCompleteHolyWordCooldown"])
		f.tooltip = L["PriestHolyCheckboxCompleteHolyWordCooldownTooltip"]
		f:SetChecked(spec.colors.comboPoints.completeCooldownEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.comboPoints.completeCooldownEnabled = self:GetChecked()
		end)

		controls.colors.comboPoints.completeCooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerCompleteHolyWordCooldown"], spec.colors.comboPoints.completeCooldown, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.completeCooldown
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "sacredReverence")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sacredReverenceEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_sacredReverenceEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sacredReverenceEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxSacredReverence"])
		f.tooltip = L["PriestHolyCheckboxSacredReverenceTooltip"]
		f:SetChecked(spec.colors.comboPoints.sacredReverenceEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.comboPoints.sacredReverenceEnabled = self:GetChecked()
		end)

		controls.colors.comboPoints.sacredReverence = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerSacredReverence"], spec.colors.comboPoints.sacredReverence, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.sacredReverence
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "sacredReverence")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorHolyWordBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorHolyWordUnfilled"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 5, 2, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 5, 2, yCoord)
		
		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHolyHeaderEndOfApotheosisConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfApotheosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfApotheosisModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosisGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfApotheosis.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfApotheosisModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfApotheosisModeTime:SetChecked(false)
			spec.endOfApotheosis.mode = "gcd"
		end)

		title = L["PriestHolyApotheosisGcds"]
		controls.endOfApotheosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfApotheosis.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfApotheosisGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfApotheosis.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfApotheosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfApotheosisModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosisTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfApotheosis.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfApotheosisModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfApotheosisModeTime:SetChecked(true)
			spec.endOfApotheosis.mode = "time"
		end)

		title = L["PriestHolyApotheosisTime"]
		controls.endOfApotheosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfApotheosis.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfApotheosisTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfApotheosis.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""

		controls.buttons.exportButton_Priest_Holy_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 2, yCoord)

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
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$swpCount/$swpTime")
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""

		controls.buttons.exportButton_Priest_Holy_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_Innervate_Audio", parent)
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
		controls.checkBoxes.surgeOfLight = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_SurgeOfLightCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestAudioCheckboxSurgeOfLight1"])
		f.tooltip = L["PriestAudioCheckboxSurgeOfLight1Tooltip"]
		f:SetChecked(spec.audio.surgeOfLight.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight.enabled = self:GetChecked()

			if spec.audio.surgeOfLight.enabled then
				PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLightAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLightAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLightAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, spec.audio.surgeOfLight.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLightAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLightAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.surgeOfLight.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLightAudio:SetValue(newValue, newName)
			spec.audio.surgeOfLight.sound = newValue
			spec.audio.surgeOfLight.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.surgeOfLight2 = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_SurgeOfLight2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestAudioCheckboxSurgeOfLight2"])
		f.tooltip = L["PriestAudioCheckboxSurgeOfLight2Tooltip"]
		f:SetChecked(spec.audio.surgeOfLight2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight2.enabled = self:GetChecked()

			if spec.audio.surgeOfLight2.enabled then
				PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLight2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLight2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLight2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, spec.audio.surgeOfLight2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLight2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLight2Audio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.surgeOfLight2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLight2Audio:SetValue(newValue, newName)
			spec.audio.surgeOfLight2.sound = newValue
			spec.audio.surgeOfLight2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		yCoord = yCoord - 60
		controls.checkBoxes.resonantWordsAudioCB = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_resonantWords", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.resonantWordsAudioCB
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyAudioCheckboxResonantWords"])
		f.tooltip = L["PriestHolyAudioCheckboxResonantWordsTooltip"]
		f:SetChecked(spec.audio.resonantWords.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.resonantWords.enabled = self:GetChecked()

			if spec.audio.resonantWords.enabled then
				PlaySoundFile(spec.audio.resonantWords.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resonantWordsAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_resonantWordsAudio", parent)
		controls.dropDown.resonantWordsAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.resonantWordsAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.resonantWordsAudio, spec.audio.resonantWords.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.resonantWordsAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.resonantWordsAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.resonantWords.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.resonantWordsAudio:SetValue(newValue, newName)
			spec.audio.resonantWords.sound = newValue
			spec.audio.resonantWords.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.resonantWordsAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.resonantWords.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		yCoord = yCoord - 60
		controls.checkBoxes.lightweaverAudioCB = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_lightweaver", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lightweaverAudioCB
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyAudioCheckboxLightweaver"])
		f.tooltip = L["PriestHolyAudioCheckboxLightweaverTooltip"]
		f:SetChecked(spec.audio.lightweaver.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.lightweaver.enabled = self:GetChecked()

			if spec.audio.lightweaver.enabled then
				PlaySoundFile(spec.audio.lightweaver.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.lightweaverAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_lightweaverAudio", parent)
		controls.dropDown.lightweaverAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.lightweaverAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.lightweaverAudio, spec.audio.lightweaver.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.lightweaverAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.lightweaverAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.lightweaver.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.lightweaverAudio:SetValue(newValue, newName)
			spec.audio.lightweaver.sound = newValue
			spec.audio.lightweaver.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.lightweaverAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.lightweaver.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerPassiveExternalManaGenerationTrackingHeader"], oUi.xCoord, yCoord)
						
		yCoord = yCoord - 30
		controls.checkBoxes.blessingOfWinterRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_BlessingOfWinterMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.blessingOfWinterRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackBlessingOfWinter"])
		f.tooltip = L["HealerCheckboxTrackBlessingOfWinterTooltip"]
		f:SetChecked(spec.passiveGeneration.blessingOfWinter)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.blessingOfWinter = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackInnervate"])
		f.tooltip = L["HealerCheckboxTrackInnervateTooltip"]
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackManaTideTotem"])
		f.tooltip = L["HealerCheckboxTrackManaTideTotemTooltip"]
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxTrackSymbolOfHope"])
		f.tooltip = L["PriestHolyCheckboxTrackSymbolOfHopeTooltip"]
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHeaderShadowfiendTracking"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiend = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Shadowfiend_Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowfiend
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxTrackShadowfiendManaGain"])
		f.tooltip = L["PriestHolyCheckboxTrackShadowfiendManaGainTooltip"]
		f:SetChecked(spec.shadowfiend.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.shadowfiend.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiendModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ShadowfiendMode_GCDs", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxShadowfiendGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.shadowfiend.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(true)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "gcd"
		end)

		title = L["PriestHolyShadowfiendGcds"]
		controls.shadowfiendGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.gcdsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeSwings = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ShadowfiendMode_Swings", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeSwings
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxShadowfiendSwings"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.shadowfiend.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(true)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "swing"
		end)

		title = L["PriestHolyShadowfiendSwings"]
		controls.shadowfiendSwings = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.swingsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendSwings:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.swingsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ShadowfiendMode_Time", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxShadowfiendTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.shadowfiend.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(true)
			spec.shadowfiend.mode = "time"
		end)

		title = L["PriestHolyShadowfiendTime"]
		controls.shadowfiendTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.shadowfiend.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.shadowfiend.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.holy
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
		controls.buttons.exportButton_Priest_Holy_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 5, 2, yCoord, cache)
	end

	local function HolyConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.holy or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.holyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Holy", UIParent)
		interfaceSettingsFrame.holyDisplayPanel.name = L["PriestHolyFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.holyDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.holyDisplayPanel, "HolyL["Priest"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.holyDisplayPanel)

		parent = interfaceSettingsFrame.holyDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHolyFull"], oUi.xCoord, yCoord-5)
		
		controls.checkBoxes.holyPriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyPriestEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyPriestEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["PriestHolyFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.priest.holy)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.priest.holy = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.holyPriestEnabled, TRB.Data.settings.core.enabled.priest.holy, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.holyPriestEnabled, TRB.Data.settings.core.enabled.priest.holy, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Priest_Holy_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Priest_Holy_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab1", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Priest_Holy_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls

		HolyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		HolyConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		HolyConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		HolyConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		HolyConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end



	--[[

	Shadow Option Menus

	]]

	local function ShadowConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.shadow
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["PriestShadowFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.priest.shadow = ShadowLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["PriestShadowFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ShadowLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["PriestShadowFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ShadowLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextNarrowAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["PriestShadowFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ShadowLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextSimple")
		end)

		yCoord = yCoord - 40
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextNarrowAdvanced")
		end)

		yCoord = yCoord - 40
		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Priest_Shadow_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 3, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 3, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], "notEmpty", true, L["PriestShadowDevouringPlague"], L["PriestShadowDevouringPlagueAbbreviation"])

		yCoord = yCoord - 90
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

		yCoord = yCoord - 30
		controls.colors.inVoidform = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerVoidform"], spec.colors.bar.inVoidform, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inVoidform		
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inVoidform")
		end)

		yCoord = yCoord - 30
		controls.colors.inVoidform1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerVoidformEnd"], spec.colors.bar.inVoidform1GCD, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inVoidform1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inVoidform1GCD")
		end)

		controls.checkBoxes.endOfVoidform = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Bar_Option_vfDaColorChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfVoidform
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxVoidformEnd"])
		f.tooltip = L["PriestShadowCheckboxVoidformEndTooltip"]
		f:SetChecked(spec.endOfVoidform.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfVoidform.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.colors.devouringPlagueUsable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerDevouringPlague"], spec.colors.bar.devouringPlagueUsable, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.devouringPlagueUsable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "devouringPlagueUsable")
		end)

		yCoord = yCoord - 30
		controls.colors.instantMindBlast = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerInstantMindBlast"], spec.colors.bar.instantMindBlast.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.instantMindBlast
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "instantMindBlast")
		end)

		controls.checkBoxes.instantMindBlast = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Checkbox_InstantMindBlast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.instantMindBlast
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxInstantMindBlast"])
		f.tooltip = L["PriestShadowCheckboxInstantMindBlastTooltip"]
		f:SetChecked(spec.colors.bar.instantMindBlast.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.instantMindBlast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerCasting"], spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 3)
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
		f.tooltip = L["ShowCastingBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.colors.devouringPlagueUsableCasting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerCastingDevouringPlagueReady"], spec.colors.bar.devouringPlagueUsableCasting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.devouringPlagueUsableCasting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "devouringPlagueUsableCasting")
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 3)
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
		f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], true, false)
		
		yCoord = yCoord - 30
		controls.checkBoxes.mindFlayInsanityBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_mindFlayInsanityBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindFlayInsanityBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mind Flay: Insanity / Mind Spike: Insanity")
		f.tooltip = "This will change the bar border color when you are able to cast Mind Flay: Insanity / Mind Spike: Insanity"
		f:SetChecked(spec.colors.bar.mindFlayInsanityBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.mindFlayInsanityBorderChange = self:GetChecked()
		end)

		controls.colors.borderMindFlayInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you can channel Mind Flay: Insanity or Mind Spike: Insanity", spec.colors.bar.borderMindFlayInsanity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderMindFlayInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderMindFlayInsanity")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.deathspeakerBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_deathspeakerBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathspeakerBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxDeathspeaker"])
		f.tooltip = L["PriestShadowCheckboxDeathspeakerTooltip"]
		f:SetChecked(spec.colors.bar.deathspeaker.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.deathspeaker.enabled = self:GetChecked()
		end)

		controls.colors.deathspeaker = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerDeathspeaker"], spec.colors.bar.deathspeaker.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.deathspeaker
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "deathspeaker")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.mindDevourer = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_mindDevourerProc", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindDevourer
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxMindDevourer"])
		f.tooltip = L["PriestShadowCheckboxMindDevourerTooltip"]
		f:SetChecked(spec.colors.bar.mindDevourer.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.mindDevourer.enabled = self:GetChecked()
		end)

		controls.colors.mindDevourer = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerMindDevourer"], spec.colors.bar.mindDevourer.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.mindDevourer
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "mindDevourer")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.deathsTormentBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_deathsTormentBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathsTormentBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxDeathsTorment"])
		f.tooltip = L["PriestShadowCheckboxDeathsTormentTooltip"]
		f:SetChecked(spec.colors.bar.deathsTorment.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.deathsTorment.enabled = self:GetChecked()
		end)

		controls.colors.deathsTorment = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerDeathsTorment"], spec.colors.bar.deathsTorment.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.deathsTorment
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "deathsTorment")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.deathsTormentMaxBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_deathsTormentMaxBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathsTormentMaxBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxDeathsTormentMax"])
		f.tooltip = L["PriestShadowCheckboxDeathsTormentMaxTooltip"]
		f:SetChecked(spec.colors.bar.deathsTormentMax.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.deathsTormentMax.enabled = self:GetChecked()
		end)

		controls.colors.deathsTormentMax = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerDeathsTormentMax"], spec.colors.bar.deathsTormentMax.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.deathsTormentMax
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "deathsTormentMax")
		end)

		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceInsanity"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceInsanity"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.mindbender = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowThresholdShadowfiend"], spec.colors.threshold.mindbender, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.mindbender
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "mindbender")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
		f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.dpThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlague", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdDevouringPlague"])
		f.tooltip = L["PriestShadowThresholdDevouringPlagueTooltip"]
		f:SetChecked(spec.thresholds.devouringPlague.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlague.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.dpThreshold2Show = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlague2", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThreshold2Show
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdDevouringPlague2x"])
		f.tooltip = L["PriestShadowThresholdDevouringPlague2xTooltip"]
		f:SetChecked(spec.thresholds.devouringPlague2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlague2.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.dpThreshold3Show = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlague3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThreshold3Show
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdDevouringPlague3x"])
		f.tooltip = L["PriestShadowThresholdDevouringPlague3xTooltip"]
		f:SetChecked(spec.thresholds.devouringPlague3.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlague3.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.dpThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlagueOnlyOver", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThresholdOnlyOverShow
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdCheckboxOnlyCurrentNext"])
		f.tooltip = L["PriestShadowThresholdCheckboxOnlyCurrentNextTooltip"]
		f:SetChecked(spec.thresholds.devouringPlagueThresholdOnlyOverShow)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlagueThresholdOnlyOverShow = self:GetChecked()
		end)

		yCoord = yCoord - 25
		yCoord = yCoord - 25
		yCoord = yCoord - 50

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 3, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowHeaderEndOfVoidformConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfVoidformModeGCDs = CreateFrame("CheckButton", "TRB_EOFV_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfVoidformModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxVoidformGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfVoidform.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfVoidformModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfVoidformModeTime:SetChecked(false)
			spec.endOfVoidform.mode = "gcd"
		end)

		title = L["PriestShadowVoidformGcds"]
		controls.endOfVoidformGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfVoidform.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfVoidformGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfVoidform.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfVoidformModeTime = CreateFrame("CheckButton", "TRB_EOFV_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfVoidformModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxVoidformTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfVoidform.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfVoidformModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfVoidformModeTime:SetChecked(true)
			spec.endOfVoidform.mode = "time"
		end)

		title = L["PriestShadowVoidformTime"]
		controls.endOfVoidformTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfVoidform.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfVoidformTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfVoidform.timeMax = value
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], 150)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Priest_Shadow_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 3, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 3, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowTextColorsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.currentInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextCurrent"], spec.colors.text.currentInsanity, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.currentInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "currentInsanity")
		end)

		controls.colors.text.castingInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextCasting"], spec.colors.text.castingInsanity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.castingInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "castingInsanity")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passiveInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextPassive"], spec.colors.text.passiveInsanity, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passiveInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passiveInsanity")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerThresholdOver"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcapInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerOvercap"], spec.colors.text.overcapInsanity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcapInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcapInsanity")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["PriestShadowCheckboxThresholdOverTooltip"]
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["PriestShadowCheckboxThresholdOvercapTooltip"]
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$swpCount/$swpTime, $vtCount/$vtTime")
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
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowHeaderHasteThreshold"], oUi.xCoord, yCoord)

		yCoord = yCoord - 50
		title = L["PriestShadowHasteLowToMedium"]
		controls.hasteApproachingThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 500, spec.hasteApproachingThreshold, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value > spec.hasteThreshold then
				value = spec.hasteThreshold
			end

			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.hasteApproachingThreshold = value
		end)

		controls.colors.text.hasteBelow = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerHasteLow"], spec.colors.text.hasteBelow,
													250, 25, oUi.xCoord2, yCoord+10)
		f = controls.colors.text.hasteBelow
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "hasteBelow")
		end)

		controls.colors.text.hasteApproaching = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerHasteMedium"], spec.colors.text.hasteApproaching,
													250, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.text.hasteApproaching
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "hasteApproaching")
		end)

		controls.colors.text.hasteAbove = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerHasteHigh"], spec.colors.text.hasteAbove,
													250, 25, oUi.xCoord2, yCoord-70)
		f = controls.colors.text.hasteAbove
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "hasteAbove")
		end)

		yCoord = yCoord - 60
		title = L["PriestShadowHasteMediumToHigh"]
		controls.hasteThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 500, spec.hasteThreshold, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value < spec.hasteApproachingThreshold then
				value = spec.hasteApproachingThreshold
			end

			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.hasteThreshold = value
		end)
		yCoord = yCoord - 40
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

		title = L["PriestShadowInsanityDecimalPrecision"]
		controls.resourcePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, spec.resourcePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.resourcePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.resourcePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Priest_Shadow_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 5, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.dpReady = CreateFrame("CheckButton", "TwintopResourceBar_CB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpReady
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowAudioCheckboxDevouringPlague"])
		f.tooltip = L["PriestShadowAudioCheckboxDevouringPlagueTooltip"]
		f:SetChecked(spec.audio.dpReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.dpReady.enabled = self:GetChecked()

			if spec.audio.dpReady.enabled then
				PlaySoundFile(spec.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.dpReadyAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_dpReadyAudio", parent)
		controls.dropDown.dpReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.dpReadyAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, spec.audio.dpReady.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.dpReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.dpReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.dpReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.dpReadyAudio:SetValue(newValue, newName)
			spec.audio.dpReady.sound = newValue
			spec.audio.dpReady.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.mdProc = CreateFrame("CheckButton", "TwintopResourceBar_CB3_MD_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mdProc
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowAudioCheckboxMindDevourer"])
		f.tooltip = L["PriestShadowAudioCheckboxMindDevourerTooltip"]
		f:SetChecked(spec.audio.mdProc.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.mdProc.enabled = self:GetChecked()

			if spec.audio.mdProc.enabled then
				PlaySoundFile(spec.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.mdProcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_mdProcAudio", parent)
		controls.dropDown.mdProcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.mdProcAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, spec.audio.mdProc.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.mdProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.mdProcAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.mdProc.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.mdProcAudio:SetValue(newValue, newName)
			spec.audio.mdProc.sound = newValue
			spec.audio.mdProc.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceInsanity"]))
		f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceInsanity"])
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Shadow_overcapAudio", parent)
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
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

		

		yCoord = yCoord - 60
		controls.checkBoxes.deathspeakerProc = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Deathspeaker_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathspeakerProc
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowAudioCheckboxDeathspeaker"])
		f.tooltip = L["PriestShadowAudioCheckboxDeathspeakerTooltip"]
		f:SetChecked(spec.audio.deathspeaker.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.deathspeaker.enabled = self:GetChecked()

			if spec.audio.deathspeaker.enabled then
				PlaySoundFile(spec.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.deathspeakerProcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Shadow_Deathspeaker_ProcAudio", parent)
		controls.dropDown.deathspeakerProcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.deathspeakerProcAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.deathspeakerProcAudio, spec.audio.deathspeaker.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.deathspeakerProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.deathspeakerProcAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.deathspeaker.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.deathspeakerProcAudio:SetValue(newValue, newName)
			spec.audio.deathspeaker.sound = newValue
			spec.audio.deathspeaker.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.deathspeakerProcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		

		yCoord = yCoord - 60
		controls.checkBoxes.deathsTormentProc = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_deathsTorment_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathsTormentProc
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowAudioCheckboxDeathsTorment"])
		f.tooltip = L["PriestShadowAudioCheckboxDeathsTormentTooltip"]
		f:SetChecked(spec.audio.deathsTorment.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.deathsTorment.enabled = self:GetChecked()

			if spec.audio.deathsTorment.enabled then
				PlaySoundFile(spec.audio.deathsTorment.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.deathsTormentProcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Shadow_deathsTorment_ProcAudio", parent)
		controls.dropDown.deathsTormentProcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.deathsTormentProcAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.deathsTormentProcAudio, spec.audio.deathsTorment.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.deathsTormentProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.deathsTormentProcAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.deathsTorment.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.deathsTormentProcAudio:SetValue(newValue, newName)
			spec.audio.deathsTorment.sound = newValue
			spec.audio.deathsTorment.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.deathsTormentProcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.deathsTorment.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		

		yCoord = yCoord - 60
		controls.checkBoxes.deathsTormentMaxProc = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_deathsTormentMax_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathsTormentMaxProc
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowAudioCheckboxDeathsTormentMax"])
		f.tooltip = L["PriestShadowAudioCheckboxDeathsTormentMaxTooltip"]
		f:SetChecked(spec.audio.deathsTormentMax.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.deathsTormentMax.enabled = self:GetChecked()

			if spec.audio.deathsTormentMax.enabled then
				PlaySoundFile(spec.audio.deathsTormentMax.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.deathsTormentMaxProcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Shadow_deathsTormentMax_ProcAudio", parent)
		controls.dropDown.deathsTormentMaxProcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.deathsTormentMaxProcAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.deathsTormentMaxProcAudio, spec.audio.deathsTormentMax.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.deathsTormentMaxProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.deathsTormentMaxProcAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.deathsTormentMax.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.deathsTormentMaxProcAudio:SetValue(newValue, newName)
			spec.audio.deathsTormentMax.sound = newValue
			spec.audio.deathsTormentMax.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.deathsTormentMaxProcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.deathsTormentMax.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowHeaderAuspiciousSpiritsTracking"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.as = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_trackingAS", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.as
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowTrackingCheckboxAuspiciousSpirits"])
		f.tooltip = L["PriestShadowTrackingCheckboxAuspiciousSpiritsTooltip"]
		f:SetChecked(spec.auspiciousSpiritsTracker)
		f:SetScript("OnClick", function(self, ...)
			spec.auspiciousSpiritsTracker = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowHeaderEternalCallToTheVoidTracking"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.voidTendril = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_trackingECTTV", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.voidTendril
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowTrackingCheckboxEternalCallToTheVoid"])
		f.tooltip = L["PriestShadowTrackingCheckboxEternalCallToTheVoidTooltip"]
		f:SetChecked(spec.voidTendrilTracker)
		f:SetScript("OnClick", function(self, ...)
			spec.voidTendrilTracker = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHeaderShadowfiendMindbenderTracking"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.mindbender = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_trackingSF", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindbender
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxTrackShadowfiendInsanityGain"])
		f.tooltip = L["PriestShadowCheckboxTrackShadowfiendInsanityGainTooltip"]
		f:SetChecked(spec.mindbender.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.mindbender.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.mindbenderModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_RB3_8", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxShadowfiendGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.mindbender.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(true)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
			controls.checkBoxes.mindbenderModeTime:SetChecked(false)
			spec.mindbender.mode = "gcd"
		end)

		title = L["PriestShadowShadowfiendGcds"]
		controls.mindbenderGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.mindbender.gcdsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.mindbenderGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.mindbender.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.mindbenderModeSwings = CreateFrame("CheckButton", "TwintopResourceBar_RB3_9", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeSwings
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxShadowfiendSwings"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.mindbender.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(true)
			controls.checkBoxes.mindbenderModeTime:SetChecked(false)
			spec.mindbender.mode = "swing"
		end)

		title = L["PriestShadowShadowfiendSwings"]
		controls.mindbenderSwings = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.mindbender.swingsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.mindbenderSwings:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.mindbender.swingsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.mindbenderModeTime = CreateFrame("CheckButton", "TwintopResourceBar_RB3_10", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxShadowfiendTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.mindbender.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
			controls.checkBoxes.mindbenderModeTime:SetChecked(true)
			spec.mindbender.mode = "time"
		end)

		title = L["PriestShadowShadowfiendTime"]
		controls.mindbenderTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.mindbender.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.mindbenderTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.mindbender.timeMax = value
		end)		


		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowHeaderDeathsTorment"], oUi.xCoord, yCoord)

		yCoord = yCoord - 60
		title = L["PriestShadowDeathsTormentStacksBeforeChange"]
		controls.deathsTorment = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 11, spec.deathsTorment.stacks, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.deathsTorment:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.deathsTorment.stacks = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Priest_Shadow_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 5, 3, yCoord, cache)
	end

	local function ShadowConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.shadow or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}
		
		interfaceSettingsFrame.shadowDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Shadow", UIParent)
		interfaceSettingsFrame.shadowDisplayPanel.name = L["PriestShadowFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.shadowDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.shadowDisplayPanel, "ShadowL["Priest"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.shadowDisplayPanel)

		parent = interfaceSettingsFrame.shadowDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowFull"], oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.shadowPriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_shadowPriestEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowPriestEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["PriestShadowFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.priest.shadow)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.priest.shadow = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.shadowPriestEnabled, TRB.Data.settings.core.enabled.priest.shadow, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.shadowPriestEnabled, TRB.Data.settings.core.enabled.priest.shadow, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Priest_Shadow_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab1", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Priest_Shadow_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls

		ShadowConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		ShadowConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		ShadowConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		ShadowConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		ShadowConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		DisciplineConstructOptionsPanel(specCache.discipline)
		HolyConstructOptionsPanel(specCache.holy)
		ShadowConstructOptionsPanel(specCache.shadow)
	end
	TRB.Options.Priest.ConstructOptionsPanel = ConstructOptionsPanel
end