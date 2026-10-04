---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Glows = TRB.Functions.OptionsUi.Glows or {}

local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization
local Glow = TRB.Functions.Glow
local namePrefix = "TwintopResourceBar_Global_Glows"
local deleteActionTextColor = { r = 1, g = 0, b = 0, a = 1 }
local actionCellDimAlpha = 0.65
local actionCellBrightAlpha = 1.0
-- Solid swatch for the table's color cell: a white texture tinted by the trailing vertex-color triplet.
local colorSwatchMarkup = "|TInterface\\Buttons\\WHITE8X8:12:40:0:0:8:8:0:8:0:8:%d:%d:%d|t"
-- A slider row is its title, the bar, and the min/max labels under it -- a shade over 50px all told.
local sliderRowHeight = 60
-- Where the style's fields start, clear of the style dropdown and color controls above them. A slider's
-- title sits above its anchor, so the first row needs more headroom than the gap it looks like.
local fieldsTop = -100
local fieldsTopWithNote = -135

-- Ranges for every field the four glow styles read. `kind` decides which pooled widget renders it, and
-- the layout pass flows sliders two per row and checkboxes one per row from the style's field list.
local glowFieldDefs = {
	lines = { kind = "slider", label = L["GlowFieldLines"], min = 1, max = 30, step = 1, decimals = 0 },
	particleGroups = { kind = "slider", label = L["GlowFieldParticleGroups"], min = 1, max = 10, step = 1, decimals = 0 },
	frequency = { kind = "slider", label = L["GlowFieldFrequency"], min = -2, max = 2, step = 0.05, decimals = 2 },
	length = { kind = "slider", label = L["GlowFieldLength"], min = 0, max = 50, step = 1, decimals = 0 },
	thickness = { kind = "slider", label = L["GlowFieldThickness"], min = 1, max = 10, step = 1, decimals = 0 },
	scale = { kind = "slider", label = L["GlowFieldScale"], min = 0.1, max = 5, step = 0.1, decimals = 1 },
	duration = { kind = "slider", label = L["GlowFieldDuration"], min = 0.1, max = 5, step = 0.1, decimals = 1 },
	xOffset = { kind = "slider", label = L["GlowFieldXOffset"], min = -20, max = 20, step = 1, decimals = 0 },
	yOffset = { kind = "slider", label = L["GlowFieldYOffset"], min = -20, max = 20, step = 1, decimals = 0 },
	border = { kind = "checkbox", label = L["GlowFieldBorder"], tooltip = L["GlowFieldBorderTooltip"] },
	startAnim = { kind = "checkbox", label = L["GlowFieldStartAnim"], tooltip = L["GlowFieldStartAnimTooltip"] },
}

StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteGlow"] = {
	text = "%s",
	button1 = L["GlowDelete"],
	button2 = CANCEL,
	OnAccept = function(self, data)
		if data == nil then
			return
		end
		local glows = TRB.Data.settings.core and TRB.Data.settings.core.glows
		if glows then
			glows[data.guid] = nil
		end
		if data.refresh then
			data.refresh()
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

---Repaints every bar that could be showing a glow. Definition edits reach live bars on their own -- each
---node re-resolves per frame -- but a bar sitting idle needs the nudge to notice.
local function RefreshRuntime()
	TRB.Data.lookupDirty = true
	if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Puts a dragged slider value onto its field's step, then onto its precision so the multiply back out
---leaves no float dust for the edit box or the saved setting to show.
---@param fieldDef table
---@param value number
---@return number
local function SnapFieldValue(fieldDef, value)
	local steps = TRB.Functions.Number:RoundTo(value / fieldDef.step, 0, nil, true) --[[@as number]]
	return TRB.Functions.Number:RoundTo(steps * fieldDef.step, fieldDef.decimals, nil, true) --[[@as number]]
end

---@param parent Frame
---@param name string
---@param label string
---@param x number
---@param y number
---@return CheckButton
local function BuildCheckButton(parent, name, label, x, y)
	local checkbox = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", x, y)
	getglobal(checkbox:GetName() .. "Text"):SetText(label)
	return checkbox
