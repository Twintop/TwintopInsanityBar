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
local cdm = TRB.Functions.CooldownManager
local aura = TRB.Functions.Aura

---@type TRB.Classes.OptionsUi.CdmPickerWording
local pickerWording = {
	otherClass = L["AudioCueOtherClassTooltip"],
	otherSpec = L["AudioCueOtherSpecTooltip"],
	disabled = L["AudioCueCdmDisabledTooltip"],
	notLearned = L["AudioCueNotLearnedTooltip"],
	notDisplayed = L["AudioCueNotDisplayedTooltip"],
}

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
---@return ChatConfigCheckButtonTemplate
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
	fontString:SetWordWrap(true)
	if width ~= nil then
		fontString:SetWidth(width)
	end
	return fontString
end

---Builds the display-ordered cue list: built-ins in registry order, each counter source's cues by threshold
---(lowest first, for reading), then Buff Alerts by name.
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

	local buffCues = {}
	for id, cue in pairs(spec.audio) do
		if type(cue) == "table" and cue.kind == "buff" then
			table.insert(buffCues, { id = id, cue = cue, isBuff = true })
		end
	end
	table.sort(buffCues, function(a, b)
		local aName = (a.cue.name or ""):lower()
		local bName = (b.cue.name or ""):lower()
		if aName ~= bName then
			return aName < bName
		end
		return tostring(a.id) < tostring(b.id)
	end)
	for _, entry in ipairs(buffCues) do
		table.insert(entries, entry)
	end

	return entries
end

---A Buff Alert's chosen Cooldown Manager condition, if it has one.
---@param cue TRB.Classes.Settings.AudioCue
---@return TRB.CustomIndicatorCondition?
local function GetBuffCondition(cue)
	local conditions = cue.configuration and cue.configuration.conditions
	return conditions ~= nil and conditions[1] or nil
end

---Whether a Buff Alert follows a buff by spell ID: its chosen buff does, or none is chosen yet on a client that reads auras.
---@param cue TRB.Classes.Settings.AudioCue
---@return boolean
local function UsesAuraSource(cue)
	local condition = GetBuffCondition(cue)
	if condition == nil then
		return TRB.Flavor.playerAuras == true
	end
	return condition.source == aura.CONDITION_SOURCE
end

