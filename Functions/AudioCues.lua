---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.AudioCues = TRB.Functions.AudioCues or {}
TRB.Data = TRB.Data or {}

---A spec's complete audio cue vocabulary. `builtIns` are fixed cues whose firing conditions live in
---the class module; `counters` are threshold sources the user can add and delete cues against. A
---spec with no `counters` entries gets no "Add New Audio Cue" button.
---@class TRB.Classes.AudioCueDefinition
---@field public builtIns TRB.Classes.AudioCueBuiltIn[]
---@field public counters TRB.Classes.AudioCueCounterSource[]

---A fixed cue. Its condition is evaluated by the class module via AudioCues:Fire().
---@class TRB.Classes.AudioCueBuiltIn
---@field public id string # Settings key, e.g. "surgeOfLight"
---@field public label string # Localized display name shown in the cue table
---@field public trigger string # Localized one-line firing condition, shown in the table and detail pane
---@field public tooltip string # Localized description, shown on row hover and in the detail pane
---@field public config TRB.Classes.AudioCueConfigControl[]? # Extra controls rendered in the detail pane

---An extra control rendered in a built-in cue's detail pane, bound to cue.configuration[key].
---@class TRB.Classes.AudioCueConfigControl
---@field public key string # Field name under cue.configuration
---@field public control string # "slider" or "checkbox"
---@field public label string # Localized label
---@field public tooltip string? # Localized tooltip (checkboxes)
---@field public default any # Value seeded onto cue.configuration when absent
---@field public min number? # Slider only
---@field public max number? # Slider only
---@field public step number? # Slider only
---@field public decimals number? # Slider only

---A countable value the user can hang threshold cues off. The class module feeds the current value
---in via AudioCues:UpdateCounter().
---@class TRB.Classes.AudioCueCounterSource
---@field public id string # Source key stored on each cue, e.g. "chi"
---@field public label string # Localized name shown in the cue table's Trigger column
---@field public description string # Localized description shown on row hover and in the detail pane
---@field public sliderLabel string # Localized label for the threshold slider
---@field public defaultName string # Localized seed name for newly added cues
---@field public min number
---@field public max number
---@field public step number
---@field public decimals number
---@field public compare string # "atLeast" (>=), "atMost" (<=), or "exact" (==)
---@field public requiresCombat boolean # Whether cues only fire while in combat
---@field public legacyIds string[]? # Pre-refactor settings keys that migrate onto this source
---@field public defaultCues TRB.Classes.AudioCueSeed[]? # Cues seeded once, the first time this source is seen

---A cue the addon ships for a counter source. Seeded into a spec's settings exactly once, then
---owned entirely by the user -- deleting one is permanent.
---@class TRB.Classes.AudioCueSeed
---@field public id string # Settings key. Keep stable: it is also what pre-refactor saves used
---@field public name string # Localized seed name; the user can rename it afterwards
---@field public enabled boolean
---@field public sound string
---@field public soundName string
---@field public thresholdValue number

---Per-spec audio cue definitions, keyed by compositeKey ("monk_windwalker").
---Registered from ClassModules/Classes/[Class]Classes.lua at load time.
---@type table<string, TRB.Classes.AudioCueDefinition>
TRB.Data.audioCueRegistry = TRB.Data.audioCueRegistry or {}

-- Cached per-source cue arrays, sorted for evaluation. Weak-keyed on the spec settings table so a
-- profile swap or spec settings rebuild drops the entry with the table it belonged to.
local counterCache = setmetatable({}, { __mode = "k" })

---Registers a spec's audio cue definition.
---@param compositeKey string # "className_specName", e.g. "monk_windwalker"
---@param definition TRB.Classes.AudioCueDefinition
function TRB.Functions.AudioCues:Register(compositeKey, definition)
	if compositeKey == nil or definition == nil then
		return
	end

	definition.builtIns = definition.builtIns or {}
	definition.counters = definition.counters or {}
	TRB.Data.audioCueRegistry[compositeKey] = definition
end

---Gets the cue definition for a spec.
---@param compositeKey string?
---@return TRB.Classes.AudioCueDefinition?
function TRB.Functions.AudioCues:GetDefinition(compositeKey)
	if compositeKey == nil then
		return nil
	end
	return TRB.Data.audioCueRegistry[compositeKey]
