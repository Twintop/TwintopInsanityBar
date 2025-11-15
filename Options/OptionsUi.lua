---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = {}
local oUi = TRB.Data.constants.optionsUi

local L = TRB.Localization

local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/225
end

local sounds = {}
local soundsList = {}
local soundPairs = {}
local soundPairsByName = {}
local function FillSoundCache()
	if TRB.Functions.Table:Length(sounds) == 0 then
		sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")

		local x = 1
		for k, v in pairs(soundsList) do
			table.insert(soundPairs, { v, sounds[v] })
			soundPairsByName[sounds[v]] = v
			x = x + 1
		end
	end
end

local fonts = {}
local fontsList = {}
local fontPairs = {}
local fontPairsByName = {}
local function FillFontCache()
	if TRB.Functions.Table:Length(fonts) == 0 then
		fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
		fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")

		local x = 1
		for k, v in pairs(fontsList) do
			table.insert(fontPairs, { v, fonts[v] })
			fontPairsByName[fonts[v]] = v
			x = x + 1
		end
	end
end

local backgrounds = {}
local backgroundsList = {}
local backgroundPairs = {}
local backgroundPairsByName = {}
local function FillBackgroundCache()
	if TRB.Functions.Table:Length(backgrounds) == 0 then
		backgrounds = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
		backgroundsList = TRB.Details.addonData.libs.SharedMedia:List("background")

		local x = 1
		for k, v in pairs(backgroundsList) do
			table.insert(backgroundPairs, { v, backgrounds[v] })
			backgroundPairsByName[backgrounds[v]] = v
			x = x + 1
		end
	end
end

local borders = {}
local bordersList = {}
local borderPairs = {}
local borderPairsByName = {}
local function FillBorderCache()
	if TRB.Functions.Table:Length(borders) == 0 then
		borders = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
		bordersList = TRB.Details.addonData.libs.SharedMedia:List("border")

		local x = 1
		for k, v in pairs(bordersList) do
			table.insert(borderPairs, { v, borders[v] })
			borderPairsByName[borders[v]] = v
			x = x + 1
		end
	end
end

local statusbars = {}
local statusbarsList = {}
local statusbarPairs = {}
local statusbarPairsByName = {}
local function FillStatusbarCache()
	if TRB.Functions.Table:Length(statusbars) == 0 then
		statusbars = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
		statusbarsList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")

		local x = 1
		for k, v in pairs(statusbarsList) do
			table.insert(statusbarPairs, { v, statusbars[v] })
			statusbarPairsByName[statusbars[v]] = v
			x = x + 1
		end
	end
end

local function DropdownSetupMenuWrapper(control)
	control:SetupMenu(control.GeneratorFunction)
end

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18
function TRB.Functions.OptionsUi:BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
---@diagnostic disable-next-line: inject-field
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minValue, maxValue)
	f:SetValueStep(stepValue)
	f:SetSize(sizeX-36, sizeY)
	f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
	f:SetOrientation("HORIZONTAL")
	---@diagnostic disable-next-line: missing-fields
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
	---@diagnostic disable-next-line: inject-field
	f.MinLabel = f:CreateFontString(nil, "OVERLAY")
	f.MinLabel:SetFontObject(GameFontHighlightSmall)
	f.MinLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MinLabel:SetWordWrap(false)
	f.MinLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -1)
	f.MinLabel:SetText(minValue)
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
	f.MaxLabel:SetText(maxValue)
	---@diagnostic disable-next-line: inject-field
	f.Title = f:CreateFontString(nil, "OVERLAY")
	f.Title:SetFontObject(GameFontNormal)
	f.Title:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.Title:SetWordWrap(false)
	f.Title:SetPoint("BOTTOM", f, "TOP")
	f.Title:SetText(title)
	---@diagnostic disable-next-line: inject-field
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
	---@diagnostic disable-next-line: missing-fields
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
	---@diagnostic disable-next-line: inject-field
	f.Plus = CreateFrame("Button", nil, f)
	f.Plus:SetSize(18, 18)
	f.Plus:RegisterForClicks("AnyUp")
	f.Plus:SetPoint("LEFT", f, "RIGHT", 0, 0)
	f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Plus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() + f:GetValueStep())
	end)
	---@diagnostic disable-next-line: inject-field
	f.Minus = CreateFrame("Button", nil, f)
	f.Minus:SetSize(18, 18)
	f.Minus:RegisterForClicks("AnyUp")
	f.Minus:SetPoint("RIGHT", f, "LEFT", 0, 0)
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
	---@diagnostic disable-next-line: missing-fields
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
	ColorPickerFrame:SetupColorPickerAndShow({
		swatchFunc = callback,
		opacityFunc = callback,
		cancelFunc = callback,--cancelCallback,
		r = r,
		g = g,
		b = b,
		opacity = 1-a,
		hasOpacity = (a ~= nil)
	})
end

function TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
	local r, g, b, a
	if color then
		r = color.r
		g = color.g
		b = color.b
		a = color.a
	else
		r, g, b = ColorPickerFrame:GetColorRGB()
		a = ColorPickerFrame:GetColorAlpha()
	end
	return r, g, b, a
end

function TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frame, classId, specId)
	if button == "LeftButton" then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorTable[key].color, true)
		TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
			colorControlsTable[key].Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			colorTable[key].color = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
		
			if frame ~= nil then
				if frameType == "backdrop" then
					TRB.Functions.Color:SetBackdropColor(frame, nil, r_1, g_1, b_1, a_1)
				elseif frameType == "border" then
					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, nil, colorTable[key].color)
				elseif frameType == "bar" then
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, nil, colorTable[key].color)
				elseif frameType == "threshold" then
					TRB.Functions.Color:SetThresholdColor(frame, nil, colorTable[key].color, true, classId, specId)
				elseif frameType == "endCap" then
					if classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
						local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
						TRB.Functions.Threshold:ResetEndCap(frame, TRB.Data.specCache[specName].settings, key)
					end
				end
			end
		end)
	end
end

function TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, colorTable, colorControlsTable, key, frameType, frame, classId, specId)
	if button == "LeftButton" then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorTable[key], true)
		TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
			colorControlsTable[key].Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			colorTable[key] = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
		
			if frame ~= nil then
				if frameType == "backdrop" then
					TRB.Functions.Color:SetBackdropColor(frame, nil, r_1, g_1, b_1, a_1)
				elseif frameType == "border" then
					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, nil, colorTable[key])
				elseif frameType == "bar" then
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, nil, colorTable[key])
				elseif frameType == "threshold" then
					TRB.Functions.Color:SetThresholdColor(frame, nil, colorTable[key], true, classId, specId)
				end
			end
		end)
	end
end

function TRB.Functions.OptionsUi:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
	local f = CreateFrame("Button", nil, parent, "BackdropTemplate")
	f:SetSize(sizeFrame, sizeFrame)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, 
		tileSize=4, 
		edgeSize=12
	})
	---@diagnostic disable-next-line: inject-field
	f.Texture = f:CreateTexture(nil)
	f.Texture:ClearAllPoints()
	f.Texture:SetPoint("TOPLEFT", 4, -4)
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4)
	f.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settingsEntry, true))
	f:EnableMouse(true)
	---@diagnostic disable-next-line: inject-field
	f.Font = f:CreateFontString(nil)
	f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0)
	f.Font:SetFontObject(GameFontHighlight)
	f.Font:SetText(description)
	---@diagnostic disable-next-line: redundant-parameter
	f.Font:SetWordWrap(true)
	f.Font:SetJustifyH("LEFT")
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame)
	return f
end

---Builds standard TRB color picker with an optional enable/disable checkbox
---@param parent frame
---@param controls table
---@param controlType string
---@param colorTable table
---@param namePrefix string
---@param value TRB.Classes.OptionsUi.Color
---@param yCoord number
---@return number
---@return table|BackdropTemplate|Button
---@return CheckButton
function TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, controlType, colorTable, namePrefix, value)
	local fCheckbox = nil
	local fColor = nil

	controls.colors[controlType] = controls.colors[controlType] or {}

	yCoord = yCoord - 30
	if value.hasEnabledCheckbox == true then
		fCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_threshold" .. value.name, parent, "ChatConfigCheckButtonTemplate")
		controls.checkBoxes["threshold" .. value.name] = fCheckbox
		fCheckbox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(fCheckbox:GetName() .. 'Text'):SetText(value.enabledCheckboxLocalization)
		fCheckbox.tooltip = value.enabledCheckboxTooltipLocalization
		fCheckbox:SetChecked(colorTable[value.name].enabled)
		fCheckbox:SetScript("OnClick", function(self, ...)
			colorTable[value.name].enabled = self:GetChecked()
		end)
	end

	controls.colors.threshold[value.name] = TRB.Functions.OptionsUi:BuildColorPicker(parent, value.colorLocalization, colorTable[value.name].color, 300, 25, oUi.xCoord2, yCoord)
	fColor = controls.colors.threshold[value.name]

	if value.colorScript ~= nil and type(value.colorScript) == "function" then
		fColor:SetScript("OnMouseDown", value.colorScript(self, button))
	else
		fColor:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, controls.colors[controlType], value.name)
		end)
	end
	
	return yCoord, fColor, fCheckbox
end

function TRB.Functions.OptionsUi:BuildSectionHeader(parent, title, posX, posY)
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(500)
	f:SetHeight(30)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormalLarge)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(500, 30)
	f.font:SetText(title)
	return f
end

function TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset, width, height, height2, justifyH, fontFile)
	height = height or 30
	height2 = height2 or (height * 3)
	justifyH = justifyH or "LEFT"
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetSize(0, 20)
	f.font:SetJustifyH("RIGHT")
	f.font:SetJustifyV("TOP")
	f.font:SetSize(offset, height)
	f.font:SetText(var)

---@diagnostic disable-next-line: inject-field
	f.description = CreateFrame("Frame", nil, parent)
	local fd = f.description
	fd:ClearAllPoints()
	fd:SetPoint("TOPLEFT", parent)
	fd:SetPoint("TOPLEFT", posX+10, posY-height)
	fd:SetWidth(width-5)
	fd:SetHeight(height2)
	---@diagnostic disable-next-line: inject-field
	fd.font = fd:CreateFontString(nil)
	fd.font:SetFontObject(GameFontHighlight)
	
	if fontFile ~= nil then
		fd.font:SetFont(fontFile, 12)
	end

	fd.font:SetPoint("LEFT", fd, "LEFT")
	fd.font:SetSize(0, 16)
	fd.font:SetJustifyH(justifyH)
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
---@diagnostic disable-next-line: param-type-mismatch
	f:SetNormalFontObject("GameFontNormal")
	---@diagnostic disable-next-line: inject-field
	f.ntex = f:CreateTexture()
	f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.ntex:SetAllPoints()
	f:SetNormalTexture(f.ntex)
	---@diagnostic disable-next-line: inject-field
	f.htex = f:CreateTexture()
	f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.htex:SetAllPoints()
	f:SetHighlightTexture(f.htex)
	---@diagnostic disable-next-line: inject-field
	f.ptex = f:CreateTexture()
	f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
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
	---@diagnostic disable-next-line: inject-field
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
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = scrollChild
	else
		---@diagnostic disable-next-line: inject-field
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
		---@diagnostic disable-next-line: inject-field
		cf.scrollFrame = TRB.Functions.OptionsUi:CreateScrollFrameContainer(name .. "ScrollFrame", cf, width - 30, height - 8)
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
	local tab = CreateFrame("Button", name, parent, "PanelTopTabButtonTemplate")
	---@diagnostic disable-next-line: inject-field
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

function TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(classId, specId)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local tab = _G["TwintopResourceBar_Options_" .. namePrefix .. "_Tab5"]
	TRB.Functions.OptionsUi:SwitchTab(tab, tab.id)
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
	
---@diagnostic disable-next-line: inject-field
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
		local vs = self:GetParent():GetVerticalScroll()
		local h  = self:GetParent():GetHeight()
	
		if vs+arg2 > 0 or 0 > vs+arg2-arg4+h then
			self:GetParent():SetVerticalScroll(arg2*-1)
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

function TRB.Functions.OptionsUi:CreateLsmDropdown(parent, dropDowns, section, classId, specId, xCoord, yCoord, lsmType, varName, sectionHeaderText, dropdownInfoText, setSelectedFunc)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	
	local lsmPairs
	local lsmPairsByName

	if lsmType == "statusbar" then
		FillStatusbarCache()
		lsmPairs = statusbarPairs
		lsmPairsByName = statusbarPairs
	elseif lsmType == "background" then
		FillBackgroundCache()
		lsmPairs = backgroundPairs
		lsmPairsByName = backgroundPairs
	elseif lsmType == "border" then
		FillBorderCache()
		lsmPairs = borderPairs
		lsmPairsByName = borderPairs
	end

	dropDowns[varName] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. varName .. "_" .. lsmType, parent, "WowStyle1DropdownTemplate")
	dropDowns[varName]:SetWidth(oUi.sliderWidth)
	dropDowns[varName].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, sectionHeaderText, xCoord, yCoord)
	dropDowns[varName].label.font:SetFontObject(GameFontNormal)
	dropDowns[varName].varName = varName
	dropDowns[varName].lsmPairs = lsmPairs
	dropDowns[varName].lsmPairsByName = lsmPairsByName

	local function IsSelected(value)
		return value == section[varName]
	end

	local function Generator(dropdown, rootDescription)
		for k, v in pairs(lsmPairs) do
			local radio = rootDescription:CreateRadio(v[1], IsSelected, setSelectedFunc, v[2])
			radio:AddInitializer(function(button, description, menu)
				local rightTexture = button:AttachTexture()
				rightTexture:SetSize(1, 18)
				rightTexture:SetPoint("RIGHT")
				local fontString = button.fontString

				local bgTexture = button:AttachTexture()
				bgTexture:SetTexture(v[2])
				bgTexture:SetPoint("LEFT", button.fontString, "LEFT")
				bgTexture:SetPoint("RIGHT", rightTexture, "LEFT")
				bgTexture:SetSize(button.fontString:GetUnboundedStringWidth(), 16)

				-- Manual calculation required to accomodate aligned text.
				local pad = 0
				local width = pad + fontString:GetUnboundedStringWidth() + rightTexture:GetWidth()
				local height = 20
				return width, height
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	dropDowns[varName].GeneratorFunction = Generator
	dropDowns[varName]:SetupMenu(Generator)
	dropDowns[varName]:SetPoint("TOPLEFT", xCoord, yCoord-30)
end

function TRB.Functions.OptionsUi:ToggleCheckboxEnabled(checkbox, enable)
	if enable then
		checkbox:Enable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 1, 1)
	else
		checkbox:Disable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
	end
end

function TRB.Functions.OptionsUi:ToggleCheckboxOnOff(checkbox, enable, changeText)
	if enable then
		getglobal(checkbox:GetName().."Text"):SetTextColor(0, 1, 0)

		if changeText == true then
			getglobal(checkbox:GetName().."Text"):SetText(L["Enabled"])
		end
	else
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 0, 0)
		
		if changeText == true then
			getglobal(checkbox:GetName().."Text"):SetText(L["Disabled"])
		end
	end
end

local function AdjustBarBorder()
	local specCacheEntry = TRB.Data.specCache[TRB.Data.character.specName].settings
	TRB.Frames.barContainerFrame:SetWidth(specCacheEntry.bar.width - (specCacheEntry.bar.border * 2))
	TRB.Frames.barContainerFrame:SetHeight(specCacheEntry.bar.height - (specCacheEntry.bar.border * 2))
	TRB.Frames.barBorderFrame:SetWidth(specCacheEntry.bar.width)
	TRB.Frames.barBorderFrame:SetHeight(specCacheEntry.bar.height)
	if specCacheEntry.bar.border < 1 then
		TRB.Frames.barBorderFrame:SetBackdrop({
			edgeFile = specCacheEntry.textures.border,
			tile = true,
			tileSize = 4,
			edgeSize = 1,
			insets = {0, 0, 0, 0}
		})
		TRB.Frames.barBorderFrame:Hide()
	else
		TRB.Frames.barBorderFrame:SetBackdrop({
			edgeFile = specCacheEntry.textures.border,
			tile = true,
			tileSize = 4,
			edgeSize = specCacheEntry.bar.border,
			insets = {0, 0, 0, 0}
		})
		TRB.Frames.barBorderFrame:Show()
	end
	TRB.Frames.barBorderFrame:SetBackdropColor(0, 0, 0, 0)
	TRB.Frames.barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specCacheEntry.colors.bar.border, true))

	TRB.Functions.Bar:SetMinMax(specCacheEntry)
	TRB.Functions.Bar:SetHeight(specCacheEntry)
	TRB.Functions.Bar:SetPosition(specCacheEntry, TRB.Frames.barContainerFrame)
	TRB.Functions.Bar:SetMinMax(specCacheEntry)
end

function TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil	
	local title = ""

	local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	controls.barPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarPositionSize"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalBarDimensions = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_barDimensions", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalBarDimensions
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_BarDimensions"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].bar)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].bar = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)

			TRB.Functions.Bar:SetHeight(TRB.Data.specCache[specName].settings)
			TRB.Functions.Bar:SetWidth(TRB.Data.specCache[specName].settings)
			
			TRB.Frames.barContainerFrame:ClearAllPoints()
			TRB.Frames.barContainerFrame:SetPoint("CENTER", UIParent)
			TRB.Frames.barContainerFrame:SetPoint("CENTER", TRB.Data.specCache[specName].settings.bar.xPos, TRB.Data.specCache[specName].settings.bar.yPos)
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[specName].settings, TRB.Frames.barContainerFrame)
			
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[specName].settings)

			AdjustBarBorder()
		end)
	end

	yCoord = yCoord - 40
	title = L["BarWidth"]
	controls.width = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.width:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.width = value

		local maxBorderSize = math.min(math.floor((spec.bar.height) / TRB.Data.constants.borderWidthFactor), math.floor((spec.bar.width) / TRB.Data.constants.borderWidthFactor))-1
		local borderSize = math.min(maxBorderSize, spec.bar.border)
		controls.borderWidth:SetValue(borderSize)
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(tostring(maxBorderSize))

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetWidth(TRB.Data.specCache[TRB.Data.character.specName].settings)
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[TRB.Data.character.specName].settings)
		end
	end)

	title = L["BarHeight"]
	controls.height = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.height:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.height = value

		local maxBorderSize = math.max(math.min(math.floor((spec.bar.height) / TRB.Data.constants.borderWidthFactor), math.floor((spec.bar.width) / TRB.Data.constants.borderWidthFactor))-1, 0)
		local borderSize = math.min(maxBorderSize, spec.bar.border)

		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(tostring(maxBorderSize))
		controls.borderWidth.EditBox:SetText(tostring(borderSize))

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetHeight(TRB.Data.specCache[TRB.Data.character.specName].settings)
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end)

	title = L["BarHorizontalPosition"]
	yCoord = yCoord - 60
	controls.horizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.bar.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.xPos = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Frames.barContainerFrame:ClearAllPoints()
			TRB.Frames.barContainerFrame:SetPoint("CENTER", UIParent)
			TRB.Frames.barContainerFrame:SetPoint("CENTER", TRB.Data.specCache[TRB.Data.character.specName].settings.bar.xPos, TRB.Data.specCache[TRB.Data.character.specName].settings.bar.yPos)
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end)

	title = L["BarVerticalPosition"]
	controls.vertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.bar.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.yPos = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Frames.barContainerFrame:ClearAllPoints()
			TRB.Frames.barContainerFrame:SetPoint("CENTER", UIParent)
			TRB.Frames.barContainerFrame:SetPoint("CENTER", TRB.Data.specCache[TRB.Data.character.specName].settings.bar.xPos, TRB.Data.specCache[TRB.Data.character.specName].settings.bar.yPos)
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end)

	title = L["BarBorderWidth"]
	yCoord = yCoord - 60
	controls.borderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.borderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.border = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			AdjustBarBorder()
		end

		local minsliderWidth = math.max((spec.bar.border)*2+1, 120)
		local minsliderHeight = math.max((spec.bar.border)*2+1, 1)

		local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
		controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
		controls.height.MinLabel:SetText(tostring(minsliderHeight))
		controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
		controls.width.MinLabel:SetText(tostring(minsliderWidth))
	end)

	--NOTE: the order of these checkboxes is reversed!

	controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.lockPosition
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText(L["DragAndDropEnabled"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["DragAndDropTooltip"]
	f:SetChecked(spec.bar.dragAndDrop)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.dragAndDrop = self:GetChecked()

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			--TRB.Frames.barContainerFrame:SetMovable((not TRB.Data.specCache[TRB.Data.character.specName].settings.bar.pinToPersonalResourceDisplay) and TRB.Data.specCache[TRB.Data.character.specName].settings.bar.dragAndDrop)
			--TRB.Frames.barContainerFrame:EnableMouse((not TRB.Data.specCache[TRB.Data.character.specName].settings.bar.pinToPersonalResourceDisplay) and TRB.Data.specCache[TRB.Data.character.specName].settings.bar.dragAndDrop)
			TRB.Frames.barContainerFrame:SetMovable(TRB.Data.specCache[TRB.Data.character.specName].settings.bar.dragAndDrop)
			TRB.Frames.barContainerFrame:EnableMouse(TRB.Data.specCache[TRB.Data.character.specName].settings.bar.dragAndDrop)
		end
	end)

	--[[
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

	controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.pinToPRD
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PinToPRDEnabled"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["PinToPRDTooltip"]
	f:SetChecked(spec.bar.pinToPersonalResourceDisplay)
	f:SetScript("OnClick", function(self, ...)
		spec.bar.pinToPersonalResourceDisplay = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not spec.bar.pinToPersonalResourceDisplay)

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:UpdateSmoothBar()
			TRB.Frames.barContainerFrame:SetMovable((not TRB.Data.specCache[TRB.Data.character.specName].settings.bar.pinToPersonalResourceDisplay) and TRB.Data.specCache[TRB.Data.character.specName].settings.bar.dragAndDrop)
			TRB.Frames.barContainerFrame:EnableMouse((not TRB.Data.specCache[TRB.Data.character.specName].settings.bar.pinToPersonalResourceDisplay) and TRB.Data.specCache[TRB.Data.character.specName].settings.bar.dragAndDrop)
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end)
	]]

	yCoord = yCoord - 30

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, secondaryResourceString)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceEnergy"]
	end
	
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil

	local title = ""

	local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	controls.comboPointPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["SecondaryPositionAndSize"], secondaryResourceString), oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalComboPoints = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_comboPoints", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalComboPoints
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ComboPoints"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].comboPoints)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].comboPoints = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)

			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[specName].settings)
		end)
	end

	yCoord = yCoord - 40
	title = string.format(L["SecondaryWidth"], secondaryResourceString)
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

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[TRB.Data.character.specName].settings)
		end
	end)

	title = string.format(L["SecondaryHeight"], secondaryResourceString)
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

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[TRB.Data.character.specName].settings)
		end
	end)

	title = string.format(L["SecondaryHorizontalPosition"], secondaryResourceString)
	yCoord = yCoord - 60
	controls.comboPointHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.comboPoints.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.comboPointHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.comboPoints.xPos = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end)

	title = string.format(L["SecondaryVerticalPosition"], secondaryResourceString)
	controls.comboPointVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.comboPoints.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.comboPointVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.comboPoints.yPos = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end)

	title = string.format(L["SecondaryBorderWidth"], secondaryResourceString)
	yCoord = yCoord - 60
	controls.comboPointBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec.comboPoints.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.comboPointBorderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.comboPoints.border = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[TRB.Data.character.specName].settings)
		end

		local minsliderWidth = math.max(spec.comboPoints.border*2, 1)
		local minsliderHeight = math.max(spec.comboPoints.border*2, 1)

		local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
		controls.comboPointHeight:SetMinMaxValues(minsliderHeight, scValues.comboPointsMaxHeight)
		controls.comboPointHeight.MinLabel:SetText(tostring(minsliderHeight))
		controls.comboPointWidth:SetMinMaxValues(minsliderWidth, scValues.comboPointsMaxWidth)
		controls.comboPointWidth.MinLabel:SetText(tostring(minsliderWidth))
	end)

	title = secondaryResourceString .. " Spacing"
	controls.comboPointSpacing = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.spacing, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.comboPoints.spacing = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[TRB.Data.character.specName].settings)
		end
	end)

	yCoord = yCoord - 40

	local comboPointsRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_comboPointsRelativeTo", parent, "WowStyle1DropdownTemplate")
	comboPointsRelativeTo:SetWidth(oUi.sliderWidth)
	comboPointsRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["SecondaryRelativeTo"], secondaryResourceString, primaryResourceString), oUi.xCoord, yCoord)
	comboPointsRelativeTo.label.font:SetFontObject(GameFontNormal)
	
	local relativeTo = {}
	relativeTo[L["PositionAboveLeft"]] = "TOPLEFT"
	relativeTo[L["PositionAboveMiddle"]] = "TOP"
	relativeTo[L["PositionAboveRight"]] = "TOPRIGHT"
	relativeTo[L["PositionBelowLeft"]] = "BOTTOMLEFT"
	relativeTo[L["PositionBelowMiddle"]] = "BOTTOM"
	relativeTo[L["PositionBelowRight"]] = "BOTTOMRIGHT"
	local relativeToList = {
		L["PositionAboveLeft"],
		L["PositionAboveMiddle"],
		L["PositionAboveRight"],
		L["PositionBelowLeft"],
		L["PositionBelowMiddle"],
		L["PositionBelowRight"]
	}

	local function RelativeToIsSelected(value)
		return value == spec.comboPoints.relativeTo
	end
	
	local function RelativeToSetSelected(newValue)
		spec.comboPoints.relativeTo = newValue
		
		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec.comboPoints.relativeToName = k
			end
		end
		comboPointsRelativeTo:SetDefaultText(spec.comboPoints.relativeToName)

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	comboPointsRelativeTo:SetupMenu(RelativeToGenerator)
	comboPointsRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		
	controls.checkBoxes.comboPointsFullWidth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_comboPointsFullWidth", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.comboPointsFullWidth
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["SecondaryFullBarWidth"], secondaryResourceString))
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format(L["SecondaryFullBarWidthTooltip"], secondaryResourceString, secondaryResourceString, secondaryResourceString)
	f:SetChecked(spec.comboPoints.fullWidth)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.fullWidth = self:GetChecked()
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			TRB.Functions.Bar:SetPosition(TRB.Data.specCache[TRB.Data.character.specName].settings, TRB.Frames.barContainerFrame)
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[TRB.Data.character.specName].settings)
		end
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(controls, textures, newValue, variable, includeComboPoints)
	local newName = statusbarPairsByName[newValue]
	if includeComboPoints == nil then
		includeComboPoints = false
	end

	textures[variable.."Bar"] = newValue
	textures[variable.."BarName"] = newName
	DropdownSetupMenuWrapper(controls[variable.."Bar"])
	if textures.textureLock then
		textures.resourceBar = newValue
		textures.resourceBarName = newName
		DropdownSetupMenuWrapper(controls.resourceBar)
		textures.castingBar = newValue
		textures.castingBarName = newName
		DropdownSetupMenuWrapper(controls.castingBar)
		textures.passiveBar = newValue
		textures.passiveBarName = newName
		DropdownSetupMenuWrapper(controls.passiveBar)

		if includeComboPoints then
			textures.comboPointsBar = newValue
			textures.comboPointsBarName = newName
			DropdownSetupMenuWrapper(controls.comboPointsBar)
		end
	end
	
	TRB.Functions.Character:ResetCaches()
	TRB.Functions.Bar:Construct()
end

function TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, yCoord, includeComboPoints, secondaryResourceString)
	if includeComboPoints == nil then
		includeComboPoints = false
	end
	
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	
	if includeComboPoints then
		controls.textBarTexturesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["BarAndSecondardTexturesHeader"], secondaryResourceString), oUi.xCoord, yCoord)
	else
		controls.textBarTexturesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarTexturesHeader"], oUi.xCoord, yCoord)
	end
	
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalTextures = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_textures", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalTextures
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_Textures"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textures)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].textures = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Bar:Construct()
		end)
	end
	
	controls.dropDown.textures = {}

	yCoord = yCoord - 30

	local function StatusbarSetValue(variable, newValue)
		TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(controls.dropDown.textures, spec.textures, newValue, variable, includeComboPoints)
	end

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "resourceBar", L["MainBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("resource", newValue)
		end)
	--[[
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "castingBar", L["CastingBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("casting", newValue)
		end)

	yCoord = yCoord - 60
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "passiveBar", L["PassiveBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("passive", newValue)
		end)]]

	if includeComboPoints then
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "comboPointsBar", string.format(L["SecondaryBarTexture"], secondaryResourceString), L["StatusBarTextures"],
			function(newValue)
				StatusbarSetValue("comboPoints", newValue)
			end)
	--end	
		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_TextureLock", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		f:SetChecked(spec.textures.textureLock)
		getglobal(f:GetName() .. 'Text'):SetText(L["UseSameTexture"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["UseSameTextureTooltip"]

		f:SetScript("OnClick", function(self, ...)
			spec.textures.textureLock = self:GetChecked()
			if spec.textures.textureLock then
				spec.textures.passiveBar = spec.textures.resourceBar
				spec.textures.passiveBarName = spec.textures.resourceBarName
				--DropdownSetupMenuWrapper(controls.dropDown.textures.passiveBar)
				spec.textures.castingBar = spec.textures.resourceBar
				spec.textures.castingBarName = spec.textures.resourceBarName
				--DropdownSetupMenuWrapper(controls.dropDown.textures.castingBar)

				if includeComboPoints then
					spec.textures.comboPointsBar = spec.textures.resourceBar
					spec.textures.comboPointsBarName = spec.textures.resourceBarName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBar)
					spec.textures.comboPointsBorder = spec.textures.border
					spec.textures.comboPointsBorderName = spec.textures.borderName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
					spec.textures.comboPointsBackground = spec.textures.background
					spec.textures.comboPointsBackgroundName = spec.textures.backgroundName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
				end

				TRB.Functions.Character:ResetCaches()
				TRB.Functions.Bar:Construct()
			end
		end)
	end

	yCoord = yCoord - 60

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "border", "border", L["BorderTexture"], L["BorderTextures"],
		function(newValue)
			local newName = borderPairsByName[newValue]
			spec.textures.border = newValue
			spec.textures.borderName = newName
			DropdownSetupMenuWrapper(controls.dropDown.textures.border)
	
			if includeComboPoints and spec.textures.textureLock then
				spec.textures.comboPointsBorder = newValue
				spec.textures.comboPointsBorderName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
			end

			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Bar:Construct()
		end)
	
	
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "background", "background", L["BackgroundTexture"], L["BackgroundTextures"],
	-- Implement the function to change the texture
		function (newValue)
			local newName = backgroundPairsByName[newValue]
			spec.textures.background = newValue
			spec.textures.backgroundName = newName
			DropdownSetupMenuWrapper(controls.dropDown.textures.background)
			
			if includeComboPoints and spec.textures.textureLock then
				spec.textures.comboPointsBackground = newValue
				spec.textures.comboPointsBackgroundName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
			end
			
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Bar:Construct()
		end)

	if includeComboPoints then
		yCoord = yCoord - 60
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "border", "comboPointsBorder", string.format(L["SecondaryBorderTexture"], secondaryResourceString), L["BorderTextures"],
			function (newValue)
				local newName = borderPairsByName[newValue]
				spec.textures.comboPointsBorder = newValue
				spec.textures.comboPointsBorderName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)

				if spec.textures.textureLock then
					spec.textures.border = newValue
					spec.textures.borderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.border)
				end
				
				TRB.Functions.Character:ResetCaches()
				TRB.Functions.Bar:Construct()
			end)

		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "background", "comboPointsBackground", string.format(L["SecondaryBackgroundTexture"], secondaryResourceString), L["BackgroundTextures"],
			function (newValue)
				local newName = backgroundPairsByName[newValue]
				spec.textures.comboPointsBackground = newValue
				spec.textures.comboPointsBackgroundName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
				
				if spec.textures.textureLock then
					spec.textures.background = newValue
					spec.textures.backgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.background)
				end
				
				TRB.Functions.Character:ResetCaches()
				TRB.Functions.Bar:Construct()
			end)

		yCoord = yCoord - 60
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["TextureLock"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["TextureLockTooltip"]
	else
		yCoord = yCoord - 30
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, showWhenCategory, includeFlashAlpha, flashAlphaName, flashAlphaNameShort)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.barDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayHeader"], oUi.xCoord, yCoord)

	if includeFlashAlpha then
		yCoord = yCoord - 50
		title = string.format(L["FlashAlpha"], flashAlphaName)
		controls.flashAlpha = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.colors.bar.flashAlpha = value
		end)

		title = string.format(L["FlashPeriod"], flashAlphaName)
		controls.flashPeriod = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.05, 2, spec.colors.bar.flashPeriod, 0.05, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.colors.bar.flashPeriod = value
		end)
	end

	yCoord = yCoord - 40

	controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_AlwaysShow", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.alwaysShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowBarAlways"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
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

	controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_NotZeroShow", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.notZeroShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)

	if showWhenCategory == "notFull" then
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["ShowBarNotZeroNotFull"], primaryResourceString))
	elseif showWhenCategory == "balance" then
		getglobal(f:GetName() .. 'Text'):SetText(L["ShowBarNotZeroBalance"])
	else
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["ShowBarNotZero"], primaryResourceString))
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

	controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_CombatShow", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.combatShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowBarCombat"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
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

	controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_NeverShow", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.neverShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-45)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowBarNever"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
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

	if includeFlashAlpha then
		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_FlashEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["FlashBar"], flashAlphaNameShort))
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["FlashBarTooltip"], flashAlphaName)
		f:SetChecked(spec.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.flashEnabled = self:GetChecked()
		end)
		yCoord2 = yCoord2-20
	end

	--[[
	controls.checkBoxes.dragonridingEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_DragonridingEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dragonridingEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-70)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["ShowBarDragonriding"], flashAlphaNameShort))
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format(L["ShowBarDragonridingTooltip"], flashAlphaName)
	f:SetChecked(spec.displayBar.dragonriding)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.dragonriding = self:GetChecked()
	end)
	]]

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
	
	yCoord = yCoord - 30
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinePositionHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdIcons = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdIcons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdIcons
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdIcons"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, isHealer)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
		end)
	end
	
	yCoord = yCoord - 20
	local thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconRelativeTo", parent, "WowStyle1DropdownTemplate")
	thresholdIconRelativeTo:SetWidth(oUi.sliderWidth)
	thresholdIconRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdIconRelativePosition"], oUi.xCoord, yCoord)
	thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)

	local relativeTo = {}
	relativeTo[L["PositionAbove"]] = "TOP"
	relativeTo[L["PositionMiddle"]] = "CENTER"
	relativeTo[L["PositionBelow"]] = "BOTTOM"
	local relativeToList = {
		L["PositionAbove"],
		L["PositionMiddle"],
		L["PositionBelow"]
	}

	local function RelativeToIsSelected(value)
		return value == spec.thresholds.icons.relativeTo
	end
	
	local function RelativeToSetSelected(newValue)
		spec.thresholds.icons.relativeTo = newValue
		
		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec.thresholds.icons.relativeToName = k
				break
			end
		end
		thresholdIconRelativeTo:SetDefaultText(spec.thresholds.icons.relativeToName)

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	thresholdIconRelativeTo:SetupMenu(RelativeToGenerator)
	thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShow"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconShowTooltip"]
	f:SetChecked(spec.thresholds.icons.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.enabled = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconDesaturated
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconDesaturate"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconDesaturateTooltip"]
	f:SetChecked(spec.thresholds.icons.desaturated)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.desaturated = self:GetChecked()
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

	yCoord = yCoord - 100
	title = L["ThresholdIconWidth"]
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
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconHeight"]
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
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)


	title = L["ThresholdIconHorizontal"]
	yCoord = yCoord - 60
	controls.thresholdIconHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.xPos = value
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconVertical"]
	controls.thresholdIconVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.yPos = value
		
		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

	title = L["ThresholdIconBorderWidth"]
	yCoord = yCoord - 60
	controls.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.border = value

		local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
		local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

		controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
		controls.thresholdIconHeight.MinLabel:SetText(tostring(minsliderHeight))
		controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
		controls.thresholdIconWidth.MinLabel:SetText(tostring(minsliderWidth))

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdLineWidth"]
	controls.thresholdWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.thresholds.properties.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.properties.width = value

		if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)
	
	yCoord = yCoord - 40
	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.properties.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.properties.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines()
	end)

	return yCoord
