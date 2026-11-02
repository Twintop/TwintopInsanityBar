-- Checks the Totems bar: slot events, node count, binding each slot once, expiry, and the enable prompt's defaults.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}
-- Slot -> { spellId, duration } for the stubbed totem API; nil is an empty slot.
local occupied = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	desktop.GetTotemInfo = function(slot)
		local totem = occupied[slot]
		if totem == nil then
			return false, "", 0, 0, 0, 1, 0
		end
		return true, "Totem" .. totem.spellId, 100, totem.duration, 136000 + slot, 1, totem.spellId
	end
	desktop.GetTotemDuration = function(slot)
		local totem = occupied[slot]
		if totem == nil then
			return nil
		end
		return {
			slot = slot,
			EvaluateRemainingDuration = function() return { GetRGBA = function() return 1, 0, 0, 1 end } end,
		}
	end
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
	local function Drain(label)
		for i = 1, 20 do
			local _, timerFailures = stubs.fireEvents("TRB_DRAIN_" .. label .. "_" .. i, ctx.addonName)
			if timerFailures == 0 then
				return
			end
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")

	local registry = TRB.Classes.BarTypeRegistry
	local Totems = TRB.Functions.Totems
	local character = TRB.Data.character
	local hasTotems = registry:SpecHasTotems(character.classId, character.specId)

	-- The enable prompt's answer decides the default, for every class. A flavor asks only if some spec's bar is its own tab
	-- and doesn't come with it.
	local prompts = false
	for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		for _, specEntry in ipairs(classEntry.specs) do
			local info = registry:GetTotemSpecInfo(specEntry.classId, specEntry.specId)
			prompts = prompts or (info ~= nil and info.placement == "spec" and not info.builtIn)
		end
	end
	local checks = TRB.Data.settings.manualUpdateChecks
	local saved = checks.totemBarsPrompt
	if prompts then
		check("a fresh install is seeded as answered", type(saved) == "table" and saved.answered == true and saved.hidden == false)
	else
		check("a flavor whose Totems bars all come with their specs never seeds the prompt", saved == nil)
	end
	checks.totemBarsPrompt = { answered = false }
	check("an unanswered prompt hides the bar by default", TRB.Functions.Settings:DefaultTotemBarVisibility().neverShow == true)
	checks.totemBarsPrompt = { answered = true, hidden = true }
	check("a No hides the bar by default", TRB.Functions.Settings:DefaultTotemBarVisibility().neverShow == true)
	checks.totemBarsPrompt = { answered = true, hidden = false }
	check("a Yes shows the bar by default", TRB.Functions.Settings:DefaultTotemBarVisibility().neverShow == false)
	check("the preset never carries Never Show", TRB.Functions.Settings:DefaultTotemBarVisibility(true).neverShow == false)
	checks.totemBarsPrompt = saved

	-- Live's specs can follow Global Options; Forever's and Classic's own the bar outright.
	local hasGlobal = registry:HasGlobalTotems()
	check("only Live has a global Totems bar", hasGlobal == not TRB.Flavor.totemElements)
	local core = TRB.Data.settings.core
	if not hasGlobal then
		check("Global Options holds no Totems bar", core.bars.totems == nil and core.colors.bars.totems == nil and core.displayBar.totems == nil
			and not registry:IsGlobalScopeBar("totems") and not registry:IsBarInScope("totems", nil, nil))
	end

	if not hasTotems then
		local groups = TRB.Frames.barGroups
		check("no Totems bar on a spec without totems", groups == nil or groups.totems == nil)
		occupied[1] = { spellId = 5394, duration = 15 }
		stubs.fireEvents("PLAYER_TOTEM_UPDATE:1", ctx.addonName)
		check("totem slots go unread on a spec without totems", Totems:GetActiveCount() == 0)
		occupied[1] = nil
		print(string.format("DRIVER totems: %d failures", errors))
		return
	end

	local key = character.compositeKey
	TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
	local settings = TRB.Data.specCache[key].settings
	local barGroups = TRB.Frames.barGroups
	TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	local group = barGroups and barGroups.totems
	check("the Totems bar is built", group ~= nil)
	check("a fresh install shows it", settings.displayBar.totems ~= nil and settings.displayBar.totems.neverShow == false)
	local builtIn = registry:IsTotemBarBuiltIn(character.classId, character.specId)
	check("only Forever and Classic Shaman's bar comes with the spec", builtIn == (TRB.Flavor.totemElements == true))
	if builtIn then
		local anchor = settings.bars.totems.anchor
		check("a bar that comes with its spec is Always Show, above the main bar", settings.displayBar.totems.alwaysShow == true
			and anchor.barKey == "primary" and anchor.anchorPoint == "TOP" and anchor.attachPoint == "BOTTOM")
		local primary = barGroups.primary
		check("it lays out at the main bar's width", group ~= nil and primary ~= nil and (group.layoutWidth or 0) > 0
			and math.abs(group.layoutWidth - (primary.layoutWidth or primary.containerFrame:GetWidth())) < 1)
	end
	if not hasGlobal then
		-- A stale Global entry, as unreleased builds left, is never followed.
		local flags = core.global[character.className][character.specName]
		core.displayBar.totems = TRB.Functions.Settings:DefaultTotemBarVisibility()
		core.displayBar.totems.neverShow = true
		flags.displayBar = true
		TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
		local followed = TRB.Data.specCache[key].settings.displayBar.totems
		check("the spec has no Totems Use Global flags and never follows a Global entry", flags.totemsDimensions == nil and flags.totemsColors == nil
			and not TRB.Functions.BarVisibility:IsEntryGlobal("totems", core.displayBar, TRB.Data.settings[character.className][character.specName].displayBar, true)
			and followed ~= nil and followed.neverShow == false)
		core.displayBar.totems = nil
		TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
		settings = TRB.Data.specCache[key].settings
	end
	if group == nil then
		print(string.format("DRIVER totems: %d failures", errors))
		return
	end

	local elements = TRB.Flavor.totemElements
	local bindCounts = {}
	local BarNode = TRB.Classes.BarNode
	local setTimer = BarNode.SetTimerDuration
	BarNode.SetTimerDuration = function(node, durationObject, ...)
		bindCounts[node] = (bindCounts[node] or 0) + 1
		return setTimer(node, durationObject, ...)
	end
	local function Render()
		TRB.Functions.Bar:UpdateTotemBars(barGroups, TRB.Data.snapshotData, settings)
	end
	local function BindsOf(slot)
		for i = 1, group.nodeCount do
			if Totems:GetNodeSlot(i, settings.colors.bars.totems) == slot then
				return bindCounts[group.nodes[i]] or 0
			end
		end
		return -1
	end

	check("an empty bar shows four nodes", group.nodeCount == 4)

	if elements then
		-- Fire and Earth up: Blizzard's order puts Earth first.
		occupied[1] = { spellId = 3599, duration = 30 }
		occupied[2] = { spellId = 2484, duration = 45 }
		stubs.fireEvents("PLAYER_TOTEM_UPDATE:1,PLAYER_TOTEM_UPDATE:2", ctx.addonName)
		Render()
		Render()
		check("an element bar keeps four nodes", group.nodeCount == 4)
		check("Earth leads, in Blizzard's order", Totems:GetNodeSlot(1, settings.colors.bars.totems) == 2 and Totems:GetNodeSlot(2, settings.colors.bars.totems) == 1)
		check("each live slot binds once across two ticks", BindsOf(1) == 1 and BindsOf(2) == 1 and BindsOf(3) == 0)
	else
		occupied[1] = { spellId = 5394, duration = 18 }
		occupied[2] = { spellId = 5394, duration = 18 }
		occupied[5] = { spellId = 192077, duration = 18 }
		stubs.fireEvents("PLAYER_TOTEM_UPDATE:1,PLAYER_TOTEM_UPDATE:2,PLAYER_TOTEM_UPDATE:5", ctx.addonName)
		check("the slots read as active", Totems:GetActiveCount() == 3)
		Render()
		Render()
		check("the bar grows to the highest active slot", group.nodeCount == 5)
		check("each live slot binds once across two ticks", BindsOf(1) == 1 and BindsOf(2) == 1 and BindsOf(5) == 1 and BindsOf(3) == 0)
		check("the layout keeps the bar's width", group.layoutWidth == settings.bars.totems.width)

		-- An extension refires the slot's update; its re-fetched object rebinds.
		stubs.fireEvents("PLAYER_TOTEM_UPDATE:2", ctx.addonName)
		Render()
		check("an update rebinds its slot", BindsOf(2) == 2 and BindsOf(1) == 1)

		occupied[5] = nil
		stubs.fireEvents("PLAYER_TOTEM_UPDATE:5", ctx.addonName)
		Render()
		check("the bar shrinks back when the highest slot empties", group.nodeCount == 4 and Totems:GetActiveCount() == 2)

		settings.bars.totems.showAllSlots = true
		Render()
		check("Show all totem slots shows every slot", group.nodeCount == Totems:GetSlotCount())
		settings.bars.totems.showAllSlots = false
		Render()
	end

	-- The icon option toggles through a layout pass, which wipes the color caches an icon's rebuilt backdrop reads.
	local function IconStates()
		local shown, uncolored = 0, 0
		for i = 1, group.nodeCount do
			local node = group.nodes[i]
			if node.icon ~= nil and node.icon:IsShown() then
				shown = shown + 1
				if node._iconBorderR == nil or node._iconBackgroundR == nil then
					uncolored = uncolored + 1
				end
			end
		end
		return shown, uncolored
	end
	local iconSettings = settings.bars.totems.icon
	iconSettings.enabled = false
	TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	Render()
	local shownOff = IconStates()
	check("turning the icon off hides every icon", shownOff == 0)
	iconSettings.enabled = true
	TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	Render()
	local shownOn, uncolored = IconStates()
	check("turning the icon on shows every node's icon in the bar's colors, not white", shownOn == group.nodeCount and uncolored == 0)

	-- Show tooltip on hover gives each icon the totem tooltip of its node's slot, and nothing over an empty slot.
	iconSettings.showTooltip = true
	TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	local tooltipSlot = nil
	local tooltip = desktop.GameTooltip
	local setTotem = tooltip.SetTotem
	tooltip.SetTotem = function(_, slot) tooltipSlot = slot end
	local liveIcon, emptyIcon = group.nodes[1].icon, group.nodes[group.nodeCount].icon
	liveIcon:GetScript("OnEnter")(liveIcon)
	local liveSlot = tooltipSlot
	tooltipSlot = nil
	emptyIcon:GetScript("OnEnter")(emptyIcon)
	tooltip.SetTotem = setTotem
	check("an icon's hover shows its node's totem, and none over an empty slot", liveSlot == Totems:GetNodeSlot(1, settings.colors.bars.totems) and tooltipSlot == nil)
	iconSettings.showTooltip = false
	TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	check("turning the tooltip off clears it", group.nodes[1].icon.tooltipProvider == nil)

	-- The visibility context follows the slots.
	local context = TRB.Classes.BarVisibilityContext:NewFromGameState(false, nil)
	check("a totem up reads as Totem Active", context.isTotemActive == true and context.isTotemMissing == false)
	for slot in pairs(occupied) do
		occupied[slot] = nil
	end
	for slot = 1, Totems:GetSlotCount() do
		stubs.fireEvents("PLAYER_TOTEM_UPDATE:" .. slot, ctx.addonName)
	end
	context = TRB.Classes.BarVisibilityContext:NewFromGameState(false, nil)
	check("no totem reads as No Totem", context.isTotemActive == false and context.isTotemMissing == true)

	-- Yes and No reach every spec the prompt asks for, and Global Options where it has the bar; a built-in bar keeps showing.
	TRB.Functions.Totems:SetBarsHidden(TRB.Data.settings, true)
	local coreEntry = TRB.Data.settings.core.displayBar.totems
	local allHidden = hasGlobal and (coreEntry ~= nil and coreEntry.neverShow == true) or (not hasGlobal and coreEntry == nil)
	for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		for _, specEntry in ipairs(classEntry.specs) do
			local spec = TRB.Data.settings[classEntry.className] and TRB.Data.settings[classEntry.className][specEntry.specName]
			if registry:SpecHasTotems(specEntry.classId, specEntry.specId) and spec ~= nil and spec.displayBar ~= nil then
				local hiddenHere = spec.displayBar.totems ~= nil and spec.displayBar.totems.neverShow == true
				allHidden = allHidden and (hiddenHere ~= registry:IsTotemBarBuiltIn(specEntry.classId, specEntry.specId))
			end
		end
	end
	check("a No hides the bar on every spec the prompt asks for, never a built-in one, and in Global Options only where it has one", allHidden)
	TRB.Functions.Totems:SetBarsHidden(TRB.Data.settings, false)
	local shownAgain = TRB.Data.settings[character.className][character.specName].displayBar.totems.neverShow == false
	if hasGlobal then
		shownAgain = shownAgain and TRB.Data.settings.core.displayBar.totems.neverShow == false
	end
	check("a Yes shows it again", shownAgain)

	BarNode.SetTimerDuration = setTimer
	print(string.format("DRIVER totems: %d failures", errors))
end

return hooks
