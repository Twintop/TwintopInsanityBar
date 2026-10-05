---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.GlobalSettings = TRB.Functions.OptionsUi.GlobalSettings or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Global settings toggles and copy menus
-- ============================================================================
-- Per-section global settings registry. These keys mirror the per-spec
-- "Use Global" flags and the copy menu sections that operate on them.
local globalSettingDefinitions = {
	bar             = { checkboxSuffix = "barDimensions",   tabKey = "resourceBar",     sectionLabel = L["CopyMenuSection_bar"],             paths = { {"bar"} } },
	comboPoints     = { checkboxSuffix = "comboPoints",     tabKey = "comboPointsBar",  sectionLabel = L["CopyMenuSection_comboPoints"],     paths = { {"comboPoints"} } },
	healthBar       = { checkboxSuffix = "healthBar",       tabKey = "healthBar",       sectionLabel = L["CopyMenuSection_healthBar"],       paths = { {"healthBar"} } },
	healthBarColors = { checkboxSuffix = "healthBarColors", tabKey = "healthBar",       sectionLabel = L["CopyMenuSection_healthBarColors"], paths = { {"colors", "healthBar"} } },
	textures        = { checkboxSuffix = "textures",        tabKey = "barTextures",     sectionLabel = L["CopyMenuSection_textures"],        paths = { {"textures"} } },
	displayBar      = { checkboxSuffix = "displayBar",      tabKey = "barVisibility",   sectionLabel = L["CopyMenuSection_displayBar"],      paths = { {"displayBar"} }, shapeSensitive = true },
	thresholdIcons  = { checkboxSuffix = "thresholdIcons",  tabKey = "thresholds",      sectionLabel = L["CopyMenuSection_thresholdIcons"],  paths = { {"thresholds", "properties"}, {"thresholds", "icons"} }, shapeSensitive = true },
	thresholdColors = { checkboxSuffix = "thresholdColors", tabKey = "thresholds",      sectionLabel = L["CopyMenuSection_thresholdColors"], paths = { {"colors", "threshold"} }, shapeSensitive = true },
	displayText     = { checkboxSuffix = "displayText",     tabKey = "fontText",        sectionLabel = L["CopyMenuSection_displayText"],     paths = { {"displayText", "default"} } },
	textColors      = { checkboxSuffix = "textColors",      tabKey = "fontText",        sectionLabel = L["CopyMenuSection_textColors"],      paths = { {"colors", "text"} } },
	precision       = { checkboxSuffix = "precision",       tabKey = "fontText",        sectionLabel = L["CopyMenuSection_precision"],       paths = { {"precision"} } },
	globalBarText   = { checkboxSuffix = "globalBarText",   tabKey = "barText",         sectionLabel = L["CopyMenuSection_globalBarText"],   paths = { {"displayText", "barText"} }, shapeSensitive = true },
	-- Castbar sections live on the top-level "Castbar" nav category, not the Global Options panel;
	-- useGlobalLabel gives their checkboxes distinct wording so users aren't sent looking in the
	-- normal Global Options frame. Field-level paths so copies never clobber spec-only data
	-- (enabled, tickProfiles).
	castbarDimensions = { checkboxSuffix = "castbarDimensions", tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalPlayerCastbar"], sectionLabel = L["CopyMenuSection_castbarDimensions"],
		paths = { {"bars", "castbar", "width"}, {"bars", "castbar", "height"}, {"bars", "castbar", "border"}, {"bars", "castbar", "xPos"}, {"bars", "castbar", "yPos"}, {"bars", "castbar", "anchor"}, {"bars", "castbar", "fillDirection"}, {"bars", "castbar", "icon"} } },
	castbarColors   = { checkboxSuffix = "castbarColors",   tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalPlayerCastbar"], sectionLabel = L["CopyMenuSection_castbarColors"],
		paths = { {"colors", "bars", "castbar", "bar"}, {"colors", "bars", "castbar", "channel"}, {"colors", "bars", "castbar", "uninterruptible"}, {"colors", "bars", "castbar", "uninterruptibleBorder"}, {"colors", "bars", "castbar", "border"}, {"colors", "bars", "castbar", "background"}, {"colors", "bars", "castbar", "endCap"} } },
	castbarOverlays = { checkboxSuffix = "castbarOverlays", tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalPlayerCastbar"], sectionLabel = L["CopyMenuSection_castbarOverlays"],
		paths = { {"colors", "bars", "castbar", "latency"}, {"colors", "bars", "castbar", "pushback"}, {"colors", "bars", "castbar", "tick"} } },
	castbarEmpower  = { checkboxSuffix = "castbarEmpower",  tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalPlayerCastbar"], sectionLabel = L["CopyMenuSection_castbarEmpower"],
		paths = { {"colors", "bars", "castbar", "empowerStages"}, {"bars", "castbar", "empowerSegmentedFill"} } },
	castbarText     = { checkboxSuffix = "castbarText",     tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalPlayerCastbar"], sectionLabel = L["CopyMenuSection_castbarText"],
		paths = { {"bars", "castbar", "castTimePrecision"}, {"bars", "castbar", "durationPrecision"}, {"bars", "castbar", "latencyPrecision"}, {"bars", "castbar", "targetClassColor"}, {"bars", "castbar", "targetClassColorPvpOnly"}, {"bars", "castbar", "targetClassColorFriendly"} } },
	castbarShield   = { checkboxSuffix = "castbarShield",   tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalPlayerCastbar"], sectionLabel = L["CopyMenuSection_castbarShield"],
		paths = { {"bars", "castbar", "uninterruptibleShield"} } },
	-- Target/Focus cast bars mirror the player cast bar's per-section "Use Global" toggles: Dimensions
	-- (position/size/icon), Colors (fill/interrupt/border/background), and Empower (empower fill color +
	-- stage lines). Secret-safe render, so no latency/pushback/tick overlays section.
	targetCastbarDimensions = { checkboxSuffix = "targetCastbarDimensions", tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalTargetCastbar"], sectionLabel = L["CopyMenuSection_targetCastbarDimensions"],
		paths = { {"bars", "targetCastbar", "width"}, {"bars", "targetCastbar", "height"}, {"bars", "targetCastbar", "border"}, {"bars", "targetCastbar", "xPos"}, {"bars", "targetCastbar", "yPos"}, {"bars", "targetCastbar", "anchor"}, {"bars", "targetCastbar", "fillDirection"}, {"bars", "targetCastbar", "icon"} } },
	targetCastbarColors     = { checkboxSuffix = "targetCastbarColors",     tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalTargetCastbar"], sectionLabel = L["CopyMenuSection_targetCastbarColors"],
		paths = { {"bars", "targetCastbar", "interruptColor"}, {"bars", "targetCastbar", "interruptHostileOnly"}, {"colors", "bars", "targetCastbar", "bar"}, {"colors", "bars", "targetCastbar", "channel"}, {"colors", "bars", "targetCastbar", "uninterruptible"}, {"colors", "bars", "targetCastbar", "uninterruptibleBorder"}, {"colors", "bars", "targetCastbar", "border"}, {"colors", "bars", "targetCastbar", "background"}, {"colors", "bars", "targetCastbar", "endCap"} } },
	targetCastbarEmpower    = { checkboxSuffix = "targetCastbarEmpower",    tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalTargetCastbar"], sectionLabel = L["CopyMenuSection_targetCastbarEmpower"],
		paths = { {"bars", "targetCastbar", "showEmpowerStages"}, {"bars", "targetCastbar", "empowerStageLineWidth"}, {"colors", "bars", "targetCastbar", "empower"}, {"colors", "bars", "targetCastbar", "empowerStageLine"} } },
	targetCastbarText       = { checkboxSuffix = "targetCastbarText",       tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalTargetCastbar"], sectionLabel = L["CopyMenuSection_targetCastbarText"],
		paths = { {"bars", "targetCastbar", "classColor"}, {"bars", "targetCastbar", "classColorPvpOnly"}, {"bars", "targetCastbar", "classColorFriendly"}, {"bars", "targetCastbar", "castTimePrecision"}, {"bars", "targetCastbar", "durationPrecision"} } },
	targetCastbarShield     = { checkboxSuffix = "targetCastbarShield",     tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalTargetCastbar"], sectionLabel = L["CopyMenuSection_targetCastbarShield"],
		paths = { {"bars", "targetCastbar", "uninterruptibleShield"} } },
	focusCastbarDimensions  = { checkboxSuffix = "focusCastbarDimensions",  tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarDimensions"],
		paths = { {"bars", "focusCastbar", "width"}, {"bars", "focusCastbar", "height"}, {"bars", "focusCastbar", "border"}, {"bars", "focusCastbar", "xPos"}, {"bars", "focusCastbar", "yPos"}, {"bars", "focusCastbar", "anchor"}, {"bars", "focusCastbar", "fillDirection"}, {"bars", "focusCastbar", "icon"} } },
	focusCastbarColors      = { checkboxSuffix = "focusCastbarColors",      tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarColors"],
		paths = { {"bars", "focusCastbar", "interruptColor"}, {"bars", "focusCastbar", "interruptHostileOnly"}, {"colors", "bars", "focusCastbar", "bar"}, {"colors", "bars", "focusCastbar", "channel"}, {"colors", "bars", "focusCastbar", "uninterruptible"}, {"colors", "bars", "focusCastbar", "uninterruptibleBorder"}, {"colors", "bars", "focusCastbar", "border"}, {"colors", "bars", "focusCastbar", "background"}, {"colors", "bars", "focusCastbar", "endCap"} } },
	focusCastbarEmpower     = { checkboxSuffix = "focusCastbarEmpower",     tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarEmpower"],
		paths = { {"bars", "focusCastbar", "showEmpowerStages"}, {"bars", "focusCastbar", "empowerStageLineWidth"}, {"colors", "bars", "focusCastbar", "empower"}, {"colors", "bars", "focusCastbar", "empowerStageLine"} } },
	focusCastbarText        = { checkboxSuffix = "focusCastbarText",        tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarText"],
		paths = { {"bars", "focusCastbar", "classColor"}, {"bars", "focusCastbar", "classColorPvpOnly"}, {"bars", "focusCastbar", "classColorFriendly"}, {"bars", "focusCastbar", "castTimePrecision"}, {"bars", "focusCastbar", "durationPrecision"} } },
	focusCastbarShield      = { checkboxSuffix = "focusCastbarShield",      tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarShield"],
		paths = { {"bars", "focusCastbar", "uninterruptibleShield"} } },
	-- Other Bars sections live on the top-level "Other Bars" nav category. Two per bar: Dimensions
	-- (position/size) and Colors (fill/border/background/end cap + the one behaviour flag each kind
	-- has). Field-level paths so copies never clobber spec-only data.
	gcdDimensions        = { checkboxSuffix = "gcdDimensions",        tabKey = "gcd",        categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = L["CopyMenuSection_gcdDimensions"],
		paths = { {"bars", "gcd", "width"}, {"bars", "gcd", "height"}, {"bars", "gcd", "border"}, {"bars", "gcd", "xPos"}, {"bars", "gcd", "yPos"}, {"bars", "gcd", "anchor"}, {"bars", "gcd", "fillDirection"} } },
	gcdColors            = { checkboxSuffix = "gcdColors",            tabKey = "gcd",        categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = L["CopyMenuSection_gcdColors"],
		paths = { {"colors", "bars", "gcd", "bar"}, {"colors", "bars", "gcd", "border"}, {"colors", "bars", "gcd", "background"}, {"colors", "bars", "gcd", "endCap"}, {"bars", "gcd", "durationPrecision"}, {"bars", "gcd", "timerDirection"} } },
	fatigueDimensions    = { checkboxSuffix = "fatigueDimensions",    tabKey = "fatigue",    categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = L["CopyMenuSection_fatigueDimensions"],
		paths = { {"bars", "fatigue", "width"}, {"bars", "fatigue", "height"}, {"bars", "fatigue", "border"}, {"bars", "fatigue", "xPos"}, {"bars", "fatigue", "yPos"}, {"bars", "fatigue", "anchor"}, {"bars", "fatigue", "fillDirection"} } },
	fatigueColors        = { checkboxSuffix = "fatigueColors",        tabKey = "fatigue",    categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = L["CopyMenuSection_fatigueColors"],
		paths = { {"colors", "bars", "fatigue", "bar"}, {"colors", "bars", "fatigue", "border"}, {"colors", "bars", "fatigue", "background"}, {"colors", "bars", "fatigue", "endCap"}, {"bars", "fatigue", "disableBlizzardBar"} } },
	breathDimensions     = { checkboxSuffix = "breathDimensions",     tabKey = "breath",     categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = L["CopyMenuSection_breathDimensions"],
		paths = { {"bars", "breath", "width"}, {"bars", "breath", "height"}, {"bars", "breath", "border"}, {"bars", "breath", "xPos"}, {"bars", "breath", "yPos"}, {"bars", "breath", "anchor"}, {"bars", "breath", "fillDirection"} } },
	breathColors         = { checkboxSuffix = "breathColors",         tabKey = "breath",     categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = L["CopyMenuSection_breathColors"],
		paths = { {"colors", "bars", "breath", "bar"}, {"colors", "bars", "breath", "border"}, {"colors", "bars", "breath", "background"}, {"colors", "bars", "breath", "endCap"}, {"bars", "breath", "disableBlizzardBar"} } },
	-- Pet bar sections live on the top-level "Pet Bars" nav category, two per bar. Whole-table paths, not
	-- field-level: these tables carry nothing spec-only, so there is no spec data for a copy to clobber.
	petPowerDimensions   = { checkboxSuffix = "petPowerDimensions",   tabKey = "petPower",   categoryKey = "petBars", barKey = "petPower", useGlobalLabel = L["CheckboxUseGlobalPetBars"], sectionLabel = L["CopyMenuSection_petPowerDimensions"],
		paths = { {"bars", "petPower"} } },
	petPowerColors       = { checkboxSuffix = "petPowerColors",       tabKey = "petPower",   categoryKey = "petBars", barKey = "petPower", useGlobalLabel = L["CheckboxUseGlobalPetBars"], sectionLabel = L["CopyMenuSection_petPowerColors"],
		paths = { {"colors", "bars", "petPower"} } },
	petHealthDimensions  = { checkboxSuffix = "petHealthDimensions",  tabKey = "petHealth",  categoryKey = "petBars", barKey = "petHealth", useGlobalLabel = L["CheckboxUseGlobalPetBars"], sectionLabel = L["CopyMenuSection_petHealthDimensions"],
		paths = { {"bars", "petHealth"} } },
	petHealthColors      = { checkboxSuffix = "petHealthColors",      tabKey = "petHealth",  categoryKey = "petBars", barKey = "petHealth", useGlobalLabel = L["CheckboxUseGlobalPetBars"], sectionLabel = L["CopyMenuSection_petHealthColors"],
		paths = { {"colors", "bars", "petHealth"} } },
	-- The Pet Cast Bar takes the player Cast Bar's sections, less Empower and the player-only overlays.
	petCastbarDimensions    = { checkboxSuffix = "petCastbarDimensions",    tabKey = "castbar", categoryKey = "castbar", barKey = "petCastbar", useGlobalLabel = L["CheckboxUseGlobalPetCastbar"], sectionLabel = L["CopyMenuSection_petCastbarDimensions"],
		paths = { {"bars", "petCastbar", "width"}, {"bars", "petCastbar", "height"}, {"bars", "petCastbar", "border"}, {"bars", "petCastbar", "xPos"}, {"bars", "petCastbar", "yPos"}, {"bars", "petCastbar", "anchor"}, {"bars", "petCastbar", "fillDirection"}, {"bars", "petCastbar", "icon"} } },
	petCastbarColors        = { checkboxSuffix = "petCastbarColors",        tabKey = "castbar", categoryKey = "castbar", barKey = "petCastbar", useGlobalLabel = L["CheckboxUseGlobalPetCastbar"], sectionLabel = L["CopyMenuSection_petCastbarColors"],
		paths = { {"colors", "bars", "petCastbar", "bar"}, {"colors", "bars", "petCastbar", "channel"}, {"colors", "bars", "petCastbar", "uninterruptible"}, {"colors", "bars", "petCastbar", "uninterruptibleBorder"}, {"colors", "bars", "petCastbar", "border"}, {"colors", "bars", "petCastbar", "background"}, {"colors", "bars", "petCastbar", "endCap"} } },
	petCastbarOverlays      = { checkboxSuffix = "petCastbarOverlays",      tabKey = "castbar", categoryKey = "castbar", barKey = "petCastbar", useGlobalLabel = L["CheckboxUseGlobalPetCastbar"], sectionLabel = L["CopyMenuSection_petCastbarOverlays"],
		paths = { {"colors", "bars", "petCastbar", "pushback"} } },
	petCastbarText          = { checkboxSuffix = "petCastbarText",          tabKey = "castbar", categoryKey = "castbar", barKey = "petCastbar", useGlobalLabel = L["CheckboxUseGlobalPetCastbar"], sectionLabel = L["CopyMenuSection_petCastbarText"],
		paths = { {"bars", "petCastbar", "castTimePrecision"}, {"bars", "petCastbar", "durationPrecision"} } },
	petCastbarShield        = { checkboxSuffix = "petCastbarShield",        tabKey = "castbar", categoryKey = "castbar", barKey = "petCastbar", useGlobalLabel = L["CheckboxUseGlobalPetCastbar"], sectionLabel = L["CopyMenuSection_petCastbarShield"],
		paths = { {"bars", "petCastbar", "uninterruptibleShield"} } },
}

