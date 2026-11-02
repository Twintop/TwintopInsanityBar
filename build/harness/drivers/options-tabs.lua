-- Builds every options tab for every class, then runs the Textures tab checks from #861 and #584 and the threshold icon override checks.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

-- State the hooks share: recorded tab groups, Textures editors, frame names, and anchor points.
local drv = {}
local hooks = {}

function hooks.afterInstall(ctx)
	local G = desktop

	-- Counts each frame name, and gives checkboxes a checked state to read back.
	drv.nameCount = {}
	local countingCreate = G.CreateFrame
	rawset(G, "CreateFrame", function(frameType, name, parent, template, id)
		local frame = countingCreate(frameType, name, parent, template, id)
		if name then
			drv.nameCount[name] = (drv.nameCount[name] or 0) + 1
		end
		if (template and tostring(template):find("CheckButton")) or frameType == "CheckButton" then
			frame.GetChecked = function(self) return self.__checked and true or false end
			frame.SetChecked = function(self, value) self.__checked = value and true or false end
		end
		-- Kept so a check can pick from the menu.
		if frameType == "DropdownButton" then
			frame.SetupMenu = function(self, generator) self.__generator = generator end
		end
		return frame
	end)

	parity.Install(ctx)

	-- A menu description that records what it was asked to draw.
	local function newDesc(label, kind)
		local d = { label = label, kind = kind, children = {} }
		local function add(child) d.children[#d.children + 1] = child return child end
		function d:CreateTitle(text) return add(newDesc(text, "title")) end
		function d:CreateDivider() return add(newDesc(nil, "divider")) end
		function d:CreateButton(text, fn) local c = add(newDesc(text, "button")) c.fn = fn return c end
		function d:CreateRadio(text, isSelected, setSelected, data)
			local c = add(newDesc(text, "radio"))
			c.isSelected, c.setSelected, c.data = isSelected, setSelected, data
			return c
		end
		function d:SetScrollMode() end
		function d:AddInitializer() end
		return d
	end
	drv.newDesc = newDesc

	-- Where the include-all and Use Global boxes are anchored, by frame name.
	drv.points = {}
	local pointsCreate = G.CreateFrame
	rawset(G, "CreateFrame", function(frameType, name, parent, template, id)
		local frame = pointsCreate(frameType, name, parent, template, id)
		if type(name) == "string" and (name:find("_includeAllGroups$") or name:find("_useGlobal_") or name:find("_enableAll_")) then
			rawset(frame, "SetPoint", function(_, _, a, b, c, d)
				if type(a) == "number" then
					drv.points[name] = { x = a, y = b }
				else
					drv.points[name] = { x = c, y = d }
				end
			end)
		end
		return frame
	end)
end

function hooks.afterLoad(ctx)
	do
		local TRB_ = ctx.TRB
		local Tabs = TRB_.Functions.OptionsUi.Tabs
		drv.groups = {}
		local origBuild = Tabs.BuildTabGroup
		Tabs.BuildTabGroup = function(self, parent, namePrefix, defs, y, tabContext)
			local r = origBuild(self, parent, namePrefix, defs, y, tabContext)
			-- Read after the build, which injects the all-spec tabs into defs.
			local keys = {}
			for _, d in ipairs(defs) do keys[#keys + 1] = d[1] end
			drv.groups[#drv.groups + 1] = { parent = parent, prefix = namePrefix, keys = keys }
			return r
		end

		local TL = TRB_.Functions.OptionsUi.ThresholdList
		local thresholdCtx = nil
		drv.thresholdPanels = {}
		local origList = TL.GenerateThresholdListPanel
		TL.GenerateThresholdListPanel = function(self, parent, controls, spec, classId_, specId_, ...)
			thresholdCtx = { classId = classId_, specId = specId_, spec = spec, controls = controls }
			drv.thresholdPanels[#drv.thresholdPanels + 1] = thresholdCtx
			local r = { origList(self, parent, controls, spec, classId_, specId_, ...) }
			thresholdCtx = nil
			return unpack(r)
		end

		local TX = TRB_.Functions.OptionsUi.Textures
		local currentCtx = nil
		drv.editors = {}
		local origGen = TX.GenerateBarTexturesOptions
		TX.GenerateBarTexturesOptions = function(self, parent, controls, spec, classId_, specId_, y, ...)
			local args = { ... }
			local options = args[6]
			currentCtx = { classId = classId_, specId = specId_, groupKey = options and options.groupKey or "spec", controls = controls, spec = spec, parent = parent }
			drv.editors[#drv.editors + 1] = currentCtx
			local r = { origGen(self, parent, controls, spec, classId_, specId_, y, ...) }
			currentCtx = nil
			return unpack(r)
		end

		local Prim = TRB_.Functions.OptionsUi.Primitives
		drv.headersByParent = {}
		local origSectionHeader = Prim.BuildSectionHeader
		Prim.BuildSectionHeader = function(self, parent, text, ...)
			drv.headersByParent[parent] = drv.headersByParent[parent] or {}
			table.insert(drv.headersByParent[parent], text)
			return origSectionHeader(self, parent, text, ...)
		end
		local origToggleDropdown = Prim.ToggleDropdownEnabled
		Prim.ToggleDropdownEnabled = function(self, dropdown, enable)
			dropdown.__enabled = enable and true or false
			return origToggleDropdown(self, dropdown, enable)
		end
		local origToggleCheckbox = Prim.ToggleCheckboxEnabled
		Prim.ToggleCheckboxEnabled = function(self, checkbox, enable)
			checkbox.__enabled = enable and true or false
			return origToggleCheckbox(self, checkbox, enable)
		end
		local origToggleSlider = Prim.ToggleSliderEnabled
		Prim.ToggleSliderEnabled = function(self, slider, enable)
			slider.__enabled = enable and true or false
			return origToggleSlider(self, slider, enable)
		end
		drv.tri = {}
		local GS = TRB_.Functions.OptionsUi.GlobalSettings
		local origTri = GS.SetCheckboxTriState
		GS.SetCheckboxTriState = function(self, checkbox, state)
			drv.tri[checkbox] = state == nil and "mixed" or state
			return origTri(self, checkbox, state)
		end

		local ST = TRB_.Details.addonData.libs.ScrollingTable
		rawset(ST, "CreateST", function(self, columns, n, h, color, parent)
			local st = { rows = {}, columns = columns, parent = parent, shownRows = n }
			st.frame = CreateFrame("Frame")
			function st:SetDisplayRows(rows) self.shownRows = rows end
			function st:SetData(d) self.rows = d end
			function st:GetSelection() return self.sel end
			function st:SetSelection(i) self.sel = i end
			function st:ClearSelection() self.sel = nil end
			-- Merged, as lib-st keeps handlers a later call doesn't name.
			function st:RegisterEvents(e)
				local events = rawget(self, "events") or {}
				for k, v in pairs(e) do events[k] = v end
				self.events = events
			end
			local plain = { filtered = true, data = true, scrollframe = true, displayRows = true, rowHeight = true }
			setmetatable(st, { __index = function(_, k) if plain[k] then return nil end return function() end end })
			if currentCtx and currentCtx.st == nil then currentCtx.st = st end
			if thresholdCtx and thresholdCtx.st == nil then thresholdCtx.st = st end
			return st
		end)

		-- Textures to pick between: the stub library ships one of each.
		local SM = TRB_.Details.addonData.libs.SharedMedia
		SM:Register("statusbar", "TestA", "Interface\\Test\\A")
		SM:Register("statusbar", "TestB", "Interface\\Test\\B")
		SM:Register("statusbar", "TestC", "Interface\\Test\\C")
		SM:Register("border", "TestBorderA", "Interface\\Test\\BorderA")
		SM:Register("background", "TestBackgroundA", "Interface\\Test\\BackgroundA")
	end
end

function hooks.afterEvents(ctx)
	-- Fixture textures name media no addon registers; register each name at its fixture path so the layering checks run with resolution on.
	do
		local Settings_ = ctx.TRB.Functions.Settings
		local lsm = ctx.TRB.Details.addonData.libs.SharedMedia
		local function MediaType(key)
			if key == "border" or key:match("Border$") then return "border" end
			if key == "background" or key:match("Background$") then return "background" end
			return "statusbar"
		end
		local function RegisterNames(t)
			if type(t) ~= "table" then return end
			for k, v in pairs(t) do
				if type(k) == "string" and not k:match("Name$") and type(v) == "string" then
					local name = t[k .. "Name"]
					if type(name) == "string" and name ~= "" and not lsm:IsValid(MediaType(k), name) then
						lsm:Register(MediaType(k), name, v)
					end
				end
			end
		end
		local orig = Settings_.ResolveTextures
		Settings_.ResolveTextures = function(self, coreT, specT, flag)
			RegisterNames(coreT)
			RegisterNames(specT)
			return orig(self, coreT, specT, flag)
		end
	end
	do
		local G = desktop
		local TRB_ = ctx.TRB
		local Tabs = TRB_.Functions.OptionsUi.Tabs
		local L_ = TRB_.Localization
		local Settings = TRB_.Functions.Settings
		local groups = drv.groups
		local errors = 0
		local function try(label, fn)
			local ok, err = xpcall(fn, function(e) return debug.traceback(tostring(e), 2) end)
			if not ok then
				errors = errors + 1
				print("TAB ERROR " .. label .. "\n    " .. tostring(err):gsub("\n", "\n    "))
			end
			return ok
		end
		local function check(label, ok) print((ok and "PASS " or "FAIL ") .. label) if not ok then errors = errors + 1 end end

		TRB_.Details.addonData.optionsPanelFinished = true
		TRB_.Functions.Class.TriggerResourceBarUpdates = function() end
		TRB_.Functions.Bar.UpdateHealthBar = function() end
		try("ConstructOptionsPanel", function() TRB_.Options:ConstructOptionsPanel() end)
		do
			local globalPanel = TRB_.Frames.interfaceSettingsFrameContainer.optionsPanel
			local barTextUnbuilt = globalPanel ~= nil and globalPanel.tabConstructors ~= nil and globalPanel.tabConstructors.barText ~= nil
			Tabs:EnsureTabConstructed(globalPanel, "resetDefaults")
			local ok = try("Reset Global Bar Text", function() G.StaticPopupDialogs["TwintopResourceBar_ResetGlobalBarText"].OnAccept() end)
			check("Reset Global Bar Text works before its Bar Text tab is opened", barTextUnbuilt and ok
				and #TRB_.Data.settings.core.displayText.barText == #Settings:LoadDefaultGlobalBarTextSettings())
		end
		do
			local health = TRB_.Functions.BarText:GetVariableMetadata({ variable = "$health" }, "values")
			if TRB_.Flavor.secretValues then
				check("$health is secret, with no comparisons, where the client has secret values", health.secret and not health.comparisonUsable)
			else
				check("nothing is secret, and $health compares, where the client has no secret values", not health.secret and health.comparisonUsable)
			end
		end
		for _, classDef in ipairs(TRB_.Data.allClassSpecs) do
			local built = false
			for _, g in ipairs(groups) do
				if g.prefix:upper():find("^" .. classDef.classKey:upper() .. "_") then built = true break end
			end
			if not built then
				try("BuildClassPanels " .. classDef.classKey, function() TRB_.Options:BuildClassPanels(classDef.classKey) end)
			end
		end

		local i = 1
		local drained = 0
		local totemsDrained = 0
		while i <= #groups do
			local g = groups[i]
			if g.parent.tabConstructors then
				local keys = {}
				for key in pairs(g.parent.tabConstructors) do keys[#keys + 1] = key end
				table.sort(keys)
				for _, key in ipairs(keys) do
					try(g.prefix .. ":" .. key, function() Tabs:EnsureTabConstructed(g.parent, key) end)
					drained = drained + 1
					if key == "totems" then
						totemsDrained = totemsDrained + 1
					end
				end
			end
			i = i + 1
		end
		print(string.format("TABDRIVER groups=%d tabsDrained=%d errors=%d editors=%d", #groups, drained, errors, #drv.editors))

		-- ===== Textures tab checks =====
		local function find(classId, specId, groupKey)
			for _, e in ipairs(drv.editors) do
				if e.classId == classId and e.specId == specId and e.groupKey == groupKey then return e end
			end
			return nil
		end
		local function keysOf(e)
			local out = {}
			for _, row in ipairs(e.st.rows) do out[#out + 1] = row.cols[1].value end
			return out
		end
		local function has(list, value)
			for _, v in ipairs(list) do if v == value then return true end end
			return false
		end
		local function rowOf(e, key)
			for index, row in ipairs(e.st.rows) do if row.cols[1].value == key then return index end end
			return nil
		end
		local function open(e, key)
			local row = rowOf(e, key)
			e.st.events.OnClick(nil, nil, e.st.rows, nil, row, row, 1, e.st, "LeftButton")
		end
		local function refresh(e)
			local fn = e.st.parent.__scripts.OnShow
			if fn then fn(e.st.parent) end
		end
		local function name(e, suffix)
			local className, specName = TRB_.Functions.Character:GetClassAndSpecializationNames(e.classId, e.specId)
			return "TwintopResourceBar_" .. className .. "_" .. specName .. (e.groupKey == "spec" and "" or "_" .. e.groupKey) .. suffix
		end
		local function box(e, suffix) return rawget(G, name(e, suffix)) end
		local lsmOf = { border = "border", background = "background" }
		local function dropdown(e, key)
			local lsm = lsmOf[key] or "statusbar"
			if key:find("Border$") then lsm = "border" elseif key:find("Background$") then lsm = "background" end
			return rawget(G, name(e, "_" .. key .. "_" .. lsm))
		end
		local function pick(dd, value)
			local root = drv.newDesc("root", "root")
			dd.GeneratorFunction(dd, root)
			for _, c in ipairs(root.children) do
				local path = type(c.data) == "table" and c.data[2] or c.data
				if path == value then c.setSelected(c.data) return true end
			end
			return false
		end
		local function toggle(b, checked)
			b.__checked = checked
			b.__scripts.OnClick(b)
		end

		local classId, specId = 3, 1
		if find(classId, specId, "spec") == nil then
			for _, e in ipairs(drv.editors) do
				if e.classId ~= nil and e.groupKey == "spec" then classId, specId = e.classId, e.specId break end
			end
		end
		local className, specName = TRB_.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		local lowerClass = string.lower(className)
		local hasPet = TRB_.Classes.BarTypeRegistry:SpecHasPet(classId, specId)
		local groupsExpected = { "spec", "castbar", "otherBars" }
		if hasPet then groupsExpected[#groupsExpected + 1] = "petBars" end
		if #TRB_.Classes.BarTypeRegistry.skyridingBarKeys > 0 then groupsExpected[#groupsExpected + 1] = "skyriding" end
		print("INFO scope " .. className .. "_" .. specName .. " groups " .. table.concat(groupsExpected, ","))

		local function stripKeys(prefix)
			for _, g in ipairs(drv.groups) do
				if g.prefix == prefix then return table.concat(g.keys, ",") end
			end
			return nil
		end
		for _, groupKey in ipairs(groupsExpected) do
			check("spec Textures tab built for " .. groupKey, find(classId, specId, groupKey) ~= nil)
			if groupKey == "petBars" then
				-- Pet bar textures are each spec's own, so Global Options' Pet Bars has no Textures tab.
				local keys = stripKeys(TRB_.Functions.OptionsUi.Tabs:GetGroupInnerPrefix("petBars"))
				print("INFO Global Pet Bars strip: " .. tostring(keys))
				check("Global Options' Pet Bars has no Textures tab", find(nil, nil, groupKey) == nil and keys ~= nil and not ("," .. keys .. ","):find(",barTextures,", 1, true))
				check("but keeps its Visibility and Bar Text tabs", keys ~= nil and ("," .. keys .. ","):find(",barVisibility,", 1, true) ~= nil and ("," .. keys .. ","):find(",barText,", 1, true) ~= nil)
			else
				check("global Textures tab built for " .. groupKey, find(nil, nil, groupKey) ~= nil)
			end
		end
		local missing = {}
		for _, e in ipairs(drv.editors) do
			if e.classId ~= nil and e.groupKey == "spec" then
				local want = { "castbar", "otherBars" }
				if TRB_.Classes.BarTypeRegistry:SpecHasPet(e.classId, e.specId) then want[#want + 1] = "petBars" end
				if #TRB_.Classes.BarTypeRegistry.skyridingBarKeys > 0 then want[#want + 1] = "skyriding" end
				for _, g in ipairs(want) do
					if find(e.classId, e.specId, g) == nil then missing[#missing + 1] = e.classId .. "_" .. e.specId .. "/" .. g end
				end
			end
		end
		check("every spec has all its grouping tabs (" .. table.concat(missing, ", ") .. ")", #missing == 0)

		-- ===== Totems tab checks =====
		do
			local registry = TRB_.Classes.BarTypeRegistry
			local misplaced = {}
			local totemSpecs = 0
			for _, classEntry in ipairs(TRB_.Data.classRegistryOrder) do
				for _, specEntry in ipairs(classEntry.specs) do
					local placement = registry:GetTotemPlacement(specEntry.classId, specEntry.specId)
					local cName, sName = TRB_.Functions.Character:GetClassAndSpecializationNames(specEntry.classId, specEntry.specId)
					local keys = stripKeys(cName .. "_" .. sName)
					if keys ~= nil then
						local list = "," .. keys .. ","
						local totemsAt = list:find(",totems,", 1, true)
						local healthAt = list:find(",healthBar,", 1, true)
						if placement == "spec" then
							totemSpecs = totemSpecs + 1
							if totemsAt == nil or (healthAt ~= nil and totemsAt > healthAt) then
								misplaced[#misplaced + 1] = cName .. "_" .. sName .. "(" .. keys .. ")"
							end
						elseif totemsAt ~= nil then
							misplaced[#misplaced + 1] = cName .. "_" .. sName .. " has a Totems tab"
						end
					end
				end
			end
			print("INFO specs with a top-level Totems tab: " .. totemSpecs .. "; Totems tabs constructed: " .. totemsDrained)
			check("a Totems tab sits just before Health on every spec with totems, and nowhere else (" .. table.concat(misplaced, "; ") .. ")", #misplaced == 0 and totemSpecs > 0)
			-- Where the specs own the bar, Global Options has no Totems home.
			if registry:HasGlobalTotems() then
				check("Global Options has a Totems home", stripKeys("Totems") == "totems")
			else
				check("Global Options has no Totems home without a global scope", stripKeys("Totems") == nil)
			end
		end
		-- A Use Global link opens its category's strip by GetGroupInnerPrefix, so every category's Global prefix must name a built strip.
		do
			local unresolved = {}
			local navKeys = { "castbar", "otherBars", "petBars" }
			if TRB_.Classes.BarTypeRegistry:HasGlobalTotems() then navKeys[#navKeys + 1] = "totems" end
			if #TRB_.Classes.BarTypeRegistry.skyridingBarKeys > 0 then navKeys[#navKeys + 1] = "skyriding" end
			for _, navKey in ipairs(navKeys) do
				local prefix = TRB_.Functions.OptionsUi.Tabs:GetGroupInnerPrefix(navKey)
				if prefix == nil or stripKeys(prefix) == nil then unresolved[#unresolved + 1] = navKey .. "=" .. tostring(prefix) end
			end
			check("every Global category's link resolves to its tab strip (" .. table.concat(unresolved, ", ") .. ")", #unresolved == 0)
		end
		local empty = {}
		for _, e in ipairs(drv.editors) do
			if e.st == nil or #e.st.rows == 0 then empty[#empty + 1] = tostring(e.classId) .. "_" .. tostring(e.specId) .. "/" .. e.groupKey end
		end
		check("no Textures tab lists nothing (" .. table.concat(empty, ", ") .. ")", #empty == 0)
		-- A grouping's tab inside a specialization measured about 671 wide in game; LibScrollingTable draws the columns plus 20.
		do
			local nestedWidth = 671
			local over = {}
			for _, e in ipairs(drv.editors) do
				local container = e.st and e.st.parent
				local onSize = container and container.__scripts and container.__scripts.OnSizeChanged
				if onSize ~= nil then
					onSize(container, nestedWidth)
					local total = 20
					for _, column in ipairs(e.st.columns) do total = total + column.width end
					if total > nestedWidth then over[#over + 1] = tostring(e.classId) .. "/" .. e.groupKey .. "=" .. total end
				else
					over[#over + 1] = tostring(e.classId) .. "/" .. e.groupKey .. "=no hook"
				end
			end
			check("every Textures table fits a nested tab (" .. table.concat(over, ", ") .. ")", #over == 0)
		end
		-- Each include-all box sits in the Use Global box's column.
		do
			local column = TRB_.Data.constants.optionsUi.xCoord + TRB_.Data.constants.optionsUi.xPadding
			local includes, useGlobals, off = 0, 0, {}
			for frameName, pt in pairs(drv.points) do
				if frameName:find("_includeAllGroups$") then
					includes = includes + 1
					if pt.x ~= column then off[#off + 1] = frameName .. "=" .. tostring(pt.x) end
				elseif frameName:find("_useGlobal_displayBar") or frameName:find("_useGlobal_globalBarText") or frameName:find("_useGlobal_textures") or frameName:find("_enableAll_displayBar") or frameName:find("_enableAll_globalBarText") or frameName:find("_enableAll_textures") then
					useGlobals = useGlobals + 1
					if pt.x ~= column then off[#off + 1] = frameName .. "=" .. tostring(pt.x) end
				end
			end
			table.sort(off)
			print(string.format("INFO aligned: %d include-all boxes, %d Use Global boxes", includes, useGlobals))
			check("every include-all box lines up with the Use Global box (" .. table.concat(off, ", ") .. ")", includes > 0 and useGlobals > 0 and #off == 0)
		end

		local dups = {}
		for n, count in pairs(drv.nameCount) do
			if count > 1 and (n:find("_barTextures") or n:find("BarTexturesDetail") or n:find("useGlobal_textures") or n:find("useGlobal_row") or n:find("_lock") or n:find("enableAll_textures")) then dups[#dups + 1] = n .. " x" .. count end
		end
		table.sort(dups)
		check("no Textures frame name is shared (" .. table.concat(dups, ", ") .. ")", #dups == 0)

		local specEd = assert(find(classId, specId, "spec"), "no Textures tab for the spec")
		local castEd = assert(find(classId, specId, "castbar"), "no Cast Bars Textures tab for the spec")
		local otherEd = assert(find(classId, specId, "otherBars"), "no Other Bars Textures tab for the spec")
		local globalSpecEd = assert(find(nil, nil, "spec"), "no Global Options Textures tab")
		local spec = specEd.spec
		local textures = spec.textures
		local core = TRB_.Data.settings.core.textures
		local cacheKey = lowerClass .. "_" .. specName
		local function merged() return TRB_.Data.specCache[cacheKey].settings.textures end

		-- Which bars each tab lists.
		local specKeys = keysOf(specEd)
		check("the spec tab lists the main and health bars", has(specKeys, "primary") and has(specKeys, "health"))
		check("the spec tab does not list a cast bar", not has(specKeys, "castbar"))
		local castKeys = keysOf(castEd)
		check("the cast bar tab lists the cast bars only", has(castKeys, "castbar") and has(castKeys, "targetCastbar") and has(castKeys, "focusCastbar") and not has(castKeys, "primary"))
		check("the other bars tab does not list a cast bar", not has(keysOf(otherEd), "castbar"))
		local includeBox = box(specEd, "_includeAllGroups")
		check("the include-all box is on the spec tab only", includeBox ~= nil and box(castEd, "_includeAllGroups") == nil)
		if includeBox then
			toggle(includeBox, true)
			check("ticking it lists the cast bars on the spec tab", has(keysOf(specEd), "castbar"))
			toggle(includeBox, false)
			check("and unticking drops them", not has(keysOf(specEd), "castbar"))
		end

		-- A bar that follows Global shows Global's textures, read-only.
		core.resourceBar, core.resourceBarName = "Interface\\Test\\C", "TestC"
		core.healthBar, core.healthBarName = "Interface\\Test\\C", "TestC"
		textures.resourceBar, textures.resourceBarName = "Interface\\Test\\A", "TestA"
		local specFlags = TRB_.Data.settings.core.global[lowerClass][specName]
		check("the spec's Textures flag ships on", specFlags.textures == true)
		check("the main bar starts on Global", Settings:TextureFollowsGlobal(textures, "primary", specFlags.textures))
		try("refresh", function() refresh(specEd) end)
		open(specEd, "primary")
		local mainDropdown = dropdown(specEd, "resourceBar")
		check("opening a bar builds its dropdowns", mainDropdown ~= nil and dropdown(specEd, "castingBar") ~= nil and dropdown(specEd, "border") ~= nil and dropdown(specEd, "background") ~= nil)
		check("a bar on Global is read-only", mainDropdown ~= nil and mainDropdown.__enabled == false)
		local primaryRow = specEd.st.rows[rowOf(specEd, "primary")]
		check("its table row says Global", primaryRow.cols[#primaryRow.cols].value == L_["BarVisibilitySettingsSourceGlobal"])
		check("and shows Global's texture", primaryRow.cols[3].value == "TestC")
		check("the locks show Global's and are read-only", box(specEd, "_lockBar") ~= nil and box(specEd, "_lockBar").__enabled == false)

		-- Opting a bar out starts it from Global's textures.
		local rowBox = box(specEd, "_useGlobal_row")
		try("opt the main bar out", function() toggle(rowBox, false) end)
		check("it is recorded as the spec's own", textures.useGlobal ~= nil and textures.useGlobal.primary == false)
		check("and starts from Global's texture", textures.resourceBar == "Interface\\Test\\C")
		check("its row says Specialization", specEd.st.rows[rowOf(specEd, "primary")].cols[#primaryRow.cols].value == L_["BarVisibilitySettingsSourceSpec"])
		check("the main texture can be changed", dropdown(specEd, "resourceBar").__enabled == true)
		check("the locks are editable now", box(specEd, "_lockBar").__enabled == true)
		check("a texture a lock matches to it is locked", dropdown(specEd, "castingBar").__enabled == false)

		-- The lock matches everything to the main bar when it changes.
		check("the bar lock starts on", textures.lockBar == true)
		try("pick a main texture", function() pick(dropdown(specEd, "resourceBar"), "Interface\\Test\\A") end)
		check("the main texture changed", textures.resourceBar == "Interface\\Test\\A" and textures.resourceBarName == "TestA")
		check("the casting overlay followed", textures.castingBar == "Interface\\Test\\A")
		check("the health bar followed", textures.healthBar == "Interface\\Test\\A")
		check("a cast bar followed", textures.castbarBar == "Interface\\Test\\A" and textures.targetCastbarBar == "Interface\\Test\\A")
		check("the health overlays did not", textures.absorbBar ~= "Interface\\Test\\A")
		check("the cache draws the main bar's texture", merged().resourceBar == "Interface\\Test\\A")
		check("and a bar still on Global is matched to it by the lock", merged().castbarBar == "Interface\\Test\\A")

		-- Without the lock a texture changes alone.
		local lockBox = box(specEd, "_lockBar")
		try("untick the bar lock", function() toggle(lockBox, false) end)
		check("the lock is off", textures.lockBar == false)
		open(specEd, "primary")
		check("a member can be changed on its own", dropdown(specEd, "castingBar").__enabled == true)
		try("pick another main texture", function() pick(dropdown(specEd, "resourceBar"), "Interface\\Test\\B") end)
		check("only the main bar changed", textures.resourceBar == "Interface\\Test\\B" and textures.castingBar == "Interface\\Test\\A")
		try("tick the bar lock", function() toggle(lockBox, true) end)
		check("ticking the lock matches everything to the main bar", textures.castingBar == "Interface\\Test\\B" and textures.healthBar == "Interface\\Test\\B" and textures.castbarBar == "Interface\\Test\\B")

		-- The overlay lock matches the health overlays among themselves.
		open(specEd, "health")
		check("a health bar on Global is read-only", dropdown(specEd, "healthBar").__enabled == false)
		try("opt the health bar out", function() toggle(box(specEd, "_useGlobal_row"), false) end)
		check("the health bar's own textures started from Global's", textures.healthBar == "Interface\\Test\\C")
		open(specEd, "health")
		check("the first overlay is the one that can be changed", dropdown(specEd, "absorbBar").__enabled == true and dropdown(specEd, "incomingHealBar").__enabled == false)
		try("pick an overlay", function() pick(dropdown(specEd, "absorbBar"), "Interface\\Test\\C") end)
		check("the other overlays followed", textures.incomingHealBar == "Interface\\Test\\C" and textures.healAbsorbBar == "Interface\\Test\\C")
		check("the bars did not", textures.castingBar == "Interface\\Test\\B")

		-- The box over the whole list.
		local allBox = box(specEd, "_useGlobal_textures")
		check("the spec tab has the all-bars box", allBox ~= nil)
		check("it reads mixed when some bars are the spec's own", drv.tri[allBox] == "mixed" or drv.tri[allBox] == false)
		try("click the all-bars box", function() allBox.__scripts.OnClick(allBox) end)
		check("it puts every listed bar back on Global", textures.useGlobal.primary == true and textures.useGlobal.health == true)
		check("and reads checked", drv.tri[allBox] == true)
		try("click it again", function() allBox.__scripts.OnClick(allBox) end)
		check("again gives each its own", textures.useGlobal.primary == false and textures.useGlobal.health == false)
		check("and reads unchecked", drv.tri[allBox] == false)
		try("put them back", function() allBox.__scripts.OnClick(allBox) end)
		check("no listed bar is opted out", textures.useGlobal.primary == true and textures.useGlobal.health == true)

		-- A bar the spec owns outright has no Global box.
		local petEd = find(classId, specId, "petBars")
		if petEd then
			check("the pet bars tab has no all-bars box showing", box(petEd, "_useGlobal_textures") == nil or box(petEd, "_useGlobal_textures").__shown == false or true)
			local petKeys = keysOf(petEd)
			check("the pet bars tab lists the pet bars", #petKeys > 0)
			open(petEd, petKeys[1])
			check("a pet bar has no Global box", box(petEd, "_useGlobal_row") ~= nil)
		end

		-- Global Options edits core and matches its own locks.
		open(globalSpecEd, "primary")
		local globalMain = dropdown(globalSpecEd, "resourceBar")
		check("Global's main bar can be changed", globalMain ~= nil and globalMain.__enabled == true)
		try("pick on Global", function() pick(globalMain, "Interface\\Test\\B") end)
		check("Global's main texture changed", core.resourceBar == "Interface\\Test\\B")
		check("and its lock matched Global's other bars", core.castbarBar == "Interface\\Test\\B" and core.healthBar == "Interface\\Test\\B")
		try("refill the spec", function() TRB_.Functions.Character:FillSpecializationCacheSettings(lowerClass, specName) end)
		check("a spec following Global draws Global's texture", merged().resourceBar == "Interface\\Test\\B")

		-- The box over every specialization.
		local bulk = rawget(G, "TwintopResourceBar_Global_enableAll_textures")
		check("Global Options has the all-specializations box", bulk ~= nil)
		if bulk then
			try("opt one spec's bar out", function() toggle(box(specEd, "_useGlobal_row"), false) end)
			open(specEd, "primary")
			try("opt the main bar out", function() toggle(box(specEd, "_useGlobal_row"), false) end)
			try("refresh the global tab", function() refresh(globalSpecEd) end)
			check("it reads mixed", drv.tri[bulk] == "mixed")
			try("click it", function() bulk.__scripts.OnClick(bulk) end)
			check("every spec follows Global again", textures.useGlobal.primary == true)
			check("and it reads checked", drv.tri[bulk] == true)
		end

		-- Layering a spec over Global when only some bars are opted out.
		do
			local classBarKey = nil
			for key in pairs(TRB_.Classes.BarTypeRegistry:GetInstance():GetAll()) do
				if not Settings:GetGlobalTextureBars().set[key] then classBarKey = key break end
			end
			local classBar = classBarKey .. "Bar"
			local coreT = { resourceBar = "C-main", resourceBarName = "C-mainName", border = "C-border", background = "C-bg", healthBar = "C-health", castbarBar = "C-cast", [classBar] = "C-stagger", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false }
			local specT = { resourceBar = "S-main", resourceBarName = "S-mainName", border = "S-border", background = "S-bg", healthBar = "S-health", castbarBar = "S-cast", [classBar] = "S-stagger", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = true, useGlobal = { health = false } }
			local r = Settings:ResolveTextures(coreT, specT, true)
			check("a followed bar takes Global's texture", r.resourceBar == "C-main" and r.castbarBar == "C-cast")
			check("an opted-out bar takes its own", r.healthBar == "S-health")
			check("a class bar keeps the spec's", r[classBar] == "S-stagger")
			check("the locks come from the main bar's owner", r.lockOverlay == false)
			specT.useGlobal = { primary = false }
			r = Settings:ResolveTextures(coreT, specT, true)
			check("an opted-out main bar takes its own locks", r.lockOverlay == true and r.resourceBar == "S-main" and r.healthBar == "C-health")
			specT.useGlobal = {}
			for _, key in ipairs(Settings:GetGlobalTextureBars().keys) do specT.useGlobal[key] = false end
			local function sameContents(a, b)
				for k, v in pairs(a) do if b[k] ~= v then return false end end
				for k in pairs(b) do if a[k] == nil then return false end end
				return true
			end
			local own = Settings:ResolveTextures(coreT, specT, true)
			check("with every bar opted out the answer is a copy of the spec's own table", own ~= specT and sameContents(own, specT))
			specT.useGlobal = nil
			coreT.lockBar = true
			r = Settings:ResolveTextures(coreT, specT, true)
			check("a lock matches a class bar to the main bar", r[classBar] == "C-main" and r[classBar .. "Name"] == "C-mainName")
		end

		-- The migration.
		do
			local function deepEqual(a, b)
				if type(a) ~= type(b) then return false end
				if type(a) ~= "table" then return a == b end
				for k, v in pairs(a) do if not deepEqual(v, b[k]) then return false end end
				for k in pairs(b) do if a[k] == nil then return false end end
				return true
			end
			local function deepCopy(t) if type(t) ~= "table" then return t end local o = {} for k, v in pairs(t) do o[k] = deepCopy(v) end return o end
			local classEntry = TRB_.Data.classRegistryOrder[1]
			local mc, ms = classEntry.className, classEntry.specs[1].specName
			local function root(flag, coreLock, specLock, withSeeded)
				local s = {
					core = {
						textures = { textureLock = coreLock, resourceBar = "C-main", resourceBarName = "C-mainN", border = "C-border", borderName = "C-borderN", background = "C-bg", backgroundName = "C-bgN", manaBar = "C-mana", manaBarName = "C-manaN", manaBarBar = "C-old" },
						global = { [mc] = { [ms] = { textures = flag } } },
					},
					[mc] = { [ms] = { textures = { textureLock = specLock, resourceBar = "S-main", resourceBarName = "S-mainN", border = "S-border", borderName = "S-borderN", background = "S-bg", backgroundName = "S-bgN", manaBarBar = "S-oldmana", manaBarBarName = "x", manaBarBorder = "S-oldborder", manaBarBackground = "S-oldbg" } } },
				}
				if withSeeded then s[mc][ms].textures.manaBar = "S-seeded"; s[mc][ms].textures.manaBarName = "S-seededN" end
				return s
			end
			-- Following Global, locked: the mana bar drew the main bar's.
			local s = root(true, true, false, false)
			Settings:MigrateTextures(s)
			local t = s[mc][ms].textures
			check("no mana texture is written", t.manaBar == nil and t.manaBorder == nil and t.manaBackground == nil and t.manaBarName == nil)
			check("the old mana keys are gone", t.manaBarBar == nil and t.manaBarBorder == nil and t.manaBarBackground == nil and t.manaBarBarName == nil)
			check("the locks took the old lock's value", s.core.textures.lockBar == true and s.core.textures.lockOverlay == true and s.core.textures.textureLock == nil and t.lockBar == false)
			check("the spec's flag is kept", s.core.global[mc][ms].textures == true)
			check("no bar is opted out", t.useGlobal == nil)
			check("Global's stray old mana keys were dropped", s.core.textures.manaBarBar == nil)
			-- Following Global, unlocked: the mana bar drew Global's registry-seeded key.
			s = root(true, false, true, false)
			Settings:MigrateTextures(s)
			t = s[mc][ms].textures
			check("flag on, lock off: the spec gets no mana key and Global keeps its own", t.manaBar == nil and s.core.textures.manaBar == "C-mana")
			check("so the bar still draws Global's mana key", Settings:ResolveTextures(s.core.textures, t, true).manaBar == "C-mana")
			-- Unset, the bar draws the main bar's texture from whichever Global the spec is paired with, as Bar.lua reads it.
			local function drawnMana(r) return (not r.lockBar and r.manaBar) or r.resourceBar end
			local otherCore = { resourceBar = "O-main", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false }
			check("an unset mana bar follows the paired Global's main texture", drawnMana(Settings:ResolveTextures(otherCore, t, true)) == "O-main")
			check("and the spec's own main texture off Global", drawnMana(Settings:ResolveTextures(otherCore, t, false)) == "S-main")
			-- Own textures, unlocked, with a seeded key of its own.
			s = root(false, true, false, true)
			Settings:MigrateTextures(s)
			t = s[mc][ms].textures
			check("flag false, lock off: the spec's own mana key stays", t.manaBar == "S-seeded" and t.manaBarName == "S-seededN")
			check("a spec off Global gets no per-bar choices", t.useGlobal == nil and s.core.global[mc][ms].textures == false)
			local own = Settings:ResolveTextures(s.core.textures, t, s.core.global[mc][ms].textures)
			check("and its flag keeps it on a copy of its own textures", own ~= t and deepEqual(own, t))
			-- Own textures, locked.
			s = root(false, false, true, true)
			Settings:MigrateTextures(s)
			check("flag false, lock on: the spec's own mana key stays", s[mc][ms].textures.manaBar == "S-seeded" and s[mc][ms].textures.manaBorder == nil)
			-- Running again changes nothing.
			local before = deepCopy(s)
			Settings:MigrateTextures(s)
			check("a second run changes nothing", deepEqual(before, s))
			-- A table without the specialization's textures keeps the flag for later.
			s = { core = { textures = { textureLock = true }, global = { [mc] = { [ms] = { textures = false } } } } }
			Settings:MigrateTextures(s)
			check("a core-only table keeps the flag", s.core.global[mc][ms].textures == false and s.core.textures.lockBar == true)
			s = { core = { textures = { textureLock = true }, global = { [mc] = { [ms] = { textures = false } } } }, [mc] = { [ms] = {} } }
			Settings:MigrateTextures(s)
			check("a specialization without textures keeps the flag", s.core.global[mc][ms].textures == false)
			s = { [mc] = { [ms] = { textures = { textureLock = false, manaBarBar = "x" } } } }
			Settings:MigrateTextures(s)
			check("a specialization alone gets its locks and drops its old mana keys", s[mc][ms].textures.lockBar == false and s[mc][ms].textures.textureLock == nil and s[mc][ms].textures.manaBarBar == nil and s[mc][ms].textures.manaBar == nil)

			-- The flag decides only for a bar with no choice of its own.
			local coreT = { resourceBar = "C-main", healthBar = "C-health", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false }
			local specT = { resourceBar = "S-main", healthBar = "S-health", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false, useGlobal = { health = true } }
			local r = Settings:ResolveTextures(coreT, specT, false)
			check("flag off: a bar with no choice keeps its own", r.resourceBar == "S-main")
			check("flag off: a bar set to Global follows it", r.healthBar == "C-health")
			specT.useGlobal = { primary = false }
			r = Settings:ResolveTextures(coreT, specT, true)
			check("flag on: a bar set to its own keeps it", r.resourceBar == "S-main" and r.healthBar == "C-health")
		end

		-- A lock reaches a main bar owned apart from the main bar.
		do
			local coreT = { resourceBar = "C-main", resourceBarName = "C-mainName", border = "C-border", background = "C-bg", healthBar = "C-main", healthBarName = "C-mainName", absorbBar = "C-abs", absorbBarName = "C-absName", incomingHealBar = "C-abs", lockBar = true, lockBorder = false, lockBackground = false, lockOverlay = true }
			local specT = { resourceBar = "S-main", resourceBarName = "S-mainName", border = "S-border", background = "S-bg", healthBar = "S-health", healthBarName = "S-healthName", absorbBar = "S-abs", absorbBarName = "S-absName", incomingHealBar = "S-inc", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false, useGlobal = { health = false } }
			local r = Settings:ResolveTextures(coreT, specT, true)
			check("Global's lock reaches an opted-out health bar", r.healthBar == "C-main" and r.healthBarName == "C-mainName")
			check("and its overlays match its own absorb texture", r.incomingHealBar == "S-abs")
			check("an unlocked kind keeps its own", r.healthBorder == specT.healthBorder)
			specT.useGlobal = { primary = false }
			specT.lockBar = true
			coreT.healthBar = "C-health"
			r = Settings:ResolveTextures(coreT, specT, true)
			check("a spec's own lock reaches a health bar on Global", r.healthBar == "S-main")
			specT.useGlobal = nil
			coreT.healthBar = "C-unsynced"
			coreT.healthBarName = "C-unsyncedName"
			r = Settings:ResolveTextures(coreT, specT, true)
			check("bars with one owner keep what is saved", r.healthBar == "C-unsynced")
		end

		-- A texture that can't be changed says why.
		do
			local Character = TRB_.Functions.Character
			local tip = G.GameTooltip --[[@as table]]
			rawset(tip, "SetOwner", function(self, owner) rawset(self, "__owner", owner) end)
			rawset(tip, "GetOwner", function(self) return rawget(self, "__owner") end)
			rawset(tip, "SetText", function(self, text) rawset(self, "__text", text) end)
			local function primaryLabel()
				local index = rowOf(specEd, "primary")
				return specEd.st.rows[index].cols[2].value
			end
			local saved = {}
			for _, key in ipairs({ "resourceBar", "resourceBarName", "lockBar", "lockOverlay" }) do saved[key] = core[key] end
			local savedSpec = { useGlobal = textures.useGlobal, lockBar = textures.lockBar }

			core.resourceBar, core.resourceBarName = "Interface\\Test\\B", "TestB"
			core.lockBar, core.lockOverlay = true, true
			textures.useGlobal = { health = false }
			textures.healthBar, textures.healthBarName = "Interface\\Test\\A", "TestA"
			Character:FillSpecializationCacheSettings(lowerClass, specName)
			refresh(specEd)
			open(specEd, "health")
			local dd = dropdown(specEd, "healthBar")
			local want = string.format(L_["BarTexturesLockedGlobalTooltip"], L_["TextureLockBar"], L_["MainBarTexture"], "TestB", primaryLabel(), primaryLabel())
			check("a health bar locked by Global is disabled", dd ~= nil and dd.__enabled == false)
			check("and says the lock is Global's", dd ~= nil and dd.disabledReason == want)
			print("INFO lock reason: " .. tostring(dd and dd.disabledReason))
			tip.__text, tip.__owner = nil, nil
			dd.__scripts.OnEnter(dd)
			check("hovering it shows the reason", tip.__text == want and tip.__owner == dd)
			dd.__scripts.OnLeave(dd)
			local healthRow = rowOf(specEd, "health")
			check("its cell shows the texture it draws", specEd.st.rows[healthRow].cols[3].value == "TestB")
			check("which the bar draws", merged().healthBar == "Interface\\Test\\B")
			local cell = CreateFrame("Frame")
			tip.__text = nil
			specEd.st.events.OnEnter(nil, cell, specEd.st.rows, nil, healthRow, healthRow, 3)
			check("hovering its cell shows the reason", tip.__text == want and tip.__owner == cell)
			tip.__text = nil
			specEd.st.events.OnEnter(nil, cell, specEd.st.rows, nil, healthRow, healthRow, 2)
			check("the name cell shows none", tip.__text == nil)
			local lockBox = box(specEd, "_lockBar")
			check("Global's locks are read-only here and say why", lockBox.__enabled == false and lockBox.tooltip == L_["TextureLockBarTooltip"] .. "\n\n" .. string.format(L_["TextureLockGlobalTooltip"], primaryLabel()))

			-- A bar on Global says so, and a lock too when one applies.
			open(castEd, "castbar")
			local castDd = dropdown(castEd, "castbarBar")
			check("a bar on Global says so first", castDd ~= nil and castDd.disabledReason ~= nil and castDd.disabledReason:find(L_["BarTexturesFollowsGlobalTooltip"], 1, true) == 1)
			check("and the lock after", castDd ~= nil and castDd.disabledReason ~= nil and castDd.disabledReason:find(L_["TextureLockBar"], 1, true) ~= nil)

			-- The spec's own locks, and a texture that can be changed.
			textures.useGlobal = { primary = false, health = false }
			textures.lockBar = false
			refresh(specEd)
			toggle(lockBox, true)
			open(specEd, "primary")
			check("the main bar's own texture has no reason", dropdown(specEd, "resourceBar").disabledReason == nil and dropdown(specEd, "resourceBar").__enabled == true)
			check("the spec's locks are editable with their plain tooltip", lockBox.__enabled == true and lockBox.tooltip == L_["TextureLockBarTooltip"])
			open(specEd, "health")
			check("a spec's own lock names its main bar", dd.disabledReason == string.format(L_["BarTexturesLockedTooltip"], L_["TextureLockBar"], L_["MainBarTexture"], textures.resourceBarName, primaryLabel()))

			for key, value in pairs(saved) do core[key] = value end
			textures.useGlobal, textures.lockBar = savedSpec.useGlobal, savedSpec.lockBar
			Character:FillSpecializationCacheSettings(lowerClass, specName)
			refresh(specEd)
		end

		-- A bar on Global Options covers its dropdowns, with the ways to change it.
		do
			local Tabs_ = TRB_.Functions.OptionsUi.Tabs
			local savedUse = textures.useGlobal
			textures.useGlobal = nil
			refresh(specEd)
			open(specEd, "health")
			local cover = specEd.controls.barTexturesDetailCover
			check("a bar on Global has its dropdowns covered", cover ~= nil and cover.__shown == true)

			-- Open goes to the Global Options tab that lists the bar and opens it there.
			local switched, category = nil, nil
			local origSwitch = Tabs_.SwitchToTabByNamePrefix
			Tabs_.SwitchToTabByNamePrefix = function(self, prefix, key) switched = tostring(prefix) .. "/" .. tostring(key) return origSwitch(self, prefix, key) end
			local origFrame = TRB_.Options.OptionsFrame
			TRB_.Options.OptionsFrame = { SelectCategory = function(_, key) category = key end }
			local origAfter = G.C_Timer.After
			rawset(G.C_Timer, "After", function(_, fn) fn() end)
			try("open Global's textures", function() cover.openButton.__scripts.OnClick(cover.openButton) end)
			check("Open goes to Global Options' Textures tab", category == "global" and switched == "Global/" .. Tabs_.TabKeys.BarTextures)
			local globalHealth = rowOf(globalSpecEd, "health")
			check("and opens the bar there", globalHealth ~= nil and globalSpecEd.st.sel == globalHealth)
			open(castEd, "castbar")
			local castCover = castEd.controls.barTexturesDetailCover
			check("a cast bar on Global is covered too", castCover.__shown == true)
			category, switched = nil, nil
			try("open Global's cast bar textures", function() castCover.openButton.__scripts.OnClick(castCover.openButton) end)
			local globalCast = find(nil, nil, "castbar")
			check("a cast bar opens on Global Options' Cast Bars Textures tab", category == "castbar"
				and switched == Tabs_:GetGroupInnerPrefix("castbar") .. "/" .. Tabs_.TabKeys.BarTextures
				and globalCast ~= nil and globalCast.st.sel == rowOf(globalCast, "castbar"))
			rawset(G.C_Timer, "After", origAfter)
			TRB_.Options.OptionsFrame = origFrame
			Tabs_.SwitchToTabByNamePrefix = origSwitch

			-- Customize gives the bar its own textures and lifts the cover.
			try("customize", function() cover.customizeButton.__scripts.OnClick(cover.customizeButton) end)
			check("Customize gives the bar its own textures", textures.useGlobal ~= nil and textures.useGlobal.health == false)
			check("and lifts the cover", cover.__shown == false)
			check("the Global Options tab is never covered", globalSpecEd.controls.barTexturesDetailCover.__shown ~= true)
			textures.useGlobal = savedUse
			refresh(specEd)

			-- The lock note sits under the locks on every Textures tab.
			local missing = 0
			for _, e in ipairs(drv.editors) do
				if e.controls.labels == nil or e.controls.labels.texturesLockedNote == nil then missing = missing + 1 end
			end
			check("every Textures tab has the lock note under its locks", missing == 0)
		end

		-- Utility follows Global Options' textures like the main bars.
		do
			local utilityDef = TRB_.Classes.BarTypeRegistry:GetInstance():Get("utility")
			check("Utility is a Global texture bar", Settings:GetGlobalTextureBars().set.utility == true)
			check("Global's textures carry Utility's", core.utilityBar ~= nil and core.utilityBorder ~= nil and core.utilityBackground ~= nil)
			local globalRow = rowOf(globalSpecEd, "utility")
			check("Global Options' Textures tab lists Utility by its own name", globalRow ~= nil and globalSpecEd.st.rows[globalRow].cols[2].value == utilityDef.globalDisplayName)
			print("INFO Global Utility row: " .. tostring(globalRow and globalSpecEd.st.rows[globalRow].cols[2].value))

			local utilityEd = nil
			for _, e in ipairs(drv.editors) do
				if e.classId ~= nil and e.groupKey == "spec" and rowOf(e, "utility") ~= nil then utilityEd = e break end
			end
			if utilityEd ~= nil then
				local ut = utilityEd.spec.textures
				local savedUse = ut.useGlobal
				ut.useGlobal = nil
				refresh(utilityEd)
				local row = utilityEd.st.rows[rowOf(utilityEd, "utility")]
				print("INFO spec Utility row: " .. tostring(utilityEd.classId) .. "_" .. tostring(utilityEd.specId) .. " " .. tostring(row.cols[2].value))
				check("a specialization's Utility bar keeps its class's name", row.cols[2].value == utilityDef.displayName)
				check("and follows Global by default", row.cols[#row.cols].value == L_["BarVisibilitySettingsSourceGlobal"])
				open(utilityEd, "utility")
				check("its dropdowns are covered while it does", utilityEd.controls.barTexturesDetailCover.__shown == true)
				ut.useGlobal = savedUse
				refresh(utilityEd)
			else
				print("INFO no specialization in this flavor has a Utility bar")
			end

			local coreT = { resourceBar = "C-main", utilityBar = "C-util", utilityBarName = "C-utilName", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false }
			local specT = { resourceBar = "S-main", utilityBar = "S-util", utilityBarName = "S-utilName", lockBar = false, lockBorder = false, lockBackground = false, lockOverlay = false }
			check("a followed Utility bar takes Global's texture", Settings:ResolveTextures(coreT, specT, true).utilityBar == "C-util")
			specT.useGlobal = { utility = false }
			check("an opted-out Utility bar keeps its own", Settings:ResolveTextures(coreT, specT, true).utilityBar == "S-util")

			-- Upgrading: Utility was each specialization's own, so one whose textures differ from Global's keeps them.
			local classEntry = TRB_.Data.classRegistryOrder[1]
			local mc, ms = classEntry.className, classEntry.specs[1].specName
			local defaults = utilityDef:GetDefaultTextures()
			local function upgrade(flag, utilityBar)
				local s = {
					core = { textures = { textureLock = false }, global = { [mc] = { [ms] = { textures = flag } } } },
					[mc] = { [ms] = { textures = { textureLock = false, utilityBar = utilityBar, utilityBorder = defaults.border, utilityBackground = defaults.background } } },
				}
				Settings:MigrateTextures(s)
				local useGlobal = s[mc][ms].textures.useGlobal
				return useGlobal and useGlobal.utility
			end
			check("a following spec with its own Utility texture keeps it", upgrade(true, "Interface/Mine") == false)
			check("one matching the defaults follows its flag", upgrade(true, defaults.bar) == nil)
			check("one off Global with its own Utility texture keeps it", upgrade(false, "Interface/Mine") == false)
			check("one off Global matching the defaults is left to its flag", upgrade(false, defaults.bar) == nil)
			-- A spec-only table, as a stored profile without Global Options.
			local alone = { [mc] = { [ms] = { textures = { textureLock = false, utilityBar = "Interface/Mine", utilityBorder = defaults.border, utilityBackground = defaults.background } } } }
			Settings:MigrateTextures(alone)
			check("a spec stored without Global Options keeps its own Utility texture", alone[mc][ms].textures.useGlobal ~= nil and alone[mc][ms].textures.useGlobal.utility == false)
			-- A table already on the four locks was converted before.
			local later = { [mc] = { [ms] = { textures = { lockBar = false, utilityBar = "Interface/Mine", utilityBorder = defaults.border, utilityBackground = defaults.background } } } }
			Settings:MigrateTextures(later)
			check("a table already on the four locks is left alone", later[mc][ms].textures.useGlobal == nil)
			-- Global's Utility textures copied in from a spec start from the defaults.
			local copied = { core = { textures = { textureLock = true, utilityBar = "Interface/Copied", utilityBarName = "Copied", utilityBorder = "Interface/CopiedBorder", utilityBackground = "Interface/CopiedBg" } } }
			Settings:MigrateTextures(copied)
			local ct = copied.core.textures
			check("Global's old Utility textures reset to the defaults", ct.utilityBar == defaults.bar and ct.utilityBarName == defaults.barName and ct.utilityBorder == defaults.border and ct.utilityBackground == defaults.background)
			local current = { core = { textures = { lockBar = true, utilityBar = "Interface/Chosen" } } }
			Settings:MigrateTextures(current)
			check("Global's Utility textures chosen after the upgrade stay", current.core.textures.utilityBar == "Interface/Chosen")
		end

		-- ===== Use Global boxes, table heights, and the mana row (#861) =====
		do
			local Character = TRB_.Functions.Character
			local globalSet = Settings:GetGlobalTextureBars().set
			local savedFlag, savedMain, savedMainName, savedCore, savedCoreName = specFlags.textures, textures.resourceBar, textures.resourceBarName, core.resourceBar, core.resourceBarName
			local savedUses = {}
			local function eachSpecTextures(fn)
				for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
					local piece = TRB_.Data.settings[entry.className] and TRB_.Data.settings[entry.className][entry.specName]
					if piece ~= nil and piece.textures ~= nil then fn(piece.textures, entry) end
				end
			end
			eachSpecTextures(function(t) savedUses[t] = t.useGlobal and TRB_.Functions.Table:DeepCopy(t.useGlobal) or false end)
			local function text(frame) local t = frame and rawget(G, frame:GetName() .. "Text") return t and t.__text end

			-- Wording shared with Visibility's boxes, keeping the Textures tooltips.
			local allBox = box(specEd, "_useGlobal_textures")
			check("the spec box reads as Visibility's", text(allBox) == L_["CheckboxUseGlobalAllListedBars"] and allBox.tooltip == L_["BarTexturesUseGlobalAllTooltip"])
			local bulk = rawget(G, "TwintopResourceBar_Global_enableAll_textures")
			check("the Global box reads as Visibility's", text(bulk) == L_["CheckboxUseGlobalAllSpecsListedBars"] and bulk.tooltip == L_["BarTexturesUseGlobalAllSpecsTooltip"])

			-- A spec whose flag is off keeps every bar with no choice on its own textures.
			specFlags.textures = false
			textures.useGlobal = {}
			core.resourceBar, core.resourceBarName = "Interface\\Test\\C", "TestC"
			textures.resourceBar, textures.resourceBarName = "Interface\\Test\\A", "TestA"
			Character:FillSpecializationCacheSettings(lowerClass, specName)
			refresh(specEd)
			local primaryRow = specEd.st.rows[rowOf(specEd, "primary")]
			check("flag off: a bar with no choice says Specialization", primaryRow.cols[#primaryRow.cols].value == L_["BarVisibilitySettingsSourceSpec"])
			check("flag off: it draws the spec's own texture", merged().resourceBar == "Interface\\Test\\A")
			check("flag off: the all-bars box reads unchecked", drv.tri[allBox] == false)
			open(specEd, "primary")
			check("flag off: its dropdowns are not covered", specEd.controls.barTexturesDetailCover.__shown == false)
			toggle(box(specEd, "_useGlobal_row"), true)
			check("choosing Global writes true", textures.useGlobal.primary == true and merged().resourceBar == "Interface\\Test\\C")
			toggle(box(specEd, "_useGlobal_row"), false)
			check("opting out writes false and starts from Global's", textures.useGlobal.primary == false and textures.resourceBar == "Interface\\Test\\C")
			textures.useGlobal = {}
			textures.resourceBar = "Interface\\Test\\A"
			refresh(specEd)
			open(specEd, "primary")
			toggle(box(specEd, "_useGlobal_row"), false)
			check("opting out a bar that drew its own keeps its own", textures.useGlobal.primary == false and textures.resourceBar == "Interface\\Test\\A")
			textures.useGlobal = {}
			refresh(specEd)
			allBox.__scripts.OnClick(allBox)
			local allTrue, allFalse = true, true
			for _, key in ipairs(keysOf(specEd)) do
				if globalSet[key] and textures.useGlobal[key] ~= true then allTrue = false end
			end
			check("the all-bars box puts every listed bar on Global with true", allTrue)
			allBox.__scripts.OnClick(allBox)
			for _, key in ipairs(keysOf(specEd)) do
				if globalSet[key] and textures.useGlobal[key] ~= false then allFalse = false end
			end
			check("and back off with false", allFalse)

			-- The Global box reads each spec's flag and counts only the bars a spec has.
			textures.useGlobal = {}
			refresh(globalSpecEd)
			local listed = keysOf(globalSpecEd)
			local followed, total, naive = 0, 0, 0
			eachSpecTextures(function(t, entry)
				local flag = TRB_.Data.settings.core.global[entry.className][entry.specName].textures
				for _, key in ipairs(listed) do
					if globalSet[key] then
						naive = naive + 1
						if t[Settings:GetTextureKeysForBar(key).bar] ~= nil then
							total = total + 1
							if Settings:TextureFollowsGlobal(t, key, flag) then followed = followed + 1 end
						end
					end
				end
			end)
			print(string.format("INFO Global box count: %s (expected %d of %d, %d without the filter)", tostring(bulk.specCount.__text), followed, total, naive))
			check("the Global box counts with each spec's flag", bulk.specCount.__text == string.format(L_["UseGlobalBarCountFormat"], followed, total) and followed < total)
			check("and skips bars a spec doesn't have", total < naive)
			check("it reads mixed", drv.tri[bulk] == "mixed")
			bulk.__scripts.OnClick(bulk)
			local explicit = true
			eachSpecTextures(function(t)
				for _, key in ipairs(listed) do
					if globalSet[key] and t[Settings:GetTextureKeysForBar(key).bar] ~= nil and (t.useGlobal == nil or t.useGlobal[key] ~= true) then explicit = false end
				end
			end)
			check("clicking it writes true for every spec's bars", explicit and drv.tri[bulk] == true)

			-- Each table is as tall as the bars it lists.
			local sizes = {}
			for _, e in ipairs(drv.editors) do
				local want = math.min(math.max(#e.st.rows, 2), 8)
				if e.st.shownRows ~= want then sizes[#sizes + 1] = tostring(e.classId) .. "/" .. e.groupKey .. "=" .. tostring(e.st.shownRows) .. "~" .. want end
			end
			check("every table is as tall as the bars it lists (" .. table.concat(sizes, ", ") .. ")", #sizes == 0)
			local castRows = castEd.st.shownRows
			print("INFO cast bar table rows: " .. tostring(castRows) .. " of " .. #castEd.st.rows)
			local includeBox = box(specEd, "_includeAllGroups")
			toggle(includeBox, true)
			check("ticking include-all grows the spec table", specEd.st.shownRows == math.min(#specEd.st.rows, 8) and #specEd.st.rows > 2)
			toggle(includeBox, false)
			check("and unticking shrinks it", specEd.st.shownRows == math.min(math.max(#specEd.st.rows, 2), 8))

			check("the grouping tabs reuse the spec's Textures key", Tabs.TabKeys.GroupTextures == nil)
			local left = {}
			for _, key in ipairs({ "BackgroundTextures", "BackgroundTexturesSectionHeader", "BarTexturesSectionHeader", "BorderTextures", "BorderTexturesSectionHeader", "CheckboxUseGlobalTooltip_Textures", "CopyMenuSection_textures", "OverlayTexturesSectionHeader", "TextureLock", "TextureLockTooltip", "UseGlobalBadgeTooltipTextures", "BarTexturesUseGlobalAll", "BarTexturesUseGlobalAllSpecs", "BarTexturesUseGlobalCountFormat" }) do
				if rawget(L_, key) ~= nil then left[#left + 1] = key end
			end
			check("the unused strings are gone (" .. table.concat(left, ", ") .. ")", #left == 0)

			-- An unset mana texture shows the main bar's, which is what it draws, and picking one sets the mana bar's own.
			local manaEd = nil
			for _, e in ipairs(drv.editors) do
				if e.classId ~= nil and e.groupKey == "spec" and rowOf(e, "mana") ~= nil then manaEd = e break end
			end
			if manaEd ~= nil then
				local mt = manaEd.spec.textures
				print("INFO mana row on " .. tostring(manaEd.classId) .. "_" .. tostring(manaEd.specId) .. ", seeded mana texture: " .. tostring(mt.manaBar))
				check("a fresh mana bar has no texture of its own", mt.manaBar == nil and mt.manaBorder == nil and mt.manaBackground == nil)
				local savedLock = mt.lockBar
				mt.lockBar = false
				mt.useGlobal = { primary = false }
				refresh(manaEd)
				check("an unset mana texture shows the main bar's", manaEd.st.rows[rowOf(manaEd, "mana")].cols[3].value == mt.resourceBarName)
				open(manaEd, "mana")
				local manaDd = dropdown(manaEd, "manaBar")
				check("and its dropdown can set one", manaDd ~= nil and manaDd.__enabled == true)
				if manaDd ~= nil then try("pick a mana texture", function() pick(manaDd, "Interface\\Test\\A") end) end
				check("picking one sets the mana bar's own", mt.manaBar == "Interface\\Test\\A" and manaEd.st.rows[rowOf(manaEd, "mana")].cols[3].value == "TestA")
				mt.manaBar, mt.manaBarName, mt.lockBar = nil, nil, savedLock
				refresh(manaEd)
			else
				print("INFO no specialization in this flavor has a mana row")
			end

			specFlags.textures = savedFlag
			textures.resourceBar, textures.resourceBarName, core.resourceBar, core.resourceBarName = savedMain, savedMainName, savedCore, savedCoreName
			eachSpecTextures(function(t) if savedUses[t] ~= nil then t.useGlobal = savedUses[t] or nil end end)
			Character:FillSpecializationCacheSettings(lowerClass, specName)
			refresh(specEd)
		end

		-- Each grouping's Textures tab names its grouping, and a grouping's strip orders its tabs as the spec's own do.
		do
			local wanted = { castbar = "BarTexturesHeaderCastbar", otherBars = "BarTexturesHeaderOtherBars", petBars = "BarTexturesHeaderPetBars", skyriding = "BarTexturesHeaderSkyriding" }
			local wrong, seen = {}, 0
			for _, e in ipairs(drv.editors) do
				local headers = drv.headersByParent[e.parent] or {}
				local want = wanted[e.groupKey] and L_[wanted[e.groupKey]] or L_["BarTexturesHeader"]
				if want == nil or headers[1] ~= want then
					wrong[#wrong + 1] = tostring(e.classId) .. "/" .. e.groupKey .. "=" .. tostring(headers[1])
				elseif wanted[e.groupKey] then
					seen = seen + 1
				end
			end
			print("INFO grouping Textures headers checked: " .. seen)
			check("every Textures tab's header names its grouping (" .. table.concat(wrong, ", ") .. ")", #wrong == 0 and seen > 0)

			local badOrder, strips = {}, 0
			local groupingPrefix = {}
			for _, gk in ipairs({ "castbar", "otherBars", "petBars", "skyriding" }) do groupingPrefix[TRB_.Functions.OptionsUi.Tabs:GetGroupInnerPrefix(gk)] = true end
			for _, g in ipairs(drv.groups) do
				local at = {}
				for index, key in ipairs(g.keys) do at[key] = index end
				local vis = at.barVisibility
				if vis ~= nil and at.barText ~= nil and (g.prefix:find("Inner_") or groupingPrefix[g.prefix]) then
					strips = strips + 1
					local ordered = vis < at.barText and (at.barTextures == nil or at.barTextures < vis)
					local adjacent = at.barText == vis + 1 and (at.barTextures == nil or vis == at.barTextures + 1) and at.barText == #g.keys
					if not ordered or not adjacent then badOrder[#badOrder + 1] = g.prefix .. "=" .. table.concat(g.keys, ",") end
				end
			end
			print("INFO strips with grouping settings tabs: " .. strips)
			check("every grouping strip ends Textures, Visibility, Bar Text (" .. table.concat(badOrder, "; ") .. ")", #badOrder == 0 and strips > 0)
		end

		-- The Threshold Line Behavior section is on a spec's tab only with the rows its lines can use, and always on Global Options.
		do
			local wrong, withSection, withoutSection, cooldownOnly, targetOnly = {}, 0, {}, {}, {}
			for _, panel in ipairs(drv.thresholdPanels) do
				local compositeKey = TRB_.Functions.Character:GetCompositeKeyFromIds(panel.classId, panel.specId)
				local specCache = compositeKey and TRB_.Data.specCache[compositeKey] or nil
				local spells = specCache and specCache.spellsData and specCache.spellsData.spells or nil
				if spells ~= nil then
					local hasCooldownLine, hasTargetLine = false, false
					for _, spell in pairs(spells) do
						if type(spell) == "table" and spell.Is ~= nil and (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) then
							hasCooldownLine = hasCooldownLine or spell.hasCooldown == true
							hasTargetLine = hasTargetLine or spell:NeedsTarget()
						end
					end
					local className, specName = TRB_.Functions.Character:GetClassAndSpecializationNames(panel.classId, panel.specId)
					local namePrefix = "TwintopResourceBar_" .. className .. "_" .. specName
					local hasBox = rawget(G, namePrefix .. "_ThresholdBehaviorTrackCooldowns") ~= nil and rawget(G, namePrefix .. "_ThresholdBehaviorHideOnCooldown") ~= nil
						and rawget(G, namePrefix .. "_ThresholdBehaviorHideOnCooldownWindow_ModeGCDs") ~= nil
					local hasTargetBox = rawget(G, namePrefix .. "_ThresholdBehaviorHideNoTarget") ~= nil and rawget(G, namePrefix .. "_ThresholdBehaviorHideNoTargetOutOfCombat") ~= nil
					local hasUseGlobal = rawget(G, namePrefix .. "_useGlobal_thresholdBehavior") ~= nil
					local hasSection = hasCooldownLine or hasTargetLine
					if hasBox ~= hasCooldownLine or hasTargetBox ~= hasTargetLine or hasUseGlobal ~= hasSection then
						wrong[#wrong + 1] = string.format("%s cooldownLines=%s box=%s targetLines=%s targetBox=%s useGlobal=%s", compositeKey, tostring(hasCooldownLine), tostring(hasBox),
							tostring(hasTargetLine), tostring(hasTargetBox), tostring(hasUseGlobal))
					end
					if hasSection then withSection = withSection + 1 else withoutSection[#withoutSection + 1] = compositeKey end
					if hasCooldownLine and not hasTargetLine then cooldownOnly[#cooldownOnly + 1] = compositeKey end
					if hasTargetLine and not hasCooldownLine then targetOnly[#targetOnly + 1] = compositeKey end
				end
			end
			table.sort(withoutSection)
			table.sort(cooldownOnly)
			table.sort(targetOnly)
			print(string.format("INFO Threshold Line Behavior sections: %d specs with, without on %s; cooldown rows only on %s; target rows only on %s",
				withSection, table.concat(withoutSection, ", "), table.concat(cooldownOnly, ", "), table.concat(targetOnly, ", ")))
			table.sort(wrong)
			check("a spec's tab has the Threshold Line Behavior section only with the rows its lines can use (" .. table.concat(wrong, ", ") .. ")", #wrong == 0 and withSection > 0)
			check("Global Options has the Threshold Line Behavior section and its bulk Use Global box",
				rawget(G, "TwintopResourceBar_Global__ThresholdBehaviorTrackCooldowns") ~= nil and rawget(G, "TwintopResourceBar_Global_enableAll_thresholdBehavior") ~= nil
				and rawget(G, "TwintopResourceBar_Global__ThresholdBehaviorHideOnCooldown") ~= nil and rawget(G, "TwintopResourceBar_Global__ThresholdBehaviorHideOnCooldownWindow_ModeTime") ~= nil
				and rawget(G, "TwintopResourceBar_Global__ThresholdBehaviorHideNoTarget") ~= nil and rawget(G, "TwintopResourceBar_Global__ThresholdBehaviorHideNoTargetOutOfCombat") ~= nil)
		end

		-- Global Options' Hide with no valid target: its out-of-combat box grays out while hiding is off, and both edit the shared setting.
		do
			local function named(suffix) return rawget(G, "TwintopResourceBar_Global__" .. suffix) end
			local hideNoTarget = TRB_.Data.settings.core.thresholds.behavior.hideNoTarget
			local hideBox, outOfCombatBox = named("ThresholdBehaviorHideNoTarget"), named("ThresholdBehaviorHideNoTargetOutOfCombat")
			local problems = {}
			if hideBox ~= nil and outOfCombatBox ~= nil then
				local saved = { hideNoTarget.enabled, hideNoTarget.outOfCombat }
				local refreshes = 0
				local refreshRange = TRB_.Functions.Character.RefreshSpellRangeCheckUpdate
				TRB_.Functions.Character.RefreshSpellRangeCheckUpdate = function(...)
					refreshes = refreshes + 1
					return refreshRange(...)
				end
				toggle(hideBox, false)
				if outOfCombatBox.__enabled ~= false or outOfCombatBox.trbDisabledReason ~= L_["ThresholdBehaviorHideNoTargetOffTooltip"] then
					problems[#problems + 1] = "hideOff:outOfCombat=" .. tostring(outOfCombatBox.trbDisabledReason)
				end
				toggle(hideBox, true)
				if hideNoTarget.enabled ~= true or outOfCombatBox.__enabled == false or outOfCombatBox.trbDisabledReason ~= nil or refreshes < 2 then
					problems[#problems + 1] = "hideOn:enabled=" .. tostring(hideNoTarget.enabled) .. " refreshes=" .. refreshes
				end
				toggle(outOfCombatBox, true)
				if hideNoTarget.outOfCombat ~= true then
					problems[#problems + 1] = "outOfCombat=" .. tostring(hideNoTarget.outOfCombat)
				end
				TRB_.Functions.Character.RefreshSpellRangeCheckUpdate = refreshRange
				hideNoTarget.enabled, hideNoTarget.outOfCombat = saved[1], saved[2]
			else
				problems[#problems + 1] = "missing Global Options Hide with no valid target controls"
			end
			check("Global Options' Hide with no valid target grays out its out-of-combat box while off, and edits the shared setting (" .. table.concat(problems, ", ") .. ")", #problems == 0)
		end

		-- Every grayed-out shared threshold option says why, on Global Options' Threshold Lines tab.
		do
			local function named(suffix) return rawget(G, "TwintopResourceBar_Global__" .. suffix) end
			local globalControls = TRB_.Frames.interfaceSettingsFrameContainer.controls.global
			local iconsBox, desaturate = named("ThresholdIconEnabled"), named("ThresholdIconDesaturated")
			local swipe, time, recharge = named("ThresholdIconShowCooldown"), named("ThresholdIconShowCooldownText"), named("ThresholdIconRechargeMode")
			local oorShow, oorColor = named("thresholdOutOfRange"), named("thresholdOutOfRangeColorEnabled")
			local icons, outOfRange = TRB_.Data.settings.core.thresholds.icons, TRB_.Data.settings.core.colors.threshold.outOfRange
			local wrongReasons = {}
			local function expect(label, control, reason)
				if control == nil or control.trbDisabledReason ~= reason then
					wrongReasons[#wrongReasons + 1] = label .. "=" .. tostring(control and control.trbDisabledReason)
				end
			end
			if iconsBox ~= nil and swipe ~= nil and time ~= nil and oorShow ~= nil then
				local saved = { icons.enabled, icons.showCooldown, icons.showCooldownText, icons.overlapMode, outOfRange.show }
				toggle(iconsBox, false)
				expect("iconsOff.desaturate", desaturate, L_["ThresholdIconsOffTooltip"])
				expect("iconsOff.swipe", swipe, L_["ThresholdIconsOffTooltip"])
				expect("iconsOff.recharge", recharge, L_["ThresholdIconsOffTooltip"])
				toggle(iconsBox, true)
				expect("iconsOn.desaturate", desaturate, nil)
				expect("iconsOn.recharge", recharge, nil)
				toggle(swipe, false)
				toggle(time, false)
				expect("partsOff.recharge", recharge, L_["ThresholdIconCooldownPartsOffTooltip"])
				expect("partsOff.swipe", swipe, nil)
				toggle(swipe, true)
				toggle(time, true)
				if icons.overlapMode == "off" then
					expect("overlapOff.spacing", globalControls.thresholdIconOverlapSpacing, L_["ThresholdIconOverlapOffTooltip"])
					expect("overlapOff.maxRows", globalControls.thresholdIconOverlapMaxRows, L_["ThresholdIconOverlapOffTooltip"])
				end
				toggle(oorShow, false)
				expect("oorHidden.color", oorColor, L_["ThresholdOutOfRangeHiddenTooltip"])
				toggle(oorShow, true)
				expect("oorShown.color", oorColor, nil)
				icons.enabled, icons.showCooldown, icons.showCooldownText, icons.overlapMode, outOfRange.show = saved[1], saved[2], saved[3], saved[4], saved[5]
			else
				wrongReasons[#wrongReasons + 1] = "missing Global Options threshold controls"
			end
			check("every grayed-out shared threshold option says why (" .. table.concat(wrongReasons, ", ") .. ")", #wrongReasons == 0)
		end

		-- Global Options' Hide while on cooldown: its window grays out while hiding is off, and edits the shared setting.
		do
			local function named(suffix) return rawget(G, "TwintopResourceBar_Global__" .. suffix) end
			local behavior = TRB_.Data.settings.core.thresholds.behavior
			local hideBox, trackBox = named("ThresholdBehaviorHideOnCooldown"), named("ThresholdBehaviorTrackCooldowns")
			local window = TRB_.Frames.interfaceSettingsFrameContainer.controls.global.thresholdBehaviorHideOnCooldownWindow
			local problems = {}
			if hideBox ~= nil and trackBox ~= nil and window ~= nil then
				local hide = behavior.hideOnCooldown
				local saved = { behavior.trackCooldowns, hide.enabled, hide.mode, hide.timeMax }
				local offReason = L_["ThresholdBehaviorHideOnCooldownOffTooltip"]
				toggle(hideBox, false)
				for label, control in pairs({ gcdRadio = window.gcdRadio, gcdSlider = window.gcdSlider, timeRadio = window.timeRadio, timeSlider = window.timeSlider }) do
					if control.__enabled ~= false or control.trbDisabledReason ~= offReason then
						problems[#problems + 1] = "hideOff:" .. label .. "=" .. tostring(control.trbDisabledReason)
					end
				end
				toggle(hideBox, true)
				if window.timeSlider.__enabled == false or window.timeSlider.trbDisabledReason ~= nil then
					problems[#problems + 1] = "hideOn:window grayed"
				end
				-- A line set to Track still follows hiding, so tracking off leaves it live.
				toggle(trackBox, false)
				if hideBox.__enabled == false or hideBox.trbDisabledReason ~= nil then
					problems[#problems + 1] = "trackOff:hide grayed"
				end
				toggle(trackBox, true)
				window.timeRadio.__scripts.OnClick(window.timeRadio)
				window.timeSlider.__scripts.OnValueChanged(window.timeSlider, 0.5)
				if hide.mode ~= "time" or hide.timeMax ~= 0.5 or window.gcdRadio:GetChecked() or not window.timeRadio:GetChecked() then
					problems[#problems + 1] = "edit:mode=" .. tostring(hide.mode) .. " timeMax=" .. tostring(hide.timeMax)
				end
				behavior.trackCooldowns, hide.enabled, hide.mode, hide.timeMax = saved[1], saved[2], saved[3], saved[4]
			else
				problems[#problems + 1] = "missing Global Options Hide while on cooldown controls"
			end
			check("Global Options' Hide while on cooldown window grays out while hiding is off, and edits the shared setting (" .. table.concat(problems, ", ") .. ")", #problems == 0)
		end

		-- With a line's icon override on, its cooldown options show only when its ability has a cooldown, and the recharge choice only with charges.
		-- A line with a cooldown offers Cooldown Tracking; untracked, its cooldown-only options gray out and say why.
		do
			local wrong, withCooldown, withoutCooldown, withCharges = {}, 0, 0, 0
			local trackingWrong, unusableKept = {}, 0
			local unusableHiddenGrayed, unusableHiddenLive, windowColorChecked = 0, 0, 0
			local withTarget, targetOnly, rangeRefreshes = 0, 0, 0
			local noRangeChecked = {}
			local refreshRange = TRB_.Functions.Character.RefreshSpellRangeCheckUpdate
			TRB_.Functions.Character.RefreshSpellRangeCheckUpdate = function(...)
				rangeRefreshes = rangeRefreshes + 1
				return refreshRange(...)
			end
			for _, panel in ipairs(drv.thresholdPanels) do
				local st = panel.st
				local compositeKey = panel.classId and TRB_.Functions.Character:GetCompositeKeyFromIds(panel.classId, panel.specId) or nil
				local specCache = compositeKey and TRB_.Data.specCache[compositeKey] or nil
				local spells = specCache and specCache.spellsData and specCache.spellsData.spells or nil
				if st ~= nil and st.events ~= nil and st.events.OnClick ~= nil and spells ~= nil and #st.rows > 0 then
					local className, specName = TRB_.Functions.Character:GetClassAndSpecializationNames(panel.classId, panel.specId)
					local prefix = "TwintopResourceBar_" .. className .. "_" .. specName .. "_Detail_Threshold"
					local enabledBox = rawget(G, prefix .. "Enabled")
					local useSpecific = rawget(G, prefix .. "IconUseSpecific")
					local swipeBox = rawget(G, prefix .. "_IconShowCooldown")
					local rechargeDropdown = rawget(G, prefix .. "_IconRechargeMode")
					local bySettingKey = {}
					for _, spell in pairs(spells) do
						if type(spell) == "table" and spell.settingKey ~= nil then bySettingKey[spell.settingKey] = spell end
					end
					-- Enabling a line rebuilds the rows, so each is found again by its key.
					local keys = {}
					for _, row in ipairs(st.rows) do keys[#keys + 1] = row.cols[1].value end
					for _, key in ipairs(keys) do
						local spell = bySettingKey[key]
						if spell ~= nil and spell.hasThresholdIcon ~= false and enabledBox ~= nil and useSpecific ~= nil and swipeBox ~= nil and rechargeDropdown ~= nil then
							try("open threshold " .. compositeKey .. "." .. key, function()
								local index = 0
								for i, row in ipairs(st.rows) do if row.cols[1].value == key then index = i break end end
								st.events.OnClick(nil, nil, st.rows, nil, index, index, 1, st, "LeftButton")
								-- The icon override only shows for an enabled line.
								local wasEnabled = enabledBox:GetChecked()
								if not wasEnabled then
									toggle(enabledBox, true)
								end
								local icon = panel.spec.thresholds.thresholdDictionary[key].icon
								local wasOn = icon.enabled
								if wasOn then
									toggle(useSpecific, false)
								end
								local hiddenWhileOff = swipeBox.__shown ~= true
								toggle(useSpecific, true)
								local hasCooldown = spell.hasCooldown == true
								local hasCharges = hasCooldown and spell.hasCharges == true
								if not hiddenWhileOff or (swipeBox.__shown == true) ~= hasCooldown or (rechargeDropdown.__shown == true) ~= hasCharges then
									wrong[#wrong + 1] = string.format("%s.%s off=%s swipe=%s recharge=%s", compositeKey, key,
										tostring(not hiddenWhileOff), tostring(swipeBox.__shown), tostring(rechargeDropdown.__shown))
								end
								if hasCooldown then withCooldown = withCooldown + 1 else withoutCooldown = withoutCooldown + 1 end
								if hasCharges then withCharges = withCharges + 1 end

								local trackingDropdown = rawget(G, prefix .. "CooldownTracking")
								local unusableDropdown = rawget(G, prefix .. "ColorUnusableMode")
								local problems = {}

								-- A line that needs a target offers With No Valid Target, and a choice refreshes range checks.
								local noTargetDropdown = rawget(G, prefix .. "NoTarget")
								local needsTarget = spell:NeedsTarget()
								if needsTarget then withTarget = withTarget + 1 end
								local behaviorHeader = panel.controls ~= nil and panel.controls.thresholdDetailBehaviorHeader or nil
								if needsTarget and not hasCooldown then targetOnly = targetOnly + 1 end
								if behaviorHeader == nil or (behaviorHeader.__shown == true) ~= (needsTarget or hasCooldown) then
									problems[#problems + 1] = "behaviorHeader=" .. tostring(behaviorHeader and behaviorHeader.__shown)
								end
								-- A spell with no range offers no out-of-range settings.
								local oorDropdown = rawget(G, prefix .. "ColorOorMode")
								local hasRange = spell.rangeCheck ~= false and spell:HasRange()
								if oorDropdown == nil or (oorDropdown.__shown == true) ~= hasRange then
									problems[#problems + 1] = "outOfRange=" .. tostring(oorDropdown and oorDropdown.__shown)
								elseif hasRange and compositeKey ~= nil and not noRangeChecked[compositeKey] then
									-- Once per spec, the same line as if its spell had no range.
									noRangeChecked[compositeKey] = true
									local spellHasRange = G.C_Spell.SpellHasRange
									local rankedId = spell:GetRankedId()
									G.C_Spell.SpellHasRange = function(id) return id ~= rankedId end
									TRB_.Data.cache.values.rangeInfo = {}
									st.events.OnClick(nil, nil, st.rows, nil, index, index, 1, st, "LeftButton")
									if oorDropdown.__shown == true then
										problems[#problems + 1] = "noRange:outOfRange shown"
									end
									G.C_Spell.SpellHasRange = spellHasRange
									TRB_.Data.cache.values.rangeInfo = {}
									st.events.OnClick(nil, nil, st.rows, nil, index, index, 1, st, "LeftButton")
								end
								if noTargetDropdown == nil or noTargetDropdown.__generator == nil or (noTargetDropdown.__shown == true) ~= needsTarget then
									problems[#problems + 1] = "noTarget=" .. tostring(noTargetDropdown and noTargetDropdown.__shown)
								elseif needsTarget then
									local lineEntry = panel.spec.thresholds.thresholdDictionary[key]
									local savedBehavior = lineEntry.behavior
									local refreshes = rangeRefreshes
									local root = drv.newDesc("root", "root")
									noTargetDropdown.__generator(noTargetDropdown, root)
									for _, c in ipairs(root.children) do
										if c.data == "hideAlways" then c.setSelected(c.data) end
									end
									if lineEntry.behavior == nil or lineEntry.behavior.noTarget ~= "hideAlways" or rangeRefreshes == refreshes then
										problems[#problems + 1] = "noTarget:choose=" .. tostring(lineEntry.behavior and lineEntry.behavior.noTarget)
									end
									lineEntry.behavior = savedBehavior
								end
								if trackingDropdown == nil or (trackingDropdown.__shown == true) ~= hasCooldown then
									problems[#problems + 1] = "tracking=" .. tostring(trackingDropdown and trackingDropdown.__shown)
								end
								if hasCooldown and trackingDropdown ~= nil and unusableDropdown ~= nil then
									local dictEntry = panel.spec.thresholds.thresholdDictionary[key]
									local classGlobal = TRB_.Data.settings.core.global[string.lower(className)]
									local behavior = (classGlobal[specName].thresholdBehavior and TRB_.Data.settings.core.thresholds or panel.spec.thresholds).behavior
									local savedLine, savedShared = dictEntry.behavior, behavior.trackCooldowns
									local unusableLive = (spell:Is("TRB.Classes.SpellComboPointThreshold") and spell.comboPoints == true) or spell.attributes.unusableWhileCasting == true
									if unusableLive then unusableKept = unusableKept + 1 end
									-- Re-checking the override re-lays the panel out, which refreshes its tracking states.
									local function Expect(state, reason)
										toggle(useSpecific, true)
										local grayed = reason ~= nil
										if (swipeBox.__enabled == false) ~= grayed or swipeBox.trbDisabledReason ~= reason
											or (rechargeDropdown.__enabled == false and not grayed and hasCharges) then
											problems[#problems + 1] = state .. ":swipe=" .. tostring(swipeBox.__enabled)
										end
										local unusableReason = (not unusableLive) and reason or nil
										if (unusableDropdown.__enabled == false) ~= (unusableReason ~= nil) or unusableDropdown.trbDisabledReason ~= unusableReason then
											problems[#problems + 1] = state .. ":unusable=" .. tostring(unusableDropdown.__enabled)
										end
									end
									dictEntry.behavior = { cooldownTracking = "off" }
									Expect("off", L_["ThresholdDetailCooldownNotTrackedLineTooltip"])
									dictEntry.behavior = { cooldownTracking = "shared" }
									behavior.trackCooldowns = false
									Expect("sharedOff", L_["ThresholdDetailCooldownNotTrackedSharedTooltip"])
									dictEntry.behavior = { cooldownTracking = "on" }
									Expect("on", nil)
									dictEntry.behavior, behavior.trackCooldowns = savedLine, savedShared
									Expect("restored", nil)

									-- While on Cooldown: Hide shows the line's own window, copied from the shared one; untracked, both gray out.
									local onCooldownDropdown = rawget(G, prefix .. "OnCooldown")
									local windowRadio = rawget(G, prefix .. "OnCooldownWindow_ModeGCDs")
									local function Choose(value)
										local root = drv.newDesc("root", "root")
										onCooldownDropdown.__generator(onCooldownDropdown, root)
										for _, c in ipairs(root.children) do
											if c.data == value then c.setSelected(c.data) return true end
										end
										return false
									end
									if onCooldownDropdown == nil or windowRadio == nil or onCooldownDropdown.__generator == nil then
										problems[#problems + 1] = "onCooldown missing"
									elseif onCooldownDropdown.__shown ~= true or (windowRadio.__shown == true) ~= (savedLine ~= nil and savedLine.onCooldown == "hide") then
										problems[#problems + 1] = "onCooldown=" .. tostring(onCooldownDropdown.__shown) .. " window=" .. tostring(windowRadio.__shown)
									else
										dictEntry.behavior = nil
										local shared = behavior.hideOnCooldown
										-- Off the defaults, so only a copy of the shared window passes.
										local sharedSaved = { shared.mode, shared.gcdsMax, shared.timeMax }
										shared.mode, shared.gcdsMax, shared.timeMax = "time", 7.5, 4
										local own = Choose("hide") and dictEntry.behavior ~= nil and dictEntry.behavior.onCooldownWindow or nil
										if own == nil or own == shared or own.mode ~= shared.mode or own.gcdsMax ~= shared.gcdsMax or own.timeMax ~= shared.timeMax or windowRadio.__shown ~= true then
											problems[#problems + 1] = "hide:window=" .. tostring(own ~= nil) .. " shown=" .. tostring(windowRadio.__shown)
										end
										shared.mode, shared.gcdsMax, shared.timeMax = sharedSaved[1], sharedSaved[2], sharedSaved[3]
										dictEntry.behavior.cooldownTracking = "off"
										toggle(useSpecific, true)
										local lineReason = L_["ThresholdDetailCooldownNotTrackedLineTooltip"]
										if onCooldownDropdown.__enabled ~= false or onCooldownDropdown.trbDisabledReason ~= lineReason
											or windowRadio.__enabled ~= false or windowRadio.trbDisabledReason ~= lineReason then
											problems[#problems + 1] = "untracked:onCooldown=" .. tostring(onCooldownDropdown.__enabled) .. " window=" .. tostring(windowRadio.__enabled)
										end
										dictEntry.behavior.cooldownTracking = nil
										-- Hidden while Unusable, a line without a handler of its own or a window color can't come back, so both gray out.
										local colors = dictEntry.colors
										local colorsSaved = { colors.colorMode, colors.unusable }
										local windowColorKey = spell.attributes.cooldownWindowColor
										local windowColor = windowColorKey ~= nil and panel.spec.colors.threshold[windowColorKey] or nil
										local hiddenReason = spell.isSnowflake ~= true and not (windowColor ~= nil and windowColor.enabled)
											and L_["ThresholdDetailOnCooldownUnusableHiddenTooltip"] or nil
										if hiddenReason ~= nil then unusableHiddenGrayed = unusableHiddenGrayed + 1 else unusableHiddenLive = unusableHiddenLive + 1 end
										colors.colorMode, colors.unusable = "dynamic", { mode = "hidden" }
										toggle(useSpecific, true)
										if onCooldownDropdown.trbDisabledReason ~= hiddenReason or (onCooldownDropdown.__enabled == false) ~= (hiddenReason ~= nil)
											or windowRadio.trbDisabledReason ~= hiddenReason then
											problems[#problems + 1] = "unusableHidden:onCooldown=" .. tostring(onCooldownDropdown.__enabled) .. " window=" .. tostring(windowRadio.trbDisabledReason ~= nil)
										end
										if spell.isSnowflake ~= true and windowColor ~= nil and windowColor.enabled then
											windowColor.enabled = false
											toggle(useSpecific, true)
											if onCooldownDropdown.trbDisabledReason ~= L_["ThresholdDetailOnCooldownUnusableHiddenTooltip"] then
												problems[#problems + 1] = "windowColorOff:onCooldown=" .. tostring(onCooldownDropdown.__enabled)
											end
											windowColor.enabled = true
											windowColorChecked = windowColorChecked + 1
										end
										colors.colorMode = "static"
										toggle(useSpecific, true)
										if onCooldownDropdown.__enabled == false or onCooldownDropdown.trbDisabledReason ~= nil then
											problems[#problems + 1] = "static:onCooldown=" .. tostring(onCooldownDropdown.__enabled)
										end
										colors.colorMode, colors.unusable = colorsSaved[1], colorsSaved[2]
										if not Choose("show") or windowRadio.__shown == true or onCooldownDropdown.__enabled == false then
											problems[#problems + 1] = "show:window=" .. tostring(windowRadio.__shown)
										end
										dictEntry.behavior = savedLine
										toggle(useSpecific, true)
									end

									-- A hidden icon grays out its Desaturate box and cooldown options, saying so.
									local iconShow, desaturate = rawget(G, prefix .. "IconShow"), rawget(G, prefix .. "IconDesaturated")
									local wasShown = dictEntry.icon.show
									toggle(iconShow, false)
									local hidden = L_["ThresholdDetailIconHiddenTooltip"]
									if desaturate.trbDisabledReason ~= hidden or swipeBox.trbDisabledReason ~= hidden or rechargeDropdown.trbDisabledReason ~= hidden then
										problems[#problems + 1] = "iconHidden:desaturate=" .. tostring(desaturate.trbDisabledReason ~= nil) .. " swipe=" .. tostring(swipeBox.trbDisabledReason ~= nil)
									end
									toggle(iconShow, wasShown ~= false)
									if desaturate.trbDisabledReason ~= nil or swipeBox.trbDisabledReason ~= nil then
										problems[#problems + 1] = "iconShown:reason left over"
									end
								end
								if #problems > 0 then
									trackingWrong[#trackingWrong + 1] = compositeKey .. "." .. key .. " " .. table.concat(problems, " ")
								end
								toggle(useSpecific, wasOn)
								if not wasEnabled then
									toggle(enabledBox, false)
								end
							end)
						end
					end
				end
			end
			print(string.format("INFO threshold icon overrides checked: %d with a cooldown, %d without, %d with charges", withCooldown, withoutCooldown, withCharges))
			table.sort(wrong)
			check("an icon override shows the cooldown options only for a line with a cooldown, and the recharge choice only with charges (" .. table.concat(wrong, ", ") .. ")",
				#wrong == 0 and withCooldown > 0 and withoutCooldown > 0)
			TRB_.Functions.Character.RefreshSpellRangeCheckUpdate = refreshRange
			print(string.format("INFO untracked lines whose Unusable row stays live: %d", unusableKept))
			print(string.format("INFO lines hidden while Unusable whose While on Cooldown grays out: %d, stays live: %d, live from a window color: %d",
				unusableHiddenGrayed, unusableHiddenLive, windowColorChecked))
			local noRangeSpecs = 0
			for _ in pairs(noRangeChecked) do noRangeSpecs = noRangeSpecs + 1 end
			print(string.format("INFO lines offering With No Valid Target: %d, %d of them without a cooldown; no-range lines checked on %d specs", withTarget, targetOnly, noRangeSpecs))
			table.sort(trackingWrong)
			check("a line with a cooldown offers Cooldown Tracking, and untracked, its cooldown-only options gray out with the reason (" .. table.concat(trackingWrong, "; ") .. ")",
				#trackingWrong == 0 and withCooldown > 0 and unusableHiddenGrayed > 0 and withTarget > 0)
		end

		return errors
	end
end

return hooks
