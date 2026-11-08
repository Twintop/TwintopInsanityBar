local _, TRB = ...
if TRB.Data.character.classId ~= 5 then -- Only do this if we are on a Priest!
	return
end

-- Priest runtime (World of Warcraft: Forever). The runtime template installs the resource, health,
-- combo point, bar text and spec-switching behavior for the archetypes declared in Classes\PriestClasses.lua;
-- ability tracking specific to this class is layered on top of the returned runtime table.
local runtime = TRB.Forever.Templates.Runtime:Install("priest")

local lookupChanged = TRB.Functions.BarText.LookupChanged

-- The WOUND flags of a hit that dealt nothing; a partly absorbed hit lands as an unflagged WOUND.
local unlandedWoundFlags = { ABSORB = true, BLOCK = true, RESIST = true }

---Whether a UNIT_COMBAT hit spends a charge: in game, every unflagged physical WOUND did, swings, throws, and partial absorbs alike.
---@param action any
---@param flagText any
---@param schoolMask any
---@return boolean
local function SpendsCharge(action, flagText, schoolMask)
	if issecretvalue(action) or issecretvalue(flagText) or issecretvalue(schoolMask) then
		return false
	end
	return action == "WOUND" and schoolMask == Enum.Damageclass.MaskPhysical and not unlandedWoundFlags[flagText]
end

---Points combat text at the player for the diagnostic when Blizzard's floating combat text hasn't, which only it does on load.
---@return boolean, string? # whether a unit is set, and which
local function EnsureCombatTextUnit()
	local unit = C_CombatText.GetActiveUnit()
	if unit == nil then
		-- Unverified for addons; a failure must not break the class module.
		pcall(C_CombatText.SetActiveUnit, "player")
		unit = C_CombatText.GetActiveUnit()
	end
	return unit ~= nil, unit
end

---The active spell set's Inner Fire snapshot and the spell set, or nil before the spec cache loads.
---@return TRB.Classes.Snapshot?, TRB.Classes.Forever.Priest.GeneralSpells?
local function GetInnerFire()
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Forever.Priest.GeneralSpells?]]
	local snapshotData = TRB.Data.snapshotData
	if spells == nil or spells.innerFire == nil or snapshotData == nil then
		return nil, nil
	end
	return snapshotData.snapshots[spells.innerFire.id], spells
end

