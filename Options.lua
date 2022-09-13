local _, TRB = ...

TRB.Options = {}

local oUi = TRB.Data.constants.optionsUi

local f1 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Highlight_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f1:SetFontObject(GameFontHighlightSmall)
local f2 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Green_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f2:SetFontObject(GameFontGreenSmall)
local f3 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Normal_Small_Color")
---@diagnostic disable-next-line: need-check-nil
f3:SetFontObject(GameFontNormalSmall)
local f4 = CreateFont("TwintopResourceBar_OptionsMenu_Export_Spec_Color")
---@diagnostic disable-next-line: need-check-nil
f4:SetFontObject(GameFontWhite)

TRB.Options.fonts = {}
TRB.Options.fonts.options = {}
TRB.Options.fonts.options.tabHighlightSmall = f1
TRB.Options.fonts.options.tabGreenSmall = f2
TRB.Options.fonts.options.tabNormalSmall = f3
TRB.Options.fonts.options.exportSpec = f4

TRB.Options.variables = {}
local barTextInstructions = string.format("For more detailed information about Bar Text customization, see the TRB Wiki on GitHub.\n\n")
barTextInstructions = string.format("%sFor conditional display (only if $VARIABLE is active/non-zero):\n    {$VARIABLE}[$VARIABLE is TRUE output]\n\n", barTextInstructions)
barTextInstructions = string.format("%sBoolean AND (&), OR (|), NOT (!), and parenthises in logic for conditional display is supported:\n    {$A&$B}[Both are TRUE output]\n    {$A|$B}[One or both is TRUE output]\n    {!$A}[$A is FALSE output]\n    {!$A&($B|$C)}[$A is FALSE and $B or $C is TRUE output]\n\n", barTextInstructions)
barTextInstructions = string.format("%sExpressions are also supported (+, -, *, /) and comparison symbols (>, >=, <, <=, =, !=):\n    {$VARIABLE*2>=$OTHERVAR}[$VARIABLE is at least twice as large as $OTHERVAR output]\n\n", barTextInstructions)
barTextInstructions = string.format("%sIF/ELSE is supported:\n    {$VARIABLE}[$VARIABLE is TRUE output][$VARIABLE is FALSE output]\n    {$VARIABLE>2}[$VARIABLE is more than 2 output][$VARIABLE is less than 2 output]\n\n", barTextInstructions)
barTextInstructions = string.format("%sIF/ELSE includes NOT support:\n    {!$VARIABLE}[$VARIABLE is FALSE output][$VARIABLE is TRUE output]\n\n", barTextInstructions)
barTextInstructions = string.format("%sLogic can be nexted inside IF/ELSE blocks:\n    {$A}[$A is TRUE output][$A is FALSE and {$B}[$B is TRUE][$B is FALSE] output]\n\n", barTextInstructions)
barTextInstructions = string.format("%sTo display icons use:\n    #ICONVARIABLENAME", barTextInstructions)
TRB.Options.variables.barTextInstructions = barTextInstructions

local function LoadDefaultSettings()
    local settings = {
        core = {
            dataRefreshRate = 5.0,
            reactionTime = 0.1,
            ttd = {
                sampleRate = 0.2,
                numEntries = 50,
                precision = 1
            },
            audio = {
                channel={
                    name="Master",
                    channel="Master"
                }
            },
            strata={
                level="BACKGROUND",
                name="Background"
            },            
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
				}
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			bar = {
				width=1555,
				height=34,
				xPos=0,
				yPos=200,
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
				textureLock=true,
				comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
				comboPointsBackgroundName="Blizzard Tooltip",
				comboPointsBorder="Interface\\Buttons\\WHITE8X8",
				comboPointsBorderName="1 Pixel",
				comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
				comboPointsBarName="Blizzard",
			},
            font={
                fontSizeLock = true,
                fontFaceLock = true,
                left = {
                    fontFace = "Fonts\\FRIZQT__.TTF",
                    fontFaceName = "Friz Quadrata TT",
                    fontSize = 18
                },
                middle = {
                    fontFace = "Fonts\\FRIZQT__.TTF",
                    fontFaceName = "Friz Quadrata TT",
                    fontSize = 18
                },
                right = {
                    fontFace = "Fonts\\FRIZQT__.TTF",
                    fontFaceName = "Friz Quadrata TT",
                    fontSize = 18
                }
            },
            globalSettings = {
                globalEnable = false,
                demonhunter = {
                    havoc = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                },
                druid = {
                    balance = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    feral = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    restoration = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                },
                hunter = {
                    beastMastery = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    marksmanship = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    survival = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                },
                monk = {
                    mistweaver = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    windwalker = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                },
                priest = {
                    holy = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    shadow = {
                        specEnable = false,
                        bar = true,
                        comboPoints = false,
                        displayBar = false,
                        font = false,
                        textures = false,
                        thresholds = false
                    }                    
                },
                rogue = {
                    assassination = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    outlaw = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                },
                shaman = {
                    elemental = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    restoration = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                },
                warrior = {
                    arms = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    },
                    fury = {
                        specEnable = false,
                        bar = true,
                        comboPoints = true,
                        displayBar = true,
                        font = true,
                        textures = true,
                        thresholds = true
                    }
                }
            },
            enabled = {
                demonhunter = {
                    havoc = true
                },
                druid = {
                    balance = true,
                    feral = true,
                    restoration = true
                },
                hunter = {
                    beastMastery = true,
                    marksmanship = true,
                    survival = true
                },
                monk = {
                    mistweaver = true,
                    windwalker = true
                },
                priest = {
                    holy = true,
                    shadow = true
                },
                rogue = {
                    assassination = true,
                    outlaw = true
                },
                shaman = {
                    elemental = true,
                    restoration = true
                },
                warrior = {
                    arms = true,
                    fury = true
                }
            },
            experimental = {
                specs = {
                }
            }
        },
        demonhunter = {
            havoc = {}
        },
        druid = {
            balance = {},
            feral = {},
            restoration = {}
        },
        hunter = {
            beastMastery = {},
            marksmanship = {},
            survival = {}
        },
        monk = {
            mistweaver = {},
            windwalker = {}
        },
        priest = {
            holy = {},
            shadow = {}
        },
        rogue = {
            assassination = {},
        },
        shaman = {
            elemental = {}
        },
        warrior = {
            arms = {},
            fury = {}
        }
    }

    return settings
end
TRB.Options.LoadDefaultSettings = LoadDefaultSettings

