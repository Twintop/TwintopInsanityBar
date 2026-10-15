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

---Builds a translucent, bordered panel that blocks clicks on a section's controls, spanning the parent between two y offsets.
---Hidden until shown.
---@param parent Frame # The panel's scroll child
---@param topY number # Y offset of the cover's top edge from parent's TOPLEFT
---@param bottomY number # Y offset of the cover's bottom edge from parent's TOPLEFT
---@return Frame|BackdropTemplate
function TRB.Functions.OptionsUi.Primitives:BuildSectionCover(parent, topY, bottomY)
	local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, topY)
	f:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, bottomY)
	-- Above every control in the section, including a slider's edit box and a dropdown's button.
	f:SetFrameLevel(parent:GetFrameLevel() + 20)
	f:EnableMouse(true)
	f:EnableMouseWheel(true)
	-- Sliders underneath would otherwise take the wheel, so hand it to the panel's scroll frame.
	f:SetScript("OnMouseWheel", function(cover, delta)
		local scrollFrame = cover:GetParent()
		while scrollFrame ~= nil and scrollFrame:GetObjectType() ~= "ScrollFrame" do
			scrollFrame = scrollFrame:GetParent()
		end
		local handler = scrollFrame and scrollFrame:GetScript("OnMouseWheel")
		if handler ~= nil then
			handler(scrollFrame, delta)
		end
	end)

	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 2,
	})
	f:SetBackdropColor(0, 0, 0, 0.8)
	f:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

	f:Hide()
	return f
end

---Moves every control anchored to the top of parent at or below topY by deltaY, so a list can grow or
---shrink in place. Panels lay out with fixed offsets, so nothing below re-flows on its own.
---@param parent Frame # The panel's scroll child
---@param topY number # Anchors with a y offset at or below this move
---@param deltaY number # Negative moves down
function TRB.Functions.OptionsUi.Primitives:ShiftControlsBelow(parent, topY, deltaY)
	local function Shift(object)
		local numPoints = object:GetNumPoints()
		local points = {}
		local moved = false
		for i = 1, numPoints do
			local point, relativeTo, relativePoint, x, y = object:GetPoint(i)
			if (relativeTo == nil or relativeTo == parent) and relativePoint ~= nil and relativePoint:sub(1, 3) == "TOP" and y <= topY then
				y = y + deltaY
				moved = true
			end
			points[i] = { point, relativeTo or parent, relativePoint, x, y }
		end
		if moved then
			object:ClearAllPoints()
			for _, p in ipairs(points) do
				object:SetPoint(p[1], p[2], p[3], p[4], p[5])
			end
		end
	end

	for _, child in ipairs({ parent:GetChildren() }) do
		Shift(child)
	end
	for _, region in ipairs({ parent:GetRegions() }) do
		Shift(region)
	end

	local scrollFrame = parent:GetParent()
	if scrollFrame ~= nil and scrollFrame.UpdateScrollChildRect ~= nil then
		scrollFrame:UpdateScrollChildRect()
	end
end

local CDM_BADGE_R, CDM_BADGE_G, CDM_BADGE_B = 1.0, 0.24, 0.24

---Returns the Cooldown Manager badge color, for text that stands in where a badge frame cannot go.
---@return number r
---@return number g
---@return number b
function TRB.Functions.OptionsUi.Primitives:GetCdmBadgeColor()
	return CDM_BADGE_R, CDM_BADGE_G, CDM_BADGE_B
end

---Points a badge at new text, colour, and tooltip, resizing it to the new label.
---@param badge Frame
---@param label string
---@param header string
---@param tooltip string
---@param r number
---@param g number
---@param b number
local function SetBadgeContent(badge, label, header, tooltip, r, g, b)
	badge.font:SetText(label)
	badge.font:SetTextColor(r, g, b, 1)
	-- Sized to the glyph so the hitbox cannot reach over a neighbouring control.
	badge:SetSize(math.max(badge.font:GetStringWidth(), 1), 16)
	---@diagnostic disable-next-line: inject-field
	badge.trbTooltip = { header = header, text = tooltip, r = r, g = g, b = b }
end

