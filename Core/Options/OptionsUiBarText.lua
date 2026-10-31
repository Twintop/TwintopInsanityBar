local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.BarText = TRB.Functions.OptionsUi.BarText or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization
local barTextCopyIconMarkup = "|TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:14:14:0:0|t"
local actionCellDimAlpha = 0.65
local actionCellBrightAlpha = 1.0
local deleteActionTextColor = { r = 1, g = 0.12, b = 0.12, a = 1 }

-- Session-only, never saved: whether a scope's spec tab also lists the text bound to the other groupings' bars.
local includeAllGroups = {}

-- Each built editor's refresh hooks, by scope then grouping, so a change in one reaches its siblings.
---@type table<string, table<string, { RefreshTable: fun(closeEditor: boolean?), RefreshUseGlobalCheckbox: fun() }>>
local barTextEditors = {}

---@param classId integer?
---@param specId integer?
---@return string
local function GetScopeKey(classId, specId)
	if classId == nil then
		return "global"
	end
	return classId .. "_" .. specId
end

-- ============================================================================
-- Bar text editor options
-- ============================================================================

-- Bar text variables side panel lives in Options\OptionsUiBarTextVariables.lua.
function TRB.Functions.OptionsUi.BarText:CreateVariablesSidePanel(...)
	return TRB.Functions.OptionsUi.BarTextVariables:CreateVariablesSidePanel(...)
end

-- Bar text input panel lives in Options\OptionsUiBarTextInput.lua.
function TRB.Functions.OptionsUi.BarText:CreateBarTextInputPanel(...)
	return TRB.Functions.OptionsUi.BarTextInput:CreateBarTextInputPanel(...)
end

-- Delete-bar-text confirmation dialog.  Defined once (outside GenerateBarTextEditor)
-- so that every spec shares a single dialog whose OnAccept works entirely from the
-- per-invocation data payload -- no closure references to the wrong spec's locals.
StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteBarText"] = {
	text = "",
	button1 = L["Yes"],
	button2 = L["No"],
	OnShow = function(self, data)
		self:SetFormattedText(data.message)
		self.data = data
	end,
	OnAccept = function(self)
		local d = self.data
		d.btt:SetSelection()
		for i, entry in ipairs(d.displayText.barText) do
			if entry.guid == d.guid then
				table.remove(d.displayText.barText, i)
				break
			end
		end
		d.refreshTable()
		-- Refresh the active spec's merged bar text list when global bar text is in use
		if d.classId == nil then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		elseif d.classId == TRB.Data.character.classId and d.specId == TRB.Data.character.specId then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		end
		if d.classId == nil or (d.classId == TRB.Data.character.classId and d.specId == TRB.Data.character.specId) then
			TRB.Data.cache.barText = {}
			TRB.Functions.BarText:ClearBarTextCacheHash()
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Data.activeVariables = nil
			TRB.Data.lookupDirty = true
		end
		TRB.Functions.BarText:CreateBarTextFrames(d.classId, d.specId)
		d.barTextOptionsFrame:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
}

