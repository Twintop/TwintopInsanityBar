---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

--[[
	Castbar: player cast/channel/empower state model for the castbar bar type.
	Holds the currently-active cast timeline in Lua-known times (GetTime based), a cached
	lookup of the casting spell's data, computed channel tick fractions (with chaining carry),
	and empower stage boundaries. It is presentation-agnostic: Functions/Castbar.lua renders it.

	Timing is best-effort under secret values. Casts/empowers expose real start/end times via
	UnitCastingInfo/UnitChannelInfo; channels frequently return secret times, so channel duration
	is reconstructed from a per-spell tick profile scaled by the GCD-inferred haste multiplier.

	Bulk crafting (professions "Create All") merges the run of individual craft casts into one
	channel-shaped timeline: total time = single craft cast time * queued count, re-extrapolated from
	real elapsed time as each craft starts, with tick lines at the craft boundaries.
]]

---@alias trbCastbarState
---| '"none"'    # Nothing casting
---| '"cast"'    # Standard cast (fills up)
---| '"channel"' # Channel (depletes)
---| '"empower"' # Empowered cast (fills up through stages)

---@class TRB.Classes.CastbarSpell
---@field public id integer
---@field public name string
---@field public iconId integer
---@field public icon string # Inline |T...|t texture string

---@class TRB.Classes.CastbarTick
---@field public fraction number # Position along the bar, 0 (start) .. 1 (end)

---@class TRB.Classes.Castbar
---@field public state trbCastbarState
---@field public spellId integer?
---@field public spell TRB.Classes.CastbarSpell?
---@field public startTime number? # GetTime() seconds when the cast began
---@field public endTime number? # GetTime() seconds when the cast completes
---@field public duration number # endTime - startTime (seconds)
---@field public latency number # Latency captured at cast start (seconds)
---@field public pushback number # Accumulated pushback delay (seconds)
---@field public notInterruptible boolean
---@field public reconstructed boolean # True when channel timing was reconstructed from GCD+profile (times not authoritative)
---@field public ticks TRB.Classes.CastbarTick[] # Channel tick positions
---@field public tickInterval number? # Tick rate (seconds between ticks), derived from the nominal channel length
---@field public profile table? # Tick profile resolved at channel start (baseline + conditional bonus ticks); reused for mid-channel recomputes
---@field public chains boolean # Whether the active channel's profile allows chain carry
---@field public chainCarry number? # Carried leftover (seconds, c0): time that remained until the interrupted channel's next tick
---@field public chainOldRate number? # The interrupted channel's tick rate (r0), so the carried leftover can be rescaled to this channel's haste
---@field public firstTickOffset number? # Time (seconds from channel start) of this channel's first rhythm tick; the phase anchor for computing the next chain carry
---@field public empowerStages integer # Number of empower stages (0 if not an empower)
---@field public empowerStageFractions number[] # Cumulative fraction at each stage completion (max line at chargeDuration/duration)
---@field public empowerChargeDuration number # Empower charge time to reach max (seconds), excluding the hold-at-max tail
---@field public empowerHoldDuration number # Empower hold-at-max window (seconds) appended after the charge portion
---@field public tradeskill boolean # Bulk crafting merge active: repeated craft casts shown as one channel
---@field public tradeskillTotal integer # Total crafts queued in the merge
---@field public tradeskillRemaining integer # Crafts not yet completed (including the one in flight)
---@field public tradeskillWaitUntil number? # Grace deadline while between crafts (nil while a craft cast is in flight)
TRB.Classes.Castbar = {}
TRB.Classes.Castbar.__index = TRB.Classes.Castbar

-- Base (unhasted) global cooldown length. Haste is inferred as baseGcd / currentGcdDuration.
local BASE_GCD = 1.5

-- Shared spell-data cache across instances: spellId -> TRB.Classes.CastbarSpell
local spellCache = {}

