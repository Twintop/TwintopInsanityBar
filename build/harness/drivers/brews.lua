-- Checks the Brewmaster Brews bar (#721): its nodes by talent, order, and enable; charges counted from the plain
-- cooldown flags; bar text; one timer binding per recharge; and each brew as a Color Indicator target.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
local PURIFYING_BREW, CELESTIAL_BREW, CELESTIAL_INFUSION, FORTIFYING_BREW, BLACK_OX_BREW = 119582, 322507, 1241059, 115203, 115399
local FORTIFYING_BREW_TALENT, DETERMINATION, ENDLESS_DRAUGHT, INVOKE_NIUZAO = 388917, 322960, 450892, 132578
local SECRET = setmetatable({}, { __tostring = function() return "SECRET" end })

-- The test clock, and the cooldown, charge, and duration readings the stubbed spell API hands out by spell id.
local drv = { now = 1000, cooldowns = {}, charges = {}, durations = {} }

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	G.GetTime = function() return drv.now end
	-- Brewmaster's and Evoker's ticks read these.
	G.UnitStagger = function() return 0 end
	G.UnitPartialPower = function() return 0 end
	local innerIsSecret = G.issecretvalue
	G.issecretvalue = function(value)
		return value == SECRET or (innerIsSecret ~= nil and innerIsSecret(value)) or false
	end
	local getCooldown, getCharges = G.C_Spell.GetSpellCooldown, G.C_Spell.GetSpellCharges
	G.C_Spell.GetSpellCooldown = function(id) return drv.cooldowns[id] or getCooldown(id) end
	G.C_Spell.GetSpellCharges = function(id) return drv.charges[id] or getCharges(id) end
	G.C_Spell.GetSpellCooldownDuration = function(id) return drv.durations[id] end
	G.C_Spell.GetSpellChargeDuration = function(id) return drv.durations[id] end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
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
	-- Only the render checks draw, through the real update.
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

	local barGroups = TRB.Frames.barGroups
	if TRB.Flavor.id ~= "mainline" or ctx.classId ~= 10 then
		check("only a Live Brewmaster has the Brews bar", barGroups == nil or barGroups.brews == nil)
		return errors
	end

	local Class = TRB.Functions.Class
	local Bar = TRB.Functions.Bar
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "brewmaster")
	local cache = TRB.Data.specCache.monk_brewmaster
	local settings = cache.settings
	local brewColors = settings.colors.bars.brews
	local group = barGroups.brews
	check("the Brews bar is built with its settings", group ~= nil and brewColors ~= nil and settings.bars.brews ~= nil
		and settings.displayBar.brews ~= nil and settings.displayBar.brews.alwaysShow == true)
	if group == nil or brewColors == nil then
		return errors
	end
	check("it anchors above the Stagger bar by default", settings.bars.brews.anchor.barKey == "stagger")

	local talents = cache.talents
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
	---What a talent change runs once SwitchSpec has read the new talents.
	local function Remap()
		try("CheckCharacter", function() Class:CheckCharacter() end)
	end
	---What the options run after an enable box or a reorder arrow.
	local function Layout()
		try("layout", function() Bar:ApplyBarGroupsLayout(settings, barGroups) end)
	end
	---The node a bar text anchor resolves to, and whether its text is enabled.
	local function NodeOf(frameName)
		local frame, enabled = Class:GetBarTextFrame(frameName)
		if frame ~= nil then
			for i = 1, group.maxNodes do
				local node = group:GetNode(i)
				if node ~= nil and node:GetFrame() == frame then
					return i, enabled
				end
			end
		end
		return nil, enabled
	end

	Unlearn(PURIFYING_BREW, CELESTIAL_BREW, CELESTIAL_INFUSION, FORTIFYING_BREW_TALENT, DETERMINATION, BLACK_OX_BREW, ENDLESS_DRAUGHT)
	Remap()
	check("with no brew talented, none has a node", NodeOf("PurifyingBrew_1") == nil and NodeOf("FortifyingBrew") == nil)
	Learn(DETERMINATION)
	Remap()
	check("Fortifying Brew: Determination alone teaches Fortifying Brew", NodeOf("FortifyingBrew") == 1)
	Unlearn(DETERMINATION)
	Learn(PURIFYING_BREW, CELESTIAL_BREW, FORTIFYING_BREW_TALENT, BLACK_OX_BREW)
	Remap()
	check("each talented brew gets a node per charge, in the default order", group.nodeCount == 5
		and NodeOf("PurifyingBrew_1") == 1 and NodeOf("PurifyingBrew_2") == 2 and NodeOf("CelestialBrew_1") == 3
		and NodeOf("FortifyingBrew") == 4 and NodeOf("BlackOxBrew") == 5)
	local infusionNode, infusionEnabled = NodeOf("CelestialInfusion_1")
	check("a brew that isn't talented has no node, and its bar text is off", infusionNode == nil and infusionEnabled == false
		and NodeOf("CelestialBrew_2") == nil)
	Learn(ENDLESS_DRAUGHT)
	Remap()
	check("Endless Draught adds Celestial Brew's second charge", group.nodeCount == 6 and NodeOf("CelestialBrew_2") == 4
		and NodeOf("FortifyingBrew") == 5 and NodeOf("BlackOxBrew") == 6)
	Unlearn(CELESTIAL_BREW)
	Learn(CELESTIAL_INFUSION)
	Remap()
	check("Celestial Infusion takes Celestial Brew's place", group.nodeCount == 6 and NodeOf("CelestialInfusion_1") == 3
		and NodeOf("CelestialInfusion_2") == 4 and NodeOf("CelestialBrew_1") == nil)
	brewColors.nodeColors.purifyingBrew.enabled = false
	Layout()
	check("a disabled brew gives up its nodes", group.nodeCount == 4 and NodeOf("PurifyingBrew_1") == nil and NodeOf("CelestialInfusion_1") == 1)
	brewColors.nodeColors.purifyingBrew.enabled = true
	local defaultOrder = brewColors.nodeOrder
	brewColors.nodeOrder = { "blackOxBrew", "purifyingBrew", "celestialBrew", "celestialInfusion", "fortifyingBrew" }
	Layout()
	check("the nodes follow the configured order", group.nodeCount == 6 and NodeOf("BlackOxBrew") == 1 and NodeOf("PurifyingBrew_1") == 2
		and NodeOf("FortifyingBrew") == 6)
	brewColors.nodeOrder = defaultOrder
	Unlearn(CELESTIAL_INFUSION, ENDLESS_DRAUGHT)
	Learn(CELESTIAL_BREW)
	Remap()
	check("dropping Endless Draught takes the second charge away again", group.nodeCount == 5 and NodeOf("CelestialBrew_2") == nil
		and NodeOf("PurifyingBrew_1") == 1)

	-- A Smooth carried in from a preset or a copied entry never reaches the timer-driven nodes.
	settings.displayBar.brews.smooth = true
	settings.displayBar.stagger.smooth = true
	Layout()
	check("a timer-driven bar ignores a carried Smooth, and Stagger keeps its own", group.smooth == false and barGroups.stagger.smooth == true)
	settings.displayBar.brews.smooth = false

	-- Cooldown events, as the client reports them: the count secret, the recharging and no-charges flags plain.
	local function Fire(spec)
		drv.now = drv.now + 1
		stubs.fireEvents(spec, ctx.addonName)
	end
	local function Reading(isActive, isOnGCD)
		return { isActive = isActive, isOnGCD = isOnGCD, isEnabled = true, modRate = 1, startTime = SECRET, duration = SECRET }
	end
	local function Charges(maxCharges, recharging)
		return { currentCharges = SECRET, maxCharges = maxCharges, cooldownStartTime = SECRET, cooldownDuration = SECRET, chargeModRate = 1, isActive = recharging }
	end
	local function Duration(remaining)
		return { GetRemainingDuration = function() return remaining end }
	end
	local function Cast(spellId)
		drv.now = drv.now + 1
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId) end)
	end
	local function Lookup()
		TRB.Data.activeVariables = nil
		try("RefreshLookupData", function() TRB.Functions.RefreshLookupData() end)
		return TRB.Data.lookup, TRB.Data.lookupLogic
	end
	local function Valid(variable)
		return Class:IsValidVariableForSpec(variable) == true
	end
	local TimerPrecision = function(seconds) return TRB.Functions.BarText:TimerPrecision(seconds) end

	local lookup, logic = Lookup()
	check("every brew starts ready", logic["$purifyingBrewCharges"] == 2 and logic["$celestialBrewCharges"] == 1
		and logic["$purifyingBrewTime"] == 0 and logic["$fortifyingBrewTime"] == 0 and logic["$blackOxBrewTime"] == 0)
	check("a ready brew counts no time", not Valid("$purifyingBrewTime") and not Valid("$fortifyingBrewTime") and Valid("$purifyingBrewCharges")
		and not Class:HasActiveTimers())
	check("the bar text offers the brews' icons", lookup["#purifyingBrew"] ~= nil and lookup["#celestialInfusion"] ~= nil and lookup["#blackOxBrew"] ~= nil)

	-- Purifying Brew: its 1 second lockout reads as its own cooldown, which must not pass for no charges.
	local firstRecharge = Duration(12.5)
	Cast(PURIFYING_BREW)
	drv.charges[PURIFYING_BREW] = Charges(2, true)
	drv.durations[PURIFYING_BREW] = firstRecharge
	drv.cooldowns[PURIFYING_BREW] = Reading(true, false)
	Fire("SPELL_UPDATE_CHARGES")
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	lookup, logic = Lookup()
	check("a Purifying Brew cast leaves one charge through its lockout", logic["$purifyingBrewCharges"] == 1 and lookup["$purifyingBrewCharges"] == 1)
	check("and its recharge counts", logic["$purifyingBrewTime"] == 1 and lookup["$purifyingBrewTime"] == TimerPrecision(12.5)
		and Valid("$purifyingBrewTime") and Class:HasActiveTimers())
	Cast(PURIFYING_BREW)
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	lookup, logic = Lookup()
	check("a second cast leaves none", logic["$purifyingBrewCharges"] == 0 and not Valid("$purifyingBrewCharges") and Valid("$purifyingBrewTime"))
	drv.cooldowns[PURIFYING_BREW] = Reading(false)
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	lookup, logic = Lookup()
	check("a charge coming back shows one while the next recharges", logic["$purifyingBrewCharges"] == 1 and logic["$purifyingBrewTime"] == 1)
	drv.charges[PURIFYING_BREW] = Charges(2, false)
	drv.durations[PURIFYING_BREW] = nil
	Fire("SPELL_UPDATE_CHARGES")
	lookup, logic = Lookup()
	check("the last charge coming back ends the count", logic["$purifyingBrewCharges"] == 2 and logic["$purifyingBrewTime"] == 0
		and not Valid("$purifyingBrewTime") and not Class:HasActiveTimers())

	-- Black Ox Brew refills both charges at once: the recharge just stops.
	Cast(PURIFYING_BREW)
	Cast(PURIFYING_BREW)
	drv.charges[PURIFYING_BREW] = Charges(2, true)
	drv.durations[PURIFYING_BREW] = firstRecharge
	drv.cooldowns[PURIFYING_BREW] = Reading(true, false)
	Fire("SPELL_UPDATE_CHARGES")
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	lookup, logic = Lookup()
	check("two casts in a row leave none", logic["$purifyingBrewCharges"] == 0)
	drv.charges[PURIFYING_BREW] = Charges(2, false)
	drv.durations[PURIFYING_BREW] = nil
	drv.cooldowns[PURIFYING_BREW] = Reading(false)
	Fire("SPELL_UPDATE_CHARGES")
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	lookup, logic = Lookup()
	check("a refill restores every charge", logic["$purifyingBrewCharges"] == 2 and logic["$purifyingBrewTime"] == 0)

	-- A recharge no cast was seen for, as after a reload.
	drv.charges[PURIFYING_BREW] = Charges(2, true)
	drv.durations[PURIFYING_BREW] = firstRecharge
	Fire("SPELL_UPDATE_CHARGES")
	lookup, logic = Lookup()
	check("an unseen recharge with a charge usable reads as one charge", logic["$purifyingBrewCharges"] == 1)
	drv.charges[PURIFYING_BREW] = Charges(2, false)
	drv.durations[PURIFYING_BREW] = nil
	Fire("SPELL_UPDATE_CHARGES")

	-- Fortifying Brew: off the GCD, so its cast reads nil as the client sends it, never false. Then reduced and ended.
	Cast(FORTIFYING_BREW)
	drv.cooldowns[FORTIFYING_BREW] = Reading(true, nil)
	drv.durations[FORTIFYING_BREW] = Duration(300)
	Fire("SPELL_UPDATE_COOLDOWN:" .. FORTIFYING_BREW)
	lookup, logic = Lookup()
	check("Fortifying Brew counts its cooldown", logic["$fortifyingBrewTime"] == 1 and lookup["$fortifyingBrewTime"] == TimerPrecision(300)
		and Valid("$fortifyingBrewTime") and Class:HasActiveTimers())

	-- The count only keeps bar text refreshing while an entry using it has somewhere to draw.
	local brewsVisibility = TRB.Data.settings.monk.brewmaster.displayBar.brews
	local function Ticking()
		TRB.Data.activeVariables = { ["$fortifyingBrewTime"] = true }
		return Class:HasActiveTimers()
	end
	check("text on a shown brew's node keeps refreshing", Ticking() == true)
	brewsVisibility.neverShow = true
	check("a Never Show bar's own text doesn't", Ticking() == false)
	local offBar = { enabled = true, text = "$fortifyingBrewTime", position = { relativeToFrame = "Resource" } }
	table.insert(settings.displayText.barText, offBar)
	check("the same time in text off the bar still does", Ticking() == true)
	table.remove(settings.displayText.barText)
	brewsVisibility.neverShow = false
	brewColors.nodeColors.fortifyingBrew.enabled = false
	Remap()
	check("nor does the text of a brew switched off the bar", Ticking() == false)
	brewColors.nodeColors.fortifyingBrew.enabled = true
	Remap()
	check("and it resumes once the brew is back", Ticking() == true)
	TRB.Data.activeVariables = nil

	drv.cooldowns[FORTIFYING_BREW] = Reading(true, nil)
	drv.durations[FORTIFYING_BREW] = Duration(297)
	Fire("SPELL_UPDATE_COOLDOWN:" .. FORTIFYING_BREW)
	lookup, logic = Lookup()
	check("a reduction retimes it", logic["$fortifyingBrewTime"] == 1 and lookup["$fortifyingBrewTime"] == TimerPrecision(297))
	drv.cooldowns[FORTIFYING_BREW] = Reading(false)
	drv.durations[FORTIFYING_BREW] = nil
	Fire("SPELL_UPDATE_COOLDOWN:" .. FORTIFYING_BREW)
	lookup, logic = Lookup()
	check("and its end stops the count", logic["$fortifyingBrewTime"] == 0 and not Valid("$fortifyingBrewTime") and not Class:HasActiveTimers())

	-- A cooldown already running when tracking starts, as after a reload, also reads nil.
	local fortifying = TRB.Data.snapshotData.snapshots[FORTIFYING_BREW].cooldown
	drv.cooldowns[FORTIFYING_BREW] = Reading(true, nil)
	drv.durations[FORTIFYING_BREW] = Duration(200)
	try("ReadInitial", function() fortifying:ReadInitial() end)
	check("an off-GCD cooldown found running at load is tracked", fortifying.onCooldown == true)
	drv.cooldowns[FORTIFYING_BREW] = Reading(false)
	drv.durations[FORTIFYING_BREW] = nil
	Fire("SPELL_UPDATE_COOLDOWN:" .. FORTIFYING_BREW)
	check("and ends like any other", fortifying.onCooldown ~= true)

	-- Black Ox Brew is off the GCD too.
	Cast(BLACK_OX_BREW)
	drv.cooldowns[BLACK_OX_BREW] = Reading(true, nil)
	drv.durations[BLACK_OX_BREW] = Duration(120)
	Fire("SPELL_UPDATE_COOLDOWN:" .. BLACK_OX_BREW)
	lookup, logic = Lookup()
	check("Black Ox Brew's cast starts its cooldown", logic["$blackOxBrewTime"] == 1 and lookup["$blackOxBrewTime"] == TimerPrecision(120))
	drv.cooldowns[BLACK_OX_BREW] = Reading(false)
	drv.durations[BLACK_OX_BREW] = nil
	Fire("SPELL_UPDATE_COOLDOWN:" .. BLACK_OX_BREW)
	lookup, logic = Lookup()
	check("and its end stops the count", logic["$blackOxBrewTime"] == 0)

	-- Celestial Brew at one charge: the recharge is its cooldown, and every reduction reads as no charges again.
	Cast(CELESTIAL_BREW)
	drv.cooldowns[CELESTIAL_BREW] = Reading(true, false)
	drv.durations[CELESTIAL_BREW] = Duration(72)
	Fire("SPELL_UPDATE_COOLDOWN:" .. CELESTIAL_BREW)
	Fire("SPELL_UPDATE_COOLDOWN:" .. CELESTIAL_BREW)
	lookup, logic = Lookup()
	check("Celestial Brew's one charge recharges through a reduction", logic["$celestialBrewCharges"] == 0 and logic["$celestialBrewTime"] == 1
		and lookup["$celestialBrewTime"] == TimerPrecision(72))
	drv.cooldowns[CELESTIAL_BREW] = Reading(false)
	drv.durations[CELESTIAL_BREW] = nil
	Fire("SPELL_UPDATE_COOLDOWN:" .. CELESTIAL_BREW)
	lookup, logic = Lookup()
	check("and comes back", logic["$celestialBrewCharges"] == 1 and logic["$celestialBrewTime"] == 0)

	-- With Endless Draught a cast with a charge left reads only the global cooldown.
	Learn(ENDLESS_DRAUGHT)
	Remap()
	Cast(CELESTIAL_BREW)
	drv.charges[CELESTIAL_BREW] = Charges(2, true)
	drv.durations[CELESTIAL_BREW] = Duration(72)
	drv.cooldowns[CELESTIAL_BREW] = Reading(true, nil)
	Fire("SPELL_UPDATE_CHARGES")
	Fire("SPELL_UPDATE_COOLDOWN:" .. CELESTIAL_BREW)
	lookup, logic = Lookup()
	check("Celestial Brew's second charge is counted", logic["$celestialBrewCharges"] == 1 and logic["$celestialBrewTime"] == 1)
	drv.charges[CELESTIAL_BREW] = Charges(2, false)
	drv.durations[CELESTIAL_BREW] = nil
	drv.cooldowns[CELESTIAL_BREW] = Reading(false)
	Fire("SPELL_UPDATE_CHARGES")
	Unlearn(ENDLESS_DRAUGHT)
	Remap()

	-- The render, through the real update.
	Bar.IsRenderTransitionActive = function() return false end
	TRB.Data.snapshotData.attributes.gcdDuration = 1
	local binds, bound, values, borders = {}, {}, {}, {}
	local BarNode = TRB.Classes.BarNode
	local setTimer = BarNode.SetTimerDuration
	BarNode.SetTimerDuration = function(node, durationObject, ...)
		binds[node] = (binds[node] or 0) + 1
		bound[node] = durationObject
		return setTimer(node, durationObject, ...)
	end
	local clearTimer = BarNode.ClearTimerDuration
	BarNode.ClearTimerDuration = function(node, ...)
		bound[node] = nil
		return clearTimer(node, ...)
	end
	local setBorder = BarNode.SetBorderColor
	BarNode.SetBorderColor = function(node, color, ...)
		borders[node] = color
		return setBorder(node, color, ...)
	end
	local setValue = Bar.SetBarNodeValue
	Bar.SetBarNodeValue = function(self, nodeSettings, key, node, value, maxResource)
		values[node] = value
		return setValue(self, nodeSettings, key, node, value, maxResource)
	end
	local function Draw()
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() triggerUpdates() end)
	end
	local function Node(index)
		return group:GetNode(index)
	end

	Draw()
	check("ready brews draw full nodes with no timer", values[Node(1)] == 1 and values[Node(2)] == 1 and values[Node(3)] == 1
		and values[Node(4)] == 1 and values[Node(5)] == 1 and next(binds) == nil)
	check("each node wears the bar's border", borders[Node(1)] == brewColors.border.color and borders[Node(5)] == brewColors.border.color)

	Cast(PURIFYING_BREW)
	drv.charges[PURIFYING_BREW] = Charges(2, true)
	drv.durations[PURIFYING_BREW] = firstRecharge
	Fire("SPELL_UPDATE_CHARGES")
	Draw()
	Draw()
	check("a recharging charge binds its node's fill once across two ticks", values[Node(1)] == 1 and binds[Node(2)] == 1
		and bound[Node(2)] == firstRecharge)
	local reducedRecharge = Duration(9)
	drv.durations[PURIFYING_BREW] = reducedRecharge
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	Draw()
	check("a reduction rebinds it", binds[Node(2)] == 2 and bound[Node(2)] == reducedRecharge)
	Cast(PURIFYING_BREW)
	drv.cooldowns[PURIFYING_BREW] = Reading(true, false)
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	Draw()
	check("with no charges the first node recharges and the second empties", bound[Node(1)] == reducedRecharge and bound[Node(2)] == nil
		and values[Node(2)] == 0)
	drv.charges[PURIFYING_BREW] = Charges(2, false)
	drv.durations[PURIFYING_BREW] = nil
	drv.cooldowns[PURIFYING_BREW] = Reading(false)
	Fire("SPELL_UPDATE_CHARGES")
	Fire("SPELL_UPDATE_COOLDOWN:" .. PURIFYING_BREW)
	Draw()
	check("a refill fills both nodes and drops the timer", values[Node(1)] == 1 and values[Node(2)] == 1 and bound[Node(1)] == nil)

	local fortifyingCooldown = Duration(300)
	Cast(FORTIFYING_BREW)
	drv.cooldowns[FORTIFYING_BREW] = Reading(true, nil)
	drv.durations[FORTIFYING_BREW] = fortifyingCooldown
	Fire("SPELL_UPDATE_COOLDOWN:" .. FORTIFYING_BREW)
	Draw()
	check("a cooldown fills its own node only", bound[Node(4)] == fortifyingCooldown and bound[Node(3)] == nil and values[Node(5)] == 1)
	drv.cooldowns[FORTIFYING_BREW] = Reading(false)
	drv.durations[FORTIFYING_BREW] = nil
	Fire("SPELL_UPDATE_COOLDOWN:" .. FORTIFYING_BREW)

	-- A Color Indicator aimed at one brew's border colors that brew's nodes alone.
	local indicator = TRB.Data.settings.monk.brewmaster.colors.shared.indicatorColors.invokeNiuzao
	indicator.targets.brewsPurifyingBrewBar = { bar = false, border = true, background = false }
	Cast(INVOKE_NIUZAO)
	Draw()
	check("a Color Indicator on Purifying Brew's border colors its nodes only", borders[Node(1)] == indicator.color and borders[Node(2)] == indicator.color
		and borders[Node(3)] == brewColors.border.color and borders[Node(4)] == brewColors.border.color)
	indicator.targets.brewsPurifyingBrewBar = nil

	BarNode.SetTimerDuration = setTimer
	BarNode.ClearTimerDuration = clearTimer
	BarNode.SetBorderColor = setBorder
	Bar.SetBarNodeValue = setValue

	-- The default bar text: one entry per charge, each anchored to its own node.
	local entries = TRB.Functions.Settings:LoadDefaultBrewsBarTextSettings()
	local anchored = {}
	for _, entry in ipairs(entries) do
		anchored[entry.position.relativeToFrame] = entry.text
	end
	check("the default bar text has an entry per charge", #entries == 8 and anchored.PurifyingBrew_2 == "{$purifyingBrewTime&$purifyingBrewCharges=1}[$purifyingBrewTime]"
		and anchored.FortifyingBrew == "{$fortifyingBrewTime}[$fortifyingBrewTime]")
	local catalog = TRB.Functions.BarText:GetAnchorCatalog(10, 1)
	local offered = 0
	for _, entry in ipairs(catalog.entries) do
		if anchored[entry.frame] ~= nil then
			offered = offered + 1
		end
	end
	check("and the bar text editor offers each of those anchors", offered == 8)

	-- Existing installs: the Brews bar copies the Stagger bar's visibility and waits on the enable prompt.
	try("the enable prompt and the Stagger copy", function()
		local Settings = TRB.Functions.Settings
		local checks = TRB.Data.settings.manualUpdateChecks
		local saved = checks.brewsBarPrompt
		check("a fresh install is seeded as answered", type(saved) == "table" and saved.answered == true and saved.hidden == false)
		local function Shaped(stagger, brews)
			return { monk = { brewmaster = { displayBar = { stagger = stagger, brews = brews } } } }
		end
		local function Stagger(neverShow)
			return { neverShow = neverShow, alwaysShow = false, presetId = "preset-guid", useGlobal = false, smooth = true, conditions = { inCombat = true }, hideConditions = { isDead = true }, fadeDuration = 1.5 }
		end

		checks.brewsBarPrompt = { answered = false }
		check("an unanswered prompt hides the bar by default", Settings:DefaultBrewsBarVisibility().neverShow == true)
		local shaped = Shaped(Stagger(false))
		Settings:PortForwardSettings(shaped)
		local brews = shaped.monk.brewmaster.displayBar.brews
		local stagger = shaped.monk.brewmaster.displayBar.stagger
		check("a profile without the Brews bar copies Stagger's visibility, hidden until answered", type(brews) == "table" and brews ~= stagger
			and brews.neverShow == true and brews.alwaysShow == false and brews.presetId == "preset-guid" and brews.useGlobal == false
			and brews.conditions ~= stagger.conditions and brews.conditions.inCombat == true and brews.hideConditions.isDead == true and brews.fadeDuration == 1.5)
		check("and leaves Stagger's own entry alone", stagger.neverShow == false and stagger.smooth == true)
		check("the copy drops Smooth, which the Brews bar doesn't offer", brews.smooth == false)

		checks.brewsBarPrompt = { answered = true, hidden = false }
		check("a Yes shows the bar by default", Settings:DefaultBrewsBarVisibility().neverShow == false)
		shaped = Shaped(Stagger(false))
		Settings:SeedBrewsBarVisibility(shaped)
		check("after a Yes the copy is shown", shaped.monk.brewmaster.displayBar.brews.neverShow == false)
		shaped = Shaped(Stagger(true))
		Settings:SeedBrewsBarVisibility(shaped)
		check("a Never Show Stagger bar gives a hidden copy", shaped.monk.brewmaster.displayBar.brews.neverShow == true)
		local own = { neverShow = false, alwaysShow = true }
		shaped = Shaped(Stagger(true), own)
		Settings:SeedBrewsBarVisibility(shaped)
		check("a Brews bar with its own entry keeps it", shaped.monk.brewmaster.displayBar.brews == own and own.neverShow == false)
		shaped = { monk = { brewmaster = { displayBar = {} } } }
		Settings:SeedBrewsBarVisibility(shaped)
		check("with no Stagger entry nothing is copied", shaped.monk.brewmaster.displayBar.brews == nil)

		checks.brewsBarPrompt = { answered = true, hidden = true }
		check("a No hides the bar by default", Settings:DefaultBrewsBarVisibility().neverShow == true)

		-- The prompt's answer reaches the live settings and every stored profile.
		local live = Shaped(Stagger(false), { neverShow = false })
		live.profiles = { list = { a = Shaped(Stagger(false)), b = Shaped(Stagger(false), { neverShow = false }), c = { core = {} } } }
		Settings:SetBrewsBarHidden(live, true)
		local a = live.profiles.list.a.monk.brewmaster.displayBar.brews
		check("a No hides the bar in the live settings and every profile", live.monk.brewmaster.displayBar.brews.neverShow == true
			and type(a) == "table" and a.neverShow == true and a.presetId == "preset-guid"
			and live.profiles.list.b.monk.brewmaster.displayBar.brews.neverShow == true and live.profiles.list.c.monk == nil)
		Settings:SetBrewsBarHidden(live, false)
		check("a Yes shows it everywhere, even where Stagger is Never Show", live.monk.brewmaster.displayBar.brews.neverShow == false and a.neverShow == false)
		checks.brewsBarPrompt = saved
	end)

	return errors
end

return hooks
