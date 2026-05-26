---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Thresholds = TRB.Functions.OptionsUi.Thresholds or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/225
end

-- ============================================================================
-- Threshold option panels
-- ============================================================================

---Generates a threshold list panel with a scrolling table showing all thresholds and a detail panel below for enabling/disabling them.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing threshold configuration
---@param classId integer The class ID
---@param specId integer The spec ID
---@param yCoord number The current Y coordinate for layout positioning
---@param thresholdConfig table Configuration for threshold list display
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Thresholds:GenerateThresholdListPanel(parent, controls, spec, classId, specId, yCoord, thresholdConfig)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	-- Category display names
	local categoryLabels = {
		offensive = L["ThresholdCategoryOffensive"],
		defensive = L["ThresholdCategoryDefensive"],
		utility = L["ThresholdCategoryUtility"],
		execute = L["ThresholdCategoryExecute"],
		custom = L["ThresholdCategoryCustom"],
		-- Spec specific categories (e.g., Druid shapeshift forms)
		metamorphosis = L["ThresholdCategoryMetamorphosis"],
	}

	-- Bar target display names (caller provides friendly resource names)
	local barTargetLabels = thresholdConfig.barTargetLabels or {
		primary = L["ThresholdBarTargetPrimary"],
		secondary = L["ThresholdBarTargetSecondary"],
	}

	-- Build the threshold entry list from the spec's cached spell data (not the runtime threshold cache,
	-- which only holds spells for the currently active spec and filters by talents).
	local thresholdEntries = {}
	local compositeKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	local specCacheEntry = compositeKey and TRB.Data.specCache[compositeKey] or nil
	local specSpells = specCacheEntry and specCacheEntry.spellsData and specCacheEntry.spellsData.spells or nil
	local configLabels = thresholdConfig.labels
	if specSpells ~= nil then
		for _, v in pairs(specSpells) do
			if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v:IsValid() then
				local spell = v --[[@as TRB.Classes.SpellThreshold]]
				local settingKey = spell.settingKey
				if settingKey ~= nil and spec.thresholds.thresholdDictionary[settingKey] ~= nil then
					-- Check for linked thresholds (e.g., cleave/whirlwind in Arms)
					local linkedKeys = nil
					if thresholdConfig.linkedThresholds and thresholdConfig.linkedThresholds[settingKey] then
						linkedKeys = thresholdConfig.linkedThresholds[settingKey]
					end

					-- Use config label if provided, otherwise fall back to spell name
					local displayName = (configLabels and configLabels[settingKey]) or spell.name or settingKey

					table.insert(thresholdEntries, {
						settingKey = settingKey,
						name = displayName,
						icon = spell.icon or "",
						category = spell.category or "offensive",
						barTarget = spell.barTarget or "primary",
						tooltip = thresholdConfig.tooltips and thresholdConfig.tooltips[settingKey] or nil,
						linkedKeys = linkedKeys,
					})
				end
			end
		end
	end

	-- Also add custom thresholds if configured
	if spec.thresholds.customThresholds then
		for key, custom in pairs(spec.thresholds.customThresholds) do
			table.insert(thresholdEntries, {
				settingKey = key,
				name = custom.name or key,
				icon = "",
				category = "custom",
				barTarget = custom.barTarget or "primary",
				tooltip = custom.tooltip or nil,
				linkedKeys = nil,
			})
		end
	end

	-- Table columns
	local columns = {
		{
			["name"] = "Key",
			["width"] = 1,
			["align"] = "CENTER",
		},
		{
			["name"] = "",
			["width"] = 22,
			["align"] = "CENTER",
			["defaultsort"] = 1,
			["comparesort"] = function(st, rowa, rowb, sortbycol)
				-- Sort by name (column 3) value, using the icon column's sort direction
				local cella = st:GetCell(rowa, 3)
				local cellb = st:GetCell(rowb, 3)
				local a1 = type(cella) == "table" and cella.value or cella
				local b1 = type(cellb) == "table" and cellb.value or cellb
				if a1 == b1 then return false end
				local column = st.cols[sortbycol]
				local direction = column.sort or column.defaultsort or 2
				if direction == 1 then return a1 < b1 else return a1 > b1 end
			end,
		},
		{
			["name"] = L["ThresholdTableHeaderName"],
			["width"] = 100,
			["align"] = "LEFT",
			["sort"] = 1,
			["defaultsort"] = 1,
		},
		{
			["name"] = L["ThresholdTableHeaderCategory"],
			["width"] = 115,
			["align"] = "LEFT",
		},
		{
			["name"] = L["ThresholdTableHeaderBar"],
			["width"] = 115,
			["align"] = "LEFT",
		},
		{
			["name"] = "",
			["width"] = 16,
			["align"] = "CENTER",
			["sortnext"] = 3,
		},
		{
			["name"] = L["ThresholdTableHeaderEnabled"],
			["width"] = 60,
			["align"] = "LEFT",
		},
	}

	yCoord = yCoord - 3
	controls.thresholdOverridesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdOverridesHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 20

	-- Create table container
	controls.thresholdListContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local tlc = controls.thresholdListContainer
	tlc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord - 10)
	tlc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	local tableRowCount = math.max(#thresholdEntries, 4)
	tableRowCount = math.min(tableRowCount, 6)
	tlc:SetHeight(35 + (tableRowCount * 15))

	local thresholdTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, tableRowCount, 15, nil, tlc, false, false)

	-- Dynamically resize the Name column to fill available width
	tlc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[4].width + columns[5].width + columns[6].width + columns[7].width
		local newNameWidth = math.max(100, w - fixedWidth - 30)
		columns[3].width = newNameWidth
		thresholdTable:SetDisplayCols(columns)
	end)

	local selectedSettingKey = nil
	local detailHasUnusable = false
	local detailHasOutOfRange = false
	local detailCanHaveAudio = true
	local detailHasThresholdIcon = true

	---Refreshes the scrolling table data from the current threshold settings.
	local function SetTableValues()
		local dataTable = {}
		for _, entry in ipairs(thresholdEntries) do
			local dictEntry = spec.thresholds.thresholdDictionary[entry.settingKey]
			local isEnabled = dictEntry and dictEntry.enabled or false

			-- For linked thresholds, check if any linked key is enabled
			if entry.linkedKeys then
				for _, lk in ipairs(entry.linkedKeys) do
					local lkEntry = spec.thresholds.thresholdDictionary[lk]
					if lkEntry and lkEntry.enabled then
						isEnabled = true
						break
					end
				end
			end

			local categoryLabel = categoryLabels[entry.category]
			local barTargetLabel = barTargetLabels[entry.barTarget]

			local enabledText = isEnabled and "|cFF00FF00Yes|r" or "|cFFFF0000No|r"

			local hasAudio = dictEntry and dictEntry.audio and dictEntry.audio.enabled and dictEntry.audio.sound and dictEntry.audio.sound ~= ""
			local audioIcon = hasAudio and "|TInterface\\Common\\VoiceChat-Speaker:12|t" or ""

			local rowData = {
				cols = {
					{ value = entry.settingKey },
					{ value = entry.icon },
					{ value = entry.name },
					{ value = categoryLabel },
					{ value = barTargetLabel },
					{ value = audioIcon },
					{ value = enabledText },
				}
			}
			table.insert(dataTable, rowData)
		end
		thresholdTable:SetData(dataTable)
		thresholdTable:EnableSelection(true)
	end

	-- Detail header below the table (outside the scrolling detail panel)
	local detailHeader = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "", oUi.xCoord, 0)
	detailHeader:SetPoint("TOPLEFT", tlc, "BOTTOMLEFT", oUi.xCoord, 0)
	detailHeader:Hide()

	-- Detail panel below the header, filling remaining space
	controls.thresholdListDetail = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_ThresholdListDetail", parent, "BackdropTemplate")
	local detailFrame = controls.thresholdListDetail
	detailFrame:SetPoint("TOPLEFT", detailHeader, "BOTTOMLEFT", -oUi.xCoord, 0)
	detailFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -oUi.xCoord, 3)
	detailFrame:Hide()

	-- Scroll frame inside the detail panel for overflow
	local detailScrollFrame = CreateFrame("ScrollFrame", "TwintopResourceBar_" .. namePrefix .. "_ThresholdDetailScroll", detailFrame, "UIPanelScrollFrameTemplate")
	detailScrollFrame:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 0, 0)
	detailScrollFrame:SetPoint("BOTTOMRIGHT", detailFrame, "BOTTOMRIGHT", -20, 0)
	local detailScrollChild = CreateFrame("Frame", nil, detailScrollFrame)
	detailScrollChild:SetSize(detailScrollFrame:GetWidth() or 600, 1)
	detailScrollFrame:SetScrollChild(detailScrollChild)

	-- Hook to keep scroll child width synchronized with the scroll frame
	detailScrollFrame:HookScript("OnSizeChanged", function(self, w, h)
		detailScrollChild:SetWidth(w)
	end)

	local detailYCoord = 0

	-- Detail panel contents: enabled checkbox
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes.thresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdEnabled", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local enabledCheckbox = controls.checkBoxes.thresholdEnabled
	enabledCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(enabledCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailEnabledCheckbox"])
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(enabledCheckbox, false, false)
	enabledCheckbox:Hide()

	-- ===== COLOR OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 30
	local colorsHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailColorsHeader"], oUi.xCoord, detailYCoord)
	colorsHeader.font:SetFontObject(GameFontNormalLarge)
	colorsHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	-- Helper to get effective mode from a color entry (backward compat with old boolean enabled field)
	local function GetColorMode(colorEntry)
		if colorEntry == nil then return "shared" end
		if colorEntry.mode ~= nil then return colorEntry.mode end
		if colorEntry.enabled then return "override" end
		return "shared"
	end

	-- Helper for OOR backward compat: old data used show/enabled booleans instead of mode
	local function GetOorColorMode(colorEntry)
		if colorEntry == nil then return "shared" end
		if colorEntry.mode ~= nil then return colorEntry.mode end
		-- Legacy: show=false means hidden, show=true+enabled=true means override, else shared
		if colorEntry.show == false then return "hidden" end
		if colorEntry.enabled then return "override" end
		return "shared"
	end

	controls.dropDown = controls.dropDown or {}

	-- Color Mode: Static / Dynamic dropdown
	controls.dropDown.thresholdColorMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorModeDropdown = controls.dropDown.thresholdColorMode
	colorModeDropdown:SetWidth(oUi.sliderWidth)
	colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorModeDropdown:Hide()

	controls.colors.thresholdStatic = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorModeStaticColor"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdStatic:Hide()

	-- Under color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorUnderMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorUnderMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorUnderModeDropdown = controls.dropDown.thresholdColorUnderMode
	colorUnderModeDropdown:SetWidth(oUi.sliderWidth)
	colorUnderModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorUnderModeDropdown:Hide()

	controls.colors.thresholdUnder = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsUnder"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdUnder:Hide()

	-- Over color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorOverMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorOverMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorOverModeDropdown = controls.dropDown.thresholdColorOverMode
	colorOverModeDropdown:SetWidth(oUi.sliderWidth)
	colorOverModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorOverModeDropdown:Hide()

	controls.colors.thresholdOver = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsOver"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdOver:Hide()

	-- Unusable color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorUnusableMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorUnusableMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorUnusableModeDropdown = controls.dropDown.thresholdColorUnusableMode
	colorUnusableModeDropdown:SetWidth(oUi.sliderWidth)
	colorUnusableModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorUnusableModeDropdown:Hide()

	controls.colors.thresholdUnusable = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsUnusable"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdUnusable:Hide()

	-- Out of Range: mode dropdown + override color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorOorMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorOorMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorOorModeDropdown = controls.dropDown.thresholdColorOorMode
	colorOorModeDropdown:SetWidth(oUi.sliderWidth)
	colorOorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorOorModeDropdown:Hide()

	controls.colors.thresholdOutOfRange = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsOutOfRange"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdOutOfRange:Hide()

	-- ===== LINE OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 40
	local lineHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailLineHeader"], oUi.xCoord, detailYCoord)
	lineHeader.font:SetFontObject(GameFontNormalLarge)
	lineHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.checkBoxes.thresholdLineUseSpecific = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdLineUseSpecific", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local lineUseSpecificCheckbox = controls.checkBoxes.thresholdLineUseSpecific
	lineUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, detailYCoord)
	getglobal(lineUseSpecificCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailLineUseSpecific"])
	lineUseSpecificCheckbox.tooltip = L["ThresholdDetailLineUseSpecificTooltip"]
	lineUseSpecificCheckbox:Hide()

	detailYCoord = detailYCoord - 40
	controls.sliders = controls.sliders or {}
	controls.sliders.thresholdLineWidth = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailLineWidth"], 1, 10, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdLineWidth:Hide()

	controls.checkBoxes.thresholdLineOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdLineOverlapBorder", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local lineOverlapBorderCheckbox = controls.checkBoxes.thresholdLineOverlapBorder
	lineOverlapBorderCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(lineOverlapBorderCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailLineOverlapBorder"])
	lineOverlapBorderCheckbox.tooltip = L["ThresholdDetailLineOverlapBorderTooltip"]
	lineOverlapBorderCheckbox:Hide()

	-- ===== ICON OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 50
	local iconHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailIconHeader"], oUi.xCoord, detailYCoord)
	iconHeader.font:SetFontObject(GameFontNormalLarge)
	iconHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.dropDown = controls.dropDown or {}
	controls.checkBoxes.thresholdIconUseSpecific = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconUseSpecific", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local iconUseSpecificCheckbox = controls.checkBoxes.thresholdIconUseSpecific
	iconUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, detailYCoord)
	getglobal(iconUseSpecificCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailIconUseSpecific"])
	iconUseSpecificCheckbox.tooltip = L["ThresholdDetailIconUseSpecificTooltip"]
	iconUseSpecificCheckbox:Hide()

	detailYCoord = detailYCoord - 20
	controls.dropDown.thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconRelativeTo", detailScrollChild, "WowStyle1DropdownTemplate")
	local iconRelativeToDropdown = controls.dropDown.thresholdIconRelativeTo
	iconRelativeToDropdown:SetWidth(oUi.sliderWidth)
	iconRelativeToDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailIconRelativePosition"], oUi.xCoord, detailYCoord)
	iconRelativeToDropdown.label.font:SetFontObject(GameFontNormal)
	iconRelativeToDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 30)
	iconRelativeToDropdown:Hide()

	controls.checkBoxes.thresholdIconShow = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconShow", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local iconShowCheckbox = controls.checkBoxes.thresholdIconShow
	iconShowCheckbox:SetPoint("TOPLEFT", oUi.xCoord2, detailYCoord - 30)
	getglobal(iconShowCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailIconShowCheckbox"])
	iconShowCheckbox.tooltip = L["ThresholdDetailIconShowCheckboxTooltip"]
	iconShowCheckbox:Hide()

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconDesaturated", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local iconDesaturateCheckbox = controls.checkBoxes.thresholdIconDesaturated
	iconDesaturateCheckbox:SetPoint("TOPLEFT", oUi.xCoord2 + oUi.xPadding * 2, detailYCoord - 50)
	getglobal(iconDesaturateCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailIconDesaturate"])
	iconDesaturateCheckbox.tooltip = L["ThresholdDetailIconDesaturateTooltip"]
	iconDesaturateCheckbox:Hide()

	detailYCoord = detailYCoord - 100
	controls.sliders.thresholdIconWidth = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconWidth"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconWidth:Hide()

	controls.sliders.thresholdIconHeight = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconHeight"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.thresholdIconHeight:Hide()

	detailYCoord = detailYCoord - 60
	controls.sliders.thresholdIconXPos = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconXPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconXPos:Hide()

	controls.sliders.thresholdIconYPos = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconYPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.thresholdIconYPos:Hide()

	detailYCoord = detailYCoord - 60
	controls.sliders.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconBorderWidth"], 0, 12, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconBorderWidth:Hide()

	-- ===== AUDIO CUE SECTION =====
	detailYCoord = detailYCoord - 50
	local audioHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailAudioHeader"], oUi.xCoord, detailYCoord)
	audioHeader.font:SetFontObject(GameFontNormalLarge)
	audioHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.checkBoxes.thresholdAudioEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdAudioEnabled", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local audioCheckbox = controls.checkBoxes.thresholdAudioEnabled
	audioCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(audioCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailAudioCheckbox"])
	audioCheckbox.tooltip = L["ThresholdDetailAudioCheckboxTooltip"]
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(audioCheckbox, false, true)
	audioCheckbox:Hide()

	controls.dropDown.thresholdAudioSound = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdAudioSound", detailScrollChild, "WowStyle1DropdownTemplate")
	local audioDropdown = controls.dropDown.thresholdAudioSound
	audioDropdown:SetWidth(oUi.sliderWidth)
	audioDropdown:SetPoint("TOPLEFT", oUi.xPadding2, detailYCoord - 20)
	audioDropdown:Hide()

	---Dynamically repositions all detail panel controls based on which sections
	---are currently visible, eliminating empty gaps from hidden controls.
	local function RepositionDetailControls()
		local y = 0
		local isEnabled = enabledCheckbox:GetChecked()

		-- Enabled checkbox
		enabledCheckbox:ClearAllPoints()
		enabledCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
		y = y - 30

		-- Color override section (hidden when threshold disabled)
		local isStaticMode = false
		if isEnabled then
			colorsHeader:Show()
			colorModeDropdown:Show()
			-- Determine if we're in static or dynamic mode
			if selectedSettingKey then
				local dictEntry = spec.thresholds.thresholdDictionary[selectedSettingKey]
				if dictEntry and dictEntry.colors and dictEntry.colors.colorMode == "static" then
					isStaticMode = true
				end
			end
			if isStaticMode then
				controls.colors.thresholdStatic:Show()
				colorUnderModeDropdown:Hide()
				controls.colors.thresholdUnder:Hide()
				colorOverModeDropdown:Hide()
				controls.colors.thresholdOver:Hide()
				colorUnusableModeDropdown:Hide()
				controls.colors.thresholdUnusable:Hide()
				colorOorModeDropdown:Hide()
				controls.colors.thresholdOutOfRange:Hide()
			else
				controls.colors.thresholdStatic:Hide()
				colorUnderModeDropdown:Show()
				colorOverModeDropdown:Show()
				-- Restore color swatch visibility based on each color entry's current mode
				local dictEntry = selectedSettingKey and spec.thresholds.thresholdDictionary[selectedSettingKey]
				if dictEntry and dictEntry.colors then
					if GetColorMode(dictEntry.colors.under) == "override" then
						controls.colors.thresholdUnder:Show()
					else
						controls.colors.thresholdUnder:Hide()
					end
					if GetColorMode(dictEntry.colors.over) == "override" then
						controls.colors.thresholdOver:Show()
					else
						controls.colors.thresholdOver:Hide()
					end
				else
					controls.colors.thresholdUnder:Hide()
					controls.colors.thresholdOver:Hide()
				end
				-- Restore unusable/OOR dropdown+swatch visibility based on spell capabilities
				if detailHasUnusable then
					colorUnusableModeDropdown:Show()
					if dictEntry and dictEntry.colors and GetColorMode(dictEntry.colors.unusable) == "override" then
						controls.colors.thresholdUnusable:Show()
					else
						controls.colors.thresholdUnusable:Hide()
					end
				end
				if detailHasOutOfRange then
					colorOorModeDropdown:Show()
					if dictEntry and dictEntry.colors and GetOorColorMode(dictEntry.colors.outOfRange) == "override" then
						controls.colors.thresholdOutOfRange:Show()
					else
						controls.colors.thresholdOutOfRange:Hide()
					end
				end
			end
		else
			colorsHeader:Hide()
			colorModeDropdown:Hide()
			controls.colors.thresholdStatic:Hide()
			colorUnderModeDropdown:Hide()
			controls.colors.thresholdUnder:Hide()
			colorOverModeDropdown:Hide()
			controls.colors.thresholdOver:Hide()
			colorUnusableModeDropdown:Hide()
			controls.colors.thresholdUnusable:Hide()
			colorOorModeDropdown:Hide()
			controls.colors.thresholdOutOfRange:Hide()
		end

		if colorsHeader:IsShown() then
			colorsHeader:ClearAllPoints()
			colorsHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			-- Color Mode row (Static / Dynamic)
			colorModeDropdown:ClearAllPoints()
			colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
			if isStaticMode then
				controls.colors.thresholdStatic:ClearAllPoints()
				controls.colors.thresholdStatic:SetPoint("TOPLEFT", oUi.xCoord2, y)
			end
			y = y - 30

			if not isStaticMode then
				-- Under row
				colorUnderModeDropdown:ClearAllPoints()
				colorUnderModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
				controls.colors.thresholdUnder:ClearAllPoints()
				controls.colors.thresholdUnder:SetPoint("TOPLEFT", oUi.xCoord2, y)
				y = y - 30

				-- Over row
				colorOverModeDropdown:ClearAllPoints()
				colorOverModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
				controls.colors.thresholdOver:ClearAllPoints()
				controls.colors.thresholdOver:SetPoint("TOPLEFT", oUi.xCoord2, y)
				y = y - 30

				-- Unusable row (only for spells with cooldown)
				if colorUnusableModeDropdown:IsShown() then
					colorUnusableModeDropdown:ClearAllPoints()
					colorUnusableModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
					controls.colors.thresholdUnusable:ClearAllPoints()
					controls.colors.thresholdUnusable:SetPoint("TOPLEFT", oUi.xCoord2, y)
					y = y - 30
				end

				-- Out of Range row (only for spells with range check)
				if colorOorModeDropdown:IsShown() then
					colorOorModeDropdown:ClearAllPoints()
					colorOorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
					controls.colors.thresholdOutOfRange:ClearAllPoints()
					controls.colors.thresholdOutOfRange:SetPoint("TOPLEFT", oUi.xCoord2, y)
					y = y - 30
				end
			end
		end

		-- Line override section (hidden when threshold disabled)
		if isEnabled then
			lineHeader:Show()
			lineUseSpecificCheckbox:Show()
			-- Restore line sub-controls based on the "Use specific" checkbox
			if lineUseSpecificCheckbox:GetChecked() then
				controls.sliders.thresholdLineWidth:Show()
				lineOverlapBorderCheckbox:Show()
			else
				controls.sliders.thresholdLineWidth:Hide()
				lineOverlapBorderCheckbox:Hide()
			end
		else
			lineHeader:Hide()
			lineUseSpecificCheckbox:Hide()
			controls.sliders.thresholdLineWidth:Hide()
			lineOverlapBorderCheckbox:Hide()
		end

		if lineHeader:IsShown() then
			lineHeader:ClearAllPoints()
			lineHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			lineUseSpecificCheckbox:ClearAllPoints()
			lineUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			if controls.sliders.thresholdLineWidth:IsShown() then
				controls.sliders.thresholdLineWidth:ClearAllPoints()
				controls.sliders.thresholdLineWidth:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				y = y - 50

				lineOverlapBorderCheckbox:ClearAllPoints()
				lineOverlapBorderCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
				y = y - 30
			end
		end

		-- Icon override section (hidden when threshold disabled or has no icon)
		if isEnabled and detailHasThresholdIcon then
			iconHeader:Show()
			iconUseSpecificCheckbox:Show()
			-- Restore icon sub-controls based on the "Use specific" checkbox
			if iconUseSpecificCheckbox:GetChecked() then
				iconRelativeToDropdown.label:Show()
				iconRelativeToDropdown:Show()
				iconShowCheckbox:Show()
				iconDesaturateCheckbox:Show()
				controls.sliders.thresholdIconWidth:Show()
				controls.sliders.thresholdIconHeight:Show()
				controls.sliders.thresholdIconXPos:Show()
				controls.sliders.thresholdIconYPos:Show()
				controls.sliders.thresholdIconBorderWidth:Show()
			else
				iconRelativeToDropdown.label:Hide()
				iconRelativeToDropdown:Hide()
				iconShowCheckbox:Hide()
				iconDesaturateCheckbox:Hide()
				controls.sliders.thresholdIconWidth:Hide()
				controls.sliders.thresholdIconHeight:Hide()
				controls.sliders.thresholdIconXPos:Hide()
				controls.sliders.thresholdIconYPos:Hide()
				controls.sliders.thresholdIconBorderWidth:Hide()
			end
		else
			iconHeader:Hide()
			iconUseSpecificCheckbox:Hide()
			iconRelativeToDropdown.label:Hide()
			iconRelativeToDropdown:Hide()
			iconShowCheckbox:Hide()
			iconDesaturateCheckbox:Hide()
			controls.sliders.thresholdIconWidth:Hide()
			controls.sliders.thresholdIconHeight:Hide()
			controls.sliders.thresholdIconXPos:Hide()
			controls.sliders.thresholdIconYPos:Hide()
			controls.sliders.thresholdIconBorderWidth:Hide()
		end

		if iconHeader:IsShown() then
			iconHeader:ClearAllPoints()
			iconHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			iconUseSpecificCheckbox:ClearAllPoints()
			iconUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			if iconRelativeToDropdown:IsShown() then
				iconRelativeToDropdown.label:ClearAllPoints()
				iconRelativeToDropdown.label:SetPoint("TOPLEFT", oUi.xCoord, y)
				iconRelativeToDropdown:ClearAllPoints()
				iconRelativeToDropdown:SetPoint("TOPLEFT", oUi.xCoord, y - 30)

				iconShowCheckbox:ClearAllPoints()
				iconShowCheckbox:SetPoint("TOPLEFT", oUi.xCoord2, y - 30)

				iconDesaturateCheckbox:ClearAllPoints()
				iconDesaturateCheckbox:SetPoint("TOPLEFT", oUi.xCoord2 + oUi.xPadding * 2, y - 50)
				y = y - 100

				controls.sliders.thresholdIconWidth:ClearAllPoints()
				controls.sliders.thresholdIconWidth:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				controls.sliders.thresholdIconHeight:ClearAllPoints()
				controls.sliders.thresholdIconHeight:SetPoint("TOPLEFT", oUi.xCoord2 + 18, y)
				y = y - 60

				controls.sliders.thresholdIconXPos:ClearAllPoints()
				controls.sliders.thresholdIconXPos:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				controls.sliders.thresholdIconYPos:ClearAllPoints()
				controls.sliders.thresholdIconYPos:SetPoint("TOPLEFT", oUi.xCoord2 + 18, y)
				y = y - 60

				controls.sliders.thresholdIconBorderWidth:ClearAllPoints()
				controls.sliders.thresholdIconBorderWidth:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				y = y - 50
			end
		end

		-- Audio section (only visible when threshold supports audio cues)
		if detailCanHaveAudio then
			audioHeader:ClearAllPoints()
			audioHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			audioCheckbox:ClearAllPoints()
			audioCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			audioDropdown:ClearAllPoints()
			audioDropdown:SetPoint("TOPLEFT", oUi.xPadding2, y - 20)
			y = y - 60
		else
			audioHeader:Hide()
			audioCheckbox:Hide()
			audioDropdown:Hide()
		end

		detailScrollChild:SetHeight(math.abs(y) + 20)
	end

	---Populates the detail panel for the selected threshold.
	---@param settingKey string The settingKey of the threshold to show details for
	local function FillDetailPanel(settingKey)
		selectedSettingKey = settingKey
		local entry = nil
		for _, e in ipairs(thresholdEntries) do
			if e.settingKey == settingKey then
				entry = e
				break
			end
		end
		if entry == nil then
			detailHeader:Hide()
			detailFrame:Hide()
			return
		end

		-- Look up the spell object for capability detection
		local spellObj = nil
		if specSpells ~= nil then
			for _, v in pairs(specSpells) do
				if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v.settingKey == settingKey then
					spellObj = v --[[@as TRB.Classes.SpellThreshold]]
					break
				end
			end
		end

		local hasUnusable = spellObj ~= nil and spellObj.hasCooldown == true
		local hasOutOfRange = spellObj ~= nil and spellObj.rangeCheck ~= false
		detailHasUnusable = hasUnusable
		detailHasOutOfRange = hasOutOfRange
		detailCanHaveAudio = spellObj == nil or spellObj.canHaveAudioCue ~= false
		detailHasThresholdIcon = spellObj == nil or spellObj.hasThresholdIcon ~= false

		-- Update header
		detailHeader.font:SetText(string.format(L["ThresholdDetailHeader"], entry.icon .. " " .. entry.name))

		-- Get the dictionary entry
		local dictEntry = spec.thresholds.thresholdDictionary[settingKey]
		if dictEntry == nil then
			spec.thresholds.thresholdDictionary[settingKey] = { enabled = false }
			dictEntry = spec.thresholds.thresholdDictionary[settingKey]
		end

		-- Ensure sub-tables exist on demand with concrete defaults from global settings
		dictEntry.audio = dictEntry.audio or {}
		dictEntry.colors = dictEntry.colors or {}
		dictEntry.colors.under = dictEntry.colors.under or {}
		dictEntry.colors.over = dictEntry.colors.over or {}
		dictEntry.colors.unusable = dictEntry.colors.unusable or {}
		dictEntry.colors.outOfRange = dictEntry.colors.outOfRange or {}
		dictEntry.icon = dictEntry.icon or {
			enabled = false,
			show = true,
			desaturated = true,
			relativeTo = spec.thresholds.icons.relativeTo or "BOTTOM",
			width = spec.thresholds.icons.width or 32,
			height = spec.thresholds.icons.height or 32,
			xPos = spec.thresholds.icons.xPos or 0,
			yPos = spec.thresholds.icons.yPos or 0,
			border = spec.thresholds.icons.border or 2,
		}
		dictEntry.line = dictEntry.line or {
			enabled = false,
			width = spec.thresholds.properties.width or 2,
			overlapBorder = spec.thresholds.properties.overlapBorder,
		}

		local isEnabled = dictEntry.enabled or false

		-- For linked thresholds, check if any linked key is enabled
		if entry.linkedKeys then
			for _, lk in ipairs(entry.linkedKeys) do
				local lkEntry = spec.thresholds.thresholdDictionary[lk]
				if lkEntry and lkEntry.enabled then
					isEnabled = true
					break
				end
			end
		end

		-- ===== ENABLED CHECKBOX =====
		enabledCheckbox:SetChecked(isEnabled)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(enabledCheckbox, isEnabled, false)
		enabledCheckbox:SetScript("OnClick", function(self, ...)
			local checked = self:GetChecked()
			dictEntry.enabled = checked
			if entry.linkedKeys then
				for _, lk in ipairs(entry.linkedKeys) do
					if spec.thresholds.thresholdDictionary[lk] then
						spec.thresholds.thresholdDictionary[lk].enabled = checked
					end
				end
			end
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(enabledCheckbox, checked, false)
			RepositionDetailControls()
			SetTableValues()
			for i, e in ipairs(thresholdEntries) do
				if e.settingKey == settingKey then
					thresholdTable:SetSelection(i)
					break
				end
			end
		end)
		if entry.tooltip then
			enabledCheckbox.tooltip = entry.tooltip
		end
		enabledCheckbox:Show()

		-- ===== COLOR OVERRIDE SECTION =====
		-- Helper to set up a color mode dropdown for a given color type
		local function SetupColorModeDropdown(dropdown, colorPicker, colorEntry, fallbackColor, modeLabels, prefix, getModeFn)
			local resolveMode = getModeFn or GetColorMode
			local mode = resolveMode(colorEntry)
			local color = colorEntry.color or fallbackColor

			-- Hook SetText to always prepend the prefix to the displayed selection
			if not dropdown._originalSetText then
				dropdown._originalSetText = dropdown.SetText
				dropdown.SetText = function(self, text)
					dropdown._originalSetText(self, prefix .. ": " .. (text or ""))
				end
			end

			dropdown:SetDefaultText(prefix .. ": " .. (modeLabels[mode] or modeLabels["shared"]))

			-- Show/hide color picker based on mode
			if mode == "override" then
				colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(color, true))
				colorPicker:Show()
			else
				colorPicker:Hide()
			end

			-- Set up dropdown menu
			local function IsSelected(value)
				return value == resolveMode(colorEntry)
			end

			local function SetSelected(newValue)
				colorEntry.mode = newValue
				colorEntry.enabled = nil -- Remove old field
				colorEntry.show = nil -- Remove old OOR field
				if newValue == "override" then
					colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color or fallbackColor, true))
					colorPicker:Show()
				else
					colorPicker:Hide()
				end
				RepositionDetailControls()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end

			dropdown:SetupMenu(function(dd, rootDescription)
				for _, key in ipairs({"shared", "override", "hidden"}) do
					rootDescription:CreateRadio(modeLabels[key], IsSelected, SetSelected, key)
				end
			end)
			dropdown:Show()
		end

		-- Helper to wire up color picker OnMouseDown
		local function WireColorPicker(colorPicker, colorEntry, fallbackColor)
			colorPicker:SetScript("OnMouseDown", function(self, button, ...)
				if button == "LeftButton" then
					local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorEntry.color or fallbackColor, true)
					TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
						local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
						local newColor = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
						colorEntry.color = newColor
						colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(newColor, true))
					end)
				end
			end)
		end

		-- ===== COLOR MODE (Static / Dynamic) =====
		dictEntry.colors.staticColor = dictEntry.colors.staticColor or {}
		local colorMode = dictEntry.colors.colorMode or "dynamic"
		local colorModeLabels = {
			static = L["ThresholdDetailColorModeStatic"],
			dynamic = L["ThresholdDetailColorModeDynamic"],
		}

		local colorModePrefix = L["ThresholdDetailColorModePrefix"]
		colorModeDropdown:SetDefaultText(colorModePrefix .. ": " .. (colorModeLabels[colorMode] or colorModeLabels["dynamic"]))
		if not colorModeDropdown._originalSetText then
			colorModeDropdown._originalSetText = colorModeDropdown.SetText
			colorModeDropdown.SetText = function(self, text)
				colorModeDropdown._originalSetText(self, colorModePrefix .. ": " .. (text or ""))
			end
		end
		colorModeDropdown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["ThresholdDetailColorModeTooltip"], 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		colorModeDropdown:SetScript("OnLeave", function() GameTooltip:Hide() end)

		-- Static color swatch
		local staticColor = dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF"
		if colorMode == "static" then
			controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(staticColor, true))
			controls.colors.thresholdStatic:Show()
		else
			controls.colors.thresholdStatic:Hide()
		end

		local function ColorModeIsSelected(value)
			return value == (dictEntry.colors.colorMode or "dynamic")
		end

		local function ColorModeSetSelected(newValue)
			dictEntry.colors.colorMode = newValue
			if newValue == "static" then
				local sc = dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF"
				controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(sc, true))
			end
			RepositionDetailControls()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end

		colorModeDropdown:SetupMenu(function(dd, rootDescription)
			for _, key in ipairs({"static", "dynamic"}) do
				rootDescription:CreateRadio(colorModeLabels[key], ColorModeIsSelected, ColorModeSetSelected, key)
			end
		end)
		colorModeDropdown:Show()

		-- Wire static color picker
		controls.colors.thresholdStatic:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF", true)
				TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
					local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
					local newColor = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
					dictEntry.colors.staticColor.color = newColor
					controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(newColor, true))
					TRB.Functions.Threshold:RedrawThresholdLines()
				end)
			end
		end)

		-- Under color: dropdown + swatch
		SetupColorModeDropdown(colorUnderModeDropdown, controls.colors.thresholdUnder, dictEntry.colors.under,
			spec.colors.threshold.under.color or "FFFFFFFF",
			{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnder"] },
			L["ThresholdDetailColorsPrefixUnder"])
		WireColorPicker(controls.colors.thresholdUnder, dictEntry.colors.under, spec.colors.threshold.under.color or "FFFFFFFF")

		-- Over color: dropdown + swatch
		SetupColorModeDropdown(colorOverModeDropdown, controls.colors.thresholdOver, dictEntry.colors.over,
			spec.colors.threshold.over.color or "FFFFFFFF",
			{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOver"] },
			L["ThresholdDetailColorsPrefixOver"])
		WireColorPicker(controls.colors.thresholdOver, dictEntry.colors.over, spec.colors.threshold.over.color or "FFFFFFFF")

		-- Unusable color: dropdown + swatch (only for spells with cooldown)
		if hasUnusable then
			SetupColorModeDropdown(colorUnusableModeDropdown, controls.colors.thresholdUnusable, dictEntry.colors.unusable,
				spec.colors.threshold.unusable.color or "FFFFFFFF",
				{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnusable"] },
				L["ThresholdDetailColorsPrefixUnusable"])
			WireColorPicker(controls.colors.thresholdUnusable, dictEntry.colors.unusable, spec.colors.threshold.unusable.color or "FFFFFFFF")
		else
			colorUnusableModeDropdown:Hide()
			controls.colors.thresholdUnusable:Hide()
		end

		-- Out of Range: dropdown + swatch (only for spells with range check)
		if hasOutOfRange then
			SetupColorModeDropdown(colorOorModeDropdown, controls.colors.thresholdOutOfRange, dictEntry.colors.outOfRange,
				spec.colors.threshold.outOfRange.color or "FFFFFFFF",
				{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOutOfRange"] },
				L["ThresholdDetailColorsPrefixOutOfRange"],
				GetOorColorMode)
			WireColorPicker(controls.colors.thresholdOutOfRange, dictEntry.colors.outOfRange, spec.colors.threshold.outOfRange.color or "FFFFFFFF")
		else
			colorOorModeDropdown:Hide()
			controls.colors.thresholdOutOfRange:Hide()
		end

		-- ===== LINE OVERRIDE SECTION =====
		local function UpdateLineControlsVisibility()
			if dictEntry.line.enabled then
				controls.sliders.thresholdLineWidth:Show()
				lineOverlapBorderCheckbox:Show()
			else
				controls.sliders.thresholdLineWidth:Hide()
				lineOverlapBorderCheckbox:Hide()
			end
		end

		lineUseSpecificCheckbox:SetChecked(dictEntry.line.enabled or false)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(lineUseSpecificCheckbox, dictEntry.line.enabled or false, true)
		lineUseSpecificCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.line.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(lineUseSpecificCheckbox, dictEntry.line.enabled, true)
			UpdateLineControlsVisibility()
			RepositionDetailControls()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		lineUseSpecificCheckbox:Show()

		local lineWidth = dictEntry.line.width or spec.thresholds.properties.width or 2
		controls.sliders.thresholdLineWidth:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdLineWidth:SetValue(lineWidth)
		controls.sliders.thresholdLineWidth.EditBox:SetText(lineWidth)
		controls.sliders.thresholdLineWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.line.width = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Overlap Border checkbox
		lineOverlapBorderCheckbox:SetChecked(dictEntry.line.overlapBorder or false)
		lineOverlapBorderCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.line.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		UpdateLineControlsVisibility()

		-- ===== ICON OVERRIDE SECTION =====
		if detailHasThresholdIcon then
		local function UpdateIconControlsVisibility()
			if dictEntry.icon.enabled then
				iconRelativeToDropdown.label:Show()
				iconRelativeToDropdown:Show()
				iconShowCheckbox:Show()
				iconDesaturateCheckbox:Show()
				TRB.Functions.OptionsUi:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show ~= false)
				controls.sliders.thresholdIconWidth:Show()
				controls.sliders.thresholdIconHeight:Show()
				controls.sliders.thresholdIconXPos:Show()
				controls.sliders.thresholdIconYPos:Show()
				controls.sliders.thresholdIconBorderWidth:Show()
			else
				iconRelativeToDropdown.label:Hide()
				iconRelativeToDropdown:Hide()
				iconShowCheckbox:Hide()
				iconDesaturateCheckbox:Hide()
				controls.sliders.thresholdIconWidth:Hide()
				controls.sliders.thresholdIconHeight:Hide()
				controls.sliders.thresholdIconXPos:Hide()
				controls.sliders.thresholdIconYPos:Hide()
				controls.sliders.thresholdIconBorderWidth:Hide()
			end
		end

		iconUseSpecificCheckbox:SetChecked(dictEntry.icon.enabled or false)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(iconUseSpecificCheckbox, dictEntry.icon.enabled or false, true)
		iconUseSpecificCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(iconUseSpecificCheckbox, dictEntry.icon.enabled, true)
			UpdateIconControlsVisibility()
			RepositionDetailControls()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		iconUseSpecificCheckbox:Show()

		-- Relative Position dropdown
		local iconRelativeTo = dictEntry.icon.relativeTo or spec.thresholds.icons.relativeTo or "BOTTOM"

		local relativeToMap = {}
		relativeToMap[L["ThresholdIconPositionAboveLeft"]] = "TOP"
		relativeToMap[L["PositionMiddle"]] = "CENTER"
		relativeToMap[L["ThresholdIconPositionBelowRight"]] = "BOTTOM"
		local relativeToList = { L["ThresholdIconPositionAboveLeft"], L["PositionMiddle"], L["ThresholdIconPositionBelowRight"] }

		-- Set initial display text
		for k, v in pairs(relativeToMap) do
			if v == iconRelativeTo then
				iconRelativeToDropdown:SetDefaultText(k)
				break
			end
		end

		local function IconRelativeToIsSelected(value)
			return value == (dictEntry.icon.relativeTo or spec.thresholds.icons.relativeTo or "BOTTOM")
		end

		local function IconRelativeToSetSelected(newValue)
			dictEntry.icon.relativeTo = newValue
			for k, v in pairs(relativeToMap) do
				if v == newValue then
					iconRelativeToDropdown:SetDefaultText(k)
					break
				end
			end
			TRB.Functions.Threshold:RedrawThresholdLines()
		end

		local function IconRelativeToGenerator(dropdown, rootDescription)
			for _, label in pairs(relativeToList) do
				rootDescription:CreateRadio(label, IconRelativeToIsSelected, IconRelativeToSetSelected, relativeToMap[label])
			end
		end
		iconRelativeToDropdown:SetupMenu(IconRelativeToGenerator)

		-- Show Icons checkbox
		iconShowCheckbox:SetChecked(dictEntry.icon.show ~= false)
		iconShowCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.show = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show)
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Desaturate Icons checkbox
		iconDesaturateCheckbox:SetChecked(dictEntry.icon.desaturated ~= false)
		iconDesaturateCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.desaturated = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show ~= false)

		-- Icon size/position sliders
		local iconWidth = dictEntry.icon.width or spec.thresholds.icons.width or 32
		local iconHeight = dictEntry.icon.height or spec.thresholds.icons.height or 32
		local iconXPos = dictEntry.icon.xPos or spec.thresholds.icons.xPos or 0
		local iconYPos = dictEntry.icon.yPos or spec.thresholds.icons.yPos or 0
		local iconBorder = dictEntry.icon.border or spec.thresholds.icons.border or 2

		controls.sliders.thresholdIconWidth:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconWidth:SetValue(iconWidth)
		controls.sliders.thresholdIconWidth.EditBox:SetText(iconWidth)
		controls.sliders.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.width = value

			local currentHeight = dictEntry.icon.height or spec.thresholds.icons.height or 32
			local maxBorderSize = math.min(math.floor(currentHeight / TRB.Data.constants.borderWidthFactor), math.floor(value / TRB.Data.constants.borderWidthFactor))
			local borderSize = math.min(maxBorderSize, dictEntry.icon.border or spec.thresholds.icons.border or 2)
			controls.sliders.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.EditBox:SetText(borderSize)

			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconHeight:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconHeight:SetValue(iconHeight)
		controls.sliders.thresholdIconHeight.EditBox:SetText(iconHeight)
		controls.sliders.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.height = value

			local currentWidth = dictEntry.icon.width or spec.thresholds.icons.width or 32
			local maxBorderSize = math.min(math.floor(value / TRB.Data.constants.borderWidthFactor), math.floor(currentWidth / TRB.Data.constants.borderWidthFactor))
			local borderSize = math.min(maxBorderSize, dictEntry.icon.border or spec.thresholds.icons.border or 2)
			controls.sliders.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.EditBox:SetText(borderSize)

			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconXPos:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconXPos:SetValue(iconXPos)
		controls.sliders.thresholdIconXPos.EditBox:SetText(iconXPos)
		controls.sliders.thresholdIconXPos:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.xPos = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconYPos:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconYPos:SetValue(iconYPos)
		controls.sliders.thresholdIconYPos.EditBox:SetText(iconYPos)
		controls.sliders.thresholdIconYPos:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.yPos = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Icon Border Width slider
		local maxIconBorder = math.min(math.floor(iconHeight / TRB.Data.constants.borderWidthFactor), math.floor(iconWidth / TRB.Data.constants.borderWidthFactor))
		controls.sliders.thresholdIconBorderWidth:SetMinMaxValues(0, maxIconBorder)
		controls.sliders.thresholdIconBorderWidth.MaxLabel:SetText(maxIconBorder)
		controls.sliders.thresholdIconBorderWidth:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconBorderWidth:SetValue(iconBorder)
		controls.sliders.thresholdIconBorderWidth.EditBox:SetText(iconBorder)
		controls.sliders.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.border = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		UpdateIconControlsVisibility()
		else
			iconHeader:Hide()
			iconUseSpecificCheckbox:Hide()
			iconRelativeToDropdown.label:Hide()
			iconRelativeToDropdown:Hide()
			iconShowCheckbox:Hide()
			iconDesaturateCheckbox:Hide()
			controls.sliders.thresholdIconWidth:Hide()
			controls.sliders.thresholdIconHeight:Hide()
			controls.sliders.thresholdIconXPos:Hide()
			controls.sliders.thresholdIconYPos:Hide()
			controls.sliders.thresholdIconBorderWidth:Hide()
		end

		-- ===== AUDIO CUE SECTION =====
		if detailCanHaveAudio then
			audioHeader:Show()
			audioCheckbox:SetChecked(dictEntry.audio.enabled or false)
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(audioCheckbox, dictEntry.audio.enabled or false, true)
			audioCheckbox:SetScript("OnClick", function(self, ...)
				dictEntry.audio.enabled = self:GetChecked()
				TRB.Functions.OptionsUi:ToggleCheckboxOnOff(audioCheckbox, dictEntry.audio.enabled, true)
				if dictEntry.audio.enabled and dictEntry.audio.sound and dictEntry.audio.sound ~= "" then
					PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
				end
				SetTableValues()
			end)
			audioCheckbox:Show()

			-- Audio sound dropdown
			FillSoundCache()
			local soundDisplayName = dictEntry.audio.soundName
			audioDropdown:SetDefaultText((soundDisplayName and soundDisplayName ~= "") and soundDisplayName or L["ThresholdDetailAudioNone"])
			local function AudioIsSelected(value)
				return value == dictEntry.audio.sound
			end
			local function AudioSetSelected(newValue)
				dictEntry.audio.sound = newValue
				dictEntry.audio.soundName = soundPairsByName[newValue]
				local newSoundName = dictEntry.audio.soundName
				audioDropdown:SetDefaultText((newSoundName and newSoundName ~= "") and newSoundName or L["ThresholdDetailAudioNone"])
				PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
				SetTableValues()
			end
			audioDropdown:SetupMenu(function(dropdown, rootDescription)
				for k, v in pairs(soundPairs) do
					rootDescription:CreateRadio(v[1], AudioIsSelected, AudioSetSelected, v[2])
				end
				rootDescription:SetScrollMode(400)
			end)
			audioDropdown:Show()
		else
			audioHeader:Hide()
			audioCheckbox:Hide()
			audioDropdown:Hide()
		end

		RepositionDetailControls()
		detailHeader:Show()
		detailFrame:Show()
	end

	-- Table click handler
	thresholdTable:RegisterEvents({
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				if realrow ~= nil and realrow > 0 then
					local settingKey = data[realrow].cols[1].value
					local currentSelection = scrollingTable:GetSelection()
					FillDetailPanel(settingKey)
					C_Timer.After(0, function()
						C_Timer.After(0.05, function()
							local newSelection = scrollingTable:GetSelection()
							if newSelection == nil then
								thresholdTable:SetSelection(currentSelection)
							end
						end)
					end)
				end
			end
		end
	})

	-- Row tooltip handler
	thresholdTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow ~= nil and realrow > 0 then
				local settingKey = data[realrow].cols[1].value
				for _, entry in ipairs(thresholdEntries) do
					if entry.settingKey == settingKey and entry.tooltip then
						GameTooltip:SetOwner(rowFrame, "ANCHOR_CURSOR")
						GameTooltip:SetText(entry.tooltip, 1, 1, 1, 1, true)
						GameTooltip:Show()
						break
					end
				end
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			GameTooltip:Hide()
		end
	})

	-- Initial table population
	SetTableValues()

	yCoord = yCoord - (35 + (tableRowCount * 15)) - 10

	return yCoord
