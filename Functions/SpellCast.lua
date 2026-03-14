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
	if event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_EMPOWER_STOP" then
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local casting = snapshotData.casting

		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			TRB.Functions.Class:SpellCast(event)
			TRB.Functions.Character:ResetCastingSnapshotData() -- Always reset on channel stop to avoid secrets
		elseif casting.spellId == spellId and TRB.Functions.Character.ResetCastingSnapshotData ~= nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
		end

		if event == "UNIT_SPELLCAST_EMPOWER_STOP" then
			TRB.Functions.Class:SpellCast(event, spellId, ...)
		end
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
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
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
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
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
---| '"UNIT_MODEL_CHANGED"' # UNIT_MODEL_CHANGED