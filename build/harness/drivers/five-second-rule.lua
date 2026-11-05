-- Checks the Five Second Rule bar: only mana classes on flavors with the rule get it, a cast of a spell that costs
-- mana starts the pause, and Show Below holds the bar back until the window opens.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

-- Classes without mana on the Classic-family flavors: Warrior and Rogue.
local NO_MANA_CLASSES = { [1] = true, [4] = true }

local hooks = {}
-- Spells by what they cost: mana, nothing, rage, and a mana cost the client hides.
local MANA_SPELL, FREE_SPELL, RAGE_SPELL, SECRET_SPELL = 2052, 6603, 78, 9999

-- The test clock and the frames the addon made.
local drv = { now = 1000, frames = {} }

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
	G.C_Spell.GetSpellPowerCost = function(spellId)
		if spellId == MANA_SPELL then
			return { { type = G.Enum.PowerType.Mana, name = "MANA", cost = 45, minCost = 45 } }
		elseif spellId == RAGE_SPELL then
			return { { type = G.Enum.PowerType.Rage, name = "RAGE", cost = 15, minCost = 15 } }
		elseif spellId == SECRET_SPELL then
			return { { type = G.Enum.PowerType.Mana, name = "MANA", cost = "secret", minCost = 0 } }
		end
		return {}
	end
	local innerIsSecret = G.issecretvalue
	G.issecretvalue = function(v)
		if v == "secret" then
			return true
		end
		return innerIsSecret ~= nil and innerIsSecret(v) or false
	end
end