end

---Generates the threshold line icon position and dimension options panel, including icon size, border, position, threshold line width, and overlap settings.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing threshold icon configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param isHealer boolean? Whether the spec is a healer (affects global setting handling)
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	yCoord = yCoord - 30
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinePositionHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdIcons = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdIcons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdIcons
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdIcons"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, isHealer)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("thresholdIcons")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "thresholdIcons")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdIcons", "thresholdIcons", yCoord)
	end

	yCoord = yCoord - 20
	local thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconRelativeTo", parent, "WowStyle1DropdownTemplate")
	thresholdIconRelativeTo:SetWidth(oUi.sliderWidth)
	thresholdIconRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdIconRelativePosition"], oUi.xCoord, yCoord)
	thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)

	local relativeTo = {}
	relativeTo[L["ThresholdIconPositionAboveLeft"]] = "TOP"
	relativeTo[L["PositionMiddle"]] = "CENTER"
	relativeTo[L["ThresholdIconPositionBelowRight"]] = "BOTTOM"
	local relativeToList = {
		L["ThresholdIconPositionAboveLeft"],
		L["PositionMiddle"],
		L["ThresholdIconPositionBelowRight"]
	}
	for label, value in pairs(relativeTo) do
		if value == spec.thresholds.icons.relativeTo then
			thresholdIconRelativeTo:SetDefaultText(label)
			break
		end
	end

	local function RelativeToIsSelected(value)
		return value == spec.thresholds.icons.relativeTo
	end

	local function RelativeToSetSelected(newValue)
		spec.thresholds.icons.relativeTo = newValue

		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec.thresholds.icons.relativeToName = k
				break
			end
		end
		thresholdIconRelativeTo:SetDefaultText(spec.thresholds.icons.relativeToName)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	thresholdIconRelativeTo:SetupMenu(RelativeToGenerator)
	thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShow"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconShowTooltip"]
	f:SetChecked(spec.thresholds.icons.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.enabled = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconDesaturated
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconDesaturate"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconDesaturateTooltip"]
	f:SetChecked(spec.thresholds.icons.desaturated)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.desaturated = self:GetChecked()

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

	yCoord = yCoord - 100
	title = L["ThresholdIconWidth"]
	controls.thresholdIconWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.width = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.thresholds.icons.border)

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconHeight"]
	controls.thresholdIconHeight = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.height = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.thresholds.icons.border)

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)


	title = L["ThresholdIconHorizontal"]
	yCoord = yCoord - 60
	controls.thresholdIconHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.xPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconVertical"]
	controls.thresholdIconVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.yPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

	title = L["ThresholdIconBorderWidth"]
	yCoord = yCoord - 60
	controls.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.border = value

		local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
		local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

		controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
		controls.thresholdIconHeight.MinLabel:SetText(tostring(minsliderHeight))
		controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
		controls.thresholdIconWidth.MinLabel:SetText(tostring(minsliderWidth))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdLineWidth"]
	controls.thresholdWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.thresholds.properties.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.properties.width = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.properties.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.properties.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines()
	end)

	return yCoord
