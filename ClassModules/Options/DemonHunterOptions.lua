local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 12 then --Only do this if we're on a DemonHunter!
	local L = TRB.Localization
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi

	local barContainerFrame = TRB.Frames.barContainerFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame

	TRB.Options.DemonHunter = {}
	TRB.Options.DemonHunter.Havoc = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = {}

	local function HavocLoadDefaultBarTextSimpleSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="{$ucTime}[$ucTime]",
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
				text="{$metamorphosisTime}[$metamorphosisTime]",
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
				text="{$passive}[$passive + ]{$casting}[$casting + ]$fury",
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
	TRB.Options.DemonHunter.HavocLoadDefaultBarTextSimpleSettings = HavocLoadDefaultBarTextSimpleSettings

	local function HavocLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="{$ttd}[TTD: $ttd]",
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
				text="{$metamorphosisTime}[#metamorphosis $metamorphosisTime #metamorphosis]",
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
				text="{$tacticalRetreatFury}[#tacticalRetreat$tacticalRetreatFury+]{$bhFury}[#bh$bhFury+]{$casting}[#casting$casting+]$fury",
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

	local function HavocLoadDefaultSettings(includeBarText)
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
					relativeTo = "TOP",
					relativeToName = L["PositionAbove"],
					enabled=true,
					desaturated=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				annihilation = {
					enabled = true, -- 1
				},
				bladeDance = {
					enabled = true, -- 2
				},
				chaosNova = {
					enabled = true, -- 3
				},
				chaosStrike = {
					enabled = true, -- 4
				},
				deathSweep = {
					enabled = true, -- 5
				},
				eyeBeam = {
					enabled = true, -- 6
				},
				-- Talents
				glaiveTempest = {
					enabled = true, -- 7
				},
				felEruption = {
					enabled = true, -- 8
				},
				throwGlaive = {
					enabled = true, -- 9
				},
				felBarrage = {
					enabled = true, -- 10
				}
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfMetamorphosis = {
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
					current="FFC942FD",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF660066",
					overcap="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
				},
				bar = {
					border="FFA330C9",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFC942FD",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF660066",
					metamorphosis="FF67F100",
					metamorphosisEnding="FFFF0000",
					overcapEnabled=true,
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
			settings.displayText.barText = HavocLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function VengeanceLoadDefaultBarTextSimpleSettings()
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
				text="{$metamorphosisTime}[$metamorphosisTime]",
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
				text="{$passive}[$passive + ]{$casting}[$casting + ]$fury",
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
	TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSimpleSettings = VengeanceLoadDefaultBarTextSimpleSettings

	local function VengeanceLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="{$ttd}[TTD: $ttd]",
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
				text="{$metamorphosisTime}[#metamorphosis $metamorphosisTime #metamorphosis]",
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
				text="{$iaFury}[#ia$iaFury+]{$casting}[#casting$casting+]$fury",
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

	local function VengeanceLoadDefaultSettings(includeBarText)
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
				soulCleave = {
					enabled = true, -- 1
				},
				chaosNova = {
					enabled = true, -- 2
				},
				-- Talents
				felDevastation = {
					enabled = true, -- 4
				},
				spiritBomb = {
					enabled = true, -- 5
				},
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfMetamorphosis = {
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
					current="FFC942FD",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF660066",
					overcap="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
				},
				bar = {
					border="FFA330C9",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFC942FD",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF660066",
					metamorphosis="FF67F100",
					metamorphosisEnding="FFFF0000",
					overcapEnabled=true,
				},
				comboPoints = {
					border="FF660088",
					background="66000000",
					base="FFC942FD",
					penultimate="FFFF9900",
					final="FFFF0000",
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
			settings.displayText.barText = VengeanceLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function LoadDefaultSettings(includeBarText)
		local settings = TRB.Options.LoadDefaultSettings()

		settings.demonhunter.havoc = HavocLoadDefaultSettings(includeBarText)
		settings.demonhunter.vengeance = VengeanceLoadDefaultSettings(includeBarText)
		return settings
	end
	TRB.Options.DemonHunter.LoadDefaultSettings = LoadDefaultSettings

	--[[

	Havoc Option Menus

	]]

	local function HavocConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.havoc
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["DemonHunterHavoc"], L["DemonHunter"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.demonhunter.havoc = HavocLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["DemonHunterHavoc"], L["DemonHunter"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = HavocLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedDialog"], L["DemonHunterHavoc"], L["DemonHunter"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = HavocLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Bar Display).", 12, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 12, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 12, 1, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 12, 1, yCoord, "Fury", "notEmpty", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 12, 1, yCoord, "Fury")

		yCoord = yCoord - 30
		controls.colors.metamorphosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury while Metamorphosis is active", spec.colors.bar.metamorphosis, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.metamorphosis
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosis")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_EndOfMetamorphosisCheckbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosis
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Metamorphosis")
		f.tooltip = "Changes the bar color when Metamorphosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfMetamorphosis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfMetamorphosis.enabled = self:GetChecked()
		end)

		controls.colors.metamorphosisEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury when Metamorphosis is ending", spec.colors.bar.metamorphosisEnding, 250, 25, oUi.xCoord2, yCoord)
		f = controls.colors.metamorphosisEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury gain from Eye Beam with Blind Fury", spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury gain from Passive Sources", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 12, 1, yCoord, "Fury", true, false)

		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Ability Threshold Lines", oUi.xCoord, yCoord)
		
		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Under minimum required Fury threshold line", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Over minimum required Fury threshold line", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Chaos Theory effect up", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.bladeDanceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_bladeDance", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.bladeDanceThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Blade Dance / Death Sweep")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Blade Dance. Shows for Death Sweep while in Demon Form."
		f:SetChecked(spec.thresholds.bladeDance.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.bladeDance.enabled = self:GetChecked()
			spec.thresholds.deathSweep.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chaosNovaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosNova", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chaosNovaThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chaos Nova (no Unleashed Power)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Chaos Nova. Only shown if Unleashed Power is not talented."
		f:SetChecked(spec.thresholds.chaosNova.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chaosNova.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chaosStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chaosStrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chaos Strike / Annihilation")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Chaos Strike. Shows for Annihilation while in Demon Form."
		f:SetChecked(spec.thresholds.chaosStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chaosStrike.enabled = self:GetChecked()
			spec.thresholds.annihilation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.eyeBeamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_eyeBeam", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.eyeBeamThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Eye Beam")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Eye Beam."
		f:SetChecked(spec.thresholds.eyeBeam.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.eyeBeam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.felBarrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_felBarrage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.felBarrageThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fel Barrage")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Fel Barrage. Only visible if talented into Fel Barrage."
		f:SetChecked(spec.thresholds.felBarrage.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.felBarrage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.felEruptionVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_felEruption", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.felEruptionVictoryThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fel Eruption")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Fel Eruption. Only visible if talented into Fel Eruption."
		f:SetChecked(spec.thresholds.felEruption.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.felEruption.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.glaiveTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_glaiveTempest", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.glaiveTempestThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Glaive Tempest")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Glaive Tempest. Only visible if talented into Glaive Tempest."
		f:SetChecked(spec.thresholds.glaiveTempest.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.glaiveTempest.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.throwGlaiveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_throwGlaive", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.throwGlaiveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Throw Glaive (Furious Throws)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Throw Glaive. Only visible if talented into Furious Throws."
		f:SetChecked(spec.thresholds.throwGlaive.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.throwGlaive.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 1, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "End of Metamorphosis Configuration", oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Metamorphosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Metamorphosis ends."
		if spec.endOfMetamorphosis.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(false)
			spec.endOfMetamorphosis.mode = "gcd"
		end)

		title = "Metamorphosis GCDs - 0.75sec Floor"
		controls.endOfMetamorphosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfMetamorphosis.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Metamorphosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Metamorphosis ends."
		if spec.endOfMetamorphosis.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(true)
			spec.endOfMetamorphosis.mode = "time"
		end)

		title = "Metamorphosis Time Remaining (sec)"
		controls.endOfMetamorphosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfMetamorphosis.timeMax = value
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 12, 1, yCoord, "Fury", 120)

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Havoc_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Font & Text).", 12, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 12, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Fury Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Fury", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Fury", spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Have enough Fury to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Overcapping Fury", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when your next builder ability will result in overcapping maximum Fury."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Audio & Tracking).", 12, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Fury")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Fury."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_DemonHunter_Havoc_overcapAudio", parent)
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_DemonHunter_Havoc_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Bar Text).", 12, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 12, 1, yCoord, cache)
	end

	local function HavocConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.havoc or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.havocDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Havoc", UIParent)
		interfaceSettingsFrame.havocDisplayPanel.name = "Havoc Demon Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.havocDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.havocDisplayPanel, "Havoc Demon Hunter")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.havocDisplayPanel)
		
		parent = interfaceSettingsFrame.havocDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Havoc Demon Hunter", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.havocDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_havocDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.havocDemonHunterEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Havoc Demon Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.havoc)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.demonhunter.havoc = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_DemonHunter_Havoc_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (All).", 12, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_DemonHunter_Havoc_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls

		HavocConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		HavocConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		HavocConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		HavocConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		HavocConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--[[

	Vengeance Option Menus

	]]

	local function VengeanceConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.vengeance

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["DemonHunterVengeance"], L["DemonHunter"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.demonhunter.vengeance = VengeanceLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["DemonHunterVengeance"], L["DemonHunter"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = VengeanceLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedDialog"], L["DemonHunterVengeance"], L["DemonHunter"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = VengeanceLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Vengeance_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls
	end

	local function VengeanceConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.vengeance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.vengeance
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Vengeance_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Vengeance_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Vengeance Demon Hunter (Bar Display).", 12, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 12, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 12, 2, yCoord, POWER_TYPE_FURY, "Soul Fragments")

		yCoord = yCoord - 60
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 12, 2, yCoord, true, "Soul Fragments")

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 12, 2, yCoord, "Fury", "notEmpty", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 12, 2, yCoord, "Fury")

		yCoord = yCoord - 30
		controls.colors.metamorphosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury while Metamorphosis is active", spec.colors.bar.metamorphosis, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.metamorphosis
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosis")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_EndOfMetamorphosisCheckbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosis
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Metamorphosis")
		f.tooltip = "Changes the bar color when Metamorphosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfMetamorphosis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfMetamorphosis.enabled = self:GetChecked()
		end)

		controls.colors.metamorphosisEnding = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury when Metamorphosis is ending", spec.colors.bar.metamorphosisEnding, 250, 25, oUi.xCoord2, yCoord)
		f = controls.colors.metamorphosisEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Fury gain from Passive Sources", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 12, 2, yCoord, "Fury", true, false)

		yCoord = yCoord - 40
		controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Soul Fragment Colors", oUi.xCoord, yCoord)
		
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, POWER_TYPE_FURY, spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Soul Fragment's border", spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30
		controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Penultimate Soul Fragment", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Final Soul Fragment", spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Soul Fragment color for all?")
		f.tooltip = "When checked, the highest Soul Fragment's color will be used for all Soul Fragments. E.g., if you have maximum 5 Soul Fragments and currently have 4, the Penultimate color will be used for all Soul Fragments instead of just the second to last."
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)

		controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled Soul Fragment background", spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Ability Threshold Lines", oUi.xCoord, yCoord)
		
		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Under minimum required Fury threshold line", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Over minimum required Fury threshold line", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.special = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Soul Fragments effect up", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.chaosNovaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_chaosNova", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chaosNovaThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chaos Nova")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Chaos Nova."
		f:SetChecked(spec.thresholds.chaosNova.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chaosNova.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.felDevastationThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_felDevastation", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.felDevastationThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fel Devastation")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Fel Devastation. Only visible if talented."
		f:SetChecked(spec.thresholds.felDevastation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.felDevastation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.soulCleaveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_soulCleave", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.soulCleaveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Soul Cleave")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Soul Cleave."
		f:SetChecked(spec.thresholds.soulCleave.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.soulCleave.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.spiritBombThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_Threshold_Option_spiritBomb", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spiritBombThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Spirit Bomb")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Spirit Bomb."
		f:SetChecked(spec.thresholds.spiritBomb.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.spiritBomb.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 100
		yCoord = yCoord - 30

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 2, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "End of Metamorphosis Configuration", oUi.xCoord, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Metamorphosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Metamorphosis ends."
		if spec.endOfMetamorphosis.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(false)
			spec.endOfMetamorphosis.mode = "gcd"
		end)

		title = "Metamorphosis GCDs - 0.75sec Floor"
		controls.endOfMetamorphosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfMetamorphosis.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Metamorphosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Metamorphosis ends."
		if spec.endOfMetamorphosis.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(true)
			spec.endOfMetamorphosis.mode = "time"
		end)

		title = "Metamorphosis Time Remaining (sec)"
		controls.endOfMetamorphosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfMetamorphosis.timeMax = value
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 12, 2, yCoord, "Fury", 120)

		TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls
	end

	local function VengeanceConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.vengeance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.vengeance
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Vengeance_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Vengeance_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Vengeance Demon Hunter (Font & Text).", 12, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 12, 2, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Fury Text Colors", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Fury", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Fury", spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Have enough Fury to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Overcapping Fury", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when your next builder ability will result in overcapping maximum Fury."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls
	end

	local function VengeanceConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.vengeance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.vengeance
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Vengeance_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Vengeance_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Vengeance Demon Hunter (Audio & Tracking).", 12, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Fury")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Fury."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_DemonHunter_Vengeance_overcapAudio", parent)
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls
	end

	local function VengeanceConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.vengeance
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.vengeance
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", oUi.xCoord, yCoord)
		controls.buttons.exportButton_DemonHunter_Vengeance_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Vengeance_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Vengeance Demon Hunter (Bar Text).", 12, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 12, 2, yCoord, cache)
	end

	local function VengeanceConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.vengeance or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.vengeanceDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Vengeance", UIParent)
		interfaceSettingsFrame.vengeanceDisplayPanel.name = "Vengeance Demon Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.vengeanceDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.vengeanceDisplayPanel, "Vengeance Demon Hunter")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.vengeanceDisplayPanel)
		
		parent = interfaceSettingsFrame.vengeanceDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Vengeance Demon Hunter", oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.vengeanceDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Vengeance_vengeanceDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.vengeanceDemonHunterEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Vengeance Demon Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.vengeance)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.demonhunter.vengeance = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.vengeanceDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.vengeance, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.vengeanceDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.vengeance, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_DemonHunter_Vengeance_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_DemonHunter_Vengeance_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Vengeance Demon Hunter (All).", 12, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Vengeance_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Vengeance_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Vengeance_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Vengeance_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_DemonHunter_Vengeance_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_DemonHunter_Vengeance_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.vengeance = controls

		VengeanceConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		VengeanceConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		VengeanceConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		VengeanceConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		VengeanceConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	
	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		HavocConstructOptionsPanel(specCache.havoc)
		VengeanceConstructOptionsPanel(specCache.vengeance)
	end
	TRB.Options.DemonHunter.ConstructOptionsPanel = ConstructOptionsPanel
end