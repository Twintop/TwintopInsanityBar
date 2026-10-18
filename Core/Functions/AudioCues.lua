---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.AudioCues = TRB.Functions.AudioCues or {}
TRB.Data = TRB.Data or {}

---A spec's built-in cues (fired by the class module) and the counter sources users add threshold cues
---against. Buff Alerts need no declaration, so every spec can add them.
---@class TRB.Classes.AudioCueDefinition
---@field public builtIns TRB.Classes.AudioCueBuiltIn[]
---@field public counters TRB.Classes.AudioCueCounterSource[]

---A fixed cue. The class module evaluates it each tick via AudioCues:Fire(), or from its proc's event via FireOnEvent().
---@class TRB.Classes.AudioCueBuiltIn
---@field public id string # Settings key, e.g. "surgeOfLight"
---@field public label string # Localized display name shown in the cue table
---@field public trigger string # Localized one-line firing condition, shown in the table and detail pane
---@field public tooltip string # Localized description, shown on row hover and in the detail pane
---@field public config TRB.Classes.AudioCueConfigControl[]? # Extra controls rendered in the detail pane
---@field public cdm TRB.CdmDependency? # Badges the trigger when the cue can only fire with Cooldown Manager data

---An extra control rendered in a built-in cue's detail pane, bound to cue.configuration[key].
---@class TRB.Classes.AudioCueConfigControl
---@field public key string # Field name under cue.configuration
---@field public control string # "slider", "checkbox", or "dropdown"
---@field public label string # Localized label
---@field public tooltip string? # Localized tooltip (checkboxes)
---@field public default any # Value seeded onto cue.configuration when absent
---@field public min number? # Slider only
---@field public max number? # Slider only
---@field public step number? # Slider only
---@field public decimals number? # Slider only
---@field public options { value: any, label: string }[]? # Dropdown only, in display order

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
---@field public requiresCombat boolean # Default for its cues' Play out of combat setting: true means combat only
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

-- Each spec's enabled Buff Alerts with a buff chosen, rebuilt by InvalidateCache. Weak-keyed on its audio table.
local buffCueCache = setmetatable({}, { __mode = "k" })

-- What a spec that registers nothing gets, so it can still hold Buff Alerts. Never mutated.
local emptyDefinition = { builtIns = {}, counters = {} }

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

---Gets the cue definition for a spec; one with no built-ins or counters when it registered none.
---@param compositeKey string?
---@return TRB.Classes.AudioCueDefinition?
function TRB.Functions.AudioCues:GetDefinition(compositeKey)
	if compositeKey == nil then
		return nil
	end
	return TRB.Data.audioCueRegistry[compositeKey] or emptyDefinition
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

---Whether a cue may play while out of combat. Absent means yes: combat-only built-ins say so in their spec defaults.
---@param cue TRB.Classes.Settings.AudioCue
---@return boolean
local function PlaysOutOfCombat(cue)
	return cue.configuration == nil or cue.configuration.playOutOfCombat ~= false
end

---Whether a cue may play while out of combat.
---@param cue TRB.Classes.Settings.AudioCue
---@return boolean
function TRB.Functions.AudioCues:PlaysOutOfCombat(cue)
	return PlaysOutOfCombat(cue)
end

---Whether a cue can play right now: always in combat, and out of it unless it is combat only.
---@param cue TRB.Classes.Settings.AudioCue
---@return boolean
local function IsAudible(cue)
	return TRB.Data.character.inCombat or PlaysOutOfCombat(cue)
end

---Plays a cue's sound on the configured channel, unless it is combat only and the player isn't in combat.
---@param cue TRB.Classes.Settings.AudioCue
local function PlayCue(cue)
	if cue.sound ~= nil and cue.sound ~= "" and IsAudible(cue) then
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

