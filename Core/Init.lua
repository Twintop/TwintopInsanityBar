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
-- One line per class, sorted by module name, listing its supported specializations in spec order.
TRB.Details.supportedSpecs = ""
do
	local classEntries = {}
	for i, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		classEntries[i] = classEntry
	end
	table.sort(classEntries, function(a, b)
		return a.classModuleName < b.classModuleName
	end)
	for _, classEntry in ipairs(classEntries) do
		local specNames = {}
		for i, specEntry in ipairs(classEntry.specs) do
			specNames[i] = L[specEntry.specLocaleKey]
		end
		TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor(classEntry.classToken)) .. L[classEntry.classModuleName] .. "|r - " .. table.concat(specNames, ", ") .. "\n"
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

addonData.libs.LibSmoothMove = LibStub:GetLibrary("LibSmoothMove-1.0")

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
	defaultSettings = {
		fonts = {}, -- This will get populated by Functions\Settings.lua
		textures = {
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			resourceBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
			resourceBarName="TRB: Smoother",
		},
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
		-- which sit between node level +1 and +9.
		bar = 100,
		barDepthStride = 10,
		thresholdBase = 1000,
		thresholdOutOfRange = 1200,
		thresholdUnusable = 1800,
		thresholdUnder = 2000,
		thresholdOver = 2200,
		thresholdHighPriority = 2600,
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
	}
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
	range = {}
}
---@type TRB.Classes.SpellThreshold[]
TRB.Data.cache.thresholdSpells = {}
TRB.Data.specCache = {}

