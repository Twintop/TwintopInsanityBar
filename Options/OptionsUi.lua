---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = {}
local oUi = TRB.Data.constants.optionsUi
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18
function TRB.Functions.OptionsUi:BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
    ---@diagnostic disable-next-line: param-type-mismatch
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
    f.MinLabel = f:CreateFontString(nil, "OVERLAY")
    f.MinLabel:SetFontObject(GameFontHighlightSmall)
    f.MinLabel:SetSize(0, 14)
    ---@diagnostic disable-next-line: redundant-parameter
    f.MinLabel:SetWordWrap(false)
---@diagnostic disable-next-line: param-type-mismatch
    f.MinLabel:SetPoint("TopLeft", f, "BottomLeft", 0, -1)
    f.MinLabel:SetText(minValue)
    f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
    f.MaxLabel:SetFontObject(GameFontHighlightSmall)
    f.MaxLabel:SetSize(0, 14)
    ---@diagnostic disable-next-line: redundant-parameter
    f.MaxLabel:SetWordWrap(false)
---@diagnostic disable-next-line: param-type-mismatch
    f.MaxLabel:SetPoint("TopRight", f, "BottomRight", 0, -1)
    f.MaxLabel:SetText(maxValue)
    f.Title = f:CreateFontString(nil, "OVERLAY")
    f.Title:SetFontObject(GameFontNormal)
    f.Title:SetSize(0, 14)
    ---@diagnostic disable-next-line: redundant-parameter
    f.Title:SetWordWrap(false)
---@diagnostic disable-next-line: param-type-mismatch
    f.Title:SetPoint("Bottom", f, "Top")
    f.Title:SetText(title)
    f.Thumb = f:CreateTexture(nil, "ARTWORK")
    f.Thumb:SetSize(32, 32)
    f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
    eb:EnableMouseWheel(true)
    eb:SetAutoFocus(false)
    eb:SetNumeric(false)
    eb:SetJustifyH("CENTER")
    eb:SetFontObject(GameFontHighlightSmall)
    eb:SetSize(50, 14)
---@diagnostic disable-next-line: param-type-mismatch
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
			value = TRB.Functions.Number:RoundTo(value, numDecimalPlaces)
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
---@diagnostic disable-next-line: param-type-mismatch
    f.Plus = CreateFrame("Button", nil, f)
    f.Plus:SetSize(18, 18)
    f.Plus:RegisterForClicks("AnyUp")
---@diagnostic disable-next-line: param-type-mismatch
    f.Plus:SetPoint("Left", f, "Right", 0, 0)
    f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
    f.Plus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() + f:GetValueStep())
    end)
---@diagnostic disable-next-line: param-type-mismatch
    f.Minus = CreateFrame("Button", nil, f)
    f.Minus:SetSize(18, 18)
    f.Minus:RegisterForClicks("AnyUp")
---@diagnostic disable-next-line: param-type-mismatch
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

function TRB.Functions.OptionsUi:BuildTextBox(parent, text, maxLetters, width, height, xPos, yPos)
	local f = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	f:SetPoint("TOPLEFT", xPos, yPos)
	f:SetAutoFocus(false)
	f:SetMaxLetters(maxLetters)
    f:SetJustifyH("LEFT")
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

function TRB.Functions.OptionsUi:EditBoxSetTextMinMax(box, value)
    local min, max = box:GetMinMaxValues()
    if value > max then
        value = max
    elseif value < min then
        value = min
    end
    box.EditBox:SetText(value)
    return value
end

function TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, a, callback)
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		callback, callback, callback
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
	ColorPickerFrame.previousValues = {r, g, b, a}
	ColorPickerFrame:Hide() -- Need to run the OnShow handler.
	ColorPickerFrame:Show()
end

function TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
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

function TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frames, specId)
    if button == "LeftButton" then
        local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorTable[key], true)
        TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
            local r, g, b, a = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
            colorControlsTable[key].Texture:SetColorTexture(r, g, b, 1-a)
            colorTable[key] = TRB.Functions.Color:ConvertColorDecimalToHex(r, g, b, 1-a)
        
            if frameType == "backdrop" then
                TRB.Functions.Color:SetBackdropColor(frames, colorTable[key], true, specId)
            elseif frameType == "border" then
                TRB.Functions.Color:SetBackdropBorderColor(frames, colorTable[key], true, specId)
            elseif frameType == "bar" then
                TRB.Functions.Color:SetStatusBarColor(frames, colorTable[key], true, specId)
            elseif frameType == "threshold" then
                TRB.Functions.Color:SetThresholdColor(frames, colorTable[key], true, specId)
            end
        end)
    end
end

function TRB.Functions.OptionsUi:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
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
	f.Texture = f:CreateTexture(nil)
	f.Texture:ClearAllPoints()
	f.Texture:SetPoint("TOPLEFT", 4, -4)
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4)
	f.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settingsEntry, true))
    f:EnableMouse(true)
	f.Font = f:CreateFontString(nil)
---@diagnostic disable-next-line: param-type-mismatch
    f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0)
	f.Font:SetFontObject(GameFontHighlight)
	f.Font:SetText(description)
    ---@diagnostic disable-next-line: redundant-parameter
	f.Font:SetWordWrap(true)
	f.Font:SetJustifyH("LEFT")
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame)
	return f
end

function TRB.Functions.OptionsUi:BuildSectionHeader(parent, title, posX, posY)
    local settings = TRB.Data.settings
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(500)
	f:SetHeight(30)
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormalLarge)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(500, 30)
	f.font:SetText(title)
	return f
end

function TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset, width, height, height2)
	height = height or 20
    height2 = height2 or (height * 3)
    local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	f.font = f:CreateFontString(nil)
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
	fd.font = fd:CreateFontString(nil)
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

function TRB.Functions.OptionsUi:BuildButton(parent, text, posX, posY, width, height)
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

function TRB.Functions.OptionsUi:BuildLabel(parent, text, posX, posY, width, height, fontObject, hAlign)
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

function TRB.Functions.OptionsUi:CreateScrollFrameContainer(name, parent, width, height, scrollChild)
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

function TRB.Functions.OptionsUi:CreateTabFrameContainer(name, parent, width, height, isManualScrollFrame)
    width = width or 652
    height = height or 523
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
    cf:SetPoint("TOPLEFT", 0, 0)

    if not isManualScrollFrame then
        cf.scrollFrame = TRB.Functions.OptionsUi:CreateScrollFrameContainer(name .. "ScrollFrame", cf, width - 30, height - 8)
---@diagnostic disable-next-line: param-type-mismatch
        cf.scrollFrame:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -5)
    end
    return cf
end

function TRB.Functions.OptionsUi:SwitchTab(self, tabId)
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

function TRB.Functions.OptionsUi:CreateTab(name, displayText, id, parent, width, rightOf)
    width = width or 100
    local tab = CreateFrame("Button", name, parent, "PanelTopTabButtonTemplate")-- "TabButtonTemplate")
    tab.id = id
    tab:SetSize(width, 16)
    tab:SetText(displayText)
    tab:SetScript("OnClick", function(self)
        TRB.Functions.OptionsUi:SwitchTab(self, self.id)
    end)

    if rightOf ~= nil then
        tab:SetPoint("LEFT", rightOf, "RIGHT")
    else
        tab:SetPoint("LEFT", parent, "LEFT", 0, 0)
    end

    tab:SetNormalFontObject(TRB.Options.fonts.options.tabNormalSmall)
    return tab
