local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 3 then --Only do this if we're on a Hunter!
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

	TRB.Options.Hunter = {}
	TRB.Options.Hunter.Marksmanship = {}
	TRB.Options.Hunter.Feral = {}
	TRB.Options.Hunter.Guardian = {}
	TRB.Options.Hunter.Restoration = {}
    
    
	local function MarksmanshipLoadDefaultBarTextSimpleSettings()
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function MarksmanshipLoadDefaultBarTextAdvancedSettings()
		local textSettings = {		
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "$haste% ($gcd)||n{$ttd}[TTD: $ttd]",
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
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$focus",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",			
				fontSize = 22
			}
		}

		return textSettings
	end

	local function MarksmanshipLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
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
				dragAndDrop=false
			},
			colors = {
				text = {
					current="FFBAE57E",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",	
					overcap="FFFF0000",	
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
				},
				bar = {
					border="FF698247",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFAAD372",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",
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

		settings.displayText = MarksmanshipLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function MarksmanshipResetSettings()
		local settings = MarksmanshipLoadDefaultSettings()
		return settings
	end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()
		local specId = GetSpecialization()
		settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings()
		return settings
	end
    TRB.Options.Hunter.LoadDefaultSettings = LoadDefaultSettings

	local function MarksmanshipConstructOptionsPanel()		
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
		interfaceSettingsFrame.shadowDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Marksmanship", UIParent)
		interfaceSettingsFrame.shadowDisplayPanel.name = "Marksmanship Hunter"
		interfaceSettingsFrame.shadowDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.shadowDisplayPanel)

		parent = interfaceSettingsFrame.shadowDisplayPanel
				
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Marksmanship Hunter", xCoord+xPadding, yCoord)

		yCoord = yCoord - 42	

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab1", "Reset Defaults", 1, parent, 100)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab2", "Bar Display", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab3", "Font & Text", 3, parent, 85, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab4", "Audio & Tracking", 4, parent, 120, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab5", "Bar Text", 5, parent, 60, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Hunter_Marksmanship_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1
		parent.tabsheets[1].selected = true
		parent.tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)

		--[[MarksmanshipConstructResetDefaultsPanel(tabsheets[1].scrollFrame.scrollChild)
		MarksmanshipConstructBarColorsAndBehaviorPanel(tabsheets[2].scrollFrame.scrollChild)
		MarksmanshipConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
		MarksmanshipConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
		MarksmanshipConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild)]]
	end

	local function ConstructOptionsPanel()
		TRB.Options.ConstructOptionsPanel()
		MarksmanshipConstructOptionsPanel()
	end
	TRB.Options.Hunter.ConstructOptionsPanel = ConstructOptionsPanel
end