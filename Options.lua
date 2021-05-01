local _, TRB = ...

TRB.Options = {}

local f1 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Highlight_Small_Color")
f1:SetFontObject(GameFontHighlightSmall)
local f2 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Green_Small_Color")
f2:SetFontObject(GameFontGreenSmall)
local f3 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Normal_Small_Color")
f3:SetFontObject(GameFontNormalSmall)
local f4 = CreateFont("TwintopResourceBar_OptionsMenu_Export_Spec_Color")
f4:SetFontObject(GameFontWhite)

TRB.Options.fonts = {}
TRB.Options.fonts.options = {}
TRB.Options.fonts.options.tabHighlightSmall = f1
TRB.Options.fonts.options.tabGreenSmall = f2
TRB.Options.fonts.options.tabNormalSmall = f3
TRB.Options.fonts.options.exportSpec = f4

local function LoadDefaultSettings()
    local settings = {
        core = {
            dataRefreshRate = 5.0,
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
            }
        },        
        druid = {
            balance = {}
        },
        hunter = {
            beastMastery = {},
            marksmanship = {},
            survival = {}
        },
        priest = {
            shadow = {}
        },
        shaman = {
            elemental = {}
        },
        warrior = {
            arms = {}
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

    local xPadding = 10
    local xPadding2 = 30
    local xCoord = 5
    local xCoord2 = 290
    local xOffset1 = 50
    local xOffset2 = xCoord2 + xOffset1

    local dropdownWidth = 225
    local sliderWidth = 260
    local sliderHeight = 20
    local title = ""

    interfaceSettingsFrame.optionsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_General", UIParent)
    interfaceSettingsFrame.optionsPanel.name = "Global Options"
    interfaceSettingsFrame.optionsPanel.parent = parent.name
    InterfaceOptions_AddCategory(interfaceSettingsFrame.optionsPanel)
    
    parent = interfaceSettingsFrame.optionsPanel
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Global Options", xCoord+xPadding, yCoord)

    yCoord = yCoord - 30
    parent.panel = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Options_General_LayoutPanel", parent, 580, 523)
    parent.panel:SetPoint("TOPLEFT", 10, yCoord)
    parent.panel:Show()

    parent = parent.panel.scrollFrame.scrollChild

    yCoord = 5

    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Time To Die", 0, yCoord)

    yCoord = yCoord - 60

    title = "Sampling Rate (seconds)"
    controls.ttdSamplingRate = TRB.UiFunctions.BuildSlider(parent, title, 0.05, 2, TRB.Data.settings.core.ttd.sampleRate, 0.05, 2,
                                    sliderWidth, sliderHeight, xCoord, yCoord)
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
    controls.ttdSampleSize = TRB.UiFunctions.BuildSlider(parent, title, 1, 1000, TRB.Data.settings.core.ttd.numEntries, 1, 0,
                                    sliderWidth, sliderHeight, xCoord2, yCoord)
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
    title = "Time To Die Precision (ms)"
    controls.ttdPrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.core.ttd.precision, 1, 0,
                                    sliderWidth, sliderHeight, xCoord, yCoord)
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
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Character Data Refresh Rate", 0, yCoord)

    yCoord = yCoord - 60

    title = "Refresh Rate (seconds)"
    controls.characterRefreshRate = TRB.UiFunctions.BuildSlider(parent, title, 0.05, 60, TRB.Data.settings.core.dataRefreshRate, 0.05, 2,
                                    sliderWidth, sliderHeight, xCoord, yCoord)
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
    
    yCoord = yCoord - 40
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Frame Strata", 0, yCoord)

    yCoord = yCoord - 30
    
    -- Create the dropdown, and configure its appearance
    controls.dropDown.strata = CreateFrame("FRAME", "TIBFrameStrata", parent, "UIDropDownMenuTemplate")
    controls.dropDown.strata.label = TRB.UiFunctions.BuildSectionHeader(parent, "Frame Strata Level To Draw Bar On", xCoord, yCoord)
    controls.dropDown.strata.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.strata:SetPoint("TOPLEFT", xCoord, yCoord-30)
    UIDropDownMenu_SetWidth(controls.dropDown.strata, dropdownWidth)
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
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Channel", 0, yCoord)

    yCoord = yCoord - 30
    
    -- Create the dropdown, and configure its appearance
    controls.dropDown.audioChannel = CreateFrame("FRAME", "TIBFrameAudioChannel", parent, "UIDropDownMenuTemplate")
    controls.dropDown.audioChannel.label = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Channel To Use", xCoord, yCoord)
    controls.dropDown.audioChannel.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.audioChannel:SetPoint("TOPLEFT", xCoord, yCoord-30)
    UIDropDownMenu_SetWidth(controls.dropDown.audioChannel, dropdownWidth)
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

    TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
    TRB.Frames.interfaceSettingsFrameContainer.controls = controls