end

---Gets a spec's built-in cue descriptor by id.
---@param compositeKey string?
---@param id string?
---@return TRB.Classes.AudioCueBuiltIn?
function TRB.Functions.AudioCues:GetBuiltIn(compositeKey, id)
	local definition = self:GetDefinition(compositeKey)
	if definition == nil or id == nil then
		return nil
	end

	for _, builtIn in ipairs(definition.builtIns) do
		if builtIn.id == id then
			return builtIn
		end
	end
	return nil
end

---Gets a spec's counter source descriptor by id.
---@param compositeKey string?
---@param sourceId string?
---@return TRB.Classes.AudioCueCounterSource?
function TRB.Functions.AudioCues:GetCounterSource(compositeKey, sourceId)
	local definition = self:GetDefinition(compositeKey)
	if definition == nil or sourceId == nil then
		return nil
	end

	for _, source in ipairs(definition.counters) do
		if source.id == sourceId then
			return source
		end
	end
	return nil
end

---Resolves the compositeKey for the spec currently being rendered.
---@return string?
local function GetActiveCompositeKey()
	local character = TRB.Data.character
	if character == nil then
		return nil
	end

	if character.compositeKey ~= nil then
		return character.compositeKey
	end

	-- CheckCharacter() stamps compositeKey, but the first update after login can land before it does.
	return TRB.Functions.Character:GetCompositeKeyFromIds(character.classId, character.specId)
end

---Gets (creating if needed) the latch table that tracks which cues have already played.
---@param snapshotData TRB.Classes.SnapshotData
---@return table<string, boolean>
local function EnsureLatches(snapshotData)
	snapshotData.audio = snapshotData.audio or {}
	snapshotData.audio.latches = snapshotData.audio.latches or {}
	return snapshotData.audio.latches
end

---Gets (creating if needed) the table of last-seen counter values, keyed by source id. Used to tell
---a rising update from a falling one.
---@param snapshotData TRB.Classes.SnapshotData
---@return table<string, number>
local function EnsureCounterValues(snapshotData)
	snapshotData.audio = snapshotData.audio or {}
	snapshotData.audio.counterValues = snapshotData.audio.counterValues or {}
	return snapshotData.audio.counterValues
end

---Whether a counter source's cues can offer the "also play on dropping to this value" toggle.
---
---Only meaningful for "atLeast": those cues latch on the way up and stay latched all the way to the
---source's maximum, so spending back down to the value is otherwise silent. "atMost" cues already
---fire as the value falls into range, and "exact" cues already fire from either direction.
---@param source TRB.Classes.AudioCueCounterSource?
---@return boolean
function TRB.Functions.AudioCues:SourceSupportsPlayOnDrop(source)
	return source ~= nil and source.compare ~= "atMost" and source.compare ~= "exact"
end

---Plays a cue's sound on the configured channel.
---@param cue TRB.Classes.Settings.AudioCue
local function PlayCue(cue)
	if cue.sound ~= nil and cue.sound ~= "" then
		PlaySoundFile(cue.sound, TRB.Data.settings.core.audio.channel.channel)
	end
end

---Builds the evaluation-ordered cue array for a counter source, so the first newly-crossed entry is
---also the most urgent one. "atLeast" sources order descending (6 Chi beats 3 Chi); "atMost" sources
---order ascending (1 Essence left beats 3). An id tiebreak keeps same-value cues in a stable,
---session-independent order.
---@param specSettings table
---@param source TRB.Classes.AudioCueCounterSource
---@return TRB.Classes.Settings.AudioCue[]
local function BuildSortedCounterCues(specSettings, source)
	local cues = {}
	for id, cue in pairs(specSettings.audio) do
		if type(cue) == "table" and cue.kind == "counter" and cue.source == source.id then
			cue.id = cue.id or id
			table.insert(cues, cue)
		end
	end

	local ascending = source.compare == "atMost"
	table.sort(cues, function(a, b)
		local aValue = (a.configuration and a.configuration.thresholdValue) or 0
		local bValue = (b.configuration and b.configuration.thresholdValue) or 0
		if aValue ~= bValue then
			if ascending then
				return aValue < bValue
			end
			return aValue > bValue
		end
		return tostring(a.id) < tostring(b.id)
	end)

	return cues
