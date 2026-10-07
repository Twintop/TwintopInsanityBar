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

---Whether the given spec uses empowered abilities (drives the Empower Level Colors section). Only
---specs whose descriptor declares `empowerCastbar` (and the Global panel) get the section.
---@param classId integer
---@param specId integer
---@return boolean
function TRB.Functions.OptionsUi.Castbar:SpecUsesEmpower(classId, specId)
	local descriptor = TRB.Functions.Character:GetSpecDescriptor(classId, specId)
	return descriptor ~= nil and descriptor.empowerCastbar == true
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

---Builds the Pet Cast Bar's Additional Settings: cast time and duration text precision.
---@param parent Frame
---@param controls table
---@param classId integer?
---@param specId integer?
---@param yCoord number
---@param barKey string
---@param barSettings table
---@param isGlobalPanel boolean
---@return number yCoord
function TRB.Functions.OptionsUi.Castbar:ConstructPetTimerSection(parent, controls, classId, specId, yCoord, barKey, barSettings, isGlobalPanel)
	controls[barKey .. "TimerSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarTimersHeader"], oUi.xCoord, yCoord)
	local textCheckbox
	yCoord, textCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, barKey .. "Text", yCoord)
	yCoord = yCoord - 40
	local function BuildPrecisionSlider(label, settingKey, xCoord)
		local slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, label, 0, 3, barSettings[settingKey], 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, xCoord, yCoord)
		slider:SetScript("OnValueChanged", function(sliderFrame, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			sliderFrame.EditBox:SetText(value)
			barSettings[settingKey] = value
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
			TRB.Data.lookupDirty = true
		end)
		return slider
	end
	controls[barKey .. "CastTimePrecision"] = BuildPrecisionSlider(L["CastbarCastTimePrecision"], "castTimePrecision", oUi.xCoord)
	controls[barKey .. "DurationPrecision"] = BuildPrecisionSlider(L["CastbarDurationPrecision"], "durationPrecision", oUi.xCoord2)
	yCoord = yCoord - 60
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(textCheckbox, controls[barKey .. "TimerSection"], yCoord)
	return yCoord
end

---Constructs a cast bar's options panel for a spec, or the global (core-scope) version when classId/specId
---are nil. The Pet Cast Bar's leaves out the rows only the player's casts have.
---@param parent Frame # The tab's scroll child
---@param classId integer?
---@param specId integer?
---@param showEmpower boolean? # Whether to build the Empower Level Colors section
---@param barKey string? # "castbar" (the default) or "petCastbar"
function TRB.Functions.OptionsUi.Castbar:ConstructPanel(parent, classId, specId, showEmpower, barKey)
	if parent == nil then
		return
	end
	barKey = barKey or "castbar"
	local isPlayer = barKey == "castbar"
	local barKeyUpper = barKey:gsub("^%l", string.upper)
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
	controls[barKey] = controls[barKey] or {}
	local cc = controls[barKey]
	cc.fill = {}
	cc.overlay = {}
	cc.empower = {}

	local castbarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(barKey)
	local barSettings = spec.bars and spec.bars[barKey]
	local colors = spec.colors and spec.colors.bars and spec.colors.bars[barKey]
	if castbarDef == nil or barSettings == nil or colors == nil then
		return
	end

	local namePrefix = "TwintopResourceBar_" .. controlsKey .. "_" .. barKey
	local yCoord = 5

	-- Enabling/visibility lives on each spec's Visibility tab (displayBar[barKey]); this panel only
	-- configures appearance.

	-- Dimensions / anchoring (reuses the shared custom-bar dimensions generator, which also builds
	-- the castbarDimensions use-global / bulk-toggle row)
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, castbarDef,
		isPlayer and L["ResourcePlayerCastbar"] or L["ResourcePetCastbar"], barKey .. "Dimensions")
	yCoord = yCoord - 60

	-- Side ability icon (generic; copied under the castbarDimensions global-settings section)
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarIconOptions(parent, controls, spec, classId, specId, yCoord, castbarDef)
	yCoord = yCoord - 20
	TRB.Functions.OptionsUi.GlobalSettings:AttachLinkedUseGlobalCover(controls.checkBoxes["useGlobal" .. barKeyUpper .. "Dimensions"], controls[castbarDef.key .. "DimensionsSection"], controls[castbarDef.key .. "IconSection"], yCoord)

	-- Uninterruptible shield (its own global-settings section, decoupled from the icon)
	controls[barKey .. "ShieldSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarIconShieldHeader"], oUi.xCoord, yCoord)
	local shieldCheckbox
	yCoord, shieldCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, barKey .. "Shield", yCoord)
	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCastbarShieldOptions(parent, controls, spec, classId, specId, yCoord, castbarDef)
	yCoord = yCoord - 20
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(shieldCheckbox, controls[barKey .. "ShieldSection"], yCoord)

	-- Fill colors
	controls[barKey .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarColorsHeader"], oUi.xCoord, yCoord)
	local colorsCheckbox
	yCoord, colorsCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, barKey .. "Colors", yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "bar", L["CastbarColorCast"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "channel", L["CastbarColorChannel"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "uninterruptible", L["CastbarColorUninterruptible"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "uninterruptibleBorder", L["CastbarColorUninterruptibleBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId)
	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colors, controlsKey .. "_" .. barKey, "endCap" .. barKeyUpper, L["EndCap"], classId, specId)
	yCoord = yCoord - 40
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(colorsCheckbox, controls[barKey .. "ColorSection"], yCoord)

	-- Overlays (latency / pushback / tick): each has an enable checkbox + color swatch. A pet has no latency,
	-- so its section skips the latency zone and latency-sized ticks.
	controls[barKey .. "OverlaySection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarOverlaysHeader"], oUi.xCoord, yCoord)
	local overlaysCheckbox
	yCoord, overlaysCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, barKey .. "Overlays", yCoord)
	yCoord = yCoord - 30
	if isPlayer then
		colors.latency = colors.latency
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_latencyEnable", L["CastbarLatencyEnable"], L["CastbarLatencyEnableTooltip"], yCoord,
			function() return colors.latency.enabled end, function(v) colors.latency.enabled = v end)
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "latency", L["CastbarColorLatency"], yCoord, classId, specId)
		yCoord = yCoord - 30
	end
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
	local tickWidthSlider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["CastbarTickWidth"], 1, 10, barSettings.tickWidth, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barKey .. "TickWidth"] = tickWidthSlider
	tickWidthSlider:SetScript("OnValueChanged", function(sliderFrame, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
		barSettings.tickWidth = value
		RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
	end)
	if not isPlayer then
		yCoord = yCoord - 60
		TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(overlaysCheckbox, controls[barKey .. "OverlaySection"], yCoord)
		return self:ConstructPetTimerSection(parent, controls, classId, specId, yCoord, barKey, barSettings, isGlobalPanel)
	end
	-- Tick width is driven by latency when tickLatencyWidth is on, so gray out the manual slider then.
	TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(tickWidthSlider, not barSettings.tickLatencyWidth)
	yCoord = yCoord - 50
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickLatencyWidth", L["CastbarTickLatencyWidth"], L["CastbarTickLatencyWidthTooltip"], yCoord,
		function() return barSettings.tickLatencyWidth end,
		function(v)
			barSettings.tickLatencyWidth = v
			TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(tickWidthSlider, not v)
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
		end)
	yCoord = yCoord - 40
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(overlaysCheckbox, controls[barKey .. "OverlaySection"], yCoord)

	-- Empower fill colors: absolute per-level (base while charging toward Level I, then Level I..IV as
	-- reached). Only built for specs with empowered abilities (and the Global panel).
	if showEmpower then
		controls.castbarEmpowerSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarEmpowerHeader"], oUi.xCoord, yCoord)
		local empowerCheckbox
		yCoord, empowerCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, "castbarEmpower", yCoord)
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
		TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(empowerCheckbox, controls.castbarEmpowerSection, yCoord)
	end

	-- Additional settings: Blizzard cast bar handling + timer text precision (castbar-specific,
	-- independent of the shared timer precision settings)
	controls.castbarTimerSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarTimersHeader"], oUi.xCoord, yCoord)
	local textCheckbox
	yCoord, textCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, "castbarText", yCoord)
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
	yCoord = yCoord - 30

	-- Target class color: recolor the whole cast bar (every cast type) by the current target's class color,
	-- a PvP class-identification aid. Two indented sub-options gate it to PvP-enabled contexts and extend it
	-- to friendly players; both are grayed out while the master option is off.
	local targetClassColorSubs = {}
	local function RefreshTargetClassColorStates()
		local enabled = barSettings.targetClassColor == true
		for _, cb in ipairs(targetClassColorSubs) do
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(cb, enabled)
		end
	end
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_targetClassColor", L["CastbarTargetClassColor"], L["CastbarTargetClassColorTooltip"], yCoord,
		function() return barSettings.targetClassColor end,
		function(v)
			barSettings.targetClassColor = v
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
			RefreshTargetClassColorStates()
		end)
	yCoord = yCoord - 20
	local pvpOnlyCb = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_targetClassColorPvpOnly", L["CastbarTargetClassColorPvpOnly"], L["CastbarTargetClassColorPvpOnlyTooltip"], yCoord,
		function() return barSettings.targetClassColorPvpOnly end,
		function(v)
			barSettings.targetClassColorPvpOnly = v
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
		end)
	pvpOnlyCb:SetPoint("TOPLEFT", oUi.xCoord + 20, yCoord)
	targetClassColorSubs[#targetClassColorSubs + 1] = pvpOnlyCb
	yCoord = yCoord - 20
	local friendlyCb = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_targetClassColorFriendly", L["CastbarTargetClassColorFriendly"], L["CastbarTargetClassColorFriendlyTooltip"], yCoord,
		function() return barSettings.targetClassColorFriendly end,
		function(v)
			barSettings.targetClassColorFriendly = v
			RefreshActiveSpecCacheForGlobalEdit(isGlobalPanel)
		end)
	friendlyCb:SetPoint("TOPLEFT", oUi.xCoord + 20, yCoord)
	targetClassColorSubs[#targetClassColorSubs + 1] = friendlyCb
	RefreshTargetClassColorStates()
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
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(textCheckbox, controls.castbarTimerSection, yCoord)

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