---Enabled Buff Alerts with a buff chosen, the only ones worth evaluating.
---@param audio table<string, TRB.Classes.Settings.AudioCue>
---@return TRB.Classes.Settings.AudioCue[]
local function BuildBuffCues(audio)
	local cues = {}
	for id, cue in pairs(audio) do
		if type(cue) == "table" and cue.kind == "buff" and cue.enabled and cue.configuration ~= nil
			and type(cue.configuration.conditions) == "table" and #cue.configuration.conditions > 0 then
			cue.id = cue.id or id
			cues[#cues + 1] = cue
		end
	end
	return cues
end

---Drops the cached cue ordering for a spec and rebuilds its Buff Alert list. Call after adding, deleting,
---or editing a cue.
---@param specSettings table? # Spec settings table, or nil for every spec
function TRB.Functions.AudioCues:InvalidateCache(specSettings)
	if specSettings == nil then
		counterCache = setmetatable({}, { __mode = "k" })
		for audio in pairs(buffCueCache) do
			buffCueCache[audio] = BuildBuffCues(audio)
		end
	else
		counterCache[specSettings] = nil
		if type(specSettings.audio) == "table" then
			buffCueCache[specSettings.audio] = BuildBuffCues(specSettings.audio)
		end
	end
end

---Plays a cue once when `condition` becomes true and re-arms it when it goes false again.
---@param latches table<string, boolean>
---@param cueId string
---@param cue TRB.Classes.Settings.AudioCue
---@param condition boolean
---@param canPlay boolean?
---@return boolean # Whether the cue crossed on this evaluation
local function LatchCue(latches, cueId, cue, condition, canPlay)
	if condition then
		if cue.enabled and not latches[cueId] then
			-- A cue's first evaluation (login, spec change) only records its state: already true is not a crossing.
			local isBaseline = latches[cueId] == nil
			latches[cueId] = true
			if isBaseline then
				return false
			end
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

---Evaluates a single built-in cue. Plays once when `condition` becomes true and re-arms when it
---goes false again.
---
---`canPlay` mutes the sound but keeps the latch tracking, like the cue's own combat-only setting does.
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

	return LatchCue(EnsureLatches(snapshotData), cueId, cue, condition, canPlay)
end

---Evaluates a built-in cue from the event that starts its proc: a crossing even on its first evaluation, except
---during a render transition (login, loading screen, spec or talent change), when the proc may predate it.
---@param specSettings table
---@param snapshotData TRB.Classes.SnapshotData
---@param cueId string
---@param canPlay boolean? # Defaults to true
---@return boolean # Whether the cue crossed on this evaluation
function TRB.Functions.AudioCues:FireOnEvent(specSettings, snapshotData, cueId, canPlay)
	if specSettings == nil or specSettings.audio == nil or snapshotData == nil then
		return false
	end

	local cue = specSettings.audio[cueId]
	if cue == nil then
		return false
	end

	local latches = EnsureLatches(snapshotData)
	if TRB.Functions.Bar:IsRenderTransitionActive() then
		if latches[cueId] == false then
			latches[cueId] = nil
		end
	elseif latches[cueId] == nil then
		latches[cueId] = false
	end
	return LatchCue(latches, cueId, cue, true, canPlay)
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
		-- Latch every member, but withhold playback until we know which one ranks highest. A cue muted
		-- out of combat still latches, but can't take the win from an audible one.
		if self:Fire(specSettings, snapshotData, entry.id, entry.condition, false) and IsAudible(specSettings.audio[entry.id]) then
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
			-- Latch every member, but withhold playback until we know which one ranks highest. A cue muted
			-- out of combat still latches, but can't take the win from an audible one.
			local audible = IsAudible(cue)
			if self:Fire(specSettings, snapshotData, entry.id, value >= entry.threshold, false) then
				if winner == nil and audible then
					winner = entry
				end
			elseif audible and isDrop and dropWinner == nil and cue.enabled and cue.configuration
				and cue.configuration.playOnDrop and value == entry.threshold then
				dropWinner = entry
			end
		end
	end

	-- A winner its entry's canPlay mutes still outranks the entry below it, so the group stays silent
	-- rather than falling through to a cue the user did not cross.
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

---Sets every recorded latch in a table back to armed. Armed (false) rather than cleared (nil), because a
---cleared latch is a first evaluation and stays silent.
---@param latches table<string, boolean>?
local function RearmLatches(latches)
	if latches == nil then
		return
	end
	for cueId in pairs(latches) do
		latches[cueId] = false
	end
end

---Re-arms every cue, built-in and threshold line alike, so one whose condition still holds plays again.
---Used on death.
---@param snapshotData TRB.Classes.SnapshotData
function TRB.Functions.AudioCues:ResetAllLatches(snapshotData)
	if snapshotData == nil or snapshotData.audio == nil then
		return
	end
	RearmLatches(snapshotData.audio.latches)
	RearmLatches(snapshotData.audio.thresholdCues)
	-- Forget the last-seen counters too, so the next update cannot read as a drop.
	snapshotData.audio.counterValues = {}
end

---Forgets every latch, so each cue's next evaluation is a baseline: a condition met while the spec was inactive
---stays silent, and a proc that ended out of sight plays its next time. Used when a different spec becomes active.
---@param snapshotData TRB.Classes.SnapshotData
function TRB.Functions.AudioCues:BaselineAllLatches(snapshotData)
	if snapshotData == nil or snapshotData.audio == nil then
		return
	end
	snapshotData.audio.latches = {}
	snapshotData.audio.thresholdCues = {}
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
---@param compositeKey string? # Overrides the active spec's key, for a counter one spec owns for the whole class
function TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, sourceId, value, compositeKey)
	if specSettings == nil or specSettings.audio == nil or snapshotData == nil or value == nil then
		return
	end

	local source = self:GetCounterSource(compositeKey or GetActiveCompositeKey(), sourceId)
	if source == nil then
		return
	end

	local counterValues = EnsureCounterValues(snapshotData)
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
				-- A cue muted out of combat still latches, but can't take the win from an audible one.
				local audible = IsAudible(cue)
				if cue.enabled and not latches[cue.id] then
					-- First evaluation only records the state, as in LatchCue.
					local isBaseline = latches[cue.id] == nil
					latches[cue.id] = true
					-- The sort puts the most urgent cue first, so the first audible crossing wins.
					if winner == nil and audible and not isBaseline then
						winner = cue
					end
				elseif audible and isDrop and dropWinner == nil and cue.enabled
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

---Evaluates the played spec's Buff Alerts against the Cooldown Manager, on the shared update tick.
---@param snapshotData TRB.Classes.SnapshotData
function TRB.Functions.AudioCues:UpdateBuffCues(snapshotData)
	local spec = TRB.Functions.Character:GetActiveRawSpecSettings()
	local cues = spec ~= nil and spec.audio ~= nil and buffCueCache[spec.audio] or nil
	if cues == nil or #cues == 0 then
		return
	end

	local cdm = TRB.Functions.CooldownManager
	local latches = EnsureLatches(snapshotData)
	for i = 1, #cues do
		local cue = cues[i]
		local conditions = cue.configuration.conditions
		---@type boolean?
		local met = true
		for c = 1, #conditions do
			local state = cdm:ReadCondition(conditions[c])
			if state == false then
				met = false
				break
			elseif state == nil then
				met = nil
			end
		end
		-- An unknown read keeps the latch, so a viewer that hides mid-buff doesn't replay it when it returns.
		if met ~= nil then
			LatchCue(latches, cue.id, cue, met)
		end
	end
end