end

---comment
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer?
---@param specId integer?
---@param yCoord number
---@param localizationResource string
---@param under boolean?
---@param over boolean?
---@param unusable boolean?
---@param outOfRange boolean?
---@param custom TRB.Classes.OptionsUi.Color[]?
---@return number
function TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, classId, specId, yCoord, localizationResource, under, over, unusable, outOfRange, custom)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	
	controls.colors.threshold = controls.colors.threshold or {}

	if classId == nill then
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsForDpsAndTanksHeader"], oUi.xCoord, yCoord)
	else
		yCoord = yCoord - 30
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)
	end
	
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
		end)
	end

	if under == true then
		yCoord = yCoord - 30
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], localizationResource), spec.colors.threshold.under.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)
	end

	if over == true then
		yCoord = yCoord - 30
		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], localizationResource), spec.colors.threshold.over.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)
	end

	if unusable == true then
		yCoord = yCoord - 30
		--[[
		controls.checkBoxes.thresholdUnusable = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdUnusable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdUnusable
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord+10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdUnusableShowCheckbox"])
		f.tooltip = L["ThresholdUnusableShowCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.unusable.show)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.unusable.show = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdUnusableColorEnabled, spec.colors.threshold.unusable.show)
		end)

		controls.checkBoxes.thresholdUnusableColorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdUnusableColorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdUnusableColorEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdUnusableCheckbox"])
		f.tooltip = L["ThresholdUnusableCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.unusable.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.unusable.enabled = self:GetChecked()
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdUnusableColorEnabled, spec.colors.threshold.unusable.show)]]

		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnusable"], spec.colors.threshold.unusable.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)
	end

	if outOfRange == true then
		yCoord = yCoord - 30
		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord+10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeShowCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeShowCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.show)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.show = self:GetChecked()

			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		controls.checkBoxes.thresholdOutOfRangeColorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRangeColorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRangeColorEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.enabled = self:GetChecked()
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or (classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)
	end

	if custom ~= nil and #custom > 0 then
		for _, value in pairs(custom) do
			yCoord, _, _ = TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, "threshold", spec.colors.threshold, namePrefix, value)
		end
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	yCoord = yCoord - 30
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PotionCooldownConfigurationHeader"], oUi.xCoord, yCoord)
	
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdPotions = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdPotions", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdPotions
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdPotions"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdPotions)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdPotions = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, true)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
		end)
	end

	yCoord = yCoord - 30
	controls.checkBoxes.potionCooldown = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_PotionCooldown_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.potionCooldown
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PotionThresholdShow"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["PotionThresholdShowTooltip"]
	f:SetChecked(spec.thresholds.potionCooldown.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.potionCooldown.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.potionCooldownModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_PotionCooldown_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.potionCooldownModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PotionThresholdShowGCDs"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.thresholds.potionCooldown.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.potionCooldownModeGCDs:SetChecked(true)
		controls.checkBoxes.potionCooldownModeTime:SetChecked(false)
		spec.thresholds.potionCooldown.mode = "gcd"
	end)

	title = L["PotionThresholdShowGCDsSlider"]
	controls.potionCooldownGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 400, spec.thresholds.potionCooldown.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.potionCooldownGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.potionCooldown.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.potionCooldownModeTime = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_PotionCooldown_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.potionCooldownModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PotionThresholdShowTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.thresholds.potionCooldown.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.potionCooldownModeGCDs:SetChecked(false)
		controls.checkBoxes.potionCooldownModeTime:SetChecked(true)
		spec.thresholds.potionCooldown.mode = "time"
	end)

	title = L["PotionThresholdShowTimeSlider"]
	controls.potionCooldownTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 300, spec.thresholds.potionCooldown.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.potionCooldownTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.thresholds.potionCooldown.timeMax = value
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local thresholdDictionary = spec.thresholds.thresholdDictionary
	local thresholdColor = spec.colors.threshold

	if classId == nil and specId == nil then
		controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesForHealersHeader"], oUi.xCoord, yCoord)
		thresholdDictionary = spec.thresholds.thresholdDictionaryHealers
		thresholdColor = spec.colors.thresholdHealers
	else
		controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)
	end
	
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdHealers = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdHealers", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdHealers
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdHealers"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdHealers)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdHealers = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, true)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
		end)
	end

	controls.colors.threshold = controls.colors.threshold or {}

	yCoord = yCoord - 30
	
	local yCoord2 = yCoord

	controls.labels.thresholdPotions = TRB.Functions.OptionsUi:BuildLabel(parent, L["AlgariManaPotion"], 5, yCoord, 300, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.algariManaPotionRank3ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_algariManaPotionRank3", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.algariManaPotionRank3ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 8, -8) .. L["AlgariManaPotionRank3"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["AlgariManaPotion"], CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 0, -8), L["AlgariManaPotionRank3"])
	f:SetChecked(thresholdDictionary.algariManaPotionRank3.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.algariManaPotionRank3.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.algariManaPotionRank2ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_algariManaPotionRank2", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.algariManaPotionRank2ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 8, -8) .. L["AlgariManaPotionRank2"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["AlgariManaPotion"], CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 0, -8), L["AlgariManaPotionRank2"])
	f:SetChecked(thresholdDictionary.algariManaPotionRank2.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.algariManaPotionRank2.enabled = self:GetChecked()
	end)
	yCoord = yCoord - 25

	controls.checkBoxes.algariManaPotionRank1ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_algariManaPotionRank1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.algariManaPotionRank1ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 8, -8) .. L["AlgariManaPotionRank1"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["AlgariManaPotion"], CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 0, -8), L["AlgariManaPotionRank1"])
	f:SetChecked(thresholdDictionary.algariManaPotionRank1.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.algariManaPotionRank1.enabled = self:GetChecked()
	end)
	yCoord = yCoord - 25

	controls.labels.thresholdPotions = TRB.Functions.OptionsUi:BuildLabel(parent, L["CavedwellersDelight"], 5, yCoord, 300, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.cavedwellersDelightRank3ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_cavedwellersDelightRank3", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cavedwellersDelightRank3ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 8, -8) .. L["CavedwellersDelightRank3"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["CavedwellersDelight"], CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 0, -8), L["CavedwellersDelightRank3"])
	f:SetChecked(thresholdDictionary.cavedwellersDelightRank3.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.cavedwellersDelightRank3.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cavedwellersDelightRank2ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_cavedwellersDelightRank2", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cavedwellersDelightRank2ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 8, -8) .. L["CavedwellersDelightRank2"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["CavedwellersDelight"], CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 0, -8), L["CavedwellersDelightRank2"])
	f:SetChecked(thresholdDictionary.cavedwellersDelightRank2.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.cavedwellersDelightRank2.enabled = self:GetChecked()
	end)
	yCoord = yCoord - 25

	controls.checkBoxes.cavedwellersDelightRank1ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_cavedwellersDelightRank1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cavedwellersDelightRank1ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 8, -8) .. L["CavedwellersDelightRank1"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["CavedwellersDelight"], CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 0, -8), L["CavedwellersDelightRank1"])
	f:SetChecked(thresholdDictionary.cavedwellersDelightRank1.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.cavedwellersDelightRank1.enabled = self:GetChecked()
	end)

	controls.labels.slumberingSoulSerum = TRB.Functions.OptionsUi:BuildLabel(parent, L["SlumberingSoulSerum"], oUi.xCoord2, yCoord2, 300, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.slumberingSoulSerumRank3ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_slumberingSoulSerumRank3", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.slumberingSoulSerumRank3ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 8, -8) .. L["SlumberingSoulSerumRank3"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["SlumberingSoulSerum"], CreateAtlasMarkup("Professions-Icon-Quality-Tier3-Inv", 40, 32, 0, -8), L["SlumberingSoulSerumRank3"])
	f:SetChecked(thresholdDictionary.slumberingSoulSerumRank3.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.slumberingSoulSerumRank3.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.slumberingSoulSerumRank2ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_slumberingSoulSerumRank2", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.slumberingSoulSerumRank2ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 8, -8) .. L["SlumberingSoulSerumRank2"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["SlumberingSoulSerum"], CreateAtlasMarkup("Professions-Icon-Quality-Tier2-Inv", 40, 32, 0, -8), L["SlumberingSoulSerumRank2"])
	f:SetChecked(thresholdDictionary.slumberingSoulSerumRank2.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.slumberingSoulSerumRank2.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.slumberingSoulSerumRank1ThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_slumberingSoulSerumRank1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.slumberingSoulSerumRank1ThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 8, -8) .. L["SlumberingSoulSerumRank1"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format("%s %s %s (%s)", L["ThresholdHealerPotionTooltipBase"], L["SlumberingSoulSerum"], CreateAtlasMarkup("Professions-Icon-Quality-Tier1-Inv", 40, 32, 0, -8), L["SlumberingSoulSerumRank1"])
	f:SetChecked(thresholdDictionary.slumberingSoulSerumRank1.enabled)
	f:SetScript("OnClick", function(self, ...)
		thresholdDictionary.slumberingSoulSerumRank1.enabled = self:GetChecked()
	end)

	--controls.labels.thresholdItems = TRB.Functions.OptionsUi:BuildLabel(parent, L["Items"], oUi.xCoord2, yCoord2, 300, 20)

	if classId == 5 or classId == 10 then -- Priest or Monk
		yCoord = yCoord - 30
		controls.labels.thresholdAbilities = TRB.Functions.OptionsUi:BuildLabel(parent, L["Abilities"], 5, yCoord, 300, 20)
		
		if classId == 5 then
			--NOTE: the order of these checkboxes is reversed!
			yCoord = yCoord - 20
			controls.checkBoxes.shadowfiendThresholdShowCooldown = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_shadowfiend_cooldown", parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes.shadowfiendThresholdShowCooldown
			f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord-20)
			getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdShowWhileOnCooldown"])
			---@diagnostic disable-next-line: inject-field
			f.tooltip = string.format(L["ThresholdHealerShowWhileOnCooldownTooltipWithAbility"], L["Shadowfiend"])
			f:SetChecked(thresholdDictionary.shadowfiend.cooldown)
			f:SetScript("OnClick", function(self, ...)
				thresholdDictionary.shadowfiend.cooldown = self:GetChecked()
				if thresholdDictionary.mindbender ~= nil then
					thresholdDictionary.mindbender.cooldown = self:GetChecked()
				end
				if thresholdDictionary.voidwraith ~= nil then
					thresholdDictionary.voidwraith.cooldown = self:GetChecked()
				end
			end)
			
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.shadowfiendThresholdShowCooldown, thresholdDictionary.shadowfiend.enabled)
			
			controls.checkBoxes.shadowfiendThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_shadowfiend", parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes.shadowfiendThresholdShow
			f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(f:GetName() .. 'Text'):SetText(L["Shadowfiend"])
			---@diagnostic disable-next-line: inject-field
			f.tooltip = string.format(L["ThresholdHealerToggleAbility"], L["Shadowfiend"])
			f:SetChecked(thresholdDictionary.shadowfiend.enabled)
			f:SetScript("OnClick", function(self, ...)
				thresholdDictionary.shadowfiend.enabled = self:GetChecked()
				if thresholdDictionary.mindbender ~= nil then
					thresholdDictionary.mindbender.enabled = self:GetChecked()
				end
				if thresholdDictionary.voidwraith ~= nil then
					thresholdDictionary.voidwraith.enabled = self:GetChecked()
				end
				TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.shadowfiendThresholdShowCooldown, thresholdDictionary.shadowfiend.enabled)
			end)
			yCoord = yCoord - 20

			if specId == 2 then
				--NOTE: the order of these checkboxes is reversed!
				yCoord = yCoord - 25
				controls.checkBoxes.symbolOfHopeThresholdShowCooldown = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_symbolOfHope_cooldown", parent, "ChatConfigCheckButtonTemplate")
				f = controls.checkBoxes.symbolOfHopeThresholdShowCooldown
				f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord-20)
				getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdShowWhileOnCooldown"])
				---@diagnostic disable-next-line: inject-field
				f.tooltip = string.format(L["ThresholdHealerShowWhileOnCooldownTooltipWithAbility"], L["SymbolOfHope"])
				f:SetChecked(thresholdDictionary.symbolOfHope.cooldown)
				f:SetScript("OnClick", function(self, ...)
					thresholdDictionary.symbolOfHope.cooldown = self:GetChecked()
				end)
				
				TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.symbolOfHopeThresholdShowCooldown, thresholdDictionary.symbolOfHope.enabled)
				
				controls.checkBoxes.symbolOfHopeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_symbolOfHope", parent, "ChatConfigCheckButtonTemplate")
				f = controls.checkBoxes.symbolOfHopeThresholdShow
				f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
				getglobal(f:GetName() .. 'Text'):SetText(L["SymbolOfHope"])
				---@diagnostic disable-next-line: inject-field
				f.tooltip = string.format(L["ThresholdHealerToggleAbility"], L["SymbolOfHope"])
				f:SetChecked(thresholdDictionary.symbolOfHope.enabled)
				f:SetScript("OnClick", function(self, ...)
					thresholdDictionary.symbolOfHope.enabled = self:GetChecked()
					TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.symbolOfHopeThresholdShowCooldown, thresholdDictionary.symbolOfHope.enabled)
				end)

				local title = L["ThresholdHealerSymbolOfHopeManaPercent"]
				controls.symbolOfHopePercent = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 100, thresholdDictionary.symbolOfHope.minimumManaPercent, 5, 5,
												oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord-20)
				controls.symbolOfHopePercent:SetScript("OnValueChanged", function(self, value)
					value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
					value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
					self.EditBox:SetText(value)
					thresholdDictionary.symbolOfHope.minimumManaPercent = value
				end)

				yCoord = yCoord - 20
			end
		end

		if classId == 10 then
			yCoord = yCoord - 25
			controls.checkBoxes.manaTeaChargesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_manaTeaCharges", parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes.manaTeaChargesThresholdShow
			f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(f:GetName() .. 'Text'):SetText(L["ManaTea"])
			---@diagnostic disable-next-line: inject-field
			f.tooltip = string.format(L["ThresholdHealerToggleAbility"], L["ManaTea"])
			f:SetChecked(thresholdDictionary.manaTeaCharges.enabled)
			f:SetScript("OnClick", function(self, ...)
				thresholdDictionary.manaTeaCharges.enabled = self:GetChecked()
			end)
		end

		--NOTE: the order of these checkboxes is reversed!
		yCoord = yCoord - 25
		controls.checkBoxes.cannibalizeThresholdShowCooldown = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_cannibalize_cooldown", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cannibalizeThresholdShowCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdShowWhileOnCooldown"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["ThresholdHealerShowWhileOnCooldownTooltipWithAbility"], L["CannibalizeIfForsaken"])
		f:SetChecked(thresholdDictionary["cannibalize"].cooldown)
		f:SetScript("OnClick", function(self, ...)
			thresholdDictionary["cannibalize"].cooldown = self:GetChecked()
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.cannibalizeThresholdShowCooldown, thresholdDictionary["cannibalize"].enabled)
		
		controls.checkBoxes.cannibalizeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_cannibalize", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cannibalizeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CannibalizeIfForsaken"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["ThresholdHealerToggleAbility"], L["CannibalizeIfForsaken"])
		f:SetChecked(thresholdDictionary["cannibalize"].enabled)
		f:SetScript("OnClick", function(self, ...)
			thresholdDictionary["cannibalize"].enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.cannibalizeThresholdShowCooldown, thresholdDictionary["cannibalize"].enabled)
		end)
		yCoord = yCoord - 30
	end
	
	local overText = L["ThresholdHealerOver"]
	if classId == 5 then
		overText = L["ThresholdHealerOver2"]
	end

	yCoord = yCoord - 30

	controls.colors.thresholdHealer = controls.colors.thresholdHealer or {}

	if classId == nil then
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsForHealersHeader"], oUi.xCoord, yCoord)
	else
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)
	end
	
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, true)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
		end)
	end

	yCoord = yCoord - 30
	controls.colors.thresholdHealer.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, overText, thresholdColor.over.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.thresholdHealer.over
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, thresholdColor, controls.colors.thresholdHealer, "over")
	end)

	controls.colors.thresholdHealer.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnusable"], thresholdColor.unusable.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.thresholdHealer.unusable
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, thresholdColor, controls.colors.thresholdHealer, "unusable")
	end)

	yCoord = yCoord - 30
	controls.colors.thresholdHealer.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdHealerPassive"], thresholdColor.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.thresholdHealer.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, thresholdColor, controls.colors.thresholdHealer, "passive")
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap)
	local f = nil
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, primaryResourceString, spec.colors.bar.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "base")
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateEndCapOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarEndcapHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalEndCap = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_endCap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalEndCap
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_EndCap"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].endCap)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].endCap = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			
			if classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
				TRB.Functions.Threshold:ResetEndCap(TRB.Frames.resourceFrame, TRB.Data.specCache[specName].settings, "base")
			end
		end)
	end

	yCoord = yCoord - 30
	controls.colors.endCap = {}
	controls.colors.endCap.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EndCap"], spec.colors.endCap.base.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.endCap.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.endCap, controls.colors.endCap, "base", "endCap", TRB.Frames.resourceFrame, classId, specId)
	end)

	controls.checkBoxes.endCapBaseEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Option_endCapBaseEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endCapBaseEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEndCapEnabled"])
	f.tooltip = L["CheckboxEndCapEnabledTooltip"]
	f:SetChecked(spec.colors.endCap.base.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.endCap.base.enabled = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.endCapBaseUseBorderColor, spec.colors.endCap.base.enabled)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.endCapBaseUseBorderColorExceptDefault, spec.colors.endCap.base.enabled and spec.colors.endCap.base.useBorderColor)

		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			local specNameInner = specName
			if classId == nil then
				 _, specNameInner = TRB.Functions.Character:GetClassAndSpecializationNames(TRB.Data.character.classId, TRB.Data.character.specId)
			end
			TRB.Functions.Threshold:ResetEndCap(TRB.Frames.resourceFrame, TRB.Data.specCache[specNameInner].settings, "base")
		end
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.endCapBaseUseBorderColor = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Option_endCapBaseUseBorderColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endCapBaseUseBorderColor
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEndCapUseBorderColor"])
	f.tooltip = L["CheckboxEndCapUseBorderColorTooltip"]
	f:SetChecked(spec.colors.endCap.base.useBorderColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.endCap.base.useBorderColor = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.endCapBaseUseBorderColorExceptDefault, spec.colors.endCap.base.useBorderColor)

		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			local specNameInner = specName
			if classId == nil then
				 _, specNameInner = TRB.Functions.Character:GetClassAndSpecializationNames(TRB.Data.character.classId, TRB.Data.character.specId)
			end
			TRB.Functions.Threshold:ResetEndCap(TRB.Frames.resourceFrame, TRB.Data.specCache[specNameInner].settings, "base")
		end
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.endCapBaseUseBorderColor, spec.colors.endCap.base.enabled)

	yCoord = yCoord - 20
	controls.checkBoxes.endCapBaseUseBorderColorExceptDefault = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Option_endCapBaseUseBorderColorExceptDefault", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endCapBaseUseBorderColorExceptDefault
	f:SetPoint("TOPLEFT", oUi.xCoord+40, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEndCapUseBorderColorExceptDefault"])
	f.tooltip = L["CheckboxEndCapUseBorderColorExceptDefaultTooltip"]
	f:SetChecked(spec.colors.endCap.base.useBorderColorExceptDefault)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.endCap.base.useBorderColorExceptDefault = self:GetChecked()

		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			local specNameInner = specName
			if classId == nil then
				 _, specNameInner = TRB.Functions.Character:GetClassAndSpecializationNames(TRB.Data.character.classId, TRB.Data.character.specId)
			end
			TRB.Functions.Threshold:ResetEndCap(TRB.Frames.resourceFrame, TRB.Data.specCache[specNameInner].settings, "base")
		end
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.endCapBaseUseBorderColorExceptDefault, spec.colors.endCap.base.enabled and spec.colors.endCap.base.useBorderColor)

	yCoord = yCoord - 20

	local title = L["EndCapWidth"]
	controls.endCapWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 50, spec.colors.endCap.base.width, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endCapWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.colors.endCap.base.width = value

		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			local specNameInner = specName
			if classId == nil then
				 _, specNameInner = TRB.Functions.Character:GetClassAndSpecializationNames(TRB.Data.character.classId, TRB.Data.character.specId)
			end
			TRB.Functions.Threshold:ResetEndCap(TRB.Frames.resourceFrame, TRB.Data.specCache[specNameInner].settings, "base")
			
			-- Reset the cache for the bar value so it redraws the end cap width
			TRB.Data.cache.values.bar["resource"].value = nil
		end
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarBorderColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25
	controls.colors.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["BorderColorBase"], spec.colors.bar.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame)
	end)

	--[[
	if includeOvercap then
		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Border_Option_overcapBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BorderColorOvercapToggle"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["BorderColorOvercapToggleTooltip"], primaryResourceString)
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		controls.colors.borderOvercap = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["BorderColorOvercap"], primaryResourceString), spec.colors.bar.borderOvercap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)
	end
	]]

	if isHealer then
		yCoord = yCoord - 30
		controls.checkBoxes.innervateBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_innervateBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["Innervate"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BorderColorInnervateToggleTooltip"]
		f:SetChecked(spec.colors.bar.innervateBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.innervateBorderChange = self:GetChecked()
		end)

		controls.colors.innervate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["BorderColorInnervate"], spec.colors.bar.innervate, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.innervate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "innervate")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.potionOfChilledClarityBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Threshold_Option_potionOfChilledClarityBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.potionOfChilledClarityBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["PotionOfChilledClarity"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip =  L["BorderColorPotionOfChilledClarityToggleTooltip"]
		f:SetChecked(spec.colors.bar.potionOfChilledClarityBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.potionOfChilledClarityBorderChange = self:GetChecked()
		end)
		
		controls.colors.potionOfChilledClarity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["BorderColorPotionOfChilledClarity"], spec.colors.bar.potionOfChilledClarity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.potionOfChilledClarity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "potionOfChilledClarity")
		end)
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.overcappingConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["OvercappingConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.overcapModeRelative = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Relative", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeRelative
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapRelativeOffset"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "relative" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(true)
		controls.checkBoxes.overcapModeFixed:SetChecked(false)
		spec.overcap.mode = "relative"
	end)

	title = string.format(L["OvercapRelativeOffsetAmount"], primaryResourceString)
	controls.overcapRelative = TRB.Functions.OptionsUi:BuildSlider(parent, title, -primaryResourceMax, 0, spec.overcap.relative, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapRelative:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.relative = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.overcapModeFixed = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Fixed", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeFixed
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapFixedValue"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "fixed" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(false)
		controls.checkBoxes.overcapModeFixed:SetChecked(true)
		spec.overcap.mode = "fixed"
	end)

	title = string.format(L["OvercapAbove"], primaryResourceString)
	controls.overcapFixed = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, primaryResourceMax, spec.overcap.fixed, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapFixed:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.fixed = value
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMin, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.maxResourceConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MaxResourceHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	title = string.format(L["MaxResourceValue"], primaryResourceString)
	controls.checkBoxes.maxResourceEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_maxResourceEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maxResourceEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MaxResourceEnabled"])
	f.tooltip = L["MaxResourceEnabledTooltip"]
	f:SetChecked(spec.maxResource.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.maxResource.enabled = self:GetChecked()
	end)
	
	controls.maxResourceValue = TRB.Functions.OptionsUi:BuildSlider(parent, title, primaryResourceMin, primaryResourceMax, spec.maxResource.value, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.maxResourceValue:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.maxResource.value = value
		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			local specNameInner = specName
			if classId == nil then
				 _, specNameInner = TRB.Functions.Character:GetClassAndSpecializationNames(TRB.Data.character.classId, TRB.Data.character.specId)
			end
			TRB.Functions.Bar:SetMinMax(TRB.Data.specCache[specNameInner].settings)
		end
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.dropDown.fonts = {}

	controls.textDisplayDefaultSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DefaultBarTextFontSettingsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	if specId ~= nil and classId ~= nil then
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobal = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_displayText", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobal
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_Font"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayText)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end)
		yCoord = yCoord - 30
	end

	FillFontCache()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFaceDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	local function FontFaceIsSelected(value)
		return value == spec.displayText.default.fontFace
	end
	
	local function FontFaceSetSelected(newValue)
		spec.displayText.default.fontFace = newValue
		spec.displayText.default.fontFaceName = fontPairsByName[newValue]
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 30
	controls.colors.text.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DefaultFontColor"], spec.displayText.default.color,
																		250, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.color
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.displayText.default, controls.colors.text, "color")
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	yCoord = yCoord - 60
	title = L["DefaultFontSize"]
	controls.fontSizeDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.default.fontSize, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontSizeDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.displayText.default.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	local lowerClassName = string.lower(className)
	controls.checkBoxes.useGlobalTextColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_textColors", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.useGlobalTextColors
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	f.tooltip = L["CheckboxUseGlobalTooltip_TextColors"]
	f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textColors)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.global[lowerClassName][specName].textColors = self:GetChecked()
		TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	return yCoord
