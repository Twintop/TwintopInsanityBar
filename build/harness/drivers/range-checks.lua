-- Checks that range checks stay on through the SwitchSpec re-runs after a loading screen, a talent change, and a specialization change.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}
local frames = {}
local enabledIds = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local innerCreate = desktop.CreateFrame
	desktop.CreateFrame = function(...)
		local frame = innerCreate(...)
		frames[#frames + 1] = frame
		return frame
	end
	desktop.C_Spell.EnableSpellRangeCheck = function(id, enable)
		enabledIds[id] = enable == true or nil
	end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local Character = TRB.Functions.Character
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
	end
	-- Runs queued timers until none fail, past the stub errors deferred UI code hits.
	local function Drain(label)
		for i = 1, 20 do
			local _, timerFailures = stubs.fireEvents("TRB_DRAIN_" .. label .. "_" .. i, ctx.addonName)
			if timerFailures == 0 then
				return
			end
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")
	check("the deferred setup finishes, so later events re-run SwitchSpec", TRB.Details.addonData.optionsPanelFinished == true)

	-- Every SwitchSpec starts by turning range checks off, so counting that shows it re-ran.
	local switches = 0
	local disable = Character.DisableSpellRangeCheckUpdate
	Character.DisableSpellRangeCheckUpdate = function(...)
		switches = switches + 1
		return disable(...)
	end

	---Whether the range event is registered, and the event and enabled spells as one comparable string.
	---@return boolean registered
	---@return string summary
	local function State()
		local registered = false
		for _, frame in ipairs(frames) do
			local events = rawget(frame, "__events")
			if events ~= nil and events.SPELL_RANGE_CHECK_UPDATE then
				registered = true
			end
		end
		local ids = {}
		for id in pairs(enabledIds) do
			ids[#ids + 1] = id
		end
		table.sort(ids)
		return registered, string.format("event %s, spells on: %s", registered and "registered" or "unregistered", #ids > 0 and table.concat(ids, " ") or "none")
	end

	---Whether the specialization needs range checks, by the rules Character.lua's NeedsSpellRangeChecks follows.
	---@param key string
	---@return boolean
	local function NeedsRangeChecks(key)
		local entry = Character:GetSpecRegistryEntry(key)
		if TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(TRB.Data.specCache[key].settings) or TRB.Functions.Threshold:UsesRangeConditions(entry.className, entry.specName) then
			return true
		end
		local descriptor = Character:GetSpecDescriptor(entry.classId, entry.specId)
		if descriptor == nil or descriptor.forms == nil then
			return false
		end
		for _, other in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
			local cache = TRB.Data.specCache[other.compositeKey]
			if other.classId == entry.classId and cache ~= nil and TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(cache.settings) then
				return true
			end
		end
		return false
	end

	---The specialization's range-checked threshold spells, when it needs range checks.
	---@param key string
	---@return integer[]
	local function RangeCheckedIds(key)
		local ids = {}
		if not NeedsRangeChecks(key) then
			return ids
		end
		local cache = TRB.Data.specCache[key]
		-- Several lines can share one spell, such as one ability at different costs.
		local seen = {}
		for _, spell in pairs(cache.spellsData.spells) do
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() and spell.rangeCheck == true and not seen[spell:GetRankedId()] then
				seen[spell:GetRankedId()] = true
				ids[#ids + 1] = spell:GetRankedId()
			end
		end
		table.sort(ids)
		return ids
	end

	---The specialization's range-checked threshold spells that need range checks but aren't on.
	---@param key string
	---@return integer[]
	local function MissingIds(key)
		local missing = {}
		for _, id in ipairs(RangeCheckedIds(key)) do
			if enabledIds[id] == nil then
				missing[#missing + 1] = id
			end
		end
		return missing
	end

	---Spells with range checks on that aren't the specialization's own, such as the previous specialization's.
	---@param key string
	---@return integer[]
	local function ExtraIds(key)
		local own = {}
		for _, id in ipairs(RangeCheckedIds(key)) do
			own[id] = true
		end
		local extra = {}
		for id in pairs(enabledIds) do
			if not own[id] then
				extra[#extra + 1] = id
			end
		end
		table.sort(extra)
		return extra
	end

	-- On means the step's specialization is built, only its own range-checked spells are on, and turning range checks on again changes nothing.
	local function CheckOn(label, key)
		local registered, now = State()
		if not TRB.Data.specSupported then
			local off = not registered and next(enabledIds) == nil
			check(label .. ": range checks stay off for an unsupported specialization" .. (off and "" or " (" .. now .. ")"), off)
			return
		end
		check(label .. ": the bar is built for " .. key, TRB.Data.barConstructedForSpec == key)
		check(label .. ": the range event is registered", registered)
		local missing = MissingIds(key)
		check(label .. ": its range-checked spells are on" .. (#missing > 0 and " (off: " .. table.concat(missing, " ") .. ")" or ""), #missing == 0)
		local extra = ExtraIds(key)
		check(label .. ": only its own range checks are on" .. (#extra > 0 and " (also on: " .. table.concat(extra, " ") .. ")" or ""), #extra == 0)
		Character:EnableSpellRangeCheckUpdate()
		local _, expected = State()
		if now == expected then
			check(label .. ": range checks stay on", true)
		else
			check(string.format("%s: range checks stay on (%s; turning them on gives %s)", label, now, expected), false)
		end
	end

	local function Step(label, event, key)
		local before = switches
		stubs.fireEvents(event, ctx.addonName)
		Drain(event:match("^[^:]+"))
		check(label .. ": SwitchSpec ran again", switches > before)
		CheckOn(label, key)
	end

	local function SetSpec(index)
		desktop.GetSpecialization = function() return index end
		desktop.C_SpecializationInfo.GetSpecialization = function() return index end
	end

	CheckOn("after login", TRB.Data.character.compositeKey)
	local entries = {}
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if entry.classId == ctx.classId then
			entries[#entries + 1] = entry
		end
	end
	-- The login spec goes last, so every specialization of a multi-spec class is changed into.
	if #entries > 1 then
		table.insert(entries, table.remove(entries, 1))
	end
	local current = desktop.C_SpecializationInfo.GetSpecialization()
	for _, entry in ipairs(entries) do
		local change = entry.specId ~= current and "a specialization change" or "a same-specialization event"
		current = entry.specId
		SetSpec(entry.specId)
		Step(entry.compositeKey .. " after " .. change, "PLAYER_SPECIALIZATION_CHANGED", entry.compositeKey)
		Step(entry.compositeKey .. " after a loading screen", "PLAYER_ENTERING_WORLD", entry.compositeKey)
		Step(entry.compositeKey .. " after a talent change", "TRAIT_CONFIG_UPDATED:12345", entry.compositeKey)
	end

	-- Disabling the live spec drops the immediate SwitchSpec on a spec change, leaving only Bootstrap's run to turn range checks on.
	local from, to = entries[#entries], nil
	for i = 1, #entries - 1 do
		if #RangeCheckedIds(entries[i].compositeKey) > 0 then
			to = entries[i]
			break
		end
	end
	if to ~= nil then
		local enabled = TRB.Data.settings.core.enabled[from.className]
		enabled[from.specName] = false
		TRB.Functions.Class:EventRegistration()
		CheckOn(from.compositeKey .. " once disabled", from.compositeKey)
		Character:RefreshSpellRangeCheckUpdate()
		CheckOn(from.compositeKey .. " once disabled, after an options refresh", from.compositeKey)
		-- Nothing on before the switch, as after logging in on the disabled spec.
		for id in pairs(enabledIds) do
			enabledIds[id] = nil
		end
		SetSpec(to.specId)
		Step(to.compositeKey .. " after a change from a disabled specialization", "PLAYER_SPECIALIZATION_CHANGED", to.compositeKey)
		enabled[from.specName] = true
	end

	---Turns Use Global threshold colors off for the class's specs, with their own colors needing no range checks.
	---@return boolean off # Whether range checks are off afterward
	local function UseOwnColorsWithoutRangeChecks()
		for _, entry in ipairs(entries) do
			TRB.Data.settings.core.global[entry.className][entry.specName].thresholdColors = false
			local colors = TRB.Data.settings[entry.className][entry.specName].colors
			local outOfRange = colors and colors.threshold and colors.threshold.outOfRange
			if outOfRange then
				outOfRange.show, outOfRange.enabled = true, false
			end
			Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
		Character:RefreshSpellRangeCheckUpdate()
		local registered = State()
		return not registered and next(enabledIds) == nil
	end

	-- Global's default colors need range checks, so Use Global can turn them on.
	local live = Character:GetSpecRegistryEntry(TRB.Data.character.compositeKey)
	check(live.compositeKey .. " with no settings needing range checks: range checks are off", UseOwnColorsWithoutRangeChecks())
	-- No color rows: the Use Global box comes first, and healer specs lack some rows' colors.
	local controls = { colors = {}, checkBoxes = {} }
	TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(desktop.CreateFrame("Frame"), controls, TRB.Data.settings[live.className][live.specName], live.classId, live.specId, 0, "", false, false, false, false, nil)
	local useGlobal = controls.checkBoxes.useGlobalThresholdColors
	useGlobal.GetChecked = function() return true end
	useGlobal.__scripts.OnClick(useGlobal)
	CheckOn(live.compositeKey .. " after ticking its Use Global threshold colors box", live.compositeKey)

	check(live.compositeKey .. " with no settings needing range checks again: range checks are off", UseOwnColorsWithoutRangeChecks())
	for _, entry in ipairs(entries) do
		TRB.Data.settings.core.global[entry.className][entry.specName].thresholdColors = true
	end
	TRB.Functions.OptionsUi.GlobalSettings:RefreshAfterBulkChange()
	CheckOn(live.compositeKey .. " after the Global Options bulk Use Global toggle", live.compositeKey)

	-- A shapeshift form can draw the live spec's lines with another spec's settings.
	local descriptor = Character:GetSpecDescriptor(live.classId, live.specId)
	if descriptor ~= nil and descriptor.forms ~= nil and #entries > 1 then
		TRB.Data.settings.core.global[live.className][live.specName].thresholdColors = false
		Character:FillSpecializationCacheSettings(live.className, live.specName)
		Character:RefreshSpellRangeCheckUpdate()
		local ownNeeds = TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(TRB.Data.specCache[live.compositeKey].settings)
		check(live.compositeKey .. " drawn with another specialization's settings: its own need no range checks, and it has range-checked lines", not ownNeeds and #RangeCheckedIds(live.compositeKey) > 0)
		CheckOn(live.compositeKey .. " with only another specialization's settings needing range checks", live.compositeKey)
	end
	return errors
end

return hooks
