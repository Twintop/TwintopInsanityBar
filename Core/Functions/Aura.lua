local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Aura = {}

local pendingPlayerBuffRefresh = false

---Queues a re-poll of every tracked player buff through the aura API, coalescing bursts of
---UNIT_AURA into a single pass. As of 12.1 the UnitAuraUpdateInfo payload is secret, so we can
---neither tell which auras changed nor whether it was a full update; whitelisted auras
---(Maelstrom Weapon, etc.) still read back cleanly from C_UnitAuras, and secret ones leave their
---event-driven state untouched.
function TRB.Functions.Aura:RequestPlayerBuffRefresh()
	if pendingPlayerBuffRefresh then
		return
	end
	pendingPlayerBuffRefresh = true

	-- Deferred a frame: when a batch of aura changes lands (combat entry, channel end) the aura
	-- API can transiently return nil for buffs that are still present, which would flash
	-- stack-based bars like Maelstrom Weapon or Soul Fragments to zero for a frame.
	C_Timer.After(0.02, function()
		pendingPlayerBuffRefresh = false
		if TRB.Data.snapshotData ~= nil then
			TRB.Data.snapshotData:RefreshAllBuffs()
			TRB.Data.snapshotData.casting:RefreshCost()
			TRB.Data.lookupDirty = true
		end
	end)
end

---Handles UNIT_AURA events. As of 12.1 the UnitAuraUpdateInfo payload is secret for the
---player, so this mostly serves as a "some aura changed" signal (cache invalidation,
---lookupDirty, OnPlayerUnitAura hook); payload branches are guarded and run when readable.
---@param self any
---@param event string
---@param unit UnitToken
---@param info UnitAuraUpdateInfo
local function AuraUpdateEvent(self, event, unit, info)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData

	-- Short circuit this for now
	if unit == "player" then
		wipe(TRB.Data.cache.values.resource)
		wipe(TRB.Data.cache.values.castTime)
		TRB.Data.lookupDirty = true
		-- Generic per-class hook for logic that should run on player aura changes (e.g. tooltip
		-- polling for procs). Optional; only classes that define it are notified.
		if TRB.Functions.Class and TRB.Functions.Class.OnPlayerUnitAura then
			TRB.Functions.Class:OnPlayerUnitAura(info)
		end
		if TRB.Flavor.playerAuras then
			TRB.Functions.Aura:UpdateConditionAuras(info)
		end
		-- The payload below is secret, so treat every player aura change as a full update and
		-- re-read the tracked buffs directly from the aura API.
		TRB.Functions.Aura:RequestPlayerBuffRefresh()
		--return
	elseif unit ~= "player" then
		return
	end
	
	if not issecretvalue(info.isFullUpdate) and info.isFullUpdate then
		-- A spec whose secondary resource resets on a full aura update stamps the moment (descriptor
		-- `secondaryTransitionOnFullAuraUpdate` names the attribute).
		local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
		local transitionAttribute = descriptor and descriptor.secondaryTransitionOnFullAuraUpdate
		if transitionAttribute ~= nil and TRB.Data.snapshotData and TRB.Data.snapshotData.attributes then
			TRB.Data.snapshotData.attributes[transitionAttribute] = GetTime()
		end
		TRB.Functions.Aura:RequestPlayerBuffRefresh()
		wipe(TRB.Data.cache.values.resource)
		wipe(TRB.Data.cache.values.castTime)
		return
	end

	---@type TRB.Classes.SpecCache
	local specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
	local targetData = snapshotData.targetData
	local unitGuid = nil
	local isUnitFriend = nil

	if info.addedAuras and not issecrettable(info.addedAuras) then
		if unit == "player" then
			for _, v in pairs(info.addedAuras) do
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

	if info.updatedAuraInstanceIDs and not issecrettable(info.updatedAuraInstanceIDs) then
		if unit == "player" then
			for _, v in pairs(info.updatedAuraInstanceIDs) do
				local snapshot = snapshotData.auraInstanceIds[v]

				if snapshot ~= nil then
					snapshot:Refresh()
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

	if info.removedAuraInstanceIDs and not issecrettable(info.removedAuraInstanceIDs) then
		if unit == "player" then
			for _, v in pairs(info.removedAuraInstanceIDs) do
				local snapshot = snapshotData.auraInstanceIds[v]
				if snapshot ~= nil then
					snapshot:Refresh()
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
end

local unitAuraFrame = CreateFrame("Frame")
unitAuraFrame:SetScript("OnEvent", AuraUpdateEvent)

---Registers the UNIT_AURA event so the addon begins processing aura updates for the player
function TRB.Functions.Aura:EnableUnitAura()
	unitAuraFrame:RegisterUnitEvent("UNIT_AURA", "player")
	-- Buffs gained or lost while UNIT_AURA was off left the followed buffs stale.
	self:RefreshConditionSpells()
