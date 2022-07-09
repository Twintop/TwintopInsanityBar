---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.UiFunctions = {}

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18
function TRB.UiFunctions:BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minValue, maxValue)
	f:SetValueStep(stepValue)
	f:SetSize(sizeX-36, sizeY)
    f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
    f:SetOrientation("Horizontal")
    f:SetBackdrop({
       bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
       edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
       tile = true,
       edgeSize = 8,
       tileSize = 8,
       insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
    f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
    f:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 1, 1, 1)
    end)
	f:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
    end)
    f:SetScript("OnValueChanged", function(self, value)
		self.EditBox:SetText(value)
	end)
    f.MinLabel = f:CreateFontString(nil, "Overlay")
    f.MinLabel:SetFontObject(GameFontHighlightSmall)
    f.MinLabel:SetSize(0, 14)
    ---@diagnostic disable-next-line: redundant-parameter
    f.MinLabel:SetWordWrap(false)
    f.MinLabel:SetPoint("TopLeft", f, "BottomLeft", 0, -1)
    f.MinLabel:SetText(minValue)
    f.MaxLabel = f:CreateFontString(nil, "Overlay")
    f.MaxLabel:SetFontObject(GameFontHighlightSmall)
    f.MaxLabel:SetSize(0, 14)
    ---@diagnostic disable-next-line: redundant-parameter
    f.MaxLabel:SetWordWrap(false)
    f.MaxLabel:SetPoint("TopRight", f, "BottomRight", 0, -1)
    f.MaxLabel:SetText(maxValue)
    f.Title = f:CreateFontString(nil, "Overlay")
    f.Title:SetFontObject(GameFontNormal)
    f.Title:SetSize(0, 14)
    ---@diagnostic disable-next-line: redundant-parameter
    f.Title:SetWordWrap(false)
    f.Title:SetPoint("Bottom", f, "Top")
    f.Title:SetText(title)
    f.Thumb = f:CreateTexture(nil, "Artwork")
    f.Thumb:SetSize(32, 32)
    f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
    eb:EnableMouseWheel(true)
    eb:SetAutoFocus(false)
    eb:SetNumeric(false)
    eb:SetJustifyH("Center")
    eb:SetFontObject(GameFontHighlightSmall)
    eb:SetSize(50, 14)
    eb:SetPoint("Top", f, "Bottom", 0, -1)
    eb:SetTextInsets(4, 4, 0, 0)
    eb:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        edgeSize = 1,
        tileSize = 5
	})
    eb:SetBackdropColor(0, 0, 0, 1)
    eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    eb:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
    end)
    eb:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    end)
    eb:SetScript("OnMouseWheel", function(self, delta)
        if delta > 0 then
            f:SetValue(f:GetValue() + f:GetValueStep())
        else
            f:SetValue(f:GetValue() - f:GetValueStep())
        end
    end)
    eb:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    eb:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            local min, max = f:GetMinMaxValues()
            if value >= min and value <= max then
                f:SetValue(value)
            elseif value < min then
                f:SetValue(min)
            elseif value > max then
                f:SetValue(max)
            end
			value = TRB.Functions.RoundTo(value, numDecimalPlaces)
            eb:SetText(value)
        else
            f:SetValue(f:GetValue())
        end
        self:ClearFocus()
    end)
    eb:SetScript("OnEditFocusLost", function(self)
        self:HighlightText(0, 0)
    end)
    eb:SetScript("OnEditFocusGained", function(self)
        self:HighlightText(0, -1)
    end)
    f.Plus = CreateFrame("Button", nil, f)
    f.Plus:SetSize(18, 18)
    f.Plus:RegisterForClicks("AnyUp")
    f.Plus:SetPoint("Left", f, "Right", 0, 0)
    f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
    f.Plus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() + f:GetValueStep())
    end)
    f.Minus = CreateFrame("Button", nil, f)
    f.Minus:SetSize(18, 18)
    f.Minus:RegisterForClicks("AnyUp")
    f.Minus:SetPoint("Right", f, "Left", 0, 0)
    f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
    f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
    f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
    f.Minus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() - f:GetValueStep())
	end)

	f:SetValue(defaultValue)
    eb:SetText(defaultValue)
	eb:SetCursorPosition(0)

	return f
