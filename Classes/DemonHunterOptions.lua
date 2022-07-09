local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 12 then --Only do this if we're on a DemonHunter!
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

	TRB.Options.DemonHunter = {}
	TRB.Options.DemonHunter.Havoc = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = {}

	local function HavocLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="{$ucTime}[$ucTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="{$metamorphosisTime}[$metamorphosisTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$passive}[$passive + ]{$casting}[$casting + ]$fury",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function HavocLoadDefaultBarTextAdvancedSettings()
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
				text="{$ucTime}[#unboundChaos $ucTime #unboundChaos||n]{$metamorphosisTime}[#metamorphosis $metamorphosisTime #metamorphosis]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$preparedFury}[#prepared$preparedFury+]{$bhFury}[#bh$bhFury+]{$casting}[#casting$casting+]$fury",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function HavocLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			furyPrecision=0,
			overcapThreshold=120,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
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
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
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

		settings.displayText = HavocLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function HavocResetSettings()
		local settings = HavocLoadDefaultSettings()
		return settings
	end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		settings.demonhunter.havoc = HavocLoadDefaultSettings()
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

		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = HavocResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HavocLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HavocLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HavocLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
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

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Bar Display).", 12, 1, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.bar.width = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetWidth(value-(spec.bar.border*2))
				barBorderFrame:SetWidth(spec.bar.width)
				resourceFrame:SetWidth(value-(spec.bar.border*2))
				castingFrame:SetWidth(value-(spec.bar.border*2))
				passiveFrame:SetWidth(value-(spec.bar.border*2))
				TRB.Functions.SetBarMinMaxValues(spec)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["fury"] ~= nil and TRB.Data.spells[k]["fury"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(spec, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, spec.thresholds.width, -TRB.Data.spells[k]["fury"], TRB.Data.character.maxResource)
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local maxBorderSize = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.bar.height = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetHeight(value-(spec.bar.border*2))
				barBorderFrame:SetHeight(spec.bar.height)
				resourceFrame:SetHeight(value-(spec.bar.border*2))
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetHeight(value)
				end

				castingFrame:SetHeight(value-(spec.bar.border*2))
				passiveFrame:SetHeight(value-(spec.bar.border*2))
				leftTextFrame:SetHeight(spec.bar.height * 3.5)
				middleTextFrame:SetHeight(spec.bar.height * 3.5)
				rightTextFrame:SetHeight(spec.bar.height * 3.5)
			end

			local maxBorderSize = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.bar.xPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", spec.bar.xPos, spec.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.bar.yPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", spec.bar.xPos, spec.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.bar.border = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetWidth(spec.bar.width-(spec.bar.border*2))
				barContainerFrame:SetHeight(spec.bar.height-(spec.bar.border*2))
				barBorderFrame:SetWidth(spec.bar.width)
				barBorderFrame:SetHeight(spec.bar.height)
				if spec.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = spec.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({
						edgeFile = spec.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=spec.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(spec.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(spec)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["fury"] ~= nil and TRB.Data.spells[k]["fury"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(spec, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, spec.thresholds.width, -TRB.Data.spells[k]["fury"], TRB.Data.character.maxResource)
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(spec.bar.border*2, 120)
			local minsliderHeight = math.max(spec.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(spec)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 10, spec.thresholds.width, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.width = value

			if GetSpecialization() == 1 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(spec.thresholds.width)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(spec.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
		end)

		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(spec.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.pinToPersonalResourceDisplay = self:GetChecked()

			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
			TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_FuryBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, spec.textures.resourceBarName)
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
						info.checked = textures[v] == spec.textures.resourceBar
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
			spec.textures.resourceBar = newValue
			spec.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if spec.textures.textureLock then
				spec.textures.castingBar = newValue
				spec.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				spec.textures.passiveBar = newValue
				spec.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				resourceFrame:SetStatusBarTexture(spec.textures.resourceBar)
				if spec.textures.textureLock then
					castingFrame:SetStatusBarTexture(spec.textures.castingBar)
					passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, spec.textures.castingBarName)
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
						info.checked = textures[v] == spec.textures.castingBar
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
			spec.textures.castingBar = newValue
			spec.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(spec.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if spec.textures.textureLock then
				spec.textures.resourceBar = newValue
				spec.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(spec.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				spec.textures.passiveBar = newValue
				spec.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				castingFrame:SetStatusBarTexture(spec.textures.castingBar)
				if spec.textures.textureLock then
					resourceFrame:SetStatusBarTexture(spec.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, spec.textures.passiveBarName)
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
						info.checked = textures[v] == spec.textures.passiveBar
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
			spec.textures.passiveBar = newValue
			spec.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if spec.textures.textureLock then
				spec.textures.resourceBar = newValue
				spec.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(spec.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				spec.textures.castingBar = newValue
				spec.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(spec.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
				if spec.textures.textureLock then
					resourceFrame:SetStatusBarTexture(spec.textures.resourceBar)
					castingFrame:SetStatusBarTexture(spec.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(spec.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			spec.textures.textureLock = self:GetChecked()
			if spec.textures.textureLock then
				spec.textures.passiveBar = spec.textures.resourceBar
				spec.textures.passiveBarName = spec.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, spec.textures.passiveBarName)
				spec.textures.castingBar = spec.textures.resourceBar
				spec.textures.castingBarName = spec.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, spec.textures.castingBarName)

				if GetSpecialization() == 1 then
					passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
					castingFrame:SetStatusBarTexture(spec.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, spec.textures.borderName)
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
						info.checked = textures[v] == spec.textures.border
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
			spec.textures.border = newValue
			spec.textures.borderName = newName

			if GetSpecialization() == 1 then
				if spec.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = spec.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=spec.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(spec.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions:BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, spec.textures.backgroundName)
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
						info.checked = textures[v] == spec.textures.background
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
			spec.textures.background = newValue
			spec.textures.backgroundName = newName

			if GetSpecialization() == 1 then
				barContainerFrame:SetBackdrop({
					bgFile = spec.textures.background,
					tile = true,
					tileSize = spec.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(spec.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(spec.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = true
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Fury > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Fury > 0, hidden otherwise when out of combat."
		f:SetChecked(spec.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = true
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not spec.displayBar.alwaysShow) and (not spec.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(spec.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when Eye Beam (with Blind Fury) is being channeled. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Fury", spec.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.metamorphosis = TRB.UiFunctions:BuildColorPicker(parent, "Fury while Metamorphosis is active", spec.colors.bar.metamorphosis, 225, 25, xCoord2, yCoord)
		f = controls.colors.metamorphosis
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "metamorphosis")
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Fury gain from Passive Sources", spec.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
		end)

		controls.colors.metamorphosisEnding = TRB.UiFunctions:BuildColorPicker(parent, "Fury when Metamorphosis is ending", spec.colors.bar.metamorphosisEnding, 250, 25, xCoord2, yCoord)
		f = controls.colors.metamorphosisEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions:BuildColorPicker(parent, "Fury gain from Eye Beam with Blind Fury", spec.colors.bar.casting, 275, 25, xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 1)
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", spec.colors.bar.border, 250, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 1)
		end)

		
		yCoord = yCoord - 30
		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, xCoord, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
		end)

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when your next builder will overcap Fury", spec.colors.bar.borderOvercap, 250, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)
		
		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Fury threshold line", spec.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Fury threshold line", spec.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.bladeDanceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_bladeDance", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.bladeDanceThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
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
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chaos Nova (no Unleashed Power)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Chaos Nova. Only shown if Unleashed Power is not talented."
		f:SetChecked(spec.thresholds.chaosNova.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chaosNova.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chaosStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chaosStrikeThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
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
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Eye Beam")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Eye Beam."
		f:SetChecked(spec.thresholds.eyeBeam.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.eyeBeam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.felEruptionVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_felEruption", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.felEruptionVictoryThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fel Eruption (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Fel Eruption. Only visible if talented."
		f:SetChecked(spec.thresholds.felEruption.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.felEruption.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.glaiveTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_glaiveTempest", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.glaiveTempestThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Glaive Tempest (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Glaive Tempest. Only visible if talented."
		f:SetChecked(spec.thresholds.glaiveTempest.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.glaiveTempest.enabled = self:GetChecked()
		end)
		


		yCoord = yCoord - 30

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, spec.thresholds.icons.relativeToName)
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
                info.checked = relativeTo[v] == spec.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            spec.thresholds.icons.relativeTo = newValue
            spec.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(spec)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end

		--NOTE: the order of these checkboxes is reversed!
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", xCoord2+(xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for potion icons that are on cooldown."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(spec.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.enabled = self:GetChecked()
			
			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.xPos = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.border = value

			local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)


		yCoord = yCoord - 60

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Metamorphosis Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosis
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Metamorphosis")
		f.tooltip = "Changes the bar color when Metamorphosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfMetamorphosis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfMetamorphosis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
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
		controls.endOfMetamorphosisGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.endOfMetamorphosis.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
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
		controls.endOfMetamorphosisTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.endOfMetamorphosis.timeMax = value
		end)


		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when your next builder ability will overcap Fury")
		f.tooltip = "This will change the bar's border color when your next builder ability will result in overcapping maximum Fury. Setting accepts values up to 130 to accomidate the Deadly Calm talent."
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 120, spec.overcapThreshold, 1, 1,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

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

		controls.buttons.exportButton_DemonHunter_Havoc_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Font & Text).", 12, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, spec.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.left.fontFace
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
			spec.displayText.left.fontFace = newValue
			spec.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.middle.fontFace
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
			spec.displayText.middle.fontFace = newValue
			spec.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.right.fontFace
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
			spec.displayText.right.fontFace = newValue
			spec.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(spec.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontFaceLock = self:GetChecked()
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = spec.displayText.left.fontFace
				spec.displayText.middle.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
				spec.displayText.right.fontFace = spec.displayText.left.fontFace
				spec.displayText.right.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)

				if GetSpecialization() == 1 then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.left.fontSize = value

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(spec.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontSizeLock = self:GetChecked()
			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(spec.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(spec.displayText.left.fontSize)
			end
		end)

		controls.colors.text = {}

		controls.colors.text.left = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", spec.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.text.left
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "left")
		end)

		controls.colors.text.middle = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", spec.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.text.middle
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "middle")
		end)

		controls.colors.text.right = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", spec.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.text.right
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "right")
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.middle.fontSize = value

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.right.fontSize = value

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Fury Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Fury", spec.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Fury", spec.colors.text.passive, 275, 25, xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Fury to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Overcapping Fury", spec.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when your next builder ability will result in overcapping maximum Fury."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 0)
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

		controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Audio & Tracking).", 12, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Fury")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Fury."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_DemonHunter_Havoc_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
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
						info.checked = sounds[v] == spec.audio.overcap.sound
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
			spec.audio.overcap.sound = newValue
			spec.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
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
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1
		local namePrefix = "DemonHunter_Havoc"

		controls.buttons.exportButton_DemonHunter_Havoc_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Bar Text).", 12, 1, false, false, false, true, false)
		end)

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)

		yCoord = yCoord - 30
		controls.labels.leftText = TRB.UiFunctions:BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 70
		controls.labels.middleText = TRB.UiFunctions:BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 70
		controls.labels.rightText = TRB.UiFunctions:BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function HavocConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.havoc or {}
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

		interfaceSettingsFrame.havocDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Havoc", UIParent)
		interfaceSettingsFrame.havocDisplayPanel.name = "Havoc Demon Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.havocDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.havocDisplayPanel)

		parent = interfaceSettingsFrame.havocDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Havoc Demon Hunter", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.havocDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_havocDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.havocDemonHunterEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Havoc Demon Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.havoc)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.demonhunter.havoc = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_DemonHunter_Havoc_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (All).", 12, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_DemonHunter_Havoc_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls

		HavocConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		HavocConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		HavocConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		HavocConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		HavocConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		HavocConstructOptionsPanel(specCache.havoc)
	end
	TRB.Options.DemonHunter.ConstructOptionsPanel = ConstructOptionsPanel
end