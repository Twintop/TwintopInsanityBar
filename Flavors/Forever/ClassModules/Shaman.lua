local _, TRB = ...
if TRB.Data.character.classId ~= 7 then -- Only do this if we are on a Shaman!
	return
end

-- Shaman runtime (World of Warcraft: Forever): the template's runtime, with elemental shield tracking layered on top.
local runtime = TRB.Forever.Templates.Runtime:Install("shaman")

local lookupChanged = TRB.Functions.BarText.LookupChanged

-- The WOUND flags of a hit that dealt nothing; a partly blocked or absorbed hit lands as a WOUND without them.
local unlandedWoundFlags = { ABSORB = true, BLOCK = true, RESIST = true }

-- Whether the tracked shield is Water Shield, and when an orb was last spent; the lockout outlives a recast.
local waterShieldUp = false
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
	if currentTime - lastSpendTime < spells.lightningShield.attributes.spendLockout then
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

-- Water Shield restores mana with each orb, so a mana gain while it is up is an orb spent, by a hit or by a crit.
local manaGainFrame = CreateFrame("Frame")
manaGainFrame:SetScript("OnEvent", function(_, _, combatTextType)
	if waterShieldUp and not issecretvalue(combatTextType) and combatTextType == "ENERGIZE" then
		SpendOrb()
	end
end)

---Follows mana gains only with the Water Shield talent; combat text is silent until a unit is set, which only Blizzard's floating combat text does.
---@param talented boolean
local function WatchManaGains(talented)
	if not talented then
		manaGainFrame:UnregisterEvent("COMBAT_TEXT_UPDATE")
		return
	end
	manaGainFrame:RegisterEvent("COMBAT_TEXT_UPDATE")
	if C_CombatText.GetActiveUnit() == nil then
		-- Unverified for addons; a failure must not break the class module.
		pcall(C_CombatText.SetActiveUnit, "player")
	end
end

-- A loading screen's sync waits for CheckCharacter when the spell set isn't loaded yet, as on login and reload.
local syncPending = true

---Corrects the counted orbs and time from whichever shield's aura is up, which reads only out of combat.
---@return boolean # whether the spell set was loaded to sync against
local function SyncShieldFromAura()
	local shield, spells = GetShield()
	if shield == nil or spells == nil then
		return false
	end
	if shield:SyncCustomFromPlayerAura(spells.lightningShield.rankIds) then
		waterShieldUp = false
		TRB.Functions.BarText:MarkLookupDirty()
	elseif shield:SyncCustomFromPlayerAura({ spells.waterShield.id }) then
		waterShieldUp = true
		TRB.Functions.BarText:MarkLookupDirty()
	end
	return true
end

local syncFrame = CreateFrame("Frame")
syncFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
syncFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
syncFrame:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		syncPending = not SyncShieldFromAura()
	else
		SyncShieldFromAura()
	end
end)

---@param spells TRB.Classes.SpecializationSpellsBase
function runtime.CheckClassCharacter(spells)
	local waterShield = (spells --[[@as TRB.Classes.Forever.Shaman.GeneralSpells]]).waterShield
	WatchManaGains(runtime.talents ~= nil and runtime.talents:IsTalentActive(waterShield))
	if syncPending then
		syncPending = not SyncShieldFromAura()
	end
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
	local isWaterShield = tContains(castSpells, spells.waterShield)
	if not isWaterShield and not tContains(castSpells, spells.lightningShield) then
		return
	end
	waterShieldUp = isWaterShield
	shield:InitializeCustom(spells.lightningShield.duration, GetTime(), true, spells.lightningShield.maxStacks)
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
	local shield = GetShield()
	return shield ~= nil and shield.isActive
end