end

function TRB.UiFunctions:BuildTextBox(parent, text, maxLetters, width, height, xPos, yPos)
	local f = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	f:SetPoint("TOPLEFT", xPos, yPos)
	f:SetAutoFocus(false)
	f:SetMaxLetters(maxLetters)
    f:SetJustifyH("Left")
    f:SetFontObject(GameFontHighlight)
    f:SetSize(width, height)
    f:SetTextInsets(4, 4, 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        edgeSize = 1,
        tileSize = 5
	})
    f:SetBackdropColor(0, 0, 0, 1)
    f:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    f:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
    end)
    f:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    end)
    f:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    f:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
    end)
	f:SetText(text)
	f:SetCursorPosition(0)

	return f
end

function TRB.UiFunctions:EditBoxSetTextMinMax(box, value)
    local min, max = box:GetMinMaxValues()
    if value > max then
        value = max
    elseif value < min then
        value = min
    end
    box.EditBox:SetText(value)
    return value
end

function TRB.UiFunctions:ShowColorPicker(r, g, b, a, callback)
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		callback, callback, callback
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
	ColorPickerFrame.previousValues = {r, g, b, a}
	ColorPickerFrame:Hide() -- Need to run the OnShow handler.
	ColorPickerFrame:Show()
end

function TRB.UiFunctions:ExtractColorFromColorPicker(color)
    local r, g, b, a
    if color then
---@diagnostic disable-next-line: deprecated
        r, g, b, a = unpack(color)
    else
        r, g, b = ColorPickerFrame:GetColorRGB()
        a = OpacitySliderFrame:GetValue()
    end
    return r, g, b, a
end

function TRB.UiFunctions:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frames, specId)
    if button == "LeftButton" then
        local r, g, b, a = TRB.Functions.GetRGBAFromString(colorTable[key], true)
        TRB.UiFunctions:ShowColorPicker(r, g, b, 1-a, function(color)
            local r, g, b, a = TRB.UiFunctions:ExtractColorFromColorPicker(color)
            colorControlsTable[key].Texture:SetColorTexture(r, g, b, 1-a)
            colorTable[key] = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
        
            if frameType == "backdrop" then
                TRB.Functions.SetBackdropColor(frames, colorTable[key], true, specId)
            elseif frameType == "border" then
                TRB.Functions.SetBackdropBorderColor(frames, colorTable[key], true, specId)
            elseif frameType == "bar" then
                TRB.Functions.SetStatusBarColor(frames, colorTable[key], true, specId)
            elseif frameType == "threshold" then
                TRB.Functions.SetThresholdColor(frames, colorTable[key], true, specId)
            end
        end)
    end
end

function TRB.UiFunctions:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
    local settings = TRB.Data.settings
	local f = CreateFrame("Button", nil, parent, "BackdropTemplate")
	f:SetSize(sizeFrame, sizeFrame)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
		tile = true, 
		tileSize=4, 
		edgeSize=12
	})
	f.Texture = f:CreateTexture(nil, settings.core.strata.level)
	f.Texture:ClearAllPoints()
	f.Texture:SetPoint("TOPLEFT", 4, -4)
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4)
	f.Texture:SetColorTexture(TRB.Functions.GetRGBAFromString(settingsEntry, true))
    f:EnableMouse(true)
	f.Font = f:CreateFontString(nil, settings.core.strata.level)
	f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0)
	f.Font:SetFontObject(GameFontHighlight)
	f.Font:SetText(description)
    ---@diagnostic disable-next-line: redundant-parameter
	f.Font:SetWordWrap(true)
	f.Font:SetJustifyH("LEFT")
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame)
	return f
end

