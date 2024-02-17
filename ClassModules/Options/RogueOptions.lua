local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 4 then --Only do this if we're on a Rogue!
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

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
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = "Left",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = "Left",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Middle",
				guid=TRB.Functions.String:Guid(),
				text="{$sadTime}[$sadTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = "Center",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Right",
				guid=TRB.Functions.String:Guid(),
				text="{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = "Right",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
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
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="#garrote $garroteCount {$garroteTime}[ $garroteTime]{$isNecrolord}[{!$garroteTime}[       ]  #serratedBoneSpike $sbsCount]||n#rupture $ruptureCount {$ruptureTime}[ $ruptureTime] {$ttd}[{!$ruptureTime}[      ]  TTD: $ttd]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = "Left",
				fontSize=13,
				color = "FFFFFFFF",
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = "Left",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Middle",
				guid=TRB.Functions.String:Guid(),
				text="{$sadTime}[#sad $sadTime #sad]|n{$blindsideTime}[#blindside $blindsideTime #blindside]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=13,
				color = "FFFFFFFF",
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = "Center",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Right",
				guid=TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=22,
				color = "FFFFFFFF",
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = "Right",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
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
					relativeToName = "Below",
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
				neverShow=false
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
				relativeToName="Above - Middle",
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
					fontJustifyHorizontalName = "Left",
					fontSize=18,
					color = "FFFFFFFF",
				},
				barText = {}
			},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				blindside={
					name = "Blindside Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				sepsis={
					name = "Sepsis Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
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
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="{$rtbBuffTime}[#rollTheBones $rtbBuffTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = "Left",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = "Left",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Middle",
				guid=TRB.Functions.String:Guid(),
				text="{$sadTime}[#sliceAndDice $sadTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = "Center",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Right",
				guid=TRB.Functions.String:Guid(),
				text="{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = "Right",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
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
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="{$rtbBuffTime}[#rollTheBones $rtbBuffTime #rollTheBones]{$ttd}[||nTTD: $ttd]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = "Left",
				fontSize=13,
				color = "FFFFFFFF",
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = "Left",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Middle",
				guid=TRB.Functions.String:Guid(),
				text="{$sadTime}[#sad $sadTime #sad]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=13,
				color = "FFFFFFFF",
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = "Center",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Right",
				guid=TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=22,
				color = "FFFFFFFF",
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = "Right",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
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
					relativeToName = "Below",
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
				neverShow=false
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
				relativeToName="Above - Middle",
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
					fontJustifyHorizontalName = "Left",
					fontSize=18,
					color = "FFFFFFFF",
				},
				barText = {}
			},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				opportunity={
					name = "Opportunity Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				sepsis={
					name = "Sepsis Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
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
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = "Left",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = "Left",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Middle",
				guid=TRB.Functions.String:Guid(),
				text="{$sadTime}[#sliceAndDice $sadTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = "Center",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Right",
				guid=TRB.Functions.String:Guid(),
				text="{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=18,
				color = "FFFFFFFF",
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = "Right",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			}
		}

		return textSettings
	end
	TRB.Options.RogueSubtletyLoadDefaultBarTextSimpleSettings = SubtletyLoadDefaultBarTextSimpleSettings
	
	local function SubtletyLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="{$rtbBuffTime}[#rollTheBones $rtbBuffTime #rollTheBones]{$ttd}[||nTTD: $ttd]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = "Left",
				fontSize=13,
				color = "FFFFFFFF",
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = "Left",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Middle",
				guid=TRB.Functions.String:Guid(),
				text="{$sadTime}[#sad $sadTime #sad]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=13,
				color = "FFFFFFFF",
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = "Center",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
				}
			},
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Right",
				guid=TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=22,
				color = "FFFFFFFF",
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = "Right",
					relativeToFrame = "Resource",
					relativeToFrameName = "Main Resource Bar"
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
					relativeToName = "Below",
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
				neverShow=false
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
				relativeToName="Above - Middle",
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
					shadowTechniques="FFFF00FF",
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
					fontJustifyHorizontalName = "Left",
					fontSize=18,
					color = "FFFFFFFF",
				},
				barText = {}
			},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				opportunity={
					name = "Opportunity Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				sepsis={
					name = "Sepsis Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
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
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = AssassinationLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
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

		controls.buttons.exportButton_Rogue_Assassination_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Bar Display).", 4, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 1, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 1, yCoord, "Energy", "Combo Point")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 1, yCoord, true, "Combo Point")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 1, yCoord, "Energy", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 1, yCoord, "Energy")

		yCoord = yCoord - 30
		controls.colors.sliceAndDicePandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy when Slice and Dice is within Pandemic refresh range (current CPs)", spec.colors.bar.sliceAndDicePandemic, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.sliceAndDicePandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "sliceAndDicePandemic")
		end)

		yCoord = yCoord - 30
		controls.colors.noSliceAndDice = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy when Slice and Dice is not up", spec.colors.bar.noSliceAndDice, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.noSliceAndDice
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noSliceAndDice")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_1_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy gain from Passive Sources", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 1, yCoord, "Energy", true, false)

		yCoord = yCoord - 30
		controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border color when you are stealth (via any ability or proc)", spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderStealth
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Combo Point Colors", oUi.xCoord, yCoord)
		
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Points", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Combo Point", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point when Echoing Reprimand buff is up", spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.echoingReprimand
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Combo Point", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		controls.colors.comboPoints.serratedBoneSpike = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point that will generate on next Serrated Bone Spike use", spec.colors.comboPoints.serratedBoneSpike, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.serratedBoneSpike
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "serratedBoneSpike")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Combo Point color for all?")
		f.tooltip = "When checked, the highest Combo Point's color will be used for all Combo Points. E.g., if you have maximum 5 combo points and currently have 4, the Penultimate color will be used for all Combo Points instead of just the second to last."
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Combo Point background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.consistentUnfilledColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always use default unfilled background")
		f.tooltip = "When checked, unfilled combo points will always use the 'Unfilled Combo Point background' color above for their background. Borders will still change color depending on Echoing Reprimand and Serrated Bone Spike settings."
		f:SetChecked(spec.comboPoints.consistentUnfilledColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.consistentUnfilledColor = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.serratedBoneSpikeComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSerratedBoneSpikeColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serratedBoneSpikeComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change color for Serrated Bone Spike generation?")
		f.tooltip = "When checked, any unfilled combo points that will generate on your next use of Serrated Bone Spike will be a different background and border color (as specified above)."
		f:SetChecked(spec.comboPoints.spec.serratedBoneSpikeColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.spec.serratedBoneSpikeColor = self:GetChecked()
		end)

		yCoord = yCoord - 40

		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Ability Threshold Lines", oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Under minimum required Energy threshold line", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Over minimum required Energy threshold line", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Improved Garrote effect up", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)
		
		controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, "Builders", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ambushThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ambush (stealth)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ambush. Only visible when in Stealth or usable via Blindside, Sepsis, or Subterfuge."
		f:SetChecked(spec.thresholds.ambush.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ambush.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cheapShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cheap Shot (stealth)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Cheap Shot. Only visible when in Stealth or usable via Sepsis or Subterfuge."
		f:SetChecked(spec.thresholds.cheapShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cheapShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.echoingReprimandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_echoingReprimand", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.echoingReprimandThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Echoing Reprimand")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Echoing Reprimand. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.echoingReprimand.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.echoingReprimand.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.fanOfKnivesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_fanOfKnives", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fanOfKnivesThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fan of Knives")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Fan of Knives."
		f:SetChecked(spec.thresholds.fanOfKnives.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.fanOfKnives.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.garroteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_garrote", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.garroteThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Garrote")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Garrote. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.garrote.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.garrote.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.gougeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Gouge")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Gouge. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.gouge.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.gouge.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.kingsbaneThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kingsbane", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.kingsbaneThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kingsbane")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kingsbane. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.kingsbane.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.kingsbane.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.mutilateThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_mutilate", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mutilateThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mutilate")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Mutilate."
		f:SetChecked(spec.thresholds.mutilate.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.mutilate.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.poisonedKnifeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_poisonedKnife", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.poisonedKnifeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Poisoned Knife")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Poisoned Knife."
		f:SetChecked(spec.thresholds.poisonedKnife.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.poisonedKnife.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sepsisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sepsis", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sepsisThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sepsis")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sepsis. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.sepsis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sepsis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serratedBoneSpikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_serratedBoneSpike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serratedBoneSpikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serrated Bone Spike")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Serrated Bone Spike. If no available charges, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.serratedBoneSpike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.serratedBoneSpike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shivThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shiv")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shiv. If on cooldown, will be colored as 'unusable'. If Tiny Toxic Blade is active, no threshold will be shown."
		f:SetChecked(spec.thresholds.shiv.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shiv.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 25
		controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, "Finishers", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.crimsonTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonTempest", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.crimsonTempestThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crimson Tempest ")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crimson Tempest. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.crimsonTempest.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.crimsonTempest.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.envenomThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_envenom", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.envenomThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Envenom")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Envenom. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.envenom.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.envenom.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.kidneyShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kidney Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot. Only visible when in Stealth or usable via Sepsis or Subterfuge. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.kidneyShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.kidneyShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sliceAndDiceThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slice and Dice")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.sliceAndDice.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sliceAndDice.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ruptureThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_rupture", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ruptureThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rupture")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Rupture. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.rupture.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rupture.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25		
		controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, "General / Utility", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.crimsonVialThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crimson Vial")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crimson Vial. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.crimsonVial.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.crimsonVial.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.distractThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Distract")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Distract. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.distract.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.distract.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.feintThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Feint")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Feint. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.feint.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.feint.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sapThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sap (stealth)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sap. Only visible when in Stealth or usable via Sepsis or Subterfuge."
		f:SetChecked(spec.thresholds.sap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sap.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, "PvP Abilities", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathFromAboveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Death From Above")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Death From Above. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.deathFromAbove.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.deathFromAbove.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dismantleThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Dismantle")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Dismantle. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.dismantle.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.dismantle.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 4, 1, yCoord, "Energy", 170)

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

		controls.buttons.exportButton_Rogue_Assassination_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Font & Text).", 4, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Energy Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Energy", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)
		
		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Energy", spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Energy is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter, DoT timer, and Slice and Dice color based on time remaining?")
		f.tooltip = "When checked, the color of total DoTs up counters, DoT timers, and Slice and Dice's timer will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Decimal Precision", oUi.xCoord, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
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

		controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Audio & Tracking).", 4, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.blindsideAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_blindside_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.blindsideAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Blindside proc occurs")
		f.tooltip = "Play an audio cue when a Blindside proc occurs, allowing Ambush to be used outside of stealth."
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
					info.text = "Sounds " .. i+1
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
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
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
					info.text = "Sounds " .. i+1
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
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you gain Sepsis buff")
		f.tooltip = "Play an audio cue when you gain Sepsis buff that allows you to use a stealth ability outside of steath."
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
					info.text = "Sounds " .. i+1
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
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Passive Energy Regeneration", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD length."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
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
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
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

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_Rogue_Assassination_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Bar Text).", 4, 1, false, false, false, true, false)
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
		interfaceSettingsFrame.assassinationDisplayPanel.name = "Assassination Rogue"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.assassinationDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.assassinationDisplayPanel, "Assassination Rogue")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.assassinationDisplayPanel)

		parent = interfaceSettingsFrame.assassinationDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Assassination Rogue", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.assassinationRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_assassinationRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.assassinationRogueEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Assassination Rogue specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.rogue.assassination)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.rogue.assassination = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Rogue_Assassination_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Rogue_Assassination_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (All).", 4, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

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
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = OutlawLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextSimple")
		end)

		yCoord = yCoord - 40
		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
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

		controls.buttons.exportButton_Rogue_Outlaw_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Bar Display).", 4, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 2, yCoord, "Energy", "Combo Point")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 2, yCoord, true, "Combo Point")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 2, yCoord, "Energy", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 2, yCoord, "Energy")

		yCoord = yCoord - 30
		controls.colors.sliceAndDicePandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy when Slice and Dice is within Pandemic refresh range (current CPs)", spec.colors.bar.sliceAndDicePandemic, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.sliceAndDicePandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "sliceAndDicePandemic")
		end)

		yCoord = yCoord - 30
		controls.colors.noSliceAndDice = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy when Slice and Dice is not up", spec.colors.bar.noSliceAndDice, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.noSliceAndDice
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noSliceAndDice")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_2_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy gain from Passive Sources", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 2, yCoord, "Energy", true, false)

		yCoord = yCoord - 30
		controls.colors.borderRtbGood = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border color when you should not use Roll the Bones (keep current rolls)", spec.colors.bar.borderRtbGood, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderRtbGood
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderRtbGood")
		end)

		yCoord = yCoord - 30
		controls.colors.borderRtbBad = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border color when you should use Roll the Bones (not up or should reroll)", spec.colors.bar.borderRtbBad, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderRtbBad
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderRtbBad")
		end)

		yCoord = yCoord - 30
		controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border color when you are stealth (via any ability or proc)", spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderStealth
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
		end)


		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Combo Point Colors", oUi.xCoord, yCoord)
		
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Points", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Combo Point", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point when Echoing Reprimand buff is up", spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.echoingReprimand
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Combo Point", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)
		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Combo Point background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Combo Point color for all?")
		f.tooltip = "When checked, the highest Combo Point's color will be used for all Combo Points. E.g., if you have maximum 5 combo points and currently have 4, the Penultimate color will be used for all Combo Points instead of just the second to last."
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.consistentUnfilledColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always use default unfilled background")
		f.tooltip = "When checked, unfilled combo points will always use the 'Unfilled Combo Point background' color above for their background. Borders will still change color depending on Echoing Reprimand settings."
		f:SetChecked(spec.comboPoints.consistentUnfilledColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.consistentUnfilledColor = self:GetChecked()
		end)




		yCoord = yCoord - 40

		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Ability Threshold Lines", oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Under minimum required Energy threshold line", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Over minimum required Energy threshold line", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.restlessBlades = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Ability usable after next finisher (via Restless Blades+True Bearing)", spec.colors.threshold.restlessBlades, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.restlessBlades
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "restlessBlades")
		end)

		controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Skull and Crossbones, Ruthless Precision, or Opportunity effect up", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-150)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-180)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-200)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)
		
		controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, "Builders", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ambushThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ambush (if stealthed)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ambush. Only visible when in Stealth."
		f:SetChecked(spec.thresholds.ambush.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ambush.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cheapShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cheap Shot (if stealthed)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Cheap Shot. Only visible when in Stealth or usable via the Subterfuge talent."
		f:SetChecked(spec.thresholds.cheapShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cheapShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.dreadbladesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dreadblades", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dreadbladesThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Dreadblades")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Dreadblades. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.dreadblades.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.dreadblades.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.echoingReprimandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_echoingRep", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.echoingReprimandThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Echoing Reprimand")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Echoing Reprimand. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.echoingReprimand.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.echoingReprimand.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ghostlyStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_ghostlyStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ghostlyStrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ghostly Strike")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ghostly Strike. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.ghostlyStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ghostlyStrike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.gougeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Gouge")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Gouge. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.gouge.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.gouge.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.pistolShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_pistolShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pistolShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pistol Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Pistol Shot."
		f:SetChecked(spec.thresholds.pistolShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.pistolShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sepsisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sepsis", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sepsisThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sepsis")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sepsis. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.sepsis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sepsis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shivThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shiv")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shiv. If on cooldown, will be colored as 'unusable'. If talented in to Tiny Toxic Blade, no threshold will be shown."
		f:SetChecked(spec.thresholds.shiv.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shiv.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sinisterStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sinisterStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sinisterStrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sinister Strike")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sinister Strike."
		f:SetChecked(spec.thresholds.sinisterStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sinisterStrike.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 25
		controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, "Finishers", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.betweenTheEyesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_betweenTheEyes", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.betweenTheEyesThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Between the Eyes")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Between the Eyes. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.betweenTheEyes.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.betweenTheEyes.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.dispatchThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dispatch", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dispatchThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Dispatch")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Dispatch. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.dispatch.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.dispatch.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.kidneyShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kidney Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot. Only visible when in Stealth or usable via the Subterfuge talent. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.kidneyShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.kidneyShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killingSpreeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_killingSpree", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killingSpreeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Killing Spree")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Killing Spree. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.killingSpree.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.killingSpree.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sliceAndDiceThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slice and Dice")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.sliceAndDice.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sliceAndDice.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25		
		controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, "General / Utility", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.bladeFlurryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_bladeFlurry", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.bladeFlurryThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Blade Flurry")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Blade Flurry. Only visible when in Stealth."
		f:SetChecked(spec.thresholds.bladeFlurry.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.bladeFlurry.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.crimsonVialThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crimson Vial")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crimson Vial. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.crimsonVial.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.crimsonVial.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.distractThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Distract")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Distract. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.distract.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.distract.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.feintThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Feint")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Feint. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.feint.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.feint.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.rollTheBonesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_rollTheBones", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.rollTheBonesThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Roll the Bones")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Roll the Bones. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.rollTheBones.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rollTheBones.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sapThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sap (if stealthed)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sap. Only visible when in Stealth or usable via the Subterfuge talent."
		f:SetChecked(spec.thresholds.sap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sap.enabled = self:GetChecked()
		end)
		yCoord = yCoord - 25
		controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, "PvP Abilities", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathFromAboveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Death From Above")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Death From Above. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.deathFromAbove.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.deathFromAbove.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dismantleThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Dismantle")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Dismantle. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.dismantle.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.dismantle.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 4, 2, yCoord, "Energy", 170)

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

		controls.buttons.exportButton_Rogue_Outlaw_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Font & Text).", 4, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 2, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Energy Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Energy", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)
		
		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Energy", spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Energy is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter, DoT timer, and Slice and Dice color based on time remaining?")
		f.tooltip = "When checked, the color of total DoTs up counters, DoT timers, and Slice and Dice's timer will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Decimal Precision", oUi.xCoord, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
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

		controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Audio & Tracking).", 4, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.opportunityAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_opportunity_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.opportunityAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when an Opportunity proc occurs")
		f.tooltip = "Play an audio cue when an Opportunity proc occurs."
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
					info.text = "Sounds " .. i+1
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
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
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
					info.text = "Sounds " .. i+1
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
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you gain Sepsis buff")
		f.tooltip = "Play an audio cue when you gain Sepsis buff that allows you to use a stealth ability outside of steath."
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
					info.text = "Sounds " .. i+1
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
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Passive Energy Regeneration", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD length."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
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
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
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

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_Rogue_Outlaw_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Bar Text).", 4, 2, false, false, false, true, false)
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
		interfaceSettingsFrame.outlawDisplayPanel.name = "Outlaw Rogue"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.outlawDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.outlawDisplayPanel, "Outlaw Rogue")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.outlawDisplayPanel)

		parent = interfaceSettingsFrame.outlawDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Outlaw Rogue", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.outlawRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_outlawRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.outlawRogueEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Outlaw Rogue specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.rogue.outlaw)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.rogue.outlaw = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Rogue_Outlaw_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Rogue_Outlaw_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (All).", 4, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

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
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = SubtletyLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
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

		controls.buttons.exportButton_Rogue_Subtlety_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Bar Display).", 4, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 3, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 3, yCoord, "Energy", "Combo Point")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 3, yCoord, true, "Combo Point")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 3, yCoord, "Energy", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 3, yCoord, "Energy")

		yCoord = yCoord - 30
		controls.colors.sliceAndDicePandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy when Slice and Dice is within Pandemic refresh range (current CPs)", spec.colors.bar.sliceAndDicePandemic, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.sliceAndDicePandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "sliceAndDicePandemic")
		end)

		yCoord = yCoord - 30
		controls.colors.noSliceAndDice = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy when Slice and Dice is not up", spec.colors.bar.noSliceAndDice, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.noSliceAndDice
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "noSliceAndDice")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Energy gain from Passive Sources", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 3, yCoord, "Energy", true, false)

		yCoord = yCoord - 30
		controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border color when you are stealth (via any ability or proc)", spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderStealth
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Combo Point Colors", oUi.xCoord, yCoord)
		
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Points", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Combo Point", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point when Echoing Reprimand buff is up", spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.echoingReprimand
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Combo Point", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		controls.colors.comboPoints.shadowTechniques = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Combo Point that will generate from Shadow Techniques", spec.colors.comboPoints.shadowTechniques, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.shadowTechniques
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "shadowTechniques")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Combo Point color for all?")
		f.tooltip = "When checked, the highest Combo Point's color will be used for all Combo Points. E.g., if you have maximum 5 combo points and currently have 4, the Penultimate color will be used for all Combo Points instead of just the second to last."
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Combo Point background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.consistentUnfilledColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always use default unfilled background")
		f.tooltip = "When checked, unfilled combo points will always use the 'Unfilled Combo Point background' color above for their background. Borders will still change color depending on Echoing Reprimand settings."
		f:SetChecked(spec.comboPoints.consistentUnfilledColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.consistentUnfilledColor = self:GetChecked()
		end)

		yCoord = yCoord - 40

		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Ability Threshold Lines", oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Under minimum required Energy threshold line", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Over minimum required Energy threshold line", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, "SPECIAL EFFECT PLACEHOLDER", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)
		
		controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, "Builders", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.backstabThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_backstab", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.backstabThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Backstab / Gloomblade")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Backstab or Gloomblade."
		f:SetChecked(spec.thresholds.backstab.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.backstab.enabled = self:GetChecked()
			spec.thresholds.gloomblade.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cheapShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cheap Shot (stealth)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Cheap Shot. Only visible when in Stealth or usable via Shadow Dance, Sepsis, or Subterfuge."
		f:SetChecked(spec.thresholds.cheapShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cheapShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.echoingReprimandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_echoingReprimand", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.echoingReprimandThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Echoing Reprimand")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Echoing Reprimand. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.echoingReprimand.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.echoingReprimand.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.goremawsBiteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_goremawsbite", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.goremawsBiteThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Goremaw's Bite")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Goremaw's Bite. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.goremawsBite.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.goremawsBite.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.gougeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Gouge")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Gouge. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.gouge.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.gouge.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sepsisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sepsis", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sepsisThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sepsis")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sepsis. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.sepsis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sepsis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shadowstrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shadowstrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowstrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shadowstrike (stealth)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shadowstrike. Only visible when in Stealth or usable via Shadow Dance, Sepsis, or Subterfuge."
		f:SetChecked(spec.thresholds.shadowstrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shadowstrike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shurikenStormThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenStorm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shurikenStormThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shuriken Storm")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shuriken Storm."
		f:SetChecked(spec.thresholds.shurikenStorm.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shurikenStorm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shurikenTornadoThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenTornado", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shurikenTornadoThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shuriken Tornado")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shuriken Tornado. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.shurikenTornado.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shurikenTornado.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shurikenTossThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenToss", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shurikenTossThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shuriken Toss")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shuriken Toss."
		f:SetChecked(spec.thresholds.shurikenToss.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shurikenToss.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shivThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shiv")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shiv. If on cooldown, will be colored as 'unusable'. If Tiny Toxic Blade is active, no threshold will be shown."
		f:SetChecked(spec.thresholds.shiv.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shiv.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 25
		controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, "Finishers", 5, yCoord, 110, 20)
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
		getglobal(f:GetName() .. 'Text'):SetText("Kidney Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot. Only visible when in Stealth or usable via Sepsis or Subterfuge. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.kidneyShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.kidneyShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sliceAndDiceThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slice and Dice")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.sliceAndDice.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sliceAndDice.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ruptureThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_rupture", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ruptureThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rupture")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Rupture. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.rupture.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rupture.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.secretTechniqueThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_secretTechnique", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.secretTechniqueThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Secret Technique")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Secret Technique. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.secretTechnique.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.secretTechnique.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25		
		controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, "General / Utility", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.crimsonVialThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crimson Vial")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crimson Vial. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.crimsonVial.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.crimsonVial.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.distractThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Distract")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Distract. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.distract.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.distract.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.feintThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Feint")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Feint. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.feint.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.feint.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sapThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sap (stealth)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sap. Only visible when in Stealth or usable via Sepsis or Subterfuge."
		f:SetChecked(spec.thresholds.sap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.sap.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, "PvP Abilities", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathFromAboveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Death From Above")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Death From Above. If on cooldown or if you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.deathFromAbove.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.deathFromAbove.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dismantleThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Dismantle")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Dismantle. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.dismantle.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.dismantle.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shadowyDuelThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shadowyDuel", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowyDuelThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shadowy Duel")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shadowy Duel. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.shadowyDuel.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shadowyDuel.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 3, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 4, 3, yCoord, "Energy", 170)

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

		controls.buttons.exportButton_Rogue_Subtlety_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Font & Text).", 4, 3, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 3, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Energy Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Energy", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)
		
		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Energy", spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Energy is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter, DoT timer, and Slice and Dice color based on time remaining?")
		f.tooltip = "When checked, the color of total DoTs up counters, DoT timers, and Slice and Dice's timer will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Decimal Precision", oUi.xCoord, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
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

		controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Audio & Tracking).", 4, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)

		--[[
		yCoord = yCoord - 30
		controls.checkBoxes.blindsideAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_blindside_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.blindsideAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Blindside proc occurs")
		f.tooltip = "Play an audio cue when a Blindside proc occurs, allowing Ambush to be used outside of stealth."
		f:SetChecked(spec.audio.blindside.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.blindside.enabled = self:GetChecked()

			if spec.audio.blindside.enabled then
				PlaySoundFile(spec.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.blindsideAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Rogue_Subtlety_blindside_Audio", parent)
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
					info.text = "Sounds " .. i+1
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
		]]

		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
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
					info.text = "Sounds " .. i+1
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
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you gain Sepsis buff")
		f.tooltip = "Play an audio cue when you gain Sepsis buff that allows you to use a stealth ability outside of steath."
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
					info.text = "Sounds " .. i+1
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
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Passive Energy Regeneration", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD length."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
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
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
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

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_Rogue_Subtlety_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Bar Text).", 4, 3, false, false, false, true, false)
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
		interfaceSettingsFrame.subtletyDisplayPanel.name = "Subtlety Rogue"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.subtletyDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.subtletyDisplayPanel, "Subtlety Rogue")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.subtletyDisplayPanel)

		parent = interfaceSettingsFrame.subtletyDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Subtlety Rogue", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.subtletyRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_subtletyRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.subtletyRogueEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Subtlety Rogue specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.rogue.subtlety)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.rogue.subtlety = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Rogue_Subtlety_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Rogue_Subtlety_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (All).", 4, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

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
end