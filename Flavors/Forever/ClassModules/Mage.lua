local _, TRB = ...
if TRB.Data.character.classId ~= 8 then -- Only do this if we are on a Mage!
	return
end

-- Mage runtime (World of Warcraft: Forever). The runtime template installs the resource, health,
-- combo point, bar text and spec-switching behavior for the archetypes declared in Classes\MageClasses.lua;
-- ability tracking specific to this class is layered on top of the returned runtime table.
local runtime = TRB.Forever.Templates.Runtime:Install("mage")

local lookupChanged = TRB.Functions.BarText.LookupChanged

---The active spell set's Arcane Blast snapshot and the spell set, or nil before the spec cache loads.
---@return TRB.Classes.Snapshot?, TRB.Classes.Forever.Mage.GeneralSpells?
local function GetArcaneBlast()
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Forever.Mage.GeneralSpells?]]
	local snapshotData = TRB.Data.snapshotData
	if spells == nil or spells.arcaneBlast == nil or snapshotData == nil then
		return nil, nil
	end
	return snapshotData.snapshots[spells.arcaneBlast.id], spells
end

---A cast of any rank adds a stack, up to the maximum.
---@param spellId integer?
function runtime.OnSpellCastSucceeded(spellId)
	local arcaneBlast, spells = GetArcaneBlast()
	if arcaneBlast == nil or spells == nil or spellId == nil or issecretvalue(spellId) then
		return
	end
	local castSpells = TRB.Data.spellsData.spellsById[spellId]
	if castSpells == nil or not tContains(castSpells, spells.arcaneBlast) then
		return
	end
	local currentTime = GetTime()
	local buff = arcaneBlast.buff
	-- Stacks that ran out since the last tick start over instead of growing.
	buff:GetRemainingTime(currentTime)
	local spell = spells.arcaneBlast
	buff:AddStackOrInitializeCustom(spell.duration, currentTime, spell.attributes.refreshOnStack)
	-- AddStack's own read returns the time cached for this timestamp, from before a refresh.
	buff:GetRemainingTime(currentTime, nil, true)
	TRB.Functions.BarText:MarkLookupDirty()
end

---@param currentTime number
function runtime.UpdateClassSnapshot(currentTime)
	local arcaneBlast = GetArcaneBlast()
	if arcaneBlast ~= nil and arcaneBlast.buff.isActive then
		arcaneBlast.buff:GetRemainingTime(currentTime)
		if not arcaneBlast.buff.isActive then
			TRB.Functions.BarText:MarkLookupDirty()
		end
	end
end

---@param lookup table
---@param lookupLogic table
---@param prevState table
---@param activeVars table?
function runtime.RefreshClassLookupData(lookup, lookupLogic, prevState, activeVars)
	if activeVars and not (activeVars["$arcaneBlastStacks"] or activeVars["$arcaneBlastStacksMax"] or activeVars["$arcaneBlastTime"]) then
		return
	end
	local arcaneBlast, spells = GetArcaneBlast()
	if arcaneBlast == nil or spells == nil then
		return
	end
	-- Reset leaves both at 0 once the stacks are gone.
	local stacks = arcaneBlast.buff.applications
	local remaining = arcaneBlast.buff.remaining
	local maxStacks = spells.arcaneBlast.maxStacks
	lookupLogic["$arcaneBlastStacks"] = stacks
	lookupLogic["$arcaneBlastStacksMax"] = maxStacks
	lookupLogic["$arcaneBlastTime"] = remaining
	if lookupChanged(prevState, "$arcaneBlastStacks", stacks) then
		lookup["$arcaneBlastStacks"] = tostring(stacks)
	end
	if lookupChanged(prevState, "$arcaneBlastStacksMax", maxStacks) then
		lookup["$arcaneBlastStacksMax"] = tostring(maxStacks)
	end
	if lookupChanged(prevState, "$arcaneBlastTime", remaining) then
		lookup["$arcaneBlastTime"] = TRB.Functions.BarText:TimerPrecision(remaining)
	end
end

---@param var string
---@return boolean
function runtime.IsValidClassVariable(var)
	if var == "$arcaneBlastStacks" or var == "$arcaneBlastTime" then
		local arcaneBlast = GetArcaneBlast()
		return arcaneBlast ~= nil and arcaneBlast.buff.isActive
	end
	return var == "$arcaneBlastStacksMax"
end

---@return boolean
function runtime.HasClassTimers()
	local arcaneBlast = GetArcaneBlast()
	return arcaneBlast ~= nil and arcaneBlast.buff.isActive
end
