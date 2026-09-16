---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.ThresholdList = TRB.Functions.OptionsUi.ThresholdList or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

local dropdownSetTextState = setmetatable({}, { __mode = "k" })

---@param colorEntry table?
---@return string
function TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(colorEntry)
	if colorEntry == nil then return "shared" end
	if colorEntry.mode ~= nil then return colorEntry.mode end
	if colorEntry.enabled then return "override" end
	return "shared"
end

---@param colorEntry table?
---@return string
function TRB.Functions.OptionsUi.ThresholdList:GetThresholdOorColorMode(colorEntry)
	if colorEntry == nil then return "shared" end
	if colorEntry.mode ~= nil then return colorEntry.mode end
	if colorEntry.show == false then return "hidden" end
	if colorEntry.enabled then return "override" end
	return "shared"
end

---@param dropdown DropdownButton
---@param prefix string
local function EnsureDropdownPrefixHook(dropdown, prefix)
	if dropdown == nil then
		return
	end
	local state = dropdownSetTextState[dropdown]
	if state ~= nil and state.prefix == prefix then
		return
	end
	if state == nil then
		state = {
			originalSetText = dropdown.SetText,
			prefix = nil,
		}
		dropdownSetTextState[dropdown] = state
	end
	state.prefix = prefix
	dropdown.SetText = function(self, text)
		state.originalSetText(self, prefix .. ": " .. (text or ""))
	end
end

---Binds a shared "shared/override/hidden" color mode dropdown and handles swatch visibility.
---@param config table
function TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown(config)
	local dropdown = config.dropdown
	local colorPicker = config.colorPicker
	local colorEntry = config.colorEntry
	local fallbackColor = config.fallbackColor
	local modeLabels = config.modeLabels
	local prefix = config.prefix
	local resolveMode = config.resolveMode or function(entry)
		return TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(entry)
	end
	if dropdown == nil or colorPicker == nil or colorEntry == nil or modeLabels == nil or prefix == nil then
		return
	end

	local mode = resolveMode(colorEntry)
	local color = colorEntry.color or fallbackColor

	EnsureDropdownPrefixHook(dropdown, prefix)
	dropdown:SetDefaultText(prefix .. ": " .. (modeLabels[mode] or modeLabels["shared"]))

	if mode == "override" then
		colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(color, true))
		colorPicker:Show()
	else
		colorPicker:Hide()
	end

	local function IsSelected(value)
		return value == resolveMode(colorEntry)
	end

	local function SetSelected(newValue)
		colorEntry.mode = newValue
		colorEntry.enabled = nil
		colorEntry.show = nil
		if newValue == "override" then
			colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color or fallbackColor, true))
			colorPicker:Show()
		else
			colorPicker:Hide()
		end
		if config.onLayoutChanged then
			config.onLayoutChanged()
		end
		if config.onChanged then
			config.onChanged(newValue, colorEntry)
		end
	end

	dropdown:SetupMenu(function(dd, rootDescription)
		for _, key in ipairs({"shared", "override", "hidden"}) do
			rootDescription:CreateRadio(modeLabels[key], IsSelected, SetSelected, key)
		end
	end)
	dropdown:Show()
end