end

function TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, name)
    local grandparent = parent:GetParent()
    local variablesPanelParent = TRB.Functions.OptionsUi:CreateTabFrameContainer("TRB_" .. name .. "_BarTextVariables_Frame", grandparent, 300, 500)
    local variablesPanel = variablesPanelParent.scrollFrame.scrollChild
    variablesPanelParent:SetBackdropColor(0, 0, 0, 0.8)
    variablesPanelParent:ClearAllPoints()
    variablesPanelParent:SetPoint("TOPLEFT", grandparent, "TOPRIGHT", 55, 5)
    TRB.Functions.OptionsUi:BuildSectionHeader(variablesPanel, "Bar Text Variables", oUi.xCoord, 5)
    return variablesPanel
end

function TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, name, text, width, height, xPos, yPos)
    local s = CreateFrame("ScrollFrame", "TRB_" .. name .. "_BarTextBox", parent, "UIPanelScrollFrameTemplate, BackdropTemplate") -- or your actual parent instead
    s:SetSize(width, height)
    s:SetPoint("TOPLEFT", parent, "TOPLEFT", xPos, yPos)
    
---@diagnostic disable-next-line: param-type-mismatch
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

---@diagnostic disable-next-line: param-type-mismatch
    s:SetScrollChild(e)
    return e
end

function TRB.Functions.OptionsUi:CreateLsmDropdown(parent, dropDowns, section, classId, specId, xCoord, yCoord, lsmType, varName, sectionHeaderText, dropdownInfoText)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    
    -- Create the dropdown, and configure its appearance
    dropDowns[varName] = LibDD:Create_UIDropDownMenu("TwintopResourceBar_"..className.."_"..specId.."_"..varName.."_"..lsmType, parent)
    dropDowns[varName].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, sectionHeaderText, xCoord, yCoord)
    dropDowns[varName].label.font:SetFontObject(GameFontNormal)
    dropDowns[varName]:SetPoint("TOPLEFT", xCoord, yCoord-30)
    LibDD:UIDropDownMenu_SetWidth(dropDowns[varName], oUi.dropdownWidth)
    LibDD:UIDropDownMenu_SetText(dropDowns[varName], section[varName.."Name"])
    LibDD:UIDropDownMenu_JustifyText(dropDowns[varName], "LEFT")

    -- Create and bind the initialization function to the dropdown menu
    LibDD:UIDropDownMenu_Initialize(dropDowns[varName], function(self, level, menuList)
        local entries = 25
        local info = LibDD:UIDropDownMenu_CreateInfo()
        local items = TRB.Details.addonData.libs.SharedMedia:HashTable(lsmType)
        local itemsList = TRB.Details.addonData.libs.SharedMedia:List(lsmType)
        if (level or 1) == 1 or menuList == nil then
            local menus = math.ceil(TRB.Functions.Table:Length(items) / entries)
            for i=0, menus-1 do
                info.hasArrow = true
                info.notCheckable = true
                info.text = dropdownInfoText .. " " .. i+1
                info.menuList = i
                LibDD:UIDropDownMenu_AddButton(info)
            end
        else
            local start = entries * menuList

            for k, v in pairs(itemsList) do
                if k > start and k <= start + entries then
                    info.text = v
                    info.value = items[v]
                    info.checked = items[v] == section[varName]
                    info.func = self.SetValue
                    info.arg1 = items[v]
                    info.arg2 = v
                    info.icon = items[v]
                    LibDD:UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end)
end

function TRB.Functions.OptionsUi:ToggleCheckboxEnabled(checkbox, enable)
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

function TRB.Functions.OptionsUi:ToggleCheckboxOnOff(checkbox, enable, changeText)
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

function TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil    
    local title = ""

    local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

    local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

    controls.barPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Position and Size", oUi.xCoord, yCoord)

    yCoord = yCoord - 40
    title = "Bar Width"
    controls.width = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.width:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.bar.width = value

        local maxBorderSize = math.min(math.floor((spec.bar.height) / TRB.Data.constants.borderWidthFactor), math.floor((spec.bar.width) / TRB.Data.constants.borderWidthFactor))-1
        local borderSize = math.min(maxBorderSize, spec.bar.border)
        controls.borderWidth:SetValue(borderSize)
        controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.borderWidth.MaxLabel:SetText(maxBorderSize)

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetWidth(spec)
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Height"
    controls.height = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.height:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.bar.height = value

        local maxBorderSize = math.min(math.floor((spec.bar.height) / TRB.Data.constants.borderWidthFactor), math.floor((spec.bar.width) / TRB.Data.constants.borderWidthFactor))-1
        local borderSize = math.min(maxBorderSize, spec.bar.border)

        controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.borderWidth.MaxLabel:SetText(maxBorderSize)
        controls.borderWidth.EditBox:SetText(borderSize)

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetHeight(spec)
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Horizontal Position"
    yCoord = yCoord - 60
    controls.horizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.bar.xPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.horizontal:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.bar.xPos = value

        if GetSpecialization() == specId then
            TRB.Frames.barContainerFrame:ClearAllPoints()
            TRB.Frames.barContainerFrame:SetPoint("CENTER", UIParent)
            TRB.Frames.barContainerFrame:SetPoint("CENTER", spec.bar.xPos, spec.bar.yPos)
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Vertical Position"
    controls.vertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.bar.yPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.vertical:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.bar.yPos = value

        if GetSpecialization() == specId then
            TRB.Frames.barContainerFrame:ClearAllPoints()
            TRB.Frames.barContainerFrame:SetPoint("CENTER", UIParent)
            TRB.Frames.barContainerFrame:SetPoint("CENTER", spec.bar.xPos, spec.bar.yPos)
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Bar Border Width"
    yCoord = yCoord - 60
    controls.borderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.borderWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.bar.border = value

        if GetSpecialization() == specId then
            TRB.Frames.barContainerFrame:SetWidth(spec.bar.width-(spec.bar.border*2))
            TRB.Frames.barContainerFrame:SetHeight(spec.bar.height-(spec.bar.border*2))
            TRB.Frames.barBorderFrame:SetWidth(spec.bar.width)
            TRB.Frames.barBorderFrame:SetHeight(spec.bar.height)
            if spec.bar.border < 1 then
                TRB.Frames.barBorderFrame:SetBackdrop({
                    edgeFile = spec.textures.border,
                    tile = true,
                    tileSize = 4,
                    edgeSize = 1,
                    insets = {0, 0, 0, 0}
                })
                TRB.Frames.barBorderFrame:Hide()
            else
                TRB.Frames.barBorderFrame:SetBackdrop({
                    edgeFile = spec.textures.border,
                    tile = true,
                    tileSize=4,
                    edgeSize=spec.bar.border,
                    insets = {0, 0, 0, 0}
                })
                TRB.Frames.barBorderFrame:Show()
            end
            TRB.Frames.barBorderFrame:SetBackdropColor(0, 0, 0, 0)
            TRB.Frames.barBorderFrame:SetBackdropBorderColor (TRB.Functions.Color:GetRGBAFromString(spec.colors.bar.border, true))

            TRB.Functions.Bar:SetMinMax(spec)
            TRB.Functions.Bar:SetHeight(spec)
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end

        local minsliderWidth = math.max((spec.bar.border)*2+1, 120)
        local minsliderHeight = math.max((spec.bar.border)*2+1, 1)

        local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
        controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
        controls.height.MinLabel:SetText(minsliderHeight)
        controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
        controls.width.MinLabel:SetText(minsliderWidth)
    end)

    if spec.thresholds ~= nil then
        title = "Threshold Line Width"
        controls.thresholdWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.thresholds.width, 1, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
        controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
            value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
            spec.thresholds.width = value

            if GetSpecialization() == specId then
                TRB.Functions.Threshold:RedrawThresholdLines(spec)
            end
        end)
    end

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
        TRB.Frames.barContainerFrame:SetMovable((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
        TRB.Frames.barContainerFrame:EnableMouse((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
    end)

    TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

    controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.pinToPRD
    f:SetPoint("TOPLEFT", 0, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
    f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
    f:SetChecked(spec.bar.pinToPersonalResourceDisplay)
    f:SetScript("OnClick", function(self, ...)
        spec.bar.pinToPersonalResourceDisplay = self:GetChecked()

        TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

        TRB.Frames.barContainerFrame:SetMovable((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
        TRB.Frames.barContainerFrame:EnableMouse((not spec.bar.pinToPersonalResourceDisplay) and spec.bar.dragAndDrop)
        TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
    end)

    return yCoord
end

function TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, secondaryResourceString)
    if primaryResourceString == nil then
        primaryResourceString = "Energy"
    end
    
    if secondaryResourceString == nil then
        secondaryResourceString = "Combo Point"
    end

    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil
    
    local title = ""

    local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

    local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

    controls.comboPointPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, secondaryResourceString .. " Position and Size", oUi.xCoord, yCoord)

    yCoord = yCoord - 40
    title = secondaryResourceString .. " Width"
    controls.comboPointWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.width, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.comboPointWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = secondaryResourceString .. " Height"
    controls.comboPointHeight = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, sanityCheckValues.barMaxHeight, spec.comboPoints.height, 1, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.comboPointHeight:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)



    title = secondaryResourceString .. " Horizontal Position (Relative)"
    yCoord = yCoord - 60
    controls.comboPointHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.comboPoints.xPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.comboPointHorizontal:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.xPos = value

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = secondaryResourceString .. " Vertical Position (Relative)"
    controls.comboPointVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.comboPoints.yPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.comboPointVertical:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.yPos = value

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = secondaryResourceString .. " Border Width"
    yCoord = yCoord - 60
    controls.comboPointBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec.comboPoints.border, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.comboPointBorderWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.border = value

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)

            --TRB.Functions.Bar:SetMinMax(spec)
        end

        local minsliderWidth = math.max(spec.comboPoints.border*2, 1)
        local minsliderHeight = math.max(spec.comboPoints.border*2, 1)

        local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
        controls.comboPointHeight:SetMinMaxValues(minsliderHeight, scValues.comboPointsMaxHeight)
        controls.comboPointHeight.MinLabel:SetText(minsliderHeight)
        controls.comboPointWidth:SetMinMaxValues(minsliderWidth, scValues.comboPointsMaxWidth)
        controls.comboPointWidth.MinLabel:SetText(minsliderWidth)
    end)

    title = secondaryResourceString .. " Spacing"
    controls.comboPointSpacing = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.spacing, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.comboPoints.spacing = value

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    yCoord = yCoord - 40
    -- Create the dropdown, and configure its appearance
    controls.dropDown.comboPointsRelativeTo = LibDD:Create_UIDropDownMenu("TwintopResourceBar_"..className.."_"..specId.."_comboPointsRelativeTo", parent)
    controls.dropDown.comboPointsRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Relative Position of "..secondaryResourceString.." to "..primaryResourceString.." Bar", oUi.xCoord, yCoord)
    controls.dropDown.comboPointsRelativeTo.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.comboPointsRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    LibDD:UIDropDownMenu_SetWidth(controls.dropDown.comboPointsRelativeTo, oUi.dropdownWidth)
    LibDD:UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, spec.comboPoints.relativeToName)
    LibDD:UIDropDownMenu_JustifyText(controls.dropDown.comboPointsRelativeTo, "LEFT")

    -- Create and bind the initialization function to the dropdown menu
    LibDD:UIDropDownMenu_Initialize(controls.dropDown.comboPointsRelativeTo, function(self, level, menuList)
        local entries = 25
        local info = LibDD:UIDropDownMenu_CreateInfo()
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
            LibDD:UIDropDownMenu_AddButton(info, level)
        end
    end)

    function controls.dropDown.comboPointsRelativeTo:SetValue(newValue, newName)
        spec.comboPoints.relativeTo = newValue
        spec.comboPoints.relativeToName = newName
        LibDD:UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, newName)
        LibDD:CloseDropDownMenus()

        if GetSpecialization() == specId then
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
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
            TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    return yCoord
end

function TRB.Functions.OptionsUi:UpdateTextureDropdowns(controls, textures, newValue, newName, variable, specId, includeComboPoints)
    if includeComboPoints == nil then
        includeComboPoints = false
    end

    textures[variable.."Bar"] = newValue
    textures[variable.."BarName"] = newName
    LibDD:UIDropDownMenu_SetText(controls[variable.."Bar"], newName)
    if textures.textureLock then
        textures.resourceBar = newValue
        textures.resourceBarName = newName
        LibDD:UIDropDownMenu_SetText(controls.resourceBar, newName)
        textures.castingBar = newValue
        textures.castingBarName = newName
        LibDD:UIDropDownMenu_SetText(controls.castingBar, newName)
        textures.passiveBar = newValue
        textures.passiveBarName = newName
        LibDD:UIDropDownMenu_SetText(controls.passiveBar, newName)

        if includeComboPoints then
            textures.comboPointsBar = newValue
            textures.comboPointsBarName = newName
            LibDD:UIDropDownMenu_SetText(controls.comboPointsBar, newName)
        end
    end

    if GetSpecialization() == specId then
        if includeComboPoints and variable == "comboPoints" then
            local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
            for x = 1, length do
                TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(textures.comboPointsBar)
            end
        else
            TRB.Frames[variable.."Frame"]:SetStatusBarTexture(textures[variable.."Bar"])
        end

        if textures.textureLock then
            TRB.Frames.resourceFrame:SetStatusBarTexture(textures.resourceBar)
            TRB.Frames.castingFrame:SetStatusBarTexture(textures.castingBar)
            TRB.Frames.passiveFrame:SetStatusBarTexture(textures.passiveBar)
            
            if includeComboPoints and variable ~= "comboPoints" then
                local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
                for x = 1, length do
                    TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(textures.comboPointsBar)
                end
            end
        end
    end

    LibDD:CloseDropDownMenus()
end

function TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, yCoord, includeComboPoints, secondaryResourceString)
    if includeComboPoints == nil then
        includeComboPoints = false
    end
    
    if secondaryResourceString == nil then
        secondaryResourceString = "Combo Point"
    end

    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil
    
    if includeComboPoints then
        controls.textBarTexturesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar and "..secondaryResourceString.." Textures", oUi.xCoord, yCoord)
    else
        controls.textBarTexturesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Textures", oUi.xCoord, yCoord)
    end
		
    controls.dropDown.textures = {}

    yCoord = yCoord - 30
    TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "resourceBar", "Main Bar Texture", "Status Bar Textures")
    -- Implement the function to change the texture
    function controls.dropDown.textures.resourceBar:SetValue(newValue, newName)
        TRB.Functions.OptionsUi:UpdateTextureDropdowns(controls.dropDown.textures, spec.textures, newValue, newName, "resource", specId, includeComboPoints)
    end

    TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "castingBar", "Casting Bar Texture", "Status Bar Textures")
    -- Implement the function to change the texture
    function controls.dropDown.textures.castingBar:SetValue(newValue, newName)
        TRB.Functions.OptionsUi:UpdateTextureDropdowns(controls.dropDown.textures, spec.textures, newValue, newName, "casting", specId, includeComboPoints)
    end

    yCoord = yCoord - 60
    TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "passiveBar", "Passive Bar Texture", "Status Bar Textures")
    -- Implement the function to change the texture
    function controls.dropDown.textures.passiveBar:SetValue(newValue, newName)
        TRB.Functions.OptionsUi:UpdateTextureDropdowns(controls.dropDown.textures, spec.textures, newValue, newName, "passive", specId, includeComboPoints)
    end

    if includeComboPoints then
        TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "comboPointsBar", secondaryResourceString.." Bar Texture", "Status Bar Textures")
        -- Implement the function to change the texture
        function controls.dropDown.textures.comboPointsBar:SetValue(newValue, newName)
            TRB.Functions.OptionsUi:UpdateTextureDropdowns(controls.dropDown.textures, spec.textures, newValue, newName, "comboPoints", specId, includeComboPoints)
        end
    end
    
    controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_TextureLock", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.textureLock
    f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
    f:SetChecked(spec.textures.textureLock)
    getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
    f.tooltip = "This will lock the texture for each part of the bar to be the same."

    f:SetScript("OnClick", function(self, ...)
        spec.textures.textureLock = self:GetChecked()
        if spec.textures.textureLock then
            spec.textures.passiveBar = spec.textures.resourceBar
            spec.textures.passiveBarName = spec.textures.resourceBarName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.resourceBar, spec.textures.passiveBarName)
            spec.textures.castingBar = spec.textures.resourceBar
            spec.textures.castingBarName = spec.textures.resourceBarName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.castingBar, spec.textures.castingBarName)

            if includeComboPoints then
				spec.textures.comboPointsBorder = spec.textures.border
				spec.textures.comboPointsBorderName = spec.textures.borderName
				LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.comboPointsBorder, spec.textures.comboPointsBorderName)
				spec.textures.comboPointsBackground = spec.textures.background
				spec.textures.comboPointsBackgroundName = spec.textures.backgroundName
				LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.comboPointsBackground, spec.textures.comboPointsBackgroundName)
            end

            if GetSpecialization() == specId then
                TRB.Frames.resourceFrame:SetStatusBarTexture(spec.textures.resourceBar)
                TRB.Frames.passiveFrame:SetStatusBarTexture(spec.textures.passiveBar)
                TRB.Frames.castingFrame:SetStatusBarTexture(spec.textures.castingBar)

                if includeComboPoints then
                    local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
                    for x = 1, length do
                        TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarTexture(spec.textures.comboPointsBar)
                        
                        TRB.Frames.resource2Frames[x].containerFrame:SetBackdrop({ 
                            bgFile = spec.textures.comboPointsBackground,
                            tile = true,
                            tileSize = spec.comboPoints.width,
                            edgeSize = 1,
                            insets = {0, 0, 0, 0}
                        })
                        TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.comboPoints.background, true))
                        
                        if spec.comboPoints.border < 1 then
                            TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ })
                        else
                            TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ edgeFile = spec.textures.comboPointsBorder,
                                                        tile = true,
                                                        tileSize=4,
                                                        edgeSize=spec.comboPoints.border,
                                                        insets = {0, 0, 0, 0}
                                                        })
                        end
                    end
                end
            end
        end
    end)

    yCoord = yCoord - 60
    TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "border", "border", "Border Texture", "Border Textures")
    -- Implement the function to change the texture
    function controls.dropDown.textures.border:SetValue(newValue, newName)
        spec.textures.border = newValue
        spec.textures.borderName = newName

        if GetSpecialization() == specId then
            if spec.bar.border < 1 then
                TRB.Frames.barBorderFrame:SetBackdrop({ })
            else
                TRB.Frames.barBorderFrame:SetBackdrop({ edgeFile = spec.textures.border,
                                            tile = true,
                                            tileSize=4,
                                            edgeSize=spec.bar.border,
                                            insets = {0, 0, 0, 0}
                                            })
            end
            TRB.Frames.barBorderFrame:SetBackdropColor(0, 0, 0, 0)
            TRB.Frames.barBorderFrame:SetBackdropBorderColor (TRB.Functions.Color:GetRGBAFromString(spec.colors.bar.border, true))
        end

        LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.border, newName)

        if includeComboPoints and spec.textures.textureLock then
			spec.textures.comboPointsBorder = newValue
			spec.textures.comboPointsBorderName = newName

			if GetSpecialization() == specId then
				local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
				for x = 1, length do
					if spec.comboPoints.border < 1 then
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ })
					else
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ edgeFile = spec.textures.comboPointsBorder,
													tile = true,
													tileSize=4,
													edgeSize=spec.comboPoints.border,
													insets = {0, 0, 0, 0}
													})
					end
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropColor(0, 0, 0, 0)
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.comboPoints.border, true))
				end
			end

			LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.comboPointsBorder, newName)
        end

        LibDD:CloseDropDownMenus()
    end
    
    TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "background", "background", "Background (Empty Bar) Texture", "Background Textures")
    -- Implement the function to change the texture
    function controls.dropDown.textures.background:SetValue(newValue, newName)
        spec.textures.background = newValue
        spec.textures.backgroundName = newName

        if GetSpecialization() == specId then
            TRB.Frames.barContainerFrame:SetBackdrop({ 
                bgFile = spec.textures.background,
                tile = true,
                tileSize = spec.bar.width,
                edgeSize = 1,
                insets = {0, 0, 0, 0}
            })
            TRB.Frames.barContainerFrame:SetBackdropColor (TRB.Functions.Color:GetRGBAFromString(spec.colors.bar.background, true))
        end

        LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.background, newName)
        
        if includeComboPoints and spec.textures.textureLock then
            spec.textures.comboPointsBackground = newValue
			spec.textures.comboPointsBackgroundName = newName

			if GetSpecialization() == specId then
				local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
				for x = 1, length do
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdrop({ 
						bgFile = spec.textures.comboPointsBackground,
						tile = true,
						tileSize = spec.comboPoints.width,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.comboPoints.background, true))
				end
			end

			LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.comboPointsBackground, newName)
        end
        LibDD:CloseDropDownMenus()
    end

    if includeComboPoints then
		yCoord = yCoord - 60
        TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "border", "comboPointsBorder", secondaryResourceString.." Border Texture", "Border Textures")
		-- Implement the function to change the texture
		function controls.dropDown.textures.comboPointsBorder:SetValue(newValue, newName)
			spec.textures.comboPointsBorder = newValue
			spec.textures.comboPointsBorderName = newName

			if GetSpecialization() == specId then
				local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
				for x = 1, length do
					if spec.comboPoints.border < 1 then
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ })
					else
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdrop({ edgeFile = spec.textures.comboPointsBorder,
													tile = true,
													tileSize=4,
													edgeSize=spec.comboPoints.border,
													insets = {0, 0, 0, 0}
													})
					end
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropColor(0, 0, 0, 0)
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.comboPoints.border, true))
				end
			end

			LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.comboPointsBorder, newName)

			if spec.textures.textureLock then
				spec.textures.border = newValue
				spec.textures.borderName = newName

                if GetSpecialization() == specId then
                    if spec.bar.border < 1 then
                        TRB.Frames.barBorderFrame:SetBackdrop({ })
                    else
                        TRB.Frames.barBorderFrame:SetBackdrop({ edgeFile = spec.textures.border,
                                                    tile = true,
                                                    tileSize=4,
                                                    edgeSize=spec.bar.border,
                                                    insets = {0, 0, 0, 0}
                                                    })
                    end
				    TRB.Frames.barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				    TRB.Frames.barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.bar.border, true))
                end

				LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.border, newName)
			end

			LibDD:CloseDropDownMenus()
		end

        TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "background", "comboPointsBackground", secondaryResourceString.." Background (Empty Bar) Texture", "Background Textures")
		-- Implement the function to change the texture
		function controls.dropDown.textures.comboPointsBackground:SetValue(newValue, newName)
			spec.textures.comboPointsBackground = newValue
			spec.textures.comboPointsBackgroundName = newName

			if GetSpecialization() == specId then
				local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
				for x = 1, length do
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdrop({ 
						bgFile = spec.textures.comboPointsBackground,
						tile = true,
						tileSize = spec.comboPoints.width,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.comboPoints.background, true))
				end
			end

			LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.comboPointsBackground, newName)
			
			if spec.textures.textureLock then
				spec.textures.background = newValue
				spec.textures.backgroundName = newName

				if GetSpecialization() == specId then
					TRB.Frames.barContainerFrame:SetBackdrop({ 
						bgFile = spec.textures.background,
						tile = true,
						tileSize = spec.bar.width,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					TRB.Frames.barContainerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(spec.colors.bar.background, true))
				end

				LibDD:UIDropDownMenu_SetText(controls.dropDown.textures.background, newName)
			end

			LibDD:CloseDropDownMenus()
		end

        yCoord = yCoord - 60
        f = controls.checkBoxes.textureLock
        f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
        getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars, borders, and backgrounds (respectively)")
		f.tooltip = "This will lock the texture for each type of texture to be the same for all parts of the bar. E.g.: All bar textures will be the same, all border textures will be the same, and all background textures will be the same."
    else
        yCoord = yCoord - 30
    end

    return yCoord
end

function TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, showWhenCategory, includeCastingBar, includePassiveBar, includeFlashAlpha, flashAlphaName, flashAlphaNameShort)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil
    local title = ""

    controls.barDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display", oUi.xCoord, yCoord)

    if includeFlashAlpha then
        yCoord = yCoord - 50
        title = flashAlphaName.." Flash Alpha"
        controls.flashAlpha = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
        controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
            value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
            value = TRB.Functions.Number:RoundTo(value, 2)
            self.EditBox:SetText(value)
            spec.colors.bar.flashAlpha = value
        end)

        title = flashAlphaName.." Flash Period (sec)"
        controls.flashPeriod = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, spec.colors.bar.flashPeriod, 0.05, 2,
                                        oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
        controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
            value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
            value = TRB.Functions.Number:RoundTo(value, 2)
            self.EditBox:SetText(value)
            spec.colors.bar.flashPeriod = value
        end)
    end

    yCoord = yCoord - 40

    controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_AlwaysShow", parent, "UIRadioButtonTemplate")
    f = controls.checkBoxes.alwaysShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Always show bar")
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
        TRB.Functions.Bar:HideResourceBar()
    end)

    controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_NotZeroShow", parent, "UIRadioButtonTemplate")
    f = controls.checkBoxes.notZeroShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
    getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)

    if showWhenCategory == "notFull" then
		getglobal(f:GetName() .. 'Text'):SetText("Show bar when "..primaryResourceString.." is not full")
		f.tooltip = "This will make the Resource Bar show out of combat only if "..primaryResourceString.." is not full, hidden otherwise when out of combat."
    elseif showWhenCategory == "balance" then
		getglobal(f:GetName() .. 'Text'):SetText("Show bar when AP > 0 (or < 50 w/NB)")
        f.tooltip = "This will make the Resource Bar show out of combat only if Astral Power > 0 (or < 50 with Nature's Balance), hidden otherwise when out of combat."
    else
        getglobal(f:GetName() .. 'Text'):SetText("Show bar when "..primaryResourceString.." > 0")
        f.tooltip = "This will make the Resource Bar show out of combat only if "..primaryResourceString.." > 0, hidden otherwise when out of combat."
    end

    f:SetChecked(spec.displayBar.notZeroShow)
    f:SetScript("OnClick", function(self, ...)
        controls.checkBoxes.alwaysShow:SetChecked(false)
        controls.checkBoxes.notZeroShow:SetChecked(true)
        controls.checkBoxes.combatShow:SetChecked(false)
        controls.checkBoxes.neverShow:SetChecked(false)
        spec.displayBar.alwaysShow = false
        spec.displayBar.notZeroShow = true
        spec.displayBar.neverShow = false
        TRB.Functions.Bar:HideResourceBar()
    end)

    controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_CombatShow", parent, "UIRadioButtonTemplate")
    f = controls.checkBoxes.combatShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    getglobal(f:GetName() .. 'Text'):SetText("Only show bar in combat")
    getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
    f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
    f:SetChecked((not spec.displayBar.alwaysShow) and (not spec.displayBar.notZeroShow) and (not spec.displayBar.neverShow))
    f:SetScript("OnClick", function(self, ...)
        controls.checkBoxes.alwaysShow:SetChecked(false)
        controls.checkBoxes.notZeroShow:SetChecked(false)
        controls.checkBoxes.combatShow:SetChecked(true)
        controls.checkBoxes.neverShow:SetChecked(false)
        spec.displayBar.alwaysShow = false
        spec.displayBar.notZeroShow = false
        spec.displayBar.neverShow = false
        TRB.Functions.Bar:HideResourceBar()
    end)

    controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_NeverShow", parent, "UIRadioButtonTemplate")
    f = controls.checkBoxes.neverShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-45)
    getglobal(f:GetName() .. 'Text'):SetText("Never show bar (run in background)")
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
        TRB.Functions.Bar:HideResourceBar()
    end)
    
    local yCoord2 = yCoord

    if includeCastingBar then
        controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
        f = controls.checkBoxes.showCastingBar
        f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
        getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
        f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
        f:SetChecked(spec.bar.showCasting)
        f:SetScript("OnClick", function(self, ...)
            spec.bar.showCasting = self:GetChecked()
        end)
        yCoord2 = yCoord2-20
    end

    if includePassiveBar then
        controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
        f = controls.checkBoxes.showPassiveBar
        f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
        getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
        f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
        f:SetChecked(spec.bar.showPassive)
        f:SetScript("OnClick", function(self, ...)
            spec.bar.showPassive = self:GetChecked()
        end)
        yCoord2 = yCoord2-20
    end
    
    if includeFlashAlpha then
        controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Checkbox_FlashEnabled", parent, "ChatConfigCheckButtonTemplate")
        f = controls.checkBoxes.flashEnabled
        f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
        getglobal(f:GetName() .. 'Text'):SetText("Flash bar when "..flashAlphaNameShort.." is usable")
        f.tooltip = "This will flash the bar when "..flashAlphaName.." can be cast."
        f:SetChecked(spec.colors.bar.flashEnabled)
        f:SetScript("OnClick", function(self, ...)
            spec.colors.bar.flashEnabled = self:GetChecked()
        end)
        yCoord2 = yCoord2-20
    end    

    return yCoord, yCoord2+20