-- Swing bar sections, shaped like the GCD's plus Hide Blizzard's bar; only where the flavor has swing bars.
local swingSectionLabels = {
	mainHandSwingDimensions = L["CopyMenuSection_mainHandSwingDimensions"],
	mainHandSwingColors = L["CopyMenuSection_mainHandSwingColors"],
	offHandSwingDimensions = L["CopyMenuSection_offHandSwingDimensions"],
	offHandSwingColors = L["CopyMenuSection_offHandSwingColors"],
	rangedSwingDimensions = L["CopyMenuSection_rangedSwingDimensions"],
	rangedSwingColors = L["CopyMenuSection_rangedSwingColors"],
}
for _, key in ipairs(TRB.Classes.BarTypeRegistry.swingBarKeys) do
	globalSettingDefinitions[key .. "Dimensions"] = { checkboxSuffix = key .. "Dimensions", tabKey = key, categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = swingSectionLabels[key .. "Dimensions"],
		paths = { {"bars", key, "width"}, {"bars", key, "height"}, {"bars", key, "border"}, {"bars", key, "xPos"}, {"bars", key, "yPos"}, {"bars", key, "anchor"}, {"bars", key, "fillDirection"} } }
	globalSettingDefinitions[key .. "Colors"] = { checkboxSuffix = key .. "Colors", tabKey = key, categoryKey = "otherBars", useGlobalLabel = L["CheckboxUseGlobalOtherBars"], sectionLabel = swingSectionLabels[key .. "Colors"],
		paths = { {"colors", "bars", key, "bar"}, {"colors", "bars", key, "border"}, {"colors", "bars", key, "background"}, {"colors", "bars", key, "endCap"}, {"bars", key, "durationPrecision"}, {"bars", key, "timerDirection"}, {"bars", key, "disableBlizzardBar"} } }
