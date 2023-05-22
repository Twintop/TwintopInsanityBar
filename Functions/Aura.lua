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
---@param snapshot table # Snapshot data associated with this spell
---@param simple boolean # If true, only determine if the spell `isActive` or not
function TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot, simple, unit)
	local currentTime = GetTime()
	if snapshot == nil then
		snapshot = {}
		print("TRB: |cFFFF5555Table missing for spellId |r"..spellId..". Please consider reporting this on GitHub!")
	end

	simple = simple or false
	unit = unit or "player"

	if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED_DOSE" then -- Gained buff
		snapshot.isActive = true
		if not simple then
			_, _, snapshot.stacks, _, snapshot.duration, snapshot.endTime, _, _, _, snapshot.spellId = TRB.Functions.Aura:FindBuffById(spellId, unit)
			snapshot.remainingTime = TRB.Functions.Spell:GetRemainingTime(snapshot)
		end
	elseif type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
		if snapshot.stacks ~= nil then
			snapshot.stacks = snapshot.stacks - 1
		end
	elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
		snapshot.isActive = false
		if not simple then
			snapshot.spellId = nil
			snapshot.duration = 0
			snapshot.stacks = 0
			snapshot.endTime = nil
			snapshot.remainingTime = 0
		end
	elseif type == nil or type == "" then
		_, _, snapshot.stacks, _, snapshot.duration, snapshot.endTime, _, _, _, snapshot.spellId = TRB.Functions.Aura:FindBuffById(spellId, unit)
		if snapshot.endTime ~= nil and snapshot.endTime > currentTime then
			snapshot.isActive = true
			snapshot.remainingTime = TRB.Functions.Spell:GetRemainingTime(snapshot)
		else
			snapshot.isActive = false
		end
	end
end