---Binds the shared static/dynamic color type dropdown.
---@param config table
function TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorTypeDropdown(config)
	local dropdown = config.dropdown
	local colorState = config.colorState
	local colorModeLabels = config.colorModeLabels
	local colorModePrefix = config.colorModePrefix
	if dropdown == nil or colorState == nil or colorModeLabels == nil or colorModePrefix == nil then
		return
	end

	local colorMode = colorState.colorMode or "dynamic"
	EnsureDropdownPrefixHook(dropdown, colorModePrefix)
	dropdown:SetDefaultText(colorModePrefix .. ": " .. (colorModeLabels[colorMode] or colorModeLabels["dynamic"]))

	if config.tooltip ~= nil then
		dropdown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(config.tooltip, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		dropdown:SetScript("OnLeave", function() GameTooltip:Hide() end)
	else
		dropdown:SetScript("OnEnter", nil)
		dropdown:SetScript("OnLeave", nil)
	end

	local function IsSelected(value)
		return value == (colorState.colorMode or "dynamic")
	end

	local function SetSelected(newValue)
		colorState.colorMode = newValue
		if config.onLayoutChanged then
			config.onLayoutChanged()
		end
		if config.onChanged then
			config.onChanged(newValue, colorState)
		end
	end

	dropdown:SetupMenu(function(dd, rootDescription)
		for _, key in ipairs({"static", "dynamic"}) do
			rootDescription:CreateRadio(colorModeLabels[key], IsSelected, SetSelected, key)
		end
	end)
	dropdown:Show()
end

---Binds a shared color picker callback for threshold color entries.
---@param config table
function TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker(config)
	local colorPicker = config.colorPicker
	local colorEntry = config.colorEntry
	local fallbackColor = config.fallbackColor or "FFFFFFFF"
	if colorPicker == nil or colorEntry == nil then
		return
	end

	colorPicker:SetScript("OnMouseDown", function(self, button)
		if button ~= "LeftButton" then
			return
		end
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorEntry.color or fallbackColor, true)
		TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, 1 - a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
			local newColor = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
			colorEntry.color = newColor
			colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(newColor, true))
			if config.onChanged then
				config.onChanged(newColor, colorEntry)
			end
		end)
	end)
end

---Applies shared visibility and positioning logic for Color override sections.
---@param config table
---@return number yCoord
function TRB.Functions.OptionsUi.ThresholdList:ApplyColorOverrideLayout(config)
	local y = config.yCoord or 0
	local isEnabled = config.isEnabled == true
	local colorMode = config.colorMode or "dynamic"
	local hasUnusable = config.hasUnusable == true
	local hasOutOfRange = config.hasOutOfRange == true

	local colorsHeader = config.colorsHeader
	local colorModeDropdown = config.colorModeDropdown
	local staticColorPicker = config.staticColorPicker
	local underModeDropdown = config.underModeDropdown
	local underColorPicker = config.underColorPicker
	local overModeDropdown = config.overModeDropdown
	local overColorPicker = config.overColorPicker
	local unusableModeDropdown = config.unusableModeDropdown
	local unusableColorPicker = config.unusableColorPicker
	local outOfRangeModeDropdown = config.outOfRangeModeDropdown
	local outOfRangeColorPicker = config.outOfRangeColorPicker

	if colorsHeader == nil or colorModeDropdown == nil or staticColorPicker == nil or underModeDropdown == nil or underColorPicker == nil or overModeDropdown == nil or overColorPicker == nil then
		return y
	end

	if isEnabled then
		colorsHeader:Show()
		colorModeDropdown:Show()
		if colorMode == "static" then
			staticColorPicker:Show()
			underModeDropdown:Hide()
			underColorPicker:Hide()
			overModeDropdown:Hide()
			overColorPicker:Hide()
			if unusableModeDropdown then unusableModeDropdown:Hide() end
			if unusableColorPicker then unusableColorPicker:Hide() end
			if outOfRangeModeDropdown then outOfRangeModeDropdown:Hide() end
			if outOfRangeColorPicker then outOfRangeColorPicker:Hide() end
		else
			staticColorPicker:Hide()
			underModeDropdown:Show()
			overModeDropdown:Show()
			if config.underMode == "override" then underColorPicker:Show() else underColorPicker:Hide() end
			if config.overMode == "override" then overColorPicker:Show() else overColorPicker:Hide() end

			if hasUnusable and unusableModeDropdown ~= nil and unusableColorPicker ~= nil then
				unusableModeDropdown:Show()
				if config.unusableMode == "override" then unusableColorPicker:Show() else unusableColorPicker:Hide() end
			elseif unusableModeDropdown ~= nil and unusableColorPicker ~= nil then
				unusableModeDropdown:Hide()
				unusableColorPicker:Hide()
			end

			if hasOutOfRange and outOfRangeModeDropdown ~= nil and outOfRangeColorPicker ~= nil then
				outOfRangeModeDropdown:Show()
				if config.outOfRangeMode == "override" then outOfRangeColorPicker:Show() else outOfRangeColorPicker:Hide() end
			elseif outOfRangeModeDropdown ~= nil and outOfRangeColorPicker ~= nil then
				outOfRangeModeDropdown:Hide()
				outOfRangeColorPicker:Hide()
			end
		end
	else
		colorsHeader:Hide()
		colorModeDropdown:Hide()
		staticColorPicker:Hide()
		underModeDropdown:Hide()
		underColorPicker:Hide()
		overModeDropdown:Hide()
		overColorPicker:Hide()
		if unusableModeDropdown then unusableModeDropdown:Hide() end
		if unusableColorPicker then unusableColorPicker:Hide() end
		if outOfRangeModeDropdown then outOfRangeModeDropdown:Hide() end
		if outOfRangeColorPicker then outOfRangeColorPicker:Hide() end
	end

	if colorsHeader:IsShown() then
		colorsHeader:ClearAllPoints()
		colorsHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
		y = y - 30

		colorModeDropdown:ClearAllPoints()
		colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
		if colorMode == "static" then
			staticColorPicker:ClearAllPoints()
			staticColorPicker:SetPoint("TOPLEFT", oUi.xCoord2, y)
			y = y - 30
		else
			y = y - 30

			underModeDropdown:ClearAllPoints()
			underModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
			underColorPicker:ClearAllPoints()
			underColorPicker:SetPoint("TOPLEFT", oUi.xCoord2, y)
			y = y - 30

			overModeDropdown:ClearAllPoints()
			overModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
			overColorPicker:ClearAllPoints()
			overColorPicker:SetPoint("TOPLEFT", oUi.xCoord2, y)
			y = y - 30

			if hasUnusable and unusableModeDropdown ~= nil and unusableModeDropdown:IsShown() and unusableColorPicker ~= nil then
				unusableModeDropdown:ClearAllPoints()
				unusableModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
				unusableColorPicker:ClearAllPoints()
				unusableColorPicker:SetPoint("TOPLEFT", oUi.xCoord2, y)
				y = y - 30
			end

			if hasOutOfRange and outOfRangeModeDropdown ~= nil and outOfRangeModeDropdown:IsShown() and outOfRangeColorPicker ~= nil then
				outOfRangeModeDropdown:ClearAllPoints()
				outOfRangeModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
				outOfRangeColorPicker:ClearAllPoints()
				outOfRangeColorPicker:SetPoint("TOPLEFT", oUi.xCoord2, y)
				y = y - 30
			end
		end
	end

	return y