end

---Sets a checkbox to tristate visual mode
---@param checkbox CheckButton # The checkbox to update
---@param state boolean|nil # true = checked, false = unchecked, nil = mixed/desaturated
local function SetCheckboxTriState(checkbox, state)
	if not checkbox then return end
	local check = checkbox:GetCheckedTexture()
	if state == true then
		checkbox:SetChecked(true)
		if check then
			check:SetDesaturated(false)
			check:SetVertexColor(1, 1, 1, 1)
		end
	elseif state == nil then
		-- Mixed/indeterminate state - show a desaturated checkmark
		checkbox:SetChecked(true)
		if check then
			check:SetDesaturated(true)
			check:SetVertexColor(0.8, 0.8, 0.8, 1)
		end
	else
		checkbox:SetChecked(false)
		if check then
			check:SetDesaturated(false)
			check:SetVertexColor(1, 1, 1, 1)
		end
	end
end

---@param settingKey string
---@return table?
function TRB.Functions.OptionsUi.GlobalSettings:GetGlobalSettingDefinition(settingKey)
	return globalSettingDefinitions[settingKey]
end

---Builds one section's Use Global row: the spec panel's checkbox with its shortcut link and Copy... button,
---or the Global panel's bulk all-specs toggle. Every section's row is built here.
---@param parent Frame
---@param controls table
---@param classId integer? # nil (or a nil specId) is the Global panel
---@param specId integer?
---@param settingKey string
---@param yCoord number
---@param options { tooltip: string?, onClick: fun()? }? # tooltip replaces the section's own; onClick replaces the layout refresh after a toggle
---@return number yCoord
---@return CheckButton? checkbox # The spec panel's Use Global box; nil on the Global panel
function TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, settingKey, yCoord, options)
	local settingKeyUpper = settingKey:gsub("^%l", string.upper)
	if classId == nil or specId == nil then
		return self:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKeyUpper, settingKey, yCoord), nil
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local lowerClassName = string.lower(className)
	yCoord = yCoord - 30
	controls.checkBoxes = controls.checkBoxes or {}
	local cb = CreateFrame("CheckButton", "TwintopResourceBar_" .. className .. "_" .. specName .. "_useGlobal_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
	controls.checkBoxes["useGlobal" .. settingKeyUpper] = cb
	cb:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	local settingDef = self:GetGlobalSettingDefinition(settingKey)
	getglobal(cb:GetName() .. "Text"):SetText(settingDef and settingDef.useGlobalLabel or L["CheckboxUseGlobal"])
	getglobal(cb:GetName() .. "Text"):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	self:BuildUseGlobalShortcutLink(cb, settingDef and settingDef.tabKey or "resourceBar", settingDef and settingDef.categoryKey or nil)
	cb.tooltip = (options and options.tooltip) or L["CheckboxUseGlobalTooltip_" .. settingKeyUpper]
	cb:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName][settingKey])
	cb:SetScript("OnClick", function(checkbox)
		local orientations = TRB.Functions.OptionsUi.Layout:SnapshotRenderedOrientations()
		TRB.Data.settings.core.global[lowerClassName][specName][settingKey] = checkbox:GetChecked()
		TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
		TRB.Functions.OptionsUi.Layout:RotateFlippedOrientations(orientations)
		if options and options.onClick then
			options.onClick()
		else
			if TRB.Frames.barGroups ~= nil then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
			end
			TRB.Data.lookupDirty = true
		end
		TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(settingKey)
	end)
	TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(cb, classId, specId, settingKey)
	return yCoord, cb
