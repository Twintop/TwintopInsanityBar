---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Aura = {}

---Handles UNIT_AURA events
---@param self any
---@param event string
---@param unit UnitToken
---@param info UnitAuraUpdateInfo
local function AuraUpdateEvent(self, event, unit, info)
	if info.isFullUpdate then
		--Only do a full refresh of buffs for now
		TRB.Data.snapshotData:RefreshAllBuffs()
		return
	end

	if info.addedAuras then
		if unit == "player" then
			for _, v in pairs(info.addedAuras) do
				local snapshot = TRB.Data.snapshotData.snapshots[v.spellId] --[[@as TRB.Classes.Snapshot]]

				if snapshot ~= nil then
					snapshot.buff:RefreshWithAuraData(v)
				end
			end
		--[[else
			for _, v in pairs(info.updatedAuraInstanceIDs) do
				local target = TRB.Data.snapshotData.targetData.auraInstanceIds[v]

				if target ~= nil then
					local targetSpell = target.auraInstanceIds[v]
					targetSpell:Update()
				end
			end]]
		end
	end

	if info.updatedAuraInstanceIDs then
		if unit == "player" then
			for _, v in pairs(info.updatedAuraInstanceIDs) do
				local snapshot = TRB.Data.snapshotData.auraInstanceIds[v] --[[@as TRB.Classes.SnapshotBuff]]

				if snapshot ~= nil then
					snapshot:Refresh()
				end
			end
		else
			for _, v in pairs(info.updatedAuraInstanceIDs) do
				local target = TRB.Data.snapshotData.targetData.auraInstanceIds[v]

				if target ~= nil then
					local targetSpell = target.auraInstanceIds[v]
					targetSpell:Update()
				end
			end
		end
	end

	if info.removedAuraInstanceIDs then
		if unit == "player" then
			for _, v in pairs(info.removedAuraInstanceIDs) do
				TRB.Functions.Aura:RemoveBuffAuraInstanceId(v)
			end

		else
			for _, v in pairs(info.removedAuraInstanceIDs) do
				local target = TRB.Data.snapshotData.targetData.auraInstanceIds[v]

				if target ~= nil then
					target.auraInstanceIds[v] = nil
					TRB.Functions.Aura:RemoveTargetAuraInstanceId(v)
				end
			end
		end
	end
end

local unitAuraFrame = CreateFrame("Frame")
unitAuraFrame:SetScript("OnEvent", AuraUpdateEvent)

function TRB.Functions.Aura:EnableUnitAura()
	unitAuraFrame:RegisterEvent("UNIT_AURA")
end

function TRB.Functions.Aura:DisableUnitAura()
	unitAuraFrame:UnegisterEvent("UNIT_AURA")
end

---Stores the AuraInstanceId->SnapshotBuff in a dictionary
---@param snapshotBuff TRB.Classes.SnapshotBuff
function TRB.Functions.Aura:StoreBuffAuraInstanceId(snapshotBuff)
	if TRB.Data.snapshotData ~= nil and snapshotBuff.auraInstanceId ~= nil then
		TRB.Data.snapshotData.auraInstanceIds[snapshotBuff.auraInstanceId] = snapshotBuff
	end
end

---Removes the AuraInstanceId->SnapshotBuff dictionary entry
---@param auraInstanceId integer
function TRB.Functions.Aura:RemoveBuffAuraInstanceId(auraInstanceId)
	if TRB.Data.snapshotData ~= nil then
		TRB.Data.snapshotData.auraInstanceIds[auraInstanceId] = nil
	end
end

---Stores the AuraInstanceId->Target in a dictionary
---@param auraInstanceId integer
---@param target TRB.Classes.Target
function TRB.Functions.Aura:StoreTargetAuraInstanceId(auraInstanceId, target)
	if TRB.Data.snapshotData ~= nil and TRB.Data.snapshotData.targetData ~= nil then
		TRB.Data.snapshotData.targetData.auraInstanceIds[auraInstanceId] = target
	end
end

---Removes the AuraInstanceId->Target dictionary entry
---@param auraInstanceId integer
function TRB.Functions.Aura:RemoveTargetAuraInstanceId(auraInstanceId)
	if TRB.Data.snapshotData ~= nil and TRB.Data.snapshotData.targetData ~= nil then
		TRB.Data.snapshotData.targetData.auraInstanceIds[auraInstanceId] = nil
	end
end

---Clears all AuraInstanceIds that are cached for snapshot buffs and targets
function TRB.Functions.Aura:ClearAuraInstanceIds()
	TRB.Data.snapshotData.auraInstanceIds = {}
	TRB.Data.snapshotData.targetData.auraInstanceIds = {}

	for _, v in pairs(TRB.Data.snapshotData.targetData.targets) do
		v.auraInstanceIds = {}
	end
	
	for _, v in pairs(TRB.Data.snapshotData.snapshots) do
		v.buff.auraInstanceId = nil
	end
end

---Attempts to get a buff on a target by its spellId
---@param spellId integer
---@param onWhom string?
---@param byWhom string?
---@return AuraData?
function TRB.Functions.Aura:FindBuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	local buffData

	for i = 1, 1000 do
		buffData = C_UnitAuras.GetBuffDataByIndex(onWhom, i)
		if not buffData then
			return
		elseif spellId == buffData.spellId and (byWhom == nil or byWhom == buffData.sourceUnit) then
			return buffData
		end
	end
end

---Attempts to get a debuff by its spellId
---@param spellId integer
---@param onWhom string?
---@param byWhom string?
---@return AuraData?
function TRB.Functions.Aura:FindDebuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	local debuffData

	for i = 1, 1000 do
		debuffData = C_UnitAuras.GetDebuffDataByIndex(onWhom, i)
		if not debuffData then
			return
		elseif spellId == debuffData.spellId and (byWhom == nil or byWhom == debuffData.sourceUnit) then
			return debuffData
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