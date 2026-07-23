---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.GlobalSettings = TRB.Functions.OptionsUi.GlobalSettings or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/255
end

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
	focusCastbarDimensions  = { checkboxSuffix = "focusCastbarDimensions",  tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarDimensions"],
		paths = { {"bars", "focusCastbar", "width"}, {"bars", "focusCastbar", "height"}, {"bars", "focusCastbar", "border"}, {"bars", "focusCastbar", "xPos"}, {"bars", "focusCastbar", "yPos"}, {"bars", "focusCastbar", "anchor"}, {"bars", "focusCastbar", "fillDirection"}, {"bars", "focusCastbar", "icon"} } },
	focusCastbarColors      = { checkboxSuffix = "focusCastbarColors",      tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarColors"],
		paths = { {"bars", "focusCastbar", "interruptColor"}, {"bars", "focusCastbar", "interruptHostileOnly"}, {"colors", "bars", "focusCastbar", "bar"}, {"colors", "bars", "focusCastbar", "channel"}, {"colors", "bars", "focusCastbar", "uninterruptible"}, {"colors", "bars", "focusCastbar", "uninterruptibleBorder"}, {"colors", "bars", "focusCastbar", "border"}, {"colors", "bars", "focusCastbar", "background"}, {"colors", "bars", "focusCastbar", "endCap"} } },
	focusCastbarEmpower     = { checkboxSuffix = "focusCastbarEmpower",     tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarEmpower"],
		paths = { {"bars", "focusCastbar", "showEmpowerStages"}, {"bars", "focusCastbar", "empowerStageLineWidth"}, {"colors", "bars", "focusCastbar", "empower"}, {"colors", "bars", "focusCastbar", "empowerStageLine"} } },
	focusCastbarText        = { checkboxSuffix = "focusCastbarText",        tabKey = "castbar", categoryKey = "castbar", useGlobalLabel = L["CheckboxUseGlobalFocusCastbar"], sectionLabel = L["CopyMenuSection_focusCastbarText"],
		paths = { {"bars", "focusCastbar", "classColor"}, {"bars", "focusCastbar", "classColorPvpOnly"}, {"bars", "focusCastbar", "classColorFriendly"}, {"bars", "focusCastbar", "castTimePrecision"}, {"bars", "focusCastbar", "durationPrecision"} } },
}

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
	-- Druids share bar settings across all forms/specs
	if TRB.Data.character.classId == 11 then
		return true
	end
	return TRB.Data.character.classId == classId and TRB.Data.character.specId == specId
end

---Gets the aggregate state of a global setting across all class/specs
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@return boolean|nil # true if all enabled, false if all disabled, nil if mixed
local function GetAllSpecsGlobalState(settingKey)
	local global = TRB.Data.settings.core.global
	local allTrue = true
	local allFalse = true

	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		local className = entry.className
		local specName = entry.specName
		if global[className] and global[className][specName] and global[className][specName][settingKey] ~= nil then
			if global[className][specName][settingKey] then
				allFalse = false
			else
				allTrue = false
			end
		end
	end

	if allTrue then
		return true
	elseif allFalse then
		return false
	else
		return nil -- Mixed state
	end
end

---Sets a global setting for all class/specs and updates related UI checkboxes
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@param value boolean # The value to set
local function SetAllSpecsGlobalSetting(settingKey, value)
	local global = TRB.Data.settings.core.global
	local settingDef = globalSettingDefinitions[settingKey]
	local checkboxSuffix = settingDef and settingDef.checkboxSuffix

	-- Update settings for all class/specs
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		local className = entry.className
		local specName = entry.specName
		if global[className] and global[className][specName] and global[className][specName][settingKey] ~= nil then
			global[className][specName][settingKey] = value
		end
	end

	-- Update all existing per-spec checkboxes in the UI across ALL classes
	if checkboxSuffix then
		for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
			local frameName = "TwintopResourceBar_" .. entry.classToken .. "_" .. entry.specName .. "_useGlobal_" .. checkboxSuffix
			local checkbox = _G[frameName]
			if checkbox then
				checkbox:SetChecked(value)
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
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	f.tooltip = customTooltip or L["CheckboxEnableForAllSpecsTooltip"]

	-- Set initial tristate based on current values
	local currentState = GetAllSpecsGlobalState(settingKey)
	SetCheckboxTriState(f, currentState)

	-- Store the setting key for the click handler
	f.settingKey = settingKey

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
	end
end

---Creates a teal hyperlink-style text button anchored to the right of a "Use global settings" checkbox.
---Clicking the link navigates to the Global Options panel (or another top-level category, e.g. the
---Castbar screen) and selects the corresponding tab.
---@param checkbox CheckButton The "Use global settings" checkbox to attach the link to
---@param globalTabKey string The tab key to navigate to (e.g., "resourceBar", "barTextures", "castbar")
---@param categoryKey string? The top-level nav category holding the tab (defaults to "global")
function TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(checkbox, globalTabKey, categoryKey)
	local textRegion = _G[checkbox:GetName() .. "Text"]
	if not textRegion then
		return
	end

	-- The Castbar category has its own wording so it's clear the link opens the Cast Bar
	-- screen, not the normal Global Options frame.
	local navKey = categoryKey or "global"
	local linkText = navKey == "castbar" and L["OpenGlobalCastbarSettings"] or L["OpenGlobalSettings"]
	local linkTooltip = navKey == "castbar" and L["OpenGlobalCastbarSettingsTooltip"] or L["OpenGlobalSettingsTooltip"]

	local link = CreateFrame("Button", nil, checkbox)
	link:SetNormalFontObject("GameFontNormalSmall")
	link:SetHighlightFontObject("GameFontHighlightSmall")
	link:SetText(linkText)
	link:GetFontString():SetTextColor(GetUseGlobalSettingsColor())
	link:SetWidth(link:GetFontString():GetStringWidth() + 4)
	link:SetHeight(16)
	link:SetPoint("LEFT", textRegion, "RIGHT", 8, 0)
	link.tooltip = linkTooltip

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
		self:GetFontString():SetTextColor(GetUseGlobalSettingsColor())
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
end

