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
		local function LinesReadRange(settings)
			return TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(settings) or TRB.Functions.Threshold:HidesAnyLineWithoutTarget(settings)
		end
		if LinesReadRange(TRB.Data.specCache[key].settings) or TRB.Functions.Threshold:UsesRangeConditions(entry.className, entry.specName) then
			return true
		end
		local descriptor = Character:GetSpecDescriptor(entry.classId, entry.specId)
		if descriptor == nil or descriptor.forms == nil then
			return false
		end
		for _, other in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
			local cache = TRB.Data.specCache[other.compositeKey]
			if other.classId == entry.classId and cache ~= nil and LinesReadRange(cache.settings) then
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
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() and spell.rangeCheck == true and spell:HasRange()
				and not seen[spell:GetRankedId()] then
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

	-- A check with no answer is cached, so a line reads the API once per target, and the range event stores answers without reading it.
	local rangeFrame = nil
	for _, frame in ipairs(frames) do
		local events = rawget(frame, "__events")
		if events ~= nil and events.SPELL_RANGE_CHECK_UPDATE then
			rangeFrame = frame
		end
	end
	local rangeSpell = nil
	for _, spell in pairs(TRB.Data.specCache[TRB.Data.character.compositeKey].spellsData.spells) do
		if rangeSpell == nil and type(spell) == "table" and spell.Is ~= nil and (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold"))
			and enabledIds[spell:GetRankedId()] then
			rangeSpell = spell
		end
	end
	if rangeSpell ~= nil and rangeFrame ~= nil then
		local id = rangeSpell:GetRankedId()
		local OnEvent = rangeFrame.__scripts.OnEvent
		local reads, inRange = 0, nil
		local isSpellInRange, spellHasRange = desktop.C_Spell.IsSpellInRange, desktop.C_Spell.SpellHasRange
		desktop.C_Spell.IsSpellInRange = function()
			reads = reads + 1
			return inRange
		end
		Character:InvalidateSpellRanges()
		local first, second = rangeSpell:GetIsSpellInRange(), rangeSpell:GetIsSpellInRange()
		check("with no target, a line reads its range once and counts as out of range with no valid target",
			reads == 1 and first == false and second == false and rangeSpell:HasNoValidTarget())
		reads = 0
		OnEvent(rangeFrame, "SPELL_RANGE_CHECK_UPDATE", id, true, true)
		local inRangeNow, noTargetNow = rangeSpell:GetIsSpellInRange(), rangeSpell:HasNoValidTarget()
		check("a range event with a check stores it without reading the API", reads == 0 and inRangeNow and not noTargetNow)
		OnEvent(rangeFrame, "SPELL_RANGE_CHECK_UPDATE", id, false, false)
		inRangeNow, noTargetNow = rangeSpell:GetIsSpellInRange(), rangeSpell:HasNoValidTarget()
		check("a range event without a check stores no valid target without reading the API", reads == 0 and not inRangeNow and noTargetNow)
		-- Another addon's range check: its events are ignored, and turning ours off, even with nothing cached, leaves only it on.
		desktop.C_Spell.EnableSpellRangeCheck(987654321, true)
		OnEvent(rangeFrame, "SPELL_RANGE_CHECK_UPDATE", 987654321, true, true)
		check("a range event for another caller's spell is ignored", TRB.Data.cache.values.range[987654321] == nil)
		Character:InvalidateSpellRanges()
		Character:DisableSpellRangeCheckUpdate()
		local othersOn = {}
		for otherId in pairs(enabledIds) do
			othersOn[#othersOn + 1] = otherId
		end
		check("turning range checks off turns off every one this addon turned on, and only those", #othersOn == 1 and othersOn[1] == 987654321)
		enabledIds[987654321] = nil
		Character:EnableSpellRangeCheckUpdate()
		inRange = true
		stubs.fireEvents("PLAYER_TARGET_CHANGED", ctx.addonName)
		reads = 0
		check("a target change reads the range again, once", rangeSpell:GetIsSpellInRange() and rangeSpell:GetIsSpellInRange() and reads == 1)
		-- A spell with no range gets no range checks and never reads out of range or without a target.
		inRange = nil
		desktop.C_Spell.SpellHasRange = function(spellId) return spellId ~= id end
		-- As each SwitchSpec does, so the spell's range is read again.
		Character:DisableSpellRangeCheckUpdate()
		Character:EnableSpellRangeCheckUpdate()
		check("a spell with no range gets no range checks, and is never out of range or without a target",
			enabledIds[id] == nil and rangeSpell:GetIsSpellInRange() and not rangeSpell:HasNoValidTarget())
		desktop.C_Spell.IsSpellInRange, desktop.C_Spell.SpellHasRange = isSpellInRange, spellHasRange
		Character:DisableSpellRangeCheckUpdate()
		Character:EnableSpellRangeCheckUpdate()
	else
		print("INFO " .. tostring(TRB.Data.character.compositeKey) .. " has no line with range checks on")
	end

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

	-- A shapeshift form can draw the live spec's lines with another spec's settings, so each one alone must turn range checks on.
	local login = entries[#entries]
	local descriptor = Character:GetSpecDescriptor(login.classId, login.specId)
	if descriptor ~= nil and descriptor.forms ~= nil and #entries > 1 then
		for i = 1, #entries - 1 do
			local other = entries[i]
			UseOwnColorsWithoutRangeChecks()
			local colors = TRB.Data.settings[other.className][other.specName].colors
			local outOfRange = colors and colors.threshold and colors.threshold.outOfRange
			if outOfRange then
				outOfRange.enabled = true
				Character:FillSpecializationCacheSettings(other.className, other.specName)
				Character:RefreshSpellRangeCheckUpdate()
				local label = login.compositeKey .. " with only " .. other.compositeKey .. "'s settings needing range checks"
				local ownNeeds = TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(TRB.Data.specCache[login.compositeKey].settings)
				check(label .. ": its own need none, and it has range-checked lines", not ownNeeds and #RangeCheckedIds(login.compositeKey) > 0)
				CheckOn(label, login.compositeKey)
			end
		end

		-- Another form's line hiding with no valid target needs range checks too.
		UseOwnColorsWithoutRangeChecks()
		local otherDictionary = TRB.Data.specCache[entries[1].compositeKey].settings.thresholds.thresholdDictionary
		local otherKey = next(otherDictionary)
		if otherKey ~= nil then
			local savedBehavior = otherDictionary[otherKey].behavior
			otherDictionary[otherKey].behavior = { noTarget = "hideAlways" }
			Character:RefreshSpellRangeCheckUpdate()
			CheckOn(login.compositeKey .. " with only " .. entries[1].compositeKey .. "'s line hiding with no valid target", login.compositeKey)
			otherDictionary[otherKey].behavior = savedBehavior
		end

		-- Global Options' out-of-range boxes reach the live spec through another spec on Global colors.
		local globalOutOfRange = TRB.Data.settings.core.colors.threshold.outOfRange
		UseOwnColorsWithoutRangeChecks()
		globalOutOfRange.show, globalOutOfRange.enabled = true, false
		TRB.Data.settings.core.global[entries[1].className][entries[1].specName].thresholdColors = true
		Character:FillSpecializationCacheSettings(entries[1].className, entries[1].specName)
		Character:RefreshSpellRangeCheckUpdate()
		local label = login.compositeKey .. " with only " .. entries[1].compositeKey .. " on Global colors"
		local registered = State()
		check(label .. ": range checks are off while Global's colors need none", not registered and next(enabledIds) == nil)
		local globalControls = { colors = {}, checkBoxes = {} }
		TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(desktop.CreateFrame("Frame"), globalControls, TRB.Data.settings.core, nil, nil, 0, "", false, false, false, true, nil)
		local recolor = globalControls.checkBoxes.thresholdOutOfRangeColorEnabled
		recolor.GetChecked = function() return true end
		recolor.__scripts.OnClick(recolor)
		CheckOn(label .. ", after ticking Global Options' change color when out of range box", login.compositeKey)
		globalOutOfRange.enabled = true

		for _, entry in ipairs(entries) do
			TRB.Data.settings.core.global[entry.className][entry.specName].thresholdColors = true
			Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
		Character:RefreshSpellRangeCheckUpdate()
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

	-- Global's default colors need range checks, so Use Global can turn them on.
	local live = Character:GetSpecRegistryEntry(TRB.Data.character.compositeKey)
	check(live.compositeKey .. " with no settings needing range checks: range checks are off", UseOwnColorsWithoutRangeChecks())
	-- No color rows: the Use Global box comes first, and Shadow, Elemental, and Balance have no Unusable color.
	local controls = { colors = {}, checkBoxes = {} }
	TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(desktop.CreateFrame("Frame"), controls, TRB.Data.settings[live.className][live.specName], live.classId, live.specId, 0, "", false, false, false, false, nil)
	local useGlobal = controls.checkBoxes.useGlobalThresholdColors
	useGlobal.GetChecked = function() return true end
	useGlobal.__scripts.OnClick(useGlobal)
	CheckOn(live.compositeKey .. " after ticking its Use Global threshold colors box", live.compositeKey)

	-- Hiding with no valid target needs range checks, from the shared setting or one line's own.
	check(live.compositeKey .. " with no settings needing range checks again: range checks are off", UseOwnColorsWithoutRangeChecks())
	local liveThresholds = TRB.Data.specCache[live.compositeKey].settings.thresholds
	liveThresholds.behavior.hideNoTarget.enabled = true
	Character:RefreshSpellRangeCheckUpdate()
	CheckOn(live.compositeKey .. " hiding lines with no valid target", live.compositeKey)
	liveThresholds.behavior.hideNoTarget.enabled = false
	local lineKey = next(liveThresholds.thresholdDictionary)
	if lineKey ~= nil then
		local savedBehavior = liveThresholds.thresholdDictionary[lineKey].behavior
		liveThresholds.thresholdDictionary[lineKey].behavior = { noTarget = "hideCombat" }
		Character:RefreshSpellRangeCheckUpdate()
		CheckOn(live.compositeKey .. " with one line hiding with no valid target", live.compositeKey)
		liveThresholds.thresholdDictionary[lineKey].behavior = savedBehavior
	end

	check(live.compositeKey .. " with no settings needing range checks once more: range checks are off", UseOwnColorsWithoutRangeChecks())
	for _, entry in ipairs(entries) do
		TRB.Data.settings.core.global[entry.className][entry.specName].thresholdColors = true
	end
	TRB.Functions.OptionsUi.GlobalSettings:RefreshAfterBulkChange()
	CheckOn(live.compositeKey .. " after the Global Options bulk Use Global toggle", live.compositeKey)
	return errors
end

return hooks