---Inner Fire's charges on a fresh cast, with Improved Inner Fire's bonus.
---@param spells TRB.Classes.Forever.Priest.GeneralSpells
---@return integer
local function GetInnerFireMaxStacks(spells)
	local maxStacks = spells.innerFire.maxStacks
	local improved = runtime.talents ~= nil and runtime.talents.talents[spells.improvedInnerFire.id] or nil
	if improved ~= nil and improved:IsActive() then
		local perRank = spells.improvedInnerFire.attributes.maxStacksPerRank
		maxStacks = maxStacks + perRank[math.min(improved.currentRank, #perRank)]
	end
	return maxStacks
end

---Spends one charge, if Inner Fire is tracked.
local function SpendCharge()
	local innerFire = GetInnerFire()
	if innerFire == nil or not innerFire.buff.isActive then
		return
	end
	innerFire.buff:RemoveStack()
	TRB.Functions.BarText:MarkLookupDirty()
end

-- /trb innerfire (temporary): one line per hit taken, pairing its combat text type with its UNIT_COMBAT payload.
local diagnostic = { enabled = false, frame = CreateFrame("Frame"), combatText = {}, unitCombat = {}, before = "", flushQueued = false, lastSync = "none yet" }

-- Combat text types that never come from a hit taken.
local diagnosticIgnoredCombatText = {
	HEAL = true, HEAL_CRIT = true, HEAL_ABSORB = true, HEAL_CRIT_ABSORB = true,
	PERIODIC_HEAL = true, PERIODIC_HEAL_CRIT = true, PERIODIC_HEAL_ABSORB = true,
	ENERGIZE = true, PERIODIC_ENERGIZE = true, ABSORB_ADDED = true,
	SPELL_CAST = true, SPELL_ACTIVE = true, SPELL_DISPELLED = true, EXTRA_ATTACKS = true,
	SPELL_AURA_START = true, SPELL_AURA_START_HARMFUL = true, SPELL_AURA_END = true, SPELL_AURA_END_HARMFUL = true,
	FACTION = true, HONOR_GAINED = true, COMBO_POINTS = true, RUNE = true, PLUNDER_UPDATE = true,
	ENTERING_COMBAT = true, LEAVING_COMBAT = true, HEALTH_LOW = true, MANA_LOW = true,
}

---A payload value for a diagnostic line, without comparing a secret.
---@param value any
---@return string
local function DiagnosticValue(value)
	if issecretvalue(value) then
		return "secret"
	elseif value == nil or value == "" then
		return "-"
	end
	return tostring(value)
end

---The tracked charges as "current/max", or "not tracking".
---@return string
local function DescribeTrackedCharges()
	local innerFire = GetInnerFire()
	if innerFire == nil or not innerFire.buff.isActive then
		return "not tracking"
	end
	return string.format("%d/%d", innerFire.buff.applications, TRB.Data.character.maxInnerFireStacks)
end

local function FlushDiagnosticHit()
	diagnostic.flushQueued = false
	print(string.format("|cFFFF8800TRB Inner Fire:|r text %s | unit %s | tracked %s -> %s",
		#diagnostic.combatText > 0 and table.concat(diagnostic.combatText, ", ") or "none",
		#diagnostic.unitCombat > 0 and table.concat(diagnostic.unitCombat, ", ") or "none",
		diagnostic.before, DescribeTrackedCharges()))
	wipe(diagnostic.combatText)
	wipe(diagnostic.unitCombat)
end

---Starts a hit's line on its first event; everything else that lands this frame joins it.
local function QueueDiagnosticHit()
	if not diagnostic.flushQueued then
		diagnostic.flushQueued = true
		diagnostic.before = DescribeTrackedCharges()
		C_Timer.After(0, FlushDiagnosticHit)
	end
end

---Copies Inner Fire's charges and time from its aura. Only an unrestricted read is trusted: in combat it is nil either way.
---@return string # what the sync found
local function SyncInnerFireFromAura()
	local innerFire, spells = GetInnerFire()
	if innerFire == nil or spells == nil then
		return "not loaded"
	end
	if InCombatLockdown() or (C_Secrets ~= nil and C_Secrets.ShouldAurasBeSecret ~= nil and C_Secrets.ShouldAurasBeSecret() == true) then
		return "auras restricted"
	end
	local buff = innerFire.buff
	local rankIds = spells.innerFire.rankIds or { spells.innerFire.id }
	for i = #rankIds, 1, -1 do
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(rankIds[i])
		if aura ~= nil then
			if issecrettable(aura) or issecretvalue(aura.applications) or issecretvalue(aura.expirationTime) or issecretvalue(aura.duration) then
				return "aura secret"
			end
			-- A count of 0 would leave an active buff with no charges, so the tracked count stands in.
			local charges = aura.applications > 0 and aura.applications or (buff.isActive and buff.applications or TRB.Data.character.maxInnerFireStacks)
			buff:InitializeCustom(aura.duration, aura.expirationTime - aura.duration, true, charges)
			TRB.Functions.BarText:MarkLookupDirty()
			return string.format("rank %d aura, %d charges, %ds left", rankIds[i], charges, math.floor(buff.remaining))
		end
	end
	if buff.isActive then
		buff:Reset()
		TRB.Functions.BarText:MarkLookupDirty()
		return "no aura, tracking ended"
	end
	return "no aura"
end

---Runs the aura sync, keeping its result for the diagnostic.
---@param trigger string
---@return string
local function SyncAndReport(trigger)
	local before = DescribeTrackedCharges()
	local result = SyncInnerFireFromAura()
	diagnostic.lastSync = trigger .. ": " .. result
	if diagnostic.enabled then
		print(string.format("|cFFFF8800TRB Inner Fire:|r sync on %s: %s | tracked %s -> %s", trigger, result, before, DescribeTrackedCharges()))
	end
	return result
end

-- A loading screen's sync waits for CheckCharacter when the spell set isn't loaded yet, as on login and reload.
local loadingScreenSyncPending = true

local function TryLoadingScreenSync()
	if SyncAndReport("loading screen") ~= "not loaded" then
		loadingScreenSyncPending = false
	end
end

-- Combat text only labels the line: for a swing it arrives about a second before its UNIT_COMBAT.
diagnostic.frame:SetScript("OnEvent", function(_, _, combatTextType)
	if issecretvalue(combatTextType) then
		QueueDiagnosticHit()
		diagnostic.combatText[#diagnostic.combatText + 1] = "secret"
	elseif not diagnosticIgnoredCombatText[combatTextType] then
		QueueDiagnosticHit()
		diagnostic.combatText[#diagnostic.combatText + 1] = combatTextType
	end
end)

local function ToggleDiagnostic()
	diagnostic.enabled = not diagnostic.enabled
	if not diagnostic.enabled then
		diagnostic.frame:UnregisterEvent("COMBAT_TEXT_UPDATE")
		print("|cFFFF8800TRB Inner Fire:|r diagnostic off")
		return
	end
	diagnostic.frame:RegisterEvent("COMBAT_TEXT_UPDATE")
	local _, combatTextUnit = EnsureCombatTextUnit()
	local innerFire, spells = GetInnerFire()
	local improved = spells ~= nil and runtime.talents ~= nil and runtime.talents.talents[spells.improvedInnerFire.id] or nil
	print(string.format("|cFFFF8800TRB Inner Fire:|r diagnostic on. Floating combat text %s, combat text unit %s, Improved Inner Fire rank %d, tracked %s, %ds left, last sync %s",
		C_CVar.GetCVarBool("enableFloatingCombatText") and "on" or "off", DiagnosticValue(combatTextUnit),
		improved ~= nil and improved.currentRank or 0, DescribeTrackedCharges(), innerFire ~= nil and math.floor(innerFire.buff.remaining) or 0,
		diagnostic.lastSync))
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		loadingScreenSyncPending = true
		TryLoadingScreenSync()
	else
		SyncAndReport("leaving combat")
	end
end)

local hitFrame = CreateFrame("Frame")
hitFrame:RegisterUnitEvent("UNIT_COMBAT", "player")
hitFrame:SetScript("OnEvent", function(_, _, _, action, flagText, amount, schoolMask)
	if diagnostic.enabled and (issecretvalue(action) or (action ~= "HEAL" and action ~= "ENERGIZE")) then
		QueueDiagnosticHit()
		diagnostic.unitCombat[#diagnostic.unitCombat + 1] = string.format("%s %s %s school %s",
			DiagnosticValue(action), DiagnosticValue(flagText), DiagnosticValue(amount), DiagnosticValue(schoolMask))
	end
	if SpendsCharge(action, flagText, schoolMask) then
		SpendCharge()
	end
end)

---@param spells TRB.Classes.SpecializationSpellsBase
function runtime.CheckClassCharacter(spells)
	TRB.Data.character.maxInnerFireStacks = GetInnerFireMaxStacks(spells --[[@as TRB.Classes.Forever.Priest.GeneralSpells]])
	if loadingScreenSyncPending then
		TryLoadingScreenSync()
	end
end

---A cast of any rank restarts Inner Fire at full charges.
---@param spellId integer?
function runtime.OnSpellCastSucceeded(spellId)
	local innerFire, spells = GetInnerFire()
	if innerFire == nil or spells == nil or spellId == nil then
		return
	end
	local castSpells = TRB.Data.spellsData.spellsById[spellId]
	if castSpells == nil or not tContains(castSpells, spells.innerFire) then
		return
	end
	local maxStacks = GetInnerFireMaxStacks(spells)
	TRB.Data.character.maxInnerFireStacks = maxStacks
	innerFire.buff:InitializeCustom(spells.innerFire.duration, GetTime(), true, maxStacks)
	TRB.Functions.BarText:MarkLookupDirty()
	if diagnostic.enabled then
		print(string.format("|cFFFF8800TRB Inner Fire:|r cast %d, tracking %d charges for %ds", spellId, maxStacks, spells.innerFire.duration))
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
	local innerFire = GetInnerFire()
	if innerFire == nil then
		return
	end
	-- Reset leaves both at 0 once the buff is gone.
	local stacks = innerFire.buff.applications
	local remaining = innerFire.buff.remaining
	local maxStacks = TRB.Data.character.maxInnerFireStacks
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

TRB.Classes.SpecDescriptor:Declare("priest_general", {
	slashCommands = {
		innerfire = function(subcommand)
			if subcommand ~= nil and subcommand ~= "" then
				print("|cFFFF8800TRB Inner Fire:|r Unknown argument '" .. subcommand .. "'. Usage: /trb innerfire")
				return
			end
			ToggleDiagnostic()
		end,
	},
})
