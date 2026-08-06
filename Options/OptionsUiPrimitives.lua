---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Primitives = TRB.Functions.OptionsUi.Primitives or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18

---Creates a slider control with +/- buttons, an editable text box, a title label, and min/max labels.
---@param parent Frame
---@param title string
---@param minValue number
---@param maxValue number
---@param defaultValue number
---@param stepValue number
---@param numDecimalPlaces integer
---@param sizeX number
---@param sizeY number
---@param posX number
---@param posY number
---@return table|BackdropTemplate|Slider
function TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
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
---@diagnostic disable-next-line: param-type-mismatch
	f.MinLabel:SetText(minValue)
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
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
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetText(defaultValue)
	eb:SetCursorPosition(0)

	return f
end

---Builds a slider that displays and accepts percentage values but stores decimal values.
---For example, displays "30%" but stores 0.30 internally.
---@param parent Frame
---@param title string
---@param minPercent number # Minimum value in percentage (e.g., 0 for 0%)
---@param maxPercent number # Maximum value in percentage (e.g., 100 for 100%, or 1000 for 1000%)
---@param defaultDecimalValue number # Default value as a decimal (e.g., 0.30 for 30%)
---@param stepPercent number # Step size in percentage (e.g., 1 for 1%)
---@param numDecimalPlaces integer # Decimal places to show in the percentage display (e.g., 0 for "30%", 2 for "30.00%")
---@param sizeX number
---@param sizeY number
---@param posX number
---@param posY number
---@return table|BackdropTemplate|Slider
function TRB.Functions.OptionsUi.Primitives:BuildPercentageSlider(parent, title, minPercent, maxPercent, defaultDecimalValue, stepPercent, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
---@diagnostic disable-next-line: inject-field
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minPercent, maxPercent)
	f:SetValueStep(stepPercent)
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
		-- Display as percentage with % suffix
		local displayValue = TRB.Functions.Number:RoundTo(value, numDecimalPlaces)
		self.EditBox:SetText(displayValue .. "%")
	end)
	---@diagnostic disable-next-line: inject-field
	f.MinLabel = f:CreateFontString(nil, "OVERLAY")
	f.MinLabel:SetFontObject(GameFontHighlightSmall)
	f.MinLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MinLabel:SetWordWrap(false)
	f.MinLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MinLabel:SetText(minPercent .. "%")
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MaxLabel:SetText(maxPercent .. "%")
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
		-- Parse the input, stripping any % suffix and converting to number
		local inputText = self:GetText()
		inputText = inputText:gsub("%%", "") -- Remove % sign if present
		local value = tonumber(inputText)
		if value then
			local min, max = f:GetMinMaxValues()
			if value >= min and value <= max then
				f:SetValue(value)
			elseif value < min then
				f:SetValue(min)
			elseif value > max then
				f:SetValue(max)
			end
			value = TRB.Functions.Number:RoundTo(f:GetValue(), numDecimalPlaces)
			eb:SetText(value .. "%")
		else
			-- Invalid input, reset to current value
			local currentValue = TRB.Functions.Number:RoundTo(f:GetValue(), numDecimalPlaces)
			eb:SetText(currentValue .. "%")
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

	-- Set initial value (convert decimal to percentage for display)
	local initialPercent = defaultDecimalValue * 100
	f:SetValue(initialPercent)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetText(TRB.Functions.Number:RoundTo(initialPercent, numDecimalPlaces) .. "%")
	eb:SetCursorPosition(0)

	return f
end

---Creates a single-line text input box with standard backdrop styling and keyboard behavior.
---@param parent Frame # The parent frame to attach the text box to
---@param text string # The initial text to display
---@param maxLetters integer # Maximum number of characters allowed
---@param width number # Width of the text box in pixels
---@param height number # Height of the text box in pixels
---@param xPos number # X offset from parent's TOPLEFT
---@param yPos number # Y offset from parent's TOPLEFT
---@return EditBox|BackdropTemplate
function TRB.Functions.OptionsUi.Primitives:BuildTextBox(parent, text, maxLetters, width, height, xPos, yPos)
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

---Clamps a numeric value to a slider's min/max range and updates its EditBox text display.
---@param box Slider # The slider frame (with an EditBox child) returned by BuildSlider
---@param value number # The value to set
---@return number # The clamped value
function TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(box, value)
	local min, max = box:GetMinMaxValues()
	if value > max then
		value = max
	elseif value < min then
		value = min
	end
	box.EditBox:SetText(value)
	return value