end

---Returns true if the panel being edited belongs to (or affects) the currently active spec.
---Used to guard live-preview callbacks so editing a non-active spec's settings doesn't
---trigger unnecessary or incorrect bar updates.
---@param classId integer? # Class ID of the panel being edited (nil for global panel)
---@param specId integer? # Spec ID of the panel being edited (nil for global panel)
---@return boolean
function TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId)
	if classId == nil and specId == nil then
		return true -- Global panel always affects active spec
	end
	-- A class whose display follows shapeshift forms shares live bar state across all of its specs.
	return TRB.Functions.Character:IsPanelForLiveSpec(classId, specId)
end

---Counts the specs that carry a section's Use Global flag, and how many of them have it on.
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@return integer used
---@return integer total
local function CountSpecsUsingGlobal(settingKey)
	local global = TRB.Data.settings.core.global
	local used = 0
	local total = 0

	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		local flags = global[entry.className] and global[entry.className][entry.specName]
		if flags ~= nil and flags[settingKey] ~= nil then
			total = total + 1
			if flags[settingKey] then
				used = used + 1
			end
		end
	end

	return used, total
end

---Gets the aggregate state of a global setting across all class/specs
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@return boolean|nil # true if all enabled, false if all disabled, nil if mixed
local function GetAllSpecsGlobalState(settingKey)
	local used, total = CountSpecsUsingGlobal(settingKey)
	if used == total then
		return true
	elseif used == 0 then
		return false
	else
		return nil -- Mixed state
	end
