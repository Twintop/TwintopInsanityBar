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
		local line = "|c" .. select(4, GetClassColor(classEntry.classToken)) .. L[classEntry.classModuleName] .. "|r"
		if #classEntry.specs > 1 then
			local specNames = {}
			for i, specEntry in ipairs(classEntry.specs) do
				specNames[i] = L[specEntry.specLocaleKey]
			end
			line = line .. " - " .. table.concat(specNames, ", ")
		end
		TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. line .. "\n"
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
	range = {}
}
---@type TRB.Classes.SpellThreshold[]
TRB.Data.cache.thresholdSpells = {}
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

-- TEMPORARY DIAGNOSTIC (/trb tickcost), remove once the 20Hz split lands: times each tick, and lets other
-- modules time or count their own work into the same run while costProbe is non-nil.
TRB.Frames.timerFrame.costProbe = nil

---Adds one timed sample to a probe bucket. Callers check costProbe first so an idle probe costs nothing.
---@param key string
---@param elapsed number # Milliseconds
function TRB.Frames.timerFrame:ProbeTime(key, elapsed)
	local probe = self.costProbe
	if probe == nil then
		return
	end
	local bucket = probe.times[key]
	if bucket == nil then
		bucket = { count = 0, total = 0, max = 0, samples = {} }
		probe.times[key] = bucket
		probe.timeOrder[#probe.timeOrder + 1] = key
	end
	bucket.count = bucket.count + 1
	bucket.total = bucket.total + elapsed
	bucket.samples[bucket.count] = elapsed
	if elapsed > bucket.max then
		bucket.max = elapsed
	end
end

---Adds one to a probe counter.
---@param key string
function TRB.Frames.timerFrame:ProbeCount(key)
	local probe = self.costProbe
	if probe == nil then
		return
	end
	if probe.counts[key] == nil then
		probe.counts[key] = 0
		probe.countOrder[#probe.countOrder + 1] = key
	end
	probe.counts[key] = probe.counts[key] + 1
end

-- Section timing: a run wraps these shared functions and charges each call's own time, minus nested
-- wrapped calls, to its section. "other" is the rest of the tick: snapshots and inline class module code.
local probeSectionTargets = {
	{ "visibility", "Bar", "HideResourceBar" },
	{ "lookup base", "BarText", "RefreshLookupDataBase" },
	{ "lookup spec", nil, "RefreshLookupData" },
	{ "text render", "BarText", "UpdateResourceBarText" },
	{ "text anchors", "BarText", "GetAnchorFrame" },
	{ "snapshots", "Character", "UpdateSnapshot" },
	{ "threshold setup", "Classes.ThresholdBar", "Set" },
	{ "threshold setup", "Classes.ThresholdState", "Refresh" },
	{ "threshold setup", "Classes.ThresholdData", "Refresh" },
	{ "spell thresholds", "Threshold", "UpdateSpellThresholds" },
	{ "threshold audio", "Threshold", "UpdateSpellThresholdAudio" },
	{ "custom thresholds", "Threshold", "UpdateCustomThresholdLines" },
	{ "custom target info", "Threshold", "GetCustomThresholdTargetInfo" },
	{ "threshold display", "Threshold", "AdjustThresholdDisplay" },
	{ "threshold position", "Threshold", "RepositionThreshold" },
	{ "threshold position", "Threshold", "RepositionThresholdCustomBar" },
	{ "threshold curve color", "Threshold", "ApplyThresholdCurveColor" },
	{ "threshold curve color", "Threshold", "ApplyCustomThresholdCurveColor" },
	{ "audio", "AudioCues", "UpdateBuffCues" },
	{ "audio", "AudioCues", "FireGroup" },
	{ "audio", "AudioCues", "FireValueGroup" },
	{ "indicators", "Color", "ApplyIndicatorColors" },
	{ "indicators", "Bar", "ApplyNodeIndicators" },
	{ "fill", "Bar", "SetBarNodePrimaryValue" },
	{ "fill", "Bar", "SetBarNodeValue" },
	{ "fill", "Color", "ApplyFillColor" },
	{ "fill", "Color", "ApplyNodeGradientColors" },
	{ "fill", "Bar", "UpdateCastingResourceOverlay" },
	{ "node colors", "Classes.BarNode", "SetColor" },
	{ "node colors", "Classes.BarNode", "SetBorderColor" },
	{ "node colors", "Classes.BarNode", "SetBackgroundColorFromString" },
	{ "node curve colors", "Classes.BarNode", "SetColorCurve" },
	{ "node curve colors", "Classes.BarNode", "SetBorderColorCurve" },
	{ "node curve colors", "Classes.BarNode", "SetBackgroundColorCurve" },
	{ "pulse", "Bar", "PulsePrimaryBar" },
	{ "pulse", "Bar", "ClearPrimaryPulse" },
	{ "health bar", "Bar", "UpdateHealthBar" },
	{ "health read", "Character", "FlushHealthValues" },
	{ "pet bars", "Bar", "UpdatePetBars" },
}

---Wraps one function so calls made inside a tick charge their exclusive time to the section.
---@param state table
---@param section string
---@param owner table
---@param key string
---@return function|nil wrapper
local function WrapProbeSection(state, section, owner, key)
	local original = owner[key]
	if type(original) ~= "function" then
		return nil
	end
	local function Finish(started, ...)
		local now = debugprofilestop()
		local depth = state.depth
		local inclusive = now - started
		state.tick[section] = state.tick[section] + inclusive - state.child[depth]
		state.depth = depth - 1
		if depth > 1 then
			state.child[depth - 1] = state.child[depth - 1] + inclusive
		end
		return ...
	end
	local wrapper = function(...)
		if not state.inTick then
			return original(...)
		end
		local depth = state.depth + 1
		state.depth = depth
		state.child[depth] = 0
		state.stack[depth] = section
		state.calls = state.calls + 1
		state.sectionCalls[section] = (state.sectionCalls[section] or 0) + 1
		return Finish(debugprofilestop(), original(...))
	end
	-- A widget's method comes from its metatable, so restoring it means clearing the field again.
	local hadField = rawget(owner, key) ~= nil
	owner[key] = wrapper
	state.installed[#state.installed + 1] = { owner = owner, key = key, original = hadField and original or nil, wrapper = wrapper }
	return wrapper
end

---Builds a run's section state and wraps every section target.
---@return table state
local function InstallProbeSections()
	local state = { inTick = false, depth = 0, calls = 0, sectionCalls = {}, child = {}, stack = {}, tick = {}, order = {}, buckets = {}, installed = {} }
	for _, target in ipairs(probeSectionTargets) do
		local section, ownerName, key = target[1], target[2], target[3]
		local className = ownerName ~= nil and string.match(ownerName, "^Classes%.(.+)$") or nil
		local owner
		if className ~= nil then
			owner = TRB.Classes[className]
		else
			owner = ownerName == nil and TRB.Functions or TRB.Functions[ownerName]
		end
		if owner ~= nil and WrapProbeSection(state, section, owner, key) ~= nil and state.buckets[section] == nil then
			state.buckets[section] = { total = 0, samples = {} }
			state.order[#state.order + 1] = section
			state.tick[section] = 0
		end
	end
	-- Bar text font strings are wrapped one by one; frames rebuilt mid-run go untimed.
	for _, textFrame in ipairs(TRB.Frames.textFrames or {}) do
		if textFrame.font ~= nil and WrapProbeSection(state, "text SetText", textFrame.font, "SetText") ~= nil and state.buckets["text SetText"] == nil then
			state.buckets["text SetText"] = { total = 0, samples = {} }
			state.order[#state.order + 1] = "text SetText"
			state.tick["text SetText"] = 0
		end
	end
	state.buckets.other = { total = 0, samples = {} }
	state.order[#state.order + 1] = "other"
	return state
end

---Restores every wrapped function that still holds the probe's wrapper (a spec switch reassigns RefreshLookupData).
---@param state table
local function UninstallProbeSections(state)
	state.inTick = false
	for _, entry in ipairs(state.installed) do
		if rawget(entry.owner, entry.key) == entry.wrapper then
			entry.owner[entry.key] = entry.original
		end
	end
end

---Prints the per-tick section breakdown, largest first.
---@param state table
---@param ticks integer
local function PrintProbeSections(state, ticks)
	if ticks == 0 then
		return
	end
	local rows = {}
	local sum = 0
	for _, section in ipairs(state.order) do
		local bucket = state.buckets[section]
		-- A section the spec never calls only lengthens the line.
		if bucket.total ~= 0 then
			rows[#rows + 1] = { section = section, avg = bucket.total / ticks, samples = bucket.samples }
			sum = sum + bucket.total / ticks
		end
	end
	table.sort(rows, function(a, b) return a.avg > b.avg end)
	local parts = {}
	for _, row in ipairs(rows) do
		table.sort(row.samples)
		local p95 = row.samples[math.ceil(#row.samples * 0.95)] or 0
		local calls = state.sectionCalls[row.section]
		local callsText = calls ~= nil and string.format(" %.1f/tick", calls / ticks) or ""
		parts[#parts + 1] = string.format("%s avg %.3fms (%d%%) p95 %.3fms%s", row.section, row.avg, sum > 0 and math.floor(row.avg / sum * 100 + 0.5) or 0, p95, callsText)
	end
	print(string.format("|cFF00FF00TRB TickCost sections:|r %.1f wrapped calls per tick | %s", state.calls / ticks, table.concat(parts, " | ")))
end

-- Script timing: a run finds this addon's frames by creation site and times their OnEvent (per event) and
-- OnUpdate handlers, beside the profiler's per-frame total for the whole addon.
local probeScriptTypes = { "OnEvent", "OnUpdate" }
local probeSampler = nil

---Returns "File.lua:line" for a region created by this addon, or nil.
---@param region table
---@return string?
local function ProbeSourceLabel(region)
	if type(region.GetSourceLocation) ~= "function" then
		return nil
	end
	local ok, location = pcall(region.GetSourceLocation, region)
	if not ok or type(location) ~= "string" or issecretvalue(location) then
		return nil
	end
	local path = string.match(location, addonName .. "[/\\](.+)$")
	if path == nil then
		return nil
	end
	return string.match(path, "([^/\\]+)$") or path
end

---Wraps one frame script so each call charges its time to a bucket keyed by creation site and event.
---@param state table
---@param frame table
---@param scriptType string
---@param label string
local function WrapProbeScript(state, frame, scriptType, label)
	local original = frame:GetScript(scriptType)
	if original == nil then
		return
	end
	local isEvent = scriptType == "OnEvent"
	local byKey = {}
	local function Record(key, started, ...)
		local elapsed = debugprofilestop() - started
		local bucket = byKey[key]
		if bucket == nil then
			bucket = { label = isEvent and (label .. " " .. key) or (label .. " OnUpdate"), count = 0, total = 0, max = 0, samples = {} }
			byKey[key] = bucket
			state.buckets[#state.buckets + 1] = bucket
		end
		bucket.count = bucket.count + 1
		bucket.total = bucket.total + elapsed
		bucket.samples[bucket.count] = elapsed
		if elapsed > bucket.max then
			bucket.max = elapsed
		end
		return ...
	end
	local wrapper = function(self, eventOrElapsed, ...)
		return Record(isEvent and eventOrElapsed or 1, debugprofilestop(), original(self, eventOrElapsed, ...))
	end
	frame:SetScript(scriptType, wrapper)
	if frame == TRB.Frames.timerFrame and not isEvent then
		state.timerBuckets = byKey
	end
	state.installed[#state.installed + 1] = { frame = frame, scriptType = scriptType, original = original, wrapper = wrapper }
end

---Wraps every script on this addon's frames and starts the per-frame addon total.
---@return table state
local function InstallProbeScripts()
	local state = { buckets = {}, installed = {}, frames = 0, addonTotal = 0, renderFrames = 0, profiler = false }
	local frame = EnumerateFrames()
	while frame ~= nil do
		local label = not frame:IsForbidden() and ProbeSourceLabel(frame) or nil
		if label ~= nil then
			state.frames = state.frames + 1
			for _, scriptType in ipairs(probeScriptTypes) do
				if frame:HasScript(scriptType) then
					WrapProbeScript(state, frame, scriptType, label)
				end
			end
		end
		frame = EnumerateFrames(frame)
	end

	local profiler = C_AddOnProfiler
	if profiler ~= nil and profiler.IsEnabled() then
		state.profiler = true
		local lastTime = Enum.AddOnProfilerMetric.LastTime
		-- Each frame reads the previous frame's finished total; this sampler's own cost lands in it too.
		probeSampler = probeSampler or CreateFrame("Frame")
		probeSampler:SetScript("OnUpdate", function()
			state.renderFrames = state.renderFrames + 1
			state.addonTotal = state.addonTotal + profiler.GetAddOnMetric(addonName, lastTime)
		end)
		probeSampler:Show()
	end
	return state
end

---Restores every script still holding its wrapper and stops the sampler.
---@param state table
local function UninstallProbeScripts(state)
	if state.profiler and probeSampler ~= nil then
		probeSampler:SetScript("OnUpdate", nil)
		probeSampler:Hide()
	end
	for _, entry in ipairs(state.installed) do
		if entry.frame:GetScript(entry.scriptType) == entry.wrapper then
			entry.frame:SetScript(entry.scriptType, entry.original)
		end
	end
end

---Prints the addon's per-second cost split into the tick, timed scripts, and the rest, then the top scripts.
---@param state table
---@param seconds number
---@param tickTotal number # Milliseconds spent in ticks during the run
local function PrintProbeScripts(state, seconds, tickTotal)
	if seconds <= 0 then
		return
	end
	local scriptTotal = 0
	local calls = 0
	for _, bucket in ipairs(state.buckets) do
		scriptTotal = scriptTotal + bucket.total
		calls = calls + bucket.count
	end
	-- The tick runs inside the timer frame's OnUpdate, so only the tick time that script saw leaves its total.
	local timerBucket = state.timerBuckets ~= nil and state.timerBuckets[1] or nil
	local tickInScripts = timerBucket ~= nil and math.min(timerBucket.total, tickTotal) or 0
	local outsideTick = scriptTotal - tickInScripts
	local head
	if state.profiler then
		head = string.format("addon %.2fms/s (%.0f fps, %.3fms/frame) | tick %.2fms/s | scripts outside tick %.2fms/s | untimed %.2fms/s",
			state.addonTotal / seconds, state.renderFrames / seconds, state.renderFrames > 0 and state.addonTotal / state.renderFrames or 0,
			tickTotal / seconds, outsideTick / seconds, (state.addonTotal - outsideTick - tickTotal) / seconds)
	else
		head = string.format("profiler off | tick %.2fms/s | scripts outside tick %.2fms/s", tickTotal / seconds, outsideTick / seconds)
	end
	table.sort(state.buckets, function(a, b) return a.total > b.total end)
	local parts = {}
	for i = 1, math.min(14, #state.buckets) do
		local bucket = state.buckets[i]
		-- A throttled updater's p50 is its between-tick frame and its p90 the throttle frame.
		table.sort(bucket.samples)
		local p50 = bucket.samples[math.ceil(bucket.count * 0.5)] or 0
		local p90 = bucket.samples[math.ceil(bucket.count * 0.9)] or 0
		parts[#parts + 1] = string.format("%s %.3fms/s %.1f/s avg %.1fus p50 %.1fus p90 %.1fus max %.2fms", bucket.label, bucket.total / seconds,
			bucket.count / seconds, bucket.total / bucket.count * 1000, p50 * 1000, p90 * 1000, bucket.max)
	end
	print(string.format("|cFF00FF00TRB TickCost scripts:|r %d frames, %d scripts%s, %.0f calls/s | %s",
		state.frames, #state.installed, state.timerBuckets ~= nil and "" or " (timer frame not found)", calls / seconds, head))
	print("|cFF00FF00TRB TickCost top scripts:|r " .. table.concat(parts, " | "))
end

---Times common operations in this client, so a change can be judged by the calls it removes. Prints ns per call.
function TRB.Frames.timerFrame:RunCostCalibration()
	local iterations = 20000
	local frame = self.calibrationFrame
	if frame == nil then
		frame = CreateFrame("Frame", nil, UIParent)
		frame:SetSize(100, 20)
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
		frame.font = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.font:SetPoint("CENTER")
		frame.texture = frame:CreateTexture(nil, "OVERLAY")
		frame.texture:SetAllPoints(frame)
		self.calibrationFrame = frame
	end
	-- Shown at zero alpha so text and texture writes cost what a visible bar's would.
	frame:SetAlpha(0)
	frame:Show()
	local curve = C_CurveUtil.CreateColorCurve()
	curve:SetType(Enum.LuaCurveType.Step)
	curve:AddPoint(0, CreateColor(1, 0, 0, 1))
	curve:AddPoint(0.5, CreateColor(0, 1, 0, 1))
	local powerType = TRB.Data.resource or 0
	local level = frame:GetFrameLevel()
	local holder = { value = 1 }
	local font, texture = frame.font, frame.texture
	local function Noop() end
	local function Time(fn)
		local started = debugprofilestop()
		fn(iterations)
		return debugprofilestop() - started
	end
	local baseline = Time(function(n) for _ = 1, n do end end)
	local ops = {
		{ "Lua call", function(n) for _ = 1, n do Noop() end end },
		{ "table read", function(n) local x for _ = 1, n do x = holder.value end return x end },
		{ "string.format", function(n) local s for _ = 1, n do s = string.format("%d", 5) end return s end },
		{ "pcall", function(n) for _ = 1, n do pcall(Noop) end end },
		{ "issecretvalue", function(n) for _ = 1, n do issecretvalue(1) end end },
		{ "debugprofilestop", function(n) for _ = 1, n do debugprofilestop() end end },
		{ "GetTime", function(n) for _ = 1, n do GetTime() end end },
		{ "GetFrameLevel", function(n) for _ = 1, n do frame:GetFrameLevel() end end },
		{ "SetFrameLevel same", function(n) for _ = 1, n do frame:SetFrameLevel(level) end end },
		{ "GetWidth", function(n) for _ = 1, n do frame:GetWidth() end end },
		{ "SetText same", function(n) for _ = 1, n do font:SetText("123") end end },
		{ "SetText changing", function(n) for i = 1, n do font:SetText(i % 2 == 0 and "123" or "124") end end },
		{ "SetVertexColor", function(n) for _ = 1, n do texture:SetVertexColor(1, 1, 1, 1) end end },
		{ "SetColorTexture", function(n) for _ = 1, n do texture:SetColorTexture(1, 1, 1, 1) end end },
		{ "UnitPower", function(n) for _ = 1, n do UnitPower("player", powerType) end end },
		{ "UnitPowerPercent curve", function(n) for _ = 1, n do UnitPowerPercent("player", powerType, true, curve) end end },
	}
	local parts = {}
	for _, op in ipairs(ops) do
		local ok, elapsed = pcall(Time, op[2])
		if ok then
			parts[#parts + 1] = string.format("%s %d", op[1], math.floor((elapsed - baseline) / iterations * 1000000 + 0.5))
		else
			parts[#parts + 1] = op[1] .. " error"
		end
	end
	frame:Hide()
	print("|cFF00FF00TRB TickCost calibrate (ns per call):|r " .. table.concat(parts, " | "))
end

-- Power event tokens by Enum.PowerType key, for matching UNIT_POWER_FREQUENT payloads to UnitPower reads.
local powerCheckTokens = {
	Mana = "MANA", Rage = "RAGE", Focus = "FOCUS", Energy = "ENERGY", ComboPoints = "COMBO_POINTS",
	Runes = "RUNES", RunicPower = "RUNIC_POWER", SoulShards = "SOUL_SHARDS", LunarPower = "LUNAR_POWER",
	HolyPower = "HOLY_POWER", Maelstrom = "MAELSTROM", Chi = "CHI", Insanity = "INSANITY",
	ArcaneCharges = "ARCANE_CHARGES", Fury = "FURY", Pain = "PAIN", Essence = "ESSENCE",
}

---Answers two questions a curve-evaluation memo depends on: does UnitPower change without a power event
---between frames, and does UnitPowerPercent return a new color object per call? Plain values only exist out of combat.
---@param seconds number
function TRB.Frames.timerFrame:RunPowerCheck(seconds)
	local frame = self.powerCheckFrame
	if frame == nil then
		frame = CreateFrame("Frame")
		self.powerCheckFrame = frame
	end
	if frame.running then
		print("|cFFFF8800TRB PowerCheck:|r Already running.")
		return
	end

	local tracked = {}
	for key, token in pairs(powerCheckTokens) do
		local powerType = Enum.PowerType[key]
		if powerType ~= nil then
			local max = UnitPowerMax("player", powerType)
			if not issecretvalue(max) and max ~= nil and max > 0 then
				tracked[#tracked + 1] = { key = key, token = token, powerType = powerType, changes = 0, unevented = 0, evented = false }
			end
		end
	end
	-- Health rides the same check: its curves would share the memo, keyed on UNIT_HEALTH instead.
	tracked[#tracked + 1] = { key = "Health", token = "HEALTH", changes = 0, unevented = 0, evented = false }
	local byToken = {}
	for _, entry in ipairs(tracked) do
		byToken[entry.token] = entry
	end

	-- Same-frame identity: a reused result object would make a stored result change under a later evaluation.
	local identity = "untested"
	if tracked[1].powerType ~= nil then
		local powerType = tracked[1].powerType
		local curveA = C_CurveUtil.CreateColorCurve()
		curveA:SetType(Enum.LuaCurveType.Step)
		curveA:AddPoint(0, CreateColor(1, 0, 0, 1))
		local curveB = C_CurveUtil.CreateColorCurve()
		curveB:SetType(Enum.LuaCurveType.Step)
		curveB:AddPoint(0, CreateColor(0, 1, 0, 1))
		local first = UnitPowerPercent("player", powerType, true, curveA)
		local second = UnitPowerPercent("player", powerType, true, curveB)
		local again = UnitPowerPercent("player", powerType, true, curveA)
		identity = string.format("%s results, other curve %s, same curve again %s", type(first),
			rawequal(first, second) and "SAME object" or "new object", rawequal(first, again) and "SAME object" or "new object")
	end

	local frames, combatFrames, secretSamples = 0, 0, 0
	local last = {}
	frame.running = true
	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	frame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	frame:RegisterUnitEvent("UNIT_HEALTH", "player")
	frame:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
	frame:SetScript("OnEvent", function(_, event, _, token)
		local entry = byToken[(event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH") and "HEALTH" or token]
		if entry ~= nil then
			entry.evented = true
		end
	end)
	frame:SetScript("OnUpdate", function()
		frames = frames + 1
		if InCombatLockdown() then
			combatFrames = combatFrames + 1
		end
		for _, entry in ipairs(tracked) do
			local value = entry.powerType ~= nil and UnitPower("player", entry.powerType) or UnitHealth("player")
			if issecretvalue(value) then
				secretSamples = secretSamples + 1
				last[entry.key] = nil
			else
				local previous = last[entry.key]
				if previous ~= nil and previous ~= value then
					entry.changes = entry.changes + 1
					if not entry.evented then
						entry.unevented = entry.unevented + 1
					end
				end
				last[entry.key] = value
			end
			entry.evented = false
		end
	end)
	print(string.format("|cFF00FF00TRB PowerCheck:|r Watching %d power types and health for %ds.", #tracked - 1, seconds))
	C_Timer.After(seconds, function()
		frame:UnregisterAllEvents()
		frame:SetScript("OnEvent", nil)
		frame:SetScript("OnUpdate", nil)
		frame.running = false
		local parts = {}
		for _, entry in ipairs(tracked) do
			parts[#parts + 1] = string.format("%s %d changes, %d without an event", entry.token, entry.changes, entry.unevented)
		end
		print(string.format("|cFF00FF00TRB PowerCheck:|r %ds, %d frames (%d in combat, %d secret reads) | %s | UnitPowerPercent: %s",
			seconds, frames, combatFrames, secretSamples, table.concat(parts, " | "), identity))
	end)
end

---Prints the run's one-line summary and stops the probe.
---@param reason string
function TRB.Frames.timerFrame:FinishCostProbe(reason)
	local probe = self.costProbe
	if probe == nil then
		return
	end
	self.costProbe = nil
	UninstallProbeSections(probe.sections)
	UninstallProbeScripts(probe.scripts)

	local parts = {}
	for _, key in ipairs(probe.timeOrder) do
		local bucket = probe.times[key]
		table.sort(bucket.samples)
		local p95 = bucket.samples[math.ceil(bucket.count * 0.95)]
		parts[#parts + 1] = string.format("%s %d x avg %.3fms p95 %.3fms max %.3fms", key, bucket.count, bucket.total / bucket.count, p95, bucket.max)
	end
	if #parts == 0 then
		parts[1] = "tick 0"
	end
	for _, key in ipairs(probe.countOrder) do
		parts[#parts + 1] = string.format("%s %d", key, probe.counts[key])
	end
	local tickCount = probe.times.tick and probe.times.tick.count or 0
	if tickCount > 0 then
		parts[#parts + 1] = string.format("curve memo %.1f hits / %.1f evaluations per tick",
			(TRB.Functions.CurveMemo.hits - probe.curveHits) / tickCount, (TRB.Functions.CurveMemo.misses - probe.curveMisses) / tickCount)
	end
	print(string.format("|cFF00FF00TRB TickCost:|r %.1fs (%s), %d/%d ticks in combat | %s",
		GetTime() - probe.started, reason, probe.combatTicks, probe.times.tick and probe.times.tick.count or 0,
		table.concat(parts, " | ")))
	PrintProbeSections(probe.sections, probe.times.tick and probe.times.tick.count or 0)
	PrintProbeScripts(probe.scripts, GetTime() - probe.started, probe.times.tick and probe.times.tick.total or 0)
end

---Starts a run that reports after the given number of seconds, replacing any run in progress.
---@param seconds number
function TRB.Frames.timerFrame:StartCostProbe(seconds)
	if self.costProbe ~= nil then
		self:FinishCostProbe("replaced")
	end
	local probe = {
		started = GetTime(),
		combatTicks = 0,
		times = {},
		timeOrder = {},
		counts = {},
		countOrder = {},
		sections = InstallProbeSections(),
		scripts = InstallProbeScripts(),
		curveHits = TRB.Functions.CurveMemo.hits,
		curveMisses = TRB.Functions.CurveMemo.misses,
	}
	self.costProbe = probe
	print(string.format("|cFF00FF00TRB TickCost:|r Measuring for %ds.", seconds))
	C_Timer.After(seconds, function()
		-- A stop or a newer run already replaced this one.
		if self.costProbe == probe then
			self:FinishCostProbe("done")
		end
	end)
end

function TRB.Frames.timerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.characterCheckSinceLastUpdate  = self.characterCheckSinceLastUpdate  + sinceLastUpdate

	if self.sinceLastUpdate >= 0.05 then -- in seconds
		local costProbe = self.costProbe
		local costProbeStart = costProbe ~= nil and debugprofilestop() or 0
		local sections = costProbe ~= nil and costProbe.sections or nil
		if sections ~= nil then
			-- A section that errored mid-call left the depth raised, so every tick starts from zero.
			sections.depth = 0
			for section in pairs(sections.tick) do
				sections.tick[section] = 0
			end
			sections.inTick = true
		end

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

		-- The tick can stop or replace the run itself, so only record into the run it started under.
		if sections ~= nil then
			sections.inTick = false
		end
		if costProbe ~= nil and self.costProbe == costProbe then
			local tickElapsed = debugprofilestop() - costProbeStart
			self:ProbeTime("tick", tickElapsed)
			if TRB.Data.character.inCombat then
				costProbe.combatTicks = costProbe.combatTicks + 1
			end
			local runSections = costProbe.sections
			local other = tickElapsed
			for section, elapsed in pairs(runSections.tick) do
				local bucket = runSections.buckets[section]
				bucket.total = bucket.total + elapsed
				bucket.samples[#bucket.samples + 1] = elapsed
				other = other - elapsed
			end
			local otherBucket = runSections.buckets.other
			otherBucket.total = otherBucket.total + other
			otherBucket.samples[#otherBucket.samples + 1] = other
		end
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
		local sig = slot and slot._endCapAnchorSig
		print(sig == nil and "  sig=nil" or string.format("  sig=%s|%s|%s|%s|%s|%s|%s|%s", tostring(sig.border), tostring(sig.width),
			tostring(sig.height), tostring(sig.fillDirection), tostring(sig.fullHeight), tostring(sig.fillTexture),
			tostring(sig.endCapWidth), tostring(sig.overshoot)))
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
	elseif cmd == "otherbars" then
		TRB.Functions.OtherBars:PrintDiagnostics()
	elseif cmd == "bars" then
		TRB.Functions.Bar:PrintDiagnostics()
	elseif cmd == "castname" then
		TRB.Functions.Castbar:ToggleCastNameEcho()
	elseif cmd == "tickcost" then
		local probeArg = ParseCmdString(subcmd)
		local seconds = tonumber(probeArg)
		if probeArg == "stop" then
			if TRB.Frames.timerFrame.costProbe == nil then
				print("|cFFFF8800TRB TickCost:|r Not running.")
			else
				TRB.Frames.timerFrame:FinishCostProbe("stopped")
			end
		elseif probeArg == "calibrate" then
			TRB.Frames.timerFrame:RunCostCalibration()
		elseif probeArg == "powercheck" then
			TRB.Frames.timerFrame:RunPowerCheck(15)
		elseif probeArg == nil or probeArg == "" then
			TRB.Frames.timerFrame:StartCostProbe(130)
		elseif seconds ~= nil and seconds >= 1 and seconds <= 600 then
			TRB.Frames.timerFrame:StartCostProbe(seconds)
		else
			print("|cFFFF8800TRB TickCost:|r Unknown argument '" .. probeArg .. "'. Usage: /trb tickcost [seconds 1-600|stop|calibrate|powercheck]")
		end
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
