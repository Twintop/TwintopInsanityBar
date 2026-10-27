local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.ThresholdCooldowns = {}

-- Threshold line cooldowns, read only in the cooldown events that can change them. Ticks read the snapshot fields alone.
local ThresholdCooldowns = TRB.Functions.ThresholdCooldowns

local eventFrame = CreateFrame("Frame")
local enabled = false
local eventsRegistered = false
---@type TRB.Classes.SnapshotCooldown[]
local tracked = {}
-- Tracked cooldowns by every spell id a cooldown event can name them by.
---@type table<integer, TRB.Classes.SnapshotCooldown[]>
local trackedById = {}
-- No event marks a cooldown's natural end, so an invisible Cooldown frame per cooldown reports it.
---@type table<TRB.Classes.SnapshotCooldown, Cooldown>
local endWidgets = {}
---@type table<TRB.Classes.SnapshotCooldown, number>
local startedAt = {}
---@type table<TRB.Classes.SnapshotCooldown, boolean>
local retimePending = {}
---@type table<TRB.Classes.SnapshotCooldown, boolean>
local chargeRefreshPending = {}

---@param cooldown TRB.Classes.SnapshotCooldown
local function End(cooldown)
	cooldown:MarkEnded()
	local widget = endWidgets[cooldown]
	if widget ~= nil then
		widget:Clear()
	end
end

---Loads the cooldown's end widget from its duration object, which carries secret times the widget can still time.
---@param cooldown TRB.Classes.SnapshotCooldown
local function LoadEndWidget(cooldown)
	local widget = endWidgets[cooldown]
	if widget == nil then
		widget = CreateFrame("Cooldown", nil, UIParent, "CooldownFrameTemplate") --[[@as Cooldown]]
		-- The template fills its parent and every load shows the frame, so it must be one invisible pixel that draws nothing.
		widget:ClearAllPoints()
		widget:SetSize(1, 1)
		widget:SetPoint("CENTER")
		widget:SetAlpha(0)
		widget:SetDrawSwipe(false)
		widget:SetDrawEdge(false)
		widget:SetDrawBling(false)
		widget:SetHideCountdownNumbers(true)
		widget:SetScript("OnCooldownDone", function()
			if cooldown.onCooldown then
				End(cooldown)
			end
		end)
		endWidgets[cooldown] = widget
	end
	local durationObject = cooldown:GetDurationObject()
	if durationObject ~= nil then
		widget:SetCooldownFromDurationObject(durationObject)
	elseif cooldown.endsAt ~= nil then
		-- With nothing for the widget to time, a plain end time ends it; any later change bumps the version and reloads.
		local version = cooldown.version
		C_Timer.After(math.max(cooldown.endsAt - GetTime(), 0), function()
			if cooldown.onCooldown and cooldown.version == version then
				End(cooldown)
			end
		end)
	end
end

---Reads a changed cooldown's new times a frame after its event, once the client has applied the change.
---@param cooldown TRB.Classes.SnapshotCooldown
local function ScheduleRetime(cooldown)
	if retimePending[cooldown] then
		return
	end
	retimePending[cooldown] = true
	C_Timer.After(0, function()
		retimePending[cooldown] = nil
		if not cooldown.onCooldown then
			return
		end
		local info = C_Spell.GetSpellCooldown(cooldown:GetSpell():GetRankedId())
		-- Only the GCD left means the change finished the ability's own cooldown.
		if info == nil or info.isActive ~= true or info.isOnGCD == true then
			End(cooldown)
			return
		end
		cooldown:Retime(info)
		LoadEndWidget(cooldown)
	end)
end

---Re-reads a recharging spell's recharge a frame after a cooldown event names it, since a reduction can move it.
---@param cooldown TRB.Classes.SnapshotCooldown
local function ScheduleChargeRefresh(cooldown)
	if chargeRefreshPending[cooldown] then
		return
	end
	chargeRefreshPending[cooldown] = true
	C_Timer.After(0, function()
		chargeRefreshPending[cooldown] = nil
		if cooldown.isActive then
			cooldown:RefreshCharges()
		end
	end)
end

---Applies a cooldown event. isOnGCD false is the spell's own cooldown (a charge spell's: no charges left), true is only
---the GCD, and nil is a running cooldown whose times changed, such as a reduction.
---@param cooldown TRB.Classes.SnapshotCooldown
---@param now number
local function ApplyCooldownEvent(cooldown, now)
	local spell = cooldown:GetSpell()
	if spell.hasCharges == true and cooldown.isActive then
		ScheduleChargeRefresh(cooldown)
	end
	local info = C_Spell.GetSpellCooldown(spell:GetRankedId())
	if info == nil then
		return
	end
	if info.isActive ~= true then
		if cooldown.onCooldown then
			End(cooldown)
		end
		return
	end
	local isOnGCD = info.isOnGCD
	if isOnGCD == false then
		cooldown:Start(info)
		startedAt[cooldown] = now
		LoadEndWidget(cooldown)
	elseif not cooldown.onCooldown then
		return
	elseif isOnGCD == true or spell.hasCharges == true then
		-- A cast reads the GCD first and its own cooldown second, in the same frame.
		if startedAt[cooldown] ~= now then
			End(cooldown)
		end
	else
		ScheduleRetime(cooldown)
	end