end

---comment
---@param parent any
---@param controls any
---@param spec any
---@param classId any
---@param specId any
---@param yCoord integer
---@param dotCheckbox any
---@param dotTooltip any
---@param showUp any
---@param showPandemic any
---@param showDown any
---@return integer
function TRB.Functions.OptionsUi:GenerateDefaultDotOptions(parent, controls, spec, classId, specId, yCoord, dotCheckbox, dotTooltip, showUp, showPandemic, showDown)
	--Short-circuit for now
	if 1 == 1 then
		return yCoord
	end

	if showUp == nil then
		showUp = true
	end

	if showPandemic == nil then
		showPandemic = true
	end

	if showDown == nil then
		showDown = true
	end
	
	local f = nil
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	yCoord = yCoord - 30
	controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DotCountTimeTrackingHeader"], oUi.xCoord, yCoord)
	
	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 25
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalDotColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_dotColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalDotColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_DotColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].dotColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].dotColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end)
	end

	yCoord = yCoord - 30
	controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_dotColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dotColor
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(dotCheckbox)
	f.tooltip =  dotTooltip
	f:SetChecked(spec.colors.text.dots.options.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.dots.options.enabled = self:GetChecked()
	end)

	controls.colors.dots = {}
	
	if showUp then
		yCoord = yCoord - 30
		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerActive"], spec.colors.text.dots.up.color, 550, 25, oUi.xCoord, yCoord)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)
	end

	if showPandemic then
		yCoord = yCoord - 30
		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerPandemic"], spec.colors.text.dots.pandemic.color, 550, 25, oUi.xCoord, yCoord)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)
	end

	if showDown then
		yCoord = yCoord - 30
		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DotColorPickerInactive"], spec.colors.text.dots.down.color, 550, 25, oUi.xCoord, yCoord)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 25
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalPrecision = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_precision", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalPrecision
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_Precision"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].precision)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].precision = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Data.snapshotData.attributes.cacheRefresh = true
		end)
	end
	yCoord = yCoord - 50

	title = L["SecondaryDecimalPrecision"]
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.secondary, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.secondary = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, name, spec, classId, specId, yCoord, localization, localizationTooltip)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	
	controls.checkBoxes[name] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Checkbox", parent, "ChatConfigCheckButtonTemplate")

	local f = controls.checkBoxes[name]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(localization)
	f.tooltip = localizationTooltip
	f:SetChecked(spec.audio[name].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio[name].enabled = self:GetChecked()
		if spec.audio[name].enabled then
			PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)
	TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)

	yCoord = yCoord - 60
	return yCoord
