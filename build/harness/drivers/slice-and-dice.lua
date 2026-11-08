-- Checks the Forever, Classic, and TBC Rogue's Slice and Dice: its cast-tracked timer, bar text, Active and Ending
-- Color Indicators, and /trb snd.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
local SLICE_AND_DICE_RANK_1, SLICE_AND_DICE_RANK_2, IMPROVED_SLICE_AND_DICE, EVISCERATE = 5171, 6774, 14165, 2098
local NETHERBLADE = { [1] = 29044, [3] = 29047, [5] = 29045, [7] = 29046, [10] = 29048 }
local ACTIVE_COLOR, ENDING_COLOR = "FFFFD100", "FFFF0000"

-- The test clock, the frames the addon made, the fill colors a draw painted, and worn gear by slot.
local drv = { now = 1000, frames = {}, printed = {}, fills = {}, gear = {} }

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
	G.GetInventoryItemLink = function(_, slot)
		local itemId = drv.gear[slot]
		return itemId ~= nil and ("|cffa335ee|Hitem:" .. itemId .. "::::::::70:::::|h[Item]|h|r") or nil
	end
end

function hooks.afterLoad(ctx)
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	ctx.TRB.Functions.News.Init = function() end
	local Color = ctx.TRB.Functions.Color
	local applyFill = Color.ApplyFillColor
	Color.ApplyFillColor = function(self, node, colorEntry, ...)
		local color = type(colorEntry) == "table" and colorEntry.color or colorEntry
		if color ~= nil then drv.fills[color] = true end
		return applyFill(self, node, colorEntry, ...)
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
	if flavorTable == nil or ctx.classId ~= 4 then
		check("only a Forever, Classic, or TBC Rogue offers Slice and Dice bar text", not Offers("$sliceAndDiceTime"))
		return errors
	end

	local runtime = flavorTable.Runtime
	local Class = TRB.Functions.Class
	local snapshot = TRB.Data.snapshotData.snapshots[SLICE_AND_DICE_RANK_1]
	local buff = snapshot ~= nil and snapshot.buff or nil
	check("Slice and Dice has a snapshot", buff ~= nil)
	check("the bar text offers $sliceAndDiceTime and #sliceAndDice", Offers("$sliceAndDiceTime") and TRB.Data.lookup["#sliceAndDice"] ~= nil)
	if buff == nil then
		return errors
	end

	---Runs every Rogue.lua frame's handler for an event.
	local function Fire(event, ...)
		local args = { ... }
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("Rogue%.lua$") then
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
	end
	local attributes = TRB.Data.snapshotData.attributes
	local castCount = 0
	---A cast as the client reports it: sent while the cache holds these combo points, which the spend clears before it succeeds.
	local function Cast(spellId, comboPoints)
		castCount = castCount + 1
		local castGuid = "Cast-" .. castCount
		attributes.resource2 = comboPoints
		Fire("UNIT_SPELLCAST_SENT", "player", "", castGuid, spellId)
		attributes.resource2 = 0
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, castGuid) end)
	end
	---A success with no send seen, read against the combo points the last bar update cached.
	local function CastUnsent(spellId, cachedComboPoints)
		attributes.resource2 = cachedComboPoints
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Unsent-" .. spellId) end)
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
	local function Near(a, b)
		return a ~= nil and math.abs(a - b) < 0.001
	end
	local function SetImproved(rank)
		runtime.talents.talents[IMPROVED_SLICE_AND_DICE] = rank > 0 and TRB.Classes.Talent:New(IMPROVED_SLICE_AND_DICE, rank, 3) or nil
	end
	local function Wear(pieces)
		drv.gear = {}
		local worn = 0
		for _, slot in ipairs({ 1, 3, 5, 7, 10 }) do
			if worn < pieces then
				drv.gear[slot] = NETHERBLADE[slot]
				worn = worn + 1
			end
		end
		stubs.fireEvents("PLAYER_EQUIPMENT_CHANGED:1", ctx.addonName)
	end

	-- Defaults: Ending outranks Active, both on the Energy bar's fill, and Ending starts at 2 GCDs.
	local settings = TRB.Data.settings.rogue.general
	local shared = settings.colors.shared
	local endingAt, activeAt
	for i, key in ipairs(shared.nodeOrder) do
		if key == "sliceAndDiceEnd" then endingAt = i end
		if key == "sliceAndDice" then activeAt = i end
	end
	local ending, active = shared.indicatorColors.sliceAndDiceEnd, shared.indicatorColors.sliceAndDice
	local function FillOnly(indicator)
		local targets = indicator ~= nil and indicator.targets or {}
		return targets.resourceBar ~= nil and targets.resourceBar.bar == true and targets.resourceBar.border ~= true
			and targets.resourceBar.background ~= true and targets.comboPointsBar == nil
	end
	check("Ending is listed above Active", endingAt ~= nil and activeAt ~= nil and endingAt < activeAt)
	check("both color the Energy bar's fill by default", FillOnly(ending) and FillOnly(active)
		and ending.color == ENDING_COLOR and active.color == ACTIVE_COLOR)
	local endOf = settings.endOf ~= nil and settings.endOf.sliceAndDice or {}
	check("Ending defaults to 2 GCDs, or 3 seconds", endOf.mode == "gcd" and endOf.gcdsMax == 2 and endOf.timeMax == 3)

	check("before a cast nothing is tracked", not buff.isActive and not Class:HasActiveTimers() and not Class:IsValidVariableForSpec("$sliceAndDiceTime"))
	Cast(EVISCERATE, 5)
	check("another finisher starts nothing", not buff.isActive)
	Cast(SLICE_AND_DICE_RANK_2, 5)
	check("a 5 point cast tracks 21 seconds from the points held when it was sent", buff.isActive and Near(buff.remaining, 21))
	check("and makes its timer and bare check live", Class:HasActiveTimers() and Class:IsValidVariableForSpec("$sliceAndDiceTime"))
	local lookup, lookupLogic = Lookup()
	check("$sliceAndDiceTime shows it", lookup["$sliceAndDiceTime"] ~= nil and Near(lookupLogic["$sliceAndDiceTime"], 21))
	Tick(5)
	lookup, lookupLogic = Lookup()
	check("and counts down", Near(buff.remaining, 16) and Near(lookupLogic["$sliceAndDiceTime"], 16))
	Cast(SLICE_AND_DICE_RANK_1, 1)
	check("a recast replaces it, even with less time", Near(buff.remaining, 9))
	Tick(9)
	check("it ends when its time runs out", not buff.isActive and not Class:HasActiveTimers() and not Class:IsValidVariableForSpec("$sliceAndDiceTime"))
	lookup, lookupLogic = Lookup()
	check("and its bar text drops to 0", lookupLogic["$sliceAndDiceTime"] == 0)

	CastUnsent(SLICE_AND_DICE_RANK_2, 3)
	check("with no send seen, the cached combo points count", Near(buff.remaining, 15))
	attributes.resource2 = 4
	Fire("UNIT_SPELLCAST_SENT", "player", "", "Cast-other", SLICE_AND_DICE_RANK_2)
	CastUnsent(SLICE_AND_DICE_RANK_2, 2)
	check("and a send for another cast is ignored", Near(buff.remaining, 12))
	Fire("UNIT_SPELLCAST_SENT", "player", "", "secret", SLICE_AND_DICE_RANK_2)
	Fire("UNIT_SPELLCAST_SENT", "player", "", "Cast-s", "secret")
	check("secret sends are ignored", Near(buff.remaining, 12))

	for points = 1, 5 do
		Cast(SLICE_AND_DICE_RANK_2, points)
		check(points .. " points give " .. (6 + 3 * points) .. " seconds", Near(buff.remaining, 6 + 3 * points))
	end
	local talents = runtime.talents
	check("the runtime has talents", talents ~= nil)
	if talents ~= nil then
		local multipliers = { 1.15, 1.30, 1.45 }
		for rank = 1, 3 do
			SetImproved(rank)
			Cast(SLICE_AND_DICE_RANK_2, 5)
			local fivePoints = buff.remaining
			Cast(SLICE_AND_DICE_RANK_2, 1)
			check("Improved Slice and Dice rank " .. rank .. " lengthens it by " .. math.floor((multipliers[rank] - 1) * 100 + 0.5) .. "%",
				Near(fivePoints, 21 * multipliers[rank]) and Near(buff.remaining, 9 * multipliers[rank]))
		end
		SetImproved(0)
	end

	if TRB.Flavor.id == "tbc" then
		Wear(1)
		Cast(SLICE_AND_DICE_RANK_2, 5)
		check("one Netherblade piece adds nothing", Near(buff.remaining, 21))
		Wear(2)
		Cast(SLICE_AND_DICE_RANK_2, 5)
		check("two Netherblade pieces add 3 seconds", Near(buff.remaining, 24))
		if talents ~= nil then
			SetImproved(3)
			Cast(SLICE_AND_DICE_RANK_2, 5)
			check("before Improved Slice and Dice's percentage", Near(buff.remaining, 24 * 1.45))
			SetImproved(0)
		end
		Wear(0)
		Cast(SLICE_AND_DICE_RANK_2, 5)
		check("taking them off removes it", Near(buff.remaining, 21))
	else
		Wear(5)
		Cast(SLICE_AND_DICE_RANK_2, 5)
		check("Netherblade only counts on TBC", Near(buff.remaining, 21))
		Wear(0)
	end

	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears it", not buff.isActive)

	-- The Color Indicators, painted by the real update.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	TRB.Data.snapshotData.attributes.gcdDuration = 1
	---Which Slice and Dice colors the real update painted on a fill.
	local function Draw()
		wipe(drv.fills)
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() triggerUpdates() end)
		return drv.fills[ACTIVE_COLOR] == true, drv.fills[ENDING_COLOR] == true
	end
	local painted, endingPainted = Draw()
	check("with Slice and Dice down, neither paints", not painted and not endingPainted)
	Cast(SLICE_AND_DICE_RANK_2, 5)
	painted, endingPainted = Draw()
	check("with plenty left, Active paints the fill", painted and not endingPainted)
	Tick(19.5)
	painted, endingPainted = Draw()
	check("within 2 GCDs of the end, Ending takes over", endingPainted and not painted)
	endOf.mode = "time"
	Cast(SLICE_AND_DICE_RANK_2, 1)
	Tick(5.5)
	painted, endingPainted = Draw()
	check("in time mode, Ending starts 3 seconds out", painted and not endingPainted)
	Tick(1)
	painted, endingPainted = Draw()
	check("and paints inside them", endingPainted and not painted)
	endOf.mode = "gcd"
	Tick(3)
	painted, endingPainted = Draw()
	check("once it runs out, neither paints", not buff.isActive and not painted and not endingPainted)
	active.modifiers = { notActive = true }
	painted = Draw()
	check("Not Active paints Active's color while Slice and Dice is down", painted)
	active.modifiers = nil

	-- The diagnostic.
	local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
	local command = descriptor ~= nil and descriptor.slashCommands ~= nil and descriptor.slashCommands.snd or nil
	check("/trb snd exists", command ~= nil)
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
	check("an argument is rejected with the usage", AnyLine(lines, "Usage: /trb snd") and not AnyLine(lines, "diagnostic on"))
	if talents ~= nil then
		SetImproved(2)
	end
	lines = Capture(function() command("") end)
	check("/trb snd turns it on with the talent rank", AnyLine(lines, "diagnostic on%. Improved Slice and Dice rank " .. (talents ~= nil and 2 or 0)))
	lines = Capture(function() Cast(SLICE_AND_DICE_RANK_2, 4) end)
	check("a cast prints both combo point readings and the time tracked",
		AnyLine(lines, "cast 6774 | combo points sent 4, cached 0 | tracking " .. string.format("%.2f", 18 * (talents ~= nil and 1.30 or 1)) .. "s from sent"))
	lines = Capture(function() Tick(30) end)
	check("its end prints the time it ran", AnyLine(lines, "timer ended after " .. string.format("%.2f", 18 * (talents ~= nil and 1.30 or 1)) .. "s"))
	lines = Capture(function() CastUnsent(SLICE_AND_DICE_RANK_1, 2) end)
	check("an unsent cast says it used the cached count", AnyLine(lines, "combo points sent %-, cached 2 | tracking .-s from cached"))
	lines = Capture(function() command("") end)
	check("/trb snd again turns it off", AnyLine(lines, "diagnostic off"))
	lines = Capture(function() Cast(SLICE_AND_DICE_RANK_2, 5) end)
	check("and casts print nothing after", not AnyLine(lines, "TRB Slice and Dice"))
	if talents ~= nil then
		SetImproved(0)
	end

	return errors
end

return hooks