function hooks.afterLoad(ctx)
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local OtherBars = TRB.Functions.OtherBars
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
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	for i = 1, 20 do
		local _, timerFailures = stubs.fireEvents("TRB_DRAIN_SETUP_" .. i, ctx.addonName)
		if timerFailures == 0 then
			break
		end
	end
	check("the deferred setup finishes", TRB.Details.addonData.optionsPanelFinished == true)

	local settings = TRB.Functions.Class:GetActiveDisplaySettings()
	if settings == nil then
		check("the active spec has settings", false)
		return errors
	end
	local core = TRB.Data.settings.core
	if TRB.Flavor.fiveSecondRule == nil then
		check("a flavor without the rule has no Five Second Rule bar", settings.displayBar.fiveSecondRule == nil and core.bars.fiveSecondRule == nil)
		return errors
	end
	check("Global Options has the Five Second Rule bar", core.bars.fiveSecondRule ~= nil and core.displayBar.fiveSecondRule ~= nil)
	if NO_MANA_CLASSES[ctx.classId] then
		check("a class without mana has no Five Second Rule bar", settings.bars.fiveSecondRule == nil and settings.displayBar.fiveSecondRule == nil)
		return errors
	end
	local barSettings = settings.bars.fiveSecondRule
	local visibility = settings.displayBar.fiveSecondRule
	check("a mana class has the Five Second Rule bar", barSettings ~= nil and visibility ~= nil)
	if barSettings == nil or visibility == nil then
		return errors
	end
	check("it anchors inside the Mana bar's bottom edge", barSettings.anchor.barKey == "primary" and barSettings.anchor.anchorPoint == "BOTTOM"
		and barSettings.anchor.attachPoint == "BOTTOM" and barSettings.anchor.matchWidth == true and barSettings.insideAnchorBorder == true and barSettings.border == 0)
	check("it starts Never Show", visibility.neverShow == true)

	---Whether any of OtherBars.lua's frames is registered for an event.
	local function Registered(event)
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("OtherBars%.lua$") then
				return true
			end
		end
		return false
	end
	---Fires an event at every OtherBars.lua frame registered for it.
	local function Fire(event, ...)
		local args = { ... }
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("OtherBars%.lua$") then
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
	end
	---Runs OtherBars.lua's per-frame updater once, on a throttle tick.
	local function Tick()
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local fn = scripts ~= nil and scripts.OnUpdate or nil
			if fn ~= nil and debug.getinfo(fn, "S").source:find("OtherBars%.lua$") then
				try("OnUpdate", function() fn(frame, 0.06) end)
			end
		end
	end
	local function Cast(spellId)
		Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-0", spellId or MANA_SPELL)
	end
	local function Remaining()
		return (OtherBars:GetTimerValues("fiveSecondRule"))
	end
	local function Near(a, b)
		return a ~= nil and math.abs(a - b) < 0.0001
	end
	local function Expire()
		drv.now = drv.now + 10
		Tick()
	end

	try("SyncEnabledState", function() OtherBars:SyncEnabledState() end)
	check("a Never Show bar registers nothing", not Registered("UNIT_SPELLCAST_SUCCEEDED"))
	visibility.neverShow = false
	try("SyncEnabledState", function() OtherBars:SyncEnabledState() end)
	check("enabling it registers the cast events, and not mana", Registered("UNIT_SPELLCAST_SUCCEEDED") and Registered("UNIT_SPELLCAST_CHANNEL_START") and not Registered("UNIT_POWER_FREQUENT"))

	Cast()
	check("a spell that costs mana starts the pause", OtherBars:IsFiveSecondRuleRunning() and OtherBars:IsBarActive("fiveSecondRule") and Near(Remaining(), 5))
	drv.now = drv.now + 2
	Tick()
	check("it counts down", Near(Remaining(), 3) and OtherBars:IsBarActive("fiveSecondRule"))
	drv.now = drv.now + 3.01
	Tick()
	check("and ends after five seconds", not OtherBars:IsFiveSecondRuleRunning() and not OtherBars:IsBarActive("fiveSecondRule") and Remaining() == nil)

	Fire("UNIT_SPELLCAST_CHANNEL_START", "player", "Cast-0", MANA_SPELL)
	check("a channel that costs mana starts it too", OtherBars:IsFiveSecondRuleRunning() and Near(Remaining(), 5))
	drv.now = drv.now + 1
	Cast()
	check("a second spend restarts it", Near(Remaining(), 5))
	Expire()

	Cast(FREE_SPELL)
	check("a spell that costs nothing starts nothing", not OtherBars:IsFiveSecondRuleRunning())
	Cast(RAGE_SPELL)
	check("a spell that costs rage starts nothing", not OtherBars:IsFiveSecondRuleRunning())
	Cast(SECRET_SPELL)
	check("a secret mana cost starts nothing", not OtherBars:IsFiveSecondRuleRunning())

	barSettings.showBelow.enabled = true
	barSettings.showBelow.mode = "time"
	barSettings.showBelow.timeMax = 3
	drv.now = drv.now + 1
	Cast()
	check("with Show Below, the pause runs but the bar waits", OtherBars:IsFiveSecondRuleRunning() and not OtherBars:IsBarActive("fiveSecondRule") and Near(Remaining(), 5))
	drv.now = drv.now + 1.9
	Tick()
	check("still outside the window", not OtherBars:IsBarActive("fiveSecondRule"))
	drv.now = drv.now + 0.2
	Tick()
	check("the bar starts once three seconds are left", OtherBars:IsBarActive("fiveSecondRule"))
	Cast()
	check("a fresh spend takes it back down until the window opens again", not OtherBars:IsBarActive("fiveSecondRule") and Near(Remaining(), 5))
	Expire()

	barSettings.showBelow.mode = "gcd"
	barSettings.showBelow.gcdsMax = 2
	local gcd = TRB.Functions.Character:GetCurrentGCDTime()
	Cast()
	drv.now = drv.now + (5 - (2 * gcd)) - 0.1
	Tick()
	check("in GCD mode it waits for two GCDs left", not OtherBars:IsBarActive("fiveSecondRule"))
	drv.now = drv.now + 0.2
	Tick()
	check("and starts inside them", OtherBars:IsBarActive("fiveSecondRule"))
	Expire()
	barSettings.showBelow.enabled = false

	visibility.neverShow = true
	try("SyncEnabledState", function() OtherBars:SyncEnabledState() end)
	check("Never Show again drops the events", not Registered("UNIT_SPELLCAST_SUCCEEDED"))

	return errors
end

return hooks
