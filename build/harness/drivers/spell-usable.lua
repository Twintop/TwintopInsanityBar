-- Checks that spells sharing an ID share one usability read, without holding it past the one-second floor or
-- dropping a spell's own bar text repaint (settings in harness/README.md).
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

	print(string.format("DRIVER spell-usable: %d failures", errors))
	return errors
end

return hooks
