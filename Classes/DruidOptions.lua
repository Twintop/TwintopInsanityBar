local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
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

	TRB.Options.Druid = {}
	TRB.Options.Druid.Balance = {}
	TRB.Options.Druid.Feral = {}
	TRB.Options.Druid.Guardian = {}
	TRB.Options.Druid.Restoration = {}
    
    
	local function BalanceLoadDefaultBarTextSimpleSettings()
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$astralPower",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function BalanceLoadDefaultBarTextAdvancedSettings()
		local textSettings = {		
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "#sunfire $sunfireCount    {$talentStellarFlare}[#stellarFlare $stellarFlareCount    ]$haste% ($gcd)||n#moonfire $moonfireCount     {$talentStellarFlare}[          ]{$ttd}[TTD: $ttd]",
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
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$astralPower",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",			
				fontSize = 22
			}
		}

		return textSettings
	end

	local function BalanceLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
			starsurgeThreshold=true,
			starfallThreshold=true,
			displayBar = {
				alwaysShow=false,
				notZeroShow=true
			},
			bar = {		
				width=555,
				height=34,
				xPos=0,
				yPos=-200,
				border=4,
				dragAndDrop=false
			},
			colors = {
				text = {
					current="FFFFB668",
					casting="FFFFFFFF",
					passive="FF00AA00",	
					overcap="FFFF0000",	
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
				},
				bar = {
					border="FFC16920",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFFF7C0A",
					lunar="FF144D72",
					solar="FFFFEE00",
					celestial="FF4A95CE",
					casting="FFFFFFFF",
					passive="FF006600",
					eclipse1GCD="FFFF0000",
					moonkinFormMissing="FFFF0000",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					starfallPandemic="FF8B0000"
				}
			},
			displayText = {},
			audio = {
				ssReady={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				sfReady={
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

		settings.displayText = BalanceLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function BalanceResetSettings()
		local settings = BalanceLoadDefaultSettings()
		return settings
	end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()
		local specId = GetSpecialization()
		settings.druid.balance = BalanceLoadDefaultSettings()
		return settings
	end
    TRB.Options.Druid.LoadDefaultSettings = LoadDefaultSettings

    
	local function BalanceConstructOptionsLayoutPanel()
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls
		local yCoord = -5
		local f = nil
		interfaceSettingsFrame.balanceOptionsLayoutPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopResourceBar_Shadow_OptionsLayoutPanel", parent)
		interfaceSettingsFrame.balanceOptionsLayoutPanel.name = "Balance - Options"
		interfaceSettingsFrame.balanceOptionsLayoutPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.balanceOptionsLayoutPanel)

		parent = interfaceSettingsFrame.balanceOptionsLayoutPanel.scrollChild

		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		local barWidth = 250
		local barHeight = 20
		local title = ""

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.druid.balance.bar.height/8), math.floor(TRB.Data.settings.druid.balance.bar.width/8))


		StaticPopupDialogs["TwintopResourceBar_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to it's default configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.druid.balance = BalanceResetSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (simple) configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.druid.balance.displayText = BalanceLoadDefaultBarTextSimpleSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (advanced) configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.druid.balance.displayText = BalanceLoadDefaultBarTextAdvancedSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (narrow advanced) configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.druid.balance.displayText = BalanceLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_ResetButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(150)
		f:SetHeight(30)
		f:SetText("Reset to Defaults")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()	
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)	
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Reset")
		end)

		yCoord = yCoord - 40		
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_ResetBarTextSimpleButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Simple)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()	
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)	
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_ResetBarTextSimple")
		end)

		yCoord = yCoord - 40
		--[[
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_ResetBarTextNarrowAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord2, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Narrow Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()	
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)	
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_ResetBarTextAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Full Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()	
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)	
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_ResetBarTextAdvanced")
		end)

		yCoord = yCoord - 40
		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", xCoord+xPadding, yCoord)
		
		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinWidth, TRB.Data.sanityCheckValues.barMaxWidth, TRB.Data.settings.druid.balance.bar.width, 1, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.druid.balance.bar.width = value
			barContainerFrame:SetWidth(value-(TRB.Data.settings.druid.balance.bar.border*2))
			barBorderFrame:SetWidth(TRB.Data.settings.druid.balance.bar.width)
			resourceFrame:SetWidth(value-(TRB.Data.settings.druid.balance.bar.border*2))
			castingFrame:SetWidth(value-(TRB.Data.settings.druid.balance.bar.border*2))
			passiveFrame:SetWidth(value-(TRB.Data.settings.druid.balance.bar.border*2))
			TRB.Functions.RepositionThreshold(resourceFrame.thresholdDp, resourceFrame, TRB.Data.character.devouringPlagueThreshold, TRB.Data.character.maxResource)
			TRB.Functions.RepositionThreshold(resourceFrame.thresholdSn, resourceFrame, TRB.Data.character.searingNightmareThreshold, TRB.Data.character.maxResource)
			local maxBorderSize = math.min(math.floor(TRB.Data.settings.druid.balance.bar.height / 8), math.floor(TRB.Data.settings.druid.balance.bar.width / 8))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinHeight, TRB.Data.sanityCheckValues.barMaxHeight, TRB.Data.settings.druid.balance.bar.height, 1, 2,
										barWidth, barHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end		
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.bar.height = value
			barContainerFrame:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))
			barBorderFrame:SetHeight(TRB.Data.settings.druid.balance.bar.height)
			resourceFrame:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))
			resourceFrame.thresholdDp:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))
			resourceFrame.thresholdSn:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))
			castingFrame:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))
			passiveFrame:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))
			passiveFrame.threshold:SetHeight(value-(TRB.Data.settings.druid.balance.bar.border*2))		
			leftTextFrame:SetHeight(TRB.Data.settings.druid.balance.bar.height * 3.5)
			middleTextFrame:SetHeight(TRB.Data.settings.druid.balance.bar.height * 3.5)
			rightTextFrame:SetHeight(TRB.Data.settings.druid.balance.bar.height * 3.5)
			local maxBorderSize = math.min(math.floor(TRB.Data.settings.druid.balance.bar.height / 8), math.floor(TRB.Data.settings.druid.balance.bar.width / 8))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth/2), math.floor(TRB.Data.sanityCheckValues.barMaxWidth/2), TRB.Data.settings.druid.balance.bar.xPos, 1, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.bar.xPos = value
			barContainerFrame:ClearAllPoints()
			barContainerFrame:SetPoint("CENTER", UIParent)
			barContainerFrame:SetPoint("CENTER", TRB.Data.settings.druid.balance.bar.xPos, TRB.Data.settings.druid.balance.bar.yPos)
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight/2), math.floor(TRB.Data.sanityCheckValues.barMaxHeight/2), TRB.Data.settings.druid.balance.bar.yPos, 1, 2,
									barWidth, barHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.druid.balance.bar.yPos = value
			barContainerFrame:ClearAllPoints()
			barContainerFrame:SetPoint("CENTER", UIParent)
			barContainerFrame:SetPoint("CENTER", TRB.Data.settings.druid.balance.bar.xPos, TRB.Data.settings.druid.balance.bar.yPos)
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.druid.balance.bar.border, 1, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.bar.border = value
			barContainerFrame:SetWidth(TRB.Data.settings.druid.balance.bar.width-(TRB.Data.settings.druid.balance.bar.border*2))
			barContainerFrame:SetHeight(TRB.Data.settings.druid.balance.bar.height-(TRB.Data.settings.druid.balance.bar.border*2))
			barBorderFrame:SetWidth(TRB.Data.settings.druid.balance.bar.width)
			barBorderFrame:SetHeight(TRB.Data.settings.druid.balance.bar.height)
			if TRB.Data.settings.druid.balance.bar.border < 1 then
				barBorderFrame:SetBackdrop({
					edgeFile = TRB.Data.settings.druid.balance.textures.border,
					tile = true,
					tileSize = 4,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barBorderFrame:Hide()
			else
				barBorderFrame:SetBackdrop({ 
					edgeFile = TRB.Data.settings.druid.balance.textures.border,
					tile = true,
					tileSize=4,
					edgeSize=TRB.Data.settings.druid.balance.bar.border,								
					insets = {0, 0, 0, 0}
				})
				barBorderFrame:Show()
			end
			barBorderFrame:SetBackdropColor(0, 0, 0, 0)
			barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.border, true))

			local minBarWidth = math.max(TRB.Data.settings.druid.balance.bar.border*2, 120)
			local minBarHeight = math.max(TRB.Data.settings.druid.balance.bar.border*2, 1)
			controls.height:SetMinMaxValues(minBarHeight, TRB.Data.sanityCheckValues.barMaxHeight)
			controls.height.MinLabel:SetText(minBarHeight)
			controls.width:SetMinMaxValues(minBarWidth, TRB.Data.sanityCheckValues.barMaxWidth)
			controls.width.MinLabel:SetText(minBarWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.druid.balance.thresholdWidth, 1, 2,
									barWidth, barHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.druid.balance.thresholdWidth = value
			resourceFrame.thresholdDp:SetWidth(TRB.Data.settings.druid.balance.thresholdWidth)
			resourceFrame.thresholdSn:SetWidth(TRB.Data.settings.druid.balance.thresholdWidth)
			passiveFrame.threshold:SetWidth(TRB.Data.settings.druid.balance.thresholdWidth)
		end)

		yCoord = yCoord - 40

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TIBCB1_1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved."
		f:SetChecked(TRB.Data.settings.druid.balance.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable(TRB.Data.settings.druid.balance.bar.dragAndDrop)
			barContainerFrame:EnableMouse(TRB.Data.settings.druid.balance.bar.dragAndDrop)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", xCoord+xPadding, yCoord)
		yCoord = yCoord - 30
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TIBResourceBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord+xPadding, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.druid.balance.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.druid.balance.textures.resourceBar
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
			TRB.Data.settings.druid.balance.textures.resourceBar = newValue
			TRB.Data.settings.druid.balance.textures.resourceBarName = newName
			resourceFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.resourceBar)
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.druid.balance.textures.textureLock then
				TRB.Data.settings.druid.balance.textures.castingBar = newValue
				TRB.Data.settings.druid.balance.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.druid.balance.textures.passiveBar = newValue
				TRB.Data.settings.druid.balance.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end
			CloseDropDownMenus()
		end
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TIBCastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2-20, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2-30, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.druid.balance.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.druid.balance.textures.castingBar
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
			TRB.Data.settings.druid.balance.textures.castingBar = newValue
			TRB.Data.settings.druid.balance.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.druid.balance.textures.textureLock then
				TRB.Data.settings.druid.balance.textures.resourceBar = newValue
				TRB.Data.settings.druid.balance.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.druid.balance.textures.passiveBar = newValue
				TRB.Data.settings.druid.balance.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end
			CloseDropDownMenus()
		end

		yCoord = yCoord - 60
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TIBPassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord+xPadding, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.druid.balance.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.druid.balance.textures.passiveBar
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
			TRB.Data.settings.druid.balance.textures.passiveBar = newValue
			TRB.Data.settings.druid.balance.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.druid.balance.textures.textureLock then
				TRB.Data.settings.druid.balance.textures.resourceBar = newValue
				TRB.Data.settings.druid.balance.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.druid.balance.textures.castingBar = newValue
				TRB.Data.settings.druid.balance.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end
			CloseDropDownMenus()
		end	
		
		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TIBCB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.druid.balance.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.druid.balance.textures.textureLock then
				TRB.Data.settings.druid.balance.textures.passiveBar = TRB.Data.settings.druid.balance.textures.resourceBar
				TRB.Data.settings.druid.balance.textures.passiveBarName = TRB.Data.settings.druid.balance.textures.resourceBarName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.druid.balance.textures.passiveBarName)
				TRB.Data.settings.druid.balance.textures.castingBar = TRB.Data.settings.druid.balance.textures.resourceBar
				TRB.Data.settings.druid.balance.textures.castingBarName = TRB.Data.settings.druid.balance.textures.resourceBarName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.druid.balance.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.druid.balance.textures.castingBarName)
			end
		end)


		yCoord = yCoord - 60
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TIBBorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord+xPadding, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.druid.balance.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.druid.balance.textures.border
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
			TRB.Data.settings.druid.balance.textures.border = newValue
			TRB.Data.settings.druid.balance.textures.borderName = newName
			if TRB.Data.settings.druid.balance.bar.border < 1 then
				barBorderFrame:SetBackdrop({ })
			else
				barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.druid.balance.textures.border,
											tile = true,
											tileSize=4,
											edgeSize=TRB.Data.settings.druid.balance.bar.border,							
											insets = {0, 0, 0, 0}
											})
			end
			barBorderFrame:SetBackdropColor(0, 0, 0, 0)
			barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.border, true))
			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TIBBackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2-20, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2-30, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.druid.balance.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.druid.balance.textures.background
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
			TRB.Data.settings.druid.balance.textures.background = newValue
			TRB.Data.settings.druid.balance.textures.backgroundName = newName
			barContainerFrame:SetBackdrop({ 
				bgFile = TRB.Data.settings.druid.balance.textures.background,		
				tile = true,
				tileSize = TRB.Data.settings.druid.balance.bar.width,
				edgeSize = 1,
				insets = {0, 0, 0, 0}
			})
			barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.background, true))
			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end

		
		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", xCoord+xPadding, yCoord)

		yCoord = yCoord - 50

		title = "Moonkin Form Missing Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.druid.balance.colors.bar.flashAlpha, 0.01, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end	

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.druid.balance.colors.bar.flashAlpha = value
		end)

		title = "Moonkin Form Missing Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.druid.balance.colors.bar.flashPeriod, 0.05, 2,
										barWidth, barHeight, xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TIBRB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.druid.balance.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			TRB.Data.settings.druid.balance.displayBar.alwaysShow = true
			TRB.Data.settings.druid.balance.displayBar.notZeroShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TIBRB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Astral Power > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Astral Power > 0 (or < 50 with Nature's Balance), hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.druid.balance.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			TRB.Data.settings.druid.balance.displayBar.alwaysShow = false
			TRB.Data.settings.druid.balance.displayBar.notZeroShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TIBRB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.druid.balance.displayBar.alwaysShow) and (not TRB.Data.settings.druid.balance.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			TRB.Data.settings.druid.balance.displayBar.alwaysShow = false
			TRB.Data.settings.druid.balance.displayBar.notZeroShow = false
			TRB.Functions.HideResourceBar()
		end)


		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TIBCB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Flash bar when Moonkin Form is missing")
		f.tooltip = "This will flash the bar when Moonkin Form is missing while in combat."
		f:SetChecked(TRB.Data.settings.druid.balance.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.ssThresholdShow = CreateFrame("CheckButton", "TIBCB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssThresholdShow
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show Starsurge threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Astral Power is required to cast Starsurge."
		f:SetChecked(TRB.Data.settings.druid.balance.starsurgeThreshold)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.starsurgeThreshold = self:GetChecked()
		end)

		controls.checkBoxes.sfThresholdShow = CreateFrame("CheckButton", "TIBCB1_7", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sfThresholdShow
		f:SetPoint("TOPLEFT", xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Show Starfall Threshold Line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Astral Power is required to cast Starfall."
		f:SetChecked(TRB.Data.settings.druid.balance.starfallThreshold)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.starfallThreshold = self:GetChecked()
		end)

		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TIBCB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current hardcast spell will result in overcapping maximum Astral Power."
		f:SetChecked(TRB.Data.settings.druid.balance.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 80

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Astral Power", TRB.Data.settings.druid.balance.colors.bar.base, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.solar = TRB.UiFunctions.BuildColorPicker(parent, "Eclipse (Solar) is Active", TRB.Data.settings.druid.balance.colors.bar.solar, 275, 25, xCoord2, yCoord)
		f = controls.colors.solar
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.solar, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.solar.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.solar = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.druid.balance.colors.bar.border, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
					barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.lunar = TRB.UiFunctions.BuildColorPicker(parent, "Eclipse (Lunar) is Active", TRB.Data.settings.druid.balance.colors.bar.lunar, 275, 25, xCoord2, yCoord)
		f = controls.colors.lunar
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.lunar, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.lunar.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.lunar = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Astral Power from hardcasting spells", TRB.Data.settings.druid.balance.colors.bar.casting, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
					castingFrame:SetStatusBarColor(r, g, b, 1-a)
				end)
			end
		end)
			
		controls.colors.celestial = TRB.UiFunctions.BuildColorPicker(parent, "Celestial Alignment / Incarnation: Chosen of Elune is Active", TRB.Data.settings.druid.balance.colors.bar.celestial, 275, 25, xCoord2, yCoord)
		f = controls.colors.celestial
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.celestial, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.celestial.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.celestial = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under min. req. Astral Power to cast Starsurge/Starfall Threshold Line", TRB.Data.settings.druid.balance.colors.threshold.under, 260, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.eclipse1GCD = TRB.UiFunctions.BuildColorPicker(parent, "Under 1 GCD left in Eclipse", TRB.Data.settings.druid.balance.colors.bar.eclipse1GCD, 275, 25, xCoord2, yCoord)
		f = controls.colors.eclipse1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.eclipse1GCD, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.eclipse1GCD.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.eclipse1GCD = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over min. req. Astral Power to cast Starsurge/Starfall Threshold Line", TRB.Data.settings.druid.balance.colors.threshold.over, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when your current hardcast will overcap Astral Power", TRB.Data.settings.druid.balance.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.borderOvercap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)


		yCoord = yCoord - 30
		controls.colors.starfallPandemic = TRB.UiFunctions.BuildColorPicker(parent, "Starfall Threshold Line when outside Pandemic refresh range", TRB.Data.settings.druid.balance.colors.threshold.starfallPandemic, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.starfallPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.starfallPandemic, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					
					controls.colors.starfallPandemic.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.threshold.starfallPandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)
		
		controls.colors.moonkinFormMissing = TRB.UiFunctions.BuildColorPicker(parent, "Moonkin Form missing when in combat", TRB.Data.settings.druid.balance.colors.bar.moonkinFormMissing, 275, 25, xCoord2, yCoord)
		f = controls.colors.moonkinFormMissing
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.moonkinFormMissing, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					
					controls.colors.moonkinFormMissing.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.moonkinFormMissing = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)
		

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Astral Power from Fury of Elune and Nature's Balance", TRB.Data.settings.druid.balance.colors.bar.passive, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.passive, true)
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
					TRB.Data.settings.druid.balance.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)		
		
		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.druid.balance.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
					barContainerFrame:SetBackdropColor(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 40
		
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TIBFontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord+xPadding, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, 250)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.druid.balance.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.druid.balance.displayText.left.fontFace
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

		-- Implement the function to change the favoriteNumber
		function controls.dropDown.fontLeft:SetValue(newValue, newName)
			TRB.Data.settings.druid.balance.displayText.left.fontFace = newValue
			TRB.Data.settings.druid.balance.displayText.left.fontFaceName = newName
			leftTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.left.fontFace, TRB.Data.settings.druid.balance.displayText.left.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.druid.balance.displayText.fontFaceLock then
				TRB.Data.settings.druid.balance.displayText.middle.fontFace = newValue
				TRB.Data.settings.druid.balance.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.middle.fontFace, TRB.Data.settings.druid.balance.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.druid.balance.displayText.right.fontFace = newValue
				TRB.Data.settings.druid.balance.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.right.fontFace, TRB.Data.settings.druid.balance.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end
			CloseDropDownMenus()
		end
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TIBfFontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2-20, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2-30, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, 250)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.druid.balance.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.druid.balance.displayText.middle.fontFace
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

		-- Implement the function to change the favoriteNumber
		function controls.dropDown.fontMiddle:SetValue(newValue, newName)
			TRB.Data.settings.druid.balance.displayText.middle.fontFace = newValue
			TRB.Data.settings.druid.balance.displayText.middle.fontFaceName = newName
			middleTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.middle.fontFace, TRB.Data.settings.druid.balance.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.druid.balance.displayText.fontFaceLock then
				TRB.Data.settings.druid.balance.displayText.left.fontFace = newValue
				TRB.Data.settings.druid.balance.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.left.fontFace, TRB.Data.settings.druid.balance.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)			
				TRB.Data.settings.druid.balance.displayText.right.fontFace = newValue
				TRB.Data.settings.druid.balance.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.right.fontFace, TRB.Data.settings.druid.balance.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end
			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TIBFontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord+xPadding, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, 250)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.druid.balance.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.druid.balance.displayText.right.fontFace
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

		-- Implement the function to change the favoriteNumber
		function controls.dropDown.fontRight:SetValue(newValue, newName)		
			TRB.Data.settings.druid.balance.displayText.right.fontFace = newValue
			TRB.Data.settings.druid.balance.displayText.right.fontFaceName = newName
			rightTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.right.fontFace, TRB.Data.settings.druid.balance.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.druid.balance.displayText.fontFaceLock then
				TRB.Data.settings.druid.balance.displayText.left.fontFace = newValue
				TRB.Data.settings.druid.balance.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.left.fontFace, TRB.Data.settings.druid.balance.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.druid.balance.displayText.middle.fontFace = newValue
				TRB.Data.settings.druid.balance.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.middle.fontFace, TRB.Data.settings.druid.balance.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end
			CloseDropDownMenus()
		end
		
		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TIBCB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.druid.balance.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.druid.balance.displayText.fontFaceLock then
				TRB.Data.settings.druid.balance.displayText.middle.fontFace = TRB.Data.settings.druid.balance.displayText.left.fontFace
				TRB.Data.settings.druid.balance.displayText.middle.fontFaceName = TRB.Data.settings.druid.balance.displayText.left.fontFaceName
				middleTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.middle.fontFace, TRB.Data.settings.druid.balance.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.druid.balance.displayText.middle.fontFaceName)
				TRB.Data.settings.druid.balance.displayText.right.fontFace = TRB.Data.settings.druid.balance.displayText.left.fontFace
				TRB.Data.settings.druid.balance.displayText.right.fontFaceName = TRB.Data.settings.druid.balance.displayText.left.fontFaceName
				rightTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.right.fontFace, TRB.Data.settings.druid.balance.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.druid.balance.displayText.right.fontFaceName)
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", xCoord+xPadding, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.druid.balance.displayText.left.fontSize, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.displayText.left.fontSize = value
			leftTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.left.fontFace, TRB.Data.settings.druid.balance.displayText.left.fontSize, "OUTLINE")
			if TRB.Data.settings.druid.balance.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)
		
		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TIBCB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.druid.balance.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.druid.balance.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.druid.balance.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.druid.balance.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.druid.balance.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.left, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.druid.balance.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.middle, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.druid.balance.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.right, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)
		
		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.druid.balance.displayText.middle.fontSize, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.displayText.middle.fontSize = value
			middleTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.middle.fontFace, TRB.Data.settings.druid.balance.displayText.middle.fontSize, "OUTLINE")
			if TRB.Data.settings.druid.balance.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)
		
		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.druid.balance.displayText.right.fontSize, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.displayText.right.fontSize = value
			rightTextFrame.font:SetFont(TRB.Data.settings.druid.balance.displayText.right.fontFace, TRB.Data.settings.druid.balance.displayText.right.fontSize, "OUTLINE")
			if TRB.Data.settings.druid.balance.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Astral Power Text Colors", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentAstralPowerText = TRB.UiFunctions.BuildColorPicker(parent, "Current Astral Power", TRB.Data.settings.druid.balance.colors.text.current, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.currentAstralPowerText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.current, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.currentAstralPowerText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.castingAstralPowerText = TRB.UiFunctions.BuildColorPicker(parent, "Astral Power from hardcasting spells", TRB.Data.settings.druid.balance.colors.text.casting, 275, 25, xCoord2, yCoord)
		f = controls.colors.castingAstralPowerText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.castingAstralPowerText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)
		
		yCoord = yCoord - 30
		controls.colors.thresholdAstralPowerText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Astral Power to cast Starsurge or Starfall", TRB.Data.settings.druid.balance.colors.text.overThreshold, 300, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.thresholdAstralPowerText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.overThreshold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.thresholdAstralPowerText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapAstralPowerText = TRB.UiFunctions.BuildColorPicker(parent, "Cast will overcap Astral Power", TRB.Data.settings.druid.balance.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapAstralPowerText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.text.overcap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.overcapAstralPowerText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.druid.balance.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		
		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding*3, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Astral Power text color when you are able to cast Starsurge or Starfall"
		f:SetChecked(TRB.Data.settings.druid.balance.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.colors.text.overThresholdEnabled = self:GetChecked()
		end)
		
		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Astral Power text color when your current hardcast spell will result in overcapping maximum Astral Power."
		f:SetChecked(TRB.Data.settings.druid.balance.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.colors.text.overcapEnabled = self:GetChecked()
		end)


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", xCoord+xPadding, yCoord)
	
		yCoord = yCoord - 40
		title = "Haste / Crit / Mastery Decimals to Show"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.druid.balance.hastePrecision, 1, 0,
										barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
	
			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)		
			TRB.Data.settings.druid.balance.hastePrecision = value
		end)

		yCoord = yCoord - 60		
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", xCoord+xPadding, yCoord)


		yCoord = yCoord - 40
		controls.checkBoxes.ssReady = CreateFrame("CheckButton", "TIBCB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssReady
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Starsurge is usable")
		f.tooltip = "Play an audio cue when Devouring Plague can be cast."
		f:SetChecked(TRB.Data.settings.druid.balance.audio.ssReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.audio.ssReady.enabled = self:GetChecked()

			if TRB.Data.settings.druid.balance.audio.ssReady.enabled then
				PlaySoundFile(TRB.Data.settings.druid.balance.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)	
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.ssReadyAudio = CreateFrame("FRAME", "TIBssReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.ssReadyAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.ssReadyAudio, 300)
		UIDropDownMenu_SetText(controls.dropDown.ssReadyAudio, TRB.Data.settings.druid.balance.audio.ssReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.ssReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.ssReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.druid.balance.audio.ssReady.sound
						info.func = self.SetValue			
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.ssReadyAudio:SetValue(newValue, newName)
			TRB.Data.settings.druid.balance.audio.dpReady.sound = newValue
			TRB.Data.settings.druid.balance.audio.dpReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.ssReadyAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.druid.balance.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.sfReady = CreateFrame("CheckButton", "TIBCB3_MD_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sfReady
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Starfall is usable")
		f.tooltip = "Play an audio cue when Starfall is usable. This supercedes the regular Starsurge audio sound if both are usable."
		f:SetChecked(TRB.Data.settings.druid.balance.audio.sfReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.audio.sfReady.enabled = self:GetChecked()

			if TRB.Data.settings.druid.balance.audio.sfReady.enabled then
				PlaySoundFile(TRB.Data.settings.druid.balance.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)	
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.sfReadyAudio = CreateFrame("FRAME", "TIBsfReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.sfReadyAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.sfReadyAudio, 300)
		UIDropDownMenu_SetText(controls.dropDown.sfReadyAudio, TRB.Data.settings.druid.balance.audio.sfReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.sfReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.sfReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.druid.balance.audio.sfReady.sound
						info.func = self.SetValue			
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.sfReadyAudio:SetValue(newValue, newName)
			TRB.Data.settings.druid.balance.audio.sfReady.sound = newValue
			TRB.Data.settings.druid.balance.audio.sfReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.sfReadyAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.druid.balance.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		
		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TIBCB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Astral Power")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Astral Power."
		f:SetChecked(TRB.Data.settings.druid.balance.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.druid.balance.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.druid.balance.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.druid.balance.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)	
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TIBovercapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, 300)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.druid.balance.audio.overcap.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.druid.balance.audio.overcap.sound
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
			TRB.Data.settings.druid.balance.audio.overcap.sound = newValue
			TRB.Data.settings.druid.balance.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.druid.balance.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		TRB.Frames.interfaceSettingsFrame = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrame.controls = controls
	end
    
	local function BalanceConstructBarTextDisplayLayoutPanel()	
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel		
		local controls = interfaceSettingsFrame.controls
		local yCoord = -5
		local f = nil
		interfaceSettingsFrame.balanceBarTextDisplayPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopResourceBar_Balance_BarTextDisplayLayoutPanel", parent)
		interfaceSettingsFrame.balanceBarTextDisplayPanel.name = "Balance - Bar Text"
		interfaceSettingsFrame.balanceBarTextDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.balanceBarTextDisplayPanel)

		parent = interfaceSettingsFrame.balanceBarTextDisplayPanel.scrollChild

		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		local barWidth = 250
		local barHeight = 20
		local title = ""

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display Text Customization", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.labels.text = CreateFrame("Frame", nil, parent)
		f = controls.labels.text
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(90)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontNormal)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("RIGHT")
		f.font:SetSize(90, 20)
		f.font:SetText("Left Text")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.druid.balance.displayText.left.text,
														500, 450, 24, xCoord+xPadding*2+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.druid.balance.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		yCoord = yCoord - 30
		controls.labels.text = CreateFrame("Frame", nil, parent)
		f = controls.labels.text
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(90)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontNormal)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("RIGHT")
		f.font:SetSize(90, 20)
		f.font:SetText("Middle Text")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.druid.balance.displayText.middle.text,
														500, 450, 24, xCoord+xPadding*2+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.druid.balance.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		yCoord = yCoord - 30
		controls.labels.text = CreateFrame("Frame", nil, parent)
		f = controls.labels.text
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(90)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontNormal)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("RIGHT")
		f.font:SetSize(90, 20)
		f.font:SetText("Right Text")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.druid.balance.displayText.right.text,
														500, 450, 24, xCoord+xPadding*2+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.druid.balance.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		yCoord = yCoord - 30
		controls.labels.instructionsVar = CreateFrame("Frame", nil, parent)
		f = controls.labels.instructionsVar
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(600)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontHighlight)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("LEFT")
		f.font:SetSize(600, 20)
		f.font:SetText("For conditional display (only if $VARIABLE is active/non-zero): {$VARIABLE}[WHAT TO DISPLAY]")
			
		yCoord = yCoord - 25
		controls.labels.instructionsVar = CreateFrame("Frame", nil, parent)
		f = controls.labels.instructionsVar
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(600)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontHighlight)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("LEFT")
		f.font:SetSize(600, 20)
		f.font:SetText("Limited Boolean NOT logic for conditional display is supported via {!$VARIABLE}")

		yCoord = yCoord - 25
		controls.labels.instructionsVar = CreateFrame("Frame", nil, parent)
		f = controls.labels.instructionsVar
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(600)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontHighlight)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("LEFT")
		f.font:SetSize(600, 20)
		f.font:SetText("IF/ELSE is supported via {$VARIABLE}[TRUE output][FALSE output] and includes NOT support")

		yCoord = yCoord - 25
		controls.labels.instructions2Var = CreateFrame("Frame", nil, parent)
		f = controls.labels.instructions2Var
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		f:SetWidth(600)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontHighlight)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("LEFT")
		f.font:SetSize(600, 20)
		f.font:SetText("For icons use #ICONVARIABLENAME")

		yCoord = yCoord - 25
		local yCoordTop = yCoord
		local entries1 = TRB.Functions.TableLength(TRB.Data.barTextVariables.values)
		for i=1, entries1 do
			if TRB.Data.barTextVariables.values[i].printInSettings == true then
				TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.values[i].variable, TRB.Data.barTextVariables.values[i].description, xCoord, yCoord, 150, 400, 15)
				local height = 15
				yCoord = yCoord - height - 5
			end
		end

		local entries2 = TRB.Functions.TableLength(TRB.Data.barTextVariables.pipe)
		for i=1, entries2 do
			if TRB.Data.barTextVariables.pipe[i].printInSettings == true then
				TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.pipe[i].variable, TRB.Data.barTextVariables.pipe[i].description, xCoord, yCoord, 150, 400, 15)
				local height = 15
				yCoord = yCoord - height - 5
			end
		end

		---------

		local entries3 = TRB.Functions.TableLength(TRB.Data.barTextVariables.icons)
		for i=1, entries3 do
			if TRB.Data.barTextVariables.icons[i].printInSettings == true then
				local text = ""
				if TRB.Data.barTextVariables.icons[i].icon ~= "" then
					text = TRB.Data.barTextVariables.icons[i].icon .. " "
				end
				local height = 15
				if TRB.Data.barTextVariables.icons[i].variable == "#casting" then
					height = 15
				end
				TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.icons[i].variable, text .. TRB.Data.barTextVariables.icons[i].description, xCoord, yCoord, 150, 400, height)
				yCoord = yCoord - height - 5
			end
		end
	end

	local function ConstructOptionsPanel()
		TRB.Options.ConstructOptionsPanel()
		BalanceConstructOptionsLayoutPanel()
		BalanceConstructBarTextDisplayLayoutPanel()
	end
	TRB.Options.Druid.ConstructOptionsPanel = ConstructOptionsPanel
end