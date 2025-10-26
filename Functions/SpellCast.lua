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
local function SpellCastEvent(self, event, unit, castGuid, spellId)
	if unit ~= "player" then
		return
	end

	if event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_EMPOWER_STOP" then
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local casting = snapshotData.casting
		--[[if casting.spellId == spellId and TRB.Functions.Character.ResetCastingSnapshotData ~= nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
		end]]
		return
	elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_EMPOWER_START" then
		--TRB.Functions.Class:SpellCast(event, spellId)
		return
	end
end

local spellCastFrame = CreateFrame("Frame")
spellCastFrame:SetScript("OnEvent", SpellCastEvent)

function TRB.Functions.SpellCast:EnableSpellCast()
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	spellCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
end

function TRB.Functions.SpellCast:DisableSpellCast()
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_STOP")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	spellCastFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
end

---@alias trbSpellCastType
---| '"UNIT_SPELLCAST_START"' # UNIT_SPELLCAST_START
---| '"UNIT_SPELLCAST_STOP"' # UNIT_SPELLCAST_STOP
---| '"UNIT_SPELLCAST_DELAYED"' # UNIT_SPELLCAST_DELAYED
---| '"UNIT_SPELLCAST_CHANNEL_START"' # UNIT_SPELLCAST_CHANNEL_START
---| '"UNIT_SPELLCAST_CHANNEL_STOP"' # UNIT_SPELLCAST_CHANNEL_STOP
---| '"UNIT_SPELLCAST_EMPOWER_START"' # UNIT_SPELLCAST_EMPOWER_START
---| '"UNIT_SPELLCAST_EMPOWER_STOP"' # UNIT_SPELLCAST_EMPOWER_STOP