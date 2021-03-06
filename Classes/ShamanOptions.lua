local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
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

	TRB.Options.Shaman = {}
	TRB.Options.Shaman.Elemental = {}
	TRB.Options.Shaman.Enhancement = {}
    TRB.Options.Shaman.Restoration = {}


	local function ElementalLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="$haste%",
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$maelstrom",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function ElementalLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "#flameShock $fsCount    $haste% ($gcd)||n{$ifStacks}[#frostShock $ifStacks][       ]    {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$maelstrom",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function ElementalLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
			overcapThreshold=100,
			earthShockThreshold=true,
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
				thresholdOverlapBorder=true,
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
					border="FF00008D",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FF0055FF",
					casting="FFFFFFFF",
					passive="FF995BDD",
					earthShock="FF00096A",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00"
				}
			},
			displayText = {},
			audio = {
				esReady={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				overcap={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
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

		settings.displayText = ElementalLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function ElementalResetSettings()
		local settings = ElementalLoadDefaultSettings()
		return settings
	end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()
		local specId = GetSpecialization()
		settings.shaman.elemental = ElementalLoadDefaultSettings()
		return settings
	end
    TRB.Options.Shaman.LoadDefaultSettings = LoadDefaultSettings


	local function ElementalConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.elemental
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

		StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Elemental Shaman settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.shaman.elemental = ElementalResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Elemental Shaman settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.shaman.elemental.displayText = ElementalLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Elemental Shaman settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.shaman.elemental.displayText = ElementalLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Elemental Shaman settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.shaman.elemental.displayText = ElementalLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions.BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
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

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.shaman.elemental.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.shaman.elemental.bar.width / TRB.Data.constants.borderWidthFactor))

		controls.buttons.exportButton_Shaman_Elemental_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Bar Display).", 7, 1, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinWidth, TRB.Data.sanityCheckValues.barMaxWidth, TRB.Data.settings.shaman.elemental.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.shaman.elemental.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.shaman.elemental.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.shaman.elemental.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			TRB.Functions.UpdateBarWidth(TRB.Data.settings.shaman.elemental)

			TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.elemental, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.shaman.elemental.thresholdWidth, TRB.Data.character.earthShockThreshold, TRB.Data.character.maxResource)
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinHeight, TRB.Data.sanityCheckValues.barMaxHeight, TRB.Data.settings.shaman.elemental.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.shaman.elemental.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.shaman.elemental.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.shaman.elemental.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			TRB.Functions.UpdateBarHeight(TRB.Data.settings.shaman.elemental)
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth/2), math.floor(TRB.Data.sanityCheckValues.barMaxWidth/2), TRB.Data.settings.shaman.elemental.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.bar.xPos = value
			barContainerFrame:ClearAllPoints()
			barContainerFrame:SetPoint("CENTER", UIParent)
			barContainerFrame:SetPoint("CENTER", TRB.Data.settings.shaman.elemental.bar.xPos, TRB.Data.settings.shaman.elemental.bar.yPos)
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight/2), math.floor(TRB.Data.sanityCheckValues.barMaxHeight/2), TRB.Data.settings.shaman.elemental.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.bar.yPos = value
			barContainerFrame:ClearAllPoints()
			barContainerFrame:SetPoint("CENTER", UIParent)
			barContainerFrame:SetPoint("CENTER", TRB.Data.settings.shaman.elemental.bar.xPos, TRB.Data.settings.shaman.elemental.bar.yPos)
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.shaman.elemental.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.bar.border = value
			barContainerFrame:SetWidth(TRB.Data.settings.shaman.elemental.bar.width-(TRB.Data.settings.shaman.elemental.bar.border*2))
			barContainerFrame:SetHeight(TRB.Data.settings.shaman.elemental.bar.height-(TRB.Data.settings.shaman.elemental.bar.border*2))
			barBorderFrame:SetWidth(TRB.Data.settings.shaman.elemental.bar.width)
			barBorderFrame:SetHeight(TRB.Data.settings.shaman.elemental.bar.height)
			if TRB.Data.settings.shaman.elemental.bar.border < 1 then
				barBorderFrame:SetBackdrop({
					edgeFile = TRB.Data.settings.shaman.elemental.textures.border,
					tile = true,
					tileSize = 4,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barBorderFrame:Hide()
			else
				barBorderFrame:SetBackdrop({
					edgeFile = TRB.Data.settings.shaman.elemental.textures.border,
					tile = true,
					tileSize=4,
					edgeSize=TRB.Data.settings.shaman.elemental.bar.border,
					insets = {0, 0, 0, 0}
				})
				barBorderFrame:Show()
			end
			barBorderFrame:SetBackdropColor(0, 0, 0, 0)
			barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.border, true))

			TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.shaman.elemental)
			TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.elemental, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.shaman.elemental.thresholdWidth, TRB.Data.character.earthShockThreshold, TRB.Data.character.maxResource)

			local minsliderWidth = math.max(TRB.Data.settings.shaman.elemental.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.shaman.elemental.bar.border*2, 1)
			controls.height:SetMinMaxValues(minsliderHeight, TRB.Data.sanityCheckValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, TRB.Data.sanityCheckValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.shaman.elemental.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.thresholdWidth = value
			resourceFrame.thresholds[1]:SetWidth(TRB.Data.settings.shaman.elemental.thresholdWidth)
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.shaman.elemental.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.shaman.elemental.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.shaman.elemental.bar.dragAndDrop)
		end)

		TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay = self:GetChecked()

			TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.shaman.elemental.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.shaman.elemental.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.shaman.elemental.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.shaman.elemental)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", xCoord+xPadding, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TIBMaelstromBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.shaman.elemental.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.shaman.elemental.textures.resourceBar
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
			TRB.Data.settings.shaman.elemental.textures.resourceBar = newValue
			TRB.Data.settings.shaman.elemental.textures.resourceBarName = newName
			resourceFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.resourceBar)
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.shaman.elemental.textures.textureLock then
				TRB.Data.settings.shaman.elemental.textures.castingBar = newValue
				TRB.Data.settings.shaman.elemental.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.shaman.elemental.textures.passiveBar = newValue
				TRB.Data.settings.shaman.elemental.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TIBCastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.shaman.elemental.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.shaman.elemental.textures.castingBar
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
			TRB.Data.settings.shaman.elemental.textures.castingBar = newValue
			TRB.Data.settings.shaman.elemental.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.shaman.elemental.textures.textureLock then
				TRB.Data.settings.shaman.elemental.textures.resourceBar = newValue
				TRB.Data.settings.shaman.elemental.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.shaman.elemental.textures.passiveBar = newValue
				TRB.Data.settings.shaman.elemental.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end
			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TIBPassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.shaman.elemental.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.shaman.elemental.textures.passiveBar
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
			TRB.Data.settings.shaman.elemental.textures.passiveBar = newValue
			TRB.Data.settings.shaman.elemental.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.shaman.elemental.textures.textureLock then
				TRB.Data.settings.shaman.elemental.textures.resourceBar = newValue
				TRB.Data.settings.shaman.elemental.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.shaman.elemental.textures.castingBar = newValue
				TRB.Data.settings.shaman.elemental.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end
			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TIBCB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.shaman.elemental.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.shaman.elemental.textures.textureLock then
				TRB.Data.settings.shaman.elemental.textures.passiveBar = TRB.Data.settings.shaman.elemental.textures.resourceBar
				TRB.Data.settings.shaman.elemental.textures.passiveBarName = TRB.Data.settings.shaman.elemental.textures.resourceBarName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.shaman.elemental.textures.passiveBarName)
				TRB.Data.settings.shaman.elemental.textures.castingBar = TRB.Data.settings.shaman.elemental.textures.resourceBar
				TRB.Data.settings.shaman.elemental.textures.castingBarName = TRB.Data.settings.shaman.elemental.textures.resourceBarName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.shaman.elemental.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.shaman.elemental.textures.castingBarName)
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TIBBorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.shaman.elemental.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.shaman.elemental.textures.border
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
			TRB.Data.settings.shaman.elemental.textures.border = newValue
			TRB.Data.settings.shaman.elemental.textures.borderName = newName
			if TRB.Data.settings.shaman.elemental.bar.border < 1 then
				barBorderFrame:SetBackdrop({ })
			else
				barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.shaman.elemental.textures.border,
											tile = true,
											tileSize=4,
											edgeSize=TRB.Data.settings.shaman.elemental.bar.border,
											insets = {0, 0, 0, 0}
											})
			end
			barBorderFrame:SetBackdropColor(0, 0, 0, 0)
			barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.border, true))
			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TIBBackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.shaman.elemental.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.shaman.elemental.textures.background
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
			TRB.Data.settings.shaman.elemental.textures.background = newValue
			TRB.Data.settings.shaman.elemental.textures.backgroundName = newName
			barContainerFrame:SetBackdrop({
				bgFile = TRB.Data.settings.shaman.elemental.textures.background,
				tile = true,
				tileSize = TRB.Data.settings.shaman.elemental.bar.width,
				edgeSize = 1,
				insets = {0, 0, 0, 0}
			})
			barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.background, true))
			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.shaman.elemental.colors.bar.flashAlpha, 0.01, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.shaman.elemental.colors.bar.flashPeriod, 0.05, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TIBRB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.shaman.elemental.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.shaman.elemental.displayBar.alwaysShow = true
			TRB.Data.settings.shaman.elemental.displayBar.notZeroShow = false
			TRB.Data.settings.shaman.elemental.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TIBRB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Maelstrom > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Maelstrom > 0, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.shaman.elemental.displayBar.alwaysShow = false
			TRB.Data.settings.shaman.elemental.displayBar.notZeroShow = true
			TRB.Data.settings.shaman.elemental.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TIBRB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.shaman.elemental.displayBar.alwaysShow = false
			TRB.Data.settings.shaman.elemental.displayBar.notZeroShow = false
			TRB.Data.settings.shaman.elemental.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TIBRB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.shaman.elemental.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.shaman.elemental.displayBar.alwaysShow = false
			TRB.Data.settings.shaman.elemental.displayBar.notZeroShow = false
			TRB.Data.settings.shaman.elemental.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.shaman.elemental.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.shaman.elemental.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.bar.showPassive = self:GetChecked()
		end)

		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TIBCB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Earth Shock/EQ is Usable")
		f.tooltip = "This will flash the bar when Earth Shock/EQ can be cast."
		f:SetChecked(TRB.Data.settings.shaman.elemental.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.colors.bar.flashEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 70

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Maelstrom", TRB.Data.settings.shaman.elemental.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.shaman.elemental.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.earthShock = TRB.UiFunctions.BuildColorPicker(parent, "Maelstrom when you can cast Earth Shock/Earthquake", TRB.Data.settings.shaman.elemental.colors.bar.earthShock, 300, 25, xCoord, yCoord)
		f = controls.colors.earthShock
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.earthShock, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.earthShock.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.bar.earthShock = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.shaman.elemental.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Maelstrom from hardcasting spells", TRB.Data.settings.shaman.elemental.colors.bar.casting, 525, 25, xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    castingFrame:SetStatusBarColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when your current hardcast will overcap Maelstrom", TRB.Data.settings.shaman.elemental.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.borderOvercap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.shaman.elemental.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Maelstrom from Passive Sources", TRB.Data.settings.shaman.elemental.colors.bar.passive, 550, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

					controls.colors.passive.Texture:SetColorTexture(r, g, b, 1-a)
					passiveFrame:SetStatusBarColor(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)


		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Maelstrom", TRB.Data.settings.shaman.elemental.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Maelstrom", TRB.Data.settings.shaman.elemental.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.shaman.elemental.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.shaman.elemental)
		end)

		controls.checkBoxes.esThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Threshold_Option_earthShock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Earth Shock/Earthquake")
		f.tooltip = "This will show the vertical line on the bar denoting how much Maelstrom is required to cast Earth Shock/Earthquake."
		f:SetChecked(TRB.Data.settings.shaman.elemental.earthShockThreshold)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.earthShockThreshold = self:GetChecked()
		end)


		yCoord = yCoord - 25
		yCoord = yCoord - 25
		yCoord = yCoord - 25

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TIBCB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current hardcast spell will result in overcapping maximum Insanity."
		f:SetChecked(TRB.Data.settings.shaman.elemental.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 100, TRB.Data.settings.shaman.elemental.overcapThreshold, 0.5, 1,
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
			TRB.Data.settings.shaman.elemental.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
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

		controls.buttons.exportButton_Shaman_Elemental_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Font & Text).", 7, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TIBFontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.shaman.elemental.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.shaman.elemental.displayText.left.fontFace
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
			TRB.Data.settings.shaman.elemental.displayText.left.fontFace = newValue
			TRB.Data.settings.shaman.elemental.displayText.left.fontFaceName = newName
			leftTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.left.fontFace, TRB.Data.settings.shaman.elemental.displayText.left.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.shaman.elemental.displayText.fontFaceLock then
				TRB.Data.settings.shaman.elemental.displayText.middle.fontFace = newValue
				TRB.Data.settings.shaman.elemental.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.middle.fontFace, TRB.Data.settings.shaman.elemental.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.shaman.elemental.displayText.right.fontFace = newValue
				TRB.Data.settings.shaman.elemental.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.right.fontFace, TRB.Data.settings.shaman.elemental.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TIBfFontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.shaman.elemental.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.shaman.elemental.displayText.middle.fontFace
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
			TRB.Data.settings.shaman.elemental.displayText.middle.fontFace = newValue
			TRB.Data.settings.shaman.elemental.displayText.middle.fontFaceName = newName
			middleTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.middle.fontFace, TRB.Data.settings.shaman.elemental.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.shaman.elemental.displayText.fontFaceLock then
				TRB.Data.settings.shaman.elemental.displayText.left.fontFace = newValue
				TRB.Data.settings.shaman.elemental.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.left.fontFace, TRB.Data.settings.shaman.elemental.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.shaman.elemental.displayText.right.fontFace = newValue
				TRB.Data.settings.shaman.elemental.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.right.fontFace, TRB.Data.settings.shaman.elemental.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end
			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TIBFontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.shaman.elemental.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.shaman.elemental.displayText.right.fontFace
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
			TRB.Data.settings.shaman.elemental.displayText.right.fontFace = newValue
			TRB.Data.settings.shaman.elemental.displayText.right.fontFaceName = newName
			rightTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.right.fontFace, TRB.Data.settings.shaman.elemental.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.shaman.elemental.displayText.fontFaceLock then
				TRB.Data.settings.shaman.elemental.displayText.left.fontFace = newValue
				TRB.Data.settings.shaman.elemental.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.left.fontFace, TRB.Data.settings.shaman.elemental.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.shaman.elemental.displayText.middle.fontFace = newValue
				TRB.Data.settings.shaman.elemental.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.middle.fontFace, TRB.Data.settings.shaman.elemental.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end
			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TIBCB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.shaman.elemental.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.shaman.elemental.displayText.fontFaceLock then
				TRB.Data.settings.shaman.elemental.displayText.middle.fontFace = TRB.Data.settings.shaman.elemental.displayText.left.fontFace
				TRB.Data.settings.shaman.elemental.displayText.middle.fontFaceName = TRB.Data.settings.shaman.elemental.displayText.left.fontFaceName
				middleTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.middle.fontFace, TRB.Data.settings.shaman.elemental.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.shaman.elemental.displayText.middle.fontFaceName)
				TRB.Data.settings.shaman.elemental.displayText.right.fontFace = TRB.Data.settings.shaman.elemental.displayText.left.fontFace
				TRB.Data.settings.shaman.elemental.displayText.right.fontFaceName = TRB.Data.settings.shaman.elemental.displayText.left.fontFaceName
				rightTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.right.fontFace, TRB.Data.settings.shaman.elemental.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.shaman.elemental.displayText.right.fontFaceName)
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.shaman.elemental.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.displayText.left.fontSize = value
			leftTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.left.fontFace, TRB.Data.settings.shaman.elemental.displayText.left.fontSize, "OUTLINE")
			if TRB.Data.settings.shaman.elemental.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TIBCB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.shaman.elemental.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.shaman.elemental.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.shaman.elemental.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.shaman.elemental.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.shaman.elemental.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.left, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.shaman.elemental.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.middle, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.shaman.elemental.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.right, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.shaman.elemental.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.displayText.middle.fontSize = value
			middleTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.middle.fontFace, TRB.Data.settings.shaman.elemental.displayText.middle.fontSize, "OUTLINE")
			if TRB.Data.settings.shaman.elemental.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.shaman.elemental.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.shaman.elemental.displayText.right.fontSize = value
			rightTextFrame.font:SetFont(TRB.Data.settings.shaman.elemental.displayText.right.fontFace, TRB.Data.settings.shaman.elemental.displayText.right.fontSize, "OUTLINE")
			if TRB.Data.settings.shaman.elemental.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Maelstrom Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentMaelstromText = TRB.UiFunctions.BuildColorPicker(parent, "Current Maelstrom", TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom, 300, 25, xCoord, yCoord)
		f = controls.colors.currentMaelstromText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.currentMaelstromText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.castingMaelstromText = TRB.UiFunctions.BuildColorPicker(parent, "Maelstrom from hardcasting spells", TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom, 275, 25, xCoord2, yCoord)
		f = controls.colors.castingMaelstromText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0

                    controls.colors.castingMaelstromText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passiveMaelstromText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Maelstrom", TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom, 300, 25, xCoord, yCoord)
		f = controls.colors.passiveMaelstromText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.passiveMaelstromText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdmaelstromText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Maelstrom to cast Earth Shock or Earthquake", TRB.Data.settings.shaman.elemental.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdmaelstromText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.overThreshold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.thresholdmaelstromText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.shaman.elemental.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapmaelstromText = TRB.UiFunctions.BuildColorPicker(parent, "Cast will overcap Maelstrom", TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapmaelstromText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.overcapmaelstromText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Maelstrom text color when you are able to cast Earth Shock or Earthquake."
		f:SetChecked(TRB.Data.settings.shaman.elemental.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Maelstrom text color when your current hardcast spell will result in overcapping maximum Maelstrom."
		f:SetChecked(TRB.Data.settings.shaman.elemental.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions.BuildSectionHeader(parent, "DoT Count Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up colors counters ($fsCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.shaman.elemental.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.shaman.elemental.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.dots.up, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions.BuildColorPicker(parent, "DoT is not active on current target", TRB.Data.settings.shaman.elemental.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.text.dots.down, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end

                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.shaman.elemental.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
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

		controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Audio & Tracking).", 7, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.esReady = CreateFrame("CheckButton", "TIBCB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esReady
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Earth Shock/EQ is usable")
		f.tooltip = "Play an audio cue when Earth Shock or Earthquake can be cast."
		f:SetChecked(TRB.Data.settings.shaman.elemental.audio.esReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.audio.esReady.enabled = self:GetChecked()
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.esReadyAudio = CreateFrame("FRAME", "TIBesReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.esReadyAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.esReadyAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.esReadyAudio, TRB.Data.settings.shaman.elemental.audio.esReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.esReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.esReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.shaman.elemental.audio.esReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.esReadyAudio:SetValue(newValue, newName)
			TRB.Data.settings.shaman.elemental.audio.esReady.sound = newValue
			TRB.Data.settings.shaman.elemental.audio.esReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.esReadyAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.esReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TIBCB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Maelstrom")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Maelstrom."
		f:SetChecked(TRB.Data.settings.shaman.elemental.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.shaman.elemental.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.shaman.elemental.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TIBovercapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.shaman.elemental.audio.overcap.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.shaman.elemental.audio.overcap.sound
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
			TRB.Data.settings.shaman.elemental.audio.overcap.sound = newValue
			TRB.Data.settings.shaman.elemental.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 40
		title = "Haste / Crit / Mastery Decimals to Show"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.shaman.elemental.hastePrecision, 1, 0,
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
			TRB.Data.settings.shaman.elemental.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls
	end

	local function ElementalConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.elemental
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		controls.buttons.exportButton_Shaman_Elemental_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Shaman_Elemental_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Bar Text).", 7, 1, false, false, false, true, false)
		end)

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)

		yCoord = yCoord - 30
		controls.labels.leftText = TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.shaman.elemental.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.shaman.elemental.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.elemental)
		end)

		yCoord = yCoord - 30
		controls.labels.middleText = TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.shaman.elemental.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.shaman.elemental.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.elemental)
		end)

		yCoord = yCoord - 30
		controls.labels.rightText = TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.shaman.elemental.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.shaman.elemental.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.elemental)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function ElementalConstructOptionsPanel()
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls
		local yCoord = 0
		local f = nil
		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275
		interfaceSettingsFrame.elementalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Elemental", UIParent)
		interfaceSettingsFrame.elementalDisplayPanel.name = "Elemental Shaman"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.elementalDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.elementalDisplayPanel)

		parent = interfaceSettingsFrame.elementalDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Elemental Shaman", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.elementalShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_elementalShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.elementalShamanEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Elemental Shaman specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.shaman.elemental)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.shaman.elemental = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.elementalShamanEnabled, TRB.Data.settings.core.enabled.shaman.elemental, true)
		end)

		TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.elementalShamanEnabled, TRB.Data.settings.core.enabled.shaman.elemental, true)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Shaman_Elemental_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Shaman_Elemental_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (All).", 7, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Shaman_Elemental_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Shaman_Elemental_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls

		ElementalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		ElementalConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		ElementalConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		ElementalConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, TRB.Data)
		ElementalConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel()
		TRB.Options.ConstructOptionsPanel()
		ElementalConstructOptionsPanel()
	end
	TRB.Options.Shaman.ConstructOptionsPanel = ConstructOptionsPanel
end