function TRB.UiFunctions:BuildSectionHeader(parent, title, posX, posY)
    local settings = TRB.Data.settings
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(500)
	f:SetHeight(30)
	f.font = f:CreateFontString(nil, settings.core.strata.level)
	f.font:SetFontObject(GameFontNormalLarge)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(500, 30)
	f.font:SetText(title)
	return f
end

function TRB.UiFunctions:BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset, width, height, height2)
	height = height or 20
    height2 = height2 or (height * 3)
    local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	f.font = f:CreateFontString(nil, TRB.Data.settings.core.strata.level)
	f.font:SetFontObject(GameFontNormalSmall)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("RIGHT")
    f.font:SetJustifyV("TOP")
	f.font:SetSize(offset, height)
	f.font:SetText(var)

	f.description = CreateFrame("Frame", nil, parent)
	local fd = f.description
	fd:ClearAllPoints()
	fd:SetPoint("TOPLEFT", parent)
	fd:SetPoint("TOPLEFT", posX+5, posY-height)
	fd:SetWidth(width-5)
	fd:SetHeight(height2)
	fd.font = fd:CreateFontString(nil, TRB.Data.settings.core.strata.level)
	fd.font:SetFontObject(GameFontHighlightSmall)
	fd.font:SetPoint("LEFT", fd, "LEFT")
    fd.font:SetSize(0, 14)
	fd.font:SetJustifyH("LEFT")
    fd.font:SetJustifyV("TOP")
	fd.font:SetSize(width, height2)
	fd.font:SetText(desc)
---@diagnostic disable-next-line: redundant-parameter
    fd.font:SetWordWrap(true)

	return f
end

function TRB.UiFunctions:BuildButton(parent, text, posX, posY, width, height)
    local f = CreateFrame("Button", nil, parent)
    f:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetText(text)
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

    return f
end

function TRB.UiFunctions:BuildLabel(parent, text, posX, posY, width, height, fontObject, hAlign)
    if fontObject == nil then
        fontObject = GameFontNormal
    end

    if hAlign == nil or (string.upper(hAlign) ~= "LEFT" and string.upper(hAlign) ~= "CENTER" and string.upper(hAlign) ~= "RIGHT") then
        hAlign = "LEFT"
    end

    local f = CreateFrame("Frame", nil, parent)
    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", parent)
    f:SetPoint("TOPLEFT", posX, posY)
    f:SetWidth(width)
    f:SetHeight(height)
    f.font = f:CreateFontString(nil, "BACKGROUND")
    f.font:SetFontObject(fontObject)
    f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetJustifyH(hAlign)
    f.font:SetSize(width, height)
    f.font:SetText(text)

    return f
end

function TRB.UiFunctions:CreateScrollFrameContainer(name, parent, width, height, scrollChild)
    width = width or 560
    height = height or 540
	local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
	sf:SetWidth(width)
	sf:SetHeight(height)
    if scrollChild then
        sf.scrollChild = scrollChild
    else
	    sf.scrollChild = CreateFrame("Frame")
    end
	sf.scrollChild:SetWidth(width)
	sf.scrollChild:SetHeight(height-10)
	sf:SetScrollChild(sf.scrollChild)
	return sf
end

function TRB.UiFunctions:CreateTabFrameContainer(name, parent, width, height, isManualScrollFrame)
    width = width or 580
    height = height or 503
    local cf = CreateFrame("Frame", name, parent, "BackdropTemplate")
    cf:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile =  "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        edgeSize = 8,
        tileSize = 32,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
        }
    })
    cf:SetBackdropColor(0, 0, 0, 0.5)
    cf:SetWidth(width)
    cf:SetHeight(height)
    cf:SetPoint("TOPLEFT", 0, 10)

    if not isManualScrollFrame then
        cf.scrollFrame = TRB.UiFunctions:CreateScrollFrameContainer(name .. "ScrollFrame", cf, width - 30, height - 8)
        cf.scrollFrame:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -5)
    end
    return cf
end