end

---Updates a bulk toggle's count of the specs using that section's global settings.
---@param checkbox CheckButton # A bulk toggle from BuildBulkGlobalToggleCheckbox
local function RefreshSpecCount(checkbox)
	local used, total = CountSpecsUsingGlobal(checkbox.settingKey)
	checkbox.specCount:SetText(string.format(L["UseGlobalSpecCountFormat"], used, total))
end

-- Clears a Use Global checkbox row, or a section header's text, above where a cover starts.
local COVER_ROW_CLEARANCE = 25

---Returns the y offset just below a frame anchored by a single TOPLEFT offset from the panel.
---@param frame Frame
---@return number
local function GetYBelow(frame)
	local _, _, _, _, y = frame:GetPoint(1)
	return (y or 0) - COVER_ROW_CLEARANCE
end

---Shows each cover and Global badge tied to a Use Global checkbox while it is checked.
---@param checkbox CheckButton
local function RefreshUseGlobalLinked(checkbox)
	if checkbox.useGlobalLinked == nil then
		return
	end
	local checked = checkbox:GetChecked() == true
	for _, linked in ipairs(checkbox.useGlobalLinked) do
		if linked.cover ~= nil then
			linked.cover:SetShown(checked)
		end
		TRB.Functions.OptionsUi.Primitives:AttachGlobalBadgeToText(linked.header.font, checked, linked.tooltip)
	end
