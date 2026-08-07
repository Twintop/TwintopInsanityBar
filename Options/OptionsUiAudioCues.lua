---@diagnostic disable: undefined-field, undefined-global, inject-field
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.AudioCues = TRB.Functions.OptionsUi.AudioCues or {}

local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization
local speakerIconMarkup = "|TInterface\\Common\\VoiceChat-Speaker:12|t"
local actionCellDimAlpha = 0.65
local actionCellBrightAlpha = 1.0
local deleteActionTextColor = { r = 1, g = 0.12, b = 0.12, a = 1 }

StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteAudioCue"] = {
	text = "%s",
	button1 = L["AudioCueDelete"],
	button2 = CANCEL,
	OnAccept = function(self, data)
		if data == nil then
			return
		end

		if data.spec ~= nil and data.spec.audio ~= nil then
			data.spec.audio[data.id] = nil
			TRB.Functions.AudioCues:InvalidateCache(data.spec)
		end

		if data.refresh then
			data.refresh(nil)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

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

---Builds a left-justified block of body text that wraps to whatever width it is anchored to.
---@param parent Frame
---@param width number? # Omit when the caller anchors both horizontal edges instead
---@return FontString
local function BuildWrappedText(parent, width)
	local fontString = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	fontString:SetJustifyH("LEFT")
	fontString:SetJustifyV("TOP")
	---@diagnostic disable-next-line: redundant-parameter
	fontString:SetWordWrap(true)
	if width ~= nil then
		fontString:SetWidth(width)
	end
	return fontString
end

---Builds the display-ordered cue list: built-ins in registry order first, then each counter
---source's cues ordered by threshold value. The runtime evaluates counter cues highest-first; this
---is a reading order for the table, so it runs lowest-first.
---@param spec table
---@param definition TRB.Classes.AudioCueDefinition
---@return table[]
local function GetOrderedEntries(spec, definition)
	local entries = {}
	if spec == nil or spec.audio == nil or definition == nil then
		return entries
	end

	for _, builtIn in ipairs(definition.builtIns) do
		local cue = spec.audio[builtIn.id]
		if cue ~= nil then
			table.insert(entries, { id = builtIn.id, cue = cue, builtIn = builtIn })
		end
	end

	for _, source in ipairs(definition.counters) do
		local sourceCues = {}
		for id, cue in pairs(spec.audio) do
			if type(cue) == "table" and cue.kind == "counter" and cue.source == source.id then
				table.insert(sourceCues, { id = id, cue = cue, source = source })
			end
		end

		table.sort(sourceCues, function(a, b)
			local aValue = (a.cue.configuration and a.cue.configuration.thresholdValue) or 0
			local bValue = (b.cue.configuration and b.cue.configuration.thresholdValue) or 0
			if aValue ~= bValue then
				return aValue < bValue
			end
			return tostring(a.id) < tostring(b.id)
		end)

		for _, entry in ipairs(sourceCues) do
			table.insert(entries, entry)
		end
	end

	return entries
end

---Formats a counter cue's threshold for the table's Trigger column.
---@param source TRB.Classes.AudioCueCounterSource
---@param value number?
---@param playOnDrop boolean?
---@return string
local function FormatTrigger(source, value, playOnDrop)
	local formatted = string.format("%." .. (source.decimals or 0) .. "f", value or 0)
	if source.compare == "exact" then
		return string.format(L["AudioCueTriggerExact"], source.label, formatted)
	elseif source.compare == "atMost" then
		return string.format(L["AudioCueTriggerAtMost"], source.label, formatted)
	elseif playOnDrop then
		return string.format(L["AudioCueTriggerAtLeastWithDrop"], source.label, formatted)
	end
	return string.format(L["AudioCueTriggerAtLeast"], source.label, formatted)
end