TRB.Data.character = {
	guid = UnitGUID("player"),
	raceId = 0,
	specId = GetSpecialization() or 0,
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
TRB.Data.castbar = TRB.Classes.Castbar:New()

---@type TRB.Classes.SpellsData
---@diagnostic disable-next-line: missing-fields
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

TRB.Frames.targetsTimerFrame = CreateFrame("Frame")
TRB.Frames.targetsTimerFrame.sinceLastUpdate = 0

---@class Frame
TRB.Frames.timerFrame = CreateFrame("Frame")
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
		
		TRB.Functions.Class:TriggerResourceBarUpdates()
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


-- TEMPORARY DIAGNOSTIC (/trb endcap), remove once end cap tracking is fixed: samples the rendered fill
-- edge against the cap band edge, alongside the overshoot the slot computes versus the one it applied.
local END_CAP_PROBE_MAX = 30
local END_CAP_PROBE_TIMEOUT = 20
local END_CAP_PROBE_INTERVAL = 0.05
local endCapProbeFrame = CreateFrame("Frame")
endCapProbeFrame:Hide()
local endCapProbeSamples = {}
local endCapProbeGroupKey = "castbar"
local endCapProbeStarted = 0
local endCapProbeNextSample = 0
local endCapProbeLastSpan = nil

---Classifies a raw widget read: a number, the string "SECRET", or "nil".
local function EndCapProbeFmt(value)
	if value == nil then
		return "nil"
	end
	if issecretvalue(value) then
		return "SECRET"
	end
	if type(value) == "number" then
		return string.format("%.2f", value)
	end
	return tostring(value)
end

---True when a raw read is a plain number we are allowed to do arithmetic on.
local function EndCapProbePlain(value)
	return value ~= nil and not issecretvalue(value) and type(value) == "number"
end

---The region leading-edge screen coordinate for this fill direction, unprocessed.
local function EndCapProbeRawEdge(region, fillDirection)
	if region == nil then
		return nil
	end
	if fillDirection == "rightLeft" then
		return region:GetLeft()
	elseif fillDirection == "bottomTop" then
		return region:GetTop()
	elseif fillDirection == "topBottom" then
		return region:GetBottom()
	end
	return region:GetRight()
end

---The bar frame fill-start screen coordinate for this fill direction, unprocessed.
local function EndCapProbeRawOrigin(frame, fillDirection)
	if frame == nil then
		return nil
	end
	if fillDirection == "rightLeft" then
		return frame:GetRight()
	elseif fillDirection == "bottomTop" then
		return frame:GetBottom()
	elseif fillDirection == "topBottom" then
		return frame:GetTop()
	end
	return frame:GetLeft()
end

---Distance from the fill start to an edge. nil when either read is missing or secret.
local function EndCapProbeSpan(edge, origin, fillDirection)
	if not EndCapProbePlain(edge) or not EndCapProbePlain(origin) then
		return nil
	end
	if fillDirection == "rightLeft" or fillDirection == "topBottom" then
		return origin - edge
	end
	return edge - origin
end

---Resolves the probed bar node, frame, end cap slot, cap band, and fill texture.
local function EndCapProbeParts()
	local group = TRB.Frames.barGroups and TRB.Frames.barGroups[endCapProbeGroupKey] or nil
	local node = group and group:GetNode(1) or nil
	if node == nil then
		return nil
	end
	local slot = node.overlaySlots and node.overlaySlots.endCap or nil
	local frame = node.frame
	local tex = (frame ~= nil and frame.GetStatusBarTexture ~= nil) and frame:GetStatusBarTexture() or nil
	return node, frame, slot, (slot and slot.endCapFrame or nil), tex
end

local function EndCapProbeFinish(reason)
	endCapProbeFrame:Hide()
	local node, frame, slot = EndCapProbeParts()
	print(string.format("|cFF00FF00TRB EndCap:|r %s -- %d sample(s) [%s] combat=%s",
		endCapProbeGroupKey, #endCapProbeSamples, reason, tostring(InCombatLockdown())))
	if node ~= nil and frame ~= nil then
		print(string.format("  w=%s border=%s dir=%s capW=%s ready=%s cfg=%s",
			EndCapProbeFmt(node.width), EndCapProbeFmt(node.border), tostring(node.fillDirection),
			EndCapProbeFmt(slot and slot.endCapWidth or nil), tostring(slot and slot.endCapReady),
			tostring(node.endCapConfig ~= nil)))
		print("  sig=" .. tostring(slot and slot._endCapAnchorSig))
	end
	if #endCapProbeSamples == 0 then
		print("  No frames captured at all -- the bar group had no node or no end cap band.")
		return
	end

	local sum, worst, deltas = 0, 0, 0
	for _, s in ipairs(endCapProbeSamples) do
		if s.delta ~= nil then
			deltas = deltas + 1
			sum = sum + s.delta
			if math.abs(s.delta) > math.abs(worst) then
				worst = s.delta
			end
		end
	end
	if deltas > 0 then
		print(string.format("  tex-cap: mean %.2fpx, worst %.2fpx over %d row(s) (positive = cap trails the fill edge)",
			sum / deltas, worst, deltas))
	else
		print("  tex-cap: not computable on any row.")
	end

	print("  t(ms) | texEdge | capEdge | tex-cap | oNow | oApp | ticks | GetValue")
	for _, s in ipairs(endCapProbeSamples) do
		print(string.format("  %5d | %7s | %7s | %7s | %4s | %4s | %5s | %s",
			s.t, s.texEdge, s.capEdge, s.delta ~= nil and string.format("%.2f", s.delta) or "-",
			s.oNow, s.oApp, s.ticks, s.value))
	end
end

endCapProbeFrame:SetScript("OnUpdate", function()
	local now = GetTime()
	if now - endCapProbeStarted > END_CAP_PROBE_TIMEOUT then
		EndCapProbeFinish("timeout")
		return
	end
	if now < endCapProbeNextSample then
		return
	end

	local node, frame, slot, band, tex = EndCapProbeParts()
	if node == nil then
		EndCapProbeFinish("bar group has no node")
		return
	end
	if band == nil or tex == nil then
		EndCapProbeFinish("no end cap band on this bar -- is End Cap enabled for it?")
		return
	end

	local fillDirection = node.fillDirection or "leftRight"
	local origin = EndCapProbeRawOrigin(frame, fillDirection)
	local texSpan = EndCapProbeSpan(EndCapProbeRawEdge(tex, fillDirection), origin, fillDirection)
	local capSpan = EndCapProbeSpan(EndCapProbeRawEdge(band, fillDirection), origin, fillDirection)

	-- Hold off until the fill is actually moving, but only when that is knowable.
	if texSpan ~= nil then
		if endCapProbeLastSpan ~= nil and math.abs(texSpan - endCapProbeLastSpan) < 0.01 then
			return
		end
		endCapProbeLastSpan = texSpan
	end
	endCapProbeNextSample = now + END_CAP_PROBE_INTERVAL

	-- oNow is what the slot would compute this frame; oApp is what its current anchor was built with.
	-- They diverge exactly when the watcher is not keeping up.
	endCapProbeSamples[#endCapProbeSamples + 1] = {
		t = math.floor((now - endCapProbeStarted) * 1000 + 0.5),
		texEdge = texSpan ~= nil and string.format("%.2f", texSpan) or "?",
		capEdge = capSpan ~= nil and string.format("%.2f", capSpan) or "?",
		delta = (texSpan ~= nil and capSpan ~= nil) and (texSpan - capSpan) or nil,
		oNow = EndCapProbeFmt(slot:GetEndCapOvershoot()),
		oApp = EndCapProbeFmt(slot._endCapOvershoot),
		ticks = tostring(slot._endCapTrackTicks or 0),
		value = EndCapProbeFmt(frame:GetValue()),
	}

	if #endCapProbeSamples >= END_CAP_PROBE_MAX then
		EndCapProbeFinish("buffer full")
	end
end)

---Arms the probe on a bar group and starts sampling.
---@param groupKey string
local function StartEndCapProbe(groupKey)
	endCapProbeGroupKey = groupKey
	endCapProbeSamples = {}
	endCapProbeStarted = GetTime()
	endCapProbeNextSample = 0
	endCapProbeLastSpan = nil
	endCapProbeFrame:Show()
	print(string.format("|cFF00FF00TRB EndCap:|r Probing %s. Move that bar now -- reports after %d sample(s) or %ds.",
		groupKey, END_CAP_PROBE_MAX, END_CAP_PROBE_TIMEOUT))
end

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
	elseif cmd == "endcap" then
		local barArg = ParseCmdString(subcmd)
		if barArg == nil or barArg == "" then
			barArg = "castbar"
		elseif barArg == "target" then
			barArg = "targetCastbar"
		elseif barArg == "focus" then
			barArg = "focusCastbar"
		end
		local barGroups = TRB.Frames.barGroups
		if barGroups == nil or barGroups[barArg] == nil then
			print("|cFFFF8800TRB EndCap:|r Unknown bar '" .. barArg .. "'. Usage: /trb endcap [castbar|target|focus|<barGroupKey>]")
		else
			StartEndCapProbe(barArg)
		end
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