end

---@param specSettings table
---@param source TRB.Classes.AudioCueCounterSource
---@return TRB.Classes.Settings.AudioCue[]
local function GetSortedCounterCues(specSettings, source)
	local bySource = counterCache[specSettings]
	if bySource == nil then
		bySource = {}
		counterCache[specSettings] = bySource
	end

	if bySource[source.id] == nil then
		bySource[source.id] = BuildSortedCounterCues(specSettings, source)
	end
	return bySource[source.id]
end

---Drops the cached cue ordering for a spec. Call after adding, deleting, or re-thresholding a cue.
---@param specSettings table? # Spec settings table, or nil to clear every spec
function TRB.Functions.AudioCues:InvalidateCache(specSettings)
	if specSettings == nil then
		counterCache = setmetatable({}, { __mode = "k" })
	else
		counterCache[specSettings] = nil
	end
end

---Evaluates a single built-in cue. Plays once when `condition` becomes true and re-arms when it
---goes false again.
---
---`canPlay` suppresses the sound without freezing the latch, for cues that should track state
---continuously but only be audible under some extra condition (typically being in combat). Passing
---the extra condition through `condition` instead would re-arm the cue whenever it went false, so
---the cue would fire on re-entering combat with its trigger already satisfied.
---@param specSettings table
---@param snapshotData TRB.Classes.SnapshotData
---@param cueId string
---@param condition boolean
---@param canPlay boolean? # Defaults to true
---@return boolean # Whether the cue crossed on this evaluation
function TRB.Functions.AudioCues:Fire(specSettings, snapshotData, cueId, condition, canPlay)
	if specSettings == nil or specSettings.audio == nil or snapshotData == nil then
		return false
	end

	local cue = specSettings.audio[cueId]
	if cue == nil then
		return false
	end

	local latches = EnsureLatches(snapshotData)
	if condition then
		if cue.enabled and not latches[cueId] then
			latches[cueId] = true
			if canPlay ~= false then
				PlayCue(cue)
			end
			return true
		end
	else
		latches[cueId] = false
	end
	return false
end

---Evaluates a mutually-exclusive group of built-in cues. Each latches independently, but when more
---than one crosses on the same update only the highest-ranked is audible.
---@param specSettings table
---@param snapshotData TRB.Classes.SnapshotData
---@param entries table[] # { id = string, condition = boolean }, lowest rank first
---@param canPlay boolean? # Defaults to true
function TRB.Functions.AudioCues:FireGroup(specSettings, snapshotData, entries, canPlay)
	if specSettings == nil or specSettings.audio == nil or snapshotData == nil then
		return
	end

	local winner = nil
	for _, entry in ipairs(entries) do
		-- Latch every member, but withhold playback until we know which one ranks highest.
		if self:Fire(specSettings, snapshotData, entry.id, entry.condition, false) then
			winner = entry.id
		end
	end

	if winner ~= nil and canPlay ~= false then
		PlayCue(specSettings.audio[winner])
	end
end

---Evaluates a fixed group of built-in cues that rank by a numeric value, like a proc's charge count.
---Behaves like UpdateCounter -- one audible winner per update, plus the `configuration.playOnDrop`
---path -- but the thresholds come from the caller instead of from user-owned cues.
---@param specSettings table
---@param snapshotData TRB.Classes.SnapshotData
---@param key string # Names this group in the last-seen value store
---@param value number?
---@param entries table[] # { id = string, threshold = number, canPlay = boolean? }, lowest threshold first
---@param canPlay boolean? # Suppresses the whole group. Defaults to true
function TRB.Functions.AudioCues:FireValueGroup(specSettings, snapshotData, key, value, entries, canPlay)
	if specSettings == nil or specSettings.audio == nil or snapshotData == nil or value == nil then
		return
	end

	local counterValues = EnsureCounterValues(snapshotData)
	local previous = counterValues[key]
	counterValues[key] = value
	local isDrop = previous ~= nil and value < previous

	local winner = nil
	local dropWinner = nil

	-- Highest threshold first, so the first crossing found is also the most urgent one.
	for x = #entries, 1, -1 do
		local entry = entries[x]
		local cue = specSettings.audio[entry.id]
		if cue ~= nil then
			-- Latch every member, but withhold playback until we know which one ranks highest.
			if self:Fire(specSettings, snapshotData, entry.id, value >= entry.threshold, false) then
				if winner == nil then
					winner = entry
				end
			elseif isDrop and dropWinner == nil and cue.enabled and cue.configuration
				and cue.configuration.playOnDrop and value == entry.threshold then
				dropWinner = entry
			end
		end
	end

	-- A muted winner still outranks the entry below it, so the group stays silent rather than
	-- falling through to a cue the user did not cross.
	local played = winner or dropWinner
	if canPlay ~= false and played ~= nil and played.canPlay ~= false then
		PlayCue(specSettings.audio[played.id])
	end
