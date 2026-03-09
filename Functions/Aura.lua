---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Aura = {}

---@type table<number, integer>
local auraCacheBuffer = {}
---@type table<number, TRB.Classes.SnapshotBuff>
local auraRequests = {}
local auraCacheCleanupTime = 0
local AURA_CACHE_MAX_DURATION = 1 -- seconds
local auraCacheEnabled = false

local allBuffsCache = nil
local allBuffsCacheTime = 0

---Handles UNIT_AURA events
---@param self any
---@param event string
---@param unit UnitToken
---@param info UnitAuraUpdateInfo
local function AuraUpdateEvent(self, event, unit, info)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData
	local currentTime = GetTime()
	
	-- Short circuit this for now
	if unit == "player" then
		wipe(TRB.Data.cache.values.resource)
		wipe(TRB.Data.cache.values.castTime)
		TRB.Data.lookupDirty = true
		--return
	elseif unit ~= "player" then
		return
	end
	
---@diagnostic disable-next-line: param-type-mismatch
	if not issecretvalue(info.isFullUpdate) and info.isFullUpdate then
		if TRB.Data.character and TRB.Data.character.classId == 12 and TRB.Data.character.specId == 3 and TRB.Data.snapshotData and TRB.Data.snapshotData.attributes then
			TRB.Data.snapshotData.attributes.devourerTransitionAt = GetTime()
		end
		if TRB.Data.character ~= nil and TRB.Data.character.classId == 12 and TRB.Data.character.specId == 3 then
			TRB.Data.lookupDirty = true
			wipe(TRB.Data.cache.values.resource)
			wipe(TRB.Data.cache.values.castTime)
			return
		end
		-- Defer the full buff refresh by one frame so that the aura API has time to
		-- stabilise.  When isFullUpdate fires (e.g. on combat entry or after a channel
		-- ends), C_UnitAuras.GetPlayerAuraBySpellID() can transiently return nil for
		-- buffs that are still present.  RefreshAllBuffs() running in the same frame
		-- would call ParseBuffData(nil) → buff:Reset() → applications = 0, causing a
		-- one-frame visual flash on stack-based secondary bars like Soul Fragments.
		-- Deferring by one frame keeps the current (correct) snapshot values intact for
		-- the first onUpdate poll and lets RefreshAllBuffs() read clean API data.
		local function RefreshAndUpdateBars()
			if TRB.Data.snapshotData ~= nil then
				TRB.Data.snapshotData:RefreshAllBuffs()
			end
			TRB.Data.lookupDirty = true
		end

		C_Timer.After(0.02, function()
			RefreshAndUpdateBars()
		end)
		wipe(TRB.Data.cache.values.resource)
		wipe(TRB.Data.cache.values.castTime)
		return
	end

	---@type TRB.Classes.SpecCache
	local specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
	local targetData = snapshotData.targetData
	local unitGuid = nil
	local isUnitFriend = nil

	if info.addedAuras then
		if unit == "player" then
			-- Aura cache handling: if enabled and exactly one aura was added, try to match it to a pending request
			if auraCacheEnabled and #info.addedAuras == 1 then
				for _, v in pairs(info.addedAuras) do
					if auraRequests[currentTime] ~= nil then
						local snapshot = auraRequests[currentTime]
						snapshot:SetAuraInstanceId(v.auraInstanceID)
						snapshot:RefreshWithSecretAuraData(v)
						auraRequests[currentTime] = nil
					else
						auraCacheBuffer[currentTime] = v.auraInstanceID
					end
				end
			end

			for _, v in pairs(info.addedAuras) do
---@diagnostic disable-next-line: param-type-mismatch
				if not issecretvalue(v.spellId) then
					local snapshot = snapshotData.snapshots[v.spellId]

					if snapshot ~= nil then
						snapshot.buff:RefreshWithAuraData(v)
					end

					if v.isFromPlayerOrPlayerPet and targetData.trackedSpells[v.spellId] ~= nil and
						specCache.spellsData.spellsById[v.spellId] ~= nil and specCache.spellsData.spellsById[v.spellId][1].isSelfInitializeAllowed then

						if TRB.Functions.Class:InitializeTarget(TRB.Data.character.guid, specCache.spellsData.spellsById[v.spellId][1].isFriend, specCache.spellsData.spellsById[v.spellId][1].isSelfInitializeAllowed) then
							targetData:HandleCombatLogBuff(v.spellId, "SPELL_AURA_APPLIED", TRB.Data.character.guid)
						end
					end
				end
				wipe(TRB.Data.cache.values.resource)
				wipe(TRB.Data.cache.values.castTime)
			end
		else
			-- This code works but has a fundamental flaw: UNIT_AURA only gives updates for the player, pet, and visible nameplates.
			-- For adding auras, e.g. SPELL_AURA_APPLIED, we need to use COMBAT_LOG_EVENT_UNFILTERED in the class module instead.
			--[[for _, v in pairs(info.addedAuras) do
				if (v.sourceUnit == "player" or v.sourceUnit == "pet") and targetData.trackedSpells[v.spellId] ~= nil then
					unitGuid = unitGuid or UnitGUID(unit)
					isUnitFriend = isUnitFriend or UnitIsFriend("player", unit)
					if TRB.Functions.Class:InitializeTarget(unitGuid, specCache.spellsData.spellsById[v.spellId][1].isFriend, specCache.spellsData.spellsById[v.spellId][1].isSelfInitializeAllowed) then
						if specCache.spellsData.spellsById[v.spellId][1].isBuff then
							targetData:HandleCombatLogBuff(v.spellId, "SPELL_AURA_APPLIED", unitGuid)
						else
							targetData:HandleCombatLogDebuff(v.spellId, "SPELL_AURA_APPLIED", unitGuid)
						end
					end
				end
			end]]
		end
	end

	if info.updatedAuraInstanceIDs then
		if unit == "player" then
			for _, v in pairs(info.updatedAuraInstanceIDs) do
				local snapshot = snapshotData.auraInstanceIds[v]

				if snapshot ~= nil then
					if snapshot.updateFromSecret then
						-- Custom buff snapshot: call RefreshWithSecretAuraData() to update with the new AuraData
						if allBuffsCache == nil or allBuffsCacheTime + 0.5 < currentTime then
							allBuffsCacheTime = currentTime
