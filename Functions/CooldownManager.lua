---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.CooldownManager = {}

local CDM = TRB.Functions.CooldownManager

---Signals that can be read for a tracked spell.
---@enum TRB.CdmSignal
CDM.Signal = {
	-- Only meaningful on the buff viewers, which override it with real expiry logic. On the icon
	-- viewers it is just "this item has a cooldownID assigned" and is always true, so it must not
	-- be used as a buff-is-up test there. IsLive() picks the right source per kind.
	ACTIVE = "active",
	-- Numeric remaining/total. BuffBar only: it is the one viewer where Blizzard subtracts
	-- expiration from now every frame and leaves the result on the status bar.
	REMAINING = "remaining",
	DURATION = "duration",
	-- Aura or spell cooldown span held on an item's Cooldown frame. Available on the icon viewers,
	-- which is where actively-cast spells and their target auras live. Both halves are secret in
	-- combat and cannot be subtracted, so these drive nothing on their own -- use REMAINING_TEXT.
	COOLDOWN_START = "cooldownStart",
	COOLDOWN_DURATION = "cooldownDuration",
	-- Display-ready remaining time. The one signal that yields a usable countdown for the icon
	-- viewers, because Blizzard has already formatted it into a font string for us.
	REMAINING_TEXT = "remainingText",
	STACKS = "stacks",
	CHARGES = "charges",
	-- Straight off the item's cached aura record rather than a widget. STACKS is the display string
	-- and is blank below two applications; APPLICATIONS is the raw number and is present whenever
	-- the aura is. Spells that pack a payload into that count -- Ignore Pain's absorb pool -- are
	-- read here. POINT_n would be the aura's effect values, but they have never once resolved on
	-- the PTR: `points` does not survive being read off the cached record. Kept because `/trb cdm`
	-- probes them, so the day they start answering is visible rather than guessed at.
	APPLICATIONS = "applications",
	POINT_1 = "point1",
	POINT_2 = "point2",
	POINT_3 = "point3",
}

---POINT_n signal to its index in the aura record's `points` array.
local pointSignalIndex = {
	[CDM.Signal.POINT_1] = 1,
	[CDM.Signal.POINT_2] = 2,
	[CDM.Signal.POINT_3] = 3,
}

-- Reads that are expected to fail for most spells: the cached aura record is absent whenever the
-- buff is down, and which effect values it carries varies per spell. A failure here means "this
-- spell has no such data", not "this frame is broken", so it must not cost the frame its other
-- signals the way a widget error does.
local nonQuarantiningSignals = {
	[CDM.Signal.APPLICATIONS] = true,
	[CDM.Signal.POINT_1] = true,
	[CDM.Signal.POINT_2] = true,
	[CDM.Signal.POINT_3] = true,
}

---Which viewer an item frame came from. Only BUFF_BAR yields a live remaining value.
---@enum TRB.CdmSourceKind
CDM.SourceKind = {
	BUFF_BAR = "buffBar",
	BUFF_ICON = "buffIcon",
	ESSENTIAL = "essential",
	UTILITY = "utility",
}

---Which half of the Cooldown Manager to read from. The same spell can sit in a cooldown viewer and
---a buff viewer at once, holding different things in each: the cooldown viewers describe the cast
---(cooldown, charges) while the buff viewers describe the resulting aura (expiry, stacks). Anywhere
---a source may be named, a `TRB.CdmSourceKind` is accepted just as readily for pinning one viewer.
---@enum TRB.CdmSourceGroup
CDM.SourceGroup = {
	ANY = "any",
	BUFF = "buff",
	COOLDOWN = "cooldown",
}

local groupKinds = {
	[CDM.SourceGroup.BUFF] = {
		[CDM.SourceKind.BUFF_BAR] = true,
		[CDM.SourceKind.BUFF_ICON] = true,
	},
	[CDM.SourceGroup.COOLDOWN] = {
		[CDM.SourceKind.ESSENTIAL] = true,
		[CDM.SourceKind.UTILITY] = true,
	},
}

---@param entry table
---@param selector TRB.CdmSourceGroup|TRB.CdmSourceKind
---@return boolean
local function MatchesSelector(entry, selector)
	if selector == CDM.SourceGroup.ANY or entry.kind == selector then
		return true
	end
	local kinds = groupKinds[selector]
	return kinds ~= nil and kinds[entry.kind] == true
end

-- Index order, and therefore the order an unpinned read considers sources in. The buff viewers come
-- first deliberately: they track real aura expiry, whereas a cooldown viewer reports every spell it
-- holds as active whether or not the buff is up.
local viewerDefinitions = {
	{ globalName = "BuffBarCooldownViewer", kind = CDM.SourceKind.BUFF_BAR },
	{ globalName = "BuffIconCooldownViewer", kind = CDM.SourceKind.BUFF_ICON },
	{ globalName = "EssentialCooldownViewer", kind = CDM.SourceKind.ESSENTIAL },
	{ globalName = "UtilityCooldownViewer", kind = CDM.SourceKind.UTILITY },
}

-- spellId -> array of { frame, kind, viewer }, in viewerDefinitions order. A spell placed in both
-- halves of the Cooldown Manager gets an entry per viewer rather than the last one winning.
local sources = {}
local indexDirty = true
local indexBuiltAt = nil

-- frame -> plain spell IDs it last indexed under. Spell IDs go secret in combat and AddSource drops
-- those, so without this a rebuild landing mid-combat loses the frame until the next one.
local frameSpellIds = {}