end

function TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil
    local title = ""
    local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

    -- Create the dropdown, and configure its appearance
    controls.dropDown.thresholdIconRelativeTo = LibDD:Create_UIDropDownMenu("TwintopResourceBar_"..className.."_"..specId.."_ThresholdIconRelativeTo", parent)
    controls.dropDown.thresholdIconRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", oUi.xCoord, yCoord)
    controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    LibDD:UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, oUi.dropdownWidth)
    LibDD:UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, spec.thresholds.icons.relativeToName)
    LibDD:UIDropDownMenu_JustifyText(controls.dropDown.thresholdIconRelativeTo, "LEFT")

    -- Create and bind the initialization function to the dropdown menu
    LibDD:UIDropDownMenu_Initialize(controls.dropDown.thresholdIconRelativeTo, function(self, level, menuList)
        local entries = 25
        local info = LibDD:UIDropDownMenu_CreateInfo()
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
            LibDD:UIDropDownMenu_AddButton(info, level)
        end
    end)

    function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
        spec.thresholds.icons.relativeTo = newValue
        spec.thresholds.icons.relativeToName = newName
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end

        LibDD:UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
        LibDD:CloseDropDownMenus()
    end

    controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_ThresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.thresholdIconEnabled
    f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
    getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
    f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
    f:SetChecked(spec.thresholds.icons.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.icons.enabled = self:GetChecked()
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end
    end)

    controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.thresholdIconDesaturated
    f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
    getglobal(f:GetName() .. 'Text'):SetText("Desaturate icons when not usable")
    f.tooltip = "When checked, icons will be desaturated when an ability is not usable (on cooldown, below minimum resource, lacking other requirements, etc.)."
    f:SetChecked(spec.thresholds.icons.desaturated)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.icons.desaturated = self:GetChecked()
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end
    end)

    yCoord = yCoord - 100
    title = "Threshold Icon Width"
    controls.thresholdIconWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.thresholds.icons.width = value

        local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
        local borderSize = spec.thresholds.icons.border
    
        if maxBorderSize < borderSize then
            maxBorderSize = borderSize
        end

        controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
        controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end
    end)

    title = "Threshold Icon Height"
    controls.thresholdIconHeight = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.thresholds.icons.height = value

        local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
        local borderSize = spec.thresholds.icons.border
    
        if maxBorderSize < borderSize then
            maxBorderSize = borderSize
        end

        controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
        controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
        controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end
    end)


    title = "Threshold Icon Horizontal Position (Relative)"
    yCoord = yCoord - 60
    controls.thresholdIconHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.thresholds.icons.xPos = value
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
            --TRB.Functions.Bar:SetPosition(spec, TRB.Frames.barContainerFrame)
        end
    end)

    title = "Threshold Icon Vertical Position (Relative)"
    controls.thresholdIconVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.thresholds.icons.yPos = value
        
        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end
    end)

    local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

    title = "Threshold Icon Border Width"
    yCoord = yCoord - 60
    controls.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.thresholds.icons.border = value

        local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
        local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

        controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
        controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
        controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
        controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

        if GetSpecialization() == specId then
            TRB.Functions.Threshold:RedrawThresholdLines(spec)
        end
    end)

    return yCoord
