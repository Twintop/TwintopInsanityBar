local _, TRB = ...
if TRB.Data.character.classId ~= 5 then -- Only do this if we are on a Priest!
	return
end

-- Priest runtime (World of Warcraft Classic). The runtime template installs the resource, health,
-- combo point, bar text and spec-switching behavior for the archetypes declared in Classes\PriestClasses.lua;
-- ability tracking specific to this class is layered on top of the returned runtime table.
local runtime = TRB.Classic.Templates.Runtime:Install("priest")

local lookupChanged = TRB.Functions.BarText.LookupChanged

---The active spell set's Inner Fire snapshot and the spell set, or nil before the spec cache loads.
---@return TRB.Classes.Snapshot?, TRB.Classes.Classic.Priest.GeneralSpells?
local function GetInnerFire()
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Classic.Priest.GeneralSpells?]]
	local snapshotData = TRB.Data.snapshotData
	if spells == nil or spells.innerFire == nil or snapshotData == nil then
		return nil, nil
	end
	return snapshotData.snapshots[spells.innerFire.id], spells
end

-- The Inner Fire aura last read, kept through a read that misses it so its next update still reads.
local innerFireInstanceId = nil

---Copies Inner Fire's charges and time from its aura, which is never secret here; any rank counts.
---@return boolean # false before the spell set loads
local function ReadInnerFire()
	local innerFire, spells = GetInnerFire()
	if innerFire == nil or spells == nil then
		return false
	end
	local buff = innerFire.buff
	local rankIds = spells.innerFire.rankIds or { spells.innerFire.id }
	for i = #rankIds, 1, -1 do
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(rankIds[i])
		if aura ~= nil then
			innerFireInstanceId = aura.auraInstanceID
			buff:InitializeCustom(aura.duration, aura.expirationTime - aura.duration, true, aura.applications)
			TRB.Functions.BarText:MarkLookupDirty()
			return true
		end
	end
	if buff.isActive then
		buff:Reset()
		TRB.Functions.BarText:MarkLookupDirty()
	end
	return true
end

-- A read the spell set wasn't loaded for waits for CheckCharacter, as on login and reload.
local readPending = true
local readQueued = false

local function QueuedRead()
	readQueued = false
	readPending = not ReadInnerFire()
end

---Reads on a short delay, as Core's buff refresh does, so a burst of aura changes reads once.
local function QueueRead()
	if not readQueued then
		readQueued = true
		C_Timer.After(0.02, QueuedRead)
	end
end

---Whether a list of aura instance IDs holds the tracked Inner Fire.
---@param ids integer[]?
---@return boolean
local function HasInnerFireInstance(ids)
	if ids == nil or innerFireInstanceId == nil then
		return false
	end
	for i = 1, #ids do
		if ids[i] == innerFireInstanceId then
			return true
		end
	end
	return false
end

---Whether a UNIT_AURA update gained, changed, or lost Inner Fire.
---@param info UnitAuraUpdateInfo?
---@return boolean
local function TouchesInnerFire(info)
	if info == nil or info.isFullUpdate then
		return true
	end
	if HasInnerFireInstance(info.updatedAuraInstanceIDs) or HasInnerFireInstance(info.removedAuraInstanceIDs) then
		return true
	end
	local added = info.addedAuras
	local _, spells = GetInnerFire()
	if added == nil or spells == nil then
		return false
	end
	local spellsById = TRB.Data.spellsData.spellsById
	for i = 1, #added do
		local auraSpells = spellsById[added[i].spellId]
		if auraSpells ~= nil and tContains(auraSpells, spells.innerFire) then
			return true
		end
	end
	return false
end

local auraFrame = CreateFrame("Frame")
auraFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
auraFrame:RegisterUnitEvent("UNIT_AURA", "player")
auraFrame:SetScript("OnEvent", function(_, event, _, info)
	if event == "PLAYER_ENTERING_WORLD" then
		readPending = not ReadInnerFire()
	elseif TouchesInnerFire(info) then
		QueueRead()
	end
end)

function runtime.CheckClassCharacter()
	if readPending then
		readPending = not ReadInnerFire()
	end
end

---@param currentTime number
function runtime.UpdateClassSnapshot(currentTime)
	local innerFire = GetInnerFire()
	if innerFire ~= nil and innerFire.buff.isActive then
		innerFire.buff:GetRemainingTime(currentTime)
		if not innerFire.buff.isActive then
			TRB.Functions.BarText:MarkLookupDirty()
		end
	end
end

---@param lookup table
---@param lookupLogic table
---@param prevState table
---@param activeVars table?
function runtime.RefreshClassLookupData(lookup, lookupLogic, prevState, activeVars)
	if activeVars and not (activeVars["$innerFireStacks"] or activeVars["$innerFireStacksMax"] or activeVars["$innerFireTime"]) then
		return
	end
	local innerFire, spells = GetInnerFire()
	if innerFire == nil or spells == nil then
		return
	end
	-- Reset leaves both at 0 once the buff is gone.
	local stacks = innerFire.buff.applications
	local remaining = innerFire.buff.remaining
	local maxStacks = spells.innerFire.maxStacks
	lookupLogic["$innerFireStacks"] = stacks
	lookupLogic["$innerFireStacksMax"] = maxStacks
	lookupLogic["$innerFireTime"] = remaining
	if lookupChanged(prevState, "$innerFireStacks", stacks) then
		lookup["$innerFireStacks"] = tostring(stacks)
	end
	if lookupChanged(prevState, "$innerFireStacksMax", maxStacks) then
		lookup["$innerFireStacksMax"] = tostring(maxStacks)
	end
	if lookupChanged(prevState, "$innerFireTime", remaining) then
		lookup["$innerFireTime"] = TRB.Functions.BarText:TimerPrecision(remaining)
	end
end

---@param var string
---@return boolean
function runtime.IsValidClassVariable(var)
	if var == "$innerFireStacks" or var == "$innerFireTime" then
		local innerFire = GetInnerFire()
		return innerFire ~= nil and innerFire.buff.isActive
	end
	return var == "$innerFireStacksMax"
end

---@return boolean
function runtime.HasClassTimers()
	local innerFire = GetInnerFire()
	return innerFire ~= nil and innerFire.buff.isActive
end
