local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 1 then --Only do this if we're on a Warrior!
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local leftTextFrame = TRB.Frames.leftTextFrame
	local middleTextFrame = TRB.Frames.middleTextFrame
	local rightTextFrame = TRB.Frames.rightTextFrame

	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

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
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$passive}[$passive+]{$casting}[$casting + ]{$passive}[$passive + ]$rage",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function ArmsLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "#deepWounds $deepWoundsCount   $haste% ($gcd)||n{$rend}[#rend $rendCount   ][          ]{$ttd}[TTD: $ttd][ ]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$suddenDeathTime}[#suddenDeath $suddenDeathTime #suddenDeath]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$ravagerRage}[#ravager$ravagerRage+]{$covenantRage}[#covenantAbility$covenantRage+]{$casting}[#casting$casting+]$rage",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function ArmsLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			ragePrecision=0,
			overcapThreshold=100,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				execute = {
					enabled = true, -- 1
				},
				ignorePain = {
					enabled = true, -- 2
				},
				shieldBlock = {
					enabled = false, -- 3
				},
				slam = {
					enabled = true, -- 4
				},
				whirlwind = {
					enabled = true, -- 5
				},
				mortalStrike = {
					enabled = true, -- 6
				},
				impendingVictory = {
					enabled = true, -- 7
				},
				rend = {
					enabled = true, -- 8
				},
				cleave = {
					enabled = true, -- 9
				},
				condemn = {
					enabled = true, -- 10
				},
				executeMinimum = {
					enabled = true, -- 11
				},
				executeMaximum = {
					enabled = true, -- 12
				},
				condemnMinimum = {
					enabled = true, -- 13
				},
				condemnMaximum = {
					enabled = true, -- 14
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
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF",
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
					unusable="FFFF0000"
				}
			},
			displayText = {},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				suddenDeath={
					name = "Sudden Death Proc",
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
				textureLock=true
			}
		}

		settings.displayText = ArmsLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function ArmsResetSettings()
		local settings = ArmsLoadDefaultSettings()
		return settings
	end


	--[[
		Fury Defaults
	]]

	
	local function FuryLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="{$enrageTime}[$enrageTime sec]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$passive}[$passive+]{$casting}[$casting + ]{$passive}[$passive + ]$rage",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function FuryLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "$haste% ($gcd)||n{$ttd}[TTD: $ttd][ ]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$enrageTime}[#enrage $enrageTime #enrage][ ]||n{$whirlwindStacks}[#whirlwind $whirlwindTime ($whirlwindStacks) #whirlwind]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$covenantRage}[#covenantAbility$covenantRage+]{$casting}[#casting$casting+]$rage",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function FuryLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			ragePrecision=0,
			overcapThreshold=100,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				ignorePain = {
					enabled = true, -- 1
				},
				shieldBlock = {
					enabled = false, -- 2
				},
				slam = {
					enabled = false, -- 3
				},
				rampage = {
					enabled = true, -- 4
				},
				impendingVictory = {
					enabled = true, -- 5
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
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF",
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
					unusable="FFFF0000"
				}
			},
			displayText = {},
			audio = {
				overcap={
					name = "Overcap",
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
				textureLock=true
			}
		}

		settings.displayText = FuryLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function FuryResetSettings()
		local settings = FuryLoadDefaultSettings()
		return settings
	end


    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		settings.warrior.arms = ArmsLoadDefaultSettings()
		settings.warrior.fury = FuryLoadDefaultSettings()
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

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.arms
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Arms Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.arms = ArmsResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Arms Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.arms.displayText = ArmsLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Arms Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.arms.displayText = ArmsLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Arms Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.arms.displayText = ArmsLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.warrior.arms.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.arms.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.warrior.arms)

		controls.buttons.exportButton_Warrior_Arms_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Bar Display).", 1, 1, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.warrior.arms.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.bar.width = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetWidth(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.warrior.arms.bar.width)
				resourceFrame:SetWidth(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				castingFrame:SetWidth(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				passiveFrame:SetWidth(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.warrior.arms)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["rage"] ~= nil and TRB.Data.spells[k]["rage"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.warrior.arms.thresholds.width, -TRB.Data.spells[k]["rage"], TRB.Data.character.maxResource)
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.arms.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.arms.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.arms.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			TRB.Functions.UpdateBarWidth(TRB.Data.settings.warrior.arms)
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.warrior.arms.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.bar.height = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetHeight(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				barBorderFrame:SetHeight(TRB.Data.settings.warrior.arms.bar.height)
				resourceFrame:SetHeight(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetHeight(value)
				end

				castingFrame:SetHeight(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				passiveFrame:SetHeight(value-(TRB.Data.settings.warrior.arms.bar.border*2))
				leftTextFrame:SetHeight(TRB.Data.settings.warrior.arms.bar.height * 3.5)
				middleTextFrame:SetHeight(TRB.Data.settings.warrior.arms.bar.height * 3.5)
				rightTextFrame:SetHeight(TRB.Data.settings.warrior.arms.bar.height * 3.5)
			end

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.arms.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.arms.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.arms.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			TRB.Functions.UpdateBarHeight(TRB.Data.settings.warrior.arms)
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.warrior.arms.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.bar.xPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.warrior.arms.bar.xPos, TRB.Data.settings.warrior.arms.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.warrior.arms.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.bar.yPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.warrior.arms.bar.xPos, TRB.Data.settings.warrior.arms.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.warrior.arms.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.bar.border = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetWidth(TRB.Data.settings.warrior.arms.bar.width-(TRB.Data.settings.warrior.arms.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.warrior.arms.bar.height-(TRB.Data.settings.warrior.arms.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.warrior.arms.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.warrior.arms.bar.height)
				if TRB.Data.settings.warrior.arms.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.warrior.arms.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.warrior.arms.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.warrior.arms.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.warrior.arms)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["rage"] ~= nil and TRB.Data.spells[k]["rage"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.warrior.arms.thresholds.width, -TRB.Data.spells[k]["rage"], TRB.Data.character.maxResource)
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.warrior.arms.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.warrior.arms.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.warrior.arms)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 10, TRB.Data.settings.warrior.arms.thresholds.width, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.thresholds.width = value

			if GetSpecialization() == 1 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.warrior.arms.thresholds.width)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.warrior.arms.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.arms.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.arms.bar.dragAndDrop)
		end)

		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay = self:GetChecked()

			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.arms.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.warrior.arms.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.arms.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.warrior.arms, TRB.Frames.barContainerFrame)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_RageBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.warrior.arms.textures.resourceBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.resourceBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.resourceBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.arms.textures.resourceBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.resourceBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.textures.resourceBar = newValue
			TRB.Data.settings.warrior.arms.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.warrior.arms.textures.textureLock then
				TRB.Data.settings.warrior.arms.textures.castingBar = newValue
				TRB.Data.settings.warrior.arms.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.warrior.arms.textures.passiveBar = newValue
				TRB.Data.settings.warrior.arms.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.resourceBar)
				if TRB.Data.settings.warrior.arms.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.warrior.arms.textures.castingBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.castingBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.castingBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.arms.textures.castingBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.castingBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.textures.castingBar = newValue
			TRB.Data.settings.warrior.arms.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.warrior.arms.textures.textureLock then
				TRB.Data.settings.warrior.arms.textures.resourceBar = newValue
				TRB.Data.settings.warrior.arms.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.warrior.arms.textures.passiveBar = newValue
				TRB.Data.settings.warrior.arms.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.castingBar)
				if TRB.Data.settings.warrior.arms.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.warrior.arms.textures.passiveBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.passiveBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.passiveBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.arms.textures.passiveBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.passiveBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.textures.passiveBar = newValue
			TRB.Data.settings.warrior.arms.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.warrior.arms.textures.textureLock then
				TRB.Data.settings.warrior.arms.textures.resourceBar = newValue
				TRB.Data.settings.warrior.arms.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.warrior.arms.textures.castingBar = newValue
				TRB.Data.settings.warrior.arms.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.passiveBar)
				if TRB.Data.settings.warrior.arms.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.warrior.arms.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.warrior.arms.textures.textureLock then
				TRB.Data.settings.warrior.arms.textures.passiveBar = TRB.Data.settings.warrior.arms.textures.resourceBar
				TRB.Data.settings.warrior.arms.textures.passiveBarName = TRB.Data.settings.warrior.arms.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.warrior.arms.textures.passiveBarName)
				TRB.Data.settings.warrior.arms.textures.castingBar = TRB.Data.settings.warrior.arms.textures.resourceBar
				TRB.Data.settings.warrior.arms.textures.castingBarName = TRB.Data.settings.warrior.arms.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.warrior.arms.textures.castingBarName)

				if GetSpecialization() == 1 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.arms.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.warrior.arms.textures.borderName)
		UIDropDownMenu_JustifyText(controls.dropDown.borderTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.borderTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("border")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Border Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.arms.textures.border
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.borderTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.textures.border = newValue
			TRB.Data.settings.warrior.arms.textures.borderName = newName

			if GetSpecialization() == 1 then
				if TRB.Data.settings.warrior.arms.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.warrior.arms.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.warrior.arms.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.warrior.arms.textures.backgroundName)
		UIDropDownMenu_JustifyText(controls.dropDown.backgroundTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.backgroundTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("background")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Background Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.arms.textures.background
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.backgroundTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.textures.background = newValue
			TRB.Data.settings.warrior.arms.textures.backgroundName = newName

			if GetSpecialization() == 1 then
				barContainerFrame:SetBackdrop({
					bgFile = TRB.Data.settings.warrior.arms.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.warrior.arms.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.warrior.arms.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.warrior.arms.displayBar.alwaysShow = true
			TRB.Data.settings.warrior.arms.displayBar.notZeroShow = false
			TRB.Data.settings.warrior.arms.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Rage > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Rage > 0, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.warrior.arms.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.warrior.arms.displayBar.alwaysShow = false
			TRB.Data.settings.warrior.arms.displayBar.notZeroShow = true
			TRB.Data.settings.warrior.arms.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.warrior.arms.displayBar.alwaysShow) and (not TRB.Data.settings.warrior.arms.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.warrior.arms.displayBar.alwaysShow = false
			TRB.Data.settings.warrior.arms.displayBar.notZeroShow = false
			TRB.Data.settings.warrior.arms.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.warrior.arms.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.warrior.arms.displayBar.alwaysShow = false
			TRB.Data.settings.warrior.arms.displayBar.notZeroShow = false
			TRB.Data.settings.warrior.arms.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when Bladestorm is being channeled. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.warrior.fury.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.bar.showCasting = self:GetChecked()
		end)


		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.warrior.arms.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Rage", TRB.Data.settings.warrior.arms.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.base, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.warrior.arms.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.border, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Rage gain from Passive Sources", TRB.Data.settings.warrior.arms.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.passive, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

					controls.colors.passive.Texture:SetColorTexture(r, g, b, 1-a)
					passiveFrame:SetStatusBarColor(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when you are overcapping Rage", TRB.Data.settings.warrior.arms.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.borderOvercap, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.arms.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.warrior.arms.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.background, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Rage threshold line", TRB.Data.settings.warrior.arms.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.threshold.under, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Rage threshold line", TRB.Data.settings.warrior.arms.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.threshold.over, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.warrior.arms.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.threshold.unusable, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.arms)
		end)

		controls.checkBoxes.cleaveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_cleave", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cleaveThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cleave (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Cleave. Only visible if talented."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.cleave.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.cleave.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_execute", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Execute/Condemn (if |cFFFF4040Venthyr|r)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Execute or Condemn (if |cFFFF4040Venthyr|r). Only visible when the current target is in Execute health range or available from a Sudden Death proc. Will move along the bar between the current minimum and maximum Rage cost amounts."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.execute.enabled or TRB.Data.settings.warrior.arms.thresholds.condemn.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.execute.enabled = self:GetChecked()
			TRB.Data.settings.warrior.arms.thresholds.condemn.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_executeMinimum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeMinimumThresholdShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Execute/Condemn (if |cFFFF4040Venthyr|r) (minimum)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Execute or Condemn (if |cFFFF4040Venthyr|r) at its minimum Rage cost. Only visible when the current target is in Execute health range or available from a Sudden Death proc."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.executeMinimum.enabled or TRB.Data.settings.warrior.arms.thresholds.condemnMinimum.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.executeMinimum.enabled = self:GetChecked()
			TRB.Data.settings.warrior.arms.thresholds.condemnMinimum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.executeMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_executeMaximum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.executeMaximumThresholdShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Execute/Condemn (if |cFFFF4040Venthyr|r) (maximum)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Execute or Condemn (if |cFFFF4040Venthyr|r) at its maximum Rage cost. Only visible when the current target is in Execute health range or available from a Sudden Death proc."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.executeMaximum.enabled or TRB.Data.settings.warrior.arms.thresholds.condemnMaximum.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.executeMaximum.enabled = self:GetChecked()
			TRB.Data.settings.warrior.arms.thresholds.condemnMaximum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ignorePainThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_ignorePain", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ignorePainThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ignore Pain")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Ignore Pain."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.ignorePain.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.ignorePain.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.impendingVictoryThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Impending Victory (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Impending Victory. Only visible if talented."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.impendingVictory.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.impendingVictory.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.mortalStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_mortalStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mortalStrikeThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mortal Strike")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Mortal Strike."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.mortalStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.mortalStrike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.rendThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_rend", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.rendThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rend (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Rend. Only visible if talented."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.rend.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.rend.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shieldBlockThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shield Block")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Shield Block. This does not check to see if you have a shield equipped!"
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.shieldBlock.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.shieldBlock.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.slamThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slam")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Slam."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.slam.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.slam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.whirlwindThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_whirlwind", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.whirlwindThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Whirlwind")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Whirlwind."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.whirlwind.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.whirlwind.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, TRB.Data.settings.warrior.arms.thresholds.icons.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.thresholdIconRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.thresholdIconRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above"] = "TOP"
            relativeTo["Middle"] = "CENTER"
            relativeTo["Below"] = "BOTTOM"
            local relativeToList = {
                "Above",
                "Middle",
                "Below"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == TRB.Data.settings.warrior.arms.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            TRB.Data.settings.warrior.arms.thresholds.icons.relativeTo = newValue
            TRB.Data.settings.warrior.arms.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.arms)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(TRB.Data.settings.warrior.arms.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.thresholds.icons.enabled = self:GetChecked()
			
			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.arms)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, TRB.Data.settings.warrior.arms.thresholds.icons.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.arms.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.arms.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.arms.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, TRB.Data.settings.warrior.arms.thresholds.icons.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.arms.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.arms.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.arms.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.warrior.arms.thresholds.icons.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.thresholds.icons.xPos = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.warrior.arms, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.warrior.arms.thresholds.icons.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(TRB.Data.settings.warrior.arms.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.arms.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, TRB.Data.settings.warrior.arms.thresholds.icons.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.thresholds.icons.border = value

			local minsliderWidth = math.max(TRB.Data.settings.warrior.arms.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(TRB.Data.settings.warrior.arms.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.arms)
			end
		end)


		yCoord = yCoord - 60

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current hardcast spell will result in overcapping maximum Rage. Setting accepts values up to 130 to accomidate the Deadly Calm talent."
		f:SetChecked(TRB.Data.settings.warrior.arms.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 130, TRB.Data.settings.warrior.arms.overcapThreshold, 1, 1,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Warrior_Arms_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Font & Text).", 1, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.warrior.arms.displayText.left.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontLeft, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontLeft, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.warrior.arms.displayText.left.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontLeft:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.displayText.left.fontFace = newValue
			TRB.Data.settings.warrior.arms.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
				TRB.Data.settings.warrior.arms.displayText.middle.fontFace = newValue
				TRB.Data.settings.warrior.arms.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.warrior.arms.displayText.right.fontFace = newValue
				TRB.Data.settings.warrior.arms.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.left.fontFace, TRB.Data.settings.warrior.arms.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.middle.fontFace, TRB.Data.settings.warrior.arms.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.right.fontFace, TRB.Data.settings.warrior.arms.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.warrior.arms.displayText.middle.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontMiddle, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontMiddle, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.warrior.arms.displayText.middle.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontMiddle:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.displayText.middle.fontFace = newValue
			TRB.Data.settings.warrior.arms.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
				TRB.Data.settings.warrior.arms.displayText.left.fontFace = newValue
				TRB.Data.settings.warrior.arms.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.warrior.arms.displayText.right.fontFace = newValue
				TRB.Data.settings.warrior.arms.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.middle.fontFace, TRB.Data.settings.warrior.arms.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.left.fontFace, TRB.Data.settings.warrior.arms.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.right.fontFace, TRB.Data.settings.warrior.arms.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.warrior.arms.displayText.right.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontRight, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontRight, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.warrior.arms.displayText.right.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontRight:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.displayText.right.fontFace = newValue
			TRB.Data.settings.warrior.arms.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
				TRB.Data.settings.warrior.arms.displayText.left.fontFace = newValue
				TRB.Data.settings.warrior.arms.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.warrior.arms.displayText.middle.fontFace = newValue
				TRB.Data.settings.warrior.arms.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.right.fontFace, TRB.Data.settings.warrior.arms.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.left.fontFace, TRB.Data.settings.warrior.arms.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.middle.fontFace, TRB.Data.settings.warrior.arms.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.warrior.arms.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.warrior.arms.displayText.fontFaceLock then
				TRB.Data.settings.warrior.arms.displayText.middle.fontFace = TRB.Data.settings.warrior.arms.displayText.left.fontFace
				TRB.Data.settings.warrior.arms.displayText.middle.fontFaceName = TRB.Data.settings.warrior.arms.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.warrior.arms.displayText.middle.fontFaceName)
				TRB.Data.settings.warrior.arms.displayText.right.fontFace = TRB.Data.settings.warrior.arms.displayText.left.fontFace
				TRB.Data.settings.warrior.arms.displayText.right.fontFaceName = TRB.Data.settings.warrior.arms.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.warrior.arms.displayText.right.fontFaceName)

				if GetSpecialization() == 1 then
					middleTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.middle.fontFace, TRB.Data.settings.warrior.arms.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.right.fontFace, TRB.Data.settings.warrior.arms.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.warrior.arms.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.displayText.left.fontSize = value

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.left.fontFace, TRB.Data.settings.warrior.arms.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.warrior.arms.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.warrior.arms.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.warrior.arms.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.warrior.arms.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.warrior.arms.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", TRB.Data.settings.warrior.arms.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.left, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", TRB.Data.settings.warrior.arms.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.middle, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", TRB.Data.settings.warrior.arms.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.right, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.warrior.arms.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.displayText.middle.fontSize = value

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.middle.fontFace, TRB.Data.settings.warrior.arms.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.warrior.arms.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.warrior.arms.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.displayText.right.fontSize = value

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(TRB.Data.settings.warrior.arms.displayText.right.fontFace, TRB.Data.settings.warrior.arms.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.warrior.arms.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Rage Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentRageText = TRB.UiFunctions:BuildColorPicker(parent, "Current Rage", TRB.Data.settings.warrior.arms.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentRageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.current, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.currentRageText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.passiveRageText = TRB.UiFunctions:BuildColorPicker(parent, "Passive Rage", TRB.Data.settings.warrior.arms.colors.text.passive, 275, 25, xCoord2, yCoord)
		f = controls.colors.passiveRageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.passive, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.passiveRageText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.arms.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdrageText = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Rage to use any enabled threshold ability", TRB.Data.settings.warrior.arms.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdrageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.overThreshold, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.thresholdrageText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.arms.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcaprageText = TRB.UiFunctions:BuildColorPicker(parent, "Overcapping Rage", TRB.Data.settings.warrior.arms.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcaprageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.overcap, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.overcaprageText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.arms.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Rage text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.warrior.arms.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Rage text color when your current hardcast spell will result in overcapping maximum Rage."
		f:SetChecked(TRB.Data.settings.warrior.arms.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.colors.text.overcapEnabled = self:GetChecked()
		end)


		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($deepWoundsCount, $rendCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.warrior.arms.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.warrior.arms.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.dots.up, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions:BuildColorPicker(parent, "DoT is not active on current target", TRB.Data.settings.warrior.arms.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.text.dots.down, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.arms.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, TRB.Data.settings.warrior.arms.hastePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.hastePrecision = value
		end)

		title = "Rage Decimal Precision"
		controls.astralPowerPrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, TRB.Data.settings.warrior.arms.ragePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.astralPowerPrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.arms.ragePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Warrior_Arms_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Audio & Tracking).", 1, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Rage")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Rage."
		f:SetChecked(TRB.Data.settings.warrior.arms.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.warrior.arms.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(TRB.Data.settings.warrior.arms.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.warrior.arms.audio.overcap.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.warrior.arms.audio.overcap.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.audio.overcap.sound = newValue
			TRB.Data.settings.warrior.arms.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(TRB.Data.settings.warrior.arms.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.suddenDeathAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_suddenDeath_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.suddenDeathAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Sudden Death proc (if talented)")
		f.tooltip = "Play an audio cue when you get a Sudden Death proc that allows you to use Execute/Condemn for 0 Rage and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.warrior.arms.audio.suddenDeath.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.arms.audio.suddenDeath.enabled = self:GetChecked()

			if TRB.Data.settings.warrior.arms.audio.suddenDeath.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(TRB.Data.settings.warrior.arms.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.suddenDeathAudio = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Arms_suddenDeath_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.suddenDeathAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.suddenDeathAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.suddenDeathAudio, TRB.Data.settings.warrior.arms.audio.suddenDeath.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.suddenDeathAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.suddenDeathAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.warrior.arms.audio.suddenDeath.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.warrior.arms.audio.suddenDeath.sound = newValue
			TRB.Data.settings.warrior.arms.audio.suddenDeath.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(TRB.Data.settings.warrior.arms.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls
	end

	local function ArmsConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.arms
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		controls.buttons.exportButton_Warrior_Arms_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Arms_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Bar Text).", 1, 1, false, false, false, true, false)
		end)

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)

		yCoord = yCoord - 30
		controls.labels.leftText = TRB.UiFunctions:BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:BuildTextBox(parent, TRB.Data.settings.warrior.arms.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.warrior.arms.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
		end)

		yCoord = yCoord - 30
		controls.labels.middleText = TRB.UiFunctions:BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:BuildTextBox(parent, TRB.Data.settings.warrior.arms.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.warrior.arms.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
		end)

		yCoord = yCoord - 30
		controls.labels.rightText = TRB.UiFunctions:BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:BuildTextBox(parent, TRB.Data.settings.warrior.arms.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.warrior.arms.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, "Warrior_Arms")
		TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function ArmsConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.arms or {}
		local yCoord = 0
		local f = nil
		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.armsDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Arms", UIParent)
		interfaceSettingsFrame.armsDisplayPanel.name = "Arms Warrior"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.armsDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.armsDisplayPanel)

		parent = interfaceSettingsFrame.armsDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Arms Warrior", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.armsWarriorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_armsWarriorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.armsWarriorEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Arms Warrior specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.warrior.arms)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.warrior.arms = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.armsWarriorEnabled, TRB.Data.settings.core.enabled.warrior.arms, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.armsWarriorEnabled, TRB.Data.settings.core.enabled.warrior.arms, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Warrior_Arms_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Warrior_Arms_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (All).", 1, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Arms_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Warrior_Arms_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
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

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.fury
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Fury Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.fury = FuryResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Fury Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.fury.displayText = FuryLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Fury Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.fury.displayText = FuryLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Fury Warrior settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.warrior.fury.displayText = FuryLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.warrior.fury.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.fury.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.warrior.fury)

		controls.buttons.exportButton_Warrior_Fury_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Fury Warrior (Bar Display).", 1, 2, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.warrior.fury.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.bar.width = value

			if GetSpecialization() == 2 then
				barContainerFrame:SetWidth(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.warrior.fury.bar.width)
				resourceFrame:SetWidth(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				castingFrame:SetWidth(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				passiveFrame:SetWidth(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.warrior.fury)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["rage"] ~= nil and TRB.Data.spells[k]["rage"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.fury, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.warrior.fury.thresholds.width, -TRB.Data.spells[k]["rage"], TRB.Data.character.maxResource)
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.fury.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.fury.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.fury.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			TRB.Functions.UpdateBarWidth(TRB.Data.settings.warrior.fury)
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.warrior.fury.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.bar.height = value

			if GetSpecialization() == 2 then
				barContainerFrame:SetHeight(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				barBorderFrame:SetHeight(TRB.Data.settings.warrior.fury.bar.height)
				resourceFrame:SetHeight(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetHeight(value)
				end

				castingFrame:SetHeight(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				passiveFrame:SetHeight(value-(TRB.Data.settings.warrior.fury.bar.border*2))
				leftTextFrame:SetHeight(TRB.Data.settings.warrior.fury.bar.height * 3.5)
				middleTextFrame:SetHeight(TRB.Data.settings.warrior.fury.bar.height * 3.5)
				rightTextFrame:SetHeight(TRB.Data.settings.warrior.fury.bar.height * 3.5)
			end

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.fury.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.fury.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.fury.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			TRB.Functions.UpdateBarHeight(TRB.Data.settings.warrior.fury)
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.warrior.fury.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.bar.xPos = value

			if GetSpecialization() == 2 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.warrior.fury.bar.xPos, TRB.Data.settings.warrior.fury.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.warrior.fury.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.bar.yPos = value

			if GetSpecialization() == 2 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.warrior.fury.bar.xPos, TRB.Data.settings.warrior.fury.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.warrior.fury.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.bar.border = value

			if GetSpecialization() == 2 then
				barContainerFrame:SetWidth(TRB.Data.settings.warrior.fury.bar.width-(TRB.Data.settings.warrior.fury.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.warrior.fury.bar.height-(TRB.Data.settings.warrior.fury.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.warrior.fury.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.warrior.fury.bar.height)
				if TRB.Data.settings.warrior.fury.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.warrior.fury.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.warrior.fury.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.warrior.fury.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.warrior.fury)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["rage"] ~= nil and TRB.Data.spells[k]["rage"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.fury, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.warrior.fury.thresholds.width, -TRB.Data.spells[k]["rage"], TRB.Data.character.maxResource)
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.warrior.fury.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.warrior.fury.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.warrior.fury)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 10, TRB.Data.settings.warrior.fury.thresholds.width, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.thresholds.width = value

			if GetSpecialization() == 2 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.warrior.fury.thresholds.width)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.warrior.fury.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.fury.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.fury.bar.dragAndDrop)
		end)

		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay = self:GetChecked()

			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.fury.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.warrior.fury.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.warrior.fury.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.warrior.fury, TRB.Frames.barContainerFrame)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_RageBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.warrior.fury.textures.resourceBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.resourceBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.resourceBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.fury.textures.resourceBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.resourceBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.textures.resourceBar = newValue
			TRB.Data.settings.warrior.fury.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.warrior.fury.textures.textureLock then
				TRB.Data.settings.warrior.fury.textures.castingBar = newValue
				TRB.Data.settings.warrior.fury.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.warrior.fury.textures.passiveBar = newValue
				TRB.Data.settings.warrior.fury.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.resourceBar)
				if TRB.Data.settings.warrior.fury.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.warrior.fury.textures.castingBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.castingBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.castingBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.fury.textures.castingBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.castingBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.textures.castingBar = newValue
			TRB.Data.settings.warrior.fury.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.warrior.fury.textures.textureLock then
				TRB.Data.settings.warrior.fury.textures.resourceBar = newValue
				TRB.Data.settings.warrior.fury.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.warrior.fury.textures.passiveBar = newValue
				TRB.Data.settings.warrior.fury.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.castingBar)
				if TRB.Data.settings.warrior.fury.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.warrior.fury.textures.passiveBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.passiveBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.passiveBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.fury.textures.passiveBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.passiveBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.textures.passiveBar = newValue
			TRB.Data.settings.warrior.fury.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.warrior.fury.textures.textureLock then
				TRB.Data.settings.warrior.fury.textures.resourceBar = newValue
				TRB.Data.settings.warrior.fury.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.warrior.fury.textures.castingBar = newValue
				TRB.Data.settings.warrior.fury.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.passiveBar)
				if TRB.Data.settings.warrior.fury.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.warrior.fury.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.warrior.fury.textures.textureLock then
				TRB.Data.settings.warrior.fury.textures.passiveBar = TRB.Data.settings.warrior.fury.textures.resourceBar
				TRB.Data.settings.warrior.fury.textures.passiveBarName = TRB.Data.settings.warrior.fury.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.warrior.fury.textures.passiveBarName)
				TRB.Data.settings.warrior.fury.textures.castingBar = TRB.Data.settings.warrior.fury.textures.resourceBar
				TRB.Data.settings.warrior.fury.textures.castingBarName = TRB.Data.settings.warrior.fury.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.warrior.fury.textures.castingBarName)

				if GetSpecialization() == 2 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.warrior.fury.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.warrior.fury.textures.borderName)
		UIDropDownMenu_JustifyText(controls.dropDown.borderTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.borderTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("border")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Border Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.fury.textures.border
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.borderTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.textures.border = newValue
			TRB.Data.settings.warrior.fury.textures.borderName = newName

			if GetSpecialization() == 2 then
				if TRB.Data.settings.warrior.fury.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.warrior.fury.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.warrior.fury.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.warrior.fury.textures.backgroundName)
		UIDropDownMenu_JustifyText(controls.dropDown.backgroundTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.backgroundTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("background")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Background Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.warrior.fury.textures.background
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.backgroundTexture:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.textures.background = newValue
			TRB.Data.settings.warrior.fury.textures.backgroundName = newName

			if GetSpecialization() == 2 then
				barContainerFrame:SetBackdrop({
					bgFile = TRB.Data.settings.warrior.fury.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.warrior.fury.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.warrior.fury.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.warrior.fury.displayBar.alwaysShow = true
			TRB.Data.settings.warrior.fury.displayBar.notZeroShow = false
			TRB.Data.settings.warrior.fury.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Rage > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Rage > 0, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.warrior.fury.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.warrior.fury.displayBar.alwaysShow = false
			TRB.Data.settings.warrior.fury.displayBar.notZeroShow = true
			TRB.Data.settings.warrior.fury.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.warrior.fury.displayBar.alwaysShow) and (not TRB.Data.settings.warrior.fury.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.warrior.fury.displayBar.alwaysShow = false
			TRB.Data.settings.warrior.fury.displayBar.notZeroShow = false
			TRB.Data.settings.warrior.fury.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.warrior.fury.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.warrior.fury.displayBar.alwaysShow = false
			TRB.Data.settings.warrior.fury.displayBar.notZeroShow = false
			TRB.Data.settings.warrior.fury.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.warrior.fury.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Rage", TRB.Data.settings.warrior.fury.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.base, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.warrior.fury.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.border, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Rage gain from Passive Sources", TRB.Data.settings.warrior.fury.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.passive, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

					controls.colors.passive.Texture:SetColorTexture(r, g, b, 1-a)
					passiveFrame:SetStatusBarColor(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when you are overcapping Rage", TRB.Data.settings.warrior.fury.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.borderOvercap, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.fury.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.warrior.fury.colors.bar.background, 275, 25, xCoord, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.background, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.enrage = TRB.UiFunctions:BuildColorPicker(parent, "Fury while Enrage is active", TRB.Data.settings.warrior.fury.colors.bar.enrage, 250, 25, xCoord2, yCoord)
		f = controls.colors.enrage
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.enrage, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.enrage.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.bar.enrage = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Rage threshold line", TRB.Data.settings.warrior.fury.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.threshold.under, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Rage threshold line", TRB.Data.settings.warrior.fury.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.threshold.over, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.warrior.fury.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.threshold.unusable, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.fury)
		end)

		controls.checkBoxes.ignorePainThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_ignorePain", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ignorePainThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ignore Pain")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Ignore Pain."
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.ignorePain.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.ignorePain.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.impendingVictoryThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Impending Victory (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Impending Victory. Only visible if talented."
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.impendingVictory.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.impendingVictory.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.rampageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_rampage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.rampageThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rampage (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Rampage."
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.rampage.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.rampage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shieldBlockThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shield Block")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Shield Block. This does not check to see if you have a shield equipped!"
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.shieldBlock.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.shieldBlock.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.slamThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slam")
		f.tooltip = "This will show the vertical line on the bar denoting how much Rage is required to use Slam."
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.slam.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.slam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, TRB.Data.settings.warrior.fury.thresholds.icons.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.thresholdIconRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.thresholdIconRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above"] = "TOP"
            relativeTo["Middle"] = "CENTER"
            relativeTo["Below"] = "BOTTOM"
            local relativeToList = {
                "Above",
                "Middle",
                "Below"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == TRB.Data.settings.warrior.fury.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            TRB.Data.settings.warrior.fury.thresholds.icons.relativeTo = newValue
            TRB.Data.settings.warrior.fury.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 2 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.fury)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(TRB.Data.settings.warrior.fury.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.thresholds.icons.enabled = self:GetChecked()
			
			if GetSpecialization() == 2 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.fury)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, TRB.Data.settings.warrior.fury.thresholds.icons.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.fury.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.fury.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.fury.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, TRB.Data.settings.warrior.fury.thresholds.icons.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.warrior.fury.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.fury.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.warrior.fury.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.warrior.fury.thresholds.icons.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.thresholds.icons.xPos = value

			if GetSpecialization() == 2 then
				TRB.Functions.RepositionBar(TRB.Data.settings.warrior.fury, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.warrior.fury.thresholds.icons.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(TRB.Data.settings.warrior.fury.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.warrior.fury.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, TRB.Data.settings.warrior.fury.thresholds.icons.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.thresholds.icons.border = value

			local minsliderWidth = math.max(TRB.Data.settings.warrior.fury.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(TRB.Data.settings.warrior.fury.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 2 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.warrior.fury)
			end
		end)


		yCoord = yCoord - 60

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current hardcast spell will result in overcapping maximum Rage. Setting accepts values up to 130 to accomidate the Deadly Calm talent."
		f:SetChecked(TRB.Data.settings.warrior.fury.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.colors.bar.overcapEnabled = self:GetChecked()
		end)


		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 100, TRB.Data.settings.warrior.fury.overcapThreshold, 1, 1,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Warrior_Fury_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Fury Warrior (Font & Text).", 1, 2, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.warrior.fury.displayText.left.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontLeft, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontLeft, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.warrior.fury.displayText.left.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontLeft:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.displayText.left.fontFace = newValue
			TRB.Data.settings.warrior.fury.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
				TRB.Data.settings.warrior.fury.displayText.middle.fontFace = newValue
				TRB.Data.settings.warrior.fury.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.warrior.fury.displayText.right.fontFace = newValue
				TRB.Data.settings.warrior.fury.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.left.fontFace, TRB.Data.settings.warrior.fury.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.middle.fontFace, TRB.Data.settings.warrior.fury.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.right.fontFace, TRB.Data.settings.warrior.fury.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.warrior.fury.displayText.middle.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontMiddle, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontMiddle, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.warrior.fury.displayText.middle.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontMiddle:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.displayText.middle.fontFace = newValue
			TRB.Data.settings.warrior.fury.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
				TRB.Data.settings.warrior.fury.displayText.left.fontFace = newValue
				TRB.Data.settings.warrior.fury.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.warrior.fury.displayText.right.fontFace = newValue
				TRB.Data.settings.warrior.fury.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.middle.fontFace, TRB.Data.settings.warrior.fury.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.left.fontFace, TRB.Data.settings.warrior.fury.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.right.fontFace, TRB.Data.settings.warrior.fury.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.warrior.fury.displayText.right.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontRight, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontRight, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.warrior.fury.displayText.right.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontRight:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.displayText.right.fontFace = newValue
			TRB.Data.settings.warrior.fury.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
				TRB.Data.settings.warrior.fury.displayText.left.fontFace = newValue
				TRB.Data.settings.warrior.fury.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.warrior.fury.displayText.middle.fontFace = newValue
				TRB.Data.settings.warrior.fury.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.right.fontFace, TRB.Data.settings.warrior.fury.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.left.fontFace, TRB.Data.settings.warrior.fury.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.middle.fontFace, TRB.Data.settings.warrior.fury.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.warrior.fury.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.warrior.fury.displayText.fontFaceLock then
				TRB.Data.settings.warrior.fury.displayText.middle.fontFace = TRB.Data.settings.warrior.fury.displayText.left.fontFace
				TRB.Data.settings.warrior.fury.displayText.middle.fontFaceName = TRB.Data.settings.warrior.fury.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.warrior.fury.displayText.middle.fontFaceName)
				TRB.Data.settings.warrior.fury.displayText.right.fontFace = TRB.Data.settings.warrior.fury.displayText.left.fontFace
				TRB.Data.settings.warrior.fury.displayText.right.fontFaceName = TRB.Data.settings.warrior.fury.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.warrior.fury.displayText.right.fontFaceName)

				if GetSpecialization() == 2 then
					middleTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.middle.fontFace, TRB.Data.settings.warrior.fury.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.right.fontFace, TRB.Data.settings.warrior.fury.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.warrior.fury.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.displayText.left.fontSize = value

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.left.fontFace, TRB.Data.settings.warrior.fury.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.warrior.fury.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.warrior.fury.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.warrior.fury.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.warrior.fury.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.warrior.fury.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", TRB.Data.settings.warrior.fury.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.left, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", TRB.Data.settings.warrior.fury.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.middle, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", TRB.Data.settings.warrior.fury.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.right, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.warrior.fury.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.displayText.middle.fontSize = value

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.middle.fontFace, TRB.Data.settings.warrior.fury.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.warrior.fury.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.warrior.fury.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.displayText.right.fontSize = value

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(TRB.Data.settings.warrior.fury.displayText.right.fontFace, TRB.Data.settings.warrior.fury.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.warrior.fury.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Rage Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentRageText = TRB.UiFunctions:BuildColorPicker(parent, "Current Rage", TRB.Data.settings.warrior.fury.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentRageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.current, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.currentRageText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.passiveRageText = TRB.UiFunctions:BuildColorPicker(parent, "Passive Rage", TRB.Data.settings.warrior.fury.colors.text.passive, 275, 25, xCoord2, yCoord)
		f = controls.colors.passiveRageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.passive, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.passiveRageText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.fury.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdrageText = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Rage to use any enabled threshold ability", TRB.Data.settings.warrior.fury.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdrageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.overThreshold, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.thresholdrageText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.fury.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcaprageText = TRB.UiFunctions:BuildColorPicker(parent, "Overcapping Rage", TRB.Data.settings.warrior.fury.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcaprageText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.overcap, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.overcaprageText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.warrior.fury.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Rage text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.warrior.fury.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Rage text color when your current hardcast spell will result in overcapping maximum Rage."
		f:SetChecked(TRB.Data.settings.warrior.fury.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.colors.text.overcapEnabled = self:GetChecked()
		end)

		--[[
		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($deepWoundsCount, $rendCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.warrior.fury.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.warrior.fury.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.dots.up, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.warrior.fury.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.dots.pandemic, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions:BuildColorPicker(parent, "DoT is not active on current target", TRB.Data.settings.warrior.fury.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.text.dots.down, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.warrior.fury.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		]]


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, TRB.Data.settings.warrior.fury.hastePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.hastePrecision = value
		end)

		title = "Rage Decimal Precision"
		controls.astralPowerPrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, TRB.Data.settings.warrior.fury.ragePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.astralPowerPrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.warrior.fury.ragePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Warrior_Fury_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Fury Warrior (Audio & Tracking).", 1, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Rage")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Rage."
		f:SetChecked(TRB.Data.settings.warrior.fury.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.warrior.fury.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(TRB.Data.settings.warrior.fury.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.warrior.fury.audio.overcap.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.warrior.fury.audio.overcap.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.audio.overcap.sound = newValue
			TRB.Data.settings.warrior.fury.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(TRB.Data.settings.warrior.fury.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		--[[
		yCoord = yCoord - 60
		controls.checkBoxes.suddenDeathAudio = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_suddenDeath_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.suddenDeathAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Sudden Death proc (if talented)")
		f.tooltip = "Play an audio cue when you get a Sudden Death proc that allows you to use Execute/Condemn for 0 Rage and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.warrior.fury.audio.suddenDeath.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.warrior.fury.audio.suddenDeath.enabled = self:GetChecked()

			if TRB.Data.settings.warrior.fury.audio.suddenDeath.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(TRB.Data.settings.warrior.fury.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.suddenDeathAudio = CreateFrame("FRAME", "TwintopResourceBar_Warrior_Fury_suddenDeath_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.suddenDeathAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.suddenDeathAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.suddenDeathAudio, TRB.Data.settings.warrior.fury.audio.suddenDeath.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.suddenDeathAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.suddenDeathAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.warrior.fury.audio.suddenDeath.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.warrior.fury.audio.suddenDeath.sound = newValue
			TRB.Data.settings.warrior.fury.audio.suddenDeath.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(TRB.Data.settings.warrior.fury.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		]]

		TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls
	end

	local function FuryConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.fury
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		controls.buttons.exportButton_Warrior_Fury_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Warrior_Fury_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Fury Warrior (Bar Text).", 1, 2, false, false, false, true, false)
		end)

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)

		yCoord = yCoord - 30
		controls.labels.leftText = TRB.UiFunctions:BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:BuildTextBox(parent, TRB.Data.settings.warrior.fury.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.warrior.fury.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
		end)

		yCoord = yCoord - 30
		controls.labels.middleText = TRB.UiFunctions:BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:BuildTextBox(parent, TRB.Data.settings.warrior.fury.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.warrior.fury.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
		end)

		yCoord = yCoord - 30
		controls.labels.rightText = TRB.UiFunctions:BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:BuildTextBox(parent, TRB.Data.settings.warrior.fury.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.warrior.fury.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, "Warrior_Fury")
		TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function FuryConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.fury or {}
		local yCoord = 0
		local f = nil
		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.furyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Fury", UIParent)
		interfaceSettingsFrame.furyDisplayPanel.name = "Fury Warrior"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.furyDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.furyDisplayPanel)

		parent = interfaceSettingsFrame.furyDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Fury Warrior", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.furyWarriorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_furyWarriorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.furyWarriorEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Fury Warrior specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.warrior.fury)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.warrior.fury = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.furyWarriorEnabled, TRB.Data.settings.core.enabled.warrior.fury, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.furyWarriorEnabled, TRB.Data.settings.core.enabled.warrior.fury, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Warrior_Fury_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Warrior_Fury_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Fury Warrior (All).", 1, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Warrior_Fury_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Warrior_Fury_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
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