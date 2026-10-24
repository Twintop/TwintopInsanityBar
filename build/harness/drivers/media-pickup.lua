-- Checks that a font, texture, or sound that isn't loaded draws or plays the default and is picked up live (#584).
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx)

	-- Keeps the last font each string was given, and succeeds as a font that loads does.
	local meta = getmetatable(desktop.CreateFrame("Frame"))
	local index = meta.__index
	local function SetFont(self, path, size)
		rawset(self, "__fontPath", path)
		rawset(self, "__fontSize", size)
		return true
	end
	meta.__index = function(self, key)
		if key == "SetFont" then
			return SetFont
		end
		return index(self, key)
	end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local lsm = TRB.Details.addonData.libs.SharedMedia
	local LibSharedMedia = TRB.Functions.LibSharedMedia
	local Character = TRB.Functions.Character
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
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
	Drain("SETUP")
	TRB.Details.addonData.optionsPanelFinished = true

	local character = TRB.Data.character
	local specSettings = TRB.Data.settings[character.className][character.specName]
	local coreSettings = TRB.Data.settings.core
	if character.className == "druid" then
		character.currentShapeshiftForm = "cat"
	end
	local defaults = TRB.Functions.Settings:DefaultTextures(true)

	local layouts = {}
	local layout = TRB.Functions.Bar.ApplyBarGroupsLayout
	TRB.Functions.Bar.ApplyBarGroupsLayout = function(self, settings, barGroups)
		layouts[#layouts + 1] = settings
		return layout(self, settings, barGroups)
	end

	---Saves a background pick under a name that isn't registered, in every built spec and Global, and re-fills them.
	---@param name string
	local function PickMissingBackground(name)
		for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
			if TRB.Data.specCache[entry.compositeKey] then
				local textures = TRB.Data.settings[entry.className][entry.specName].textures
				textures.background, textures.backgroundName = "Interface\\Old\\Background", name
			end
		end
		coreSettings.textures.background, coreSettings.textures.backgroundName = "Interface\\Old\\Background", name
		for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
			if TRB.Data.specCache[entry.compositeKey] then
				Character:FillSpecializationCacheSettings(entry.className, entry.specName)
			end
		end
	end
	local function DisplayedBackground()
		local settings = TRB.Functions.Class:GetActiveDisplaySettings()
		return settings and settings.textures.background
	end
	local function PrimaryNodeBackground()
		local primary = TRB.Frames.barGroups and TRB.Frames.barGroups.primary
		local node = primary and primary:GetNode(1)
		return node and node.backgroundTexture
	end

	-- A texture that isn't loaded draws the default, keeps the pick, and switches when it registers.
	PickMissingBackground("TRB Driver Late Background")
	check("a texture that isn't loaded draws the default", DisplayedBackground() == defaults.background)
	check("and keeps its saved name and path", specSettings.textures.backgroundName == "TRB Driver Late Background" and specSettings.textures.background == "Interface\\Old\\Background")
	check("the options mark it as not loaded", LibSharedMedia:GetDisplayName("background", "TRB Driver Late Background") == string.format(TRB.Localization["LSMNotLoaded"], "TRB Driver Late Background"))
	lsm:Register("background", "TRB Driver Late Background", "Interface\\Late\\Background")
	Drain("REGISTERED")
	check("registering it switches the displayed settings", DisplayedBackground() == "Interface\\Late\\Background")
	check("and the main bar", PrimaryNodeBackground() == "Interface\\Late\\Background")
	check("without writing settings", specSettings.textures.background == "Interface\\Old\\Background")

	-- In combat the switch waits for combat to end, then lays out the displayed settings once.
	PickMissingBackground("TRB Driver Combat Background")
	local inCombat = desktop.InCombatLockdown
	desktop.InCombatLockdown = function() return true end
	local before = #layouts
	lsm:Register("background", "TRB Driver Combat Background", "Interface\\Combat\\Background")
	Drain("COMBAT")
	check("a pickup in combat waits", DisplayedBackground() == defaults.background and #layouts == before)
	desktop.InCombatLockdown = inCombat
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	Drain("REGEN")
	check("and applies once combat ends", DisplayedBackground() == "Interface\\Combat\\Background" and #layouts == before + 1)
	check("laid out with the displayed settings", layouts[#layouts] == TRB.Functions.Class:GetActiveDisplaySettings())
	local displayKey = TRB.Functions.Class:GetActiveDisplayCompositeKey()
	if displayKey ~= character.compositeKey then
		check("a " .. character.compositeKey .. " in Cat Form is laid out with " .. tostring(displayKey), layouts[#layouts] == TRB.Data.specCache[displayKey].settings)
	end
	before = #layouts
	stubs.fireEvents("PLAYER_REGEN_ENABLED", ctx.addonName)
	Drain("REGEN_AGAIN")
	check("a later combat end does nothing", #layouts == before)

	-- Bar text fonts draw from their name, and an entry without one draws the default.
	lsm:Register("font", "TRB Driver Font", "Fonts\\Driver.ttf")
	local defaultFont = TRB.Data.constants.defaultSettings.fonts.fontFace
	local cases = {
		{ size = 31, name = nil, path = "Fonts\\Saved.ttf", want = defaultFont, label = "a font with no name draws the default" },
		{ size = 32, name = "", path = "Fonts\\Saved.ttf", want = defaultFont, label = "a font with an empty name draws the default" },
		{ size = 33, name = "TRB Driver Font", path = "", want = "Fonts\\Driver.ttf", label = "a loaded font with no file draws its file" },
		{ size = 34, name = "TRB Driver Font", path = "Fonts\\Stale.ttf", want = "Fonts\\Driver.ttf", label = "a loaded font with a stale file draws its file" },
		{ size = 35, name = "TRB Driver Late Font", path = "Fonts\\Old.ttf", want = defaultFont, label = "a font that isn't loaded draws the default" },
	}
	local barText = specSettings.displayText.barText
	local template = TRB.Functions.Table:DeepCopy(barText[1])
	local first = #barText + 1
	for i, case in ipairs(cases) do
		local entry = TRB.Functions.Table:DeepCopy(template)
		entry.guid = "trb-driver-font-" .. i
		entry.enabled, entry.useDefaultFontFace, entry.useDefaultFontSize = true, false, false
		entry.fontSize, entry.fontFaceName, entry.fontFace = case.size, case.name, case.path
		entry.position = { relativeTo = "CENTER", relativeToName = "Center", relativeToFrame = "UIParent", relativeToFrameName = "Screen", xPos = 0, yPos = 0 }
		barText[first + i - 1] = entry
	end
	Character:FillSpecializationCacheSettings(character.className, character.specName)
	TRB.Functions.BarText:CreateBarTextFrames()
	local function FontOfSize(size)
		for _, frame in ipairs(TRB.Frames.textFrames or {}) do
			if frame.font and rawget(frame.font, "__fontSize") == size then
				return rawget(frame.font, "__fontPath")
			end
		end
		return nil
	end
	local wrote = false
	for i, case in ipairs(cases) do
		check(case.label, FontOfSize(case.size) == case.want)
		local entry = barText[first + i - 1]
		wrote = wrote or entry.fontFaceName ~= case.name or entry.fontFace ~= case.path
	end
	check("drawing bar text writes no font into settings", not wrote)
	lsm:Register("font", "TRB Driver Late Font", "Fonts\\Late.ttf")
	Drain("FONT")
	check("a font that registers later is picked up", FontOfSize(35) == "Fonts\\Late.ttf")

	-- Sounds resolve where they play.
	local defaultSound = TRB.Data.constants.defaultSettings.sounds.sound
	check("a sound that isn't loaded plays the default", LibSharedMedia:ResolveSound("TRB Driver Missing Sound", "Interface\\Old.ogg") == defaultSound)
	check("a sound with no name plays its saved file", LibSharedMedia:ResolveSound(nil, "Interface\\Saved.ogg") == "Interface\\Saved.ogg")

	-- One label refresher that throws reports it without skipping the others.
	local Media = TRB.Functions.OptionsUi.Media
	local ran, reported = 0, 0
	local handler = desktop.geterrorhandler
	desktop.geterrorhandler = function() return function() reported = reported + 1 end end
	local keys = { {}, {}, {} }
	Media:SetLabelRefresher(keys[1], function() error("driver refresher") end)
	Media:SetLabelRefresher(keys[2], function() ran = ran + 1 end)
	Media:SetLabelRefresher(keys[3], function() ran = ran + 1 end)
	Media:GetFontPairs()
	Media:RefreshCaches()
	desktop.geterrorhandler = handler
	for _, key in ipairs(keys) do
		Media:SetLabelRefresher(key, function() end)
	end
	check("a throwing label refresher is reported and the rest still run", ran == 2 and reported == 1)

	return errors
end

return hooks
