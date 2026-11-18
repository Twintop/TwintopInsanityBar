-- Checks that spells sharing an ID share one usability read, and that a threshold line reads usability only when a
-- rule asks, without losing the one-second floor or the bar text repaint (settings in harness/README.md).
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

-- What the stubbed APIs answer from.
local world = { now = 1000, usable = {}, reads = {} }

local SHARED_ID = 990001
local OTHER_ID = 990002

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1 })
	local G = desktop
	-- Files alias these at load, so they are replaced before any file loads.
	G.GetTime = function() return world.now end
	G.GetTimePreciseSec = function() return world.now end
	G.C_Spell.IsSpellUsable = function(id)
		world.reads[id] = (world.reads[id] or 0) + 1
		local answer = world.usable[id]
		if answer == nil then
			return true, false
		end
		return answer[1], answer[2]
	end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local errors = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail ~= nil) and (" (" .. tostring(detail) .. ")") or ""))
		if not ok then
			errors = errors + 1
		end
	end

	local SpellBase = TRB.Classes.SpellBase
	-- Outside the tick, so each ask reads the stubbed clock.
	SpellBase.SetTickTime(nil)
	local first = SpellBase:New({
		id = SHARED_ID,
	})
	local second = SpellBase:New({
		id = SHARED_ID,
	})
	local other = SpellBase:New({
		id = OTHER_ID,
	})
	local function Reads(id)
		return world.reads[id] or 0
	end
	---Fires the event's own invalidation and moves the clock, so the checks before it can't satisfy the ones after.
	local function NewGeneration()
		world.now = world.now + 10
		SpellBase.InvalidateSpellUsable()
	end

	NewGeneration()
	local firstUsable, secondUsable = first:IsUsable(), second:IsUsable()
	check("Two spells with one ID share a read", Reads(SHARED_ID) == 1, Reads(SHARED_ID))
	check("Both answer usable from it", firstUsable == true and secondUsable == true)
	other:IsUsable()
	check("A spell with another ID reads for itself", Reads(OTHER_ID) == 1 and Reads(SHARED_ID) == 1, Reads(OTHER_ID))
	first:IsUsable()
	second:InsufficientPower()
	check("Asking again before anything changes reads nothing", Reads(SHARED_ID) == 1, Reads(SHARED_ID))

	world.usable[SHARED_ID] = { false, true }
	NewGeneration()
	local before = Reads(SHARED_ID)
	firstUsable, secondUsable = first:IsUsable(), second:IsUsable()
	check("After SPELL_UPDATE_USABLE, the pair reads once more", Reads(SHARED_ID) == before + 1, Reads(SHARED_ID) - before)
	check("Both answer unusable and short on power", firstUsable == false and secondUsable == false
		and first:InsufficientPower() == true and second:InsufficientPower() == true)

	-- The floor, with no event: a read is good for under a second, counted from the read.
	NewGeneration()
	first:IsUsable()
	before = Reads(SHARED_ID)
	world.now = world.now + 0.6
	second:IsUsable()
	check("A spell that asks later in the second joins the read", Reads(SHARED_ID) == before, Reads(SHARED_ID) - before)
	world.now = world.now + 0.45
	second:IsUsable()
	check("It doesn't hold that read past the read's own second", Reads(SHARED_ID) == before + 1, Reads(SHARED_ID) - before)
	first:IsUsable()
	check("The spell that read first joins the new one", Reads(SHARED_ID) == before + 1, Reads(SHARED_ID) - before)
	world.now = world.now + 1.05
	first:IsUsable()
	check("With no event, a spell reads again after a second", Reads(SHARED_ID) == before + 2, Reads(SHARED_ID) - before)

	-- A re-read that differs repaints bar text, once for each spell that held the old answer.
	NewGeneration()
	first:IsUsable()
	second:IsUsable()
	world.usable[SHARED_ID] = { true, false }
	world.now = world.now + 1.05
	TRB.Data.lookupDirty = false
	first:IsUsable()
	check("A changed answer marks bar text dirty", TRB.Data.lookupDirty == true)
	TRB.Data.lookupDirty = false
	second:IsUsable()
	check("The spell that joins the changed read marks it dirty too", TRB.Data.lookupDirty == true)
	TRB.Data.lookupDirty = false
	world.now = world.now + 1.05
	first:IsUsable()
	second:IsUsable()
	check("An unchanged re-read leaves it clean", TRB.Data.lookupDirty == false)

	-- A threshold pass: a line reads its spell's usability only when one of its rules asks.
	local G = desktop
	local Threshold = TRB.Functions.Threshold
	local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	local powerType = G.Enum.PowerType.Mana
	-- A cost on the bar, so the generic rules reach their usability check.
	G.C_Spell.GetSpellPowerCost = function()
		return { { type = powerType, cost = 30, minCost = 30 } }
	end
	---@param key string
	---@param id integer
	---@param isSnowflake boolean
	---@param stealth boolean?
	---@return TRB.Classes.SpellThreshold
	local function NewLine(key, id, isSnowflake, stealth)
		return TRB.Classes.SpellThreshold:New({
			id = id,
			settingKey = key,
			primaryResourceType = powerType,
			isSnowflake = isSnowflake,
			stealth = stealth,
		})
	end
	local UNUSABLE_ID, USABLE_ID, UNASKED_ID, STEALTH_ID, TWICE_ID = 990011, 990012, 990013, 990014, 990015
	local lineIds = { UNUSABLE_ID, USABLE_ID, UNASKED_ID, STEALTH_ID, TWICE_ID }
	local twice = NewLine("driverTwice", TWICE_ID, true)
	local twiceAsks = 0
	rawset(twice, "IsUsable", function(self)
		twiceAsks = twiceAsks + 1
		return SpellBase.IsUsable(self)
	end)
	-- The unusable line goes first, so an answer carried over from the line before would show on the usable one.
	local data = {
		thresholdSpells = {
			NewLine("driverUnusable", UNUSABLE_ID, false),
			NewLine("driverUsable", USABLE_ID, false),
			NewLine("driverUnasked", UNASKED_ID, true),
			NewLine("driverStealth", STEALTH_ID, false, true),
			twice,
		},
		spells = TRB.Data.spellsData.spells,
		talents = TRB.Data.talents,
		requireKnown = false,
	}
	local snowflakes = {
		spells = {
			driverUnasked = function(line) line:Unusable() end,
			driverTwice = function(line)
				if line:IsUsable() and line:IsUsable() then
					line:Over()
				end
			end,
		},
	}
	world.usable[UNUSABLE_ID] = { false, true }

	local nodeFrame = G.CreateFrame("Frame")
	local nodeThresholds = {}
	local node = {
		GetFrame = function() return nodeFrame end,
		GetThresholds = function() return nodeThresholds end,
		RegisterThreshold = function(_, frame) nodeThresholds[#nodeThresholds + 1] = frame end,
	}
	local bar = TRB.Classes.ThresholdBar:New()
	bar:Set(node, 1000000)
	local state = TRB.Classes.ThresholdState:New()

	-- What each line was handed to the draw step with.
	local drawn = {}
	local adjust = Threshold.AdjustThresholdDisplay
	Threshold.AdjustThresholdDisplay = function(self, spell, key, threshold, showThreshold, frameLevel, pairOffset, color, ...)
		drawn[key] = { show = showThreshold, color = color }
		return adjust(self, spell, key, threshold, showThreshold, frameLevel, pairOffset, color, ...)
	end
	local readsBefore = {}
	---Runs one pass and returns how many reads each line's spell made in it.
	---@return table<integer, integer>?
	local function Pass()
		for _, id in ipairs(lineIds) do
			readsBefore[id] = Reads(id)
		end
		state:Refresh(settings)
		local ok, err = pcall(Threshold.UpdateSpellThresholds, Threshold, bar, state, data, snowflakes)
		if not ok then
			check("A threshold pass runs without an error", false, err)
			return nil
		end
		local made = {}
		for _, id in ipairs(lineIds) do
			made[id] = Reads(id) - readsBefore[id]
		end
		return made
	end
	---The next tick, with SPELL_UPDATE_USABLE fired since the last.
	local function NextTick()
		world.now = world.now + 0.05
		SpellBase.InvalidateSpellUsable()
	end

	NewGeneration()
	local made = Pass()
	if made ~= nil then
		local colors = settings.colors.threshold
		check("A usable line after an unusable one draws in its own color", drawn.driverUsable.color == colors.over.color
			and drawn.driverUnusable.color == colors.under.color and drawn.driverUsable.show == true,
			tostring(drawn.driverUsable.color) .. " / " .. tostring(drawn.driverUnusable.color))
		check("A stealth line out of stealth is hidden", drawn.driverStealth.show == false)

		NextTick()
		twiceAsks = 0
		made = Pass() or {}
		check("A line whose rule asks reads once in a pass", made[USABLE_ID] == 1 and made[UNUSABLE_ID] == 1, made[USABLE_ID])
		check("A line hidden by its stealth gate reads nothing", made[STEALTH_ID] == 0, made[STEALTH_ID])
		check("A line whose rule doesn't ask reads nothing", made[UNASKED_ID] == 0, made[UNASKED_ID])
		check("A rule that asks twice asks the spell once", twiceAsks == 1, twiceAsks)

		-- With no event, the floor's re-read still reaches a line nothing asked about.
		world.now = world.now + 1.05
		made = Pass() or {}
		check("With no event, a line nothing asked about is re-read after a second", made[STEALTH_ID] == 1 and made[UNASKED_ID] == 1,
			tostring(made[STEALTH_ID]) .. " / " .. tostring(made[UNASKED_ID]))
		world.now = world.now + 0.05
		made = Pass() or {}
		check("It isn't read again on the next pass", made[STEALTH_ID] == 0 and made[UNASKED_ID] == 0 and made[USABLE_ID] == 0,
			tostring(made[STEALTH_ID]) .. " / " .. tostring(made[UNASKED_ID]) .. " / " .. tostring(made[USABLE_ID]))

		world.usable[STEALTH_ID] = { false, false }
		world.now = world.now + 1.05
		TRB.Data.lookupDirty = false
		Pass()
		check("That re-read marks bar text dirty when the answer changed", TRB.Data.lookupDirty == true)
		world.now = world.now + 1.05
		TRB.Data.lookupDirty = false
		Pass()
		check("An unchanged one leaves it clean", TRB.Data.lookupDirty == false)
	end
	Threshold.AdjustThresholdDisplay = adjust

	print(string.format("DRIVER spell-usable: %d failures", errors))
	return errors
end

return hooks