end

eventFrame:SetScript("OnEvent", function(_, event, spellID, baseSpellID)
	if event == "SPELL_UPDATE_CHARGES" then
		for _, cooldown in ipairs(tracked) do
			if cooldown:GetSpell().hasCharges == true then
				cooldown:RefreshCharges()
			end
		end
		return
	end

	local now = GetTime()
	-- A secret id can't key a table, so it updates everything like a nil one.
	if spellID ~= nil and issecretvalue(spellID) then
		spellID = nil
	end
	if spellID == nil then
		for _, cooldown in ipairs(tracked) do
			ApplyCooldownEvent(cooldown, now)
		end
		return
	end
	if baseSpellID ~= nil and issecretvalue(baseSpellID) then
		baseSpellID = nil
	end
	local matches = trackedById[spellID] or (baseSpellID ~= nil and trackedById[baseSpellID]) or nil
	if matches ~= nil then
		for _, cooldown in ipairs(matches) do
			ApplyCooldownEvent(cooldown, now)
		end
	end
end)

---@param id integer?
---@param cooldown TRB.Classes.SnapshotCooldown
local function AddId(id, cooldown)
	if id == nil then
		return
	end
	local list = trackedById[id]
	if list == nil then
		list = {}
		trackedById[id] = list
	end
	if not tContains(list, cooldown) then
		list[#list + 1] = cooldown
	end
end

---@param spell TRB.Classes.SpellBase
---@param cooldown TRB.Classes.SnapshotCooldown
local function AddSpellIds(spell, cooldown)
	AddId(spell.id, cooldown)
	AddId(spell:GetRankedId(), cooldown)
	AddId(spell.castId, cooldown)
	if spell.rankIds ~= nil then
		for _, rankId in ipairs(spell.rankIds) do
			AddId(rankId, cooldown)
		end
	end
end

---@param spell TRB.Classes.SpellBase?
---@param snapshots table<integer, TRB.Classes.Snapshot>
local function Track(spell, snapshots)
	local snapshot = spell ~= nil and snapshots[spell.id] or nil
	if snapshot == nil or snapshot.spell == nil then
		return
	end
	local cooldown = snapshot.cooldown
	if not tContains(tracked, cooldown) then
		tracked[#tracked + 1] = cooldown
	end
	-- Lines sharing a snapshot, such as Execute's, are named by their own ids as well as the snapshot's.
	AddSpellIds(spell --[[@as TRB.Classes.SpellBase]], cooldown)
	AddSpellIds(snapshot.spell, cooldown)
end

local function SyncEventRegistration()
	local wanted = #tracked > 0
	if wanted == eventsRegistered then
		return
	end
	eventsRegistered = wanted
	if wanted then
		eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		eventFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
	else
		eventFrame:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		eventFrame:UnregisterEvent("SPELL_UPDATE_CHARGES")
	end
end

---Rebuilds the tracked set from the live spec's learned threshold lines with a cooldown and its descriptor's
---cooldownSpells. A cooldown that joins is read once; one that leaves ends, so no stale cooldown outlives tracking.
function ThresholdCooldowns:Sync()
	local previous = tracked
	tracked = {}
	wipe(trackedById)

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	if enabled and snapshotData ~= nil then
		local snapshots = snapshotData.snapshots
		for _, spell in pairs(TRB.Data.cache.thresholdSpellsByKey) do
			if spell.hasCooldown then
				Track(spell, snapshots)
			end
		end
		local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
		if descriptor ~= nil and descriptor.cooldownSpells ~= nil then
			local spells = TRB.Data.spellsData.spells
			for _, key in ipairs(descriptor.cooldownSpells) do
				Track(spells[key], snapshots)
			end
		end
	end

	local left = {}
	for _, cooldown in ipairs(previous) do
		left[cooldown] = true
	end
	for _, cooldown in ipairs(tracked) do
		if left[cooldown] then
			left[cooldown] = nil
		else
			cooldown:ReadInitial()
			if cooldown.onCooldown then
				LoadEndWidget(cooldown)
			end
		end
	end
	for cooldown in pairs(left) do
		End(cooldown)
		if cooldown:GetSpell().hasCharges == true then
			cooldown:ClearRecharge()
		end
		startedAt[cooldown] = nil
		retimePending[cooldown] = nil
		chargeRefreshPending[cooldown] = nil
	end

	SyncEventRegistration()
end

---Starts tracking the live spec's threshold line cooldowns.
function ThresholdCooldowns:Enable()
	enabled = true
	self:Sync()
end

---Stops tracking and ends every tracked cooldown.
function ThresholdCooldowns:Disable()
	enabled = false
	self:Sync()
end
