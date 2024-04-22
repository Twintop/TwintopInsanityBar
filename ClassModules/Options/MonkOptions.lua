local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 10 then --Only do this if we're on a Monk!
	local L = TRB.Localization
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame

	TRB.Options.Monk = {}
	TRB.Options.Monk.Brewmaster = {}
	TRB.Options.Monk.Mistweaver = {}
	TRB.Options.Monk.Windwalker = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.brewmaster = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = {}


	-- Mistweaver
	local function MistweaverLoadDefaultBarTextSimpleSettings()
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
	TRB.Options.Monk.MistweaverLoadDefaultBarTextSimpleSettings = MistweaverLoadDefaultBarTextSimpleSettings

	local function MistweaverLoadDefaultBarTextAdvancedSettings()
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

	local function MistweaverLoadDefaultSettings(includeBarText)
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
					manaTea = {
						color = "FF00FFFF",
						enabled = true
					},
					vivaciousVivification = {
						color = "FF00FFBB",
						enabled = true
					},
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
			settings.displayText.barText = MistweaverLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function WindwalkerLoadDefaultBarTextSimpleSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="{$serenityTime}[$serenityTime sec]",
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
				text="{$danceOfChiJiTime}[$danceOfChiJiTime] {$motcCount}[#sck $motcCount | $motcMinTime]",
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
	TRB.Options.Monk.WindwalkerLoadDefaultBarTextSimpleSettings = WindwalkerLoadDefaultBarTextSimpleSettings
	
	local function WindwalkerLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="{$serenityTime}[#serenity $serenityTime #serenity]{$ttd}[||nTTD: $ttd]",
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
				text="{$danceOfChiJiTime}[$danceOfChiJiTime]{$motcCount}[||n#sck$motcCount - $motcMinTime#sck]",
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

	local function WindwalkerLoadDefaultSettings(includeBarText)
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
				cracklingJadeLightning = {
					enabled = false, -- 1
				},
				expelHarm = {
					enabled = true, -- 2
				},
				tigerPalm = {
					enabled = true, -- 3
				},
				vivify = {
					enabled = false, -- 4
				},
				detox = {
					enabled = false, -- 5
				},
				disable = {
					enabled = false, -- 6
				},
				paralysis = {
					enabled = false, -- 7
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
			endOfSerenity = {
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
						pandemic="FFFF00FF"
					}
				},
				bar = {
					border="FFFFD300",
					borderOvercap="FFFF0000",
					borderChiJi="FF00FF00",
					background="66000000",
					base="FFFFFF00",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF9F4500",
					serenity="FF00FF96",
					serenityEnd="FFFF0000",
					overcapEnabled=true,
				},
				comboPoints = {
					border="FF00FF98",
					background="66000000",
					base="FFB5FFEB",
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
				danceOfChiJi={
					name = L["MonkWindwalkerAudioDanceOfChiJi"],
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
			settings.displayText.barText = WindwalkerLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end
	
	local function LoadDefaultSettings(includeBarText)
		local settings = TRB.Options.LoadDefaultSettings()

		settings.monk.mistweaver = MistweaverLoadDefaultSettings(includeBarText)
		settings.monk.windwalker = WindwalkerLoadDefaultSettings(includeBarText)

		return settings
	end
	TRB.Options.Monk.LoadDefaultSettings = LoadDefaultSettings
	


	--[[

	Mistweaver Option Menus

	]]

	local function MistweaverConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.mistweaver

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["MonkMistweaverFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.monk.mistweaver = MistweaverLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["MonkMistweaverFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = MistweaverLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["MonkMistweaverFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = MistweaverLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[
		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextNarrowAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["MonkMistweaverFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = MistweaverLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Mistweaver_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 10, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 10, 2, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"], "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"])

		yCoord = yCoord - 30
		controls.checkBoxes.vivaciousVivification = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_vivaciousVivification", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.vivaciousVivification
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxVivify"])
		f.tooltip = L["MonkMistweaverCheckboxVivifyTooltip"]
		f:SetChecked(spec.colors.bar.vivaciousVivification.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.vivaciousVivification.enabled = self:GetChecked()
		end)

		controls.colors.vivaciousVivification = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerVivify"], spec.colors.bar.vivaciousVivification.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.vivaciousVivification
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "vivaciousVivification")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
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
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 10, 2, yCoord, L["ResourceMana"], false, true)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTeaBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Border_Option_manaTeaBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTeaBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkMistweaverCheckboxManaTea"])
		f.tooltip = L["MonkMistweaverCheckboxManaTeaTooltip"]
		f:SetChecked(spec.colors.bar.manaTea.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.manaTea.enabled = self:GetChecked()
		end)

		controls.colors.manaTea = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkMistweaverColorPickerManaTea"], spec.colors.bar.manaTea.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.manaTea
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "manaTea")
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 10, 2, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 10, 2, yCoord)
	end

	local function MistweaverConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Mistweaver_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 10, 2, yCoord)

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
	
		--[[
		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "")
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
		]]

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
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Mistweaver_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 10, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Monk_Mistweaver_Innervate_Audio", parent)
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
		controls.checkBoxes.blessingOfWinterRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_BlessingOfWinterMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.blessingOfWinterRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackBlessingOfWinter"])
		f.tooltip = L["HealerCheckboxTrackBlessingOfWinterTooltip"]
		f:SetChecked(spec.passiveGeneration.blessingOfWinter)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.blessingOfWinter = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackInnervate"])
		f.tooltip = L["HealerCheckboxTrackInnervateTooltip"]
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackManaTideTotem"])
		f.tooltip = L["HealerCheckboxTrackManaTideTotemTooltip"]
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["HealerCheckboxTrackSymbolOfHope"])
		f.tooltip = L["HealerCheckboxTrackSymbolOfHopeTooltip"]
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.mistweaver
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Monk_Mistweaver_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 10, 2, yCoord, cache)
	end

	local function MistweaverConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.mistweaver or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.mistweaverDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Mistweaver", UIParent)
		interfaceSettingsFrame.mistweaverDisplayPanel.name = L["MonkMistweaverFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.mistweaverDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.mistweaverDisplayPanel, L["MonkMistweaver"] .. "L["Monk"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.mistweaverDisplayPanel)

		parent = interfaceSettingsFrame.mistweaverDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkMistweaverFull"], oUi.xCoord, yCoord-5)	
		
		controls.checkBoxes.mistweaverMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_mistweaverMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mistweaverMonkEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["MonkMistweaverFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.monk.mistweaver)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.monk.mistweaver = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.mistweaverMonkEnabled, TRB.Data.settings.core.enabled.monk.mistweaver, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.mistweaverMonkEnabled, TRB.Data.settings.core.enabled.monk.mistweaver, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Monk_Mistweaver_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Monk_Mistweaver_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkMistweaverFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab1", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Monk_Mistweaver_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls

		MistweaverConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		MistweaverConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		MistweaverConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		MistweaverConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		MistweaverConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	--[[

	Windwalker Option Menus

	]]

	local function WindwalkerConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.windwalker

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["MonkWindwalkerFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.monk.windwalker = WindwalkerLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["MonkWindwalkerFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = WindwalkerLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["MonkWindwalkerFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = WindwalkerLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Windwalker_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 10, 3, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 10, 3, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], L["ResourceChi"])

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 10, 3, yCoord, true, L["ResourceChi"])

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"])

		yCoord = yCoord - 30
		controls.colors.serenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerSerenity"], spec.colors.bar.serenity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.serenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "serenity")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfSerenity = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Checkbox_EOS", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfSerenity
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxSerenityEnd"])
		f.tooltip = L["MonkWindwalkerCheckboxSerenityEndTooltip"]
		f:SetChecked(spec.endOfSerenity.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfSerenity.enabled = self:GetChecked()
		end)

		controls.colors.serenityEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerSerenityEnd"], spec.colors.bar.serenityEnd, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.serenityEnd
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "serenityEnd")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
		f.tooltip = L["ShowCastingBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerCasting"], spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 3)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
		f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], true, false)

		yCoord = yCoord - 30
		controls.colors.borderChiJi = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MonkWindwalkerColorPickerDanceOfChiJi"], spec.colors.bar.borderChiJi, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderChiJi
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderChiJi")
		end)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ChiColorsHeader"], oUi.xCoord, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceChi"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ChiColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ChiCheckboxUseHighestForAll"])
		f.tooltip = L["ChiCheckboxUseHighestForAllTooltip"]
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
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

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
		f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)
		
		controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
		yCoord = yCoord - 20
		controls.checkBoxes.expelHarmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_expelHarm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.expelHarmThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxExpelHarm"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxExpelHarmTooltip"]
		f:SetChecked(spec.thresholds.expelHarm.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.expelHarm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.tigerPalmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_tigerPalm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.tigerPalmThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxTigerPalm"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxTigerPalmTooltip"]
		f:SetChecked(spec.thresholds.tigerPalm.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.tigerPalm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.cracklingJadeLightningThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_cracklingJadeLightning", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cracklingJadeLightningThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxCracklingJadeLightning"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxCracklingJadeLightningTooltip"]
		f:SetChecked(spec.thresholds.cracklingJadeLightning.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cracklingJadeLightning.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.detoxThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_detox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.detoxThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxDetox"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxDetoxTooltip"]
		f:SetChecked(spec.thresholds.detox.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.detox.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.disableThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_disable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.disableThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxDisable"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxDisableTooltip"]
		f:SetChecked(spec.thresholds.disable.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.disable.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.paralysisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_paralysis", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.paralysisThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxParalysis"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxParalysisTooltip"]
		f:SetChecked(spec.thresholds.paralysis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.paralysis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.vivifyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_vivify", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.vivifyThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerThresholdCheckboxVivify"])
		f.tooltip = L["MonkWindwalkerThresholdCheckboxVivifyTooltip"]
		f:SetChecked(spec.thresholds.vivify.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.vivify.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 3, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkWindwalkerHeaderEndOfSerenityConfiguration"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfSerenityModeGCDs = CreateFrame("CheckButton", "TRB_EOFV_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfSerenityModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxSerenityGcds"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfSerenity.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfSerenityModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfSerenityModeTime:SetChecked(false)
			spec.endOfSerenity.mode = "gcd"
		end)

		title = L["MonkWindwalkerSerenityGcds"]
		controls.endOfSerenityGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfSerenity.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfSerenityGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfSerenity.gcdsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.endOfSerenityModeTime = CreateFrame("CheckButton", "TRB_EOFV_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfSerenityModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxSerenityTime"])
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.endOfSerenity.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfSerenityModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfSerenityModeTime:SetChecked(true)
			spec.endOfSerenity.mode = "time"
		end)

		title = L["MonkWindwalkerSerenityTime"]
		controls.endOfSerenityTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfSerenity.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfSerenityTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfSerenity.timeMax = value
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 10, 3, yCoord, L["ResourceEnergy"], 150)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Windwalker_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 10, 3, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 10, 3, yCoord)

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

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["CheckboxThresholdOverTooltip"]
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["CheckboxThresholdOvercapTooltip"]
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkWindwalkerMarkOfTheCraneTrackingHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxMarkOfTheCraneTracking"])
		f.tooltip = L["MonkWindwalkerCheckboxMarkOfTheCraneTrackingTooltip"]
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 10, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Monk_Windwalker_overcapAudio", parent)
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
		controls.checkBoxes.danceOfChiJiAudio = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_danceOfChiJi_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.danceOfChiJiAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["MonkWindwalkerCheckboxDanceOfChiJi"])
		f.tooltip = L["MonkWindwalkerCheckboxDanceOfChiJiTooltip"]
		f:SetChecked(spec.audio.danceOfChiJi.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.danceOfChiJi.enabled = self:GetChecked()

			if spec.audio.danceOfChiJi.enabled then
				PlaySoundFile(spec.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.danceOfChiJiAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Monk_Windwalker_danceOfChiJi_Audio", parent)
		controls.dropDown.danceOfChiJiAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.danceOfChiJiAudio, oUi.dropdownWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.danceOfChiJiAudio, spec.audio.danceOfChiJi.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.danceOfChiJiAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.danceOfChiJiAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.danceOfChiJi.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.danceOfChiJiAudio:SetValue(newValue, newName)
			spec.audio.danceOfChiJi.sound = newValue
			spec.audio.danceOfChiJi.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.danceOfChiJiAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PassiveEntryRegenerationHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxTrackEnergyRegen"])
		f.tooltip = L["CheckboxTrackEnergyRegenTooltip"]
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_GCD", parent, "UIRadioButtonTemplate")
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
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_TIME", parent, "UIRadioButtonTemplate")
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end
	
	local function WindwalkerConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.monk.windwalker
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Monk_Windwalker_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 10, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 10, 3, yCoord, cache)
	end

	local function WindwalkerConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.windwalker or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.windwalkerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Windwalker", UIParent)
		interfaceSettingsFrame.windwalkerDisplayPanel.name = L["MonkWindwalkerFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.windwalkerDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.windwalkerDisplayPanel, L["MonkWindwalkerFull"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.windwalkerDisplayPanel)

		parent = interfaceSettingsFrame.windwalkerDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MonkWindwalkerFull"], oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.windwalkerMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_windwalkerMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.windwalkerMonkEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["MonkWindwalkerFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.monk.windwalker)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.monk.windwalker = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Monk_Windwalker_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Monk_Windwalker_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MonkWindwalkerFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 10, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab2", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do 
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Monk_Windwalker_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls

		WindwalkerConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		WindwalkerConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		WindwalkerConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		WindwalkerConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		WindwalkerConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		MistweaverConstructOptionsPanel(specCache.mistweaver)
		WindwalkerConstructOptionsPanel(specCache.windwalker)
	end
	TRB.Options.Monk.ConstructOptionsPanel = ConstructOptionsPanel
end