end

---Builds the Glows tab: a table of the defined glows over an editor for the selected one, with a preview
---bar that runs the glow live as its values are changed.
---@param parent Frame # The tab's content frame
---@param controls table # The Global panel's controls table
---@param yCoord number
---@return number
function TRB.Functions.OptionsUi.Glows:GenerateGlowsPanel(parent, controls, yCoord)
	if parent == nil then
		return yCoord
	end

	controls.glows = controls.glows or {}
	local selectedGuid = nil
	local isRefreshing = false

	local columns = {
		{ name = "", width = 1, align = "CENTER" },
		{ name = L["Name"], width = 220, align = "LEFT", sort = 1, defaultsort = 1 },
		{ name = L["GlowTableHeaderStyle"], width = 150, align = "LEFT" },
		{ name = L["GlowTableHeaderColor"], width = 130, align = "LEFT" },
		{ name = "", width = 15, align = "CENTER", color = deleteActionTextColor },
	}

	yCoord = yCoord - 5
	controls.glows.header = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GlowsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 20

	controls.glows.note = TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["GlowsPanelNote"], oUi.xCoord, yCoord, oUi.maxOptionsWidth, 28)
	yCoord = yCoord - 30

	local tableContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	tableContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord - 10)
	tableContainer:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	tableContainer:SetHeight(35 + 5 * 15)

	local glowTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 5, 15, nil, tableContainer, false, false)
	controls.glows.table = glowTable

	tableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[3].width + columns[4].width + columns[5].width
		columns[2].width = math.max(120, w - fixedWidth - 30)
		glowTable:SetDisplayCols(columns)
	end)

	local function UpdateActionCell(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
		scrollingTable.DoCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
		if fShow and cellFrame ~= nil and cellFrame.text ~= nil then
			cellFrame.text:SetAlpha(actionCellDimAlpha)
		end
	end

	-- Name field, style-agnostic color controls and the preview stay pinned above the scrolling editor.
	local editorHeaderRow = CreateFrame("Frame", namePrefix .. "_EditorHeaderRow", parent)
	editorHeaderRow:SetPoint("TOPLEFT", tableContainer, "BOTTOMLEFT", 0, -2)
	editorHeaderRow:SetPoint("TOPRIGHT", tableContainer, "BOTTOMRIGHT", 0, -2)
	-- Just past the preview bar: enough for the wider styles to draw outside it, no more.
	editorHeaderRow:SetHeight(60)
	controls.glows.editorHeaderRow = editorHeaderRow

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["GlowAdd"], 0, 0, 140, 24)
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", editorHeaderRow, "TOPRIGHT", -5, -8)
	controls.glows.addButton = addButton

	local nameLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorHeaderRow, L["GlowNameLabel"], oUi.xCoord, 0, 110, 20)
	local nameBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(editorHeaderRow, "", 80, 260, 20, oUi.xCoord, -20)

	-- Sits in the gap between the name field and the Add button, with the rest of the row left empty: the
	-- wider styles draw well outside the bar they are attached to and would otherwise overlap the table.
	local previewLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorHeaderRow, L["GlowPreviewLabel"], 300, 0, 160, 16)
	local previewBar = CreateFrame("StatusBar", namePrefix .. "_Preview", editorHeaderRow, "BackdropTemplate")
	previewBar:SetSize(160, 22)
	previewBar:SetPoint("TOPLEFT", 300, -22)
	previewBar:SetStatusBarTexture("Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga")
	previewBar:SetMinMaxValues(0, 1)
	previewBar:SetValue(0.7)
	previewBar:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString("FF3C3C8C", true))
	previewBar:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = true,
		edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	previewBar:SetBackdropColor(0, 0, 0, 0.8)
	previewBar:SetBackdropBorderColor(0, 0, 0, 1)
	controls.glows.preview = previewBar

	nameLabel:Hide()
	nameBox:Hide()
	previewLabel:Hide()
	previewBar:Hide()

	local editorFrame = CreateFrame("Frame", namePrefix .. "_Editor", parent, "BackdropTemplate")
	editorFrame:SetPoint("TOPLEFT", editorHeaderRow, "BOTTOMLEFT", 0, -5)
	editorFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -oUi.xCoord, 3)
	editorFrame:Hide()
	controls.glows.editorFrame = editorFrame

	local editorScrollFrame = CreateFrame("ScrollFrame", namePrefix .. "_EditorScroll", editorFrame, "UIPanelScrollFrameTemplate")
	editorScrollFrame:SetPoint("TOPLEFT", editorFrame, "TOPLEFT", 0, 0)
	editorScrollFrame:SetPoint("BOTTOMRIGHT", editorFrame, "BOTTOMRIGHT", -20, 0)
	local editorContent = CreateFrame("Frame", nil, editorScrollFrame)
	editorContent:SetSize(editorScrollFrame:GetWidth() or 600, 1)
	editorScrollFrame:SetScrollChild(editorContent)
	editorScrollFrame:HookScript("OnSizeChanged", function(self, w, h)
		editorContent:SetWidth(w)
	end)

	local function GetSelectedGlow()
		return Glow:Get(selectedGuid)
	end

	local styleOptions = {}
	for _, typeDef in ipairs(Glow:GetTypes()) do
		styleOptions[#styleOptions + 1] = { value = typeDef.key, label = typeDef.label }
	end

	local SetTableValues, RefreshEditor, RefreshPreview

	local styleDropdown = TRB.Functions.OptionsUi.Primitives:BuildDropdown(editorContent, namePrefix .. "_Style", L["GlowStyle"], styleOptions,
		function()
			local glow = GetSelectedGlow()
			return glow and glow.type or "pixel"
		end,
		function(value)
			local glow = GetSelectedGlow()
			if glow == nil then return end
			glow.type = value
			SetTableValues()
			RefreshEditor(selectedGuid)
			RefreshRuntime()
		end,
		oUi.xCoord, 0)

	local useCustomColorCheckbox = BuildCheckButton(editorContent, namePrefix .. "_UseCustomColor", L["GlowUseCustomColor"], oUi.xCoord2, -20)
	---@diagnostic disable-next-line: inject-field
	useCustomColorCheckbox.tooltip = L["GlowUseCustomColorTooltip"]

	local colorPicker = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(editorContent, L["GlowColor"], "FFF2F252", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, -48)
	---@cast colorPicker Button

	-- Full-width row of its own: the style's fields start below it, so it can't collide with a slider.
	local colorNote = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorContent, L["GlowUseCustomColorNote"], oUi.xCoord, -82, oUi.maxOptionsWidth, 28)

	-- One widget per field, created up front and re-laid out per style, so switching style never rebuilds
	-- the panel (which would drop the scroll position and every script handler with it).
	local fieldWidgets = {}
	for fieldKey, fieldDef in pairs(glowFieldDefs) do
		if fieldDef.kind == "slider" then
			local slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, fieldDef.label, fieldDef.min, fieldDef.max,
				fieldDef.min, fieldDef.step, fieldDef.decimals, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, 0)
			slider:SetScript("OnValueChanged", function(self, value)
				if isRefreshing then return end
				local glow = GetSelectedGlow()
				if glow == nil then return end
				-- Snap before clamping: EditBoxSetTextMinMax displays whatever it is handed, so a raw
				-- dragged value would show every digit the drag produced.
				value = SnapFieldValue(fieldDef, value)
				value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
				value = SnapFieldValue(fieldDef, value)
				if glow[fieldKey] == value then return end
				glow[fieldKey] = value
				RefreshPreview()
				RefreshRuntime()
			end)
			fieldWidgets[fieldKey] = slider
		else
			local checkbox = BuildCheckButton(editorContent, namePrefix .. "_" .. fieldKey, fieldDef.label, oUi.xCoord, 0)
			---@diagnostic disable-next-line: inject-field
			checkbox.tooltip = fieldDef.tooltip
			checkbox:SetScript("OnClick", function(self)
				local glow = GetSelectedGlow()
				if glow == nil then return end
				glow[fieldKey] = self:GetChecked()
				RefreshPreview()
				RefreshRuntime()
			end)
			fieldWidgets[fieldKey] = checkbox
		end
	end

	---Runs the selected glow on the preview bar. With "always use this color" off the swatch stands in for
	---whatever Color Indicator turns the glow on, which is what the note under it says.
	RefreshPreview = function()
		local glow = GetSelectedGlow()
		if glow == nil or not previewBar:IsShown() then
			Glow:Clear(previewBar)
			return
		end
		Glow:Apply(previewBar, glow, glow.color)
	end

	---Lays the style's fields out two sliders per row, then one checkbox per row, hiding everything the
	---current style does not read.
	---@param glow table
	local function RepositionEditorControls(glow)
		for _, widget in pairs(fieldWidgets) do
			widget:Hide()
		end

		local typeDef = Glow:GetTypeDefinition(glow.type)
		local fields = typeDef and typeDef.fields or {}
		local sliders = {}
		local checkboxes = {}
		for _, fieldKey in ipairs(fields) do
			local fieldDef = glowFieldDefs[fieldKey]
			if fieldDef ~= nil then
				if fieldDef.kind == "slider" then
					sliders[#sliders + 1] = fieldKey
				else
					checkboxes[#checkboxes + 1] = fieldKey
				end
			end
		end

		local y = colorNote:IsShown() and fieldsTopWithNote or fieldsTop
		for index, fieldKey in ipairs(sliders) do
			local widget = fieldWidgets[fieldKey]
			local isRightColumn = (index % 2) == 0
			widget:ClearAllPoints()
			widget:SetPoint("TOPLEFT", (isRightColumn and oUi.xCoord2 or oUi.xCoord) + 18, y)
			widget:Show()
			if isRightColumn then
				y = y - sliderRowHeight
			end
		end
		if (#sliders % 2) == 1 then
			y = y - sliderRowHeight
		end

		for _, fieldKey in ipairs(checkboxes) do
			local widget = fieldWidgets[fieldKey]
			widget:ClearAllPoints()
			widget:SetPoint("TOPLEFT", oUi.xCoord, y)
			widget:Show()
			y = y - 20
		end

		editorContent:SetHeight(math.max(1, -y + 30))
	end

	RefreshEditor = function(guid)
		selectedGuid = guid
		local glow = GetSelectedGlow()

		if glow == nil then
			selectedGuid = nil
			nameLabel:Hide()
			nameBox:Hide()
			previewLabel:Hide()
			Glow:Clear(previewBar)
			previewBar:Hide()
			editorFrame:Hide()
			if glowTable.ClearSelection then
				glowTable:ClearSelection()
			end
			return
		end

		isRefreshing = true
		nameLabel:Show()
		nameBox:Show()
		previewLabel:Show()
		previewBar:Show()
		editorFrame:Show()

		nameBox:SetText(glow.name or L["GlowDefaultName"])
		styleDropdown:SetDefaultText(Glow:GetTypeLabel(glow.type))
		useCustomColorCheckbox:SetChecked(glow.useCustomColor == true)
		colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(glow.color or "FFF2F252", true))
		colorNote:SetShown(glow.useCustomColor ~= true)

		for fieldKey, widget in pairs(fieldWidgets) do
			local fieldDef = glowFieldDefs[fieldKey]
			if fieldDef.kind == "slider" then
				local value = SnapFieldValue(fieldDef, tonumber(glow[fieldKey]) or fieldDef.min)
				value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(widget, value)
				widget:SetValue(value)
			else
				widget:SetChecked(glow[fieldKey] == true)
			end
		end

		RepositionEditorControls(glow)
		RefreshPreview()
		isRefreshing = false
	end

	SetTableValues = function()
		local dataTable = {}
		for _, glow in ipairs(Glow:GetOrdered()) do
			local colorText
			if glow.useCustomColor then
				local r, g, b = TRB.Functions.Color:GetRGBAFromString(glow.color or "FFF2F252")
				colorText = string.format(colorSwatchMarkup, r, g, b)
			else
				colorText = L["GlowTableColorFromIndicator"]
			end
			table.insert(dataTable, {
				cols = {
					{ value = glow.guid },
					{ value = glow.name or L["GlowDefaultName"] },
					{ value = Glow:GetTypeLabel(glow.type) },
					{ value = colorText },
					{ value = "X", color = deleteActionTextColor, DoCellUpdate = UpdateActionCell },
				}
			})
		end
		glowTable:SetData(dataTable)
		glowTable:EnableSelection(true)
	end

	nameBox:SetScript("OnTextChanged", function(self)
		if isRefreshing then return end
		local glow = GetSelectedGlow()
		if glow == nil then return end
		glow.name = self:GetText()
		SetTableValues()
	end)

	useCustomColorCheckbox:SetScript("OnClick", function(self)
		local glow = GetSelectedGlow()
		if glow == nil then return end
		glow.useCustomColor = self:GetChecked()
		SetTableValues()
		-- The note takes a row of its own, so showing or hiding it re-flows every field below.
		RefreshEditor(selectedGuid)
		RefreshRuntime()
	end)

	colorPicker:SetScript("OnMouseDown", function(self, button)
		local glow = GetSelectedGlow()
		if glow == nil then return end
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, glow, { color = colorPicker }, "color", nil, nil, nil, nil, function()
			SetTableValues()
			RefreshPreview()
		end)
	end)

	addButton:SetScript("OnClick", function()
		local core = TRB.Data.settings.core
		if core == nil then return end
		core.glows = core.glows or {}
		local guid = TRB.Functions.String:Guid()
		core.glows[guid] = Glow:DefaultGlow(guid)
		SetTableValues()
		RefreshEditor(guid)
	end)

	glowTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnEnter(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow ~= nil and realrow > 0 and column == 5 and cellFrame ~= nil and cellFrame.text ~= nil then
				cellFrame.text:SetAlpha(actionCellBrightAlpha)
				GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
				GameTooltip:SetText(L["GlowDeleteActionTooltip"], 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnLeave(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if column == 5 then
				if cellFrame ~= nil and cellFrame.text ~= nil then
					cellFrame.text:SetAlpha(actionCellDimAlpha)
				end
				GameTooltip:Hide()
			end
		end,
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button)
			if button ~= "LeftButton" or realrow == nil or realrow <= 0 then
				return
			end
			local guid = data[realrow].cols[1].value
			if column == 5 then
				local glow = Glow:Get(guid)
				StaticPopup_Show("TwintopResourceBar_ConfirmDeleteGlow", string.format(L["GlowDeleteConfirmation"], glow and glow.name or L["GlowDefaultName"]), nil, {
					guid = guid,
					refresh = function()
						SetTableValues()
						RefreshEditor(nil)
						RefreshRuntime()
					end,
				})
			else
				RefreshEditor(guid)
			end
		end,
	})

	-- The preview animates on an OnUpdate; leaving the tab parks it until the panel is opened again.
	editorHeaderRow:HookScript("OnHide", function()
		Glow:Clear(previewBar)
	end)

	-- Built once and kept, so a profile switch or an import can leave the table showing glows that are
	-- gone. Resync whenever the tab comes back into view.
	parent:HookScript("OnShow", function()
		SetTableValues()
		RefreshEditor(selectedGuid)
	end)

	SetTableValues()

	return yCoord - 520
end

---The Glows tab definition for the Global Options tab strip.
---@param controls table
---@return table
function TRB.Functions.OptionsUi.Glows:BuildTabDefinition(controls)
	return {
		key = "glows",
		label = L["TabGlows"],
		width = oUi.tabWidth.small,
		isManualScrollFrame = true,
		constructor = function(scrollChild)
			TRB.Functions.OptionsUi.Glows:GenerateGlowsPanel(scrollChild, controls, 5)
		end,
	}
end
