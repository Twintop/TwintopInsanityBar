-- Checks the threshold line cooldown tracker (#279): snapshot coverage, the event filter, the cooldown flag rules, and the end widget.
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
	G.C_Spell.GetSpellCooldown = function(id)
		if trackedIds[id] then
			cooldownReads = cooldownReads + 1
		end
		readsById[id] = (readsById[id] or 0) + 1
		return readings[id] or saved.GetSpellCooldown(id)
	end
	local chargeReads = 0
	G.C_Spell.GetSpellCharges = function()
		chargeReads = chargeReads + 1
		return { currentCharges = SECRET, maxCharges = 2, cooldownStartTime = SECRET, cooldownDuration = SECRET, chargeModRate = 1, isActive = true }
	end
	local durationObject = { HasSecretValues = function() return true end }
	G.C_Spell.GetSpellCooldownDuration = function(id) return readings[id] ~= nil and durationObject or nil end
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
