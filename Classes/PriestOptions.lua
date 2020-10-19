local _, TRB = ...

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

local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer

TRB.Options = {}

local function LoadDefaultBarTextSimpleSettings()
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
TRB.Options.LoadDefaultBarTextSimpleSettings = LoadDefaultBarTextSimpleSettings

local function LoadDefaultBarTextAdvancedSettings()
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
TRB.Options.LoadDefaultBarTextAdvancedSettings = LoadDefaultBarTextAdvancedSettings

local function LoadDefaultBarTextNarrowAdvancedSettings()
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
TRB.Options.LoadDefaultBarTextNarrowAdvancedSettings = LoadDefaultBarTextNarrowAdvancedSettings

local function LoadDefaultSettings()
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
		dataRefreshRate = 5.0,
		ttd = {
			sampleRate = 0.2,
			numEntries = 50
		},
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
			},
			channel={
				name="Master",
				channel="Master"
			}
		},
		textures={
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			insanityBar="Interface\\TargetingFrame\\UI-StatusBar",
			insanityBarName="Blizzard",
			passiveBar="Interface\\TargetingFrame\\UI-StatusBar",
			passiveBarName="Blizzard",
			castingBar="Interface\\TargetingFrame\\UI-StatusBar",
			castingBarName="Blizzard",
			textureLock=true
		},
		strata={
			level="BACKGROUND",
			name="Background"
		}
	}

	TRB.Data.settings.displayText = TRB.Options.LoadDefaultBarTextSimpleSettings()
	return settings
end
TRB.Options.LoadDefaultSettings = LoadDefaultSettings

