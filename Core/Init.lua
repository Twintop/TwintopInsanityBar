local addonName, TRB = ...
local L = TRB.Localization
local _, _, classIndexId = UnitClass("player")

-- Addon details data
TRB.Details = {}
TRB.Details.addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version") .. "-" .. C_AddOns.GetAddOnMetadata(addonName, "X-ReleaseType")
TRB.Details.addonAuthor = C_AddOns.GetAddOnMetadata(addonName, "Author")
TRB.Details.addonAuthorServer = C_AddOns.GetAddOnMetadata(addonName, "X-AuthorServer")
TRB.Details.addonTitle = C_AddOns.GetAddOnMetadata(addonName, "Title")
TRB.Details.addonReleaseDate = C_AddOns.GetAddOnMetadata(addonName, "X-ReleaseDate")
-- Voidform (file 1386550) shipped with the addon, since Classic Era's client lacks it. Every TOC's IconTexture names this file too.
TRB.Details.addonIcon = "Interface\\AddOns\\TwintopInsanityBar\\Images\\Icon.blp"
-- One line per class, sorted by module name, listing its supported specializations in spec order.
TRB.Details.supportedSpecs = ""
TRB.Details.supportedSpecsLabel = L["SupportedSpecs"]
do
	local hasSpecs = false
	local classEntries = {}
	for i, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		classEntries[i] = classEntry
	end
	table.sort(classEntries, function(a, b)
		return a.classModuleName < b.classModuleName
	end)
	for _, classEntry in ipairs(classEntries) do
		local line = "|c" .. select(4, GetClassColor(classEntry.classToken)) .. L[classEntry.classModuleName] .. "|r"
		if #classEntry.specs > 1 then
			hasSpecs = true
			local specNames = {}
			for i, specEntry in ipairs(classEntry.specs) do
				specNames[i] = L[specEntry.specLocaleKey]
			end
			line = line .. " - " .. table.concat(specNames, ", ")
		end
		TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. line .. "\n"
	end
	-- A flavor with one spec per class lists classes, under its own game's name rather than Midnight's.
	if not hasSpecs then
		TRB.Details.supportedSpecsLabel = string.format(L["SupportedClassesFormat"], L[TRB.Flavor.nameKey])
	end
end

local addonData = {
	loaded = false,
	registered = false,
	libs = {},
	toc = select(4, GetBuildInfo()),
	build = select(2, GetBuildInfo()),
}
addonData.libs.SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundWilhelmScream"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\wilhelm.ogg")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundBoxingArenaGong"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundAirHorn"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg")

addonData.libs.SharedMedia:Register("statusbar", L["LSMStatusBarM1"], "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\m1.tga")
addonData.libs.SharedMedia:Register("statusbar", L["LSMStatusBarClean"], "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\clean.blp")
addonData.libs.SharedMedia:Register("statusbar", L["LSMStatusBarSmoother"], "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga")

if not addonData.libs.SharedMedia:IsValid("border", "1 Pixel") then -- No localization on this as it is usually provided by WeakAuras
	addonData.libs.SharedMedia:Register("border", "1 Pixel", "Interface\\Buttons\\WHITE8X8")
end

addonData.libs.ScrollingTable = LibStub:GetLibrary("ScrollingTable")

addonData.libs.LibEditMode = TRB.LibEditMode or LibStub:GetLibrary("LibEditMode-1.0")

addonData.libs.CustomGlow = LibStub:GetLibrary("LibCustomGlow-1.0")

TRB.Details.addonData = addonData

-- Some class functions get referenced by other methods. These live in a consistent location but are actually created in the class modules.
TRB.Functions = TRB.Functions or {}
TRB.Functions.Class = {}

---Returns true when spec-specific timer variables (buff durations, rune cooldowns, etc.)
---are actively counting down, meaning lookup data changes with elapsed time even when
---no events fire. Each class module overrides this for specs that have such variables.
---The base implementation returns false (no spec-specific timers).
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	return false
end

-- Working data. The root table, the class/spec registries and TRB.Data.maxResource were created by
-- Core\FlavorRegistry.lua from the flavor manifest; everything else on TRB.Data is set up here.
TRB.Data = TRB.Data or {}