-- Chaining carry: when a chainable channel ends mid-tick, the leftover phase (and the channel's tick rate)
-- is stored here so the next channel of the same spell can place its first tick at the rescaled remainder.
---@type { spellId: integer, phaseRemaining: number, oldTickRate: number, expireTime: number }?
local chainCarry = nil

-- Grace window (seconds) during which a channel-end carry remains valid for the next channel.
local CHAIN_CARRY_GRACE = 1.0

-- Grace window (seconds, plus latency) for the next craft cast of a bulk-crafting merge to start after
-- the previous one stops; past it the merge is considered halted (out of reagents, window closed, etc).
local TRADESKILL_RESUME_GRACE = 1.0

-- Craft-boundary tick lines get unreadably dense on large queues; skip drawing them past this count.
local TRADESKILL_MAX_TICKS = 40

---Banks the leftover tick phase of the model's active chainable channel into chainCarry so the next
---channel of the same spell (within the grace window) starts with the carried partial tick. Anchored to
---the channel's first-tick offset, which itself may have been carried in (chain of chains).
---@param model TRB.Classes.Castbar
local function StoreChainCarry(model)
	if model.state ~= "channel" or not model.chains or model.spellId == nil
		or model.tickInterval == nil or model.tickInterval <= 0 or model.startTime == nil then
		return
	end
	local now = GetTime()
	local elapsed = now - model.startTime
	if elapsed <= 0 then
		return
	end
	-- Ticks occur at firstTickOffset + k*tickInterval, so the leftover until the next tick is one interval
	-- minus how far into the current interval we are (measured from that first-tick phase anchor). This
	-- leftover (c0) carries to the next chained channel, rescaled there to its own haste.
	local anchor = model.firstTickOffset or 0
	local remaining = model.tickInterval - ((elapsed - anchor) % model.tickInterval)
	if remaining <= 0 or remaining >= model.tickInterval then
		return
	end
	chainCarry = {
		spellId = model.spellId,
		phaseRemaining = remaining,
		oldTickRate = model.tickInterval,
		expireTime = now + CHAIN_CARRY_GRACE
	}
end

---Creates a new Castbar model
---@return TRB.Classes.Castbar
function TRB.Classes.Castbar:New()
	local self = {}
	setmetatable(self, TRB.Classes.Castbar)
	self:Reset()
	return self
end

---Resets the model to the idle (nothing casting) state
function TRB.Classes.Castbar:Reset()
	self.state = "none"
	self.spellId = nil
	self.spell = nil
	self.startTime = nil
	self.endTime = nil
	self.duration = 0
	self.latency = 0
	self.pushback = 0
	self.notInterruptible = false
	self.reconstructed = false
	self.ticks = {}
	self.tickInterval = nil
	self.profile = nil
	self.chains = false
	self.chainCarry = nil
	self.chainOldRate = nil
	self.firstTickOffset = nil
	self.empowerStages = 0
	self.empowerStageFractions = {}
	self.empowerChargeDuration = 0
	self.empowerHoldDuration = 0
	self.tradeskill = false
	self.tradeskillTotal = 0
	self.tradeskillRemaining = 0
	self.tradeskillWaitUntil = nil
end

---Returns cached spell data for a spellId, populating the cache on first use.
---@param spellId integer?
---@return TRB.Classes.CastbarSpell?
function TRB.Classes.Castbar:GetSpellData(spellId)
	if spellId == nil or spellId == 0 or issecretvalue(spellId) then
		return nil
	end
	local cached = spellCache[spellId]
	if cached then
		return cached
	end
	local info = C_Spell.GetSpellInfo(spellId)
	if info == nil then
		return nil
	end
	local iconId = info.iconID or 134400 -- fallback to question mark icon
	---@type TRB.Classes.CastbarSpell
	local data = {
		id = info.spellID or spellId,
		name = info.name or "",
		iconId = iconId,
		icon = string.format("|T%s:0|t", iconId)
	}
	spellCache[spellId] = data
	return data
end

---Infers the current haste multiplier (>= 1.0) from the whitelisted GCD spell duration cached on the
---snapshot (see TRB.Classes.SnapshotData:UpdateGCD). At >100% haste the GCD floors at 0.75s, so this saturates
---near 2.0; that is an accepted best-effort limit for channel tick reconstruction.
---@return number
function TRB.Classes.Castbar:GetHasteMultiplier()
	local gcd = BASE_GCD
	local snapshotData = TRB.Data.snapshotData
	if snapshotData and snapshotData.attributes and snapshotData.attributes.gcdDuration then
		local g = snapshotData.attributes.gcdDuration
		if type(g) == "number" and g > 0 then
			gcd = g
		end
	end
	local mult = BASE_GCD / gcd
	return mult
end

---Reads player cast timing from UnitCastingInfo, returning seconds. Values may be secret.
---@return integer? spellId, number? startTime, number? endTime, boolean notInterruptible
local function ReadCastingInfo()
	local _, _, _, startMS, endMS, _, _, notInterruptible, spellId = UnitCastingInfo("player")
	if spellId == nil then
		return nil, nil, nil, false
	end
	local startTime, endTime
	if startMS ~= nil and endMS ~= nil and not issecretvalue(startMS) and not issecretvalue(endMS) then
		startTime = startMS / 1000
		endTime = endMS / 1000
	end
	return spellId, startTime, endTime, notInterruptible == true
end

---Reads player channel/empower timing from UnitChannelInfo, returning seconds. Values may be secret.
---@return integer? spellId, number? startTime, number? endTime, boolean notInterruptible, boolean isEmpowered, integer numStages
local function ReadChannelInfo()
	local _, _, _, startMS, endMS, _, notInterruptible, spellId, isEmpowered, numStages = UnitChannelInfo("player")
	local startTime, endTime
	if startMS ~= nil and endMS ~= nil and not issecretvalue(startMS) and not issecretvalue(endMS) then
		startTime = startMS / 1000
		endTime = endMS / 1000
	end
	local stages = 0
	if not issecretvalue(numStages) and type(numStages) == "number" then
		stages = numStages
	end
	return spellId, startTime, endTime, notInterruptible == true, isEmpowered == true, stages
end

---Begins tracking a standard cast. Reads real timing from UnitCastingInfo when available.
---@param spellId integer? # Spell id from the event (authoritative name/icon source)
function TRB.Classes.Castbar:StartCast(spellId)
	local infoSpellId, startTime, endTime, notInterruptible = ReadCastingInfo()
	local resolvedId = spellId
	if resolvedId == nil or resolvedId == 0 or issecretvalue(resolvedId) then
		resolvedId = infoSpellId
	end

	self:Reset()
	self.state = "cast"
	self.spellId = (not issecretvalue(resolvedId)) and resolvedId or nil
	self.spell = self:GetSpellData(self.spellId)
	self.notInterruptible = notInterruptible
	self.latency = TRB.Data.character and TRB.Data.character.latency or 0

	local now = GetTime()
	if startTime ~= nil and endTime ~= nil and endTime > startTime then
		self.startTime = startTime
		self.endTime = endTime
		self.reconstructed = false
	else
		-- No readable timing: fall back to a GCD-length window so the bar still animates.
		self.startTime = now
		self.endTime = now + BASE_GCD
		self.reconstructed = true
	end
	self.duration = self.endTime - self.startTime
end

---Begins tracking a channel. Uses real timing when UnitChannelInfo exposes it, otherwise reconstructs
---the duration from the tick profile scaled by GCD-inferred haste. Computes tick fractions (with chaining).
---@param spellId integer? # Channel spell id resolved by the caller (may be nil if secret)
---@param profile table? # Resolved tick profile { mode, baseDuration, tickCount?, baseTickRate?, firstTickAtStart?, chains? }; kept on the model so recomputes don't re-evaluate conditional bonuses
function TRB.Classes.Castbar:StartChannel(spellId, profile)
	local infoSpellId, startTime, endTime, notInterruptible = ReadChannelInfo()
	local resolvedId = spellId
	if resolvedId == nil or resolvedId == 0 or issecretvalue(resolvedId) then
		resolvedId = (not issecretvalue(infoSpellId)) and infoSpellId or nil
	end

	-- Chained channel: WoW fires CHANNEL_START for the new channel while the old one is still active
	-- (no CHANNEL_STOP in between), so bank the old channel's leftover tick phase before resetting.
	StoreChainCarry(self)

	self:Reset()
	self.state = "channel"
	self.spellId = (resolvedId and not issecretvalue(resolvedId)) and resolvedId or nil
	self.spell = self:GetSpellData(self.spellId)
	self.notInterruptible = notInterruptible
	self.latency = TRB.Data.character and TRB.Data.character.latency or 0
	self.chains = (profile ~= nil and profile.chains) == true
	self.profile = profile

	-- Consume a pending carry (same spell, within grace): the leftover until the previous channel's next
	-- tick lengthens this channel by one tick (see the duration adjustment below).
	if self.chains and chainCarry ~= nil and self.spellId ~= nil
		and chainCarry.spellId == self.spellId and GetTime() <= chainCarry.expireTime then
		self.chainCarry = chainCarry.phaseRemaining
		self.chainOldRate = chainCarry.oldTickRate
	end
	chainCarry = nil

	local now = GetTime()
	local haste = self:GetHasteMultiplier()

	-- Determine the channel duration. Prefer authoritative timing; else reconstruct from the profile.
	local duration
	if startTime ~= nil and endTime ~= nil and endTime > startTime then
		self.startTime = startTime
		self.endTime = endTime
		self.reconstructed = false
		duration = endTime - startTime
	elseif profile and profile.baseDuration and profile.baseDuration > 0 then
		if profile.mode == "fixedRate" then
			-- fixedRate (e.g. Void Torrent): duration is fixed, tick rate scales with haste.
			duration = profile.baseDuration
		else
			-- fixedCount (e.g. Mind Flay) and pandemic (e.g. Drain Life): duration shrinks with haste, tick
			-- count stays constant.
			duration = profile.baseDuration / haste
		end
		self.startTime = now
		self.endTime = now + duration
		self.reconstructed = true
	else
		-- Unknown channel: single GCD-length window, no ticks.
		duration = BASE_GCD / haste
		self.startTime = now
		self.endTime = now + duration
		self.reconstructed = true
	end
	self.duration = duration

	-- A chained channel runs longer than nominal by the carried leftover. Authoritative timing already
	-- reflects this (its end time gets nudged out by CHANNEL_UPDATE); a reconstructed duration does not, so
	-- lengthen it here so the extra tick fits.
	if self.reconstructed and self.chainCarry ~= nil and self.chainCarry > 0 then
		self.duration = self.duration + self.chainCarry
		self.endTime = self.startTime + self.duration
	end

	self:ComputeChannelTicks(profile, haste)
end

---Computes channel tick positions (fraction 0..1 along the depleting bar) and stores them on self.ticks.
---A tick firing at elapsed time t sits at bar fraction 1 - t/duration (the fill edge's spot when it fires),
---so fraction 1 is the channel START (full bar) and fraction 0 the END.
---
---The tick interval R is derived from the NOMINAL (un-extended, channel-start) length: from the authoritative
---channel duration where it is un-stretched, falling back to GCD-inferred haste only on a chain (whose own
---duration is stretched by the carry). firstTickAtStart is the game's "tick zero": a mark lands at t=0, on top
---of the rhythm below. Each mode lays out its rhythm differently:
---
---fixedCount (Mind Flay): tick count is constant, duration shrinks with haste. Anchored to the END -- the
---final tick ALWAYS lands on the channel end, no exceptions. A chain-extended cast surfaces the carried
---leftover as an extra tick near the START, leaving a gap before it, rather than moving the last tick.
---
---pandemic (Drain Life/Drain Soul/Malefic Grasp): tick count is constant, duration shrinks with haste. Rate r1
---is the FRESH (channel-start) rate -- from the authoritative duration on a fresh cast, or GCD-inferred haste on
---a chain (whose own duration is stretched). Anchored to the START and runs FORWARD every r1. A chain recast
---happens a fraction p0 = c0/r0 before the interrupted channel's next tick (c0 = carried leftover, r0 = its
---rate), so the first (chain) tick lands p0*r1 in and the rhythm continues from there; a fresh cast starts one
---interval in. A final PARTIAL tick pins to the channel end if the last full beat falls short. Per-spell and NOT
---derivable -- Mind Flay (fixedCount) does not do it.
---
---fixedRate (Void Torrent): fixed duration, hasted rate. Anchored to the START, runs forwards, and its final
---partial tick is simply cut off at the channel end.
---@param profile table?
---@param haste number
function TRB.Classes.Castbar:ComputeChannelTicks(profile, haste)
	self.ticks = {}
	self.tickInterval = nil
	if profile == nil or self.duration == nil or self.duration <= 0 then
		return
	end
	if haste == nil or haste <= 0 then
		haste = 1
	end

	local duration = self.duration
	local firstAtStart = profile.firstTickAtStart == true

	local tickRate
	if profile.mode == "fixedCount" then
		local count = profile.tickCount or 0
		if count <= 0 then return end
		-- tick-zero channels span [0, nominal] with a tick at each end, so there are count-1 intervals;
		-- otherwise the count ticks land at R, 2R, ..., nominal.
		local intervals = firstAtStart and (count - 1) or count
		if intervals < 1 then intervals = 1 end
		-- Rate from the NOMINAL (un-extended, channel-start) length so a chain-extended duration doesn't stretch
		-- the (end-anchored) spacing. A chain adds exactly the carried leftover, so subtract it back out.
		local nominal = duration - (self.chainCarry or 0)
		if nominal <= 0 or nominal > duration then nominal = duration end
		tickRate = nominal / intervals
	elseif profile.mode == "pandemic" then
		local count = profile.tickCount or 0
		if count <= 0 then return end
		local intervals = firstAtStart and (count - 1) or count
		if intervals < 1 then intervals = 1 end
		-- r1 = the fresh (channel-start) tick rate. On a chain this channel's own duration is stretched by the
		-- carried leftover, so it can't yield r1; derive it from GCD-inferred haste instead. A fresh cast's
		-- authoritative duration IS the fresh length, so use it directly.
		if self.chainCarry ~= nil and self.chainCarry > 0 then
			tickRate = (profile.baseDuration / haste) / intervals
		else
			tickRate = duration / intervals
		end
	else
		local baseRate = profile.baseTickRate or 0
		if baseRate <= 0 then return end
		tickRate = baseRate / haste
	end
	if tickRate <= 0 then return end
	self.tickInterval = tickRate

	-- Tick zero: a mark at t=0 (full bar), on top of the rhythm below.
	if firstAtStart then
		self.ticks[#self.ticks + 1] = { fraction = 1 }
	end

	-- Some channels hit on only a subset of their rhythm (e.g. Demolish lands 3 hits on a 4-tick rhythm,
	-- skipping the 3rd). Spacing still comes from the full rhythm, so only the mark is suppressed.
	local skip = nil
	if profile.skipTicks ~= nil then
		skip = {}
		for _, index in ipairs(profile.skipTicks) do
			skip[index] = true
		end
	end

	-- Collect the rhythm's tick times. Each mode places them differently:
	local times = {}
	if profile.mode == "fixedCount" then
		-- End-anchored: the final tick ALWAYS lands exactly on the channel end -- no exceptions. Step backwards
		-- from the end by one interval at a time, so a chain-extended duration surfaces the carried leftover as
		-- an extra tick near the START (with a gap before it) instead of dragging the last tick off the end.
		local t = duration
		while t > 0.0001 and #times < 1000 do
			times[#times + 1] = t
			t = t - tickRate
		end
		-- Reverse to ascending order so skipTicks (1-based from the earliest beat) still indexes correctly.
		local n = #times
		for i = 1, math.floor(n / 2) do
			times[i], times[n - i + 1] = times[n - i + 1], times[i]
		end
	elseif profile.mode == "pandemic" then
		-- Start-anchored, running FORWARD from the first tick every r1. On a chain the recast happened a fraction
		-- p0 = c0/r0 before the interrupted channel's next tick (c0 = carried leftover, r0 = its tick rate), so
		-- that fraction still owes p0 of a tick: rescaled to this channel's rate, the first (chain) tick lands
		-- p0*r1 in, then the rhythm continues every r1. A fresh cast simply starts one interval in. If the last
		-- full beat falls short of the channel end, a PARTIAL tick pins to the end (damage scaled to that phase).
		local firstOffset = tickRate
		if self.chainCarry ~= nil and self.chainCarry > 0 and self.chainOldRate ~= nil and self.chainOldRate > 0 then
			local p0 = self.chainCarry / self.chainOldRate
			firstOffset = p0 * tickRate
		end
		local t = firstOffset
		while t <= duration + 0.0001 and #times < 1000 do
			times[#times + 1] = t
			t = t + tickRate
		end
		local last = times[#times]
		if last == nil or (duration - last) > 0.0001 then
			times[#times + 1] = duration
		end
	else
		-- fixedRate: start-anchored, running forwards; fixed duration with a hasted rate, so the final partial
		-- tick is simply cut off at the channel end.
		local t = (self.chainCarry ~= nil and self.chainCarry > 0) and self.chainCarry or tickRate
		while t <= duration + 0.0001 and #times < 1000 do
			times[#times + 1] = t
			t = t + tickRate
		end
	end

	-- Phase anchor for the next chain: the first tick's time. All rhythms are firstTickOffset + k*tickInterval,
	-- so this lets StoreChainCarry compute the leftover to the next tick regardless of which mode placed them.
	self.firstTickOffset = times[1]

	for i, time in ipairs(times) do
		if skip == nil or not skip[i] then
			local fraction = 1 - time / duration
			if fraction < 0 then fraction = 0 elseif fraction > 1 then fraction = 1 end
			self.ticks[#self.ticks + 1] = { fraction = fraction }
		end
	end
end

---Begins tracking a bulk-crafting run as one merged channel-style bar: the queued craft casts display as
---a single depleting channel whose total time is the single craft cast time * queued count. The estimate
---self-corrects as each craft starts (see ContinueTradeskill).
---@param spellId integer? # Recipe cast spell id from the event
---@param count integer # Number of crafts queued (> 1)
function TRB.Classes.Castbar:StartTradeskill(spellId, count)
	local infoSpellId, startTime, endTime, notInterruptible = ReadCastingInfo()
	local resolvedId = spellId
	if resolvedId == nil or resolvedId == 0 or issecretvalue(resolvedId) then
		resolvedId = infoSpellId
	end

	self:Reset()
	self.state = "channel"
	self.spellId = (resolvedId ~= nil and not issecretvalue(resolvedId)) and resolvedId or nil
	self.spell = self:GetSpellData(self.spellId)
	self.notInterruptible = notInterruptible
	self.latency = TRB.Data.character and TRB.Data.character.latency or 0
	self.tradeskill = true
	self.tradeskillTotal = count
	self.tradeskillRemaining = count

	local now = GetTime()
	local castDuration
	if startTime ~= nil and endTime ~= nil and endTime > startTime then
		castDuration = endTime - startTime
		self.startTime = startTime
		self.reconstructed = false
	else
		castDuration = BASE_GCD
		self.startTime = now
		self.reconstructed = true
	end
	self.duration = castDuration * count
	self.endTime = self.startTime + self.duration
	self:ComputeTradeskillTicks()
end

---Advances the merged bulk-crafting bar when the next individual craft cast starts: re-extrapolates the
---total duration from real elapsed time over the completed fraction, absorbing the inter-cast gaps.
function TRB.Classes.Castbar:ContinueTradeskill()
	if not self.tradeskill or self.startTime == nil then
		return
	end
	self.tradeskillWaitUntil = nil
	local completed = self.tradeskillTotal - self.tradeskillRemaining
	if completed > 0 then
		local elapsed = GetTime() - self.startTime
		if elapsed > 0 then
			self.duration = elapsed * self.tradeskillTotal / completed
			self.endTime = self.startTime + self.duration
		end
	end
	self:ComputeTradeskillTicks()
end

---Marks one craft of the merged bulk-crafting bar as completed (its individual UNIT_SPELLCAST_STOP).
---@return boolean # true when crafts remain (keep the merged bar running through the gap), false when done
function TRB.Classes.Castbar:TradeskillCastStopped()
	if not self.tradeskill then
		return false
	end
	self.tradeskillRemaining = self.tradeskillRemaining - 1
	if self.tradeskillRemaining <= 0 then
		return false
	end
	-- The next craft's START normally arrives within a fraction of a second; if it never comes (out of
	-- reagents, profession window closed, crafting stopped), the per-frame updater tears the bar down.
	self.tradeskillWaitUntil = GetTime() + TRADESKILL_RESUME_GRACE + (self.latency or 0)
	return true
end

---Returns the 1-based index of the craft currently in progress in a merged bulk-crafting bar (during the
---gap after a completed craft this is already the upcoming one), clamped to the total. 0 when not merging.
---@return integer
function TRB.Classes.Castbar:GetTradeskillIndex()
	if not self.tradeskill or self.tradeskillTotal <= 0 then
		return 0
	end
	return math.min(self.tradeskillTotal - self.tradeskillRemaining + 1, self.tradeskillTotal)
end

---Places a tick line at each craft boundary of the merged bulk-crafting bar. The bar depletes, so the
---i-th boundary is crossed when the fill edge reaches 1 - i/total (same mirroring as fixedRate channels).
function TRB.Classes.Castbar:ComputeTradeskillTicks()
	self.ticks = {}
	self.tickInterval = nil
	local total = self.tradeskillTotal
	if not self.tradeskill or total <= 1 or total > TRADESKILL_MAX_TICKS then
		return
	end
	for i = 1, total - 1 do
		self.ticks[#self.ticks + 1] = { fraction = 1 - (i / total) }
	end
end

---Begins tracking an empowered cast. Reads stage count and per-stage durations (best-effort under
---secret values), computing cumulative stage boundary fractions for threshold placement.
---@param spellId integer?
function TRB.Classes.Castbar:StartEmpower(spellId)
	local infoSpellId, startTime, endTime, notInterruptible, _, numStages = ReadChannelInfo()
	local resolvedId = spellId
	if resolvedId == nil or resolvedId == 0 or issecretvalue(resolvedId) then
		resolvedId = (not issecretvalue(infoSpellId)) and infoSpellId or nil
	end

	self:Reset()
	self.state = "empower"
	self.spellId = (resolvedId and not issecretvalue(resolvedId)) and resolvedId or nil
	self.spell = self:GetSpellData(self.spellId)
	self.notInterruptible = notInterruptible
	self.latency = TRB.Data.character and TRB.Data.character.latency or 0

	local now = GetTime()
	if startTime ~= nil and endTime ~= nil and endTime > startTime then
		self.startTime = startTime
		self.endTime = endTime
		self.reconstructed = false
	else
		self.startTime = now
		self.endTime = now + BASE_GCD
		self.reconstructed = true
	end

	-- endTime from UnitChannelInfo is when the FINAL (max) empower stage is reached; the charge portion
	-- is startTime..endTime. Blizzard's cast bar then extends through the hold-at-max window (you may keep
	-- holding at max before releasing), so the visible timeline is charge + hold. Including the hold here
	-- is what makes the stage lines and the total time match the default bar: every stage completion
	-- (including max) lands inside the bar, and the tail past the max line is the hold zone.
	self.empowerChargeDuration = self.endTime - self.startTime
	local hold = 0
	if GetUnitEmpowerHoldAtMaxTime then
		local h = GetUnitEmpowerHoldAtMaxTime("player")
		if type(h) == "number" and not issecretvalue(h) and h > 0 then
			hold = h / 1000
		end
	end
	self.empowerHoldDuration = hold
	self.endTime = self.endTime + hold
	self.duration = self.endTime - self.startTime

	-- numStages from UnitChannelInfo is the authoritative empower stage count (matches Blizzard's cast
	-- bar): a line is drawn at each of the N stage completions. With the hold tail the max completion is
	-- interior (not at the bar's end), so all N lines are visible.
	self.empowerStages = numStages or 0
	self:ComputeEmpowerStages()
end

---Computes cumulative empower stage-completion fractions along the full (charge + hold-at-max) timeline.
---Uses GetUnitEmpowerStageDuration when it returns non-secret values; otherwise divides the charge
---portion evenly (empower stages are equal-duration in game time). One line is placed at each of the
---N = empowerStages completions; the N-th (max) line sits at chargeDuration/duration, so whenever there
---is a hold-at-max tail it lands short of 1.0 and stays visible, with the region past it being the hold.
function TRB.Classes.Castbar:ComputeEmpowerStages()
	self.empowerStageFractions = {}
	local numStages = self.empowerStages or 0
	if numStages <= 0 or self.duration == nil or self.duration <= 0 then
		return
	end
	local chargeDuration = self.empowerChargeDuration or self.duration

	-- Try authoritative per-stage durations first. Query every stage (0 .. numStages-1); the running sum
	-- after the last stage equals the charge duration (time to reach max).
	local cumulative = 0
	local ok = true
	local fractions = {}
	for i = 0, numStages - 1 do
		local d = GetUnitEmpowerStageDuration("player", i)
		if d == nil or issecretvalue(d) or type(d) ~= "number" or d < 0 then
			ok = false
			break
		end
		cumulative = cumulative + d / 1000
		fractions[i + 1] = math.min(1, cumulative / self.duration)
	end

	if ok then
		self.empowerStageFractions = fractions
	else
		-- Even-division fallback: equal-duration stages put the i-th of numStages completions at
		-- i/numStages of the CHARGE portion; scale by chargeDuration/duration so the hold tail is
		-- preserved past the final (max) line.
		local scale = chargeDuration / self.duration
		for i = 1, numStages do
			self.empowerStageFractions[i] = math.min(1, (i / numStages) * scale)
		end
	end
end

---Records pushback for a standard cast after UNIT_SPELLCAST_DELAYED by re-reading the (later) end time.
function TRB.Classes.Castbar:Delayed()
	if self.state ~= "cast" then
		return
	end
	local _, startTime, endTime = ReadCastingInfo()
	if startTime ~= nil and endTime ~= nil and endTime > startTime then
		if self.endTime then
			local delta = endTime - self.endTime
			if delta > 0 then
				self.pushback = self.pushback + delta
			end
		end
		self.startTime = startTime
		self.endTime = endTime
		self.duration = endTime - startTime
	end
end

---Re-reads channel timing after UNIT_SPELLCAST_CHANNEL_UPDATE (e.g. a chain nudging the end time out).
---Pushback never applies to a channel, so this only updates timing -- it does not accumulate pushback.
function TRB.Classes.Castbar:ChannelUpdate()
	-- A bulk-crafting merge is channel-shaped but not a real channel; UnitChannelInfo has nothing for it.
	if self.state ~= "channel" or self.tradeskill then
		return
	end
	local _, startTime, endTime = ReadChannelInfo()
	if startTime ~= nil and endTime ~= nil and endTime > startTime then
		self.startTime = startTime
		self.endTime = endTime
		self.duration = endTime - startTime
	end
end

---Stops the active cast. Does NOT bank a chain carry: a natural channel end has no in-progress partial
---tick, and an interrupt/cancel breaks the cadence. True chains (a new CHANNEL_START arriving while still
---channeling, with no CHANNEL_STOP between) bank their carry in StartChannel instead.
function TRB.Classes.Castbar:Stop()
	self:Reset()
end

---Whether a cast/channel/empower is currently being tracked.
---@return boolean
function TRB.Classes.Castbar:IsActive()
	return self.state ~= "none"
end

---Returns the timeline progress at a point in time.
---@param now number? # GetTime() seconds; defaults to GetTime()
---@return number elapsed # Seconds elapsed (clamped >= 0)
---@return number remaining # Seconds remaining (clamped >= 0)
---@return number duration # Total duration (seconds)
---@return number fillFraction # Bar fill 0..1, oriented per state (cast/empower grow, channel depletes)
function TRB.Classes.Castbar:GetProgress(now)
	now = now or GetTime()
	if self.startTime == nil or self.endTime == nil or self.duration <= 0 then
		return 0, 0, 0, 0
	end
	local elapsed = now - self.startTime
	if elapsed < 0 then elapsed = 0 end
	if elapsed > self.duration then elapsed = self.duration end
	local remaining = self.duration - elapsed
	local progress = elapsed / self.duration
	local fill
	if self.state == "channel" then
		fill = 1 - progress -- channels deplete
	else
		fill = progress -- casts/empowers fill up
	end
	return elapsed, remaining, self.duration, fill
end

---Returns the fraction (0..1) of the timeline the latency "safe zone" occupies, measured from the END.
---Marks the window where queuing the next spell is safe; SetupOverlays draws it on the bar's ending side
---(fraction 1 for casts/empowers, fraction 0 for depleting channels). Nil when latency is 0.
---@return number?
function TRB.Classes.Castbar:GetLatencyFraction()
	if self.latency == nil or self.latency <= 0 or self.duration == nil or self.duration <= 0 then
		return nil
	end
	local frac = self.latency / self.duration
	if frac > 1 then frac = 1 end
	return frac
end

---Returns the pushback fraction (0..1) of the total duration, or nil when there is no pushback.
---@return number?
function TRB.Classes.Castbar:GetPushbackFraction()
	if self.pushback == nil or self.pushback <= 0 or self.duration == nil or self.duration <= 0 then
		return nil
	end
	local frac = self.pushback / self.duration
	if frac > 1 then frac = 1 end
	return frac
end

---Returns the current empower stage index (1-based) reached at a point in time, or 0 if none.
---@param now number?
---@return integer
function TRB.Classes.Castbar:GetCurrentEmpowerStage(now)
	if self.state ~= "empower" or #self.empowerStageFractions == 0 then
		return 0
	end
	now = now or GetTime()
	local _, _, _, fill = self:GetProgress(now)
	local stage = 0
	for i = 1, #self.empowerStageFractions do
		if fill >= self.empowerStageFractions[i] - 0.0001 then
			stage = i
		end
	end
	return stage
end
