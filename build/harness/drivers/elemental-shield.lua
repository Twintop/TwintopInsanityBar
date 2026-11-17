-- Checks the Forever Shaman's Elemental Shield bar (gate, casts, orb spends and their lockout, Water Shield's talent,
-- the aura sync, nodes, bar text, and audio counter).
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
-- Lightning Shield's rank 1 and top rank, Water Shield, the orb cap, the duration, and the gaps after a spend that, in game,
-- spent nothing (3.3s) and spent an orb (3.4s).
local SHIELD = { first = 324, top = 10432, water = 408510, orbs = 3, duration = 600, locked = 3.3, spent = 3.4 }
local OTHER_SPELL = 403

-- The test clock, the addon's frames, the known spells, the Water Shield talent, the player's auras, and combat lockdown.
local drv = { now = 1000, frames = {}, known = {}, talent = false, auras = {}, inCombat = false }

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	local innerCreate = G.CreateFrame
	G.CreateFrame = function(...)
		local frame = innerCreate(...)
		drv.frames[#drv.frames + 1] = frame
		return frame
	end
	G.GetTime = function() return drv.now end
	local innerIsSecret = G.issecretvalue
	G.issecretvalue = function(v)
		if v == "secret" then
			return true
		end
		return innerIsSecret ~= nil and innerIsSecret(v) or false
	end
	G.C_SpellBook.IsSpellKnown = function(spellId) return drv.known[spellId] == true end
	G.C_UnitAuras.GetPlayerAuraBySpellID = function(spellId) return drv.auras[spellId] end
	G.issecrettable = function() return false end
	G.InCombatLockdown = function() return drv.inCombat end
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	TRB.Functions.News.Init = function() end
	if TRB.Flavor.id == "forever" then
		-- The talent cache reads the Water Shield talent from here.
		local readTalentRanks = TRB.Flavor.ReadTalentRanks
		TRB.Flavor.ReadTalentRanks = function()
			local ranks = readTalentRanks()
			if drv.talent then
				ranks[SHIELD.water] = { currentRank = 1, maxRank = 1 }
			end
			return ranks
		end
	end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
	end
	local function try(label, fn)
		local ok, err = xpcall(fn, function(e) return debug.traceback(tostring(e), 2) end)
		if not ok then
			errors = errors + 1
			print("DRIVER ERROR " .. label .. "\n    " .. tostring(err):gsub("\n", "\n    "))
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	-- Only the fill checks draw, through the real update.
	local triggerUpdates = TRB.Functions.Class.TriggerResourceBarUpdates
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	for i = 1, 20 do
		local _, timerFailures = stubs.fireEvents("TRB_DRAIN_SETUP_" .. i, ctx.addonName)
		if timerFailures == 0 then
			break
		end
	end
	check("the deferred setup finishes", TRB.Details.addonData.optionsPanelFinished == true)

	local L = TRB.Localization
	local Class = TRB.Functions.Class
	local Bar = TRB.Functions.Bar
	local barGroups = TRB.Frames.barGroups

	---Whether the spec's bar text variable list offers a variable.
	local function Offers(variable)
		for _, entry in ipairs(TRB.Data.barTextVariables.values or {}) do
			if entry.variable == variable then
				return true
			end
		end
		return false
	end

	if TRB.Flavor.id ~= "forever" or ctx.classId ~= 7 then
		check("only a Forever Shaman offers shield orb bar text", not Offers("$shieldOrbs"))
		return errors
	end

	---The shield snapshot's buff, read fresh after a spec switch.
	local function Buff()
		local spell = TRB.Data.spellsData.spells.lightningShield
		local snapshot = spell ~= nil and TRB.Data.snapshotData.snapshots[spell.id] or nil
		return snapshot ~= nil and snapshot.buff or nil
	end
	local buff = Buff()
	local group = barGroups ~= nil and barGroups.secondary or nil
	check("the shield has a snapshot", buff ~= nil)
	check("the bar text offers $shieldOrbs, $shieldOrbsMax, $shieldTime, #lightningShield, and #waterShield, but not $comboPoints",
		Offers("$shieldOrbs") and Offers("$shieldOrbsMax") and Offers("$shieldTime") and TRB.Data.lookup["#lightningShield"] ~= nil
		and TRB.Data.lookup["#waterShield"] ~= nil and not Offers("$comboPoints"))
	check("the secondary bar has one node per orb", group ~= nil and group.maxNodes == SHIELD.orbs)
	if buff == nil or group == nil then
		return errors
	end
	check("it is named the Elemental Shield Bar", Bar:GetSpecResourceBarName("secondary", 7, 1) == string.format(L["ResourceBarName"], L["ResourceShamanElementalShield"]))
	local settings = TRB.Data.settings.shaman.general
	local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
	local anchors = descriptor ~= nil and descriptor.barTextAnchorFrames ~= nil and descriptor.barTextAnchorFrames.secondary or nil
	check("its nodes are bar text anchors", anchors ~= nil and #anchors == SHIELD.orbs and anchors[1].label == L["ForeverShamanElementalShield1"]
		and anchors[SHIELD.orbs].frame == "ComboPoint_" .. SHIELD.orbs)
	check("the Totems bar stays declared", descriptor ~= nil and descriptor.totems ~= nil)
	local source = TRB.Functions.AudioCues:GetCounterSource("shaman_general", "elementalShield")
	check("it has a Shield Orbs audio counter that plays at or below a value", source ~= nil and source.max == SHIELD.orbs and source.compare == "atMost"
		and source.label == L["ForeverShamanAudioCueSourceElementalShield"])
	local seed1, seed2 = settings.audio.elementalShieldThreshold1, settings.audio.elementalShieldThreshold2
	check("seeded with two cues, both off, at one orb and none", seed1 ~= nil and seed2 ~= nil and seed1.enabled == false and seed2.enabled == false
		and seed1.source == "elementalShield" and seed1.configuration.thresholdValue == 1 and seed2.configuration.thresholdValue == 0)

	-- A layout's render transition runs on the stubs' wall clock and would hide every bar from the draws.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	local secondaryEnabled = nil
	local addEntry = TRB.Functions.BarVisibility.AddEntry
	TRB.Functions.BarVisibility.AddEntry = function(self, entries, barGroup, visibility, enabled, ...)
		if barGroup ~= nil and barGroup == group then
			secondaryEnabled = enabled
		end
		return addEntry(self, entries, barGroup, visibility, enabled, ...)
	end
	-- A forced pass hides every bar, so this runs an ordinary one.
	local function Shown()
		secondaryEnabled = nil
		TRB.Functions.BarVisibility:MarkDirty()
		try("HideResourceBar", function() Class:HideResourceBar() end)
		return secondaryEnabled
	end
	---Runs the handlers of the frames one source file made for an event; returns how many ran.
	local function Fire(sourcePattern, event, ...)
		local args = { ... }
		local ran = 0
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find(sourcePattern) then
				ran = ran + 1
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
		return ran
	end
	-- Enough passes for the spec switch's nested timers.
	local function Drain()
		for _ = 1, 5 do
			stubs.fireEvents("TRB_DRAIN", ctx.addonName)
		end
	end
	local function Retalent(taken)
		drv.talent = taken
		stubs.fireEvents("TRAIT_CONFIG_UPDATED", ctx.addonName)
		Drain()
	end

	-- The real update's node fills and the counter value it feeds the audio cues.
	local values = {}
	local setValue = Bar.SetBarNodeValue
	Bar.SetBarNodeValue = function(self, nodeSettings, key, node, value, maxResource)
		values[node] = value
		return setValue(self, nodeSettings, key, node, value, maxResource)
	end
	local counted = nil
	local updateCounter = TRB.Functions.AudioCues.UpdateCounter
	TRB.Functions.AudioCues.UpdateCounter = function(self, specSettings, snapshotData, sourceId, value, ...)
		if sourceId == "elementalShield" then
			counted = value
		end
		return updateCounter(self, specSettings, snapshotData, sourceId, value, ...)
	end
	---The filled node count the real update draws; nil when it draws some node no whole value, or none at all.
	local function Draw()
		wipe(values)
		counted = nil
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() triggerUpdates() end)
		local filled = 0
		for i = 1, SHIELD.orbs do
			local value = values[group:GetNode(i)]
			if value == 1 then
				filled = filled + 1
			elseif value ~= 0 then
				return nil
			end
		end
		return filled
	end
	local function Cast(spellId)
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Cast-0") end)
	end
	---A UNIT_COMBAT hit on the player, with its amount secret as in game.
	local function Hit(action, flagText, schoolMask)
		Fire("Shaman%.lua$", "UNIT_COMBAT", "player", action or "WOUND", flagText or "", "secret", schoolMask or 1)
	end
	---Whether the shield counts as a running timer for bar text that uses the given variables; nil is every variable.
	local function TimersActive(activeVariables)
		TRB.Data.activeVariables = activeVariables
		local active = Class:HasActiveTimers()
		TRB.Data.activeVariables = nil
		return active
	end
	local function Wait(seconds)
		drv.now = drv.now + seconds
	end
	local function Lookup()
		TRB.Data.activeVariables = nil
		try("RefreshLookupData", function() TRB.Functions.RefreshLookupData() end)
		return TRB.Data.lookup, TRB.Data.lookupLogic
	end

	check("before Lightning Shield is learned, the bar is hidden", Bar:IsBarTalentGatedHidden("secondary") and Shown() == false)
	drv.known[SHIELD.first] = true
	Fire("Runtime%.lua$", "SPELLS_CHANGED")
	Drain()
	check("learning it shows the bar", not Bar:IsBarTalentGatedHidden("secondary") and Shown() == true)
	buff = Buff() --[[@as table]]

	check("before a cast nothing is tracked", not buff.isActive and not TimersActive()
		and not Class:IsValidVariableForSpec("$shieldOrbs") and not Class:IsValidVariableForSpec("$shieldTime")
		and Class:IsValidVariableForSpec("$shieldOrbsMax") and Draw() == 0 and counted == 0)
	Cast(OTHER_SPELL)
	Hit()
	check("another spell or a hit with no shield changes nothing", not buff.isActive)
	Cast(SHIELD.first)
	check("Lightning Shield starts at three orbs for ten minutes", buff.isActive and buff.applications == SHIELD.orbs and buff.remaining == SHIELD.duration
		and TimersActive() and Class:IsValidVariableForSpec("$shieldOrbs"))
	check("but runs no bar text timer when no text shows $shieldTime", not TimersActive({ ["$shieldOrbs"] = true })
		and TimersActive({ ["$shieldTime"] = true }))
	Wait(10)
	Hit()
	check("a hit that lands spends an orb", buff.applications == 2 and Draw() == 2 and counted == 2)
	local lookup, lookupLogic = Lookup()
	check("the bar text shows 2 of 3 orbs", lookup["$shieldOrbs"] == "2" and lookup["$shieldOrbsMax"] == "3" and lookupLogic["$shieldOrbs"] == 2
		and lookupLogic["$shieldTime"] == buff.remaining)
	Wait(SHIELD.locked)
	Hit()
	Hit("BLOCK", "BLOCK")
	check("hits 3.3 seconds after a spend spend nothing", buff.applications == 2)
	Wait(SHIELD.spent - SHIELD.locked)
	Hit("MISS")
	Hit("DODGE")
	Hit("WOUND", "ABSORB")
	Hit("WOUND", "RESIST", 8)
	Hit("WOUND", "BLOCK")
	Hit("HEAL")
	Hit("secret")
	check("a miss, a dodge, a hit that dealt nothing, a heal, and a secret hit spend nothing", buff.applications == 2)
	Hit("WOUND", "", 8)
	check("a spell hit 3.4 seconds after a spend spends an orb", buff.applications == 1)
	Wait(SHIELD.spent)
	Cast(SHIELD.top)
	check("any rank's recast refills the orbs", buff.applications == SHIELD.orbs and buff.remaining == SHIELD.duration)
	Hit("BLOCK", "BLOCK")
	check("a fully blocked hit spends an orb", buff.applications == 2)
	Cast(SHIELD.first)
	Hit()
	check("the lockout carries across a recast", buff.applications == SHIELD.orbs)
	Wait(SHIELD.spent)
	Hit("WOUND", "BLOCK_REDUCED")
	check("a partly blocked hit spends an orb", buff.applications == 2)
	Wait(SHIELD.spent)
	Hit("WOUND", "CRITICAL")
	Wait(SHIELD.spent)
	Hit()
	check("the last orb ends the tracking", not buff.isActive and not TimersActive() and Draw() == 0)

	-- Water Shield: hits spend its orbs, and unlearning its talent takes them away.
	Retalent(true)
	buff = Buff() --[[@as table]]
	Wait(SHIELD.spent)
	Cast(SHIELD.first)
	Cast(SHIELD.water)
	check("Water Shield replaces Lightning Shield at three orbs", buff.isActive and buff.applications == SHIELD.orbs and buff.remaining == SHIELD.duration)
	Hit()
	check("a hit spends Water Shield's orbs too", buff.applications == 2)
	Retalent(false)
	buff = Buff() --[[@as table]]
	check("unlearning Water Shield ends its orbs", not buff.isActive)
	Cast(SHIELD.first)
	Retalent(false)
	buff = Buff() --[[@as table]]
	check("but leaves Lightning Shield's", buff.isActive and buff.applications == SHIELD.orbs)

	-- The aura sync: leaving combat copies the orbs and time of whichever shield is up, and a missing aura ends them.
	drv.auras[SHIELD.top] = { applications = 1, expirationTime = drv.now + 200, duration = SHIELD.duration }
	drv.inCombat = true
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	check("in combat lockdown, the aura isn't read", buff.applications == SHIELD.orbs)
	drv.inCombat = false
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	check("leaving combat copies Lightning Shield's orbs and time", buff.applications == 1 and buff.remaining == 200)
	drv.auras[SHIELD.top] = nil
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	check("with no shield's aura up, leaving combat ends the orbs", not buff.isActive)
	Retalent(true)
	buff = Buff() --[[@as table]]
	drv.auras[SHIELD.water] = { applications = 0, charges = 2, expirationTime = drv.now + 100, duration = SHIELD.duration }
	stubs.fireEvents("PLAYER_ENTERING_WORLD", ctx.addonName)
	Drain()
	buff = Buff() --[[@as table]]
	check("a loading screen copies Water Shield's orbs from its charges, and keeps the bar", buff.isActive and buff.applications == 2 and buff.remaining == 100
		and Shown() == true and Draw() == 2)
	Retalent(false)
	buff = Buff() --[[@as table]]
	check("and tracks it as Water Shield, which the missing talent ends", not buff.isActive)
	drv.auras = {}
	-- A loading screen whose read misses keeps the orbs, and a later frame's CheckCharacter reads again.
	Cast(SHIELD.first)
	stubs.fireEvents("PLAYER_ENTERING_WORLD", ctx.addonName)
	Drain()
	buff = Buff() --[[@as table]]
	check("a loading screen whose read finds no shield keeps the orbs", buff.isActive and buff.applications == SHIELD.orbs)
	drv.auras[SHIELD.top] = { applications = 2, expirationTime = drv.now + 300, duration = SHIELD.duration }
	Wait(0.15)
	try("CheckCharacter", function() Class:CheckCharacter() end)
	check("and the next CheckCharacter, a frame later, copies the aura", buff.applications == 2)
	-- A login: the sync waits until the spell set loads.
	buff:Reset()
	drv.auras[SHIELD.top] = { applications = 1, expirationTime = drv.now + 250, duration = SHIELD.duration }
	local spellsData = TRB.Data.spellsData
	TRB.Data.spellsData = nil
	Fire("Snapshot%.lua$", "PLAYER_ENTERING_WORLD")
	TRB.Data.spellsData = spellsData
	check("before the spell set loads, a loading screen syncs nothing", not buff.isActive)
	try("CheckCharacter", function() Class:CheckCharacter() end)
	check("and the next CheckCharacter copies the aura, as on login and reload", buff.isActive and buff.applications == 1)
	drv.auras = {}

	-- The Totems bar sits on the shield bar by default, instead of at the same spot above the Mana bar.
	local shamanSettings = TRB.Data.settings.shaman.general
	check("the Totems bar's default anchor is the shield bar", shamanSettings.bars.totems.anchor.barKey == "secondary"
		and shamanSettings.comboPoints.anchor.barKey == "primary")
	local totemsGroup = barGroups.totems
	local anchoredTo = {}
	for _, watched in ipairs({ group, totemsGroup }) do
		local frame = watched ~= nil and watched.containerFrame or nil
		if frame ~= nil then
			local setPoint = frame.SetPoint
			frame.SetPoint = function(self, point, relativeTo, ...)
				anchoredTo[watched] = relativeTo
				return setPoint(self, point, relativeTo, ...)
			end
		end
	end
	try("layout", function() Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, barGroups) end)
	for _, watched in ipairs({ group, totemsGroup }) do
		if watched ~= nil and watched.containerFrame ~= nil then
			watched.containerFrame.SetPoint = nil
		end
	end
	check("and a layout puts the Totems bar on the shield bar", totemsGroup ~= nil and anchoredTo[group] ~= nil and anchoredTo[totemsGroup] ~= nil
		and anchoredTo[group] ~= anchoredTo[totemsGroup] and anchoredTo[totemsGroup] == group:GetAnchorFrame())

	-- An existing save: a Totems bar at its old default spot moves once; one placed anywhere else stays.
	local Settings = TRB.Functions.Settings
	---A saved-variables shaped table holding one Shaman spec piece with this Totems anchor and migration flags.
	local function SavedWith(anchor, migrations)
		return { shaman = { general = { bars = { totems = { anchor = anchor } }, displayText = { barText = {}, migrations = migrations } } } }
	end
	local function TotemAnchor(saved)
		return saved.shaman.general.bars.totems.anchor
	end
	local oldDefault = Settings:DefaultCustomBarDimensions(false).anchor
	local saved = SavedWith(TRB.Functions.Table:DeepCopy(oldDefault), nil)
	try("MigrateTotemBarAnchors", function() Settings:MigrateTotemBarAnchors(saved) end)
	check("a Totems bar at the old default spot moves onto the shield bar, once", TotemAnchor(saved).barKey == "secondary"
		and TotemAnchor(saved).yOffset == oldDefault.yOffset and saved.shaman.general.displayText.migrations.totemBarAnchor == true)
	TotemAnchor(saved).barKey = "primary"
	try("MigrateTotemBarAnchors", function() Settings:MigrateTotemBarAnchors(saved) end)
	check("and one put back on the Mana bar afterward stays there", TotemAnchor(saved).barKey == "primary")
	saved = SavedWith(TRB.Functions.Table:DeepCopy(Settings:DefaultCustomBarDimensions(true).anchor), nil)
	try("MigrateTotemBarAnchors", function() Settings:MigrateTotemBarAnchors(saved) end)
	check("the old Classic default spot moves too", TotemAnchor(saved).barKey == "secondary")
	local moved = TRB.Functions.Table:DeepCopy(oldDefault)
	moved.yOffset = 12
	saved = SavedWith(moved, nil)
	try("MigrateTotemBarAnchors", function() Settings:MigrateTotemBarAnchors(saved) end)
	check("a Totems bar the user moved stays put", TotemAnchor(saved).barKey == "primary" and TotemAnchor(saved).yOffset == 12)
	saved = SavedWith(TRB.Functions.Table:DeepCopy(oldDefault), { totemBarAnchor = true })
	try("MigrateTotemBarAnchors", function() Settings:MigrateTotemBarAnchors(saved) end)
	check("a spec that already ran the step, or started with it, is left alone", TotemAnchor(saved).barKey == "primary")
	saved = { shaman = { general = { bars = { totems = { anchor = TRB.Functions.Table:DeepCopy(oldDefault) } } } } }
	try("MigrateTotemBarAnchors", function() Settings:MigrateTotemBarAnchors(saved) end)
	check("a spec piece with no bar text is left for the defaults", TotemAnchor(saved).barKey == "primary")
	check("new settings start with the step done", shamanSettings.displayText.migrations ~= nil and shamanSettings.displayText.migrations.totemBarAnchor == true)

	-- A shield with 100 seconds left, for the expiry below.
	buff:InitializeCustom(SHIELD.duration, drv.now - SHIELD.duration + 100, true, SHIELD.orbs)

	Wait(100)
	check("the shield ends when its time runs out", Draw() == 0 and not buff.isActive and not Class:IsValidVariableForSpec("$shieldTime"))
	Cast(SHIELD.first)
	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears the orbs", not buff.isActive)

	TRB.Functions.BarVisibility.AddEntry = addEntry
	Bar.SetBarNodeValue = setValue
	TRB.Functions.AudioCues.UpdateCounter = updateCounter
	return errors
end

return hooks