local function ConstructAddonOptionsPanel()
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
    local parent = interfaceSettingsFrame.panel
    local controls = interfaceSettingsFrame.controls
    local yCoord = -5
    local f = nil

    local maxOptionsWidth = 580

    local title = ""

    interfaceSettingsFrame.optionsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_General", UIParent)
    interfaceSettingsFrame.optionsPanel.name = "Global Options"
---@diagnostic disable-next-line: undefined-field
    interfaceSettingsFrame.optionsPanel.parent = parent.name
    local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.optionsPanel, "Global Options")

    parent = interfaceSettingsFrame.optionsPanel
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Global Options", oUi.xCoord+oUi.xPadding, yCoord)

    yCoord = yCoord - 30
    parent.panel = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Options_General_LayoutPanel", parent, 580, 523)
    parent.panel:SetPoint("TOPLEFT", 10, yCoord)
    parent.panel:Show()

    parent = parent.panel.scrollFrame.scrollChild

    yCoord = 5

    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Time To Die", 0, yCoord)

    yCoord = yCoord - 50

    title = "Sampling Rate (seconds)"
    controls.ttdSamplingRate = TRB.UiFunctions:BuildSlider(parent, title, 0.05, 2, TRB.Data.settings.core.ttd.sampleRate, 0.05, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.ttdSamplingRate:SetScript("OnValueChanged", function(self, value)
        local min, max = self:GetMinMaxValues()
        if value > max then
            value = max
        elseif value < min then
            value = min
        else
            value = TRB.Functions.RoundTo(value, 2)
        end

        self.EditBox:SetText(value)
        TRB.Data.settings.core.ttd.sampleRate = value
    end)

    title = "Sample Size"
    controls.ttdSampleSize = TRB.UiFunctions:BuildSlider(parent, title, 1, 1000, TRB.Data.settings.core.ttd.numEntries, 1, 0,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.ttdSampleSize:SetScript("OnValueChanged", function(self, value)
        local min, max = self:GetMinMaxValues()
        if value > max then
            value = max
        elseif value < min then
            value = min
        end

        self.EditBox:SetText(value)
        TRB.Data.settings.core.ttd.numEntries = value
    end)

    yCoord = yCoord - 60
    title = "Time To Die Precision"
    controls.ttdPrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.ttd.precision, 1, 0,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.ttdPrecision:SetScript("OnValueChanged", function(self, value)
        local min, max = self:GetMinMaxValues()
        if value > max then
            value = max
        elseif value < min then
            value = min
        end

        value = TRB.Functions.RoundTo(value, 0)
        self.EditBox:SetText(value)
        TRB.Data.settings.core.ttd.precision = value
    end)

    yCoord = yCoord - 40
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Character and Player Settings", 0, yCoord)

    yCoord = yCoord - 50

    title = "Character Data Refresh Rate (seconds)"
    controls.characterRefreshRate = TRB.UiFunctions:BuildSlider(parent, title, 0.05, 60, TRB.Data.settings.core.dataRefreshRate, 0.05, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.characterRefreshRate:SetScript("OnValueChanged", function(self, value)
        local min, max = self:GetMinMaxValues()
        if value > max then
            value = max
        elseif value < min then
            value = min
        else
            value = TRB.Functions.RoundTo(value, 2)
        end

        self.EditBox:SetText(value)
        TRB.Data.settings.core.dataRefreshRate = value
    end)

    title = "Player Reaction Time Latency (seconds)"
    controls.reactionTime = TRB.UiFunctions:BuildSlider(parent, title, 0.00, 1, TRB.Data.settings.core.reactionTime, 0.05, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.reactionTime:SetScript("OnValueChanged", function(self, value)
        local min, max = self:GetMinMaxValues()
        if value > max then
            value = max
        elseif value < min then
            value = min
        else
            value = TRB.Functions.RoundTo(value, 2)
        end

        self.EditBox:SetText(value)
        TRB.Data.settings.core.reactionTime = value
    end)

    yCoord = yCoord - 40
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Frame Strata", 0, yCoord)

    yCoord = yCoord - 30

    -- Create the dropdown, and configure its appearance
    controls.dropDown.strata = CreateFrame("FRAME", "TwintopResourceBar_FrameStrata", parent, "UIDropDownMenuTemplate")
    controls.dropDown.strata.label = TRB.UiFunctions:BuildSectionHeader(parent, "Frame Strata Level To Draw Bar On", oUi.xCoord, yCoord)
    controls.dropDown.strata.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.strata:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    UIDropDownMenu_SetWidth(controls.dropDown.strata, oUi.dropdownWidth)
    UIDropDownMenu_SetText(controls.dropDown.strata, TRB.Data.settings.core.strata.name)
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
            info.checked = strata[v] == TRB.Data.settings.core.strata.level
            info.func = self.SetValue
            info.arg1 = strata[v]
            info.arg2 = v
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    function controls.dropDown.strata:SetValue(newValue, newName)
        TRB.Data.settings.core.strata.level = newValue
        TRB.Data.settings.core.strata.name = newName
        TRB.Frames.barContainerFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.barBorderFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.resourceFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.castingFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.passiveFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.passiveFrame.thresholds[1]:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.resourceFrame.thresholds[1]:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.resourceFrame.thresholds[2]:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.leftTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.middleTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        TRB.Frames.rightTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        UIDropDownMenu_SetText(controls.dropDown.strata, newName)
        CloseDropDownMenus()
    end


    yCoord = yCoord - 60
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Channel", 0, yCoord)

    yCoord = yCoord - 30

    -- Create the dropdown, and configure its appearance
    controls.dropDown.audioChannel = CreateFrame("FRAME", "TwintopResourceBar_FrameAudioChannel", parent, "UIDropDownMenuTemplate")
    controls.dropDown.audioChannel.label = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Channel To Use", oUi.xCoord, yCoord)
    controls.dropDown.audioChannel.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.audioChannel:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    UIDropDownMenu_SetWidth(controls.dropDown.audioChannel, oUi.dropdownWidth)
    UIDropDownMenu_SetText(controls.dropDown.audioChannel, TRB.Data.settings.core.audio.channel.name)
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
            info.checked = channel[v] == TRB.Data.settings.core.audio.channel.channel
            info.func = self.SetValue
            info.arg1 = channel[v]
            info.arg2 = v
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    function controls.dropDown.audioChannel:SetValue(newValue, newName)
        TRB.Data.settings.core.audio.channel.channel = newValue
        TRB.Data.settings.core.audio.channel.name = newName
        UIDropDownMenu_SetText(controls.dropDown.audioChannel, newName)
        CloseDropDownMenus()
    end

    --[[
    yCoord = yCoord - 60
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Experimental Features", 0, yCoord)

    yCoord = yCoord - 30
    controls.checkBoxes.experimentalMonkMistweaver = CreateFrame("CheckButton", "TwintopResourceBar_CB_Experimental_Shaman_Mistweaver", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.experimentalMonkMistweaver
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Mistweaver Monk support")
    f.tooltip = "This will enable experimental Mistweaver Monk support within the bar. If you change this setting and are currently logged in on a Monk, you'll need to reload your UI before Mistweaver Monk configuration options become available."
    f:SetChecked(TRB.Data.settings.core.experimental.specs.monk.mistweaver)
    f:SetScript("OnClick", function(self, ...)
        TRB.Data.settings.core.experimental.specs.monk.mistweaver = self:GetChecked()
    end)

    yCoord = yCoord - 30
    controls.checkBoxes.experimentalShamanRestoration = CreateFrame("CheckButton", "TwintopResourceBar_CB_Experimental_Shaman_Restoration", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.experimentalShamanRestoration
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Restoration Shaman support")
    f.tooltip = "This will enable experimental Restoration Shaman support within the bar. If you change this setting and are currently logged in on a Shaman, you'll need to reload your UI before Restoration Shaman configuration options become available."
    f:SetChecked(TRB.Data.settings.core.experimental.specs.shaman.restoration)
    f:SetScript("OnClick", function(self, ...)
        TRB.Data.settings.core.experimental.specs.shaman.restoration = self:GetChecked()
    end)

    yCoord = yCoord - 30
    controls.checkBoxes.experimentalDruidRestoration = CreateFrame("CheckButton", "TwintopResourceBar_CB_Experimental_Druid_Restoration", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.experimentalDruidRestoration
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Restoration Druid support")
    f.tooltip = "This will enable experimental Restoration Druid support within the bar. If you change this setting and are currently logged in on a Druid, you'll need to reload your UI before Restoration Druid configuration options become available."
    f:SetChecked(TRB.Data.settings.core.experimental.specs.druid.restoration)
    f:SetScript("OnClick", function(self, ...)
        TRB.Data.settings.core.experimental.specs.druid.restoration = self:GetChecked()
    end)
    ]]

    TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
    TRB.Frames.interfaceSettingsFrameContainer.controls = controls
end


local function ConstructImportExportPanel()
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
    local parent = interfaceSettingsFrame.panel
    local controls = interfaceSettingsFrame.controls.importExport or {}
    local yCoord = -5
    local f = nil

    local title = ""
    local specName = ""
    local buttonOffset = 0
    local buttonSpacing = 5


    interfaceSettingsFrame.optionsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_ImportExport", UIParent)
    interfaceSettingsFrame.optionsPanel.name = "Import/Export"
---@diagnostic disable-next-line: undefined-field
    interfaceSettingsFrame.optionsPanel.parent = parent.name
    local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.optionsPanel, "Import/Export")

    parent = interfaceSettingsFrame.optionsPanel
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Import/Export", oUi.xCoord+oUi.xPadding, yCoord)
    controls.labels = controls.labels or {}
    controls.buttons = controls.buttons or {}

    yCoord = yCoord - 30
    parent.panel = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Options_General_LayoutPanel", parent, 580, 523)
    parent.panel:SetPoint("TOPLEFT", 10, yCoord)
    parent.panel:Show()

    parent = parent.panel.scrollFrame.scrollChild

    yCoord = 5
    controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Import Settings Configuration", oUi.xCoord, yCoord)


    StaticPopupDialogs["TwintopResourceBar_ImportError"] = {
        text = "Twintop's Resource Bar import failed. Please check the settings configuration string that you entered and try again.",
        button1 = "OK",
        OnAccept = function(self)
            StaticPopup_Show("TwintopResourceBar_Import")
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3
    }

    StaticPopupDialogs["TwintopResourceBar_Import"] = {
        text = "Paste in a Twintop's Resource Bar configuration string to have that configuration be imported. Your UI will be reloaded automatically.",
        button1 = "Import",	
        button2 = "Cancel",		
        hasEditBox = true,
        hasWideEditBox = true,
        editBoxWidth = 500,
        OnAccept = function(self)
            local result = false
            result = TRB.Functions.Import(self.editBox:GetText())

            if result >= 0 then
                ReloadUI()
            else
                if result == -3 then
                    StaticPopupDialogs["TwintopResourceBar_ImportError"].text = "Twintop's Resource Bar import failed. There were no valid classes, specs, or settings values found. Please check the settings configuration string that you entered and try again."
                else
                    StaticPopupDialogs["TwintopResourceBar_ImportError"].text = "Twintop's Resource Bar import failed. Please check the settings configuration string that you entered and try again."
                end

                StaticPopup_Show("TwintopResourceBar_ImportError")
            end
        end,
        timeout = 0,
        whileDead = true,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide();
        end,
        hideOnEscape = true,
        preferredIndex = 3
    }

    yCoord = yCoord - 40
    controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import existing Settings Configuration string", oUi.xCoord, yCoord, 300, 30)
    controls.buttons.importButton:SetScript("OnClick", function(self, ...)
	    StaticPopup_Show("TwintopResourceBar_Import")
    end)


    StaticPopupDialogs["TwintopResourceBar_Export"] = {
        text = "",
        button1 = "Close",
        hasEditBox = true,
        hasWideEditBox = true,
        editBoxWidth = 500,
        timeout = 0,
        whileDead = true,
        OnShow = function(self)
            self:SetWidth(420)
            local editBox = _G[self:GetName() .. "WideEditBox"] or _G[self:GetName() .. "EditBox"]
            editBox:SetText(self.text.text_arg1)
            editBox:SetFocus()
            editBox:HighlightText(false)
        end,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide();
        end,
        hideOnEscape = true,
        preferredIndex = 3
    }



    yCoord = yCoord - 40
    controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Export Settings Configuration", oUi.xCoord, yCoord)

    local exportPopupBoilerplate = "Copy the string below to share your Twintop's Resource Bar configuration for "

    yCoord = yCoord - 35

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Everything = TRB.UiFunctions:BuildButton(parent, "All Classes/Specs + Global Options", buttonOffset, yCoord, 230, 20)
    controls.buttons.exportButton_Everything:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "All Classes/Specs + Global Options.", nil, nil, true, true, true, true, true)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 230
    controls.exportButton_All_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Global Options Only", buttonOffset, yCoord, 200, 20)
    controls.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Global Options Only.", nil, -1, false, false, false, false, true)
    end)

    yCoord = yCoord - 35
    controls.labels.druid = TRB.UiFunctions:BuildLabel(parent, "All Classes/Specs", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_All_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_All_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "All Classes/Specs (All).", nil, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_All_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "All Classes/Specs (Bar Display).", nil, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_All_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_All_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "All Classes/Specs (Font & Text).", nil, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_All_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_All_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "All Classes/Specs (Audio & Tracking).", nil, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_All_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_All_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "All Classes/Specs (Bar Text).", nil, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.demonhunter = TRB.UiFunctions:BuildLabel(parent, "Demon Hunter", oUi.xCoord, yCoord, 110, 20)

    yCoord = yCoord - 25
    specName = "Havoc"
    controls.labels.demonhunterHavoc = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_DemonHunter_Havoc_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_DemonHunter_Havoc_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Havoc Demon Hunter (All).", 12, 1, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_DemonHunter_Havoc_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_DemonHunter_Havoc_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Havoc Demon Hunter (Bar Display).", 12, 1, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_DemonHunter_Havoc_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_DemonHunter_Havoc_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Havoc Demon Hunter (Font & Text).", 12, 1, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_DemonHunter_Havoc_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_DemonHunter_Havoc_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Havoc Demon Hunter (Audio & Tracking).", 12, 1, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_DemonHunter_Havoc_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_DemonHunter_Havoc_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Havoc Demon Hunter (Bar Text).", 12, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.druid = TRB.UiFunctions:BuildLabel(parent, "Druid", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Druid_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Druid_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Druid specializations (All).", 11, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Druid_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Druid_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Druid specializations (Bar Display).", 11, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Druid_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Druid_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Druid specializations (Font & Text).", 11, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Druid_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Druid_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Druid specializations (Audio & Tracking).", 11, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Druid_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Druid_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Druid specializations (Bar Text).", 11, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Balance"
    controls.labels.druidBalance = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Druid_Balance_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Druid_Balance_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Balance Druid (All).", 11, 1, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Druid_Balance_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Druid_Balance_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Balance Druid (Bar Display).", 11, 1, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Druid_Balance_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Druid_Balance_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Balance Druid (Font & Text).", 11, 1, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Druid_Balance_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Druid_Balance_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Balance Druid (Audio & Tracking).", 11, 1, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Druid_Balance_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Druid_Balance_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Balance Druid (Bar Text).", 11, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Feral"
    controls.labels.druidFeral = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Druid_Feral_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Druid_Feral_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Feral Druid (All).", 11, 2, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Druid_Feral_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Druid_Feral_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Feral Druid (Bar Display).", 11, 2, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Druid_Feral_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Druid_Feral_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Feral Druid (Font & Text).", 11, 2, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Druid_Feral_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Druid_Feral_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Feral Druid (Audio & Tracking).", 11, 2, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Druid_Feral_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Druid_Feral_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Feral Druid (Bar Text).", 11, 2, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Restoration"
    controls.labels.druidRestoration = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Druid_Restoration_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Druid_Restoration_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Druid (All).", 11, 4, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Druid_Restoration_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Druid_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Druid (Bar Display).", 11, 4, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Druid_Restoration_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Druid_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Druid (Font & Text).", 11, 4, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Druid_Restoration_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Druid_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Druid (Audio & Tracking).", 11, 4, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Druid_Restoration_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Druid_Restoration_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Druid (Bar Text).", 11, 4, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.hunter = TRB.UiFunctions:BuildLabel(parent, "Hunter", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Hunter_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Hunter specializations (All).", 3, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Hunter_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Hunter_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Hunter specializations (Bar Display).", 3, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Hunter_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Hunter_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Hunter specializations (Font & Text).", 3, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Hunter_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Hunter_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Hunter specializations (Audio & Tracking).", 3, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Hunter_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Hunter_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Hunter specializations (Bar Text).", 3, nil, false, false, false, true, false)
    end)


    yCoord = yCoord - 25
    specName = "Beast Mastery"
    controls.labels.hunterBeastMastery = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Beast Mastery Hunter (All).", 3, 1, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Hunter_BeastMastery_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Beast Mastery Hunter (Bar Display).", 3, 1, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Hunter_BeastMastery_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Beast Mastery Hunter (Font & Text).", 3, 1, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Beast Mastery Hunter (Audio & Tracking).", 3, 1, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Hunter_BeastMastery_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Beast Mastery Hunter (Bar Text).", 3, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Marksmanship"
    controls.labels.hunterMarksmanship = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Hunter_Marksmanship_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_Marksmanship_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Marksmanship Hunter (All).", 3, 2, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Hunter_Marksmanship_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Hunter_Marksmanship_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Marksmanship Hunter (Bar Display).", 3, 2, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Hunter_Marksmanship_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Marksmanship Hunter (Font & Text).", 3, 2, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Marksmanship Hunter (Audio & Tracking).", 3, 2, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Hunter_Marksmanship_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Marksmanship Hunter (Bar Text).", 3, 2, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Survival"
    controls.labels.hunterSurvival = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Hunter_Survival_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_Survival_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Survival Hunter (All).", 3, 3, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Hunter_Survival_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Hunter_Survival_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Survival Hunter (Bar Display).", 3, 3, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Hunter_Survival_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Survival Hunter (Font & Text).", 3, 3, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Hunter_Survival_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Survival Hunter (Audio & Tracking).", 3, 3, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Hunter_Survival_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Survival Hunter (Bar Text).", 3, 3, false, false, false, true, false)
    end)
    

    yCoord = yCoord - 35
    controls.labels.monk = TRB.UiFunctions:BuildLabel(parent, "Monk", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Monk_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Monk_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Monk specializations (All).", 10, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Monk_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Monk_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Monk specializations (Bar Display).", 10, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Monk_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Monk_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Monk specializations (Font & Text).", 10, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Monk_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Monk_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Monk specializations (Audio & Tracking).", 10, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Monk_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Monk_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Monk specializations (Bar Text).", 10, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Mistweaver"
    controls.labels.monkMistweaver = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Monk_Mistweaver_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Monk_Mistweaver_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Mistweaver Monk (All).", 10, 2, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Monk_Mistweaver_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Monk_Mistweaver_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Mistweaver Monk (Bar Display).", 10, 2, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Monk_Mistweaver_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Monk_Mistweaver_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Mistweaver Monk (Font & Text).", 10, 2, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Monk_Mistweaver_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Monk_Mistweaver_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Mistweaver Monk (Audio & Tracking).", 10, 2, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Monk_Mistweaver_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Monk_Mistweaver_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Mistweaver Monk (Bar Text).", 10, 2, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Windwalker"
    controls.labels.monkWindwalker = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Monk_Windwalker_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Monk_Windwalker_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Windwalker Monk (All).", 10, 3, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Monk_Windwalker_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Monk_Windwalker_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Windwalker Monk (Bar Display).", 10, 3, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Monk_Windwalker_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Monk_Windwalker_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Windwalker Monk (Font & Text).", 10, 3, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Monk_Windwalker_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Monk_Windwalker_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Windwalker Monk (Audio & Tracking).", 10, 3, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Monk_Windwalker_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Monk_Windwalker_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Windwalker Monk (Bar Text).", 10, 3, false, false, false, true, false)
    end)
    

    yCoord = yCoord - 35
    controls.labels.priest = TRB.UiFunctions:BuildLabel(parent, "Priest", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Priest_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Priest_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Priest specializations (All).", 5, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Priest_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Priest_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Priest specializations (Bar Display).", 5, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Priest_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Priest_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Priest specializations (Font & Text).", 5, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Priest_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Priest_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Priest specializations (Audio & Tracking).", 5, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Priest_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Priest_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Priest specializations (Bar Text).", 5, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Holy"
    controls.labels.priestHoly = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Priest_Holy_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Priest_Holy_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Holy Priest (All).", 5, 2, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Priest_Holy_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Priest_Holy_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Holy Priest (Bar Display).", 5, 2, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Priest_Holy_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Priest_Holy_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Holy Priest (Font & Text).", 5, 2, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Priest_Holy_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Priest_Holy_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Holy Priest (Audio & Tracking).", 5, 2, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Priest_Holy_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Priest_Holy_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Holy Priest (Bar Text).", 5, 2, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Shadow"
    controls.labels.priestShadow = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Priest_Shadow_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Shadow Priest (All).", 5, 3, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Priest_Shadow_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Priest_Shadow_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Shadow Priest (Bar Display).", 5, 3, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Priest_Shadow_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Shadow Priest (Font & Text).", 5, 3, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Priest_Shadow_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Priest_Shadow_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Shadow Priest (Audio & Tracking).", 5, 3, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Priest_Shadow_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Priest_Shadow_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Shadow Priest (Bar Text).", 5, 3, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.rogue = TRB.UiFunctions:BuildLabel(parent, "Rogue", oUi.xCoord, yCoord, 110, 20)
    
    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Rogue_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Rogue_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Rogue specializations (All).", 4, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Rogue_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Rogue_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Rogue specializations (Bar Display).", 4, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Rogue_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Rogue_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Rogue specializations (Font & Text).", 4, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Rogue_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Rogue_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Rogue specializations (Audio & Tracking).", 4, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Rogue_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Rogue_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Rogue specializations (Bar Text).", 4, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Assassination"
    controls.labels.rogueAssassination = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Rogue_Assassination_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Rogue_Assassination_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Assassination Rogue (All).", 4, 1, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Rogue_Assassination_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Rogue_Assassination_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Assassination Rogue (Bar Display).", 4, 1, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Rogue_Assassination_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Rogue_Assassination_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Assassination Rogue (Font & Text).", 4, 1, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Rogue_Assassination_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Rogue_Assassination_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Assassination Rogue (Audio & Tracking).", 4, 1, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Rogue_Assassination_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Rogue_Assassination_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Assassination Rogue (Bar Text).", 4, 1, false, false, false, true, false)
    end)


    yCoord = yCoord - 25
    specName = "Outlaw"
    controls.labels.rogueOutlaw = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Rogue_Outlaw_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Rogue_Outlaw_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Outlaw Rogue (All).", 4, 2, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Rogue_Outlaw_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Rogue_Outlaw_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Outlaw Rogue (Bar Display).", 4, 2, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Rogue_Outlaw_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Rogue_Outlaw_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Outlaw Rogue (Font & Text).", 4, 2, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Rogue_Outlaw_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Rogue_Outlaw_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Outlaw Rogue (Audio & Tracking).", 4, 2, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Rogue_Outlaw_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Rogue_Outlaw_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Outlaw Rogue (Bar Text).", 4, 2, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.shaman = TRB.UiFunctions:BuildLabel(parent, "Shaman", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Shaman_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Shaman_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Shaman specializations (All).", 7, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Shaman_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Shaman_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Shaman specializations (Bar Display).", 7, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Shaman_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Shaman_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Shaman specializations (Font & Text).", 7, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Shaman_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Shaman_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Shaman specializations (Audio & Tracking).", 7, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Shaman_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Shaman_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Shaman specializations (Bar Text).", 7, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Elemental"
    controls.labels.shamanElemental = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Shaman_Elemental_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Shaman_Elemental_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Elemental Shaman (All).", 7, 1, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Shaman_Elemental_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Shaman_Elemental_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Elemental Shaman (Bar Display).", 7, 1, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Shaman_Elemental_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Elemental Shaman (Font & Text).", 7, 1, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Shaman_Elemental_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Shaman_Elemental_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Elemental Shaman (Audio & Tracking).", 7, 1, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Shaman_Elemental_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Shaman_Elemental_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Elemental Shaman (Bar Text).", 7, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Restoration"
    controls.labels.shamanRestoration = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Shaman_Restoration_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Shaman_Restoration_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Shaman (All).", 7, 3, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Shaman_Restoration_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Shaman_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Shaman (Bar Display).", 7, 3, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Shaman_Restoration_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Shaman_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Shaman (Font & Text).", 7, 3, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Shaman_Restoration_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Shaman_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Shaman (Audio & Tracking).", 7, 3, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Shaman_Restoration_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Shaman_Restoration_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Restoration Shaman (Bar Text).", 7, 3, false, false, false, true, false)
    end)


    yCoord = yCoord - 35
    controls.labels.warrior = TRB.UiFunctions:BuildLabel(parent, "Warrior", oUi.xCoord, yCoord, 110, 20)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Warrior_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Warrior_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Warrior specializations (All).", 1, nil, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Warrior_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Warrior_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Warrior specializations (Bar Display).", 1, nil, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Warrior_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Warrior_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Warrior specializations (Font & Text).", 1, nil, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Warrior_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Warrior_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Warrior specializations (Audio & Tracking).", 1, nil, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Warrior_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Warrior_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "all Warrior specializations (Bar Text).", 1, nil, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Arms"
    controls.labels.warriorArms = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Warrior_Arms_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Warrior_Arms_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Arms Warrior (All).", 1, 1, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Warrior_Arms_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Warrior_Arms_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Arms Warrior (Bar Display).", 1, 1, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Warrior_Arms_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Warrior_Arms_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Arms Warrior (Font & Text).", 1, 1, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Warrior_Arms_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Warrior_Arms_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Arms Warrior (Audio & Tracking).", 1, 1, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Warrior_Arms_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Warrior_Arms_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Arms Warrior (Bar Text).", 1, 1, false, false, false, true, false)
    end)


    yCoord = yCoord - 25
    specName = "Fury"
    controls.labels.warriorFury = TRB.UiFunctions:BuildLabel(parent, specName, oUi.xCoord+oUi.xPadding, yCoord, 100, 20, TRB.Options.fonts.options.exportSpec)

    buttonOffset = oUi.xCoord + oUi.xPadding + 100
    controls.buttons.exportButton_Warrior_Fury_All = TRB.UiFunctions:BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Warrior_Fury_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Fury Warrior (All).", 1, 2, true, true, true, true, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 50
    controls.exportButton_Warrior_Fury_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.exportButton_Warrior_Fury_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Fury Warrior (Bar Display).", 1, 2, true, false, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 80
    controls.exportButton_Warrior_Fury_FontAndText = TRB.UiFunctions:BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.exportButton_Warrior_Fury_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Fury Warrior (Font & Text).", 1, 2, false, true, false, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 90
    controls.exportButton_Warrior_Fury_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.exportButton_Warrior_Fury_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Fury Warrior (Audio & Tracking).", 1, 2, false, false, true, false, false)
    end)

    buttonOffset = buttonOffset + buttonSpacing + 120
    controls.exportButton_Warrior_Fury_BarText = TRB.UiFunctions:BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.exportButton_Warrior_Fury_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup(exportPopupBoilerplate .. "Fury Warrior (Bar Text).", 1, 2, false, false, false, true, false)
    end)

    TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
    TRB.Frames.interfaceSettingsFrameContainer.controls.importExport = controls