local function ConstructOptionsPanel()
	local xPadding = 10
	local xPadding2 = 30
	local xMax = 550
	local xCoord = 0
	local xCoord2 = 325
	local yCoord = -5
	local xOffset1 = 50
	local xOffset2 = 275
	
	local yOffset60 = 60
	local yOffset30 = 30
	local yOffset40 = 40
	local yOffset30 = 30
	local yOffset25 = 25
	local yOffset20 = 20
	local yOffset15 = 15
	local yOffset10 = 10
	local barWidth = 250
	local barHeight = 20
	local title = ""

	local maxBorderHeight = math.min(math.floor(TRB.Data.settings.bar.height/8), math.floor(TRB.Data.settings.bar.width/8))

	interfaceSettingsFrame.panel = CreateFrame("Frame", "TwintopInsanityBarPanel", UIParent)
	interfaceSettingsFrame.panel.name = "Twintop's Insanity Bar"
	local parent = interfaceSettingsFrame.panel
	
	local controls = {}
	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	local f = nil

	yCoord = -5	
	controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Twintop's Insanity Bar", xCoord+xPadding, yCoord)

	StaticPopupDialogs["TwintopInsanityBar_Reset"] = {
		text = "Do you want to reset Twintop's Insanity Bar back to it's default configuration? This will cause your UI to be reloaded!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			LoadDefaultSettings()
			ReloadUI()			
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopInsanityBar_ResetBarTextSimple"] = {
		text = "Do you want to reset Twintop's Insanity Bar's text (including font size, font style, and text information) back to it's default (simple) configuration? This will cause your UI to be reloaded!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			TRB.Data.settings.displayText = LoadDefaultBarTextSimpleSettings()
			ReloadUI()			
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopInsanityBar_ResetBarTextAdvanced"] = {
		text = "Do you want to reset Twintop's Insanity Bar's text (including font size, font style, and text information) back to it's default (advanced) configuration? This will cause your UI to be reloaded!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			TRB.Data.settings.displayText = LoadDefaultBarTextAdvancedSettings()
			ReloadUI()			
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopInsanityBar_ResetBarTextNarrowAdvanced"] = {
		text = "Do you want to reset Twintop's Insanity Bar's text (including font size, font style, and text information) back to it's default (narrow advanced) configuration? This will cause your UI to be reloaded!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			TRB.Data.settings.displayText = LoadDefaultBarTextNarrowAdvancedSettings()
			ReloadUI()			
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	yCoord = yCoord - yOffset40
	controls.labels.infoVersion = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Author:", "Twintop - Frostmourne-US/OCE", xCoord+xPadding*2, yCoord, 75, 200)
	yCoord = yCoord - yOffset20
	controls.labels.infoVersion = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Version:", TRB.Details.addonVersion, xCoord+xPadding*2, yCoord, 75, 200)
	yCoord = yCoord - yOffset20
	controls.labels.infoVersion = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Released:", TRB.Details.addonReleaseDate, xCoord+xPadding*2, yCoord, 75, 200)

	yCoord = yCoord - yOffset40
	controls.resetButton = CreateFrame("Button", "TwintopInsanityBar_ResetButton", parent)
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
		StaticPopup_Show("TwintopInsanityBar_Reset")
	end)

	yCoord = yCoord - yOffset40
	controls.resetButton = CreateFrame("Button", "TwintopInsanityBar_ResetBarTextSimpleButton", parent)
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
		StaticPopup_Show("TwintopInsanityBar_ResetBarTextSimple")
	end)

	yCoord = yCoord - yOffset40
	controls.resetButton = CreateFrame("Button", "TwintopInsanityBar_ResetBarTextNarrowAdvancedButton", parent)
	f = controls.resetButton
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord+xPadding*2, yCoord)
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
		StaticPopup_Show("TwintopInsanityBar_ResetBarTextNarrowAdvanced")
	end)

	yCoord = yCoord - yOffset40
	controls.resetButton = CreateFrame("Button", "TwintopInsanityBar_ResetBarTextAdvancedButton", parent)
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
		StaticPopup_Show("TwintopInsanityBar_ResetBarTextAdvanced")
	end)


	InterfaceOptions_AddCategory(interfaceSettingsFrame.panel)
	
	interfaceSettingsFrame.barLayoutPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopInsanityBar_BarLayoutPanel", parent)
	interfaceSettingsFrame.barLayoutPanel.name = "Bar Layout and Textures"
	interfaceSettingsFrame.barLayoutPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barLayoutPanel)
	
	interfaceSettingsFrame.barFontPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopInsanityBar_BarFontPanel", parent)
	interfaceSettingsFrame.barFontPanel.name = "Bar Fonts"
	interfaceSettingsFrame.barFontPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barFontPanel)
	
	interfaceSettingsFrame.barColorPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopInsanityBar_barColorPanel", parent)
	interfaceSettingsFrame.barColorPanel.name = "Bar Colors"
	interfaceSettingsFrame.barColorPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barColorPanel)
	
	interfaceSettingsFrame.barTextPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopInsanityBar_BarTextPanel", parent)
	interfaceSettingsFrame.barTextPanel.name = "Bar Text Display"
	interfaceSettingsFrame.barTextPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barTextPanel)
	
	interfaceSettingsFrame.optionalFeaturesPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopInsanityBar_OptionalFeaturesPanel", parent)
	interfaceSettingsFrame.optionalFeaturesPanel.name = "Optional Features"
	interfaceSettingsFrame.optionalFeaturesPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.optionalFeaturesPanel)
	
	interfaceSettingsFrame.advancedConfigurationPanel = TRB.UiFunctions.CreateScrollFrameContainer("TwintopInsanityBar_AdvancedConfigurationPanel", parent)
	interfaceSettingsFrame.advancedConfigurationPanel.name = "Advanced Configuration"
	interfaceSettingsFrame.advancedConfigurationPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.advancedConfigurationPanel)

	
	yCoord = -5
	parent = interfaceSettingsFrame.barLayoutPanel.scrollChild
	controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", xCoord+xPadding, yCoord)
	
	yCoord = yCoord - yOffset40
	title = "Bar Width"
	controls.width = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinWidth, TRB.Data.sanityCheckValues.barMaxWidth, TRB.Data.settings.bar.width, 1, 2,
								 barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.width:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)
		TRB.Data.settings.bar.width = value
		barContainerFrame:SetWidth(value-(TRB.Data.settings.bar.border*2))
		barBorderFrame:SetWidth(TRB.Data.settings.bar.width)
		resourceFrame:SetWidth(value-(TRB.Data.settings.bar.border*2))
		castingFrame:SetWidth(value-(TRB.Data.settings.bar.border*2))
		passiveFrame:SetWidth(value-(TRB.Data.settings.bar.border*2))
		RepositionThreshold(resourceFrame.thresholdDp, resourceFrame, TRB.Data.character.devouringPlagueThreshold, TRB.Data.character.maxResource)
		RepositionThreshold(resourceFrame.thresholdSn, resourceFrame, TRB.Data.character.searingNightmareThreshold, TRB.Data.character.maxResource)
		local maxBorderSize = math.min(math.floor(TRB.Data.settings.bar.height / 8), math.floor(TRB.Data.settings.bar.width / 8))
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(maxBorderSize)
	end)

	title = "Bar Height"
	controls.height = TRB.UiFunctions.BuildSlider(parent, title, TRB.Data.sanityCheckValues.barMinHeight, TRB.Data.sanityCheckValues.barMaxHeight, TRB.Data.settings.bar.height, 1, 2,
									barWidth, barHeight, xCoord2, yCoord)
	controls.height:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end		
		self.EditBox:SetText(value)		
		TRB.Data.settings.bar.height = value
		barContainerFrame:SetHeight(value-(TRB.Data.settings.bar.border*2))
		barBorderFrame:SetHeight(TRB.Data.settings.bar.height)
		resourceFrame:SetHeight(value-(TRB.Data.settings.bar.border*2))
		resourceFrame.thresholdDp:SetHeight(value-(TRB.Data.settings.bar.border*2))
		resourceFrame.thresholdSn:SetHeight(value-(TRB.Data.settings.bar.border*2))
		castingFrame:SetHeight(value-(TRB.Data.settings.bar.border*2))
		passiveFrame:SetHeight(value-(TRB.Data.settings.bar.border*2))
		passiveFrame.threshold:SetHeight(value-(TRB.Data.settings.bar.border*2))		
		leftTextFrame:SetHeight(TRB.Data.settings.bar.height * 3.5)
		middleTextFrame:SetHeight(TRB.Data.settings.bar.height * 3.5)
		rightTextFrame:SetHeight(TRB.Data.settings.bar.height * 3.5)
		local maxBorderSize = math.min(math.floor(TRB.Data.settings.bar.height / 8), math.floor(TRB.Data.settings.bar.width / 8))
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(maxBorderSize)
	end)

	title = "Bar Horizontal Position"
	yCoord = yCoord - yOffset60
	controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth/2), math.floor(TRB.Data.sanityCheckValues.barMaxWidth/2), TRB.Data.settings.bar.xPos, 1, 2,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		TRB.Data.settings.bar.xPos = value
		barContainerFrame:ClearAllPoints()
		barContainerFrame:SetPoint("CENTER", UIParent)
		barContainerFrame:SetPoint("CENTER", TRB.Data.settings.bar.xPos, TRB.Data.settings.bar.yPos)
	end)

	title = "Bar Vertical Position"
	controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight/2), math.floor(TRB.Data.sanityCheckValues.barMaxHeight/2), TRB.Data.settings.bar.yPos, 1, 2,
								  barWidth, barHeight, xCoord2, yCoord)
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)
		TRB.Data.settings.bar.yPos = value
		barContainerFrame:ClearAllPoints()
		barContainerFrame:SetPoint("CENTER", UIParent)
		barContainerFrame:SetPoint("CENTER", TRB.Data.settings.bar.xPos, TRB.Data.settings.bar.yPos)
	end)

	title = "Bar Border Width"
	yCoord = yCoord - yOffset60
	controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.bar.border, 1, 2,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.borderWidth:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		TRB.Data.settings.bar.border = value
		barContainerFrame:SetWidth(TRB.Data.settings.bar.width-(TRB.Data.settings.bar.border*2))
		barContainerFrame:SetHeight(TRB.Data.settings.bar.height-(TRB.Data.settings.bar.border*2))
		barBorderFrame:SetWidth(TRB.Data.settings.bar.width)
		barBorderFrame:SetHeight(TRB.Data.settings.bar.height)
		if TRB.Data.settings.bar.border < 1 then
			barBorderFrame:SetBackdrop({
				edgeFile = TRB.Data.settings.textures.border,
				tile = true,
				tileSize = 4,
				edgeSize = 1,
				insets = {0, 0, 0, 0}
			})
			barBorderFrame:Hide()
		else
			barBorderFrame:SetBackdrop({ 
				edgeFile = TRB.Data.settings.textures.border,
				tile = true,
				tileSize=4,
				edgeSize=TRB.Data.settings.bar.border,								
				insets = {0, 0, 0, 0}
			})
			barBorderFrame:Show()
		end
		barBorderFrame:SetBackdropColor(0, 0, 0, 0)
		barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.border, true))

		local minBarWidth = math.max(TRB.Data.settings.bar.border*2, 120)
		local minBarHeight = math.max(TRB.Data.settings.bar.border*2, 1)
		controls.height:SetMinMaxValues(minBarHeight, TRB.Data.sanityCheckValues.barMaxHeight)
		controls.height.MinLabel:SetText(minBarHeight)
		controls.width:SetMinMaxValues(minBarWidth, TRB.Data.sanityCheckValues.barMaxWidth)
		controls.width.MinLabel:SetText(minBarWidth)
	end)

	title = "Threshold Line Width"
	controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.thresholdWidth, 1, 2,
								  barWidth, barHeight, xCoord2, yCoord)
	controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)
		TRB.Data.settings.thresholdWidth = value
		resourceFrame.thresholdDp:SetWidth(TRB.Data.settings.thresholdWidth)
		resourceFrame.thresholdSn:SetWidth(TRB.Data.settings.thresholdWidth)
		passiveFrame.threshold:SetWidth(TRB.Data.settings.thresholdWidth)
	end)

	yCoord = yCoord - yOffset40

	controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TIBCB1_1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.lockPosition
	f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
	f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved."
	f:SetChecked(TRB.Data.settings.bar.dragAndDrop)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.bar.dragAndDrop = self:GetChecked()
		barContainerFrame:SetMovable(TRB.Data.settings.bar.dragAndDrop)
		barContainerFrame:EnableMouse(TRB.Data.settings.bar.dragAndDrop)
	end)



	yCoord = yCoord - yOffset20
	controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", xCoord+xPadding, yCoord)
	yCoord = yCoord - yOffset20
	
	-- Create the dropdown, and configure its appearance
	controls.dropDown.insanityBarTexture = CreateFrame("FRAME", "TIBInsanityBarTexture", parent, "UIDropDownMenuTemplate")
	controls.dropDown.insanityBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord+xPadding, yCoord)
	controls.dropDown.insanityBarTexture.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.insanityBarTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.insanityBarTexture, 250)
	UIDropDownMenu_SetText(controls.dropDown.insanityBarTexture, TRB.Data.settings.textures.insanityBarName)
	UIDropDownMenu_JustifyText(controls.dropDown.insanityBarTexture, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(controls.dropDown.insanityBarTexture, function(self, level, menuList)
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
					info.checked = textures[v] == TRB.Data.settings.textures.insanityBar
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
	function controls.dropDown.insanityBarTexture:SetValue(newValue, newName)
		TRB.Data.settings.textures.insanityBar = newValue
		TRB.Data.settings.textures.insanityBarName = newName
		resourceFrame:SetStatusBarTexture(TRB.Data.settings.textures.insanityBar)
		UIDropDownMenu_SetText(controls.dropDown.insanityBarTexture, newName)
		if TRB.Data.settings.textures.textureLock then
			TRB.Data.settings.textures.castingBar = newValue
			TRB.Data.settings.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			TRB.Data.settings.textures.passiveBar = newValue
			TRB.Data.settings.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
		end
		CloseDropDownMenus()
	end
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TIBCastBarTexture", parent, "UIDropDownMenuTemplate")
	controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2-20, yCoord)
	controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2-30, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, 250)
	UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.textures.castingBarName)
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
					info.checked = textures[v] == TRB.Data.settings.textures.castingBar
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
		TRB.Data.settings.textures.castingBar = newValue
		TRB.Data.settings.textures.castingBarName = newName
		castingFrame:SetStatusBarTexture(TRB.Data.settings.textures.castingBar)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
		if TRB.Data.settings.textures.textureLock then
			TRB.Data.settings.textures.insanityBar = newValue
			TRB.Data.settings.textures.insanityBarName = newName
			resourceFrame:SetStatusBarTexture(TRB.Data.settings.textures.insanityBar)
			UIDropDownMenu_SetText(controls.dropDown.insanityBarTexture, newName)
			TRB.Data.settings.textures.passiveBar = newValue
			TRB.Data.settings.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
		end
		CloseDropDownMenus()
	end

	yCoord = yCoord - yOffset60
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TIBPassiveBarTexture", parent, "UIDropDownMenuTemplate")
	controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord+xPadding, yCoord)
	controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, 250)
	UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.textures.passiveBarName)
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
					info.checked = textures[v] == TRB.Data.settings.textures.passiveBar
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
		TRB.Data.settings.textures.passiveBar = newValue
		TRB.Data.settings.textures.passiveBarName = newName
		passiveFrame:SetStatusBarTexture(TRB.Data.settings.textures.passiveBar)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
		if TRB.Data.settings.textures.textureLock then
			TRB.Data.settings.textures.insanityBar = newValue
			TRB.Data.settings.textures.insanityBarName = newName
			resourceFrame:SetStatusBarTexture(TRB.Data.settings.textures.insanityBar)
			UIDropDownMenu_SetText(controls.dropDown.insanityBarTexture, newName)
			TRB.Data.settings.textures.castingBar = newValue
			TRB.Data.settings.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
		end
		CloseDropDownMenus()
	end	
	
	controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TIBCB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.textureLock
	f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
	f.tooltip = "This will lock the texture for each part of the bar to be the same."
	f:SetChecked(TRB.Data.settings.textures.textureLock)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.textures.textureLock = self:GetChecked()
		if TRB.Data.settings.textures.textureLock then
			TRB.Data.settings.textures.passiveBar = TRB.Data.settings.textures.insanityBar
			TRB.Data.settings.textures.passiveBarName = TRB.Data.settings.textures.insanityBarName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.insanityBarTexture, TRB.Data.settings.textures.passiveBarName)
			TRB.Data.settings.textures.castingBar = TRB.Data.settings.textures.insanityBar
			TRB.Data.settings.textures.castingBarName = TRB.Data.settings.textures.insanityBarName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.textures.castingBarName)
		end
	end)


	yCoord = yCoord - yOffset60
	
	-- Create the dropdown, and configure its appearance
	controls.dropDown.borderTexture = CreateFrame("FRAME", "TIBBorderTexture", parent, "UIDropDownMenuTemplate")
	controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord+xPadding, yCoord)
	controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, 250)
	UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.textures.borderName)
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
					info.checked = textures[v] == TRB.Data.settings.textures.border
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
		TRB.Data.settings.textures.border = newValue
		TRB.Data.settings.textures.borderName = newName
		if TRB.Data.settings.bar.border < 1 then
			barBorderFrame:SetBackdrop({ })
		else
			barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.textures.border,
										tile = true,
										tileSize=4,
										edgeSize=TRB.Data.settings.bar.border,							
										insets = {0, 0, 0, 0}
										})
		end
		barBorderFrame:SetBackdropColor(0, 0, 0, 0)
		barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.border, true))
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
		CloseDropDownMenus()
	end
	
	-- Create the dropdown, and configure its appearance
	controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TIBBackgroundTexture", parent, "UIDropDownMenuTemplate")
	controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2-20, yCoord)
	controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2-30, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, 250)
	UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.textures.backgroundName)
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
					info.checked = textures[v] == TRB.Data.settings.textures.background
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
		TRB.Data.settings.textures.background = newValue
		TRB.Data.settings.textures.backgroundName = newName
		barContainerFrame:SetBackdrop({ 
			bgFile = TRB.Data.settings.textures.background,		
			tile = true,
			tileSize = TRB.Data.settings.bar.width,
			edgeSize = 1,
			insets = {0, 0, 0, 0}
		})
		barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.background, true))
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
		CloseDropDownMenus()
	end


	
	yCoord = yCoord - yOffset60
	controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset40

	title = "Devouring Plague Flash Alpha"
	controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.colors.bar.flashAlpha, 0.01, 2,
								 barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end	

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)
		TRB.Data.settings.colors.bar.flashAlpha = value
	end)

	title = "Devouring Plague Flash Period (sec)"
	controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.colors.bar.flashPeriod, 0.05, 2,
									barWidth, barHeight, xCoord2, yCoord)
	controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		TRB.Data.settings.colors.bar.flashPeriod = value
	end)

	yCoord = yCoord - yOffset40
	controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TIBRB1_2", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.alwaysShow
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Always show Insanity Bar")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "This will make the Insanity Bar always visible on your UI, even when out of combat."
	f:SetChecked(TRB.Data.settings.displayBar.alwaysShow)
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(true)
		controls.checkBoxes.notZeroShow:SetChecked(false)
		controls.checkBoxes.combatShow:SetChecked(false)
		TRB.Data.settings.displayBar.alwaysShow = true
		TRB.Data.settings.displayBar.notZeroShow = false
		TRB.Functions.HideResourceBar()
	end)

	controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TIBRB1_3", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.notZeroShow
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-15)
	getglobal(f:GetName() .. 'Text'):SetText("Show Insanity Bar when Insanity > 0")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "This will make the Insanity Bar show out of combat only if Insanity > 0, hidden otherwise when out of combat."
	f:SetChecked(TRB.Data.settings.displayBar.notZeroShow)
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(false)
		controls.checkBoxes.notZeroShow:SetChecked(true)
		controls.checkBoxes.combatShow:SetChecked(false)
		TRB.Data.settings.displayBar.alwaysShow = false
		TRB.Data.settings.displayBar.notZeroShow = true
		TRB.Functions.HideResourceBar()
	end)

	controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TIBRB1_4", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.combatShow
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText("Only show Insanity Bar in combat")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "This will make the Insanity Bar only be visible on your UI when in combat."
	f:SetChecked((not TRB.Data.settings.displayBar.alwaysShow) and (not TRB.Data.settings.displayBar.notZeroShow))
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(false)
		controls.checkBoxes.notZeroShow:SetChecked(false)
		controls.checkBoxes.combatShow:SetChecked(true)
		TRB.Data.settings.displayBar.alwaysShow = false
		TRB.Data.settings.displayBar.notZeroShow = false
		TRB.Functions.HideResourceBar()
	end)


	controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TIBCB1_5", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.flashEnabled
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Devouring Plague is Usable")
	f.tooltip = "This will flash the bar when Devouring Plague can be cast."
	f:SetChecked(TRB.Data.settings.colors.bar.flashEnabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.colors.bar.flashEnabled = self:GetChecked()
	end)

	controls.checkBoxes.dpThresholdShow = CreateFrame("CheckButton", "TIBCB1_6", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpThresholdShow
	f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText("Show Devouring Plague Threshold Line")
	f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Devouring Plague."
	f:SetChecked(TRB.Data.settings.devouringPlagueThreshold)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.devouringPlagueThreshold = self:GetChecked()
	end)

	controls.checkBoxes.snThresholdShow = CreateFrame("CheckButton", "TIBCB1_7", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.snThresholdShow
	f:SetPoint("TOPLEFT", xCoord2, yCoord-40)
	getglobal(f:GetName() .. 'Text'):SetText("Show Searing Nightmare Threshold Line")
	f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Searing Nightmare. Only visibile if spec'd in to Searing Nightmare and channeling Mind Sear."
	f:SetChecked(TRB.Data.settings.searingNightmareThreshold)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.searingNightmareThreshold = self:GetChecked()
	end)

	------------------------------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.barColorPanel.scrollChild

	controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while not in Voidform", TRB.Data.settings.colors.bar.base, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.base
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.base.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.base, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.inVoidform = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while in Voidform", TRB.Data.settings.colors.bar.inVoidform, 250, 25, xCoord2, yCoord)
	f = controls.colors.inVoidform
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.inVoidform.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.inVoidform = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.inVoidform, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset30
	controls.colors.enterVoidform = TRB.UiFunctions.BuildColorPicker(parent, "Insanity when you can cast Devouring Plague", TRB.Data.settings.colors.bar.enterVoidform, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.enterVoidform
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.enterVoidform.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.enterVoidform = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.enterVoidform, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Insanity Bar's border", TRB.Data.settings.colors.bar.border, 225, 25, xCoord2, yCoord)
	f = controls.colors.border
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.border.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
		barBorderFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.border, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset30
	controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Insanity from hardcasting spells", TRB.Data.settings.colors.bar.casting, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.casting
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.casting.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
		castingFrame:SetStatusBarColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.casting, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)	
		
	controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.colors.bar.background, 250, 25, xCoord2, yCoord)
	f = controls.colors.background
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.background.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
		barContainerFrame:SetBackdropColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.background, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset30
	controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under min. req. Insanity to cast Devouring Plague Threshold Line", TRB.Data.settings.colors.threshold.under, 260, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.thresholdUnder
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.threshold.under, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)	
		
	controls.colors.inVoidform2GCD = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while you have between 1-2 GCDs left in Voidform", TRB.Data.settings.colors.bar.inVoidform2GCD, 250, 25, xCoord2, yCoord)
	f = controls.colors.inVoidform2GCD
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.inVoidform2GCD.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.inVoidform2GCD = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.inVoidform2GCD, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset30
	controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over min. req. Insanity to cast Devouring Plague Threshold Line", TRB.Data.settings.colors.threshold.over, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.thresholdOver
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.threshold.over, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.inVoidform1GCD = TRB.UiFunctions.BuildColorPicker(parent, "Insanity while you have less than 1 GCD left in Voidform", TRB.Data.settings.colors.bar.inVoidform1GCD, 250, 25, xCoord2, yCoord)
	f = controls.colors.inVoidform1GCD
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.inVoidform1GCD.Texture:SetColorTexture(r, g, b, a)
		TRB.Data.settings.colors.bar.inVoidform1GCD = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.inVoidform1GCD, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset30
	controls.colors.mindbenderThreshold = TRB.UiFunctions.BuildColorPicker(parent, "Shadowfiend Insanity Gain Threshold Line", TRB.Data.settings.colors.bar.passive, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.mindbenderThreshold
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		
		controls.colors.mindbenderThreshold.Texture:SetColorTexture(r, g, b, a)
		passiveFrame:SetStatusBarColor(r, g, b, a)
		TRB.Data.settings.colors.threshold.mindbender = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.threshold.mindbender, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset30
	controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Insanity from Auspicious Spirits, Shadowfiend swings, Death and Madness ticks, and Lash of Insanity ticks", TRB.Data.settings.colors.bar.passive, 550, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.passive
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		
		controls.colors.passive.Texture:SetColorTexture(r, g, b, a)
		passiveFrame:SetStatusBarColor(r, g, b, a)
		TRB.Data.settings.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.bar.passive, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	-------------------------------------------------



	yCoord = -5
	parent = interfaceSettingsFrame.barFontPanel.scrollChild

	controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	
	-- Create the dropdown, and configure its appearance
	controls.dropDown.fontLeft = CreateFrame("FRAME", "TIBFontLeft", parent, "UIDropDownMenuTemplate")
	controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord+xPadding, yCoord)
	controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, 250)
	UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.displayText.left.fontFaceName)
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
					info.checked = fonts[v] == TRB.Data.settings.displayText.left.fontFace
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
		TRB.Data.settings.displayText.left.fontFace = newValue
		TRB.Data.settings.displayText.left.fontFaceName = newName
		leftTextFrame.font:SetFont(TRB.Data.settings.displayText.left.fontFace, TRB.Data.settings.displayText.left.fontSize, "OUTLINE")
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
		if TRB.Data.settings.displayText.fontFaceLock then
			TRB.Data.settings.displayText.middle.fontFace = newValue
			TRB.Data.settings.displayText.middle.fontFaceName = newName
			middleTextFrame.font:SetFont(TRB.Data.settings.displayText.middle.fontFace, TRB.Data.settings.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			TRB.Data.settings.displayText.right.fontFace = newValue
			TRB.Data.settings.displayText.right.fontFaceName = newName
			rightTextFrame.font:SetFont(TRB.Data.settings.displayText.right.fontFace, TRB.Data.settings.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
		end
		CloseDropDownMenus()
	end
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.fontMiddle = CreateFrame("FRAME", "TIBfFontMiddle", parent, "UIDropDownMenuTemplate")
	controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2-20, yCoord)
	controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2-30, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, 250)
	UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.displayText.middle.fontFaceName)
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
					info.checked = fonts[v] == TRB.Data.settings.displayText.middle.fontFace
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
		TRB.Data.settings.displayText.middle.fontFace = newValue
		TRB.Data.settings.displayText.middle.fontFaceName = newName
		middleTextFrame.font:SetFont(TRB.Data.settings.displayText.middle.fontFace, TRB.Data.settings.displayText.middle.fontSize, "OUTLINE")
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
		if TRB.Data.settings.displayText.fontFaceLock then
			TRB.Data.settings.displayText.left.fontFace = newValue
			TRB.Data.settings.displayText.left.fontFaceName = newName
			leftTextFrame.font:SetFont(TRB.Data.settings.displayText.left.fontFace, TRB.Data.settings.displayText.left.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)			
			TRB.Data.settings.displayText.right.fontFace = newValue
			TRB.Data.settings.displayText.right.fontFaceName = newName
			rightTextFrame.font:SetFont(TRB.Data.settings.displayText.right.fontFace, TRB.Data.settings.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
		end
		CloseDropDownMenus()
	end

	yCoord = yCoord - yOffset40 - yOffset20
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.fontRight = CreateFrame("FRAME", "TIBFontRight", parent, "UIDropDownMenuTemplate")
	controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord+xPadding, yCoord)
	controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.fontRight, 250)
	UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.displayText.right.fontFaceName)
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
					info.checked = fonts[v] == TRB.Data.settings.displayText.right.fontFace
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
		TRB.Data.settings.displayText.right.fontFace = newValue
		TRB.Data.settings.displayText.right.fontFaceName = newName
		rightTextFrame.font:SetFont(TRB.Data.settings.displayText.right.fontFace, TRB.Data.settings.displayText.right.fontSize, "OUTLINE")
		UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
		if TRB.Data.settings.displayText.fontFaceLock then
			TRB.Data.settings.displayText.left.fontFace = newValue
			TRB.Data.settings.displayText.left.fontFaceName = newName
			leftTextFrame.font:SetFont(TRB.Data.settings.displayText.left.fontFace, TRB.Data.settings.displayText.left.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			TRB.Data.settings.displayText.middle.fontFace = newValue
			TRB.Data.settings.displayText.middle.fontFaceName = newName
			middleTextFrame.font:SetFont(TRB.Data.settings.displayText.middle.fontFace, TRB.Data.settings.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
		end
		CloseDropDownMenus()
	end
	
	controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TIBCB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fontFaceLock
	f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
	f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
	f:SetChecked(TRB.Data.settings.displayText.fontFaceLock)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.displayText.fontFaceLock = self:GetChecked()
		if TRB.Data.settings.displayText.fontFaceLock then
			TRB.Data.settings.displayText.middle.fontFace = TRB.Data.settings.displayText.left.fontFace
			TRB.Data.settings.displayText.middle.fontFaceName = TRB.Data.settings.displayText.left.fontFaceName
			middleTextFrame.font:SetFont(TRB.Data.settings.displayText.middle.fontFace, TRB.Data.settings.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.displayText.middle.fontFaceName)
			TRB.Data.settings.displayText.right.fontFace = TRB.Data.settings.displayText.left.fontFace
			TRB.Data.settings.displayText.right.fontFaceName = TRB.Data.settings.displayText.left.fontFaceName
			rightTextFrame.font:SetFont(TRB.Data.settings.displayText.right.fontFace, TRB.Data.settings.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.displayText.right.fontFaceName)
		end
	end)


	yCoord = yCoord - yOffset60
	controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", xCoord+xPadding, yCoord)

	title = "Left Bar Text Font Size"
	yCoord = yCoord - yOffset40
	controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.displayText.left.fontSize, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		TRB.Data.settings.displayText.left.fontSize = value
		leftTextFrame.font:SetFont(TRB.Data.settings.displayText.left.fontFace, TRB.Data.settings.displayText.left.fontSize, "OUTLINE")
		if TRB.Data.settings.displayText.fontSizeLock then
			controls.fontSizeMiddle:SetValue(value)
			controls.fontSizeRight:SetValue(value)
		end
	end)
	
	controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TIBCB2_F1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fontSizeLock
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
	f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
	f:SetChecked(TRB.Data.settings.displayText.fontSizeLock)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.displayText.fontSizeLock = self:GetChecked()
		if TRB.Data.settings.displayText.fontSizeLock then
			controls.fontSizeMiddle:SetValue(TRB.Data.settings.displayText.left.fontSize)
			controls.fontSizeRight:SetValue(TRB.Data.settings.displayText.left.fontSize)
		end
	end)

	controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.colors.text.left,
													250, 25, xCoord2, yCoord-30)
	f = controls.colors.leftText
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.left, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.colors.text.middle,
													225, 25, xCoord2, yCoord-70)
	f = controls.colors.middleText
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
		--barContainerFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.middle, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.colors.text.right,
													225, 25, xCoord2, yCoord-110)
	f = controls.colors.rightText
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
		--barContainerFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.right, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)
	
	title = "Middle Bar Text Font Size"
	yCoord = yCoord - yOffset60
	controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.displayText.middle.fontSize, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		TRB.Data.settings.displayText.middle.fontSize = value
		middleTextFrame.font:SetFont(TRB.Data.settings.displayText.middle.fontFace, TRB.Data.settings.displayText.middle.fontSize, "OUTLINE")
		if TRB.Data.settings.displayText.fontSizeLock then
			controls.fontSizeLeft:SetValue(value)
			controls.fontSizeRight:SetValue(value)
		end
	end)
	
	title = "Right Bar Text Font Size"
	yCoord = yCoord - yOffset60
	controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.displayText.right.fontSize, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		TRB.Data.settings.displayText.right.fontSize = value
		rightTextFrame.font:SetFont(TRB.Data.settings.displayText.right.fontFace, TRB.Data.settings.displayText.right.fontSize, "OUTLINE")
		if TRB.Data.settings.displayText.fontSizeLock then
			controls.fontSizeLeft:SetValue(value)
			controls.fontSizeMiddle:SetValue(value)
		end
	end)

	yCoord = yCoord - yOffset40
	controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Insanity Text Colors", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	controls.colors.currentInsanityText = TRB.UiFunctions.BuildColorPicker(parent, "Current Insanity", TRB.Data.settings.colors.text.currentInsanity, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.currentInsanityText
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.currentInsanity = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.currentInsanity, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.castingInsanityText = TRB.UiFunctions.BuildColorPicker(parent, "Insanity from hardcasting spells", TRB.Data.settings.colors.text.castingInsanity, 250, 25, xCoord2, yCoord)
	f = controls.colors.castingInsanityText
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.castingInsanity = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
		--barContainerFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.currentInsanity, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)
	
	yCoord = yCoord - yOffset40
	controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Haste Threshold Colors in Voidform", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset40
	title = "Low to Medium Haste% Threshold in Voidform"
	controls.hasteApproachingThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 500, TRB.Data.settings.hasteApproachingThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value > TRB.Data.settings.hasteThreshold then
			value = TRB.Data.settings.hasteThreshold
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		TRB.Data.settings.hasteApproachingThreshold = value
	end)

	controls.colors.hasteBelow = TRB.UiFunctions.BuildColorPicker(parent, "Low Haste% in Voidform", TRB.Data.settings.colors.text.hasteBelow,
												250, 25, xCoord2, yCoord+10)
	f = controls.colors.hasteBelow
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.hasteBelow = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.hasteBelow, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.hasteApproaching = TRB.UiFunctions.BuildColorPicker(parent, "Medium Haste% in Voidform", TRB.Data.settings.colors.text.hasteApproaching,
												250, 25, xCoord2, yCoord-30)
	f = controls.colors.hasteApproaching
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.hasteApproaching = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.hasteApproaching, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.hasteAbove = TRB.UiFunctions.BuildColorPicker(parent, "High Haste% in Voidform", TRB.Data.settings.colors.text.hasteAbove,
												250, 25, xCoord2, yCoord-70)
	f = controls.colors.hasteAbove
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.hasteAbove = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.hasteAbove, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset60	
	title = "Medium to High Haste% Threshold in Voidform"
	controls.hasteThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 500, TRB.Data.settings.hasteThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value < TRB.Data.settings.hasteApproachingThreshold then
			value = TRB.Data.settings.hasteApproachingThreshold
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		TRB.Data.settings.hasteThreshold = value
	end)
	
	yCoord = yCoord - yOffset40
	controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Surrender to Madness Target Time to Die Thresholds", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset40
	title = "Low to Medium S2M Time to Die Threshold (sec)"
	controls.s2mApproachingThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 30, TRB.Data.settings.s2mApproachingThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.s2mApproachingThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value > TRB.Data.settings.s2mThreshold then
			value = TRB.Data.settings.s2mThreshold
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		TRB.Data.settings.s2mApproachingThreshold = value
	end)

	controls.colors.s2mBelow = TRB.UiFunctions.BuildColorPicker(parent, "Low S2M Time to Die Threshold", TRB.Data.settings.colors.text.s2mBelow,
												250, 25, xCoord2, yCoord+10)
	f = controls.colors.s2mBelow
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.s2mBelow = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.s2mBelow, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.s2mApproaching = TRB.UiFunctions.BuildColorPicker(parent, "Medium S2M Time to Die", TRB.Data.settings.colors.text.s2mApproaching,
												250, 25, xCoord2, yCoord-30)
	f = controls.colors.s2mApproaching
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.s2mApproaching = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.s2mApproaching, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.s2mAbove = TRB.UiFunctions.BuildColorPicker(parent, "High S2M Time to Die", TRB.Data.settings.colors.text.s2mAbove,
												250, 25, xCoord2, yCoord-70)
	f = controls.colors.s2mAbove
	f.recolorTexture = function(color)
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
		TRB.Data.settings.colors.text.s2mAbove = TRB.Functions.ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.colors.text.s2mAbove, true)
			TRB.UiFunctions.ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset60	
	title = "Medium to High S2M Time to Die Threshold (sec)"
	controls.s2mThreshold = TRB.UiFunctions.BuildSlider(parent, title, 0, 30, TRB.Data.settings.s2mThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.s2mThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value < TRB.Data.settings.s2mApproachingThreshold then
			value = TRB.Data.settings.s2mApproachingThreshold
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		TRB.Data.settings.s2mThreshold = value
	end)

	
	yCoord = yCoord - yOffset40
	controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset40	
	title = "Haste / Crit / Mastery Decimals to Show"
	controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hastePrecision, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = RoundTo(value, 0)
		self.EditBox:SetText(value)		
		TRB.Data.settings.hastePrecision = value
	end)
	
	controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TIBCB1_FOTM", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fontFaceLock
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Show decimals w/Fortress of the Mind")
	f.tooltip = "Show decimal values with Fortress of the Mind. If unchecked, rounded (approximate) values will be displayed instead."
	f:SetChecked(TRB.Data.settings.fotmPrecision)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.fotmPrecision = self:GetChecked()
	end)

	------------------------------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.barTextPanel.scrollChild

	controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display Text Customization", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
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

	yCoord = yCoord - yOffset20
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

	controls.textbox.voidformOutLeft = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.displayText.left.outVoidformText,
													500, 225, 24, xCoord+xPadding*2+100, yCoord)
	f = controls.textbox.voidformOutLeft
	f:SetScript("OnTextChanged", function(self, input)
		TRB.Data.settings.displayText.left.outVoidformText = self:GetText()
		TRB.Data.barTextCache = {}
		TRB.Functions.IsTtdActive()
	end)

	controls.textbox.voidformInLeft = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.displayText.left.inVoidformText,
													500, 225, 24, xCoord2+25, yCoord)
	f = controls.textbox.voidformInLeft
	f:SetScript("OnTextChanged", function(self, input)
		TRB.Data.settings.displayText.left.inVoidformText = self:GetText()
		TRB.Data.barTextCache = {}
		TRB.Functions.IsTtdActive()
	end)

	yCoord = yCoord - yOffset30
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

	controls.textbox.voidformOutMiddle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.displayText.middle.outVoidformText,
													500, 225, 24, xCoord+xPadding*2+100, yCoord)
	f = controls.textbox.voidformOutMiddle
	f:SetScript("OnTextChanged", function(self, input)
		TRB.Data.settings.displayText.middle.outVoidformText = self:GetText()
		TRB.Data.barTextCache = {}
		TRB.Functions.IsTtdActive()
	end)

	controls.textbox.voidformInMiddle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.displayText.middle.inVoidformText,
													500, 225, 24, xCoord2+25, yCoord)
	f = controls.textbox.voidformInMiddle
	f:SetScript("OnTextChanged", function(self, input)
		TRB.Data.settings.displayText.middle.inVoidformText = self:GetText()
		TRB.Data.barTextCache = {}
		TRB.Functions.IsTtdActive()
	end)

	yCoord = yCoord - yOffset30
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

	controls.textbox.voidformOutRight = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.displayText.right.outVoidformText,
													500, 225, 24, xCoord+xPadding*2+100, yCoord)
	f = controls.textbox.voidformOutRight
	f:SetScript("OnTextChanged", function(self, input)
		TRB.Data.settings.displayText.right.outVoidformText = self:GetText()
		TRB.Data.barTextCache = {}
		TRB.Functions.IsTtdActive()
	end)

	controls.textbox.voidformInRight = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.displayText.right.inVoidformText,
													500, 225, 24, xCoord2+25, yCoord)
	f = controls.textbox.voidformInRight
	f:SetScript("OnTextChanged", function(self, input)
		TRB.Data.settings.displayText.right.inVoidformText = self:GetText()
		TRB.Data.barTextCache = {}
		TRB.Functions.IsTtdActive()
	end)

	yCoord = yCoord - yOffset30
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
		
	yCoord = yCoord - yOffset25
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

	yCoord = yCoord - yOffset25
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

	yCoord = yCoord - yOffset25
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
	--interfaceSettingsFrame.barTextPanel.variableFrame:SetPoint("TOPLEFT", xCoord, yCoord - yOffset15)
	--parent = interfaceSettingsFrame.barTextPanel.variableFrame.scrollChild
	
	yCoord = yCoord - yOffset25
	local yCoordTop = yCoord
	local entries1 = TRB.Functions.TableLength(TRB.Data.barTextVariables.values)
	for i=1, entries1 do
		if TRB.Data.barTextVariables.values[i].printInSettings == true then
			TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.values[i].variable, TRB.Data.barTextVariables.values[i].description, xCoord, yCoord, 115, 200)
			yCoord = yCoord - yOffset25
		end
	end

	local entries2 = TRB.Functions.TableLength(TRB.Data.barTextVariables.pipe)
	for i=1, entries2 do
		if TRB.Data.barTextVariables.pipe[i].printInSettings == true then
			TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.pipe[i].variable, TRB.Data.barTextVariables.pipe[i].description, xCoord, yCoord, 115, 200)
			yCoord = yCoord - yOffset25
		end
	end

	-----	
	

	yCoord = yCoordTop

	--controls.labels.castingIconVar = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "#casting", "The icon of the Insanity Generating Spell you are currently hardcasting", xCoord, yCoord, 85, 500)
	--yCoord = yCoord - yOffset15

	local entries3 = TRB.Functions.TableLength(TRB.Data.barTextVariables.icons)
	for i=1, entries3 do
		if TRB.Data.barTextVariables.icons[i].printInSettings == true then
			local text = ""
			if TRB.Data.barTextVariables.icons[i].icon ~= "" then
				text = TRB.Data.barTextVariables.icons[i].icon .. " "
			end
			TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, TRB.Data.barTextVariables.icons[i].variable, text .. TRB.Data.barTextVariables.icons[i].description, xCoord+115+200+25, yCoord, 50, 200)
			yCoord = yCoord - yOffset25
		end
	end
