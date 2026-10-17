local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.ValueReplay = TRB.Functions.ValueReplay or {}

-- Each tick records the writes that read a health or power value. A value event then replays just those
-- writes in its own frame instead of waiting up to 50ms for the next tick; everything else stays on the tick.
local ValueReplay = TRB.Functions.ValueReplay

-- Op slots per channel, reused every tick. A slot holds its replay function plus whatever fields its
-- recorder set; a replay reads only the fields its own recorder wrote.
local channels = {
	health = { count = 0 },
	power = { count = 0 },
}

local recording = false
-- True once a tick has recorded from start to finish; a tick that errors partway leaves it false.
local complete = false
-- Counts completed ticks, so a flush can tell a tick already ran after the event and wrote the same values.
local tickSerial = 0
local recordedBarGroups = nil
local recordedSpecId = nil
-- channel -> the tickSerial its latest Request saw
local requested = {}

local flushFrame = CreateFrame("Frame")
flushFrame:Hide()

---Starts recording a tick, discarding the last one. Call right before the class module's UpdateResourceBar.
function ValueReplay:BeginTick()
	recording = true
	complete = false
	for _, ops in pairs(channels) do
		ops.count = 0
	end
end

---Ends the tick BeginTick started, making its record replayable.
function ValueReplay:EndTick()
	recording = false
	complete = true
	tickSerial = tickSerial + 1
	recordedBarGroups = TRB.Frames.barGroups
	recordedSpecId = TRB.Data.character.specId
end

---Discards the record and any pending flush. The next completed tick records afresh.
function ValueReplay:Clear()
	recording = false
	complete = false
	recordedBarGroups = nil
	for _, ops in pairs(channels) do
		ops.count = 0
	end
	for channel in pairs(requested) do
		requested[channel] = nil
	end
end

---Records one op on a channel while a tick is recording.
---@param channel string # "health" or "power"
---@param replay fun(slot: table) # Re-applies the write from the fields the caller sets on the slot
---@return table|nil # The slot to fill, or nil outside a tick
function ValueReplay:Record(channel, replay)
	if not recording then
		return nil
	end
	local ops = channels[channel]
	local index = ops.count + 1
	local slot = ops[index]
	if slot == nil then
		slot = {}
		ops[index] = slot
	end
	slot.replay = replay
	ops.count = index
	return slot
end

---Asks for a channel's writes to be replayed this frame. Any number of requests in a frame cost one replay.
---@param channel string # "health" or "power"
function ValueReplay:Request(channel)
	requested[channel] = tickSerial
	flushFrame:Show()

	-- TEMPORARY DIAGNOSTIC (/trb tickcost), remove with the probe in Init.lua.
	if TRB.Frames.timerFrame.costProbe ~= nil then
		TRB.Frames.timerFrame:ProbeCount(channel == "health" and "health requests" or "power requests")
	end
end

local function ReplayChannel(channel)
	local ops = channels[channel]
	for i = 1, ops.count do
		local slot = ops[i]
		slot.replay(slot)
	end
	TRB.Functions.BarVisibility:ReplayCurveChannel(channel)
end

flushFrame:SetScript("OnUpdate", function(self)
	self:Hide()
	local valid = complete
		and TRB.Data.specSupported
		and recordedBarGroups == TRB.Frames.barGroups
		and recordedSpecId == TRB.Data.character.specId
		and not TRB.Functions.Bar:IsRenderTransitionActive()

	-- TEMPORARY DIAGNOSTIC (/trb tickcost), remove with the probe in Init.lua.
	local timerFrame = TRB.Frames.timerFrame
	local probing = timerFrame.costProbe ~= nil

	for channel, serial in pairs(requested) do
		requested[channel] = nil
		-- A tick that ran after the request already wrote these values.
		if valid and serial == tickSerial then
			local started = probing and debugprofilestop() or 0
			ReplayChannel(channel)
			if probing then
				timerFrame:ProbeTime("flush " .. channel, debugprofilestop() - started)
			end
		elseif probing then
			timerFrame:ProbeCount(valid and "flush skipped (tick ran)" or "flush skipped (invalid)")
		end
	end
end)