end

function TRB.Options:ConstructOptionsPanel()
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
    interfaceSettingsFrame.controls = {}
    local controls = interfaceSettingsFrame.controls
    controls.colors = {}
    controls.labels = {}
    controls.textbox = {}
    controls.checkBoxes = {}
    controls.dropDown = {}

    interfaceSettingsFrame.panel = CreateFrame("Frame", "TwintopResourceBarPanel", UIParent)
    interfaceSettingsFrame.panel.name = "Twintop's Resource Bar"
    local parent = interfaceSettingsFrame.panel
    local yCoord = -5

    interfaceSettingsFrame.controls.barPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, TRB.Details.addonTitle, oUi.xCoord+oUi.xPadding, yCoord)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoAuthor = TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, "Author:", TRB.Details.addonAuthor .. " - " .. TRB.Details.addonAuthorServer, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 450, 15, 15)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoVersion = TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, "Version:", TRB.Details.addonVersion, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 450, 15, 15)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoReleased = TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, "Released:", TRB.Details.addonReleaseDate, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 450, 15, 15)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoSupport = TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, "Supported Specs (Dragonflight):", TRB.Details.supportedSpecs, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 450, 15, 300)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoSupport = TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, "Not Yet Updated Specs (Dragonflight):", TRB.Details.needUpdatingSpecs, oUi.xCoord+(oUi.xPadding*2), yCoord, 0, 450, 15, 300)


    interfaceSettingsFrame.panel.yCoord = yCoord
    local layout
    TRB.Details.addonCategory, layout = Settings.RegisterCanvasLayoutCategory(interfaceSettingsFrame.panel, "Twintop's Resource Bar")
    Settings.RegisterAddOnCategory(TRB.Details.addonCategory)

    ConstructAddonOptionsPanel()
    ConstructImportExportPanel()