-- Dirty flag: set to true whenever data consumed by lookup refresh changes.
-- When false and no timers are active, UpdateResourceBarText skips the refresh entirely.
TRB.Data.lookupDirty = true

TRB.Data.constants = {
	borderWidthFactor = 2,
	-- Yards per second at 100% movement speed.
	runSpeed = 7,
	-- The range cache's value for a check with no answer: no target, or one the spell can't be used on.
	rangeInvalid = "invalid",
	defaultSettings = {
		fonts = {}, -- This will get populated by Functions\Settings.lua
		sounds = {
			sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
			soundName = L["LSMSoundAirHorn"]
		}
	},
	---Declared Cooldown Manager reliance, read only by the options panel. Lives here rather than on
	---the CDM module because bar types register before that module loads.
	---@enum TRB.CdmDependency
	cdmDependency = {
		-- Value is unobtainable without the tracked spell: bar text renders "??", nodes stay empty.
		REQUIRED = "required",
	},
	frameCategories = {
		container = "Container",
		resource = "Resource"
	},
	frameNames = {
		container = "Container",
		resource = "Resource",
		border = "Border",
	},
	frameLevels = {
		-- Every bar is levelled as bar + (anchor depth * barDepthStride), so a bar always draws
		-- above the bar it is anchored to. The stride leaves room for a bar's own overlays,
		-- which sit between node level +1 and +19.
		bar = 100,
		barDepthStride = 20,
		thresholdBase = 1000,
		thresholdOutOfRange = 1200,
		thresholdUnusable = 1800,
		thresholdUnder = 2000,
		thresholdOver = 2200,
		thresholdHighPriority = 2600,
		-- Overlap layout icons, 2 levels per rank, above every threshold line.
		thresholdIconLayout = 3000,
		thresholdOffsetLine = 2,
		thresholdOffsetIcon = 1,
		thresholdOffsetCooldown = 0,
		thresholdOffsetNoCooldown = 100,
		barText = 5000
	},
	optionsUi = {
		xPadding = 10,
		xPadding2 = 30,
		xCoord = 5,
		xCoord2 = 360,
		xOffset1 = 50,
		xOffset2 = 410, --Calculated below
		dropdownWidth = 350,
		sliderWidth = 300,
		sliderHeight = 20,
		maxOptionsWidth = 720,
		colorPickerTextWidth = 350,
		colorPickerFrameSize = 25,
		gradientColorPickerFrameSize = 25,
		tabWidth = {
			small = 125,
			medium = 150,
			large = 175,
			xlarge = 250
		}
	},
	---All 9 valid anchor points for bar positioning
	anchorPoints = {
		"TOPLEFT", "TOP", "TOPRIGHT",
		"LEFT", "CENTER", "RIGHT",
		"BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"
	},
	---Maps a legacy relativeTo value to the corresponding anchor/attach point pair
	---Used by PortForwardSettings migration and runtime fallback
	relativeToAnchorMap = {
		["TOP"]         = { anchorPoint = "TOP",         attachPoint = "BOTTOM" },
		["TOPLEFT"]     = { anchorPoint = "TOPLEFT",     attachPoint = "BOTTOMLEFT" },
		["TOPRIGHT"]    = { anchorPoint = "TOPRIGHT",    attachPoint = "BOTTOMRIGHT" },
		["BOTTOM"]      = { anchorPoint = "BOTTOM",      attachPoint = "TOP" },
		["BOTTOMLEFT"]  = { anchorPoint = "BOTTOMLEFT",  attachPoint = "TOPLEFT" },
		["BOTTOMRIGHT"] = { anchorPoint = "BOTTOMRIGHT",  attachPoint = "TOPRIGHT" },
	},
	---Maps an anchorPoint to the closest legacy relativeTo value.
	---Used for dual-write from anchor UI back to legacy fields.
	anchorPointToRelativeToMap = {
		["TOPLEFT"]     = "TOPLEFT",
		["TOP"]         = "TOP",
		["TOPRIGHT"]    = "TOPRIGHT",
		["LEFT"]        = "TOPLEFT",
		["CENTER"]      = "TOP",
		["RIGHT"]       = "TOPRIGHT",
		["BOTTOMLEFT"]  = "BOTTOMLEFT",
		["BOTTOM"]      = "BOTTOM",
		["BOTTOMRIGHT"] = "BOTTOMRIGHT",
	},
	---Threshold line colors a spec takes from Global Options while its Use Global box is checked
	globalThresholdColorKeys = { "over", "under", "unusable", "special", "outOfRange" }
}

