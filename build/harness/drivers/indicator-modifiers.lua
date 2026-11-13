-- Checks Color Indicator modifiers and the Edit menu: Not Active flips a row's condition (an unreadable custom source
-- stays off), Only In Combat keeps a row off out of combat, every specialization's real update honors both, and Change
-- Source re-points built-in rows in place.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
-- Colors painted during a draw, the conditions forced, and what the options built.
local drv = { borders = {}, fills = {}, curves = {}, force = nil, groups = {}, panels = {}, menus = {}, popups = {}, editButtons = {} }

---A menu description that records what it was asked to draw.
local function newDesc(label, kind)
	local d = { label = label, kind = kind, children = {} }
	local function add(child) d.children[#d.children + 1] = child return child end
	function d:CreateTitle(text) return add(newDesc(text, "title")) end
	function d:CreateDivider() return add(newDesc(nil, "divider")) end
	function d:CreateButton(text, fn) local c = add(newDesc(text, "button")) c.fn = fn return c end
	function d:CreateCheckbox(text, isSelected, setSelected) local c = add(newDesc(text, "checkbox")) c.isSelected, c.setSelected = isSelected, setSelected return c end
	function d:CreateRadio(text, isSelected, setSelected) local c = add(newDesc(text, "radio")) c.isSelected, c.setSelected = isSelected, setSelected return c end
	function d:SetEnabled(enabled) self.disabled = not enabled end
	function d:SetTooltip() end
	function d:SetScrollMode() end
	function d:AddInitializer() end
	return d
end

---@param root table
---@param label string
---@return table?
local function FindEntry(root, label)
	for _, child in ipairs(root.children) do
		if child.label == label then
			return child
		end
		local found = FindEntry(child, label)
		if found ~= nil then
			return found
		end
	end
	return nil
end

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	G.UnitStagger = function() return 0 end
	G.UnitPartialPower = function() return 0 end
	G.StaticPopup_Show = function(which, _, _, data)
		drv.popups[#drv.popups + 1] = { which = which, data = data }
	end
	G.MenuUtil = setmetatable({
		CreateContextMenu = function(owner, generator)
			local root = newDesc("root", "root")
			generator(owner, root)
			drv.menus[#drv.menus + 1] = root
			return root
		end,
	}, { __index = G.MenuUtil })
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	local Color = TRB.Functions.Color
	local BarNode = TRB.Classes.BarNode
	local setBorder = BarNode.SetBorderColor
	BarNode.SetBorderColor = function(self, color, ...)
		if color ~= nil then drv.borders[color] = true end
		return setBorder(self, color, ...)
	end
	local applyFill = Color.ApplyFillColor
	Color.ApplyFillColor = function(self, node, colorEntry, ...)
		local color = type(colorEntry) == "table" and colorEntry.color or colorEntry
		if color ~= nil then drv.fills[color] = true end
		return applyFill(self, node, colorEntry, ...)
	end
	-- A gradient paints through a curve up to its own color, so a built curve marks the gradient as applied.
	local buildCurve = Color.BuildResourceThresholdCurve
	Color.BuildResourceThresholdCurve = function(self, specSettings, belowColor, aboveColor, ...)
		local color = type(aboveColor) == "table" and aboveColor.color or aboveColor
		if color ~= nil then drv.curves[color] = true end
		return buildCurve(self, specSettings, belowColor, aboveColor, ...)
	end
	local stepCurve = Color.GetStepColorCurve
	Color.GetStepColorCurve = function(self, cacheKey, belowColor, aboveColor, ...)
		if aboveColor ~= nil then drv.curves[aboveColor] = true end
		return stepCurve(self, cacheKey, belowColor, aboveColor, ...)
	end
	local applyIndicators = Color.ApplyIndicatorColors
	Color.ApplyIndicatorColors = function(self, sharedColors, conditionMap, ...)
		if drv.force ~= nil and conditionMap ~= nil then
			for k, v in pairs(drv.force) do conditionMap[k] = v end
		end
		return applyIndicators(self, sharedColors, conditionMap, ...)
	end

	local Tabs = TRB.Functions.OptionsUi.Tabs
	local buildTabGroup = Tabs.BuildTabGroup
	Tabs.BuildTabGroup = function(self, parent, ...)
		local r = buildTabGroup(self, parent, ...)
		drv.groups[#drv.groups + 1] = parent
		return r
	end
	local Primitives = TRB.Functions.OptionsUi.Primitives
	local building = nil
	local buildButton = Primitives.BuildButton
	Primitives.BuildButton = function(self, parent, text, ...)
		local button = buildButton(self, parent, text, ...)
		if building ~= nil then
			building.buttons[#building.buttons + 1] = { text = text, button = button }
		end
		return button
	end
	local buildEdit = Primitives.BuildEditIconButton
	Primitives.BuildEditIconButton = function(self, parent, ...)
		local button = buildEdit(self, parent, ...)
		-- Each list builds its rows in order, so a list's Nth button is its Nth row's.
		local list = debug.getinfo(2, "n").name == "BuildGradientRow" and "gradient" or "flat"
		drv.editButtons[parent] = drv.editButtons[parent] or { flat = {}, gradient = {} }
		table.insert(drv.editButtons[parent][list], button)
		return button
	end
	local Indicators = TRB.Functions.OptionsUi.Indicators
	local generate = Indicators.GenerateIndicatorColorsPanel
	Indicators.GenerateIndicatorColorsPanel = function(self, parent, controls, spec, classId, specId, yCoord, config)
		building = { parent = parent, controls = controls, spec = spec, classId = classId, specId = specId, config = config, buttons = {} }
		drv.panels[#drv.panels + 1] = building
		local r = { generate(self, parent, controls, spec, classId, specId, yCoord, config) }
		building = nil
		return unpack(r)
	end
	TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local L = TRB.Localization
	local Settings = TRB.Functions.Settings
	local Color = TRB.Functions.Color
	local Table = TRB.Functions.Table
	local Character = TRB.Functions.Character
	local cdm = TRB.Functions.CooldownManager
	local Threshold = TRB.Functions.Threshold
	local Aura = TRB.Functions.Aura
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
	local function IndexOf(list, key)
		for i, k in ipairs(list or {}) do
			if k == key then return i end
		end
		return nil
	end
	---Puts a spec's indicator lists and entries back in place, keeping the tables the options panel holds.
	local function Restore(shared, backup)
		for _, listName in ipairs({ "nodeOrder", "gradientOrder" }) do
			if shared[listName] ~= nil then
				wipe(shared[listName])
				for i, k in ipairs(backup[listName] or {}) do shared[listName][i] = k end
			end
		end
		wipe(shared.indicatorColors)
		for k, v in pairs(backup.indicatorColors) do shared.indicatorColors[k] = Table:DeepCopy(v) end
		shared.removed = backup.removed ~= nil and Table:DeepCopy(backup.removed) or nil
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")
	check("the deferred setup finishes", TRB.Details.addonData.optionsPanelFinished == true)
	-- The login's render transition runs on the stubs' wall clock and would skip the draws below.
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end

	-- Resolution: Not Active flips built-ins, copies, and custom rows; an unreadable custom source stays off.
	do
		local BUILT_IN, COPY, UNKNOWN_LINE, UNFOLLOWED_BUFF, CDM_ROW, PLAIN_CDM = "FF0D0D01", "FF0D0D02", "FF0D0D03", "FF0D0D04", "FF0D0D05", "FF0D0D06"
		local notActive = { notActive = true }
		local cdmReads = { [9001] = nil, [9002] = nil }
		local shared = {
			nodeOrder = { "builtIn", "copy_1", "custom_1", "custom_2", "custom_3", "custom_4" },
			indicatorColors = {
				builtIn = { enabled = true, color = BUILT_IN, targets = { testBar = { border = true } }, modifiers = notActive },
				copy_1 = { copyOf = "builtIn", enabled = true, color = COPY, targets = { testBar = { background = true } } },
				custom_1 = { enabled = true, color = UNKNOWN_LINE, targets = { testBar = { endCap = true } }, modifiers = notActive,
					custom = { conditions = { { source = Threshold.CONDITION_SOURCE, settingKey = "noSuchLine", state = Threshold.ConditionState.USABLE } } } },
				custom_2 = { enabled = true, color = UNFOLLOWED_BUFF, targets = { otherBar = { border = true } }, modifiers = notActive,
					custom = { conditions = { { source = Aura.CONDITION_SOURCE, spellID = 424242, state = Aura.ConditionState.ACTIVE } } } },
				custom_3 = { enabled = true, color = CDM_ROW, targets = { otherBar = { background = true } }, modifiers = notActive,
					custom = { conditions = { { source = cdm.CONDITION_SOURCE, cooldownID = 9001, state = cdm.ConditionState.ACTIVE } } } },
				custom_4 = { enabled = true, color = PLAIN_CDM, targets = { otherBar = { endCap = true } },
					custom = { conditions = { { source = cdm.CONDITION_SOURCE, cooldownID = 9002, state = cdm.ConditionState.ACTIVE } } } },
			},
		}
		local readCondition = cdm.ReadCondition
		cdm.ReadCondition = function(_, condition) return cdmReads[condition.cooldownID] end
		local function Resolve(conditionMap)
			local barColorMap = { testBar = {}, otherBar = {} }
			try("resolve", function() Color:ApplyIndicatorColors(shared, conditionMap, barColorMap) end)
			return barColorMap.testBar, barColorMap.otherBar
		end

		local testBar, otherBar = Resolve({ builtIn = false })
		check("Not Active turns a built-in on while its condition is not met", testBar.border == BUILT_IN)
		check("a copy without Not Active stays off with it", testBar.background == nil)
		check("a threshold line that isn't learned stays off under Not Active", testBar.endCap == nil)
		check("a buff that isn't followed stays off under Not Active", otherBar.border == nil)
		check("a Cooldown Manager entry that can't be read stays off under Not Active", otherBar.background == nil)
		check("and one without Not Active stays off too", otherBar.endCap == nil)

		testBar = Resolve({ builtIn = true })
		check("Not Active turns a built-in off while its condition is met", testBar.border == nil)
		check("while its copy without Not Active turns on", testBar.background == COPY)

		testBar = Resolve({})
		check("a built-in condition the spec left unset counts as not met", testBar.border == BUILT_IN)

		cdmReads[9001], cdmReads[9002] = false, false
		testBar, otherBar = Resolve({ builtIn = true })
		check("Not Active turns a Cooldown Manager row on while its buff is down", otherBar.background == CDM_ROW)
		check("and one without Not Active stays off", otherBar.endCap == nil)
		cdmReads[9001], cdmReads[9002] = true, true
		testBar, otherBar = Resolve({ builtIn = true })
		check("Not Active turns a Cooldown Manager row off while its buff is up", otherBar.background == nil)
		check("and one without Not Active turns on", otherBar.endCap == PLAIN_CDM)

		local map = { builtIn = false }
		check("IsIndicatorMet flips a built-in", Color:IsIndicatorMet(map, "builtIn", shared.indicatorColors.builtIn) == true)
		check("and reads a row without modifiers as is", not Color:IsIndicatorMet({ builtIn = false }, "copy_1", shared.indicatorColors.copy_1))

		-- Only In Combat keeps a row off out of combat, and in combat leaves its condition and Not Active as they are.
		local character = TRB.Data.character
		local wasInCombat = character.inCombat
		local combatOnly = { enabled = true, color = BUILT_IN, targets = {}, modifiers = { onlyInCombat = true } }
		local notActiveInCombat = { enabled = true, color = BUILT_IN, targets = {}, modifiers = { onlyInCombat = true, notActive = true } }
		character.inCombat = false
		check("Only In Combat keeps a met row off out of combat", Color:IsIndicatorMet({ builtIn = true }, "builtIn", combatOnly) == false)
		check("and a Not Active row that isn't met", Color:IsIndicatorMet({ builtIn = false }, "builtIn", notActiveInCombat) == false)
		shared.indicatorColors.builtIn.modifiers = { onlyInCombat = true, notActive = true }
		testBar = Resolve({ builtIn = false })
		check("and so does the resolve", testBar.border == nil)
		character.inCombat = true
		check("in combat it reads the condition as is", Color:IsIndicatorMet({ builtIn = true }, "builtIn", combatOnly) == true
			and not Color:IsIndicatorMet({ builtIn = false }, "builtIn", combatOnly))
		check("and Not Active still flips it", Color:IsIndicatorMet({ builtIn = false }, "builtIn", notActiveInCombat) == true
			and not Color:IsIndicatorMet({ builtIn = true }, "builtIn", notActiveInCombat))
		testBar = Resolve({ builtIn = false })
		check("and the resolve paints it", testBar.border == BUILT_IN)
		character.inCombat = wasInCombat
		cdm.ReadCondition = readCondition
	end

	-- Gradients: Only In Combat gates the curve on a spec's own bars and on the shared bars.
	do
		local character = TRB.Data.character
		local wasInCombat = character.inCombat
		local gradientShared = { nodeOrder = {}, gradientOrder = { "overcap" }, indicatorColors = {
			overcap = { enabled = true, isGradient = true, color = "FF0D0D07", targets = { testBar = { border = true }, healthBar = { border = true } },
				modifiers = { onlyInCombat = true } },
		} }
		local function Resolved()
			local own = Color:ResolveGradientTargets(gradientShared, { overcap = true }, "testBar", {})
			try("resolve gradients", function() Color:ApplyIndicatorColors(gradientShared, { overcap = true }, { testBar = {} }) end)
			local sharedBar = Color:GetResolvedGradients("healthBar")
			return own.border ~= nil, sharedBar ~= nil and sharedBar.border ~= nil
		end
		character.inCombat = false
		local own, sharedBar = Resolved()
		check("an Only In Combat gradient applies nowhere out of combat", not own and not sharedBar)
		character.inCombat = true
		own, sharedBar = Resolved()
		check("and in combat applies on its own bar and the shared bars", own and sharedBar)
		character.inCombat = false
		gradientShared.indicatorColors.overcap.modifiers = { onlyInCombat = false }
		own, sharedBar = Resolved()
		check("with Only In Combat off, it applies out of combat too", own and sharedBar)
		character.inCombat = wasInCombat
		try("clear gradients", function() Color:ApplyIndicatorColors({ nodeOrder = {}, gradientOrder = {}, indicatorColors = {} }, {}, { testBar = {} }) end)
	end

	-- Copies take their built-in's default modifiers they leave unset, as the login's merge does for the built-in.
	do
		local defaultShared = { nodeOrder = { "builtIn" }, gradientOrder = {}, indicatorColors = {
			builtIn = { enabled = true, color = "FF0D0D08", targets = {}, modifiers = { onlyInCombat = true } },
		} }
		local spec = { colors = { shared = { nodeOrder = { "builtIn", "copy_1", "copy_2" }, gradientOrder = {}, indicatorColors = {
			builtIn = { enabled = true, color = "FF0D0D08", targets = {}, modifiers = { onlyInCombat = true } },
			copy_1 = { copyOf = "builtIn", enabled = true, color = "FF0D0D09", targets = {} },
			copy_2 = { copyOf = "builtIn", enabled = true, color = "FF0D0D0A", targets = {}, modifiers = { onlyInCombat = false } },
		} } } }
		try("reconcile copies", function() Settings:ReconcileSharedIndicators(spec, defaultShared) end)
		local colors = spec.colors.shared.indicatorColors
		check("a copy with no Only In Combat of its own takes its built-in's default", colors.copy_1.modifiers ~= nil and colors.copy_1.modifiers.onlyInCombat == true)
		check("while a copy that turned it off keeps it off", colors.copy_2.modifiers ~= nil and colors.copy_2.modifiers.onlyInCombat == false)
	end

	-- Every options tab, so each specialization's Color Indicators panel is built.
	try("ConstructOptionsPanel", function() TRB.Options:ConstructOptionsPanel() end)
	local Tabs = TRB.Functions.OptionsUi.Tabs
	parity.BuildAllSections(TRB)
	local g = 1
	while g <= #drv.groups do
		local parent = drv.groups[g]
		if parent.tabConstructors then
			local keys = {}
			for k in pairs(parent.tabConstructors) do keys[#keys + 1] = k end
			table.sort(keys)
			for _, k in ipairs(keys) do pcall(Tabs.EnsureTabConstructed, Tabs, parent, k) end
		end
		g = g + 1
	end

	local entries = {}
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if entry.classId == ctx.classId then
			entries[#entries + 1] = entry
		end
	end
	-- The login spec goes last, so the render pass ends on it.
	if #entries > 1 then
		table.insert(entries, table.remove(entries, 1))
	end
	local function FindPanel(specId)
		local found = nil
		for _, panel in ipairs(drv.panels) do
			if panel.classId == ctx.classId and panel.specId == specId then found = panel end
		end
		return found
	end
	local function SortedLabels(defs)
		local sorted = {}
		for _, def in ipairs(defs) do sorted[#sorted + 1] = def end
		table.sort(sorted, function(a, b)
			local aLabel, bLabel = (a.colorLabel or a.key):lower(), (b.colorLabel or b.key):lower()
			if aLabel == bLabel then return a.key < b.key end
			return aLabel < bLabel
		end)
		return sorted
	end

	-- Options: the Edit menu on built-in, copy, gradient, and threshold rows, on every specialization's panel.
	for _, panelEntry in ipairs(entries) do
		local panel = FindPanel(panelEntry.specId)
		check(panelEntry.compositeKey .. ": the Color Indicators panel is built", panel ~= nil)
		if panel ~= nil then
			local label = panelEntry.compositeKey
			local shared = panel.spec.colors.shared
			local backup = Table:DeepCopy(shared)
			local defaults = Settings:GetDefaultSharedIndicators(panelEntry.compositeKey)
			local defs = panel.config.indicatorDefs
			local gradientDefs = panel.config.gradientDefs or {}
			local defKeys = {}
			for _, def in ipairs(defs) do defKeys[def.key] = def end
			for _, def in ipairs(gradientDefs) do defKeys[def.key] = def end
			local buttons = drv.editButtons[panel.parent] or { flat = {}, gradient = {} }

			---A key's row in its list, counting only the rows the panel draws.
			local function RowIndex(key, listName)
				local i = 0
				for _, k in ipairs(shared[listName]) do
					local indicator = shared.indicatorColors[k]
					if indicator ~= nil and (defKeys[k] or indicator.custom ~= nil or (indicator.copyOf ~= nil and defKeys[indicator.copyOf])) then
						i = i + 1
						if k == key then return i end
					end
				end
				return nil
			end
			local function KeyAtRow(rowIndex, listName)
				for _, k in ipairs(shared[listName]) do
					if RowIndex(k, listName) == rowIndex then return k end
				end
				return nil
			end
			local function OpenEdit(rowIndex, listName)
				local button = buttons[listName == "gradientOrder" and "gradient" or "flat"][rowIndex]
				if button == nil then return nil end
				local before = #drv.menus
				try("open edit", function() button.__scripts.OnClick(button) end)
				return #drv.menus > before and drv.menus[#drv.menus] or nil
			end
			local function RowLabel(rowIndex)
				local row = panel.controls.indicatorColors.rows[rowIndex]
				return row ~= nil and row.colorPicker.Font:GetText() or nil
			end
			---Picks a built-in in a row's Change Source submenu.
			local function PickSource(rowIndex, listName, builtInKey)
				local menu = OpenEdit(rowIndex, listName)
				local source = menu ~= nil and FindEntry(menu, L["IndicatorEditChangeSource"]) or nil
				local target = source ~= nil and FindEntry(source, defKeys[builtInKey].colorLabel or builtInKey) or nil
				if target == nil then return false end
				try("pick " .. builtInKey, function() target.setSelected() end)
				return true
			end
			local function TargetString(entry)
				local found = {}
				for barKey, elements in pairs(entry ~= nil and entry.targets or {}) do
					for elemKey, isTargeted in pairs(elements) do
						if isTargeted == true then found[#found + 1] = barKey .. "." .. elemKey end
					end
				end
				table.sort(found)
				return table.concat(found, ",")
			end
			local function TargetsAfterLogin(key)
				local merged = Table:Merge({ colors = { shared = Table:DeepCopy(defaults or {}) } }, { colors = { shared = Table:DeepCopy(shared) } })
				return TargetString(merged.colors.shared.indicatorColors[key])
			end
			---Ticks one element the built-in doesn't target by default, as its targets menu does.
			local function TargetNonDefault(key)
				local defaultEntry = defaults ~= nil and defaults.indicatorColors[key] or nil
				local defaultTargets = defaultEntry ~= nil and defaultEntry.targets or {}
				local entry = shared.indicatorColors[key]
				entry.targets = {}
				for barKey, elements in pairs(defaultTargets) do
					entry.targets[barKey] = {}
					for elemKey, isTargeted in pairs(elements) do
						if type(isTargeted) == "boolean" then entry.targets[barKey][elemKey] = false end
					end
				end
				for _, barDef in ipairs(panel.config.barTargetDefs) do
					for _, elemKey in ipairs({ "background", "border", "bar" }) do
						if not (defaultTargets[barDef.key] and defaultTargets[barDef.key][elemKey]) then
							entry.targets[barDef.key] = entry.targets[barDef.key] or {}
							entry.targets[barDef.key][elemKey] = true
							entry.enabled = true
							return barDef.key .. "." .. elemKey
						end
					end
				end
				return nil
			end

			-- A built-in with modifiers on by default: turning one off saves false, which a login's merge keeps.
			local seededKey, plainKey = nil, nil
			for _, k in ipairs(shared.nodeOrder) do
				local indicator = shared.indicatorColors[k]
				local defaultEntry = defaults ~= nil and defaults.indicatorColors[k] or nil
				if indicator ~= nil and indicator.custom == nil and indicator.copyOf == nil and defKeys[k] and defaultEntry ~= nil and defKeys[k].barKeys == nil then
					if seededKey == nil and defaultEntry.modifiers ~= nil then seededKey = k end
					if plainKey == nil and defaultEntry.modifiers == nil then plainKey = k end
				end
			end
			if seededKey ~= nil then
				local defaultModifiers = defaults.indicatorColors[seededKey].modifiers
				local function ModifiersAfterLogin()
					local merged = Table:Merge({ colors = { shared = Table:DeepCopy(defaults or {}) } }, { colors = { shared = Table:DeepCopy(shared) } })
					return merged.colors.shared.indicatorColors[seededKey].modifiers or {}
				end
				local menu = OpenEdit(RowIndex(seededKey, "nodeOrder"), "nodeOrder")
				for _, modifier in ipairs({ { "notActive", L["IndicatorModifierNotActive"] }, { "onlyInCombat", L["IndicatorModifierOnlyInCombat"] } }) do
					local name, entry = modifier[1], menu ~= nil and FindEntry(menu, modifier[2]) or nil
					if defaultModifiers[name] == true then
						check(label .. ": " .. seededKey .. " starts with " .. name .. " on, as its default", entry ~= nil and entry.isSelected())
						if entry ~= nil then
							try(name .. " off", function() entry.setSelected() end)
							local modifiers = shared.indicatorColors[seededKey].modifiers
							check(label .. ": turning " .. name .. " off saves false", modifiers ~= nil and modifiers[name] == false and not entry.isSelected())
							check(label .. ": which a login keeps", ModifiersAfterLogin()[name] == false)
							try(name .. " on", function() entry.setSelected() end)
							check(label .. ": turning it back on saves true", shared.indicatorColors[seededKey].modifiers[name] == true)
						end
					end
				end
				-- A row with no modifiers switched onto it keeps none, saved as false over the built-in's defaults.
				if plainKey ~= nil then
					local rowIndex = RowIndex(plainKey, "nodeOrder")
					check(label .. ": switching a row without modifiers onto " .. seededKey, PickSource(rowIndex, "nodeOrder", seededKey))
					local copy = shared.indicatorColors[KeyAtRow(rowIndex, "nodeOrder")]
					local keptNone = copy ~= nil and copy.copyOf == seededKey and copy.modifiers ~= nil
					for name, on in pairs(defaultModifiers) do
						if on == true and (copy == nil or copy.modifiers == nil or copy.modifiers[name] ~= false) then keptNone = false end
					end
					check(label .. ": saves each of its default modifiers as false", keptNone)
					check(label .. ": switching it back", PickSource(rowIndex, "nodeOrder", plainKey))
					shared.indicatorColors[plainKey].modifiers = nil
				end
			end

			-- A built-in with no default modifiers, so its menu starts with every modifier off.
			local key, seededOnly = nil, false
			for _, k in ipairs(shared.nodeOrder) do
				local indicator = shared.indicatorColors[k]
				if indicator ~= nil and indicator.custom == nil and indicator.copyOf == nil and defKeys[k] and defKeys[k].barKeys == nil then
					local defaultEntry = defaults ~= nil and defaults.indicatorColors[k] or nil
					if defaultEntry ~= nil and defaultEntry.modifiers ~= nil then
						seededOnly = true
					elseif key == nil then
						key = k
					end
				end
			end
			if key == nil then
				check(label .. ": no built-in row without default modifiers to edit", #defs == 0 or #shared.nodeOrder == 0 or seededOnly)
			else
				local rowIndex = RowIndex(key, "nodeOrder")
				local sorted = SortedLabels(defs)
				local menu = OpenEdit(rowIndex, "nodeOrder")
				local source = menu ~= nil and menu.children[1] or nil
				check(label .. ": a built-in row's Edit menu starts with Change Source", source ~= nil and source.label == L["IndicatorEditChangeSource"] and not source.disabled)
				local inOrder = source ~= nil and #source.children == #sorted
				local current = 0
				for i, child in ipairs(source ~= nil and source.children or {}) do
					if child.kind ~= "radio" or sorted[i] == nil or child.label ~= (sorted[i].colorLabel or sorted[i].key) then inOrder = false end
					if child.isSelected ~= nil and child.isSelected() then current = i end
				end
				check(label .. ": Change Source lists every built-in, sorted by label", inOrder)
				check(label .. ": with the row's own built-in picked", current > 0 and sorted[current].key == key)
				local notActive = menu ~= nil and FindEntry(menu, L["IndicatorModifierNotActive"]) or nil
				check(label .. ": then Not Active under Modifiers", menu ~= nil and notActive ~= nil and notActive.kind == "checkbox"
					and FindEntry(menu, L["IndicatorEditModifiers"]) ~= nil and not notActive.isSelected())

				local defLabel = defKeys[key].colorLabel
				if notActive ~= nil then
					try("Not Active on", function() notActive.setSelected() end)
					check(label .. ": Not Active saves on the row", shared.indicatorColors[key].modifiers ~= nil and shared.indicatorColors[key].modifiers.notActive == true and notActive.isSelected())
					check(label .. ": and marks its label", RowLabel(rowIndex) == string.format(L["IndicatorNotActiveLabelFormat"], defLabel))
					try("Not Active off", function() notActive.setSelected() end)
					check(label .. ": turning it off leaves no modifiers", shared.indicatorColors[key].modifiers == nil and RowLabel(rowIndex) == defLabel)
					try("Not Active on again", function() notActive.setSelected() end)
				end
				local onlyInCombat = menu ~= nil and FindEntry(menu, L["IndicatorModifierOnlyInCombat"]) or nil
				check(label .. ": and Only In Combat", onlyInCombat ~= nil and onlyInCombat.kind == "checkbox" and not onlyInCombat.isSelected())
				if onlyInCombat ~= nil then
					local notLabel = string.format(L["IndicatorNotActiveLabelFormat"], defLabel)
					try("Only In Combat on", function() onlyInCombat.setSelected() end)
					local modifiers = shared.indicatorColors[key].modifiers
					check(label .. ": Only In Combat saves on the row beside Not Active", modifiers ~= nil and modifiers.onlyInCombat == true
						and modifiers.notActive == true and onlyInCombat.isSelected())
					check(label .. ": and marks its label too", RowLabel(rowIndex) == string.format(L["IndicatorOnlyInCombatLabelFormat"], notLabel))
					try("Only In Combat off", function() onlyInCombat.setSelected() end)
					modifiers = shared.indicatorColors[key].modifiers
					check(label .. ": turning it off keeps Not Active", modifiers ~= nil and modifiers.onlyInCombat == nil and modifiers.notActive == true
						and RowLabel(rowIndex) == notLabel)
				end

				local other = nil
				for _, def in ipairs(sorted) do
					if other == nil and def.key ~= key and def.barKeys == nil then other = def.key end
				end
				if other == nil then
					local everyBarCount = 0
					for _, def in ipairs(defs) do
						if def.barKeys == nil then everyBarCount = everyBarCount + 1 end
					end
					check(label .. ": no other built-in that offers every bar to switch to", everyBarCount == 1)
				else
					local ROW_COLOR = "FF0E0E01"
					shared.indicatorColors[key].color = ROW_COLOR
					local picked = TargetNonDefault(key)
					check(label .. ": switching an original built-in", PickSource(rowIndex, "nodeOrder", other))
					local copyKey = KeyAtRow(rowIndex, "nodeOrder")
					local copy = shared.indicatorColors[copyKey]
					check(label .. ": makes the row a copy of the new built-in in the same place", copyKey ~= nil and copyKey:match("^copy_%d+$") ~= nil and copy ~= nil
						and copy.copyOf == other and RowIndex(copyKey, "nodeOrder") == rowIndex)
					check(label .. ": keeping its color, targets, and modifiers", copy ~= nil and copy.color == ROW_COLOR and TargetString(copy) == picked
						and copy.modifiers ~= nil and copy.modifiers.notActive == true and copy.enabled == true)
					check(label .. ": and deletes the original", IndexOf(shared.nodeOrder, key) == nil and shared.removed ~= nil and shared.removed[key] == true
						and shared.indicatorColors[key].enabled == false)
					check(label .. ": the row reads as the new built-in", RowLabel(rowIndex) == string.format(L["IndicatorNotActiveLabelFormat"], defKeys[other].colorLabel))

					local third = nil
					for _, def in ipairs(sorted) do
						if third == nil and def.key ~= key and def.key ~= other and def.barKeys == nil then third = def.key end
					end
					if third ~= nil then
						check(label .. ": switching a copy", PickSource(rowIndex, "nodeOrder", third))
						check(label .. ": re-points it under the same key", shared.indicatorColors[copyKey] ~= nil and shared.indicatorColors[copyKey].copyOf == third
							and shared.nodeOrder[IndexOf(shared.nodeOrder, copyKey) or 0] == copyKey)
					end

					check(label .. ": switching to the deleted original", PickSource(rowIndex, "nodeOrder", key))
					check(label .. ": restores its own key in the row's place", RowIndex(key, "nodeOrder") == rowIndex and (shared.removed == nil or shared.removed[key] == nil)
						and shared.indicatorColors[copyKey] == nil and IndexOf(shared.nodeOrder, copyKey) == nil)
					check(label .. ": with the row's color and modifiers", shared.indicatorColors[key].color == ROW_COLOR and shared.indicatorColors[key].copyOf == nil
						and shared.indicatorColors[key].modifiers ~= nil and shared.indicatorColors[key].modifiers.notActive == true)
					check(label .. ": and only the row's targets through a login", TargetsAfterLogin(key) == picked)
				end

				-- A built-in that offers only some bars keeps only the row's targets on those.
				local narrow = nil
				for _, def in ipairs(sorted) do
					if narrow == nil and def.barKeys ~= nil and def.key ~= key then narrow = def end
				end
				local wideBar = nil
				for _, barDef in ipairs(panel.config.barTargetDefs) do
					if narrow ~= nil and wideBar == nil and barDef.key ~= narrow.barKeys[1] then wideBar = barDef.key end
				end
				if narrow ~= nil and wideBar ~= nil then
					local entry = shared.indicatorColors[KeyAtRow(rowIndex, "nodeOrder")]
					entry.targets = { [narrow.barKeys[1]] = { border = true }, [wideBar] = { background = true } }
					check(label .. ": switching to " .. narrow.key .. ", which offers only " .. narrow.barKeys[1], PickSource(rowIndex, "nodeOrder", narrow.key))
					local switched = shared.indicatorColors[KeyAtRow(rowIndex, "nodeOrder")]
					check(label .. ": keeps only the targets on that bar", switched ~= nil and switched.copyOf == narrow.key
						and TargetString(switched) == narrow.barKeys[1] .. ".border" and switched.enabled == true)
				end
			end

			-- A gradient's Edit menu offers Change Source and Only In Combat, never Not Active.
			local gradientKey = nil
			for _, k in ipairs(shared.gradientOrder or {}) do
				local indicator = shared.indicatorColors[k]
				if gradientKey == nil and indicator ~= nil and indicator.copyOf == nil and defKeys[k] then gradientKey = k end
			end
			if gradientKey ~= nil then
				local rowIndex = RowIndex(gradientKey, "gradientOrder")
				local menu = OpenEdit(rowIndex, "gradientOrder")
				local source = menu ~= nil and menu.children[1] or nil
				check(label .. ": a gradient row's Edit menu offers Change Source", source ~= nil and source.label == L["IndicatorEditChangeSource"]
					and #source.children == #gradientDefs)
				local onlyInCombat = menu ~= nil and FindEntry(menu, L["IndicatorModifierOnlyInCombat"]) or nil
				check(label .. ": and Only In Combat under Modifiers, without Not Active", menu ~= nil and onlyInCombat ~= nil
					and FindEntry(menu, L["IndicatorEditModifiers"]) ~= nil and FindEntry(menu, L["IndicatorModifierNotActive"]) == nil)
				local defaultEntry = defaults ~= nil and defaults.indicatorColors[gradientKey] or nil
				local seeded = defaultEntry ~= nil and defaultEntry.modifiers ~= nil and defaultEntry.modifiers.onlyInCombat == true
				local function GradientLabel()
					local row = panel.controls.indicatorColors.gradientRows[rowIndex]
					return row ~= nil and row.colorPicker.Font:GetText() or nil
				end
				local function OnlyInCombatAfterLogin()
					local merged = Table:Merge({ colors = { shared = Table:DeepCopy(defaults or {}) } }, { colors = { shared = Table:DeepCopy(shared) } })
					local modifiers = merged.colors.shared.indicatorColors[gradientKey].modifiers
					if modifiers == nil then
						return nil
					end
					return modifiers.onlyInCombat
				end
				local plainLabel = defKeys[gradientKey].colorLabel
				local combatLabel = string.format(L["IndicatorOnlyInCombatLabelFormat"], plainLabel)
				if onlyInCombat ~= nil then
					check(label .. ": which starts " .. (seeded and "on, as its default" or "off"), onlyInCombat.isSelected() == seeded
						and GradientLabel() == (seeded and combatLabel or plainLabel))
					try("gradient Only In Combat", function() onlyInCombat.setSelected() end)
					local modifiers = shared.indicatorColors[gradientKey].modifiers
					-- Off is saved as false over a default that has it on, so the login's merge can't turn it back on.
					local expected = not seeded
					check(label .. ": toggling it saves " .. tostring(expected) .. " on the row, which a login keeps", modifiers ~= nil
						and modifiers.onlyInCombat == expected and OnlyInCombatAfterLogin() == expected)
					check(label .. ": and relabels it", GradientLabel() == (expected and combatLabel or plainLabel))
					try("gradient Only In Combat back", function() onlyInCombat.setSelected() end)
					check(label .. ": and toggling it back restores it", onlyInCombat.isSelected() == seeded and GradientLabel() == (seeded and combatLabel or plainLabel))
				end
				local other = nil
				for _, def in ipairs(gradientDefs) do
					if other == nil and def.key ~= gradientKey then other = def.key end
				end
				if other ~= nil then
					check(label .. ": switching a gradient row", PickSource(rowIndex, "gradientOrder", other))
					local copyKey = KeyAtRow(rowIndex, "gradientOrder")
					local copy = shared.indicatorColors[copyKey]
					check(label .. ": makes it a gradient copy in the same place", copy ~= nil and copy.copyOf == other and copy.isGradient == true
						and IndexOf(shared.gradientOrder, gradientKey) == nil)
				end
			end

			-- A custom threshold row, where the spec has threshold lines to follow.
			local addButton = nil
			for _, entry in ipairs(panel.buttons) do
				if entry.text == L["CustomIndicatorAddButton"] then addButton = entry.button end
			end
			local addMenu = nil
			if addButton ~= nil then
				local before = #drv.menus
				try("open add", function() addButton.__scripts.OnClick(addButton) end)
				addMenu = #drv.menus > before and drv.menus[#drv.menus] or nil
			end
			local thresholds = addMenu ~= nil and FindEntry(addMenu, L["CustomIndicatorSourceThresholds"]) or nil
			local stateRadio = nil
			for _, line in ipairs(thresholds ~= nil and thresholds.children or {}) do
				for _, radio in ipairs(line.children) do
					if stateRadio == nil and radio.kind == "radio" then stateRadio = radio end
				end
			end
			if stateRadio ~= nil then
				try("add threshold row", function() stateRadio.setSelected() end)
				local customKey = shared.nodeOrder[#shared.nodeOrder]
				local customEntry = shared.indicatorColors[customKey]
				local condition = customEntry ~= nil and customEntry.custom ~= nil and customEntry.custom.conditions[1] or nil
				check(label .. ": a threshold row is added", condition ~= nil and condition.source == Threshold.CONDITION_SOURCE)
				local menu = OpenEdit(RowIndex(customKey, "nodeOrder"), "nodeOrder")
				local source = menu ~= nil and menu.children[1] or nil
				local notActive = menu ~= nil and FindEntry(menu, L["IndicatorModifierNotActive"]) or nil
				check(label .. ": its Edit menu offers its threshold lines under Change Source", source ~= nil and source.label == L["IndicatorEditChangeSource"] and #source.children > 0)
				check(label .. ": and Not Active unless the state is Static", (notActive ~= nil) == (condition ~= nil and condition.state ~= Threshold.ConditionState.STATIC))
				check(label .. ": and Only In Combat", menu ~= nil and FindEntry(menu, L["IndicatorModifierOnlyInCombat"]) ~= nil)
			end
			Restore(shared, backup)
		end
	end

	-- Renders: each specialization's real update with Not Active on a built-in and on its copy.
	local function SetSpec(index)
		desktop.GetSpecialization = function() return index end
		desktop.C_SpecializationInfo.GetSpecialization = function() return index end
	end
	local function Draw(force)
		drv.force = force
		wipe(drv.borders)
		wipe(drv.fills)
		wipe(drv.curves)
		try("power", function() Character:UpdateResourceValues() end)
		local ok = try("draw", function() TRB.Functions.Class:TriggerResourceBarUpdates() end)
		drv.force = nil
		return ok
	end
	local ORIGINAL, COPY = "FF0F0F01", "FF0F0F02"
	-- Each live Druid specialization draws its own bars only in its form.
	local druidForms = { druid_balance = { 31, "moonkin" }, druid_feral = { 1, "cat" }, druid_guardian = { 5, "bear" }, druid_restoration = { 0, "humanoid" } }

	for _, entry in ipairs(entries) do
		local label = entry.compositeKey
		if TRB.Data.character.compositeKey ~= entry.compositeKey then
			SetSpec(entry.specId)
			stubs.fireEvents("PLAYER_SPECIALIZATION_CHANGED", ctx.addonName)
			Drain("SPEC")
		end
		check(label .. ": the specialization is live", TRB.Data.character.compositeKey == entry.compositeKey)
		local form = TRB.Flavor.id == "mainline" and druidForms[entry.compositeKey] or nil
		if form ~= nil then
			desktop.GetShapeshiftFormID = function() return form[1] end
			TRB.Data.character.currentShapeshiftFormId = form[1]
			TRB.Data.character.currentShapeshiftForm = form[2]
		end
		local specSettings = TRB.Data.settings[entry.className][entry.specName]
		local shared = specSettings.colors.shared
		local backup = Table:DeepCopy(shared)
		local entryPanel = FindPanel(entry.specId)
		local barDefs = entryPanel ~= nil and entryPanel.config.barTargetDefs or {}

		local key = nil
		for _, k in ipairs(shared.nodeOrder) do
			local indicator = shared.indicatorColors[k]
			if key == nil and indicator ~= nil and indicator.custom == nil and indicator.copyOf == nil then key = k end
		end
		if key == nil or #barDefs == 0 then
			check(label .. ": no built-in Color Indicator to modify", key == nil)
		else
			TRB.Data.character.inCombat = false
			table.remove(shared.nodeOrder, IndexOf(shared.nodeOrder, key))
			table.insert(shared.nodeOrder, 1, key)
			table.insert(shared.nodeOrder, 2, "copy_1")
			local original = shared.indicatorColors[key]
			original.modifiers = { notActive = true }
			shared.indicatorColors.copy_1 = { copyOf = key, enabled = true, color = COPY, color2 = COPY, gradientDirection = "disabled", targets = {} }
			-- The first of the spec's bars this draw paints.
			local barKey = nil
			for _, barDef in ipairs(barDefs) do
				if barKey == nil then
					original.enabled, original.color, original.targets = true, ORIGINAL, { [barDef.key] = { border = true } }
					shared.indicatorColors.copy_1.targets = { [barDef.key] = { bar = true } }
					Draw({ [key] = false })
					if drv.borders[ORIGINAL] then barKey = barDef.key end
				end
			end
			barKey = barKey or barDefs[1].key
			check(label .. ": Not Active " .. key .. " paints the " .. barKey .. " border while its condition is not met", drv.borders[ORIGINAL] == true)
			check(label .. ": while its copy stays off", not drv.fills[COPY])
			Draw({ [key] = true })
			check(label .. ": and stays off while it is met", not drv.borders[ORIGINAL])
			check(label .. ": while its copy paints the fill", drv.fills[COPY] == true)

			original.modifiers = nil
			shared.indicatorColors.copy_1.modifiers = { notActive = true }
			Draw({ [key] = false })
			check(label .. ": a Not Active copy paints while its built-in is not met", drv.fills[COPY] == true and not drv.borders[ORIGINAL])

			shared.indicatorColors.copy_1.modifiers = nil
			original.modifiers = { onlyInCombat = true }
			Draw({ [key] = true })
			check(label .. ": an Only In Combat " .. key .. " stays off out of combat while its condition is met", not drv.borders[ORIGINAL])
			-- In combat a gradient on the same element paints it through a curve instead, so gradients go off here.
			for _, k in ipairs(shared.gradientOrder or {}) do
				if shared.indicatorColors[k] ~= nil then shared.indicatorColors[k].enabled = false end
			end
			TRB.Data.character.inCombat = true
			Draw({ [key] = true })
			check(label .. ": and paints in combat", drv.borders[ORIGINAL] == true)
			TRB.Data.character.inCombat = false
			Restore(shared, backup)
		end

		-- Built-ins seeded with Only In Combat: off out of combat, on in combat, and on out of combat once it's turned off.
		local SEEDED = "FF0F0F03"
		for _, seededKey in ipairs(Table:DeepCopy(shared.nodeOrder) --[[@as string[] ]]) do
			local indicator = shared.indicatorColors[seededKey]
			local modifiers = indicator ~= nil and indicator.custom == nil and indicator.copyOf == nil and indicator.modifiers or nil
			if modifiers ~= nil and modifiers.onlyInCombat == true and #barDefs > 0 then
				table.remove(shared.nodeOrder, IndexOf(shared.nodeOrder, seededKey))
				table.insert(shared.nodeOrder, 1, seededKey)
				-- In combat a gradient on the same element paints it through a curve instead.
				for _, k in ipairs(shared.gradientOrder or {}) do
					if shared.indicatorColors[k] ~= nil then shared.indicatorColors[k].enabled = false end
				end
				-- Met after Not Active's flip, so only the combat gate decides.
				local force = { [seededKey] = not modifiers.notActive }
				indicator.enabled, indicator.color = true, SEEDED
				TRB.Data.character.inCombat = true
				local paintedIn = false
				for _, barDef in ipairs(barDefs) do
					if not paintedIn then
						indicator.targets = { [barDef.key] = { border = true } }
						Draw(force)
						paintedIn = drv.borders[SEEDED] == true
					end
				end
				check(label .. ": " .. seededKey .. ", seeded Only In Combat, paints in combat", paintedIn)
				TRB.Data.character.inCombat = false
				Draw(force)
				check(label .. ": and not out of combat", not drv.borders[SEEDED])
				indicator.modifiers = { notActive = modifiers.notActive, onlyInCombat = false }
				Draw(force)
				check(label .. ": until Only In Combat is turned off", drv.borders[SEEDED] == true)
				Restore(shared, backup)
			end
		end
		for _, seededKey in ipairs(Table:DeepCopy(shared.gradientOrder or {}) --[[@as string[] ]]) do
			local indicator = shared.indicatorColors[seededKey]
			if indicator ~= nil and indicator.copyOf == nil and indicator.enabled and indicator.modifiers ~= nil and indicator.modifiers.onlyInCombat == true then
				indicator.color = SEEDED
				TRB.Data.character.inCombat = true
				Draw()
				check(label .. ": the " .. seededKey .. " gradient, seeded Only In Combat, applies in combat", drv.curves[SEEDED] == true)
				TRB.Data.character.inCombat = false
				Draw()
				check(label .. ": and not out of combat", not drv.curves[SEEDED])
				indicator.modifiers = { onlyInCombat = false }
				Draw()
				check(label .. ": until Only In Combat is turned off", drv.curves[SEEDED] == true)
				Restore(shared, backup)
			end
		end
	end

	return errors
end

return hooks