end

---Re-arms a single cue so it can play again without waiting for its condition to go false.
---@param snapshotData TRB.Classes.SnapshotData
---@param cueId string
function TRB.Functions.AudioCues:ResetLatch(snapshotData, cueId)
	if snapshotData == nil or cueId == nil then
		return
	end
	EnsureLatches(snapshotData)[cueId] = false
end

---Re-arms every cue. Used on spec switch and when leaving combat.
---@param snapshotData TRB.Classes.SnapshotData
function TRB.Functions.AudioCues:ResetAllLatches(snapshotData)
	if snapshotData == nil then
		return
	end
	snapshotData.audio = snapshotData.audio or {}
	snapshotData.audio.latches = {}
	-- Forget the last-seen counters too, so the next update cannot read as a drop.
	snapshotData.audio.counterValues = {}
end

---Evaluates every counter cue bound to `sourceId` against the current counter value. Cues fire once
---on crossing and re-arm when the value stops satisfying them; when several cross on the same
---update only the most urgent one is audible.
---
---A cue with `configuration.playOnDrop` also fires when the value falls onto its threshold exactly.
---That is a separate path from the latch: spending from 6 to 4 leaves every threshold at or below 4
---still latched, so without it the drop is silent.
---@param specSettings table
---@param snapshotData TRB.Classes.SnapshotData
---@param sourceId string
---@param value number?
function TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, sourceId, value)
	if specSettings == nil or specSettings.audio == nil or snapshotData == nil or value == nil then
		return
	end

	local source = self:GetCounterSource(GetActiveCompositeKey(), sourceId)
	if source == nil then
		return
	end

	local counterValues = EnsureCounterValues(snapshotData)

	if source.requiresCombat and not TRB.Data.character.inCombat then
		-- Latches stay frozen out of combat, but drop the remembered value: resources decay while
		-- idle, and re-entering combat should not read as a spend.
		counterValues[sourceId] = nil
		return
	end

	local previous = counterValues[sourceId]
	counterValues[sourceId] = value
	local isDrop = previous ~= nil and value < previous

	local cues = GetSortedCounterCues(specSettings, source)
	local latches = EnsureLatches(snapshotData)
	local winner = nil
	local dropWinner = nil

	for x = 1, #cues do
		local cue = cues[x]
		local threshold = cue.configuration and cue.configuration.thresholdValue
		if threshold ~= nil then
			local matches
			if source.compare == "exact" then
				matches = value == threshold
			elseif source.compare == "atMost" then
				matches = value <= threshold
			else
				matches = value >= threshold
			end

			if matches then
				if cue.enabled and not latches[cue.id] then
					latches[cue.id] = true
					-- The sort puts the most urgent cue first, so the first crossing wins.
					if winner == nil then
						winner = cue
					end
				elseif isDrop and dropWinner == nil and cue.enabled
					and cue.configuration.playOnDrop and value == threshold then
					dropWinner = cue
				end
			else
				latches[cue.id] = false
			end
		end
	end

	-- A rising crossing and a drop cannot both happen on one update, but prefer the crossing if a
	-- newly added or re-enabled cue ever produces both.
	if winner ~= nil then
		PlayCue(winner)
	elseif dropWinner ~= nil then
		PlayCue(dropWinner)
	end
end
