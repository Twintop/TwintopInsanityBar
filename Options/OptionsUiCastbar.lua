---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Castbar = TRB.Functions.OptionsUi.Castbar or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Castbar options panel (single central tab, injected into every spec by BuildTabGroup,
-- plus the global core-scope version hosted on the top-level Castbar screen)
-- ============================================================================

-- Specs with empowered abilities; only these (and the Global panel) get the Empower Level Colors section.
local empowerSpecs = {
	deathknight = { blood = true },
	monk = { windwalker = true },
	evoker = { devastation = true, preservation = true, augmentation = true },
}

---Whether the given spec uses empowered abilities (drives the Empower Level Colors section).
---@param classId integer
---@param specId integer
---@return boolean
function TRB.Functions.OptionsUi.Castbar:SpecUsesEmpower(classId, specId)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local byClass = className ~= nil and empowerSpecs[className] or nil
	return (byClass ~= nil and specName ~= nil and byClass[specName]) == true
end

---Composes a human-readable summary of the configured tick profiles.
---@param tickProfiles table<integer, table>
---@return string
local function ComposeTickSummary(tickProfiles)
	if type(tickProfiles) ~= "table" then
		return L["CastbarTickRatesEmpty"]
	end
	local ids = {}
	for id in pairs(tickProfiles) do
		ids[#ids + 1] = id
	end
	if #ids == 0 then
		return L["CastbarTickRatesEmpty"]
	end
	table.sort(ids)
	local lines = {}
	for _, id in ipairs(ids) do
		local p = tickProfiles[id]
		local spellName = ""
		local info = C_Spell.GetSpellInfo(id)
		if info and info.name then spellName = info.name end
		if p.mode == "fixedCount" then
			lines[#lines + 1] = string.format("%d %s: %s, %.2fs, %d ticks%s", id, spellName,
				L["CastbarTickModeFixedCountShort"], p.baseDuration or 0, p.tickCount or 0, p.chains and (" +" .. L["CastbarTickChainsShort"]) or "")
		else
			lines[#lines + 1] = string.format("%d %s: %s, %.2fs, %.2fs/tick%s", id, spellName,
				L["CastbarTickModeFixedRateShort"], p.baseDuration or 0, p.baseTickRate or 0, p.chains and (" +" .. L["CastbarTickChainsShort"]) or "")
		end
	end
	return table.concat(lines, "\n")
end

-- Global-panel edits to value-copied primitives (precisions, empowerSegmentedFill) reach the active
-- spec's merged cache only via a re-fill when its use-global flag is set.
local function RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
	if not isGlobalPanel then
		return
	end
	local char = TRB.Data.character
	if char ~= nil and char.className ~= nil and char.specName ~= nil and TRB.Data.specCache[char.compositeKey] ~= nil then
		TRB.Functions.Character:FillSpecializationCacheSettings(char.className, char.specName)
	end
end

-- Builds one castbar section's global-settings row: a "Use global settings" checkbox with shortcut
-- link and Copy... button on spec panels, or a bulk all-specs toggle (with Copy...) on the Global panel.
---@return number yCoord
local function BuildCastbarUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, settingKey, yCoord)
	local settingKeyUpper = settingKey:gsub("^%l", string.upper)
	if classId ~= nil then
		yCoord = yCoord - 30
		local classToken = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		controls.checkBoxes = controls.checkBoxes or {}
		local cb = CreateFrame("CheckButton", "TwintopResourceBar_" .. classToken .. "_" .. specName .. "_useGlobal_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
		controls.checkBoxes["useGlobal" .. settingKeyUpper] = cb
		cb:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		local settingDef = TRB.Functions.OptionsUi.GlobalSettings:GetGlobalSettingDefinition(settingKey)
		getglobal(cb:GetName() .. 'Text'):SetText(settingDef and settingDef.useGlobalLabel or L["CheckboxUseGlobal"])
		getglobal(cb:GetName() .. 'Text'):SetTextColor(100/255, 225/255, 200/255)
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(cb, "castbar", "castbar")
		cb.tooltip = L["CheckboxUseGlobalTooltip_" .. settingKeyUpper]
		cb:SetChecked(TRB.Data.settings.core.global[classNameLower][specName][settingKey])
		cb:SetScript("OnClick", function(self)
			TRB.Data.settings.core.global[classNameLower][specName][settingKey] = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(classNameLower, specName)

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
			TRB.Data.lookupDirty = true
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(settingKey)
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(cb, classId, specId, settingKey)
	else
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKeyUpper, settingKey, yCoord)
	end
	return yCoord
end

---Constructs the castbar options panel for a spec, or the global (core-scope) version when
---classId/specId are nil.
---@param parent Frame # The tab's scroll child
---@param classId integer?
---@param specId integer?
---@param showEmpower boolean? # Whether to build the Empower Level Colors section
function TRB.Functions.OptionsUi.Castbar:ConstructPanel(parent, classId, specId, showEmpower)
	if parent == nil then
		return
	end
	local isGlobalPanel = classId == nil
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec, controlsKey
	if isGlobalPanel then
		spec = TRB.Data.settings.core
		controlsKey = "castbarGlobal"
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
		controlsKey = classNameLower .. "_" .. specName
	end
	if spec == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[controlsKey] = interfaceSettingsFrame.controls[controlsKey] or {}
	local controls = interfaceSettingsFrame.controls[controlsKey]
	controls.colors = controls.colors or {}
	controls.castbar = controls.castbar or {}
	local cc = controls.castbar
	cc.fill = {}
	cc.overlay = {}
	cc.empower = {}

	local castbarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("castbar")
	local barSettings = spec.bars and spec.bars.castbar
	local colors = spec.colors and spec.colors.bars and spec.colors.bars.castbar
	if castbarDef == nil or barSettings == nil or colors == nil then
		return
	end

	local namePrefix = "TwintopResourceBar_" .. controlsKey .. "_castbar"
	local yCoord = 5

	-- Enabling/visibility lives on each spec's Visibility tab (displayBar.castbar); this panel only
	-- configures appearance.

	-- Dimensions / anchoring (reuses the shared custom-bar dimensions generator, which also builds
	-- the castbarDimensions use-global / bulk-toggle row)
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, castbarDef, L["ResourceCastbar"], "castbarDimensions")
	yCoord = yCoord - 60

	-- Fill colors
	controls.castbarColorSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarColorsHeader"], oUi.xCoord, yCoord)
	yCoord = BuildCastbarUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, "castbarColors", yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "bar", L["CastbarColorCast"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "channel", L["CastbarColorChannel"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "uninterruptible", L["CastbarColorUninterruptible"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId)
	yCoord = yCoord - 40

	-- Overlays (latency / pushback / tick): each has an enable checkbox + color swatch
	controls.castbarOverlaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarOverlaysHeader"], oUi.xCoord, yCoord)
	yCoord = BuildCastbarUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, "castbarOverlays", yCoord)
	yCoord = yCoord - 30
	colors.latency = colors.latency
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_latencyEnable", L["CastbarLatencyEnable"], L["CastbarLatencyEnableTooltip"], yCoord,
		function() return colors.latency.enabled end, function(v) colors.latency.enabled = v end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "latency", L["CastbarColorLatency"], yCoord, classId, specId)
	yCoord = yCoord - 30
	colors.pushback = colors.pushback
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_pushbackEnable", L["CastbarPushbackEnable"], L["CastbarPushbackEnableTooltip"], yCoord,
		function() return colors.pushback.enabled end, function(v) colors.pushback.enabled = v end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "pushback", L["CastbarColorPushback"], yCoord, classId, specId)
	yCoord = yCoord - 30
	colors.tick = colors.tick
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickEnable", L["CastbarTickEnable"], L["CastbarTickEnableTooltip"], yCoord,
		function() return colors.tick.enabled end, function(v) colors.tick.enabled = v end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "tick", L["CastbarColorTick"], yCoord, classId, specId)
	yCoord = yCoord - 40

	-- Tick / empower boundary line thickness (mirrors the threshold line width control).
	controls.castbarTickWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["CastbarTickWidth"], 1, 10, barSettings.tickWidth, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.castbarTickWidth:SetScript("OnValueChanged", function(sliderFrame, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
		barSettings.tickWidth = value
		RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
	end)
	yCoord = yCoord - 60
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickLatencyWidth", L["CastbarTickLatencyWidth"], L["CastbarTickLatencyWidthTooltip"], yCoord,
		function() return barSettings.tickLatencyWidth end,
		function(v)
			barSettings.tickLatencyWidth = v
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
		end)
	yCoord = yCoord - 40

	-- Empower fill colors: absolute per-level (base while charging toward Level I, then Level I..IV as
	-- reached). Only built for specs with empowered abilities (and the Global panel).
	if showEmpower then
		controls.castbarEmpowerSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarEmpowerHeader"], oUi.xCoord, yCoord)
		yCoord = BuildCastbarUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, "castbarEmpower", yCoord)
		yCoord = yCoord - 30
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_empowerSegmentedFill", L["CastbarEmpowerSegmentedFill"], L["CastbarEmpowerSegmentedFillTooltip"], yCoord,
			function() return barSettings.empowerSegmentedFill end,
			function(v)
				barSettings.empowerSegmentedFill = v
				RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
			end)
		colors.empowerStages = colors.empowerStages
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.empower, colors.empowerStages, "base", L["CastbarColorEmpowerBase"], yCoord, classId, specId)
		yCoord = yCoord - 30
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.empower, colors.empowerStages, "level1", L["CastbarColorEmpowerLevel1"], yCoord, classId, specId)
		yCoord = yCoord - 30
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.empower, colors.empowerStages, "level2", L["CastbarColorEmpowerLevel2"], yCoord, classId, specId)
		yCoord = yCoord - 30
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.empower, colors.empowerStages, "level3", L["CastbarColorEmpowerLevel3"], yCoord, classId, specId)
		yCoord = yCoord - 30
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.empower, colors.empowerStages, "level4", L["CastbarColorEmpowerLevel4"], yCoord, classId, specId)
		yCoord = yCoord - 40
	end

	-- Additional settings: Blizzard cast bar handling + timer text precision (castbar-specific,
	-- independent of the shared timer precision settings)
	controls.castbarTimerSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarTimersHeader"], oUi.xCoord, yCoord)
	yCoord = BuildCastbarUseGlobalRow(parent, controls, classId, specId, classNameLower, specName, "castbarText", yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_disableBlizzardCastbar", L["CastbarDisableBlizzard"], L["CastbarDisableBlizzardTooltip"], yCoord,
		function() return barSettings.disableBlizzardCastbar end,
		function(v)
			barSettings.disableBlizzardCastbar = v
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
			TRB.Functions.Castbar:UpdateBlizzardCastbarVisibility()
		end)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_mergeTradeskill", L["CastbarMergeTradeskill"], L["CastbarMergeTradeskillTooltip"], yCoord,
		function() return barSettings.mergeTradeskill end,
		function(v)
			barSettings.mergeTradeskill = v
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
		end)
	yCoord = yCoord - 40
	local function BuildPrecisionSlider(label, settingKey, xCoord, y)
		local slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, label, 0, 3, barSettings[settingKey], 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, xCoord, y)
		slider:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			barSettings[settingKey] = value
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
			TRB.Data.lookupDirty = true
		end)
		return slider
	end
	controls.castbarCastTimePrecision = BuildPrecisionSlider(L["CastbarCastTimePrecision"], "castTimePrecision", oUi.xCoord, yCoord)
	controls.castbarDurationPrecision = BuildPrecisionSlider(L["CastbarDurationPrecision"], "durationPrecision", oUi.xCoord2, yCoord)
	yCoord = yCoord - 60
	controls.castbarLatencyPrecision = BuildPrecisionSlider(L["CastbarLatencyPrecision"], "latencyPrecision", oUi.xCoord, yCoord)
	yCoord = yCoord - 60

	--[[
	-- Tick-rate editor (built-in table + editable list)
	barSettings.tickProfiles = barSettings.tickProfiles or {}
	controls.castbarTickSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarTickRatesHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 24
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["CastbarTickRatesHelp"], oUi.xCoord, yCoord, 700, 30)
	yCoord = yCoord - 40

	local summaryLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, ComposeTickSummary(barSettings.tickProfiles), oUi.xCoord, yCoord, 700, 160, nil, "LEFT")
	local function RefreshSummary()
		summaryLabel.font:SetText(ComposeTickSummary(barSettings.tickProfiles))
	end
	yCoord = yCoord - 170

	-- Add / edit form
	local spellIdBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(parent, "", 10, 90, 20, oUi.xCoord + 90, yCoord)
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["CastbarTickAddSpellId"], oUi.xCoord, yCoord - 4, 85, 20)
	yCoord = yCoord - 28
	local durationBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(parent, "", 6, 90, 20, oUi.xCoord + 90, yCoord)
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["CastbarTickBaseDuration"], oUi.xCoord, yCoord - 4, 85, 20)
	yCoord = yCoord - 28
	local countBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(parent, "", 4, 90, 20, oUi.xCoord + 90, yCoord)
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["CastbarTickCount"], oUi.xCoord, yCoord - 4, 85, 20)
	yCoord = yCoord - 28
	local rateBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(parent, "", 6, 90, 20, oUi.xCoord + 90, yCoord)
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["CastbarTickBaseRate"], oUi.xCoord, yCoord - 4, 85, 20)
	yCoord = yCoord - 30

	local fixedCountChecked = { value = true }
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickMode", L["CastbarTickModeFixedCount"], L["CastbarTickModeFixedCountTooltip"], yCoord,
		function() return fixedCountChecked.value end, function(v) fixedCountChecked.value = v end)
	yCoord = yCoord - 26
	local chainsChecked = { value = false }
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickChains", L["CastbarTickChains"], L["CastbarTickChainsTooltip"], yCoord,
		function() return chainsChecked.value end, function(v) chainsChecked.value = v end)
	yCoord = yCoord - 26
	local firstTickChecked = { value = false }
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickFirst", L["CastbarTickFirstAtStart"], L["CastbarTickFirstAtStartTooltip"], yCoord,
		function() return firstTickChecked.value end, function(v) firstTickChecked.value = v end)
	yCoord = yCoord - 30

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["CastbarTickAdd"], oUi.xCoord, yCoord, 120, 22)
	addButton:SetScript("OnClick", function()
		local id = tonumber(spellIdBox:GetText())
		if id == nil or id <= 0 then return end
		local duration = tonumber(durationBox:GetText()) or 0
		local profile = {
			mode = fixedCountChecked.value and "fixedCount" or "fixedRate",
			baseDuration = duration,
			chains = chainsChecked.value,
			firstTickAtStart = firstTickChecked.value,
		}
		if fixedCountChecked.value then
			profile.tickCount = math.floor(tonumber(countBox:GetText()) or 0)
		else
			profile.baseTickRate = tonumber(rateBox:GetText()) or 0
		end
		barSettings.tickProfiles[id] = profile
		RefreshSummary()
	end)

	local removeButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["CastbarTickRemove"], oUi.xCoord + 130, yCoord, 120, 22)
	removeButton:SetScript("OnClick", function()
		local id = tonumber(spellIdBox:GetText())
		if id ~= nil then
			barSettings.tickProfiles[id] = nil
			RefreshSummary()
		end
	end)
	yCoord = yCoord - 30]]

	return yCoord
end
