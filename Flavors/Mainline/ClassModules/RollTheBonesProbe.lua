local _, TRB = ...
if TRB.Data.character.classId ~= 4 then
	return
end

-- TEMPORARY DIAGNOSTIC for #896, not for merge: which signals carry the Roll the Bones outcome.
local PREFIX = "|cFFFF8800TRB rtbprobe:|r "
local USAGE = "Usage: /trb rtbprobe on | off"

local ROLL_THE_BONES = 1214909
local KEEP_IT_ROLLING = 381989
local DRAGON_BONE_DICE = 1259481
local RESTLESS_BLADES = 79096
local SINISTER_STRIKE = 193315
local OPPORTUNITY = 279876
local OUTCOMES = {
	[1214933] = "One of a Kind",
	[1214934] = "Double Trouble",
	[1214935] = "Triple Threat",
	[1214937] = "Jackpot",
}
-- The outcomes change only these three spells' values, so only their text can move.
local TEXT_SPELLS = {
	[RESTLESS_BLADES] = "Restless Blades",
	[SINISTER_STRIKE] = "Sinister Strike",
	[OPPORTUNITY] = "Opportunity",
}

local OUTCOME_DURATION = 30
local KEEP_IT_ROLLING_EXTENSION = 30
-- The outcome may land before the cast's SUCCEEDED.
local PRE_CAST_WINDOW = 0.3
local SAMPLE_DELAYS = { 0.05, 0.1, 0.2, 0.4, 0.7 }
local REPORT_DELAY = 1
local END_LEAD = 1
local END_TRAIL = 1.5
local END_STEP = 0.1
local HIT_HISTORY = 64
-- Caps the samples a flood of text updates could take in one window.
local MAX_SAMPLES = 40

local SPELL_EVENTS = {
	"SPELL_UPDATE_COOLDOWN",
	"SPELL_UPDATE_USES",
	"SPELL_UPDATE_ICON",
	"SPELL_TEXT_UPDATE",
	"SPELL_ACTIVATION_OVERLAY_SHOW",
	"SPELL_ACTIVATION_OVERLAY_GLOW_SHOW",
}
-- The overlay events' second argument is a file id, not a base spell id.
local BASE_ID_EVENTS = {
	SPELL_UPDATE_COOLDOWN = true,
	SPELL_UPDATE_USES = true,
}
local METRICS = {
	{ key = "restlessBlades", label = "RB", format = "%.1f", unit = "" },
	{ key = "comboPoints", label = "SS", format = "%d", unit = "" },
	{ key = "opportunity", label = "Opp", format = "%d", unit = "%" },
}

local eventFrame = CreateFrame("Frame")
local enabled = false
local rollCount = 0
local recentHits = {}
---@type any
local sentSample = nil
---@type any
local roll = nil
---@type any
local endWatch = nil

---@param text string
local function Print(text)
	print(PREFIX .. text)
end

---@param value any
---@return boolean
local function IsPlain(value)
	return value ~= nil and not issecretvalue(value)
end

---@param spellId integer
---@return string?
local function ReadDescription(spellId)
	local description = C_Spell.GetSpellDescription(spellId)
	if not IsPlain(description) or description == "" then
		return nil
	end
	return description
end

-- The combo point line ends Sinister Strike's text in every locale, so the count is the last number.
---@param description string?
---@return number?
local function ParseLastInteger(description)
	if description == nil then
		return nil
	end
	local stripped = description:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	return tonumber(stripped:match(".*%f[%d](%d+)"))
end

---@return table
local function TakeSample()
	local crit = GetCritChance()
	local critSecret = issecretvalue(crit)
	return {
		time = GetTime(),
		restlessBlades = TRB.Functions.String:ParseDurationSeconds(ReadDescription(RESTLESS_BLADES)),
		comboPoints = ParseLastInteger(ReadDescription(SINISTER_STRIKE)),
		opportunity = TRB.Functions.String:ParseFirstNumber(ReadDescription(OPPORTUNITY)),
		crit = not critSecret and crit or nil,
		critSecret = critSecret,
	}
end

