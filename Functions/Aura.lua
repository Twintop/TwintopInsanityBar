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

function TRB.Functions.Aura:HandleGenericAura(spellId, type, spell, snapshot)
	
end