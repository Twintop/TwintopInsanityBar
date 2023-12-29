local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 13 then --Only do this if we're on a Evoker!
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

	TRB.Options.Evoker = {}
	TRB.Options.Evoker.Devastation = {}
	TRB.Options.Evoker.Preservation = {}
	TRB.Options.Evoker.Augmentation = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = {}

	local function EvokerLoadExtraBarTextSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				enabled = true,
				fontFace = "Fonts\\FRIZQT__.TTF",
				useDefaultFontFace = false,
				guid=TRB.Functions.String:Guid(),
				fontJustifyHorizontalName = "Left",
				text = "{$essence=0}[$essenceRegenTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "Essence 1",
				position = {
					relativeToName = "Center",
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = "Essence 1",
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
				fontJustifyHorizontalName = "Left",
				text = "{$essence=1}[$essenceRegenTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "Essence 2",
				position = {
					relativeToName = "Center",
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = "Essence 2",
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
				fontJustifyHorizontalName = "Left",
				text = "{$essence=2}[$essenceRegenTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "Essence 3",
				position = {
					relativeToName = "Center",
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = "Essence 3",
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
				fontJustifyHorizontalName = "Left",
				text = "{$essence=3}[$essenceRegenTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "Essence 4",
				position = {
					relativeToName = "Center",
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = "Essence 4",
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
				fontJustifyHorizontalName = "Left",
				text = "{$essence=4}[$essenceRegenTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "Essence 5",
				position = {
					relativeToName = "Center",
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = "Essence 5",
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
				fontJustifyHorizontalName = "Left",
				text = "{$essence=5}[$essenceRegenTime]",
				fontSize = 14,
				color = "FFFFFFFF",
				name = "Essence 6",
				position = {
					relativeToName = "Center",
					relativeTo = "CENTER",
					xPos = 0,
					relativeToFrameName = "Essence 6",
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
				text="",
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
				text="{$passive}[$passive + ]",
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

		local extraTextSettings = EvokerLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end
	TRB.Options.Evoker.DevastationLoadDefaultBarTextSimpleSettings = DevastationLoadDefaultBarTextSimpleSettings
	
	local function DevastationLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="{$ttd}[||nTTD: $ttd]",
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
				text="",
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
				text="$mana",
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

		local extraTextSettings = EvokerLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end

	local function DevastationLoadDefaultSettings(includeBarText)
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
				height=16,
				xPos=0,
				yPos=-215,
				border=2,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=false,
				showCasting=true
			},
			comboPoints = {
				width=25,
				height=16,
				xPos=0,
				yPos=4,
				border=2,
				spacing=14,
				relativeTo="TOP",
				relativeToName="Above - Middle",
				fullWidth=true,
			},
			colors = {
				text = {
					current="FF4D4DFF",
					casting="FFFFFFFF",
					spending="FFFFFFFF",
					passive="FF8080FF",
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
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
				essenceBurst={
					name = "Essence Burst (1 stack)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				essenceBurst2={
					name = "Essence Burst (2 stacks)",
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
			settings.displayText.barText = DevastationLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	-- Preservation
	local function PreservationLoadDefaultBarTextSimpleSettings()
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
				fontSize=16,
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
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = "Center",
				fontSize=16,
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
				text="{$casting}[#casting$casting + ]{$passive}[$passive + ]$mana/$manaMax $manaPercent%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=16,
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

		local extraTextSettings = EvokerLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end
	TRB.Options.Evoker.PreservationLoadDefaultBarTextSimpleSettings = PreservationLoadDefaultBarTextSimpleSettings

	local function PreservationLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="{$potionCooldown}[#potionOfFrozenFocus $potionCooldown] ",
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
				text="",
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
				text="{$casting}[#casting$casting+]{$passive}[$passive+]$mana/$manaMax $manaPercent%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = "Right",
				fontSize=16,
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

		local extraTextSettings = EvokerLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end

	local function PreservationLoadDefaultSettings(includeBarText)
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
			},
			passiveGeneration = {
				innervate = true,
				manaTideTotem = true,
				symbolOfHope = true
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
				},
				comboPoints = {
					border="FF246759",
					background="66000000",
					base="FF33937F",
					penultimate="FFFF9900",
					final="FFFF0000",
					sameColor=false
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
					fontJustifyHorizontalName = "Left",
					fontSize=18,
					color = "FFFFFFFF",
				},
				barText = {}
			},
			audio={
				innervate={
					name = "Innervate",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				essenceBurst={
					name = "Essence Burst (1 stack)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				essenceBurst2={
					name = "Essence Burst (2 stacks)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
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
				text="",
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
				text="$mana",
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

		local extraTextSettings = EvokerLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end
	TRB.Options.Evoker.AugmentationLoadDefaultBarTextSimpleSettings = AugmentationLoadDefaultBarTextSimpleSettings
	
	local function AugmentationLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name="Left",
				guid=TRB.Functions.String:Guid(),
				text="{$ttd}[||nTTD: $ttd]",
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
				text="",
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
				text="$mana",
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

		local extraTextSettings = EvokerLoadExtraBarTextSettings()

		for x = 1, #extraTextSettings do
			table.insert(textSettings, extraTextSettings[x])
		end
		return textSettings
	end

	local function AugmentationLoadDefaultSettings(includeBarText)
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
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			bar = {
				width=555,
				height=16,
				xPos=0,
				yPos=-215,
				border=2,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=false,
				showCasting=true
			},
			comboPoints = {
				width=25,
				height=16,
				xPos=0,
				yPos=4,
				border=2,
				spacing=14,
				relativeTo="TOP",
				relativeToName="Above - Middle",
				fullWidth=true,
			},
			colors = {
				text = {
					current="FF4D4DFF",
					casting="FFFFFFFF",
					spending="FFFFFFFF",
					passive="FF8080FF",
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
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
				essenceBurst={
					name = "Essence Burst (1 stack)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				essenceBurst2={
					name = "Essence Burst (2 stacks)",
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
			settings.displayText.barText = AugmentationLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function LoadDefaultSettings(includeBarText)
		local settings = TRB.Options.LoadDefaultSettings()
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
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Devastation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Devastation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = DevastationLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Devastation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = DevastationLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
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
			StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
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

		controls.buttons.exportButton_Evoker_Devastation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Devastation_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Devastation Evoker (Bar Display).", 13, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 1, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 1, yCoord, "Mana", "Essence")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 1, yCoord, true, "Essence")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 1, yCoord, "Mana", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 1, yCoord, "Mana")

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 1, yCoord, "Mana", false, false)
		
		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurstBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_Threshold_Option_essenceBurstBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurstBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Essence Burst (1 stack)")
		f.tooltip = "This will change the bar border color when you have 1 stack of Essence Burst."
		f:SetChecked(spec.colors.bar.essenceBurst.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.essenceBurst.enabled = self:GetChecked()
		end)

		controls.colors.essenceBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 1 stack of Essence Burst", spec.colors.bar.essenceBurst.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.essenceBurst
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurst2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_Threshold_Option_essenceBurst2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Essence Burst (2 stacks)")
		f.tooltip = "This will change the bar border color when you have 2 stacks of Essence Burst."
		f:SetChecked(spec.colors.bar.essenceBurst2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.essenceBurst2.enabled = self:GetChecked()
		end)

		controls.colors.essenceBurst2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 2 stacks of Essence Burst", spec.colors.bar.essenceBurst2.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.essenceBurst2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst2")
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Essence Colors", oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Essence", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Essence's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Essence", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Essence background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Essence", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Essence color for all?")
		f.tooltip = "When checked, the highest Essence's color will be used for all Essence. E.g., if you have maximum 5 Essence and currently have 4, the Penultimate color will be used for all Essence instead of just the second to last."
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

		controls.buttons.exportButton_Evoker_Devastation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Devastation_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Devastation Evoker (Font & Text).", 13, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Mana Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Mana", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls
	end

	local function DevastationConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.evoker.devastation

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.devastation
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Evoker_Devastation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Devastation_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Devastation Evoker (Audio & Tracking).", 13, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)


		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurst = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_essenceBurstCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Essence Burst proc occurs")
		f.tooltip = "Play an audio cue when a Essence Burst proc occurs. This will only play for the first proc."
		f:SetChecked(spec.audio.essenceBurst.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.essenceBurst.enabled = self:GetChecked()

			if spec.audio.essenceBurst.enabled then
				PlaySoundFile(spec.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.essenceBurstAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Devastation_essenceBurstAudio", parent)
		controls.dropDown.essenceBurstAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.essenceBurstAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurstAudio, spec.audio.essenceBurst.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.essenceBurstAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.essenceBurstAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.essenceBurst.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.essenceBurstAudio:SetValue(newValue, newName)
			spec.audio.essenceBurst.sound = newValue
			spec.audio.essenceBurst.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurstAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.essenceBurst2 = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_essenceBurst2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you have two (max) Essence Burst procs")
		f.tooltip = "Play audio cue when you get a second (and maximum) Essence Burst proc. If both are checked, only this sound will play."
		f:SetChecked(spec.audio.essenceBurst2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.essenceBurst2.enabled = self:GetChecked()

			if spec.audio.essenceBurst2.enabled then
				PlaySoundFile(spec.audio.essenceBurst2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.essenceBurst2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Devastation_essenceBurstAudio", parent)
		controls.dropDown.essenceBurst2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.essenceBurst2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurst2Audio, spec.audio.essenceBurst2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.essenceBurst2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.essenceBurst2Audio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.essenceBurst2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.essenceBurst2Audio:SetValue(newValue, newName)
			spec.audio.essenceBurst2.sound = newValue
			spec.audio.essenceBurst2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurst2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.essenceBurst2.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls
	end
	
	local function DevastationConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.evoker.devastation
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.devastation
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_Evoker_Devastation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Devastation_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Devastation Evoker (Bar Text).", 13, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 1, yCoord, cache)
	end

	local function DevastationConstructOptionsPanel(cache)
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
		interfaceSettingsFrame.devastationDisplayPanel.name = "Devastation Evoker"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.devastationDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.devastationDisplayPanel, "Devastation Evoker")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.devastationDisplayPanel)

		parent = interfaceSettingsFrame.devastationDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Devastation Evoker", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.devastationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_devastationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.devastationEvokerEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Devastation Evoker specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.evoker.devastation)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.evoker.devastation = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devastationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.devastation, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devastationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.devastation, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Evoker_Devastation_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Evoker_Devastation_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Devastation Evoker (All).", 13, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Devastation_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Devastation_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Devastation_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Devastation_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Devastation_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do 
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Evoker_Devastation_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls

		DevastationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		DevastationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		DevastationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		DevastationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		DevastationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
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
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Preservation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Preservation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = PreservationLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Preservation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = PreservationLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[
		StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Preservation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = PreservationLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		]]

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
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

		controls.buttons.exportButton_Evoker_Preservation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Preservation_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Preservation Evoker (Bar Display).", 13, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 2, yCoord, "Mana", "Essence")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 2, yCoord, true, "Essence")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 2, yCoord, "Mana", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 2, yCoord, "Mana")

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_2_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana cost of current hardcast spell", spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_2_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana from Passive Sources (Potions, Mana Tide Totem bonus regen, etc)", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 2, yCoord, "Mana", false, true)
		
		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurstBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Threshold_Option_essenceBurstBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurstBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Essence Burst (1 stack)")
		f.tooltip = "This will change the bar border color when you have 1 stack of Essence Burst."
		f:SetChecked(spec.colors.bar.essenceBurst.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.essenceBurst.enabled = self:GetChecked()
		end)

		controls.colors.essenceBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 1 stack of Essence Burst", spec.colors.bar.essenceBurst.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.essenceBurst
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurst2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Threshold_Option_essenceBurst2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Essence Burst (2 stacks)")
		f.tooltip = "This will change the bar border color when you have 2 stacks of Essence Burst."
		f:SetChecked(spec.colors.bar.essenceBurst2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.essenceBurst2.enabled = self:GetChecked()
		end)

		controls.colors.essenceBurst2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 2 stacks of Essence Burst", spec.colors.bar.essenceBurst2.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.essenceBurst2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst2")
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Essence Colors", oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Essence", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Essence's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Essence", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Essence background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Essence", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 13, 2, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 13, 2, yCoord)

		yCoord = yCoord - 40
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

		controls.buttons.exportButton_Evoker_Preservation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Preservation_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Preservation Evoker (Font & Text).", 13, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 2, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Mana Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Mana", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana spent from hardcasting spells", spec.colors.text.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "casting")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Mana", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)
	
		--[[
		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers will change based on whether or not the DoT is on the current target."
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
		]]

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

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = controls
	end

	local function PreservationConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.evoker.preservation

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.preservation
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Evoker_Preservation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Preservation_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Preservation Evoker (Audio & Tracking).", 13, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervate
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio when you gain Innervate")
		f.tooltip = "This sound will play when you gain Innervate from a helpful Druid."
		f:SetChecked(spec.audio.innervate.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.innervate.enabled = self:GetChecked()

			if spec.audio.innervate.enabled then
				PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Preservation_Innervate_Audio", parent)
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
		controls.checkBoxes.essenceBurst = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_essenceBurstCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Essence Burst proc occurs")
		f.tooltip = "Play an audio cue when a Essence Burst proc occurs. This will only play for the first proc."
		f:SetChecked(spec.audio.essenceBurst.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.essenceBurst.enabled = self:GetChecked()

			if spec.audio.essenceBurst.enabled then
				PlaySoundFile(spec.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.essenceBurstAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Preservation_essenceBurstAudio", parent)
		controls.dropDown.essenceBurstAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.essenceBurstAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurstAudio, spec.audio.essenceBurst.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.essenceBurstAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.essenceBurstAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.essenceBurst.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.essenceBurstAudio:SetValue(newValue, newName)
			spec.audio.essenceBurst.sound = newValue
			spec.audio.essenceBurst.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurstAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.essenceBurst2 = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_essenceBurst2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you have two (max) Essence Burst procs")
		f.tooltip = "Play audio cue when you get a second (and maximum) Essence Burst proc. If both are checked, only this sound will play."
		f:SetChecked(spec.audio.essenceBurst2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.essenceBurst2.enabled = self:GetChecked()

			if spec.audio.essenceBurst2.enabled then
				PlaySoundFile(spec.audio.essenceBurst2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.essenceBurst2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Preservation_essenceBurstAudio", parent)
		controls.dropDown.essenceBurst2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.essenceBurst2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurst2Audio, spec.audio.essenceBurst2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.essenceBurst2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.essenceBurst2Audio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.essenceBurst2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.essenceBurst2Audio:SetValue(newValue, newName)
			spec.audio.essenceBurst2.sound = newValue
			spec.audio.essenceBurst2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurst2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.essenceBurst2.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Passive External Mana Generation Tracking", oUi.xCoord, yCoord)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track passive mana regen while Innervate is active")
		f.tooltip = "Show the passive regeneration of mana over the remaining duration of Innervate."
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track bonus passive mana regen while Mana Tide Totem is active")
		f.tooltip = "Show the bonus passive regeneration of mana over the remaining duration of Mana Tide Totem."
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track mana regen from a Priest's Symbol of Hope")
		f.tooltip = "Show the regeneration of mana from a Priest's Symbol of Hope channel."
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = controls
	end

	local function PreservationConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.evoker.preservation
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.preservation
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_Evoker_Preservation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Preservation_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Preservation Evoker (Bar Text).", 13, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 2, yCoord, cache)
	end

	local function PreservationConstructOptionsPanel(cache)
		
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
		interfaceSettingsFrame.preservationDisplayPanel.name = "Preservation Evoker"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.preservationDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.preservationDisplayPanel, "Preservation Evoker")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.preservationDisplayPanel)

		parent = interfaceSettingsFrame.preservationDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Preservation Evoker", oUi.xCoord, yCoord-5)	
		
		controls.checkBoxes.preservationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_preservationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.preservationEvokerEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Preservation Evoker specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.evoker.preservation)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.evoker.preservation = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.preservationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.preservation, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.preservationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.preservation, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Evoker_Preservation_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Evoker_Preservation_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Preservation Evoker (All).", 13, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Preservation_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Preservation_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Preservation_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Preservation_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Preservation_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Evoker_Preservation_LayoutPanel" .. i, parent)
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
		PreservationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		PreservationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		PreservationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		PreservationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
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
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Augmentation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
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
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Augmentation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = AugmentationLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Augmentation Evoker settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText.barText = AugmentationLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
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
			StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
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

		controls.buttons.exportButton_Evoker_Augmentation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Augmentation_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Augmentation Evoker (Bar Display).", 13, 3, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 3, yCoord, "Mana", "Essence")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 3, yCoord, true, "Essence")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 3, yCoord, "Mana", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 3, yCoord, "Mana")

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 3, yCoord, "Mana", false, false)
		
		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurstBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Threshold_Option_essenceBurstBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurstBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Essence Burst (1 stack)")
		f.tooltip = "This will change the bar border color when you have 1 stack of Essence Burst."
		f:SetChecked(spec.colors.bar.essenceBurst.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.essenceBurst.enabled = self:GetChecked()
		end)

		controls.colors.essenceBurst = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 1 stack of Essence Burst", spec.colors.bar.essenceBurst.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.essenceBurst
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurst2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Threshold_Option_essenceBurst2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Essence Burst (2 stacks)")
		f.tooltip = "This will change the bar border color when you have 2 stacks of Essence Burst."
		f:SetChecked(spec.colors.bar.essenceBurst2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.essenceBurst2.enabled = self:GetChecked()
		end)

		controls.colors.essenceBurst2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 2 stacks of Essence Burst", spec.colors.bar.essenceBurst2.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.essenceBurst2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "essenceBurst2")
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Essence Colors", oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Essence", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Essence's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Essence", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Essence background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Essence", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Essence color for all?")
		f.tooltip = "When checked, the highest Essence's color will be used for all Essence. E.g., if you have maximum 5 Essence and currently have 4, the Penultimate color will be used for all Essence instead of just the second to last."
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

		controls.buttons.exportButton_Evoker_Augmentation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Augmentation_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Augmentation Evoker (Font & Text).", 13, 3, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 3, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Mana Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Mana", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls
	end

	local function AugmentationConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.evoker.augmentation

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.augmentation
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Evoker_Augmentation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Augmentation_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Augmentation Evoker (Audio & Tracking).", 13, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)


		yCoord = yCoord - 30
		controls.checkBoxes.essenceBurst = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_essenceBurstCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Essence Burst proc occurs")
		f.tooltip = "Play an audio cue when a Essence Burst proc occurs. This will only play for the first proc."
		f:SetChecked(spec.audio.essenceBurst.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.essenceBurst.enabled = self:GetChecked()

			if spec.audio.essenceBurst.enabled then
				PlaySoundFile(spec.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.essenceBurstAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Augmentation_essenceBurstAudio", parent)
		controls.dropDown.essenceBurstAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.essenceBurstAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurstAudio, spec.audio.essenceBurst.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.essenceBurstAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.essenceBurstAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.essenceBurst.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.essenceBurstAudio:SetValue(newValue, newName)
			spec.audio.essenceBurst.sound = newValue
			spec.audio.essenceBurst.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurstAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.essenceBurst2 = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_essenceBurst2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.essenceBurst2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you have two (max) Essence Burst procs")
		f.tooltip = "Play audio cue when you get a second (and maximum) Essence Burst proc. If both are checked, only this sound will play."
		f:SetChecked(spec.audio.essenceBurst2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.essenceBurst2.enabled = self:GetChecked()

			if spec.audio.essenceBurst2.enabled then
				PlaySoundFile(spec.audio.essenceBurst2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.essenceBurst2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Evoker_Augmentation_essenceBurstAudio", parent)
		controls.dropDown.essenceBurst2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.essenceBurst2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurst2Audio, spec.audio.essenceBurst2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.essenceBurst2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.essenceBurst2Audio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.essenceBurst2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.essenceBurst2Audio:SetValue(newValue, newName)
			spec.audio.essenceBurst2.sound = newValue
			spec.audio.essenceBurst2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.essenceBurst2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.essenceBurst2.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls
	end
	
	local function AugmentationConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.evoker.augmentation
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.augmentation
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_Evoker_Augmentation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Evoker_Augmentation_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Augmentation Evoker (Bar Text).", 13, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 3, yCoord, cache)
	end

	local function AugmentationConstructOptionsPanel(cache)
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
		interfaceSettingsFrame.augmentationDisplayPanel.name = "Augmentation Evoker"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.augmentationDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.augmentationDisplayPanel, "Augmentation Evoker")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.augmentationDisplayPanel)

		parent = interfaceSettingsFrame.augmentationDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Augmentation Evoker", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.augmentationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_augmentationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.augmentationEvokerEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Augmentation Evoker specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.evoker.augmentation)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.evoker.augmentation = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.augmentationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.augmentation, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.augmentationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.augmentation, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Evoker_Augmentation_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Evoker_Augmentation_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Augmentation Evoker (All).", 13, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Augmentation_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Augmentation_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Augmentation_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Augmentation_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Evoker_Augmentation_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do 
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Evoker_Augmentation_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls

		AugmentationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		AugmentationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		AugmentationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		AugmentationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		AugmentationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		if TRB.Data.settings.core.experimental.specs.evoker.devastation == true then
			DevastationConstructOptionsPanel(specCache.devastation)
		end

		PreservationConstructOptionsPanel(specCache.preservation)

		if TRB.Data.settings.core.experimental.specs.evoker.augmentation == true then
			AugmentationConstructOptionsPanel(specCache.augmentation)
		end
	end
	TRB.Options.Evoker.ConstructOptionsPanel = ConstructOptionsPanel
end