end

function TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, classId, specId, yCoord)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil
    local title = ""

    yCoord = yCoord - 40
    controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Potion on Cooldown Configuration", oUi.xCoord, yCoord)

    yCoord = yCoord - 30
    controls.checkBoxes.potionCooldown = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_PotionCooldown_CB", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.potionCooldown
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Show potion threshold lines when potion is on cooldown")
    f.tooltip = "Shows the potion threshold lines while potion use is still on cooldown. Configure below how far in advance to have the lines be visible, between 0 - 300 seconds (300 being effectively 'always visible')."
    f:SetChecked(spec.thresholds.potionCooldown.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.potionCooldown.enabled = self:GetChecked()
    end)

    yCoord = yCoord - 40
    controls.checkBoxes.potionCooldownModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_PotionCooldown_M_GCD", parent, "UIRadioButtonTemplate")
    f = controls.checkBoxes.potionCooldownModeGCDs
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("GCDs left on Potion cooldown")
    getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
    f.tooltip = "Show potion threshold lines based on how many GCDs remain on potion cooldown."
    if spec.thresholds.potionCooldown.mode == "gcd" then
        f:SetChecked(true)
    end
    f:SetScript("OnClick", function(self, ...)
        controls.checkBoxes.potionCooldownModeGCDs:SetChecked(true)
        controls.checkBoxes.potionCooldownModeTime:SetChecked(false)
        spec.thresholds.potionCooldown.mode = "gcd"
    end)

    title = "Potion Cooldown GCDs - 0.75sec Floor"
    controls.potionCooldownGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 400, spec.thresholds.potionCooldown.gcdsMax, 0.25, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.potionCooldownGCDs:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.thresholds.potionCooldown.gcdsMax = value
    end)


    yCoord = yCoord - 60
    controls.checkBoxes.potionCooldownModeTime = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_PotionCooldown_M_TIME", parent, "UIRadioButtonTemplate")
    f = controls.checkBoxes.potionCooldownModeTime
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Time left on Potion cooldown")
    getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
    f.tooltip = "Change the bar color based on how many seconds remain until potions will come off cooldown."
    if spec.thresholds.potionCooldown.mode == "time" then
        f:SetChecked(true)
    end
    f:SetScript("OnClick", function(self, ...)
        controls.checkBoxes.potionCooldownModeGCDs:SetChecked(false)
        controls.checkBoxes.potionCooldownModeTime:SetChecked(true)
        spec.thresholds.potionCooldown.mode = "time"
    end)

    title = "Potion Cooldown Time Remaining"
    controls.potionCooldownTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 300, spec.thresholds.potionCooldown.timeMax, 0.25, 2,
                                    oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
    controls.potionCooldownTime:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        value = TRB.Functions.Number:RoundTo(value, 2)
        self.EditBox:SetText(value)
        spec.thresholds.potionCooldown.timeMax = value
    end)

    return yCoord
