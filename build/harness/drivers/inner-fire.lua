-- Checks Inner Fire's charges, timer, bar text, and Color Indicator: on Forever from casts, UNIT_COMBAT hits, and the aura sync,
-- with /trb innerfire; on Classic and TBC from the aura through UNIT_AURA.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
local INNER_FIRE_RANK_1, INNER_FIRE_RANK_6, IMPROVED_INNER_FIRE, OTHER_SPELL = 588, 10952, 14747, 2052

-- The test clock, the frames the addon made, the border colors a draw painted, the combat text unit, and the auras.
local drv = { now = 1000, frames = {}, printed = {}, borders = {}, combatTextUnit = nil, auras = {}, aurasSecret = false, inCombat = false }

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
	-- Floating combat text off: Blizzard never loaded its combat text, so no unit is set.
	G.C_CombatText = {
		GetActiveUnit = function() return drv.combatTextUnit end,
		SetActiveUnit = function(unit) drv.combatTextUnit = unit end,
	}
	-- Player auras by spell ID; an aura table with `secret = true` stands in for a secret table.
	G.C_UnitAuras.GetPlayerAuraBySpellID = function(spellId) return drv.auras[spellId] end
	G.issecrettable = function(t) return type(t) == "table" and rawget(t, "secret") == true end
	G.C_Secrets = { ShouldAurasBeSecret = function() return drv.aurasSecret end }
	G.InCombatLockdown = function() return drv.inCombat end
end

