-- Checks custom Color Indicators and Buff Alerts that follow a player buff by spell ID: on Classic, UNIT_AURA keeps them
-- current and the options add, re-point, and remove them; a client whose auras can be secret never reads one.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

-- Two ranks of one buff, two more buffs, and an ID no spell has.
local SND_RANK1, SND_RANK2, ADRENALINE_RUSH, SPRINT, NO_SPELL = 5171, 6774, 13750, 2983, 424242
local spellNames = { [SND_RANK1] = "Slice and Dice", [SND_RANK2] = "Slice and Dice", [ADRENALINE_RUSH] = "Adrenaline Rush", [SPRINT] = "Sprint" }
local followedNames = { ["Slice and Dice"] = true, ["Adrenaline Rush"] = true, ["Sprint"] = true }

local hooks = {}
-- The player's fake auras, the reads of followed ones, and what the options asked for.
local drv = { frames = {}, auras = {}, followedReads = 0, popups = {}, menus = {}, plays = 0, groups = {}, panels = {}, cuePanels = {}, editButtons = {}, deleteButtons = {}, badges = {} }

---A menu description that records what it was asked to draw.
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
	local innerCreate = G.CreateFrame
	G.CreateFrame = function(...)
		local frame = innerCreate(...)
		drv.frames[#drv.frames + 1] = frame
		return frame
	end
	local getName = G.C_Spell.GetSpellName
	G.C_Spell.GetSpellName = function(id)
		if id == NO_SPELL then
			return nil
		end
		return spellNames[id] or getName(id)
	end
	G.C_UnitAuras.GetAuraDataBySpellName = function(unit, name, filter)
		if followedNames[name] then
			drv.followedReads = drv.followedReads + 1
		end
		for _, aura in ipairs(drv.auras) do
			if unit == "player" and aura.name == name and aura.isHelpful == (filter == "HELPFUL") then
				return aura
			end
		end
		return nil
	end
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
	G.PlaySoundFile = function()
		drv.plays = drv.plays + 1
		return true
	end
end

function hooks.afterLoad(ctx)
	local TRB = ctx.TRB
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local origBuild = Tabs.BuildTabGroup
	Tabs.BuildTabGroup = function(self, parent, namePrefix, defs, y, tabContext)
		local r = origBuild(self, parent, namePrefix, defs, y, tabContext)
		drv.groups[#drv.groups + 1] = parent
		return r
	end

	-- Buttons each panel builds, by the panel they belong to.
	local Primitives = TRB.Functions.OptionsUi.Primitives
	local building = nil
	local origButton = Primitives.BuildButton
	Primitives.BuildButton = function(self, parent, text, ...)
		local button = origButton(self, parent, text, ...)
		if building ~= nil then
			building.buttons[#building.buttons + 1] = { text = text, button = button }
		end
		return button
	end
	local origEdit = Primitives.BuildEditIconButton
	Primitives.BuildEditIconButton = function(self, parent, ...)
		local button = origEdit(self, parent, ...)
		drv.editButtons[parent] = drv.editButtons[parent] or {}
		table.insert(drv.editButtons[parent], button)
		return button
	end
	local origDelete = Primitives.BuildDeleteIconButton
	Primitives.BuildDeleteIconButton = function(self, parent, ...)
		local button = origDelete(self, parent, ...)
		drv.deleteButtons[parent] = drv.deleteButtons[parent] or {}
		table.insert(drv.deleteButtons[parent], button)
		return button
	end
	local origBadge = Primitives.AttachCustomBadgeToText
	Primitives.AttachCustomBadgeToText = function(self, fontString, shown, notTracked, tooltip)
		if shown then
			drv.badges[#drv.badges + 1] = { text = fontString:GetText(), notTracked = notTracked, tooltip = tooltip }
		end
		return origBadge(self, fontString, shown, notTracked, tooltip)
	end

	local Indicators = TRB.Functions.OptionsUi.Indicators
	local origIndicators = Indicators.GenerateIndicatorColorsPanel
	Indicators.GenerateIndicatorColorsPanel = function(self, parent, controls, spec, classId, specId, ...)
		building = { parent = parent, spec = spec, classId = classId, specId = specId, buttons = {} }
		drv.panels[#drv.panels + 1] = building
		local r = { origIndicators(self, parent, controls, spec, classId, specId, ...) }
		building = nil
		return unpack(r)
	end
	local Cues = TRB.Functions.OptionsUi.AudioCues
	local origCues = Cues.GenerateAudioCuesPanel
	Cues.GenerateAudioCuesPanel = function(self, parent, controls, spec, classId, specId, ...)
		building = { parent = parent, spec = spec, classId = classId, specId = specId, buttons = {} }
		drv.cuePanels[#drv.cuePanels + 1] = building
		local r = { origCues(self, parent, controls, spec, classId, specId, ...) }
		building = nil
		return unpack(r)
	end

	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local L = TRB.Localization
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
	-- Runs queued timers until none fail, past the stub errors deferred UI code hits.
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
	check("the deferred setup finishes", TRB.Details.addonData.optionsPanelFinished == true)

	-- UNIT_AURA goes through Aura.lua's own handler, so the flavor gate on it is exercised too.
	local auraHandlers = {}
	for _, frame in ipairs(drv.frames) do
		local scripts = rawget(frame, "__scripts")
		local events = rawget(frame, "__events")
		local fn = scripts ~= nil and scripts.OnEvent or nil
		local source = fn ~= nil and debug.getinfo(fn, "S").source or ""
		if events ~= nil and events.UNIT_AURA and source:find("Functions[/\\]Aura%.lua$") then
			auraHandlers[#auraHandlers + 1] = { frame = frame, fn = fn }
		end
	end
	check("Aura.lua's UNIT_AURA handler is registered", #auraHandlers == 1)
	local function FireAura(info)
		for _, handler in ipairs(auraHandlers) do
			try("UNIT_AURA", function() handler.fn(handler.frame, "UNIT_AURA", "player", info) end)
		end
		Drain("AURA")
	end
	local nextInstance = 100
	local function Gain(spellId, isHelpful)
		nextInstance = nextInstance + 1
		local aura = { name = spellNames[spellId], spellId = spellId, auraInstanceID = nextInstance, isHelpful = isHelpful ~= false }
		drv.auras[#drv.auras + 1] = aura
		FireAura({ isFullUpdate = false, addedAuras = { aura } })
		return aura
	end
	local function Lose(aura)
		for i, a in ipairs(drv.auras) do
			if a == aura then
				table.remove(drv.auras, i)
				break
			end
		end
		FireAura({ isFullUpdate = false, removedAuraInstanceIDs = { aura.auraInstanceID } })
	end

	local Character = TRB.Functions.Character
	local spec = Character:GetActiveRawSpecSettings()
	check("the played spec's settings are found", spec ~= nil)
	if spec == nil then
		return errors + 1
	end
	local shared = spec.colors.shared
	local function Condition(spellId)
		return { source = Aura.CONDITION_SOURCE, state = Aura.ConditionState.ACTIVE, spellID = spellId }
	end
	shared.indicatorColors.custom_driver = { color = "FFFFFFFF", color2 = "FFFFFFFF", gradientDirection = "disabled", enabled = true, targets = {},
		custom = { conditions = { Condition(SND_RANK1) } } }
	table.insert(shared.nodeOrder, "custom_driver")
	shared.indicatorColors.custom_nospell = { color = "FFFFFFFF", color2 = "FFFFFFFF", gradientDirection = "disabled", enabled = true, targets = {},
		custom = { conditions = { Condition(NO_SPELL) } } }
	table.insert(shared.nodeOrder, "custom_nospell")
	spec.audio = spec.audio or {}
	spec.audio.driverCue = { id = "driverCue", kind = "buff", name = "Driver", enabled = true, sound = "Interface\\Test.ogg", soundName = "Test",
		configuration = { playOutOfCombat = true, conditions = { Condition(ADRENALINE_RUSH) } } }
	drv.followedReads = 0
	TRB.Functions.AudioCues:InvalidateCache(spec)

	local function Met(key)
		local map = {}
		TRB.Functions.Color:ApplyCustomIndicatorConditions(shared, map)
		return map[key] == true
	end
	local function Plays()
		local before = drv.plays
		TRB.Functions.AudioCues:UpdateBuffCues(TRB.Data.snapshotData)
		return drv.plays - before
	end

	if not TRB.Flavor.playerAuras then
		check("this client never follows a buff by spell ID", TRB.Flavor.id ~= "classic")
		Plays()
		Gain(SND_RANK1)
		Gain(ADRENALINE_RUSH)
		FireAura({ isFullUpdate = true })
		check("a buff indicator stays off with its buff up", not Met("custom_driver"))
		check("a buff alert stays silent when its buff is gained", Plays() == 0)
		check("no followed aura is ever read", drv.followedReads == 0)
	else
		check("each followed buff is read once when the list is rebuilt", drv.followedReads == 2)
		check("a buff indicator is off before its buff is up", not Met("custom_driver"))
		local rank2 = Gain(SND_RANK2)
		check("another rank of the buff turns it on", Met("custom_driver"))
		local copy = Gain(SND_RANK1)
		Lose(rank2)
		check("losing one copy keeps it on while another is up", Met("custom_driver"))
		Lose(copy)
		check("losing the last copy turns it off", not Met("custom_driver"))
		local harmful = Gain(SND_RANK1, false)
		check("a harmful aura with the same name doesn't count", not Met("custom_driver"))
		Lose(harmful)
		drv.auras[#drv.auras + 1] = { name = "Slice and Dice", spellId = SND_RANK1, auraInstanceID = 900, isHelpful = true }
		FireAura({ isFullUpdate = true })
		check("a full update finds a buff already up", Met("custom_driver"))
		wipe(drv.auras)
		FireAura({ isFullUpdate = true })
		check("a full update finds it gone", not Met("custom_driver"))
		check("an ID no spell has never turns on", not Met("custom_nospell"))

		-- Turning the class off and on drops UNIT_AURA in between, so a buff can come or go unseen.
		Gain(SND_RANK1)
		Aura:DisableUnitAura()
		wipe(drv.auras)
		Aura:EnableUnitAura()
		check("a buff lost while UNIT_AURA was off reads off once it's back", not Met("custom_driver"))
		Aura:DisableUnitAura()
		drv.auras[#drv.auras + 1] = { name = "Slice and Dice", spellId = SND_RANK1, auraInstanceID = 901, isHelpful = true }
		Aura:EnableUnitAura()
		check("and one gained reads on", Met("custom_driver"))
		wipe(drv.auras)
		FireAura({ isFullUpdate = true })

		drv.followedReads = 0
		Gain(SPRINT)
		FireAura({ isFullUpdate = false, removedAuraInstanceIDs = { 12345 } })
		check("unfollowed gains and losses read no auras", drv.followedReads == 0)
		wipe(drv.auras)
		FireAura({ isFullUpdate = true })

		check("a buff alert's first look only records its state", Plays() == 0)
		local rush = Gain(ADRENALINE_RUSH)
		check("a buff alert plays when its buff is gained", Plays() == 1)
		check("and stays silent while it lasts", Plays() == 0)
		Lose(rush)
		Plays()
		Gain(ADRENALINE_RUSH)
		check("and plays again on the next gain", Plays() == 1)
		wipe(drv.auras)
		FireAura({ isFullUpdate = true })
	end

	-- Every options tab, so the played class's Color Indicators and Audio Cues panels are built.
	TRB.Details.addonData.optionsPanelFinished = true
	try("ConstructOptionsPanel", function() TRB.Options:ConstructOptionsPanel() end)
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local i = 1
	while i <= #drv.groups do
		local parent = drv.groups[i]
		if parent.tabConstructors then
			local keys = {}
			for key in pairs(parent.tabConstructors) do keys[#keys + 1] = key end
			table.sort(keys)
			for _, key in ipairs(keys) do
				pcall(Tabs.EnsureTabConstructed, Tabs, parent, key)
			end
		end
		i = i + 1
	end

	local character = TRB.Data.character
	-- The latest build, should a panel be built more than once.
	local function FindPanel(list)
		local found = nil
		for _, panel in ipairs(list) do
			if panel.classId == character.classId and panel.specId == character.specId then
				found = panel
			end
		end
		return found
	end
	local function FindButton(panel, text)
		for _, entry in ipairs(panel.buttons) do
			if entry.text == text then
				return entry.button
			end
		end
		return nil
	end
	local function AllMenuLabels()
		local found = {}
		local function walk(desc)
			for _, child in ipairs(desc.children) do
				if child.label ~= nil then found[child.label] = true end
				walk(child)
			end
		end
		for _, root in ipairs(drv.menus) do walk(root) end
		return found
	end
	local function LastPopup(which)
		local popup = drv.popups[#drv.popups]
		return popup ~= nil and popup.which == which and popup.data or nil
	end

	local panel = FindPanel(drv.panels)
	check("the played class's Color Indicators panel is built", panel ~= nil)
	local cuePanel = FindPanel(drv.cuePanels)
	check("the played class's Audio Cues panel is built", cuePanel ~= nil)
	if panel == nil or cuePanel == nil then
		return errors
	end
	local addButton = FindButton(panel, L["CustomIndicatorAddButton"])
	local cueAddButton = FindButton(cuePanel, L["AudioCueAdd"])
	check("both panels have an Add button", addButton ~= nil and cueAddButton ~= nil)
	if addButton == nil or cueAddButton == nil then
		return errors
	end

	if not TRB.Flavor.playerAuras then
		try("Add indicator", function() addButton.__scripts.OnClick(addButton) end)
		try("Add cue", function() cueAddButton.__scripts.OnClick(cueAddButton) end)
		check("no Add menu offers a buff by spell ID", not AllMenuLabels()[L["CustomIndicatorSourceAuraSpellId"]])
		check("no prompt for a spell ID opens", LastPopup("TwintopResourceBar_AuraSpellId") == nil)
		return errors
	end

	-- The prompt: OK only for an ID some spell has, and the spell named as it's typed.
	local dialogDef = desktop.StaticPopupDialogs["TwintopResourceBar_AuraSpellId"]
	local dialog = { text = "", enabled = nil, hidden = false }
	local editBox = { text = "" }
	function editBox:SetText(t) self.text = t end
	function editBox:GetText() return self.text end
	function editBox:HighlightText() end
	function editBox:SetFocus() end
	function editBox:GetParent() return dialog end
	local button1 = {}
	function button1:SetEnabled(enabled) dialog.enabled = enabled end
	function dialog:GetEditBox() return editBox end
	function dialog:GetButton1() return button1 end
	function dialog:SetFormattedText(fmt, ...) self.text = string.format(fmt, ...) end
	function dialog:Resize() end
	function dialog:Hide() self.hidden = true end
	local accepted = {}
	local data = { spellId = SND_RANK1, onAccept = function(spellId) accepted[#accepted + 1] = spellId end }
	try("prompt", function()
		dialogDef.OnShow(dialog, data)
		check("the prompt opens on the current ID, named", editBox.text == tostring(SND_RANK1) and dialog.enabled == true and dialog.text:find("Slice and Dice (5171)", 1, true) ~= nil)
		editBox.text = "abc"
		dialogDef.EditBoxOnTextChanged(editBox, data)
		check("text that isn't an ID can't be accepted", dialog.enabled == false and dialog.text:find(L["AuraSpellIdPromptUnknown"], 1, true) ~= nil)
		editBox.text = tostring(NO_SPELL)
		dialogDef.EditBoxOnTextChanged(editBox, data)
		check("an ID no spell has can't be accepted", dialog.enabled == false)
		dialogDef.OnAccept(dialog, data)
		dialogDef.EditBoxOnEnterPressed(editBox, data)
		check("and neither OK nor Enter accepts it", #accepted == 0 and not dialog.hidden)
		editBox.text = " 6774 "
		dialogDef.EditBoxOnTextChanged(editBox, data)
		check("an ID with spaces around it is accepted", dialog.enabled == true)
		dialogDef.EditBoxOnEnterPressed(editBox, data)
		check("Enter accepts it and closes the prompt", accepted[1] == SND_RANK2 and dialog.hidden)
	end)

	-- Add, re-point, and remove a buff indicator through the panel.
	local indicatorColors = panel.spec.colors.shared.indicatorColors
	local before = {}
	for key in pairs(indicatorColors) do before[key] = true end
	try("Add indicator", function() addButton.__scripts.OnClick(addButton) end)
	local menu = drv.menus[#drv.menus]
	local auraEntry = menu ~= nil and FindEntry(menu, L["CustomIndicatorSourceAuraSpellId"]) or nil
	check("the Add menu offers a buff by spell ID", auraEntry ~= nil)
	local offersCdm = false
	for _, child in ipairs(menu ~= nil and menu.children or {}) do
		if type(child.label) == "string" and child.label:find(L["CdmBadgeLabel"], 1, true) then offersCdm = true end
	end
	check("and no Cooldown Manager buffs", menu ~= nil and not offersCdm)
	if auraEntry ~= nil then
		try("pick", function() auraEntry.fn() end)
	end
	local prompt = LastPopup("TwintopResourceBar_AuraSpellId")
	check("picking it asks for a spell ID", prompt ~= nil and prompt.spellId == nil)
	if prompt == nil then
		return errors
	end
	local badgesBefore = #drv.badges
	try("accept", function() prompt.onAccept(ADRENALINE_RUSH) end)
	local newKey = nil
	for key in pairs(indicatorColors) do
		if not before[key] then newKey = key end
	end
	local condition = newKey ~= nil and indicatorColors[newKey].custom.conditions[1] or nil
	check("a new indicator follows the buff", condition ~= nil and condition.source == Aura.CONDITION_SOURCE and condition.spellID == ADRENALINE_RUSH and condition.name == "Adrenaline Rush")
	local inOrder = false
	for _, key in ipairs(panel.spec.colors.shared.nodeOrder) do
		if key == newKey then inOrder = true end
	end
	check("at the end of the priority list", inOrder)
	local newBadge, missingBadge = nil, nil
	for b = badgesBefore + 1, #drv.badges do
		local badge = drv.badges[b]
		if badge.text == string.format(L["CustomIndicatorActiveFormat"], "Adrenaline Rush") then newBadge = badge end
		if badge.tooltip:find(tostring(NO_SPELL), 1, true) then missingBadge = badge end
	end
	check("its row reads as tracked, with its spell ID", newBadge ~= nil and not newBadge.notTracked and newBadge.tooltip:find(tostring(ADRENALINE_RUSH), 1, true) ~= nil)
	check("a row whose ID no spell has reads as not tracked", missingBadge ~= nil and missingBadge.notTracked)
	Gain(ADRENALINE_RUSH)
	check("and turns on with the buff", Met(newKey))
	wipe(drv.auras)
	FireAura({ isFullUpdate = true })

	local rowIndex = #(drv.editButtons[panel.parent] or {})
	local editButton = drv.editButtons[panel.parent] ~= nil and drv.editButtons[panel.parent][rowIndex] or nil
	if editButton ~= nil then
		try("Edit", function() editButton.__scripts.OnClick(editButton) end)
	end
	prompt = LastPopup("TwintopResourceBar_AuraSpellId")
	check("Edit asks again, filled with the current ID", prompt ~= nil and prompt.spellId == ADRENALINE_RUSH)
	if prompt ~= nil then
		try("re-point", function() prompt.onAccept(SPRINT) end)
	end
	check("and re-points it", condition ~= nil and condition.spellID == SPRINT and condition.name == "Sprint")
	Gain(SPRINT)
	check("which now follows the new buff", Met(newKey))

	local deleteButton = drv.deleteButtons[panel.parent] ~= nil and drv.deleteButtons[panel.parent][rowIndex] or nil
	if deleteButton ~= nil then
		try("Remove", function() deleteButton.__scripts.OnClick(deleteButton) end)
	end
	local confirm = LastPopup("TwintopResourceBar_ConfirmDeleteCustomIndicator")
	if confirm ~= nil then
		try("confirm", function() confirm.remove() end)
	end
	check("Remove deletes it", newKey ~= nil and indicatorColors[newKey] == nil)
	check("and its buff is no longer followed", not Aura:IsConditionMet(Condition(SPRINT)))
	wipe(drv.auras)
	FireAura({ isFullUpdate = true })

	-- A Buff Alert: added with no buff, then pointed at one by spell ID.
	local spellButton = nil
	for _, entry in ipairs(cuePanel.buttons) do
		if entry.text == "" then spellButton = entry.button end
	end
	local menusBefore = #drv.menus
	try("Add cue", function() cueAddButton.__scripts.OnClick(cueAddButton) end)
	if #drv.menus > menusBefore then
		local entry = FindEntry(drv.menus[#drv.menus], L["AudioCueAddBuffAlert"])
		check("the Add menu offers a Buff Alert", entry ~= nil and not entry.disabled)
		if entry ~= nil then
			try("New Buff Alert", function() entry.fn() end)
		end
	end
	local cue = nil
	for _, c in pairs(cuePanel.spec.audio) do
		if type(c) == "table" and c.kind == "buff" and c.id ~= "driverCue" then cue = c end
	end
	check("a Buff Alert is added with no buff", cue ~= nil and #cue.configuration.conditions == 0)
	check("its editor asks for a spell ID", spellButton ~= nil and spellButton:IsShown() and spellButton:GetText() == L["AudioCueBuffEnterSpellId"])
	if spellButton == nil or cue == nil then
		return errors
	end
	try("spell button", function() spellButton.__scripts.OnClick(spellButton) end)
	prompt = LastPopup("TwintopResourceBar_AuraSpellId")
	check("which opens the prompt", prompt ~= nil and prompt.spellId == nil)
	if prompt ~= nil then
		try("accept cue", function() prompt.onAccept(SND_RANK1) end)
	end
	local cueCondition = cue.configuration.conditions[1]
	check("the alert follows the buff and takes its name", cueCondition ~= nil and cueCondition.source == Aura.CONDITION_SOURCE
		and cueCondition.spellID == SND_RANK1 and cue.name == "Slice and Dice")
	check("its editor names the buff", spellButton:GetText():find("Slice and Dice (5171)", 1, true) ~= nil)
	Plays()
	Gain(SND_RANK2)
	check("and it plays when any rank is gained", Plays() == 1)

	return errors
end

return hooks