-- Usable state per viewerDefinitions index, as of the last rebuild. An unusable viewer is skipped by
-- RebuildIndex outright, so one appearing or disappearing changes what the index holds without any
-- event announcing it -- the "only in combat" visibility setting flips it on every pull, and the
-- master CVar flips all four at once. Polled rather than subscribed, at most once per frame.
local viewerShown = {}
local shownCheckedAt = nil

-- Time each viewer was last seen shown, stamped by every usability check. Survives rebuilds, since
-- it is the only record of when the grace period below started.
local viewerLastShown = {}

---True while a viewer is worth indexing: shown now, or hidden within the user's grace period. A
---viewer that hides -- dropping combat with "only in combat" set is the common case -- takes every
---value it carries with it, so without the grace those flicker to unknown and straight back.
---@param index integer
---@param viewer table?
---@param now number
---@return boolean
local function IsViewerUsable(index, viewer, now)
	if viewer ~= nil and viewer:IsShown() then
		viewerLastShown[index] = now
		return true
	end

	local lastShown = viewerLastShown[index]
	local grace = TRB.Data.settings.core.cooldownManagerGracePeriod
	return lastShown ~= nil and grace > 0 and (now - lastShown) < grace
end

---@return boolean
local function ShownStateChanged()
	local now = GetTime()
	if shownCheckedAt == now then
		return false
	end
	shownCheckedAt = now

	for index, definition in ipairs(viewerDefinitions) do
		if IsViewerUsable(index, _G[definition.globalName], now) ~= viewerShown[index] then
			return true
		end
	end

	return false
end

-- Per-frame memo, one record per signal *per selector*, each keyed by spellId. The selector is part
-- of the key because the same spellId and signal legitimately answer differently depending on which
-- viewer the read resolved to. Freshness is a GetTime() stamp rather than a wipe, so a hit is a few
-- table lookups and neither path allocates.
---@class TRB.CdmSignalCache
---@field stamp table<integer, number>
---@field ok table<integer, boolean>
---@field value table<integer, any>
---@field secret table<integer, boolean>

---@type table<string, table<string, TRB.CdmSignalCache>>
local caches = {}

---@param signal TRB.CdmSignal
---@param selector TRB.CdmSourceGroup|TRB.CdmSourceKind
---@return TRB.CdmSignalCache
local function GetCache(signal, selector)
	local bySelector = caches[signal]
	if bySelector == nil then
		bySelector = {}
		caches[signal] = bySelector
	end
	local cache = bySelector[selector]
	if cache == nil then
		cache = { stamp = {}, ok = {}, value = {}, secret = {} }
		bySelector[selector] = cache
	end
	return cache
end

-- A source that throws is dropped, because an error raised inside bar text processing is far worse
-- than a missing value. Keyed by frame, and item frames are pooled and reassigned to different
-- cooldownIDs, so this must be cleared whenever the index is rebuilt or a frame that failed once
-- would stay silently dead after being recycled for an unrelated spell.
local quarantined = {}

---Drops every cached read and the quarantine list. Called on index rebuilds and from the addon's
---established force-purge so CDM state cannot outlive a spec or talent change.
function CDM:ResetCaches()
	wipe(caches)
	wipe(quarantined)
end

---True when the Cooldown Manager addon is loaded and its frames exist.
---@return boolean
function CDM:IsAvailable()
	if C_CooldownViewer == nil or C_CooldownViewer.GetCooldownViewerCooldownInfo == nil then
		return false
	end
	return _G["BuffBarCooldownViewer"] ~= nil
end

