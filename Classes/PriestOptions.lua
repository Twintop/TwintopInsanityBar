local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
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

	TRB.Options.Priest = {}
	TRB.Options.Priest.Discipline = {}
	TRB.Options.Priest.Holy = {}
	TRB.Options.Priest.Shadow = {}

	local function ShadowLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				outVoidformText="$haste%",
				inVoidformText="$haste%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				outVoidformText="",
				inVoidformText="{$hvTime}[$hvTime sec. (+$vbCasts)][$vfTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				outVoidformText="{$casting}[$casting + ]{$passive}[$passive + ]$insanity%",
				inVoidformText="{$casting}[$casting + ]{$passive}[$passive + ]$insanity%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

	local function ShadowLoadDefaultBarTextAdvancedSettings()
		local textSettings = {		
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				outVoidformText = "#swp $swpCount   #dp $dpCount   $haste% ($gcd)||n#vt $vtCount   {$cttvEquipped}[#loi $ecttvCount][       ]   {$ttd}[TTD: $ttd]",
				inVoidformText = "#swp $swpCount   #dp $dpCount   $haste% ($gcd)||n#vt $vtCount   {$cttvEquipped}[#loi $ecttvCount][       ]   {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				outVoidformText = "{$mdTime}[#mDev $mdTime #mDev]",
				inVoidformText = "{$mdTime}[#mDev $mdTime #mDev||n]{$hvAvgTime}[$hvAvgTime (+$vbAvgCasts)][$vfTime]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				outVoidformText = "{$casting}[#casting$casting+]{$asCount}[#as$asInsanity+]{$mbInsanity}[#mindbender$mbInsanity+]{$loiInsanity}[#loi$loiInsanity+]{$damInsanity}[#dam$damInsanity+]$insanity",
				inVoidformText = "{$casting}[#casting$casting+]{$asCount}[#as$asInsanity+]{$mbInsanity}[#mindbender$mbInsanity+]{$loiInsanity}[#loi$loiInsanity+]{$damInsanity}[#dam$damInsanity+]$insanity",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",			
				fontSize = 22
			}
		}

		return textSettings
	end

	local function ShadowLoadDefaultBarTextNarrowAdvancedSettings()
		local textSettings = {		
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				outVoidformText = "#swp $swpCount   $haste% ($gcd)||n#vt $vtCount   {$ttd}[TTD: $ttd]",
				inVoidformText = "#swp $swpCount   $haste% ($gcd)||n#vt $vtCount   {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				outVoidformText = "{$mdTime}[#mDev $mdTime #mDev]",
				inVoidformText = "{$mdTime}[#mDev $mdTime #mDev||n]{$hvAvgTime}[$hvAvgTime (+$vbAvgCasts)][$vfTime]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				outVoidformText = "{$casting}[#casting$casting+]{$passive}[$passive+]$insanity",
				inVoidformText = "{$casting}[#casting$casting+]{$passive}[$passive+]$insanity",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",			
				fontSize = 22
			}
		}

		return textSettings
	end

	local function ShadowLoadDefaultSettings()
		local settings = {
			hasteApproachingThreshold=135,
			hasteThreshold=140,
			s2mApproachingThreshold=15,
			s2mThreshold=20,
			hastePrecision=2,
			fotmPrecision=true,
			devouringPlagueThreshold=true,
			searingNightmareThreshold=true,
			thresholdWidth=2,
			auspiciousSpiritsTracker=true,
			voidTendrilTracker=true,
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
			mindbender={
				mode="gcd",
				swingsMax=4,
				gcdsMax=2,
				timeMax=3.0,
				enabled=true,
				useNotification = {
					enabled=false,
					thresholdStacks=10
				}
			},
			colors={
				text={
					currentInsanity="FFC2A3E0",
					castingInsanity="FFFFFFFF",
					passiveInsanity="FFDF00FF",		
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF",
					hasteBelow="FFFFFFFF",
					hasteApproaching="FFFFFF00",
					hasteAbove="FF00FF00",
					s2mBelow="FF00FF00",
					s2mApproaching="FFFFFF00",
					s2mAbove="FFFF0000"
				},
				bar={
					border="FF431863",
					background="66000000",
					base="FF763BAF",
					enterVoidform="FF5C2F89",
					inVoidform="FF431863",
					inVoidform2GCD="FFFFFF00",
					inVoidform1GCD="FFFF0000",
					casting="FFFFFFFF",
					passive="FFDF00FF",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true
				},
				threshold={
					under="FFFFFFFF",
					over="FF00FF00",
					mindbender="FFFF11FF"
				}
			},
			displayText={},
			audio={
				s2mDeath={
					enabled=true,
					sound="Interface\\Addons\\TwintopInsanityBar\\wilhelm.ogg",
					soundName="Wilhelm Scream (TIB)"
				},
				dpReady={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg",
					soundName="Boxing Arena Gong (TIB)"
				},
				mdProc={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg",
					soundName="Boxing Arena Gong (TIB)"
				},
				mindbender={
					sound="Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg",
					soundName="Boxing Arena Gong (TIB)"
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

		settings.displayText = ShadowLoadDefaultBarTextSimpleSettings()
		return settings
	end

	local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()
		settings.priest.shadow = ShadowLoadDefaultSettings()
		return settings
	end
	TRB.Options.Priest.LoadDefaultSettings = LoadDefaultSettings

	local function ShadowConstructOptionsLayoutPanel()
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls
		local yCoord = -5
		local f = nil
		interfaceSettingsFrame.shadowOptionsLayoutPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopResourceBar_Shadow_OptionsLayoutPanel", parent)
		interfaceSettingsFrame.shadowOptionsLayoutPanel.name = "Shadow - Options"
		interfaceSettingsFrame.shadowOptionsLayoutPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.shadowOptionsLayoutPanel)

		parent = interfaceSettingsFrame.shadowOptionsLayoutPanel.scrollChild

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

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.priest.shadow.bar.height/8), math.floor(TRB.Data.settings.priest.shadow.bar.width/8))


		StaticPopupDialogs["TwintopResourceBar_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to it's default configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				ShadowLoadDefaultSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (simple) configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.priest.shadow.displayText = ShadowLoadDefaultBarTextSimpleSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (advanced) configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.priest.shadow.displayText = ShadowLoadDefaultBarTextAdvancedSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (narrow advanced) configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.priest.shadow.displayText = ShadowLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

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
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinWidth, TRB.Data.sanityCheckValues.barMaxWidth, TRB.Data.settings.priest.shadow.bar.width, 1, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.priest.shadow.bar.width = value
			barContainerFrame:SetWidth(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			barBorderFrame:SetWidth(TRB.Data.settings.priest.shadow.bar.width)
			resourceFrame:SetWidth(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			castingFrame:SetWidth(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			passiveFrame:SetWidth(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			TRB.Functions.RepositionThreshold(resourceFrame.thresholdDp, resourceFrame, TRB.Data.character.devouringPlagueThreshold, TRB.Data.character.maxResource)
			TRB.Functions.RepositionThreshold(resourceFrame.thresholdSn, resourceFrame, TRB.Data.character.searingNightmareThreshold, TRB.Data.character.maxResource)
			local maxBorderSize = math.min(math.floor(TRB.Data.settings.priest.shadow.bar.height / 8), math.floor(TRB.Data.settings.priest.shadow.bar.width / 8))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinHeight, TRB.Data.sanityCheckValues.barMaxHeight, TRB.Data.settings.priest.shadow.bar.height, 1, 2,
										barWidth, barHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end		
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.bar.height = value
			barContainerFrame:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			barBorderFrame:SetHeight(TRB.Data.settings.priest.shadow.bar.height)
			resourceFrame:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			resourceFrame.thresholdDp:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			resourceFrame.thresholdSn:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			castingFrame:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			passiveFrame:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))
			passiveFrame.threshold:SetHeight(value-(TRB.Data.settings.priest.shadow.bar.border*2))		
			leftTextFrame:SetHeight(TRB.Data.settings.priest.shadow.bar.height * 3.5)
			middleTextFrame:SetHeight(TRB.Data.settings.priest.shadow.bar.height * 3.5)
			rightTextFrame:SetHeight(TRB.Data.settings.priest.shadow.bar.height * 3.5)
			local maxBorderSize = math.min(math.floor(TRB.Data.settings.priest.shadow.bar.height / 8), math.floor(TRB.Data.settings.priest.shadow.bar.width / 8))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth/2), math.floor(TRB.Data.sanityCheckValues.barMaxWidth/2), TRB.Data.settings.priest.shadow.bar.xPos, 1, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.bar.xPos = value
			barContainerFrame:ClearAllPoints()
			barContainerFrame:SetPoint("CENTER", UIParent)
			barContainerFrame:SetPoint("CENTER", TRB.Data.settings.priest.shadow.bar.xPos, TRB.Data.settings.priest.shadow.bar.yPos)
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight/2), math.floor(TRB.Data.sanityCheckValues.barMaxHeight/2), TRB.Data.settings.priest.shadow.bar.yPos, 1, 2,
									barWidth, barHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.priest.shadow.bar.yPos = value
			barContainerFrame:ClearAllPoints()
			barContainerFrame:SetPoint("CENTER", UIParent)
			barContainerFrame:SetPoint("CENTER", TRB.Data.settings.priest.shadow.bar.xPos, TRB.Data.settings.priest.shadow.bar.yPos)
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.priest.shadow.bar.border, 1, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.bar.border = value
			barContainerFrame:SetWidth(TRB.Data.settings.priest.shadow.bar.width-(TRB.Data.settings.priest.shadow.bar.border*2))
			barContainerFrame:SetHeight(TRB.Data.settings.priest.shadow.bar.height-(TRB.Data.settings.priest.shadow.bar.border*2))
			barBorderFrame:SetWidth(TRB.Data.settings.priest.shadow.bar.width)
			barBorderFrame:SetHeight(TRB.Data.settings.priest.shadow.bar.height)
			if TRB.Data.settings.priest.shadow.bar.border < 1 then
				barBorderFrame:SetBackdrop({
					edgeFile = TRB.Data.settings.priest.shadow.textures.border,
					tile = true,
					tileSize = 4,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barBorderFrame:Hide()
			else
				barBorderFrame:SetBackdrop({ 
					edgeFile = TRB.Data.settings.priest.shadow.textures.border,
					tile = true,
					tileSize=4,
					edgeSize=TRB.Data.settings.priest.shadow.bar.border,								
					insets = {0, 0, 0, 0}
				})
				barBorderFrame:Show()
			end
			barBorderFrame:SetBackdropColor(0, 0, 0, 0)
			barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.border, true))

			local minBarWidth = math.max(TRB.Data.settings.priest.shadow.bar.border*2, 120)
			local minBarHeight = math.max(TRB.Data.settings.priest.shadow.bar.border*2, 1)
			controls.height:SetMinMaxValues(minBarHeight, TRB.Data.sanityCheckValues.barMaxHeight)
			controls.height.MinLabel:SetText(minBarHeight)
			controls.width:SetMinMaxValues(minBarWidth, TRB.Data.sanityCheckValues.barMaxWidth)
			controls.width.MinLabel:SetText(minBarWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.priest.shadow.thresholdWidth, 1, 2,
									barWidth, barHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.priest.shadow.thresholdWidth = value
			resourceFrame.thresholdDp:SetWidth(TRB.Data.settings.priest.shadow.thresholdWidth)
			resourceFrame.thresholdSn:SetWidth(TRB.Data.settings.priest.shadow.thresholdWidth)
			passiveFrame.threshold:SetWidth(TRB.Data.settings.priest.shadow.thresholdWidth)
		end)

		yCoord = yCoord - 40

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TIBCB1_1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved."
		f:SetChecked(TRB.Data.settings.priest.shadow.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable(TRB.Data.settings.priest.shadow.bar.dragAndDrop)
			barContainerFrame:EnableMouse(TRB.Data.settings.priest.shadow.bar.dragAndDrop)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", xCoord+xPadding, yCoord)
		yCoord = yCoord - 30
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TIBInsanityBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord+xPadding, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.priest.shadow.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.priest.shadow.textures.resourceBar
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
			TRB.Data.settings.priest.shadow.textures.resourceBar = newValue
			TRB.Data.settings.priest.shadow.textures.resourceBarName = newName
			resourceFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.resourceBar)
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.priest.shadow.textures.textureLock then
				TRB.Data.settings.priest.shadow.textures.castingBar = newValue
				TRB.Data.settings.priest.shadow.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.priest.shadow.textures.passiveBar = newValue
				TRB.Data.settings.priest.shadow.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.passiveBar)
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
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.priest.shadow.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.priest.shadow.textures.castingBar
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
			TRB.Data.settings.priest.shadow.textures.castingBar = newValue
			TRB.Data.settings.priest.shadow.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.priest.shadow.textures.textureLock then
				TRB.Data.settings.priest.shadow.textures.resourceBar = newValue
				TRB.Data.settings.priest.shadow.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.priest.shadow.textures.passiveBar = newValue
				TRB.Data.settings.priest.shadow.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.passiveBar)
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
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.priest.shadow.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.priest.shadow.textures.passiveBar
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
			TRB.Data.settings.priest.shadow.textures.passiveBar = newValue
			TRB.Data.settings.priest.shadow.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.priest.shadow.textures.textureLock then
				TRB.Data.settings.priest.shadow.textures.resourceBar = newValue
				TRB.Data.settings.priest.shadow.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.priest.shadow.textures.castingBar = newValue
				TRB.Data.settings.priest.shadow.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end
			CloseDropDownMenus()
		end	
		
		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TIBCB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.priest.shadow.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.priest.shadow.textures.textureLock then
				TRB.Data.settings.priest.shadow.textures.passiveBar = TRB.Data.settings.priest.shadow.textures.resourceBar
				TRB.Data.settings.priest.shadow.textures.passiveBarName = TRB.Data.settings.priest.shadow.textures.resourceBarName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.priest.shadow.textures.passiveBarName)
				TRB.Data.settings.priest.shadow.textures.castingBar = TRB.Data.settings.priest.shadow.textures.resourceBar
				TRB.Data.settings.priest.shadow.textures.castingBarName = TRB.Data.settings.priest.shadow.textures.resourceBarName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.priest.shadow.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.priest.shadow.textures.castingBarName)
			end
		end)


		yCoord = yCoord - 60
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TIBBorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord+xPadding, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.priest.shadow.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.priest.shadow.textures.border
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
			TRB.Data.settings.priest.shadow.textures.border = newValue
			TRB.Data.settings.priest.shadow.textures.borderName = newName
			if TRB.Data.settings.priest.shadow.bar.border < 1 then
				barBorderFrame:SetBackdrop({ })
			else
				barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.priest.shadow.textures.border,
											tile = true,
											tileSize=4,
											edgeSize=TRB.Data.settings.priest.shadow.bar.border,							
											insets = {0, 0, 0, 0}
											})
			end
			barBorderFrame:SetBackdropColor(0, 0, 0, 0)
			barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.border, true))
			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end
		
		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TIBBackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2-20, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2-30, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, 250)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.priest.shadow.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.priest.shadow.textures.background
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
			TRB.Data.settings.priest.shadow.textures.background = newValue
			TRB.Data.settings.priest.shadow.textures.backgroundName = newName
			barContainerFrame:SetBackdrop({ 
				bgFile = TRB.Data.settings.priest.shadow.textures.background,		
				tile = true,
				tileSize = TRB.Data.settings.priest.shadow.bar.width,
				edgeSize = 1,
				insets = {0, 0, 0, 0}
			})
			barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.background, true))
			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end

		
		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", xCoord+xPadding, yCoord)

		yCoord = yCoord - 50

		title = "Devouring Plague Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.priest.shadow.colors.bar.flashAlpha, 0.01, 2,
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
			TRB.Data.settings.priest.shadow.colors.bar.flashAlpha = value
		end)

		title = "Devouring Plague Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.priest.shadow.colors.bar.flashPeriod, 0.05, 2,
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
			TRB.Data.settings.priest.shadow.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TIBRB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.priest.shadow.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			TRB.Data.settings.priest.shadow.displayBar.alwaysShow = true
			TRB.Data.settings.priest.shadow.displayBar.notZeroShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TIBRB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Insanity > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Insanity > 0, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.priest.shadow.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			TRB.Data.settings.priest.shadow.displayBar.alwaysShow = false
			TRB.Data.settings.priest.shadow.displayBar.notZeroShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TIBRB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.priest.shadow.displayBar.alwaysShow) and (not TRB.Data.settings.priest.shadow.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			TRB.Data.settings.priest.shadow.displayBar.alwaysShow = false
			TRB.Data.settings.priest.shadow.displayBar.notZeroShow = false
			TRB.Functions.HideResourceBar()
		end)


		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TIBCB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Devouring Plague is Usable")
		f.tooltip = "This will flash the bar when Devouring Plague can be cast."
		f:SetChecked(TRB.Data.settings.priest.shadow.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.dpThresholdShow = CreateFrame("CheckButton", "TIBCB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThresholdShow
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show Devouring Plague Threshold Line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Devouring Plague."
		f:SetChecked(TRB.Data.settings.priest.shadow.devouringPlagueThreshold)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.devouringPlagueThreshold = self:GetChecked()
		end)

		controls.checkBoxes.snThresholdShow = CreateFrame("CheckButton", "TIBCB1_7", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.snThresholdShow
		f:SetPoint("TOPLEFT", xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Show Searing Nightmare Threshold Line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Searing Nightmare. Only visibile if spec'd in to Searing Nightmare and channeling Mind Sear."
		f:SetChecked(TRB.Data.settings.priest.shadow.searingNightmareThreshold)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.searingNightmareThreshold = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while not in Voidform", TRB.Data.settings.priest.shadow.colors.bar.base, 250, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.base.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.inVoidform = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while in Voidform", TRB.Data.settings.priest.shadow.colors.bar.inVoidform, 250, 25, xCoord2, yCoord)
		f = controls.colors.inVoidform
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.inVoidform.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.inVoidform = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.enterVoidform = TRB.UiFunctions.BuildColorPicker(parent, "Insanity when you can cast Devouring Plague", TRB.Data.settings.priest.shadow.colors.bar.enterVoidform, 250, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.enterVoidform
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.enterVoidform, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.enterVoidform.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.enterVoidform = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.priest.shadow.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.border.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
					barBorderFrame:SetBackdropBorderColor(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Insanity from hardcasting spells", TRB.Data.settings.priest.shadow.colors.bar.casting, 250, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.casting.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
					castingFrame:SetStatusBarColor(r, g, b, a)
				end)
			end
		end)	
			
		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.priest.shadow.colors.bar.background, 250, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.background.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
					barContainerFrame:SetBackdropColor(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under min. req. Insanity to cast Devouring Plague Threshold Line", TRB.Data.settings.priest.shadow.colors.threshold.under, 260, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)	
			
		controls.colors.inVoidform2GCD = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while you have between 1-2 GCDs left in Voidform", TRB.Data.settings.priest.shadow.colors.bar.inVoidform2GCD, 250, 25, xCoord2, yCoord)
		f = controls.colors.inVoidform2GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform2GCD, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.inVoidform2GCD.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.inVoidform2GCD = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over min. req. Insanity to cast Devouring Plague Threshold Line", TRB.Data.settings.priest.shadow.colors.threshold.over, 250, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.inVoidform1GCD = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while you have less than 1 GCD left in Voidform", TRB.Data.settings.priest.shadow.colors.bar.inVoidform1GCD, 250, 25, xCoord2, yCoord)
		f = controls.colors.inVoidform1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform1GCD, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
		
					controls.colors.inVoidform1GCD.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.inVoidform1GCD = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.mindbenderThreshold = TRB.UiFunctions.BuildColorPicker(parent, "Shadowfiend Insanity Gain Threshold Line", TRB.Data.settings.priest.shadow.colors.bar.passive, 250, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.mindbenderThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.mindbender, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					
					controls.colors.mindbenderThreshold.Texture:SetColorTexture(r, g, b, a)
					passiveFrame:SetStatusBarColor(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.threshold.mindbender = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Insanity from Auspicious Spirits, Shadowfiend swings, Death and Madness ticks, and Lash of Insanity ticks", TRB.Data.settings.priest.shadow.colors.bar.passive, 550, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					
					controls.colors.passive.Texture:SetColorTexture(r, g, b, a)
					passiveFrame:SetStatusBarColor(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
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
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.priest.shadow.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.priest.shadow.displayText.left.fontFace
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
			TRB.Data.settings.priest.shadow.displayText.left.fontFace = newValue
			TRB.Data.settings.priest.shadow.displayText.left.fontFaceName = newName
			leftTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.left.fontFace, TRB.Data.settings.priest.shadow.displayText.left.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.priest.shadow.displayText.fontFaceLock then
				TRB.Data.settings.priest.shadow.displayText.middle.fontFace = newValue
				TRB.Data.settings.priest.shadow.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.middle.fontFace, TRB.Data.settings.priest.shadow.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.priest.shadow.displayText.right.fontFace = newValue
				TRB.Data.settings.priest.shadow.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.right.fontFace, TRB.Data.settings.priest.shadow.displayText.right.fontSize, "OUTLINE")
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
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.priest.shadow.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.priest.shadow.displayText.middle.fontFace
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
			TRB.Data.settings.priest.shadow.displayText.middle.fontFace = newValue
			TRB.Data.settings.priest.shadow.displayText.middle.fontFaceName = newName
			middleTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.middle.fontFace, TRB.Data.settings.priest.shadow.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.priest.shadow.displayText.fontFaceLock then
				TRB.Data.settings.priest.shadow.displayText.left.fontFace = newValue
				TRB.Data.settings.priest.shadow.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.left.fontFace, TRB.Data.settings.priest.shadow.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)			
				TRB.Data.settings.priest.shadow.displayText.right.fontFace = newValue
				TRB.Data.settings.priest.shadow.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.right.fontFace, TRB.Data.settings.priest.shadow.displayText.right.fontSize, "OUTLINE")
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
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.priest.shadow.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.priest.shadow.displayText.right.fontFace
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
			TRB.Data.settings.priest.shadow.displayText.right.fontFace = newValue
			TRB.Data.settings.priest.shadow.displayText.right.fontFaceName = newName
			rightTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.right.fontFace, TRB.Data.settings.priest.shadow.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.priest.shadow.displayText.fontFaceLock then
				TRB.Data.settings.priest.shadow.displayText.left.fontFace = newValue
				TRB.Data.settings.priest.shadow.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.left.fontFace, TRB.Data.settings.priest.shadow.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.priest.shadow.displayText.middle.fontFace = newValue
				TRB.Data.settings.priest.shadow.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.middle.fontFace, TRB.Data.settings.priest.shadow.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end
			CloseDropDownMenus()
		end
		
		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TIBCB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.priest.shadow.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.priest.shadow.displayText.fontFaceLock then
				TRB.Data.settings.priest.shadow.displayText.middle.fontFace = TRB.Data.settings.priest.shadow.displayText.left.fontFace
				TRB.Data.settings.priest.shadow.displayText.middle.fontFaceName = TRB.Data.settings.priest.shadow.displayText.left.fontFaceName
				middleTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.middle.fontFace, TRB.Data.settings.priest.shadow.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.priest.shadow.displayText.middle.fontFaceName)
				TRB.Data.settings.priest.shadow.displayText.right.fontFace = TRB.Data.settings.priest.shadow.displayText.left.fontFace
				TRB.Data.settings.priest.shadow.displayText.right.fontFaceName = TRB.Data.settings.priest.shadow.displayText.left.fontFaceName
				rightTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.right.fontFace, TRB.Data.settings.priest.shadow.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.priest.shadow.displayText.right.fontFaceName)
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", xCoord+xPadding, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.priest.shadow.displayText.left.fontSize, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.displayText.left.fontSize = value
			leftTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.left.fontFace, TRB.Data.settings.priest.shadow.displayText.left.fontSize, "OUTLINE")
			if TRB.Data.settings.priest.shadow.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)
		
		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TIBCB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.priest.shadow.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.priest.shadow.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.priest.shadow.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.priest.shadow.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.priest.shadow.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.left, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.leftText.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.priest.shadow.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.middle, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.middleText.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
					--barContainerFrame:SetBackdropBorderColor(r, g, b, a)
				end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.priest.shadow.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.right, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.rightText.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
					--barContainerFrame:SetBackdropBorderColor(r, g, b, a)
				end)
			end
		end)
		
		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.priest.shadow.displayText.middle.fontSize, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.displayText.middle.fontSize = value
			middleTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.middle.fontFace, TRB.Data.settings.priest.shadow.displayText.middle.fontSize, "OUTLINE")
			if TRB.Data.settings.priest.shadow.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)
		
		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.priest.shadow.displayText.right.fontSize, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.displayText.right.fontSize = value
			rightTextFrame.font:SetFont(TRB.Data.settings.priest.shadow.displayText.right.fontFace, TRB.Data.settings.priest.shadow.displayText.right.fontSize, "OUTLINE")
			if TRB.Data.settings.priest.shadow.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Insanity Text Colors", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentInsanityText = TRB.UiFunctions.BuildColorPicker(parent, "Current Insanity", TRB.Data.settings.priest.shadow.colors.text.currentInsanity, 250, 25, xCoord+xPadding*2, yCoord)
		f = controls.colors.currentInsanityText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.currentInsanity, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.currentInsanityText.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.currentInsanity = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.castingInsanityText = TRB.UiFunctions.BuildColorPicker(parent, "Insanity from hardcasting spells", TRB.Data.settings.priest.shadow.colors.text.castingInsanity, 250, 25, xCoord2, yCoord)
		f = controls.colors.castingInsanityText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.currentInsanity, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.castingInsanityText.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.castingInsanity = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
					--barContainerFrame:SetBackdropBorderColor(r, g, b, a)
				end)
			end
		end)
		
		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Haste Threshold Colors in Voidform", xCoord+xPadding, yCoord)

		yCoord = yCoord - 50
		title = "Low to Medium Haste% Threshold in Voidform"
		controls.hasteApproachingThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 500, TRB.Data.settings.priest.shadow.hasteApproachingThreshold, 0.25, 2,
										barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value > TRB.Data.settings.priest.shadow.hasteThreshold then
				value = TRB.Data.settings.priest.shadow.hasteThreshold
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.hasteApproachingThreshold = value
		end)

		controls.colors.hasteBelow = TRB.UiFunctions.BuildColorPicker(parent, "Low Haste% in Voidform", TRB.Data.settings.priest.shadow.colors.text.hasteBelow,
													250, 25, xCoord2, yCoord+10)
		f = controls.colors.hasteBelow
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.hasteBelow, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.hasteBelow.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.hasteBelow = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.hasteApproaching = TRB.UiFunctions.BuildColorPicker(parent, "Medium Haste% in Voidform", TRB.Data.settings.priest.shadow.colors.text.hasteApproaching,
													250, 25, xCoord2, yCoord-30)
		f = controls.colors.hasteApproaching
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.hasteApproaching, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.hasteApproaching.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.hasteApproaching = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.hasteAbove = TRB.UiFunctions.BuildColorPicker(parent, "High Haste% in Voidform", TRB.Data.settings.priest.shadow.colors.text.hasteAbove,
													250, 25, xCoord2, yCoord-70)
		f = controls.colors.hasteAbove
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.hasteAbove, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.hasteAbove.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.hasteAbove = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 60	
		title = "Medium to High Haste% Threshold in Voidform"
		controls.hasteThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 500, TRB.Data.settings.priest.shadow.hasteThreshold, 0.25, 2,
										barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value < TRB.Data.settings.priest.shadow.hasteApproachingThreshold then
				value = TRB.Data.settings.priest.shadow.hasteApproachingThreshold
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.hasteThreshold = value
		end)
		
		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Surrender to Madness Target Time to Die Thresholds", xCoord+xPadding, yCoord)

		yCoord = yCoord - 50
		title = "Low to Medium S2M Time to Die Threshold (sec)"
		controls.s2mApproachingThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 30, TRB.Data.settings.priest.shadow.s2mApproachingThreshold, 0.25, 2,
										barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.s2mApproachingThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value > TRB.Data.settings.priest.shadow.s2mThreshold then
				value = TRB.Data.settings.priest.shadow.s2mThreshold
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.s2mApproachingThreshold = value
		end)

		controls.colors.s2mBelow = TRB.UiFunctions.BuildColorPicker(parent, "Low S2M Time to Die Threshold", TRB.Data.settings.priest.shadow.colors.text.s2mBelow,
													250, 25, xCoord2, yCoord+10)
		f = controls.colors.s2mBelow
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.s2mBelow, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.s2mBelow.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.s2mBelow = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.s2mApproaching = TRB.UiFunctions.BuildColorPicker(parent, "Medium S2M Time to Die", TRB.Data.settings.priest.shadow.colors.text.s2mApproaching,
													250, 25, xCoord2, yCoord-30)
		f = controls.colors.s2mApproaching
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.s2mApproaching, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.s2mApproaching.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.s2mApproaching = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		controls.colors.s2mAbove = TRB.UiFunctions.BuildColorPicker(parent, "High S2M Time to Die", TRB.Data.settings.priest.shadow.colors.text.s2mAbove,
													250, 25, xCoord2, yCoord-70)
		f = controls.colors.s2mAbove
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.text.s2mAbove, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 1.0
		
					controls.colors.s2mAbove.Texture:SetColorTexture(r, g, b, a)
					TRB.Data.settings.priest.shadow.colors.text.s2mAbove = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
				end)
			end
		end)

		yCoord = yCoord - 60	
		title = "Medium to High S2M Time to Die Threshold (sec)"
		controls.s2mThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 30, TRB.Data.settings.priest.shadow.s2mThreshold, 0.25, 2,
										barWidth, barHeight, xCoord+xPadding2, yCoord)
		controls.s2mThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value < TRB.Data.settings.priest.shadow.s2mApproachingThreshold then
				value = TRB.Data.settings.priest.shadow.s2mApproachingThreshold
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.s2mThreshold = value
		end)

		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", xCoord+xPadding, yCoord)
	
		yCoord = yCoord - 40
		title = "Haste / Crit / Mastery Decimals to Show"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.priest.shadow.hastePrecision, 1, 0,
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
			TRB.Data.settings.priest.shadow.hastePrecision = value
		end)

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TIBCB1_FOTM", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show decimals w/Fortress of the Mind")
		f.tooltip = "Show decimal values with Fortress of the Mind. If unchecked, rounded (approximate) values will be displayed instead."
		f:SetChecked(TRB.Data.settings.priest.shadow.fotmPrecision)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.fotmPrecision = self:GetChecked()
		end)

		yCoord = yCoord - 60		
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.s2mDeath = CreateFrame("CheckButton", "TIBCB3_2", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.s2mDeath
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio when you die, horribly, from Surrender to Madness")
		f.tooltip = "When you die, horribly, after Surrender to Madness ends, play the infamous Wilhelm Scream (or another sound) to make you feel a bit better."
		f:SetChecked(TRB.Data.settings.priest.shadow.audio.s2mDeath.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.audio.s2mDeath.enabled = self:GetChecked()
		end)	
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.s2mAudio = CreateFrame("FRAME", "TIBS2MDeathAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.s2mAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.s2mAudio, 300)
		UIDropDownMenu_SetText(controls.dropDown.s2mAudio, TRB.Data.settings.priest.shadow.audio.s2mDeath.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.s2mAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.s2mAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.priest.shadow.audio.s2mDeath.sound
						info.func = self.SetValue			
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.s2mAudio:SetValue(newValue, newName)
			TRB.Data.settings.priest.shadow.audio.s2mDeath.sound = newValue
			TRB.Data.settings.priest.shadow.audio.s2mDeath.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.s2mAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.priest.shadow.audio.s2mDeath.sound, TRB.Data.settings.priest.shadow.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.dpReady = CreateFrame("CheckButton", "TIBCB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpReady
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Devouring Plague is usable")
		f.tooltip = "Play an audio cue when Devouring Plague can be cast."
		f:SetChecked(TRB.Data.settings.priest.shadow.audio.dpReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.audio.dpReady.enabled = self:GetChecked()
		end)	
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.dpReadyAudio = CreateFrame("FRAME", "TIBdpReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.dpReadyAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.dpReadyAudio, 300)
		UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, TRB.Data.settings.priest.shadow.audio.dpReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.dpReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.dpReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.priest.shadow.audio.dpReady.sound
						info.func = self.SetValue			
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.dpReadyAudio:SetValue(newValue, newName)
			TRB.Data.settings.priest.shadow.audio.dpReady.sound = newValue
			TRB.Data.settings.priest.shadow.audio.dpReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.priest.shadow.audio.dpReady.sound, TRB.Data.settings.priest.shadow.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.dpReady = CreateFrame("CheckButton", "TIBCB3_MD_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpReady
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Mind Devourer proc occurs")
		f.tooltip = "Play an audio cue when a Mind Devourer proc occurs. This supercedes the regular Devouring Plague audio sound."
		f:SetChecked(TRB.Data.settings.priest.shadow.audio.mdProc.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.audio.mdProc.enabled = self:GetChecked()
		end)	
			
		-- Create the dropdown, and configure its appearance
		controls.dropDown.mdProcAudio = CreateFrame("FRAME", "TIBmdProcAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.mdProcAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.mdProcAudio, 300)
		UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, TRB.Data.settings.priest.shadow.audio.mdProc.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.mdProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.mdProcAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.priest.shadow.audio.mdProc.sound
						info.func = self.SetValue			
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.mdProcAudio:SetValue(newValue, newName)
			TRB.Data.settings.priest.shadow.audio.mdProc.sound = newValue
			TRB.Data.settings.priest.shadow.audio.mdProc.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mdProc.sound, TRB.Data.settings.priest.shadow.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Auspicious Spirits Tracking", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.as = CreateFrame("CheckButton", "TIBCB3_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.as
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Auspicious Spirits")
		f.tooltip = "Track Shadowy Apparitions in flight that will generate Insanity upon reaching their target with the Auspicious Spirits talent."
		f:SetChecked(TRB.Data.settings.priest.shadow.auspiciousSpiritsTracker)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.auspiciousSpiritsTracker = self:GetChecked()
			
			if ((TRB.Data.settings.priest.shadow.auspiciousSpiritsTracker and TRB.Data.character.talents.as.isSelected) or TRB.Functions.IsTtdActive()) and GetSpecialization() == 3 then
				targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			else
				targetsTimerFrame:SetScript("OnUpdate", nil)
			end	
			snapshotData.auspiciousSpirits.total = 0
			snapshotData.auspiciousSpirits.units = 0
			snapshotData.auspiciousSpirits.tracker = {}
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Eternal Call to the Void / Void Tendril + Void Lasher Tracking", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.as = CreateFrame("CheckButton", "TIBCB3_6a", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.as
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Eternal Call to the Void")
		f.tooltip = "Track Insanity generated from Lash of Insanity via Void Tendril + Void Lasher spawns / Eternal Call of the Void procs."
		f:SetChecked(TRB.Data.settings.priest.shadow.voidTendrilTracker)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.voidTendrilTracker = self:GetChecked()
			snapshotData.eternalCallToTheVoid.numberActive = 0
			snapshotData.eternalCallToTheVoid.resourceRaw = 0
			snapshotData.eternalCallToTheVoid.resourceFinal = 0
			snapshotData.eternalCallToTheVoid.maxTicksRemaining = 0
			snapshotData.eternalCallToTheVoid.voidTendrils = {}
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Shadowfiend/Mindbender Tracking", xCoord+xPadding, yCoord)

		yCoord = yCoord - 30	
		controls.checkBoxes.mindbender = CreateFrame("CheckButton", "TIBCB3_7", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindbender
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend Insanity Gain")
		f.tooltip = "Show the gain of Insanity over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below."
		f:SetChecked(TRB.Data.settings.priest.shadow.mindbender.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.mindbender.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30	
		controls.checkBoxes.mindbenderModeGCDs = CreateFrame("CheckButton", "TIBRB3_8", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeGCDs
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Insanity from GCDs remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Insanity incoming over the up to next X GCDs, based on player's current GCD."
		if TRB.Data.settings.priest.shadow.mindbender.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(true)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
			controls.checkBoxes.mindbenderModeTime:SetChecked(false)
			TRB.Data.settings.priest.shadow.mindbender.mode = "gcd"
		end)

		title = "Shadowfiend GCDs - 0.75sec Floor"
		controls.mindbenderGCDs = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.priest.shadow.mindbender.gcdsMax, 1, 0,
										barWidth, barHeight, xCoord2, yCoord)
		controls.mindbenderGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.mindbender.gcdsMax = value
		end)


		yCoord = yCoord - 60	
		controls.checkBoxes.mindbenderModeSwings = CreateFrame("CheckButton", "TIBRB3_9", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeSwings
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Insanity from Swings remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Insanity incoming over the up to next X melee swings from Shadowfiend/Mindbender. This is only different from the GCD option if you are above 200% haste (GCD cap)."
		if TRB.Data.settings.priest.shadow.mindbender.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(true)
			controls.checkBoxes.mindbenderModeTime:SetChecked(false)
			TRB.Data.settings.priest.shadow.mindbender.mode = "swing"
		end)

		title = "Shadowfiend Swings - No Floor"
		controls.mindbenderSwings = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.priest.shadow.mindbender.swingsMax, 1, 0,
										barWidth, barHeight, xCoord2, yCoord)
		controls.mindbenderSwings:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.mindbender.swingsMax = value
		end)

		yCoord = yCoord - 60	
		controls.checkBoxes.mindbenderModeTime = CreateFrame("CheckButton", "TIBRB3_10", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeTime
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Insanity from Time remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Insanity incoming over the up to next X seconds."
		if TRB.Data.settings.priest.shadow.mindbender.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
			controls.checkBoxes.mindbenderModeTime:SetChecked(true)
			TRB.Data.settings.priest.shadow.mindbender.mode = "time"
		end)

		title = "Shadowfiend Time Remaining"
		controls.mindbenderTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.priest.shadow.mindbender.timeMax, 0.25, 2,
										barWidth, barHeight, xCoord2, yCoord)
		controls.mindbenderTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)		
			TRB.Data.settings.priest.shadow.mindbender.timeMax = value
		end)

		--[[
		yCoord = yCoord - 60	
		controls.checkBoxes.mindbenderAudio = CreateFrame("CheckButton", "TIBCB3_11", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindbenderAudio
		f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play Audio Cue to use Shadowfiend")
		f.tooltip = "Plays an audio cue when in Voidform, Shadowfiend/Mindbender is offcooldown, and the number of Drain Stacks is above a certain threshold."
		f:SetChecked(TRB.Data.settings.priest.shadow.mindbender.useNotification.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.priest.shadow.mindbender.useNotification.enabled = self:GetChecked()
			if TRB.Data.settings.priest.shadow.mindbender.useNotification.enabled then
				mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate) end)
			else
				mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
			end
		end)	
		
		yCoord = yCoord - 40
		-- Create the dropdown, and configure its appearance
		controls.dropDown.mindbenderAudio = CreateFrame("FRAME", "TIBMindbenderAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.mindbenderAudio.label = TRB.UiFunctions.BuildSectionHeader(parent, "Mindbender Ready Audio", xCoord+xPadding, yCoord)
		controls.dropDown.mindbenderAudio.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.mindbenderAudio:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.mindbenderAudio, 250)
		UIDropDownMenu_SetText(controls.dropDown.mindbenderAudio, TRB.Data.settings.priest.shadow.audio.mindbender.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.mindbenderAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.mindbenderAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == TRB.Data.settings.priest.shadow.audio.mindbender.sound
						info.func = self.SetValue			
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.mindbenderAudio:SetValue(newValue, newName)
			TRB.Data.settings.priest.shadow.audio.mindbender.sound = newValue
			TRB.Data.settings.priest.shadow.audio.mindbender.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.mindbenderAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mindbender.sound, TRB.Data.settings.priest.shadow.audio.channel.channel)
		end
		]]--
		
		--interfaceSettingsFrame.shadowOptionsLayoutPanel.scrollChild = parent
		--interfaceSettingsFrame.controls = controls
		--TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	end

	local function ShadowConstructBarTextDisplayLayoutPanel()	
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel		
		local controls = interfaceSettingsFrame.controls
		local yCoord = -5
		local f = nil
		interfaceSettingsFrame.shadowBarTextDisplayPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopResourceBar_Shadow_BarTextDisplayLayoutPanel", parent)
		interfaceSettingsFrame.shadowBarTextDisplayPanel.name = "Shadow - Bar Text"
		interfaceSettingsFrame.shadowBarTextDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.shadowBarTextDisplayPanel)

		parent = interfaceSettingsFrame.shadowBarTextDisplayPanel.scrollChild

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
		controls.labels.outVoidform = CreateFrame("Frame", nil, parent)
		f = controls.labels.outVoidform
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord+xPadding2+100, yCoord)
		f:SetWidth(225)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontNormal)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("CENTER")
		f.font:SetSize(225, 20)
		f.font:SetText("Out of Voidform")

		controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
		f = controls.labels.inVoidform
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parent)
		f:SetPoint("TOPLEFT", xCoord2+25, yCoord)
		f:SetWidth(200)
		f:SetHeight(20)
		f.font = f:CreateFontString(nil, "BACKGROUND")
		f.font:SetFontObject(GameFontNormal)
		f.font:SetPoint("LEFT", f, "LEFT")
		f.font:SetSize(0, 14)
		f.font:SetJustifyH("CENTER")
		f.font:SetSize(225, 20)
		f.font:SetText("In Voidform")

		yCoord = yCoord - 20
		controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
		f = controls.labels.inVoidform
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

		controls.textbox.voidformOutLeft = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.priest.shadow.displayText.left.outVoidformText,
														500, 225, 24, xCoord+xPadding*2+100, yCoord)
		f = controls.textbox.voidformOutLeft
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.priest.shadow.displayText.left.outVoidformText = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		controls.textbox.voidformInLeft = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.priest.shadow.displayText.left.inVoidformText,
														500, 225, 24, xCoord2+25, yCoord)
		f = controls.textbox.voidformInLeft
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.priest.shadow.displayText.left.inVoidformText = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		yCoord = yCoord - 30
		controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
		f = controls.labels.inVoidform
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

		controls.textbox.voidformOutMiddle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.priest.shadow.displayText.middle.outVoidformText,
														500, 225, 24, xCoord+xPadding*2+100, yCoord)
		f = controls.textbox.voidformOutMiddle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.priest.shadow.displayText.middle.outVoidformText = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		controls.textbox.voidformInMiddle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.priest.shadow.displayText.middle.inVoidformText,
														500, 225, 24, xCoord2+25, yCoord)
		f = controls.textbox.voidformInMiddle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.priest.shadow.displayText.middle.inVoidformText = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		yCoord = yCoord - 30
		controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
		f = controls.labels.inVoidform
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

		controls.textbox.voidformOutRight = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.priest.shadow.displayText.right.outVoidformText,
														500, 225, 24, xCoord+xPadding*2+100, yCoord)
		f = controls.textbox.voidformOutRight
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.priest.shadow.displayText.right.outVoidformText = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive()
		end)

		controls.textbox.voidformInRight = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.priest.shadow.displayText.right.inVoidformText,
														500, 225, 24, xCoord2+25, yCoord)
		f = controls.textbox.voidformInRight
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.priest.shadow.displayText.right.inVoidformText = self:GetText()
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

		--interfaceSettingsFrame.barTextPanel.variableFrame = TRB.UiFunctions.CreateScrollFrameContainer("TIB_VariablesFrame", interfaceSettingsFrame.barTextPanel)
		--interfaceSettingsFrame.barTextPanel.variableFrame:ClearAllPoints()
		--interfaceSettingsFrame.barTextPanel.variableFrame:SetPoint("TOPLEFT", xCoord, yCoord - 15)
		--parent = interfaceSettingsFrame.barTextPanel.variableFrame.scrollChild
		
		yCoord = yCoord - 25
		local yCoordTop = yCoord
		local entries1 = TRB.Functions.TableLength(TRB.Data.barTextVariables.values)
		for i=1, entries1 do
			if TRB.Data.barTextVariables.values[i].printInSettings == true then
				TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.values[i].variable, TRB.Data.barTextVariables.values[i].description, xCoord, yCoord, 115, 200, 20)
				yCoord = yCoord - 25
			end
		end

		local entries2 = TRB.Functions.TableLength(TRB.Data.barTextVariables.pipe)
		for i=1, entries2 do
			if TRB.Data.barTextVariables.pipe[i].printInSettings == true then
				TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.pipe[i].variable, TRB.Data.barTextVariables.pipe[i].description, xCoord, yCoord, 115, 200, 20)
				yCoord = yCoord - 25
			end
		end

		-----	
		

		yCoord = yCoordTop

		local entries3 = TRB.Functions.TableLength(TRB.Data.barTextVariables.icons)
		for i=1, entries3 do
			if TRB.Data.barTextVariables.icons[i].printInSettings == true then
				local text = ""
				if TRB.Data.barTextVariables.icons[i].icon ~= "" then
					text = TRB.Data.barTextVariables.icons[i].icon .. " "
				end
				TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.icons[i].variable, text .. TRB.Data.barTextVariables.icons[i].description, xCoord+115+200+25, yCoord, 50, 200, 20)
				yCoord = yCoord - 25
			end
		end
		
		--interfaceSettingsFrame.shadowBarTextDisplayPanel.scrollChild = parent
		--interfaceSettingsFrame.controls = controls
		--TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	end
	
	local function ConstructOptionsPanel()
		TRB.Options.ConstructOptionsPanel()
		ShadowConstructOptionsLayoutPanel()
		ShadowConstructBarTextDisplayLayoutPanel()
	end
	TRB.Options.Priest.ConstructOptionsPanel = ConstructOptionsPanel
end