TRB.Data.constants.optionsUi.xOffset2 = TRB.Data.constants.optionsUi.xCoord2 + TRB.Data.constants.optionsUi.xOffset1

TRB.Data.settings = {}

TRB.Data.specSupported = false
TRB.Data.resource = nil
TRB.Data.resourceFactor = 1
TRB.Data.barConstructedForSpec = nil

TRB.Data.barTextVariables = {
	icons = {},
	values = {},
	pipe = {
		{ variable = "||n", description = L["BarTextNewline"], printInSettings = true },
		{ variable = "||c", description = "", printInSettings = false },
		{ variable = "||r", description = "", printInSettings = false },
	},
	percent = {
		{ variable = "%%" }
	}
}

TRB.Data.cache = {}
TRB.Data.cache.barText = {}
TRB.Data.cache.symbols = {}
TRB.Data.cache.barTextTree = {}
TRB.Data.cache.colors = {
	bar = {},
	border = {},
	backdrop = {},
	gradient = {}
}
TRB.Data.cache.values = {
	bar = {},
	threshold = {},
	resource = {},
	castTime = {},
	frame = {},
	range = {},
	rangeInfo = {}
}
---@type TRB.Classes.SpellThreshold[]
TRB.Data.cache.thresholdSpells = {}
-- The learned lines by settingKey, rebuilt by Character:RefreshThresholdSpellsLearned.
---@type table<string, TRB.Classes.SpellThreshold>
TRB.Data.cache.thresholdSpellsByKey = {}
TRB.Data.specCache = {}

TRB.Data.character = {
	guid = UnitGUID("player"),
	raceId = 0,
	specId = TRB.Flavor.GetSpecializationIndex() or 0,
	classId = classIndexId,
	className = "",
	specName = "",
	compositeKey = nil, -- className_specName composite key, set by CheckCharacter()
	maxResource = 100,
	talents = TRB.Classes.Talents:New() --[[@as TRB.Classes.Talents]],
	items = {}
}
_, _, TRB.Data.character.raceId = UnitRace("player")

-- Register built-in bar types
TRB.Classes.BarTypeRegistry:GetInstance():RegisterBuiltInTypes()

-- Global player cast/channel/empower state model for the castbar bar type.
TRB.Data.castbar = TRB.Classes.Castbar:New("player")
TRB.Data.petCastbar = TRB.Classes.Castbar:New("pet")

-- Replaced by the active spec cache's SpellsData on spec load.
TRB.Data.spellsData = {}

TRB.Data.lookup = {}
TRB.Data.lookupLogic = {}

TRB.Data.sanityCheckValues = {
	barMaxWidth = 0,
	barMinWidth = 0,
	barMaxHeight = 0,
	barMinHeight = 0
}


-- Frames
TRB.Frames = {}

TRB.Frames.textFrames = {}

---A frame whose OnUpdate accumulates elapsed time into a throttled onUpdate; class modules supply targetsTimerFrame's.
---@class TRB.Classes.TimerFrame : Frame
---@field public sinceLastUpdate number
---@field public characterCheckSinceLastUpdate number?
---@field public onUpdate fun(self: TRB.Classes.TimerFrame, sinceLastUpdate: number)

TRB.Frames.targetsTimerFrame = CreateFrame("Frame") --[[@as TRB.Classes.TimerFrame]]
TRB.Frames.targetsTimerFrame.sinceLastUpdate = 0

TRB.Frames.timerFrame = CreateFrame("Frame") --[[@as TRB.Classes.TimerFrame]]
TRB.Frames.timerFrame.sinceLastUpdate = 0
TRB.Frames.timerFrame.characterCheckSinceLastUpdate = 0

