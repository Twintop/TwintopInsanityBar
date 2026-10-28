-- Checks Classic's Overcap indicators: flat rows in the priority list (moved there from a save's gradient list), on at the
-- threshold in combat, the text's overcap color, and no color curves; other flavors keep their gradient Overcap.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
-- Power by power type, the colors each node was last painted, the curves built, and the indicator panel's config.
local drv = { power = {}, maxPower = 100, stealthed = false, painted = {}, curves = 0, panelConfigs = {}, groups = {} }

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	G.UnitPower = function(_, powerType) return drv.power[powerType] or 0 end
	G.UnitPowerMax = function() return drv.maxPower end
	G.IsStealthed = function() return drv.stealthed end
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	local Color = TRB.Functions.Color
	local applyNodeColors = Color.ApplyNodeColors
	Color.ApplyNodeColors = function(self, node, colors)
		drv.painted[node] = { border = colors.border, background = colors.background }
		return applyNodeColors(self, node, colors)
	end
	local buildCurve = Color.BuildResourceThresholdCurve
	Color.BuildResourceThresholdCurve = function(...)
		drv.curves = drv.curves + 1
		return buildCurve(...)
	end
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local buildTabGroup = Tabs.BuildTabGroup
	Tabs.BuildTabGroup = function(self, parent, ...)
		local r = buildTabGroup(self, parent, ...)
		drv.groups[#drv.groups + 1] = parent
		return r
	end
	local Indicators = TRB.Functions.OptionsUi.Indicators
	local generate = Indicators.GenerateIndicatorColorsPanel
	Indicators.GenerateIndicatorColorsPanel = function(self, parent, controls, spec, classId, specId, yCoord, config)
		drv.panelConfigs[#drv.panelConfigs + 1] = config
		return generate(self, parent, controls, spec, classId, specId, yCoord, config)
	end
	TRB.Functions.News.Init = function() end
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
		return ok
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
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")
	-- The login's render transition runs on the stubs' wall clock and would skip the draws below.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end

	local spec = TRB.Functions.Character:GetActiveRawSpecSettings()
	if spec == nil then
		check("the played spec's settings are found", false)
		return errors
	end
	local shared = spec.colors.shared

	-- The Overcap indicators this class has: the template's one on its resource bar, or a Druid's one per form bar.
	local Enum = desktop.Enum
	local overcaps = {}
	if shared.indicatorColors.borderOvercap ~= nil then
		local barGroups = TRB.Frames.barGroups
		local variables = { [Enum.PowerType.Rage] = "$rage", [Enum.PowerType.Energy] = "$energy" }
		overcaps[1] = { key = "borderOvercap", node = barGroups.primary:GetNode(1), baseBorder = spec.colors.bar.border.color,
			powerType = TRB.Data.resource, textColor = spec.colors.text.overcap, variable = variables[TRB.Data.resource] }
	end
	if shared.indicatorColors.rageOvercap ~= nil then
		for _, form in ipairs({ { key = "rage", powerType = Enum.PowerType.Rage }, { key = "energy", powerType = Enum.PowerType.Energy } }) do
			spec.displayBar[form.key].neverShow = false
			local group = TRB.Frames.barGroups[form.key]
			overcaps[#overcaps + 1] = { key = form.key .. "Overcap", node = group ~= nil and group:GetNode(1) or nil, baseBorder = spec.colors.bars[form.key].border.color,
				powerType = form.powerType, textColor = spec.colors.text[form.key .. "Overcap"], variable = "$" .. form.key, stealthPauses = form.key == "energy" }
		end
	end

	if TRB.Flavor.secretValues then
		-- Other flavors keep Overcap as a gradient indicator.
		local inGradient = false
		for _, key in ipairs(shared.gradientOrder or {}) do
			if key == "borderOvercap" or key == "rageOvercap" or key == "energyOvercap" then inGradient = true end
		end
		check("Overcap stays a gradient indicator where values can be secret", #overcaps == 0 or inGradient)
		return errors
	end
	if #overcaps == 0 then
		check("a class without an overcapping resource has no Overcap indicator", true)
		return errors
	end

	local function InList(list, key)
		for _, k in ipairs(list or {}) do
			if k == key then return true end
		end
		return false
	end
	for _, overcap in ipairs(overcaps) do
		check(overcap.key .. " is in the priority list, not the gradient list", InList(shared.nodeOrder, overcap.key) and not InList(shared.gradientOrder, overcap.key)
			and not shared.indicatorColors[overcap.key].isGradient)
	end

	-- A save from before keeps Overcap in its gradient list, flagged as a gradient; the load's reconcile moves it.
	do
		local key = overcaps[1].key
		for i = #shared.nodeOrder, 1, -1 do
			if shared.nodeOrder[i] == key then table.remove(shared.nodeOrder, i) end
		end
		shared.gradientOrder[#shared.gradientOrder + 1] = key
		shared.indicatorColors[key].isGradient = true
		try("reconcile", function() TRB.Functions.Settings:ReconcileAllSharedIndicators(TRB.Data.settings) end)
		check("an older save's Overcap moves into the priority list", InList(shared.nodeOrder, key) and not InList(shared.gradientOrder, key))
	end

	-- A power event refreshes the snapshot's resource before the draw, as UNIT_POWER_FREQUENT does in game.
	local function Draw()
		try("power", function() TRB.Functions.Character:UpdateResourceValues() end)
		try("draw", function() TRB.Functions.Class:TriggerResourceBarUpdates() end)
		try("text", function() TRB.Functions.RefreshLookupData() end)
	end
	local function BorderOf(overcap)
		local painted = drv.painted[overcap.node]
		return painted ~= nil and painted.border or nil
	end
	local function TextOf(overcap)
		return TRB.Data.lookup[overcap.variable] or ""
	end

	drv.curves = 0
	TRB.Data.character.inCombat = true
	for _, overcap in ipairs(overcaps) do
		-- Rage's text is red by default, as is its overcap text; a distinct color shows the switch.
		if overcap.textColor ~= nil then
			overcap.textColor.color = "FF123456"
		end
		local indicatorColor = shared.indicatorColors[overcap.key].color
		drv.power[overcap.powerType] = 50
		Draw()
		check(overcap.key .. ": below the threshold the border keeps its own color", overcap.node ~= nil and BorderOf(overcap) == overcap.baseBorder)
		-- Text colors render lowercase or uppercase depending on the path; compare without case.
		local function TextHasColor(color) return TextOf(overcap):lower():find(color:lower(), 1, true) ~= nil end
		if overcap.textColor ~= nil and overcap.textColor.enabled and overcap.variable ~= nil then
			check(overcap.key .. ": and the text keeps its own color", TextOf(overcap) ~= "" and not TextHasColor(overcap.textColor.color))
		end
		drv.power[overcap.powerType] = drv.maxPower
		Draw()
		check(overcap.key .. ": at the threshold in combat the border turns the Overcap color", BorderOf(overcap) == indicatorColor)
		if overcap.textColor ~= nil and overcap.textColor.enabled and overcap.variable ~= nil then
			check(overcap.key .. ": and the text turns the overcap text color", TextHasColor(overcap.textColor.color))
		end
		TRB.Data.character.inCombat = false
		Draw()
		check(overcap.key .. ": out of combat it doesn't", BorderOf(overcap) == overcap.baseBorder)
		TRB.Data.character.inCombat = true
		local settingsOvercap = overcap.key == "borderOvercap" and spec.overcap or spec.bars[overcap.key:gsub("Overcap$", "")].overcap
		local savedMode, savedRelative = settingsOvercap.mode, settingsOvercap.relative
		settingsOvercap.mode, settingsOvercap.relative = "relative", -20
		drv.power[overcap.powerType] = 85
		Draw()
		check(overcap.key .. ": a relative offset moves the threshold", BorderOf(overcap) == indicatorColor)
		settingsOvercap.mode, settingsOvercap.relative = savedMode, savedRelative
		if overcap.stealthPauses or (overcap.key == "borderOvercap" and shared.indicatorColors.borderStealth ~= nil) then
			drv.stealthed = true
			drv.power[overcap.powerType] = drv.maxPower
			Draw()
			check(overcap.key .. ": Stealth pauses it", BorderOf(overcap) ~= indicatorColor)
			drv.stealthed = false
		end
		drv.power[overcap.powerType] = 0
	end
	check("no color curve is built", drv.curves == 0)

	-- The options list Overcap with the other indicators and have no gradient section.
	TRB.Details.addonData.optionsPanelFinished = true
	try("ConstructOptionsPanel", function() TRB.Options:ConstructOptionsPanel() end)
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local i = 1
	while i <= #drv.groups do
		local parent = drv.groups[i]
		if parent.tabConstructors then
			local keys = {}
			for k in pairs(parent.tabConstructors) do keys[#keys + 1] = k end
			table.sort(keys)
			for _, k in ipairs(keys) do pcall(Tabs.EnsureTabConstructed, Tabs, parent, k) end
		end
		i = i + 1
	end
	local config = drv.panelConfigs[#drv.panelConfigs]
	local listed = false
	if config ~= nil then
		for _, def in ipairs(config.indicatorDefs or {}) do
			if def.key == overcaps[1].key then listed = true end
		end
	end
	check("the Color Indicators tab lists Overcap with the others and has no gradient section", config ~= nil and listed and (config.gradientDefs == nil or #config.gradientDefs == 0))

	return errors
end

return hooks