end

function TRB.Options:PortForwardSettings()
    -- Forward port old Insanity Bar settings
    if TwintopInsanityBarSettings ~= nil and TwintopInsanityBarSettings.priest == nil and TwintopInsanityBarSettings.bar ~= nil then
        local tempSettings = TwintopInsanityBarSettings
        TwintopInsanityBarSettings.priest = {}
        TwintopInsanityBarSettings.priest.discipline = {}
        TwintopInsanityBarSettings.priest.holy = {}
        TwintopInsanityBarSettings.priest.shadow = tempSettings
        TwintopInsanityBarSettings.priest.shadow.textures.resourceBar = TwintopInsanityBarSettings.priest.shadow.textures.insanityBar
        TwintopInsanityBarSettings.priest.shadow.textures.resourceBarName = TwintopInsanityBarSettings.priest.shadow.textures.insanityBarName
        TwintopInsanityBarSettings.core = {}
        TwintopInsanityBarSettings.core.dataRefreshRate = tempSettings.dataRefreshRate
        TwintopInsanityBarSettings.core.ttd = tempSettings.ttd
        TwintopInsanityBarSettings.core.audio = {}
        TwintopInsanityBarSettings.core.audio.channel = tempSettings.audio.channel
        TwintopInsanityBarSettings.core.strata = tempSettings.strata
    end

    -- Forward port old In/Out of Voidform settings
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.priest ~= nil and
        TwintopInsanityBarSettings.priest.shadow ~= nil and
        TwintopInsanityBarSettings.priest.shadow.displayText ~= nil and
        TwintopInsanityBarSettings.priest.shadow.displayText.left ~= nil and
        TwintopInsanityBarSettings.priest.shadow.displayText.left.text == nil then
        local leftText = ""
        local middleText = ""
        local rightText = ""
        
        if TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText == TwintopInsanityBarSettings.priest.shadow.displayText.left.inVoidformText then
            leftText = TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText
        else
            leftText = "{$vfTime}[" .. TwintopInsanityBarSettings.priest.shadow.displayText.left.inVoidformText .. "][" .. TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText .. "]"
        end
        TwintopInsanityBarSettings.priest.shadow.displayText.left.text = leftText
        TwintopInsanityBarSettings.priest.shadow.displayText.left.inVoidformText = nil
        TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText = nil
        
        if TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText == TwintopInsanityBarSettings.priest.shadow.displayText.middle.inVoidformText then
            middleText = TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText
        else
            middleText = "{$vfTime}[" .. TwintopInsanityBarSettings.priest.shadow.displayText.middle.inVoidformText .. "][" .. TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText .. "]"
        end
        TwintopInsanityBarSettings.priest.shadow.displayText.middle.text = middleText
        TwintopInsanityBarSettings.priest.shadow.displayText.middle.inVoidformText = nil
        TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText = nil
        
        if TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText == TwintopInsanityBarSettings.priest.shadow.displayText.right.inVoidformText then
            rightText = TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText
        else
            rightText = "{$vfTime}[" .. TwintopInsanityBarSettings.priest.shadow.displayText.right.inVoidformText .. "][" .. TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText .. "]"
        end
        TwintopInsanityBarSettings.priest.shadow.displayText.right.text = rightText
        TwintopInsanityBarSettings.priest.shadow.displayText.right.inVoidformText = nil
        TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText = nil
    end

    -- Shadow Thresholds
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.priest ~= nil and
        TwintopInsanityBarSettings.priest.shadow ~= nil and
        TwintopInsanityBarSettings.priest.shadow.thresholdWidth ~= nil then
        
        TwintopInsanityBarSettings.priest.shadow.thresholds = {
            width = TwintopInsanityBarSettings.priest.shadow.thresholdWidth,
            overlapBorder = TwintopInsanityBarSettings.priest.shadow.thresholdsOverlapBorder,
            devouringPlague = {
                enabled = TwintopInsanityBarSettings.priest.shadow.devouringPlagueThreshold
            },
            searingNightmare = {
                enabled = TwintopInsanityBarSettings.priest.shadow.searingNightmareThreshold
            }
        }

        TwintopInsanityBarSettings.priest.shadow.thresholdWidth = nil
        TwintopInsanityBarSettings.priest.shadow.devouringPlagueThreshold = nil
        TwintopInsanityBarSettings.priest.shadow.searingNightmareThreshold = nil
        TwintopInsanityBarSettings.priest.shadow.thresholdsOverlapBorder = nil
    end

    -- Holy Thresholds
    if TwintopInsanityBarSettings ~= nil and
    TwintopInsanityBarSettings.priest ~= nil and
    TwintopInsanityBarSettings.priest.holy ~= nil and
    TwintopInsanityBarSettings.priest.holy.thresholdWidth ~= nil then
        
        TwintopInsanityBarSettings.priest.holy.thresholds.width = TwintopInsanityBarSettings.priest.holy.thresholdWidth
        TwintopInsanityBarSettings.priest.holy.thresholds.overlapBorder = TwintopInsanityBarSettings.priest.holy.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.priest.holy.thresholdWidth = nil
        TwintopInsanityBarSettings.priest.holy.thresholdsOverlapBorder = nil
    end

    -- Balance Thresholds
    if TwintopInsanityBarSettings ~= nil and
    TwintopInsanityBarSettings.druid ~= nil and
    TwintopInsanityBarSettings.druid.balance ~= nil and
    TwintopInsanityBarSettings.druid.balance.thresholdWidth ~= nil then
    
        TwintopInsanityBarSettings.druid.balance.thresholds = {
            width = TwintopInsanityBarSettings.druid.balance.thresholdWidth,
            overlapBorder = TwintopInsanityBarSettings.druid.balance.thresholdsOverlapBorder,
            starsurgeThresholdOnlyOverShow = TwintopInsanityBarSettings.druid.balance.starsurgeThresholdOnlyOverShow,
            starsurge = {
                enabled = TwintopInsanityBarSettings.druid.balance.starsurgeThreshold
            },
            starsurge2 = {
                enabled = TwintopInsanityBarSettings.druid.balance.starsurge2Threshold
            },
            starsurge3 = {
                enabled = TwintopInsanityBarSettings.druid.balance.starsurge3Threshold
            },
            starfall = {
                enabled = TwintopInsanityBarSettings.druid.balance.starfallThreshold
            }
        }

        TwintopInsanityBarSettings.druid.balance.thresholdWidth = nil
        TwintopInsanityBarSettings.druid.balance.devouringPlagueThreshold = nil
        TwintopInsanityBarSettings.druid.balance.searingNightmareThreshold = nil
        TwintopInsanityBarSettings.druid.balance.thresholdsOverlapBorder = nil
    end
  
    -- Elemental Thresholds
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.shaman ~= nil and
        TwintopInsanityBarSettings.shaman.elemental ~= nil and
        TwintopInsanityBarSettings.shaman.elemental.thresholdWidth ~= nil then

        TwintopInsanityBarSettings.shaman.elemental.thresholds = {
            width = TwintopInsanityBarSettings.shaman.elemental.thresholdWidth,
            overlapBorder = TwintopInsanityBarSettings.shaman.elemental.thresholdsOverlapBorder,
            earthShock = {
                enabled = TwintopInsanityBarSettings.shaman.elemental.earthShockThreshold
            }
        }
        
        TwintopInsanityBarSettings.shaman.elemental.thresholdWidth = nil
        TwintopInsanityBarSettings.shaman.elemental.earthShockThreshold = nil
        TwintopInsanityBarSettings.shaman.elemental.thresholdsOverlapBorder = nil
    end

    -- Hunters
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.hunter ~= nil and
        TwintopInsanityBarSettings.hunter.beastMastery ~= nil and
        TwintopInsanityBarSettings.hunter.beastMastery.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.hunter.beastMastery.thresholds.width = TwintopInsanityBarSettings.hunter.beastMastery.thresholdWidth
        TwintopInsanityBarSettings.hunter.beastMastery.thresholds.overlapBorder = TwintopInsanityBarSettings.hunter.beastMastery.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.hunter.beastMastery.thresholdWidth = nil
        TwintopInsanityBarSettings.hunter.beastMastery.thresholdsOverlapBorder = nil
    end
    
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.hunter ~= nil and
        TwintopInsanityBarSettings.hunter.marksmanship ~= nil and
        TwintopInsanityBarSettings.hunter.marksmanship.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.hunter.marksmanship.thresholds.width = TwintopInsanityBarSettings.hunter.marksmanship.thresholdWidth
        TwintopInsanityBarSettings.hunter.marksmanship.thresholds.overlapBorder = TwintopInsanityBarSettings.hunter.marksmanship.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.hunter.marksmanship.thresholdWidth = nil
        TwintopInsanityBarSettings.hunter.marksmanship.thresholdsOverlapBorder = nil
    end
    
    -- ChimaeraShot threshold
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.hunter ~= nil and
        TwintopInsanityBarSettings.hunter.marksmanship ~= nil and
        TwintopInsanityBarSettings.hunter.marksmanship.thresholds ~= nil and
        TwintopInsanityBarSettings.hunter.marksmanship.thresholds.chimaeraShot == nil then
        
        TwintopInsanityBarSettings.hunter.marksmanship.thresholds.chimaeraShot = TwintopInsanityBarSettings.hunter.marksmanship.thresholds.arcaneShot
    end

    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.hunter ~= nil and
        TwintopInsanityBarSettings.hunter.survival ~= nil and
        TwintopInsanityBarSettings.hunter.survival.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.hunter.survival.thresholds.width = TwintopInsanityBarSettings.hunter.survival.thresholdWidth
        TwintopInsanityBarSettings.hunter.survival.thresholds.overlapBorder = TwintopInsanityBarSettings.hunter.survival.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.hunter.survival.thresholds.mongooseBite = {
            enabled = TwintopInsanityBarSettings.hunter.survival.thresholds.raptorStrike.enabled
        }
        TwintopInsanityBarSettings.hunter.survival.thresholds.butchery = {
            enabled = TwintopInsanityBarSettings.hunter.survival.thresholds.carve.enabled
        }

        TwintopInsanityBarSettings.hunter.survival.thresholdWidth = nil
        TwintopInsanityBarSettings.hunter.survival.thresholdsOverlapBorder = nil
    end

    -- Warriors
    if TwintopInsanityBarSettings ~= nil and
    TwintopInsanityBarSettings.warrior ~= nil and
    TwintopInsanityBarSettings.warrior.arms ~= nil and
    TwintopInsanityBarSettings.warrior.arms.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.warrior.arms.thresholds.width = TwintopInsanityBarSettings.warrior.arms.thresholdWidth
        TwintopInsanityBarSettings.warrior.arms.thresholds.overlapBorder = TwintopInsanityBarSettings.warrior.arms.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.warrior.arms.thresholdWidth = nil
        TwintopInsanityBarSettings.warrior.arms.thresholdsOverlapBorder = nil
    end
    
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.warrior ~= nil and
        TwintopInsanityBarSettings.warrior.fury ~= nil and
        TwintopInsanityBarSettings.warrior.fury.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.warrior.fury.thresholds.width = TwintopInsanityBarSettings.warrior.fury.thresholdWidth
        TwintopInsanityBarSettings.warrior.fury.thresholds.overlapBorder = TwintopInsanityBarSettings.warrior.fury.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.warrior.fury.thresholdWidth = nil
        TwintopInsanityBarSettings.warrior.fury.thresholdsOverlapBorder = nil
    end

    -- Havoc
    if TwintopInsanityBarSettings ~= nil and
    TwintopInsanityBarSettings.demonhunter ~= nil and
    TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
    TwintopInsanityBarSettings.demonhunter.havoc.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.demonhunter.havoc.thresholds.width = TwintopInsanityBarSettings.demonhunter.havoc.thresholdWidth
        TwintopInsanityBarSettings.demonhunter.havoc.thresholds.overlapBorder = TwintopInsanityBarSettings.demonhunter.havoc.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.demonhunter.havoc.thresholdWidth = nil
        TwintopInsanityBarSettings.demonhunter.havoc.thresholdsOverlapBorder = nil
    end

    -- Assassination
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.rogue ~= nil and
        TwintopInsanityBarSettings.rogue.assassination ~= nil and
        TwintopInsanityBarSettings.rogue.assassination.thresholdWidth ~= nil then
            
        TwintopInsanityBarSettings.rogue.assassination.thresholds.width = TwintopInsanityBarSettings.rogue.assassination.thresholdWidth
        TwintopInsanityBarSettings.rogue.assassination.thresholds.overlapBorder = TwintopInsanityBarSettings.rogue.assassination.thresholdsOverlapBorder
        
        TwintopInsanityBarSettings.rogue.assassination.thresholdWidth = nil
        TwintopInsanityBarSettings.rogue.assassination.thresholdsOverlapBorder = nil
    end


    -- Shadow Voidform color variable name changed to Devouring Plague
    if TwintopInsanityBarSettings ~= nil and
        TwintopInsanityBarSettings.priest ~= nil and
        TwintopInsanityBarSettings.priest.shadow ~= nil and
        TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
        TwintopInsanityBarSettings.priest.shadow.colors.bar ~= nil and
        TwintopInsanityBarSettings.priest.shadow.colors.bar.enterVoidform ~= nil then
        TwintopInsanityBarSettings.priest.shadow.colors.bar.devouringPlagueUsable = TwintopInsanityBarSettings.priest.shadow.colors.bar.enterVoidform
        TwintopInsanityBarSettings.priest.shadow.colors.bar.enterVoidform = nil
    end
