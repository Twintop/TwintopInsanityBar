local _, TRB = ...
if TRB.Data.character.classId ~= 7 then -- Only do this if we are on a Shaman!
	return
end

-- Shaman runtime (World of Warcraft: Forever): the template's runtime, with elemental shield tracking layered on top.
local runtime = TRB.Forever.Templates.Runtime:Install("shaman")

local lookupChanged = TRB.Functions.BarText.LookupChanged

-- The WOUND flags of a hit that dealt nothing; a partly blocked or absorbed hit lands as a WOUND without them.
local unlandedWoundFlags = { ABSORB = true, BLOCK = true, RESIST = true }

-- The spell field of the shield the snapshot tracks, and when an orb was last spent; the lockout outlives a recast.
local trackedShieldKey = "lightningShield"
local lastSpendTime = 0

---The active spell set's shield snapshot's buff and the spell set, or nil before the spec cache loads.
---@return TRB.Classes.SnapshotBuff?, TRB.Classes.Forever.Shaman.GeneralSpells?
local function GetShield()
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Forever.Shaman.GeneralSpells?]]
	local snapshotData = TRB.Data.snapshotData
	if spells == nil or spells.lightningShield == nil or snapshotData == nil then
		return nil, nil
	end
	local snapshot = snapshotData.snapshots[spells.lightningShield.id]
	return snapshot and snapshot.buff, spells
end

---Spends one orb unless one was spent inside the lockout.
local function SpendOrb()
	local shield, spells = GetShield()
	if shield == nil or spells == nil or not shield.isActive then
		return
	end
	local currentTime = GetTime()
	if currentTime - lastSpendTime < spells[trackedShieldKey].attributes.spendLockout then
		return
	end
	lastSpendTime = currentTime
	shield:RemoveStack()
	TRB.Functions.BarText:MarkLookupDirty()
end

---Whether a UNIT_COMBAT hit spends an orb: in game, every landed hit of any school and every fully blocked one did.
---@param action any
---@param flagText any
---@return boolean
local function SpendsOrb(action, flagText)
	if issecretvalue(action) or issecretvalue(flagText) then
		return false
	end
	return action == "BLOCK" or (action == "WOUND" and not unlandedWoundFlags[flagText])
end

local hitFrame = CreateFrame("Frame")
hitFrame:RegisterUnitEvent("UNIT_COMBAT", "player")
hitFrame:SetScript("OnEvent", function(_, _, _, action, flagText)
	if SpendsOrb(action, flagText) then
		SpendOrb()
	end
end)

---Corrects the counted orbs and time from whichever shield's aura is up, which reads only out of combat; nil before the spell set loads.
---@param endWhenMissing boolean
---@return string?
local function SyncShieldFromAura(endWhenMissing)
	local shield, spells = GetShield()
	if shield == nil or spells == nil then
		return nil
	end
	local result = shield:SyncCustomFromPlayerAura(spells.lightningShield.rankIds, false)
	if result == "copied" then
		trackedShieldKey = "lightningShield"
	elseif result == "missing" then
		result = shield:SyncCustomFromPlayerAura({ spells.waterShield.id }, endWhenMissing)
		if result == "copied" then
			trackedShieldKey = "waterShield"
		end
	end
	if result == "copied" or result == "ended" then
		TRB.Functions.BarText:MarkLookupDirty()
	end
	return result
end

local shieldSync = TRB.Classes.AuraSync:New(SyncShieldFromAura)

---@param spells TRB.Classes.SpecializationSpellsBase
function runtime.CheckClassCharacter(spells)
	local shield = GetShield()
	local waterShield = (spells --[[@as TRB.Classes.Forever.Shaman.GeneralSpells]]).waterShield
	-- Unlearning Water Shield takes its buff with it.
	if shield ~= nil and shield.isActive and trackedShieldKey == "waterShield" and runtime.talents ~= nil
		and not runtime.talents:IsTalentActive(waterShield) then
		shield:Reset(nil, true)
		TRB.Functions.BarText:MarkLookupDirty()
	end
	shieldSync:OnCheckCharacter()
end

---A cast of either shield, any rank, replaces the tracked shield at full orbs.
---@param spellId integer?
function runtime.OnSpellCastSucceeded(spellId)
	local shield, spells = GetShield()
	if shield == nil or spells == nil or spellId == nil or issecretvalue(spellId) then
		return
	end
	local castSpells = TRB.Data.spellsData.spellsById[spellId]
	if castSpells == nil then
		return
	end
	local key = nil
	if tContains(castSpells, spells.waterShield) then
		key = "waterShield"
	elseif tContains(castSpells, spells.lightningShield) then
		key = "lightningShield"
	else
		return
	end
	trackedShieldKey = key
	local spell = spells[key]
	shield:InitializeCustom(spell.duration, GetTime(), true, spell.maxStacks)
	TRB.Functions.BarText:MarkLookupDirty()
end

---@param currentTime number
function runtime.UpdateClassSnapshot(currentTime)
	local shield = GetShield()
	if shield ~= nil and shield.isActive then
		shield:GetRemainingTime(currentTime)
		if not shield.isActive then
			TRB.Functions.BarText:MarkLookupDirty()
		end
	end
end

---@param lookup table
---@param lookupLogic table
---@param prevState table
---@param activeVars table?
function runtime.RefreshClassLookupData(lookup, lookupLogic, prevState, activeVars)
	if activeVars and not (activeVars["$shieldOrbs"] or activeVars["$shieldOrbsMax"] or activeVars["$shieldTime"]) then
		return
	end
	local shield, spells = GetShield()
	if shield == nil or spells == nil then
		return
	end
	-- Reset leaves both at 0 once the shield is gone.
	local orbs = shield.applications
	local remaining = shield.remaining
	local maxOrbs = spells.lightningShield.maxStacks
	lookupLogic["$shieldOrbs"] = orbs
	lookupLogic["$shieldOrbsMax"] = maxOrbs
	lookupLogic["$shieldTime"] = remaining
	if lookupChanged(prevState, "$shieldOrbs", orbs) then
		lookup["$shieldOrbs"] = tostring(orbs)
	end
	if lookupChanged(prevState, "$shieldOrbsMax", maxOrbs) then
		lookup["$shieldOrbsMax"] = tostring(maxOrbs)
	end
	if lookupChanged(prevState, "$shieldTime", remaining) then
		lookup["$shieldTime"] = TRB.Functions.BarText:TimerPrecision(remaining)
	end
end

---@param var string
---@return boolean
function runtime.IsValidClassVariable(var)
	if var == "$shieldOrbs" or var == "$shieldTime" then
		local shield = GetShield()
		return shield ~= nil and shield.isActive
	end
	return var == "$shieldOrbsMax"
end

---@return boolean
function runtime.HasClassTimers()
	-- A 10 minute shield would keep the bar text on its timer path even when no text shows its time.
	local activeVars = TRB.Data.activeVariables
	if activeVars ~= nil and not activeVars["$shieldTime"] then
		return false
	end
	local shield = GetShield()
	return shield ~= nil and shield.isActive
end
