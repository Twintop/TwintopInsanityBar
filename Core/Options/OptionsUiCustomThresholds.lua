---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.CustomThresholds = TRB.Functions.OptionsUi.CustomThresholds or {}

local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization
local copyActionIconMarkup = "|TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:14:14:0:0|t"
local actionCellDimAlpha = 0.65
local actionCellBrightAlpha = 1.0
local deleteActionTextColor = { r = 1, g = 0.12, b = 0.12, a = 1 }

StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteCustomThreshold"] = {
	text = "%s",
	button1 = L["CustomThresholdDelete"],
	button2 = CANCEL,
	OnAccept = function(self, data)
		if data == nil then
			return
		end

		local guid = data.guid
		local spec = data.spec
		if spec and spec.thresholds then
			spec.thresholds.customThresholds[guid] = nil
			local dictionaryKey = TRB.Functions.Settings:GetCustomThresholdDictionaryKey(guid)
			if dictionaryKey ~= nil then
				spec.thresholds.thresholdDictionary[dictionaryKey] = nil
			end
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

---@param spec table
local function EnsureCustomThresholdSettings(spec)
	spec.thresholds = spec.thresholds or {}
	spec.thresholds.customThresholds = spec.thresholds.customThresholds or {}
	spec.thresholds.thresholdDictionary = spec.thresholds.thresholdDictionary or {}
end

---@param guid string
---@param spec table
---@return table?
local function EnsureThresholdDictionaryEntry(guid, spec)
	EnsureCustomThresholdSettings(spec)
	local dictionaryKey = TRB.Functions.Settings:GetCustomThresholdDictionaryKey(guid)
	if dictionaryKey == nil then
		return nil
	end
	if spec.thresholds.thresholdDictionary[dictionaryKey] == nil and spec.thresholds.thresholdDictionary[guid] ~= nil then
		spec.thresholds.thresholdDictionary[dictionaryKey] = spec.thresholds.thresholdDictionary[guid]
	end
	spec.thresholds.thresholdDictionary[dictionaryKey] = TRB.Functions.Settings:NormalizeThresholdDictionaryEntry(spec.thresholds.thresholdDictionary[dictionaryKey], true)
	return spec.thresholds.thresholdDictionary[dictionaryKey]
end

---@param spec table
---@return table[]
local function GetOrderedEntries(spec)
	local entries = {}
	if spec == nil or spec.thresholds == nil or spec.thresholds.customThresholds == nil then
		return entries
	end

	for guid, customThreshold in pairs(spec.thresholds.customThresholds) do
		if type(customThreshold) == "table" then
			customThreshold.guid = customThreshold.guid or guid
			table.insert(entries, customThreshold)
		end
	end

	table.sort(entries, function(a, b)
		local aName = a.name or ""
		local bName = b.name or ""
		if aName == bName then
			return (a.guid or "") < (b.guid or "")
		end
		return aName < bName
	end)

	return entries
end

---@param spec table
---@param barTarget string
---@param classId integer?
---@param specId integer?
---@return number minValue
---@return number maxValue
local function GetBarTargetRange(spec, barTarget, classId, specId)
	return TRB.Functions.Threshold:GetCustomThresholdTargetRange(spec, barTarget, nil, classId, specId)
end

---Returns the decimal precision allowed on the Threshold Value slider for a given bar target.
---@param spec table
---@param barTarget string
---@param classId integer?
---@param specId integer?
---@return integer
local function GetBarTargetDecimals(spec, barTarget, classId, specId)
	for _, target in ipairs(TRB.Functions.Threshold:GetCustomThresholdBarTargets(spec, classId, specId)) do
		if target.key == barTarget then
			return target.decimals or 0
		end
	end
	return 0
end

---@param className string
---@param specName string
local function RefreshSpecCache(className, specName)
	if className ~= nil and specName ~= nil then
		TRB.Functions.Character:FillSpecializationCacheSettings(className, specName)
	end

	if className == TRB.Data.character.className and specName == TRB.Data.character.specName then
		TRB.Data.lookupDirty = true
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end

		-- TriggerResourceBarUpdates() is class-specific and does not always guarantee
		-- custom threshold redraws, so force custom threshold refresh for immediate UI feedback.
		local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
		local specCacheEntry = compositeKey and TRB.Data.specCache and TRB.Data.specCache[compositeKey]
		if specCacheEntry ~= nil and specCacheEntry.settings ~= nil then
			TRB.Functions.Threshold:UpdateCustomThresholdLines(specCacheEntry.settings, TRB.Frames.barGroups)
		elseif TRB.Data.barConstructedForSpec and TRB.Data.specCache[TRB.Data.barConstructedForSpec] then
			TRB.Functions.Threshold:UpdateCustomThresholdLines(TRB.Data.specCache[TRB.Data.barConstructedForSpec].settings, TRB.Frames.barGroups)
		end
	end
end

---@param sourceLine table
---@param sourceDictEntry table
---@param destClassName string
---@param destSpecName string
---@return table?
local function CopyCustomThresholdToSpec(sourceLine, sourceDictEntry, destClassName, destSpecName)
	if sourceLine == nil or destClassName == nil or destSpecName == nil then
		return nil
	end

	if not TRB.Functions.Character:EnsureSpecSettings(destClassName) then
		return nil
	end

	local destSpec = TRB.Data.settings[destClassName] and TRB.Data.settings[destClassName][destSpecName]
	if destSpec == nil then
		return nil
	end

	EnsureCustomThresholdSettings(destSpec)
	local copiedLine = TRB.Functions.Table:DeepCopy(sourceLine)
	copiedLine.guid = TRB.Functions.String:Guid()
	local dictionaryKey = TRB.Functions.Settings:GetCustomThresholdDictionaryKey(copiedLine.guid)
	destSpec.thresholds.customThresholds[copiedLine.guid] = copiedLine
	destSpec.thresholds.thresholdDictionary[dictionaryKey] = TRB.Functions.Table:DeepCopy(sourceDictEntry or TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true))
	RefreshSpecCache(destClassName, destSpecName)
	return copiedLine
end

local function BuildCheckButton(parent, name, label, x, y)
	local checkbox = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", x, y)
	getglobal(checkbox:GetName() .. "Text"):SetText(label)
	return checkbox
end

