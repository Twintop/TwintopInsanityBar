local _, TRB = ...
if TRB.Data.character.classId ~= 4 then -- Only do this if we are on a Rogue!
	return
end

-- Rogue runtime (World of Warcraft Classic). The runtime template installs the resource, health,
-- combo point, bar text and spec-switching behavior for the archetypes declared in Classes\RogueClasses.lua;
-- ability tracking specific to this class is layered on top of the returned runtime table.
local runtime = TRB.Classic.Templates.Runtime:Install("rogue")

local lookupChanged = TRB.Functions.BarText.LookupChanged

-- The last Slice and Dice cast sent and the cached combo points then, before the server spends them.
local sentCast = { castGuid = nil, comboPoints = nil }

-- /trb snd (temporary): one line per cast with each combo point reading, and one when the timer ends.
local diagnostic = { enabled = false }

---The active spell set's Slice and Dice snapshot and the spell set, or nil before the spec cache loads.
---@return TRB.Classes.Snapshot?, TRB.Classes.Classic.Rogue.GeneralSpells?
local function GetSliceAndDice()
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Classic.Rogue.GeneralSpells?]]
	local snapshotData = TRB.Data.snapshotData
	if spells == nil or spells.sliceAndDice == nil or snapshotData == nil then
		return nil, nil
	end
	return snapshotData.snapshots[spells.sliceAndDice.id], spells
end

---Whether a cast is any rank of Slice and Dice.
---@param spells TRB.Classes.Classic.Rogue.GeneralSpells
---@param spellId any
---@return boolean
local function IsSliceAndDice(spells, spellId)
	if spellId == nil or issecretvalue(spellId) then
		return false
	end
	local castSpells = TRB.Data.spellsData.spellsById[spellId]
	return castSpells ~= nil and tContains(castSpells, spells.sliceAndDice)
end

---Improved Slice and Dice's rank, 0 when not talented.
---@param spells TRB.Classes.Classic.Rogue.GeneralSpells
---@return integer
local function GetImprovedRank(spells)
	local improved = runtime.talents ~= nil and runtime.talents.talents[spells.improvedSliceAndDice.id] or nil
	if improved == nil or not improved:IsActive() then
		return 0
	end
	return improved.currentRank
end

---Slice and Dice's duration for a cast that spends these combo points.
---@param spells TRB.Classes.Classic.Rogue.GeneralSpells
---@param comboPoints integer
---@return number
local function GetSliceAndDiceDuration(spells, comboPoints)
	local sliceAndDice = spells.sliceAndDice
	local duration = sliceAndDice.baseDuration + sliceAndDice.attributes.durationPerComboPoint * comboPoints
	local rank = GetImprovedRank(spells)
	if rank > 0 then
		local perRank = spells.improvedSliceAndDice.attributes.durationPercentPerRank
		duration = duration * (1 + perRank[math.min(rank, #perRank)] / 100)
	end
	return duration
end

---A combo point reading for a diagnostic line.
---@param value integer?
---@return string
local function DiagnosticValue(value)
	return value == nil and "-" or tostring(value)
end

local function ToggleDiagnostic()
	diagnostic.enabled = not diagnostic.enabled
	if not diagnostic.enabled then
		print("|cFFFF8800TRB Slice and Dice:|r diagnostic off")
		return
	end
	local sliceAndDice, spells = GetSliceAndDice()
	print(string.format("|cFFFF8800TRB Slice and Dice:|r diagnostic on. Improved Slice and Dice rank %d, tracked %s",
		spells ~= nil and GetImprovedRank(spells) or 0,
		(sliceAndDice ~= nil and sliceAndDice.buff.isActive) and string.format("%.2fs left", sliceAndDice.buff.remaining) or "nothing"))
end

local sendFrame = CreateFrame("Frame")
sendFrame:RegisterUnitEvent("UNIT_SPELLCAST_SENT", "player")
sendFrame:SetScript("OnEvent", function(_, _, _, _, castGuid, spellId)
	local _, spells = GetSliceAndDice()
	if spells == nil or not IsSliceAndDice(spells, spellId) or castGuid == nil or issecretvalue(castGuid) then
		return
	end
	sentCast.castGuid = castGuid
	sentCast.comboPoints = TRB.Data.snapshotData.attributes.resource2
end)

---A cast of any rank starts Slice and Dice over at the length its spent combo points give.
---@param spellId integer?
---@param castGuid string?
function runtime.OnSpellCastSucceeded(spellId, castGuid)
	local sliceAndDice, spells = GetSliceAndDice()
	if sliceAndDice == nil or spells == nil or not IsSliceAndDice(spells, spellId) then
		return
	end
	local sent = nil
	if castGuid ~= nil and not issecretvalue(castGuid) and castGuid == sentCast.castGuid then
		sent = sentCast.comboPoints
	end
	sentCast.castGuid = nil
	local cached = TRB.Data.snapshotData.attributes.resource2
	local duration = GetSliceAndDiceDuration(spells, sent or cached or 0)
	sliceAndDice.buff:InitializeCustom(duration, GetTime())
	TRB.Functions.BarText:MarkLookupDirty()
	if diagnostic.enabled then
		print(string.format("|cFFFF8800TRB Slice and Dice:|r cast %d | combo points sent %s, cached %s | tracking %.2fs from %s",
			spellId, DiagnosticValue(sent), DiagnosticValue(cached), duration, sent ~= nil and "sent" or "cached"))
	end
end

---@param currentTime number
function runtime.UpdateClassSnapshot(currentTime)
	local sliceAndDice = GetSliceAndDice()
	if sliceAndDice ~= nil and sliceAndDice.buff.isActive then
		local duration = sliceAndDice.buff.duration
		sliceAndDice.buff:GetRemainingTime(currentTime)
		if not sliceAndDice.buff.isActive then
			TRB.Functions.BarText:MarkLookupDirty()
			if diagnostic.enabled then
				print(string.format("|cFFFF8800TRB Slice and Dice:|r timer ended after %.2fs", duration or 0))
			end
		end
	end
end

---@param lookup table
---@param lookupLogic table
---@param prevState table
---@param activeVars table?
function runtime.RefreshClassLookupData(lookup, lookupLogic, prevState, activeVars)
	if activeVars and not activeVars["$sliceAndDiceTime"] then
		return
	end
	local sliceAndDice = GetSliceAndDice()
	if sliceAndDice == nil then
		return
	end
	-- Reset leaves it at 0 once the buff is gone.
	local remaining = sliceAndDice.buff.remaining
	lookupLogic["$sliceAndDiceTime"] = remaining
	if lookupChanged(prevState, "$sliceAndDiceTime", remaining) then
		lookup["$sliceAndDiceTime"] = TRB.Functions.BarText:TimerPrecision(remaining)
	end
end

---@param var string
---@return boolean
function runtime.IsValidClassVariable(var)
	if var == "$sliceAndDiceTime" then
		local sliceAndDice = GetSliceAndDice()
		return sliceAndDice ~= nil and sliceAndDice.buff.isActive
	end
	return false
end

---@return boolean
function runtime.HasClassTimers()
	local sliceAndDice = GetSliceAndDice()
	return sliceAndDice ~= nil and sliceAndDice.buff.isActive
end

TRB.Classes.SpecDescriptor:Declare("rogue_general", {
	slashCommands = {
		snd = function(subcommand)
			if subcommand ~= nil and subcommand ~= "" then
				print("|cFFFF8800TRB Slice and Dice:|r Unknown argument '" .. subcommand .. "'. Usage: /trb snd")
				return
			end
			ToggleDiagnostic()
		end,
	},
})
