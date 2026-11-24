-- Checks the Live Holy Priest's Prayer of Mending charges and Epiphany (#710): the hand count, its hasted recharge and
-- corrections, Epiphany's glow, refresh, and free cast, bar text, the audio cue, the Color Indicator, and /trb mending.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
local MENDING, EPIPHANY_BUFF, EPIPHANY_TALENT = 33076, 414556, 414553
local GUIDING_LIGHT, WASTE_NO_TIME, SERENITY, VOIDBINDING = 1248423, 440681, 2050, 462661
local COLOR = "FFFF8AD8"
local SECRET = setmetatable({}, { __tostring = function() return "SECRET" end })

-- The test clock, Prayer of Mending's charge read, the border colors a draw painted, and the sounds played.
local drv = { now = 1000, charges = nil, borders = {}, sounds = 0 }

function hooks.afterInstall(ctx)
	-- Holy for a Live Priest only: another class's second specialization may not finish its deferred setup in the stubs.
	local isLivePriest = ctx.classId == 5 and not ctx.tocRel:find("^Flavors/")
	parity.Install(ctx, { spec = isLivePriest and 2 or 1, holdDeferredSetup = true })
	local G = desktop
	G.GetTime = function() return drv.now end
	local innerIsSecret = G.issecretvalue
	G.issecretvalue = function(value)
		return value == SECRET or (innerIsSecret ~= nil and innerIsSecret(value)) or false
	end
	local getCharges = G.C_Spell.GetSpellCharges
	G.C_Spell.GetSpellCharges = function(id)
		if id == MENDING and drv.charges ~= nil then
			return drv.charges
		end
		return getCharges(id)
	end
	G.PlaySoundFile = function() drv.sounds = drv.sounds + 1 end
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
	-- Only the ticks and the indicator checks draw, through the real update.
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

	if TRB.Flavor.id ~= "mainline" or ctx.classId ~= 5 then
		check("only a Live Holy Priest offers Prayer of Mending bar text", not Offers("$pomCharges") and not Offers("$epiphanyTime"))
		return errors
	end

	local Class = TRB.Functions.Class
	local cache = TRB.Data.specCache.priest_holy
	local snapshotData = TRB.Data.snapshotData
	local snapshots = snapshotData.snapshots
	check("Prayer of Mending and Epiphany have snapshots", snapshots[MENDING] ~= nil and snapshots[EPIPHANY_BUFF] ~= nil)
	if snapshots[MENDING] == nil or snapshots[EPIPHANY_BUFF] == nil then
		return errors
	end
	local cooldown = snapshots[MENDING].cooldown
	local buff = snapshots[EPIPHANY_BUFF].buff
	check("the bar text offers the charge, time, and Epiphany variables and their icons", Offers("$pomCharges") and Offers("$pomMaxCharges")
		and Offers("$pomTime") and Offers("$pomFullTime") and Offers("$epiphany") and Offers("$epiphanyTime")
		and TRB.Data.lookup["#pom"] ~= nil and TRB.Data.lookup["#prayerOfMending"] ~= nil and TRB.Data.lookup["#epiphany"] ~= nil)

	-- The login's render transition runs on the stubs' wall clock and would skip the draws and silence the cue.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	local talents = cache.talents
	-- SwitchSpec re-reads the talents, which the stubs don't have.
	talents.GetTalents = function() end
	local function Learn(...)
		for _, id in ipairs({ ... }) do
			talents.talents[id] = TRB.Classes.Talent:New(id, 1, 1)
		end
	end
	local function Unlearn(...)
		for _, id in ipairs({ ... }) do
			talents.talents[id] = nil
		end
	end
	---A talent change, through the event and the spec switch it runs.
	local function Respec()
		stubs.fireEvents("TRAIT_CONFIG_UPDATED", ctx.addonName)
		for _ = 1, 5 do
			stubs.fireEvents("TRB_DRAIN", ctx.addonName)
		end
	end
	---The game's charge read: the count plain or secret, the maximum and the recharging flag always plain.
	local function Charges(current, max, recharging)
		drv.charges = { currentCharges = current, maxCharges = max, cooldownStartTime = 0, cooldownDuration = 0, chargeModRate = 1, isActive = recharging }
	end
	local function Fire(event, ...)
		local args = { ... }
		try(event, function() stubs.fireEventWith(event, unpack(args)) end)
	end
	local function Cast(spellId)
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Cast-0") end)
	end
	---Lets time pass, then runs the real update, which settles the timers.
	local function Tick(seconds)
		drv.now = drv.now + seconds
		wipe(drv.borders)
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("update", function() triggerUpdates() end)
	end
	local function Lookup()
		TRB.Data.activeVariables = nil
		try("RefreshLookupData", function() TRB.Functions.RefreshLookupData() end)
		return TRB.Data.lookup, TRB.Data.lookupLogic
	end
	local function Valid(variable)
		return Class:IsValidVariableForSpec(variable) == true
	end
	local function Near(value, expected)
		return type(value) == "number" and math.abs(value - expected) < 1e-6
	end
	local function SetGcd(seconds)
		snapshotData.attributes.gcdDuration = seconds
	end

	-- One charge, out of combat, where the count reads plain.
	Unlearn(GUIDING_LIGHT, WASTE_NO_TIME)
	Learn(EPIPHANY_TALENT)
	Charges(1, 1, false)
	Respec()
	SetGcd(1.2)
	check("Prayer of Mending is hand-counted, with a hasted recharge", cooldown.useManualCharges == true and cooldown.hastedCooldown == true)
	check("the Holy Words' recharges stay unhasted", snapshots[SERENITY].cooldown.hastedCooldown == false)
	check("without Guiding Light it has one charge", cooldown.manualMaxCharges == 1 and cooldown.manualCharges == 1)
	Tick(0)
	local lookup, logic = Lookup()
	check("ready, the bar text shows 1 of 1 and no time", logic["$pomCharges"] == 1 and logic["$pomMaxCharges"] == 1 and logic["$pomTime"] == 0
		and logic["$pomFullTime"] == 0 and lookup["$pomCharges"] == "1" and logic["$prayerOfMendingCharges"] == 1)
	check("and only the charge checks are live", Valid("$pomCharges") and Valid("$pomMaxCharges") and not Valid("$pomTime") and not Valid("$pomFullTime")
		and not Valid("$epiphany") and not Valid("$epiphanyTime") and not Class:HasActiveTimers())

	Cast(MENDING)
	Charges(0, 1, false)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("a cast spends the charge and starts 12 seconds scaled by the GCD", cooldown.manualCharges == 0 and Near(logic["$pomTime"], 9.6)
		and Near(logic["$pomFullTime"], 9.6) and logic["$pomCharges"] == 0)
	check("and its timer and bare checks go live", Valid("$pomTime") and Valid("$pomFullTime") and not Valid("$pomCharges") and Class:HasActiveTimers())
	Tick(4)
	lookup, logic = Lookup()
	check("the recharge counts down", Near(logic["$pomTime"], 5.6) and logic["$prayerOfMendingTime"] == logic["$pomTime"])
	Tick(5.6)
	lookup, logic = Lookup()
	check("and returns the charge when it ends", cooldown.manualCharges == 1 and logic["$pomTime"] == 0 and not Class:HasActiveTimers())

	-- Epiphany: the glow starts it, with a charge more in both counts, and a cast under it is free.
	Charges(1, 1, false)
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	check("the buff's event alone starts nothing", not buff.isActive)
	Unlearn(EPIPHANY_TALENT)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	check("without the talent, the glow starts nothing", not buff.isActive)
	Learn(EPIPHANY_TALENT)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", SERENITY)
	check("another spell's glow starts nothing", not buff.isActive)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	Charges(2, 2, false)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("Prayer of Mending's glow tracks Epiphany for 20 seconds", buff.isActive and Near(buff.remaining, 20) and Near(logic["$epiphanyTime"], 20)
		and logic["$epiphany"] == true)
	check("its charge shows in both counts, but not in the hand count", logic["$pomCharges"] == 2 and logic["$pomMaxCharges"] == 2
		and cooldown.manualCharges == 1 and cooldown.manualMaxCharges == 1)
	check("and its checks and timer go live", Valid("$epiphany") and Valid("$epiphanyTime") and Class:HasActiveTimers())
	Tick(6)
	Cast(MENDING)
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
	Charges(1, 1, false)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("a cast under Epiphany spends no charge and starts no recharge", cooldown.manualCharges == 1 and logic["$pomTime"] == 0 and logic["$pomCharges"] == 1)
	check("and the glow hiding ends Epiphany", not buff.isActive and logic["$epiphany"] == false and logic["$epiphanyTime"] == 0 and not Valid("$epiphany"))
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	check("the buff's event after its glow hid restarts nothing", not buff.isActive)

	-- A second proc shows no new glow: the buff's event restarts the 20 seconds.
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	Tick(15)
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	Tick(0)
	check("a second proc restarts its 20 seconds", buff.isActive and Near(buff.remaining, 20))
	Tick(12)
	Fire("SPELL_UPDATE_COOLDOWN", SERENITY)
	check("another spell's event leaves its time alone", Near(buff.remaining, 8))
	Tick(8)
	lookup, logic = Lookup()
	check("it ends when its 20 seconds run out", not buff.isActive and logic["$epiphanyTime"] == 0 and logic["$pomCharges"] == 1)
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
	check("and the buff's own ending event doesn't bring it back", not buff.isActive)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	Tick(3)
	Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
	check("nor does it when it lands ahead of the glow hiding", not buff.isActive)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears Epiphany", not buff.isActive)

	-- Two charges, in combat, where the count is secret and only the maximum and the recharging flag read plain.
	Learn(GUIDING_LIGHT, WASTE_NO_TIME)
	Charges(SECRET, 2, false)
	Respec()
	SetGcd(1.2)
	TRB.Data.character.inCombat = true
	check("Guiding Light gives a second charge, read as full from the recharging flag", cooldown.manualMaxCharges == 2 and cooldown.manualCharges == 2)
	Cast(MENDING)
	Charges(SECRET, 2, true)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("Waste No Time shortens the recharge to 10.5 seconds before haste", cooldown.manualCharges == 1 and Near(logic["$pomTime"], 8.4))
	Tick(1)
	Cast(MENDING)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("a second cast keeps the running recharge and queues another", cooldown.manualCharges == 0 and Near(logic["$pomTime"], 7.4)
		and Near(logic["$pomFullTime"], 15.8) and logic["$pomMaxCharges"] == 2)
	Tick(7.4)
	lookup, logic = Lookup()
	check("the first charge returns and the next recharge starts", cooldown.manualCharges == 1 and Near(logic["$pomTime"], 8.4) and Near(logic["$pomFullTime"], 8.4))
	Tick(8)
	Fire("SPELL_UPDATE_CHARGES")
	check("a charge event while the game still recharges changes nothing", cooldown.manualCharges == 1)
	Charges(SECRET, 2, false)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("one showing every charge back fills the count and ends the timer", cooldown.manualCharges == 2 and logic["$pomTime"] == 0 and logic["$pomFullTime"] == 0)

	-- A plain count can raise the hand count, never lower it.
	Cast(MENDING)
	Tick(1)
	Cast(MENDING)
	Charges(1, 2, true)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("a plain count above the hand count raises it and restarts the recharge", cooldown.manualCharges == 1 and Near(logic["$pomTime"], 8.4))
	Charges(0, 2, true)
	Fire("SPELL_UPDATE_CHARGES")
	check("a plain count below it changes nothing", cooldown.manualCharges == 1)
	Charges(2, 2, false)
	Fire("SPELL_UPDATE_CHARGES")
	check("and a plain full count fills it", cooldown.manualCharges == 2)

	-- Epiphany above two charges, with the count secret.
	Charges(SECRET, 2, false)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	Charges(SECRET, 3, false)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("under Epiphany the counts read 3 of 3", logic["$pomCharges"] == 3 and logic["$pomMaxCharges"] == 3 and cooldown.manualCharges == 2)
	Cast(MENDING)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
	Charges(SECRET, 2, false)
	Fire("SPELL_UPDATE_CHARGES")
	Tick(0)
	lookup, logic = Lookup()
	check("and its free cast leaves 2 of 2", logic["$pomCharges"] == 2 and logic["$pomMaxCharges"] == 2 and logic["$pomTime"] == 0)
	Cast(MENDING)
	Tick(1)
	Cast(MENDING)
	Charges(SECRET, 2, true)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
	Tick(0)
	lookup, logic = Lookup()
	check("with no charge left, Epiphany still gives one, and the charge bare check is live", logic["$pomCharges"] == 1 and cooldown.manualCharges == 0 and Valid("$pomCharges"))
	Cast(MENDING)
	Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
	Tick(0)
	lookup, logic = Lookup()
	check("and its free cast leaves the running recharge alone", cooldown.manualCharges == 0 and Near(logic["$pomTime"], 7.4))
	Charges(SECRET, 2, false)
	Fire("SPELL_UPDATE_CHARGES")

	-- Haste: a GCD change rescales the running recharge and the queued one, and leaves an unhasted recharge alone.
	Cast(SERENITY)
	Cast(MENDING)
	Tick(1)
	Cast(MENDING)
	Tick(1)
	local serenityBefore = snapshots[SERENITY].cooldown:GetRemainingTime(drv.now)
	try("haste", function() snapshotData:RecalculateHastedCooldowns(1.2, 0.9, drv.now) end)
	SetGcd(0.9)
	Tick(0)
	lookup, logic = Lookup()
	check("a shorter GCD shortens the running recharge and the queued one", Near(logic["$pomTime"], 4.8) and Near(logic["$pomFullTime"], 11.1))
	check("and leaves Holy Word: Serenity's recharge alone", Near(snapshots[SERENITY].cooldown:GetRemainingTime(drv.now), serenityBefore))
	Tick(4.8)
	Cast(MENDING)
	Tick(0)
	lookup, logic = Lookup()
	check("a charge returned and spent again keeps the rescaled recharge", cooldown.manualCharges == 0 and Near(logic["$pomTime"], 6.3))
	Charges(SECRET, 2, false)
	Fire("SPELL_UPDATE_CHARGES")
	try("haste", function() snapshotData:RecalculateHastedCooldowns(0.9, 1.2, drv.now) end)
	SetGcd(1.2)
	check("a GCD change with every charge up starts nothing", cooldown.manualCharges == 2 and cooldown:GetRemainingTime(drv.now) == 0)

	-- Voidbinding speeds the recharge up like the Holy Words'.
	snapshots[VOIDBINDING].buff:InitializeCustom(30, drv.now)
	Cast(MENDING)
	check("under Voidbinding the recharge is 30% faster", Near(cooldown:GetRemainingTime(drv.now), 8.4 / 1.3))
	snapshots[VOIDBINDING].buff:Reset()
	Fire("SPELL_UPDATE_CHARGES")

	-- A loading screen re-runs the spec switch.
	Cast(MENDING)
	Tick(2)
	Charges(1, 2, true)
	stubs.fireEvents("PLAYER_ENTERING_WORLD", ctx.addonName)
	for _ = 1, 5 do
		stubs.fireEvents("TRB_DRAIN", ctx.addonName)
	end
	SetGcd(1.2)
	check("a loading screen keeps the count and the running recharge", cooldown.manualCharges == 1 and cooldown.manualMaxCharges == 2
		and cooldown:GetRemainingTime(drv.now) > 0 and cooldown.hastedCooldown == true)
	Charges(SECRET, 2, false)
	Fire("SPELL_UPDATE_CHARGES")

	-- Custom Bars offer what the snapshots track.
	local kinds = TRB.Functions.CustomBars.kinds
	local offered = {}
	for _, source in ipairs(TRB.Functions.CustomBars:GetSources(5, 2)) do
		offered[tostring(source.spellId) .. ":" .. tostring(source.kind)] = true
	end
	check("Custom Bars offer its charges, recharge, and time until every charge", offered[MENDING .. ":" .. kinds.charges] == true
		and offered[MENDING .. ":" .. kinds.rechargeTime] == true and offered[MENDING .. ":" .. kinds.totalRechargeTime] == true
		and offered[MENDING .. ":" .. kinds.buffTime] == nil)
	check("and Epiphany's time", offered[EPIPHANY_BUFF .. ":" .. kinds.buffTime] == true)

	-- The audio cue: off by default, once per Epiphany.
	local cue = TRB.Data.settings.priest.holy.audio.epiphany
	local definition = TRB.Functions.AudioCues:GetDefinition("priest_holy")
	local registered = false
	for _, builtIn in ipairs(definition.builtIns) do
		registered = registered or builtIn.id == "epiphany"
	end
	check("the Epiphany audio cue is registered and off by default", registered and cue ~= nil and cue.enabled == false)
	if cue ~= nil then
		drv.sounds = 0
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
		check("off, a proc plays nothing", drv.sounds == 0)
		cue.enabled = true
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
		check("on, a proc plays it", drv.sounds == 1)
		Fire("SPELL_UPDATE_COOLDOWN", EPIPHANY_BUFF)
		check("a second proc inside it doesn't play it again", drv.sounds == 1)
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
		check("the next Epiphany does", drv.sounds == 2)
		Tick(20)
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
		check("and so does one after an Epiphany that ran out", drv.sounds == 3)
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
		cue.enabled = false
	end

	-- The Color Indicator: deleted by default, so it paints only once added back to the list.
	local shared = TRB.Data.settings.priest.holy.colors.shared
	local indicator = shared.indicatorColors.epiphany
	local function Listed()
		for _, key in ipairs(shared.nodeOrder) do
			if key == "epiphany" then
				return true
			end
		end
		return false
	end
	check("the Epiphany Color Indicator starts deleted, off, and in its color", not Listed() and shared.removed ~= nil
		and shared.removed.epiphany == true and indicator ~= nil and indicator.enabled == false and indicator.color == COLOR)
	if indicator ~= nil then
		---Whether the real update painted the Epiphany color on a border.
		local function Draw()
			Tick(0)
			return drv.borders[COLOR] == true
		end
		indicator.enabled = true
		indicator.targets.manaBar.border = true
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", MENDING)
		check("unlisted, it paints nothing while Epiphany is up", buff.isActive and not Draw())
		table.insert(shared.nodeOrder, 1, "epiphany")
		shared.removed.epiphany = false
		check("listed on the Mana bar border, it paints while Epiphany is up", Draw())
		Fire("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", MENDING)
		check("and stops when Epiphany ends", not buff.isActive and not Draw())
		table.remove(shared.nodeOrder, 1)
		shared.removed.epiphany = true
		indicator.enabled = false
		indicator.targets.manaBar.border = false
	end

	-- /trb mending prints the tracker's state beside the game's read.
	local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
	local command = descriptor ~= nil and descriptor.slashCommands ~= nil and descriptor.slashCommands.mending or nil
	check("/trb mending is declared", command ~= nil)
	if command ~= nil then
		local function Capture(fn)
			local lines = {}
			local realPrint = desktop.print
			desktop.print = function(...)
				local parts = {}
				for i = 1, select("#", ...) do
					parts[#parts + 1] = tostring((select(i, ...)))
				end
				lines[#lines + 1] = table.concat(parts, " ")
			end
			local ok, err = xpcall(fn, function(e) return debug.traceback(tostring(e), 2) end)
			desktop.print = realPrint
			if not ok then
				errors = errors + 1
				print("DRIVER ERROR /trb mending\n    " .. tostring(err):gsub("\n", "\n    "))
			end
			return lines
		end
		local function AnyLine(lines, pattern)
			for _, line in ipairs(lines) do
				if line:find(pattern) then
					return true
				end
			end
			return false
		end
		local lines = Capture(function() command("x") end)
		check("it rejects an argument", #lines == 1 and AnyLine(lines, "Unknown argument 'x'%. Usage: /trb mending"))
		Cast(MENDING)
		Charges(SECRET, 2, true)
		lines = Capture(function() command("") end)
		check("it prints the tracked charges, the recharge, and the game's read", AnyLine(lines, "tracked 1/2 charges | remaining 8%.40s | recharge 8%.40s | expected 8%.40s | game reads secret/2 recharging"))
		check("and Epiphany and the talents", AnyLine(lines, "Epiphany down | Guiding Light yes | Waste No Time yes | Voidbinding down"))
	end

	return errors
end

return hooks