end 


local function ConstructImportExportPanel()
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
    local parent = interfaceSettingsFrame.panel
    local controls = interfaceSettingsFrame.controls.importExport or {}
    local yCoord = -5
    local f = nil

    local maxOptionsWidth = 580

    local xPadding = 10
    local xPadding2 = 30
    local xCoord = 5
    local xCoord2 = 290
    local xOffset1 = 50
    local xOffset2 = xCoord2 + xOffset1

    local title = ""
    local specName = ""
    local buttonOffest = 0

    local dropdownWidth = 225
    local sliderWidth = 260
    local sliderHeight = 20

    interfaceSettingsFrame.optionsPanel = CreateFrame("Frame", "TwintopResourceBar_Options_ImportExport", UIParent)
    interfaceSettingsFrame.optionsPanel.name = "Import/Export"
    interfaceSettingsFrame.optionsPanel.parent = parent.name
    InterfaceOptions_AddCategory(interfaceSettingsFrame.optionsPanel) 
    
    parent = interfaceSettingsFrame.optionsPanel
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Import/Export", xCoord+xPadding, yCoord)
    controls.labels = controls.labels or {}
    controls.buttons = controls.buttons or {}

    yCoord = yCoord - 30
    parent.panel = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Options_General_LayoutPanel", parent, 580, 523)
    parent.panel:SetPoint("TOPLEFT", 10, yCoord)
    parent.panel:Show()

    parent = parent.panel.scrollFrame.scrollChild

    yCoord = 5
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Import Settings Configuration", xCoord, yCoord)
    

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
    controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import existing Settings Configuration string", xCoord, yCoord, 300, 30)
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
    controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Export Settings Configuration", xCoord, yCoord)


    yCoord = yCoord - 35
    --controls.labels.druid = TRB.UiFunctions.BuildLabel(parent, "Everything", xCoord, yCoord, 100, 20)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Everything = TRB.UiFunctions.BuildButton(parent, "All Classes/Specs + Global Options", buttonOffset, yCoord, 230, 20)
    controls.buttons.exportButton_Everything:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for All Classes/Specs + Global Options.", nil, nil, true, true, true, true, true)
    end)    

    buttonOffset = buttonOffset + 230 + 5
    controls.buttons.exportButton_All_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Global Options Only", buttonOffset, yCoord, 200, 20)
    controls.buttons.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Global Options Only.", nil, -1, false, false, false, false, true)
    end)   

    yCoord = yCoord - 35
    controls.labels.druid = TRB.UiFunctions.BuildLabel(parent, "All Classes/Specs", xCoord, yCoord, 100, 20)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_All_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_All_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for All Classes/Specs (All).", 11, 1, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_All_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_All_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for All Classes/Specs (Bar Display).", 11, 1, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_All_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_All_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for All Classes/Specs (Font & Text).", 11, 1, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_All_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_All_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for All Classes/Specs (Audio & Tracking).", 11, 1, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_All_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_All_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for All Classes/Specs (Bar Text).", 11, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.druid = TRB.UiFunctions.BuildLabel(parent, "Druid", xCoord, yCoord, 100, 20)

    yCoord = yCoord - 25
    specName = "Balance"
    controls.labels.druidBalance = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.druidBalance.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Druid_Balance_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Druid_Balance_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (All).", 11, 1, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Druid_Balance_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Druid_Balance_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Bar Display).", 11, 1, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Druid_Balance_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Druid_Balance_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Font & Text).", 11, 1, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Druid_Balance_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Druid_Balance_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Audio & Tracking).", 11, 1, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Druid_Balance_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Druid_Balance_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Bar Text).", 11, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.hunter = TRB.UiFunctions.BuildLabel(parent, "Hunter", xCoord, yCoord, 100, 20)
    
    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for all Hunter specializations (All).", 3, nil, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for all Hunter specializations (Bar Display).", 3, nil, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for all Hunter specializations (Font & Text).", 3, nil, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for all Hunter specializations (Audio & Tracking).", 3, nil, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for all Hunter specializations (Bar Text).", 3, nil, false, false, false, true, false)
    end)


    yCoord = yCoord - 25
    specName = "Beast Mastery"
    controls.labels.hunterBeastMastery = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.hunterBeastMastery.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (All).", 3, 1, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Bar Display).", 3, 1, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Font & Text).", 3, 1, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Audio & Tracking).", 3, 1, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Hunter_BeastMastery_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Bar Text).", 3, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Marksmanship"
    controls.labels.hunterMarksmanship = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.hunterMarksmanship.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Hunter_Marksmanship_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_Marksmanship_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (All).", 3, 2, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Bar Display).", 3, 2, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Hunter_Marksmanship_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Font & Text).", 3, 2, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Audio & Tracking).", 3, 2, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Hunter_Marksmanship_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Bar Text).", 3, 2, false, false, false, true, false)
    end)

    yCoord = yCoord - 25
    specName = "Survival"
    controls.labels.hunterSurvival = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.hunterSurvival.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Hunter_Survival_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Hunter_Survival_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (All).", 3, 3, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Hunter_Survival_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Hunter_Survival_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Bar Display).", 3, 3, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Hunter_Survival_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Font & Text).", 3, 3, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Hunter_Survival_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Audio & Tracking).", 3, 3, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Hunter_Survival_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Bar Text).", 3, 3, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.priest = TRB.UiFunctions.BuildLabel(parent, "Priest", xCoord, yCoord, 100, 20)

    yCoord = yCoord - 25
    specName = "Shadow"
    controls.labels.priestShadow = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.priestShadow.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Priest_Shadow_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (All).", 5, 3, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Priest_Shadow_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Priest_Shadow_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Bar Display).", 5, 3, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Priest_Shadow_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Font & Text).", 5, 3, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Priest_Shadow_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Priest_Shadow_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Audio & Tracking).", 5, 3, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Priest_Shadow_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Priest_Shadow_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Bar Text).", 5, 3, false, false, false, true, false)
    end)   

    yCoord = yCoord - 35
    controls.labels.shaman = TRB.UiFunctions.BuildLabel(parent, "Shaman", xCoord, yCoord, 100, 20)

    yCoord = yCoord - 25
    specName = "Elemental"
    controls.labels.shamanElemental = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.shamanElemental.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Shaman_Elemental_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Shaman_Elemental_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (All).", 7, 1, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Shaman_Elemental_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Shaman_Elemental_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Bar Display).", 7, 1, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Shaman_Elemental_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Font & Text).", 7, 1, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Audio & Tracking).", 7, 1, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Shaman_Elemental_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Shaman_Elemental_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Elemental Shaman (Bar Text).", 7, 1, false, false, false, true, false)
    end)

    yCoord = yCoord - 35
    controls.labels.warrior = TRB.UiFunctions.BuildLabel(parent, "Warrior", xCoord, yCoord, 100, 20)

    yCoord = yCoord - 25
    specName = "Arms"
    controls.labels.warriorArms = TRB.UiFunctions.BuildLabel(parent, specName, xCoord+(xPadding*2), yCoord, 100, 20)
    controls.labels.warriorArms.font:SetFontObject(TRB.Options.fonts.options.exportSpec)

    buttonOffset = xCoord + xPadding + 100
    controls.buttons.exportButton_Warrior_Arms_All = TRB.UiFunctions.BuildButton(parent, "All", buttonOffset, yCoord, 50, 20)
    controls.buttons.exportButton_Warrior_Arms_All:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (All).", 1, 1, true, true, true, true, false)
    end)    

    buttonOffset = buttonOffset + 50 + 5
    controls.buttons.exportButton_Warrior_Arms_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Bar Display", buttonOffset, yCoord, 80, 20)
    controls.buttons.exportButton_Warrior_Arms_BarDisplay:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Bar Display).", 1, 1, true, false, false, false, false)
    end)   

    buttonOffset = buttonOffset + 80 + 5
    controls.buttons.exportButton_Warrior_Arms_FontAndText = TRB.UiFunctions.BuildButton(parent, "Font & Text", buttonOffset, yCoord, 90, 20)
    controls.buttons.exportButton_Warrior_Arms_FontAndText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Font & Text).", 1, 1, false, true, false, false, false)
    end)   

    buttonOffset = buttonOffset + 90 + 5
    controls.buttons.exportButton_Warrior_Arms_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Audio & Tracking", buttonOffset, yCoord, 120, 20)
    controls.buttons.exportButton_Warrior_Arms_AudioAndTracking:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Audio & Tracking).", 1, 1, false, false, true, false, false)
    end)   

    buttonOffset = buttonOffset + 120 + 5
    controls.buttons.exportButton_Warrior_Arms_BarText = TRB.UiFunctions.BuildButton(parent, "Bar Text", buttonOffset, yCoord, 70, 20)
    controls.buttons.exportButton_Warrior_Arms_BarText:SetScript("OnClick", function(self, ...)
        TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Arms Warrior (Bar Text).", 1, 1, false, false, false, true, false)
    end)


    TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
    TRB.Frames.interfaceSettingsFrameContainer.controls.importExport = controls
