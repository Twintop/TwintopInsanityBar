---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.SpellCast = {}

---Handles UNIT_SPELLCAST_* events
---@param self any
---@param event trbSpellCastType
---@param unit UnitToken
---@param castGuid string
---@param spellId integer
local function SpellCastEvent(self, event, unit, castGuid, spellId, ...)
	if unit ~= "player" then
		return
	end
	TRB.Data.lookupDirty = true

	-- Drive the castbar bar type (independent of the class-specific resource routing below). Wrapped in
	-- pcall so a bug in this newer code path can never abort this shared event handler and take the
	-- pre-existing resource-bar cast tracking below down with it.
	local castbarOk, castbarErr = pcall(TRB.Functions.Castbar.OnSpellCastEvent, TRB.Functions.Castbar, event, spellId)
	if not castbarOk then
		geterrorhandler()(castbarErr)
	end

	-- Cache the GCD duration from the dummy GCD spell (61304) on every cast start / instant succeed.
	-- GetTotalDuration() returns the full GCD length in seconds while the GCD is active (0 otherwise).
	-- This replaces haste-based GCD math since haste is now a secret value.
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SUCCEEDED" then
		local durationObj = C_Spell.GetSpellCooldownDuration(61304)
		if durationObj then
			local totalDuration = durationObj:GetTotalDuration()
			if not issecretvalue(totalDuration) and totalDuration > 0 then
				local snapshotData = TRB.Data.snapshotData
				if snapshotData then
					local oldGcd = snapshotData.attributes.gcdDuration or 1.5

					snapshotData.attributes.gcdDuration = totalDuration

					-- Process deferred haste recalc if pending (flagged by UpdateSecondaryStatsSnapshot)
					local pending = snapshotData.attributes.pendingGcdRecalc
					if pending and oldGcd ~= totalDuration then
						snapshotData:RecalculateHastedCooldowns(pending.oldGcd, totalDuration, pending.time)
						snapshotData.attributes.pendingGcdRecalc = nil
					end

					-- Update formatted GCD display (clamped to 0.75 – 1.5)
					local displayGcd = totalDuration
					if displayGcd > 1.5 then displayGcd = 1.5 elseif displayGcd < 0.75 then displayGcd = 0.75 end
					snapshotData.formatted.gcd = string.format("%.2f", displayGcd)
					snapshotData.formatted.gcdRaw = displayGcd

					TRB.Data.lookupDirty = true
				end
			end
		end
	end

	if event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_EMPOWER_STOP"
		or event == "UNIT_SPELLCAST_INTERRUPTED" then
		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			TRB.Functions.Class:SpellCast(event)
		elseif event == "UNIT_SPELLCAST_EMPOWER_STOP" then
			TRB.Functions.Class:SpellCast(event, spellId, ...)
		end
		TRB.Functions.Character:ResetCastingSnapshotData()
		return
	elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_EMPOWER_START" then
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local channelId = select(8, UnitChannelInfo("player"))
			if type(channelId) ~= "secret" then
				TRB.Functions.Class:SpellCast(event, channelId)
			else
				TRB.Functions.Class:SpellCast(event, 0) -- Pass a dummy value to wipe casting data
			end
		else
			TRB.Functions.Class:SpellCast(event, spellId)
		end
		return
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		TRB.Functions.Class:SpellCast(event, spellId, castGuid)
	elseif event == "UNIT_MODEL_CHANGED" then
		-- Some forms change the unit model. We can use this to detect loss or gain of a proc
		TRB.Functions.Class:SpellCast(event, 0)
	elseif event == "SPELL_UPDATE_ICON" then
		TRB.Functions.Class:SpellCast(event, spellId)
	end
end

local spellCastFrame = CreateFrame("Frame")
spellCastFrame:SetScript("OnEvent", SpellCastEvent)


-- NOTE: 2025-11-08 -- UNIT_SPELLCAST_CHANNEL_* still returns a secret. Comment out for now.

---Registers all spell cast related events to begin tracking player spell casts, channels, and empowers
function TRB.Functions.SpellCast:EnableSpellCast()
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	spellCastFrame:RegisterEvent("UNIT_MODEL_CHANGED")
	spellCastFrame:RegisterEvent("SPELL_UPDATE_ICON")
end

---Unregisters all spell cast related events to stop tracking player spell casts, channels, and empowers
function TRB.Functions.SpellCast:DisableSpellCast()
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_STOP")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	spellCastFrame:UnregisterEvent("UNIT_MODEL_CHANGED")
end

---@alias trbSpellCastType
---| '"UNIT_SPELLCAST_START"' # UNIT_SPELLCAST_START
---| '"UNIT_SPELLCAST_STOP"' # UNIT_SPELLCAST_STOP
---| '"UNIT_SPELLCAST_DELAYED"' # UNIT_SPELLCAST_DELAYED
---| '"UNIT_SPELLCAST_SUCCEEDED"' # UNIT_SPELLCAST_SUCCEEDED
---| '"UNIT_SPELLCAST_CHANNEL_START"' # UNIT_SPELLCAST_CHANNEL_START
---| '"UNIT_SPELLCAST_CHANNEL_STOP"' # UNIT_SPELLCAST_CHANNEL_STOP
---| '"UNIT_SPELLCAST_EMPOWER_START"' # UNIT_SPELLCAST_EMPOWER_START
---| '"UNIT_SPELLCAST_EMPOWER_STOP"' # UNIT_SPELLCAST_EMPOWER_STOP
---| '"UNIT_SPELLCAST_INTERRUPTED"' # UNIT_SPELLCAST_INTERRUPTED
---| '"UNIT_MODEL_CHANGED"' # UNIT_MODEL_CHANGED