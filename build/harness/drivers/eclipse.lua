-- Checks the Forever Druid's Eclipse bar (gate, cast-tracked charges, timer, nodes, bar text, and audio counter).
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
-- The talent, its aura, Wrath's and Starfire's rank 1 and top rank, the charge cap, charges per Wrath, and the duration.
local ECLIPSE = { talent = 408248, aura = 408255, wrath = 5176, wrathTop = 9912, starfire = 2912, starfireTop = 25298, stacks = 4, perWrath = 2, duration = 15 }
local MOONFIRE = 8921

-- The test clock, whether the talent is taken, the player's auras, and combat lockdown.
local drv = { now = 1000, talent = false, auras = {}, inCombat = false }

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	desktop.GetTime = function() return drv.now end
	-- Player auras by spell ID, readable only out of combat.
	desktop.C_UnitAuras.GetPlayerAuraBySpellID = function(spellId) return drv.auras[spellId] end
	desktop.issecrettable = function() return false end
	desktop.InCombatLockdown = function() return drv.inCombat end
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	TRB.Functions.News.Init = function() end
	if TRB.Flavor.id == "forever" then
		-- The talent cache reads the Eclipse talent from here.
		local readTalentRanks = TRB.Flavor.ReadTalentRanks
		TRB.Flavor.ReadTalentRanks = function()
			local ranks = readTalentRanks()
			if drv.talent then
				ranks[ECLIPSE.talent] = { currentRank = 1, maxRank = 3 }
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

	if TRB.Flavor.id ~= "forever" or ctx.classId ~= 11 then
		check("only a Forever Druid offers Eclipse bar text and an Eclipse bar", not Offers("$eclipseStacks")
			and (barGroups == nil or barGroups.eclipse == nil))
		return errors
	end

	---The Eclipse snapshot's buff, read fresh after a spec switch.
	local function Buff()
		local spell = TRB.Data.spellsData.spells.eclipse
		local snapshot = spell ~= nil and TRB.Data.snapshotData.snapshots[spell.id] or nil
		return snapshot ~= nil and snapshot.buff or nil
	end
	local buff = Buff()
	local group = barGroups ~= nil and barGroups.eclipse or nil
	check("Eclipse has a snapshot", buff ~= nil)
	check("the bar text offers $eclipseStacks, $eclipseStacksMax, $eclipseTime, and #eclipse", Offers("$eclipseStacks") and Offers("$eclipseStacksMax")
		and Offers("$eclipseTime") and TRB.Data.lookup["#eclipse"] ~= nil)
	check("the Eclipse bar has one node per charge", group ~= nil and group.maxNodes == ECLIPSE.stacks)
	if buff == nil or group == nil then
		return errors
	end
	local settings = TRB.Data.settings.druid.general
	local hide = settings.displayBar.eclipse.hideConditions
	check("it hides by default in Cat, Bear, and Travel forms only", hide.isDruidCatForm == true and hide.isDruidBearForm == true
		and hide.isDruidTravelFormAny == true and not hide.isDruidHumanoidForm and not hide.isDruidMoonkinForm)
	check("it starts with one color per charge", settings.colors.bars.eclipse.nodeColors.charge1 ~= nil and settings.colors.bars.eclipse.nodeColors.charge4 ~= nil
		and settings.bars.eclipse.anchor.barKey == "primary")
	local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
	local anchors = descriptor ~= nil and descriptor.barTextAnchorFrames ~= nil and descriptor.barTextAnchorFrames.eclipse or nil
	check("its nodes are bar text anchors", anchors ~= nil and #anchors == ECLIPSE.stacks and anchors[1].label == L["ForeverDruidEclipse1"]
		and anchors[ECLIPSE.stacks].frame == "Eclipse_" .. ECLIPSE.stacks)
	local source = TRB.Functions.AudioCues:GetCounterSource("druid_general", "eclipse")
	check("it has an Eclipse Charges audio counter up to its cap", source ~= nil and source.max == ECLIPSE.stacks and source.label == L["ForeverDruidAudioCueSourceEclipse"])
	local seed1, seed2 = settings.audio.eclipseThreshold1, settings.audio.eclipseThreshold2
	check("seeded with two cues, both off, the second at the cap", seed1 ~= nil and seed2 ~= nil and seed1.enabled == false and seed2.enabled == false
		and seed1.source == "eclipse" and seed1.configuration.thresholdValue == 2 and seed2.configuration.thresholdValue == ECLIPSE.stacks)
	check("the Combo Points counter stays", TRB.Functions.AudioCues:GetCounterSource("druid_general", "comboPoints") ~= nil)

	-- A layout's render transition runs on the stubs' wall clock and would hide every bar from the draws.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	local eclipseEnabled = nil
	local addEntry = TRB.Functions.BarVisibility.AddEntry
	TRB.Functions.BarVisibility.AddEntry = function(self, entries, barGroup, visibility, enabled, ...)
		if barGroup ~= nil and barGroup == group then
			eclipseEnabled = enabled
		end
		return addEntry(self, entries, barGroup, visibility, enabled, ...)
	end
	-- A forced pass hides every bar, so this runs an ordinary one.
	local function Shown()
		eclipseEnabled = nil
		TRB.Functions.BarVisibility:MarkDirty()
		try("HideResourceBar", function() Class:HideResourceBar() end)
		return eclipseEnabled
	end
	local layouts = 0
	local applyLayout = Bar.ApplyBarGroupsLayout
	Bar.ApplyBarGroupsLayout = function(...)
		layouts = layouts + 1
		return applyLayout(...)
	end
	-- Enough passes for the spec switch's nested timers.
	local function Drain()
		for _ = 1, 5 do
			stubs.fireEvents("TRB_DRAIN", ctx.addonName)
		end
	end
	---Takes or drops the talent through the talent change event and the spec switch it runs.
	local function Retalent(taken)
		drv.talent = taken
		layouts = 0
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
		if sourceId == "eclipse" then
			counted = value
		end
		return updateCounter(self, specSettings, snapshotData, sourceId, value, ...)
	end
	---The filled node count the real update draws, which also runs the tick; nil when it draws some node no whole value.
	local function Draw()
		wipe(values)
		counted = nil
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() triggerUpdates() end)
		local filled = 0
		for i = 1, ECLIPSE.stacks do
			local value = values[group:GetNode(i)]
			if value == 1 then
				filled = filled + 1
			elseif value ~= 0 and value ~= nil then
				return nil
			end
		end
		return filled
	end
	local function DrawnNodes()
		local drawn = 0
		for i = 1, ECLIPSE.stacks do
			drawn = drawn + (values[group:GetNode(i)] ~= nil and 1 or 0)
		end
		return drawn
	end
	local function Cast(spellId)
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Cast-0") end)
	end
	local function Lookup()
		TRB.Data.activeVariables = nil
		try("RefreshLookupData", function() TRB.Functions.RefreshLookupData() end)
		return TRB.Data.lookup, TRB.Data.lookupLogic
	end

	local container = group.containerFrame
	check("without the talent, the bar is hidden and takes no room", Bar:IsBarTalentGatedHidden("eclipse") and Shown() == false
		and container:GetHeight() < 0.01)
	Draw()
	check("and the update draws none of its nodes and feeds no audio cue", TRB.Data.snapshotData.attributes.isTracking
		and DrawnNodes() == 0 and counted == nil)
	Cast(ECLIPSE.wrath)
	check("and a Wrath stores nothing", not buff.isActive)

	Retalent(false)
	local baseline = layouts
	check("a talent change that leaves Eclipse untaken keeps the bar hidden", Shown() == false)
	Retalent(true)
	check("taking the Eclipse talent lays the bars out once more and shows it", layouts == baseline + 1 and Shown() == true
		and not Bar:IsBarTalentGatedHidden("eclipse") and container:GetHeight() > 1)
	Retalent(true)
	check("an unchanged talent lays out nothing more", layouts == baseline)
	buff = Buff() --[[@as table]]

	check("before a cast nothing is tracked", not buff.isActive and not Class:HasActiveTimers()
		and not Class:IsValidVariableForSpec("$eclipseStacks") and not Class:IsValidVariableForSpec("$eclipseTime")
		and Class:IsValidVariableForSpec("$eclipseStacksMax"))
	check("and no node is filled", Draw() == 0 and DrawnNodes() == ECLIPSE.stacks and counted == 0)
	Cast(MOONFIRE)
	Cast(ECLIPSE.starfire)
	check("another spell, or a Starfire with nothing stored, changes nothing", not buff.isActive)
	Cast(ECLIPSE.wrath)
	check("a Wrath stores two charges for the full duration", buff.isActive and buff.applications == ECLIPSE.perWrath and buff.remaining == ECLIPSE.duration)
	check("and makes its timer and bare checks live", Class:HasActiveTimers() and Class:IsValidVariableForSpec("$eclipseStacks")
		and Class:IsValidVariableForSpec("$eclipseTime"))
	drv.now = drv.now + 5
	Cast(ECLIPSE.starfireTop)
	check("any rank of Starfire spends one and leaves the timer running", buff.applications == 1 and Draw() == 1 and buff.remaining == ECLIPSE.duration - 5)
	Cast(ECLIPSE.wrathTop)
	check("any rank of Wrath adds two more and restarts the timer", buff.applications == 3 and buff.remaining == ECLIPSE.duration)
	check("three charges fill three nodes and feed the audio counter", Draw() == 3 and counted == 3)
	local lookup, lookupLogic = Lookup()
	check("the bar text shows 3 of 4 charges", lookup["$eclipseStacks"] == "3" and lookup["$eclipseStacksMax"] == "4"
		and lookupLogic["$eclipseStacks"] == 3 and lookupLogic["$eclipseStacksMax"] == 4 and lookupLogic["$eclipseTime"] == buff.remaining)
	Cast(ECLIPSE.wrath)
	check("a Wrath at three charges stops at the cap", buff.applications == ECLIPSE.stacks and Draw() == ECLIPSE.stacks and counted == ECLIPSE.stacks)
	drv.now = drv.now + 5
	Cast(ECLIPSE.wrath)
	check("a Wrath at the cap only restarts the timer", buff.applications == ECLIPSE.stacks and buff.remaining == ECLIPSE.duration)

	for _, anchor in ipairs({ "Eclipse_1", "Eclipse_4" }) do
		local frame = nil
		try("GetBarTextFrame", function() frame = Class:GetBarTextFrame(anchor) end)
		check("bar text can anchor to " .. anchor, frame ~= nil and frame == group:GetNode(tonumber(anchor:sub(-1))):GetFrame())
	end
	local comboFrame = nil
	try("GetBarTextFrame", function() comboFrame = Class:GetBarTextFrame("ComboPoint_2") end)
	check("and combo point anchors still resolve", comboFrame ~= nil and comboFrame == barGroups.secondary:GetNode(2):GetFrame())

	-- The aura sync: leaving combat and a loading screen copy the real charges and time; a missing aura changes nothing.
	drv.auras[ECLIPSE.aura] = { applications = 2, expirationTime = drv.now + 9, duration = ECLIPSE.duration }
	drv.inCombat = true
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	check("in combat lockdown, the aura isn't read", buff.applications == ECLIPSE.stacks)
	drv.inCombat = false
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	check("leaving combat copies the aura's charges and time", buff.applications == 2 and buff.remaining == 9)
	drv.auras[ECLIPSE.aura] = nil
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	check("with no aura, the counted charges stand", buff.isActive and buff.applications == 2 and buff.remaining == 9)

	drv.auras[ECLIPSE.aura] = { applications = 3, expirationTime = drv.now + 12, duration = ECLIPSE.duration }
	stubs.fireEvents("PLAYER_ENTERING_WORLD", ctx.addonName)
	Drain()
	buff = Buff() --[[@as table]]
	check("a loading screen keeps the gate and copies the aura", buff.isActive and buff.applications == 3 and buff.remaining == 12
		and not Bar:IsBarTalentGatedHidden("eclipse") and Shown() == true and Draw() == 3)
	drv.auras[ECLIPSE.aura] = nil
	stubs.fireEvents("PLAYER_ENTERING_WORLD", ctx.addonName)
	Drain()
	buff = Buff() --[[@as table]]
	check("and one with no aura keeps the charges", buff.isActive and buff.applications == 3)

	for _ = 1, ECLIPSE.stacks do
		Cast(ECLIPSE.starfire)
	end
	check("spending the last charge ends the tracking", not buff.isActive and not Class:HasActiveTimers() and Draw() == 0)

	Cast(ECLIPSE.wrath)
	drv.now = drv.now + ECLIPSE.duration
	check("the charges end when the timer runs out", Draw() == 0 and not buff.isActive and not Class:HasActiveTimers()
		and not Class:IsValidVariableForSpec("$eclipseTime"))
	lookup, lookupLogic = Lookup()
	check("and the bar text drops to 0", lookup["$eclipseStacks"] == "0" and lookupLogic["$eclipseTime"] == 0)

	Cast(ECLIPSE.wrath)
	Cast(ECLIPSE.wrath)
	drv.now = drv.now + ECLIPSE.duration + 1
	Cast(ECLIPSE.wrath)
	check("a Wrath after the charges ran out, before a tick, starts over at two", buff.applications == ECLIPSE.perWrath and buff.remaining == ECLIPSE.duration)
	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears the charges", not buff.isActive)

	Cast(ECLIPSE.wrath)
	Retalent(false)
	buff = Buff() --[[@as table]]
	check("dropping the talent hides the bar and clears its charges", layouts == baseline + 1 and Shown() == false and not buff.isActive)

	TRB.Functions.BarVisibility.AddEntry = addEntry
	Bar.ApplyBarGroupsLayout = applyLayout
	Bar.SetBarNodeValue = setValue
	TRB.Functions.AudioCues.UpdateCounter = updateCounter
	return errors
end

return hooks