end

---Generates Threshold Line color options for the specialization, including custom colors if provided.
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer?
---@param specId integer?
---@param yCoord number
---@param localizationResource string
---@param under boolean?
---@param over boolean?
---@param unusable boolean?
---@param outOfRange boolean?
---@param custom TRB.Classes.OptionsUi.Color[]?
---@return number
function TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, classId, specId, yCoord, localizationResource, under, over, unusable, outOfRange, custom)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.colors.threshold = controls.colors.threshold or {}

	if classId == nill then
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsForDpsAndTanksHeader"], oUi.xCoord, yCoord)
	else
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)
	end

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("thresholdColors")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "thresholdColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdColors", "thresholdColors", yCoord)
	end

	if under == true then
		yCoord = yCoord - 30
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], localizationResource), spec.colors.threshold.under.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)
	end

	if over == true then
		yCoord = yCoord - 30
		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], localizationResource), spec.colors.threshold.over.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)
	end

	if unusable == true then
		yCoord = yCoord - 30
		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnusable"], spec.colors.threshold.unusable.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)
	end

	if outOfRange == true then
		yCoord = yCoord - 30
		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord+10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeShowCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeShowCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.show)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.show = self:GetChecked()

			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		controls.checkBoxes.thresholdOutOfRangeColorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRangeColorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRangeColorEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.enabled = self:GetChecked()
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)
	end

	if custom ~= nil and #custom > 0 then
		for _, value in pairs(custom) do
			yCoord, _, _ = TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, "threshold", spec.colors.threshold, namePrefix, value)
		end
	end

	return yCoord
end