end

---Ties a cover and header badge to a Use Global checkbox so both follow its clicks.
---@param checkbox CheckButton
---@param header Frame # Section header from BuildSectionHeader
---@param tooltip string
---@param cover Frame?
local function LinkToCheckbox(checkbox, header, tooltip, cover)
	if checkbox.useGlobalLinked == nil then
		---@diagnostic disable-next-line: inject-field
		checkbox.useGlobalLinked = {}
		checkbox:HookScript("OnClick", RefreshUseGlobalLinked)
	end
	table.insert(checkbox.useGlobalLinked, { header = header, tooltip = tooltip, cover = cover })
	RefreshUseGlobalLinked(checkbox)
end

local COVER_BUTTON_HEIGHT = 22
local COVER_BUTTON_GAP = 8

---Builds a cover carrying the Use Global message, an Open button for the checkbox's shortcut link, and a Customize button that unchecks it.
---@param checkbox CheckButton
---@param topY number
---@param bottomY number
---@return Frame
local function BuildUseGlobalCover(checkbox, topY, bottomY)
	local cover = TRB.Functions.OptionsUi.Primitives:BuildSectionCover(checkbox:GetParent(), topY, bottomY)

	local message = cover:CreateFontString(nil, "OVERLAY")
	message:SetFontObject(GameFontHighlightLarge)
	message:SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	message:SetJustifyH("CENTER")
	message:SetText(L["UseGlobalCoverText"])
	-- Raised by half the button row so the message and buttons sit centered as one block.
	local messageYOffset = (COVER_BUTTON_GAP + COVER_BUTTON_HEIGHT) / 2
	message:SetPoint("LEFT", cover, "LEFT", 20, messageYOffset)
	message:SetPoint("RIGHT", cover, "RIGHT", -20, messageYOffset)

	local customize = CreateFrame("Button", nil, cover, "UIPanelButtonTemplate")
	customize:SetText(L["UseGlobalCoverCustomize"])
	customize:SetSize(customize:GetTextWidth() + 30, COVER_BUTTON_HEIGHT)
	customize:SetScript("OnClick", function()
		checkbox:Click()
	end)

	local link = checkbox.useGlobalLink
	if link ~= nil then
		local open = CreateFrame("Button", nil, cover, "UIPanelButtonTemplate")
		open:SetText(link.coverButtonText)
		open:SetSize(open:GetTextWidth() + 30, COVER_BUTTON_HEIGHT)
		open:SetPoint("TOPRIGHT", message, "BOTTOM", -5, -COVER_BUTTON_GAP)
		open:SetScript("OnClick", function()
			link:Click()
		end)
		customize:SetPoint("TOPLEFT", message, "BOTTOM", 5, -COVER_BUTTON_GAP)
	else
		customize:SetPoint("TOP", message, "BOTTOM", 0, -COVER_BUTTON_GAP)
	end

	return cover
end

