-- Checks Custom Bars: sources, the registry and scope of an added bar, its group, fill, and visibility entry, its bar
-- text anchor, and the options tab's add, edit, and delete.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}
-- What the stubbed client UI was asked for.
local drv = { tables = {}, menus = {}, buttons = {}, durations = 0 }

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	-- Brewmaster's and Evoker's ticks read these on the way through a layout pass.
	desktop.UnitStagger = function() return 0 end
	desktop.UnitPartialPower = function() return 0 end
	-- A confirmation is accepted at once.
	desktop.StaticPopup_Show = function(which, _, _, data)
		local dialog = desktop.StaticPopupDialogs[which]
		if dialog ~= nil and dialog.OnAccept ~= nil then
			dialog.OnAccept(nil, data)
		end
	end
	desktop.MenuUtil = setmetatable({
		CreateContextMenu = function(owner, generator)
			local root = { buttons = {} }
			function root:CreateTitle() end
			function root:CreateButton(label, callback)
				self.buttons[#self.buttons + 1] = { label = label, callback = callback }
			end
			function root:SetScrollMode() end
			generator(owner, root)
			drv.menus[#drv.menus + 1] = root
			return root
		end,
	}, { __index = desktop.MenuUtil })
	-- A stub frame has nothing under it; the default answer for an unknown Get is the number 0.
	local meta = getmetatable(desktop.CreateFrame("Frame"))
	local index = meta.__index
	meta.__index = function(self, key)
		if key == "GetChildren" or key == "GetRegions" then
			return function() end
		end
		return index(self, key)
	end
	desktop.C_DurationUtil = {
		CreateDuration = function()
			drv.durations = drv.durations + 1
			drv.lastDuration = { SetTimeSpan = function(self, startTime, endTime) self.startTime, self.endTime = startTime, endTime end }
			return drv.lastDuration
		end,
	}
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	TRB.Functions.News.Init = function() end

	local ScrollingTable = TRB.Details.addonData.libs.ScrollingTable
	rawset(ScrollingTable, "CreateST", function(self, columns, rowCount, rowHeight, color, parent)
		local st = { rows = {}, columns = columns, parent = parent }
		st.frame = desktop.CreateFrame("Frame")
		function st:SetData(data) self.rows = data end
		function st:GetSelection() return self.sel end
		function st:SetSelection(index) self.sel = index end
		function st:ClearSelection() self.sel = nil end
		function st:RegisterEvents(events)
			local merged = rawget(self, "events") or {}
			for name, handler in pairs(events) do
				merged[name] = handler
			end
			self.events = merged
		end
		local plain = { filtered = true, data = true, scrollframe = true, displayRows = true, rowHeight = true }
		setmetatable(st, { __index = function(_, key) if plain[key] then return nil end return function() end end })
		drv.tables[#drv.tables + 1] = st
		return st
	end)

	local Primitives = TRB.Functions.OptionsUi.Primitives
	local buildButton = Primitives.BuildButton
	Primitives.BuildButton = function(self, parent, text, ...)
		local button = buildButton(self, parent, text, ...)
		drv.buttons[text] = button
		return button
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
	---Runs a step, reporting an error as a failure.
	local function try(label, step)
		local ok, message = pcall(step)
		if not ok then
			check(label .. " (" .. tostring(message) .. ")", false)
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
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")

	local CustomBars = TRB.Functions.CustomBars
	local registry = TRB.Classes.BarTypeRegistry
	local definitions = registry:GetInstance()
	local BarVisibility = TRB.Functions.BarVisibility
	local BarText = TRB.Functions.BarText
	local BarNode = TRB.Classes.BarNode
	local character = TRB.Data.character
	local classId, specId = character.classId, character.specId
	local spec = TRB.Data.settings[character.className][character.specName]
	local snapshots = TRB.Data.snapshotData.snapshots

	-- A live Druid's humanoid form draws Restoration's bars, so the character starts in its own specialization's form.
	local isLiveDruid = TRB.Flavor.id == "mainline" and classId == 11
	local function SetForm(formId)
		desktop.GetShapeshiftFormID = function() return formId end
		stubs.fireEvents("UPDATE_SHAPESHIFT_FORM", ctx.addonName)
	end
	if isLiveDruid then
		check("a Druid in humanoid form draws Restoration's bars", CustomBars:IsDisplayedSpec(classId, 4) and not CustomBars:IsDisplayedSpec(classId, specId))
		try("shift to Moonkin Form", function() SetForm(31) end)
	end
	check("the character's own specialization is the one drawn", CustomBars:IsDisplayedSpec(classId, specId)
		and not CustomBars:IsDisplayedSpec(classId, specId + 50))

	-- A timer and a count that behave the same on every class and flavor.
	local timerSpell = TRB.Classes.SpellBase:New({
		id = 990001,
		duration = 10
	})
	timerSpell.name = "Driver Timer"
	local stackSpell = TRB.Classes.SpellBase:New({
		id = 990002,
		maxStacks = 3
	})
	stackSpell.name = "Driver Stacks"
	snapshots[timerSpell.id] = TRB.Classes.Snapshot:New(timerSpell)
	snapshots[stackSpell.id] = TRB.Classes.Snapshot:New(stackSpell)

	local function FindSource(kind, spellId)
		for _, source in ipairs(CustomBars:GetSources(classId, specId)) do
			if source.kind == kind and source.spellId == spellId then
				return source
			end
		end
		return nil
	end
	local timerSource = FindSource("buffTime", timerSpell.id)
	local stackSource = FindSource("buffStacks", stackSpell.id)
	check("a tracked spell with a duration is offered as a timer", timerSource ~= nil and FindSource("buffStacks", timerSpell.id) == nil)
	check("a tracked spell with a stack cap is offered as a count", stackSource ~= nil and FindSource("buffTime", stackSpell.id) == nil)
	check("another class's specialization offers nothing", #CustomBars:GetSources(classId, specId + 50) == 0)
	if timerSource == nil or stackSource == nil then
		print(string.format("DRIVER custom-bars: %d failures", errors))
		return
	end

	local function Relayout()
		TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
		local settings = TRB.Data.specCache[character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		return settings
	end
	local showContext = TRB.Classes.BarVisibilityContext:New({ specSupported = true })
	---Whether the visibility pass would show an entry's bar.
	local function Shows(entry)
		return entry ~= nil and BarVisibility:ShouldShowBar(showContext, entry) == true
	end
	local function EntryFor(group)
		local entries = BarVisibility:BeginEntries()
		CustomBars:AppendVisibilityEntries(entries, TRB.Frames.barGroups)
		for _, entry in ipairs(entries) do
			if entry.barGroup == group then
				return entry
			end
		end
		return nil
	end

	-- A timer bar.
	local timerGuid = CustomBars:Add(spec, classId, specId, timerSource)
	local timerKey = CustomBars:GetBarKey(timerGuid)
	local timerDef = definitions:Get(timerKey)
	check("an added bar is registered as its specialization's", timerDef ~= nil and timerDef.isUserBar and timerDef.ownerClassId == classId
		and timerDef.ownerSpecId == specId and timerDef.displayName == "Driver Timer")
	check("it has the standard bar data", spec.bars[timerKey] ~= nil and spec.colors.bars[timerKey] ~= nil and spec.displayBar[timerKey] ~= nil
		and spec.textures[timerKey .. "Bar"] ~= nil and spec.textures[timerKey .. "Border"] ~= nil and spec.textures[timerKey .. "Background"] ~= nil)
	check("it is in scope on its own specialization only", registry:IsBarInScope(timerKey, classId, specId)
		and not registry:IsBarInScope(timerKey, classId, specId + 50) and not registry:IsBarInScope(timerKey, nil, nil))
	check("it never follows Global Options", not registry:IsGlobalScopeBar(timerKey) and TRB.Data.settings.core.bars[timerKey] == nil
		and TRB.Data.settings.core.displayBar[timerKey] == nil)
	check("its options live under Custom Bars", registry:GetBarGroup(timerKey, classId, specId) == "customBars")
	check("it is exported with its specialization", definitions:GetBarTypesForSpec(classId, specId)[timerKey] ~= nil)

	local anchorName = CustomBars:GetAnchorName(timerKey)
	---The bar text entries bound to a bar, with their index in the spec's list.
	local function BoundText(name)
		local found = {}
		for index, textEntry in ipairs(spec.displayText.barText) do
			if textEntry.position ~= nil and textEntry.position.relativeToFrame == name then
				found[#found + 1] = { index = index, entry = textEntry }
			end
		end
		return found
	end
	local timerText = BoundText(anchorName)
	check("a timer bar gets its time as centered default bar text", #timerText == 1 and timerText[1].entry.text == "{$abilityTime}[$abilityTime]"
		and timerText[1].entry.position.relativeTo == "CENTER" and timerText[1].entry.fontJustifyHorizontal == "CENTER")

	local barGroups
	local timerGroup
	if try("lay out the timer bar", Relayout) then
		barGroups = TRB.Frames.barGroups
		timerGroup = barGroups[timerKey]
	end
	check("the timer bar is built with one node", timerGroup ~= nil and timerGroup.maxNodes == 1)
	if timerGroup == nil then
		print(string.format("DRIVER custom-bars: %d failures", errors))
		return
	end

	local binds, clears = 0, 0
	local setTimer, clearTimer = BarNode.SetTimerDuration, BarNode.ClearTimerDuration
	BarNode.SetTimerDuration = function(self, ...)
		binds = binds + 1
		return setTimer(self, ...)
	end
	BarNode.ClearTimerDuration = function(self, ...)
		clears = clears + 1
		return clearTimer(self, ...)
	end

	local timerBuff = snapshots[timerSpell.id].buff
	try("render an idle timer", function() CustomBars:Render() end)
	local entry = EntryFor(timerGroup)
	check("an idle timer is never bound and its bar is hidden", binds == 0 and not Shows(entry))
	timerBuff:InitializeCustom(10)
	try("render a running timer", function() CustomBars:Render() end)
	entry = EntryFor(timerGroup)
	check("a running timer is bound once and its bar shows", binds == 1 and Shows(entry))
	try("render it again", function() CustomBars:Render() end)
	check("an unchanged timer isn't bound again", binds == 1)
	timerBuff:InitializeCustom(20)
	try("render a refreshed timer", function() CustomBars:Render() end)
	check("a refreshed timer is bound again", binds == 2)

	-- The bar's own bar text variables, which text bound to it reaches as $abilityTime.
	local timeVar = "$" .. timerKey .. "Time"
	---The index of a bound entry in the list the text frames were built from, which leads with Global Bar Text.
	local function FrameIndexOf(name)
		for index, textEntry in ipairs(TRB.Data.specCache[character.compositeKey].settings.displayText.barText) do
			if textEntry.position ~= nil and textEntry.position.relativeToFrame == name then
				return index
			end
		end
		return nil
	end
	local function RenderedText(name)
		local index = FrameIndexOf(name)
		local frame = index ~= nil and TRB.Frames.textFrames ~= nil and TRB.Frames.textFrames[index] or nil
		return frame ~= nil and frame.font ~= nil and rawget(frame.font, "__text") or nil
	end
	---Draws the bar text with the bar's group and node counted as shown.
	local function DrawText(group)
		group.isVisible = true
		group.nodes[1].isVisible = true
		TRB.Data.lookupDirty = true
		BarText:UpdateResourceBarText(TRB.Data.specCache[character.compositeKey].settings, true)
	end
	if #timerText == 1 then
		try("build the text frames", function() BarText:CreateBarTextFrames() end)
		try("draw a running timer's text", function() DrawText(timerGroup) end)
		local shown = RenderedText(anchorName)
		check("text bound to a running timer shows its time", TRB.Data.activeVariables ~= nil and TRB.Data.activeVariables[timeVar] == true
			and TRB.Functions.Class:IsValidVariableForSpec(timeVar) == true and TRB.Data.lookup[timeVar] ~= nil and TRB.Data.lookup[timeVar] ~= ""
			and type(shown) == "string" and shown:find(TRB.Data.lookup[timeVar], 1, true) ~= nil)
		check("a running timer keeps bar text counting down", CustomBars:HasActiveTimer())
	end
	local clearsBefore = clears
	timerBuff.endTime = desktop.GetTime() - 1
	try("render an expired timer", function() CustomBars:Render() end)
	entry = EntryFor(timerGroup)
	check("an expired timer is cleared and its bar is hidden", clears > clearsBefore and not Shows(entry))
	check("a new bar shows When Active, offered with the standard conditions", spec.displayBar[timerKey].alwaysShow == false
		and spec.displayBar[timerKey].conditions.whenActive == true and BarVisibility:GetProfileKeyForBar(timerKey) == "timerEnvironment")
	spec.displayBar[timerKey].alwaysShow = true
	try("recompose with Always Show", Relayout)
	try("render under Always Show", function() CustomBars:Render() end)
	check("with Always Show, an idle bar shows", Shows(EntryFor(barGroups[timerKey])))
	spec.displayBar[timerKey].neverShow = true
	try("recompose with Never Show", Relayout)
	check("with Never Show, it never does", not Shows(EntryFor(barGroups[timerKey])))
	spec.displayBar[timerKey].alwaysShow, spec.displayBar[timerKey].neverShow = false, false
	try("recompose with When Active", Relayout)
	try("render under When Active", function() CustomBars:Render() end)
	check("back on When Active, an idle bar is hidden again", not Shows(EntryFor(barGroups[timerKey])))
	timerGroup = barGroups[timerKey]
	if #timerText == 1 then
		try("draw an idle timer's text", function() DrawText(timerGroup) end)
		check("text bound to an idle timer is empty", TRB.Data.lookup[timeVar] == "" and not TRB.Functions.Class:IsValidVariableForSpec(timeVar)
			and not CustomBars:HasActiveTimer())
		check("the unbound names render empty on any other bar", TRB.Data.lookup["$abilityTime"] == "" and TRB.Data.lookup["$abilityStacks"] == ""
			and TRB.Data.lookup["$abilityStacksMax"] == "" and not TRB.Functions.Class:IsValidVariableForSpec("$abilityTime"))
	end
	BarNode.SetTimerDuration, BarNode.ClearTimerDuration = setTimer, clearTimer

	-- A count bar.
	local stackGuid = CustomBars:Add(spec, classId, specId, stackSource)
	local stackKey = CustomBars:GetBarKey(stackGuid)
	local stackDef = definitions:Get(stackKey)
	check("a count bar is segmented by default", stackDef ~= nil and stackDef.isMultiNode and stackDef.maxNodes == 3 and stackDef.minMaxMode == "stepped")
	try("lay out the count bar", Relayout)
	local stackGroup = barGroups[stackKey]
	check("the count bar is built with a node per stack", stackGroup ~= nil and stackGroup.maxNodes == 3)
	local stackAnchor = CustomBars:GetAnchorName(stackKey)
	local stackText = BoundText(stackAnchor)
	check("a count bar gets its stacks as centered default bar text", #stackText == 1 and stackText[1].entry.text == "{$abilityStacks}[$abilityStacks]"
		and stackText[1].entry.position.relativeTo == "CENTER")

	local values = {}
	local setValue = BarNode.SetValue
	BarNode.SetValue = function(self, value, ...)
		values[self] = value
		return setValue(self, value, ...)
	end
	local stackBuff = snapshots[stackSpell.id].buff
	stackBuff:InitializeCustom(10, nil, true, 2)
	try("render two stacks", function() CustomBars:Render() end)
	local allTwo = stackGroup ~= nil
	for i = 1, 3 do
		allTwo = allTwo and stackGroup ~= nil and values[stackGroup.nodes[i]] == math.min(2, i)
	end
	entry = EntryFor(stackGroup)
	check("each segment fills up to the count, and the bar shows", allTwo and Shows(entry) and entry ~= nil and entry.showNodesCount == 3)
	if #stackText == 1 and stackGroup ~= nil then
		try("build the count's text frame", function() BarText:CreateBarTextFrames() end)
		try("draw the count's text", function() DrawText(stackGroup) end)
		local shown = RenderedText(stackAnchor)
		check("text bound to a count shows its stacks and knows its maximum", TRB.Data.lookup["$" .. stackKey .. "Stacks"] == "2"
			and TRB.Data.lookup["$" .. stackKey .. "StacksMax"] == "3" and type(shown) == "string" and shown:find("2", 1, true) ~= nil
			and TRB.Functions.Class:IsValidVariableForSpec("$" .. stackKey .. "Stacks") == true
			and TRB.Functions.Class:IsValidVariableForSpec("$" .. stackKey .. "StacksMax") == true)
		CustomBars:SetSource(spec, classId, specId, spec.customBars.bars[stackGuid], timerSource)
		check("changing what a bar tracks swaps its untouched default text", BoundText(stackAnchor)[1].entry.text == "{$abilityTime}[$abilityTime]"
			and spec.customBars.bars[stackGuid].name == "Driver Timer")
		CustomBars:SetSource(spec, classId, specId, spec.customBars.bars[stackGuid], stackSource)
		check("and back again", BoundText(stackAnchor)[1].entry.text == "{$abilityStacks}[$abilityStacks]"
			and spec.customBars.bars[stackGuid].name == "Driver Stacks")
		try("lay out after the source changes", Relayout)
		try("render after the source changes", function() CustomBars:Render() end)
		stackGroup = barGroups[stackKey]
	end

	-- End Cap.
	local stackColors = spec.colors.bars[stackKey]
	check("a new bar has an End Cap entry, off by default", stackColors.endCap ~= nil and stackColors.endCap.enabled == false
		and stackGroup ~= nil and stackGroup.nodes[1].endCapConfig == nil)
	stackColors.endCap.enabled = true
	try("apply the End Cap", function() TRB.Functions.Bar:ApplyBarGroupsAppearance(Relayout(), barGroups) end)
	stackGroup = barGroups[stackKey]
	check("turning the End Cap on reaches the bar's nodes", stackGroup ~= nil and stackGroup.nodes[1].endCapConfig ~= nil
		and stackGroup.nodes[3].endCapConfig ~= nil)
	stackColors.endCap.enabled = false

	spec.customBars.bars[stackGuid].segmented = false
	try("lay out the count bar unsegmented", Relayout)
	stackGroup = barGroups[stackKey]
	check("an unsegmented count bar is rebuilt with one node", stackGroup ~= nil and stackGroup.maxNodes == 1 and not stackDef.isMultiNode
		and stackDef.minMaxMode == "custom")
	try("render the unsegmented count", function() CustomBars:Render() end)
	check("its one node takes the count", stackGroup ~= nil and values[stackGroup.nodes[1]] == 2 and stackGroup.nodes[1].rangeMax == 3)
	-- A cooldown and a charge count, read through the cooldown tracker.
	local SECRET = setmetatable({}, { __tostring = function() return "SECRET" end })
	local cooldownSpell = TRB.Classes.SpellBase:New({
		id = 990003,
		hasCooldown = true
	})
	cooldownSpell.name = "Driver Cooldown"
	-- Its duration is its recharge, as a charge ability's is.
	local chargeSpell = TRB.Classes.SpellBase:New({
		id = 990004,
		duration = 20,
		hasCharges = true
	})
	chargeSpell.name = "Driver Charges"
	-- A charge ability that also names a buff, whose duration is the buff's.
	local chargeBuffSpell = TRB.Classes.SpellBase:New({
		id = 990005,
		buffId = 990015,
		duration = 6,
		hasCharges = true
	})
	chargeBuffSpell.name = "Driver Charge Buff"
	-- Charges a class module counts by hand, with nothing in the spell saying so.
	local manualSpell = TRB.Classes.SpellBase:New({
		id = 990006,
		duration = 30
	})
	manualSpell.name = "Driver Manual Charges"
	snapshots[cooldownSpell.id] = TRB.Classes.Snapshot:New(cooldownSpell)
	snapshots[chargeSpell.id] = TRB.Classes.Snapshot:New(chargeSpell)
	snapshots[chargeBuffSpell.id] = TRB.Classes.Snapshot:New(chargeBuffSpell)
	snapshots[manualSpell.id] = TRB.Classes.Snapshot:New(manualSpell)
	local savedApi = {
		GetSpellCooldown = desktop.C_Spell.GetSpellCooldown,
		GetSpellCharges = desktop.C_Spell.GetSpellCharges,
		GetSpellCooldownDuration = desktop.C_Spell.GetSpellCooldownDuration,
		GetSpellChargeDuration = desktop.C_Spell.GetSpellChargeDuration,
		issecretvalue = desktop.issecretvalue,
	}
	local cooldownReading = nil
	local chargeReading = { currentCharges = 1, maxCharges = 2, isActive = false }
	local cooldownObject = { GetRemainingDuration = function() return 9 end }
	local rechargeObject = { GetRemainingDuration = function() return 5 end }
	desktop.C_Spell.GetSpellChargeDuration = function(id)
		if id == chargeSpell.id then
			return rechargeObject
		end
		return savedApi.GetSpellChargeDuration(id)
	end
	desktop.C_Spell.GetSpellCooldown = function(id)
		if id == cooldownSpell.id then
			return cooldownReading
		elseif id == chargeSpell.id then
			return nil
		end
		return savedApi.GetSpellCooldown(id)
	end
	desktop.C_Spell.GetSpellCharges = function(id)
		if id == chargeSpell.id then
			return chargeReading
		elseif id == manualSpell.id or id == chargeBuffSpell.id then
			return nil
		end
		return savedApi.GetSpellCharges(id)
	end
	desktop.C_Spell.GetSpellCooldownDuration = function(id, ...)
		if id == cooldownSpell.id then
			return cooldownObject
		end
		return savedApi.GetSpellCooldownDuration(id, ...)
	end
	desktop.issecretvalue = function(value) return value == SECRET end

	local cooldownSource = FindSource("cooldownTime", cooldownSpell.id)
	local chargeSource = FindSource("charges", chargeSpell.id)
	local rechargeSource = FindSource("rechargeTime", chargeSpell.id)
	check("a tracked cooldown is offered as a Cooldown, and a charge ability as Charges and a Recharge", cooldownSource ~= nil
		and chargeSource ~= nil and rechargeSource ~= nil and FindSource("cooldownTime", chargeSpell.id) == nil
		and FindSource("rechargeTime", cooldownSpell.id) == nil)
	check("a charge ability's duration is its recharge, so it is never offered as a Duration", FindSource("buffTime", chargeSpell.id) == nil)
	check("unless the spell also names a buff", FindSource("buffTime", chargeBuffSpell.id) ~= nil and FindSource("rechargeTime", chargeBuffSpell.id) ~= nil)
	check("a spell with a duration and no charges is a Duration", FindSource("buffTime", manualSpell.id) ~= nil
		and FindSource("rechargeTime", manualSpell.id) == nil)
	local manualCooldown = snapshots[manualSpell.id].cooldown
	manualCooldown:InitializeManualCharges(2, 1)
	local manualSource = FindSource("rechargeTime", manualSpell.id)
	check("charges a class module counts by hand make it a charge ability", manualSource ~= nil and FindSource("charges", manualSpell.id) ~= nil
		and FindSource("buffTime", manualSpell.id) == nil)
	-- A hand-counted single charge on a spell that declares a cooldown, as Holy Word: Chastise is.
	local singleSpell = TRB.Classes.SpellBase:New({
		id = 990007,
		cooldown = 60,
		hasCooldown = true
	})
	singleSpell.name = "Driver Single Charge"
	snapshots[singleSpell.id] = TRB.Classes.Snapshot:New(singleSpell)
	local listedBefore = FindSource("cooldownTime", singleSpell.id) ~= nil and FindSource("buffTime", singleSpell.id) == nil
	local singleCooldown = snapshots[singleSpell.id].cooldown
	singleCooldown:InitializeManualCharges(1, 0)
	local singleSource = FindSource("cooldownTime", singleSpell.id)
	check("a hand-counted single charge is a Cooldown, counted or not, and never a Duration", listedBefore and singleSource ~= nil
		and FindSource("buffTime", singleSpell.id) == nil and FindSource("charges", singleSpell.id) == nil
		and FindSource("rechargeTime", singleSpell.id) == nil)
	if singleSource ~= nil then
		local singleGuid = CustomBars:Add(spec, classId, specId, singleSource)
		local singleKey = CustomBars:GetBarKey(singleGuid)
		try("lay out the single charge bar", Relayout)
		singleCooldown.manualCooldownDuration = 60
		singleCooldown.manualCooldownExpires = desktop.GetTime() + 20
		try("render the single charge's cooldown", function() CustomBars:Render() end)
		check("its Cooldown bar runs on the hand-counted cooldown", Shows(EntryFor(barGroups[singleKey])))
		singleCooldown.manualCharges = 1
		try("render the single charge ready", function() CustomBars:Render() end)
		check("and hides when it is ready", not Shows(EntryFor(barGroups[singleKey])))
		CustomBars:Delete(spec, classId, specId, singleGuid)
	end
	snapshots[singleSpell.id] = nil
	local totalSource = FindSource("totalRechargeTime", manualSpell.id)
	check("only hand-counted charges are offered a Total Recharge", totalSource ~= nil and FindSource("totalRechargeTime", chargeSpell.id) == nil)
	if cooldownSource ~= nil and chargeSource ~= nil and rechargeSource ~= nil and manualSource ~= nil then
		local cooldownGuid = CustomBars:Add(spec, classId, specId, cooldownSource)
		local chargeGuid = CustomBars:Add(spec, classId, specId, chargeSource)
		local rechargeGuid = CustomBars:Add(spec, classId, specId, rechargeSource)
		local manualGuid = CustomBars:Add(spec, classId, specId, manualSource)
		local cooldownKey, chargeKey = CustomBars:GetBarKey(cooldownGuid), CustomBars:GetBarKey(chargeGuid)
		local rechargeKey, manualKey = CustomBars:GetBarKey(rechargeGuid), CustomBars:GetBarKey(manualGuid)
		check("a recharge bar gets its time as default bar text", #BoundText(CustomBars:GetAnchorName(rechargeKey)) == 1
			and BoundText(CustomBars:GetAnchorName(rechargeKey))[1].entry.text == "{$abilityTime}[$abilityTime]")
		local chargingAnchor = CustomBars:GetRechargingAnchorName(chargeKey)
		local chargingText = BoundText(chargingAnchor)
		check("a charges bar that fills its recharging charge gets the recharge time centered on that charge", #chargingText == 1
			and chargingText[1].entry.text == "{$abilityTime}[$abilityTime]" and chargingText[1].entry.position.relativeTo == "CENTER"
			and #BoundText(CustomBars:GetAnchorName(chargeKey)) == 0)
		local chargingAnchored = false
		for _, anchor in ipairs(BarText:GetAnchorCatalog(classId, specId).entries) do
			chargingAnchored = chargingAnchored or (anchor.frame == chargingAnchor and anchor.groupKey == "customBars")
		end
		check("bar text can be bound to its recharging charge", chargingAnchored
			and BarText:IsEntryInScope({ position = { relativeToFrame = chargingAnchor } }, classId, specId)
			and not BarText:IsEntryInScope({ position = { relativeToFrame = chargingAnchor } }, classId, specId + 50))
		local trackedSpells = {}
		CustomBars:AppendCooldownSpells(trackedSpells)
		check("the tracked cooldowns join the cooldown tracker, and hand-counted charges stay out", #trackedSpells == 3)
		try("track the cooldowns", function() TRB.Functions.ThresholdCooldowns:Enable() end)
		check("a tracked charge spell is read once on joining", snapshots[chargeSpell.id].cooldown.charges == 1 and snapshots[chargeSpell.id].cooldown.maxCharges == 2)
		try("lay out the cooldown bars", Relayout)
		local cooldownGroup, chargeGroup = barGroups[cooldownKey], barGroups[chargeKey]
		check("a charge bar is built with a node per charge", chargeGroup ~= nil and chargeGroup.maxNodes == 2 and cooldownGroup ~= nil and cooldownGroup.maxNodes == 1)

		try("render the charges", function() CustomBars:Render() end)
		entry = EntryFor(chargeGroup)
		check("each charge segment takes the count", chargeGroup ~= nil and values[chargeGroup.nodes[1]] == 1 and values[chargeGroup.nodes[2]] == 1
			and Shows(entry))
		chargeReading.currentCharges = SECRET
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		local writes = 0
		BarNode.SetValue = function(self, value, ...)
			if value == SECRET then
				writes = writes + 1
			end
			return setValue(self, value, ...)
		end
		try("render a secret count", function()
			CustomBars:Render()
			CustomBars:Render()
		end)
		entry = EntryFor(chargeGroup)
		check("a secret count is written once, not on every tick, and its bar stays shown", writes == 2 and Shows(entry))
		chargeReading.isActive = true
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render after a charge event", function()
			CustomBars:Render()
			CustomBars:Render()
		end)
		check("and again when a charge event says it changed", writes == 4)
		chargeReading.isActive = false
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render after the recharge ends", function() CustomBars:Render() end)

		-- A maximum learned after the bar was built rebuilds it, and the text frames with it.
		local textBuilds = 0
		local createBarTextFrames = BarText.CreateBarTextFrames
		BarText.CreateBarTextFrames = function(...)
			textBuilds = textBuilds + 1
			return createBarTextFrames(...)
		end
		chargeReading.currentCharges, chargeReading.maxCharges = 1, 3
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render a raised maximum", function() CustomBars:Render() end)
		check("a raised maximum rebuilds the bar and its text frames", barGroups[chargeKey] ~= nil and barGroups[chargeKey].maxNodes == 3
			and textBuilds > 0 and spec.customBars.bars[chargeGuid].maxCount == 3)
		BarText.CreateBarTextFrames = createBarTextFrames
		chargeReading.currentCharges, chargeReading.maxCharges = SECRET, 2
		chargeReading.isActive = true
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render the maximum back", function() CustomBars:Render() end)
		chargeReading.isActive = false
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render settled", function() CustomBars:Render() end)
		chargeGroup = barGroups[chargeKey]

		binds, clears = 0, 0
		BarNode.SetTimerDuration = function(self, ...)
			binds = binds + 1
			return setTimer(self, ...)
		end
		BarNode.ClearTimerDuration = function(self, ...)
			clears = clears + 1
			return clearTimer(self, ...)
		end
		try("render an idle cooldown", function() CustomBars:Render() end)
		entry = EntryFor(cooldownGroup)
		check("a ready cooldown is never bound and its bar is hidden", binds == 0 and not Shows(entry))
		cooldownReading = { isActive = true, isOnGCD = false, isEnabled = true, modRate = 1, startTime = desktop.GetTime(), duration = 30 }
		stubs.fireEvents("SPELL_UPDATE_COOLDOWN:" .. cooldownSpell.id, ctx.addonName)
		try("render a running cooldown", function()
			CustomBars:Render()
			CustomBars:Render()
		end)
		entry = EntryFor(cooldownGroup)
		check("a running cooldown is bound once and its bar shows", binds == 1 and Shows(entry))
		cooldownReading = { isActive = false, isOnGCD = false, isEnabled = true, modRate = 1, startTime = 0, duration = 0 }
		stubs.fireEvents("SPELL_UPDATE_COOLDOWN:" .. cooldownSpell.id, ctx.addonName)
		clearsBefore = clears
		try("render a finished cooldown", function() CustomBars:Render() end)
		entry = EntryFor(cooldownGroup)
		check("a finished cooldown is cleared and its bar is hidden", clears > clearsBefore and not Shows(entry))

		-- Recharges: one the tracker reads, one a class module counts.
		local rechargeGroup, manualGroup = barGroups[rechargeKey], barGroups[manualKey]
		check("the recharge bars are built", rechargeGroup ~= nil and manualGroup ~= nil)
		binds = 0
		check("a charge ability that isn't recharging hides its recharge bar", not Shows(EntryFor(rechargeGroup)))
		chargeReading.isActive = true
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render a running recharge", function()
			CustomBars:Render()
			CustomBars:Render()
		end)
		check("a running recharge is bound once and its bar shows", binds == 1 and Shows(EntryFor(rechargeGroup)))
		chargeReading.isActive = false
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		clearsBefore = clears
		try("render a finished recharge", function() CustomBars:Render() end)
		check("a finished recharge is cleared and its bar is hidden", clears > clearsBefore and not Shows(EntryFor(rechargeGroup)))

		binds = 0
		check("a hand-counted recharge that isn't timed yet is hidden", not Shows(EntryFor(manualGroup)))
		manualCooldown.manualCooldownDuration = 30
		manualCooldown.manualCooldownExpires = desktop.GetTime() + 12
		try("render a hand-counted recharge", function()
			CustomBars:Render()
			CustomBars:Render()
		end)
		check("a hand-counted recharge is bound once and its bar shows", binds == 1 and Shows(EntryFor(manualGroup)))
		manualCooldown.manualCooldownExpires = manualCooldown.manualCooldownExpires - 4
		try("render a shortened recharge", function() CustomBars:Render() end)
		check("a shortened recharge is bound again", binds == 2)
		manualCooldown.manualCharges = 2
		try("render a full set of charges", function() CustomBars:Render() end)
		check("with every charge back, its bar is hidden", not Shows(EntryFor(manualGroup)))

		-- Total Recharge: the running recharge plus a full one for each charge queued behind it.
		if totalSource ~= nil then
			local totalGuid = CustomBars:Add(spec, classId, specId, totalSource)
			local totalKey = CustomBars:GetBarKey(totalGuid)
			try("lay out the total recharge bar", Relayout)
			local now = desktop.GetTime()
			manualCooldown.manualCharges = 0
			manualCooldown.manualCooldownDuration = 30
			manualCooldown.manualCooldownExpires = now + 12
			binds = 0
			drv.lastDuration = nil
			try("render a total recharge", function()
				CustomBars:Render()
				CustomBars:Render()
			end)
			-- The recharge and total recharge bars each build one.
			local total = nil
			for _, runtimeEntry in ipairs(CustomBars:GetRuntime()) do
				if runtimeEntry.key == totalKey then
					total = runtimeEntry
				end
			end
			check("with no charges left, the total runs the recharge and one more, against two", total ~= nil and total.active
				and math.abs(total.endTime - (now + 42)) < 0.001 and total.duration == 60 and Shows(EntryFor(barGroups[totalKey])))
			manualCooldown.manualCharges = 1
			try("render the last recharge", function() CustomBars:Render() end)
			check("with one charge back, it runs only the recharge left", total ~= nil and math.abs(total.endTime - (now + 12)) < 0.001
				and total.duration == 60)
			manualCooldown.manualCharges = 2
			try("render a finished total recharge", function() CustomBars:Render() end)
			check("with every charge back, the total recharge bar is hidden", not Shows(EntryFor(barGroups[totalKey])))
			CustomBars:Delete(spec, classId, specId, totalGuid)
		end

		-- Charges with the recharging charge filling.
		local BarGroup = TRB.Classes.BarGroup
		local recharges = {}
		local setRecharge = BarGroup.SetChargeRechargeDuration
		BarGroup.SetChargeRechargeDuration = function(self, durationObject)
			recharges[self] = durationObject or false
			return setRecharge(self, durationObject)
		end
		chargeGroup = barGroups[chargeKey]
		check("a segmented charges bar fills its recharging charge by default", CustomBars:FillsRecharge(spec.customBars.bars[chargeGuid])
			and chargeGroup ~= nil and chargeGroup.chargeTracker ~= nil)
		chargeReading.currentCharges = 0
		chargeReading.isActive = true
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render a recharging charge", function() CustomBars:Render() end)
		check("the recharging charge runs on the game's recharge, and the bar shows with no charges left", recharges[chargeGroup] == rechargeObject
			and Shows(EntryFor(chargeGroup)))
		try("draw the recharging charges bar's text", function() DrawText(chargeGroup) end)
		check("a charges bar's time is its next charge's recharge", TRB.Functions.Class:IsValidVariableForSpec("$" .. chargeKey .. "Time") == true
			and CustomBars:HasActiveTimer())
		chargeReading.currentCharges = 2
		chargeReading.isActive = false
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("render full charges", function() CustomBars:Render() end)
		check("with every charge back, nothing fills", recharges[chargeGroup] == false
			and not TRB.Functions.Class:IsValidVariableForSpec("$" .. chargeKey .. "Time"))
		CustomBars:Change(spec, classId, specId, spec.customBars.bars[chargeGuid], function(bar)
			bar.fillRecharge = false
		end)
		local movedText = BoundText(CustomBars:GetAnchorName(chargeKey))
		check("turning the fill off moves its untouched default text to the bar, as its charges", #BoundText(chargingAnchor) == 0
			and #movedText == 1 and movedText[1].entry.text == "{$abilityStacks}[$abilityStacks]")
		chargeReading.currentCharges = 1
		chargeReading.isActive = true
		stubs.fireEvents("SPELL_UPDATE_CHARGES", ctx.addonName)
		try("recompose with the fill off", Relayout)
		try("render with the fill off", function() CustomBars:Render() end)
		check("with the option off, the recharging charge stays empty", not CustomBars:FillsRecharge(spec.customBars.bars[chargeGuid])
			and recharges[barGroups[chargeKey]] == false)
		BarGroup.SetChargeRechargeDuration = setRecharge
		BarNode.SetTimerDuration, BarNode.ClearTimerDuration = setTimer, clearTimer

		CustomBars:Delete(spec, classId, specId, cooldownGuid)
		CustomBars:Delete(spec, classId, specId, chargeGuid)
		CustomBars:Delete(spec, classId, specId, rechargeGuid)
		CustomBars:Delete(spec, classId, specId, manualGuid)
		try("lay out without the cooldown bars", Relayout)
		try("render without them", function() CustomBars:Render() end)
		local stillTracked = {}
		CustomBars:AppendCooldownSpells(stillTracked)
		check("deleted bars leave the cooldown tracker", #stillTracked == 0 and barGroups[cooldownKey] == nil and barGroups[chargeKey] == nil)
		check("and take the text bound to them, on the bar or its recharging charge", #BoundText(CustomBars:GetAnchorName(chargeKey)) == 0
			and #BoundText(chargingAnchor) == 0 and #BoundText(CustomBars:GetAnchorName(rechargeKey)) == 0)
	end
	desktop.C_Spell.GetSpellCooldown = savedApi.GetSpellCooldown
	desktop.C_Spell.GetSpellCharges = savedApi.GetSpellCharges
	desktop.C_Spell.GetSpellCooldownDuration = savedApi.GetSpellCooldownDuration
	desktop.C_Spell.GetSpellChargeDuration = savedApi.GetSpellChargeDuration
	snapshots[chargeBuffSpell.id], snapshots[manualSpell.id] = nil, nil
	desktop.issecretvalue = savedApi.issecretvalue
	BarNode.SetValue = setValue

	-- Bar text.
	local anchored = nil
	for _, anchor in ipairs(BarText:GetAnchorCatalog(classId, specId).entries) do
		if anchor.frame == anchorName then
			anchored = anchor
		end
	end
	check("bar text can be bound to the bar, on the Custom Bars tab", anchored ~= nil and anchored.groupKey == "customBars")
	local globalHasIt = false
	for _, anchor in ipairs(BarText:GetAnchorCatalog(nil, nil).entries) do
		globalHasIt = globalHasIt or anchor.frame == anchorName
	end
	check("Global Bar Text can't be bound to it", not globalHasIt)
	check("its anchor resolves to the bar's frame", BarText:GetAnchorFrame(anchorName) == timerGroup:GetNode(1):GetFrame())
	check("text bound to it stays on its specialization", BarText:IsEntryInScope({ position = { relativeToFrame = anchorName } }, classId, specId)
		and not BarText:IsEntryInScope({ position = { relativeToFrame = anchorName } }, classId, specId + 50))

	-- Retiring a built frame frees the names under it, and only the ones still pointing at it.
	do
		local function Named(name, children, regions)
			return {
				GetName = function() return name end,
				GetChildren = function() return unpack(children or {}) end,
				GetRegions = function() return unpack(regions or {}) end,
			}
		end
		local label = Named("TRBDriverCheckboxText")
		local checkbox = Named("TRBDriverCheckbox", nil, { label })
		local replaced = Named("TRBDriverReplaced")
		local unnamed = Named(nil, { checkbox, replaced })
		local other = {}
		rawset(desktop, "TRBDriverCheckboxText", label)
		rawset(desktop, "TRBDriverCheckbox", checkbox)
		rawset(desktop, "TRBDriverReplaced", other)
		TRB.Functions.OptionsUi.Primitives:ReleaseFrameNames(unnamed)
		check("retiring a frame frees its children's and their regions' names", rawget(desktop, "TRBDriverCheckboxText") == nil
			and rawget(desktop, "TRBDriverCheckbox") == nil)
		check("a name something else took since is left alone", rawget(desktop, "TRBDriverReplaced") == other)
		rawset(desktop, "TRBDriverReplaced", nil)
	end

	local function RuntimeEntry(key)
		for _, runtimeEntry in ipairs(CustomBars:GetRuntime()) do
			if runtimeEntry.key == key then
				return runtimeEntry
			end
		end
		return nil
	end

	-- The real visibility pass takes the bars in and shows or hides them.
	do
		local appended = 0
		local append = CustomBars.AppendVisibilityEntries
		CustomBars.AppendVisibilityEntries = function(self, entries, groups)
			local before = #entries
			append(self, entries, groups)
			appended = #entries - before
		end
		-- What the pass asks of the timer bar; a layout pass's transition would hold every bar hidden.
		local alpha = nil
		local passGroup = barGroups[timerKey]
		local setTargetAlpha = passGroup.SetTargetAlpha
		passGroup.SetTargetAlpha = function(self, target, ...)
			alpha = target
			return setTargetAlpha(self, target, ...)
		end
		try("end the render transition", function() TRB.Functions.Bar:EndRenderTransition("driver") end)
		local function Pass()
			BarVisibility:ProcessBars(BarVisibility:GetGameStateContext(false), BarVisibility:BeginEntries(), TRB.Data.snapshotData,
				TRB.Data.specCache[character.compositeKey].settings)
		end
		timerBuff:InitializeCustom(10)
		try("render a running timer for the visibility pass", function() CustomBars:Render() end)
		try("run the visibility pass", Pass)
		check("the visibility pass takes in every custom bar and shows a running one", appended == #CustomBars:GetRuntime() and appended > 0
			and alpha ~= nil and alpha > 0)
		timerBuff.endTime = desktop.GetTime() - 1
		try("render an expired timer for the visibility pass", function() CustomBars:Render() end)
		try("run the visibility pass again", Pass)
		check("and hides it once it stops", alpha == 0)
		passGroup.SetTargetAlpha = nil
		CustomBars.AppendVisibilityEntries = append
	end

	-- A paused buff holds its bar.
	do
		timerBuff:InitializeCustom(10)
		try("render before the pause", function() CustomBars:Render() end)
		timerBuff:SetPauseMaxDuration(5)
		timerBuff:GetRemainingTime()
		timerBuff:EnterPauseMode()
		try("render a paused buff", function() CustomBars:Render() end)
		local paused = RuntimeEntry(timerKey)
		check("a paused buff's bar holds its time and stays shown", timerBuff.isPaused == true and paused ~= nil and paused.active
			and paused.pausedRemaining ~= nil and paused.endTime == nil and Shows(EntryFor(barGroups[timerKey])))
		local lookup = {}
		CustomBars:WriteLookup(lookup)
		check("and its text shows the held time", lookup["$" .. timerKey .. "Time"] ~= nil and lookup["$" .. timerKey .. "Time"] ~= "")
		timerBuff:ExitPauseMode()
		try("render after the pause", function() CustomBars:Render() end)
		check("and runs again when the pause ends", paused ~= nil and paused.pausedRemaining == nil and paused.endTime ~= nil)
		timerBuff:SetPauseMaxDuration(nil)
		timerBuff.endTime = desktop.GetTime() - 1
		try("render the expired timer", function() CustomBars:Render() end)
	end

	-- A rename takes the bound text's names along, unless one was changed by hand.
	do
		local timerBar = spec.customBars.bars[timerGuid]
		local textEntry = BoundText(anchorName)[1].entry
		local label = TRB.Localization["CustomBarsAnchorLabel"]
		CustomBars:Rename(spec, classId, specId, timerBar, "Renamed")
		check("renaming a bar renames its untouched bar text and its anchor", textEntry.name == string.format(label, "Renamed")
			and textEntry.position.relativeToFrameName == string.format(label, "Renamed") and timerDef.displayName == "Renamed")
		textEntry.name = "Mine"
		CustomBars:Rename(spec, classId, specId, timerBar, "Driver Timer")
		check("a bar text name changed by hand is kept, and its anchor still follows", textEntry.name == "Mine"
			and textEntry.position.relativeToFrameName == string.format(label, "Driver Timer"))
		textEntry.name = string.format(label, "Driver Timer")
	end

	-- A count bar's maximum is saved, for a login where it can't be read.
	check("a count bar saves the maximum it read", spec.customBars.bars[stackGuid].maxCount == 3)

	-- A cooldown its class module times itself stays out of the tracker and runs on the module's timing.
	do
		local handSpell = TRB.Classes.SpellBase:New({
			id = 990008,
			hasCooldown = true,
			handTimedCooldown = true
		})
		handSpell.name = "Driver Hand Timed"
		snapshots[handSpell.id] = TRB.Classes.Snapshot:New(handSpell)
		local handSource = FindSource("cooldownTime", handSpell.id)
		check("a hand-timed cooldown is offered as a Cooldown", handSource ~= nil)
		if handSource ~= nil then
			local handGuid = CustomBars:Add(spec, classId, specId, handSource)
			local handKey = CustomBars:GetBarKey(handGuid)
			try("lay out the hand-timed bar", Relayout)
			local trackedSpells = {}
			CustomBars:AppendCooldownSpells(trackedSpells)
			check("it stays out of the cooldown tracker", #trackedSpells == 0)
			try("render it idle", function() CustomBars:Render() end)
			check("and is hidden until the module times it", not Shows(EntryFor(barGroups[handKey])))
			snapshots[handSpell.id].cooldown:InitializeCustom(30, desktop.GetTime())
			try("render it running", function() CustomBars:Render() end)
			local hand = RuntimeEntry(handKey)
			check("then runs on the module's timing", hand ~= nil and hand.active and hand.duration == 30 and Shows(EntryFor(barGroups[handKey])))
			CustomBars:Delete(spec, classId, specId, handGuid)
			check("and deleting its bar leaves the module's cooldown running", snapshots[handSpell.id].cooldown.isCustom == true
				and snapshots[handSpell.id].cooldown.startTime ~= nil)
			try("lay out without it", Relayout)
		end
		snapshots[handSpell.id] = nil
	end

	-- An import replaces the bar text list, except for what belongs to the bars the user added.
	do
		local plain = { position = { relativeToFrame = "UIParent" } }
		local orphan = { position = { relativeToFrame = CustomBars:GetAnchorName(CustomBars:GetBarKey("driver-missing")) } }
		local replacement = { position = { relativeToFrame = anchorName } }
		local result = CustomBars:ReconcileImportedText(spec, { plain, orphan, replacement }, spec.displayText.barText)
		local has = {}
		for _, textEntry in ipairs(result) do
			has[textEntry] = true
		end
		local ownTimerText, ownStackText = BoundText(anchorName)[1].entry, BoundText(stackAnchor)[1].entry
		check("imported text bound to a bar that isn't here is dropped", has[plain] and has[replacement] and not has[orphan])
		check("the character's own text on a custom bar is kept, unless the import carries that bar's text", has[ownStackText]
			and not has[ownTimerText] and #result == 3)
	end

	-- Another provider's bars draw and read through it, and a bar whose provider is missing is left alone.
	do
		local drawn, looked = 0, 0
		---@type TRB.Classes.CustomBarProvider
		local driverProvider = {
			GetSources = function()
				return { { kind = "buffTime", spellId = 990020, spellName = "Driver Provided", label = "Driver Provided" } }
			end,
			GetSourceName = function() return "Driver Named" end,
			ReadMax = function() return nil end,
			WriteLookup = function()
				looked = looked + 1
				return "7", "", ""
			end,
			Render = function(runtimeEntry)
				drawn = drawn + 1
				runtimeEntry.active = true
				return false
			end,
		}
		CustomBars:RegisterProvider("driver", driverProvider)
		local provided = nil
		for _, source in ipairs(CustomBars:GetSources(classId, specId)) do
			if source.provider == "driver" then
				provided = source
			end
		end
		check("a provider's sources are listed under its name, and the spec's own under none", provided ~= nil and provided.spellId == 990020
			and timerSource.provider == nil)
		if provided ~= nil then
			local providedGuid = CustomBars:Add(spec, classId, specId, provided)
			local providedKey = CustomBars:GetBarKey(providedGuid)
			local providedBar = spec.customBars.bars[providedGuid]
			try("lay out the provided bar", Relayout)
			try("render the provided bar", function() CustomBars:Render() end)
			local lookup = {}
			CustomBars:WriteLookup(lookup)
			check("its bar is saved with the provider, and draws, reads, and is named through it", providedBar.source.provider == "driver" and drawn > 0
				and looked > 0 and lookup["$" .. providedKey .. "Time"] == "7" and Shows(EntryFor(barGroups[providedKey]))
				and CustomBars:GetSourceLabel(classId, specId, providedBar.source):find("Driver Named", 1, true) ~= nil)
			CustomBars:RegisterProvider("driver", nil)
			try("lay out without the provider", Relayout)
			try("render without the provider", function() CustomBars:Render() end)
			check("with its provider missing, the bar isn't built and stays in the save", definitions:Get(providedKey) == nil
				and barGroups[providedKey] == nil and spec.customBars.bars[providedGuid] == providedBar and RuntimeEntry(providedKey) == nil)
			CustomBars:RegisterProvider("driver", driverProvider)
			CustomBars:Delete(spec, classId, specId, providedGuid)
			CustomBars:RegisterProvider("driver", nil)
			try("lay out after deleting it", Relayout)
		end
	end

	-- A stored profile's bars, as another class's are, have no definition to export by.
	do
		local stored = TRB.Functions.Table:DeepCopy(spec)
		local storedKey = CustomBars:GetBarKey("driver-stored")
		stored.customBars.bars["driver-stored"] = { name = "Stored", source = { kind = "buffTime", spellId = timerSpell.id } }
		stored.bars[storedKey] = { width = 10 }
		stored.colors.bars[storedKey] = { bar = { color = "FFFFFFFF" } }
		stored.displayBar[storedKey] = { alwaysShow = true }
		stored.textures[storedKey .. "Bar"] = "Driver"
		local exported = TRB.Functions.IO:BuildSpecProfileExportConfiguration("Driver", classId, specId, stored)
		local _, classExport = next(exported ~= nil and exported.profiles.list.Driver or {})
		local _, specExport = next(classExport or {})
		check("a bar with no definition exports with its bar data", definitions:Get(storedKey) == nil and specExport ~= nil
			and specExport.customBars.bars["driver-stored"] ~= nil and specExport.bars[storedKey] ~= nil and specExport.colors.bars[storedKey] ~= nil
			and specExport.displayBar[storedKey] ~= nil and specExport.textures[storedKey .. "Bar"] == "Driver")
	end

	-- The options tab.
	local tablesBefore = #drv.tables
	local built = try("build the Bars tab", function()
		TRB.Functions.OptionsUi.CustomBars:ConstructPanel(desktop.CreateFrame("Frame"), classId, specId)
	end)
	local barsTable = drv.tables[tablesBefore + 1]
	check("the Bars tab lists both bars", built and barsTable ~= nil and #barsTable.rows == 2)
	if built and barsTable ~= nil then
		local addButton = drv.buttons[TRB.Localization["CustomBarsAdd"]]
		local menusBefore = #drv.menus
		try("click Add Bar", function() addButton.__scripts.OnClick(addButton) end)
		local menu = drv.menus[menusBefore + 1]
		check("Add Bar offers what the specialization tracks", menu ~= nil and #menu.buttons == #CustomBars:GetSources(classId, specId))
		if menu ~= nil and #menu.buttons > 0 then
			try("pick the first source", function() menu.buttons[1].callback() end)
		end
		check("picking one adds a bar and lists it", #barsTable.rows == 3)

		local function RowOf(guid)
			for index, row in ipairs(barsTable.rows) do
				if row.cols[1].value == guid then
					return index
				end
			end
			return nil
		end
		-- A click on a bar in Preview Mode opens that bar's row.
		barsTable.sel = nil
		try("open the stack bar from its key", function() TRB.Functions.OptionsUi.CustomBars:OpenBar(classId, specId, stackKey) end)
		check("opening a bar by its key selects its row", barsTable.sel ~= nil and barsTable.sel == RowOf(stackGuid))
		local timerRow = RowOf(timerGuid)
		check("the table names what each bar tracks", timerRow ~= nil and barsTable.rows[timerRow].cols[3].value == timerSource.label)
		if timerRow ~= nil then
			try("open the timer bar", function() barsTable.events.OnClick(nil, nil, barsTable.rows, nil, timerRow, timerRow, 2, barsTable, "LeftButton") end)
			try("delete the timer bar", function() barsTable.events.OnClick(nil, nil, barsTable.rows, nil, timerRow, timerRow, 4, barsTable, "LeftButton") end)
		end
		check("deleting a bar removes its row, definition, and settings", #barsTable.rows == 2 and definitions:Get(timerKey) == nil
			and spec.customBars.bars[timerGuid] == nil and spec.bars[timerKey] == nil and spec.colors.bars[timerKey] == nil
			and spec.displayBar[timerKey] == nil and spec.textures[timerKey .. "Bar"] == nil and #BoundText(anchorName) == 0)
		check("and its bar", barGroups[timerKey] == nil)
	end

	-- A live Druid's form draws another specialization's bars: its custom bars, and the text bound to them.
	if isLiveDruid then
		local FERAL = 2
		local feral = TRB.Data.settings.druid.feral
		local function RecomposeFeral()
			TRB.Functions.Character:FillSpecializationCacheSettings("druid", "feral")
		end
		local function RuntimeByKey()
			local byKey = {}
			for _, runtimeEntry in ipairs(CustomBars:GetRuntime()) do
				byKey[runtimeEntry.key] = runtimeEntry
			end
			return byKey
		end
		local sharedGuid = CustomBars:Add(feral, classId, FERAL, timerSource)
		-- Nothing the character tracks has this spell.
		local lackingGuid = CustomBars:Add(feral, classId, FERAL, { kind = "buffTime", spellId = 990098, spellName = "Driver Feral Only" })
		local sharedKey, lackingKey = CustomBars:GetBarKey(sharedGuid), CustomBars:GetBarKey(lackingGuid)
		local sharedAnchor = CustomBars:GetAnchorName(sharedKey)
		local BORDER = "FF0A0B0C"
		feral.colors.bars[sharedKey].border = BORDER
		feral.bars[sharedKey].width = 123
		try("recompose Feral", RecomposeFeral)
		try("render in Moonkin Form", function() CustomBars:Render() end)
		check("another specialization's bars aren't drawn in the character's own form", barGroups[sharedKey] == nil and barGroups[stackKey] ~= nil
			and FrameIndexOf(sharedAnchor) == nil)

		local borders = {}
		local setBorderColor = BarNode.SetBorderColor
		BarNode.SetBorderColor = function(self, color, ...)
			borders[self] = color
			return setBorderColor(self, color, ...)
		end
		try("shift to Cat Form", function() SetForm(1) end)
		try("render in Cat Form", function() CustomBars:Render() end)
		barGroups = TRB.Frames.barGroups
		local byKey = RuntimeByKey()
		check("a form that draws another specialization's bars draws its custom bars, not the character's own", CustomBars:IsDisplayedSpec(classId, FERAL)
			and byKey[sharedKey] ~= nil and byKey[lackingKey] ~= nil and byKey[stackKey] == nil
			and barGroups[sharedKey] ~= nil and barGroups[lackingKey] ~= nil and barGroups[stackKey] == nil)
		if byKey[sharedKey] ~= nil and byKey[lackingKey] ~= nil and barGroups[sharedKey] ~= nil and barGroups[lackingKey] ~= nil then
			local ownSettings = TRB.Data.specCache[character.compositeKey].settings
			check("with that specialization's layout and colors", barGroups.layoutSettings.bars[sharedKey].width == 123
				and borders[barGroups[sharedKey].nodes[1]] == BORDER)
			-- Edit Mode, Preview Mode, and the character's own options lay out and color with the character's settings.
			try("lay out and color with the character's settings", function()
				TRB.Functions.Bar:ApplyBarGroupsLayout(ownSettings, barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(ownSettings, barGroups)
			end)
			check("a pass given the character's settings leaves them", barGroups.layoutSettings.bars[sharedKey] ~= nil
				and barGroups.layoutSettings.bars[sharedKey].width == 123 and borders[barGroups[sharedKey].nodes[1]] == BORDER)

			-- Preview Mode places the character's own bars.
			try("turn Preview Mode on", function() TRB.Functions.Preview:SetActive(true) end)
			try("render in Preview Mode", function() CustomBars:Render() end)
			local inPreview = RuntimeByKey()
			check("Preview Mode shows the character's own custom bars in any form", inPreview[stackKey] ~= nil and inPreview[sharedKey] == nil
				and barGroups[stackKey] ~= nil and barGroups[sharedKey] == nil and FrameIndexOf(sharedAnchor) == nil)
			try("turn Preview Mode off", function() TRB.Functions.Preview:SetActive(false) end)
			try("render after Preview Mode", function() CustomBars:Render() end)
			byKey = RuntimeByKey()
			check("and the form's return when it ends, where their specialization puts them", byKey[sharedKey] ~= nil and byKey[stackKey] == nil
				and barGroups[sharedKey] ~= nil and barGroups[stackKey] == nil and barGroups.layoutSettings.bars[sharedKey] ~= nil
				and barGroups.layoutSettings.bars[sharedKey].width == 123 and borders[barGroups[sharedKey].nodes[1]] == BORDER
				and FrameIndexOf(sharedAnchor) ~= nil)
		end
		BarNode.SetBorderColor = setBorderColor
		if byKey[sharedKey] ~= nil and byKey[lackingKey] ~= nil and barGroups[sharedKey] ~= nil and barGroups[lackingKey] ~= nil then
			timerBuff:InitializeCustom(10)
			try("render a running timer in Cat Form", function() CustomBars:Render() end)
			check("one tracking something the character has runs", byKey[sharedKey].active and Shows(EntryFor(barGroups[sharedKey])))
			check("one tracking something the character lacks never does anything", not byKey[lackingKey].active
				and not Shows(EntryFor(barGroups[lackingKey])))
			feral.displayBar[sharedKey].neverShow = true
			try("recompose Feral with Never Show", RecomposeFeral)
			check("its visibility is that specialization's", not Shows(EntryFor(barGroups[sharedKey])))
			feral.displayBar[sharedKey].neverShow = false
			try("recompose Feral without it", RecomposeFeral)

			check("the text bound to it is drawn without joining the character's own list", FrameIndexOf(sharedAnchor) ~= nil
				and #BoundText(sharedAnchor) == 0)
			try("draw its text", function() DrawText(barGroups[sharedKey]) end)
			local sharedTime = TRB.Data.lookup["$" .. sharedKey .. "Time"]
			local shown = RenderedText(sharedAnchor)
			check("and shows the bar's time", sharedTime ~= nil and sharedTime ~= "" and type(shown) == "string" and shown:find(sharedTime, 1, true) ~= nil)
			try("recompose the character's settings", function()
				TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
			end)
			check("recomposing the character's settings keeps that text drawn", FrameIndexOf(sharedAnchor) ~= nil)
			local ownEntries = #spec.displayText.barText
			table.insert(spec.displayText.barText, TRB.Functions.Settings:LoadDefaultOtherBarTextSettings("UIParent", "Driver Own", "$haste", "CENTER", 12))
			try("rebuild the text frames after adding the character's own text", function() BarText:CreateBarTextFrames() end)
			check("the character's own new text is drawn ahead of it", FrameIndexOf("UIParent") ~= nil and FrameIndexOf(sharedAnchor) ~= nil
				and FrameIndexOf("UIParent") < FrameIndexOf(sharedAnchor))
			table.remove(spec.displayText.barText, ownEntries + 1)

			-- Preview Mode passes the character's own specialization with the bar it was clicked on.
			local opened = nil
			local optionsFrame = TRB.Options.OptionsFrame
			local selectCategory = optionsFrame.SelectCategory
			optionsFrame.SelectCategory = function(_, navKey) opened = navKey end
			try("open its options from Preview Mode", function() TRB.Functions.OptionsUi.Tabs:OpenBarTab(classId, specId, sharedKey) end)
			optionsFrame.SelectCategory = selectCategory
			check("a click on it in Preview Mode opens its own specialization's options", opened == "druid_feral")

			CustomBars:Delete(feral, classId, FERAL, lackingGuid)
			try("recompose Feral after deleting a bar", RecomposeFeral)
			try("render after deleting it", function() CustomBars:Render() end)
			check("deleting one of them while it shows drops its bar", barGroups[lackingKey] == nil and barGroups[sharedKey] ~= nil)
		end

		try("shift back to Moonkin Form", function() SetForm(31) end)
		try("render back in Moonkin Form", function() CustomBars:Render() end)
		barGroups = TRB.Frames.barGroups
		byKey = RuntimeByKey()
		check("back in its own form, the character's bars return and the other specialization's leave", byKey[stackKey] ~= nil and byKey[sharedKey] == nil
			and barGroups[stackKey] ~= nil and barGroups[sharedKey] == nil and FrameIndexOf(sharedAnchor) == nil)
		for guid in pairs(feral.customBars.bars) do
			CustomBars:Delete(feral, classId, FERAL, guid)
		end
		try("recompose Feral with no custom bars", RecomposeFeral)
		timerBuff.endTime = desktop.GetTime() - 1
	end

	-- Clean up, so nothing custom is left for a later check.
	for guid in pairs(spec.customBars.bars) do
		CustomBars:Delete(spec, classId, specId, guid)
	end
	try("lay out with no custom bars", Relayout)
	local leftover = false
	for key in pairs(barGroups) do
		leftover = leftover or registry:IsUserBar(key)
	end
	check("deleting every bar leaves no group or definition", not leftover and #registry:GetUserBarKeys(classId, specId) == 0)

	print(string.format("DRIVER custom-bars: %d failures", errors))
end

return hooks
