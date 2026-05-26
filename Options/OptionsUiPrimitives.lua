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

---Opens the WoW color picker dialog pre-filled with the given RGBA values.
---@param r number # Red component (0-1)
---@param g number # Green component (0-1)
---@param b number # Blue component (0-1)
---@param a number # Alpha component (0-1, where 1 is fully opaque)
---@param callback function # Called when the color is changed or cancelled
function TRB.Functions.OptionsUi.Primitives:ShowColorPicker(r, g, b, a, callback)
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

---Extracts RGBA color values from a color picker callback argument or directly from the ColorPickerFrame.
---@param color table? # The color table passed to the callback (nil if reading directly from the frame)
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
---@return number a # Alpha component (0-1)
function TRB.Functions.OptionsUi.Primitives:ExtractColorFromColorPicker(color)
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

---Handles mouse-down on a color picker swatch: opens the color picker and applies changes to the bar and settings.
---@param button string # The mouse button pressed (e.g., "LeftButton")
---@param colorTable table # The settings table containing the color entry
---@param colorControlsTable table # The controls table containing the color picker frame
---@param key string # The key into colorTable/colorControlsTable for the color entry
---@param frameType string? # The type of frame to update ("backdrop", "border", "bar", "threshold", or "health")
---@param frame Frame|table|nil # The frame(s) to update live, or nil for health-type updates
---@param classId integer? # Class ID for the panel being edited
---@param specId integer? # Spec ID for the panel being edited
function TRB.Functions.OptionsUi.Primitives:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frame, classId, specId)
	if button == "LeftButton" then
		-- Handle both table format { color = "FFRRGGBB" } and direct string format "FFRRGGBB"
		local colorValue = colorTable[key]
		local isNestedTable = type(colorValue) == "table" and colorValue.color ~= nil
		local colorString = isNestedTable and colorValue.color or colorValue

		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
		TRB.Functions.OptionsUi.Primitives:ShowColorPicker(r, g, b, 1-a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.Primitives:ExtractColorFromColorPicker(color)
			colorControlsTable[key].Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			local newColorString = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)

			-- Update the color in the appropriate format
			if isNestedTable then
				colorTable[key].color = newColorString
			else
				colorTable[key] = newColorString
			end

			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				if frame ~= nil then
					if frameType == "backdrop" then
						-- Handle both single frame and array of frames
						if type(frame) == "table" and frame[1] ~= nil then
							for _, f in ipairs(frame) do
								TRB.Functions.Color:SetBackdropColor(f, nil, r_1, g_1, b_1, a_1)
							end
						else
							TRB.Functions.Color:SetBackdropColor(frame, nil, r_1, g_1, b_1, a_1)
						end
					elseif frameType == "border" then
						-- Handle both single frame and array of frames
						if type(frame) == "table" and frame[1] ~= nil then
							for _, f in ipairs(frame) do
								TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(f, nil, newColorString)
							end
						else
							TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, nil, newColorString)
						end
					elseif frameType == "bar" then
						TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, nil, newColorString)
					elseif frameType == "threshold" then
						TRB.Functions.Color:SetThresholdColor(frame, newColorString, true, classId, specId)
					end
				elseif frameType == "health" then
					TRB.Functions.Character:UpdateHealthValues()
				end

				-- Clear color caches and trigger resource bar update to apply correct spec colors
				TRB.Data.cache.colors.backdrop = {}
				TRB.Data.cache.colors.border = {}
				TRB.Data.cache.colors.bar = {}
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end)
	end
end

---Gets the primary bar's container frame for use in color picker callbacks
---@return Frame|nil
function TRB.Functions.OptionsUi.Primitives:GetPrimaryBackdropFrame()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			return primaryNode:GetFrame()
		end
	end
	return nil
end

---Gets all secondary bar container frames (combo points, etc.) for use in color picker callbacks
---@return table<number, Frame>
function TRB.Functions.OptionsUi.Primitives:GetSecondaryBackdropFrames()
	local frames = {}
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.secondary then
		local nodeCount = barGroups.secondary:GetNodeCount()
		for i = 1, nodeCount do
			local node = barGroups.secondary:GetNode(i)
			if node then
				local containerFrame = node:GetFrame()
				if containerFrame then
					table.insert(frames, containerFrame)
				end
			end
		end
	end
	return frames
end