---Generates the bar text editor panel, including the scrolling table of bar text entries, add/delete controls, and per-entry editing fields for font, position, and text content.
---@param parent Frame|TRB.Classes.OptionsUi.ScrollChild The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing displayText configuration
---@param classId integer? The class ID, or nil for global bar text settings
---@param specId integer? The spec ID, or nil for global bar text settings
---@param yCoord number The current Y coordinate for layout positioning
---@param cache table The bar text variables cache used for the side panel
---@param options { groupKey: string? }? Which grouping's bar text to list; nil is the spec's own tab
function TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, classId, specId, yCoord, cache, options)
	local groupKey = options and options.groupKey or "spec"
	local scopeKey = GetScopeKey(classId, specId)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	-- specCache keys use lowercase class names (e.g. "priest_discipline"), but
	-- GetClassAndSpecializationNames without lowerCaseClass returns UPPERCASE (e.g. "PRIEST").
	-- Use the lowercase form for specCache lookups so ResetTableValues actually updates the runtime cache.
	local compositeKey = TRB.Functions.Character:GetCompositeKey(string.lower(className), specName)
	local namePrefix = className .. "_" .. specName .. "_barTextEditor" .. (groupKey == "spec" and "" or "_" .. groupKey)
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	-- Per-spec "Use Global Bar Text" checkbox (skip for the global panel itself)
	controls.checkBoxes = controls.checkBoxes or {}
	-- Re-reads the flag into this tab's box, so a click on a sibling tab's box shows here too.
	local RefreshUseGlobalCheckbox = function() end
	if classId ~= nil and specId ~= nil then
		local lowerClassName = string.lower(className)
		-- SetAllSpecsGlobalSetting finds the spec tab's box by name; the other tabs' boxes follow through the registry.
		local checkboxName = "TwintopResourceBar_" .. className .. "_" .. specName .. "_useGlobal_globalBarText" .. (groupKey == "spec" and "" or "_" .. groupKey)
		controls.checkBoxes.useGlobalBarText = CreateFrame("CheckButton", checkboxName, parent, "ChatConfigCheckButtonTemplate")
		local f = controls.checkBoxes.useGlobalBarText
		f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobalBarText"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		if groupKey == "spec" then
			TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "barText")
		else
			TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "barText", groupKey)
		end
		f.tooltip = L["CheckboxUseGlobalTooltip_GlobalBarText"]
		RefreshUseGlobalCheckbox = function()
			f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].globalBarText)
		end
		RefreshUseGlobalCheckbox()
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].globalBarText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Data.cache.barText = {}
			TRB.Functions.BarText:ClearBarTextCacheHash()
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Data.activeVariables = nil
			TRB.Functions.BarText:Hide(spec)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("globalBarText")
			TRB.Functions.OptionsUi.BarText:RefreshUseGlobalBarText()
		end)
		yCoord = yCoord - 20
	elseif groupKey == "spec" then
		yCoord = yCoord + 10 -- Fix offset
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllGlobalBarText", "globalBarText", yCoord, L["GlobalBarTextBulkToggleLabel"], L["GlobalBarTextBulkToggleTooltip"])
		yCoord = yCoord - 20
	end

	-- Redraws the table and keeps the open entry in step with it; assigned once the editor exists.
	---@type fun()
	local RefreshBarTextTable = function() end
	if groupKey == "spec" then
		controls.checkBoxes.includeAllBarTextGroups = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, "TwintopResourceBar_" .. namePrefix .. "_includeAllGroups",
			L["CheckboxIncludeAllBarTextGroups"], L["CheckboxIncludeAllBarTextGroupsTooltip"], yCoord,
			function() return includeAllGroups[scopeKey] == true end,
			function(checked)
				includeAllGroups[scopeKey] = checked
				RefreshBarTextTable()
			end)
		-- Lined up with the Use Global box above it.
		controls.checkBoxes.includeAllBarTextGroups:ClearAllPoints()
		controls.checkBoxes.includeAllBarTextGroups:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		yCoord = yCoord - 20
	end

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
			["width"] = 22,
			["align"] = "CENTER",
		},
		{
			["name"] = "",
			["width"] = 15,
			["align"] = "CENTER",
			["color"] = {
				["r"] = 1,
				["g"] = 0,
				["b"] = 0,
				["a"] = 1,
			}
		}
	}

	-- Empty until an entry is selected, then the selected DisplayTextEntry.
	local workingBarText = {}
	-- The entries the table lists, in row order; its rows are not the settings list's indexes.
	local listedEntries = {}

	---Whether this specialization draws Global Bar Text, which its tabs then list beside its own.
	---@return boolean
	local function IsUsingGlobalBarText()
		if classId == nil then
			return false
		end
		local classFlags = TRB.Data.settings.core.global[string.lower(className)]
		local flags = classFlags and classFlags[specName]
		return flags ~= nil and flags.globalBarText == true
	end

	---Whether a specialization's tab is showing an entry of Global Bar Text.
	---@param entry table?
	---@return boolean
	local function IsGlobalEntry(entry)
		if classId == nil or entry == nil then
			return false
		end
		for _, globalEntry in ipairs(TRB.Data.settings.core.displayText.barText) do
			if globalEntry == entry then
				return true
			end
		end
		return false
	end

	---@param barTextEntry TRB.Classes.Settings.DisplayTextEntry|table|nil
	---@return string
	local function NormalizeBarTextEntryColor(barTextEntry)
		if barTextEntry == nil then
			return "FFFFFFFF"
		end

		if type(barTextEntry.color) == "table" then
			barTextEntry.color.color = barTextEntry.color.color or "FFFFFFFF"
			return barTextEntry.color.color
		end

		if type(barTextEntry.color) == "string" and barTextEntry.color ~= "" then
			local legacyColor = barTextEntry.color
			local mutableBarTextEntry = barTextEntry --[[@as table<string, any>]]
			mutableBarTextEntry.color = { color = legacyColor }
			return mutableBarTextEntry.color.color
		end

		local mutableBarTextEntry = barTextEntry --[[@as table<string, any>]]
		mutableBarTextEntry.color = { color = "FFFFFFFF" }
		return mutableBarTextEntry.color.color
	end

	local function GetActiveBarTextPreviewIndex()
		local activeClassId = TRB.Data.character.classId
		local activeSpecId = TRB.Data.character.specId
		local activeCompositeKey = TRB.Data.character.compositeKey
		if activeClassId == nil or activeSpecId == nil or activeCompositeKey == nil then
			return nil
		end

		local shouldPreviewActiveSpec = false
		if classId == activeClassId and specId == activeSpecId then
			shouldPreviewActiveSpec = true
		elseif (classId == nil and specId == nil) or IsGlobalEntry(workingBarText) then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			shouldPreviewActiveSpec = charClassName ~= nil and charSpecName ~= nil and
				TRB.Data.settings.core.global[charClassName] ~= nil and
				TRB.Data.settings.core.global[charClassName][charSpecName] ~= nil and
				TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText == true
		end

		if not shouldPreviewActiveSpec or workingBarText == nil or workingBarText.guid == nil then
			return nil
		end

		local activeSettings = TRB.Data.specCache[activeCompositeKey] and TRB.Data.specCache[activeCompositeKey].settings
		local activeBarText = activeSettings and activeSettings.displayText and activeSettings.displayText.barText
		if activeBarText == nil then
			return nil
		end

		for i = 1, #activeBarText do
			if activeBarText[i].guid == workingBarText.guid then
				return i
			end
		end

		return nil
	end

	local function RefreshBarTextEditorPreview(forceRebuild)
		local previewIndex = GetActiveBarTextPreviewIndex()
		if previewIndex == nil then
			return
		end

		if not forceRebuild then
			if TRB.Functions.BarText:RepositionBarTextEntry(previewIndex, TRB.Data.character.classId, TRB.Data.character.specId) then
				return
			end
		end

		TRB.Functions.BarText:CreateBarTextFrames(TRB.Data.character.classId, TRB.Data.character.specId)
		TRB.Functions.BarText:InvalidateLookupMemoization()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end

	controls.barTextContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local btc = controls.barTextContainer

	btc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	btc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	btc:SetHeight(120)

	yCoord = yCoord - 105
	local btoHeight = 620
	local barTextTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 5, 15, nil, btc, false, false)

	-- Dynamically resize "Bar Text" column (index 4) to fill available width
	btc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[3].width + columns[5].width + columns[6].width
		local newBarTextWidth = math.max(200, w - fixedWidth - 30) -- 30 for internal padding/scrollbar
		columns[4].width = newBarTextWidth
		barTextTable:SetDisplayCols(columns)
	end)

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["AddNewBarTextArea"], 0, 0, 175, 25)

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

	local barTextOptionsFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame", parent, "BackdropTemplate")
	barTextOptionsFrame:SetPoint("TOPLEFT", btc, "BOTTOMLEFT", 0, -10)
	barTextOptionsFrame:SetPoint("TOPRIGHT", btc, "BOTTOMRIGHT", 0, -10)
	barTextOptionsFrame:SetHeight(btoHeight)
	barTextOptionsFrame:Hide()

	-- Place addButton in the same row as Name / Enabled, anchored to top-right of barTextOptionsFrame
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", barTextOptionsFrame, "TOPRIGHT", -5, 5)

	local oldYCoord = yCoord - btoHeight

	yCoord = 0

	local barTextName = TRB.Functions.OptionsUi.Primitives:BuildTextBox(barTextOptionsFrame, "", 200, 300, 20, oUi.xCoord, yCoord)
	barTextName.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["Name"], oUi.xCoord, yCoord+25)
	barTextName.label.font:SetFontObject(GameFontNormal)

	local barTextEntryEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_TextEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	barTextEntryEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(barTextEntryEnabled:GetName() .. 'Text'):SetText(L["Enabled"])
	barTextEntryEnabled.tooltip = L["BarTextEntryEnabledTooltip"]

	yCoord = yCoord - 30
	controls.labels = controls.labels or {}
	controls.labels.barText = TRB.Functions.OptionsUi.Primitives:BuildLabel(barTextOptionsFrame, L["BarText"], oUi.xCoord, yCoord, 90, 20)

	yCoord = yCoord - 20
	local barText = TRB.Functions.OptionsUi.BarTextInput:CreateBarTextInputPanel(barTextOptionsFrame, namePrefix .. "_Text", "",
											590, 45, oUi.xCoord, yCoord)
	local barTextScrollFrame = barText:GetParent() --[[@as Frame]]
	barTextScrollFrame:ClearAllPoints()
	barTextScrollFrame:SetPoint("TOPLEFT", barTextOptionsFrame, "TOPLEFT", oUi.xCoord, yCoord)
	barTextScrollFrame:SetPoint("RIGHT", barTextOptionsFrame, "RIGHT", -30, 0)
	barText:SetCursorPosition(0)

	barTextOptionsFrame:HookScript("OnShow", function()
		TRB.Frames.activeBarTextEditBox = barText
		TRB.Frames.activeBarTextCursorPosition = barText:GetCursorPosition()
		if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel.variablesTable then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end)

	barTextOptionsFrame:HookScript("OnHide", function()
		TRB.Frames.activeBarTextEditBox = nil
		TRB.Frames.activeBarTextCursorPosition = nil
		if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel.variablesTable then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end)

	yCoord = yCoord - 75
	title = L["HorizontalOffset"]
	local barTextHorizontal = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxWidth), math.floor(sanityCheckValues.barMaxWidth), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	barTextHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.position.xPos = value
		RefreshBarTextEditorPreview(false)
	end)
	controls.barTextHorizontal = barTextHorizontal

	title = L["VerticalOffset"]
	local barTextVertical = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxHeight), math.floor(sanityCheckValues.barMaxHeight), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	barTextVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.position.yPos = value
		RefreshBarTextEditorPreview(false)
	end)
	controls.barTextVertical = barTextVertical

	yCoord = yCoord - 40
	local barTextRelativeToFrame = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeToFrame", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeToFrame:SetWidth(oUi.sliderWidth)
	barTextRelativeToFrame.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["BoundToBar"], oUi.xCoord, yCoord)
	barTextRelativeToFrame.label.font:SetFontObject(GameFontNormal)

	local catalog = TRB.Functions.BarText:GetAnchorCatalog(classId, specId)
	-- Global Bar Text reaches every specialization, so it only binds to the bars Global Options offers.
	local globalCatalog = classId == nil and catalog or TRB.Functions.BarText:GetAnchorCatalog(nil, nil)
	local primaryLabel = catalog.primaryLabel

	---The anchors an entry can bind to.
	---@param entry table?
	---@return TRB.Classes.BarTextAnchorCatalog
	local function CatalogFor(entry)
		return IsGlobalEntry(entry) and globalCatalog or catalog
	end

	---An entry's anchor label, looked up from its frame so a renamed bar shows its current name.
	---@param position table
	---@return string
	local function GetRelativeToFrameLabel(position)
		return catalog.labelByFrame[position.relativeToFrame] or globalCatalog.labelByFrame[position.relativeToFrame] or position.relativeToFrameName
	end

	---Whether a bar text entry belongs on this tab: a grouping's tab lists the text bound to its bars, and the spec tab
	---lists the rest plus the text on the screen, or everything when the include-all box is ticked.
	---@param groupOfEntry string
	---@param entryCatalog TRB.Classes.BarTextAnchorCatalog? # The catalog the entry's bar comes from
	---@return boolean
	local function IsGroupListed(groupOfEntry, entryCatalog)
		if groupKey == "spec" then
			-- Text bound to a bar this scope has no tab for, like pet bar text copied to a spec without a pet, stays listed here.
			return includeAllGroups[scopeKey] == true or groupOfEntry == "spec" or groupOfEntry == "screen"
				or (entryCatalog ~= nil and not entryCatalog.groups[groupOfEntry])
		end
		return groupOfEntry == groupKey
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
			workingBarText.position.relativeToFrameName = CatalogFor(workingBarText).labelByFrame[newValue]
			barTextRelativeToFrame:SetDefaultText(workingBarText.position.relativeToFrameName)
			RefreshBarTextTable()
			RefreshBarTextEditorPreview(false)
		end
	end

	local function RelativeToFrameGenerator(dropdown, rootDescription)
		for _, anchor in ipairs(CatalogFor(workingBarText).entries) do
			if IsGroupListed(anchor.groupKey) then
				rootDescription:CreateRadio(anchor.label, RelativeToFrameIsSelected, RelativeToFrameSetSelected, anchor.frame)
			end
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
	barTextRelativeToFrame:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	local barTextRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeTo", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeTo:SetWidth(oUi.sliderWidth)
	barTextRelativeTo.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
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
			RefreshBarTextEditorPreview(false)
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

	local fontPairs = TRB.Functions.OptionsUi.Media:GetFontPairs()
	local UpdateBarTextEditorInheritedControlState

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFace", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	-- By name, since a saved path can be stale and several names can share one file.
	local function FontFaceIsSelected(pair)
		if workingBarText ~= nil then
			return pair[1] == workingBarText.fontFaceName
		else
			return false
		end
	end

	local function FontFaceSetSelected(pair)
		if workingBarText ~= nil then
			workingBarText.fontFace = pair[2]
			workingBarText.fontFaceName = pair[1]
			barTextFontFace:SetDefaultText(pair[1])
			RefreshBarTextEditorPreview(true)
		end
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for _, v in ipairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v)
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				local outlineFlag = (workingBarText and workingBarText.fontOutline) or "OUTLINE"
				font:SetFont(v[2], 12, outlineFlag)
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	local function RefreshFontFaceLabel()
		barTextFontFace:SetDefaultText(TRB.Functions.LibSharedMedia:GetDisplayName("font", workingBarText.fontFaceName) or TRB.Data.constants.defaultSettings.fonts.fontFaceName)
	end
	TRB.Functions.OptionsUi.Media:SetLabelRefresher(barTextFontFace, RefreshFontFaceLabel)

	local useDefaultFontFace = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontFace", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontFace:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-60)
	getglobal(useDefaultFontFace:GetName() .. 'Text'):SetText(L["UseDefaultFontFace"])
	useDefaultFontFace.tooltip = L["UseDefaultFontFaceTooltip"]
	useDefaultFontFace:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontFace = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)


	local barTextFontJustifyHorizontal = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextFontJustifyHorizontal", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontJustifyHorizontal:SetWidth(oUi.sliderWidth)
	barTextFontJustifyHorizontal.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
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
			RefreshBarTextEditorPreview(true)
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
	local fontSize = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, 6, 300, 18, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontSize:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.fontSize = value
		RefreshBarTextEditorPreview(true)
	end)

	local useDefaultFontSize = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontSize", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontSize:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-40)
	getglobal(useDefaultFontSize:GetName() .. 'Text'):SetText(L["UseDefaultFontSize"])
	useDefaultFontSize.tooltip = L["UseDefaultFontSizeTooltip"]
	useDefaultFontSize:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontSize = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	controls.colors = controls.colors or {}
	controls.colors.barText = controls.colors.barText or {}
	local initialBarTextColor = NormalizeBarTextEntryColor(workingBarText)
	controls.colors.barText.color = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(barTextOptionsFrame, L["FontColor"], initialBarTextColor,
																			oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	local barTextColor = controls.colors.barText.color
	barTextColor:SetScript("OnMouseDown", function(self, button, ...)
		NormalizeBarTextEntryColor(workingBarText)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, workingBarText, controls.colors.barText, "color")
	end)

	local useDefaultFontColor = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontColor", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontColor:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(useDefaultFontColor:GetName() .. 'Text'):SetText(L["UseDefaultFontColor"])
	useDefaultFontColor.tooltip = L["UseDefaultFontColorTooltip"]
	useDefaultFontColor:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontColor = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	-- Font Outline dropdown
	yCoord = yCoord - 60
	local barTextFontOutline, RefreshFontOutlineDisplayText = TRB.Functions.OptionsUi.Primitives:BuildFontOutlineDropdown(barTextOptionsFrame,
		"TwintopResourceBar_" .. namePrefix .. "_fontOutline", L["FontOutlineHeader"],
		function()
			return workingBarText ~= nil and workingBarText.fontOutline or ""
		end,
		function(newValue)
			if workingBarText ~= nil then
				workingBarText.fontOutline = newValue
				RefreshBarTextEditorPreview(true)
			end
		end,
		oUi.xCoord, yCoord)

	local useDefaultFontOutline = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontOutline", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontOutline:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-60)
	getglobal(useDefaultFontOutline:GetName() .. 'Text'):SetText(L["UseDefaultFontOutline"])
	useDefaultFontOutline.tooltip = L["UseDefaultFontOutlineTooltip"]
	useDefaultFontOutline:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontOutline = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	controls.colors.barText.fontShadowColor = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(barTextOptionsFrame, L["FontShadowColor"],
		"FF000000", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord-10)
	local barTextShadowColor = controls.colors.barText.fontShadowColor
	barTextShadowColor:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			if workingBarText.fontShadow == nil then
				workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
			end
			local colorString = workingBarText.fontShadow.color or "FF000000"
			local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
			TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, 1-a, function(color)
				local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
				controls.colors.barText.fontShadowColor.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
				workingBarText.fontShadow.color = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
				RefreshBarTextEditorPreview(true)
			end)
		end
	end)

	local fontShadowEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_fontShadowEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	fontShadowEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
	getglobal(fontShadowEnabled:GetName() .. 'Text'):SetText(L["FontShadowEnable"])
	fontShadowEnabled.tooltip = L["FontShadowEnableTooltip"]
	fontShadowEnabled:SetScript("OnClick", function(self, ...)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.enabled = self:GetChecked()
		RefreshBarTextEditorPreview(true)
	end)

	local useDefaultFontShadow = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontShadow", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontShadow:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-60)
	getglobal(useDefaultFontShadow:GetName() .. 'Text'):SetText(L["UseDefaultFontShadow"])
	useDefaultFontShadow.tooltip = L["UseDefaultFontShadowTooltip"]
	useDefaultFontShadow:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontShadow = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	yCoord = yCoord - 100
	title = L["FontShadowXOffset"]
	local fontShadowXOffset = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, -10, 10, 1, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontShadowXOffset:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.xOffset = value
		RefreshBarTextEditorPreview(true)
	end)

	title = L["FontShadowYOffset"]
	local fontShadowYOffset = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, -10, 10, -1, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	fontShadowYOffset:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.yOffset = value
		RefreshBarTextEditorPreview(true)
	end)

	yCoord = yCoord - 75
	local constrainTextWidth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_constrainTextWidth", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	constrainTextWidth:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-8)
	getglobal(constrainTextWidth:GetName() .. 'Text'):SetText(L["ConstrainBarTextWidth"])
	constrainTextWidth.tooltip = L["ConstrainBarTextWidthTooltip"]
	constrainTextWidth:SetScript("OnClick", function(self, ...)
		workingBarText.constrainToParent = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	title = L["MaxBarTextWidthPercent"]
	local maxWidthPercent = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, 1, 100, 100, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	maxWidthPercent:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.maxWidthPercent = value
		RefreshBarTextEditorPreview(true)
	end)

	UpdateBarTextEditorInheritedControlState = function()
		local hasWorkingBarText = workingBarText ~= nil
		TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(barTextFontFace, hasWorkingBarText and not workingBarText.useDefaultFontFace)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(fontSize, hasWorkingBarText and not workingBarText.useDefaultFontSize)
		TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(barTextColor, hasWorkingBarText and not workingBarText.useDefaultFontColor)
		TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(barTextFontOutline, hasWorkingBarText and not (workingBarText.useDefaultFontOutline or false))

		local shadowControlsEnabled = hasWorkingBarText and not (workingBarText.useDefaultFontShadow or false)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(fontShadowEnabled, shadowControlsEnabled)
		TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(barTextShadowColor, shadowControlsEnabled)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(fontShadowXOffset, shadowControlsEnabled)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(fontShadowYOffset, shadowControlsEnabled)

		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(maxWidthPercent, hasWorkingBarText and (workingBarText.constrainToParent or false))
	end

	local globalRowR, globalRowG, globalRowB = TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor()
	local globalRowColor = { r = globalRowR, g = globalRowG, b = globalRowB, a = 1 }

	---Populates the bar text scrolling table with a row for each entry this tab lists: the Global Bar Text the
	---specialization draws, first and in light blue as it draws it, then the tab's own displayText.barText entries.
	---@param displayText TRB.Classes.Settings.DisplayText The display text settings containing the barText array
	---@param btt table LibScrollingTable instance to populate with data rows
	local function SetTableValues(displayText, btt)
		local dataTable = {}
		listedEntries = {}
		---@param barTextEntry TRB.Classes.Settings.DisplayTextEntry
		---@param isGlobal boolean
		local function AddRow(barTextEntry, isGlobal)
			NormalizeBarTextEntryColor(barTextEntry)
			local entryCatalog = isGlobal and globalCatalog or catalog
			if not IsGroupListed(TRB.Functions.BarText:GetEntryGroupKey(barTextEntry, entryCatalog), entryCatalog) then
				return
			end
			listedEntries[#listedEntries + 1] = barTextEntry
			local nameColor = nil
			if barTextEntry.enabled == false then
				nameColor = { r = 1, g = 0.3, b = 0.3, a = 1 }
			end
			table.insert(dataTable, {
				cols = {
					{
						value = barTextEntry.guid
					},
					{
						value = barTextEntry.name,
						color = nameColor,
					},
					{
						value = GetRelativeToFrameLabel(barTextEntry.position),
					},
					{
						value = barTextEntry.text,
					},
					{
						value = barTextCopyIconMarkup,
						DoCellUpdate = UpdateActionCell,
					},
					{
						value = "X",
						color = deleteActionTextColor,
						DoCellUpdate = UpdateActionCell,
					}
				},
				color = isGlobal and globalRowColor or nil,
			})
		end

		if IsUsingGlobalBarText() then
			for _, globalEntry in ipairs(TRB.Data.settings.core.displayText.barText) do
				if TRB.Functions.BarText:IsEntryInScope(globalEntry, classId, specId) then
					AddRow(globalEntry, true)
				end
			end
		end
		local entries = TRB.Functions.Table:Length(displayText.barText)
		for index = 1, entries do
			AddRow(displayText.barText[index], false)
		end
		btt:SetData(dataTable)
		btt:EnableSelection(true)
	end

	---The table row listing a bar text entry, or nil when this tab does not list it.
	---@param guid string
	---@return integer?
	local function FindListedRow(guid)
		for row, listed in ipairs(listedEntries) do
			if listed.guid == guid then
				return row
			end
		end
		return nil
	end

	---Creates and returns a new default bar text entry with default font, position, and empty text content.
	---@return TRB.Classes.Settings.DisplayTextEntry entry A new display text entry with default values
	local function GetNewDisplayTextEntry()
		-- A grouping's tab starts the text on that grouping's first bar; the spec tab starts it on the main resource bar.
		local startFrame, startLabel = "Resource", primaryLabel
		if groupKey ~= "spec" then
			for _, anchor in ipairs(catalog.entries) do
				if anchor.groupKey == groupKey then
					startFrame, startLabel = anchor.frame, anchor.label
					break
				end
			end
		end
		return {
			enabled = true,
			useDefaultFontFace = true,
			useDefaultFontSize = true,
			useDefaultFontColor = true,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			name = L["NewBarTextEntry"],
			text = "",
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			fontOutline = "OUTLINE",
			fontShadow = {
				enabled = false,
				color = "FF000000",
				xOffset = 1,
				yOffset = -1,
			},
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = startFrame,
				relativeToFrameName = startLabel
			}
		}
	end

	---Finds the bar text entry matching the given GUID and populates the editor fields with its values.
	---@param guid string The unique identifier of the bar text entry to load
	---@param dt TRB.Classes.Settings.DisplayText The display text settings containing the barText array to search
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
		if not found and IsUsingGlobalBarText() then
			for _, globalEntry in ipairs(TRB.Data.settings.core.displayText.barText) do
				if globalEntry.guid == guid then
					workingBarText = globalEntry
					found = true
					break
				end
			end
		end

		if not found then
			return
		end

		TRB.Functions.OptionsUi.Primitives:AttachGlobalBadgeToText(barTextName.label.font, IsGlobalEntry(workingBarText), L["BarTextGlobalBadgeTooltip"])

		barTextName:SetText(workingBarText.name)
		barTextEntryEnabled:SetChecked(workingBarText.enabled)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)

		barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
		barTextRelativeTo:SetupMenu(RelativeToGenerator)
		barTextFontFace:SetupMenu(FontFaceGenerator)
		barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)
		barTextRelativeToFrame:SetDefaultText(GetRelativeToFrameLabel(workingBarText.position))
		barTextRelativeTo:SetDefaultText(workingBarText.position.relativeToName)
		RefreshFontFaceLabel()
		barTextFontJustifyHorizontal:SetDefaultText(workingBarText.fontJustifyHorizontalName)

		fontSize:SetValue(workingBarText.fontSize)
		local currentBarTextColor = NormalizeBarTextEntryColor(workingBarText)
		barTextColor.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(currentBarTextColor, true))
		barText:SetText(workingBarText.text)
		-- Reset undo history so the newly loaded text is the baseline
		if barText.ResetUndoHistory then
			barText:ResetUndoHistory(workingBarText.text)
		end

		barTextHorizontal:SetValue(workingBarText.position.xPos)
		barTextVertical:SetValue(workingBarText.position.yPos)

		useDefaultFontColor:SetChecked(workingBarText.useDefaultFontColor)
		useDefaultFontFace:SetChecked(workingBarText.useDefaultFontFace)
		useDefaultFontSize:SetChecked(workingBarText.useDefaultFontSize)
		useDefaultFontOutline:SetChecked(workingBarText.useDefaultFontOutline or false)
		useDefaultFontShadow:SetChecked(workingBarText.useDefaultFontShadow or false)
		RefreshFontOutlineDisplayText()

		-- Restore font shadow controls
		local shadow = workingBarText.fontShadow or { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		fontShadowEnabled:SetChecked(shadow.enabled)
		barTextShadowColor.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadow.color or "FF000000", true))
		fontShadowXOffset:SetValue(shadow.xOffset or 1)
		fontShadowYOffset:SetValue(shadow.yOffset or -1)

		constrainTextWidth:SetChecked(workingBarText.constrainToParent or false)
		maxWidthPercent:SetValue(workingBarText.maxWidthPercent or 100)
		UpdateBarTextEditorInheritedControlState()

		barTextOptionsFrame:Show()
	end

	RefreshBarTextTable = function()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)

		if workingBarText.guid ~= nil then
			local row = FindListedRow(workingBarText.guid)
			if row == nil then
				-- The open entry left this list (moved, deleted, or filtered out), so its editor closes.
				workingBarText = {}
				barTextOptionsFrame:Hide()
				return
			end
			barTextTable:SetSelection(row)
			if listedEntries[row] ~= workingBarText then
				FillBarTextEditorFields(workingBarText.guid, displayText)
			end
		end
	end

	-- A sibling tab's edits show up when this one comes back into view.
	btc:HookScript("OnShow", function()
		RefreshBarTextTable()
	end)

	local function ScrollBarTextTableToRow(realrow)
		local scrollFrame = barTextTable and barTextTable.scrollframe
		if realrow == nil or scrollFrame == nil then
			return
		end

		local displayIndex = realrow
		local filteredRows = barTextTable.filtered
		local totalRows = #(barTextTable.data or {})
		if filteredRows ~= nil then
			totalRows = #filteredRows
			for i = 1, totalRows do
				if filteredRows[i] == realrow then
					displayIndex = i
					break
				end
			end
		end

		local displayRows = barTextTable.displayRows or 0
		if displayRows <= 0 then
			return
		end

		local offset = math.max(0, displayIndex - displayRows)
		offset = math.min(offset, math.max(0, totalRows - displayRows))
		if FauxScrollFrame_SetOffset ~= nil then
			FauxScrollFrame_SetOffset(scrollFrame, offset)
		end
		scrollFrame:SetVerticalScroll(offset * (barTextTable.rowHeight or 15))
		barTextTable:Refresh()
	end

	local function ClearBarTextRuntimeCaches()
		TRB.Data.cache.barText = {}
		TRB.Functions.BarText:ClearBarTextCacheHash()
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
	end

	local function GetActiveDestinationProfileName(destScope, destClassName, destSpecName)
		local profiles = TRB.Functions.Profiles
		if destScope == "global" then
			return profiles:ResolveCoreProfileName() or profiles.DEFAULT_NAME
		end
		return profiles:ResolveSpecProfileName(destClassName, destSpecName) or profiles.DEFAULT_NAME
	end

	local function IsLiveBarTextDestination(destScope, destProfileName, destClassName, destSpecName)
		return destProfileName == nil or destProfileName == GetActiveDestinationProfileName(destScope, destClassName, destSpecName)
	end

	local function RebuildSpecCacheBarText(destClassName, destSpecName)
		if destClassName == nil or destSpecName == nil then
			return
		end

		local composite = TRB.Functions.Character:GetCompositeKey(destClassName, destSpecName)
		local specCache = TRB.Data.specCache[composite]
		if specCache == nil or specCache.settings == nil then
			return
		end

		local core = TRB.Data.settings.core
		local globalSettings = core.global and core.global[destClassName] and core.global[destClassName][destSpecName]
		local destSpec = TRB.Data.settings[destClassName] and TRB.Data.settings[destClassName][destSpecName]
		if globalSettings == nil or destSpec == nil or destSpec.displayText == nil then
			return
		end

		local mergedBarText = destSpec.displayText.barText
		local globalBarTextCount = 0
		if globalSettings.globalBarText and core.displayText and core.displayText.barText and #core.displayText.barText > 0 then
			mergedBarText = {}
			local registryEntry = TRB.Functions.Character:GetSpecRegistryEntry(composite)
			for _, entry in ipairs(core.displayText.barText) do
				if registryEntry == nil or TRB.Functions.BarText:IsEntryInScope(entry, registryEntry.classId, registryEntry.specId) then
					mergedBarText[#mergedBarText + 1] = entry
				end
			end
			globalBarTextCount = #mergedBarText
			for _, entry in ipairs(destSpec.displayText.barText) do
				mergedBarText[#mergedBarText + 1] = entry
			end
		end

		specCache.settings.displayText = specCache.settings.displayText or {}
		specCache.settings.displayText.barText = mergedBarText
		specCache.settings.displayText.globalBarTextCount = globalBarTextCount
		if globalSettings.displayText and core.displayText then
			specCache.settings.displayText.default = core.displayText.default
		else
			specCache.settings.displayText.default = destSpec.displayText.default
		end
	end

	local function RebuildAllGlobalBarTextSpecCaches()
		for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
			local specCache = TRB.Data.specCache[entry.compositeKey]
			if specCache ~= nil and specCache.settings ~= nil then
				RebuildSpecCacheBarText(entry.className, entry.specName)
			end
		end
	end

	local function DestinationAffectsActiveBarText(destScope, destProfileName, destClassName, destSpecName)
		if not IsLiveBarTextDestination(destScope, destProfileName, destClassName, destSpecName) then
			return false
		end

		if destScope == "global" then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			return charClassName ~= nil and charSpecName ~= nil
				and TRB.Data.settings.core.global[charClassName] ~= nil
				and TRB.Data.settings.core.global[charClassName][charSpecName] ~= nil
				and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText == true
		end

		return destClassName == TRB.Data.character.className and destSpecName == TRB.Data.character.specName
	end

	local function RefreshAfterBarTextEntryCopy(destScope, destProfileName, destClassName, destSpecName)
		local isLiveDestination = IsLiveBarTextDestination(destScope, destProfileName, destClassName, destSpecName)
		if isLiveDestination then
			if destScope == "global" then
				RebuildAllGlobalBarTextSpecCaches()
				TRB.Functions.Profiles:WriteThrough("core")
			else
				RebuildSpecCacheBarText(destClassName, destSpecName)
				TRB.Functions.Profiles:WriteThrough("spec", destClassName, destSpecName)
			end
		else
			TRB.Functions.Profiles:InvalidateCache()
			if TRB.Functions.OptionsUi.Profiles and TRB.Functions.OptionsUi.Profiles.RefreshProfileDropdownForScope then
				if destScope == "global" then
					TRB.Functions.OptionsUi.Profiles:RefreshProfileDropdownForScope("core")
				else
					TRB.Functions.OptionsUi.Profiles:RefreshProfileDropdownForScope("spec", destClassName, destSpecName)
				end
			end
			TRB.Functions.Profiles:FlushActive()
		end

		if DestinationAffectsActiveBarText(destScope, destProfileName, destClassName, destSpecName) then
			ClearBarTextRuntimeCaches()
			TRB.Functions.BarText:CreateBarTextFrames()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function GetDestinationDisplayText(destScope, destProfileName, destClassName, destSpecName)
		local profiles = TRB.Functions.Profiles
		if not IsLiveBarTextDestination(destScope, destProfileName, destClassName, destSpecName) then
			profiles:EnsureStructure()
			local profileList = TRB.Data.settings.profiles and TRB.Data.settings.profiles.list
			if profileList == nil or destProfileName == nil then
				return nil
			end
			profileList[destProfileName] = profileList[destProfileName] or {}
			local profile = profileList[destProfileName]

			if destScope == "global" then
				profile.core = profile.core or {}
				profile.core.displayText = profile.core.displayText or {}
				profile.core.displayText.barText = profile.core.displayText.barText or {}
				return profile.core.displayText
			end

			if destClassName == nil or destSpecName == nil then
				return nil
			end
			profile[destClassName] = profile[destClassName] or {}
			profile[destClassName][destSpecName] = profile[destClassName][destSpecName] or {}
			profile[destClassName][destSpecName].displayText = profile[destClassName][destSpecName].displayText or {}
			profile[destClassName][destSpecName].displayText.barText = profile[destClassName][destSpecName].displayText.barText or {}
			return profile[destClassName][destSpecName].displayText
		end

		if destScope == "global" then
			TRB.Data.settings.core.displayText = TRB.Data.settings.core.displayText or {}
			TRB.Data.settings.core.displayText.barText = TRB.Data.settings.core.displayText.barText or {}
			return TRB.Data.settings.core.displayText
		end

		if destClassName == nil or destSpecName == nil then
			return nil
		end
		if not TRB.Functions.Character:EnsureSpecSettings(destClassName) then
			return nil
		end
		local classSettings = TRB.Data.settings[destClassName]
		local destSpec = classSettings and classSettings[destSpecName]
		if destSpec == nil then
			return nil
		end
		destSpec.displayText = destSpec.displayText or {}
		destSpec.displayText.barText = destSpec.displayText.barText or {}
		return destSpec.displayText
	end

	local function CopyBarTextEntryToDestination(entry, destScope, destProfileName, destClassName, destSpecName)
		local destinationDisplayText = GetDestinationDisplayText(destScope, destProfileName, destClassName, destSpecName)
		if entry == nil or destinationDisplayText == nil or destinationDisplayText.barText == nil then
			return nil
		end

		local copiedEntry = TRB.Functions.Table:DeepCopy(entry)
		copiedEntry.guid = TRB.Functions.String:Guid()
		NormalizeBarTextEntryColor(copiedEntry)
		table.insert(destinationDisplayText.barText, copiedEntry)
		RefreshAfterBarTextEntryCopy(destScope, destProfileName, destClassName, destSpecName)
		return copiedEntry
	end

	local function IsCurrentEditorDestination(destScope, destProfileName, destClassName, destSpecName)
		if not IsLiveBarTextDestination(destScope, destProfileName, destClassName, destSpecName) then
			return false
		end

		if destScope == "global" then
			return classId == nil and specId == nil
		end

		local editorClassName = classId ~= nil and string.lower(className) or nil
		return editorClassName == destClassName and specName == destSpecName
	end

	---@param selectCopy boolean? # Select the copy even though this tab is not its destination, for a Global copy made on a spec's tab
	local function CopyBarTextEntryAndRefreshEditor(entry, destScope, destProfileName, destClassName, destSpecName, selectCopy)
		local copiedEntry = CopyBarTextEntryToDestination(entry, destScope, destProfileName, destClassName, destSpecName)
		if copiedEntry ~= nil and (selectCopy or IsCurrentEditorDestination(destScope, destProfileName, destClassName, destSpecName)) then
			SetTableValues(spec.displayText, barTextTable)
			local newRow = FindListedRow(copiedEntry.guid)
			if newRow ~= nil then
				barTextTable:SetSelection(newRow)
				ScrollBarTextTableToRow(newRow)
				FillBarTextEditorFields(copiedEntry.guid, spec.displayText)
			end
		end
	end

	local moveGroupLabels = {
		spec = L["BarTextGroupSpecBars"],
		castbar = L["TabCastbars"],
		otherBars = L["TabOtherBars"],
		petBars = L["TabPetBars"],
		totems = L["ResourceTotems"],
		skyriding = L["TabSkyriding"],
	}
	local moveGroupOrder = { "spec", "castbar", "otherBars", "petBars", "totems", "skyriding" }

	---Binds an entry to another bar, then redraws the lists and text the move changes.
	---@param entry TRB.Classes.Settings.DisplayTextEntry
	---@param anchor TRB.Classes.BarTextAnchor
	local function MoveBarTextEntryToAnchor(entry, anchor)
		entry.position.relativeToFrame = anchor.frame
		entry.position.relativeToFrameName = anchor.label
		local isGlobal = classId == nil or IsGlobalEntry(entry)
		RefreshBarTextTable()
		if isGlobal then
			RefreshAfterBarTextEntryCopy("global", nil)
		else
			RefreshAfterBarTextEntryCopy("spec", nil, string.lower(className), specName)
		end
	end

	---Lists every bar of the scope a bar text entry can move to: the screen first, then each grouping under its own title.
	---@param menu table
	---@param entry TRB.Classes.Settings.DisplayTextEntry
	local function AddBarTextMoveTargets(menu, entry)
		local function IsCurrentAnchor(anchor)
			return anchor.frame == entry.position.relativeToFrame
		end
		local function MoveToAnchor(anchor)
			MoveBarTextEntryToAnchor(entry, anchor)
		end

		local entryCatalog = CatalogFor(entry)
		for _, anchor in ipairs(entryCatalog.entries) do
			if anchor.groupKey == "screen" then
				menu:CreateRadio(anchor.label, IsCurrentAnchor, MoveToAnchor, anchor)
			end
		end
		for _, moveGroupKey in ipairs(moveGroupOrder) do
			local isFirst = true
			for _, anchor in ipairs(entryCatalog.entries) do
				if anchor.groupKey == moveGroupKey then
					if isFirst then
						menu:CreateDivider()
						menu:CreateTitle(moveGroupLabels[moveGroupKey])
						isFirst = false
					end
					menu:CreateRadio(anchor.label, IsCurrentAnchor, MoveToAnchor, anchor)
				end
			end
		end
	end

	local function ProfileHasCore(profileName)
		if profileName == nil then
			return false
		end
		if IsLiveBarTextDestination("global", profileName) then
			return TRB.Data.settings.core ~= nil
		end
		local profileList = TRB.Data.settings.profiles and TRB.Data.settings.profiles.list
		return profileList ~= nil and profileList[profileName] ~= nil and type(profileList[profileName].core) == "table"
	end

	local function ProfileHasSpec(profileName, profileClassName, profileSpecName)
		if profileName == nil or profileClassName == nil or profileSpecName == nil then
			return false
		end
		if IsLiveBarTextDestination("spec", profileName, profileClassName, profileSpecName) then
			TRB.Functions.Character:EnsureSpecSettings(profileClassName)
			local classSettings = TRB.Data.settings[profileClassName]
			return classSettings ~= nil and classSettings[profileSpecName] ~= nil
		end
		local profileList = TRB.Data.settings.profiles and TRB.Data.settings.profiles.list
		return profileList ~= nil and profileList[profileName] ~= nil
			and type(profileList[profileName][profileClassName]) == "table"
			and type(profileList[profileName][profileClassName][profileSpecName]) == "table"
	end

	local function GetSortedClassSpecs()
		local sortedClasses = {}
		for i, classDef in ipairs(TRB.Data.allClassSpecs or {}) do
			sortedClasses[i] = classDef
		end
		table.sort(sortedClasses, function(a, b) return a.classLabel < b.classLabel end)
		return sortedClasses
	end

	local function GetCopyMenuNewTargetLabel(label)
		return string.format(L["CopyMenuNewTargetFormat"], label)
	end

	local function AddBarTextDestinationProfileSubmenu(parent, onPicked)
		local profiles = TRB.Functions.Profiles
		profiles:EnsureStructure()
		local profileNames = profiles:GetProfileNames()
		local sortedClasses = GetSortedClassSpecs()

		for _, profileName in ipairs(profileNames) do
			local profileMenu = parent:CreateButton(profileName)
			if type(profileMenu) == "table" and type(profileMenu.CreateButton) == "function" then
				local globalLabel = L["ProfileScopeLabelGlobal"]
				if not ProfileHasCore(profileName) then
					globalLabel = GetCopyMenuNewTargetLabel(globalLabel)
				end
				profileMenu:CreateButton(globalLabel, function()
					onPicked(profileName, nil, nil)
				end)

				for _, classDef in ipairs(sortedClasses) do
					local targetClassName = classDef.classKey
					local classMenu = profileMenu:CreateButton(classDef.classLabel)
					if type(classMenu) == "table" and type(classMenu.CreateButton) == "function" then
						local prefix = targetClassName .. "_"
						for _, specDef in ipairs(classDef.specs) do
							local targetSpecName = string.sub(specDef.compositeKey, #prefix + 1)
							local specLabel = specDef.specLabel
							if not ProfileHasSpec(profileName, targetClassName, targetSpecName) then
								specLabel = GetCopyMenuNewTargetLabel(specLabel)
							end
							classMenu:CreateButton(specLabel, function()
								onPicked(profileName, targetClassName, targetSpecName)
							end)
						end
					end
				end
			end
		end
	end

	local function ShowBarTextEntryCopyMenu(owner, entry)
		if owner == nil or entry == nil then
			return
		end

		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			rootDescription:CreateTitle(string.format(L["BarTextCopyMenuTitleFormat"], entry.name or L["BarText"]))
			rootDescription:CreateButton(L["BarTextCopyMenuDuplicate"], function()
				-- Duplicate in the entry's own scope, as Move and Delete do: a Global entry on a spec's tab stays Global and is listed here.
				if classId == nil or specId == nil or IsGlobalEntry(entry) then
					CopyBarTextEntryAndRefreshEditor(entry, "global", nil, nil, nil, true)
				else
					CopyBarTextEntryAndRefreshEditor(entry, "spec", nil, string.lower(className), specName)
				end
			end)

			local moveTo = rootDescription:CreateButton(L["BarTextMoveToBar"])
			if type(moveTo) == "table" and type(moveTo.CreateButton) == "function" then
				if moveTo.SetScrollMode then
					moveTo:SetScrollMode(400)
				end
				AddBarTextMoveTargets(moveTo, entry)
			end

			local copyTo = rootDescription:CreateButton(L["CopyMenuCopyTo"])
			if type(copyTo) == "table" and type(copyTo.CreateButton) == "function" then
				copyTo:CreateTitle(L["CopyMenuCopyTo"])
				copyTo:CreateDivider()
				copyTo:CreateTitle(L["ProfileMenuHeaderProfiles"])
				AddBarTextDestinationProfileSubmenu(copyTo, function(profileName, destClassName, destSpecName)
					if destClassName == nil then
						CopyBarTextEntryAndRefreshEditor(entry, "global", profileName)
					else
						CopyBarTextEntryAndRefreshEditor(entry, "spec", profileName, destClassName, destSpecName)
					end
				end)
			end
		end)
	end

	SetTableValues(spec.displayText, barTextTable)

	addButton:SetScript("OnClick", function(self, ...)
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		local newEntry = GetNewDisplayTextEntry()
		table.insert(displayText.barText, newEntry)
		SetTableValues(displayText, barTextTable)
		local newRow = FindListedRow(newEntry.guid)
		barTextTable:SetSelection(newRow)
		ScrollBarTextTableToRow(newRow)
		-- Refresh the active spec's merged bar text list when global bar text is in use
		-- (the merged table is a copy, so the insert above won't be reflected without a rebuild)
		if classId == nil then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		elseif classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		end
		TRB.Data.cache.barText = {}
		TRB.Functions.BarText:ClearBarTextCacheHash()
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		FillBarTextEditorFields(newEntry.guid, displayText)
	end)

	barTextEntryEnabled:SetScript("OnClick", function(self, ...)
		workingBarText.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
		RefreshBarTextEditorPreview(true)
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
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
		TRB.Functions.BarText:ClearBarTextCacheHash()
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
	end)

	-- Attach undo/redo AFTER SetScript("OnTextChanged") so the HookScript
	-- recording handler is guaranteed to persist.
	TRB.Functions.OptionsUi.BarTextInput:AttachUndoRedo(barText)

	local function ShowActionCellTooltip(cellFrame, text)
		if cellFrame == nil or text == nil then
			return
		end
		GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
		GameTooltip:SetText(text, 1, 1, 1, 1, true)
		GameTooltip:Show()
	end

	barTextTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnEnter(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow ~= nil and realrow > 0 then
				if column == 5 then
					SetActionCellHoverState(cellFrame, true)
					ShowActionCellTooltip(cellFrame, L["BarTextCopyActionTooltip"])
				elseif column == 6 then
					SetActionCellHoverState(cellFrame, true)
					ShowActionCellTooltip(cellFrame, L["BarTextDeleteActionTooltip"])
				end
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnLeave(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if column == 5 or column == 6 then
				SetActionCellHoverState(cellFrame, false)
				GameTooltip:Hide()
			end
		end,
		OnClick = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				local currentSelection = scrollingTable:GetSelection()

				if realrow ~= nil and realrow > 0 then
					local guid = data[realrow].cols[1].value

					if column == 5 then
						ShowBarTextEntryCopyMenu(cellFrame or rowFrame, listedEntries[realrow])
					elseif column == 6 then
						local entry = listedEntries[realrow]
						local isGlobal = IsGlobalEntry(entry)
						local message = string.format(L["BarTextDeleteConfirmation"], data[realrow].cols[2].value)
						if isGlobal then
							local otherSpecs = 0
							for _, specEntry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
								if specEntry.classId ~= classId or specEntry.specId ~= specId then
									local classFlags = TRB.Data.settings.core.global[specEntry.className]
									local flags = classFlags and classFlags[specEntry.specName]
									if flags ~= nil and flags.globalBarText == true and TRB.Functions.BarText:IsEntryInScope(entry, specEntry.classId, specEntry.specId) then
										otherSpecs = otherSpecs + 1
									end
								end
							end
							message = string.format(L["BarTextDeleteGlobalConfirmation"], data[realrow].cols[2].value, otherSpecs)
						end
						-- Global Bar Text is deleted from Global Options, and refreshed the way that editor does.
						StaticPopup_Show("TwintopResourceBar_ConfirmDeleteBarText", nil, nil, {
							message = message,
							displayText = isGlobal and TRB.Data.settings.core.displayText or spec.displayText,
							guid = guid,
							btt = scrollingTable,
							classId = (not isGlobal) and classId or nil,
							specId = (not isGlobal) and specId or nil,
							barTextOptionsFrame = barTextOptionsFrame,
							refreshTable = RefreshBarTextTable,
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

	---Replaces the spec's bar text entries, updates the specCache, refreshes the scrolling table, and triggers bar text frame recreation.
	---@param barText TRB.Classes.Settings.DisplayTextEntry[] The new array of bar text entries to apply
	local function ResetTableValues(barText)
		barText = TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(barText)
		spec.displayText.barText = barText
		if TRB.Data.specCache[compositeKey] then
			if not TRB.Data.specCache[compositeKey].settings.displayText then
				TRB.Data.specCache[compositeKey].settings.displayText = {}
			end
			TRB.Data.specCache[compositeKey].settings.displayText.barText = barText
		end
		SetTableValues(spec.displayText, barTextTable)
		_G["TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame"]:Hide()

		if classId == nil then
			-- Global bar text editor: rebuild the active spec if it uses global bar text
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
				TRB.Data.cache.barText = {}
				TRB.Functions.BarText:ClearBarTextCacheHash()
				TRB.Data.cache.symbols = {}
				TRB.Data.cache.barTextTree = {}
				TRB.Data.activeVariables = nil
				-- Use the active spec's merged settings (not core) so frame indices match the merged barText list
				local activeCompositeKey = TRB.Functions.Character:GetCompositeKey(charClassName, charSpecName)
				local activeSettings = TRB.Data.specCache[activeCompositeKey] and TRB.Data.specCache[activeCompositeKey].settings
				TRB.Functions.BarText:Hide(activeSettings or spec)
				TRB.Functions.BarText:CreateBarTextFrames()
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		elseif classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
			TRB.Data.cache.barText = {}
			TRB.Functions.BarText:ClearBarTextCacheHash()
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Data.activeVariables = nil
			-- Hide all existing bar text frames before recreating to prevent stale text from persisting
			TRB.Functions.BarText:Hide(spec)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			-- Force an immediate bar text update so the new strings render right away
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		for siblingGroupKey, sibling in pairs(barTextEditors[scopeKey]) do
			if siblingGroupKey ~= groupKey then
				sibling.RefreshTable()
			end
		end
		TRB.Functions.OptionsUi.Tabs:SwitchToBarTextTabByClassSpec(classId, specId)
	end

	-- The spec tab's editor is the one the reset popups and the global reset reach through the controls.
	if groupKey == "spec" then
		controls.barTextFields = {}
		controls.barTextFields.barTextTable = barTextTable
		controls.barTextFields.ResetTableValues = ResetTableValues
	end
	barTextEditors[scopeKey] = barTextEditors[scopeKey] or {}
	barTextEditors[scopeKey][groupKey] = { RefreshTable = RefreshBarTextTable, RefreshUseGlobalCheckbox = RefreshUseGlobalCheckbox }

	yCoord = oldYCoord
	local variablesPanel = TRB.Functions.OptionsUi.BarTextVariables:CreateVariablesSidePanel(parent, namePrefix, cache, classId, specId)
	-- Tag the scroll child's ancestor (the tabsheet parent) so SwitchTab/SelectCategory can find the right panel
	parent.barTextVariablesPanel = variablesPanel
	TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
end

---Redraws every built editor's Use Global Bar Text box from the saved flag, and its table, which lists Global Bar
---Text only while that box is checked.
function TRB.Functions.OptionsUi.BarText:RefreshUseGlobalBarText()
	for _, scopeEditors in pairs(barTextEditors) do
		for _, editor in pairs(scopeEditors) do
			editor.RefreshUseGlobalCheckbox()
			editor.RefreshTable()
		end
	end
end

---The bar text variables Global bar text can use, which the Global editors share.
---@return table
function TRB.Functions.OptionsUi.BarText:GetGlobalVariablesCache()
	local varCategory = TRB.Functions.BarText.VariableCategory
	return {
		barTextVariables = {
			icons = TRB.Functions.BarText:GetCommonIcons(),
			values = TRB.Functions.BarText:GetCommonValues({
				{ variable = "$resource", description = L["GlobalBarTextVariable_resource"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$resourceMax", description = L["GlobalBarTextVariable_resourceMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$casting", description = L["GlobalBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$comboPoints", description = L["GlobalBarTextVariable_comboPoints"] .. " " .. L["GlobalBarTextWarningComboPoints"], printInSettings = true, color = false, category = varCategory.RESOURCES },
				{ variable = "$comboPointsMax", description = L["GlobalBarTextVariable_comboPointsMax"] .. " " .. L["GlobalBarTextWarningComboPoints"], printInSettings = true, color = false, category = varCategory.RESOURCES },
			}),
		}
	}
end

---Constructs the Bar Text tab of a shared grouping's strip: the bar text bound to just that grouping's bars.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param groupKey string # castbar, otherBars, petBars, or skyriding
function TRB.Functions.OptionsUi.BarText:ConstructGroupPanel(parent, classId, specId, groupKey)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec, cache
	if classId == nil then
		spec = TRB.Data.settings.core
		cache = self:GetGlobalVariablesCache()
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
		cache = TRB.Data.specCache[TRB.Functions.Character:GetCompositeKey(classNameLower, specName)]
	end
	if spec == nil or cache == nil then
		return
	end

	-- Each grouping's tab gets its own controls: they would otherwise overwrite each other's under one scope.
	local controls = { checkBoxes = {}, colors = {}, labels = {}, buttons = {} }
	local sectionTitle = L["BarDisplayTextCustomizationHeader"]
	if groupKey == "castbar" then
		sectionTitle = L["BarDisplayTextCustomizationHeaderCastbar"]
	elseif groupKey == "otherBars" then
		sectionTitle = L["BarDisplayTextCustomizationHeaderOtherBars"]
	elseif groupKey == "petBars" then
		sectionTitle = L["BarDisplayTextCustomizationHeaderPetBars"]
	elseif groupKey == "totems" then
		sectionTitle = L["BarDisplayTextCustomizationHeaderTotems"]
	elseif groupKey == "skyriding" then
		sectionTitle = L["BarDisplayTextCustomizationHeaderSkyriding"]
	end
	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, sectionTitle, oUi.xCoord, 5)
	-- The first row clears the header, as on a class's own Bar Text tab; the Global screens have no Use Global box there, so the table takes it.
	self:GenerateBarTextEditor(parent, controls, spec, classId, specId, -25, cache, { groupKey = groupKey })
end