function TRB.Frames.timerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.characterCheckSinceLastUpdate  = self.characterCheckSinceLastUpdate  + sinceLastUpdate

	if self.sinceLastUpdate >= 0.05 then -- in seconds
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshotData.targetData

		if self.characterCheckSinceLastUpdate >= TRB.Data.settings.core.dataRefreshRate then -- in seconds
			TRB.Data.character.latency = TRB.Functions.Character:GetLatency()
			self.characterCheckSinceLastUpdate = 0
		end

		-- Stop all current target tracking
		local guid = nil --UnitGUID("target")
		if targetData.currentTargetGuid ~= guid then
			targetData.currentTargetGuid = guid
		end

		if guid ~= nil then
			local isDead = UnitIsDeadOrGhost("target")

			if isDead and targetData.targets[targetData.currentTargetGuid] ~= nil then
				targetData:Remove(guid)
			end
		end

		TRB.Functions.CurveMemo:SetActive(true)
		TRB.Functions.Character:FlushHealthValues()
		TRB.Functions.AudioCues:UpdateBuffCues(TRB.Data.snapshotData)
		TRB.Functions.Class:TriggerResourceBarUpdates()
		TRB.Functions.CurveMemo:SetActive(false)
		self.sinceLastUpdate = 0
	end
end

-- Tracks an active boss encounter so the combat timer survives a death-and-rez mid-fight.
local inEncounter = false

TRB.Frames.combatFrame = CreateFrame("Frame", "TwintopResourceBarFrame_CombatFrame", UIParent)
TRB.Frames.combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		TRB.Data.character.inCombat = true
		-- Keep an existing start time so a battle rez mid-fight continues the timer rather than restarting.
		if TRB.Data.character.combatStartTime == nil then
			TRB.Data.character.combatStartTime = GetTime()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		TRB.Data.character.inCombat = false
		-- Dying drops combat but the fight may continue, so only reset when leaving combat while alive and not in an encounter.
		if not UnitIsDeadOrGhost("player") and not inEncounter then
			TRB.Data.character.combatStartTime = nil
		end
	elseif event == "ENCOUNTER_START" then
		inEncounter = true
	elseif event == "ENCOUNTER_END" then
		inEncounter = false
		-- Encounter over (kill or wipe); reset the timer unless combat is somehow still ongoing.
		if not InCombatLockdown() then
			TRB.Data.character.combatStartTime = nil
		end
	elseif event == "PLAYER_UNGHOST" or event == "PLAYER_ALIVE" then
		-- Fully resurrected out of combat with no active encounter (e.g. corpse run after a world death): reset before the next pull.
		if not inEncounter and not InCombatLockdown() and not UnitIsDeadOrGhost("player") then
			TRB.Data.character.combatStartTime = nil
		end
	end
	-- Fully invalidate memoization so formatting branches that depend on inCombat
	-- (e.g., overcap text coloring) rewrite all lookup strings on the next refresh.
	TRB.Functions.BarText:InvalidateLookupMemoization()
	TRB.Functions.BarVisibility:MarkDirty()
	TRB.Functions.Bar:ShowResourceBar()
end)

TRB.Frames.renderTransitionFrame = CreateFrame("Frame")
TRB.Frames.renderTransitionFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TRB.Frames.renderTransitionFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
TRB.Frames.renderTransitionFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
TRB.Frames.renderTransitionFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
TRB.Frames.renderTransitionFrame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
TRB.Frames.renderTransitionFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
TRB.Frames.renderTransitionFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	-- Wrong game version for this build: no bar was ever constructed, so there is nothing to transition.
	if TRB.Functions.VersionGate:IsBlocked() then
		return
	end

	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end

	if event == "PLAYER_TALENT_UPDATE" then
		local specName = TRB.Data.barConstructedForSpec
		if specName ~= nil and TRB.Data.specCache[specName] ~= nil and TRB.Data.specCache[specName].talents ~= nil then
			if not TRB.Data.specCache[specName].talents:HaveTalentsChanged() then
				return
			end
		end
	end

	if TRB.Functions and TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
		-- Increase initial transition time to cover the loading sequence delay
		TRB.Functions.Bar:QueueRenderTransition("init:" .. event, 2.5)
	end