---Generates the Audio Cues panel: a table of every cue the spec supports, with a detail editor
---below it. Built-in cues are fixed; cues bound to a counter source can be added and deleted.
---@param parent Frame
---@param controls table
---@param spec table
---@param classId integer
---@param specId integer
---@param yCoord number
---@return number
function TRB.Functions.OptionsUi.AudioCues:GenerateAudioCuesPanel(parent, controls, spec, classId, specId, yCoord)
	if parent == nil or spec == nil then
		return yCoord
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local lowerClassName = string.lower(className)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(lowerClassName, specName)
	local definition = TRB.Functions.AudioCues:GetDefinition(compositeKey)
	if definition == nil then
		return yCoord
	end

	spec.audio = spec.audio or {}
	controls.audioCues = controls.audioCues or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.dropDown = controls.dropDown or {}

	local namePrefix = lowerClassName .. "_" .. specName .. "_AudioCues"
	local selectedId = nil
	local isRefreshing = false
	local soundPairs = TRB.Functions.OptionsUi.Media:GetSoundPairs()
	local soundPairsByName = TRB.Functions.OptionsUi.Media:GetSoundPairsByName()

	local function GetCurrentSpec()
		return TRB.Data.settings[lowerClassName] and TRB.Data.settings[lowerClassName][specName]
	end

	local function RefreshRuntime()
		local currentSpec = GetCurrentSpec()
		if currentSpec ~= nil then
			TRB.Functions.AudioCues:InvalidateCache(currentSpec)
		end
	end

	local columns = {
		{ name = "", width = 1, align = "CENTER" },
		{ name = "", width = 22, align = "CENTER" },
		{ name = L["Name"], width = 170, align = "LEFT", sort = 1, defaultsort = 1 },
		{ name = L["AudioCueTableHeaderType"], width = 80, align = "LEFT" },
		{ name = L["AudioCueTableHeaderTrigger"], width = 200, align = "LEFT" },
		{ name = L["AudioCueTableHeaderSound"], width = 120, align = "LEFT" },
		{ name = L["Enabled"], width = 70, align = "LEFT" },
		{ name = "", width = 15, align = "CENTER", color = { r = 1, g = 0, b = 0, a = 1 } },
	}

	yCoord = yCoord - 5
	controls.audioCues.header = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioCuesHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 20

	local tableContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	tableContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord - 10)
	tableContainer:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	tableContainer:SetHeight(35 + 7 * 15)

	local cueTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 7, 15, nil, tableContainer, false, false)
	controls.audioCues.table = cueTable

	tableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[4].width + columns[5].width + columns[6].width + columns[7].width + columns[8].width
		columns[3].width = math.max(120, w - fixedWidth - 30)
		cueTable:SetDisplayCols(columns)
	end)

	local function UpdateActionCell(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
		scrollingTable.DoCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
		if fShow and cellFrame ~= nil and cellFrame.text ~= nil then
			cellFrame.text:SetAlpha(actionCellDimAlpha)
		end
	end

	local function SetActionCellHoverState(cellFrame, isHovering)
		if cellFrame ~= nil and cellFrame.text ~= nil then
			cellFrame.text:SetAlpha(isHovering and actionCellBrightAlpha or actionCellDimAlpha)
		end
	end

	local function ShowActionCellTooltip(cellFrame, text)
		if cellFrame == nil or text == nil then
			return
		end
		GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
		GameTooltip:SetText(text, 1, 1, 1, 1, true)
		GameTooltip:Show()
	end

	---Shows a cue's name, firing condition and description on row hover.
	---@param cellFrame Frame?
	---@param tooltip table? # { title, trigger, description }
	local function ShowRowTooltip(cellFrame, tooltip)
		if cellFrame == nil or tooltip == nil then
			return
		end

		GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
		GameTooltip:SetText(tooltip.title, 1, 1, 1, 1, true)
		if tooltip.trigger ~= nil then
			GameTooltip:AddLine(tooltip.trigger, 1, 0.82, 0, true)
		end
		if tooltip.description ~= nil then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(tooltip.description, 1, 1, 1, true)
		end
		GameTooltip:Show()
	end

	-- Fixed header row above the editor: name field plus the always-visible Add button.
	local editorHeaderRow = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_EditorHeaderRow", parent)
	editorHeaderRow:SetPoint("TOPLEFT", tableContainer, "BOTTOMLEFT", 0, -2)
	editorHeaderRow:SetPoint("TOPRIGHT", tableContainer, "BOTTOMRIGHT", 0, -2)
	editorHeaderRow:SetHeight(45)
	controls.audioCues.editorHeaderRow = editorHeaderRow

	local addButton = nil
	if #definition.counters > 0 then
		addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["AudioCueAdd"], 0, 0, 170, 24)
		addButton:ClearAllPoints()
		addButton:SetPoint("TOPRIGHT", editorHeaderRow, "TOPRIGHT", -5, -8)
		controls.audioCues.addButton = addButton
	end

	local nameLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorHeaderRow, L["AudioCueNameLabel"], oUi.xCoord, 0, 110, 20)
	local nameBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(editorHeaderRow, "", 80, 260, 20, oUi.xCoord, -20)
	-- Built-in cues take their name from the registry, so they get read-only text in the box's place.
	local nameText = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorHeaderRow, "", oUi.xCoord + 2, -20, 260, 20, GameFontHighlight)
	nameLabel:Hide()
	nameBox:Hide()
	nameText:Hide()

	local editorFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_Editor", parent, "BackdropTemplate")
	editorFrame:SetPoint("TOPLEFT", editorHeaderRow, "BOTTOMLEFT", 0, -5)
	editorFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -oUi.xCoord, 3)
	editorFrame:Hide()
	controls.audioCues.editorFrame = editorFrame

	local editorScrollFrame = CreateFrame("ScrollFrame", "TwintopResourceBar_" .. namePrefix .. "_EditorScroll", editorFrame, "UIPanelScrollFrameTemplate")
	editorScrollFrame:SetPoint("TOPLEFT", editorFrame, "TOPLEFT", 0, 0)
	editorScrollFrame:SetPoint("BOTTOMRIGHT", editorFrame, "BOTTOMRIGHT", -20, 0)
	local editorContent = CreateFrame("Frame", nil, editorScrollFrame)
	editorContent:SetSize(editorScrollFrame:GetWidth() or 600, 1)
	editorScrollFrame:SetScrollChild(editorContent)
	editorScrollFrame:HookScript("OnSizeChanged", function(self, w, h)
		editorContent:SetWidth(w)
	end)

	local enabledCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_Enabled", L["AudioCueEnabledCheckbox"], oUi.xCoord, 0)
	enabledCheckbox.tooltip = L["AudioCueEnabledCheckboxTooltip"]

	local soundDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Sound", editorContent, "WowStyle1DropdownTemplate")
	soundDropdown:SetWidth(oUi.sliderWidth)
	soundDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["AudioCueSoundLabel"], oUi.xCoord, -30)
	soundDropdown.label.font:SetFontObject(GameFontNormal)
	soundDropdown:SetPoint("TOPLEFT", oUi.xCoord, -55)

	-- A built-in cue's trigger is fixed, so it reads as text where a counter cue's slider sits.
	local triggerHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["AudioCueTriggerLabel"], oUi.xCoord2, -30)
	triggerHeader.font:SetFontObject(GameFontNormal)
	local triggerText = BuildWrappedText(editorContent, oUi.sliderWidth)
	triggerText:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2 + 2, -55)
	triggerHeader:Hide()
	triggerText:Hide()

	-- Spans both columns, below everything else: descriptions run long enough to need the width.
	local descriptionHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["AudioCueDescriptionLabel"], oUi.xCoord, 0)
	descriptionHeader.font:SetFontObject(GameFontNormal)
	local descriptionText = BuildWrappedText(editorContent)
	descriptionHeader:Hide()
	descriptionText:Hide()

	-- One threshold slider per counter source, created on demand. BuildSlider bakes the decimal
	-- precision into its EditBox handlers, so a single shared slider cannot serve sources of
	-- differing precision (Destruction Soul Shards run to 1 decimal, every other source is integer).
	local thresholdSliders = {}

	-- Declared extra controls for built-in cues, created lazily and reused across selections.
	local configControls = {}

	-- Sits under the threshold slider; only shown for sources whose cues can fire on the way down.
	local playOnDropCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_PlayOnDrop",
		L["AudioCuePlayOnDropCheckbox"], oUi.xCoord2, -115)
	playOnDropCheckbox.tooltip = L["AudioCuePlayOnDropCheckboxTooltip"]
	playOnDropCheckbox:Hide()

	local function GetSelectedCue()
		local currentSpec = GetCurrentSpec()
		return selectedId and currentSpec and currentSpec.audio and currentSpec.audio[selectedId] or nil
	end

	-- Row hover text, rebuilt with the table so the OnEnter handler can look it up by cue id.
	local rowTooltips = {}

	local function SetTableValues()
		local currentSpec = GetCurrentSpec()
		if currentSpec == nil then
			return
		end

		local dataTable = {}
		wipe(rowTooltips)
		for _, entry in ipairs(GetOrderedEntries(currentSpec, definition)) do
			local cue = entry.cue
			local isCounter = entry.source ~= nil
			local displayName = isCounter and (cue.name or entry.source.defaultName) or entry.builtIn.label
			local typeLabel = isCounter and L["AudioCueTypeCustom"] or L["AudioCueTypeBuiltIn"]
			local trigger = isCounter
				and FormatTrigger(entry.source, cue.configuration and cue.configuration.thresholdValue,
					cue.configuration and cue.configuration.playOnDrop)
				or entry.builtIn.trigger
			local soundName = (cue.soundName ~= nil and cue.soundName ~= "") and cue.soundName or L["AudioCueSoundNone"]
			local enabledText = cue.enabled and ("|cFF00FF00" .. L["BarTextVariablesStatusYes"] .. "|r") or ("|cFFFF0000" .. L["BarTextVariablesStatusNo"] .. "|r")

			rowTooltips[entry.id] = {
				title = displayName,
				trigger = trigger,
				description = isCounter and entry.source.description or entry.builtIn.tooltip,
			}

			table.insert(dataTable, {
				cols = {
					{ value = entry.id },
					{ value = cue.enabled and speakerIconMarkup or "" },
					{ value = displayName },
					{ value = typeLabel },
					{ value = trigger },
					{ value = soundName },
					{ value = enabledText },
					{ value = isCounter and "X" or "", color = isCounter and deleteActionTextColor or nil, DoCellUpdate = isCounter and UpdateActionCell or nil },
				}
			})
		end
		cueTable:SetData(dataTable)
		cueTable:EnableSelection(true)
	end

	---Gets (creating on first use) the threshold slider for a counter source.
	---@param source TRB.Classes.AudioCueCounterSource
	local function GetThresholdSlider(source)
		if thresholdSliders[source.id] == nil then
			thresholdSliders[source.id] = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent,
				source.sliderLabel, source.min, source.max, source.min, source.step, source.decimals,
				oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, -55)
		end
		return thresholdSliders[source.id]
	end

	local function HideThresholdSliders()
		for _, slider in pairs(thresholdSliders) do
			slider:Hide()
		end
	end

	---Hides every declared config control; RefreshEditor re-shows only the ones the selection needs.
	local function HideConfigControls()
		for _, control in pairs(configControls) do
			control:Hide()
			if control.label ~= nil then
				control.label:Hide()
			end
		end
	end

	---Gets (creating on first use) the control bound to a built-in cue's configuration field. Each
	---descriptor gets its own control because BuildSlider bakes decimal precision into its handlers;
	---RefreshEditor positions it, since the trigger text above it wraps to a variable height.
	---@param builtInId string
	---@param descriptor TRB.Classes.AudioCueConfigControl
	local function GetConfigControl(builtInId, descriptor)
		local key = builtInId .. "_" .. descriptor.key
		if configControls[key] ~= nil then
			return configControls[key]
		end

		local control
		if descriptor.control == "checkbox" then
			control = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_Config_" .. key, descriptor.label, oUi.xCoord2, 0)
			control.tooltip = descriptor.tooltip
		else
			control = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, descriptor.label,
				descriptor.min or 0, descriptor.max or 10, descriptor.min or 0,
				descriptor.step or 1, descriptor.decimals or 0,
				oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, 0)
		end

		---@diagnostic disable-next-line: inject-field
		control.isSlider = descriptor.control ~= "checkbox"
		configControls[key] = control
		return control
	end

	---Re-anchors a config control below the right column's running cursor and returns the new cursor.
	---BuildSlider offsets its own x by 18 and hangs its title above the bar, so sliders need both a
	---horizontal correction and leading room that checkboxes do not.
	---@param control Frame
	---@param cursor number
	---@return number
	local function PlaceConfigControl(control, cursor)
		control:ClearAllPoints()
		if control.isSlider then
			control:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2 + 18, cursor - 25)
			return cursor - 80
		end
		control:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2, cursor - 5)
		return cursor - 35
	end

	local function RefreshEditor(id)
		selectedId = id
		local currentSpec = GetCurrentSpec()
		local cue = GetSelectedCue()

		if cue == nil or currentSpec == nil then
			nameLabel:Hide()
			nameBox:Hide()
			nameText:Hide()
			editorFrame:Hide()
			return
		end

		isRefreshing = true

		local source = cue.kind == "counter" and TRB.Functions.AudioCues:GetCounterSource(compositeKey, cue.source) or nil
		local builtIn = cue.kind == "builtin" and TRB.Functions.AudioCues:GetBuiltIn(compositeKey, cue.id) or nil

		nameLabel:Show()
		if source ~= nil then
			nameBox:SetText(cue.name or source.defaultName)
			nameBox:Show()
			nameText:Hide()
		else
			nameText.font:SetText(builtIn ~= nil and builtIn.label or cue.name)
			nameText:Show()
			nameBox:Hide()
		end

		enabledCheckbox:SetChecked(cue.enabled == true)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, cue.enabled == true, true)

		soundDropdown:SetDefaultText((cue.soundName ~= nil and cue.soundName ~= "") and cue.soundName or L["AudioCueSoundNone"])
		soundDropdown:SetupMenu(function(dropdown, rootDescription)
			for _, v in pairs(soundPairs) do
				rootDescription:CreateRadio(v[1], function(value)
					return value == cue.sound
				end, function(newValue)
					cue.sound = newValue
					cue.soundName = soundPairsByName[newValue]
					soundDropdown:SetDefaultText((cue.soundName ~= nil and cue.soundName ~= "") and cue.soundName or L["AudioCueSoundNone"])
					PlaySoundFile(cue.sound, TRB.Data.settings.core.audio.channel.channel)
					SetTableValues()
				end, v[2])
			end
			rootDescription:SetScrollMode(400)
		end)

		HideConfigControls()
		HideThresholdSliders()
		triggerHeader:Hide()
		triggerText:Hide()

		-- The two columns grow independently; the description sits below whichever runs longer.
		local editorY = -55
		local leftBottom = editorY - 30
		local rightBottom = editorY

		if source ~= nil then
			cue.configuration = cue.configuration or {}
			local slider = GetThresholdSlider(source)
			slider:ClearAllPoints()
			slider:SetPoint("TOPLEFT", oUi.xCoord2 + 18, editorY)
			slider:SetValue(cue.configuration.thresholdValue or source.min)
			slider.EditBox:SetText(string.format("%." .. source.decimals .. "f", cue.configuration.thresholdValue or source.min))
			slider:SetScript("OnValueChanged", function(self, value)
				value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
				value = TRB.Functions.Number:RoundTo(value, source.decimals, nil, true)
				self.EditBox:SetText(value)
				if isRefreshing then
					return
				end
				cue.configuration.thresholdValue = value
				RefreshRuntime()
				SetTableValues()
			end)
			slider:Show()
			rightBottom = editorY - 55

			if TRB.Functions.AudioCues:SourceSupportsPlayOnDrop(source) then
				playOnDropCheckbox:ClearAllPoints()
				playOnDropCheckbox:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2, rightBottom - 5)
				playOnDropCheckbox:SetChecked(cue.configuration.playOnDrop == true)
				playOnDropCheckbox:SetScript("OnClick", function(self)
					cue.configuration.playOnDrop = self:GetChecked()
					RefreshRuntime()
					SetTableValues()
				end)
				playOnDropCheckbox:Show()
				rightBottom = rightBottom - 35
			else
				playOnDropCheckbox:Hide()
			end
		else
			playOnDropCheckbox:Hide()
		end

		if builtIn ~= nil then
			triggerText:SetText(builtIn.trigger)
			triggerHeader:Show()
			triggerText:Show()
			rightBottom = editorY - math.max(oUi.sliderHeight, triggerText:GetStringHeight()) - 10

			for _, descriptor in ipairs(builtIn.config or {}) do
				cue.configuration = cue.configuration or {}
				local control = GetConfigControl(builtIn.id, descriptor)
				rightBottom = PlaceConfigControl(control, rightBottom)

				if descriptor.control == "checkbox" then
					control:SetChecked(cue.configuration[descriptor.key] == true)
					control:SetScript("OnClick", function(self)
						cue.configuration[descriptor.key] = self:GetChecked()
					end)
				else
					local value = cue.configuration[descriptor.key] or descriptor.min or 0
					control:SetValue(value)
					control.EditBox:SetText(string.format("%." .. (descriptor.decimals or 0) .. "f", value))
					control:SetScript("OnValueChanged", function(self, newValue)
						newValue = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, newValue)
						newValue = TRB.Functions.Number:RoundTo(newValue, descriptor.decimals or 0, nil, true)
						self.EditBox:SetText(newValue)
						if isRefreshing then
							return
						end
						cue.configuration[descriptor.key] = newValue
					end)
				end

				control:Show()
				if control.label ~= nil then
					control.label:Show()
				end
			end
		end

		local description = (source ~= nil and source.description) or (builtIn ~= nil and builtIn.tooltip) or nil
		if description ~= nil then
			local descriptionY = math.min(leftBottom, rightBottom) - 15
			descriptionHeader:ClearAllPoints()
			descriptionHeader:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord, descriptionY)
			descriptionText:ClearAllPoints()
			descriptionText:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord + 2, descriptionY - 25)
			descriptionText:SetPoint("TOPRIGHT", editorContent, "TOPRIGHT", -10, descriptionY - 25)
			descriptionText:SetText(description)
			descriptionHeader:Show()
			descriptionText:Show()
		else
			descriptionHeader:Hide()
			descriptionText:Hide()
		end

		editorFrame:Show()
		isRefreshing = false
	end

	nameBox:SetScript("OnTextChanged", function(self)
		if isRefreshing then
			return
		end
		local cue = GetSelectedCue()
		if cue ~= nil then
			cue.name = self:GetText()
			SetTableValues()
		end
	end)

	enabledCheckbox:SetScript("OnClick", function(self)
		local cue = GetSelectedCue()
		if cue == nil then
			return
		end
		cue.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, cue.enabled, true)
		if cue.enabled and cue.sound ~= nil and cue.sound ~= "" then
			PlaySoundFile(cue.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		RefreshRuntime()
		SetTableValues()
	end)

	---Creates a cue bound to the given counter source and selects it for editing.
	---@param source TRB.Classes.AudioCueCounterSource
	local function AddCue(source)
		local currentSpec = GetCurrentSpec()
		if currentSpec == nil then
			return
		end

		local id = TRB.Functions.String:Guid()
		currentSpec.audio[id] = {
			id = id,
			kind = "counter",
			source = source.id,
			name = source.defaultName,
			enabled = true,
			sound = TRB.Data.constants.defaultSettings.sounds.sound,
			soundName = TRB.Data.constants.defaultSettings.sounds.soundName,
			configuration = {
				thresholdValue = source.min,
			},
		}

		RefreshRuntime()
		SetTableValues()
		RefreshEditor(id)
	end

	if addButton ~= nil then
		addButton:SetScript("OnClick", function(self)
			if #definition.counters == 1 then
				AddCue(definition.counters[1])
				return
			end

			-- More than one countable source on this spec, so ask which one the cue watches.
			MenuUtil.CreateContextMenu(self, function(owner, rootDescription)
				rootDescription:CreateTitle(L["AudioCueAddSourceTitle"])
				for _, source in ipairs(definition.counters) do
					rootDescription:CreateButton(source.label, function()
						AddCue(source)
					end)
				end
			end)
		end)
	end

	cueTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnEnter(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow == nil or realrow <= 0 then
				return
			end

			if column == 8 and data[realrow].cols[8].value == "X" then
				SetActionCellHoverState(cellFrame, true)
				ShowActionCellTooltip(cellFrame, L["AudioCueDeleteActionTooltip"])
			else
				ShowRowTooltip(cellFrame, rowTooltips[data[realrow].cols[1].value])
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnLeave(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if column == 8 then
				SetActionCellHoverState(cellFrame, false)
			end
			GameTooltip:Hide()
		end,
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button)
			if button ~= "LeftButton" or realrow == nil or realrow <= 0 then
				return
			end

			local id = data[realrow].cols[1].value
			if column == 8 and data[realrow].cols[8].value == "X" then
				local currentSpec = GetCurrentSpec()
				local cue = currentSpec and currentSpec.audio and currentSpec.audio[id]
				local source = cue and TRB.Functions.AudioCues:GetCounterSource(compositeKey, cue.source)
				StaticPopup_Show("TwintopResourceBar_ConfirmDeleteAudioCue",
					string.format(L["AudioCueDeleteConfirmation"], (cue and cue.name) or (source and source.defaultName) or ""), nil, {
						spec = currentSpec,
						id = id,
						refresh = function()
							SetTableValues()
							RefreshEditor(nil)
							RefreshRuntime()
						end,
					})
			else
				RefreshEditor(id)
			end
		end,
	})

	SetTableValues()

	return yCoord - 820
end

---Builds the Audio Cues tab definition for a spec's BuildTabGroup list.
---@param className string
---@param specName string
---@param controls table
---@return table
function TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition(className, specName, controls)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
	local specRegistryEntry = TRB.Functions.Character:GetSpecRegistryEntry(compositeKey)
	return {
		key = "audioCues",
		label = L["TabAudioCues"],
		width = oUi.tabWidth.medium,
		isManualScrollFrame = true,
		constructor = function(scrollChild)
			local spec = TRB.Data.settings[className] and TRB.Data.settings[className][specName]
			if spec ~= nil and specRegistryEntry ~= nil then
				TRB.Functions.OptionsUi.AudioCues:GenerateAudioCuesPanel(scrollChild, controls, spec, specRegistryEntry.classId, specRegistryEntry.specId, 5)
			end
		end,
	}
end