end

function TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)
	FillSoundCache()
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	controls.dropDown = controls.dropDown or {}

	controls.dropDown[name .. "Audio"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Audio", parent, "WowStyle1DropdownTemplate")
	local dd = controls.dropDown[name .. "Audio"]
	dd:SetWidth(oUi.sliderWidth)
	dd:SetDefaultText(spec.audio[name].soundName)
	local function IsSelected(value)
		return value == spec.audio[name].sound
	end
	
	local function SetSelected(newValue)
		spec.audio[name].sound = newValue
		spec.audio[name].soundName = soundPairsByName[newValue]
		dd:SetDefaultText(spec.audio[name].soundName)
		PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
	end

	local function Generator(dropdown, rootDescription)
		for k, v in pairs(soundPairs) do
			rootDescription:CreateRadio(v[1], IsSelected, SetSelected, v[2])
		end
		rootDescription:SetScrollMode(400)

	end
	dd:SetupMenu(Generator)
	dd:SetPoint("TOPLEFT", oUi.xPadding2, yCoord-20)
end

---
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer
---@param specId integer
---@param yCoord number
function TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, classId, specId, yCoord, cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_barTextEditor"
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
	
	local columns = {
		{
			["name"] = "GUID",
			["width"] = 1,
			["align"] = "CENTER"
		},
		{
			["name"] = "Name",
			["width"] = 100,
			["align"] = "LEFT",
			--[[["color"] = { 
				["r"] = 0.5, 
				["g"] = 0.5, 
				["b"] = 1.0, 
				["a"] = 1.0 
			},
			["colorargs"] = nil,
			["bgcolor"] = {
				["r"] = 1.0, 
				["g"] = 0.0, 
				["b"] = 0.0, 
				["a"] = 1.0 
			}, -- red backgrounds, eww!
			["defaultsort"] = "dsc",
			["sortnext"]= 4,
			["comparesort"] = function (cella, cellb, column)
				return cella.value < cellb.value;
			end,
			["DoCellUpdate"] = nil,]]
		},
		{
			["name"] = "Bound To",
			["width"] = 150,
			["align"] = "LEFT"
		},
		{
			["name"] = "Bar Text",
			["width"] = 320,
			["align"] = "LEFT"
		},
		{
			["name"] = "",
			["width"] = 15,--260,
			["align"] = "CENTER",
			["color"] = {
				["r"] = 1,
				["g"] = 0,
				["b"] = 0,
				["a"] = 1,
			}
		}
	}

	---@type TRB.Classes.Settings.DisplayTextEntry
	---@diagnostic disable-next-line: missing-fields
	local workingBarText = {}

	controls.barTextContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local btc = controls.barTextContainer

	btc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	btc:SetWidth(620)
	btc:SetHeight(105)

	yCoord = yCoord - 90
	local btoHeight = 400
	local barTextTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 4, 15, nil, btc, false, false)
	
	local addButton = TRB.Functions.OptionsUi:BuildButton(parent, L["AddNewBarTextArea"], 450, yCoord, 175, 25)

	local barTextOptionsFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame", parent, "BackdropTemplate")
	barTextOptionsFrame:SetPoint("TOPLEFT", btc, "BOTTOMLEFT", 0, 0)
	barTextOptionsFrame:SetPoint("TOPRIGHT", btc, "BOTTOMRIGHT", 0, 0)
	barTextOptionsFrame:SetHeight(btoHeight)
	barTextOptionsFrame:Hide()

	local oldYCoord = yCoord - btoHeight

	yCoord = 0

	local barTextName = TRB.Functions.OptionsUi:BuildTextBox(barTextOptionsFrame, "", 200, 250, 20, oUi.xCoord, yCoord)