end

function TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, classId, specId, yCoord)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil

    controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Threshold Lines", oUi.xCoord, yCoord)

    controls.colors.threshold = {}

    yCoord = yCoord - 25
    controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana gain from potions and items (when usable)", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-0)
    f = controls.colors.threshold.over
    f:SetScript("OnMouseDown", function(self, button, ...)
        TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
    end)

    controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana potion or item on cooldown", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-30)
    f = controls.colors.threshold.unusable
    f:SetScript("OnMouseDown", function(self, button, ...)
        TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
    end)

    controls.colors.threshold.mindbender = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive mana gain per source", spec.colors.threshold.mindbender, 300, 25, oUi.xCoord2, yCoord-60)
    f = controls.colors.threshold.mindbender
    f:SetScript("OnMouseDown", function(self, button, ...)
        TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "mindbender")
    end)

    controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_ThresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.thresholdOverlapBorder
    f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
    getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
    f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
    f:SetChecked(spec.thresholds.overlapBorder)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.overlapBorder = self:GetChecked()
        TRB.Functions.Threshold:RedrawThresholdLines(spec)
    end)

    controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, "Aerated Mana Potion", 5, yCoord, 300, 20)
    yCoord = yCoord - 20

    controls.checkBoxes.aeratedManaPotionRank3ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_AeratedManaPotionRank3", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.aeratedManaPotionRank3ThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 8, -8) .. "27,600 mana")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use an Aerated Mana Potion " .. CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 0, -8) .. " (27,600 mana)"
    f:SetChecked(spec.thresholds.aeratedManaPotionRank3.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.aeratedManaPotionRank3.enabled = self:GetChecked()
    end)

    yCoord = yCoord - 25
    controls.checkBoxes.aeratedManaPotionRank2ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_AeratedManaPotionRank2", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.aeratedManaPotionRank2ThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 8, -8) .. "24,000 mana")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use an Aerated Mana Potion " .. CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 0, -8) .. " (24,000 mana)"
    f:SetChecked(spec.thresholds.aeratedManaPotionRank2.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.aeratedManaPotionRank2.enabled = self:GetChecked()
    end)
    yCoord = yCoord - 25

    controls.checkBoxes.aeratedManaPotionRank1ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_AeratedManaPotionRank1", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.aeratedManaPotionRank1ThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 8, -8) .. "20,869 mana")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use an Aerated Mana Potion " .. CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 0, -8) .. " (20,869 mana)"
    f:SetChecked(spec.thresholds.aeratedManaPotionRank1.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.aeratedManaPotionRank1.enabled = self:GetChecked()
    end)
    yCoord = yCoord - 25

    controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, "Potion of Frozen Focus", 5, yCoord, 300, 20)
    yCoord = yCoord - 20

    controls.checkBoxes.potionOfFrozenFocusRank3ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_potionOfFrozenFocusRank3", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.potionOfFrozenFocusRank3ThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 8, -8) .. "48,300 mana + regen")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use an Aerated Mana Potion " .. CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 0, -8) .. " (48,300 mana + regen)"
    f:SetChecked(spec.thresholds.potionOfFrozenFocusRank3.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.potionOfFrozenFocusRank3.enabled = self:GetChecked()
    end)

    yCoord = yCoord - 25
    controls.checkBoxes.potionOfFrozenFocusRank2ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_potionOfFrozenFocusRank2", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.potionOfFrozenFocusRank2ThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 8, -8) .. "42,000 mana + regen")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use an Aerated Mana Potion " .. CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 0, -8) .. " (42,000 mana + regen)"
    f:SetChecked(spec.thresholds.potionOfFrozenFocusRank2.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.potionOfFrozenFocusRank2.enabled = self:GetChecked()
    end)

    yCoord = yCoord - 25
    controls.checkBoxes.potionOfFrozenFocusRank1ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_potionOfFrozenFocusRank1", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.potionOfFrozenFocusRank1ThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 8, -8) .. "36,531 mana + regen")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use an Aerated Mana Potion " .. CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 0, -8) .. " (36,531 mana + regen)"
    f:SetChecked(spec.thresholds.potionOfFrozenFocusRank1.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.potionOfFrozenFocusRank1.enabled = self:GetChecked()
    end)

    yCoord = yCoord - 25
    controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, "Items", 5, yCoord, 300, 20)
    yCoord = yCoord - 20

    controls.checkBoxes.snThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_Threshold_Option_conjuredChillglobe", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.snThresholdShow
    f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
    getglobal(f:GetName() .. 'Text'):SetText("Conjured Chillglobe")
    f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use the Conjured Chillglobe trinket. Only shown below 65% mana."
    f:SetChecked(spec.thresholds.conjuredChillglobe.enabled)
    f:SetScript("OnClick", function(self, ...)
        spec.thresholds.conjuredChillglobe.enabled = self:GetChecked()
    end)

    yCoord = yCoord - 40

    return yCoord
end

