-- Checks the Forever Priest's Dark Inspiration: its talent gate, Mind Blast and full Mind Flay channels, the aura sync,
-- bar text, and its Color Indicator, which starts deleted.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
local DARK_INSPIRATION, DARK_INSPIRATION_AURA = 1326159, 1326168
local MIND_BLAST_RANK_1, MIND_BLAST_RANK_9 = 8092, 10947
local MIND_FLAY_RANK_1, MIND_FLAY_RANK_6 = 15407, 18807
local PENANCE, OTHER_SPELL = 402174, 2052
local COLOR = "FF8A2BE2"

-- The test clock, the frames the addon made, the border colors a draw painted, the auras, and the channel in progress.
local drv = { now = 1000, frames = {}, borders = {}, auras = {}, inCombat = false, channel = nil }

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
	G.C_UnitAuras.GetPlayerAuraBySpellID = function(spellId) return drv.auras[spellId] end
	G.issecrettable = function(t) return type(t) == "table" and rawget(t, "secret") == true end
	G.C_Secrets = { ShouldAurasBeSecret = function() return false end }
	G.InCombatLockdown = function() return drv.inCombat end
	-- The channel in progress: its spell ID and end time in milliseconds, either of which can be "secret".
	G.UnitChannelInfo = function(unit)
		local channel = drv.channel
		if unit ~= "player" or channel == nil then
			return nil
		end
		return "Channel", "", 0, channel.startMS, channel.endMS, false, false, channel.spellId
	end
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

	if TRB.Flavor.id ~= "forever" or ctx.classId ~= 5 then
		check("only a Forever Priest offers Dark Inspiration bar text", not Offers("$darkInspirationTime"))
		return errors
	end

	local runtime = TRB.Forever.Runtime
	local snapshot = TRB.Data.snapshotData.snapshots[DARK_INSPIRATION]
	local buff = snapshot ~= nil and snapshot.buff or nil
	check("Dark Inspiration has a snapshot", buff ~= nil)
	check("the bar text offers $darkInspirationTime and #darkInspiration", Offers("$darkInspirationTime") and TRB.Data.lookup["#darkInspiration"] ~= nil)
	local talents = runtime.talents
	check("the runtime has talents", talents ~= nil)
	if buff == nil or talents == nil then
		return errors
	end

	---Runs the handlers Priest.lua and its aura sync registered for an event.
	local function Fire(event, ...)
		local args = { ... }
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			local source = fn ~= nil and debug.getinfo(fn, "S").source or ""
			if fn ~= nil and events ~= nil and events[event] and (source:find("Priest%.lua$") or source:find("Snapshot%.lua$")) then
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
	end
	local function Cast(spellId)
		try("SpellCast", function() TRB.Functions.Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Cast-0") end)
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
	local function Learn(learned)
		talents.talents[DARK_INSPIRATION] = learned and TRB.Classes.Talent:New(DARK_INSPIRATION, 5, 5) or nil
	end
	local Class = TRB.Functions.Class

	-- Mind Blast: any rank starts or refreshes the 10 seconds, only with the talent.
	check("before a cast nothing is tracked", not buff.isActive and not Class:HasActiveTimers() and not Class:IsValidVariableForSpec("$darkInspirationTime"))
	Learn(false)
	Cast(MIND_BLAST_RANK_9)
	check("without the talent, Mind Blast starts nothing", not buff.isActive)
	Learn(true)
	Cast(OTHER_SPELL)
	Cast(MIND_FLAY_RANK_1)
	check("another spell, or Mind Flay's cast, starts nothing", not buff.isActive)
	Cast(MIND_BLAST_RANK_9)
	check("with it, a rank 9 Mind Blast tracks Dark Inspiration for 10 seconds", buff.isActive and buff.remaining == 10)
	check("and makes its timer and bare check live", Class:HasActiveTimers() and Class:IsValidVariableForSpec("$darkInspirationTime"))
	local lookup, lookupLogic = Lookup()
	check("the bar text shows its 10 seconds", lookupLogic["$darkInspirationTime"] == 10 and lookup["$darkInspirationTime"] ~= nil)
	Tick(4)
	lookup, lookupLogic = Lookup()
	check("its time counts down", buff.remaining == 6 and lookupLogic["$darkInspirationTime"] == 6)
	Cast(MIND_BLAST_RANK_1)
	check("recasting any rank refreshes it to 10 seconds", buff.remaining == 10)
	Tick(10)
	check("it ends when its 10 seconds run out", not buff.isActive and not Class:HasActiveTimers() and not Class:IsValidVariableForSpec("$darkInspirationTime"))
	lookup, lookupLogic = Lookup()
	check("and its bar text drops to 0", lookupLogic["$darkInspirationTime"] == 0)
	Cast(MIND_BLAST_RANK_9)
	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears it", not buff.isActive)

	-- Mind Flay: only a channel that runs to its end counts, read from the channel's own timing.
	TRB.Data.character.latency = 0.1
	---Starts a channel lasting `duration` seconds; the event's spell ID and the channel's end time can be secret.
	local function StartChannel(spellId, duration, eventSpellId, endSecret)
		drv.channel = { spellId = spellId, startMS = drv.now * 1000, endMS = endSecret and "secret" or (drv.now + duration) * 1000 }
		Fire("UNIT_SPELLCAST_CHANNEL_START", "player", "Cast-1", eventSpellId or spellId)
	end
	local function UpdateChannel(remaining)
		drv.channel.endMS = (drv.now + remaining) * 1000
		Fire("UNIT_SPELLCAST_CHANNEL_UPDATE", "player", "Cast-1", drv.channel.spellId)
	end
	local function StopChannel(after)
		drv.now = drv.now + after
		local spellId = drv.channel ~= nil and drv.channel.spellId or nil
		drv.channel = nil
		Fire("UNIT_SPELLCAST_CHANNEL_STOP", "player", "Cast-1", spellId)
	end

	StartChannel(MIND_FLAY_RANK_1, 3)
	StopChannel(3)
	check("a fully channeled Mind Flay tracks it for 10 seconds", buff.isActive and buff.remaining == 10)
	buff:Reset()
	StartChannel(MIND_FLAY_RANK_6, 3)
	StopChannel(2.75)
	check("so does one stopped within latency and 0.2 seconds of its end, at any rank", buff.isActive)
	buff:Reset()
	StartChannel(MIND_FLAY_RANK_1, 3)
	StopChannel(2.65)
	check("one stopped earlier than that starts nothing", not buff.isActive)
	StartChannel(MIND_FLAY_RANK_1, 3)
	StopChannel(1.5)
	check("nor does one cut short", not buff.isActive)
	StartChannel(MIND_FLAY_RANK_1, 3)
	drv.now = drv.now + 1
	StartChannel(MIND_FLAY_RANK_1, 3)
	StopChannel(3)
	check("a recast mid-channel counts once its own channel finishes", buff.isActive)
	buff:Reset()
	StartChannel(MIND_FLAY_RANK_1, 3)
	drv.now = drv.now + 1
	StartChannel(PENANCE, 2)
	StopChannel(2)
	check("another channel started over Mind Flay starts nothing", not buff.isActive)
	StartChannel(MIND_FLAY_RANK_1, 3)
	drv.now = drv.now + 1
	UpdateChannel(1)
	StopChannel(1)
	check("a channel whose end moves earlier counts at its new end", buff.isActive)
	buff:Reset()
	StartChannel(MIND_FLAY_RANK_1, 3)
	drv.now = drv.now + 1
	UpdateChannel(3)
	StopChannel(2)
	check("and one whose end moves later doesn't count at its old end", not buff.isActive)
	StartChannel(MIND_FLAY_RANK_1, 3, "secret")
	StopChannel(3)
	check("a secret event spell ID falls back to the channel's own", buff.isActive)
	buff:Reset()
	StartChannel(MIND_FLAY_RANK_1, 3, nil, true)
	StopChannel(3)
	check("a channel with secret timing starts nothing", not buff.isActive)
	Learn(false)
	StartChannel(MIND_FLAY_RANK_1, 3)
	StopChannel(3)
	check("without the talent, a full channel starts nothing", not buff.isActive)
	Learn(true)

	-- The aura sync: leaving combat and a loading screen copy the aura's time, read only out of combat.
	Cast(MIND_BLAST_RANK_9)
	Tick(2)
	drv.auras = { [DARK_INSPIRATION_AURA] = { applications = 0, expirationTime = drv.now + 5, duration = 10 } }
	Fire("PLAYER_REGEN_ENABLED")
	check("leaving combat corrects its time from the aura", buff.isActive and buff.remaining == 5)
	drv.auras = {}
	drv.inCombat = true
	Fire("PLAYER_REGEN_ENABLED")
	drv.inCombat = false
	check("but not in combat lockdown", buff.isActive)
	Fire("PLAYER_REGEN_ENABLED")
	check("and with no aura up, tracking ends", not buff.isActive)
	drv.auras = { [DARK_INSPIRATION_AURA] = { applications = 0, expirationTime = drv.now + 7, duration = 10 } }
	Fire("PLAYER_ENTERING_WORLD")
	check("a loading screen copies it from its aura", buff.isActive and buff.remaining == 7)
	buff:Reset()
	drv.auras = {}

	-- The Color Indicator: deleted by default, so it paints only once added back to the list.
	local shared = TRB.Data.settings.priest.general.colors.shared
	local indicator = shared.indicatorColors.darkInspiration
	local function Listed()
		for _, key in ipairs(shared.nodeOrder) do
			if key == "darkInspiration" then
				return true
			end
		end
		return false
	end
	check("the Dark Inspiration Color Indicator starts deleted, off, and in its color", not Listed() and shared.removed ~= nil
		and shared.removed.darkInspiration == true and indicator ~= nil and indicator.enabled == false and indicator.color == COLOR)
	if indicator == nil then
		return errors
	end
	-- The login's render transition runs on the stubs' wall clock and would skip the draws.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	---Whether the real update painted the Dark Inspiration color on a border.
	local function Draw()
		wipe(drv.borders)
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() triggerUpdates() end)
		return drv.borders[COLOR] == true
	end
	indicator.enabled = true
	indicator.targets = { resourceBar = { bar = false, border = true, background = false } }
	Cast(MIND_BLAST_RANK_9)
	check("unlisted, it paints nothing while Dark Inspiration is up", buff.isActive and not Draw())
	table.insert(shared.nodeOrder, "darkInspiration")
	shared.removed.darkInspiration = false
	check("listed on the mana bar border, it paints while Dark Inspiration is up", Draw())
	Tick(10)
	check("and stops when its time runs out", not buff.isActive and not Draw())
	table.remove(shared.nodeOrder, #shared.nodeOrder)
	shared.removed.darkInspiration = true
	indicator.enabled = false
	indicator.targets = {}

	return errors
end

return hooks