---@diagnostic disable-next-line: inject-field
	barTextName.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["Name"], oUi.xCoord, yCoord+25)
	barTextName.label.font:SetFontObject(GameFontNormal)
	
	local barTextEntryEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_TextEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	barTextEntryEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(barTextEntryEnabled:GetName() .. 'Text'):SetText(L["Enabled"])
---@diagnostic disable-next-line: inject-field
	barTextEntryEnabled.tooltip = L["BarTextEntryEnabledTooltip"]

	yCoord = yCoord - 40
	title = L["HorizontalOffset"]
	local barTextHorizontal = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxWidth), math.floor(sanityCheckValues.barMaxWidth), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	barTextHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.position.xPos = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	title = L["VerticalOffset"]
	local barTextVertical = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxHeight), math.floor(sanityCheckValues.barMaxHeight), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	barTextVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.position.yPos = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	yCoord = yCoord - 40
	local barTextRelativeToFrame = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeToFrame", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeToFrame:SetWidth(oUi.sliderWidth)
	barTextRelativeToFrame.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["BoundToBar"], oUi.xCoord, yCoord)
	barTextRelativeToFrame.label.font:SetFontObject(GameFontNormal)

	local relativeToFrame = {}
	relativeToFrame[L["MainResourceBar"]] = "Resource"
	relativeToFrame[L["Screen"]] = "UIParent"
	local relativeToFrameList = {
		L["MainResourceBar"],
		L["Screen"]
	}
	
	if (classId == 1 and specId == 3) then -- Protection Warrior
		relativeToFrame[L["IgnorePain"]] = "IgnorePain"
		relativeToFrame[L["ShieldBlock"]] = "ShieldBlock"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["IgnorePain"],
			L["ShieldBlock"],
			L["Screen"],
		}
	elseif(classId == 2) then -- Paladin
		relativeToFrame[L["HolyPower1"]] = "ComboPoint_1"
		relativeToFrame[L["HolyPower2"]] = "ComboPoint_2"
		relativeToFrame[L["HolyPower3"]] = "ComboPoint_3"
		relativeToFrame[L["HolyPower4"]] = "ComboPoint_4"
		relativeToFrame[L["HolyPower5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["HolyPower1"],
			L["HolyPower2"],
			L["HolyPower3"],
			L["HolyPower4"],
			L["HolyPower5"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 1) then -- Assassination Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 2) then -- Outlaw Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrame[L["ComboPoint7"]] = "ComboPoint_7"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["ComboPoint7"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 3) then -- Subtlety Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrame[L["ComboPoint7"]] = "ComboPoint_7"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["ComboPoint7"],
			L["Screen"],
		}
	elseif (classId == 5 and specId == 1) then -- Discipline Priest
		relativeToFrame[L["PowerWordRadianceCharge1"]] = "PowerWord_Radiance_1"
		relativeToFrame[L["PowerWordRadianceCharge2"]] = "PowerWord_Radiance_2"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["PowerWordRadianceCharge1"],
			L["PowerWordRadianceCharge2"],
			L["Screen"],
		}
	elseif (classId == 5 and specId == 2) then -- Holy Priest
		relativeToFrame[L["HolyWordSerenityCharge1"]] = "HolyWord_Serenity_1"
		relativeToFrame[L["HolyWordSerenityCharge2"]] = "HolyWord_Serenity_2"
		relativeToFrame[L["HolyWordSanctifyCharge1"]] = "HolyWord_Sanctify_1"
		relativeToFrame[L["HolyWordSanctifyCharge2"]] = "HolyWord_Sanctify_2"
		relativeToFrame[L["HolyWordChastiseCharge1"]] = "HolyWord_Chastise_1"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["HolyWordSerenityCharge1"],
			L["HolyWordSerenityCharge2"],
			L["HolyWordSanctifyCharge1"],
			L["HolyWordSanctifyCharge2"],
			L["HolyWordChastiseCharge1"],
			L["Screen"],
		}
	elseif (classId == 7 and specId == 2) then -- Enhancement Shaman
		relativeToFrame[L["Maelstrom1"]] = "ComboPoint_1"
		relativeToFrame[L["Maelstrom2"]] = "ComboPoint_2"
		relativeToFrame[L["Maelstrom3"]] = "ComboPoint_3"
		relativeToFrame[L["Maelstrom4"]] = "ComboPoint_4"
		relativeToFrame[L["Maelstrom5"]] = "ComboPoint_5"
		relativeToFrame[L["Maelstrom6"]] = "ComboPoint_6"
		relativeToFrame[L["Maelstrom7"]] = "ComboPoint_7"
		relativeToFrame[L["Maelstrom8"]] = "ComboPoint_8"
		relativeToFrame[L["Maelstrom9"]] = "ComboPoint_9"
		relativeToFrame[L["Maelstrom10"]] = "ComboPoint_10"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Maelstrom1"],
			L["Maelstrom2"],
			L["Maelstrom3"],
			L["Maelstrom4"],
			L["Maelstrom5"],
			L["Maelstrom6"],
			L["Maelstrom7"],
			L["Maelstrom8"],
			L["Maelstrom9"],
			L["Maelstrom10"],
			L["Screen"],
		}
	elseif (classId == 9 and specId == 1) then -- Affliction Warlock
		relativeToFrame[L["SoulShard1"]] = "ComboPoint_1"
		relativeToFrame[L["SoulShard2"]] = "ComboPoint_2"
		relativeToFrame[L["SoulShard3"]] = "ComboPoint_3"
		relativeToFrame[L["SoulShard4"]] = "ComboPoint_4"
		relativeToFrame[L["SoulShard5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulShard1"],
			L["SoulShard2"],
			L["SoulShard3"],
			L["SoulShard4"],
			L["SoulShard5"],
			L["Screen"],
		}
	elseif (classId == 10 and specId == 3) then -- Windwalker Monk
		relativeToFrame[L["Chi1"]] = "ComboPoint_1"
		relativeToFrame[L["Chi2"]] = "ComboPoint_2"
		relativeToFrame[L["Chi3"]] = "ComboPoint_3"
		relativeToFrame[L["Chi4"]] = "ComboPoint_4"
		relativeToFrame[L["Chi5"]] = "ComboPoint_5"
		relativeToFrame[L["Chi6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Chi1"],
			L["Chi2"],
			L["Chi3"],
			L["Chi4"],
			L["Chi5"],
			L["Chi6"],
			L["Screen"],
		}
	elseif (classId == 11 and specId == 2) then -- Feral Druid
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["Screen"],
		}
	elseif (classId == 12 and specId == 2) then -- Vengeance Demon Hunter
		relativeToFrame[L["SoulFragment1"]] = "ComboPoint_1"
		relativeToFrame[L["SoulFragment2"]] = "ComboPoint_2"
		relativeToFrame[L["SoulFragment3"]] = "ComboPoint_3"
		relativeToFrame[L["SoulFragment4"]] = "ComboPoint_4"
		relativeToFrame[L["SoulFragment5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulFragment1"],
			L["SoulFragment2"],
			L["SoulFragment3"],
			L["SoulFragment4"],
			L["SoulFragment5"],
			L["Screen"],
		}
	elseif (classId == 12 and specId == 3) then -- Devourer Demon Hunter
		relativeToFrame[L["SoulFragments"]] = "ComboPoint_1"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulFragments"],
			L["Screen"],
		}
	elseif (classId == 13) then -- Evoker
		relativeToFrame[L["Essence1"]] = "ComboPoint_1"
		relativeToFrame[L["Essence2"]] = "ComboPoint_2"
		relativeToFrame[L["Essence3"]] = "ComboPoint_3"
		relativeToFrame[L["Essence4"]] = "ComboPoint_4"
		relativeToFrame[L["Essence5"]] = "ComboPoint_5"
		relativeToFrame[L["Essence6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Essence1"],
			L["Essence2"],
			L["Essence3"],
			L["Essence4"],
			L["Essence5"],
			L["Essence6"],
			L["Screen"],
		}
	end

	local function RelativeToFrameIsSelected(value)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			return value == workingBarText.position.relativeToFrame
		else
			return false
		end
	end
	
	local function RelativeToFrameSetSelected(newValue)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			workingBarText.position.relativeToFrame = newValue
			
			for k, v in pairs(relativeToFrame) do
				if v == newValue then
					workingBarText.position.relativeToFrameName = k
				end
			end
			barTextRelativeToFrame:SetDefaultText(workingBarText.position.relativeToFrameName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function RelativeToFrameGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToFrameList) do
			rootDescription:CreateRadio(v, RelativeToFrameIsSelected, RelativeToFrameSetSelected, relativeToFrame[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
	barTextRelativeToFrame:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	
	local barTextRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeTo", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeTo:SetWidth(oUi.sliderWidth)
	barTextRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
	barTextRelativeTo.label.font:SetFontObject(GameFontNormal)
	
	local relativeTo = {}
	relativeTo[L["PositionTopLeft"]] = "TOPLEFT"
	relativeTo[L["PositionTop"]] = "TOP"
	relativeTo[L["PositionTopRight"]] = "TOPRIGHT"
	relativeTo[L["PositionLeft"]] = "LEFT"
	relativeTo[L["PositionCenter"]] = "CENTER"
	relativeTo[L["PositionRight"]] = "RIGHT"
	relativeTo[L["PositionBottomLeft"]] = "BOTTOMLEFT"
	relativeTo[L["PositionBottom"]] = "BOTTOM"
	relativeTo[L["PositionBottomRight"]] = "BOTTOMRIGHT"
	local relativeToList = {
		L["PositionTopLeft"],
		L["PositionTop"],
		L["PositionTopRight"],
		L["PositionLeft"],
		L["PositionCenter"],
		L["PositionRight"],
		L["PositionBottomLeft"],
		L["PositionBottom"],
		L["PositionBottomRight"]
	}

	local function RelativeToIsSelected(value)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			return value == workingBarText.position.relativeTo
		else
			return false
		end
	end
	
	local function RelativeToSetSelected(newValue)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			workingBarText.position.relativeTo = newValue
			
			for k, v in pairs(relativeTo) do
				if v == newValue then
					workingBarText.position.relativeToName = k
				end
			end
			barTextRelativeTo:SetDefaultText(workingBarText.position.relativeToName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeTo:SetupMenu(RelativeToGenerator)
	barTextRelativeTo:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)

	yCoord = yCoord - 60

	controls.colors.text = controls.colors.text or {}
	
	FillFontCache()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFace", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)
	
	local function FontFaceIsSelected(value)
		if workingBarText ~= nil then
			return value == workingBarText.fontFace
		else
			return false
		end
	end
	
	local function FontFaceSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontFace = newValue
			workingBarText.fontFaceName = fontPairsByName[newValue]
			barTextFontFace:SetDefaultText(workingBarText.fontFaceName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	local useDefaultFontFace = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontFace", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontFace:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-60)
	getglobal(useDefaultFontFace:GetName() .. 'Text'):SetText(L["UseDefaultFontFace"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontFace.tooltip = L["UseDefaultFontFaceTooltip"]
	useDefaultFontFace:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontFace = self:GetChecked()
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)


	local barTextFontJustifyHorizontal = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextFontJustifyHorizontal", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontJustifyHorizontal:SetWidth(oUi.sliderWidth)
	barTextFontJustifyHorizontal.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
	barTextFontJustifyHorizontal.label.font:SetFontObject(GameFontNormal)
	
	local fontJustifyHorizontal = {}
	fontJustifyHorizontal[L["PositionLeft"]] = "LEFT"
	fontJustifyHorizontal[L["PositionCenter"]] = "CENTER"
	fontJustifyHorizontal[L["PositionRight"]] = "RIGHT"
	local fontJustifyHorizontalList = {
		L["PositionLeft"],
		L["PositionCenter"],
		L["PositionRight"],
	}

	local function FontJustifyHorizontalIsSelected(value)
		if workingBarText ~= nil then
			return value == workingBarText.fontJustifyHorizontal
		else
			return false
		end
	end
	
	local function FontJustifyHorizontalSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontJustifyHorizontal = newValue
			
			for k, v in pairs(fontJustifyHorizontal) do
				if v == newValue then
					workingBarText.fontJustifyHorizontalName = k
				end
			end
			barTextFontJustifyHorizontal:SetDefaultText(workingBarText.fontJustifyHorizontalName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function FontJustifyHorizontalGenerator(dropdown, rootDescription)
		for k, v in pairs(fontJustifyHorizontalList) do
			rootDescription:CreateRadio(v, FontJustifyHorizontalIsSelected, FontJustifyHorizontalSetSelected, fontJustifyHorizontal[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)
	barTextFontJustifyHorizontal:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	
	yCoord = yCoord - 100
	title = L["FontSize"]
	local fontSize = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, 6, 72, 18, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontSize:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	local useDefaultFontSize = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontSize", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontSize:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-40)
	getglobal(useDefaultFontSize:GetName() .. 'Text'):SetText(L["UseDefaultFontSize"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontSize.tooltip = L["UseDefaultFontSizeTooltip"]
	useDefaultFontSize:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontSize = self:GetChecked()
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	controls.colors = controls.colors or {}
	controls.colors.barText = controls.colors.barText or {}
	controls.colors.barText.color = TRB.Functions.OptionsUi:BuildColorPicker(barTextOptionsFrame, L["FontColor"], "FFFFFFFF",
																			250, 25, oUi.xCoord2, yCoord)
	local barTextColor = controls.colors.barText.color
	barTextColor:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, workingBarText, controls.colors.barText, "color")
	end)

	local useDefaultFontColor = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontColor", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontColor:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(useDefaultFontColor:GetName() .. 'Text'):SetText(L["UseDefaultFontColor"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontColor.tooltip = L["UseDefaultFontColorTooltip"]
	useDefaultFontColor:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontColor = self:GetChecked()
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)


	yCoord = yCoord - 70
	controls.labels.barText = TRB.Functions.OptionsUi:BuildLabel(barTextOptionsFrame, L["BarText"], oUi.xCoord, yCoord, 90, 20)

	yCoord = yCoord - 20
	local barText = TRB.Functions.OptionsUi:CreateBarTextInputPanel(barTextOptionsFrame, namePrefix .. "_Text", "",
													590, 45, oUi.xCoord, yCoord)
	barText:SetCursorPosition(0)

	---@param displayText TRB.Classes.Settings.DisplayText
	---@param btt table # LibScrollingTable
	local function SetTableValues(displayText, btt)
		local dataTable = {}
		local entries = TRB.Functions.Table:Length(displayText.barText)
		if entries > 0 then
			for i = 1, entries do
				local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(displayText.barText[i].color, true)
				table.insert(dataTable, {
					cols = {
						{
							value = displayText.barText[i].guid
						},
						{
							value = displayText.barText[i].name,
						},
						{
							value = displayText.barText[i].position.relativeToFrameName,
						},
						{
							value = displayText.barText[i].text,
						},
						{
							value = "X",
						}
					}
				})
			end
		end
		btt:SetData(dataTable)
		btt:EnableSelection(true)
	end

	---@return TRB.Classes.Settings.DisplayTextEntry
	local function GetNewDisplayTextEntry()
		return {
			enabled = true,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontColor = false,
			name = L["NewBarTextEntry"],
			text = "",
			guid = TRB.Functions.String:Guid(),
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=18,
			color="FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	end

	---@param guid string
	---@param dt TRB.Classes.Settings.DisplayText
	local function FillBarTextEditorFields(guid, dt)
		local found = false
		local e = TRB.Functions.Table:Length(dt.barText)
		if e > 0 then
			for i = 1, e do
				if dt.barText[i].guid == guid then
					workingBarText = dt.barText[i]
					found = true
					break
				end
			end
		end

		if not found then
			return
		end

		barTextName:SetText(workingBarText.name)
		barTextEntryEnabled:SetChecked(workingBarText.enabled)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
		
		barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
		barTextRelativeTo:SetupMenu(RelativeToGenerator)
		barTextFontFace:SetupMenu(FontFaceGenerator)
		barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)

		fontSize:SetValue(workingBarText.fontSize)
		barTextColor.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(workingBarText.color, true))
		barText:SetText(workingBarText.text)

		TRB.Functions.OptionsUi:EditBoxSetTextMinMax(barTextHorizontal, workingBarText.position.xPos)
		TRB.Functions.OptionsUi:EditBoxSetTextMinMax(barTextVertical, workingBarText.position.yPos)
		
		useDefaultFontColor:SetChecked(workingBarText.useDefaultFontColor)
		useDefaultFontFace:SetChecked(workingBarText.useDefaultFontFace)
		useDefaultFontSize:SetChecked(workingBarText.useDefaultFontSize)
		
		barTextOptionsFrame:Show()
	end

	SetTableValues(spec.displayText, barTextTable)

	addButton:SetScript("OnClick", function(self, ...)
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		local newEntry = GetNewDisplayTextEntry()
		table.insert(displayText.barText, newEntry)
		SetTableValues(displayText, barTextTable)
		barTextTable:SetSelection(TRB.Functions.Table:Length(displayText.barText))
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		FillBarTextEditorFields(newEntry.guid, displayText)
	end)
	
	barTextEntryEnabled:SetScript("OnClick", function(self, ...)
		workingBarText.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	barTextName:SetScript("OnTextChanged", function(self, input)
		workingBarText.name = self:GetText()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
	end)

	barText:SetScript("OnTextChanged", function(self, input)
		workingBarText.text = self:GetText()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
		TRB.Data.cache.barText = {}
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
	end)

	---Deletes a specified bar text row
	---@param displayText TRB.Classes.Settings.DisplayText
	---@param deleteClassId integer
	---@param deleteSpecId integer
	---@param row integer
	---@param btt table
	local function DeleteBarTextRow(displayText, deleteClassId, deleteSpecId, row, btt)
		btt:SetSelection()
		table.remove(displayText.barText, row)
---@diagnostic disable-next-line: missing-fields
		workingBarText = {}
		SetTableValues(displayText, btt)
		TRB.Functions.BarText:CreateBarTextFrames(deleteClassId, deleteSpecId)
		_G["TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame"]:Hide()
	end

	StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteBarText"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		OnShow = function(self, data)
			self.text:SetFormattedText(data.message)
			self.data = data
		end,
		OnAccept = function(self)
			DeleteBarTextRow(self.data.displayText, self.data.classId, self.data.specId, self.data.row, self.data.btt)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	barTextTable:RegisterEvents({
		OnClick = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				local currentSelection = scrollingTable:GetSelection()

				if realrow ~= nil and realrow > 0 then
					local guid = data[realrow].cols[1].value

					if column == 5 then
						StaticPopup_Show("TwintopResourceBar_ConfirmDeleteBarText", nil, nil, {
							message = string.format(L["BarTextDeleteConfirmation"], data[realrow].cols[2].value),
							displayText = spec.displayText,
							row = realrow,
							btt = scrollingTable,
							classId = classId,
							specId = specId,
						})
					else
						FillBarTextEditorFields(guid, spec.displayText)
						C_Timer.After(0, function()
							C_Timer.After(0.05, function()
								local newSelection = scrollingTable:GetSelection()

								if newSelection == nil then
									barTextTable:SetSelection(currentSelection)
								end
							end)
						end)
					end
				end
			end
		end
	})

	local function ResetTableValues(barText)
		spec.displayText.barText = barText
		TRB.Data.specCache[specName].settings.displayText.barText = barText
		SetTableValues(spec.displayText, barTextTable)
		_G["TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame"]:Hide()
		
		if classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then			
			TRB.Data.cache.barText = {}
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
		TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(classId, specId)
	end

	controls.barTextFields = {}
	controls.barTextFields.barTextTable = barTextTable
	controls.barTextFields.ResetTableValues = ResetTableValues

	yCoord = oldYCoord
	local variablesPanel = TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, namePrefix)
	TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
	TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
end