---Gets the health bar's container frame for use in color picker callbacks
---@return Frame|nil
function TRB.Functions.OptionsUi.Primitives:GetHealthBackdropFrame()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.health then
		local healthNode = barGroups.health:GetNode(1)
		if healthNode then
			return healthNode:GetFrame()
		end
	end
	return nil
end

---Creates a color picker button with a colored texture swatch and a descriptive text label.
---@param parent Frame # The parent frame
---@param description string # Text label displayed next to the color swatch
---@param settingsEntry string # ARGB hex color string (e.g., "FF00FF00") used to set the initial swatch color
---@param sizeTotal number # Total width reserved for the color picker and label combined
---@param sizeFrame number # Width and height of the color swatch square
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Button|BackdropTemplate
function TRB.Functions.OptionsUi.Primitives:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
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

local gradientDirectionCycle = { "disabled", "horizontal", "vertical" }
local gradientDirectionAbbrevLabels = {
	disabled = L["GradientDirectionDisabledAbbrev"],
	horizontal = L["GradientDirectionHorizontalAbbrev"],
	vertical = L["GradientDirectionVerticalAbbrev"],
}

local function NormalizeGradientColorEntry(colorEntry)
	if colorEntry == nil then
		return
	end

	if colorEntry.color2 == nil then
		colorEntry.color2 = colorEntry.color
	end

	if gradientDirectionAbbrevLabels[colorEntry.gradientDirection] == nil then
		colorEntry.gradientDirection = "disabled"
	end
end

