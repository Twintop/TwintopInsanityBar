---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.BarTextInput = TRB.Functions.OptionsUi.BarTextInput or {}

-- ============================================================================
-- Bar text input panel
-- ============================================================================

---Attaches undo/redo support (Ctrl+Z / Ctrl+Y) to an EditBox.
---Text snapshots are recorded on a debounced timer so rapid typing collapses into
---a single history entry.  The public helpers `editBox:ResetUndoHistory()` and
---`editBox:ResetUndoHistory(initialText)` are added for external use (e.g. when
---the user switches to a different bar-text entry).
local UNDO_MAX_HISTORY = 50
local UNDO_DEBOUNCE_SEC = 0.4

---Attaches undo/redo keyboard support (Ctrl+Z / Ctrl+Y) to an EditBox with debounced history snapshots.
---@param editBox EditBox # The EditBox frame to attach undo/redo behavior to
local function AttachUndoRedo(editBox)
	-- Private state stored directly on the frame
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoHistory  = { editBox:GetText() or "" }
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoCursors  = { 0 }
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoIndex    = 1
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoSuppress = false  -- flag: true while we are programmatically setting text
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoTimer    = nil

	--- Reset the undo stack (call when loading a different entry).
	---@param initialText? string  If given, seeds the stack with this text.
---@diagnostic disable-next-line: undefined-field, inject-field
	function editBox:ResetUndoHistory(initialText)
---@diagnostic disable-next-line: undefined-field, inject-field
		if self._undoTimer then self._undoTimer:Cancel(); self._undoTimer = nil end
		local t = initialText or self:GetText() or ""
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoHistory  = { t }
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoCursors  = { self:GetCursorPosition() or 0 }
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoIndex    = 1
	end

	---Pushes the current text and cursor position onto the undo stack, trimming any redo entries beyond the current index.
	---@param self EditBox # The EditBox whose state is being recorded
	local function PushState(self)
		local text   = self:GetText()
		local cursor = self:GetCursorPosition() or 0
		-- Don't push if identical to the current entry
		if self._undoHistory[self._undoIndex] == text then return end
		-- Trim any redo entries beyond the current index
		for i = #self._undoHistory, self._undoIndex + 1, -1 do
			table.remove(self._undoHistory, i)
			table.remove(self._undoCursors, i)
		end
		-- Push
		table.insert(self._undoHistory, text)
		table.insert(self._undoCursors, cursor)
		-- Cap size
		if #self._undoHistory > UNDO_MAX_HISTORY then
			table.remove(self._undoHistory, 1)
			table.remove(self._undoCursors, 1)
		end
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoIndex = #self._undoHistory
	end

	-- Record text changes (debounced, user-input only)
	editBox:HookScript("OnTextChanged", function(self, userInput)
		if self._undoSuppress or not userInput then return end
		if self._undoTimer then self._undoTimer:Cancel() end
		self._undoTimer = C_Timer.NewTimer(UNDO_DEBOUNCE_SEC, function()
			self._undoTimer = nil
			PushState(self)
		end)
	end)

	-- Intercept Ctrl+Z (undo), Ctrl+Y / Ctrl+Shift+Z (redo)
	editBox:SetScript("OnKeyDown", function(self, key)
		local handled = false
		if IsControlKeyDown() then
			local isRedo = (key == "Y") or (key == "Z" and IsShiftKeyDown())
			if key == "Z" and not IsShiftKeyDown() then
				handled = true
				-- Flush any pending debounce so the current state is saved first
				if self._undoTimer then
					self._undoTimer:Cancel()
					self._undoTimer = nil
					PushState(self)
				end
				if self._undoIndex > 1 then
					self._undoIndex = self._undoIndex - 1
					self._undoSuppress = true
					self:SetText(self._undoHistory[self._undoIndex])
					self:SetCursorPosition(self._undoCursors[self._undoIndex] or 0)
					self._undoSuppress = false
				end
			elseif isRedo then
				handled = true
				if self._undoIndex < #self._undoHistory then
					self._undoIndex = self._undoIndex + 1
					self._undoSuppress = true
					self:SetText(self._undoHistory[self._undoIndex])
					self:SetCursorPosition(self._undoCursors[self._undoIndex] or 0)
					self._undoSuppress = false
				end
			end
		end
		-- Prevent keystrokes from leaking to game keybinds.
		-- Must be called AFTER all processing (WoW requirement).
		self:SetPropagateKeyboardInput(false)
	end)
end

function TRB.Functions.OptionsUi.BarTextInput:AttachUndoRedo(editBox)
	AttachUndoRedo(editBox)
end

---Creates a multi-line bar text input panel inside a scroll frame with undo/redo, cursor tracking, and focus management.
---@param parent Frame # The parent frame
---@param name string # Unique name prefix for frame naming
---@param text string # The initial text content
---@param width number # Width of the input panel in pixels
---@param height number # Height of the input panel in pixels
---@param xPos number # X offset from parent's TOPLEFT
---@param yPos number # Y offset from parent's TOPLEFT
---@return EditBox # The inner EditBox (scroll child)
function TRB.Functions.OptionsUi.BarTextInput:CreateBarTextInputPanel(parent, name, text, width, height, xPos, yPos)
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

	-- Track this EditBox as the active bar text editor when it gains focus.
	-- We remember both the EditBox and cursor position so the side panel
	-- "Add" button can insert variables at the right place even after focus
	-- moves away.
	e:HookScript("OnEditFocusGained", function(self)
		TRB.Frames.activeBarTextEditBox = self
	end)
	e:HookScript("OnEditFocusLost", function(self)
		TRB.Frames.activeBarTextCursorPosition = self:GetCursorPosition()
	end)

	-- Clicking anywhere in the scroll frame (not just on text) gives focus to the EditBox
	s:EnableMouse(true)
	s:SetScript("OnMouseDown", function(self)
		e:SetFocus()
	end)

	-- Keep EditBox width in sync if the ScrollFrame resizes
	s:HookScript("OnSizeChanged", function(self, w, h)
		e:SetWidth(w)
	end)

	s:SetScrollChild(e)
	return e
end