end

---Applies shared visibility and positioning logic for Line/Icon override sections.
---This is used by both Threshold Lines and Custom Thresholds so spacing and
---anchors remain identical between tabs.
---@param config table
---@return number yCoord
function TRB.Functions.OptionsUi.ThresholdList:ApplyLineIconOverrideLayout(config)
	local y = config.yCoord or 0
	local isEnabled = config.isEnabled == true
	local hasThresholdIcon = config.hasThresholdIcon ~= false

	local lineHeader = config.lineHeader
	local lineUseSpecificCheckbox = config.lineUseSpecificCheckbox
	local lineWidthSlider = config.lineWidthSlider
	local lineOverlapBorderCheckbox = config.lineOverlapBorderCheckbox

	local iconHeader = config.iconHeader
	local iconUseSpecificCheckbox = config.iconUseSpecificCheckbox
	local iconRelativeToDropdown = config.iconRelativeToDropdown
	local iconShowCheckbox = config.iconShowCheckbox
	local iconDesaturateCheckbox = config.iconDesaturateCheckbox
	local iconWidthSlider = config.iconWidthSlider
	local iconHeightSlider = config.iconHeightSlider
	local iconXSlider = config.iconXSlider
	local iconYSlider = config.iconYSlider
	local iconBorderSlider = config.iconBorderSlider
	local hasLineSection = lineHeader ~= nil and lineUseSpecificCheckbox ~= nil and lineWidthSlider ~= nil and lineOverlapBorderCheckbox ~= nil
	local hasIconSection = iconHeader ~= nil and iconUseSpecificCheckbox ~= nil and iconRelativeToDropdown ~= nil and iconShowCheckbox ~= nil and iconDesaturateCheckbox ~= nil and iconWidthSlider ~= nil and iconHeightSlider ~= nil and iconXSlider ~= nil and iconYSlider ~= nil and iconBorderSlider ~= nil

	if hasLineSection then
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(lineUseSpecificCheckbox, lineUseSpecificCheckbox:GetChecked() == true, true)
	end
	if hasIconSection then
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(iconUseSpecificCheckbox, iconUseSpecificCheckbox:GetChecked() == true, true)
	end

	-- Line override section
	if hasLineSection and isEnabled then
		lineHeader:Show()
		lineUseSpecificCheckbox:Show()
		if lineUseSpecificCheckbox:GetChecked() then
			lineWidthSlider:Show()
			lineOverlapBorderCheckbox:Show()
		else
			lineWidthSlider:Hide()
			lineOverlapBorderCheckbox:Hide()
		end
	elseif hasLineSection then
		lineHeader:Hide()
		lineUseSpecificCheckbox:Hide()
		lineWidthSlider:Hide()
		lineOverlapBorderCheckbox:Hide()
	end

	if hasLineSection and lineHeader:IsShown() then
		lineHeader:ClearAllPoints()
		lineHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
		y = y - 30

		lineUseSpecificCheckbox:ClearAllPoints()
		lineUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
		y = y - 30

		if lineWidthSlider:IsShown() then
			lineWidthSlider:ClearAllPoints()
			lineWidthSlider:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
			y = y - 50

			lineOverlapBorderCheckbox:ClearAllPoints()
			lineOverlapBorderCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30
		end
	end

	-- Icon source section (custom thresholds only): positioned between the Line override
	-- and Icon override sections. The header + type dropdown always show while the threshold
	-- is enabled; the spell/item ID controls are hidden when the type is "No Icon".
	local iconSource = config.iconSourceSection
	if iconSource ~= nil and iconSource.header ~= nil and iconSource.typeDropdown ~= nil then
		local srcHeader = iconSource.header
		local typeDropdown = iconSource.typeDropdown
		local idLabel = iconSource.idLabel
		local idBox = iconSource.idBox
		local preview = iconSource.preview
		local showIdControls = iconSource.showIdControls ~= false

		if isEnabled then
			srcHeader:Show()
			typeDropdown.label:Show()
			typeDropdown:Show()

			srcHeader:ClearAllPoints()
			srcHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 28

			typeDropdown.label:ClearAllPoints()
			typeDropdown.label:SetPoint("TOPLEFT", oUi.xCoord, y)
			typeDropdown:ClearAllPoints()
			typeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y - 25)

			if showIdControls then
				if idLabel then idLabel:Show(); idLabel:ClearAllPoints(); idLabel:SetPoint("TOPLEFT", oUi.xCoord2, y) end
				if idBox then idBox:Show(); idBox:ClearAllPoints(); idBox:SetPoint("TOPLEFT", oUi.xCoord2, y - 25) end
				if preview and idBox then preview:Show(); preview:ClearAllPoints(); preview:SetPoint("TOPLEFT", idBox, "TOPRIGHT", 15, 0) end
			else
				if idLabel then idLabel:Hide() end
				if idBox then idBox:Hide() end
				if preview then preview:Hide() end
			end
			y = y - 55
		else
			srcHeader:Hide()
			typeDropdown.label:Hide()
			typeDropdown:Hide()
			if idLabel then idLabel:Hide() end
			if idBox then idBox:Hide() end
			if preview then preview:Hide() end
		end
	end

	-- Icon override section
	if hasIconSection and isEnabled and hasThresholdIcon then
		iconHeader:Show()
		iconUseSpecificCheckbox:Show()
		if iconUseSpecificCheckbox:GetChecked() then
			iconRelativeToDropdown.label:Show()
			iconRelativeToDropdown:Show()
			iconShowCheckbox:Show()
			iconDesaturateCheckbox:Show()
			iconWidthSlider:Show()
			iconHeightSlider:Show()
			iconXSlider:Show()
			iconYSlider:Show()
			iconBorderSlider:Show()
		else
			iconRelativeToDropdown.label:Hide()
			iconRelativeToDropdown:Hide()
			iconShowCheckbox:Hide()
			iconDesaturateCheckbox:Hide()
			iconWidthSlider:Hide()
			iconHeightSlider:Hide()
			iconXSlider:Hide()
			iconYSlider:Hide()
			iconBorderSlider:Hide()
		end
	elseif hasIconSection then
		iconHeader:Hide()
		iconUseSpecificCheckbox:Hide()
		iconRelativeToDropdown.label:Hide()
		iconRelativeToDropdown:Hide()
		iconShowCheckbox:Hide()
		iconDesaturateCheckbox:Hide()
		iconWidthSlider:Hide()
		iconHeightSlider:Hide()
		iconXSlider:Hide()
		iconYSlider:Hide()
		iconBorderSlider:Hide()
	end

	if hasIconSection and iconHeader:IsShown() then
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

			iconWidthSlider:ClearAllPoints()
			iconWidthSlider:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
			iconHeightSlider:ClearAllPoints()
			iconHeightSlider:SetPoint("TOPLEFT", oUi.xCoord2 + 18, y)
			y = y - 60

			iconXSlider:ClearAllPoints()
			iconXSlider:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
			iconYSlider:ClearAllPoints()
			iconYSlider:SetPoint("TOPLEFT", oUi.xCoord2 + 18, y)
			y = y - 60

			iconBorderSlider:ClearAllPoints()
			iconBorderSlider:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
			y = y - 50
		end
	end

	return y
