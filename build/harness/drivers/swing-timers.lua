-- Checks the swing timer bars: on Classic the combat log and the player's casts start each swing, with no Hide Blizzard
-- option; on Forever PLAYER_SWING still drives them and the option stays.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local PLAYER_GUID = "Player-1-00000001"
local TARGET_GUID = "Creature-0-1-1-1-1-1"
local OTHER_GUID = "Player-1-00000002"
-- Lightning Bolt (a cast that pauses the swing), Slam, Heroic Strike, Auto Shot, Shoot, and an instant.
local LIGHTNING_BOLT, SLAM, HEROIC_STRIKE, AUTO_SHOT, WAND_SHOOT, INSTANT = 403, 1464, 78, 75, 5019, 2

local hooks = {}
-- The test clock, weapon speeds, the combat log payload, and the frames and checkboxes the addon made.
local drv = { now = 1000, mainSpeed = 2, offSpeed = 2, rangedAttackSpeed = 3.3, rangedSpeed = 2.8, payload = {}, frames = {}, blizzardSwingBoxes = 0, groups = {} }

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	-- Classic Era's mirror timers: three global frames, shown through MirrorTimer_Show. The stubs leave out the container.
	if ctx.tocRel:find("Classic", 1, true) then
		drv.classicMirror = true
		drv.mirrorTimers = {}
		for index = 1, 3 do
			local frame = G.CreateFrame("Frame", "MirrorTimer" .. index)
			frame:Hide()
			G["MirrorTimer" .. index] = frame
		end
		G.GetMirrorTimerInfo = function(index)
			local timer = drv.mirrorTimers[index]
			if timer == nil then
				return "UNKNOWN", 0, 0, 0, 0, ""
			end
			return timer, 30000, 60000, -1, 0, timer
		end
		-- Blizzard's pick: the shown frame of that type, else a free one.
		G.MirrorTimer_Show = function(timer)
			local dialog = nil
			for index = 1, 3 do
				local frame = G["MirrorTimer" .. index]
				if frame:IsShown() and frame.timer == timer then
					dialog = frame
					break
				end
			end
			for index = 1, 3 do
				local frame = G["MirrorTimer" .. index]
				if dialog == nil and not frame:IsShown() then
					dialog = frame
				end
			end
			if dialog ~= nil then
				dialog.timer = timer
				dialog:Show()
			end
			return dialog
		end
	end
	local innerCreate = G.CreateFrame
	G.CreateFrame = function(...)
		local frame = innerCreate(...)
		drv.frames[#drv.frames + 1] = frame
		return frame
	end
	G.GetTime = function() return drv.now end
	G.UnitGUID = function() return PLAYER_GUID end
	G.UnitAttackSpeed = function() return drv.mainSpeed, drv.offSpeed, drv.rangedAttackSpeed end
	G.UnitRangedDamage = function() return drv.rangedSpeed end
	G.CombatLogGetCurrentEventInfo = function() return unpack(drv.payload, 1, 21) end
	-- A weapon in both hands and the ranged slot.
	G.GetInventoryItemID = function(_, slot)
		if slot == G.INVSLOT_MAINHAND or slot == G.INVSLOT_OFFHAND or slot == G.INVSLOT_RANGED then
			return 1234
		end
		return nil
	end
	G.C_Item.GetItemInfoInstant = function() return 1234, "", "", "", 0, G.Enum.ItemClass.Weapon end
	G.INVSLOT_MAINHAND, G.INVSLOT_OFFHAND, G.INVSLOT_RANGED = 16, 17, 18
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
	local L = TRB.Localization
	local Primitives = TRB.Functions.OptionsUi.Primitives
	local origCheckbox = Primitives.BuildCheckboxRow
	Primitives.BuildCheckboxRow = function(self, parent, name, label, tooltip, ...)
		if tooltip == L["SwingTimerDisableBlizzardTooltip"] then
			drv.blizzardSwingBoxes = drv.blizzardSwingBoxes + 1
		end
		return origCheckbox(self, parent, name, label, tooltip, ...)
	end
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local OtherBars = TRB.Functions.OtherBars
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

	local settings = TRB.Functions.Class:GetActiveDisplaySettings()
	if not TRB.Flavor.swingTimers then
		check("a flavor without swing timers has no swing bars", #TRB.Classes.BarTypeRegistry.swingBarKeys == 0 and settings ~= nil and settings.displayBar.mainHandSwing == nil)
		return errors
	end
	check("swing bars exist", #TRB.Classes.BarTypeRegistry.swingBarKeys == 3 and settings ~= nil and settings.displayBar.mainHandSwing ~= nil)
	if settings == nil or settings.displayBar.mainHandSwing == nil then
		return errors
	end

	---Whether any of OtherBars.lua's frames is registered for an event.
	local function Registered(event)
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("OtherBars%.lua$") then
				return true
			end
		end
		return false
	end
	---Fires an event at every OtherBars.lua frame registered for it.
	local function Fire(event, ...)
		local args = { ... }
		for _, frame in ipairs(drv.frames) do
			local scripts = rawget(frame, "__scripts")
			local events = rawget(frame, "__events")
			local fn = scripts ~= nil and scripts.OnEvent or nil
			if fn ~= nil and events ~= nil and events[event] and debug.getinfo(fn, "S").source:find("OtherBars%.lua$") then
				try(event, function() fn(frame, event, unpack(args)) end)
			end
		end
	end
	local function SetEnabled(main, off, ranged)
		settings.displayBar.mainHandSwing.neverShow = not main
		settings.displayBar.offHandSwing.neverShow = not off
		settings.displayBar.rangedSwing.neverShow = not ranged
		try("SyncSwingEvents", function() OtherBars:SyncSwingEvents() end)
	end
	local function Remaining(barKey)
		local remaining, total = OtherBars:GetTimerValues(barKey)
		return remaining, total
	end
	local function Near(a, b)
		return a ~= nil and math.abs(a - b) < 0.0001
	end

	if TRB.Flavor.blizzardSwingTimer then
		check("Forever keeps the Hide Blizzard swing timers option", settings.bars.mainHandSwing.disableBlizzardBar == true)
		SetEnabled(true, true, true)
		check("an enabled swing bar registers PLAYER_SWING", Registered("PLAYER_SWING"))
		check("and not the combat log", not Registered("COMBAT_LOG_EVENT_UNFILTERED"))
		Fire("PLAYER_SWING", 2.5, desktop.Enum.PlayerSwingType.OffHand)
		local remaining, total = Remaining("offHandSwing")
		check("PLAYER_SWING starts the hand it names", Near(total, 2.5) and Near(remaining, 2.5) and not OtherBars:IsBarActive("mainHandSwing"))
		Fire("PLAYER_SWING", 3, desktop.Enum.PlayerSwingType.Ranged)
		Fire("WEAPON_SLOT_CHANGED")
		remaining, total = Remaining("rangedSwing")
		check("a weapon swap restarts ranged at UnitAttackSpeed's ranged speed", Near(total, drv.rangedAttackSpeed))
		SetEnabled(false, false, false)
		check("no swing bar enabled unregisters PLAYER_SWING", not Registered("PLAYER_SWING"))
	else
		if drv.classicMirror then
			---Whether any of Blizzard's frames shows the timer type.
			local function BlizzardShows(timer)
				for index = 1, 3 do
					local frame = desktop["MirrorTimer" .. index]
					if frame:IsShown() and frame.timer == timer then
						return true
					end
				end
				return false
			end
			local breath = settings.bars.breath
			local breathVisibility = settings.displayBar.breath
			local savedHide, savedNever, savedAlways = breath.disableBlizzardBar, breathVisibility.neverShow, breathVisibility.alwaysShow
			breathVisibility.neverShow = false
			breathVisibility.alwaysShow = true
			breath.disableBlizzardBar = true
			Fire("PLAYER_ENTERING_WORLD")
			drv.mirrorTimers[1] = "BREATH"
			try("MirrorTimer_Show", function() desktop.MirrorTimer_Show("BREATH", 30000, 60000, -1, 0, "Breath") end)
			Fire("MIRROR_TIMER_START", "BREATH", 30000, 60000, -1, 0, "Breath")
			check("Classic Era hides Blizzard's Breath bar", not BlizzardShows("BREATH"))
			breath.disableBlizzardBar = false
			try("RefreshVisibility", function() OtherBars:RefreshVisibility() end)
			check("unticking it brings a running Breath bar back", BlizzardShows("BREATH"))
			breath.disableBlizzardBar = true
			try("RefreshVisibility", function() OtherBars:RefreshVisibility() end)
			check("ticking it again hides it", not BlizzardShows("BREATH"))
			drv.mirrorTimers[1] = nil
			Fire("MIRROR_TIMER_STOP", "BREATH")
			breath.disableBlizzardBar = false
			try("RefreshVisibility", function() OtherBars:RefreshVisibility() end)
			check("a Breath timer that stopped while hidden stays gone", not BlizzardShows("BREATH"))
			breath.disableBlizzardBar, breathVisibility.neverShow, breathVisibility.alwaysShow = savedHide, savedNever, savedAlways
			try("RefreshVisibility", function() OtherBars:RefreshVisibility() end)
		end
		check("Classic has no Hide Blizzard swing timers setting", settings.bars.mainHandSwing.disableBlizzardBar == nil)
		try("SyncSwingEvents", function() OtherBars:SyncSwingEvents() end)
		check("with every swing bar off, nothing is registered", not Registered("COMBAT_LOG_EVENT_UNFILTERED") and not Registered("UNIT_SPELLCAST_SUCCEEDED"))
		SetEnabled(true, true, true)
		check("an enabled melee bar registers the combat log", Registered("COMBAT_LOG_EVENT_UNFILTERED") and Registered("UNIT_ATTACK_SPEED") and Registered("UNIT_SPELLCAST_START"))

		local timestamp = 5000
		local function Log(subevent, source, dest, ...)
			drv.payload = { timestamp, subevent, false, source, "", 0, 0, dest, "", 0, 0, ... }
			Fire("COMBAT_LOG_EVENT_UNFILTERED")
		end
		local function Swing(isOffHand, source)
			-- SWING_DAMAGE's tenth suffix value is isOffHand.
			Log("SWING_DAMAGE", source or PLAYER_GUID, TARGET_GUID, 100, 0, 1, nil, nil, nil, nil, nil, nil, isOffHand)
		end
		local function Cast(event, spellId)
			Fire(event, "player", "Cast-0", spellId)
		end

		Swing(nil)
		local remaining, total = Remaining("mainHandSwing")
		check("a main hand swing starts Main Hand at its speed", Near(total, 2) and Near(remaining, 2) and not OtherBars:IsBarActive("offHandSwing"))
		drv.now = drv.now + 0.5
		Log("SWING_MISSED", PLAYER_GUID, TARGET_GUID, "DODGE", true)
		check("an off hand miss starts Off Hand", OtherBars:IsBarActive("offHandSwing") and Near((Remaining("offHandSwing")), 2))
		Swing(nil, OTHER_GUID)
		check("someone else's swing changes nothing", Near((Remaining("mainHandSwing")), 1.5))

		Log("SPELL_EXTRA_ATTACKS", PLAYER_GUID, PLAYER_GUID, 15494, "Hand of Justice", 1, 1)
		timestamp = timestamp + 0.01
		Swing(nil)
		check("an extra attack's swing doesn't restart it", Near((Remaining("mainHandSwing")), 1.5))
		timestamp = timestamp + 0.01
		Swing(nil)
		check("the next swing does", Near((Remaining("mainHandSwing")), 2))

		drv.now = drv.now + 0.2
		Log("SWING_MISSED", TARGET_GUID, PLAYER_GUID, "PARRY", false)
		check("a parry takes 40% off the swing", Near((Remaining("mainHandSwing")), 1.0))
		Log("SWING_MISSED", TARGET_GUID, PLAYER_GUID, "PARRY", false)
		check("but never below 20% left", Near((Remaining("mainHandSwing")), 0.4))
		Log("SWING_MISSED", TARGET_GUID, PLAYER_GUID, "PARRY", false)
		check("and not at all once at 20%", Near((Remaining("mainHandSwing")), 0.4))
		Swing(nil)
		Log("SPELL_MISSED", TARGET_GUID, PLAYER_GUID, 12345, "Strike", 1, "PARRY")
		check("a parried special attack counts too", Near((Remaining("mainHandSwing")), 1.2))

		Swing(nil)
		drv.now = drv.now + 1
		drv.mainSpeed = 1.5
		Fire("UNIT_ATTACK_SPEED", "player")
		remaining, total = Remaining("mainHandSwing")
		check("an attack speed change rescales the rest of the swing", Near(total, 1.5) and Near(remaining, 0.75))
		drv.mainSpeed = 2

		Swing(nil)
		Cast("UNIT_SPELLCAST_START", LIGHTNING_BOLT)
		check("starting a cast pauses both hands", not OtherBars:IsBarActive("mainHandSwing") and not OtherBars:IsBarActive("offHandSwing"))
		Cast("UNIT_SPELLCAST_SUCCEEDED", LIGHTNING_BOLT)
		check("its success doesn't restart a swing without auto attack", not OtherBars:IsBarActive("mainHandSwing"))
		Fire("PLAYER_ENTER_COMBAT")
		Cast("UNIT_SPELLCAST_START", LIGHTNING_BOLT)
		Cast("UNIT_SPELLCAST_SUCCEEDED", LIGHTNING_BOLT)
		check("with auto attack on, its success restarts Main Hand", OtherBars:IsBarActive("mainHandSwing") and Near((Remaining("mainHandSwing")), 2))
		Cast("UNIT_SPELLCAST_START", SLAM)
		check("Slam's cast doesn't pause it", OtherBars:IsBarActive("mainHandSwing"))
		Cast("UNIT_SPELLCAST_START", LIGHTNING_BOLT)
		Cast("UNIT_SPELLCAST_INTERRUPTED", LIGHTNING_BOLT)
		Cast("UNIT_SPELLCAST_SUCCEEDED", INSTANT)
		check("an interrupted cast leaves nothing to restart", not OtherBars:IsBarActive("mainHandSwing"))

		Swing(nil)
		drv.now = drv.now + 0.5
		Cast("UNIT_SPELLCAST_SUCCEEDED", HEROIC_STRIKE)
		check("Heroic Strike restarts Main Hand", Near((Remaining("mainHandSwing")), 2))
		Fire("PLAYER_LEAVE_COMBAT")
		drv.now = drv.now + 0.5
		Cast("UNIT_SPELLCAST_SUCCEEDED", HEROIC_STRIKE)
		check("but not with auto attack off", Near((Remaining("mainHandSwing")), 1.5))

		Cast("UNIT_SPELLCAST_SUCCEEDED", AUTO_SHOT)
		remaining, total = Remaining("rangedSwing")
		check("Auto Shot starts Ranged at UnitRangedDamage's speed", Near(total, drv.rangedSpeed) and Near(remaining, drv.rangedSpeed))
		check("without touching Main Hand", Near((Remaining("mainHandSwing")), 1.5))
		Fire("PLAYER_ENTER_COMBAT")
		drv.now = drv.now + 0.5
		Cast("UNIT_SPELLCAST_SUCCEEDED", WAND_SHOOT)
		check("a wand shot restarts Ranged and Main Hand", Near((Remaining("rangedSwing")), drv.rangedSpeed) and Near((Remaining("mainHandSwing")), 2))
		drv.rangedSpeed = 3.1
		Fire("WEAPON_SLOT_CHANGED")
		check("a weapon swap restarts Ranged at UnitRangedDamage's speed", Near(select(2, Remaining("rangedSwing")), 3.1))

		SetEnabled(false, false, true)
		check("with only Ranged enabled, the combat log is dropped", not Registered("COMBAT_LOG_EVENT_UNFILTERED") and Registered("UNIT_SPELLCAST_SUCCEEDED"))
		SetEnabled(false, false, false)
		check("with none, the casts are dropped too", not Registered("UNIT_SPELLCAST_SUCCEEDED"))
		check("PLAYER_SWING is never registered", not Registered("PLAYER_SWING"))
	end

	-- Every options tab, to count the Hide Blizzard swing timers boxes.
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
	if TRB.Flavor.blizzardSwingTimer then
		check("the swing tabs offer Hide Blizzard swing timers", drv.blizzardSwingBoxes > 0)
	else
		check("no swing tab offers Hide Blizzard swing timers", drv.blizzardSwingBoxes == 0)
	end

	return errors
end

return hooks