function hooks.afterLoad(ctx)
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	ctx.TRB.Functions.News.Init = function() end
	local BarNode = ctx.TRB.Classes.BarNode
	local setBorder = BarNode.SetBorderColor
	BarNode.SetBorderColor = function(self, color, ...)
		if color ~= nil then drv.borders[color] = true end
		return setBorder(self, color, ...)
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
	-- Only the indicator checks draw, through the real update.
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

	---Whether the spec's bar text variable list offers a variable.
	local function Offers(variable)
		for _, entry in ipairs(TRB.Data.barTextVariables.values or {}) do
			if entry.variable == variable then
				return true
			end
		end
		return false
	end

	local flavorTable = ({ forever = TRB.Forever, classic = TRB.Classic, tbc = TRB.TBC })[TRB.Flavor.id]
	if flavorTable == nil or ctx.classId ~= 5 then
		check("only a Forever, Classic, or TBC Priest offers Inner Fire bar text", not Offers("$innerFireStacks"))
		return errors
	end

	local runtime = flavorTable.Runtime
	local snapshot = TRB.Data.snapshotData.snapshots[INNER_FIRE_RANK_1]
	local buff = snapshot ~= nil and snapshot.buff or nil
	check("Inner Fire has a snapshot", buff ~= nil)
	check("the bar text offers $innerFireStacks, $innerFireStacksMax, $innerFireTime, and #innerFire",
		Offers("$innerFireStacks") and Offers("$innerFireStacksMax") and Offers("$innerFireTime") and TRB.Data.lookup["#innerFire"] ~= nil)
	if buff == nil then
		return errors
	end

	---Runs every Priest.lua frame's handler for an event, then the timers it queued.
	local function Fire(event, ...)
		local args = { ... }
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("Priest%.lua$") then
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
	end
	local function Drain()
		stubs.fireEvents("TRB_DRAIN", ctx.addonName)
	end
	local function Cast(spellId)
		try("SpellCast", function() TRB.Functions.Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Cast-0") end)
	end
	local PHYSICAL, HOLY, FIRE = 1, 2, 4
	---A UNIT_COMBAT event on the player, its amount secret as in combat; a landed physical hit with no arguments.
	local function Hit(action, schoolMask, flagText)
		Fire("UNIT_COMBAT", "player", action or "WOUND", flagText or "", "secret", schoolMask or PHYSICAL)
	end
	---A combat text event, which only the diagnostic listens to.
	local function CombatText(combatTextType)
		Fire("COMBAT_TEXT_UPDATE", combatTextType)
	end
	local function Tick(seconds)
		drv.now = drv.now + seconds
		try("UpdateClassSnapshot", function() runtime.UpdateClassSnapshot(drv.now) end)
	end
	local function Lookup()
		TRB.Data.activeVariables = nil
		try("RefreshLookupData", function() TRB.Functions.RefreshLookupData() end)
		return TRB.Data.lookup, TRB.Data.lookupLogic
	end
	local Class = TRB.Functions.Class

	-- The Inner Fire Color Indicator: listed with no targets, then painted by the real update from the tracked buff.
	local INNER_FIRE_COLOR = "FFFF8000"
	local shared = TRB.Data.settings.priest.general.colors.shared
	local indicator = shared.indicatorColors.innerFire
	local listed, targeted = false, false
	for _, key in ipairs(shared.nodeOrder) do
		listed = listed or key == "innerFire"
	end
	for _, elements in pairs(indicator ~= nil and indicator.targets or {}) do
		for _, isTargeted in pairs(elements) do
			targeted = targeted or isTargeted == true
		end
	end
	check("the Inner Fire Color Indicator is listed by default, with no targets", listed and indicator ~= nil and indicator.color == INNER_FIRE_COLOR and not targeted)
	-- The login's render transition runs on the stubs' wall clock and would skip the draws.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	---Whether the real update painted the Inner Fire color on a border.
	local function Draw()
		wipe(drv.borders)
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() triggerUpdates() end)
		return drv.borders[INNER_FIRE_COLOR] == true
	end

	if TRB.Flavor.id ~= "forever" then
		-- Classic and TBC: auras are never secret, so the charges and time are the aura's own.
		local RANK_TOP = TRB.Flavor.id == "tbc" and 25431 or INNER_FIRE_RANK_6
		local auraReads = 0
		local readAura = desktop.C_UnitAuras.GetPlayerAuraBySpellID
		desktop.C_UnitAuras.GetPlayerAuraBySpellID = function(spellId)
			auraReads = auraReads + 1
			return readAura(spellId)
		end
		local function Aura(spellId, applications, remaining, instanceId)
			drv.auras = { [spellId] = { spellId = spellId, auraInstanceID = instanceId, applications = applications, expirationTime = drv.now + remaining, duration = 600 } }
			return drv.auras[spellId]
		end
		local function UnitAura(info)
			Fire("UNIT_AURA", "player", info)
		end

		check("before its aura nothing is tracked", not buff.isActive and not Class:HasActiveTimers()
			and not Class:IsValidVariableForSpec("$innerFireStacks") and not Class:IsValidVariableForSpec("$innerFireTime")
			and Class:IsValidVariableForSpec("$innerFireStacksMax"))
		Cast(RANK_TOP)
		check("a cast alone tracks nothing", not buff.isActive)
		local gained = Aura(RANK_TOP, 20, 600, 101)
		UnitAura({ addedAuras = { gained } })
		check("a gained aura reads after a short delay", not buff.isActive)
		Drain()
		check("then tracks its 20 charges and 10 minutes", buff.isActive and buff.applications == 20 and buff.remaining == 600)
		check("and makes its timer and bare checks live", Class:HasActiveTimers() and Class:IsValidVariableForSpec("$innerFireStacks")
			and Class:IsValidVariableForSpec("$innerFireTime"))

		drv.auras[RANK_TOP].applications = 19
		UnitAura({ updatedAuraInstanceIDs = { 101 } })
		Drain()
		check("a charge the aura loses comes off", buff.applications == 19)
		drv.auras[RANK_TOP].applications = 18
		UnitAura({ updatedAuraInstanceIDs = { 555 }, addedAuras = { { spellId = OTHER_SPELL, auraInstanceID = 556 } } })
		Hit()
		Drain()
		check("other auras and hits taken read nothing", buff.applications == 19)
		auraReads = 0
		UnitAura({ updatedAuraInstanceIDs = { 101 } })
		Drain()
		local oneRead = auraReads
		auraReads = 0
		UnitAura({ updatedAuraInstanceIDs = { 101 } })
		UnitAura({ updatedAuraInstanceIDs = { 101 }, removedAuraInstanceIDs = { 556 } })
		Drain()
		check("a burst of updates reads once", oneRead > 0 and auraReads == oneRead and buff.applications == 18)

		local lookup, lookupLogic = Lookup()
		check("the bar text shows 18 of 20 charges", lookup["$innerFireStacks"] == "18" and lookup["$innerFireStacksMax"] == "20"
			and lookupLogic["$innerFireStacks"] == 18 and lookupLogic["$innerFireStacksMax"] == 20)
		Tick(100)
		lookup, lookupLogic = Lookup()
		check("its time counts down", buff.remaining == 500 and lookupLogic["$innerFireTime"] == 500 and lookup["$innerFireTime"] ~= nil)

		drv.auras = {}
		UnitAura({ removedAuraInstanceIDs = { 101 } })
		Drain()
		check("losing the aura ends it", not buff.isActive and not Class:HasActiveTimers())
		lookup, lookupLogic = Lookup()
		check("and its bar text drops to 0", lookup["$innerFireStacks"] == "0" and lookupLogic["$innerFireTime"] == 0)

		Aura(INNER_FIRE_RANK_1, 7, 300, 102)
		UnitAura({ isFullUpdate = true })
		Drain()
		check("a full update reads any rank's aura", buff.isActive and buff.applications == 7 and buff.remaining == 300)
		drv.auras = {}
		UnitAura({ updatedAuraInstanceIDs = { 102 } })
		Drain()
		check("a read that misses the aura ends tracking", not buff.isActive)
		Aura(INNER_FIRE_RANK_1, 6, 290, 102)
		UnitAura({ updatedAuraInstanceIDs = { 102 } })
		Drain()
		check("but the aura's next update still reads it", buff.isActive and buff.applications == 6)
		Tick(290)
		check("it ends when its time runs out", not buff.isActive)

		buff:Reset()
		Aura(RANK_TOP, 12, 300, 103)
		Fire("PLAYER_ENTERING_WORLD")
		check("a loading screen reads the aura", buff.isActive and buff.applications == 12 and buff.remaining == 300)
		buff:Reset()
		local spellsData = TRB.Data.spellsData
		TRB.Data.spellsData = nil
		Fire("PLAYER_ENTERING_WORLD")
		TRB.Data.spellsData = spellsData
		check("before the spell set loads, nothing reads", not buff.isActive)
		try("CheckCharacter", function() Class:CheckCharacter() end)
		check("and the next CheckCharacter reads it, as on login and reload", buff.isActive and buff.applications == 12)
		buff:Reset()
		try("CheckCharacter", function() Class:CheckCharacter() end)
		check("only once", not buff.isActive)

		if indicator ~= nil then
			check("untargeted, it paints nothing", not Draw())
			indicator.targets = { resourceBar = { bar = false, border = true, background = false } }
			UnitAura({ isFullUpdate = true })
			Drain()
			check("on the mana bar border, it paints while Inner Fire is up", buff.isActive and Draw())
			drv.auras = {}
			UnitAura({ removedAuraInstanceIDs = { 103 } })
			Drain()
			check("and stops once its aura is gone", not buff.isActive and not Draw())
			indicator.modifiers = { notActive = true }
			check("Not Active paints it while Inner Fire is down", Draw())
			indicator.modifiers = nil
			indicator.targets = {}
		end

		local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
		check("there is no /trb innerfire", descriptor == nil or descriptor.slashCommands == nil or descriptor.slashCommands.innerfire == nil)
		return errors
	end

	check("before a cast nothing is tracked", not buff.isActive and not Class:HasActiveTimers()
		and not Class:IsValidVariableForSpec("$innerFireStacks") and not Class:IsValidVariableForSpec("$innerFireTime")
		and Class:IsValidVariableForSpec("$innerFireStacksMax"))
	Hit()
	check("a hit with no Inner Fire up changes nothing", not buff.isActive)

	Cast(OTHER_SPELL)
	check("another spell starts nothing", not buff.isActive)
	Cast(INNER_FIRE_RANK_6)
	check("a rank 6 cast tracks 20 charges for 10 minutes", buff.isActive and buff.applications == 20 and buff.remaining == 600)
	check("and makes its timer and bare checks live", Class:HasActiveTimers() and Class:IsValidVariableForSpec("$innerFireStacks")
		and Class:IsValidVariableForSpec("$innerFireTime"))

	Hit()
	Hit("WOUND", PHYSICAL, "CRITICAL")
	check("a landed physical hit and crit spend a charge each", buff.applications == 18)
	Hit("WOUND", PHYSICAL, "ABSORB")
	Hit("WOUND", PHYSICAL, "BLOCK")
	Hit("WOUND", PHYSICAL, "RESIST")
	Hit("WOUND", FIRE)
	Hit("MISS")
	Hit("DODGE")
	Hit("PARRY")
	Hit("HEAL", HOLY)
	Fire("UNIT_COMBAT", "player", "secret", "secret", "secret", "secret")
	check("fully absorbed, blocked, or resisted, magic, avoided, healing, and secret hits spend nothing", buff.applications == 18)
	CombatText("DAMAGE")
	check("combat text alone spends nothing", buff.applications == 18)
	-- From a 20-charge fight in game: a partial absorb and a thrown hit land as plain physical WOUNDs, and each took a charge.
	CombatText("ABSORB")
	Hit()
	CombatText("SPELL_DAMAGE")
	Hit()
	check("so do a partly absorbed swing and a thrown hit", buff.applications == 16)
	check("tracking leaves combat text alone", drv.combatTextUnit == nil)

	local lookup, lookupLogic = Lookup()
	check("the bar text shows 16 of 20 charges", lookup["$innerFireStacks"] == "16" and lookup["$innerFireStacksMax"] == "20"
		and lookupLogic["$innerFireStacks"] == 16 and lookupLogic["$innerFireStacksMax"] == 20)
	Tick(100)
	lookup, lookupLogic = Lookup()
	check("its time counts down", buff.remaining == 500 and lookupLogic["$innerFireTime"] == 500 and lookup["$innerFireTime"] ~= nil)

	Cast(INNER_FIRE_RANK_1)
	check("recasting any rank restarts it at full charges and time", buff.applications == 20 and buff.remaining == 600)
	Tick(600)
	check("it ends when the 10 minutes run out", not buff.isActive and not Class:HasActiveTimers() and not Class:IsValidVariableForSpec("$innerFireTime"))
	lookup, lookupLogic = Lookup()
	check("and its bar text drops to 0", lookup["$innerFireStacks"] == "0" and lookupLogic["$innerFireTime"] == 0)

	Cast(INNER_FIRE_RANK_6)
	for _ = 1, 20 do
		Hit()
	end
	check("it ends when the last charge is spent", not buff.isActive and buff.applications == 0)
	Hit()
	check("and a later hit does nothing", not buff.isActive)

	Cast(INNER_FIRE_RANK_6)
	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears it", not buff.isActive)

	local talents = runtime.talents
	check("the runtime has talents", talents ~= nil)
	if talents ~= nil then
		talents.talents[IMPROVED_INNER_FIRE] = TRB.Classes.Talent:New(IMPROVED_INNER_FIRE, 2, 3)
		Cast(INNER_FIRE_RANK_6)
		check("Improved Inner Fire rank 2 casts with 28 charges", buff.applications == 28)
		lookup = Lookup()
		check("and raises $innerFireStacksMax to 28", lookup["$innerFireStacksMax"] == "28")
		talents.talents[IMPROVED_INNER_FIRE] = nil
		try("CheckCharacter", function() Class:CheckCharacter() end)
		lookup = Lookup()
		check("dropping the talent puts the maximum back to 20", lookup["$innerFireStacksMax"] == "20")
	end

	if indicator ~= nil then
		check("untargeted, it paints nothing", not Draw())
		indicator.targets = { resourceBar = { bar = false, border = true, background = false } }
		check("on the mana bar border, it paints while Inner Fire is up", Draw())
		for _ = 1, 28 do
			Hit()
		end
		check("and stops once its charges are spent", not buff.isActive and not Draw())
		indicator.modifiers = { notActive = true }
		check("Not Active paints it while Inner Fire is down", Draw())
		Cast(INNER_FIRE_RANK_6)
		check("and not once it is cast", not Draw())
		Tick(600)
		check("and again when its 10 minutes run out", Draw())
		indicator.modifiers = nil
		indicator.targets = {}
	end

	-- The aura sync: a loading screen and leaving combat copy the real charges and time, read only when auras aren't restricted.
	check("with no aura at login, nothing is tracked", not buff.isActive)
	drv.auras[INNER_FIRE_RANK_6] = { applications = 12, expirationTime = drv.now + 300, duration = 600 }
	Fire("PLAYER_ENTERING_WORLD")
	check("a loading screen copies Inner Fire's charges and time from its aura", buff.isActive and buff.applications == 12 and buff.remaining == 300)
	buff:Reset()
	local spellsData = TRB.Data.spellsData
	TRB.Data.spellsData = nil
	Fire("PLAYER_ENTERING_WORLD")
	TRB.Data.spellsData = spellsData
	check("before the spell set loads, nothing syncs", not buff.isActive)
	try("CheckCharacter", function() Class:CheckCharacter() end)
	check("and the next CheckCharacter syncs it, as on login and reload", buff.isActive and buff.applications == 12)
	buff:Reset()
	try("CheckCharacter", function() Class:CheckCharacter() end)
	check("once per loading screen", not buff.isActive)

	Cast(INNER_FIRE_RANK_6)
	Hit()
	Hit()
	drv.auras[INNER_FIRE_RANK_6] = { applications = 17, expirationTime = drv.now + 550, duration = 600 }
	Fire("PLAYER_REGEN_ENABLED")
	check("leaving combat corrects the tracked charges and time from the aura", buff.applications == 17 and buff.remaining == 550)
	drv.auras[INNER_FIRE_RANK_6].applications = 9
	drv.inCombat = true
	Fire("PLAYER_REGEN_ENABLED")
	drv.inCombat = false
	drv.aurasSecret = true
	Fire("PLAYER_REGEN_ENABLED")
	drv.aurasSecret = false
	drv.auras[INNER_FIRE_RANK_6] = { secret = true }
	Fire("PLAYER_REGEN_ENABLED")
	drv.auras[INNER_FIRE_RANK_6] = { applications = "secret", expirationTime = drv.now + 500, duration = 600 }
	Fire("PLAYER_REGEN_ENABLED")
	check("but not in combat lockdown, while auras are restricted, or from a secret aura", buff.applications == 17 and buff.remaining == 550)
	drv.auras[INNER_FIRE_RANK_6] = { applications = 0, expirationTime = drv.now + 500, duration = 600 }
	Fire("PLAYER_REGEN_ENABLED")
	check("an aura with no count keeps the tracked charges", buff.applications == 17 and buff.remaining == 500)
	drv.auras = { [INNER_FIRE_RANK_1] = { applications = 5, expirationTime = drv.now + 100, duration = 600 } }
	Fire("PLAYER_REGEN_ENABLED")
	check("any rank's aura counts", buff.applications == 5 and buff.remaining == 100)
	drv.auras = {}
	Fire("PLAYER_REGEN_ENABLED")
	check("and with no rank's aura up, tracking ends", not buff.isActive)

	-- The diagnostic: one line per hit, joining the combat text type and the UNIT_COMBAT payload from the same frame.
	local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
	local command = descriptor ~= nil and descriptor.slashCommands ~= nil and descriptor.slashCommands.innerfire or nil
	check("/trb innerfire exists", command ~= nil)
	if command == nil then
		return errors
	end
	local innerPrint = desktop.print
	local function Capture(fn)
		drv.printed = {}
		desktop.print = function(...)
			local parts = {}
			for i = 1, select("#", ...) do
				parts[#parts + 1] = tostring((select(i, ...)))
			end
			drv.printed[#drv.printed + 1] = table.concat(parts, " ")
		end
		try("diagnostic", fn)
		desktop.print = innerPrint
		return drv.printed
	end
	local function AnyLine(lines, pattern)
		for _, line in ipairs(lines) do
			if line:find(pattern) then
				return true
			end
		end
		return false
	end

	local lines = Capture(function() command("now") end)
	check("an argument is rejected with the usage", AnyLine(lines, "Usage: /trb innerfire") and not AnyLine(lines, "diagnostic on"))
	drv.combatTextUnit = "vehicle"
	lines = Capture(function() command("") end)
	check("/trb innerfire leaves a combat text unit Blizzard set alone", AnyLine(lines, "combat text unit vehicle") and drv.combatTextUnit == "vehicle")
	Capture(function() command("") end)
	drv.combatTextUnit = nil
	lines = Capture(function() command("") end)
	check("/trb innerfire turns it on and points combat text at the player",
		AnyLine(lines, "diagnostic on. Floating combat text off, combat text unit player") and drv.combatTextUnit == "player")
	check("and the last sync", AnyLine(lines, "last sync leaving combat: no aura, tracking ended"))
	lines = Capture(function() Cast(INNER_FIRE_RANK_6) end)
	check("a cast prints its charges and time", AnyLine(lines, "cast 10952, tracking 20 charges for 600s"))
	lines = Capture(function()
		Hit("WOUND", PHYSICAL, "CRITICAL")
		CombatText("DAMAGE_CRIT")
		Drain()
	end)
	check("a hit prints one line with both events and the spent charge",
		AnyLine(lines, "text DAMAGE_CRIT | unit WOUND CRITICAL secret school 1 | tracked 20/20 %-> 19/20"))
	lines = Capture(function()
		CombatText("SPELL_DAMAGE")
		Hit()
		Drain()
	end)
	check("a thrown hit prints its combat text and spends a charge", AnyLine(lines, "text SPELL_DAMAGE | unit WOUND %- secret school 1 | tracked 19/20 %-> 18/20"))
	lines = Capture(function()
		Hit("WOUND", PHYSICAL, "ABSORB")
		Drain()
	end)
	check("a fully absorbed hit keeps its charge", AnyLine(lines, "text none | unit WOUND ABSORB secret school 1 | tracked 18/20 %-> 18/20"))
	lines = Capture(function()
		Hit("HEAL", HOLY)
		CombatText("HEAL")
		Drain()
	end)
	check("heals print nothing", not AnyLine(lines, "TRB Inner Fire"))
	lines = Capture(function()
		Fire("UNIT_COMBAT", "player", "secret", "secret", "secret", "secret")
		Drain()
	end)
	check("a secret payload prints as secret", AnyLine(lines, "text none | unit secret secret secret school secret"))
	drv.auras = { [INNER_FIRE_RANK_6] = { applications = 15, expirationTime = drv.now + 400, duration = 600 } }
	lines = Capture(function() Fire("PLAYER_REGEN_ENABLED") end)
	check("a sync prints what it found", AnyLine(lines, "sync on leaving combat: rank 10952 aura, 15 charges, 400s left | tracked 18/20 %-> 15/20"))
	lines = Capture(function() command("") end)
	check("/trb innerfire again turns it off", AnyLine(lines, "diagnostic off"))
	lines = Capture(function()
		Hit()
		Drain()
	end)
	check("and hits print nothing after", not AnyLine(lines, "TRB Inner Fire") and buff.applications == 14)

	return errors
end

return hooks