end)

-- Settings placeholders
TRB.Frames.interfaceSettingsFrameContainer = {}
TRB.Frames.interfaceSettingsFrameContainer.controls = {}

-- Minimap button: initialize once settings are loaded
local minimapButtonInitFrame = CreateFrame("Frame")
minimapButtonInitFrame:RegisterEvent("PLAYER_LOGIN")
minimapButtonInitFrame:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	-- Wrong game version for this build: settings were never merged, so there is nothing to drive a button.
	if TRB.Functions.VersionGate:IsBlocked() then
		return
	end
	-- Delay slightly to ensure saved variables and settings merging is complete
	C_Timer.After(2, function()
		TRB.Functions.MinimapButton:Initialize()
	end)
end)

local function ParseCmdString(msg)
	if msg then
		while (strfind(msg,"  ") ~= nil) do
			msg = string.gsub(msg,"  "," ")
		end
		local a,b,c=strfind(msg,"(%S+)")
		if a then
			return c,strsub(msg,b+2)
		else
			return ""
		end
	end
end

function SlashCmdList.TWINTOP(msg)
	local cmd, subcmd = ParseCmdString(msg)
	if cmd == "reset" then
		StaticPopup_Show("TwintopResourceBar_Reset")
	elseif cmd == "fill" then
		TRB.Functions.Spell:FillSpellData()
	elseif cmd == "move" then
		local x, y = ParseCmdString(subcmd)
		TRB.Functions.Bar:SetPositionXY(tonumber(x), tonumber(y))
	elseif cmd == "news" then
		TRB.Functions.News:Show()
	elseif cmd == "cdm" then
		local spellArg = ParseCmdString(subcmd)
		if spellArg == nil or spellArg == "" then
			TRB.Functions.CooldownManager:PrintDiagnostics()
		elseif tonumber(spellArg) ~= nil then
			TRB.Functions.CooldownManager:PrintSpellReport(tonumber(spellArg))
		else
			print("|cFFFF8800TRB CDM:|r Unknown argument '" .. spellArg .. "'. Usage: /trb cdm [spellId]")
		end
	elseif cmd == "auraengine" then
		TRB.Functions.AuraEngine:PrintDiagnostics()
	elseif cmd == "otherbars" then
		TRB.Functions.OtherBars:PrintDiagnostics()
	elseif cmd == "skyriding" then
		if subcmd ~= nil and subcmd ~= "" then
			print("|cFFFF8800TRB Skyriding:|r Unknown argument '" .. subcmd .. "'. Usage: /trb skyriding")
		else
			TRB.Functions.Skyriding:ToggleProbe()
		end
	elseif cmd == "bars" then
		TRB.Functions.Bar:PrintDiagnostics()
	elseif cmd == "castname" then
		TRB.Functions.Castbar:ToggleCastNameEcho()
	elseif cmd == "minimap" then
		local minimapCmd = ParseCmdString(subcmd)
		if minimapCmd == "hide" then
			TRB.Functions.MinimapButton:Hide()
		elseif minimapCmd == "show" then
			TRB.Functions.MinimapButton:Show()
		else
			TRB.Functions.MinimapButton:Toggle()
		end
	elseif cmd == nil or cmd == "" then
		TRB.Options.OptionsFrame:Show()
		if TRB.Data.barConstructedForSpec ~= nil then
			TRB.Options.OptionsFrame:SelectCategory(TRB.Data.barConstructedForSpec)
		else
			TRB.Options.OptionsFrame:SelectCategory("main")
		end
	else
		-- Spec modules can add their own diagnostics sub-commands through the spec descriptor.
		local descriptor = TRB.Functions.Character:GetActiveSpecDescriptor()
		local handler = descriptor and descriptor.slashCommands and descriptor.slashCommands[cmd]
		if handler ~= nil then
			handler(subcmd)
		else
			print("|cFFFF8800TRB:|r Unknown command '" .. cmd .. "'. Valid: reset, fill, move, news, minimap. Use /trb on its own for options.")
		end
	end
end

Twintop_Data = TRB.Data