end

-- ============================================================================
-- Threshold list/detail panel
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
function TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, classId, specId, yCoord, thresholdConfig)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	-- Category display names
	local categoryLabels = {
		offensive = L["ThresholdCategoryOffensive"],
		defensive = L["ThresholdCategoryDefensive"],
		pvp = L["ThresholdCategoryPvp"],
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
	controls.thresholdOverridesSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ThresholdOverridesHeader"], oUi.xCoord, yCoord)
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
	local detailHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, "", oUi.xCoord, 0)
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
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, false, false)
	enabledCheckbox:Hide()

	-- ===== COLOR OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 30
	local colorsHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailScrollChild, L["ThresholdDetailColorsHeader"], oUi.xCoord, detailYCoord)
	colorsHeader.font:SetFontObject(GameFontNormalLarge)
	colorsHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	-- Color mode helpers live on the ThresholdList module for reuse by Custom Thresholds.

	controls.dropDown = controls.dropDown or {}

	-- Color Mode: Static / Dynamic dropdown
	controls.dropDown.thresholdColorMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorModeDropdown = controls.dropDown.thresholdColorMode
	colorModeDropdown:SetWidth(oUi.sliderWidth)
	colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorModeDropdown:Hide()

	controls.colors.thresholdStatic = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorModeStaticColor"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdStatic:Hide()

	-- Under color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorUnderMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorUnderMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorUnderModeDropdown = controls.dropDown.thresholdColorUnderMode
	colorUnderModeDropdown:SetWidth(oUi.sliderWidth)
	colorUnderModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorUnderModeDropdown:Hide()

	controls.colors.thresholdUnder = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsUnder"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdUnder:Hide()

	-- Over color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorOverMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorOverMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorOverModeDropdown = controls.dropDown.thresholdColorOverMode
	colorOverModeDropdown:SetWidth(oUi.sliderWidth)
	colorOverModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorOverModeDropdown:Hide()

	controls.colors.thresholdOver = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsOver"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdOver:Hide()

	-- Unusable color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorUnusableMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorUnusableMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorUnusableModeDropdown = controls.dropDown.thresholdColorUnusableMode
	colorUnusableModeDropdown:SetWidth(oUi.sliderWidth)
	colorUnusableModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorUnusableModeDropdown:Hide()

	controls.colors.thresholdUnusable = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsUnusable"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdUnusable:Hide()

	-- Out of Range: mode dropdown + override color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorOorMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorOorMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorOorModeDropdown = controls.dropDown.thresholdColorOorMode
	colorOorModeDropdown:SetWidth(oUi.sliderWidth)
	colorOorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorOorModeDropdown:Hide()

	controls.colors.thresholdOutOfRange = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsOutOfRange"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdOutOfRange:Hide()

	-- ===== LINE OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 40
	local lineHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailScrollChild, L["ThresholdDetailLineHeader"], oUi.xCoord, detailYCoord)
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
	controls.sliders.thresholdLineWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailScrollChild, L["ThresholdDetailLineWidth"], 1, 10, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdLineWidth:Hide()

	controls.checkBoxes.thresholdLineOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdLineOverlapBorder", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local lineOverlapBorderCheckbox = controls.checkBoxes.thresholdLineOverlapBorder
	lineOverlapBorderCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(lineOverlapBorderCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailLineOverlapBorder"])
	lineOverlapBorderCheckbox.tooltip = L["ThresholdDetailLineOverlapBorderTooltip"]
	lineOverlapBorderCheckbox:Hide()

	-- ===== ICON OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 50
	local iconHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailScrollChild, L["ThresholdDetailIconHeader"], oUi.xCoord, detailYCoord)
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
	iconRelativeToDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailScrollChild, L["ThresholdDetailIconRelativePosition"], oUi.xCoord, detailYCoord)
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
	controls.sliders.thresholdIconWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailScrollChild, L["ThresholdDetailIconWidth"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconWidth:Hide()

	controls.sliders.thresholdIconHeight = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailScrollChild, L["ThresholdDetailIconHeight"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.thresholdIconHeight:Hide()

	detailYCoord = detailYCoord - 60
	controls.sliders.thresholdIconXPos = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailScrollChild, L["ThresholdDetailIconXPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconXPos:Hide()

	controls.sliders.thresholdIconYPos = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailScrollChild, L["ThresholdDetailIconYPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.thresholdIconYPos:Hide()

	detailYCoord = detailYCoord - 60
	controls.sliders.thresholdIconBorderWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailScrollChild, L["ThresholdDetailIconBorderWidth"], 0, 12, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconBorderWidth:Hide()

	-- ===== AUDIO CUE SECTION =====
	detailYCoord = detailYCoord - 50
	local audioHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailScrollChild, L["ThresholdDetailAudioHeader"], oUi.xCoord, detailYCoord)
	audioHeader.font:SetFontObject(GameFontNormalLarge)
	audioHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.checkBoxes.thresholdAudioEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdAudioEnabled", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local audioCheckbox = controls.checkBoxes.thresholdAudioEnabled
	audioCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(audioCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailAudioCheckbox"])
	audioCheckbox.tooltip = L["ThresholdDetailAudioCheckboxTooltip"]
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(audioCheckbox, false, true)
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

		local dictEntryForLayout = selectedSettingKey and spec.thresholds.thresholdDictionary[selectedSettingKey]
		local layoutColors = dictEntryForLayout and dictEntryForLayout.colors or nil
		local layoutColorMode = (layoutColors and layoutColors.colorMode) or "dynamic"
		y = TRB.Functions.OptionsUi.ThresholdList:ApplyColorOverrideLayout({
			yCoord = y,
			isEnabled = isEnabled,
			colorMode = layoutColorMode,
			hasUnusable = detailHasUnusable,
			hasOutOfRange = detailHasOutOfRange,
			underMode = TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(layoutColors and layoutColors.under),
			overMode = TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(layoutColors and layoutColors.over),
			unusableMode = TRB.Functions.OptionsUi.ThresholdList:GetThresholdColorMode(layoutColors and layoutColors.unusable),
			outOfRangeMode = TRB.Functions.OptionsUi.ThresholdList:GetThresholdOorColorMode(layoutColors and layoutColors.outOfRange),
			colorsHeader = colorsHeader,
			colorModeDropdown = colorModeDropdown,
			staticColorPicker = controls.colors.thresholdStatic,
			underModeDropdown = colorUnderModeDropdown,
			underColorPicker = controls.colors.thresholdUnder,
			overModeDropdown = colorOverModeDropdown,
			overColorPicker = controls.colors.thresholdOver,
			unusableModeDropdown = colorUnusableModeDropdown,
			unusableColorPicker = controls.colors.thresholdUnusable,
			outOfRangeModeDropdown = colorOorModeDropdown,
			outOfRangeColorPicker = controls.colors.thresholdOutOfRange,
		})

		y = TRB.Functions.OptionsUi.ThresholdList:ApplyLineIconOverrideLayout({
			yCoord = y,
			isEnabled = isEnabled,
			hasThresholdIcon = detailHasThresholdIcon,
			lineHeader = lineHeader,
			lineUseSpecificCheckbox = lineUseSpecificCheckbox,
			lineWidthSlider = controls.sliders.thresholdLineWidth,
			lineOverlapBorderCheckbox = lineOverlapBorderCheckbox,
			iconHeader = iconHeader,
			iconUseSpecificCheckbox = iconUseSpecificCheckbox,
			iconRelativeToDropdown = iconRelativeToDropdown,
			iconShowCheckbox = iconShowCheckbox,
			iconDesaturateCheckbox = iconDesaturateCheckbox,
			iconWidthSlider = controls.sliders.thresholdIconWidth,
			iconHeightSlider = controls.sliders.thresholdIconHeight,
			iconXSlider = controls.sliders.thresholdIconXPos,
			iconYSlider = controls.sliders.thresholdIconYPos,
			iconBorderSlider = controls.sliders.thresholdIconBorderWidth,
		})

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
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, isEnabled, false)
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
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(enabledCheckbox, checked, false)
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

		-- ===== COLOR MODE (Static / Dynamic) =====
		dictEntry.colors.staticColor = dictEntry.colors.staticColor or {}
		local colorMode = dictEntry.colors.colorMode or "dynamic"
		local colorModeLabels = {
			static = L["ThresholdDetailColorModeStatic"],
			dynamic = L["ThresholdDetailColorModeDynamic"],
		}

		local colorModePrefix = L["ThresholdDetailColorModePrefix"]

		-- Static color swatch
		local staticColor = dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF"
		if colorMode == "static" then
			controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(staticColor, true))
			controls.colors.thresholdStatic:Show()
		else
			controls.colors.thresholdStatic:Hide()
		end

		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorTypeDropdown({
			dropdown = colorModeDropdown,
			colorState = dictEntry.colors,
			colorModeLabels = colorModeLabels,
			colorModePrefix = colorModePrefix,
			tooltip = L["ThresholdDetailColorModeTooltip"],
			onLayoutChanged = RepositionDetailControls,
			onChanged = function(newValue)
				if newValue == "static" then
					local sc = dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF"
					controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(sc, true))
				end
				TRB.Functions.Threshold:RedrawThresholdLines()
			end,
		})

		-- Wire static color picker
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
			colorPicker = controls.colors.thresholdStatic,
			colorEntry = dictEntry.colors.staticColor,
			fallbackColor = spec.colors.threshold.under.color or "FFFFFFFF",
			onChanged = function()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end,
		})

		-- Under color: dropdown + swatch
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown({
			dropdown = colorUnderModeDropdown,
			colorPicker = controls.colors.thresholdUnder,
			colorEntry = dictEntry.colors.under,
			fallbackColor = spec.colors.threshold.under.color or "FFFFFFFF",
			modeLabels = { shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnder"] },
			prefix = L["ThresholdDetailColorsPrefixUnder"],
			onLayoutChanged = RepositionDetailControls,
			onChanged = function()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end,
		})
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
			colorPicker = controls.colors.thresholdUnder,
			colorEntry = dictEntry.colors.under,
			fallbackColor = spec.colors.threshold.under.color or "FFFFFFFF",
			onChanged = function()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end,
		})

		-- Over color: dropdown + swatch
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown({
			dropdown = colorOverModeDropdown,
			colorPicker = controls.colors.thresholdOver,
			colorEntry = dictEntry.colors.over,
			fallbackColor = spec.colors.threshold.over.color or "FFFFFFFF",
			modeLabels = { shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOver"] },
			prefix = L["ThresholdDetailColorsPrefixOver"],
			onLayoutChanged = RepositionDetailControls,
			onChanged = function()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end,
		})
		TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
			colorPicker = controls.colors.thresholdOver,
			colorEntry = dictEntry.colors.over,
			fallbackColor = spec.colors.threshold.over.color or "FFFFFFFF",
			onChanged = function()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end,
		})

		-- Unusable color: dropdown + swatch (only for spells with cooldown)
		if hasUnusable then
			TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown({
				dropdown = colorUnusableModeDropdown,
				colorPicker = controls.colors.thresholdUnusable,
				colorEntry = dictEntry.colors.unusable,
				fallbackColor = spec.colors.threshold.unusable.color or "FFFFFFFF",
				modeLabels = { shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnusable"] },
				prefix = L["ThresholdDetailColorsPrefixUnusable"],
				onLayoutChanged = RepositionDetailControls,
				onChanged = function()
					TRB.Functions.Threshold:RedrawThresholdLines()
				end,
			})
			TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
				colorPicker = controls.colors.thresholdUnusable,
				colorEntry = dictEntry.colors.unusable,
				fallbackColor = spec.colors.threshold.unusable.color or "FFFFFFFF",
				onChanged = function()
					TRB.Functions.Threshold:RedrawThresholdLines()
				end,
			})
		else
			colorUnusableModeDropdown:Hide()
			controls.colors.thresholdUnusable:Hide()
		end

		-- Out of Range: dropdown + swatch (only for spells with range check)
		if hasOutOfRange then
			TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorModeDropdown({
				dropdown = colorOorModeDropdown,
				colorPicker = controls.colors.thresholdOutOfRange,
				colorEntry = dictEntry.colors.outOfRange,
				fallbackColor = spec.colors.threshold.outOfRange.color or "FFFFFFFF",
				modeLabels = { shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOutOfRange"] },
				prefix = L["ThresholdDetailColorsPrefixOutOfRange"],
				resolveMode = function(entry)
					return TRB.Functions.OptionsUi.ThresholdList:GetThresholdOorColorMode(entry)
				end,
				onLayoutChanged = RepositionDetailControls,
				onChanged = function()
					TRB.Functions.Threshold:RedrawThresholdLines()
				end,
			})
			TRB.Functions.OptionsUi.ThresholdList:BindThresholdColorPicker({
				colorPicker = controls.colors.thresholdOutOfRange,
				colorEntry = dictEntry.colors.outOfRange,
				fallbackColor = spec.colors.threshold.outOfRange.color or "FFFFFFFF",
				onChanged = function()
					TRB.Functions.Threshold:RedrawThresholdLines()
				end,
			})
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
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(lineUseSpecificCheckbox, dictEntry.line.enabled or false, true)
		lineUseSpecificCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.line.enabled = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(lineUseSpecificCheckbox, dictEntry.line.enabled, true)
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
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
				TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show ~= false)
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
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(iconUseSpecificCheckbox, dictEntry.icon.enabled or false, true)
		iconUseSpecificCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.enabled = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(iconUseSpecificCheckbox, dictEntry.icon.enabled, true)
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
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show)
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Desaturate Icons checkbox
		iconDesaturateCheckbox:SetChecked(dictEntry.icon.desaturated ~= false)
		iconDesaturateCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.desaturated = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show ~= false)

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
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.xPos = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconYPos:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconYPos:SetValue(iconYPos)
		controls.sliders.thresholdIconYPos.EditBox:SetText(iconYPos)
		controls.sliders.thresholdIconYPos:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(audioCheckbox, dictEntry.audio.enabled or false, true)
			audioCheckbox:SetScript("OnClick", function(self, ...)
				dictEntry.audio.enabled = self:GetChecked()
				TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(audioCheckbox, dictEntry.audio.enabled, true)
				if dictEntry.audio.enabled and dictEntry.audio.sound and dictEntry.audio.sound ~= "" then
					PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
				end
				SetTableValues()
			end)
			audioCheckbox:Show()

			-- Audio sound dropdown
			local soundPairs = TRB.Functions.OptionsUi.Media:GetSoundPairs()
			local soundPairsByName = TRB.Functions.OptionsUi.Media:GetSoundPairsByName()
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

