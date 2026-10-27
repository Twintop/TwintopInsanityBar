-- Checks the threshold line cooldown tracker (#279): snapshot coverage, the event filter, the cooldown flag rules, the end widget, charge recharges, and the icon swipe.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx)
end

---@param spell table
---@return boolean
local function IsCooldownLine(spell)
	return type(spell) == "table" and spell.Is ~= nil
		and (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold"))
		and spell.hasCooldown == true and spell:IsValid()
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local G = desktop
	local failures = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail) and (" (" .. detail .. ")") or ""))
		if not ok then
			failures = failures + 1
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

	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	Drain("SETUP")

	-- Every threshold line with a cooldown, on every spec of the class, has a snapshot for the tracker to drive.
	local missing = {}
	for compositeKey, cache in pairs(TRB.Data.specCache) do
		local spells = cache.spellsData and cache.spellsData.spells
		local snapshots = cache.snapshotData and cache.snapshotData.snapshots
		if spells ~= nil and snapshots ~= nil then
			for name, spell in pairs(spells) do
				if IsCooldownLine(spell) and snapshots[spell.id] == nil then
					missing[#missing + 1] = compositeKey .. "." .. name
				end
			end
		end
	end
	table.sort(missing)
	check("Every threshold line with a cooldown has a snapshot", #missing == 0, table.concat(missing, ", "))

	-- A remaining-time curve, as Restless Blades uses: the within color through the limit, the beyond color past it.
	local remainingCurve = TRB.Functions.Color:BuildRemainingTimeCurve(3, "FFFF0000", "FF0000FF")
	local function IsColor(color, r, g, b)
		local cr, cg, cb = color:GetRGBA()
		return math.abs(cr - r) < 1e-6 and math.abs(cg - g) < 1e-6 and math.abs(cb - b) < 1e-6
	end
	check("A remaining-time curve is the within color at its limit", IsColor(remainingCurve:Evaluate(3), 1, 0, 0))
	check("A remaining-time curve is the beyond color past its limit", IsColor(remainingCurve:Evaluate(3.01), 0, 0, 1))
	check("A remaining-time curve is reused for the same inputs", TRB.Functions.Color:BuildRemainingTimeCurve(3, "FFFF0000", "FF0000FF") == remainingCurve)

	-- Old saves with the cooldown swipe off drew no cooldown time either, so the new time option starts off there.
	local classEntry = TRB.Data.classRegistryOrder[1]
	local specs = classEntry.specs
	local oldSave = { core = { thresholds = { icons = { showCooldown = false } } }, [classEntry.className] = {} }
	oldSave[classEntry.className][specs[1].specName] = { thresholds = { icons = { showCooldown = false } } }
	if specs[2] ~= nil then
		oldSave[classEntry.className][specs[2].specName] = { thresholds = { icons = { showCooldown = true } } }
	end
	if specs[3] ~= nil then
		oldSave[classEntry.className][specs[3].specName] = { thresholds = { icons = { showCooldown = false, showCooldownText = true } } }
	end
	TRB.Functions.Settings:MigrateThresholdIconCooldownText(oldSave)
	local migrated = oldSave[classEntry.className]
	check("Migration: the cooldown time starts off where the swipe was off", oldSave.core.thresholds.icons.showCooldownText == false
		and migrated[specs[1].specName].thresholds.icons.showCooldownText == false)
	check("Migration: a save with the swipe on, or the time already set, is left alone",
		(specs[2] == nil or migrated[specs[2].specName].thresholds.icons.showCooldownText == nil)
		and (specs[3] == nil or migrated[specs[3].specName].thresholds.icons.showCooldownText == true))

	local snapshotData = TRB.Data.snapshotData
	if snapshotData == nil then
		check("The live spec has snapshot data", false)
		return failures
	end
	local snapshots = snapshotData.snapshots

	-- Forever lists only known spells, and the stubs know none.
	local isSpellKnown = G.C_SpellBook.IsSpellKnown
	if TRB.Flavor.thresholdsRequireKnown then
		G.C_SpellBook.IsSpellKnown = function() return true end
		TRB.Functions.Character:RefreshThresholdSpellsLearned()
	end

	-- The tracked set, as the tracker builds it: learned cooldown lines plus the descriptor's cooldownSpells.
	local keys = {}
	for key, spell in pairs(TRB.Data.cache.thresholdSpellsByKey) do
		if spell.hasCooldown and snapshots[spell.id] ~= nil then
			keys[#keys + 1] = key
		end
	end
	table.sort(keys)
	local trackedCooldowns = {}
	local trackedCount = 0
	local function Count(spell)
		local snapshot = spell ~= nil and snapshots[spell.id] or nil
		if snapshot ~= nil and trackedCooldowns[snapshot.cooldown] == nil then
			trackedCooldowns[snapshot.cooldown] = spell
			trackedCount = trackedCount + 1
		end
	end
	local plainSpell, chargeSpell = nil, nil
	for _, key in ipairs(keys) do
		local spell = TRB.Data.cache.thresholdSpellsByKey[key]
		Count(spell)
		if spell.hasCharges then
			chargeSpell = chargeSpell or spell
		else
			plainSpell = plainSpell or spell
		end
	end
	local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
	if descriptor ~= nil and descriptor.cooldownSpells ~= nil then
		for _, key in ipairs(descriptor.cooldownSpells) do
			Count(TRB.Data.spellsData.spells[key])
		end
	end
	if trackedCount == 0 then
		print("INFO " .. tostring(TRB.Data.character.compositeKey) .. " has no threshold line with a cooldown")
		G.C_SpellBook.IsSpellKnown = isSpellKnown
		return failures
	end

	-- Stubs: a controlled clock, sentinel secrets, per-spell cooldown readings, and Cooldown frames that record their loads.
	local SECRET = setmetatable({}, { __tostring = function() return "SECRET" end })
	local now = 1000
	local saved = {
		GetTime = G.GetTime,
		issecretvalue = G.issecretvalue,
		GetSpellCooldown = G.C_Spell.GetSpellCooldown,
		GetSpellCharges = G.C_Spell.GetSpellCharges,
		GetSpellCooldownDuration = G.C_Spell.GetSpellCooldownDuration,
		GetSpellChargeDuration = G.C_Spell.GetSpellChargeDuration,
		CreateFrame = G.CreateFrame,
	}
	G.GetTime = function() return now end
	local secretsOn = true
	G.issecretvalue = function(value) return secretsOn and value == SECRET end
	local readings = {}
	-- Only reads of tracked spells count: the GCD bar and Skyriding read their own spells on the same events.
	local trackedIds = {}
	for cooldown in pairs(trackedCooldowns) do
		trackedIds[cooldown:GetSpell():GetRankedId()] = true
	end
	local cooldownReads = 0
	local readsById = {}
	-- Readings handed out one per read before `readings` applies, for a change seen differently a frame later.
	local queued = {}
	G.C_Spell.GetSpellCooldown = function(id)
		if trackedIds[id] then
			cooldownReads = cooldownReads + 1
		end
		readsById[id] = (readsById[id] or 0) + 1
		if queued[id] ~= nil and #queued[id] > 0 then
			return table.remove(queued[id], 1)
		end
		return readings[id] or saved.GetSpellCooldown(id)
	end
	local chargeReads = 0
	local chargeReading = { currentCharges = SECRET, maxCharges = 2, cooldownStartTime = SECRET, cooldownDuration = SECRET, chargeModRate = 1, isActive = true }
	G.C_Spell.GetSpellCharges = function()
		chargeReads = chargeReads + 1
		return chargeReading
	end
	local durationObject = { HasSecretValues = function() return true end }
	local noDurationObject = false
	G.C_Spell.GetSpellCooldownDuration = function(id) return not noDurationObject and readings[id] ~= nil and durationObject or nil end
	G.C_Spell.GetSpellChargeDuration = G.C_Spell.GetSpellCooldownDuration
	local cooldownFrames = {}
	G.CreateFrame = function(frameType, ...)
		local frame = saved.CreateFrame(frameType, ...)
		if frameType == "Cooldown" then
			frame.loads = 0
			frame.SetCooldownFromDurationObject = function(self, object)
				self.loaded = object
				self.loads = self.loads + 1
			end
			frame.Clear = function(self) self.loaded = nil end
			cooldownFrames[#cooldownFrames + 1] = frame
		end
		return frame
	end

	local function Fire(spellId)
		stubs.fireEvents(spellId ~= nil and ("SPELL_UPDATE_COOLDOWN:" .. spellId) or "SPELL_UPDATE_COOLDOWN", ctx.addonName)
	end
	local function Reading(isActive, isOnGCD, startTime, duration)
		return { isActive = isActive, isOnGCD = isOnGCD, isEnabled = true, modRate = 1, startTime = startTime or SECRET, duration = duration or SECRET }
	end

	if plainSpell ~= nil then
		local id = plainSpell:GetRankedId()
		local cooldown = snapshots[plainSpell.id].cooldown
		local label = plainSpell.settingKey

		readings[id] = Reading(true, false)
		cooldownReads = 0
		Fire(987654321)
		check(label .. ": an event naming an untracked spell reads no cooldown", cooldownReads == 0, cooldownReads .. " reads")

		readings[id] = Reading(true, true)
		Fire(id)
		check(label .. ": the GCD alone doesn't start a cooldown", not cooldown.onCooldown)

		readings[id] = Reading(true, false)
		local reads = readsById[id] or 0
		Fire(id)
		check(label .. ": its own cooldown starts on isOnGCD false", cooldown.onCooldown and cooldown:IsUnusable())
		check(label .. ": one read per event naming it", (readsById[id] or 0) - reads == 1, ((readsById[id] or 0) - reads) .. " reads")
		check(label .. ": secret times leave no plain timing", not cooldown:HasPlainTiming())
		local widget = cooldownFrames[#cooldownFrames]
		check(label .. ": the end widget loads the duration object", widget ~= nil and widget.loaded == durationObject)

		readings[id] = Reading(true, true)
		Fire(id)
		check(label .. ": a GCD reading in the start's frame doesn't end it", cooldown.onCooldown)

		now = now + 1
		readings[id] = Reading(true, nil)
		local version = cooldown.version
		local loads = widget ~= nil and widget.loads or 0
		Fire(id)
		check(label .. ": a reduction keeps it on cooldown", cooldown.onCooldown)
		check(label .. ": a reduction retimes it and reloads the end widget", cooldown.version > version and widget ~= nil and widget.loads > loads)

		local onDone = widget ~= nil and widget:GetScript("OnCooldownDone") or nil
		if onDone ~= nil then
			onDone(widget)
		end
		check(label .. ": the end widget ends it", not cooldown.onCooldown)

		now = now + 1
		readings[id] = Reading(true, false)
		Fire(id)
		now = now + 1
		readings[id] = Reading(true, true)
		Fire(id)
		check(label .. ": a later GCD-only reading ends it (reset or finishing reduction)", not cooldown.onCooldown)

		now = now + 1
		readings[id] = Reading(true, false)
		Fire(id)
		now = now + 1
		readings[id] = Reading(false, nil)
		Fire(id)
		check(label .. ": isActive false ends it", not cooldown.onCooldown)

		local before = cooldownReads
		Fire(nil)
		check("An event naming no spell reads every tracked cooldown once", cooldownReads - before == trackedCount,
			(cooldownReads - before) .. " reads for " .. trackedCount .. " tracked")

		now = now + 1
		secretsOn = false
		readings[id] = Reading(true, false, now, 30)
		Fire(id)
		check(label .. ": plain times give a plain end", cooldown:HasPlainTiming() and cooldown.endsAt == now + 30)
		secretsOn = true
		now = now + 1
		readings[id] = Reading(false, nil)
		Fire(id)

		now = now + 1
		readings[id] = Reading(true, false)
		Fire(id)
		now = now + 1
		queued[id] = { Reading(true, nil), Reading(true, true) }
		Fire(id)
		check(label .. ": a change that leaves only the GCD a frame later ends it", not cooldown.onCooldown)

		-- The stubs run every timer at once, so the end timer is checked by the delay it asked for.
		now = now + 1
		secretsOn = false
		noDurationObject = true
		local delays = {}
		local after = G.C_Timer.After
		G.C_Timer.After = function(delay, fn)
			delays[#delays + 1] = delay
			return after(delay, fn)
		end
		readings[id] = Reading(true, false, now, 30)
		Fire(id)
		G.C_Timer.After = after
		noDurationObject = false
		secretsOn = true
		local timed = false
		for _, delay in ipairs(delays) do
			if math.abs(delay - 30) < 1e-6 then
				timed = true
			end
		end
		check(label .. ": with no duration object, its plain end time ends it", timed and not cooldown.onCooldown)
		readings[id] = Reading(false, nil)
	end

	if chargeSpell ~= nil then
		local id = chargeSpell:GetRankedId()
		local cooldown = snapshots[chargeSpell.id].cooldown
		local label = chargeSpell.settingKey

		now = now + 1
		readings[id] = Reading(true, nil)
		Fire(id)
		check(label .. ": a charge spell with charges left isn't on cooldown", not cooldown.onCooldown)

		readings[id] = Reading(true, false)
		Fire(id)
		check(label .. ": no charges left puts a charge spell on cooldown", cooldown.onCooldown and cooldown:IsUnusable())

		local before = chargeReads
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		check(label .. ": a charge event re-reads the counts", chargeReads > before)
		check(label .. ": secret counts still read as unusable", cooldown:IsUnusable())

		now = now + 1
		readings[id] = Reading(true, nil)
		Fire(id)
		check(label .. ": a charge coming back ends its cooldown", not cooldown.onCooldown and not cooldown:IsUnusable())
		check(label .. ": a charge coming back keeps the recharge", cooldown.isActive and cooldown.rechargeDurationObject == durationObject)
		cooldown:MarkEnded()
		check(label .. ": the end of a no-charges cooldown leaves the recharge", cooldown.rechargeDurationObject == durationObject)

		-- The icon swipe, on a line frame built over the recording Cooldown stub.
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		local dictEntry = settings.thresholds.thresholdDictionary[chargeSpell.settingKey]
		local lineFrame = G.CreateFrame("Frame")
		TRB.Functions.Threshold:ResetThresholdLine(lineFrame, settings, true)
		local swipe = lineFrame.icon.cooldown
		swipe.SetCooldown = function(self, _, duration)
			self.loaded = duration ~= 0 and duration or nil
		end
		-- The template's look: a swipe, no edge, and countdown numbers.
		swipe.drawSwipe, swipe.drawEdge, swipe.hideNumbers = true, false, false
		swipe.GetDrawSwipe = function(self) return self.drawSwipe end
		swipe.SetDrawSwipe = function(self, value) self.drawSwipe = value end
		swipe.GetDrawEdge = function(self) return self.drawEdge end
		swipe.SetDrawEdge = function(self, value) self.drawEdge = value end
		swipe.GetHideCountdownNumbers = function(self) return self.hideNumbers end
		swipe.SetHideCountdownNumbers = function(self, value) self.hideNumbers = value end
		local showCooldown, lineEnabled = settings.thresholds.icons.showCooldown, dictEntry.enabled
		settings.thresholds.icons.showCooldown = true
		dictEntry.enabled = true
		local function DrawSwipe(step)
			local ok, err = pcall(TRB.Functions.Threshold.AdjustThresholdDisplay, TRB.Functions.Threshold, chargeSpell, chargeSpell.settingKey, lineFrame, true,
				TRB.Data.constants.frameLevels.thresholdOver, 0, settings.colors.threshold.over.color, snapshots[chargeSpell.id], settings, dictEntry)
			if not ok then
				check(label .. ": the line draws " .. step, false, tostring(err))
			end
		end

		DrawSwipe("with charges left")
		check(label .. ": by default a charge recharging with charges left draws only the swipe's edge",
			swipe.loaded == durationObject and swipe.drawSwipe == false and swipe.drawEdge == true)

		local reads, version = chargeReads, cooldown.version
		Fire(id)
		check(label .. ": a cooldown event naming a recharging spell re-reads its recharge", chargeReads - reads == 1 and cooldown.version > version,
			(chargeReads - reads) .. " reads")

		chargeReading.isActive = false
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		check(label .. ": the recharge clears once every charge is up", not cooldown.isActive and cooldown.rechargeDurationObject == nil)
		DrawSwipe("with every charge up")
		check(label .. ": the swipe clears once every charge is up", swipe.loaded == nil)
		reads = chargeReads
		Fire(id)
		check(label .. ": a cooldown event with every charge up reads no recharge", chargeReads == reads, (chargeReads - reads) .. " reads")

		readings[id] = Reading(true, false)
		chargeReading.isActive = true
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		Fire(id)
		DrawSwipe("with no charges left")
		check(label .. ": the swipe shows the recharge with no charges left", cooldown.onCooldown and swipe.loaded == durationObject)
		check(label .. ": by default a cooldown draws the template's swipe and time",
			swipe.drawSwipe == true and swipe.drawEdge == false and swipe.hideNumbers == false and swipe.noCooldownCount == nil)

		local icons = settings.thresholds.icons
		local iconsSaved = { icons.showCooldown, icons.showCooldownText, icons.rechargeMode }
		now = now + 1
		readings[id] = Reading(true, nil)
		Fire(id)
		icons.rechargeMode = "edge"
		DrawSwipe("as an edge")
		check(label .. ": Swipe edge only draws the recharge's edge without the swipe",
			swipe.loaded == durationObject and swipe.drawSwipe == false and swipe.drawEdge == true)
		icons.rechargeMode = "hidden"
		DrawSwipe("hiding the recharge")
		check(label .. ": Hide until no charges are left clears a recharge with charges left", swipe.loaded == nil)
		readings[id] = Reading(true, false)
		Fire(id)
		DrawSwipe("hiding the recharge, with no charges left")
		check(label .. ": Hide until no charges are left still draws the full cooldown with none left",
			swipe.loaded == durationObject and swipe.drawSwipe == true and swipe.drawEdge == false)
		icons.rechargeMode = "full"

		icons.showCooldown = false
		DrawSwipe("without the swipe")
		check(label .. ": turning the swipe off keeps the time", swipe.loaded == durationObject and swipe.drawSwipe == false and swipe.hideNumbers == false)
		icons.showCooldown = true
		icons.showCooldownText = false
		DrawSwipe("without the time")
		check(label .. ": turning the time off hides the numbers and cooldown text addons' text",
			swipe.loaded == durationObject and swipe.drawSwipe == true and swipe.hideNumbers == true and swipe.noCooldownCount == true)
		icons.showCooldown = false
		DrawSwipe("with neither")
		check(label .. ": turning the swipe and the time off draws nothing", swipe.loaded == nil)
		icons.showCooldown, icons.showCooldownText = true, true

		-- Some lines have no icon settings until the options panel creates them.
		local hadIconOverride = dictEntry.icon ~= nil
		dictEntry.icon = dictEntry.icon or { enabled = false }
		local iconOverride = dictEntry.icon
		local overrideSaved = { iconOverride.enabled, iconOverride.showCooldown }
		iconOverride.showCooldown = false
		DrawSwipe("with an unused line setting")
		check(label .. ": a line's own setting waits for its icon override", swipe.loaded == durationObject and swipe.drawSwipe == true)
		iconOverride.enabled = true
		DrawSwipe("with the line's own setting")
		check(label .. ": a line's own setting wins with its icon override on", swipe.loaded == durationObject and swipe.drawSwipe == false)
		iconOverride.enabled, iconOverride.showCooldown = overrideSaved[1], overrideSaved[2]
		if not hadIconOverride then
			dictEntry.icon = nil
		end
		icons.showCooldown, icons.showCooldownText, icons.rechargeMode = iconsSaved[1], iconsSaved[2], iconsSaved[3]

		TRB.Functions.ThresholdCooldowns:Disable()
		DrawSwipe("once untracked")
		check(label .. ": the recharge and swipe clear once nothing tracks the spell", not cooldown.isActive and swipe.loaded == nil)
		TRB.Functions.ThresholdCooldowns:Enable()

		settings.thresholds.icons.showCooldown = showCooldown
		dictEntry.enabled = lineEnabled
	end

	G.GetTime = saved.GetTime
	G.issecretvalue = saved.issecretvalue
	G.C_Spell.GetSpellCooldown = saved.GetSpellCooldown
	G.C_Spell.GetSpellCharges = saved.GetSpellCharges
	G.C_Spell.GetSpellCooldownDuration = saved.GetSpellCooldownDuration
	G.C_Spell.GetSpellChargeDuration = saved.GetSpellChargeDuration
	G.CreateFrame = saved.CreateFrame
	G.C_SpellBook.IsSpellKnown = isSpellKnown
	return failures
end

return hooks