end

---Creates a section header frame with a large font title string.
---@param parent Frame # The parent frame
---@param title string # Header text to display
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Frame
function TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, title, posX, posY)
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

---Creates a two-part help entry: a right-aligned variable name and a left-aligned description below it.
---@param parent Frame # The parent frame
---@param var string # The variable name or label (displayed right-aligned)
---@param desc string # The description text (displayed below the variable)
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@param offset number # Width of the variable label column
---@param width number # Total width of the help entry
---@param height number? # Height of the variable label row (default 30)
---@param height2 number? # Height of the description area (default height * 3)
---@param justifyH string? # Horizontal justification for the description text (default "LEFT")
---@param fontFile string? # Optional font file path for the description text
---@return Frame
function TRB.Functions.OptionsUi.Primitives:BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset, width, height, height2, justifyH, fontFile)
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

---Creates a standard button with normal, highlight, and pushed textures.
---@param parent Frame # The parent frame
---@param text string # Button label text
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@param width number # Button width in pixels
---@param height number # Button height in pixels
---@return Button
function TRB.Functions.OptionsUi.Primitives:BuildButton(parent, text, posX, posY, width, height)
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

---Builds an export button anchored to the top-right corner of its parent panel.
---Used for "Export Bar Display", "Export Thresholds", "Export Bar Text", etc.
---@param parent Frame The parent panel
---@param text string Button label text
---@param yCoord number Vertical offset from parent's top
---@param height? number Button height (default 25)
---@return Button
function TRB.Functions.OptionsUi.Primitives:BuildExportButton(parent, text, yCoord, height)
	height = height or 25
	local f = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, text, 0, 0, 225, height)
	f:ClearAllPoints()
	f:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, yCoord)
	return f
end


---Builds a Label object for the Options UI
---@param parent frame
---@param text string
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param fontObject Font?
---@param hAlign string?
---@return table|Frame
function TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, text, posX, posY, width, height, fontObject, hAlign)
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

---Builds a checkbox bound to a getter/setter.
---@param parent Frame
---@param name string # Unique global frame name
---@param label string
---@param tooltip string?
---@param yCoord number
---@param getFn fun():boolean
---@param setFn fun(checked:boolean)
---@return CheckButton
function TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, name, label, tooltip, yCoord, getFn, setFn)
	local cb = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(cb:GetName() .. "Text"):SetText(label)
	cb.tooltip = tooltip
	cb:SetChecked(getFn() and true or false)
	cb:SetScript("OnClick", function(self)
		setFn(self:GetChecked() and true or false)
	end)
	return cb
end

---Builds a labeled radio dropdown bound to a getter/setter. Keeps the button's display text in sync with
---the selection, so callers only supply the value list and the two accessors.
---@param parent Frame
---@param name string # Unique global frame name
---@param label string # Header text drawn above the dropdown
---@param options table[] # Ordered list of { value = any, label = string }
---@param getFn fun():any # Returns the currently selected value
---@param setFn fun(value:any) # Applies a newly selected value
---@param posX number
---@param posY number
---@return DropdownButton
function TRB.Functions.OptionsUi.Primitives:BuildDropdown(parent, name, label, options, getFn, setFn, posX, posY)
	local dropdown = CreateFrame("DropdownButton", name, parent, "WowStyle1DropdownTemplate")
	dropdown:SetWidth(oUi.sliderWidth)
	dropdown.label = self:BuildSectionHeader(parent, label, posX, posY)
	dropdown.label.font:SetFontObject(GameFontNormal)
	dropdown:SetPoint("TOPLEFT", posX, posY - 30)

	local function LabelFor(value)
		for _, opt in ipairs(options) do
			if opt.value == value then
				return opt.label
			end
		end
		return options[1] and options[1].label or ""
	end

	local function IsSelected(value)
		return getFn() == value
	end

	local function SetSelected(value)
		setFn(value)
		-- Deferred: the menu is still closing, and SetDefaultText during teardown does not stick
		C_Timer.After(0, function()
			dropdown:SetDefaultText(LabelFor(value))
		end)
	end

	dropdown:SetupMenu(function(_, rootDescription)
		for _, opt in ipairs(options) do
			rootDescription:CreateRadio(opt.label, IsSelected, SetSelected, opt.value)
		end
	end)
	dropdown:SetDefaultText(LabelFor(getFn()))
	return dropdown
