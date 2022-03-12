local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 10 then --Only do this if we're on a Monk!
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

	TRB.Options.Monk = {}
	TRB.Options.Monk.Windwalker = {}
	TRB.Options.Monk.Outlaw = {}
	TRB.Options.Monk.Subtlety = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = {}

	local function WindwalkerLoadDefaultBarTextSimpleSettings()
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
				text="{$serenityTime}[$serenityTime sec]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function WindwalkerLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$serenityTime}[#serenity $serenityTime #serenity]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function WindwalkerLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			overcapThreshold=120,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					border=2,
					relativeTo = "BOTTOM",
					relativeToName = "Below",
					enabled=true,
					xPos=0,
					yPos=12,
					width=24,
					height=24
				},
				-- Core Monk
				cracklingJadeLightning = {
					enabled = true, -- 1
				},
				detox = {
					enabled = false, -- 2
				},
				expelHarm = {
					enabled = true, -- 3
				},
				paralysis = {
					enabled = false, -- 4
				},
				tigerPalm = {
					enabled = true, -- 5
				},
				vivify = {
					enabled = false, -- 6
				},
				-- Windwalker
				disable = {
					enabled = false, -- 7
				},
				-- Talents
				fistOfTheWhiteTiger = {
					enabled = true, -- 8
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
                fullWidth=false,
            },
			endOfSerenity = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
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
					border="FFFFD300",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFFFFF00",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF9F4500",
					serenity="FF00FF98",
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
				textureLock=true,
				comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
				comboPointsBackgroundName="Blizzard Tooltip",
				comboPointsBorder="Interface\\Buttons\\WHITE8X8",
				comboPointsBorderName="1 Pixel",
				comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
				comboPointsBarName="Blizzard",
			}
		}

		settings.displayText = WindwalkerLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function WindwalkerResetSettings()
		local settings = WindwalkerLoadDefaultSettings()
		return settings
	end


    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		if TwintopInsanityBarSettings.core ~= nil and
			TwintopInsanityBarSettings.core.experimental ~= nil and
			TwintopInsanityBarSettings.core.experimental.specs ~= nil and
			TwintopInsanityBarSettings.core.experimental.specs.monk ~= nil and 
			TwintopInsanityBarSettings.core.experimental.specs.monk.windwalker then
			settings.monk.windwalker = WindwalkerLoadDefaultSettings()
		end
		return settings
	end
    TRB.Options.Monk.LoadDefaultSettings = LoadDefaultSettings

	--[[

	Windwalker Option Menus

	]]

	local function WindwalkerConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker
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

		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Windwalker Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.monk.windwalker = WindwalkerResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Windwalker Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.monk.windwalker.displayText = WindwalkerLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Windwalker Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.monk.windwalker.displayText = WindwalkerLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
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

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.monk.windwalker.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.monk.windwalker)

		controls.buttons.exportButton_Monk_Windwalker_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Bar Display).", 10, 3, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.monk.windwalker.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.monk.windwalker.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.monk.windwalker.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.monk.windwalker)
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.monk.windwalker, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.monk.windwalker.thresholds.width, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.monk.windwalker.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.monk.windwalker.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.monk.windwalker.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.monk.windwalker)
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.monk.windwalker.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.bar.xPos = value

			if GetSpecialization() == 3 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.monk.windwalker.bar.xPos, TRB.Data.settings.monk.windwalker.bar.yPos)
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.monk.windwalker.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.bar.yPos = value

			if GetSpecialization() == 3 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.monk.windwalker.bar.xPos, TRB.Data.settings.monk.windwalker.bar.yPos)
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.monk.windwalker.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.bar.border = value

			if GetSpecialization() == 3 then
				barContainerFrame:SetWidth(TRB.Data.settings.monk.windwalker.bar.width-(TRB.Data.settings.monk.windwalker.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.monk.windwalker.bar.height-(TRB.Data.settings.monk.windwalker.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.monk.windwalker.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.monk.windwalker.bar.height)
				if TRB.Data.settings.monk.windwalker.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.monk.windwalker.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.monk.windwalker.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.monk.windwalker.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.monk.windwalker)                
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.monk.windwalker)
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.monk.windwalker, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.monk.windwalker.thresholds.width, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.monk.windwalker.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.monk.windwalker.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.monk.windwalker)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 10, TRB.Data.settings.monk.windwalker.thresholds.width, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.thresholds.width = value

			if GetSpecialization() == 3 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.monk.windwalker.thresholds.width)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.monk.windwalker.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.monk.windwalker.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.monk.windwalker.bar.dragAndDrop)
		end)
			
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.monk.windwalker.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.monk.windwalker.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.monk.windwalker.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
		end)


		yCoord = yCoord - 30
		controls.comboPointPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, "Chis Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Chi Width"
		controls.comboPointWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, TRB.Functions.RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), TRB.Data.settings.monk.windwalker.comboPoints.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.comboPointWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.comboPoints.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.monk.windwalker.comboPoints.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.comboPoints.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.monk.windwalker.comboPoints.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.comboPointBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.comboPointBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.comboPointBorderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Chi Height"
		controls.comboPointHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, sanityCheckValues.barMaxHeight, TRB.Data.settings.monk.windwalker.comboPoints.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.comboPointHeight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.comboPoints.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.monk.windwalker.comboPoints.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.monk.windwalker.comboPoints.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.comboPointBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.comboPointBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.comboPointBorderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)



		title = "Chi Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.comboPointHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.monk.windwalker.comboPoints.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.comboPointHorizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.comboPoints.xPos = value

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Chi Vertical Position (Relative)"
		controls.comboPointVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.monk.windwalker.comboPoints.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.comboPointVertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.comboPoints.yPos = value

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)



		title = "Chi Border Width"
		yCoord = yCoord - 60
		controls.comboPointBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.monk.windwalker.comboPoints.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.comboPointBorderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.comboPoints.border = value

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)

				--TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.monk.windwalker)
			end

			local minsliderWidth = math.max(TRB.Data.settings.monk.windwalker.comboPoints.border*2, 1)
			local minsliderHeight = math.max(TRB.Data.settings.monk.windwalker.comboPoints.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.monk.windwalker)
			controls.comboPointHeight:SetMinMaxValues(minsliderHeight, scValues.comboPointsMaxHeight)
			controls.comboPointHeight.MinLabel:SetText(minsliderHeight)
			controls.comboPointWidth:SetMinMaxValues(minsliderWidth, scValues.comboPointsMaxWidth)
			controls.comboPointWidth.MinLabel:SetText(minsliderWidth)
		end)

		title = "Chi Spacing"
		controls.comboPointSpacing = TRB.UiFunctions:BuildSlider(parent, title, 0, TRB.Functions.RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), TRB.Data.settings.monk.windwalker.comboPoints.spacing, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.comboPoints.spacing = value

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		yCoord = yCoord - 40
        -- Create the dropdown, and configure its appearance
        controls.dropDown.comboPointsRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_comboPointsRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.comboPointsRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Chi to Energy Bar", xCoord, yCoord)
        controls.dropDown.comboPointsRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.comboPointsRelativeTo:SetPoint("TOPLEFT", xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.comboPointsRelativeTo, dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, TRB.Data.settings.monk.windwalker.comboPoints.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.comboPointsRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.comboPointsRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above - Left"] = "TOPLEFT"
            relativeTo["Above - Middle"] = "TOP"
            relativeTo["Above - Right"] = "TOPRIGHT"
            relativeTo["Below - Left"] = "BOTTOMLEFT"
            relativeTo["Below - Middle"] = "BOTTOM"
            relativeTo["Below - Right"] = "BOTTOMRIGHT"
            local relativeToList = {
                "Above - Left",
                "Above - Middle",
                "Above - Right",
                "Below - Left",
                "Below - Middle",
                "Below - Right"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == TRB.Data.settings.monk.windwalker.comboPoints.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.comboPointsRelativeTo:SetValue(newValue, newName)
            TRB.Data.settings.monk.windwalker.comboPoints.relativeTo = newValue
            TRB.Data.settings.monk.windwalker.comboPoints.relativeToName = newName
            UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, newName)
            CloseDropDownMenus()

            if GetSpecialization() == 3 then
                TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
            end
        end


        controls.checkBoxes.comboPointsFullWidth = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_comboPointsFullWidth", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.comboPointsFullWidth
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Chi are full bar width?")
		f.tooltip = "Makes the Chi bars take up the same total width of the bar, spaced according to Chi Spacing (above). The horizontal position adjustment will be ignored and the width of Chi bars will be automatically calculated and will ignore the value set above."
		f:SetChecked(TRB.Data.settings.monk.windwalker.comboPoints.fullWidth)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.comboPoints.fullWidth = self:GetChecked()
            
			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

        yCoord = yCoord - 60
		controls.textBarTexturesSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar and Chi Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_EnergyBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.monk.windwalker.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.resourceBar
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
			TRB.Data.settings.monk.windwalker.textures.resourceBar = newValue
			TRB.Data.settings.monk.windwalker.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.castingBar = newValue
				TRB.Data.settings.monk.windwalker.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.passiveBar = newValue
				TRB.Data.settings.monk.windwalker.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.comboPointsBar = newValue
				TRB.Data.settings.monk.windwalker.textures.comboPointsBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.resourceBar)
				if TRB.Data.settings.monk.windwalker.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.passiveBar)
					
					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.comboPointsBar)
					end
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.monk.windwalker.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.castingBar
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
			TRB.Data.settings.monk.windwalker.textures.castingBar = newValue
			TRB.Data.settings.monk.windwalker.textures.castingBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.resourceBar = newValue
				TRB.Data.settings.monk.windwalker.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.passiveBar = newValue
				TRB.Data.settings.monk.windwalker.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.comboPointsBar = newValue
				TRB.Data.settings.monk.windwalker.textures.comboPointsBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.castingBar)
				if TRB.Data.settings.monk.windwalker.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.passiveBar)
					
					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.comboPointsBar)
					end
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.monk.windwalker.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.passiveBar
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
			TRB.Data.settings.monk.windwalker.textures.passiveBar = newValue
			TRB.Data.settings.monk.windwalker.textures.passiveBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.resourceBar = newValue
				TRB.Data.settings.monk.windwalker.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.castingBar = newValue
				TRB.Data.settings.monk.windwalker.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.comboPointsBar = newValue
				TRB.Data.settings.monk.windwalker.textures.comboPointsBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.passiveBar)
				if TRB.Data.settings.monk.windwalker.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.castingBar)
					
					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.comboPointsBar)
					end
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.comboPointsBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_ComboPointsBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.comboPointsBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Chi Texture", xCoord2, yCoord)
		controls.dropDown.comboPointsBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.comboPointsBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.comboPointsBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.comboPointsBarTexture, TRB.Data.settings.monk.windwalker.textures.comboPointsBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.comboPointsBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.comboPointsBarTexture, function(self, level, menuList)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.comboPointsBar
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
		function controls.dropDown.comboPointsBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.monk.windwalker.textures.comboPointsBar = newValue
			TRB.Data.settings.monk.windwalker.textures.comboPointsBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.comboPointsBarTexture, newName)
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.resourceBar = newValue
				TRB.Data.settings.monk.windwalker.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.passiveBar = newValue
				TRB.Data.settings.monk.windwalker.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
				TRB.Data.settings.monk.windwalker.textures.castingBar = newValue
				TRB.Data.settings.monk.windwalker.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 3 then					
				local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
				for x = 1, length do
					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.comboPointsBar)
				end

				if TRB.Data.settings.monk.windwalker.textures.textureLock then
				    castingFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.castingBar)
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.monk.windwalker.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.border
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
			TRB.Data.settings.monk.windwalker.textures.border = newValue
			TRB.Data.settings.monk.windwalker.textures.borderName = newName

			if GetSpecialization() == 3 then
				if TRB.Data.settings.monk.windwalker.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.monk.windwalker.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.monk.windwalker.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)

			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.comboPointsBorder = newValue
				TRB.Data.settings.monk.windwalker.textures.comboPointsBorderName = newName
	
				if GetSpecialization() == 3 then
					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						if TRB.Data.settings.monk.windwalker.comboPoints.border < 1 then
							TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ })
						else
							TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.monk.windwalker.textures.comboPointsBorder,
														tile = true,
														tileSize=4,
														edgeSize=TRB.Data.settings.monk.windwalker.comboPoints.border,
														insets = {0, 0, 0, 0}
														})
						end
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropColor(0, 0, 0, 0)
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.border, true))
					end
				end
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBorderTexture, newName)
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.monk.windwalker.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.background
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
			TRB.Data.settings.monk.windwalker.textures.background = newValue
			TRB.Data.settings.monk.windwalker.textures.backgroundName = newName

			if GetSpecialization() == 3 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.monk.windwalker.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.monk.windwalker.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.comboPointsBackground = newValue
				TRB.Data.settings.monk.windwalker.textures.comboPointsBackgroundName = newName
	
				if GetSpecialization() == 3 then
					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdrop({ 
							bgFile = TRB.Data.settings.monk.windwalker.textures.comboPointsBackground,
							tile = true,
							tileSize = TRB.Data.settings.monk.windwalker.comboPoints.width,
							edgeSize = 1,
							insets = {0, 0, 0, 0}
						})
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.background, true))
					end
				end

				UIDropDownMenu_SetText(controls.dropDown.comboPointsBackgroundTexture, newName)
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.comboPointsBorderTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_CB1_ComboPointsBorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.comboPointsBorderTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Chi Border Texture", xCoord, yCoord)
		controls.dropDown.comboPointsBorderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.comboPointsBorderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.comboPointsBorderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.comboPointsBorderTexture, TRB.Data.settings.monk.windwalker.textures.comboPointsBorderName)
		UIDropDownMenu_JustifyText(controls.dropDown.comboPointsBorderTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.comboPointsBorderTexture, function(self, level, menuList)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.comboPointsBorder
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
		function controls.dropDown.comboPointsBorderTexture:SetValue(newValue, newName)
			TRB.Data.settings.monk.windwalker.textures.comboPointsBorder = newValue
			TRB.Data.settings.monk.windwalker.textures.comboPointsBorderName = newName

			if GetSpecialization() == 3 then
				local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
				for x = 1, length do
					if TRB.Data.settings.monk.windwalker.comboPoints.border < 1 then
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ })
					else
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.monk.windwalker.textures.comboPointsBorder,
													tile = true,
													tileSize=4,
													edgeSize=TRB.Data.settings.monk.windwalker.comboPoints.border,
													insets = {0, 0, 0, 0}
													})
					end
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropColor(0, 0, 0, 0)
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.border, true))
				end
			end

			UIDropDownMenu_SetText(controls.dropDown.comboPointsBorderTexture, newName)

			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.border = newValue
				TRB.Data.settings.monk.windwalker.textures.borderName = newName

				if TRB.Data.settings.monk.windwalker.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.monk.windwalker.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.monk.windwalker.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.border, true))
				UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.comboPointsBackgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_ComboPointsBackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.comboPointsBackgroundTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Background (Empty Chi) Texture", xCoord2, yCoord)
		controls.dropDown.comboPointsBackgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.comboPointsBackgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.comboPointsBackgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.comboPointsBackgroundTexture, TRB.Data.settings.monk.windwalker.textures.comboPointsBackgroundName)
		UIDropDownMenu_JustifyText(controls.dropDown.comboPointsBackgroundTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.comboPointsBackgroundTexture, function(self, level, menuList)
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
						info.checked = textures[v] == TRB.Data.settings.monk.windwalker.textures.comboPointsBackground
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
		function controls.dropDown.comboPointsBackgroundTexture:SetValue(newValue, newName)
			TRB.Data.settings.monk.windwalker.textures.comboPointsBackground = newValue
			TRB.Data.settings.monk.windwalker.textures.comboPointsBackgroundName = newName

			if GetSpecialization() == 3 then
				local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
				for x = 1, length do
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdrop({ 
						bgFile = TRB.Data.settings.monk.windwalker.textures.comboPointsBackground,
						tile = true,
						tileSize = TRB.Data.settings.monk.windwalker.comboPoints.width,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.background, true))
				end
			end

			UIDropDownMenu_SetText(controls.dropDown.comboPointsBackgroundTexture, newName)
			
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.background = newValue
				TRB.Data.settings.monk.windwalker.textures.backgroundName = newName

				if GetSpecialization() == 3 then
					barContainerFrame:SetBackdrop({ 
						bgFile = TRB.Data.settings.monk.windwalker.textures.background,
						tile = true,
						tileSize = TRB.Data.settings.monk.windwalker.bar.width,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barContainerFrame:SetBackdropColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.background, true))
				end

				UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			end

			CloseDropDownMenus()
		end

		

		yCoord = yCoord - 60
		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars, borders, and backgrounds (respectively)")
		f.tooltip = "This will lock the texture for each type of texture to be the same for all parts of the bar. E.g.: All bar textures will be the same, all border textures will be the same, and all background textures will be the same."
		f:SetChecked(TRB.Data.settings.monk.windwalker.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.monk.windwalker.textures.textureLock then
				TRB.Data.settings.monk.windwalker.textures.passiveBar = TRB.Data.settings.monk.windwalker.textures.resourceBar
				TRB.Data.settings.monk.windwalker.textures.passiveBarName = TRB.Data.settings.monk.windwalker.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.monk.windwalker.textures.passiveBarName)
				TRB.Data.settings.monk.windwalker.textures.castingBar = TRB.Data.settings.monk.windwalker.textures.resourceBar
				TRB.Data.settings.monk.windwalker.textures.castingBarName = TRB.Data.settings.monk.windwalker.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.monk.windwalker.textures.castingBarName)
				TRB.Data.settings.monk.windwalker.textures.comboPointsBar = TRB.Data.settings.monk.windwalker.textures.resourceBar
				TRB.Data.settings.monk.windwalker.textures.comboPointsBarName = TRB.Data.settings.monk.windwalker.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBarTexture, TRB.Data.settings.monk.windwalker.textures.resourceBarName)
				TRB.Data.settings.monk.windwalker.textures.comboPointsBorder = TRB.Data.settings.monk.windwalker.textures.border
				TRB.Data.settings.monk.windwalker.textures.comboPointsBorderName = TRB.Data.settings.monk.windwalker.textures.borderName
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBorderTexture, TRB.Data.settings.monk.windwalker.textures.comboPointsBorderName)
				TRB.Data.settings.monk.windwalker.textures.comboPointsBackground = TRB.Data.settings.monk.windwalker.textures.background
				TRB.Data.settings.monk.windwalker.textures.comboPointsBackgroundName = TRB.Data.settings.monk.windwalker.textures.backgroundName
				UIDropDownMenu_SetText(controls.dropDown.comboPointsBackgroundTexture, TRB.Data.settings.monk.windwalker.textures.comboPointsBackgroundName)

				if GetSpecialization() == 3 then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.castingBar)

					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(TRB.Data.settings.monk.windwalker.textures.comboPointsBar)
						
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdrop({ 
							bgFile = TRB.Data.settings.monk.windwalker.textures.comboPointsBackground,
							tile = true,
							tileSize = TRB.Data.settings.monk.windwalker.comboPoints.width,
							edgeSize = 1,
							insets = {0, 0, 0, 0}
						})
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.background, true))
						
						if TRB.Data.settings.monk.windwalker.comboPoints.border < 1 then
							TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ })
						else
							TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.monk.windwalker.textures.comboPointsBorder,
														tile = true,
														tileSize=4,
														edgeSize=TRB.Data.settings.monk.windwalker.comboPoints.border,
														insets = {0, 0, 0, 0}
														})
						end
					end
				end
			end
		end)

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.monk.windwalker.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.monk.windwalker.displayBar.alwaysShow = true
			TRB.Data.settings.monk.windwalker.displayBar.notZeroShow = false
			TRB.Data.settings.monk.windwalker.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Energy is not capped")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Energy is not capped, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.monk.windwalker.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.monk.windwalker.displayBar.alwaysShow = false
			TRB.Data.settings.monk.windwalker.displayBar.notZeroShow = true
			TRB.Data.settings.monk.windwalker.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.monk.windwalker.displayBar.alwaysShow) and (not TRB.Data.settings.monk.windwalker.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.monk.windwalker.displayBar.alwaysShow = false
			TRB.Data.settings.monk.windwalker.displayBar.notZeroShow = false
			TRB.Data.settings.monk.windwalker.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.monk.windwalker.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.monk.windwalker.displayBar.alwaysShow = false
			TRB.Data.settings.monk.windwalker.displayBar.notZeroShow = false
			TRB.Data.settings.monk.windwalker.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting Cracking Jade Lightning. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.monk.windwalker.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.monk.windwalker.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Energy", TRB.Data.settings.monk.windwalker.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.base, true)
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
                    TRB.Data.settings.monk.windwalker.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.monk.windwalker.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.border, true)
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
                    TRB.Data.settings.monk.windwalker.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Energy gain from Passive Sources", TRB.Data.settings.monk.windwalker.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.passive, true)
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
                    TRB.Data.settings.monk.windwalker.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.casting = TRB.UiFunctions:BuildColorPicker(parent, "Energy spent from hardcasting spells", TRB.Data.settings.monk.windwalker.colors.bar.casting, 275, 25, xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.casting, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.monk.windwalker.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
					castingFrame:SetStatusBarColor(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.serenity = TRB.UiFunctions:BuildColorPicker(parent, "Energy while Serenity is active", TRB.Data.settings.monk.windwalker.colors.bar.serenity, 275, 25, xCoord, yCoord)
		f = controls.colors.serenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.serenity, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.serenity.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.monk.windwalker.colors.bar.serenity = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)	

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.monk.windwalker.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.background, true)
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
                    TRB.Data.settings.monk.windwalker.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.serenityEnd = TRB.UiFunctions:BuildColorPicker(parent, "Energy while you have less than 1 GCD left in Serenity", TRB.Data.settings.monk.windwalker.colors.bar.serenityEnd, 275, 25, xCoord, yCoord)
		f = controls.colors.serenityEnd
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.serenityEnd, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
---@diagnostic disable-next-line: deprecated
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.serenityEnd.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.monk.windwalker.colors.bar.serenityEnd = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)		

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Chi Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.comboPointBase = TRB.UiFunctions:BuildColorPicker(parent, "Chi", TRB.Data.settings.monk.windwalker.colors.comboPoints.base, 300, 25, xCoord, yCoord)
		f = controls.colors.comboPointBase
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.base, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.comboPointBase.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.monk.windwalker.colors.comboPoints.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.comboPointBorder = TRB.UiFunctions:BuildColorPicker(parent, "Chi's border", TRB.Data.settings.monk.windwalker.colors.comboPoints.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.comboPointBorder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.border, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.comboPointBorder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.monk.windwalker.colors.comboPoints.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.comboPointPenultimate = TRB.UiFunctions:BuildColorPicker(parent, "Penultimate Chi", TRB.Data.settings.monk.windwalker.colors.comboPoints.penultimate, 275, 25, xCoord, yCoord)
		f = controls.colors.comboPointPenultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.penultimate, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.comboPointPenultimate.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.monk.windwalker.colors.comboPoints.penultimate = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.comboPointFinal = TRB.UiFunctions:BuildColorPicker(parent, "Final Chi", TRB.Data.settings.monk.windwalker.colors.comboPoints.final, 275, 25, xCoord2, yCoord)
		f = controls.colors.comboPointFinal
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.final, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.comboPointFinal.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.monk.windwalker.colors.comboPoints.final = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Chi color for all?")
		f.tooltip = "When checked, the highest Chi's color will be used for all Chi. E.g., if you have maximum 5 Chi and currently have 4, the Penultimate color will be used for all Chi instead of just the second to last."
		f:SetChecked(TRB.Data.settings.monk.windwalker.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.comboPoints.sameColor = self:GetChecked()
		end)


		controls.colors.comboPointBackground = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled Chi background", TRB.Data.settings.monk.windwalker.colors.comboPoints.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.comboPointBackground
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.background, true)
				TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