---Sets a global setting for all class/specs and updates related UI checkboxes
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@param value boolean # The value to set
local function SetAllSpecsGlobalSetting(settingKey, value)
	local global = TRB.Data.settings.core.global
	local settingDef = globalSettingDefinitions[settingKey]
	local checkboxSuffix = settingDef and settingDef.checkboxSuffix
	local orientations = TRB.Functions.OptionsUi.Layout:SnapshotRenderedOrientations()

	-- Update settings for all class/specs
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		local className = entry.className
		local specName = entry.specName
		if global[className] and global[className][specName] and global[className][specName][settingKey] ~= nil then
			global[className][specName][settingKey] = value
		end
	end
	TRB.Functions.OptionsUi.Layout:RotateFlippedOrientations(orientations)

	-- Update all existing per-spec checkboxes in the UI across ALL classes
	if checkboxSuffix then
		for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
			local frameName = "TwintopResourceBar_" .. entry.classToken .. "_" .. entry.specName .. "_useGlobal_" .. checkboxSuffix
			local checkbox = _G[frameName]
			if checkbox then
				checkbox:SetChecked(value)
				RefreshUseGlobalLinked(checkbox)
			end
		end
	end

	-- Refresh caches for all specs that have been initialized (specCache exists)
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		if TRB.Data.specCache[entry.compositeKey] then
			TRB.Functions.Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
	end

	-- Trigger bar updates for current spec
	TRB.Functions.Character:ResetCaches()
	-- RecomputeFormattedValues re-reads live API values and re-formats ALL pre-formatted
	-- display strings (resource, health, primary stats, secondary stats) using the
	-- current precision settings.  It also calls InvalidateLookupMemoization which
	-- wipes prevLookupState and sets lookupDirty, forcing every lookup string to be
	-- rebuilt from scratch on the next RefreshLookupData pass.
	-- This is the same call the per-spec precision sliders use.
	TRB.Functions.Character:RecomputeFormattedValues()
	if TRB.Frames.barGroups ~= nil then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		-- Recreate bar text frames to match potentially changed settings.
		-- FillSpecializationCacheSettings always rebuilds displayText, which can shift
		-- entry indices (e.g., globalBarText prepends global entries) or change font
		-- defaults. Without this, text frames become desynced from their entries --
		-- wrong parents, fonts, or positions -- causing bar text to vanish.
		-- This matches the sequence in ConstructBarGroups.
		TRB.Functions.BarText:CreateBarTextFrames()
		TRB.Functions.BarVisibility:MarkDirty()
		TRB.Functions.Bar:HideResourceBar()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	else
		-- All classes use the BarGroups system; this path should not be reached.
		-- ConstructBarGroups is called by each class module's ConstructResourceBar.
		if TRB.Functions.Bar.ConstructBarGroups then
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
		end
	end
end