---Appends an entry to a spell's source list, ignoring a repeat of a frame already listed -- a
---spell whose live and base IDs are the same must not be indexed against itself twice.
---@param spellId any # Rejected unless plain; secret and nil IDs cannot key the index
---@param entry table
---@param recorded table? # Collects the plain IDs accepted for this frame during this rebuild
local function AddSource(spellId, entry, recorded)
	if not TRB.Functions.Number:IsPlainNumber(spellId) then
		return
	end

	local entries = sources[spellId]
	if entries == nil then
		entries = {}
		sources[spellId] = entries
	end

	for _, existing in ipairs(entries) do
		if existing.frame == entry.frame then
			return
		end
	end

	entries[#entries + 1] = entry
	if recorded ~= nil then
		recorded[#recorded + 1] = spellId
	end
end

---Indexes the extra spell IDs an entry declares. An aura is often a different spell from the ability
---applying it (Coagulating Blood rides on Death Strike), reachable only through linkedSpellIDs.
---@param frame table
---@param entry table
---@param recorded table? # Collects the plain IDs accepted for this frame during this rebuild
---@return boolean # True when the entry's metadata was reachable, so the linked IDs are complete
local function IndexLinkedSpellIds(frame, entry, recorded)
	if C_CooldownViewer == nil or C_CooldownViewer.GetCooldownViewerCooldownInfo == nil
		or frame.GetCooldownID == nil then
		return false
	end

	local okId, cooldownID = pcall(frame.GetCooldownID, frame)
	if not okId or not TRB.Functions.Number:IsPlainNumber(cooldownID) then
		return false
	end

	local okInfo, info = pcall(C_CooldownViewer.GetCooldownViewerCooldownInfo, cooldownID)
	if not okInfo or type(info) ~= "table" then
		return false
	end

	AddSource(info.overrideSpellID, entry, recorded)

	if type(info.linkedSpellIDs) == "table" then
		for _, linkedSpellId in ipairs(info.linkedSpellIDs) do
			AddSource(linkedSpellId, entry, recorded)
		end
	end

	return true
end

---Indexes a spell against an item frame. Both the live and base spell IDs are recorded so a
---talent-overridden spell still resolves from whichever ID the spec data uses, plus every ID the
---entry's metadata links to it.
---@param frame table
---@param kind TRB.CdmSourceKind
---@param viewer table
local function IndexItemFrame(frame, kind, viewer)
	local entry = { frame = frame, kind = kind, viewer = viewer }
	local recorded = {}

	local okLive, liveSpellId = pcall(frame.GetSpellID, frame)
	if okLive then
		AddSource(liveSpellId, entry, recorded)
	end

	local okBase, baseSpellId = pcall(frame.GetBaseSpellID, frame)
	if okBase then
		AddSource(baseSpellId, entry, recorded)
	end

	local metadataResolved = IndexLinkedSpellIds(frame, entry, recorded)

	-- A complete read is authoritative, and replacing is how a recycled frame corrects itself.
	if metadataResolved and #recorded > 0 then
		frameSpellIds[frame] = recorded
		return
	end

	-- Partial read: what's missing is the linked aura IDs, so union with the remembered set instead
	-- of replacing. AddSource dedupes by frame, so `recorded` ends up holding the union.
	local known = frameSpellIds[frame]
	if known ~= nil then
		for _, spellId in ipairs(known) do
			AddSource(spellId, entry, recorded)
		end
	end

	if #recorded > 0 then
		frameSpellIds[frame] = recorded
	end
end

---Walks every viewer and rebuilds the spellId index. Read-only by design: nothing here calls a
---setter or a refresh method, which would run Blizzard's code under our taint and error.
function CDM:RebuildIndex()
	wipe(sources)
	wipe(viewerShown)
	-- A rebuild means frame->spell assignments may have changed, so every memoized read and
	-- quarantine verdict from the old mapping is void.
	self:ResetCaches()
	indexDirty = false
	indexBuiltAt = GetTime()
	shownCheckedAt = indexBuiltAt

	-- Recorded ahead of the availability guard so an unavailable Cooldown Manager leaves a settled
	-- state of "nothing shown" rather than an empty table the poll would read as a change every frame.
	local available = self:IsAvailable()
	for index, definition in ipairs(viewerDefinitions) do
		viewerShown[index] = IsViewerUsable(index, _G[definition.globalName], indexBuiltAt)
	end

	if not available then
		return
	end

	for index, definition in ipairs(viewerDefinitions) do
		local viewer = _G[definition.globalName]
		-- A hidden viewer has unregistered its events and is serving stale data, which is exactly
		-- what the grace period trades for: frozen values beat values that vanish and return.
		if viewerShown[index] and viewer.GetItemFrames ~= nil then
			local ok, itemFrames = pcall(viewer.GetItemFrames, viewer)
			if ok and type(itemFrames) == "table" then
				for _, frame in ipairs(itemFrames) do
					if frame ~= nil and frame.GetSpellID ~= nil and not quarantined[frame] then
						IndexItemFrame(frame, definition.kind, viewer)
					end
				end
			end
		end
	end
end

---Marks the index stale; the next read rebuilds it.
function CDM:MarkIndexDirty()
	indexDirty = true
end

---The single funnel for spellId: every public read reaches the index through here, so this is
---where a caller passing a nil or secret ID is turned away rather than indexing `sources` with it.
---With no selector the first matching source wins, which is the buff viewers where a spell is in
---both -- name a group or a kind to pin the read to the half of the Cooldown Manager you want.
---@param spellId integer
---@param selector TRB.CdmSourceGroup|TRB.CdmSourceKind|nil # Defaults to ANY
---@return table? entry
local function GetSource(spellId, selector)
	if not TRB.Functions.Number:IsPlainNumber(spellId) then
		return nil
	end
	if indexDirty or ShownStateChanged() then
		CDM:RebuildIndex()
	end

	local entries = sources[spellId]
	if entries == nil then
		return nil
	end

	selector = selector or CDM.SourceGroup.ANY
	for _, entry in ipairs(entries) do
		if not quarantined[entry.frame] and MatchesSelector(entry, selector) then
			return entry
		end
	end

	return nil
end

---True when this spell is present in one of the user's visible viewers. Always a plain boolean,
---so it is safe for conditional logic and for deciding whether a variable renders at all.
---@param spellId integer
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean
function CDM:IsTracked(spellId, source)
	return GetSource(spellId, source) ~= nil
end

---Picks the first of several candidate spell IDs the user actually has placed in a viewer. A talent
---and the buff it applies are separate IDs, and which one an item answers to depends on how that
---Cooldown Manager entry was configured, so callers offer every ID the spec data knows and take
---whichever resolves.
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@param ... integer|nil # Candidate spell IDs, in preference order; nils are skipped
---@return integer? # nil when none of them are tracked
function CDM:ResolveTrackedSpellId(source, ...)
	for index = 1, select("#", ...) do
		local spellId = select(index, ...)
		if spellId ~= nil and GetSource(spellId, source) ~= nil then
			return spellId
		end
	end
	return nil
end

---True when this spell resolves to a source that can supply a live remaining time. Pinned to the
---bar viewer, which is the only one where Blizzard leaves a subtracted remaining value behind.
---@param spellId integer
---@return boolean
function CDM:HasLiveDuration(spellId)
	return GetSource(spellId, CDM.SourceKind.BUFF_BAR) ~= nil
end

---Performs the widget read for one signal. Split out so it can be handed to pcall directly
---rather than through a per-call closure.
---@param entry table
---@param signal TRB.CdmSignal
---@return any
local function ReadSignal(entry, signal)
	local frame = entry.frame
	local kind = entry.kind

	if signal == CDM.Signal.ACTIVE then
		return frame:IsActive()
	end

	if signal == CDM.Signal.REMAINING then
		-- Only the bar viewer has Blizzard subtracting expiration from now every frame. The icon
		-- viewers expose start+duration, which we are not permitted to subtract ourselves.
		return frame.Bar:GetValue()
	end

	if signal == CDM.Signal.DURATION then
		local _, maxValue = frame.Bar:GetMinMaxValues()
		return maxValue
	end

	if signal == CDM.Signal.COOLDOWN_START then
		local startTime = frame.Cooldown:GetCooldownTimes()
		return startTime
	end

	if signal == CDM.Signal.COOLDOWN_DURATION then
		local _, cooldownDuration = frame.Cooldown:GetCooldownTimes()
		return cooldownDuration
	end

	if signal == CDM.Signal.REMAINING_TEXT then
		if kind == CDM.SourceKind.BUFF_BAR then
			return frame.Bar.Duration:GetText()
		end
		return frame.Cooldown:GetCountdownFontString():GetText()
	end

	if signal == CDM.Signal.STACKS then
		if kind == CDM.SourceKind.BUFF_BAR then
			return frame.Icon.Applications:GetText()
		end
		return frame.Applications.Applications:GetText()
	end

	if signal == CDM.Signal.CHARGES then
		return frame.ChargeCount.Current:GetText()
	end

	if signal == CDM.Signal.APPLICATIONS then
		return frame.auraDataCached.applications
	end

	local pointIndex = pointSignalIndex[signal]
	if pointIndex ~= nil then
		return frame.auraDataCached.points[pointIndex]
	end

	return nil
end

---True when this source kind can supply this signal at all.
---@param entry table
---@param signal TRB.CdmSignal
---@return boolean
local function SupportsSignal(entry, signal)
	local frame = entry.frame
	local kind = entry.kind

	if signal == CDM.Signal.ACTIVE then
		return frame.IsActive ~= nil
	end

	if signal == CDM.Signal.REMAINING or signal == CDM.Signal.DURATION then
		return kind == CDM.SourceKind.BUFF_BAR and frame.Bar ~= nil
	end

	if signal == CDM.Signal.COOLDOWN_START or signal == CDM.Signal.COOLDOWN_DURATION then
		return frame.Cooldown ~= nil
	end

	if signal == CDM.Signal.REMAINING_TEXT then
		if kind == CDM.SourceKind.BUFF_BAR then
			return frame.Bar ~= nil and frame.Bar.Duration ~= nil
		end
		-- The countdown font string only carries text while the user has timers enabled for that
		-- viewer; it exists either way, so an empty read is a settings answer, not an error.
		return frame.Cooldown ~= nil and frame.Cooldown.GetCountdownFontString ~= nil
			and frame.Cooldown:GetCountdownFontString() ~= nil
	end

	if signal == CDM.Signal.STACKS then
		if kind == CDM.SourceKind.BUFF_BAR then
			return frame.Icon ~= nil and frame.Icon.Applications ~= nil
		end
		if kind == CDM.SourceKind.BUFF_ICON then
			return frame.Applications ~= nil and frame.Applications.Applications ~= nil
		end
		return false
	end

	if signal == CDM.Signal.CHARGES then
		return frame.ChargeCount ~= nil and frame.ChargeCount.Current ~= nil
	end

	if signal == CDM.Signal.APPLICATIONS or pointSignalIndex[signal] ~= nil then
		-- Every item kind refreshes an aura instance, so this is not gated on the viewer. The record
		-- is nil while the aura is down, and may itself be a secret table; `~= nil` holds either way.
		return frame.auraDataCached ~= nil
	end

	return false
end

---Reads a signal, memoized for the current frame.
---@param spellId integer
---@param signal TRB.CdmSignal
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil # Which viewer to read from; defaults to ANY
---@return boolean ok # False means "no data"; callers must not substitute a guess
---@return any value
---@return boolean isSecret
function CDM:Read(spellId, signal, source)
	-- spellId is validated by GetSource; signal is guarded here because it keys the memo.
	if signal == nil then
		return false, nil, false
	end
	source = source or CDM.SourceGroup.ANY

	local entry = GetSource(spellId, source)
	if entry == nil then
		return false, nil, false
	end

	local cache = GetCache(signal, source)
	local now = GetTime()
	if cache.stamp[spellId] == now then
		return cache.ok[spellId], cache.value[spellId], cache.secret[spellId]
	end

	cache.stamp[spellId] = now

	if not SupportsSignal(entry, signal) then
		cache.ok[spellId] = false
		cache.value[spellId] = nil
		cache.secret[spellId] = false
		return false, nil, false
	end

	local ok, value = pcall(ReadSignal, entry, signal)
	if not ok then
		if not nonQuarantiningSignals[signal] then
			quarantined[entry.frame] = true
		end
		cache.ok[spellId] = false
		cache.value[spellId] = nil
		cache.secret[spellId] = false
		return false, nil, false
	end

	local isSecret = issecretvalue(value)
	cache.ok[spellId] = true
	cache.value[spellId] = value
	cache.secret[spellId] = isSecret
	return true, value, isSecret
end

---Returns a signal only when it is a plain (non-secret) value. Logic sinks -- the compiled
---conditional engine and indicator condition maps -- branch on what they are given, so a secret
---reaching them raises. nil means "unknowable", and callers fall back to their own event-driven
---state rather than guessing.
---@param spellId integer
---@param signal TRB.CdmSignal
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return any? # nil when unavailable or secret
function CDM:ReadPlain(spellId, signal, source)
	local ok, value, isSecret = self:Read(spellId, signal, source)
	if not ok or isSecret then
		return nil
	end
	return value
end

---True when a signal read succeeded and carried a value, false when it read as empty, nil when
---there was no data at all. Works even for secret values: `~= nil` is one of the few operations
---permitted on a secret, so this converts "there is a countdown running" into a plain boolean
---without ever observing the number behind it.
---@param spellId integer
---@param signal TRB.CdmSignal
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean? # nil only when unavailable
function CDM:HasSignal(spellId, signal, source)
	local ok, value = self:Read(spellId, signal, source)
	if not ok then
		return nil
	end
	return value ~= nil
end

---True while this spell has a countdown running -- a DoT ticking on the target for an actively
---cast spell, or a cooldown in progress. Plain boolean, safe for logic and indicator conditions.
---@param spellId integer
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean? # nil when unavailable
function CDM:HasTimer(spellId, source)
	return self:HasSignal(spellId, CDM.Signal.REMAINING_TEXT, source)
end

---Boolean form of ReadPlain, for indicator condition maps and `lookupLogic`. Reads the ok flag
---rather than testing the value, because a successful read can legitimately return nil: an item
---whose buff has never been up reports IsActive() as nil, which means "not active", not "no data".
---@param spellId integer
---@param signal TRB.CdmSignal
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean? # nil only when unavailable or secret
function CDM:ReadPlainBoolean(spellId, signal, source)
	local ok, value, isSecret = self:Read(spellId, signal, source)
	if not ok or isSecret then
		return nil
	end
	return value == true
end

---Formats a signal for display. The result may be a secret string, which is legal to hand to
---`FontString:SetText`/`SetFormattedText` and to `TRB.Data.lookup`, but must never reach logic
---or string concatenation.
---@param spellId integer
---@param signal TRB.CdmSignal
---@param format string? # Defaults to "%s"; numeric signals should pass an explicit precision
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return string? # nil when unavailable
---@return boolean isSecret
function CDM:ReadFormatted(spellId, signal, format, source)
	local ok, value = self:Read(spellId, signal, source)
	if not ok or value == nil then
		return nil, false
	end

	-- Stack and charge signals are already strings from the widget; reformatting them only risks
	-- a type mismatch against the caller's format.
	if signal == CDM.Signal.STACKS or signal == CDM.Signal.CHARGES then
		return value, issecretvalue(value)
	end

	local formatOk, formatted = pcall(string.format, format or "%s", value)
	if not formatOk then
		return nil, false
	end
	return formatted, issecretvalue(formatted)
end

---Writes a display value into the bar text lookup table. Secret-safe: lookup values are consumed
---by string.format in GetReturnText, never concatenated.
---@param lookup table
---@param key string
---@param spellId integer
---@param signal TRB.CdmSignal
---@param format string?
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean written
function CDM:FeedLookup(lookup, key, spellId, signal, format, source)
	local formatted = self:ReadFormatted(spellId, signal, format, source)
	if formatted == nil then
		return false
	end
	lookup[key] = formatted
	return true
end

---Writes a logic value into `lookupLogic` only when it is plain. Returns false when the value was
---unavailable or secret so the caller can seed its own fallback instead.
---@param lookupLogic table
---@param key string
---@param spellId integer
---@param signal TRB.CdmSignal
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean written
function CDM:FeedLogic(lookupLogic, key, spellId, signal, source)
	local value = self:ReadPlain(spellId, signal, source)
	if value == nil then
		return false
	end
	lookupLogic[key] = value
	return true
end

---Writes an indicator condition only when it is a plain boolean, matching FeedLogic's contract.
---@param conditionMap table<string, boolean>
---@param key string
---@param spellId integer
---@param signal TRB.CdmSignal
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean written
function CDM:FeedIndicatorCondition(conditionMap, key, spellId, signal, source)
	local value = self:ReadPlainBoolean(spellId, signal, source)
	if value == nil then
		return false
	end
	conditionMap[key] = value
	return true
end

---Gate for a CDM-backed bar text variable, shaped for a `specValidVars` entry: plain boolean,
---never nil. False suppresses rendering, which is the safe direction when the answer is unknowable.
---Source depends on the viewer: the buff viewers track real expiry through IsActive(), while the
---icon viewers report IsActive() as true for anything assigned, so those are gated on whether a
---countdown is actually running instead.
---@param spellId integer
---@param source TRB.CdmSourceGroup|TRB.CdmSourceKind|nil
---@return boolean
function CDM:IsLive(spellId, source)
	source = source or CDM.SourceGroup.ANY
	local entry = GetSource(spellId, source)
	if entry == nil then
		return false
	end

	-- Which test to apply follows the source the read actually resolved to, not what was asked for,
	-- since a group can land on either half.
	if entry.kind == CDM.SourceKind.BUFF_BAR or entry.kind == CDM.SourceKind.BUFF_ICON then
		local active = self:ReadPlainBoolean(spellId, CDM.Signal.ACTIVE, source)
		if active == nil then
			-- Unreadable or secret. The frame exists and Blizzard is updating it, so fall back to
			-- presence and let the caller's own event-driven state decide.
			return true
		end
		return active
	end

	local hasTimer = self:HasTimer(spellId, source)
	if hasTimer == nil then
		return true
	end
	return hasTimer
end

---Applies min/max and value to a status bar. Module-local so pcall gets a plain function.
---@param frame StatusBar
---@param duration any
---@param remaining any
local function ApplyBarValues(frame, duration, remaining)
	frame:SetMinMaxValues(0, duration)
	frame:SetValue(remaining)
end

---Drives a bar node's fill straight from the CDM. SetMinMaxValues + SetValue normalise inside the
---widget, so no arithmetic ever touches the secret.
---@param node TRB.Classes.BarNode
---@param spellId integer
---@return boolean applied
function CDM:ApplyToBarNode(node, spellId)
	-- Boundary guard only. BarNode:GetFrame() is declared to return a StatusBar, so the frame and
	-- its setters are taken on trust; the pcall covers the part that is actually uncertain, which
	-- is whether a secret survives being forwarded into the widget.
	if node == nil or not self:HasLiveDuration(spellId) then
		return false
	end

	local durationOk, duration = self:Read(spellId, CDM.Signal.DURATION, CDM.SourceKind.BUFF_BAR)
	local remainingOk, remaining = self:Read(spellId, CDM.Signal.REMAINING, CDM.SourceKind.BUFF_BAR)
	if not durationOk or not remainingOk then
		return false
	end

	return (pcall(ApplyBarValues, node:GetFrame(), duration, remaining))
end

local cdmFrame = CreateFrame("Frame")
local function InvalidateIndex()
	CDM:MarkIndexDirty()
	TRB.Data.lookupDirty = true
end
cdmFrame:SetScript("OnEvent", InvalidateIndex)

-- Fires whenever the player edits what the Cooldown Manager tracks: a spell added or removed, a
-- viewer reconfigured, a saved layout applied. Nothing in the ordinary event stream reports that,
-- which is why the index used to stay stale until a reload. Blizzard's own viewers rebuild off this
-- same callback and it dispatches synchronously, so the item frames are settled again well before
-- our next update tick reads them.
local dataChangedEvent = "CooldownViewerSettings.OnDataChanged"

---Starts watching for changes that invalidate the spellId index.
function CDM:Enable()
	cdmFrame:RegisterEvent("COOLDOWN_VIEWER_DATA_LOADED")
	cdmFrame:RegisterEvent("COOLDOWN_VIEWER_TABLE_HOTFIXED")
	cdmFrame:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
	cdmFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	cdmFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Registering an event nobody has declared yet is supported, so this does not need to wait on
	-- the Cooldown Manager loading. Callbacks are dispatched through securecallfunction, so our
	-- taint cannot follow the return path back into Blizzard's layout code.
	if EventRegistry ~= nil then
		EventRegistry:RegisterCallback(dataChangedEvent, InvalidateIndex, cdmFrame)
	end

	self:MarkIndexDirty()
end

---Stops watching and drops the index.
function CDM:Disable()
	cdmFrame:UnregisterAllEvents()
	if EventRegistry ~= nil then
		EventRegistry:UnregisterCallback(dataChangedEvent, cdmFrame)
	end
	wipe(sources)
	wipe(viewerShown)
	wipe(viewerLastShown)
	wipe(frameSpellIds)
	self:ResetCaches()
	indexDirty = true
end

local probeOrder = {
	CDM.Signal.ACTIVE,
	CDM.Signal.REMAINING,
	CDM.Signal.DURATION,
	CDM.Signal.COOLDOWN_START,
	CDM.Signal.COOLDOWN_DURATION,
	CDM.Signal.REMAINING_TEXT,
	CDM.Signal.STACKS,
	CDM.Signal.CHARGES,
	CDM.Signal.APPLICATIONS,
	CDM.Signal.POINT_1,
	CDM.Signal.POINT_2,
	CDM.Signal.POINT_3,
}

---Describes one spell ID read off an item frame, without ever observing a secret.
---@param ok boolean
---@param spellId any
---@return string
local function DescribeFrameSpellId(ok, spellId)
	if not ok then
		return "error"
	end
	if spellId == nil then
		return "nil"
	end
	if issecretvalue(spellId) then
		return "SECRET"
	end
	if not TRB.Functions.Number:IsPlainNumber(spellId) then
		return "nonPlain"
	end
	return tostring(spellId)
end

---Reports the item frames the index would NOT record. Such a frame is absent from `sources`, so the
---probe list below cannot show it -- which is what makes "it's in my layout but nothing reads it"
---unanswerable from the probes alone.
---@return table[] skipped
---@return table<string, table> counts # Per viewer: frames walked vs frames recorded
local function CollectSkippedFrames()
	local skipped = {}
	local counts = {}

	for index, definition in ipairs(viewerDefinitions) do
		local viewer = _G[definition.globalName]
		-- Unusable viewers are walked too, unlike in RebuildIndex: "0 frames" would read as empty
		-- when it means "never looked", and what a hidden viewer holds is the whole question.
		local usable = viewerShown[index] == true
		local walked, recorded = 0, 0

		if viewer ~= nil and viewer.GetItemFrames ~= nil then
			local ok, itemFrames = pcall(viewer.GetItemFrames, viewer)
			if ok and type(itemFrames) == "table" then
				for _, frame in ipairs(itemFrames) do
					if frame ~= nil and frame.GetSpellID ~= nil then
						walked = walked + 1

						local okLive, liveSpellId = pcall(frame.GetSpellID, frame)
						local okBase, baseSpellId = pcall(frame.GetBaseSpellID, frame)
						-- A secret read is no longer a skip; having no remembered identity at all is.
						local hasIdentity = frameSpellIds[frame] ~= nil

						local reason
						if not usable then
							reason = "viewerNotUsable"
						elseif quarantined[frame] == true then
							reason = "quarantined"
						elseif not hasIdentity then
							reason = "noPlainSpellId"
						end

						if reason ~= nil then
							-- Named off whichever ID is plain, falling back to the remembered identity
							-- since both reads are secret in combat.
							local nameId
							if okLive and TRB.Functions.Number:IsPlainNumber(liveSpellId) then
								nameId = liveSpellId
							elseif okBase and TRB.Functions.Number:IsPlainNumber(baseSpellId) then
								nameId = baseSpellId
							else
								local known = frameSpellIds[frame]
								nameId = known and known[1] or nil
							end
							local name = "?"
							if nameId ~= nil then
								local okName, spellName = pcall(C_Spell.GetSpellName, nameId)
								if okName and spellName ~= nil then
									name = spellName
								end
							end

							skipped[#skipped + 1] = {
								kind = definition.kind,
								reason = reason,
								name = name,
								liveSpellId = DescribeFrameSpellId(okLive, liveSpellId),
								baseSpellId = DescribeFrameSpellId(okBase, baseSpellId),
							}
						else
							recorded = recorded + 1
						end
					end
				end
			end
		end

		counts[definition.globalName] = { walked = walked, recorded = recorded }
	end

	return skipped, counts
end

---Diagnostic snapshot, for troubleshooting and for the options panel to explain why a spell has
---no CDM data. One probe **per source**, not per spell: a spell sitting in both halves of the
---Cooldown Manager answers differently in each, and seeing only one of them hides that. Plain
---values are captured, secret ones only recorded as present, since the point of the probe is
---whether a read succeeded at all.
---@return table
function CDM:GetDiagnostics()
	if indexDirty or ShownStateChanged() then
		self:RebuildIndex()
	end

	local viewerStates = {}
	for index, definition in ipairs(viewerDefinitions) do
		local viewer = _G[definition.globalName]
		viewerStates[definition.globalName] = {
			exists = viewer ~= nil,
			shown = viewer ~= nil and viewer:IsShown() or false,
			-- Diverges from `shown` only inside the grace period, which is the one state where a
			-- hidden viewer still supplies data and the probe below would otherwise look impossible.
			usable = viewerShown[index] == true,
		}
	end

	-- Before the probes, which can quarantine a frame themselves and would show up as our own damage.
	local skipped, frameCounts = CollectSkippedFrames()

	local probes = {}
	local trackedCount = 0
	for spellId, entries in pairs(sources) do
		trackedCount = trackedCount + 1

		local okName, spellName = pcall(C_Spell.GetSpellName, spellId)
		for _, entry in ipairs(entries) do
			-- Pinning to the entry's own kind is what makes each source individually legible; it is
			-- also exactly the selector a caller would pass to read from that source.
			local signals = {}
			for _, signal in ipairs(probeOrder) do
				local ok, value, isSecret = self:Read(spellId, signal, entry.kind)
				signals[signal] = {
					ok = ok,
					secret = isSecret,
					-- Only a non-secret value is safe to carry out of here; a secret cannot be
					-- compared, concatenated or tostring'd by whatever renders this.
					value = (ok and not isSecret) and value or nil,
				}
			end

			probes[#probes + 1] = {
				spellId = spellId,
				name = (okName and spellName) or "?",
				kind = entry.kind,
				signals = signals,
			}
		end
	end

	table.sort(probes, function(a, b)
		if a.spellId ~= b.spellId then
			return a.spellId < b.spellId
		end
		return a.kind < b.kind
	end)

	return {
		available = self:IsAvailable(),
		trackedCount = trackedCount,
		sourceCount = #probes,
		indexBuiltAt = indexBuiltAt,
		viewers = viewerStates,
		probes = probes,
		skipped = skipped,
		frameCounts = frameCounts,
	}
end

---Cooldown Manager category enum per viewer kind, for reading the *configured* layout rather than
---the frames built from it.
local categoryByKind = {
	[CDM.SourceKind.ESSENTIAL] = Enum.CooldownViewerCategory and Enum.CooldownViewerCategory.Essential,
	[CDM.SourceKind.UTILITY] = Enum.CooldownViewerCategory and Enum.CooldownViewerCategory.Utility,
	[CDM.SourceKind.BUFF_ICON] = Enum.CooldownViewerCategory and Enum.CooldownViewerCategory.TrackedBuff,
	[CDM.SourceKind.BUFF_BAR] = Enum.CooldownViewerCategory and Enum.CooldownViewerCategory.TrackedBar,
}

---Equality against a plain spell ID, safe on a value that may be secret -- comparing a secret raises
---rather than returning false, so the plainness check has to come first.
---@param candidate any
---@param spellId integer
---@return boolean
local function SpellIdMatches(candidate, spellId)
	return TRB.Functions.Number:IsPlainNumber(candidate) and candidate == spellId
end

---True when a cooldown entry names this spell by any of the IDs it can answer to.
---@param info table
---@param spellId integer
---@return boolean
local function CooldownInfoNamesSpell(info, spellId)
	if SpellIdMatches(info.spellID, spellId) or SpellIdMatches(info.overrideSpellID, spellId) then
		return true
	end
	if type(info.linkedSpellIDs) == "table" then
		for _, linked in ipairs(info.linkedSpellIDs) do
			if SpellIdMatches(linked, spellId) then
				return true
			end
		end
	end
	return false
end

---Everything the Cooldown Manager knows about one spell across all three layers: configured entry,
---item frame, and our index. Reached from `/trb cdm <spellId>`.
---@param spellId integer
function CDM:PrintSpellReport(spellId)
	local prefix = "|cFFFF8800TRB CDM:|r "

	if not TRB.Functions.Number:IsPlainNumber(spellId) then
		print(prefix .. "Usage: /trb cdm <spellId>")
		return
	end

	if indexDirty or ShownStateChanged() then
		self:RebuildIndex()
	end

	local okName, spellName = pcall(C_Spell.GetSpellName, spellId)
	print(prefix .. string.format("Report for %d %s", spellId, (okName and spellName) or "?"))

	-- Layer 1: our index.
	local entries = sources[spellId]
	if entries == nil then
		print(prefix .. "  index: NOT INDEXED")
	else
		for _, entry in ipairs(entries) do
			print(prefix .. string.format("  index: indexed from [%s]%s", entry.kind,
				quarantined[entry.frame] and " (QUARANTINED)" or ""))
		end
	end

	-- Layer 2: item frames that exist right now, including in viewers we are not indexing.
	local foundFrame = false
	for index, definition in ipairs(viewerDefinitions) do
		local viewer = _G[definition.globalName]
		if viewer ~= nil and viewer.GetItemFrames ~= nil then
			local ok, itemFrames = pcall(viewer.GetItemFrames, viewer)
			if ok and type(itemFrames) == "table" then
				for _, frame in ipairs(itemFrames) do
					if frame ~= nil and frame.GetSpellID ~= nil then
						local okLive, liveSpellId = pcall(frame.GetSpellID, frame)
						local okBase, baseSpellId = pcall(frame.GetBaseSpellID, frame)
						-- SpellIdMatches screens for plainness; both go secret in combat.
						if (okLive and SpellIdMatches(liveSpellId, spellId))
							or (okBase and SpellIdMatches(baseSpellId, spellId)) then
							foundFrame = true
							print(prefix .. string.format("  frame: exists in %s (viewerUsable=%s)",
								definition.globalName, tostring(viewerShown[index] == true)))
						end
					end
				end
			end
		end
	end
	if not foundFrame then
		print(prefix .. "  frame: NO ITEM FRAME in any viewer")
	end

	-- Layer 3: the configured layout. A spell present here but absent above is one Blizzard declined
	-- to build a frame for, and these fields are the reasons it would.
	if C_CooldownViewer == nil or C_CooldownViewer.GetCooldownViewerCategorySet == nil then
		print(prefix .. "  config: C_CooldownViewer unavailable")
		return
	end

	local foundConfig = false
	for _, definition in ipairs(viewerDefinitions) do
		local category = categoryByKind[definition.kind]
		if category ~= nil then
			local okSet, cooldownIDs = pcall(C_CooldownViewer.GetCooldownViewerCategorySet, category)
			if okSet and type(cooldownIDs) == "table" then
				for _, cooldownID in ipairs(cooldownIDs) do
					local okInfo, info = pcall(C_CooldownViewer.GetCooldownViewerCooldownInfo, cooldownID)
					if okInfo and type(info) == "table" and CooldownInfoNamesSpell(info, spellId) then
						foundConfig = true
						print(prefix .. string.format("  config: %s cooldownID=%s spellID=%s overrideSpellID=%s isKnown=%s isInvisible=%s flags=%s hasAura=%s",
							definition.kind, tostring(cooldownID), tostring(info.spellID),
							tostring(info.overrideSpellID), tostring(info.isKnown),
							tostring(info.isInvisible), tostring(info.flags), tostring(info.hasAura)))
					end
				end
			end
		end
	end
	if not foundConfig then
		print(prefix .. "  config: not present in any category set")
	end
end

---Prints GetDiagnostics to chat. Reached from `/trb cdm`.
function CDM:PrintDiagnostics()
	local diagnostics = self:GetDiagnostics()
	local prefix = "|cFFFF8800TRB CDM:|r "

	print(prefix .. string.format("available=%s tracked=%d sources=%d", tostring(diagnostics.available),
		diagnostics.trackedCount, diagnostics.sourceCount))

	for _, definition in ipairs(viewerDefinitions) do
		local state = diagnostics.viewers[definition.globalName]
		local counts = diagnostics.frameCounts and diagnostics.frameCounts[definition.globalName]
		print(prefix .. string.format("  %s exists=%s shown=%s usable=%s frames=%d indexed=%d", definition.globalName,
			tostring(state.exists), tostring(state.shown), tostring(state.usable),
			counts and counts.walked or 0, counts and counts.recorded or 0))
	end

	-- Ahead of the probes: a frame listed here is missing from every line below.
	if diagnostics.skipped ~= nil and #diagnostics.skipped > 0 then
		print(prefix .. string.format("%d frame(s) skipped during indexing:", #diagnostics.skipped))
		for _, entry in ipairs(diagnostics.skipped) do
			print(prefix .. string.format("  [%s] SKIPPED %s %s reason=%s baseSpellId=%s",
				entry.kind, entry.liveSpellId, entry.name, entry.reason, entry.baseSpellId))
		end
	end

	if not diagnostics.available then
		print(prefix .. "Cooldown Manager is unavailable; nothing else to report.")
		return
	end

	if diagnostics.trackedCount == 0 then
		print(prefix .. "No tracked spells. Every viewer is hidden, or none has spells assigned.")
		return
	end

	for _, probe in ipairs(diagnostics.probes) do
		-- Signals that read as unavailable are omitted rather than printed as "-": most spells carry
		-- only a handful of the set, and the blanks bury the ones that actually resolved.
		local parts = {}
		for _, signal in ipairs(probeOrder) do
			local result = probe.signals[signal]
			if result.ok then
				local state
				if result.secret then
					state = "SECRET"
				else
					state = string.format("%s", tostring(result.value))
				end
				parts[#parts + 1] = string.format("%s=%s", signal, state)
			end
		end
		print(prefix .. string.format("  [%s] %d %s : %s", probe.kind, probe.spellId, probe.name,
			table.concat(parts, " ")))
	end
end