end

function TRB.Options:CleanupSettings(oldSettings)
    local newSettings = {}
    if oldSettings ~= nil then
        for k, v in pairs(oldSettings) do
            if  k == "core" or
                k == "demonhunter" or
                k == "deathknight" or
                k == "druid" or
                k == "hunter" or
                k == "mage" or
                k == "monk" or
                k == "paladin" or
                k == "priest" or
                k == "rogue" or
                k == "shaman" or
                k == "warlock" or
                k == "warrior"
            then
                newSettings[k] = v
            end
        end
    end
    return newSettings
end

function TRB.Options:CreateBarTextInstructions(parent, xCoord, yCoord)
    local maxOptionsWidth = 550
    local barTextInstructionsHeight = 400
    TRB.UiFunctions:BuildLabel(parent, TRB.Options.variables.barTextInstructions, xCoord+5, yCoord, maxOptionsWidth-(2*(xCoord+5)), barTextInstructionsHeight, GameFontHighlight, "LEFT")
end


function TRB.Options:CreateBarTextVariables(cache, parent, xCoord, yCoord)
    local height = 15
    local width = 260
    local entries1 = TRB.Functions.TableLength(cache.barTextVariables.values)
    for i=1, entries1 do
        if cache.barTextVariables.values[i].printInSettings == true then
            TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.values[i].variable, cache.barTextVariables.values[i].description, xCoord, yCoord, 0, width, height)
            yCoord = yCoord - (height * 3) - 5
        end
    end

    local entries2 = TRB.Functions.TableLength(cache.barTextVariables.pipe)
    for i=1, entries2 do
        if cache.barTextVariables.pipe[i].printInSettings == true then
            TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.pipe[i].variable, cache.barTextVariables.pipe[i].description, xCoord, yCoord, 0, width, height)
            yCoord = yCoord - (height * 3) - 5
        end
    end

    ---------

    local entries3 = TRB.Functions.TableLength(cache.barTextVariables.icons)
    for i=1, entries3 do
        if cache.barTextVariables.icons[i].printInSettings == true then
            local text = ""
            if cache.barTextVariables.icons[i].icon ~= "" then
                text = cache.barTextVariables.icons[i].icon .. " "
            end
            TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, cache.barTextVariables.icons[i].variable, text .. cache.barTextVariables.icons[i].description, xCoord, yCoord, 0, width, height)
            yCoord = yCoord - (height * 3) - 5
        end
    end
end