function TRB.UiFunctions:SwitchTab(self, tabId)
    local parent = self:GetParent()
    if parent.lastTab then
        parent.lastTab:Hide()
        parent.tabs[parent.lastTabId]:SetNormalFontObject(TRB.Options.fonts.options.tabNormalSmall)
	end
	parent.tabsheets[tabId]:Show()
    parent.tabs[tabId]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
    parent.lastTab = parent.tabsheets[tabId]
    parent.lastTabId = tabId
end

function TRB.UiFunctions:CreateTab(name, displayText, id, parent, width, rightOf)
    width = width or 100
    local tab = CreateFrame("Button", name, parent, "TabButtonTemplate")
    tab.id = id
    tab:SetSize(width, 16)
    tab:SetText(displayText)
    tab:SetScript("OnClick", function(self)
        TRB.UiFunctions:SwitchTab(self, self.id)
    end)

    if rightOf ~= nil then
        tab:SetPoint("LEFT", rightOf, "RIGHT")
    else
        tab:SetPoint("LEFT", parent, "LEFT", 0, 0)
    end

    tab:SetNormalFontObject(TRB.Options.fonts.options.tabNormalSmall)
    return tab
end

function TRB.UiFunctions:CreateVariablesSidePanel(parent, name)
    local grandparent = parent:GetParent()
    local variablesPanelParent = TRB.UiFunctions:CreateTabFrameContainer("TRB_" .. name .. "_BarTextVariables_Frame", grandparent, 300, 500)
    local variablesPanel = variablesPanelParent.scrollFrame.scrollChild
    variablesPanelParent:SetBackdropColor(0, 0, 0, 0.8)
    variablesPanelParent:ClearAllPoints()
    variablesPanelParent:SetPoint("TOPLEFT", grandparent, "TOPRIGHT", 55, 5)
    TRB.UiFunctions:BuildSectionHeader(variablesPanel, "Bar Text Variables", 0, 5)
    return variablesPanel
end

function TRB.UiFunctions:CreateBarTextInputPanel(parent, name, text, width, height, xPos, yPos)
    local s = CreateFrame("ScrollFrame", "TRB_" .. name .. "_BarTextBox", parent, "UIPanelScrollFrameTemplate, BackdropTemplate") -- or your actual parent instead
    s:SetSize(width, height)
    s:SetPoint("TOPLEFT", parent, "TOPLEFT", xPos, yPos)
    
    s.ScrollFrame = CreateFrame("EditBox", nil, s, "BackdropTemplate")
    local e = s.ScrollFrame
    e:SetTextInsets(4, 4, 0, 0)
    s:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        edgeSize = 1,
        tileSize = 5
	})
    s:SetBackdropColor(0, 0, 0, 1)
    s:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    e:SetScript("OnEnter", function(self)
        self:GetParent():SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
    end)
    e:SetScript("OnLeave", function(self)
        self:GetParent():SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    end)
    e:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
	e:SetCursorPosition(0)
    e:SetScript("OnCursorChanged", function(self, arg1, arg2, arg3, arg4)
        local vs = self:GetParent():GetVerticalScroll();
        local h  = self:GetParent():GetHeight();
    
        if vs+arg2 > 0 or 0 > vs+arg2-arg4+h then
            self:GetParent():SetVerticalScroll(arg2*-1);
        end
    end)

    e:SetMultiLine(true)
    e:SetFontObject(ChatFontNormal)
    e:SetWidth(width)
    e:SetText(text)
    e:SetAutoFocus(false)


    s:SetScrollChild(e)
    return e
end

function TRB.UiFunctions:ToggleCheckboxEnabled(checkbox, enable)
    if enable then
---@diagnostic disable-next-line: undefined-field
        checkbox:Enable()
        getglobal(checkbox:GetName().."Text"):SetTextColor(1, 1, 1)
    else
