-- Checks the Forever and TBC Mage's Arcane Blast bar (gate, stacks, timer, nodes, bar text, audio counter, and colors tab),
-- and that every template flavor's Rogue keeps its combo point anchors, counter, and color labels.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
-- Each flavor's rank 1 and top rank, stack cap, duration, and whether a cast restarts the timer.
local ARCANE_BLAST = {
	forever = { first = 400574, top = 1239700, stacks = 4, duration = 18, refresh = false },
	tbc = { first = 30451, top = 30451, stacks = 3, duration = 8, refresh = true },
}
local FROSTBOLT = 116

-- The test clock, the addon's frames, the known spells, the Forever talent, and the options tab groups.
local drv = { now = 1000, frames = {}, known = {}, talent = false, groups = {} }

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
	G.C_SpellBook.IsSpellKnown = function(spellId) return drv.known[spellId] == true end
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	TRB.Functions.News.Init = function() end
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local buildTabGroup = Tabs.BuildTabGroup
	Tabs.BuildTabGroup = function(self, parent, ...)
		local r = buildTabGroup(self, parent, ...)
		drv.groups[#drv.groups + 1] = parent
		return r
	end
	if TRB.Flavor.id == "forever" then
		-- The talent cache reads the Arcane Blast talent from here.
		local readTalentRanks = TRB.Flavor.ReadTalentRanks
		TRB.Flavor.ReadTalentRanks = function()
			local ranks = readTalentRanks()
			if drv.talent then
				ranks[ARCANE_BLAST.forever.first] = { currentRank = 1, maxRank = 1 }
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
	---The active spec's secondary bar text anchors.
	local function Anchors()
		local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
		return descriptor ~= nil and descriptor.barTextAnchorFrames ~= nil and descriptor.barTextAnchorFrames.secondary or nil, descriptor
	end
	---Builds the secondary bar's options tab: how many were built, every section header and color picker label in them,
	---and the same-color checkbox's tooltip.
	local function BuildSecondaryTab()
		local seen, built = {}, 0
		local ColorPickers = TRB.Functions.OptionsUi.ColorPickers
		local Primitives = TRB.Functions.OptionsUi.Primitives
		local buildColor, buildGradient, buildHeader = ColorPickers.BuildColorPicker, ColorPickers.BuildGradientColorPicker, Primitives.BuildSectionHeader
		ColorPickers.BuildColorPicker = function(self, parent, description, ...)
			seen[description] = true
			return buildColor(self, parent, description, ...)
		end
		ColorPickers.BuildGradientColorPicker = function(self, parent, description, ...)
			seen[description] = true
			return buildGradient(self, parent, description, ...)
		end
		Primitives.BuildSectionHeader = function(self, parent, title, ...)
			seen[title] = true
			return buildHeader(self, parent, title, ...)
		end
		local Tabs = TRB.Functions.OptionsUi.Tabs
		for _, parent in ipairs(drv.groups) do
			if parent.tabConstructors ~= nil and parent.tabConstructors.comboPoints ~= nil then
				built = built + 1
				try("the secondary bar's tab", function() Tabs:EnsureTabConstructed(parent, "comboPoints") end)
			end
		end
		ColorPickers.BuildColorPicker, ColorPickers.BuildGradientColorPicker, Primitives.BuildSectionHeader = buildColor, buildGradient, buildHeader
		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.compositeKey]
		local checkbox = controls ~= nil and controls.checkBoxes ~= nil and controls.checkBoxes.sameColorComboPoint or nil
		return built, seen, checkbox ~= nil and checkbox.tooltip or nil
	end

	local data = ARCANE_BLAST[TRB.Flavor.id]
	-- Every template flavor's Rogue reads the shared secondary shape.
	if ctx.classId == 4 and TRB.Flavor.id ~= "mainline" then
		local anchors, descriptor = Anchors()
		check("the Rogue's combo point nodes keep their bar text anchor labels", anchors ~= nil and #anchors == 5
			and anchors[1].label == L["ComboPoint1"] and anchors[5].label == L["ComboPoint5"])
		check("and its Combo Points audio counter", TRB.Functions.AudioCues:GetCounterSource("rogue_general", "comboPoints") ~= nil)
		check("and no talent gate", descriptor ~= nil and descriptor.talentGatedBars == nil and not Bar:IsBarTalentGatedHidden("secondary"))
		local built, seen, tooltip = BuildSecondaryTab()
		check("and its Combo Points tab keeps its color labels", built == 1 and seen[L["ComboPointColorsHeader"]]
			and seen[L["ComboPointColorPickerPenultimate"]] and seen[L["ComboPointColorPickerFinal"]] and seen[L["ComboPointColorPickerBorder"]]
			and seen[L["ComboPointColorPickerBackground"]] and tooltip == L["ComboPointCheckboxUseHighestForAllTooltip"])
		return errors
	end
	if data == nil or ctx.classId ~= 8 then
		check("only a Forever or TBC Mage offers Arcane Blast bar text", not Offers("$arcaneBlastStacks"))
		if ctx.classId == 8 and TRB.Flavor.id == "classic" then
			check("the Classic Mage has no secondary bar", barGroups == nil or barGroups.secondary == nil)
		end
		return errors
	end

	local runtime = (TRB.Flavor.id == "forever" and TRB.Forever or TRB.TBC).Runtime
	---The Arcane Blast snapshot's buff, read fresh after a spec switch.
	local function Buff()
		local spell = TRB.Data.spellsData.spells.arcaneBlast
		local snapshot = spell ~= nil and TRB.Data.snapshotData.snapshots[spell.id] or nil
		return snapshot ~= nil and snapshot.buff or nil
	end
	local buff = Buff()
	local group = barGroups ~= nil and barGroups.secondary or nil
	check("Arcane Blast has a snapshot", buff ~= nil)
	check("the bar text offers $arcaneBlastStacks, $arcaneBlastStacksMax, $arcaneBlastTime, and #arcaneBlast, but not $comboPoints",
		Offers("$arcaneBlastStacks") and Offers("$arcaneBlastStacksMax") and Offers("$arcaneBlastTime") and TRB.Data.lookup["#arcaneBlast"] ~= nil
		and not Offers("$comboPoints"))
	check("the secondary bar has one node per stack", group ~= nil and group.maxNodes == data.stacks)
	if buff == nil or group == nil then
		return errors
	end
	check("it is named the Arcane Blast Bar", Bar:GetSpecResourceBarName("secondary", 8, 1) == string.format(L["ResourceBarName"], L["ResourceMageArcaneBlast"]))
	local settings = TRB.Data.settings.mage.general
	local colors = settings.colors.comboPoints
	check("it starts with Arcane Charges' colors and no charged color", colors.base.color == "FF1A1AFA" and colors.border.color == "FF00AAFF"
		and colors.penultimate.color == "FFFF9900" and colors.final.color == "FFFF0000" and colors.echoingReprimand == nil)
	local anchors = Anchors()
	check("its nodes are bar text anchors", anchors ~= nil and #anchors == data.stacks and anchors[1].label == L["ForeverMageArcaneBlast1"]
		and anchors[data.stacks].frame == "ComboPoint_" .. data.stacks)
	local source = TRB.Functions.AudioCues:GetCounterSource("mage_general", "arcaneBlast")
	check("it has an Arcane Blast Stacks audio counter up to its cap", source ~= nil and source.max == data.stacks and source.label == L["ForeverMageAudioCueSourceArcaneBlast"])
	local seed1, seed2 = settings.audio.arcaneBlastThreshold1, settings.audio.arcaneBlastThreshold2
	check("seeded with two cues, both off, the second at the cap", seed1 ~= nil and seed2 ~= nil and seed1.enabled == false and seed2.enabled == false
		and seed1.source == "arcaneBlast" and seed1.configuration.thresholdValue == 2 and seed2.configuration.thresholdValue == data.stacks)
	local built, seen, tooltip = BuildSecondaryTab()
	check("its colors tab names Arcane Blast stacks, not Combo Points", built == 1 and seen[L["ForeverMageArcaneBlastColorsHeader"]]
		and seen[L["ForeverMageArcaneBlastColorPickerPenultimate"]] and seen[L["ForeverMageArcaneBlastColorPickerFinal"]]
		and seen[L["ForeverMageArcaneBlastColorPickerBorder"]] and seen[L["ForeverMageArcaneBlastColorPickerBackground"]]
		and not seen[L["ComboPointColorsHeader"]] and not seen[L["ComboPointColorPickerPenultimate"]] and not seen[L["ComboPointColorPickerBorder"]]
		and tooltip == string.format(L["ForeverMageArcaneBlastCheckboxUseHighestForAllTooltip"], data.stacks, data.stacks - 1))

	-- The gate: the visibility entry ProcessBars gets for the secondary bar, and the layouts a gate change runs.
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
	local layouts = 0
	local applyLayout = Bar.ApplyBarGroupsLayout
	Bar.ApplyBarGroupsLayout = function(...)
		layouts = layouts + 1
		return applyLayout(...)
	end
	---Runs the runtime template's handlers for an event.
	local function Fire(event, ...)
		local args = { ... }
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("Runtime%.lua$") then
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
	end
	-- Enough passes for the spec switch's nested timers.
	local function Drain()
		for _ = 1, 5 do
			stubs.fireEvents("TRB_DRAIN", ctx.addonName)
		end
	end
	---Takes or drops the Forever talent through the talent change event and the spec switch it runs.
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
		if sourceId == "arcaneBlast" then
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
		for i = 1, data.stacks do
			local value = values[group:GetNode(i)]
			if value == 1 then
				filled = filled + 1
			elseif value ~= 0 then
				return nil
			end
		end
		return filled
	end

	local container = group.containerFrame
	check("not yet available, the bar is hidden and takes no room", Bar:IsBarTalentGatedHidden("secondary") and Shown() == false
		and container:GetHeight() < 0.01)
	Draw()
	local drawnNodes = 0
	for i = 1, data.stacks do
		drawnNodes = drawnNodes + (values[group:GetNode(i)] ~= nil and 1 or 0)
	end
	check("and the update draws none of its nodes and feeds no audio cue", TRB.Data.snapshotData.attributes.isTracking
		and drawnNodes == 0 and counted == nil)
	if TRB.Flavor.id == "forever" then
		-- A talent change's spec switch lays the bars out on its own; the gate adds one more.
		Retalent(false)
		local baseline = layouts
		check("a talent change that leaves Arcane Blast untaken keeps the bar hidden", Shown() == false)
		Retalent(true)
		check("taking the Arcane Blast talent lays the bars out once more and shows it", layouts == baseline + 1 and Shown() == true)
		Retalent(true)
		check("an unchanged talent lays out nothing more", layouts == baseline)
		Retalent(false)
		check("dropping it hides the bar again", layouts == baseline + 1 and Shown() == false)
		drv.known[data.first] = true
		check("knowing the spell without the talent keeps it hidden", Bar:IsBarTalentGatedHidden("secondary"))
		drv.known[data.first] = nil
		Retalent(true)
	else
		drv.known[data.first] = true
		layouts = 0
		Fire("SPELLS_CHANGED")
		check("learning Arcane Blast waits a frame", layouts == 0)
		Drain()
		check("then lays the bars out and shows it", layouts == 1 and Shown() == true)
		layouts = 0
		Fire("SPELLS_CHANGED")
		Drain()
		check("another spellbook change lays nothing out", layouts == 0)
		drv.known[data.first] = nil
		Fire("SPELLS_CHANGED")
		Drain()
		check("unlearning it hides the bar again", layouts == 1 and Shown() == false)
		drv.known[data.first] = true
		Fire("SPELLS_CHANGED")
		Drain()
	end
	check("available, the bar shows", not Bar:IsBarTalentGatedHidden("secondary") and Shown() == true)
	local openWidth, openHeight = container:GetWidth(), container:GetHeight()
	local nodeWidths = {}
	for i = 1, data.stacks do
		nodeWidths[i] = group:GetNode(i):GetFrame():GetWidth()
	end
	try("full layout", function()
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		applyLayout(Bar, sharedSettings, barGroups)
		Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
	end)
	local sameSize = openHeight > 1 and container:GetWidth() == openWidth and container:GetHeight() == openHeight
	for i = 1, data.stacks do
		sameSize = sameSize and group:GetNode(i):GetFrame():GetWidth() == nodeWidths[i]
	end
	check("and gets back the size a full layout gives it", sameSize)
	buff = Buff() --[[@as table]]

	local function Cast(spellId)
		try("SpellCast", function() Class:SpellCast("UNIT_SPELLCAST_SUCCEEDED", spellId, "Cast-0") end)
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

	check("before a cast nothing is tracked", not buff.isActive and not Class:HasActiveTimers()
		and not Class:IsValidVariableForSpec("$arcaneBlastStacks") and not Class:IsValidVariableForSpec("$arcaneBlastTime")
		and Class:IsValidVariableForSpec("$arcaneBlastStacksMax"))
	check("and no node is filled", Draw() == 0 and counted == 0)
	Cast(FROSTBOLT)
	check("another spell adds nothing", not buff.isActive)
	Cast(data.first)
	check("a cast adds a stack for the full duration", buff.isActive and buff.applications == 1 and buff.remaining == data.duration)
	check("and makes its timer and bare checks live", Class:HasActiveTimers() and Class:IsValidVariableForSpec("$arcaneBlastStacks")
		and Class:IsValidVariableForSpec("$arcaneBlastTime"))
	Tick(5)
	Cast(data.top)
	if data.refresh then
		check("the next cast adds a stack and restarts the timer", buff.applications == 2 and buff.remaining == data.duration)
	else
		check("any rank's next cast adds a stack and keeps the first cast's expiry", buff.applications == 2 and buff.remaining == data.duration - 5)
	end
	check("two stacks fill two nodes and feed the audio counter", Draw() == 2 and counted == 2)
	local lookup, lookupLogic = Lookup()
	check("the bar text shows 2 of " .. data.stacks .. " stacks", lookup["$arcaneBlastStacks"] == "2" and lookup["$arcaneBlastStacksMax"] == tostring(data.stacks)
		and lookupLogic["$arcaneBlastStacks"] == 2 and lookupLogic["$arcaneBlastStacksMax"] == data.stacks and lookupLogic["$arcaneBlastTime"] == buff.remaining)
	for _ = 1, data.stacks do
		Cast(data.top)
	end
	check("stacks stop at the cap", buff.applications == data.stacks and Draw() == data.stacks and counted == data.stacks)

	stubs.fireEvents("PLAYER_ENTERING_WORLD", ctx.addonName)
	Drain()
	buff = Buff() --[[@as table]]
	check("a loading screen keeps the stacks, the gate, and the bar's size", buff.isActive and buff.applications == data.stacks
		and not Bar:IsBarTalentGatedHidden("secondary") and Shown() == true and container:GetHeight() == openHeight and Draw() == data.stacks)

	Tick(data.duration)
	check("the stacks end when the timer runs out", not buff.isActive and not Class:HasActiveTimers() and not Class:IsValidVariableForSpec("$arcaneBlastTime"))
	lookup, lookupLogic = Lookup()
	check("and the bar text and nodes drop to 0", lookup["$arcaneBlastStacks"] == "0" and lookupLogic["$arcaneBlastTime"] == 0 and Draw() == 0)

	Cast(data.first)
	Cast(data.first)
	drv.now = drv.now + data.duration + 1
	Cast(data.first)
	check("a cast after the stacks ran out, before a tick, starts over at one", buff.applications == 1 and buff.remaining == data.duration)
	stubs.fireEvents("PLAYER_DEAD", ctx.addonName)
	check("death clears the stacks", not buff.isActive)

	TRB.Functions.BarVisibility.AddEntry = addEntry
	Bar.ApplyBarGroupsLayout = applyLayout
	Bar.SetBarNodeValue = setValue
	TRB.Functions.AudioCues.UpdateCounter = updateCounter
	return errors
end

return hooks