function TRB.Functions.OptionsUi:GenerateFontOptions(parent, controls, spec, classId, specId, yCoord)
    local oUi = TRB.Data.constants.optionsUi
    local _, className, _ = GetClassInfo(classId)
    local f = nil
    local title = ""
    
    controls.dropDown.fonts = {}

    controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Font Face", oUi.xCoord, yCoord)

    --[[

        Todo: Refactor font naming to make using the LSM functions a reality.

    ]]
    yCoord = yCoord - 30

    -- Create the dropdown, and configure its appearance
    controls.dropDown.fontLeft = LibDD:Create_UIDropDownMenu("TwintopResourceBar_"..className.."_"..specId.."_FontLeft", parent)
    controls.dropDown.fontLeft.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Left Bar Font Face", oUi.xCoord, yCoord)
    controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.fontLeft:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    LibDD:UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, oUi.dropdownWidth)
    LibDD:UIDropDownMenu_SetText(controls.dropDown.fontLeft, spec.displayText.left.fontFaceName)
    LibDD:UIDropDownMenu_JustifyText(controls.dropDown.fontLeft, "LEFT")

    -- Create and bind the initialization function to the dropdown menu
    LibDD:UIDropDownMenu_Initialize(controls.dropDown.fontLeft, function(self, level, menuList)
        local entries = 25
        local info = LibDD:UIDropDownMenu_CreateInfo()
        local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
        local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
        if (level or 1) == 1 or menuList == nil then
            local menus = math.ceil(TRB.Functions.Table:Length(fonts) / entries)
            for i=0, menus-1 do
                info.hasArrow = true
                info.notCheckable = true
                info.text = "Fonts " .. i+1
                info.menuList = i
                LibDD:UIDropDownMenu_AddButton(info)
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
                    LibDD:UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end)

    function controls.dropDown.fontLeft:SetValue(newValue, newName)
        spec.displayText.left.fontFace = newValue
        spec.displayText.left.fontFaceName = newName
        LibDD:UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
        if spec.displayText.fontFaceLock then
            spec.displayText.middle.fontFace = newValue
            spec.displayText.middle.fontFaceName = newName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
            spec.displayText.right.fontFace = newValue
            spec.displayText.right.fontFaceName = newName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
        end

        if GetSpecialization() == specId then
            TRB.Frames.leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
            if spec.displayText.fontFaceLock then
                TRB.Frames.middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
                TRB.Frames.rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
            end
        end

        LibDD:CloseDropDownMenus()
    end

    -- Create the dropdown, and configure its appearance
    controls.dropDown.fontMiddle = LibDD:Create_UIDropDownMenu("TwintopResourceBar_"..className.."_"..specId.."_FontMiddle", parent)
    controls.dropDown.fontMiddle.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Middle Bar Font Face", oUi.xCoord2, yCoord)
    controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.fontMiddle:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
    LibDD:UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, oUi.dropdownWidth)
    LibDD:UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
    LibDD:UIDropDownMenu_JustifyText(controls.dropDown.fontMiddle, "LEFT")

    -- Create and bind the initialization function to the dropdown menu
    LibDD:UIDropDownMenu_Initialize(controls.dropDown.fontMiddle, function(self, level, menuList)
        local entries = 25
        local info = LibDD:UIDropDownMenu_CreateInfo()
        local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
        local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
        if (level or 1) == 1 or menuList == nil then
            local menus = math.ceil(TRB.Functions.Table:Length(fonts) / entries)
            for i=0, menus-1 do
                info.hasArrow = true
                info.notCheckable = true
                info.text = "Fonts " .. i+1
                info.menuList = i
                LibDD:UIDropDownMenu_AddButton(info)
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
                    LibDD:UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end)

    function controls.dropDown.fontMiddle:SetValue(newValue, newName)
        spec.displayText.middle.fontFace = newValue
        spec.displayText.middle.fontFaceName = newName
        LibDD:UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
        if spec.displayText.fontFaceLock then
            spec.displayText.left.fontFace = newValue
            spec.displayText.left.fontFaceName = newName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
            spec.displayText.right.fontFace = newValue
            spec.displayText.right.fontFaceName = newName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
        end

        if GetSpecialization() == specId then
            TRB.Frames.middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
            if spec.displayText.fontFaceLock then
                TRB.Frames.leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
                TRB.Frames.rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
            end
        end

        LibDD:CloseDropDownMenus()
    end

    yCoord = yCoord - 40 - 20

    -- Create the dropdown, and configure its appearance
    controls.dropDown.fontRight = LibDD:Create_UIDropDownMenu("TwintopResourceBar_"..className.."_"..specId.."_FontRight", parent)
    controls.dropDown.fontRight.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Right Bar Font Face", oUi.xCoord, yCoord)
    controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
    controls.dropDown.fontRight:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
    LibDD:UIDropDownMenu_SetWidth(controls.dropDown.fontRight, oUi.dropdownWidth)
    LibDD:UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)
    LibDD:UIDropDownMenu_JustifyText(controls.dropDown.fontRight, "LEFT")

    -- Create and bind the initialization function to the dropdown menu
    LibDD:UIDropDownMenu_Initialize(controls.dropDown.fontRight, function(self, level, menuList)
        local entries = 25
        local info = LibDD:UIDropDownMenu_CreateInfo()
        local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
        local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
        if (level or 1) == 1 or menuList == nil then
            local menus = math.ceil(TRB.Functions.Table:Length(fonts) / entries)
            for i=0, menus-1 do
                info.hasArrow = true
                info.notCheckable = true
                info.text = "Fonts " .. i+1
                info.menuList = i
                LibDD:UIDropDownMenu_AddButton(info)
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
                    LibDD:UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end)

    function controls.dropDown.fontRight:SetValue(newValue, newName)
        spec.displayText.right.fontFace = newValue
        spec.displayText.right.fontFaceName = newName
        LibDD:UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
        if spec.displayText.fontFaceLock then
            spec.displayText.left.fontFace = newValue
            spec.displayText.left.fontFaceName = newName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
            spec.displayText.middle.fontFace = newValue
            spec.displayText.middle.fontFaceName = newName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
        end

        if GetSpecialization() == specId then
            TRB.Frames.rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
            if spec.displayText.fontFaceLock then
                TRB.Frames.leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
                TRB.Frames.middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
            end
        end

        LibDD:CloseDropDownMenus()
    end

    controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.fontFaceLock
    f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
    getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
    f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
    f:SetChecked(spec.displayText.fontFaceLock)
    f:SetScript("OnClick", function(self, ...)
        spec.displayText.fontFaceLock = self:GetChecked()
        if spec.displayText.fontFaceLock then
            spec.displayText.middle.fontFace = spec.displayText.left.fontFace
            spec.displayText.middle.fontFaceName = spec.displayText.left.fontFaceName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
            spec.displayText.right.fontFace = spec.displayText.left.fontFace
            spec.displayText.right.fontFaceName = spec.displayText.left.fontFaceName
            LibDD:UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)

            if GetSpecialization() == specId then
                TRB.Frames.middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
                TRB.Frames.rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
            end
        end
    end)


    yCoord = yCoord - 70
    controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Font Size and Colors", oUi.xCoord, yCoord)

    title = "Left Bar Text Font Size"
    yCoord = yCoord - 50
    controls.fontSizeLeft = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.left.fontSize, 1, 0,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.displayText.left.fontSize = value

        if GetSpecialization() == specId then
            TRB.Frames.leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
        end

        if spec.displayText.fontSizeLock then
            controls.fontSizeMiddle:SetValue(value)
            controls.fontSizeRight:SetValue(value)
        end
    end)

    controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_"..className.."_"..specId.."_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
    f = controls.checkBoxes.fontSizeLock
    f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
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

    controls.colors.text.left = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Left Text", spec.colors.text.left,
                                                    250, 25, oUi.xCoord2, yCoord-30)
    f = controls.colors.text.left
    f:SetScript("OnMouseDown", function(self, button, ...)
        TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "left")
    end)

    controls.colors.text.middle = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Middle Text", spec.colors.text.middle,
                                                    225, 25, oUi.xCoord2, yCoord-70)
    f = controls.colors.text.middle
    f:SetScript("OnMouseDown", function(self, button, ...)
        TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "middle")
    end)

    controls.colors.text.right = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Right Text", spec.colors.text.right,
                                                    225, 25, oUi.xCoord2, yCoord-110)
    f = controls.colors.text.right
    f:SetScript("OnMouseDown", function(self, button, ...)
        TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "right")
    end)

    title = "Middle Bar Text Font Size"
    yCoord = yCoord - 60
    controls.fontSizeMiddle = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.middle.fontSize, 1, 0,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.displayText.middle.fontSize = value

        if GetSpecialization() == specId then
            TRB.Frames.middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
        end

        if spec.displayText.fontSizeLock then
            controls.fontSizeLeft:SetValue(value)
            controls.fontSizeRight:SetValue(value)
        end
    end)

    title = "Right Bar Text Font Size"
    yCoord = yCoord - 60
    controls.fontSizeRight = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.right.fontSize, 1, 0,
                                oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
    controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
        value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
        spec.displayText.right.fontSize = value

        if GetSpecialization() == specId then
            TRB.Frames.rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
        end

        if spec.displayText.fontSizeLock then
            controls.fontSizeLeft:SetValue(value)
            controls.fontSizeMiddle:SetValue(value)
        end
    end)
    return yCoord
end