---@diagnostic disable-next-line: param-type-mismatch
							allBuffsCache = C_UnitAuras.GetUnitAuras("player", "HELPFUL")
						end

						for i = 1, #allBuffsCache do
							local auraData = allBuffsCache[i]
							if auraData.auraInstanceID == v then
								snapshot:RefreshWithSecretAuraData(auraData)
								break
							end
						end
						--[[

							Try one of these instead once they return non-secret `points` table data.

							]]
						--local buffData = TRB.Functions.Aura:FindBuffById(snapshot.parent.spell.id)
						--local buffData = C_UnitAuras.GetAuraDataBySpellName("player", snapshot.parent.spell.name)
						--local buffData = C_UnitAuras.GetUnitAuraBySpellID("player", snapshot.parent.spell.id)
						--local buffData = C_UnitAuras..GetAuraDataByAuraInstanceID("player", snapshot.auraInstanceId)
						--snapshot:RefreshWithSecretAuraData(buffData)
					else
						-- Standard buff snapshot: call Refresh() to update from current aura state
						snapshot:Refresh()
					end
				end

				local target = targetData.auraInstanceIds[v]

				if target ~= nil then
					local targetSpell = target.auraInstanceIds[v]
				
					targetData:HandleCombatLogBuff(targetSpell.id, "SPELL_AURA_REFRESH", unitGuid)
				end
			end
			wipe(TRB.Data.cache.values.resource)
			wipe(TRB.Data.cache.values.castTime)
		else
			for _, v in pairs(info.updatedAuraInstanceIDs) do
				local target = targetData.auraInstanceIds[v]

				if target ~= nil then
					local targetSpell = target.auraInstanceIds[v]
					unitGuid = unitGuid or UnitGUID(unit)
					if targetSpell.spell.isBuff then
						targetData:HandleCombatLogBuff(targetSpell.id, "SPELL_AURA_REFRESH", unitGuid)
					else
						targetData:HandleCombatLogDebuff(targetSpell.id, "SPELL_AURA_REFRESH", unitGuid)
					end
				end
			end
		end
	end

	if info.removedAuraInstanceIDs then
		if unit == "player" then
			for _, v in pairs(info.removedAuraInstanceIDs) do
				local snapshot = snapshotData.auraInstanceIds[v]
				if snapshot ~= nil then
					if auraCacheEnabled then
						-- Cache-managed snapshot: call Reset() to fully clear it
						snapshot:Reset()
					else
						-- Standard snapshot: call Refresh() to update from current aura state
						snapshot:Refresh()
					end
				end
				TRB.Functions.Aura:RemoveBuffAuraInstanceId(v)
			end

			wipe(TRB.Data.cache.values.resource)
			wipe(TRB.Data.cache.values.castTime)
		else
			for _, v in pairs(info.removedAuraInstanceIDs) do
				local target = targetData.auraInstanceIds[v]

				if target ~= nil then
					local targetSpell = target.auraInstanceIds[v]
					unitGuid = unitGuid or UnitGUID(unit)
					if targetSpell.spell.isBuff then
						targetData:HandleCombatLogBuff(targetSpell.id, "SPELL_AURA_REMOVED", unitGuid)
					else
						targetData:HandleCombatLogDebuff(targetSpell.id, "SPELL_AURA_REMOVED", unitGuid)
					end
				end
			end
		end
	end

	-- Aura cache buffer cleanup
	if auraCacheEnabled and currentTime - auraCacheCleanupTime > AURA_CACHE_MAX_DURATION then
		auraCacheCleanupTime = currentTime
		for k, v in pairs(auraCacheBuffer) do
			if currentTime - k > AURA_CACHE_MAX_DURATION then
				auraCacheBuffer[k] = nil
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
	unitAuraFrame:UnregisterEvent("UNIT_AURA")
end

function TRB.Functions.Aura:EnableUnitAuraCache()
	auraCacheEnabled = true
end

function TRB.Functions.Aura:DisableUnitAuraCache()
	auraCacheEnabled = false
	auraCacheBuffer = {}
	auraRequests = {}
end

---Gets an aura from the cache buffer by its timestamp
---@param time number
---@return integer
function TRB.Functions.Aura:GetFromAuraCacheBuffer(time)
	return auraCacheBuffer[time]
end

---Inserts an aura request into the request cache
---@param time number
---@param buff TRB.Classes.SnapshotBuff
function TRB.Functions.Aura:InsertAuraRequest(time, buff)
	auraRequests[time] = buff
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
---@diagnostic disable-next-line: param-type-mismatch
		buffData = C_UnitAuras.GetBuffDataByIndex(onWhom, i)
		if not buffData then
			return
---@diagnostic disable-next-line: param-type-mismatch
		elseif issecretvalue(buffData.spellId) then
			-- do nothing
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
---@diagnostic disable-next-line: param-type-mismatch
		debuffData = C_UnitAuras.GetDebuffDataByIndex(onWhom, i)
		if not debuffData then
			return
		elseif issecretvalue(buffData.spellId) then
			-- do nothing
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
---| '"SPELL_PERIODIC_ENERGIZE"' # SPELL_PERIODIC_ENERGIZE
---| '""' # No event type; refresh data and nothing else