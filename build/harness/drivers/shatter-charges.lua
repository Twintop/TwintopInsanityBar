-- Checks the Live Frost Mage Shatter bar's Ice Lance charges: nodes by Polished Focus, full charge and custom indicator
-- gates, plain and secret counts, custom threshold lines, the options checkbox, and the stack view coming back.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
local SHATTER, POLISHED_FOCUS = 1246769, 1261082
-- A string, so the bar text's format of the count still runs.
local SECRET = "\1secretShatterStacks"

-- The test clock, the Shatter count the Cooldown Manager reports (nil when untracked), and the options tab groups.
local drv = { now = 1000, stacks = nil, groups = {} }

function hooks.afterInstall(ctx)
	-- Frost for a Mage only: another class's third specialization may not finish its deferred setup in the stubs.
	parity.Install(ctx, { spec = ctx.classId == 8 and 3 or 1, holdDeferredSetup = true })
	local G = desktop
	G.GetTime = function() return drv.now end
	G.UnitPartialPower = function() return 0 end
	local innerIsSecret = G.issecretvalue
	G.issecretvalue = function(value)
		return value == SECRET or (innerIsSecret ~= nil and innerIsSecret(value)) or false
	end
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
	if TRB.Flavor.id ~= "mainline" or ctx.classId ~= 8 then
		check("only a Live Frost Mage has the Shatter bar", barGroups == nil or barGroups.shatter == nil)
		return errors
	end

	local Class = TRB.Functions.Class
	local Bar = TRB.Functions.Bar
	local BarNode = TRB.Classes.BarNode
	local OverlaySlot = TRB.Classes.OverlaySlot
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "frost")
	local cache = TRB.Data.specCache.mage_frost
	local settings = cache.settings
	local group = barGroups.shatter
	local shatterSettings = settings.bars.shatter
	local shatterColors = settings.colors.bars.shatter
	check("the Shatter bar is built, with Ice Lance charges off by default", group ~= nil and shatterSettings ~= nil
		and shatterSettings.chargeView == false and shatterColors ~= nil)
	if group == nil or shatterSettings == nil or shatterColors == nil then
		return errors
	end

	-- Node ranges, sizes, values, and the gates each charge's overlay slot opens.
	local ranges, values, valueMaxes, gateThresholds, gateValues = {}, {}, {}, {}, {}
	local setMinMax = BarNode.SetMinMax
	BarNode.SetMinMax = function(node, min, max)
		ranges[node] = { min, max }
		return setMinMax(node, min, max)
	end
	local setValue = Bar.SetBarNodeValue
	Bar.SetBarNodeValue = function(self, nodeSettings, key, node, value, maxResource)
		values[node] = value
		valueMaxes[node] = maxResource
		return setValue(self, nodeSettings, key, node, value, maxResource)
	end
	local setThreshold = OverlaySlot.SetRangeOverlayThreshold
	OverlaySlot.SetRangeOverlayThreshold = function(slot, index, threshold)
		gateThresholds[slot] = gateThresholds[slot] or {}
		gateThresholds[slot][index] = threshold
		return setThreshold(slot, index, threshold)
	end
	local setGateValue = OverlaySlot.SetRangeOverlayValue
	OverlaySlot.SetRangeOverlayValue = function(slot, index, value)
		gateValues[slot] = gateValues[slot] or {}
		gateValues[slot][index] = value
		return setGateValue(slot, index, value)
	end
	local hideResourceBar = Bar.HideResourceBar
	Bar.HideResourceBar = function(self, ...)
		local r = hideResourceBar(self, ...)
		TRB.Data.snapshotData.attributes.isTracking = true
		return r
	end
	local cdm = TRB.Functions.CooldownManager
	local resolve, read = cdm.ResolveTrackedSpellId, cdm.Read
	cdm.ResolveTrackedSpellId = function(self, sourceGroup, spellId, ...)
		if spellId == SHATTER and drv.stacks ~= nil then
			return SHATTER
		end
		return resolve(self, sourceGroup, spellId, ...)
	end
	cdm.Read = function(self, trackedId, signal, sourceGroup, ...)
		if trackedId == SHATTER and drv.stacks ~= nil then
			return true, drv.stacks
		end
		return read(self, trackedId, signal, sourceGroup, ...)
	end

	local function Layout()
		try("layout", function() Bar:ApplyBarGroupsLayout(settings, barGroups) end)
	end
	local function Remap()
		try("CheckCharacter", function() Class:CheckCharacter() end)
	end
	local function Draw()
		-- Past the render transition a layout starts.
		drv.now = drv.now + 1
		try("draw", function() triggerUpdates() end)
	end
	local function Node(index)
		return group:GetNode(index)
	end
	local function Range(index, min, max)
		local r = ranges[Node(index)]
		return r ~= nil and r[1] == min and r[2] == max
	end
	local function Bounds(...)
		local expected = { ... }
		local bounds = group.nodeBounds
		if bounds == nil or #bounds ~= #expected then
			return false
		end
		for i = 1, #expected do
			if bounds[i] ~= expected[i] then
				return false
			end
		end
		return true
	end
	local function Near(a, b)
		return a ~= nil and b ~= nil and math.abs(a - b) < 0.001
	end
	---The thresholds of the gates a charge shows, in paint order, and their colors.
	local function Gates(index)
		local slot = Node(index):GetOverlaySlot("shatterCharge")
		local shown, colors = {}, {}
		if slot ~= nil and slot.rangeOverlayFrames ~= nil then
			for i = 1, #slot.rangeOverlayFrames do
				if slot.rangeOverlayFrames[i]:IsShown() then
					shown[#shown + 1] = gateThresholds[slot] and gateThresholds[slot][i]
					colors[#colors + 1] = slot.rangeColors[i]
				end
			end
		end
		return shown, colors, slot
	end
	local function List(t)
		local parts = {}
		for i = 1, #t do
			parts[i] = tostring(t[i])
		end
		return table.concat(parts, ",")
	end

	Layout()
	check("the stack view has a node per stack, each one stack wide", group.nodeCount == 20 and group.nodeBounds == nil
		and Range(1, 0, 1) and Range(7, 6, 7) and Range(20, 19, 20))

	shatterSettings.chargeView = true
	Layout()
	check("Ice Lance charges take 5 stacks each without Polished Focus", group.nodeCount == 4 and Bounds(0, 5, 10, 15, 20)
		and Range(1, 0, 5) and Range(2, 5, 10) and Range(4, 15, 20))
	check("equal charges are equally wide", Near(Node(1).width, Node(4).width) and Near(Node(2).width, Node(3).width))
	check("the nodes past the charges hide", not Node(5):GetFrame():IsShown() and not Node(20):GetFrame():IsShown())

	cache.talents.talents[POLISHED_FOCUS] = TRB.Classes.Talent:New(POLISHED_FOCUS, 1, 1)
	Remap()
	check("Polished Focus makes it 6 stacks each, the last charge holding the 2 left over", TRB.Data.character.shatterStackThreshold == 6
		and group.nodeCount == 4 and Bounds(0, 6, 12, 18, 20) and Range(3, 12, 18) and Range(4, 18, 20))
	check("the last charge is a third as wide", Near(Node(1).width, Node(3).width) and Near(Node(4).width * 3, Node(1).width))

	drv.stacks = 15
	Draw()
	check("each charge takes the count at its own scale", values[Node(1)] == 15 and valueMaxes[Node(1)] == 6
		and valueMaxes[Node(3)] == 18 and valueMaxes[Node(4)] == 20)
	local gates1, colors1, slot1 = Gates(1)
	local gates4 = Gates(4)
	check("a full Ice Lance gates on its last stack in the full charge color", List(gates1) == "6" and colors1[1] == shatterColors.threshold
		and List(Gates(2)) == "12" and List(Gates(3)) == "18")
	check("the 18-20 charge is no full Ice Lance, so it gets no full charge color", #gates4 == 0)
	check("the gates read the count", slot1 ~= nil and gateValues[slot1] ~= nil and gateValues[slot1][1] == 15)

	local indicator1, indicator2 = shatterColors.customIndicators[1], shatterColors.customIndicators[2]
	local savedModes = { indicator1.mode, indicator2.mode, indicator1.value, indicator2.value }
	indicator1.mode, indicator1.value = "enabled", 12
	Draw()
	local gates2, colors2 = Gates(2)
	check("a custom indicator on a charge's last stack replaces its full charge color", List(gates2) == "12" and colors2[1] == indicator1)
	indicator2.mode, indicator2.value = "enabled", 9
	Draw()
	gates2, colors2 = Gates(2)
	check("custom indicators in one charge gate in stack order, with no full charge color", List(gates2) == "9,12"
		and colors2[1] == indicator2 and colors2[2] == indicator1)
	check("charges without a custom indicator keep their full charge color", List(Gates(1)) == "6" and List(Gates(3)) == "18")
	indicator1.mode, indicator2.mode, indicator1.value, indicator2.value = savedModes[1], savedModes[2], savedModes[3], savedModes[4]

	shatterColors.threshold.enabled = false
	Draw()
	check("with Change Shatter color at Ice Lance stacks off, no charge gates", #Gates(1) == 0 and #Gates(2) == 0 and #Gates(3) == 0)
	shatterColors.threshold.enabled = true

	drv.stacks = SECRET
	Draw()
	local _, _, secretSlot = Gates(2)
	check("a secret count goes straight to the nodes and the gates", values[Node(2)] == SECRET
		and secretSlot ~= nil and gateValues[secretSlot][1] == SECRET)
	drv.stacks = 15

	-- Custom threshold lines sit at their stack inside its charge.
	local positions = {}
	local Threshold = TRB.Functions.Threshold
	local reposition = Threshold.RepositionThresholdCustomBar
	Threshold.RepositionThresholdCustomBar = function(self, frameKey, threshold, show, parentFrame, positionValue, positionMax, ...)
		positions[frameKey] = { parentFrame = parentFrame, value = positionValue, max = positionMax }
		return reposition(self, frameKey, threshold, show, parentFrame, positionValue, positionMax, ...)
	end
	local lines = {}
	settings.thresholds.customThresholds = settings.thresholds.customThresholds or {}
	for _, stack in ipairs({ 9, 12, 19 }) do
		local guid = "trbDriverShatter" .. stack
		local dictionaryKey = TRB.Functions.Settings:GetCustomThresholdDictionaryKey(guid)
		settings.thresholds.customThresholds[guid] = TRB.Functions.Settings:NormalizeCustomThresholdLine({ guid = guid, name = "Driver", barTarget = "shatter",
			value = stack, iconSourceType = "none", iconSourceId = 0 }, guid)
		settings.thresholds.thresholdDictionary[dictionaryKey] = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(true)
		lines[stack] = { guid = guid, dictionaryKey = dictionaryKey }
	end
	try("custom threshold lines", function() Threshold:UpdateCustomThresholdLines(settings, barGroups) end)
	local function LineAt(stack, nodeIndex, fraction)
		for frameKey, position in pairs(positions) do
			if frameKey:find(lines[stack].dictionaryKey, 1, true) then
				return position.parentFrame == Node(nodeIndex):GetFrame() and Near(position.value, fraction) and position.max == 1
			end
		end
		return false
	end
	check("a line at 9 stacks sits halfway through the second charge", LineAt(9, 2, 0.5))
	check("a line at 12 stacks sits at the end of the second charge", LineAt(12, 2, 1))
	check("a line at 19 stacks sits halfway through the 18-20 charge", LineAt(19, 4, 0.5))
	for _, line in pairs(lines) do
		settings.thresholds.customThresholds[line.guid] = nil
		settings.thresholds.thresholdDictionary[line.dictionaryKey] = nil
	end
	Threshold.RepositionThresholdCustomBar = reposition

	shatterSettings.chargeView = false
	Layout()
	Draw()
	local _, _, offSlot = Gates(1)
	check("turning it off brings back a node per stack", group.nodeCount == 20 and group.nodeBounds == nil
		and Range(1, 0, 1) and Range(4, 3, 4) and Near(Node(1).width, Node(4).width))
	check("and takes the charge gates down", offSlot ~= nil and #Gates(1) == 0 and #Gates(2) == 0
		and not offSlot.rangeOverlayFrames[offSlot:GetRangeBaselineIndex()]:IsShown())
	check("the stack view passes the count unscaled, as before", values[Node(7)] == 15 and valueMaxes[Node(7)] == nil)

	-- The options checkbox writes the setting and redraws the live bar.
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local Primitives = TRB.Functions.OptionsUi.Primitives
	local ColorPickers = TRB.Functions.OptionsUi.ColorPickers
	-- The stub frames report no anchors, so the rows are read from what each builder is given.
	local buildCheckboxRow, buildGradient = Primitives.BuildCheckboxRow, ColorPickers.BuildGradientColorPicker
	local checkboxY, barColorY = nil, nil
	Primitives.BuildCheckboxRow = function(self, parent, name, label, tooltip, y, ...)
		if name == "TwintopResourceBar_Mage_Frost_shatterChargeView" then
			checkboxY = y
		end
		return buildCheckboxRow(self, parent, name, label, tooltip, y, ...)
	end
	ColorPickers.BuildGradientColorPicker = function(self, parent, description, colorTable, textWidth, frameSize, x, y, ...)
		if colorTable == TRB.Data.settings.mage.frost.colors.bars.shatter.bar then
			barColorY = y
		end
		return buildGradient(self, parent, description, colorTable, textWidth, frameSize, x, y, ...)
	end
	local built = 0
	for _, parent in ipairs(drv.groups) do
		if parent.tabConstructors ~= nil and parent.tabConstructors.shatterBar ~= nil then
			built = built + 1
			try("the Shatter tab", function() Tabs:EnsureTabConstructed(parent, "shatterBar") end)
		end
	end
	Primitives.BuildCheckboxRow, ColorPickers.BuildGradientColorPicker = buildCheckboxRow, buildGradient
	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mage_frost
	local checkbox = controls ~= nil and controls.checkBoxes ~= nil and controls.checkBoxes.shatterChargeView or nil
	check("the Shatter tab has the Show Ice Lance charges checkbox", built > 0 and checkbox ~= nil
		and checkbox.tooltip == TRB.Localization["MageFrostCheckboxShatterChargeViewTooltip"])
	check("it shares the Shatter bar color's row", checkboxY ~= nil and checkboxY == barColorY)
	if checkbox ~= nil then
		local checked = true
		checkbox.GetChecked = function() return checked end
		try("checking it", function() checkbox.__scripts.OnClick(checkbox) end)
		check("checking it turns on Ice Lance charges on the live bar", TRB.Data.settings.mage.frost.bars.shatter.chargeView == true
			and group.nodeCount == 4 and Bounds(0, 6, 12, 18, 20))
		checked = false
		try("unchecking it", function() checkbox.__scripts.OnClick(checkbox) end)
		check("unchecking it brings the stacks back", TRB.Data.settings.mage.frost.bars.shatter.chargeView == false
			and group.nodeCount == 20)
	end

	return errors
end

return hooks
