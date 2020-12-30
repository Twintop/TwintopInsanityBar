local _, TRB = ...

TRB.Options = {}

local f1 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Highlight_Small_Color")
f1:SetFontObject(GameFontHighlightSmall)
local f2 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Green_Small_Color")
f2:SetFontObject(GameFontGreenSmall)
local f3 = CreateFont("TwintopResourceBar_OptionsMenu_Tab_Normal_Small_Color")
f3:SetFontObject(GameFontNormalSmall)

TRB.Options.fonts = {}
TRB.Options.fonts.options = {}
TRB.Options.fonts.options.tabHighlightSmall = f1
TRB.Options.fonts.options.tabGreenSmall = f2
TRB.Options.fonts.options.tabNormalSmall = f3

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
            balance = {},
            feral = {},
            guardian = {},
            restoration = {}
        },
        hunter = {
            beastMastery = {},
            marksmanship = {},
            survival = {}
        },
        priest = {
            discipline = {},
            holy = {},
            shadow = {}
        },
        shaman = {
            elemental = {},
            enhancement = {},
            restoration = {}
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
    controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "General Options", xCoord+xPadding, yCoord)

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

    -- Implement the function to change the texture
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

    -- Implement the function to change the texture
    function controls.dropDown.audioChannel:SetValue(newValue, newName)
        TRB.Data.settings.core.audio.channel.channel = newValue
        TRB.Data.settings.core.audio.channel.name = newName
        UIDropDownMenu_SetText(controls.dropDown.audioChannel, newName)
        CloseDropDownMenus()
    end
    
    --interfaceSettingsFrame.panel = parent
    --interfaceSettingsFrame.controls = controls
    --TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
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

    interfaceSettingsFrame.controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Twintop's Resource Bar", xCoord+xPadding, yCoord)
    yCoord = yCoord - 40
    interfaceSettingsFrame.controls.labels.infoAuthor = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Author:", "Twintop - Frostmourne-US/OCE", xCoord+xPadding*2, yCoord, 100, 200)
    yCoord = yCoord - 20
    interfaceSettingsFrame.controls.labels.infoVersion = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Version:", TRB.Details.addonVersion, xCoord+xPadding*2, yCoord, 100, 200)
    yCoord = yCoord - 20
    interfaceSettingsFrame.controls.labels.infoReleased = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Released:", TRB.Details.addonReleaseDate, xCoord+xPadding*2, yCoord, 100, 200)
    yCoord = yCoord - 20
    interfaceSettingsFrame.controls.labels.infoReleased = TRB.UiFunctions.BuildDisplayTextHelpEntry(parent, "Supported Specs:", TRB.Details.supportedSpecs, xCoord+xPadding*2, yCoord, 100, 200)
    

    interfaceSettingsFrame.panel.yCoord = yCoord
    InterfaceOptions_AddCategory(interfaceSettingsFrame.panel)

    ConstructAddonOptionsPanel()
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