---@diagnostic disable-next-line: undefined-field
        checkbox:Disable()
        getglobal(checkbox:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
    end
end

function TRB.UiFunctions:ToggleCheckboxOnOff(checkbox, enable, changeText)
    if enable then
        getglobal(checkbox:GetName().."Text"):SetTextColor(0, 1, 0)

        if changeText == true then
            getglobal(checkbox:GetName().."Text"):SetText("Enabled")
        end
    else
        getglobal(checkbox:GetName().."Text"):SetTextColor(1, 0, 0)
        
        if changeText == true then
            getglobal(checkbox:GetName().."Text"):SetText("Disabled")
        end
    end
end

function TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)
    local oUi = TRB.Data.constants.optionsUi

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

    local f = nil
    
    local title = ""

    local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

    local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

    local _, className, _ = GetClassInfo(classId)

    controls.barPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

    yCoord = yCoord - 40
    title = "Bar Width"
    controls.width = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.width:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.bar.width = value

        if GetSpecialization() == specId then
            TRB.Functions.UpdateBarWidth(spec)
        end

        local maxBorderSize = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
        controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.borderWidth.MaxLabel:SetText(maxBorderSize)
    end)

    title = "Bar Height"
    controls.height = TRB.UiFunctions:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.height:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.bar.height = value

        local maxBorderSize = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
        local borderSize = spec.bar.border
    
        if maxBorderSize < borderSize then
            maxBorderSize = borderSize
        end

        controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.borderWidth.MaxLabel:SetText(maxBorderSize)
        controls.borderWidth.EditBox:SetText(borderSize)

        if GetSpecialization() == specId then
            TRB.Functions.UpdateBarHeight(spec)
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Horizontal Position"
    yCoord = yCoord - 60
    controls.horizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.bar.xPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.horizontal:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.bar.xPos = value

        if GetSpecialization() == specId then
            barContainerFrame:ClearAllPoints()
            barContainerFrame:SetPoint("CENTER", UIParent)
            barContainerFrame:SetPoint("CENTER", spec.bar.xPos, spec.bar.yPos)
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Vertical Position"
    controls.vertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.bar.yPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.vertical:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.bar.yPos = value

        if GetSpecialization() == specId then
            barContainerFrame:ClearAllPoints()
            barContainerFrame:SetPoint("CENTER", UIParent)
            barContainerFrame:SetPoint("CENTER", spec.bar.xPos, spec.bar.yPos)
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Border Width"
    yCoord = yCoord - 60
    controls.borderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.borderWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.bar.border = value

        if GetSpecialization() == specId then
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
            TRB.Functions.UpdateBarHeight(spec)
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
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
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.thresholds.width = value

        if GetSpecialization() == specId then
            TRB.Functions.RedrawThresholdLines(spec)
        end
    end)

    yCoord = yCoord - 40

    --NOTE: the order of these checkboxes is reversed!

    controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.lockPosition
    f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
    f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
    f:SetChecked(spec.bar.dragAndDrop)
    f:SetScript("OnClick", function(self, ...)
        spec.bar.dragAndDrop = self:GetChecked()
        barContainerFrame:SetMovable((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
        barContainerFrame:EnableMouse((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
    end)

    TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

    controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.pinToPRD
    f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
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

    return yCoord
end

function TRB.UiFunctions:GenerateComboPointDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, secondaryResourceString)
    if primaryResourceString == nil then
        primaryResourceString = "Energy"
    end
    
    if secondaryResourceString == nil then
        secondaryResourceString = "Combo Point"
    end

    local oUi = TRB.Data.constants.optionsUi
    local f = nil
    
    local title = ""

    local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

    local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

    local _, className, _ = GetClassInfo(classId)

    controls.comboPointPositionSection = TRB.UiFunctions:BuildSectionHeader(parent, secondaryResourceString .. " Position and Size", 0, yCoord)

    yCoord = yCoord - 40
    title = secondaryResourceString .. " Width"
    controls.comboPointWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, TRB.Functions.RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.width, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.comboPointWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.width = value

        local maxBorderSize = math.min(math.floor(spec.comboPoints.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.comboPoints.width / TRB.Data.constants.borderWidthFactor))
        local borderSize = spec.comboPoints.border
    
        if maxBorderSize < borderSize then
            maxBorderSize = borderSize
        end

        controls.comboPointBorderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.comboPointBorderWidth.MaxLabel:SetText(maxBorderSize)
        controls.comboPointBorderWidth.EditBox:SetText(borderSize)

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = secondaryResourceString .. " Height"
    controls.comboPointHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, sanityCheckValues.barMaxHeight, spec.comboPoints.height, 1, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.comboPointHeight:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.height = value

        local maxBorderSize = math.min(math.floor(spec.comboPoints.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
        local borderSize = spec.comboPoints.border
    
        if maxBorderSize < borderSize then
            maxBorderSize = borderSize
        end

        controls.comboPointBorderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.comboPointBorderWidth.MaxLabel:SetText(maxBorderSize)
        controls.comboPointBorderWidth.EditBox:SetText(borderSize)

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)



    title = secondaryResourceString .. " Horizontal Position (Relative)"
    yCoord = yCoord - 60
    controls.comboPointHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.comboPoints.xPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.comboPointHorizontal:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.xPos = value

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = secondaryResourceString .. " Vertical Position (Relative)"
    controls.comboPointVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.comboPoints.yPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.comboPointVertical:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.yPos = value

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = secondaryResourceString .. " Border Width"
    yCoord = yCoord - 60
    controls.comboPointBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxBorderHeight, spec.comboPoints.border, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.comboPointBorderWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.border = value

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)

            --TRB.Functions.SetBarMinMaxValues(spec)
        end

        local minsliderWidth = math.max(spec.comboPoints.border*2, 1)
        local minsliderHeight = math.max(spec.comboPoints.border*2, 1)

        local scValues = TRB.Functions.GetSanityCheckValues(spec)
        controls.comboPointHeight:SetMinMaxValues(minsliderHeight, scValues.comboPointsMaxHeight)
        controls.comboPointHeight.MinLabel:SetText(minsliderHeight)
        controls.comboPointWidth:SetMinMaxValues(minsliderWidth, scValues.comboPointsMaxWidth)
        controls.comboPointWidth.MinLabel:SetText(minsliderWidth)
    end)

    title = secondaryResourceString .. " Spacing"
    controls.comboPointSpacing = TRB.UiFunctions:BuildSlider(parent, title, 0, TRB.Functions.RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.spacing, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
        value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.spacing = value

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    yCoord = yCoord - 40
    -- Create the dropdown, and configure its appearance
    controls.dropDown.comboPointsRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_"..className.."_"..specId.."_comboPointsRelativeTo", parent, "UIDropDownMenuTemplate")
    controls.dropDown.comboPointsRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of "..secondaryResourceString.." to "..primaryResourceString.." Bar", oUi.xCoord, yCoord)
    controls.dropDown.comboPointsRelativeTo.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.comboPointsRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    UIDropDownMenu_SetWidth(controls.dropDown.comboPointsRelativeTo, oUi.dropdownWidth)
    UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, spec.comboPoints.relativeToName)
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
            info.checked = relativeTo[v] == spec.comboPoints.relativeTo
            info.func = self.SetValue
            info.arg1 = relativeTo[v]
            info.arg2 = v
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    function controls.dropDown.comboPointsRelativeTo:SetValue(newValue, newName)
        spec.comboPoints.relativeTo = newValue
        spec.comboPoints.relativeToName = newName
        UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, newName)
        CloseDropDownMenus()

        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end

    controls.checkBoxes.comboPointsFullWidth = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_comboPointsFullWidth", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.comboPointsFullWidth
    f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord-30)
    getglobal(f:GetName() .. 'Text'):SetText(secondaryResourceString .. " are full bar width?")
    f.tooltip = "Makes the "..secondaryResourceString.." bars take up the same total width of the bar, spaced according to "..secondaryResourceString.." Spacing (above). The horizontal position adjustment will be ignored and the width of "..secondaryResourceString.." bars will be automatically calculated and will ignore the value set above."
    f:SetChecked(spec.comboPoints.fullWidth)
    f:SetScript("OnClick", function(self, ...)
        spec.comboPoints.fullWidth = self:GetChecked()
        
        if GetSpecialization() == specId then
            TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
        end
    end)

    return yCoord
end