---@param samples table
---@param force boolean?
local function AddSample(samples, force)
	if force or #samples < MAX_SAMPLES then
		samples[#samples + 1] = TakeSample()
	end
end

---@param value number?
---@param format string
---@return string
local function FormatValue(value, format)
	if value == nil then
		return "?"
	end
	return string.format(format, value)
end

---@param seconds number
---@return string
local function FormatOffset(seconds)
	if math.abs(seconds) < 1 then
		return string.format("%+dms", math.floor(seconds * 1000 + 0.5))
	end
	return string.format("%+.2fs", seconds)
end

---@param spellId integer
---@return string
local function TalentText(spellId)
	local talents = TRB.Data.talents
	local talent = talents ~= nil and talents.talents[spellId] or nil
	return (talent ~= nil and talent:IsActive()) and "yes" or "no"
end

---@param hits table
---@param origin number
---@return string
local function HitsText(hits, origin)
	if #hits == 0 then
		return "events: none"
	end
	local order = {}
	local groups = {}
	for _, hit in ipairs(hits) do
		local key = hit.event .. " " .. hit.spellId
		local group = groups[key]
		if group == nil then
			group = { hit = hit, count = 0 }
			groups[key] = group
			order[#order + 1] = group
		end
		group.count = group.count + 1
	end
	local parts = {}
	for _, group in ipairs(order) do
		local hit = group.hit
		local name = OUTCOMES[hit.spellId] or TEXT_SPELLS[hit.spellId] or tostring(hit.spellId)
		local count = group.count > 1 and (" x" .. group.count) or ""
		parts[#parts + 1] = string.format("%s %s%s %s", hit.event, name, count, FormatOffset(hit.time - origin))
	end
	return "events: " .. table.concat(parts, ", ")
end

---@param from table
---@param to table
---@return string
local function CritText(from, to)
	if from.critSecret or to.critSecret then
		return "crit secret"
	end
	if from.crit == nil or to.crit == nil then
		return "crit ?"
	end
	return string.format("crit %+.2f", to.crit - from.crit)
end

---@param metric table
---@param from number?
---@param to number?
---@param at string?
---@return string
local function MetricText(metric, from, to, at)
	if at == nil then
		return string.format("%s %s%s", metric.label, FormatValue(from, metric.format), metric.unit)
	end
	return string.format("%s %s->%s%s @%s", metric.label, FormatValue(from, metric.format), FormatValue(to, metric.format), metric.unit, at)
end

---@param current table
local function ReportRoll(current)
	current.reported = true
	local final = current.samples[#current.samples]
	local parts = {
		string.format("roll %d (%s%s)", current.index, current.combat, current.beforeFromSent and "" or ", no SENT"),
		HitsText(current.hits, current.castTime),
	}
	for _, metric in ipairs(METRICS) do
		local from = current.before[metric.key]
		local to = final[metric.key]
		local at = nil
		if from ~= to then
			for _, sample in ipairs(current.samples) do
				if sample[metric.key] == to then
					at = FormatOffset(sample.time - current.castTime)
					break
				end
			end
		end
		parts[#parts + 1] = MetricText(metric, from, to, at)
	end
	parts[#parts + 1] = CritText(current.before, final)
	Print(table.concat(parts, " | "))
end

---@param watch table
local function ReportEnd(watch)
	local current = watch.roll
	local reference = current.samples[#current.samples]
	local first = watch.samples[1]
	local last = watch.samples[#watch.samples]
	local header = string.format("roll %d end", current.index)
	if watch.extended > 0 then
		header = header .. string.format(" (Keep It Rolling +%ds)", watch.extended)
	end
	local parts = { header }
	local changed = false
	for _, metric in ipairs(METRICS) do
		local from = reference[metric.key]
		local to = nil
		local at = nil
		for _, sample in ipairs(watch.samples) do
			if sample[metric.key] ~= from then
				to = sample[metric.key]
				-- A change in the first sample happened before the window opened.
				at = (sample == first and "<=" or "") .. FormatOffset(sample.time - current.castTime)
				break
			end
		end
		changed = changed or at ~= nil
		parts[#parts + 1] = MetricText(metric, from, to, at)
	end
	parts[#parts + 1] = CritText(first, last)
	parts[#parts + 1] = HitsText(watch.hits, current.castTime)
	if not changed then
		parts[1] = header .. ": no change by " .. FormatOffset(last.time - current.castTime)
	end
	Print(table.concat(parts, " | "))
end

local function CancelEndWatch()
	if endWatch ~= nil and endWatch.ticker ~= nil then
		endWatch.ticker:Cancel()
	end
	endWatch = nil
end

---@param watch table
local function ScheduleEndWatch(watch)
	watch.generation = watch.generation + 1
	local generation = watch.generation
	if watch.ticker ~= nil then
		watch.ticker:Cancel()
		watch.ticker = nil
	end
	watch.samples = nil
	watch.hits = nil
	local delay = math.max(0, watch.expectedEnd - END_LEAD - GetTime())
	C_Timer.After(delay, function()
		if endWatch ~= watch or watch.generation ~= generation then
			return
		end
		watch.samples = { TakeSample() }
		watch.hits = {}
		---@type any
		local ticker = nil
		ticker = C_Timer.NewTicker(END_STEP, function()
			if endWatch ~= watch or watch.generation ~= generation then
				ticker:Cancel()
				return
			end
			AddSample(watch.samples, true)
			if watch.samples[#watch.samples].time >= watch.expectedEnd + END_TRAIL then
				ticker:Cancel()
				watch.ticker = nil
				endWatch = nil
				ReportEnd(watch)
			end
		end)
		watch.ticker = ticker
	end)
end

---@param current table
local function StartEndWatch(current)
	CancelEndWatch()
	endWatch = {
		roll = current,
		expectedEnd = current.castTime + OUTCOME_DURATION + current.extended,
		extended = current.extended,
		generation = 0,
	}
	ScheduleEndWatch(endWatch)
end

local function ExtendForKeepItRolling()
	if roll ~= nil and not roll.reported then
		roll.extended = roll.extended + KEEP_IT_ROLLING_EXTENSION
	elseif endWatch ~= nil then
		endWatch.expectedEnd = endWatch.expectedEnd + KEEP_IT_ROLLING_EXTENSION
		endWatch.extended = endWatch.extended + KEEP_IT_ROLLING_EXTENSION
		ScheduleEndWatch(endWatch)
	end
end

local function StartRoll()
	-- A reroll replaces the outcome, so the previous one's end never comes.
	CancelEndWatch()
	rollCount = rollCount + 1
	local castSample = TakeSample()
	local before = sentSample
	sentSample = nil
	if before ~= nil and castSample.time - before.time > 1 then
		before = nil
	end
	local current = {
		index = rollCount,
		castTime = castSample.time,
		combat = InCombatLockdown() and "in combat" or "out of combat",
		before = before or castSample,
		beforeFromSent = before ~= nil,
		samples = { castSample },
		hits = {},
		extended = 0,
	}
	for _, hit in ipairs(recentHits) do
		if hit.time >= current.castTime - PRE_CAST_WINDOW then
			current.hits[#current.hits + 1] = hit
		end
	end
	roll = current
	for _, delay in ipairs(SAMPLE_DELAYS) do
		C_Timer.After(delay, function()
			if roll == current and not current.reported then
				AddSample(current.samples)
			end
		end)
	end
	C_Timer.After(REPORT_DELAY, function()
		if roll ~= current then
			return
		end
		AddSample(current.samples, true)
		ReportRoll(current)
		StartEndWatch(current)
	end)
end

---@param event string
---@param spellId integer
local function RecordHit(event, spellId)
	local hit = { time = GetTime(), event = event, spellId = spellId }
	recentHits[#recentHits + 1] = hit
	if #recentHits > HIT_HISTORY then
		table.remove(recentHits, 1)
	end
	if roll ~= nil and not roll.reported then
		roll.hits[#roll.hits + 1] = hit
		AddSample(roll.samples)
	end
	if endWatch ~= nil and endWatch.samples ~= nil then
		endWatch.hits[#endWatch.hits + 1] = hit
		AddSample(endWatch.samples)
	end
end

eventFrame:SetScript("OnEvent", function(_, event, ...)
	if event == "UNIT_SPELLCAST_SENT" then
		local _, _, _, spellId = ...
		if IsPlain(spellId) and spellId == ROLL_THE_BONES then
			sentSample = TakeSample()
		end
		return
	end
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local _, _, spellId = ...
		if not IsPlain(spellId) then
			return
		end
		if spellId == ROLL_THE_BONES then
			StartRoll()
		elseif spellId == KEEP_IT_ROLLING then
			ExtendForKeepItRolling()
		elseif OUTCOMES[spellId] ~= nil then
			RecordHit(event, spellId)
		end
		return
	end
	local spellId, baseSpellId = ...
	if IsPlain(spellId) and (OUTCOMES[spellId] ~= nil or (event == "SPELL_TEXT_UPDATE" and TEXT_SPELLS[spellId] ~= nil)) then
		RecordHit(event, spellId)
	elseif BASE_ID_EVENTS[event] and IsPlain(baseSpellId) and OUTCOMES[baseSpellId] ~= nil then
		RecordHit(event, baseSpellId)
	end
end)

local function Enable()
	if TRB.Data.character.specId ~= 2 then
		Print("Outlaw only.")
		return
	end
	if enabled then
		Print("already on. " .. USAGE)
		return
	end
	enabled = true
	for _, event in ipairs(SPELL_EVENTS) do
		eventFrame:RegisterEvent(event)
	end
	eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_SENT", "player")
	eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
	for spellId in pairs(TEXT_SPELLS) do
		C_Spell.RequestLoadSpellData(spellId)
	end
	local sample = TakeSample()
	Print(string.format("on (%s) | Dragon-Bone Dice %s | Keep It Rolling %s | RB %s sec/CP | SS %s CP | Opportunity %s%% | crit %s",
		InCombatLockdown() and "in combat" or "out of combat",
		TalentText(DRAGON_BONE_DICE),
		TalentText(KEEP_IT_ROLLING),
		FormatValue(sample.restlessBlades, "%.1f"),
		FormatValue(sample.comboPoints, "%d"),
		FormatValue(sample.opportunity, "%d"),
		sample.critSecret and "secret" or FormatValue(sample.crit, "%.2f%%")))
end

local function Disable()
	if not enabled then
		Print("already off. " .. USAGE)
		return
	end
	enabled = false
	eventFrame:UnregisterAllEvents()
	CancelEndWatch()
	roll = nil
	sentSample = nil
	recentHits = {}
	Print("off.")
end

TRB.Classes.SpecDescriptor:DeclareForClass("rogue", {
	slashCommands = {
		rtbprobe = function(subcommand)
			local argument = string.lower((subcommand or ""):match("^%s*(.-)%s*$") or "")
			if argument == "on" then
				Enable()
			elseif argument == "off" then
				Disable()
			elseif argument == "" then
				Print(USAGE)
			else
				Print("Unknown argument '" .. argument .. "'. " .. USAGE)
			end
		end,
	},
})
