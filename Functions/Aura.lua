---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Aura = {}

function TRB.Functions.Aura:FindBuffByName(spellName, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName, _, _, _, _, _, castBy = UnitBuff(onWhom, i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName and (byWhom == nil or byWhom == castBy) then
			return UnitBuff(onWhom, i)
		end
	end
end

function TRB.Functions.Aura:FindBuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local _, _, _, _, _, _, castBy, _, _, unitSpellId = UnitBuff(onWhom, i)
		if not unitSpellId then
			return
		elseif spellId == unitSpellId and (byWhom == nil or byWhom == castBy) then
			return UnitBuff(onWhom, i)
		end
	end
end

function TRB.Functions.Aura:FindDebuffByName(spellName, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local unitSpellName, _, _, _, _, _, castBy = UnitDebuff(onWhom, i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName and (byWhom == nil or byWhom == castBy) then
			return UnitDebuff(onWhom, i)
		end
	end
end

function TRB.Functions.Aura:FindDebuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local _, _, _, _, _, _, castBy, _, _, unitSpellId = UnitDebuff(onWhom, i)
		if not unitSpellId then
			return
		elseif spellId == unitSpellId and (byWhom == nil or byWhom == castBy) then
			return UnitDebuff(onWhom, i)
		end
	end
end

function TRB.Functions.Aura:FindAuraByName(spellName, onWhom, filter, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName, _, _, _, _, _, castBy = UnitAura(onWhom, i, filter)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName and (byWhom == nil or byWhom == castBy) then
			return UnitAura(onWhom, i, filter)
		end
	end
end

function TRB.Functions.Aura:FindAuraById(spellId, onWhom, filter, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local _, _, _, _, _, _, castBy, _, _, unitSpellId = UnitAura(onWhom, i, filter)
		if not unitSpellId then
			return
		elseif spellId == unitSpellId and (byWhom == nil or byWhom == castBy) then
			return UnitAura(onWhom, i, filter)
		end
	end
end

---@alias trbAuraEventType
---| '"SPELL_AURA_APPLIED"' # SPELL_AURA_APPLIED
---| '"SPELL_AURA_REFRESH"' # SPELL_AURA_REFRESH
---| '"SPELL_AURA_REMOVED"' # SPELL_AURA_REMOVED
---| '"SPELL_AURA_APPLIED_DOSE"' # SPELL_AURA_APPLIED_DOSE
---| '"SPELL_AURA_REMOVED_DOSE"' # SPELL_AURA_REMOVED_DOSE
---| '"SPELL_DISPEL"' # SPELL_DISPEL
---| '""' # No event type; refresh data and nothing else

---@param spellId number # Spell ID of the aura we are storing details about
---@param type trbAuraEventType? # Event Type sourced from the combat log event
---@param snapshotObj table # Snapshot data associated with this spell
---@param simple boolean # If true, only determine if the spell `isActive` or not
function TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshotObj, simple, unit)
	local currentTime = GetTime()
	if snapshotObj == nil then
		snapshotObj = {}
		print("TRB: |cFFFF5555Table missing for spellId |r"..spellId..". Please consider reporting this on GitHub!")
	end

	simple = simple or false
	unit = unit or "player"

	if snapshotObj.buff ~= nil then -- New Snapshot class
		---@type TRB.Classes.Snapshot
		local snapshot = snapshotObj
		if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED_DOSE" then -- Gained buff
			snapshot.buff.isActive = true
			if not simple then
				_, _, snapshot.buff.stacks, _, snapshot.buff.duration, snapshot.buff.endTime, _, _, _, snapshot.spellId = TRB.Functions.Aura:FindBuffById(spellId, unit)
				snapshot.buff:GetRemainingTime()
			end
		elseif type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
			if snapshot.buff.stacks ~= nil then
				snapshot.buff.stacks = snapshot.buff.stacks - 1
			end
		elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
			snapshot.buff.isActive = false
			if not simple then
				snapshot.spellId = nil
				snapshot.buff.stacks = 0
				snapshot.buff.duration = 0
				snapshot.buff.endTime = nil
				snapshot.buff.remaining = 0
			end
		elseif type == nil or type == "" then
			_, _, snapshot.buff.stacks, _, snapshot.buff.duration, snapshot.buff.endTime, _, _, _, snapshot.spellId = TRB.Functions.Aura:FindBuffById(spellId, unit)
			if snapshot.buff.endTime ~= nil and snapshot.buff.endTime > currentTime then
				snapshot.buff.isActive = true
				snapshot.buff:GetRemainingTime()
			else
				snapshot:Reset()
			end
		end
	else
		if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED_DOSE" then -- Gained buff
			snapshotObj.isActive = true
			if not simple then
				_, _, snapshotObj.stacks, _, snapshotObj.duration, snapshotObj.endTime, _, _, _, snapshotObj.spellId = TRB.Functions.Aura:FindBuffById(spellId, unit)
				snapshotObj.remainingTime = TRB.Functions.Spell:GetRemainingTime(snapshotObj)
			end
		elseif type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
			if snapshotObj.stacks ~= nil then
				snapshotObj.stacks = snapshotObj.stacks - 1
			end
		elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
			snapshotObj.isActive = false
			if not simple then
				snapshotObj.spellId = nil
				snapshotObj.duration = 0
				snapshotObj.stacks = 0
				snapshotObj.endTime = nil
				snapshotObj.remainingTime = 0
			end
		elseif type == nil or type == "" then
			_, _, snapshotObj.stacks, _, snapshotObj.duration, snapshotObj.endTime, _, _, _, snapshotObj.spellId = TRB.Functions.Aura:FindBuffById(spellId, unit)
			if snapshotObj.endTime ~= nil and snapshotObj.endTime > currentTime then
				snapshotObj.isActive = true
				snapshotObj.remainingTime = TRB.Functions.Spell:GetRemainingTime(snapshotObj)
			else
				snapshotObj.isActive = false
			end
		end
	end
end