---@diagnostic disable-next-line: deprecated
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.comboPointBackground.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.monk.windwalker.colors.comboPoints.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    
					local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
					for x = 1, length do
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.background, true))
					end
                end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Energy threshold line", TRB.Data.settings.monk.windwalker.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.threshold.under, true)
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
                    TRB.Data.settings.monk.windwalker.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Energy threshold line", TRB.Data.settings.monk.windwalker.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.threshold.over, true)
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
                    TRB.Data.settings.monk.windwalker.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.monk.windwalker.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.threshold.unusable, true)
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
                    TRB.Data.settings.monk.windwalker.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.monk.windwalker)
		end)
		
		controls.labels.builders = TRB.UiFunctions:BuildLabel(parent, "Builders", 5, yCoord, 110, 20)
		yCoord = yCoord - 20
		controls.checkBoxes.expelHarmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_expelHarm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.expelHarmThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Expel Harm")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Expel Harm. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.expelHarm.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.expelHarm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.tigerPalmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_tigerPalm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.tigerPalmThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Tiger Palm")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Tiger Palm."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.tigerPalm.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.tigerPalm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.fistOfTheWhiteTigerThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_fistOfTheWhiteTiger", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fistOfTheWhiteTigerThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fist of the White Tiger (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Fist of the White Tiger. Only visible if talented in to Fist of the White Tiger. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.fistOfTheWhiteTiger.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.fistOfTheWhiteTiger.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25		
		controls.labels.utility = TRB.UiFunctions:BuildLabel(parent, "General / Utility", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.cracklingJadeLightningThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_cracklingJadeLightning", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cracklingJadeLightningThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crackling Jade Lightning")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crackling Jade Lightning."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.cracklingJadeLightning.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.cracklingJadeLightning.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.detoxThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_detox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.detoxThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Detox")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Detox. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.detox.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.detox.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.paralysisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_paralysis", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.paralysisThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Paralysis")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Paralysis. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.paralysis.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.paralysis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.vivifyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_vivify", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.vivifyThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Vivify")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Vivify."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.vivify.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.vivify.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.disableThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_disable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.disableThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Disable")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Disable."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.disable.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.disable.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, TRB.Data.settings.monk.windwalker.thresholds.icons.relativeToName)
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
                info.checked = relativeTo[v] == TRB.Data.settings.monk.windwalker.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            TRB.Data.settings.monk.windwalker.thresholds.icons.relativeTo = newValue
            TRB.Data.settings.monk.windwalker.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 3 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.monk.windwalker)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(TRB.Data.settings.monk.windwalker.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.thresholds.icons.enabled = self:GetChecked()
			
			if GetSpecialization() == 3 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.monk.windwalker)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, TRB.Data.settings.monk.windwalker.thresholds.icons.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.monk.windwalker.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.monk.windwalker.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, TRB.Data.settings.monk.windwalker.thresholds.icons.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.monk.windwalker.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.monk.windwalker.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.monk.windwalker.thresholds.icons.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.thresholds.icons.xPos = value

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.monk.windwalker.thresholds.icons.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(TRB.Data.settings.monk.windwalker.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.monk.windwalker.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, TRB.Data.settings.monk.windwalker.thresholds.icons.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.thresholds.icons.border = value

			local minsliderWidth = math.max(TRB.Data.settings.monk.windwalker.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(TRB.Data.settings.monk.windwalker.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 3 then
				TRB.Functions.RedrawThresholdLines(TRB.Data.settings.monk.windwalker)
			end
		end)


		yCoord = yCoord - 60
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Serenity Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfSerenity = CreateFrame("CheckButton", "TRB_EOVF_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfSerenity
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Serenity")
		f.tooltip = "Changes the bar color when Serenity is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(TRB.Data.settings.monk.windwalker.endOfSerenity.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.endOfSerenity.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfSerenityModeGCDs = CreateFrame("CheckButton", "TRB_EOFV_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfSerenityModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Serenity ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Serenity ends."
		if TRB.Data.settings.monk.windwalker.endOfSerenity.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfSerenityModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfSerenityModeTime:SetChecked(false)
			TRB.Data.settings.monk.windwalker.endOfSerenity.mode = "gcd"
		end)

		title = "Serenity GCDs - 0.75sec Floor"
		controls.endOfSerenityGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 10, TRB.Data.settings.monk.windwalker.endOfSerenity.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfSerenityGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.endOfSerenity.gcdsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.endOfSerenityModeTime = CreateFrame("CheckButton", "TRB_EOFV_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfSerenityModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Serenity ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Serenity will end."
		if TRB.Data.settings.monk.windwalker.endOfSerenity.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfSerenityModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfSerenityModeTime:SetChecked(true)
			TRB.Data.settings.monk.windwalker.endOfSerenity.mode = "time"
		end)

		title = "Serenity Time Remaining"
		controls.endOfSerenityTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, TRB.Data.settings.monk.windwalker.endOfSerenity.timeMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfSerenityTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.endOfSerenity.timeMax = value
		end)


		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current energy is above the overcapping maximum Energy as configured below."
		f:SetChecked(TRB.Data.settings.monk.windwalker.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 170, TRB.Data.settings.monk.windwalker.overcapThreshold, 1, 1,
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
			TRB.Data.settings.monk.windwalker.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
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

		controls.buttons.exportButton_Monk_Windwalker_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Font & Text).", 10, 3, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.monk.windwalker.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.monk.windwalker.displayText.left.fontFace
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
			TRB.Data.settings.monk.windwalker.displayText.left.fontFace = newValue
			TRB.Data.settings.monk.windwalker.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
				TRB.Data.settings.monk.windwalker.displayText.middle.fontFace = newValue
				TRB.Data.settings.monk.windwalker.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.monk.windwalker.displayText.right.fontFace = newValue
				TRB.Data.settings.monk.windwalker.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.left.fontFace, TRB.Data.settings.monk.windwalker.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.middle.fontFace, TRB.Data.settings.monk.windwalker.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.right.fontFace, TRB.Data.settings.monk.windwalker.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.monk.windwalker.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.monk.windwalker.displayText.middle.fontFace
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
			TRB.Data.settings.monk.windwalker.displayText.middle.fontFace = newValue
			TRB.Data.settings.monk.windwalker.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
				TRB.Data.settings.monk.windwalker.displayText.left.fontFace = newValue
				TRB.Data.settings.monk.windwalker.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.monk.windwalker.displayText.right.fontFace = newValue
				TRB.Data.settings.monk.windwalker.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.middle.fontFace, TRB.Data.settings.monk.windwalker.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.left.fontFace, TRB.Data.settings.monk.windwalker.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.right.fontFace, TRB.Data.settings.monk.windwalker.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.monk.windwalker.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.monk.windwalker.displayText.right.fontFace
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
			TRB.Data.settings.monk.windwalker.displayText.right.fontFace = newValue
			TRB.Data.settings.monk.windwalker.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
				TRB.Data.settings.monk.windwalker.displayText.left.fontFace = newValue
				TRB.Data.settings.monk.windwalker.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.monk.windwalker.displayText.middle.fontFace = newValue
				TRB.Data.settings.monk.windwalker.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.right.fontFace, TRB.Data.settings.monk.windwalker.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.left.fontFace, TRB.Data.settings.monk.windwalker.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.middle.fontFace, TRB.Data.settings.monk.windwalker.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.monk.windwalker.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.monk.windwalker.displayText.fontFaceLock then
				TRB.Data.settings.monk.windwalker.displayText.middle.fontFace = TRB.Data.settings.monk.windwalker.displayText.left.fontFace
				TRB.Data.settings.monk.windwalker.displayText.middle.fontFaceName = TRB.Data.settings.monk.windwalker.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.monk.windwalker.displayText.middle.fontFaceName)
				TRB.Data.settings.monk.windwalker.displayText.right.fontFace = TRB.Data.settings.monk.windwalker.displayText.left.fontFace
				TRB.Data.settings.monk.windwalker.displayText.right.fontFaceName = TRB.Data.settings.monk.windwalker.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.monk.windwalker.displayText.right.fontFaceName)

				if GetSpecialization() == 3 then
					middleTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.middle.fontFace, TRB.Data.settings.monk.windwalker.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.right.fontFace, TRB.Data.settings.monk.windwalker.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.monk.windwalker.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.displayText.left.fontSize = value

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.left.fontFace, TRB.Data.settings.monk.windwalker.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.monk.windwalker.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.monk.windwalker.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.monk.windwalker.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.monk.windwalker.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.monk.windwalker.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", TRB.Data.settings.monk.windwalker.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.left, true)
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
                    TRB.Data.settings.monk.windwalker.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", TRB.Data.settings.monk.windwalker.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.middle, true)
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
                    TRB.Data.settings.monk.windwalker.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", TRB.Data.settings.monk.windwalker.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.right, true)
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
                    TRB.Data.settings.monk.windwalker.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.monk.windwalker.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.displayText.middle.fontSize = value

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.middle.fontFace, TRB.Data.settings.monk.windwalker.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.monk.windwalker.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, TRB.Data.settings.monk.windwalker.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.displayText.right.fontSize = value

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(TRB.Data.settings.monk.windwalker.displayText.right.fontFace, TRB.Data.settings.monk.windwalker.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.monk.windwalker.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Energy Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentEnergyText = TRB.UiFunctions:BuildColorPicker(parent, "Current Energy", TRB.Data.settings.monk.windwalker.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.current, true)
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
        
                    controls.colors.currentEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.monk.windwalker.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		
		controls.colors.passiveEnergyText = TRB.UiFunctions:BuildColorPicker(parent, "Passive Energy", TRB.Data.settings.monk.windwalker.colors.text.passive, 275, 25, xCoord2, yCoord)
		f = controls.colors.passiveEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.passive, true)
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

					controls.colors.passiveEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.monk.windwalker.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdenergyText = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", TRB.Data.settings.monk.windwalker.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.overThreshold, true)
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

					controls.colors.thresholdenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.monk.windwalker.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapenergyText = TRB.UiFunctions:BuildColorPicker(parent, "Current Energy is above overcap threshold", TRB.Data.settings.monk.windwalker.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.overcap, true)
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

					controls.colors.overcapenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.monk.windwalker.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.monk.windwalker.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(TRB.Data.settings.monk.windwalker.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on time remaining?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.monk.windwalker.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.monk.windwalker.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.dots.up, true)
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
                    TRB.Data.settings.monk.windwalker.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.monk.windwalker.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.dots.pandemic, true)
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
                    TRB.Data.settings.monk.windwalker.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions:BuildColorPicker(parent, "DoT is not active on current target", TRB.Data.settings.monk.windwalker.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.text.dots.down, true)
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
                    TRB.Data.settings.monk.windwalker.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, TRB.Data.settings.monk.windwalker.hastePrecision, 1, 0,
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
			TRB.Data.settings.monk.windwalker.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
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

		controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Audio & Tracking).", 10, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
		f:SetChecked(TRB.Data.settings.monk.windwalker.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.monk.windwalker.audio.overcap.enabled then
				---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(TRB.Data.settings.monk.windwalker.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.monk.windwalker.audio.overcap.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.monk.windwalker.audio.overcap.sound
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
			TRB.Data.settings.monk.windwalker.audio.overcap.sound = newValue
			TRB.Data.settings.monk.windwalker.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(TRB.Data.settings.monk.windwalker.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Energy Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.monk.windwalker.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.monk.windwalker.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD length."
		if TRB.Data.settings.monk.windwalker.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			TRB.Data.settings.monk.windwalker.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
		controls.energyGenerationGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, TRB.Data.settings.monk.windwalker.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if TRB.Data.settings.monk.windwalker.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			TRB.Data.settings.monk.windwalker.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
		controls.energyGenerationTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, TRB.Data.settings.monk.windwalker.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.monk.windwalker.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end
    
	local function WindwalkerConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1
		local namePrefix = "Monk_Windwalker"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Monk_Windwalker_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Bar Text).", 10, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions:BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", TRB.Data.settings.monk.windwalker.displayText.left.text,
														430, 60, xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.monk.windwalker.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.monk.windwalker)
		end)


		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", TRB.Data.settings.monk.windwalker.displayText.middle.text,
														430, 60, xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.monk.windwalker.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.monk.windwalker)
		end)


		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Right", TRB.Data.settings.monk.windwalker.displayText.right.text,
														430, 60, xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.monk.windwalker.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.monk.windwalker)
		end)

		yCoord = yCoord - 70
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function WindwalkerConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.windwalker or {}
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
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.windwalkerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Windwalker", UIParent)
		interfaceSettingsFrame.windwalkerDisplayPanel.name = "Windwalker Monk"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.windwalkerDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.windwalkerDisplayPanel)

		parent = interfaceSettingsFrame.windwalkerDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Windwalker Monk", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.windwalkerMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_windwalkerMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.windwalkerMonkEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Windwalker Monk specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.monk.windwalker)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.monk.windwalker = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Monk_Windwalker_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Monk_Windwalker_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (All).", 10, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Monk_Windwalker_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls

		WindwalkerConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		WindwalkerConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		WindwalkerConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		WindwalkerConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		WindwalkerConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		if TRB.Data.settings.core.experimental.specs.monk.windwalker then
			WindwalkerConstructOptionsPanel(specCache.windwalker)
		end
	end
	TRB.Options.Monk.ConstructOptionsPanel = ConstructOptionsPanel
end