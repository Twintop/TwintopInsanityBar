---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.ColorPickers = TRB.Functions.OptionsUi.ColorPickers or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Color picker primitives
-- ============================================================================

---Opens the WoW color picker dialog pre-filled with the given RGBA values.
---@param r number # Red component (0-1)
---@param g number # Green component (0-1)
---@param b number # Blue component (0-1)
---@param a number # Alpha component (0-1, where 1 is fully opaque)
---@param callback function # Called when the color is changed or cancelled
function TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, a, callback)
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
function TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
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
---@param onColorChanged function? # Optional callback run after the color is applied (e.g. UpdateHealthValues)
function TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frame, classId, specId, onColorChanged)
	if button == "LeftButton" then
		-- Handle both table format { color = "FFRRGGBB" } and direct string format "FFRRGGBB"
		local colorValue = colorTable[key]
		local isNestedTable = type(colorValue) == "table" and colorValue.color ~= nil
		local colorString = isNestedTable and colorValue.color or colorValue

		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
		TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, 1-a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
			colorControlsTable[key].Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			local newColorString = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)

			-- Update the color in the appropriate format
			if isNestedTable then
				colorTable[key].color = newColorString
			else
				colorTable[key] = newColorString
			end

			if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
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

				-- Run any caller-supplied refresh (e.g. UpdateHealthValues for threshold
				-- pickers) before the bar update so the repaint uses the fresh color.
				if onColorChanged then
					onColorChanged()
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
function TRB.Functions.OptionsUi.ColorPickers:GetPrimaryBackdropFrame()
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
function TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames()
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
function TRB.Functions.OptionsUi.ColorPickers:GetHealthBackdropFrame()
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
function TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
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

---Builds the full end cap option block for one bar: enable checkbox + color swatch,
---border-follow checkboxes, and a width slider. Mutates parentColorTable.endCap live.
---@param parent Frame # The parent options panel frame
---@param controls table # Controls table with checkBoxes/colors subtables
---@param yCoord number # Current layout Y coordinate
---@param parentColorTable table # Table containing the endCap entry (e.g. spec.colors.bar)
---@param namePrefix string # Unique frame-name prefix including the bar identity (e.g. "rogue_assassination_ComboPoints")
---@param controlKey string # Key prefix for storing controls (e.g. "endCapComboPoints")
---@param swatchLabel string? # Color swatch label; defaults to L["EndCap"]
---@param classId integer? # Class ID for the panel being edited, nil for global
---@param specId integer? # Spec ID for the panel being edited, nil for global
---@return number yCoord # The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, parentColorTable, namePrefix, controlKey, swatchLabel, classId, specId)
	local endCapSettings = parentColorTable.endCap
	if endCapSettings == nil then
		return yCoord
	end

	local Primitives = TRB.Functions.OptionsUi.Primitives
	controls.checkBoxes = controls.checkBoxes or {}
	controls.colors = controls.colors or {}

	-- Recomposes the active spec's cached settings, then re-applies bar appearance so endcap
	-- changes render immediately (the renderer reads the composed cache, not the raw table)
	local function RefreshEndCaps()
		if not TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			return
		end
		local className, specName
		if classId ~= nil and specId ~= nil then
			className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
		else
			className, specName = TRB.Data.character.className, TRB.Data.character.specName
		end
		if className ~= nil and specName ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(className, specName)
		end
		local specCacheEntry = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if TRB.Frames.barGroups ~= nil and specCacheEntry ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsAppearance(specCacheEntry.settings, TRB.Frames.barGroups)
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end

	local function RefreshSubControlStates()
		Primitives:ToggleColorPickerEnabled(controls.colors[controlKey], endCapSettings.enabled)
		Primitives:ToggleSliderEnabled(controls.sliders[controlKey .. "Width"], endCapSettings.enabled)
		Primitives:ToggleCheckboxEnabled(controls.checkBoxes[controlKey .. "UseBorderColor"], endCapSettings.enabled)
		Primitives:ToggleCheckboxEnabled(controls.checkBoxes[controlKey .. "UseBorderColorExceptDefault"], endCapSettings.enabled and endCapSettings.useBorderColor == true)
	end

	-- Enable checkbox + color swatch on one row
	yCoord = yCoord - 30
	local fCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_EndCapEnabled", parent, "ChatConfigCheckButtonTemplate")
	controls.checkBoxes[controlKey .. "Enabled"] = fCheckbox
	fCheckbox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(fCheckbox:GetName() .. 'Text'):SetText(L["CheckboxEndCapEnabled"])