end

-- SetFont outline flags in canonical order; the stored setting is these joined with ", "
local fontOutlineFlags = {
	{ flag = "OUTLINE", labelKey = "FontOutlineOutline", excludes = "THICKOUTLINE" },
	{ flag = "THICKOUTLINE", labelKey = "FontOutlineThickOutline", excludes = "OUTLINE" },
	{ flag = "MONOCHROME", labelKey = "FontOutlineMonochrome" },
	{ flag = "SLUG", labelKey = "FontOutlineSlug" },
}

---Splits a SetFont flag string into a set of active flags.
---@param value string?
---@return table<string, boolean>
local function ParseFontOutline(value)
	local flags = {}
	for flag in string.gmatch(value or "", "[^,%s]+") do
		flags[string.upper(flag)] = true
	end
	return flags
end

---Joins a set of active flags back into a SetFont flag string in canonical order.
---@param flags table<string, boolean>
---@return string
local function JoinFontOutline(flags)
	local parts = {}
	for _, entry in ipairs(fontOutlineFlags) do
		if flags[entry.flag] then
			table.insert(parts, entry.flag)
		end
	end
	return table.concat(parts, ", ")
end

---Builds the localized display name for a SetFont outline flag string.
---@param value string? # e.g. "OUTLINE, SLUG"
---@return string
local function GetFontOutlineDisplayName(value)
	local flags = ParseFontOutline(value)
	local labels = {}
	for _, entry in ipairs(fontOutlineFlags) do
		if flags[entry.flag] then
			table.insert(labels, L[entry.labelKey])
		end
	end

	if #labels == 0 then
		return L["FontOutlineNone"]
	end

	return table.concat(labels, ", ")
end

---Builds a labeled multiselect font outline dropdown bound to a getter/setter. Flags stack, except None,
---which clears everything, and Outline/Thick Outline, which replace each other.
---@param parent Frame
---@param name string # Unique global frame name
---@param label string # Header text drawn above the dropdown
---@param getFn fun():string # Returns the current SetFont flag string
---@param setFn fun(value:string) # Applies a newly built SetFont flag string
---@param posX number
---@param posY number
---@return DropdownButton dropdown
---@return fun() refresh # Resyncs the button text after the bound value changes outside the menu
function TRB.Functions.OptionsUi.Primitives:BuildFontOutlineDropdown(parent, name, label, getFn, setFn, posX, posY)
	local dropdown = CreateFrame("DropdownButton", name, parent, "WowStyle1DropdownTemplate")
	dropdown:SetWidth(oUi.sliderWidth)
	dropdown.label = self:BuildSectionHeader(parent, label, posX, posY)
	dropdown.label.font:SetFontObject(GameFontNormal)
	dropdown:SetPoint("TOPLEFT", posX, posY - 30)

	dropdown:SetScript("OnEnter", function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["FontOutlineTooltip"], 1, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	dropdown:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	local function RefreshText()
		local displayName = GetFontOutlineDisplayName(getFn())
		dropdown:SetDefaultText(displayName)
		dropdown:SetText(displayName)
	end

	local function Apply(flags)
		setFn(JoinFontOutline(flags))
		RefreshText()
	end

	dropdown:SetupMenu(function(_, rootDescription)
		rootDescription:CreateCheckbox(L["FontOutlineNone"],
			function()
				return next(ParseFontOutline(getFn())) == nil
			end,
			function()
				Apply({})
			end)

		for _, entry in ipairs(fontOutlineFlags) do
			local capturedEntry = entry
			rootDescription:CreateCheckbox(L[capturedEntry.labelKey],
				function()
					return ParseFontOutline(getFn())[capturedEntry.flag] == true
				end,
				function()
					local flags = ParseFontOutline(getFn())
					if flags[capturedEntry.flag] then
						flags[capturedEntry.flag] = nil
					else
						flags[capturedEntry.flag] = true
						if capturedEntry.excludes ~= nil then
							flags[capturedEntry.excludes] = nil
						end
					end
					Apply(flags)
				end)
		end
	end)

	RefreshText()
	return dropdown, RefreshText
end

---Enables or disables a ChatConfigCheckButton checkbox and grays out its label text when disabled.
---@param checkbox CheckButton # The checkbox frame to toggle
---@param enable boolean # Whether to enable (true) or disable (false) the checkbox
function TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(checkbox, enable)
	if enable then
		checkbox:Enable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 1, 1)
	else
		checkbox:Disable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
	end