---Builds a bulk global toggle checkbox for the Global Options panel
---@param parent Frame # Parent frame
---@param controls table # Controls table to store the checkbox
---@param controlKey string # Key to store in controls.checkBoxes
---@param settingKey string # The global setting key (e.g., "bar", "comboPoints")
---@param yCoord number # Y coordinate for positioning
---@param customLabel string? # Optional custom label text
---@param customTooltip string? # Optional custom tooltip text
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, controlKey, settingKey, yCoord, customLabel, customTooltip)
	local f = nil

	yCoord = yCoord - 30
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes[controlKey] = CreateFrame("CheckButton", "TwintopResourceBar_Global_enableAll_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[controlKey]
	f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(customLabel or L["CheckboxEnableForAllSpecs"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	f.tooltip = customTooltip or L["CheckboxEnableForAllSpecsTooltip"]

	-- Set initial tristate based on current values
	local currentState = GetAllSpecsGlobalState(settingKey)
	SetCheckboxTriState(f, currentState)

	-- Store the setting key for the click handler
	f.settingKey = settingKey

	---@diagnostic disable-next-line: inject-field
	f.specCount = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.specCount:SetTextColor(0.75, 0.75, 0.75)
	-- The template's label keeps its own width, so sit past the rendered text rather than its right edge.
	f.specCount:SetPoint("LEFT", f, "RIGHT", getglobal(f:GetName() .. 'Text'):GetStringWidth() + 14, 0)
	RefreshSpecCount(f)

	f:SetScript("OnClick", function(self, ...)
		-- Get current tristate: Unchecked->Checked, Mixed->Checked, Checked->Unchecked
		local currentState = GetAllSpecsGlobalState(self.settingKey)
		local newValue
		if currentState == true then
			newValue = false
		else
			-- Both false and nil (mixed) go to true
			newValue = true
		end

		SetAllSpecsGlobalSetting(self.settingKey, newValue)

		-- Update this checkbox's visual state
		SetCheckboxTriState(self, newValue)
		RefreshSpecCount(self)
	end)

	-- Add a "Copy..." button next to the bulk-toggle checkbox so users can
	-- push Global -> a single spec or pull a single spec -> Global without
	-- using the all-specs bulk apply.
	if TRB.Functions.OptionsUi.GlobalCopy and TRB.Functions.OptionsUi.GlobalCopy.BuildGlobalBulkCopyButton then
		TRB.Functions.OptionsUi.GlobalCopy:BuildGlobalBulkCopyButton(f, settingKey)
	end

	return yCoord
end

---Refreshes the bulk global toggle checkbox state based on current per-spec settings
---Call this after changing a per-spec "Use global settings" checkbox
---@param settingKey string # The global setting key (e.g., "bar", "comboPoints", "textures")
function TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(settingKey)
	local frameName = "TwintopResourceBar_Global_enableAll_" .. settingKey
	local checkbox = _G[frameName]
	if checkbox then
		local currentState = GetAllSpecsGlobalState(settingKey)
		SetCheckboxTriState(checkbox, currentState)
		RefreshSpecCount(checkbox)
	end
end

---Creates a teal hyperlink-style text button anchored to the right of a "Use global settings" checkbox.
---Clicking the link navigates to the Global Options panel (or another top-level category, e.g. the
---Castbar screen) and selects the corresponding tab.
---@param checkbox CheckButton The "Use global settings" checkbox to attach the link to
---@param globalTabKey string The tab key to navigate to (e.g., "resourceBar", "barTextures", "castbar")
---@param categoryKey string? The top-level nav category holding the tab (defaults to "global")
---@return Button|nil link The created link button, or nil when the checkbox has no text region
function TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(checkbox, globalTabKey, categoryKey)
	local textRegion = _G[checkbox:GetName() .. "Text"]
	if not textRegion then
		return nil
	end

	-- The Castbar and Other Bars categories have their own wording so it's clear the link opens that
	-- screen, not the normal Global Options frame.
	local navKey = categoryKey or "global"
	local linkText = L["OpenGlobalSettings"]
	local linkTooltip = L["OpenGlobalSettingsTooltip"]
	local coverButtonText = L["UseGlobalCoverOpenGlobal"]
	if navKey == "castbar" then
		linkText = L["OpenGlobalCastbarSettings"]
		linkTooltip = L["OpenGlobalCastbarSettingsTooltip"]
		coverButtonText = L["UseGlobalCoverOpenGlobalCastbar"]
	elseif navKey == "otherBars" then
		linkText = L["OpenGlobalOtherBarsSettings"]
		linkTooltip = L["OpenGlobalOtherBarsSettingsTooltip"]
		coverButtonText = L["OpenGlobalOtherBarsSettings"]
	elseif navKey == "petBars" then
		linkText = L["OpenGlobalPetBarsSettings"]
		linkTooltip = L["OpenGlobalPetBarsSettingsTooltip"]
		coverButtonText = L["OpenGlobalPetBarsSettings"]
	end

	local link = CreateFrame("Button", nil, checkbox)
	link:SetNormalFontObject("GameFontNormalSmall")
	link:SetHighlightFontObject("GameFontHighlightSmall")
	link:SetText(linkText)
	link:GetFontString():SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	link:SetWidth(link:GetFontString():GetStringWidth() + 4)
	link:SetHeight(16)
	link:SetPoint("LEFT", textRegion, "RIGHT", 8, 0)
	link.tooltip = linkTooltip
	---@diagnostic disable-next-line: inject-field
	link.coverButtonText = coverButtonText
	---@diagnostic disable-next-line: inject-field
	checkbox.useGlobalLink = link

	link:SetScript("OnEnter", function(self)
		self:GetFontString():SetTextColor(1, 1, 1)
		SetCursor("Interface\\CURSOR\\vehichleCursor.PNG")
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
---@diagnostic disable-next-line: param-type-mismatch
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)

	link:SetScript("OnLeave", function(self)
		self:GetFontString():SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		SetCursor(nil)
		GameTooltip:Hide()
	end)

	local tabNamePrefix = navKey:gsub("^%l", string.upper)
	link:SetScript("OnClick", function()
		if TRB.Options.OptionsFrame then
			TRB.Options.OptionsFrame:SelectCategory(navKey)
			C_Timer.After(0, function()
				TRB.Functions.OptionsUi.Tabs:SwitchToTabByNamePrefix(tabNamePrefix, globalTabKey)
			end)
		end
	end)

	return link
end

---Covers a section's controls from below its Use Global row down to bottomY, and badges its header, while the box is checked.
---@param checkbox CheckButton? # nil on the Global panel, which gets no cover
---@param header Frame # The section's header from BuildSectionHeader
---@param bottomY number # Y offset of the section's end from the panel's TOPLEFT
function TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(checkbox, header, bottomY)
	if checkbox == nil then
		return
	end
	LinkToCheckbox(checkbox, header, L["UseGlobalBadgeTooltip"], BuildUseGlobalCover(checkbox, GetYBelow(checkbox), bottomY))
end

---Covers a section whose settings follow another section's Use Global box, from below its own header down to bottomY.
---@param checkbox CheckButton? # The governing section's box; nil on the Global panel
---@param governingHeader Frame # The governing section's header, named in the badge tooltip
---@param header Frame # This section's header
---@param bottomY number # Y offset of the section's end from the panel's TOPLEFT
function TRB.Functions.OptionsUi.GlobalSettings:AttachLinkedUseGlobalCover(checkbox, governingHeader, header, bottomY)
	if checkbox == nil then
		return
	end
	local tooltip = string.format(L["UseGlobalBadgeTooltipLinkedFormat"], governingHeader.font:GetText())
	LinkToCheckbox(checkbox, header, tooltip, BuildUseGlobalCover(checkbox, GetYBelow(header), bottomY))
end

---Badges a section's header while its Use Global box is checked, for a section the global settings only partly cover.
---@param checkbox CheckButton? # nil on the Global panel
---@param header Frame # The section's header from BuildSectionHeader
---@param tooltip string # Which parts of the section follow the global settings
function TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalBadge(checkbox, header, tooltip)
	if checkbox == nil then
		return
	end
	LinkToCheckbox(checkbox, header, tooltip, nil)
end