---Builds a gradient-aware color picker with two swatches and a direction cycle button.
---The first swatch controls `colorEntry.color`, the second controls `colorEntry.color2`.
---The cycle button rotates through Disabled / Horizontal / Vertical gradient directions.
---When direction is "disabled", the second swatch is grayed out and non-interactive.
---@param parent Frame
---@param description string # Label text beside the swatches
---@param colorEntry table # Table with `color`, plus optional `color2` and `gradientDirection` fields
---@param sizeTotal number # Total width reserved for the widget and label combined
---@param sizeFrame number # Width and height of each color swatch square
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@param tooltipNote string? # Optional tooltip text shown on the direction button
---@return Frame # Container frame with .Swatch1, .Swatch2, .DirectionButton, .Font children
function TRB.Functions.OptionsUi.Primitives:BuildGradientColorPicker(parent, description, colorEntry, sizeTotal, sizeFrame, posX, posY, tooltipNote)
	NormalizeGradientColorEntry(colorEntry)

	local swatchSize = sizeFrame - 8
	local gap = 2
	local btnWidth = 22
	local btnGap = 4

	local container = CreateFrame("Frame", nil, parent)
	container:SetSize(sizeTotal, sizeFrame)
	container:SetPoint("TOPLEFT", posX, posY)

	-- Swatch 1 (primary color)
	local s1 = CreateFrame("Button", nil, container, "BackdropTemplate")
	s1:SetSize(swatchSize, swatchSize)
	s1:SetPoint("TOPLEFT", 0, -math.floor((sizeFrame - swatchSize) / 2))
	s1:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 4, edgeSize = 10
	})
	---@diagnostic disable-next-line: inject-field
	s1.Texture = s1:CreateTexture(nil)
	s1.Texture:ClearAllPoints()
	s1.Texture:SetPoint("TOPLEFT", 3, -3)
	s1.Texture:SetPoint("BOTTOMRIGHT", -3, 3)
	s1.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color, true))
	s1:EnableMouse(true)

	-- Swatch 2 (secondary color)
	local s2 = CreateFrame("Button", nil, container, "BackdropTemplate")
	s2:SetSize(swatchSize, swatchSize)
	s2:SetPoint("LEFT", s1, "RIGHT", gap, 0)
	s2:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 4, edgeSize = 10
	})
	---@diagnostic disable-next-line: inject-field
	s2.Texture = s2:CreateTexture(nil)
	s2.Texture:ClearAllPoints()
	s2.Texture:SetPoint("TOPLEFT", 3, -3)
	s2.Texture:SetPoint("BOTTOMRIGHT", -3, 3)
	s2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color2, true))
	s2:EnableMouse(true)

	-- Direction cycle button
	local btn = CreateFrame("Button", nil, container, "BackdropTemplate")
	btn:SetSize(btnWidth, swatchSize)
	btn:SetPoint("LEFT", s2, "RIGHT", btnGap, 0)
	btn:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 4, edgeSize = 10,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
	})
	btn:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
	---@diagnostic disable-next-line: inject-field
	btn.Font = btn:CreateFontString(nil)
	btn.Font:SetPoint("CENTER", 0, 0)
	btn.Font:SetFontObject(GameFontHighlightSmall)
	btn.Font:SetText(gradientDirectionAbbrevLabels[colorEntry.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
	btn:EnableMouse(true)

	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["GradientDirectionButtonTooltip"], 1, 1, 1)
		if tooltipNote then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(tooltipNote, 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Label
	---@diagnostic disable-next-line: inject-field
	container.Font = container:CreateFontString(nil)
	container.Font:SetPoint("LEFT", btn, "RIGHT", 10, 0)
	container.Font:SetFontObject(GameFontHighlight)
	container.Font:SetText(description)
	---@diagnostic disable-next-line: redundant-parameter
	container.Font:SetWordWrap(true)
	container.Font:SetJustifyH("LEFT")
	local labelWidth = sizeTotal - (swatchSize * 2 + gap + btnGap + btnWidth + 35)
	container.Font:SetSize(labelWidth, sizeFrame)

	-- Apply initial disabled state to swatch 2
	local function UpdateSwatch2State()
		if colorEntry.gradientDirection == "disabled" then
			s2:SetAlpha(0.35)
			s2:EnableMouse(false)
		else
			s2:SetAlpha(1.0)
			s2:EnableMouse(true)
		end
		btn.Font:SetText(gradientDirectionAbbrevLabels[colorEntry.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
	end
	UpdateSwatch2State()

	-- Expose child references for external use
	---@diagnostic disable-next-line: inject-field
	container.Swatch1 = s1
	---@diagnostic disable-next-line: inject-field
	container.Swatch2 = s2
	---@diagnostic disable-next-line: inject-field
	container.DirectionButton = btn
	-- Alias for compatibility: callers that read .Texture (like ToggleColorPickerEnabled) will find it on Swatch1
	---@diagnostic disable-next-line: inject-field
	container.Texture = s1.Texture
	---@diagnostic disable-next-line: inject-field
	container.UpdateSwatch2State = UpdateSwatch2State

	-- Direction cycle click handler
	btn:SetScript("OnMouseDown", function(self, mouseButton)
		if mouseButton == "LeftButton" then
			local currentIdx = 1
			for idx, dir in ipairs(gradientDirectionCycle) do
				if dir == colorEntry.gradientDirection then
					currentIdx = idx
					break
				end
			end
			local nextIdx = (currentIdx % #gradientDirectionCycle) + 1
			colorEntry.gradientDirection = gradientDirectionCycle[nextIdx]
			UpdateSwatch2State()
			TRB.Data.cache.colors.gradient = {}
			TRB.Data.cache.colors.bar = {}
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	return container
end

---Handles mouse-down on a gradient color picker's secondary swatch: opens the color picker for `color2`.
---@param button string # The mouse button pressed
---@param colorEntry table # The settings entry with `color`, `color2`, `gradientDirection`
---@param swatch2 Button|BackdropTemplate # The second swatch frame (to update its texture)
---@param classId integer? # Class ID for the panel being edited
---@param specId integer? # Spec ID for the panel being edited
function TRB.Functions.OptionsUi.Primitives:GradientColor2OnMouseDown(button, colorEntry, swatch2, classId, specId)
	NormalizeGradientColorEntry(colorEntry)

	if button == "LeftButton" and colorEntry.gradientDirection ~= "disabled" then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorEntry.color2, true)
		TRB.Functions.OptionsUi.Primitives:ShowColorPicker(r, g, b, 1 - a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.Primitives:ExtractColorFromColorPicker(color)
			swatch2.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			colorEntry.color2 = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)

			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Data.cache.colors.gradient = {}
				TRB.Data.cache.colors.bar = {}
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end)
	end
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
function TRB.Functions.OptionsUi.Primitives:BuildColorPickerWithEnable(parent, yCoord, controls, controlType, colorTable, namePrefix, value)
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

	controls.colors.threshold[value.name] = TRB.Functions.OptionsUi.Primitives:BuildColorPicker(parent, value.colorLocalization, colorTable[value.name].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	fColor = controls.colors.threshold[value.name]

	if value.colorScript ~= nil and type(value.colorScript) == "function" then
		fColor:SetScript("OnMouseDown", value.colorScript(self, button))
	else
		fColor:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.Primitives:ColorOnMouseDown(button, colorTable, controls.colors[controlType], value.name)
		end)
	end

	return yCoord, fColor, fCheckbox
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