end

---Enables or disables a slider built with BuildSlider, including its EditBox and labels.
---@param slider Slider # The slider frame returned by BuildSlider
---@param enable boolean # Whether to enable or disable the slider
function TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(slider, enable)
	if enable then
		slider:Enable()
		slider:SetAlpha(1.0)
		slider:EnableMouseWheel(true)
		if slider.EditBox then
			slider.EditBox:Enable()
			slider.EditBox:EnableMouseWheel(true)
		end
		if slider.Plus then
			slider.Plus:Enable()
		end
		if slider.Minus then
			slider.Minus:Enable()
		end
		if slider.Title then
			slider.Title:SetFontObject(GameFontNormal)
		end
		if slider.MinLabel then
			slider.MinLabel:SetFontObject(GameFontHighlightSmall)
		end
		if slider.MaxLabel then
			slider.MaxLabel:SetFontObject(GameFontHighlightSmall)
		end
	else
		slider:Disable()
		slider:SetAlpha(0.5)
		slider:EnableMouseWheel(false)
		if slider.EditBox then
			slider.EditBox:Disable()
			slider.EditBox:EnableMouseWheel(false)
		end
		if slider.Plus then
			slider.Plus:Disable()
		end
		if slider.Minus then
			slider.Minus:Disable()
		end
		if slider.Title then
			slider.Title:SetFontObject(GameFontDisable)
		end
		if slider.MinLabel then
			slider.MinLabel:SetFontObject(GameFontDisableSmall)
		end
		if slider.MaxLabel then
			slider.MaxLabel:SetFontObject(GameFontDisableSmall)
		end
	end
end

---Enables or disables a dropdown button and grays out its section label when disabled.
---@param dropdown Button # The dropdown button frame to toggle
---@param enable boolean # Whether to enable or disable the dropdown
function TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(dropdown, enable)
	if enable then
		dropdown:Enable()
		dropdown:SetAlpha(1.0)
		if dropdown.label and dropdown.label.font then
			dropdown.label.font:SetFontObject(GameFontNormal)
		end
	else
		dropdown:Disable()
		dropdown:SetAlpha(0.5)
		if dropdown.label and dropdown.label.font then
			dropdown.label.font:SetFontObject(GameFontDisable)
		end
	end
end

---Enables or disables a color picker button and grays out its label when disabled.
---@param colorPicker Button # The color picker button returned by BuildColorPicker
---@param enable boolean # Whether to enable or disable the control
function TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(colorPicker, enable)
	if enable then
		if colorPicker.Enable then colorPicker:Enable() end
		colorPicker:SetAlpha(1.0)
		colorPicker:EnableMouse(true)
		if colorPicker.Font then
			colorPicker.Font:SetFontObject(GameFontHighlight)
		end
		if colorPicker.Swatch1 then
			colorPicker.Swatch1:EnableMouse(true)
			colorPicker.DirectionButton:EnableMouse(true)
			if colorPicker.UpdateSwatch2State then colorPicker.UpdateSwatch2State() end
		end
	else
		if colorPicker.Disable then colorPicker:Disable() end
		colorPicker:SetAlpha(0.5)
		colorPicker:EnableMouse(false)
		if colorPicker.Font then
			colorPicker.Font:SetFontObject(GameFontDisable)
		end
		if colorPicker.Swatch1 then
			colorPicker.Swatch1:EnableMouse(false)
			colorPicker.Swatch2:EnableMouse(false)
			colorPicker.DirectionButton:EnableMouse(false)
		end
	end
end

---Sets a checkbox label to green (enabled) or red (disabled) and optionally changes the label text.
---@param checkbox CheckButton # The checkbox frame to style
---@param enable boolean # Whether the checkbox represents an enabled state
---@param changeText boolean? # If true, also changes the label text to "Enabled" or "Disabled"
function TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(checkbox, enable, changeText)
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