---@diagnostic disable-next-line: inject-field
	fCheckbox.tooltip = L["CheckboxEndCapEnabledTooltip"]
	fCheckbox:SetChecked(endCapSettings.enabled == true)
	fCheckbox:SetScript("OnClick", function(self, ...)
		endCapSettings.enabled = self:GetChecked()
		RefreshSubControlStates()
		RefreshEndCaps()
	end)

	-- The swatch proxy keys the color entry as "endCap" for ColorOnMouseDown while the
	-- shared controls table keeps the panel-unique controlKey.
	local swatchProxy = {}
	local fSwatch = self:BuildColorPicker(parent, swatchLabel or L["EndCap"], endCapSettings.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	swatchProxy.endCap = fSwatch
	controls.colors[controlKey] = fSwatch
	fSwatch:SetScript("OnMouseDown", function(_, button, ...)
		self:ColorOnMouseDown(button, parentColorTable, swatchProxy, "endCap", nil, nil, classId, specId, RefreshEndCaps)
	end)

	-- Border-follow checkboxes (indented, gated on enabled)
	yCoord = yCoord - 20
	fCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_EndCapUseBorderColor", parent, "ChatConfigCheckButtonTemplate")
	controls.checkBoxes[controlKey .. "UseBorderColor"] = fCheckbox
	fCheckbox:SetPoint("TOPLEFT", oUi.xCoord + 20, yCoord)
	getglobal(fCheckbox:GetName() .. 'Text'):SetText(L["CheckboxEndCapUseBorderColor"])
---@diagnostic disable-next-line: inject-field
	fCheckbox.tooltip = L["CheckboxEndCapUseBorderColorTooltip"]
	fCheckbox:SetChecked(endCapSettings.useBorderColor == true)
	fCheckbox:SetScript("OnClick", function(self, ...)
		endCapSettings.useBorderColor = self:GetChecked()
		RefreshSubControlStates()
		RefreshEndCaps()
	end)

	yCoord = yCoord - 20
	fCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_EndCapUseBorderColorExceptDefault", parent, "ChatConfigCheckButtonTemplate")
	controls.checkBoxes[controlKey .. "UseBorderColorExceptDefault"] = fCheckbox
	fCheckbox:SetPoint("TOPLEFT", oUi.xCoord + 40, yCoord)
	getglobal(fCheckbox:GetName() .. 'Text'):SetText(L["CheckboxEndCapUseBorderColorExceptDefault"])
---@diagnostic disable-next-line: inject-field
	fCheckbox.tooltip = L["CheckboxEndCapUseBorderColorExceptDefaultTooltip"]
	fCheckbox:SetChecked(endCapSettings.useBorderColorExceptDefault == true)
	fCheckbox:SetScript("OnClick", function(self, ...)
		endCapSettings.useBorderColorExceptDefault = self:GetChecked()
		RefreshEndCaps()
	end)

	-- Width slider
	--yCoord = yCoord - 20
	controls.sliders = controls.sliders or {}
	controls.sliders[controlKey .. "Width"] = Primitives:BuildSlider(parent, L["EndCapWidth"], 1, 50, endCapSettings.width or 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.sliders[controlKey .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = Primitives:EditBoxSetTextMinMax(self, value)
		endCapSettings.width = value
		RefreshEndCaps()
	end)

	RefreshSubControlStates()

	return yCoord
end

---Builds a color swatch bound to colorTable[key].color, persisting + live-updating via ColorOnMouseDown.
---@param parent Frame
---@param controlsTbl table # Swatch storage keyed by `key` (for refresh)
---@param colorTable table # The parent color table
---@param key string # Field within colorTable
---@param label string
---@param yCoord number
---@param classId integer
---@param specId integer
---@return Frame swatch
function TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, controlsTbl, colorTable, key, label, yCoord, classId, specId)
	local entry = colorTable[key]
	local value = (type(entry) == "table" and entry.color) or entry or "FFFFFFFF"
	local f = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, label, value, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controlsTbl[key] = f
	f:SetScript("OnMouseDown", function(self, button)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorTable, controlsTbl, key, nil, nil, classId, specId)
	end)
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
---@param onChanged function? # Optional callback run after the direction is cycled, for bars whose repaint
---                             is not driven by TriggerResourceBarUpdates
---@return Frame # Container frame with .Swatch1, .Swatch2, .DirectionButton, .Font children
function TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, description, colorEntry, sizeTotal, sizeFrame, posX, posY, tooltipNote, onChanged)
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
			if onChanged then
				onChanged()
			end
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
---@param onColorChanged function? # Optional callback run after the color is applied (e.g. UpdateHealthValues)
function TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorEntry, swatch2, classId, specId, onColorChanged)
	NormalizeGradientColorEntry(colorEntry)

	if button == "LeftButton" and colorEntry.gradientDirection ~= "disabled" then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorEntry.color2, true)
		TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, 1 - a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
			swatch2.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			colorEntry.color2 = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)

			if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
				if onColorChanged then
					onColorChanged()
				end
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

---Builds one gradient-capable color row: the two-swatch picker plus its direction cycle button, with both
---swatches wired to the color picker. The gradient twin of BuildColorRow -- same argument shape, same
---controls-table bookkeeping -- for panels whose fill color offers a gradient.
---@param parent Frame
---@param controlsTbl table # Controls table the built frame is stored in under `key`
---@param colorTable table # The settings table holding the color entry
---@param key string # Key into colorTable/controlsTbl
---@param label string # Label text beside the swatches
---@param yCoord number
---@param classId integer?
---@param specId integer?
---@param onChanged function? # Optional callback run after any of the three controls changes a value
---@return Frame # The gradient picker container
function TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorRow(parent, controlsTbl, colorTable, key, label, yCoord, classId, specId, onChanged)
	local colorEntry = colorTable[key]
	local f = self:BuildGradientColorPicker(parent, label, colorEntry, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord, L["GradientBarFillOnlyTooltip"], onChanged)
	controlsTbl[key] = f
	f.Swatch1:SetScript("OnMouseDown", function(_, button)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorTable, controlsTbl, key, nil, nil, classId, specId, onChanged)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(swatch, button)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorEntry, swatch, classId, specId, onChanged)
	end)
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
function TRB.Functions.OptionsUi.ColorPickers:BuildColorPickerWithEnable(parent, yCoord, controls, controlType, colorTable, namePrefix, value)
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

	controls.colors.threshold[value.name] = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, value.colorLocalization, colorTable[value.name].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	fColor = controls.colors.threshold[value.name]

	if value.colorScript ~= nil and type(value.colorScript) == "function" then
		fColor:SetScript("OnMouseDown", function(self, button, ...)
			value.colorScript(self, button, ...)
		end)
	else
		fColor:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorTable, controls.colors[controlType], value.name)
		end)
	end

	return yCoord, fColor, fCheckbox
end

