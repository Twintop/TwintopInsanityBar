-- Checks built-in Color Indicator copies and deletions through the settings reconcile, the options, and every
-- specialization's render, where gradient copies resolve per element with the top of the list winning.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}
-- Colors painted and curved during a draw, the condition forced on, and what the options built.
local drv = { borders = {}, fills = {}, curveColors = {}, force = nil, groups = {}, panels = {}, menus = {}, popups = {}, deleteButtons = {} }

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

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	G.UnitStagger = function() return 0 end
	-- The stubs' frames forget their anchors and parents' children, which the options need to move rows.
	local createFrame = G.CreateFrame
	G.CreateFrame = function(frameType, name, parent, ...)
		local frame = createFrame(frameType, name, parent, ...)
		if type(frame) == "table" then
			local children = type(parent) == "table" and rawget(parent, "__children") or nil
			if children ~= nil then
				children[#children + 1] = frame
			end
			local points = {}
			rawset(frame, "SetPoint", function(_, point, relativeTo, relativePoint, x, y)
				if type(relativeTo) == "number" then
					relativeTo, relativePoint, x, y = nil, point, relativeTo, relativePoint
				end
				for i = #points, 1, -1 do
					if points[i][1] == point then table.remove(points, i) end
				end
				points[#points + 1] = { point, relativeTo, relativePoint or point, x or 0, y or 0 }
			end)
			rawset(frame, "ClearAllPoints", function() wipe(points) end)
			rawset(frame, "GetNumPoints", function() return #points end)
			rawset(frame, "GetPoint", function(_, index)
				local p = points[index or 1]
				if p ~= nil then return p[1], p[2], p[3], p[4], p[5] end
			end)
		end
		return frame
	end
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
	local buildCurve = Color.BuildResourceThresholdCurve
	Color.BuildResourceThresholdCurve = function(self, specSettings, belowColor, aboveColor, ...)
		if aboveColor ~= nil then drv.curveColors[aboveColor] = true end
		return buildCurve(self, specSettings, belowColor, aboveColor, ...)
	end
	local applyIndicators = Color.ApplyIndicatorColors
	Color.ApplyIndicatorColors = function(self, sharedColors, conditionMap, ...)
		if drv.force ~= nil and conditionMap ~= nil then
			conditionMap[drv.force] = true
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
	local buildDelete = Primitives.BuildDeleteIconButton
	Primitives.BuildDeleteIconButton = function(self, parent, ...)
		local button = buildDelete(self, parent, ...)
		-- Each list builds its rows in order, so a list's Nth button is its Nth row's.
		local list = debug.getinfo(2, "n").name == "BuildGradientRow" and "gradient" or "flat"
		drv.deleteButtons[parent] = drv.deleteButtons[parent] or { flat = {}, gradient = {} }
		table.insert(drv.deleteButtons[parent][list], button)
		return button
	end
	local Indicators = TRB.Functions.OptionsUi.Indicators
	local generate = Indicators.GenerateIndicatorColorsPanel
	Indicators.GenerateIndicatorColorsPanel = function(self, parent, controls, spec, classId, specId, yCoord, config)
		building = { parent = parent, spec = spec, classId = classId, specId = specId, config = config, buttons = {} }
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
	local Table = TRB.Functions.Table
	local Character = TRB.Functions.Character
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
	local function Count(list, key)
		local n = 0
		for _, k in ipairs(list or {}) do
			if k == key then n = n + 1 end
		end
		return n
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

	local entries = {}
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if entry.classId == ctx.classId then
			entries[#entries + 1] = entry
		end
	end
	-- The login spec goes last, so its panel is the one the options checks drive.
	if #entries > 1 then
		table.insert(entries, table.remove(entries, 1))
	end

	-- Settings: deletions and copies survive the reconcile and a login's merge; a merging profile piece clears them.
	local settingsEntry = nil
	for _, entry in ipairs(entries) do
		local defaults = Settings:GetDefaultSharedIndicators(entry.compositeKey)
		if settingsEntry == nil and defaults ~= nil and #defaults.nodeOrder > 0 then
			settingsEntry = entry
		end
	end
	if settingsEntry ~= nil then
		local label = settingsEntry.compositeKey
		local defaults = Settings:GetDefaultSharedIndicators(settingsEntry.compositeKey)
		local specSettings = TRB.Data.settings[settingsEntry.className][settingsEntry.specName]
		local shared = specSettings.colors.shared
		local backup = Table:DeepCopy(shared)
		local key = defaults.nodeOrder[1]
		local function Merged()
			local merged = Table:Merge({ colors = { shared = Table:DeepCopy(defaults) } }, { colors = { shared = Table:DeepCopy(shared) } })
			Settings:ReconcileSharedIndicators(merged, defaults)
			return merged.colors.shared
		end

		table.remove(shared.nodeOrder, IndexOf(shared.nodeOrder, key))
		shared.removed = { [key] = true }
		try("reconcile", function() Settings:ReconcileAllSharedIndicators(TRB.Data.settings) end)
		check(label .. ": a deleted built-in stays out after the reconcile", IndexOf(shared.nodeOrder, key) == nil)
		local merged = Merged()
		local othersOnce = true
		for _, k in ipairs(defaults.nodeOrder) do
			if k ~= key and Count(merged.nodeOrder, k) ~= 1 then othersOnce = false end
		end
		check(label .. ": and after a login's merge over the defaults, with every other built-in listed once", IndexOf(merged.nodeOrder, key) == nil and othersOnce)

		shared.indicatorColors.copy_1 = { copyOf = key, color = "FF010203", enabled = true, targets = {} }
		table.insert(shared.nodeOrder, "copy_7")
		try("reconcile", function() Settings:ReconcileAllSharedIndicators(TRB.Data.settings) end)
		check(label .. ": a copy missing from the list is added back at the end", shared.nodeOrder[#shared.nodeOrder] == "copy_1")
		check(label .. ": a listed copy with no settings is dropped", IndexOf(shared.nodeOrder, "copy_7") == nil)
		check(label .. ": a copy survives a login's merge", Count(Merged().nodeOrder, "copy_1") == 1)
		if defaults.gradientOrder ~= nil and #defaults.gradientOrder > 0 then
			shared.indicatorColors.copy_2 = { copyOf = defaults.gradientOrder[1], isGradient = true, color = "FF040506", enabled = true, targets = {} }
			table.insert(shared.nodeOrder, "copy_2")
			try("reconcile", function() Settings:ReconcileAllSharedIndicators(TRB.Data.settings) end)
			check(label .. ": a gradient copy moves to its built-in's list", IndexOf(shared.gradientOrder, "copy_2") ~= nil and IndexOf(shared.nodeOrder, "copy_2") == nil)
		end

		Settings:ClearUserIndicatorsForMerge(specSettings, { colors = { shared = { indicatorColors = {} } } })
		check(label .. ": a merging profile piece clears copies and deletions", shared.indicatorColors.copy_1 == nil and shared.indicatorColors.copy_2 == nil
			and shared.removed == nil and IndexOf(shared.nodeOrder, "copy_1") == nil and IndexOf(shared.gradientOrder, "copy_2") == nil)
		Restore(shared, backup)
	else
		check("no specialization has built-in Color Indicators to delete", true)
	end

	-- Every options tab, so each specialization's Color Indicators panel is built.
	try("ConstructOptionsPanel", function() TRB.Options:ConstructOptionsPanel() end)
	local Tabs = TRB.Functions.OptionsUi.Tabs
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
	local function FindPanel(specId)
		local found = nil
		for _, panel in ipairs(drv.panels) do
			if panel.classId == ctx.classId and panel.specId == specId then found = panel end
		end
		return found
	end
	local function FindButton(panel, text)
		for _, entry in ipairs(panel.buttons) do
			if entry.text == text then return entry.button end
		end
		return nil
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

	-- Options: Add Built-in copies a listed built-in, deleting asks first, and re-adding a deleted one restores its key.
	local loginEntry = entries[#entries]
	local panel = FindPanel(loginEntry.specId)
	check(loginEntry.compositeKey .. ": the Color Indicators panel is built", panel ~= nil)
	if panel ~= nil then
		local shared = panel.spec.colors.shared
		local backup = Table:DeepCopy(shared)
		local defaults = Settings:GetDefaultSharedIndicators(loginEntry.compositeKey)
		local defs = panel.config.indicatorDefs
		local defKeys = {}
		for _, def in ipairs(defs) do defKeys[def.key] = true end
		for _, def in ipairs(panel.config.gradientDefs or {}) do defKeys[def.key] = true end
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
		local function DeleteButton(key, listName)
			local index = RowIndex(key, listName)
			local buttons = drv.deleteButtons[panel.parent]
			return index ~= nil and buttons ~= nil and buttons[listName == "gradientOrder" and "gradient" or "flat"][index] or nil
		end
		local function Delete(key, listName)
			local button = DeleteButton(key, listName or "nodeOrder")
			if button == nil then
				return false
			end
			local before = #drv.popups
			try("delete " .. key, function() button.__scripts.OnClick(button) end)
			local popup = drv.popups[#drv.popups]
			if #drv.popups == before or popup.which ~= "TwintopResourceBar_ConfirmDeleteCustomIndicator" then
				return false
			end
			try("confirm delete " .. key, function() popup.data.remove() end)
			return true
		end
		local function OpenMenu(button)
			try("open menu", function() button.__scripts.OnClick(button) end)
			return drv.menus[#drv.menus]
		end
		local function MenuInOrder(menu, sorted)
			local inOrder = #menu.children == #sorted
			for i, child in ipairs(menu.children) do
				if sorted[i] == nil or child.label ~= (sorted[i].colorLabel or sorted[i].key) then inOrder = false end
			end
			return inOrder
		end
		local function PointY(frame)
			local _, _, _, _, y = frame:GetPoint(1)
			return y
		end

		local addBuiltIn = FindButton(panel, L["BuiltInIndicatorAddButton"])
		if #defs == 0 then
			check(loginEntry.compositeKey .. ": no built-ins, no Add Built-in button", addBuiltIn == nil)
		elseif addBuiltIn == nil then
			check(loginEntry.compositeKey .. ": the Add Built-in button is built", false)
		else
			local sorted = SortedLabels(defs)
			local menu = OpenMenu(addBuiltIn)
			check(loginEntry.compositeKey .. ": the Add Built-in menu lists every built-in, sorted by label", MenuInOrder(menu, sorted))

			local key = sorted[1].key
			try("pick " .. key, function() menu.children[1].fn() end)
			local copyKey = shared.nodeOrder[#shared.nodeOrder]
			local copy = shared.indicatorColors[copyKey]
			check(loginEntry.compositeKey .. ": picking a listed built-in adds a copy at the bottom", copyKey:match("^copy_%d+$") ~= nil and copy ~= nil and copy.copyOf == key)
			local defaultColor = defaults ~= nil and defaults.indicatorColors[key] ~= nil and defaults.indicatorColors[key].color or nil
			check(loginEntry.compositeKey .. ": the copy starts off, untargeted, in the built-in's default color", copy ~= nil and copy.enabled == false
				and next(copy.targets) == nil and copy.color == defaultColor)

			check(loginEntry.compositeKey .. ": deleting a built-in asks first", Delete(key))
			check(loginEntry.compositeKey .. ": a deleted built-in leaves the list, off and recorded", IndexOf(shared.nodeOrder, key) == nil
				and shared.removed ~= nil and shared.removed[key] == true and shared.indicatorColors[key].enabled == false)
			check(loginEntry.compositeKey .. ": its copy stays", IndexOf(shared.nodeOrder, copyKey) ~= nil)

			menu = OpenMenu(addBuiltIn)
			try("re-add " .. key, function() menu.children[1].fn() end)
			check(loginEntry.compositeKey .. ": adding a deleted built-in restores its own key at the bottom", shared.nodeOrder[#shared.nodeOrder] == key
				and (shared.removed == nil or shared.removed[key] == nil) and shared.indicatorColors[key].copyOf == nil)

			check(loginEntry.compositeKey .. ": deleting a copy asks first", Delete(copyKey))
			check(loginEntry.compositeKey .. ": a deleted copy is gone", shared.indicatorColors[copyKey] == nil and IndexOf(shared.nodeOrder, copyKey) == nil)
		end

		local gradientDefs = panel.config.gradientDefs or {}
		local addGradient = FindButton(panel, L["BuiltInGradientAddButton"])
		if #gradientDefs == 0 then
			check(loginEntry.compositeKey .. ": no gradient built-ins, no Add Built-in Gradient Color button", addGradient == nil)
		elseif addGradient == nil then
			check(loginEntry.compositeKey .. ": the Add Built-in Gradient Color button is built", false)
		else
			local sorted = SortedLabels(gradientDefs)
			local menu = OpenMenu(addGradient)
			check(loginEntry.compositeKey .. ": the gradient menu lists every gradient built-in, sorted by label", MenuInOrder(menu, sorted))

			local key = sorted[1].key
			local buttonY = PointY(addGradient)
			try("pick gradient " .. key, function() menu.children[1].fn() end)
			local copyKey = shared.gradientOrder[#shared.gradientOrder]
			local copy = shared.indicatorColors[copyKey]
			check(loginEntry.compositeKey .. ": picking a listed gradient adds a gradient copy at the bottom", copyKey:match("^copy_%d+$") ~= nil and copy ~= nil
				and copy.copyOf == key and copy.isGradient == true and copy.enabled == false and next(copy.targets) == nil)
			local copyButton = DeleteButton(copyKey, "gradientOrder")
			check(loginEntry.compositeKey .. ": the new gradient row takes the Add button's place and the button moves down",
				copyButton ~= nil and PointY(copyButton) == buttonY and PointY(addGradient) == buttonY - 30)

			check(loginEntry.compositeKey .. ": deleting a gradient built-in asks first", Delete(key, "gradientOrder"))
			check(loginEntry.compositeKey .. ": a deleted gradient built-in leaves the list, off and recorded", IndexOf(shared.gradientOrder, key) == nil
				and shared.removed ~= nil and shared.removed[key] == true and shared.indicatorColors[key].enabled == false)
			check(loginEntry.compositeKey .. ": and the button moves back up", PointY(addGradient) == buttonY)

			-- With the list emptied, a restored row still lands where the button was.
			while #shared.gradientOrder > 0 do
				if not Delete(shared.gradientOrder[1], "gradientOrder") then break end
			end
			check(loginEntry.compositeKey .. ": every gradient row can be deleted", #shared.gradientOrder == 0)
			buttonY = PointY(addGradient)
			menu = OpenMenu(addGradient)
			try("re-add gradient " .. key, function() menu.children[1].fn() end)
			local restoredButton = DeleteButton(key, "gradientOrder")
			check(loginEntry.compositeKey .. ": re-adding a deleted gradient restores its own key", shared.gradientOrder[1] == key
				and (shared.removed == nil or shared.removed[key] == nil) and shared.indicatorColors[key].copyOf == nil)
			check(loginEntry.compositeKey .. ": in the emptied list's first slot", restoredButton ~= nil and PointY(restoredButton) == buttonY)

			-- The priority list growing above moves the gradient section with it.
			if addBuiltIn ~= nil then
				buttonY = PointY(addGradient)
				menu = OpenMenu(addBuiltIn)
				try("flat add", function() menu.children[1].fn() end)
				check(loginEntry.compositeKey .. ": a priority list row pushes the gradient section down", PointY(addGradient) == buttonY - 30
					and PointY(restoredButton) == buttonY)
				menu = OpenMenu(addGradient)
				try("gradient add after flat add", function() menu.children[1].fn() end)
				local nextButton = DeleteButton(shared.gradientOrder[#shared.gradientOrder], "gradientOrder")
				check(loginEntry.compositeKey .. ": and a gradient row added after it lands under the moved rows", nextButton ~= nil and PointY(nextButton) == buttonY - 30)
			end
		end
		Restore(shared, backup)
	end

	-- Renders: each specialization's real update, with a copy and its built-in on different elements of a bar.
	local function SetSpec(index)
		desktop.GetSpecialization = function() return index end
		desktop.C_SpecializationInfo.GetSpecialization = function() return index end
	end
	local function Draw()
		wipe(drv.borders)
		wipe(drv.fills)
		wipe(drv.curveColors)
		try("power", function() Character:UpdateResourceValues() end)
		return try("draw", function() TRB.Functions.Class:TriggerResourceBarUpdates() end)
	end
	local ORIGINAL, COPY, LOWER = "FF0A0B01", "FF0A0B02", "FF0A0B03"
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

		-- Flat: the built-in on a bar's border, its copy on the fill, both under one forced condition.
		local key = nil
		for _, k in ipairs(shared.nodeOrder) do
			local indicator = shared.indicatorColors[k]
			if key == nil and indicator ~= nil and indicator.custom == nil and indicator.copyOf == nil then key = k end
		end
		if key == nil or #barDefs == 0 then
			check(label .. ": no built-in Color Indicator to copy", key == nil)
		else
			TRB.Data.character.inCombat = false
			table.remove(shared.nodeOrder, IndexOf(shared.nodeOrder, key))
			table.insert(shared.nodeOrder, 1, key)
			table.insert(shared.nodeOrder, 2, "copy_1")
			local original = shared.indicatorColors[key]
			shared.indicatorColors.copy_1 = { copyOf = key, enabled = true, color = COPY, color2 = COPY, gradientDirection = "disabled", targets = {} }
			drv.force = key
			-- The first of the spec's bars this draw paints.
			local barKey = nil
			for _, barDef in ipairs(barDefs) do
				if barKey == nil then
					original.enabled, original.color, original.targets = true, ORIGINAL, { [barDef.key] = { border = true } }
					shared.indicatorColors.copy_1.targets = { [barDef.key] = { bar = true } }
					Draw()
					if drv.borders[ORIGINAL] then barKey = barDef.key end
				end
			end
			barKey = barKey or barDefs[1].key
			check(label .. ": " .. key .. " paints the " .. barKey .. " border", drv.borders[ORIGINAL] == true)
			check(label .. ": its copy paints the " .. barKey .. " fill", drv.fills[COPY] == true)

			table.remove(shared.nodeOrder, 1)
			shared.removed = { [key] = true }
			original.enabled, original.targets = false, {}
			shared.indicatorColors.copy_1.targets = { [barKey] = { border = true } }
			Draw()
			check(label .. ": with " .. key .. " deleted, its copy still paints the border", drv.borders[COPY] == true and not drv.borders[ORIGINAL])
			drv.force = nil
			Restore(shared, backup)
		end

		-- Gradient: Overcap on the border, a copy on the background, and a lower copy on the border that loses.
		local overcap = shared.indicatorColors.borderOvercap
		local overcapBar = nil
		if overcap ~= nil and overcap.isGradient and IndexOf(shared.gradientOrder, "borderOvercap") ~= nil then
			for k, elements in pairs(overcap.targets or {}) do
				if overcapBar == nil and elements.border then overcapBar = k end
			end
		end
		if overcapBar ~= nil then
			TRB.Data.character.inCombat = true
			overcap.enabled, overcap.color, overcap.targets = true, ORIGINAL, { [overcapBar] = { border = true } }
			table.remove(shared.gradientOrder, IndexOf(shared.gradientOrder, "borderOvercap"))
			table.insert(shared.gradientOrder, 1, "borderOvercap")
			table.insert(shared.gradientOrder, 2, "copy_1")
			table.insert(shared.gradientOrder, 3, "copy_2")
			shared.indicatorColors.copy_1 = { copyOf = "borderOvercap", isGradient = true, enabled = true, color = COPY, targets = { [overcapBar] = { background = true } } }
			shared.indicatorColors.copy_2 = { copyOf = "borderOvercap", isGradient = true, enabled = true, color = LOWER, targets = { [overcapBar] = { border = true } } }
			Draw()
			check(label .. ": Overcap curves the " .. overcapBar .. " border and its copy the background", drv.curveColors[ORIGINAL] == true and drv.curveColors[COPY] == true)
			check(label .. ": a lower Overcap copy on the same border loses", not drv.curveColors[LOWER])

			table.remove(shared.gradientOrder, 1)
			shared.removed = { borderOvercap = true }
			overcap.enabled, overcap.targets = false, {}
			Draw()
			check(label .. ": with Overcap deleted, the next copy takes the border", drv.curveColors[LOWER] == true and not drv.curveColors[ORIGINAL] and drv.curveColors[COPY] == true)
			TRB.Data.character.inCombat = false
			Restore(shared, backup)
		end
	end

	return errors
end

return hooks