end 

local function ConstructOptionsPanel()
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
    local xPadding = 10
    local xPadding2 = 30
    local xMax = 550
    local xCoord = 0
    local xCoord2 = 325
    local yCoord = -5
    local xOffset1 = 50
    local xOffset2 = 275

    interfaceSettingsFrame.controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, TRB.Details.addonTitle, xCoord+xPadding, yCoord)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoAuthor = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Author:", TRB.Details.addonAuthor .. " - " .. TRB.Details.addonAuthorServer, xCoord+xPadding*2, yCoord, 100, 450)
    yCoord = yCoord - 20
    interfaceSettingsFrame.controls.labels.infoVersion = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Version:", TRB.Details.addonVersion, xCoord+xPadding*2, yCoord, 100, 450)
    yCoord = yCoord - 20
    interfaceSettingsFrame.controls.labels.infoReleased = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Released:", TRB.Details.addonReleaseDate, xCoord+xPadding*2, yCoord, 100, 450)
    yCoord = yCoord - 20
    interfaceSettingsFrame.controls.labels.infoSupport = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Supported Specs:", TRB.Details.supportedSpecs, xCoord+xPadding*2, yCoord, 100, 450, 300)
    

    interfaceSettingsFrame.panel.yCoord = yCoord
    InterfaceOptions_AddCategory(interfaceSettingsFrame.panel)

    ConstructAddonOptionsPanel()
    ConstructImportExportPanel()
end
TRB.Options.ConstructOptionsPanel = ConstructOptionsPanel

local function PortForwardPriestSettings()
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
end
TRB.Options.PortForwardPriestSettings = PortForwardPriestSettings

local function CleanupSettings(oldSettings)
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
TRB.Options.CleanupSettings = CleanupSettings