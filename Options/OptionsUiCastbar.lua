---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Castbar = TRB.Functions.OptionsUi.Castbar or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Castbar options panel (single central tab, injected into every spec by BuildTabGroup)
-- ============================================================================

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

---Constructs the castbar options panel for a spec.
---@param parent Frame # The tab's scroll child
---@param classId integer
---@param specId integer
function TRB.Functions.OptionsUi.Castbar:ConstructPanel(parent, classId, specId)
	if parent == nil then
		return
	end
	local classNameLower, specNameLower = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specNameLower]
	if spec == nil then
		return
	end
	local compositeKey = classNameLower .. "_" .. specNameLower

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[compositeKey] = interfaceSettingsFrame.controls[compositeKey] or {}
	local controls = interfaceSettingsFrame.controls[compositeKey]
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

	local namePrefix = "TwintopResourceBar_" .. compositeKey .. "_castbar"
	local yCoord = 5

	-- Simple opt-in toggle. The castbar is not part of the displayBar/BarVisibility system: when
	-- enabled it shows automatically while actively casting/channeling/empowering, and hides otherwise.
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_enable", L["CastbarEnable"], L["CastbarEnableTooltip"], yCoord,
		function() return barSettings.enabled end, function(v) barSettings.enabled = v end)
	yCoord = yCoord - 40

	-- Dimensions / anchoring (reuses the shared custom-bar dimensions generator)
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, castbarDef, L["ResourceCastbar"])
	yCoord = yCoord - 40

	-- Fill colors
	controls.castbarColorSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarColorsHeader"], oUi.xCoord, yCoord)
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
	yCoord = yCoord - 30
	colors.latency = colors.latency or { color = "80FF0000", enabled = true }
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_latencyEnable", L["CastbarLatencyEnable"], L["CastbarLatencyEnableTooltip"], yCoord,
		function() return colors.latency.enabled end, function(v) colors.latency.enabled = v end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "latency", L["CastbarColorLatency"], yCoord, classId, specId)
	yCoord = yCoord - 30
	colors.pushback = colors.pushback or { color = "80FF00FF", enabled = true }
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_pushbackEnable", L["CastbarPushbackEnable"], L["CastbarPushbackEnableTooltip"], yCoord,
		function() return colors.pushback.enabled end, function(v) colors.pushback.enabled = v end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "pushback", L["CastbarColorPushback"], yCoord, classId, specId)
	yCoord = yCoord - 30
	colors.tick = colors.tick or { color = "FFFFFFFF", enabled = true }
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_tickEnable", L["CastbarTickEnable"], L["CastbarTickEnableTooltip"], yCoord,
		function() return colors.tick.enabled end, function(v) colors.tick.enabled = v end)
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.overlay, colors, "tick", L["CastbarColorTick"], yCoord, classId, specId)
	yCoord = yCoord - 40

	-- Empower fill colors: absolute per-level (base while charging toward Level I, then Level I..IV as reached)
	controls.castbarEmpowerSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarEmpowerHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_empowerSegmentedFill", L["CastbarEmpowerSegmentedFill"], L["CastbarEmpowerSegmentedFillTooltip"], yCoord,
		function() return barSettings.empowerSegmentedFill end, function(v) barSettings.empowerSegmentedFill = v end)
	yCoord = yCoord - 30
	colors.empowerStages = colors.empowerStages or { base = { color = "FFC8B0FF" }, level1 = { color = "FFFFCC00" }, level2 = { color = "FFFFAA00" }, level3 = { color = "FFFF6600" }, level4 = { color = "FFFF3000" } }
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

	-- Timer text precision (castbar-specific, independent of the shared timer precision settings)
	controls.castbarTimerSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CastbarTimersHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	controls.castbarCastTimePrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["CastbarCastTimePrecision"], 0, 3, barSettings.castTimePrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.castbarCastTimePrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		barSettings.castTimePrecision = value
		TRB.Data.lookupDirty = true
	end)
	yCoord = yCoord - 60
	controls.castbarDurationPrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["CastbarDurationPrecision"], 0, 3, barSettings.durationPrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.castbarDurationPrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		barSettings.durationPrecision = value
		TRB.Data.lookupDirty = true
	end)
	yCoord = yCoord - 60
	controls.castbarLatencyPrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["CastbarLatencyPrecision"], 0, 3, barSettings.latencyPrecision, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.castbarLatencyPrecision:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		barSettings.latencyPrecision = value
		TRB.Data.lookupDirty = true
	end)
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