---@param parent Frame
---@param controls table
---@param spec table
---@param classId integer
---@param specId integer
---@param yCoord number
---@return number
function TRB.Functions.OptionsUi.CustomThresholds:GenerateCustomThresholdsPanel(parent, controls, spec, classId, specId, yCoord)
	if parent == nil or spec == nil then
		return yCoord
	end

	EnsureCustomThresholdSettings(spec)
	controls.customThresholds = controls.customThresholds or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.dropDown = controls.dropDown or {}
	controls.sliders = controls.sliders or {}
	controls.colors = controls.colors or {}
	controls.colors.customThresholds = controls.colors.customThresholds or {}

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local lowerClassName = string.lower(className)
	local namePrefix = lowerClassName .. "_" .. specName .. "_CustomThresholds"
	local selectedGuid = nil
	local isRefreshing = false
	-- Decimal precision currently applied to the Threshold Value slider. Most bars use whole
	-- numbers; bars whose underlying resource has finer granularity than its node count (e.g.
	-- Destruction Warlock Soul Shards) opt into decimals via the bar-target descriptor.
	local currentValueDecimals = 0
	-- Whether the current bar target is on a fixed 0-100% scale (Mana/Stagger/Health). These are
	-- absolute-only, so the Absolute/Offset mode dropdown is hidden for them.
	local currentValueIsPercent = false

	local function RefreshRuntime()
		RefreshSpecCache(lowerClassName, specName)
	end

	local function GetCurrentSpec()
		return TRB.Data.settings[lowerClassName] and TRB.Data.settings[lowerClassName][specName]
	end

	-- Secret cast-count targets (Soul Fragments, Fire Blast charges, Bone Shield) are forced to the
	-- static color mode and their icon is always full color (no under->over trigger). Shared detector
	-- so the options UI and the runtime renderer agree on which targets are static-only.
	local function IsTargetStaticColorOnly(barTarget)
		return TRB.Functions.Threshold:BarTargetUsesSecretValue(barTarget, classId, specId)
	end

	local function GetCurrentThresholdSettings()
		local currentSpec = GetCurrentSpec()
		return currentSpec and currentSpec.thresholds or TRB.Functions.Settings:DefaultThresholdSettings()
	end

	local function GetCurrentThresholdColors()
		local currentSpec = GetCurrentSpec()
		return currentSpec and currentSpec.colors and currentSpec.colors.threshold or TRB.Functions.Settings:DefaultThresholdColors()
	end

	local columns = {
		{ name = "", width = 1, align = "CENTER" },
		{ name = "", width = 22, align = "CENTER" },
		{ name = L["Name"], width = 170, align = "LEFT", sort = 1, defaultsort = 1 },
		{ name = L["BoundToBar"], width = 120, align = "LEFT" },
		{ name = L["CustomThresholdTableHeaderValue"], width = 70, align = "RIGHT" },
		{ name = L["Enabled"], width = 70, align = "LEFT" },
		{ name = "", width = 22, align = "CENTER" },
		{ name = "", width = 15, align = "CENTER", color = { r = 1, g = 0, b = 0, a = 1 } },
	}

	yCoord = yCoord - 5
	controls.customThresholds.header = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CustomThresholdsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 20

	local tableContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	tableContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord - 10)
	tableContainer:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	tableContainer:SetHeight(35 + 5 * 15)

	local customThresholdTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 5, 15, nil, tableContainer, false, false)
	controls.customThresholds.table = customThresholdTable

	-- Dynamically resize the Name column to fill available width (matches every other options table).
	tableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[4].width + columns[5].width + columns[6].width + columns[7].width + columns[8].width
		columns[3].width = math.max(120, w - fixedWidth - 30)
		customThresholdTable:SetDisplayCols(columns)
	end)

	-- Dim the copy/delete action-cell glyphs by default, brightening on hover (matches Bar Text styling).
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

	-- Fixed (non-scrolling) header row that holds the Name field, Enabled checkbox, and Add button.
	-- The Name/Enabled controls are shown/hidden alongside the editor panel; the Add button is always visible.
	local editorHeaderRow = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_EditorHeaderRow", parent)
	editorHeaderRow:SetPoint("TOPLEFT", tableContainer, "BOTTOMLEFT", 0, -2)
	editorHeaderRow:SetPoint("TOPRIGHT", tableContainer, "BOTTOMRIGHT", 0, -2)
	editorHeaderRow:SetHeight(45)
	controls.customThresholds.editorHeaderRow = editorHeaderRow

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["CustomThresholdAdd"], 0, 0, 140, 24)
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", editorHeaderRow, "TOPRIGHT", -5, -8)
	controls.customThresholds.addButton = addButton

	local nameLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorHeaderRow, L["CustomThresholdNameLabel"], oUi.xCoord, 0, 110, 20)
	local nameBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(editorHeaderRow, "", 80, 260, 20, oUi.xCoord, -20)
	local enabledCheckbox = BuildCheckButton(editorHeaderRow, "TwintopResourceBar_" .. namePrefix .. "_Enabled", L["Enabled"], oUi.xCoord2, -18)
	nameLabel:Hide()
	nameBox:Hide()
	enabledCheckbox:Hide()

	local editorFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_Editor", parent, "BackdropTemplate")
	editorFrame:SetPoint("TOPLEFT", editorHeaderRow, "BOTTOMLEFT", 0, -5)
	editorFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -oUi.xCoord, 3)
	editorFrame:Hide()
	controls.customThresholds.editorFrame = editorFrame

	-- Scroll frame inside the editor panel so all "Bar Target onward" controls scroll (mirrors the Threshold Lines tab).
	local editorScrollFrame = CreateFrame("ScrollFrame", "TwintopResourceBar_" .. namePrefix .. "_EditorScroll", editorFrame, "UIPanelScrollFrameTemplate")
	editorScrollFrame:SetPoint("TOPLEFT", editorFrame, "TOPLEFT", 0, 0)
	editorScrollFrame:SetPoint("BOTTOMRIGHT", editorFrame, "BOTTOMRIGHT", -20, 0)
	local editorContent = CreateFrame("Frame", nil, editorScrollFrame)
	editorContent:SetSize(editorScrollFrame:GetWidth() or 600, 1)
	editorScrollFrame:SetScrollChild(editorContent)
	editorScrollFrame:HookScript("OnSizeChanged", function(self, w, h)
		editorContent:SetWidth(w)
	end)

	local editorY = 0
	local barTargetDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_BarTarget", editorContent, "WowStyle1DropdownTemplate")
	barTargetDropdown:SetWidth(oUi.sliderWidth)
	barTargetDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["BoundToBar"], oUi.xCoord, editorY)
	barTargetDropdown.label.font:SetFontObject(GameFontNormal)
	barTargetDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY - 25)

	local valueSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["CustomThresholdValue"], 0, 100, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, editorY - 25)

	-- Absolute/Offset mode selector, stacked beneath Bound-To-Bar in the left column.
	local valueModeDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ValueMode", editorContent, "WowStyle1DropdownTemplate")
	valueModeDropdown:SetWidth(oUi.sliderWidth)
	valueModeDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["CustomThresholdValueMode"], oUi.xCoord, editorY - 50)
	valueModeDropdown.label.font:SetFontObject(GameFontNormal)
	valueModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY - 75)

	editorY = editorY - 105
	local iconHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["CustomThresholdIconHeader"], oUi.xCoord, editorY)
	iconHeader.font:SetFontObject(GameFontNormalLarge)
	editorY = editorY - 28

	local iconTypeDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_IconType", editorContent, "WowStyle1DropdownTemplate")
	iconTypeDropdown:SetWidth(oUi.sliderWidth)
	iconTypeDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["CustomThresholdIconSourceType"], oUi.xCoord, editorY)
	iconTypeDropdown.label.font:SetFontObject(GameFontNormal)
	iconTypeDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY - 25)

	local iconIdLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorContent, L["CustomThresholdIconSourceId"], oUi.xCoord2, editorY, 150, 20)
	local iconIdBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(editorContent, "", 12, 110, 20, oUi.xCoord2, editorY - 25)
	iconIdBox:SetNumeric(true)
	local iconPreview = CreateFrame("Frame", nil, editorContent, "BackdropTemplate")
	iconPreview:SetPoint("TOPLEFT", iconIdBox, "TOPRIGHT", 15, 0)
	iconPreview:SetSize(32, 32)
	iconPreview.texture = iconPreview:CreateTexture(nil, "ARTWORK")
	iconPreview.texture:SetAllPoints(iconPreview)

	editorY = editorY - 85
	local colorsHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["ThresholdDetailColorsHeader"], oUi.xCoord, editorY)
	colorsHeader.font:SetFontObject(GameFontNormalLarge)
	editorY = editorY - 30

	local colorModeDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ColorMode", editorContent, "WowStyle1DropdownTemplate")
	colorModeDropdown:SetWidth(oUi.sliderWidth)
	colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY)
	local staticColorPicker = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(editorContent, L["ThresholdDetailColorModeStaticColor"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, editorY)

	editorY = editorY - 35
	local underModeDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_UnderMode", editorContent, "WowStyle1DropdownTemplate")
	underModeDropdown:SetWidth(oUi.sliderWidth)
	underModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY)
	local underColorPicker = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(editorContent, L["ThresholdDetailColorsUnder"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, editorY)

	editorY = editorY - 35
	local overModeDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_OverMode", editorContent, "WowStyle1DropdownTemplate")
	overModeDropdown:SetWidth(oUi.sliderWidth)
	overModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY)
	local overColorPicker = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(editorContent, L["ThresholdDetailColorsOver"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, editorY)

	editorY = editorY - 55
	local lineHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["ThresholdDetailLineHeader"], oUi.xCoord, editorY)
	lineHeader.font:SetFontObject(GameFontNormalLarge)
	editorY = editorY - 30
	local lineUseSpecificCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_LineUseSpecific", L["ThresholdDetailLineUseSpecific"], oUi.xCoord, editorY)
	local lineOverlapBorderCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_LineOverlapBorder", L["ThresholdDetailLineOverlapBorder"], oUi.xCoord2, editorY)
	editorY = editorY - 50
	local lineWidthSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["ThresholdDetailLineWidth"], 0, 20, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, editorY)

	editorY = editorY - 75
	local iconOverrideHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["ThresholdDetailIconHeader"], oUi.xCoord, editorY)
	iconOverrideHeader.font:SetFontObject(GameFontNormalLarge)
	editorY = editorY - 30
	local iconUseSpecificCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_IconUseSpecific", L["ThresholdDetailIconUseSpecific"], oUi.xCoord, editorY)
	local iconShowCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_IconShow", L["ThresholdDetailIconShowCheckbox"], oUi.xCoord2, editorY)
	editorY = editorY - 28
	local iconDesaturateCheckbox = BuildCheckButton(editorContent, "TwintopResourceBar_" .. namePrefix .. "_IconDesaturate", L["ThresholdDetailIconDesaturate"], oUi.xCoord2 + oUi.xPadding * 2, editorY)
	editorY = editorY - 45

	local iconRelativeToDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_IconRelativeTo", editorContent, "WowStyle1DropdownTemplate")
	iconRelativeToDropdown:SetWidth(oUi.sliderWidth)
	iconRelativeToDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(editorContent, L["ThresholdDetailIconRelativePosition"], oUi.xCoord, editorY)
	iconRelativeToDropdown.label.font:SetFontObject(GameFontNormal)
	iconRelativeToDropdown:SetPoint("TOPLEFT", oUi.xCoord, editorY - 25)

	local iconWidthSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["ThresholdDetailIconWidth"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, editorY - 25)
	editorY = editorY - 85
	local iconHeightSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["ThresholdDetailIconHeight"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, editorY)
	local iconBorderSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["ThresholdDetailIconBorderWidth"], 0, 12, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, editorY)
	editorY = editorY - 85
	local iconXSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["ThresholdDetailIconXPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, editorY)
	local iconYSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(editorContent, L["ThresholdDetailIconYPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, editorY)

	local function GetSelectedLine()
		local currentSpec = GetCurrentSpec()
		return selectedGuid and currentSpec and currentSpec.thresholds.customThresholds[selectedGuid] or nil
	end

	local function GetSelectedDictEntry()
		if selectedGuid == nil then
			return nil
		end
		local currentSpec = GetCurrentSpec()
		return currentSpec and EnsureThresholdDictionaryEntry(selectedGuid, currentSpec) or nil
	end

	local function GetSelectedDictEntrySections()
		local dictEntry = GetSelectedDictEntry()
		if dictEntry == nil then
			return nil, nil, nil, nil
		end
		---@cast dictEntry TRB.Classes.Settings.ThresholdDictionaryEntry
		dictEntry.colors = dictEntry.colors or {}
		local dictColors = dictEntry.colors --[[@as table]]
		local currentThresholdColors = GetCurrentThresholdColors()
		local defaultThresholdColors = TRB.Functions.Settings:DefaultThresholdColors()
		local underColor = (currentThresholdColors and currentThresholdColors.under and currentThresholdColors.under.color) or defaultThresholdColors.under.color
		local overColor = (currentThresholdColors and currentThresholdColors.over and currentThresholdColors.over.color) or defaultThresholdColors.over.color
		dictColors.staticColor = dictColors.staticColor or { color = underColor }
		dictColors.under = dictColors.under or { mode = "shared", color = underColor }
		dictColors.over = dictColors.over or { mode = "shared", color = overColor }
		dictEntry.line = dictEntry.line or {}
		dictEntry.icon = dictEntry.icon or {}
		return dictEntry, dictColors, dictEntry.line, dictEntry.icon
	end

	local function UpdateIconPreview(line)
		local texture = TRB.Functions.Threshold:GetCustomThresholdIconTexture(line)
		if texture ~= nil then
			iconPreview.texture:SetTexture(texture)
			iconPreview:Show()
		else
			iconPreview.texture:SetTexture(nil)
			iconPreview:Show()
		end
	end

	local function SetTableValues()
		local currentSpec = GetCurrentSpec()
		if currentSpec == nil then
			return
		end
		-- Build a key -> label lookup from the bound-bar descriptors so the table shows the
		-- same resource-accurate names (e.g. "Insanity", "Holy Word: Serenity") as the editor.
		local targetLabels = {}
		for _, target in ipairs(TRB.Functions.Threshold:GetCustomThresholdBarTargets(currentSpec, classId, specId)) do
			targetLabels[target.key] = target.label
		end
		local dataTable = {}
		for _, customThreshold in ipairs(GetOrderedEntries(currentSpec)) do
			local dictEntry = currentSpec.thresholds.thresholdDictionary[TRB.Functions.Settings:GetCustomThresholdDictionaryKey(customThreshold.guid)]
			local texture = TRB.Functions.Threshold:GetCustomThresholdIconTexture(customThreshold)
			local iconText = texture and ("|T" .. tostring(texture) .. ":16|t") or ""
			local barTargetKey = customThreshold.barTarget or "primary"
			local targetLabel = targetLabels[barTargetKey]
			if targetLabel == nil and TRB.Functions.Bar and TRB.Functions.Bar.GetBarDisplayName then
				targetLabel = TRB.Functions.Bar:GetBarDisplayName(barTargetKey)
			end
			local enabledText = dictEntry and dictEntry.enabled and ("|cFF00FF00" .. L["BarTextVariablesStatusYes"] .. "|r") or ("|cFFFF0000" .. L["BarTextVariablesStatusNo"] .. "|r")
			table.insert(dataTable, {
				cols = {
					{ value = customThreshold.guid },
					{ value = iconText },
					{ value = customThreshold.name or L["CustomThresholdDefaultName"] },
					{ value = targetLabel },
					{ value = (customThreshold.valueMode == "offset") and string.format(L["CustomThresholdOffsetDisplay"], customThreshold.value or 0) or tostring(customThreshold.value or 0) },
					{ value = enabledText },
					{ value = copyActionIconMarkup, DoCellUpdate = UpdateActionCell },
					{ value = "X", color = deleteActionTextColor, DoCellUpdate = UpdateActionCell },
				}
			})
		end
		customThresholdTable:SetData(dataTable)
		customThresholdTable:EnableSelection(true)
	end

	local function RepositionEditorControls(isThresholdEnabled, colorMode, dictColors, dictLine, dictIcon)
		local y = 0

		barTargetDropdown.label:ClearAllPoints()
		barTargetDropdown.label:SetPoint("TOPLEFT", oUi.xCoord, y)
		barTargetDropdown:ClearAllPoints()
		barTargetDropdown:SetPoint("TOPLEFT", oUi.xCoord, y - 25)
		valueSlider:ClearAllPoints()
		valueSlider:SetPoint("TOPLEFT", oUi.xCoord2, y - 25)

		-- Mode dropdown stacks beneath Bound-To-Bar (left column); hidden for absolute-only percent targets.
		if currentValueIsPercent then
			valueModeDropdown:Hide()
			valueModeDropdown.label:Hide()
			y = y - 65
		else
			valueModeDropdown.label:ClearAllPoints()
			valueModeDropdown.label:SetPoint("TOPLEFT", oUi.xCoord, y - 50)
			valueModeDropdown:ClearAllPoints()
			valueModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y - 75)
			valueModeDropdown.label:Show()
			valueModeDropdown:Show()
			y = y - 105
		end

		y = TRB.Functions.OptionsUi.ThresholdList:ApplyColorOverrideLayout({
			yCoord = y,
			isEnabled = isThresholdEnabled,
			colorMode = colorMode,
			hasUnusable = false,
			hasOutOfRange = false,
			underMode = TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(dictColors and dictColors.under),
			overMode = TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(dictColors and dictColors.over),
			colorsHeader = colorsHeader,
			colorModeDropdown = colorModeDropdown,
			staticColorPicker = staticColorPicker,
			underModeDropdown = underModeDropdown,
			underColorPicker = underColorPicker,
			overModeDropdown = overModeDropdown,
			overColorPicker = overColorPicker,
		})

		-- Icon Source sits between the Line and Icon override sections. When its type is
		-- "No Icon", the whole Icon override subsection is hidden (hasThresholdIcon=false).
		local selectedLine = GetSelectedLine()
		local iconType = (selectedLine and selectedLine.iconSourceType) or "none"
		local hasThresholdIcon = iconType ~= "none"

		y = TRB.Functions.OptionsUi.ThresholdList:ApplyLineIconOverrideLayout({
			yCoord = y,
			isEnabled = isThresholdEnabled,
			hasThresholdIcon = hasThresholdIcon,
			lineHeader = lineHeader,
			lineUseSpecificCheckbox = lineUseSpecificCheckbox,
			lineWidthSlider = lineWidthSlider,
			lineOverlapBorderCheckbox = lineOverlapBorderCheckbox,
			iconSourceSection = {
				header = iconHeader,
				typeDropdown = iconTypeDropdown,
				idLabel = iconIdLabel,
				idBox = iconIdBox,
				preview = iconPreview,
				showIdControls = hasThresholdIcon,
			},
			iconHeader = iconOverrideHeader,
			iconUseSpecificCheckbox = iconUseSpecificCheckbox,
			iconRelativeToDropdown = iconRelativeToDropdown,
			iconShowCheckbox = iconShowCheckbox,
			iconDesaturateCheckbox = iconDesaturateCheckbox,
			iconWidthSlider = iconWidthSlider,
			iconHeightSlider = iconHeightSlider,
			iconXSlider = iconXSlider,
			iconYSlider = iconYSlider,
			iconBorderSlider = iconBorderSlider,
		})
		-- Forced-static thresholds (secret cast-count bars) always show a full-color icon (no
		-- under->over trigger exists), so the "Desaturate icon" option is meaningless: keep it
		-- unchecked and disabled. Other targets keep the normal "enabled while the icon shows" rule.
		local staticColorOnly = selectedLine ~= nil and IsTargetStaticColorOnly(selectedLine.barTarget)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(iconDesaturateCheckbox, (dictIcon and dictIcon.show ~= false) and not staticColorOnly)

		local minHeight = 360
		editorContent:SetHeight(math.max(minHeight, math.abs(y) + 30))
	end

	local function HideEditor()
		editorFrame:Hide()
		nameLabel:Hide()
		nameBox:Hide()
		enabledCheckbox:Hide()
	end

	local function RefreshEditor(guid)
		selectedGuid = guid
		local line = GetSelectedLine()
		if line == nil then
			HideEditor()
			return
		end

		local dictEntry, dictColors, dictLine, dictIcon = GetSelectedDictEntrySections()
		if dictEntry == nil then
			HideEditor()
			return
		end
		---@cast dictColors table
		---@cast dictLine table
		---@cast dictIcon table
		local function ReflowColorSectionOnly()
			RepositionEditorControls(dictEntry.enabled == true, dictColors.colorMode or "dynamic", dictColors, dictLine, dictIcon)
		end
		isRefreshing = true
		editorFrame:Show()
		nameLabel:Show()
		nameBox:Show()
		enabledCheckbox:Show()
		nameBox:SetText(line.name or L["CustomThresholdDefaultName"])
		enabledCheckbox:SetChecked(dictEntry.enabled == true)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, dictEntry.enabled == true, true)

		local currentSpec = GetCurrentSpec() or spec
		local currentThresholdSettings = GetCurrentThresholdSettings()
		local currentThresholdColors = GetCurrentThresholdColors()
		local defaultThresholdColors = TRB.Functions.Settings:DefaultThresholdColors()
		local underColor = (currentThresholdColors and currentThresholdColors.under and currentThresholdColors.under.color) or defaultThresholdColors.under.color
		local overColor = (currentThresholdColors and currentThresholdColors.over and currentThresholdColors.over.color) or defaultThresholdColors.over.color

		local currentBarTarget = line.barTarget or "primary"
		local barTargets = TRB.Functions.Threshold:GetCustomThresholdBarTargets(currentSpec, classId, specId)
		local targetLabel = nil
		local currentIsPercent = false
		currentValueDecimals = 0
		for _, target in ipairs(barTargets) do
			if target.key == currentBarTarget then
				targetLabel = target.label
				currentValueDecimals = target.decimals or 0
				currentIsPercent = target.isPercent == true
				break
			end
		end
		if targetLabel == nil then
			-- Stored target no longer exists for this spec; fall back to the first available one.
			if barTargets[1] ~= nil then
				currentBarTarget = barTargets[1].key
				line.barTarget = currentBarTarget
				targetLabel = barTargets[1].label
				currentValueDecimals = barTargets[1].decimals or 0
				currentIsPercent = barTargets[1].isPercent == true
			else
				targetLabel = TRB.Functions.Bar:GetBarDisplayName(currentBarTarget)
			end
		end

		local minValue, maxValue = GetBarTargetRange(currentSpec, currentBarTarget, classId, specId)

		currentValueIsPercent = currentIsPercent
		-- Percent targets (Mana/Stagger/Health) are absolute-only: fold any stored offset back to absolute.
		if currentIsPercent and (line.valueMode or "absolute") == "offset" then
			line.value = maxValue + (line.value or 0)
			line.valueMode = "absolute"
		end
		local valueMode = line.valueMode or "absolute"

		local valueStep = currentValueDecimals > 0 and (1 / (10 ^ currentValueDecimals)) or 1
		valueSlider:SetValueStep(valueStep)
		valueSlider:SetObeyStepOnDrag(true)

		-- Offset mode: stored value is a negative offset from max, so the slider runs [min - max, 0].
		local sliderMin, sliderMax = minValue, maxValue
		if valueMode == "offset" then
			sliderMin, sliderMax = minValue - maxValue, 0
			valueSlider.Title:SetText(L["CustomThresholdOffsetTitle"])
		else
			valueSlider.Title:SetText(L["CustomThresholdValue"])
		end

		local clampedValue = TRB.Functions.Number:RoundTo(math.max(sliderMin, math.min(line.value or sliderMin, sliderMax)), currentValueDecimals)
		if line.value ~= clampedValue then
			line.value = clampedValue
		end
		valueSlider:SetMinMaxValues(sliderMin, sliderMax)
		local labelSuffix = currentIsPercent and "%" or ""
		valueSlider.MaxLabel:SetText(sliderMax .. labelSuffix)
		valueSlider.MinLabel:SetText(sliderMin .. labelSuffix)
		valueSlider:SetValue(clampedValue)
		valueSlider.EditBox:SetText(clampedValue)

		local valueModeLabels = { absolute = L["CustomThresholdValueModeAbsolute"], offset = L["CustomThresholdValueModeOffset"] }
		valueModeDropdown:SetDefaultText(valueModeLabels[valueMode])
		valueModeDropdown:SetupMenu(function(dd, rootDescription)
			for _, mode in ipairs({ "absolute", "offset" }) do
				rootDescription:CreateRadio(valueModeLabels[mode], function(value) return value == (line.valueMode or "absolute") end, function(value)
					if value == (line.valueMode or "absolute") then
						return
					end
					-- Convert to keep the line in the same position across the mode switch.
					local rMin, rMax = GetBarTargetRange(GetCurrentSpec() or spec, line.barTarget or "primary", classId, specId)
					local rDecimals = GetBarTargetDecimals(GetCurrentSpec() or spec, line.barTarget or "primary", classId, specId)
					if value == "offset" then
						line.value = TRB.Functions.Number:RoundTo(math.max(rMin - rMax, math.min((line.value or rMax) - rMax, 0)), rDecimals)
					else
						line.value = TRB.Functions.Number:RoundTo(math.max(rMin, math.min(rMax + (line.value or 0), rMax)), rDecimals)
					end
					line.valueMode = value
					RefreshEditor(selectedGuid)
					SetTableValues()
					RefreshRuntime()
				end, mode)
			end
		end)

		barTargetDropdown:SetDefaultText(targetLabel)
		barTargetDropdown:SetupMenu(function(dd, rootDescription)
			for _, target in ipairs(TRB.Functions.Threshold:GetCustomThresholdBarTargets(GetCurrentSpec() or spec, classId, specId)) do
				rootDescription:CreateRadio(target.label, function(value) return value == (line.barTarget or "primary") end, function(value)
					line.barTarget = value
					local newMin, newMax = GetBarTargetRange(GetCurrentSpec() or spec, value, classId, specId)
					local newDecimals = GetBarTargetDecimals(GetCurrentSpec() or spec, value, classId, specId)
					-- Percent targets are absolute-only: fold an offset back to absolute first.
					if target.isPercent == true and (line.valueMode or "absolute") == "offset" then
						line.value = newMax + (line.value or 0)
						line.valueMode = "absolute"
					end
					if (line.valueMode or "absolute") == "offset" then
						-- Offset keeps its meaning across bars (distance below max); clamp into the new range.
						line.value = TRB.Functions.Number:RoundTo(math.max(newMin - newMax, math.min(line.value or 0, 0)), newDecimals)
					else
						line.value = TRB.Functions.Number:RoundTo(math.max(newMin, math.min(line.value or newMin, newMax)), newDecimals)
					end
					RefreshEditor(selectedGuid)
					SetTableValues()
					RefreshRuntime()
				end, target.key)
			end
		end)

		local iconTypeLabels = {
			spell = L["CustomThresholdIconSourceSpell"],
			item = L["CustomThresholdIconSourceItem"],
			icon = L["CustomThresholdIconSourceIcon"],
			none = L["CustomThresholdIconSourceNone"],
		}
		iconTypeDropdown:SetDefaultText(iconTypeLabels[line.iconSourceType or "none"])
		iconTypeDropdown:SetupMenu(function(dd, rootDescription)
			for _, sourceType in ipairs({ "spell", "item", "icon", "none" }) do
				rootDescription:CreateRadio(iconTypeLabels[sourceType], function(value) return value == (line.iconSourceType or "none") end, function(value)
					line.iconSourceType = value
					line.iconTexture = nil
					-- "No Icon" writes the per-threshold show flag the "Show ability icon?"
					-- checkbox uses, so the shared runtime icon path hides the icon; Spell/Item
					-- restore it. The selection itself is still stored in iconSourceType so the
					-- spell/item code paths keep working unchanged.
					local _, _, _, dictIcon = GetSelectedDictEntrySections()
					if dictIcon ~= nil then
						dictIcon.show = value ~= "none"
					end
					RefreshEditor(selectedGuid)
					SetTableValues()
					RefreshRuntime()
				end, sourceType)
			end
		end)
		iconIdBox:SetText(tostring(line.iconSourceId or 0))
		UpdateIconPreview(line)

		-- Secret cast-count bars (Bone Shield, Fire Blast charges) have no under->over trigger, so
		-- their custom thresholds are forced to the static color mode: lock the value to "static" and
		-- disable the dropdown so the line shows a single fixed color.
		local staticColorOnly = line ~= nil and IsTargetStaticColorOnly(line.barTarget)
		if staticColorOnly then
			dictColors.colorMode = "static"
		end
		local colorMode = dictColors.colorMode or "dynamic"
		local colorModeLabels = { static = L["ThresholdDetailColorModeStatic"], dynamic = L["ThresholdDetailColorModeDynamic"] }
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorTypeDropdown({
			dropdown = colorModeDropdown,
			colorState = dictColors,
			colorModeLabels = colorModeLabels,
			colorModePrefix = L["ThresholdDetailColorModePrefix"],
			tooltip = L["ThresholdDetailColorModeTooltip"],
			onLayoutChanged = function()
				ReflowColorSectionOnly()
			end,
			onChanged = function(newValue)
				if newValue == "static" then
					staticColorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(dictColors.staticColor.color or underColor, true))
				end
				RefreshRuntime()
			end,
		})
		colorModeDropdown:SetEnabled(not staticColorOnly)

		if colorMode == "static" then
			staticColorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(dictColors.staticColor.color or underColor, true))
		end
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown({
			dropdown = underModeDropdown,
			colorPicker = underColorPicker,
			colorEntry = dictColors.under,
			fallbackColor = underColor,
			modeLabels = { shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnder"] },
			prefix = L["ThresholdDetailColorsPrefixUnder"],
			onLayoutChanged = function()
				ReflowColorSectionOnly()
			end,
			onChanged = function()
				RefreshRuntime()
			end,
		})
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown({
			dropdown = overModeDropdown,
			colorPicker = overColorPicker,
			colorEntry = dictColors.over,
			fallbackColor = overColor,
			modeLabels = { shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOver"] },
			prefix = L["ThresholdDetailColorsPrefixOver"],
			onLayoutChanged = function()
				ReflowColorSectionOnly()
			end,
			onChanged = function()
				RefreshRuntime()
			end,
		})
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
			colorPicker = staticColorPicker,
			colorEntry = dictColors.staticColor,
			fallbackColor = underColor,
			onChanged = function()
				RefreshRuntime()
			end,
		})
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
			colorPicker = underColorPicker,
			colorEntry = dictColors.under,
			fallbackColor = underColor,
			onChanged = function()
				RefreshRuntime()
			end,
		})
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
			colorPicker = overColorPicker,
			colorEntry = dictColors.over,
			fallbackColor = overColor,
			onChanged = function()
				RefreshRuntime()
			end,
		})

		lineUseSpecificCheckbox:SetChecked(dictLine.enabled == true)
		lineOverlapBorderCheckbox:SetChecked(dictLine.overlapBorder ~= false)
		lineWidthSlider:SetValue(dictLine.width or (currentThresholdSettings.properties and currentThresholdSettings.properties.width) or 2)
		lineWidthSlider.EditBox:SetText(dictLine.width or (currentThresholdSettings.properties and currentThresholdSettings.properties.width) or 2)

		iconUseSpecificCheckbox:SetChecked(dictIcon.enabled == true)
		iconShowCheckbox:SetChecked(dictIcon.show ~= false)
		iconDesaturateCheckbox:SetChecked(dictIcon.desaturated == true)
		iconWidthSlider:SetValue(dictIcon.width or (currentThresholdSettings.icons and currentThresholdSettings.icons.width))
		iconHeightSlider:SetValue(dictIcon.height or (currentThresholdSettings.icons and currentThresholdSettings.icons.height))
		iconBorderSlider:SetValue(dictIcon.border or (currentThresholdSettings.icons and currentThresholdSettings.icons.border))
		iconXSlider:SetValue(dictIcon.xPos or (currentThresholdSettings.icons and currentThresholdSettings.icons.xPos))
		iconYSlider:SetValue(dictIcon.yPos or (currentThresholdSettings.icons and currentThresholdSettings.icons.yPos))
		iconRelativeToDropdown:SetDefaultText((dictIcon.relativeTo == "CENTER" and L["AnchorPointCENTER"]) or (dictIcon.relativeTo == "BOTTOM" and L["AnchorPointBOTTOM"]) or L["AnchorPointTOP"])
		iconRelativeToDropdown:SetupMenu(function(dd, rootDescription)
			local options = {
				{ key = "TOP", label = L["AnchorPointTOP"] },
				{ key = "CENTER", label = L["AnchorPointCENTER"] },
				{ key = "BOTTOM", label = L["AnchorPointBOTTOM"] },
			}
			for _, option in ipairs(options) do
				rootDescription:CreateRadio(option.label, function(value) return value == (dictIcon.relativeTo or (currentThresholdSettings.icons and currentThresholdSettings.icons.relativeTo) or "TOP") end, function(value)
					dictIcon.relativeTo = value
					RefreshEditor(selectedGuid)
					RefreshRuntime()
				end, option.key)
			end
		end)

		local isThresholdEnabled = dictEntry.enabled == true
		RepositionEditorControls(isThresholdEnabled, colorMode, dictColors, dictLine, dictIcon)

		isRefreshing = false
	end

	local function SaveIconId()
		if isRefreshing then return end
		local line = GetSelectedLine()
		if line == nil then return end
		line.iconSourceId = tonumber(iconIdBox:GetText()) or 0
		line.iconTexture = nil
		UpdateIconPreview(line)
		SetTableValues()
		RefreshRuntime()
	end

	nameBox:SetScript("OnTextChanged", function(self)
		if isRefreshing then return end
		local line = GetSelectedLine()
		if line == nil then return end
		line.name = self:GetText()
		SetTableValues()
	end)
	nameBox:SetScript("OnEditFocusLost", function() RefreshRuntime() end)

	enabledCheckbox:SetScript("OnClick", function(self)
		local dictEntry = GetSelectedDictEntry()
		if dictEntry == nil then return end
		dictEntry.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, dictEntry.enabled == true, true)
		SetTableValues()
		RefreshEditor(selectedGuid)
		RefreshRuntime()
	end)

	valueSlider:SetScript("OnValueChanged", function(self, value)
		if isRefreshing then return end
		local line = GetSelectedLine()
		if line == nil then return end
		-- Round before clamping so the edit box display matches the allowed precision.
		value = TRB.Functions.Number:RoundTo(value, currentValueDecimals, nil, true)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		line.value = TRB.Functions.Number:RoundTo(value, currentValueDecimals)
		SetTableValues()
		RefreshRuntime()
	end)

	iconIdBox:SetScript("OnEnterPressed", function(self) SaveIconId(); self:ClearFocus() end)
	iconIdBox:SetScript("OnEditFocusLost", SaveIconId)

	-- Color pickers are wired in RefreshEditor via shared ThresholdList binding helpers.

	lineUseSpecificCheckbox:SetScript("OnClick", function(self)
		local _, _, dictLine = GetSelectedDictEntrySections()
		if dictLine == nil then return end
		dictLine.enabled = self:GetChecked()
		RefreshEditor(selectedGuid)
		RefreshRuntime()
	end)
	lineOverlapBorderCheckbox:SetScript("OnClick", function(self)
		local _, _, dictLine = GetSelectedDictEntrySections()
		if dictLine == nil then return end
		dictLine.overlapBorder = self:GetChecked()
		RefreshRuntime()
	end)
	lineWidthSlider:SetScript("OnValueChanged", function(self, value)
		if isRefreshing then return end
		local _, _, dictLine = GetSelectedDictEntrySections()
		if dictLine == nil then return end
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		dictLine.width = TRB.Functions.Number:RoundTo(value, 0)
		RefreshRuntime()
	end)

	iconUseSpecificCheckbox:SetScript("OnClick", function(self)
		local _, _, _, dictIcon = GetSelectedDictEntrySections()
		if dictIcon == nil then return end
		dictIcon.enabled = self:GetChecked()
		RefreshEditor(selectedGuid)
		RefreshRuntime()
	end)
	iconShowCheckbox:SetScript("OnClick", function(self)
		local _, _, _, dictIcon = GetSelectedDictEntrySections()
		if dictIcon == nil then return end
		dictIcon.show = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictIcon.show ~= false)
		RefreshRuntime()
	end)
	iconDesaturateCheckbox:SetScript("OnClick", function(self)
		local _, _, _, dictIcon = GetSelectedDictEntrySections()
		if dictIcon == nil then return end
		dictIcon.desaturated = self:GetChecked()
		RefreshRuntime()
	end)

	local function WireIconSlider(slider, fieldName, decimals)
		slider:SetScript("OnValueChanged", function(self, value)
			if isRefreshing then return end
			local _, _, _, dictIcon = GetSelectedDictEntrySections()
			if dictIcon == nil then return end
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			-- returnAsNumber=true so icon override fields (border, width, height, xPos, yPos) are
			-- stored as numbers; RoundTo defaults to returning a string, which breaks numeric
			-- comparisons downstream (e.g. SetThresholdIcon's `effectiveBorder < 1`).
			dictIcon[fieldName] = TRB.Functions.Number:RoundTo(value, decimals or 0, nil, true)
			RefreshRuntime()
		end)
	end
	WireIconSlider(iconWidthSlider, "width")
	WireIconSlider(iconHeightSlider, "height")
	WireIconSlider(iconBorderSlider, "border")
	WireIconSlider(iconXSlider, "xPos")
	WireIconSlider(iconYSlider, "yPos")

	local function CopyMenu(owner, guid)
		local currentSpec = GetCurrentSpec()
		if currentSpec == nil then return end
		local sourceLine = currentSpec.thresholds.customThresholds[guid]
		local sourceDictEntry = currentSpec.thresholds.thresholdDictionary[TRB.Functions.Settings:GetCustomThresholdDictionaryKey(guid)]
		if sourceLine == nil then
			return
		end

		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			rootDescription:CreateTitle(string.format(L["CustomThresholdCopyMenuTitleFormat"], sourceLine.name or L["CustomThresholdDefaultName"]))
			rootDescription:CreateButton(L["CustomThresholdCopyMenuDuplicate"], function()
				local copiedLine = CopyCustomThresholdToSpec(sourceLine, sourceDictEntry, lowerClassName, specName)
				if copiedLine ~= nil then
					SetTableValues()
					RefreshEditor(copiedLine.guid)
				end
			end)

			---@diagnostic disable-next-line: redundant-parameter, missing-parameter
			local copyTo = rootDescription:CreateButton(L["CopyMenuCopyTo"])
			if type(copyTo) == "table" and type(copyTo.CreateButton) == "function" then
				copyTo:CreateTitle(L["CopyMenuCopyTo"])
				copyTo:CreateDivider()
				local sortedClasses = {}
				for i, classDef in ipairs(TRB.Data.allClassSpecs or {}) do
					sortedClasses[i] = classDef
				end
				table.sort(sortedClasses, function(a, b) return a.classLabel < b.classLabel end)
				for _, classDef in ipairs(sortedClasses) do
					---@diagnostic disable-next-line: redundant-parameter, missing-parameter
					local classMenu = copyTo:CreateButton(classDef.classLabel)
					if type(classMenu) == "table" and type(classMenu.CreateButton) == "function" then
						local prefix = classDef.classKey .. "_"
						for _, specDef in ipairs(classDef.specs) do
							local targetSpecName = string.sub(specDef.compositeKey, #prefix + 1)
							classMenu:CreateButton(specDef.specLabel, function()
								local copiedLine = CopyCustomThresholdToSpec(sourceLine, sourceDictEntry, classDef.classKey, targetSpecName)
								if classDef.classKey == lowerClassName and targetSpecName == specName and copiedLine ~= nil then
									SetTableValues()
									RefreshEditor(copiedLine.guid)
								end
							end)
						end
					end
				end
			end
		end)
	end

	addButton:SetScript("OnClick", function()
		local currentSpec = GetCurrentSpec()
		if currentSpec == nil then return end
		local guid = TRB.Functions.String:Guid()
		local minValue = GetBarTargetRange(currentSpec, "primary")
		local newLine = TRB.Functions.Settings:NormalizeCustomThresholdLine({
			guid = guid,
			name = L["CustomThresholdDefaultName"],
			barTarget = "primary",
			value = minValue,
			iconSourceType = "none",
			iconSourceId = 0,
		}, guid)
		currentSpec.thresholds.customThresholds[guid] = newLine
		EnsureThresholdDictionaryEntry(guid, currentSpec)
		SetTableValues()
		RefreshEditor(guid)
		RefreshRuntime()
	end)

	customThresholdTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnEnter(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow ~= nil and realrow > 0 then
				if column == 7 then
					SetActionCellHoverState(cellFrame, true)
					ShowActionCellTooltip(cellFrame, L["CustomThresholdCopyActionTooltip"])
				elseif column == 8 then
					SetActionCellHoverState(cellFrame, true)
					ShowActionCellTooltip(cellFrame, L["CustomThresholdDeleteActionTooltip"])
				end
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnLeave(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if column == 7 or column == 8 then
				SetActionCellHoverState(cellFrame, false)
				GameTooltip:Hide()
			end
		end,
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button)
			if button ~= "LeftButton" or realrow == nil or realrow <= 0 then
				return
			end
			local guid = data[realrow].cols[1].value
			if column == 7 then
				CopyMenu(cellFrame or rowFrame, guid)
			elseif column == 8 then
				local currentSpec = GetCurrentSpec()
				local line = currentSpec and currentSpec.thresholds.customThresholds[guid]
				StaticPopup_Show("TwintopResourceBar_ConfirmDeleteCustomThreshold", string.format(L["CustomThresholdDeleteConfirmation"], line and line.name or L["CustomThresholdDefaultName"]), nil, {
					spec = currentSpec,
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

	SetTableValues()

	return yCoord - 820
end

---@param className string
---@param specName string
---@param controls table
---@return table
function TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition(className, specName, controls)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
	local specRegistryEntry = TRB.Functions.Character:GetSpecRegistryEntry(compositeKey)
	return {
		key = "customThresholds",
		label = L["TabCustomThresholds"],
		width = oUi.tabWidth.large,
		isManualScrollFrame = true,
		constructor = function(scrollChild)
			local spec = TRB.Data.settings[className] and TRB.Data.settings[className][specName]
			if spec ~= nil and specRegistryEntry ~= nil then
				TRB.Functions.OptionsUi.CustomThresholds:GenerateCustomThresholdsPanel(scrollChild, controls, spec, specRegistryEntry.classId, specRegistryEntry.specId, 5)
			end
		end,
	}
end