---------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.optionalFeaturesPanel.scrollChild

	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	controls.checkBoxes.s2mDeath = CreateFrame("CheckButton", "TIBCB3_2", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.s2mDeath
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Play audio when you die, horribly, from Surrender to Madness")
	f.tooltip = "When you die, horribly, after Surrender to Madness ends, play the infamous Wilhelm Scream (or another sound) to make you feel a bit better."
	f:SetChecked(TRB.Data.settings.audio.s2mDeath.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.audio.s2mDeath.enabled = self:GetChecked()
	end)	
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.s2mAudio = CreateFrame("FRAME", "TIBS2MDeathAudio", parent, "UIDropDownMenuTemplate")
	controls.dropDown.s2mAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-yOffset30+10)
	UIDropDownMenu_SetWidth(controls.dropDown.s2mAudio, 300)
	UIDropDownMenu_SetText(controls.dropDown.s2mAudio, TRB.Data.settings.audio.s2mDeath.soundName)
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
					info.checked = sounds[v] == TRB.Data.settings.audio.s2mDeath.sound
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
		TRB.Data.settings.audio.s2mDeath.sound = newValue
		TRB.Data.settings.audio.s2mDeath.soundName = newName
		UIDropDownMenu_SetText(controls.dropDown.s2mAudio, newName)
		CloseDropDownMenus()
		PlaySoundFile(TRB.Data.settings.audio.s2mDeath.sound, TRB.Data.settings.audio.channel.channel)
	end


	yCoord = yCoord - yOffset60
	controls.checkBoxes.dpReady = CreateFrame("CheckButton", "TIBCB3_3", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpReady
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Devouring Plague is usable")
	f.tooltip = "Play an audio cue when Devouring Plague can be cast."
	f:SetChecked(TRB.Data.settings.audio.dpReady.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.audio.dpReady.enabled = self:GetChecked()
	end)	
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.dpReadyAudio = CreateFrame("FRAME", "TIBdpReadyAudio", parent, "UIDropDownMenuTemplate")
	controls.dropDown.dpReadyAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-yOffset30+10)
	UIDropDownMenu_SetWidth(controls.dropDown.dpReadyAudio, 300)
	UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, TRB.Data.settings.audio.dpReady.soundName)
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
					info.checked = sounds[v] == TRB.Data.settings.audio.dpReady.sound
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
		TRB.Data.settings.audio.dpReady.sound = newValue
		TRB.Data.settings.audio.dpReady.soundName = newName
		UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, newName)
		CloseDropDownMenus()
		PlaySoundFile(TRB.Data.settings.audio.dpReady.sound, TRB.Data.settings.audio.channel.channel)
	end


	yCoord = yCoord - yOffset60
	controls.checkBoxes.dpReady = CreateFrame("CheckButton", "TIBCB3_MD_Sound", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpReady
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Mind Devourer proc occurs")
	f.tooltip = "Play an audio cue when a Mind Devourer proc occurs. This supercedes the regular Devouring Plague audio sound."
	f:SetChecked(TRB.Data.settings.audio.mdProc.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.audio.mdProc.enabled = self:GetChecked()
	end)	
		
	-- Create the dropdown, and configure its appearance
	controls.dropDown.mdProcAudio = CreateFrame("FRAME", "TIBmdProcAudio", parent, "UIDropDownMenuTemplate")
	controls.dropDown.mdProcAudio:SetPoint("TOPLEFT", xCoord+xPadding+10, yCoord-yOffset30+10)
	UIDropDownMenu_SetWidth(controls.dropDown.mdProcAudio, 300)
	UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, TRB.Data.settings.audio.mdProc.soundName)
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
					info.checked = sounds[v] == TRB.Data.settings.audio.mdProc.sound
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
		TRB.Data.settings.audio.mdProc.sound = newValue
		TRB.Data.settings.audio.mdProc.soundName = newName
		UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, newName)
		CloseDropDownMenus()
		PlaySoundFile(TRB.Data.settings.audio.mdProc.sound, TRB.Data.settings.audio.channel.channel)
	end

	yCoord = yCoord - yOffset60
	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Auspicious Spirits Tracking", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	controls.checkBoxes.as = CreateFrame("CheckButton", "TIBCB3_6", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.as
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Track Auspicious Spirits")
	f.tooltip = "Track Shadowy Apparitions in flight that will generate Insanity upon reaching their target with the Auspicious Spirits talent."
	f:SetChecked(TRB.Data.settings.auspiciousSpiritsTracker)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.auspiciousSpiritsTracker = self:GetChecked()
		
		if ((TRB.Data.settings.auspiciousSpiritsTracker and TRB.Data.character.talents.as.isSelected) or TRB.Functions.IsTtdActive()) and GetSpecialization() == 3 then
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		else
			targetsTimerFrame:SetScript("OnUpdate", nil)
		end	
		snapshotData.auspiciousSpirits.total = 0
		snapshotData.auspiciousSpirits.units = 0
		snapshotData.auspiciousSpirits.tracker = {}
	end)

	yCoord = yCoord - yOffset30
	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Eternal Call to the Void / Void Tendril + Void Lasher Tracking", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	controls.checkBoxes.as = CreateFrame("CheckButton", "TIBCB3_6a", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.as
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Track Eternal Call to the Void")
	f.tooltip = "Track Insanity generated from Lash of Insanity via Void Tendril + Void Lasher spawns / Eternal Call of the Void procs."
	f:SetChecked(TRB.Data.settings.voidTendrilTracker)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.voidTendrilTracker = self:GetChecked()
		snapshotData.eternalCallToTheVoid.numberActive = 0
		snapshotData.eternalCallToTheVoid.resourceRaw = 0
		snapshotData.eternalCallToTheVoid.resourceFinal = 0
		snapshotData.eternalCallToTheVoid.maxTicksRemaining = 0
		snapshotData.eternalCallToTheVoid.voidTendrils = {}
	end)

	yCoord = yCoord - yOffset30
	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Shadowfiend/Mindbender Tracking", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30	
	controls.checkBoxes.mindbender = CreateFrame("CheckButton", "TIBCB3_7", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindbender
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend Insanity Gain")
	f.tooltip = "Show the gain of Insanity over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below."
	f:SetChecked(TRB.Data.settings.mindbender.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.mindbender.enabled = self:GetChecked()
	end)

	yCoord = yCoord - yOffset30	
	controls.checkBoxes.mindbenderModeGCDs = CreateFrame("CheckButton", "TIBRB3_8", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.mindbenderModeGCDs
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from GCDs remaining")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X GCDs, based on player's current GCD."
	if TRB.Data.settings.mindbender.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(true)
		controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
		controls.checkBoxes.mindbenderModeTime:SetChecked(false)
		TRB.Data.settings.mindbender.mode = "gcd"
	end)

	title = "Shadowfiend GCDs - 0.75sec Floor"
	controls.mindbenderGCDs = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.mindbender.gcdsMax, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderGCDs:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)		
		TRB.Data.settings.mindbender.gcdsMax = value
	end)


	yCoord = yCoord - yOffset60	
	controls.checkBoxes.mindbenderModeSwings = CreateFrame("CheckButton", "TIBRB3_9", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.mindbenderModeSwings
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from Swings remaining")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X melee swings from Shadowfiend/Mindbender. This is only different from the GCD option if you are above 200% haste (GCD cap)."
	if TRB.Data.settings.mindbender.mode == "swing" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
		controls.checkBoxes.mindbenderModeSwings:SetChecked(true)
		controls.checkBoxes.mindbenderModeTime:SetChecked(false)
		TRB.Data.settings.mindbender.mode = "swing"
	end)

	title = "Shadowfiend Swings - No Floor"
	controls.mindbenderSwings = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.mindbender.swingsMax, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderSwings:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)		
		TRB.Data.settings.mindbender.swingsMax = value
	end)

	yCoord = yCoord - yOffset60	
	controls.checkBoxes.mindbenderModeTime = CreateFrame("CheckButton", "TIBRB3_10", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.mindbenderModeTime
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from Time remaining")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X seconds."
	if TRB.Data.settings.mindbender.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
		controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
		controls.checkBoxes.mindbenderModeTime:SetChecked(true)
		TRB.Data.settings.mindbender.mode = "time"
	end)

	title = "Shadowfiend Time Remaining"
	controls.mindbenderTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.mindbender.timeMax, 0.25, 2,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderTime:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		TRB.Data.settings.mindbender.timeMax = value
	end)

	--[[
	yCoord = yCoord - yOffset60	
	controls.checkBoxes.mindbenderAudio = CreateFrame("CheckButton", "TIBCB3_11", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindbenderAudio
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Play Audio Cue to use Shadowfiend")
	f.tooltip = "Plays an audio cue when in Voidform, Shadowfiend/Mindbender is offcooldown, and the number of Drain Stacks is above a certain threshold."
	f:SetChecked(TRB.Data.settings.mindbender.useNotification.enabled)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.mindbender.useNotification.enabled = self:GetChecked()
		if TRB.Data.settings.mindbender.useNotification.enabled then
			mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate) end)
		else
			mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
		end
	end)	
	
	yCoord = yCoord - yOffset40
	-- Create the dropdown, and configure its appearance
	controls.dropDown.mindbenderAudio = CreateFrame("FRAME", "TIBMindbenderAudio", parent, "UIDropDownMenuTemplate")
	controls.dropDown.mindbenderAudio.label = TRB.UiFunctions.BuildSectionHeader(parent, "Mindbender Ready Audio", xCoord+xPadding, yCoord)
	controls.dropDown.mindbenderAudio.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.mindbenderAudio:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.mindbenderAudio, 250)
	UIDropDownMenu_SetText(controls.dropDown.mindbenderAudio, TRB.Data.settings.audio.mindbender.soundName)
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
					info.checked = sounds[v] == TRB.Data.settings.audio.mindbender.sound
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
		TRB.Data.settings.audio.mindbender.sound = newValue
		TRB.Data.settings.audio.mindbender.soundName = newName
		UIDropDownMenu_SetText(controls.dropDown.mindbenderAudio, newName)
		CloseDropDownMenus()
		PlaySoundFile(TRB.Data.settings.audio.mindbender.sound, TRB.Data.settings.audio.channel.channel)
	end
	]]--

	------------------------------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.advancedConfigurationPanel.scrollChild

	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Time To Die", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset60

	title = "Sampling Rate (seconds)"
	controls.ttdSamplingRate = TRB.UiFunctions.BuildSlider(parent, title, 0.05, 2, TRB.Data.settings.ttd.sampleRate, 0.05, 2,
									barWidth, barHeight, xCoord+xPadding*2, yCoord)
	controls.ttdSamplingRate:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		else
			value = RoundTo(value, 2)
		end

		self.EditBox:SetText(value)		
		TRB.Data.settings.ttd.sampleRate = value
	end)

	title = "Sample Size"
	controls.ttdSampleSize = TRB.UiFunctions.BuildSlider(parent, title, 1, 1000, TRB.Data.settings.ttd.numEntries, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.ttdSampleSize:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)		
		TRB.Data.settings.ttd.numEntries = value
	end)

	yCoord = yCoord - yOffset40
	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Character Data Refresh Rate", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset60

	title = "Refresh Rate (seconds)"
	controls.ttdSamplingRate = TRB.UiFunctions.BuildSlider(parent, title, 0.05, 60, TRB.Data.settings.dataRefreshRate, 0.05, 2,
									barWidth, barHeight, xCoord+xPadding*2, yCoord)
	controls.ttdSamplingRate:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		else
			value = RoundTo(value, 2)
		end

		self.EditBox:SetText(value)		
		TRB.Data.settings.dataRefreshRate = value
	end)
	
	yCoord = yCoord - yOffset40
	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Frame Strata", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	
	-- Create the dropdown, and configure its appearance
	controls.dropDown.strata = CreateFrame("FRAME", "TIBFrameStrata", parent, "UIDropDownMenuTemplate")
	controls.dropDown.strata.label = TRB.UiFunctions.BuildSectionHeader(parent, "Frame Strata Level To Draw Bar On", xCoord+xPadding, yCoord)
	controls.dropDown.strata.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.strata:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.strata, 250)
	UIDropDownMenu_SetText(controls.dropDown.strata, TRB.Data.settings.strata.name)
	UIDropDownMenu_JustifyText(controls.dropDown.strata, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(controls.dropDown.strata, function(self, level, menuList)
		local entries = 25
		local info = UIDropDownMenu_CreateInfo()
		local strata = {}
		strata["Background"] = "BACKGROUND"
		strata["Low"] = "LOW"
		strata["Medium"] = "MEDIUM"
		strata["High"] = "HIGH"
		strata["Dialog"] = "DIALOG"
		strata["Fullscreen"] = "FULLSCREEN"
		strata["Fullscreen Dialog"] = "FULLSCREEN_DIALOG"		
		strata["Tooltip"] = "TOOLTIP"
		local strataList = {
			"Background",
			"Low",
			"Medium",
			"High",
			"Dialog",
			"Fullscreen",
			"Fullscreen Dialog",
			"Tooltip"
		}

		for k, v in pairs(strataList) do
			info.text = v
			info.value = strata[v]
			info.checked = strata[v] == TRB.Data.settings.strata.level
			info.func = self.SetValue			
			info.arg1 = strata[v]
			info.arg2 = v
			UIDropDownMenu_AddButton(info, level)
		end
	end)

	-- Implement the function to change the texture
	function controls.dropDown.strata:SetValue(newValue, newName)
		TRB.Data.settings.strata.level = newValue
		TRB.Data.settings.strata.name = newName
		barContainerFrame:SetFrameStrata(TRB.Data.settings.strata.level)
		UIDropDownMenu_SetText(controls.dropDown.strata, newName)
		CloseDropDownMenus()
	end


	
	yCoord = yCoord - yOffset60
	controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Channel", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset30
	
	-- Create the dropdown, and configure its appearance
	controls.dropDown.audioChannel = CreateFrame("FRAME", "TIBFrameAudioChannel", parent, "UIDropDownMenuTemplate")
	controls.dropDown.audioChannel.label = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Channel To Use", xCoord+xPadding, yCoord)
	controls.dropDown.audioChannel.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.audioChannel:SetPoint("TOPLEFT", xCoord+xPadding, yCoord-yOffset30)
	UIDropDownMenu_SetWidth(controls.dropDown.audioChannel, 250)
	UIDropDownMenu_SetText(controls.dropDown.audioChannel, TRB.Data.settings.audio.channel.name)
	UIDropDownMenu_JustifyText(controls.dropDown.audioChannel, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(controls.dropDown.audioChannel, function(self, level, menuList)
		local entries = 25
		local info = UIDropDownMenu_CreateInfo()
		local channel = {}
		channel["Master"] = "Master"
		channel["SFX"] = "SFX"
		channel["Music"] = "Music"
		channel["Ambience"] = "Ambience"
		channel["Dialog"] = "Dialog"

		for k, v in pairs(channel) do
			info.text = v
			info.value = channel[v]
			info.checked = channel[v] == TRB.Data.settings.audio.channel.channel
			info.func = self.SetValue			
			info.arg1 = channel[v]
			info.arg2 = v
			UIDropDownMenu_AddButton(info, level)
		end
	end)

	-- Implement the function to change the texture
	function controls.dropDown.audioChannel:SetValue(newValue, newName)
		TRB.Data.settings.audio.channel.channel = newValue
		TRB.Data.settings.audio.channel.name = newName
		UIDropDownMenu_SetText(controls.dropDown.audioChannel, newName)
		CloseDropDownMenus()
	end


	-------------------

	interfaceSettingsFrame.controls = controls
	
end
TRB.Options.ConstructOptionsPanel = ConstructOptionsPanel