-- Checks that the shared bar text refreshers and the stat, health, and pet reads, which skip what no enabled entry
-- shows, write a value the moment an entry starts showing it (settings in harness/README.md).
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

-- What the stubbed APIs answer from.
local world = { now = 1000, playerCast = nil, pet = false, health = 100000 }

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	-- Files alias these at load, so they are replaced before any file loads.
	G.GetTime = function() return world.now end
	G.GetTimePreciseSec = function() return world.now end
	G.UnitCastingInfo = function(unit)
		local cast = unit == "player" and world.playerCast or nil
		if cast == nil then
			return nil
		end
		return cast.name, cast.name, cast.icon, cast.startTime * 1000, cast.endTime * 1000, false, cast.castId, false, cast.spellId
	end
	G.UnitExists = function(unit) return unit == "player" or (unit == "pet" and world.pet) end
	G.UnitIsDead = function() return false end
	G.UnitHealth = function(unit) return unit == "pet" and 4000 or world.health end
	G.UnitHealthMax = function(unit) return unit == "pet" and 5000 or 200000 end
	G.UnitGetTotalAbsorbs = function() return 1500 end
	G.UnitGetIncomingHeals = function() return 2500 end
	G.UnitGetTotalHealAbsorbs = function() return 3500 end
	-- Brewmaster's and Evoker's ticks read these.
	G.UnitStagger = function() return 0 end
	G.UnitPartialPower = function() return 0 end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local errors = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail ~= nil) and (" (" .. tostring(detail) .. ")") or ""))
		if not ok then
			errors = errors + 1
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	for i = 1, 20 do
		local _, timerFailures = stubs.fireEvents("TRB_DRAIN_SETUP_" .. i, ctx.addonName)
		if timerFailures == 0 then
			break
		end
	end

	local BarText = TRB.Functions.BarText
	local cache = TRB.Data.specCache[TRB.Data.character.compositeKey]
	if not TRB.Data.specSupported or cache == nil or cache.settings.displayText == nil then
		check("the specialization has bar text", false)
		print(string.format("DRIVER bartext-refresh: %d failures", errors))
		return errors
	end
	local settings = cache.settings
	local displayText = settings.displayText

	---A screen entry reading a label and a variable's text.
	---@param label string
	---@param variable string
	local function Entry(label, variable)
		local entry = TRB.Functions.Settings:LoadDefaultOtherBarTextSettings("UIParent", label, variable, "CENTER", 12, true)
		entry.text = label .. "=" .. variable
		return entry
	end
	local list = { Entry("x", "$inCombat") }
	displayText.barText = list

	---Rebuilds the text frames as the options do after the entry list changes.
	local function Rebuild()
		TRB.Data.activeVariables = nil
		BarText:CreateBarTextFrames()
	end
	local function Pass()
		world.now = world.now + 0.05
		TRB.Data.lookupDirty = true
		BarText:UpdateResourceBarText(settings, true)
	end
	---@param index integer
	---@return string
	local function Text(index)
		local frame = TRB.Frames.textFrames[index]
		return frame ~= nil and frame.font ~= nil and frame.font:GetText() or ""
	end
	---@param index integer
	---@param expected string
	local function Reads(index, expected)
		return string.find(Text(index), expected, 1, true) ~= nil
	end
	---@param entry table
	---@return integer index
	local function Add(entry)
		list[#list + 1] = entry
		Rebuild()
		return #list
	end

	Rebuild()
	Pass()
	check("the first entry draws", Reads(1, "x=false"), Text(1))

	-- Stats: one is read on its event, and formatted only while an enabled entry shows it.
	local stat = TRB.Flavor.stats[1]
	local statVariable = stat.variables[1]
	local statEvent = nil
	for event, buckets in pairs(TRB.Data.statEventBuckets) do
		for _, bucket in ipairs(buckets) do
			if bucket == stat.refresh and (statEvent == nil or event < statEvent) then
				statEvent = event
			end
		end
	end
	local statValue = 12.5
	stat.read = function() return statValue end
	local attributes = TRB.Data.snapshotData.attributes
	local formatted = TRB.Data.snapshotData.formatted
	check("the stat has an event", statEvent ~= nil)
	if statEvent ~= nil then
		local statEventSpec = statEvent .. (string.sub(statEvent, 1, 5) == "UNIT_" and ":player" or "")
		local function StatEvent()
			stubs.fireEvents(statEventSpec, ctx.addonName)
		end
		StatEvent()
		Pass()
		check("a stat no entry shows is read", attributes[stat.key] == 12.5 and TRB.Data.lookupLogic[statVariable] == 12.5, attributes[stat.key])
		check("a stat no entry shows is not formatted", formatted[stat.key] == nil, formatted[stat.key])

		local statIndex = Add(Entry("s", statVariable))
		Pass()
		local first = formatted[stat.key]
		check("an entry that starts showing a stat formats it", type(first) == "string" and first ~= "", first)
		check("and draws it on that pass", first ~= nil and Reads(statIndex, "s=" .. tostring(first)), Text(statIndex))

		statValue = 47
		StatEvent()
		Pass()
		local second = formatted[stat.key]
		check("a stat event redraws the shown stat", second ~= first and second ~= nil and Reads(statIndex, "s=" .. tostring(second)), Text(statIndex))

		list[statIndex].enabled = false
		TRB.Data.activeVariables = nil
		statValue = 3
		StatEvent()
		Pass()
		check("a stat whose entry is turned off stops being formatted", formatted[stat.key] == nil and attributes[stat.key] == 3, formatted[stat.key])
		list[statIndex].enabled = true
		TRB.Data.activeVariables = nil
		Pass()
		check("and is formatted again when the entry comes back, with no stat event", formatted[stat.key] ~= nil and Reads(statIndex, "s=" .. tostring(formatted[stat.key])), Text(statIndex))
	end

	-- Other Bars: an idle bar's text reads its zero as soon as an entry shows it, though another bar's entry already
	-- had the refresher settled.
	if settings.bars ~= nil and settings.bars.fatigue ~= nil and settings.bars.breath ~= nil then
		local fatigueIndex = Add(Entry("f", "$fatigueDurationRemaining"))
		Pass()
		Pass()
		check("an idle timer bar's text reads zero", Reads(fatigueIndex, "f=00:00"), Text(fatigueIndex))
		local breathIndex = Add(Entry("b", "$breathDurationRemaining"))
		Pass()
		check("a second idle timer bar's text reads zero once an entry shows it", Reads(breathIndex, "b=00:00"), Text(breathIndex))
		check("and no variable is left unwritten", TRB.Data.lookup["$breathDuration"] == "00:00" and TRB.Data.lookup["$fatigueDuration"] == "00:00",
			tostring(TRB.Data.lookup["$breathDuration"]))
	else
		check("the specialization has Fatigue and Breath bars", false)
	end

	-- Health: each piece is read on its event, and abbreviated only while an enabled entry shows it.
	local function HealthEvent()
		stubs.fireEvents("UNIT_HEALTH:player", ctx.addonName)
		TRB.Functions.Character:FlushHealthValues()
	end
	HealthEvent()
	Pass()
	check("health no entry shows is read", attributes.health == 100000 and attributes.absorb == 1500 and attributes.incomingHeal == 2500
		and attributes.healAbsorb == 3500, attributes.health)
	check("health no entry shows is not formatted", formatted.health == nil and formatted.healthMax == nil and formatted.absorb == nil
		and formatted.incomingHeal == nil and formatted.healAbsorb == nil, formatted.health)
	local healthIndex = Add(Entry("h", "$health"))
	Pass()
	local firstHealth = formatted.health
	check("an entry that starts showing health formats it, with no health event", type(firstHealth) == "string" and firstHealth ~= "", firstHealth)
	check("and draws it on that pass", firstHealth ~= nil and Reads(healthIndex, "h=" .. tostring(firstHealth)), Text(healthIndex))
	check("the pieces still not shown stay unformatted", formatted.healthMax == nil and formatted.absorb == nil and formatted.incomingHeal == nil
		and formatted.healAbsorb == nil, formatted.healthMax)
	world.health = 54321
	HealthEvent()
	Pass()
	check("a health event redraws the shown piece alone", formatted.health ~= firstHealth and Reads(healthIndex, "h=" .. tostring(formatted.health))
		and formatted.healthMax == nil and formatted.absorb == nil, Text(healthIndex))
	local absorbIndex = Add(Entry("a", "$absorb"))
	Pass()
	check("an entry that starts showing the absorb draws it", formatted.absorb ~= nil and Reads(absorbIndex, "a=" .. tostring(formatted.absorb)), Text(absorbIndex))

	-- Pet: the same, for the values the pet refresher abbreviates. Any specialization stands in for one with a pet.
	TRB.Classes.BarTypeRegistry.SpecHasPet = function() return true end
	world.pet = true
	-- A specialization without a pet never registered the pet events, so the read is called as they would call it.
	TRB.Functions.Character:UpdatePetValues()
	BarText:ClearBarTextCacheHash()
	local petNameIndex = Add(Entry("n", "$petHealthPercent"))
	Pass()
	check("pet text draws with a pet out", Reads(petNameIndex, "n=80"), Text(petNameIndex))
	check("a pet value no entry shows stays empty", TRB.Data.lookup["$petHealth"] == "" and TRB.Data.lookup["$petHealthMax"] == "",
		TRB.Data.lookup["$petHealth"])
	local petHealthIndex = Add(Entry("p", "$petHealth"))
	Pass()
	local petHealth = TRB.Data.lookup["$petHealth"]
	check("an entry that starts showing the pet's health draws it, with no pet event", type(petHealth) == "string" and petHealth ~= ""
		and Reads(petHealthIndex, "p=" .. tostring(petHealth)), Text(petHealthIndex))
	check("the pet value still not shown stays empty", TRB.Data.lookup["$petHealthMax"] == "", TRB.Data.lookup["$petHealthMax"])

	-- Cast bar: the values a cast holds are written when they change, not on every pass.
	local castIndex = Add(Entry("t", "$castTime"))
	local idIndex = Add(Entry("i", "$castSpellId"))
	Pass()
	check("cast text is empty with nothing casting", Reads(castIndex, "t=") and not Reads(castIndex, "t=1"), Text(castIndex))
	local function Cast(castId, spellId, seconds)
		world.playerCast = { name = "Test Spell", icon = 136000, startTime = world.now, endTime = world.now + seconds, castId = castId, spellId = spellId }
		stubs.fireEvents("UNIT_SPELLCAST_START:player;" .. castId .. ";" .. spellId, ctx.addonName)
	end
	local function EndCast(castId, spellId)
		world.playerCast = nil
		stubs.fireEvents("UNIT_SPELLCAST_STOP:player;" .. castId .. ";" .. spellId, ctx.addonName)
		stubs.fireEvents("UNIT_SPELLCAST_SUCCEEDED:player;" .. castId .. ";" .. spellId, ctx.addonName)
	end
	Cast("cast1", 589, 1.5)
	Pass()
	local firstId = Text(idIndex)
	check("a cast draws its length", Reads(castIndex, "t=1.5"), Text(castIndex))
	Pass()
	Pass()
	check("and holds it through the cast", Reads(castIndex, "t=1.5") and Text(idIndex) == firstId, Text(castIndex))
	EndCast("cast1", 589)
	Cast("cast2", 589, 2)
	Pass()
	check("the same spell chained onto it draws its own length", Reads(castIndex, "t=2.0") and Text(idIndex) == firstId, Text(castIndex))
	EndCast("cast2", 589)
	Cast("cast2", 116, 2)
	Pass()
	check("another spell of the same length draws its own spell", Reads(castIndex, "t=2.0") and Text(idIndex) ~= firstId, Text(idIndex))

	-- A specialization change replaces the logic table mid-cast.
	local secondId = Text(idIndex)
	TRB.Data.lookupLogic = {}
	BarText:InvalidateLookupMemoization()
	Pass()
	check("a replaced logic table gets the cast's values again", TRB.Data.lookupLogic["$castTime"] == 2 and Reads(castIndex, "t=2.0")
		and Text(idIndex) == secondId, tostring(TRB.Data.lookupLogic["$castTime"]) .. " | " .. Text(castIndex))
	-- And a replaced display table.
	TRB.Data.lookup = {}
	BarText:InvalidateLookupMemoization()
	Pass()
	check("a replaced display table gets the cast's values again", TRB.Data.lookup["$castTime"] == "2.0" and Reads(castIndex, "t=2.0")
		and Text(idIndex) == secondId, tostring(TRB.Data.lookup["$castTime"]) .. " | " .. Text(castIndex))

	EndCast("cast2", 116)
	Pass()
	Pass()
	check("cast text empties when the cast ends", Reads(castIndex, "t=") and not Reads(castIndex, "t=2"), Text(castIndex))

	print(string.format("DRIVER bartext-refresh: %d failures", errors))
	return errors
end

return hooks
