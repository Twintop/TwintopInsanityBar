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
			GetRemainingDuration = function() return totem.duration - 0.5 end,
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

	local BarText = TRB.Functions.BarText
	local function HasAnchor(catalog, frame)
		for _, entry in ipairs(catalog.entries) do
			if entry.frame == frame then
				return true
			end
		end
		return false
	end
	local slotOneEntry = { position = { relativeToFrame = "TotemSlot1" } }
	-- Live's specs can follow Global Options; Forever's and Classic's own the bar outright.
	local hasGlobal = registry:HasGlobalTotems()
	check("only Live has a global Totems bar", hasGlobal == not TRB.Flavor.totemElements)
	check("Global Options offers the totem slot anchors only with a global scope", HasAnchor(BarText:GetAnchorCatalog(nil, nil), "TotemSlot1") == hasGlobal)
	local core = TRB.Data.settings.core
	if not hasGlobal then
		check("Global Options holds no Totems bar", core.bars.totems == nil and core.colors.bars.totems == nil and core.displayBar.totems == nil
			and not registry:IsGlobalScopeBar("totems") and not registry:IsBarInScope("totems", nil, nil))
	end

	if not hasTotems then
		local groups = TRB.Frames.barGroups
		check("no Totems bar on a spec without totems", groups == nil or groups.totems == nil)
		check("no totem slot anchors on a spec without totems", not HasAnchor(BarText:GetAnchorCatalog(character.classId, character.specId), "TotemSlot1"))
		check("totem slot text stays off a spec without totems", not BarText:IsEntryInScope(slotOneEntry, character.classId, character.specId))
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
	local optIn = registry:GetTotemPlacement(character.classId, character.specId) == "otherBars"
	local savedEntry = TRB.Data.settings[character.className][character.specName].displayBar.totems
	if optIn then
		check("an Other Bars spec starts Never Show on its own settings", settings.displayBar.totems ~= nil and settings.displayBar.totems.neverShow == true
			and savedEntry ~= nil and savedEntry.useGlobal == false)
		-- The checks below draw the bar.
		settings.displayBar.totems.neverShow = false
	else
		check("a fresh install shows it", settings.displayBar.totems ~= nil and settings.displayBar.totems.neverShow == false)
	end
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
	-- Bar text anchors before the bar's first render, so the slot's node can't come from one.
	check("a slot's node is known before any render", Totems:GetSlotNodeIndex(2) == (elements and 1 or 2))

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

	-- A Color Indicator's border and background reach every node, and the bar's own colors return once it ends.
	local resolved = TRB.Data.resolvedIndicators
	local function NodeColors(cacheKey, colorString)
		for i = 1, group.nodeCount do
			local node = group.nodes[i]
			local entry = TRB.Data.cache.colors[cacheKey][cacheKey == "border" and node.borderKey or node.backgroundKey]
			if entry == nil or entry.source ~= colorString then
				return false
			end
		end
		return true
	end
	resolved.compositeKey = character.compositeKey
	resolved.totemsBar.border = "FFFF0000"
	resolved.totemsBar.background = "FF00FF00"
	Render()
	check("an indicator recolors every node's border and background", NodeColors("border", "FFFF0000") and NodeColors("backdrop", "FF00FF00"))
	wipe(resolved.totemsBar)
	Render()
	local barColors = settings.colors.bars.totems
	check("the bar's own colors return when it ends", NodeColors("border", barColors.border.color) and NodeColors("backdrop", barColors.background.color))

	-- Bar text: each slot's variables, their bare checks, and the anchor on the node showing the slot.
	check("totem slot anchors are offered on a spec with totems", HasAnchor(BarText:GetAnchorCatalog(character.classId, character.specId), "TotemSlot1"))
	-- Its rows list on the spec's Totems tab, or Other Bars where the spec puts it, and never on the spec's own tabs.
	local home = optIn and "otherBars" or "totems"
	local classId, specId = character.classId, character.specId
	check("the Totems bar groups by the spec's placement, and as Totems on Global Options", registry:GetBarGroup("totems") == "totems"
		and registry:GetBarGroup("totems", classId, specId) == home and registry:IsBarInGroupScope("totems", home, false, classId, specId)
		and not registry:IsBarInGroupScope("totems", "spec", false, classId, specId))
	check("totem slot text lists under that grouping", BarText:GetAnchorCatalog(classId, specId).groupByFrame["TotemSlot1"] == home)
	check("totem slot text is in scope on a spec with totems", BarText:IsEntryInScope(slotOneEntry, character.classId, character.specId))
	BarText:RefreshTotemLookupData()
	local lookup = TRB.Data.lookup
	local firstSlot = elements and 2 or 1
	local emptySlot = 3
	local listedName = BarText:GetTotemSlotVariables(firstSlot).names[1]
	check("a live slot's name, time, and icon fill", lookup["$totem" .. firstSlot .. "Name"] == "Totem" .. occupied[firstSlot].spellId
		and (lookup["$totem" .. firstSlot .. "Time"] or "") ~= "" and (lookup["#totem" .. firstSlot] or ""):find("|T", 1, true) ~= nil)
	check("an empty slot's variables are blank", lookup["$totem" .. emptySlot .. "Name"] == "" and lookup["$totem" .. emptySlot .. "Time"] == "")
	check("the listed name and the slot alias agree", lookup[listedName] == lookup["$totem" .. firstSlot .. "Name"])
	if elements then
		check("Forever and Classic list the element names", listedName == "$earthTotemName")
	else
		check("Live lists the slot names", listedName == "$totem1Name")
	end
	local function Declares(section, var)
		for _, entry in ipairs(TRB.Data.barTextVariables[section] or {}) do
			if entry.variable == var then
				return entry.totem == true
			end
		end
		return false
	end
	check("the spec's bar text parses the totem variables", Declares("values", listedName) and Declares("values", "$totem" .. firstSlot .. "Time")
		and Declares("icons", BarText:GetTotemSlotVariables(firstSlot).icons[1]))
	check("a bare check follows the slot", BarText:IsValidVariableBase("$totem" .. firstSlot .. "Time") == true and BarText:IsValidVariableBase("$totem" .. emptySlot .. "Time") == false)
	local anchorFrame, anchorKnown = BarText:GetAnchorFrame("TotemSlot" .. firstSlot)
	local expectedNode = group.nodes[Totems:GetSlotNodeIndex(firstSlot)]
	check("a slot's anchor is the node showing it", anchorKnown == true and anchorFrame ~= nil and anchorFrame == expectedNode.frame
		and (not elements or Totems:GetSlotNodeIndex(firstSlot) == 1))

	-- Default text lives in the global list, or the spec's own without a global scope; seeded once, and a deleted entry
	-- stays deleted.
	local specText = TRB.Data.settings[character.className][character.specName].displayText
	local textHome = hasGlobal and core.displayText or specText
	local migrations = core.displayText.migrations
	local seedFlag = hasGlobal and "totemBarText" or "totemSpecBarText"
	local function CountTotemText(list)
		local count = 0
		for _, entry in ipairs(list) do
			if entry.position ~= nil and BarText:GetAnchorBarKey(entry.position.relativeToFrame) == "totems" then
				count = count + 1
			end
		end
		return count
	end
	local expected = Totems:GetSlotCount() * 2
	check("a fresh install has a name and a time on every slot", CountTotemText(textHome.barText) == expected and migrations[seedFlag] == true)
	if not hasGlobal then
		check("a fresh install's global list has no totem text", CountTotemText(core.displayText.barText) == 0)
	end
	local kept = {}
	for _, entry in ipairs(textHome.barText) do
		if entry.position == nil or BarText:GetAnchorBarKey(entry.position.relativeToFrame) ~= "totems" then
			kept[#kept + 1] = entry
		end
	end
	local savedText = textHome.barText
	local savedCoreText = core.displayText.barText
	textHome.barText = kept
	TRB.Functions.Settings:SeedTotemBarsText(TRB.Data.settings)
	check("a deleted entry stays deleted once seeded", CountTotemText(textHome.barText) == 0)
	migrations[seedFlag] = nil
	if not hasGlobal then
		-- Unreleased builds seeded the global list; the spec seed takes those back out.
		core.displayText.barText = {}
		TRB.Functions.Settings:AppendTotemBarText(core.displayText.barText)
	end
	TRB.Functions.Settings:SeedTotemBarsText(TRB.Data.settings)
	check("an existing save gets the text once", CountTotemText(textHome.barText) == expected and migrations[seedFlag] == true)
	if not hasGlobal then
		check("the spec seed clears totem text from the global list", CountTotemText(core.displayText.barText) == 0)
	end
	textHome.barText = savedText
	core.displayText.barText = savedCoreText

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
			if registry:GetTotemPlacement(specEntry.classId, specEntry.specId) == "spec" and spec ~= nil and spec.displayBar ~= nil then
				local hiddenHere = spec.displayBar.totems ~= nil and spec.displayBar.totems.neverShow == true
				allHidden = allHidden and (hiddenHere ~= registry:IsTotemBarBuiltIn(specEntry.classId, specEntry.specId))
			end
		end
	end
	check("a No hides the bar on every spec the prompt asks for, never a built-in one, and in Global Options only where it has one", allHidden)
	TRB.Functions.Totems:SetBarsHidden(TRB.Data.settings, false)
	local shownAgain = TRB.Data.settings[character.className][character.specName].displayBar.totems.neverShow == false or optIn
	if hasGlobal then
		shownAgain = shownAgain and TRB.Data.settings.core.displayBar.totems.neverShow == false
	end
	check("a Yes shows it again", shownAgain)
	if optIn then
		check("the answer leaves an Other Bars spec at Never Show", savedEntry.neverShow == true)
	end

	BarNode.SetTimerDuration = setTimer
	print(string.format("DRIVER totems: %d failures", errors))
end

return hooks
