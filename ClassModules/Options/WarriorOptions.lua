local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 1 then --Only do this if we're on a Warrior!
	local L = TRB.Localization
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local passiveFrame = TRB.Frames.passiveFrame

	TRB.Options.Warrior = {}
	TRB.Options.Warrior.Arms = {}
	TRB.Options.Warrior.Fury = {}
	TRB.Options.Warrior.Protection = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.arms = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.fury = {}
	TRB.Frames.interfaceSettingsFrameContainer.controls.protection = {}

	--[[
		Arms Defaults
	]]

	local function ArmsLoadDefaultBarTextSimpleSettings()
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
				text="{$passive}[$passive+]{$casting}[$casting + ]{$passive}[$passive + ]$rage",
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
	TRB.Options.Warrior.ArmsLoadDefaultBarTextSimpleSettings = ArmsLoadDefaultBarTextSimpleSettings

	local function ArmsLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="#deepWounds $deepWoundsCount   $haste% ($gcd)||n{$rend}[#rend $rendCount   ][          ]{$ttd}[TTD: $ttd][ ]",
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
				text="{$suddenDeathTime}[#suddenDeath $suddenDeathTime #suddenDeath]",
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
				text="{$casting}[#casting$casting+]$rage",
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

	local function ArmsLoadDefaultSettings(includeBarText)
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
				execute = {
					enabled = true, -- 1
				},
				executeMinimum = {
					enabled = true, -- 2
				},
				executeMaximum = {
					enabled = true, -- 3
				},
				hamstring = {
					enabled = false -- 4
				},
				shieldBlock = {
					enabled = false, -- 5
				},
				slam = {
					enabled = true, -- 6
				},
				whirlwind = {
					enabled = true, -- 7
				},
				impendingVictory = {
					enabled = true, -- 8
				},
				thunderClap = {
					enabled = true -- 9
				},
				mortalStrike = {
					enabled = true, -- 10
				},
				rend = {
					enabled = true, -- 11
				},
				cleave = {
					enabled = true, -- 12
				},
				ignorePain = {
					enabled = true, -- 13
				}
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
					current="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FFEA3C53",
					overcap="FF800000",
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
					border="FFC21807",
					borderOvercap="FF800000",
					background="66000000",
					base="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FFEA3C53",
					overcapEnabled=true,
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
				suddenDeath={
					name = L["WarriorAudioSuddenDeathProc"],
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
				textureLock=true
			}
		}

		if includeBarText then
			settings.displayText.barText = ArmsLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	--[[
		Fury Defaults
	]]

	
	local function FuryLoadDefaultBarTextSimpleSettings()
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
				text="{$enrageTime}[$enrageTime sec]",
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$rage",
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
	TRB.Options.Warrior.FuryLoadDefaultBarTextSimpleSettings = FuryLoadDefaultBarTextSimpleSettings

	local function FuryLoadDefaultBarTextAdvancedSettings()
		---@type TRB.Classes.DisplayTextEntry[]
		local textSettings = {
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionLeft"],
				guid=TRB.Functions.String:Guid(),
				text="$haste% ($gcd)||n{$ttd}[TTD: $ttd][ ]",
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
				text="{$enrageTime}[#enrage $enrageTime #enrage][ ]||n{$whirlwindStacks}[#whirlwind $whirlwindTime ($whirlwindStacks) #whirlwind]",
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
				text="{$ravagerRage}[#ravager$ravagerRage+]{$casting}[#casting$casting+]$rage",
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

	local function FuryLoadDefaultSettings(includeBarText)
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
				execute = {
					enabled = true, -- 1
				},
				executeMinimum = {
					enabled = true, -- 2
				},
				executeMaximum = {
					enabled = true, -- 3
				},
				hamstring = {
					enabled = false -- 4
				},
				shieldBlock = {
					enabled = false, -- 5
				},
				slam = {
					enabled = false, -- 6
				},
				impendingVictory = {
					enabled = true, -- 7
				},
				thunderClap = {
					enabled = false -- 8
				},
				rampage = {
					enabled = true, -- 9
				},
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
					current="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FFEA3C53",
					overcap="FF800000",
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
					border="FFC21807",
					borderOvercap="FF800000",
					background="66000000",
					base="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FFEA3C53",
					enrage="FFFFCC55",
					overcapEnabled=true,
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
				suddenDeath={
					name = L["WarriorAudioSuddenDeathProc"],
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
				textureLock=true
			}
		}

		if includeBarText then
			settings.displayText.barText = FuryLoadDefaultBarTextSimpleSettings()
		end

		return settings
	end

	local function LoadDefaultSettings(includeBarText)
		local settings = TRB.Options.LoadDefaultSettings()

		settings.warrior.arms = ArmsLoadDefaultSettings(includeBarText)
		settings.warrior.fury = FuryLoadDefaultSettings(includeBarText)
		return settings
	end
	TRB.Options.Warrior.LoadDefaultSettings = LoadDefaultSettings


	--[[

	Arms Option Menus

	]]

	local function ArmsConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.arms

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.arms
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["WarriorArmsFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.warrior.arms = ArmsLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["WarriorArmsFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ArmsLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["WarriorArmsFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ArmsLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextNarrowAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["WarriorArmsFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = ArmsLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.arms

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Warrior_Arms_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 1, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 1, 1, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], "notEmpty", false)

		yCoord = yCoord - 100
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"])

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_1_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
		f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], true, false)


		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceRage"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceRage"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
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

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
		f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.cleaveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_cleave", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cleaveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdCleave"])
		f.tooltip = L["WarriorArmsThresholdCleaveTooltip"]
		f:SetChecked(spec.thresholds.cleave.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cleave.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_execute", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdExecute"])
		f.tooltip = L["WarriorArmsThresholdExecuteTooltip"]
		f:SetChecked(spec.thresholds.execute.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.execute.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_executeMinimum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeMinimumThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdExecuteMinimum"])
		f.tooltip = L["WarriorArmsThresholdExecuteMinimumTooltip"]
		f:SetChecked(spec.thresholds.executeMinimum.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.executeMinimum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_executeMaximum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeMaximumThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdExecuteMaximum"])
		f.tooltip = L["WarriorArmsThresholdExecuteMaximumTooltip"]
		f:SetChecked(spec.thresholds.executeMaximum.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.executeMaximum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.hamstringThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_hamstring", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.hamstringThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdHamstring"])
		f.tooltip = L["WarriorArmsThresholdHamstringTooltip"]
		f:SetChecked(spec.thresholds.hamstring.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.hamstring.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ignorePainThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_ignorePain", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ignorePainThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdIgnorePain"])
		f.tooltip = L["WarriorArmsThresholdIgnorePainTooltip"]
		f:SetChecked(spec.thresholds.ignorePain.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ignorePain.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.impendingVictoryThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdImpendingVictory"])
		f.tooltip = L["WarriorArmsThresholdImpendingVictoryTooltip"]
		f:SetChecked(spec.thresholds.impendingVictory.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.impendingVictory.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.mortalStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_mortalStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mortalStrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdMortalStrike"])
		f.tooltip = L["WarriorArmsThresholdMortalStrikeTooltip"]
		f:SetChecked(spec.thresholds.mortalStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.mortalStrike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.rendThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_rend", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.rendThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdRend"])
		f.tooltip = L["WarriorArmsThresholdRendTooltip"]
		f:SetChecked(spec.thresholds.rend.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rend.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shieldBlockThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdShieldBlock"])
		f.tooltip = L["WarriorArmsThresholdShieldBlockTooltip"]
		f:SetChecked(spec.thresholds.shieldBlock.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shieldBlock.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.slamThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdSlam"])
		f.tooltip = L["WarriorArmsThresholdSlamTooltip"]
		f:SetChecked(spec.thresholds.slam.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.slam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.thunderClapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_thunderClap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thunderClapThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdThunderClap"])
		f.tooltip = L["WarriorArmsThresholdThunderClapTooltip"]
		f:SetChecked(spec.thresholds.thunderClap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.thunderClap.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.whirlwindThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_whirlwind", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.whirlwindThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdWhirlwind"])
		f.tooltip = L["WarriorArmsThresholdWhirlwindTooltip"]
		f:SetChecked(spec.thresholds.whirlwind.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.whirlwind.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], 130)

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.arms

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Warrior_Arms_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 1, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorTextColorsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerTextCurrent"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerTextPassive"], spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.overcaprageText = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.overcaprageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["WarriorCheckboxThresholdOverTooltip"]
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["WarriorCheckboxThresholdOvercapTooltip"]
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)


		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["DotChangeColorCheckbox"])
		f.tooltip = string.format(L["DotChangeColorCheckboxTooltip"], "$deepWoundsCount/$deepWoundsTime, $rendCount/$rendTime")
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

		title = L["WarriorRageDecimalPrecision"]
		controls.resourcePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 1, spec.resourcePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.resourcePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.resourcePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.arms

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Warrior_Arms_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 1, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceRage"]))
		f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceRage"])
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warrior_Arms_overcapAudio", parent)
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
		controls.checkBoxes.suddenDeathAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_suddenDeath_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.suddenDeathAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorAudioCheckboxSuddenDeath"])
		f.tooltip = L["WarriorAudioCheckboxSuddenDeathTooltip"]
		f:SetChecked(spec.audio.suddenDeath.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.suddenDeath.enabled = self:GetChecked()

			if spec.audio.suddenDeath.enabled then
				PlaySoundFile(spec.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.suddenDeathAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warrior_Arms_suddenDeath_Audio", parent)
		controls.dropDown.suddenDeathAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.suddenDeathAudio, oUi.dropdownWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.suddenDeathAudio, spec.audio.suddenDeath.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.suddenDeathAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.suddenDeathAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.suddenDeath.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.suddenDeathAudio:SetValue(newValue, newName)
			spec.audio.suddenDeath.sound = newValue
			spec.audio.suddenDeath.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.suddenDeathAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.arms
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Warrior_Arms_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 1, 1, yCoord, cache)
	end

	local function ArmsConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.arms or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.armsDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Arms", UIParent)
		interfaceSettingsFrame.armsDisplayPanel.name = L["WarriorArmsFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.armsDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.armsDisplayPanel, "ArmsL["Warrior"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.armsDisplayPanel)

		parent = interfaceSettingsFrame.armsDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorArmsFull"], oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.armsWarriorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_armsWarriorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.armsWarriorEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["WarriorArmsFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.warrior.arms)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.warrior.arms = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.armsWarriorEnabled, TRB.Data.settings.core.enabled.warrior.arms, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.armsWarriorEnabled, TRB.Data.settings.core.enabled.warrior.arms, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Warrior_Arms_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Warrior_Arms_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab2", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Warrior_Arms_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls

		ArmsConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		ArmsConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		ArmsConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		ArmsConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		ArmsConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	--[[

	Fury Option Menus

	]]

	local function FuryConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.fury

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.fury
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_Reset"] = {
			text = string.format(L["ResetBarDialog"], L["WarriorFuryFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				TRB.Data.settings.warrior.fury = FuryLoadDefaultSettings(true)
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextSimple"] = {
			text = string.format(L["ResetBarTextSimpleDialog"], L["WarriorFuryFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = FuryLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedFullDialog"], L["WarriorFuryFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = FuryLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextNarrowAdvanced"] = {
			text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["WarriorFuryFull"]),
			button1 = L["Yes"],
			button2 = L["No"],
			OnAccept = function()
				spec.displayText.barText = FuryLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.fury

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Warrior_Fury_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 1, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 1, 2, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], "notEmpty", false)

		yCoord = yCoord - 100
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"])

		yCoord = yCoord - 30
		controls.colors.enrage = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorFuryColorPickerEnrage"], spec.colors.bar.enrage, 250, 25, oUi.xCoord2, yCoord)
		f = controls.colors.enrage
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "enrage")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_2_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
		f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
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
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], true, false)

		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], L["ResourceRage"]), spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], L["ResourceRage"]), spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
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

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
		f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.executeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_execute", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdExecute"])
		f.tooltip = L["WarriorFuryThresholdExecuteTooltip"]
		f:SetChecked(spec.thresholds.execute.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.execute.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_executeMinimum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeMinimumThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdExecuteMinimum"])
		f.tooltip = L["WarriorFuryThresholdExecuteMinimumTooltip"]
		f:SetChecked(spec.thresholds.executeMinimum.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.executeMinimum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_executeMaximum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeMaximumThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdExecuteMaximum"])
		f.tooltip = L["WarriorFuryThresholdExecuteMaximumTooltip"]
		f:SetChecked(spec.thresholds.executeMaximum.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.executeMaximum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.hamstringThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_hamstring", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.hamstringThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdHamstring"])
		f.tooltip = L["WarriorFuryThresholdHamstringTooltip"]
		f:SetChecked(spec.thresholds.hamstring.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.hamstring.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.impendingVictoryThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdImpendingVictory"])
		f.tooltip = L["WarriorFuryThresholdImpendingVictoryTooltip"]
		f:SetChecked(spec.thresholds.impendingVictory.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.impendingVictory.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.rampageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_rampage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.rampageThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdRampage"])
		f.tooltip = L["WarriorFuryThresholdRampageTooltip"]
		f:SetChecked(spec.thresholds.rampage.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rampage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shieldBlockThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdShieldBlock"])
		f.tooltip = L["WarriorFuryThresholdShieldBlockTooltip"]
		f:SetChecked(spec.thresholds.shieldBlock.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shieldBlock.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.slamThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdSlam"])
		f.tooltip = L["WarriorFuryThresholdSlamTooltip"]
		f:SetChecked(spec.thresholds.slam.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.slam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.thunderClapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_thunderClap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thunderClapThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdThunderClap"])
		f.tooltip = L["WarriorFuryThresholdThunderClapTooltip"]
		f:SetChecked(spec.thresholds.thunderClap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.thunderClap.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], 130)

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.fury

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Warrior_Fury_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 1, 2, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorTextColorsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerTextCurrent"], spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerTextPassive"], spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.overcaprageText = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.overcaprageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["WarriorCheckboxThresholdOverTooltip"]
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
		f.tooltip = L["WarriorCheckboxThresholdOvercapTooltip"]
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
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

		title = L["WarriorRageDecimalPrecision"]
		controls.resourcePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 1, spec.resourcePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.resourcePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.resourcePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.fury

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		controls.buttons.exportButton_Warrior_Fury_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 1, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapAudioCheckbox"], L["ResourceRage"]))
		f.tooltip = string.format(L["OvercapAudioCheckboxTooltip"], L["ResourceRage"])
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warrior_Fury_overcapAudio", parent)
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
		controls.checkBoxes.suddenDeathAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_suddenDeath_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.suddenDeathAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["WarriorAudioCheckboxSuddenDeath"])
		f.tooltip = L["WarriorAudioCheckboxSuddenDeathTooltip"]
		f:SetChecked(spec.audio.suddenDeath.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.suddenDeath.enabled = self:GetChecked()

			if spec.audio.suddenDeath.enabled then
				PlaySoundFile(spec.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.suddenDeathAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warrior_Fury_suddenDeath_Audio", parent)
		controls.dropDown.suddenDeathAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.suddenDeathAudio, oUi.dropdownWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.suddenDeathAudio, spec.audio.suddenDeath.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.suddenDeathAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.suddenDeathAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.suddenDeath.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.suddenDeathAudio:SetValue(newValue, newName)
			spec.audio.suddenDeath.sound = newValue
			spec.audio.suddenDeath.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.suddenDeathAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.warrior.fury
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
		controls.buttons.exportButton_Warrior_Fury_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 1, 2, yCoord, cache)
	end

	local function FuryConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.fury or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.furyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Fury", UIParent)
		interfaceSettingsFrame.furyDisplayPanel.name = L["WarriorFuryFull"]
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.furyDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.furyDisplayPanel, L["WarriorFuryFull"])
		InterfaceOptions_AddCategory(interfaceSettingsFrame.furyDisplayPanel)

		parent = interfaceSettingsFrame.furyDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorFuryFull"], oUi.xCoord, yCoord-5)
	
		controls.checkBoxes.furyWarriorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_furyWarriorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.furyWarriorEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
		f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["WarriorFuryFull"])
		f:SetChecked(TRB.Data.settings.core.enabled.warrior.fury)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.warrior.fury = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.furyWarriorEnabled, TRB.Data.settings.core.enabled.warrior.fury, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.furyWarriorEnabled, TRB.Data.settings.core.enabled.warrior.fury, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Warrior_Fury_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Warrior_Fury_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab2", L["TabBarDisplay"], 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab3", L["TabFontText"], 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab4", L["TabAudioTracking"], 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab5", L["TabBarText"], 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab1", L["TabResetDefaults"], 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Warrior_Fury_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls

		FuryConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		FuryConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		FuryConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		FuryConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		FuryConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		ArmsConstructOptionsPanel(specCache.arms)
		FuryConstructOptionsPanel(specCache.fury)
	end
	TRB.Options.Warrior.ConstructOptionsPanel = ConstructOptionsPanel
end