end

---Unregisters the UNIT_AURA event so the addon stops processing aura updates
function TRB.Functions.Aura:DisableUnitAura()
	unitAuraFrame:UnregisterEvent("UNIT_AURA")
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
		debuffData = C_UnitAuras.GetDebuffDataByIndex(onWhom, i)
		if not debuffData then
			return
		elseif issecretvalue(debuffData.spellId) then
			-- do nothing
		elseif spellId == debuffData.spellId and (byWhom == nil or byWhom == debuffData.sourceUnit) then
			return debuffData
		end
	end
end

-- Custom indicators and Buff Alerts following a player buff by spell ID where auras are never secret; matched by name, so any rank counts.
TRB.Functions.Aura.CONDITION_SOURCE = "aura"

---@enum TRB.AuraConditionState
TRB.Functions.Aura.ConditionState = {
	ACTIVE = "active",
}

-- The played spec's followed buffs: spell -> name, name -> whether it's up, aura instance -> name; kept current by UNIT_AURA.
local conditionNames = {}
local conditionActive = {}
local conditionInstances = {}

---@param conditions TRB.CustomIndicatorCondition[]?
local function AddConditionSpells(conditions)
	if conditions == nil then
		return
	end
	for _, condition in ipairs(conditions) do
		local spellId = condition.source == TRB.Functions.Aura.CONDITION_SOURCE and condition.spellID or nil
		local name = spellId ~= nil and C_Spell.GetSpellName(spellId) or nil
		if spellId ~= nil and name ~= nil then
			conditionNames[spellId] = name
			conditionActive[name] = false
		end
	end
end

---Re-reads whether the player has the named buff, recording the copy it found.
---@param name string
local function ReadConditionAura(name)
	local aura = C_UnitAuras.GetAuraDataBySpellName("player", name, "HELPFUL")
	conditionActive[name] = aura ~= nil
	if aura ~= nil then
		conditionInstances[aura.auraInstanceID] = name
	end
end

---Rebuilds the buffs the played spec's custom indicators and Buff Alerts follow, and reads each once. Call
---after a spec change, or after one is added, re-pointed, or removed.
function TRB.Functions.Aura:RefreshConditionSpells()
	wipe(conditionNames)
	wipe(conditionActive)
	wipe(conditionInstances)
	local spec = TRB.Flavor.playerAuras and TRB.Functions.Character:GetActiveRawSpecSettings() or nil
	if spec == nil then
		return
	end

	local indicatorColors = spec.colors ~= nil and spec.colors.shared ~= nil and spec.colors.shared.indicatorColors or nil
	if indicatorColors ~= nil then
		for _, indicator in pairs(indicatorColors) do
			AddConditionSpells(type(indicator) == "table" and indicator.custom ~= nil and indicator.custom.conditions or nil)
		end
	end
	if spec.audio ~= nil then
		for _, cue in pairs(spec.audio) do
			AddConditionSpells(type(cue) == "table" and cue.kind == "buff" and cue.configuration ~= nil and cue.configuration.conditions or nil)
		end
	end
	for name in pairs(conditionActive) do
		ReadConditionAura(name)
	end
	TRB.Data.lookupDirty = true
end

---Keeps the followed buffs current from a player UNIT_AURA payload: a gain by name, a loss by aura instance.
---@param info UnitAuraUpdateInfo?
function TRB.Functions.Aura:UpdateConditionAuras(info)
	if next(conditionActive) == nil then
		return
	end
	if info == nil or info.isFullUpdate then
		wipe(conditionInstances)
		for name in pairs(conditionActive) do
			ReadConditionAura(name)
		end
		return
	end

	if info.addedAuras ~= nil then
		for _, aura in ipairs(info.addedAuras) do
			local name = aura.isHelpful and aura.name or nil
			if name ~= nil and conditionActive[name] ~= nil then
				conditionActive[name] = true
				conditionInstances[aura.auraInstanceID] = name
			end
		end
	end
	if info.removedAuraInstanceIDs ~= nil then
		for _, auraInstanceId in ipairs(info.removedAuraInstanceIDs) do
			local name = conditionInstances[auraInstanceId]
			if name ~= nil then
				conditionInstances[auraInstanceId] = nil
				-- Another caster's copy, or another rank, can still be up.
				ReadConditionAura(name)
			end
		end
	end
end

---Whether a buff condition holds right now: the player has any rank of its spell.
---@param condition TRB.CustomIndicatorCondition
---@return boolean
function TRB.Functions.Aura:IsConditionMet(condition)
	if condition.state ~= TRB.Functions.Aura.ConditionState.ACTIVE then
		return false
	end
	local name = conditionNames[condition.spellID]
	return name ~= nil and conditionActive[name] == true
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