---Why a Buff Alert following a buff by spell ID can't play (nil when it can), refreshing its cached name.
---@param condition TRB.CustomIndicatorCondition
---@return string?
local function GetAuraBuffStatus(condition)
	local name = condition.spellID ~= nil and C_Spell.GetSpellName(condition.spellID) or nil
	if name ~= nil then
		condition.name = name
	end
	if not TRB.Flavor.playerAuras then
		return L["AudioCueBuffAuraUnavailableTooltip"]
	elseif name == nil then
		return string.format(L["AudioCueBuffAuraUnknownSpellTooltip"], tostring(condition.spellID))
	end
	return nil
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
---below it. Built-in cues are fixed; threshold cues and Buff Alerts can be added and deleted.
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

	local function GetCurrentSpec()
		return TRB.Data.settings[lowerClassName] and TRB.Data.settings[lowerClassName][specName]
	end

	local function RefreshRuntime()
		local currentSpec = GetCurrentSpec()
		if currentSpec ~= nil then
			TRB.Functions.AudioCues:InvalidateCache(currentSpec)
		end
	end

	---Why a Buff Alert's buff can't be picked right now (nil when it can), and the layout status behind it.
	---@return string? reason
	---@return TRB.CdmLayoutStatus? status
	local function GetPickerBlock()
		return TRB.Functions.OptionsUi.Primitives:GetCdmPickerBlock(classId, specId, pickerWording)
	end

	---Judges a Buff Alert against the layout, refreshing its cached name and following a renumbered entry,
	---but only while its own spec's layout can be read.
	---@param cue TRB.Classes.Settings.AudioCue
	---@param blockReason string?
	---@param blockStatus TRB.CdmLayoutStatus?
	---@return string? notTrackedReason # nil when tracked, unpicked, or not judged
	---@return TRB.CdmLayoutEntry? entry # The layout entry it follows, when it could be read
	local function GetBuffStatus(cue, blockReason, blockStatus)
		local condition = GetBuffCondition(cue)
		if condition == nil then
			return nil, nil
		elseif condition.source == aura.CONDITION_SOURCE then
			return GetAuraBuffStatus(condition), nil
		elseif blockReason == nil then
			local entry = cdm:ResolveCondition(condition)
			if entry == nil then
				return L["AudioCueBuffMissingTooltip"], nil
			elseif entry.state ~= cdm.EntryState.TRACKED then
				return table.concat(TRB.Functions.OptionsUi.Primitives:GetCdmEntryNotes(entry, pickerWording), "\n\n"), entry
			end
			return nil, entry
		elseif blockStatus == cdm.LayoutStatus.DISABLED or blockStatus == cdm.LayoutStatus.UNAVAILABLE then
			return blockReason, nil
		end
		return nil, nil
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

	local cdmBadgeColor = CreateColor(TRB.Functions.OptionsUi.Primitives:GetCdmBadgeColor())

	---Badge-colored CDM label, for text where the badge frame cannot go.
	---@param format string # Wraps the label, e.g. "[%s]"
	---@return string
	local function GetCdmLabelMarkup(format)
		return cdmBadgeColor:WrapTextInColorCode(string.format(format, L["CdmBadgeLabel"]))
	end

	local notTrackedR, notTrackedG, notTrackedB = TRB.Functions.OptionsUi.Primitives:GetNotTrackedColor()
	local notTrackedHex = CreateColor(notTrackedR, notTrackedG, notTrackedB):GenerateHexColor()

	---Shows a cue's name, firing condition and description on row hover.
	---@param cellFrame Frame?
	---@param tooltip table? # { title, trigger, description, cdm, notTracked }
	local function ShowRowTooltip(cellFrame, tooltip)
		if cellFrame == nil or tooltip == nil then
			return
		end

		GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
		GameTooltip:SetText(tooltip.title, 1, 1, 1, 1, true)
		if tooltip.trigger ~= nil then
			local trigger = tooltip.trigger
			if tooltip.cdm == TRB.Data.constants.cdmDependency.REQUIRED then
				trigger = string.format("%s  %s", trigger, GetCdmLabelMarkup("%s"))
			end
			GameTooltip:AddLine(trigger, 1, 0.82, 0, true)
		end
		if tooltip.notTracked ~= nil then
			GameTooltip:AddLine(tooltip.notTracked, notTrackedR, notTrackedG, notTrackedB, true)
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

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["AudioCueAdd"], 0, 0, 170, 24)
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", editorHeaderRow, "TOPRIGHT", -5, -8)
	addButton:SetDisabledFontObject(GameFontDisable)
	addButton:SetMotionScriptsWhileDisabled(true)
	controls.audioCues.addButton = addButton

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

	local playOutOfCombatCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_PlayOutOfCombat",
		L["AudioCuePlayOutOfCombatCheckbox"], oUi.xCoord, -90)
	playOutOfCombatCheckbox.tooltip = L["AudioCuePlayOutOfCombatCheckboxTooltip"]

	-- A Buff Alert's buff is picked where a counter cue's slider sits.
	local buffHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["AudioCueBuffLabel"], oUi.xCoord2, -30)
	buffHeader.font:SetFontObject(GameFontNormal)
	TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(buffHeader.font, TRB.Data.constants.cdmDependency.REQUIRED)
	local buffDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Buff", editorContent, "WowStyle1DropdownTemplate")
	buffDropdown:SetWidth(oUi.sliderWidth)
	buffDropdown.label = buffHeader
	buffDropdown:SetPoint("TOPLEFT", oUi.xCoord2, -55)
	buffDropdown:SetMotionScriptsWhileDisabled(true)
	buffDropdown:SetScript("OnEnter", function(self)
		local reason = GetPickerBlock()
		if reason ~= nil then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(reason, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)
	buffDropdown:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- A buff followed by spell ID is entered in a prompt rather than picked from a list.
	local buffSpellButton = TRB.Functions.OptionsUi.Primitives:BuildButton(editorContent, "", oUi.xCoord2, -55, oUi.sliderWidth, 25)
	buffSpellButton:Hide()
	local buffStatusText = BuildWrappedText(editorContent, oUi.sliderWidth)
	buffStatusText:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2 + 2, -90)
	buffStatusText:SetTextColor(notTrackedR, notTrackedG, notTrackedB)
	buffHeader:Hide()
	buffDropdown:Hide()
	buffStatusText:Hide()

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
		local blockReason, blockStatus = GetPickerBlock()
		for _, entry in ipairs(GetOrderedEntries(currentSpec, definition)) do
			local cue = entry.cue
			local isCounter = entry.source ~= nil
			local isCustom = isCounter or entry.isBuff
			local displayName, trigger, description, cdmDependency, notTracked
			if entry.isBuff then
				notTracked = GetBuffStatus(cue, blockReason, blockStatus)
				local condition = GetBuffCondition(cue)
				displayName = cue.name or L["AudioCueBuffAlertDefaultName"]
				trigger = condition ~= nil and string.format(L["AudioCueTriggerBuffGained"], condition.name or L["CustomIndicatorUnknownEntry"])
					or L["AudioCueTriggerBuffNone"]
				if UsesAuraSource(cue) then
					description = L["AudioCueBuffAlertAuraDescription"]
				else
					description = L["AudioCueBuffAlertDescription"]
					cdmDependency = TRB.Data.constants.cdmDependency.REQUIRED
				end
			elseif isCounter then
				displayName = cue.name or entry.source.defaultName
				trigger = FormatTrigger(entry.source, cue.configuration and cue.configuration.thresholdValue,
					cue.configuration and cue.configuration.playOnDrop)
				description = entry.source.description
			else
				displayName = entry.builtIn.label
				trigger = entry.builtIn.trigger
				description = entry.builtIn.tooltip
				cdmDependency = entry.builtIn.cdm
			end
			local typeLabel = isCustom and L["AudioCueTypeCustom"] or L["AudioCueTypeBuiltIn"]
			local soundName = TRB.Functions.LibSharedMedia:GetDisplayName("sound", cue.soundName) or L["AudioCueSoundNone"]
			local enabledText = cue.enabled and ("|cFF00FF00" .. L["BarTextVariablesStatusYes"] .. "|r") or ("|cFFFF0000" .. L["BarTextVariablesStatusNo"] .. "|r")

			rowTooltips[entry.id] = {
				title = displayName,
				trigger = trigger,
				description = description,
				cdm = cdmDependency,
				notTracked = notTracked,
			}

			-- A table cell cannot hold the badge frame, so the column gets a text prefix instead.
			local triggerCell = trigger
			if cdmDependency == TRB.Data.constants.cdmDependency.REQUIRED then
				triggerCell = string.format("%s %s", GetCdmLabelMarkup("[%s]"), trigger)
			end
			if notTracked ~= nil then
				triggerCell = string.format("%s |c%s(%s)|r", triggerCell, notTrackedHex, L["CustomIndicatorBadgeNotTrackedHeader"])
			end

			table.insert(dataTable, {
				cols = {
					{ value = entry.id },
					{ value = cue.enabled and speakerIconMarkup or "" },
					{ value = displayName },
					{ value = typeLabel },
					{ value = triggerCell },
					{ value = soundName },
					{ value = enabledText },
					{ value = isCustom and "X" or "", color = isCustom and deleteActionTextColor or nil, DoCellUpdate = isCustom and UpdateActionCell or nil },
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
			control = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_Config_" .. key, descriptor.label, oUi.xCoord2, 0) --[[@as TRB.Classes.OptionsUi.CueConfigControl]]
			control.tooltip = descriptor.tooltip
		elseif descriptor.control == "dropdown" then
			control = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Config_" .. key, editorContent, "WowStyle1DropdownTemplate") --[[@as TRB.Classes.OptionsUi.CueConfigControl]]
			control:SetWidth(oUi.sliderWidth)
			control.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, descriptor.label, oUi.xCoord2, 0)
			control.label.font:SetFontObject(GameFontNormal)
		else
			control = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, descriptor.label,
				descriptor.min or 0, descriptor.max or 10, descriptor.min or 0,
				descriptor.step or 1, descriptor.decimals or 0,
				oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, 0) --[[@as TRB.Classes.OptionsUi.CueConfigControl]]
		end

		control.isSlider = descriptor.control ~= "checkbox" and descriptor.control ~= "dropdown"
		control.isDropdown = descriptor.control == "dropdown"
		configControls[key] = control
		return control
	end

	---Re-anchors a config control below the right column's running cursor and returns the new cursor.
	---Sliders and dropdowns hang a title above themselves, so they need leading room checkboxes do not.
	---@param control TRB.Classes.OptionsUi.CueConfigControl
	---@param cursor number
	---@return number
	local function PlaceConfigControl(control, cursor)
		control:ClearAllPoints()
		if control.isSlider then
			control:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2 + 18, cursor - 25)
			return cursor - 80
		elseif control.isDropdown then
			-- The label is a separate frame, so it moves with the dropdown.
			control.label:ClearAllPoints()
			control.label:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2, cursor - 5)
			control:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2, cursor - 30)
			return cursor - 60
		end
		control:SetPoint("TOPLEFT", editorContent, "TOPLEFT", oUi.xCoord2, cursor - 5)
		return cursor - 20
	end

	local PickBuff
	local PickAuraBuff

	---@param cue TRB.Classes.Settings.AudioCue
	local function RefreshSoundLabel(cue)
		soundDropdown:SetDefaultText(TRB.Functions.LibSharedMedia:GetDisplayName("sound", cue.soundName) or L["AudioCueSoundNone"])
	end

	TRB.Functions.OptionsUi.Media:SetLabelRefresher(soundDropdown, function()
		local cue = GetSelectedCue()
		if cue ~= nil then
			RefreshSoundLabel(cue)
		end
		SetTableValues()
	end)

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
		local isBuff = cue.kind == "buff"

		nameLabel:Show()
		if source ~= nil or isBuff then
			nameBox:SetText(cue.name or (source ~= nil and source.defaultName) or L["AudioCueBuffAlertDefaultName"])
			nameBox:Show()
			nameText:Hide()
		else
			nameText.font:SetText(builtIn ~= nil and builtIn.label or cue.name)
			nameText:Show()
			nameBox:Hide()
		end

		enabledCheckbox:SetChecked(cue.enabled == true)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, cue.enabled == true, true)

		RefreshSoundLabel(cue)
		soundDropdown:SetupMenu(function(dropdown, rootDescription)
			-- By name, since a saved path can be stale and several names can share one file.
			for _, v in ipairs(soundPairs) do
				rootDescription:CreateRadio(v[1], function(pair)
					return pair[1] == cue.soundName
				end, function(pair)
					cue.sound = pair[2]
					cue.soundName = pair[1]
					soundDropdown:SetDefaultText(pair[1])
					PlaySoundFile(TRB.Functions.LibSharedMedia:ResolveSound(cue.soundName, cue.sound), TRB.Data.settings.core.audio.channel.channel)
					SetTableValues()
				end, v)
			end
			rootDescription:SetScrollMode(400)
		end)

		playOutOfCombatCheckbox:SetChecked(TRB.Functions.AudioCues:PlaysOutOfCombat(cue))

		HideConfigControls()
		HideThresholdSliders()
		triggerHeader:Hide()
		triggerText:Hide()
		TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(triggerText, nil)
		buffHeader:Hide()
		buffDropdown:Hide()
		buffSpellButton:Hide()
		buffStatusText:Hide()

		-- The two columns grow independently; the description sits below whichever runs longer.
		local editorY = -55
		local leftBottom = -110
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

		if isBuff then
			local condition = GetBuffCondition(cue)
			local blockReason, blockStatus = GetPickerBlock()
			local notTracked, entry = GetBuffStatus(cue, blockReason, blockStatus)
			if UsesAuraSource(cue) then
				local spellId = condition ~= nil and condition.spellID or nil
				buffSpellButton:SetText(TRB.Functions.OptionsUi.Primitives:FormatAuraSpellLabel(spellId)
					or (condition ~= nil and condition.name) or L["AudioCueBuffEnterSpellId"])
				buffSpellButton:SetScript("OnClick", function()
					TRB.Functions.OptionsUi.Primitives:ShowAuraSpellIdPrompt(spellId, function(picked)
						PickAuraBuff(cue, picked)
					end)
				end)
				buffSpellButton:SetEnabled(TRB.Flavor.playerAuras)
				TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(buffHeader.font, nil)
				buffSpellButton:Show()
			else
				local label = L["AudioCueBuffNone"]
				if entry ~= nil then
					label = TRB.Functions.OptionsUi.Primitives:FormatCdmEntryLabel(entry)
				elseif condition ~= nil then
					label = condition.name or L["CustomIndicatorUnknownEntry"]
				end
				buffDropdown:SetDefaultText(label)
				buffDropdown:SetupMenu(function(_, rootDescription)
					TRB.Functions.OptionsUi.Primitives:PopulateCdmPicker(rootDescription, condition and condition.cooldownID, pickerWording, function(picked)
						PickBuff(cue, picked)
					end)
				end)
				TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(buffDropdown, blockReason == nil)
				TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(buffHeader.font, TRB.Data.constants.cdmDependency.REQUIRED)
				buffDropdown:Show()
			end
			buffHeader:Show()
			rightBottom = editorY - 30
			if notTracked ~= nil then
				buffStatusText:SetText(notTracked)
				buffStatusText:Show()
				rightBottom = -90 - buffStatusText:GetStringHeight()
			end
		end

		if builtIn ~= nil then
			triggerText:SetText(builtIn.trigger)
			triggerHeader:Show()
			triggerText:Show()
			TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(triggerText, builtIn.cdm)
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
				elseif descriptor.control == "dropdown" then
					local function LabelFor(value)
						for _, option in ipairs(descriptor.options) do
							if option.value == value then
								return option.label
							end
						end
						return descriptor.options[1].label
					end

					control:SetDefaultText(LabelFor(cue.configuration[descriptor.key]))
					control:SetupMenu(function(_, rootDescription)
						for _, option in ipairs(descriptor.options) do
							rootDescription:CreateRadio(option.label, function(value)
								return cue.configuration[descriptor.key] == value
							end, function(value)
								cue.configuration[descriptor.key] = value
								-- Deferred: SetDefaultText during menu teardown does not stick.
								C_Timer.After(0, function()
									control:SetDefaultText(LabelFor(value))
								end)
							end, option.value)
						end
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

		local description = (source ~= nil and source.description) or (builtIn ~= nil and builtIn.tooltip)
			or (isBuff and (UsesAuraSource(cue) and L["AudioCueBuffAlertAuraDescription"] or L["AudioCueBuffAlertDescription"])) or nil
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

	---Points a Buff Alert at a picked entry, renaming it while its name still follows its buff.
	---@param cue TRB.Classes.Settings.AudioCue
	---@param entry TRB.CdmLayoutEntry
	PickBuff = function(cue, entry)
		cue.configuration = cue.configuration or {}
		cue.configuration.conditions = cue.configuration.conditions or {}
		local condition = cue.configuration.conditions[1]
		local previousName = condition ~= nil and condition.name or nil
		if condition == nil then
			---@type TRB.CustomIndicatorCondition
			condition = { source = cdm.CONDITION_SOURCE, state = cdm.ConditionState.ACTIVE, cooldownID = entry.cooldownID }
			cue.configuration.conditions[1] = condition
		end
		cdm:PointConditionAt(condition, entry, true)
		if entry.name ~= nil and (cue.name == nil or cue.name == "" or cue.name == L["AudioCueBuffAlertDefaultName"] or cue.name == previousName) then
			cue.name = entry.name
		end

		RefreshRuntime()
		SetTableValues()
		-- Deferred: SetDefaultText during menu teardown does not stick.
		C_Timer.After(0, function()
			RefreshEditor(selectedId)
		end)
	end

	---Points a Buff Alert at a buff by spell ID, renaming it while its name still follows its buff.
	---@param cue TRB.Classes.Settings.AudioCue
	---@param spellId integer
	PickAuraBuff = function(cue, spellId)
		cue.configuration = cue.configuration or {}
		cue.configuration.conditions = cue.configuration.conditions or {}
		local condition = cue.configuration.conditions[1]
		local previousName = condition ~= nil and condition.name or nil
		if condition == nil or condition.source ~= aura.CONDITION_SOURCE then
			---@type TRB.CustomIndicatorCondition
			condition = { source = aura.CONDITION_SOURCE, state = aura.ConditionState.ACTIVE }
			cue.configuration.conditions[1] = condition
		end
		condition.spellID = spellId
		condition.name = C_Spell.GetSpellName(spellId)
		if condition.name ~= nil and (cue.name == nil or cue.name == "" or cue.name == L["AudioCueBuffAlertDefaultName"] or cue.name == previousName) then
			cue.name = condition.name
		end

		RefreshRuntime()
		SetTableValues()
		RefreshEditor(selectedId)
	end

	playOutOfCombatCheckbox:SetScript("OnClick", function(self)
		local cue = GetSelectedCue()
		if cue == nil then
			return
		end
		cue.configuration = cue.configuration or {}
		cue.configuration.playOutOfCombat = self:GetChecked()
		RefreshRuntime()
	end)

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
			PlaySoundFile(TRB.Functions.LibSharedMedia:ResolveSound(cue.soundName, cue.sound), TRB.Data.settings.core.audio.channel.channel)
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
				playOutOfCombat = not source.requiresCombat,
			},
		}

		RefreshRuntime()
		SetTableValues()
		RefreshEditor(id)
	end

	---Creates a Buff Alert with no buff chosen yet and selects it for editing.
	local function AddBuffCue()
		local currentSpec = GetCurrentSpec()
		if currentSpec == nil then
			return
		end

		local id = TRB.Functions.String:Guid()
		currentSpec.audio[id] = {
			id = id,
			kind = "buff",
			name = L["AudioCueBuffAlertDefaultName"],
			enabled = true,
			sound = TRB.Data.constants.defaultSettings.sounds.sound,
			soundName = TRB.Data.constants.defaultSettings.sounds.soundName,
			configuration = {
				conditions = {},
				playOutOfCombat = true,
			},
		}

		RefreshRuntime()
		SetTableValues()
		RefreshEditor(id)
	end

	---Why a Buff Alert can't be added right now (nil when it can); only the Cooldown Manager can block one.
	---@return string?
	local function GetAddBuffBlock()
		if TRB.Flavor.playerAuras then
			return nil
		end
		return (GetPickerBlock())
	end

	-- With no threshold sources the button only makes Buff Alerts, so it greys out whenever they can't be made.
	local function RefreshAddButton()
		addButton:SetEnabled(#definition.counters > 0 or TRB.Flavor.playerAuras or (TRB.Flavor.cooldownManager and GetPickerBlock() == nil))
	end

	-- A client with neither the Cooldown Manager nor readable auras makes no Buff Alerts, so a spec without threshold sources has nothing to add.
	if not TRB.Flavor.cooldownManager and not TRB.Flavor.playerAuras and #definition.counters == 0 then
		addButton:Hide()
	end

	addButton:SetScript("OnEnter", function(self)
		local reason = #definition.counters == 0 and GetAddBuffBlock() or nil
		if reason ~= nil then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(reason, 1, 1, 1, 1, true)
			GameTooltip:Show()
		elseif not self:IsEnabled() then
			RefreshAddButton()
		end
	end)
	addButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	addButton:SetScript("OnClick", function(self)
		local reason = GetAddBuffBlock()
		if #definition.counters == 0 then
			-- The Cooldown Manager can change under an open panel; say why instead of doing nothing.
			if reason ~= nil then
				RefreshAddButton()
				self:GetScript("OnEnter")(self)
				return
			end
			AddBuffCue()
			return
		end

		MenuUtil.CreateContextMenu(self, function(_, rootDescription)
			for _, source in ipairs(definition.counters) do
				rootDescription:CreateButton(string.format(L["AudioCueAddThresholdFormat"], source.defaultName), function()
					AddCue(source)
				end)
			end
			if TRB.Flavor.cooldownManager or TRB.Flavor.playerAuras then
				local buffButton = rootDescription:CreateButton(L["AudioCueAddBuffAlert"], AddBuffCue)
				if reason ~= nil then
					buffButton:SetEnabled(false)
					buffButton:SetTooltip(function(tooltip)
						tooltip:SetText(reason, 1, 1, 1, 1, true)
					end)
				end
			end
		end)
	end)

	---Re-judges every Buff Alert against the layout, which can change while the panel is open.
	local function RefreshCdmState()
		RefreshAddButton()
		SetTableValues()
		local cue = GetSelectedCue()
		if cue ~= nil and cue.kind == "buff" then
			RefreshEditor(selectedId)
		end
	end

	parent:HookScript("OnShow", RefreshCdmState)
	if EventRegistry ~= nil and TRB.Flavor.cooldownManager then
		local refreshQueued = false
		EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged", function()
			if refreshQueued or not parent:IsVisible() then return end
			refreshQueued = true
			-- Read a frame late, so Blizzard's own listeners for the same callback rebuild the layout first.
			C_Timer.After(0, function()
				refreshQueued = false
				if parent:IsVisible() then
					RefreshCdmState()
				end
			end)
		end, parent)
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

	RefreshAddButton()
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