---Builds a short coloured badge that explains itself on hover.
---@param parent Frame
---@param label string
---@param header string
---@param tooltip string
---@param r number
---@param g number
---@param b number
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Frame
local function BuildBadge(parent, label, header, tooltip, r, g, b, posX, posY)
	local f = CreateFrame("Frame", nil, parent)
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
	f:EnableMouse(true)
	-- Above the parent so the control it annotates cannot swallow the hover.
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil, "OVERLAY")
	f.font:SetFontObject(GameFontNormalSmall)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetJustifyH("LEFT")
	SetBadgeContent(f, label, header, tooltip, r, g, b)

	f:SetScript("OnEnter", function(self)
		local content = self.trbTooltip
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(content.header, 1, 1, 1)
		GameTooltip:AddLine(content.text, content.r, content.g, content.b, true)
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	return f
end

local BADGE_GAP = 6
local badgeOrder = { "cdm", "global", "custom" }

---Lines up a font string's shown badges after its text. A label with a fixed `trbBadgeBox` wraps onto a
---second line when they wouldn't fit beside it, rather than pushing them off the panel's edge.
---@param fontString FontString
local function LayoutBadges(fontString)
	local badges = fontString.trbBadges
	local badgesWidth = 0
	for _, kind in ipairs(badgeOrder) do
		local badge = badges[kind]
		if badge ~= nil and badge:IsShown() then
			badgesWidth = badgesWidth + BADGE_GAP + badge:GetWidth()
		end
	end

	-- Re-measured each call since rows relabel; only a boxed label is measured unbounded, to decide its wrap.
	local box = fontString.trbBadgeBox
	local x = box ~= nil and fontString:GetUnboundedStringWidth() or fontString:GetStringWidth()
	if box ~= nil then
		if badgesWidth > 0 and x + badgesWidth > box.width then
			local _, fontHeight = fontString:GetFont()
			x = box.width - badgesWidth
			fontString:SetSize(x, math.max(box.height, math.ceil(fontHeight * 2 + 6)))
		else
			fontString:SetSize(box.width, box.height)
		end
	end

	for _, kind in ipairs(badgeOrder) do
		local badge = badges[kind]
		if badge ~= nil and badge:IsShown() then
			badge:ClearAllPoints()
			badge:SetPoint("LEFT", fontString, "LEFT", x + BADGE_GAP, 0)
			x = x + BADGE_GAP + badge:GetWidth()
		end
	end
end

---Shows a badge just past the rendered end of a font string, creating it on first need and toggling
---it thereafter. Reorderable rows re-label in place, so a build-once badge would stay on the wrong row.
---@param fontString FontString
---@param kind string # One badge of each kind per font string; see badgeOrder
---@param shown boolean # False hides an existing badge and never builds one
---@return Frame?
local function AttachBadge(fontString, kind, shown, label, header, tooltip, r, g, b)
	---@diagnostic disable-next-line: inject-field
	local badges = fontString.trbBadges
	local badge = badges and badges[kind]

	if not shown then
		if badge ~= nil then
			badge:Hide()
			LayoutBadges(fontString)
		end
		return nil
	end

	if badge == nil then
		badge = BuildBadge(fontString:GetParent(), label, header, tooltip, r, g, b, 0, 0)
		if badges == nil then
			badges = {}
			---@diagnostic disable-next-line: inject-field
			fontString.trbBadges = badges
		end
		badges[kind] = badge
	else
		SetBadgeContent(badge, label, header, tooltip, r, g, b)
	end

	badge:Show()
	LayoutBadges(fontString)
	return badge
end

---Creates a Cooldown Manager reliance badge. Declared state only: it never checks whether the spell
---is tracked right now, since the viewers are hidden while the options panel is open out of combat.
---@param parent Frame # The frame the badge is parented to
---@param dependency TRB.CdmDependency? # Absent or unrecognized produces no badge
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Frame? # nil when the feature declares no reliance
function TRB.Functions.OptionsUi.Primitives:BuildCdmBadge(parent, dependency, posX, posY)
	if parent == nil or dependency ~= TRB.Data.constants.cdmDependency.REQUIRED then
		return nil
	end
	return BuildBadge(parent, L["CdmBadgeLabel"], L["CdmBadgeHeader"], L["CdmBadgeRequiredTooltip"],
		CDM_BADGE_R, CDM_BADGE_G, CDM_BADGE_B, posX, posY)
end

---Attaches a Cooldown Manager reliance badge just past the rendered end of a font string. Safe to call
---again whenever the label is re-pointed at another feature, which shows, hides and re-places it.
---@param fontString FontString # The label to sit beside
---@param dependency TRB.CdmDependency? # Absent or unrecognized produces no badge
---@return Frame? # nil when the feature declares no reliance
function TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(fontString, dependency)
	if fontString == nil then
		return nil
	end
	return AttachBadge(fontString, "cdm", dependency == TRB.Data.constants.cdmDependency.REQUIRED,
		L["CdmBadgeLabel"], L["CdmBadgeHeader"], L["CdmBadgeRequiredTooltip"],
		CDM_BADGE_R, CDM_BADGE_G, CDM_BADGE_B)
end

---Shows or hides a "Global" badge just past a section header's text, after its CDM badge when it has one.
---@param fontString FontString # The header's label
---@param shown boolean
---@param tooltip string
---@return Frame?
function TRB.Functions.OptionsUi.Primitives:AttachGlobalBadgeToText(fontString, shown, tooltip)
	if fontString == nil then
		return nil
	end
	local r, g, b = TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor()
	return AttachBadge(fontString, "global", shown, L["UseGlobalBadgeLabel"], L["UseGlobalBadgeHeader"], tooltip, r, g, b)
end

local CUSTOM_BADGE_R, CUSTOM_BADGE_G, CUSTOM_BADGE_B = 1.0, 0.82, 0.0
local NOT_TRACKED_BADGE_R, NOT_TRACKED_BADGE_G, NOT_TRACKED_BADGE_B = 1.0, 0.5, 0.25

---Shows or hides the badge marking a custom Color Indicator. A not-tracked one gets its own label and
---colour; the tooltip says why.
---@param fontString FontString # The indicator's label
---@param shown boolean
---@param notTracked boolean
---@param tooltip string
---@return Frame?
function TRB.Functions.OptionsUi.Primitives:AttachCustomBadgeToText(fontString, shown, notTracked, tooltip)
	if fontString == nil then
		return nil
	end
	if notTracked then
		return AttachBadge(fontString, "custom", shown, L["CustomIndicatorBadgeNotTrackedLabel"], L["CustomIndicatorBadgeNotTrackedHeader"],
			tooltip, NOT_TRACKED_BADGE_R, NOT_TRACKED_BADGE_G, NOT_TRACKED_BADGE_B)
	end
	return AttachBadge(fontString, "custom", shown, L["CustomIndicatorBadgeLabel"], L["CustomIndicatorBadgeHeader"],
		tooltip, CUSTOM_BADGE_R, CUSTOM_BADGE_G, CUSTOM_BADGE_B)
end

---The color a not-tracked custom feature is marked in.
---@return number r
---@return number g
---@return number b
function TRB.Functions.OptionsUi.Primitives:GetNotTrackedColor()
	return NOT_TRACKED_BADGE_R, NOT_TRACKED_BADGE_G, NOT_TRACKED_BADGE_B
end

local cdm = TRB.Functions.CooldownManager

-- Marks TRB's own notes under a spell's tooltip in a Cooldown Manager picker, so they read as ours.
local cdmPickerNotePrefix = "|cFFA335EETRB:|r "
local CDM_PICKER_NOTE_R, CDM_PICKER_NOTE_G, CDM_PICKER_NOTE_B = 0.85, 0.75, 1.0

-- Past this many rows a long menu scrolls instead of growing off the screen.
local menuMaxRowsBeforeScroll = 15
local menuRowHeight = 20

---Makes a menu scroll once it holds more rows than fit comfortably on screen.
---@param rootDescription table
---@param rowCount integer # Rows the menu draws, counting titles and dividers
function TRB.Functions.OptionsUi.Primitives:LimitMenuRows(rootDescription, rowCount)
	if rowCount > menuMaxRowsBeforeScroll and rootDescription.SetScrollMode then
		rootDescription:SetScrollMode(menuMaxRowsBeforeScroll * menuRowHeight)
	end
end

local cdmPickerHeadings = {
	{ group = cdm.LayoutGroup.DISPLAYED, label = L["CustomIndicatorPickerDisplayed"] },
	{ group = cdm.LayoutGroup.INACTIVE, label = L["CustomIndicatorPickerInactive"] },
	{ group = cdm.LayoutGroup.NOT_DISPLAYED, label = L["CustomIndicatorPickerNotDisplayed"] },
	{ group = cdm.LayoutGroup.INACTIVE_NOT_DISPLAYED, label = L["CustomIndicatorPickerInactiveNotDisplayed"] },
}

---What a Cooldown Manager picker says that names the feature it picks for.
---@class TRB.Classes.OptionsUi.CdmPickerWording
---@field otherClass string # Why another class's panel can't pick
---@field otherSpec string # Why another spec's panel can't pick
---@field disabled string # Why nothing can be picked while the Cooldown Manager is turned off
---@field notLearned string # Entry note: its talent isn't taken
---@field notDisplayed string # Entry note: it isn't in Tracked Buffs or Tracked Bars

---Why a panel's Cooldown Manager picker can't be used right now (nil when it can), and the layout status behind
---it (nil on another spec's panel, since the Cooldown Manager only holds the played spec's layout).
---@param classId integer
---@param specId integer
---@param wording TRB.Classes.OptionsUi.CdmPickerWording
---@return string? reason
---@return TRB.CdmLayoutStatus? status
function TRB.Functions.OptionsUi.Primitives:GetCdmPickerBlock(classId, specId, wording)
	local character = TRB.Data.character
	if character == nil or character.classId ~= classId then
		return wording.otherClass, nil
	elseif character.specId ~= specId then
		return wording.otherSpec, nil
	end
	local status, reason = cdm:GetLayoutStatus()
	if status == cdm.LayoutStatus.UNAVAILABLE then
		return string.format(L["CustomIndicatorCdmUnavailableTooltip"], reason or ""), status
	elseif status == cdm.LayoutStatus.DISABLED then
		return wording.disabled, status
	elseif status == cdm.LayoutStatus.NOT_READY then
		return L["CustomIndicatorCdmNotReadyTooltip"], status
	end
	return nil, status
end

---Everything keeping a layout entry from driving a feature, plus the potion caveat.
---@param entry TRB.CdmLayoutEntry
---@param wording TRB.Classes.OptionsUi.CdmPickerWording
---@return string[]
function TRB.Functions.OptionsUi.Primitives:GetCdmEntryNotes(entry, wording)
	local notes = {}
	if entry.state == cdm.EntryState.NOT_LEARNED then
		notes[#notes + 1] = wording.notLearned
	elseif entry.state == cdm.EntryState.NO_TRINKET_BUFF then
		notes[#notes + 1] = L["CustomIndicatorNoTrinketBuffTooltip"]
	elseif entry.state == cdm.EntryState.UNAVAILABLE then
		notes[#notes + 1] = L["CustomIndicatorUnavailableTooltip"]
	end
	if not entry.displayed then
		notes[#notes + 1] = wording.notDisplayed
	end
	if entry.isPotion then
		notes[#notes + 1] = L["CustomIndicatorPotionCaveat"]
	end
	return notes
end

---A layout entry's menu label: its icon, then its name.
---@param entry TRB.CdmLayoutEntry
---@return string
function TRB.Functions.OptionsUi.Primitives:FormatCdmEntryLabel(entry)
	local text = entry.name or L["CustomIndicatorUnknownEntry"]
	if entry.icon ~= nil then
		text = "|T" .. entry.icon .. ":16:16:0:0|t " .. text
	end
	return text
end

---Fills a menu with the played spec's passive Cooldown Manager entries under their headings, alphabetically.
---Empty headings are left out, and nothing is greyed: a not-tracked entry is still a valid pick.
---@param rootDescription table
---@param currentCooldownID integer?
---@param wording TRB.Classes.OptionsUi.CdmPickerWording
---@param onPick fun(entry: TRB.CdmLayoutEntry)
function TRB.Functions.OptionsUi.Primitives:PopulateCdmPicker(rootDescription, currentCooldownID, wording, onPick)
	local entries = cdm:GetLayoutEntries() or {}
	table.sort(entries, function(a, b)
		local aName = (a.name or L["CustomIndicatorUnknownEntry"]):lower()
		local bName = (b.name or L["CustomIndicatorUnknownEntry"]):lower()
		if aName == bName then
			return a.cooldownID < b.cooldownID
		end
		return aName < bName
	end)

	local rowCount = 0
	for _, heading in ipairs(cdmPickerHeadings) do
		local first = true
		for _, entry in ipairs(entries) do
			if entry.group == heading.group then
				if first then
					if rowCount > 0 then
						rootDescription:CreateDivider()
						rowCount = rowCount + 1
					end
					rootDescription:CreateTitle(heading.label)
					rowCount = rowCount + 1
					first = false
				end

				local radio = rootDescription:CreateRadio(self:FormatCdmEntryLabel(entry), function()
					return entry.cooldownID == currentCooldownID
				end, function()
					onPick(entry)
					return MenuResponse.Close
				end)
				rowCount = rowCount + 1

				radio:SetTooltip(function(tooltipFrame)
					if entry.equipSlot ~= nil and GetInventoryItemID("player", entry.equipSlot) ~= nil then
						tooltipFrame:SetInventoryItem("player", entry.equipSlot)
					elseif entry.tooltipSpellID ~= nil then
						tooltipFrame:SetSpellByID(entry.tooltipSpellID)
					else
						tooltipFrame:SetText(entry.name or L["CustomIndicatorUnknownEntry"], 1, 1, 1)
					end
					local notes = self:GetCdmEntryNotes(entry, wording)
					if #notes > 0 then
						tooltipFrame:AddLine(" ")
						for _, note in ipairs(notes) do
							tooltipFrame:AddLine(cdmPickerNotePrefix .. note, CDM_PICKER_NOTE_R, CDM_PICKER_NOTE_G, CDM_PICKER_NOTE_B, true)
						end
					end
					tooltipFrame:Show()
				end)
			end
		end
	end

	if rowCount == 0 then
		rootDescription:CreateTitle(L["CustomIndicatorPickerEmpty"])
	else
		self:LimitMenuRows(rootDescription, rowCount)
	end
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

---Builds an 18px red cross button for deleting a row. Shows its tooltip even while disabled.
---@param parent Frame
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Button
function TRB.Functions.OptionsUi.Primitives:BuildDeleteIconButton(parent, posX, posY)
	local btn = CreateFrame("Button", nil, parent)
	btn:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
	btn:SetSize(18, 18)
	btn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	btn:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	btn:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	btn:SetDisabledTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	btn:GetNormalTexture():SetVertexColor(1, 0.3, 0.3)
	btn:GetDisabledTexture():SetDesaturated(true)
	btn:SetMotionScriptsWhileDisabled(true)
	return btn
end

---Builds an 18px note button for editing a row. Shows its tooltip even while disabled.
---@param parent Frame
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Button
function TRB.Functions.OptionsUi.Primitives:BuildEditIconButton(parent, posX, posY)
	local btn = CreateFrame("Button", nil, parent)
	btn:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
	btn:SetSize(18, 18)
	btn:SetNormalTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
	btn:SetPushedTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
	btn:SetHighlightTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
	btn:SetDisabledTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
	btn:GetPushedTexture():SetVertexColor(0.7, 0.7, 0.7)
	btn:GetHighlightTexture():SetBlendMode("ADD")
	btn:GetHighlightTexture():SetAlpha(0.4)
	btn:GetDisabledTexture():SetDesaturated(true)
	btn:GetDisabledTexture():SetAlpha(0.5)
	btn:SetMotionScriptsWhileDisabled(true)
	return btn
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

---Builds the "Enabled?" checkbox that toggles a setting's `enabled` flag, such as a color that only applies when on.
---@param parent Frame
---@param name string # Unique global frame name
---@param tooltip string?
---@param setting table # The settings entry holding `enabled`
---@param posX number
---@param posY number
---@return CheckButton
function TRB.Functions.OptionsUi.Primitives:BuildEnabledCheckbox(parent, name, tooltip, setting, posX, posY)
	local cb = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", posX, posY)
	getglobal(cb:GetName() .. "Text"):SetText(L["CheckboxEnabledQuestion"])
	cb.tooltip = tooltip
	cb:SetChecked(setting.enabled)
	cb:SetScript("OnClick", function(self)
		setting.enabled = self:GetChecked()
	end)
	return cb
end

---Builds a labeled radio dropdown bound to a getter/setter. Keeps the button's display text in sync with
---the selection, so callers only supply the value list and the two accessors.
---@param parent Frame
---@param name string # Unique global frame name
---@param label string? # Header text drawn above the dropdown, or nil to sit on the row itself
---@param options table[] # Ordered list of { value = any, label = string }
---@param getFn fun():any # Returns the currently selected value
---@param setFn fun(value:any) # Applies a newly selected value
---@param posX number
---@param posY number
---@return DropdownButton
function TRB.Functions.OptionsUi.Primitives:BuildDropdown(parent, name, label, options, getFn, setFn, posX, posY)
	local dropdown = CreateFrame("DropdownButton", name, parent, "WowStyle1DropdownTemplate")
	dropdown:SetWidth(oUi.sliderWidth)
	if label ~= nil then
		dropdown.label = self:BuildSectionHeader(parent, label, posX, posY)
		dropdown.label.font:SetFontObject(GameFontNormal)
		posY = posY - 30
	end
	dropdown:SetPoint("TOPLEFT", posX, posY)

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

