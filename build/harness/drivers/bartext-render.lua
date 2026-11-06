-- Plays a fixed scenario through the real 20Hz tick and event handlers, writing every bar text change to
-- TRB_RENDER_OUT for build/render-compare.ps1 (settings in harness/README.md).
local desktop = _G --[[@as table<string, any>]]
local os, io, debug = desktop.os, desktop.io, desktop.debug
local parity = desktop.require("drivers.parity")

-- About 57fps, so three frames always reach the 20Hz tick's 0.05s, as they do in game.
local FRAME = 0.0175

-- Everything the stubbed APIs below answer from; the scenario changes it between steps.
local world = {
	now = 1000,
	speed = 0,
	power = 0,
	playerCast = nil,
	targetCast = nil,
	gcdEnd = nil,
	pet = false,
	totem = nil,
	target = false,
}

-- Entries added on top of the save's own, on the screen so no bar's visibility hides them.
local EXTRA_TEXTS = {
	"$movementSpeed",
	"{$movementSpeed}[moving][still]",
	"{$castTimeRemaining}[$castTimeRemaining #casting][no cast]",
	"{$gcdDurationRemaining}[$gcdDurationRemaining][no gcd]",
	"{$petHealth}[$petHealth $petState][no pet]",
	"{$totem1Time}[$totem1Time][no totem]",
	"{$targetCastTimeRemaining}[$targetCastTimeRemaining][no target cast]",
	"{$inCombatTime}[$inCombatTime][out of combat]",
}

---A DurationObject stand-in that counts down on the scenario clock.
---@param startTime number
---@param endTime number
local function NewDuration(startTime, endTime)
	local methods = {
		GetRemainingDuration = function() return math.max(0, endTime - world.now) end,
		GetTotalDuration = function() return endTime - startTime end,
		GetElapsedDuration = function() return math.min(endTime - startTime, world.now - startTime) end,
		GetStartTime = function() return startTime end,
		GetEndTime = function() return endTime end,
		IsZero = function() return world.now >= endTime end,
		EvaluateRemainingDuration = function(_, curve) return curve:Evaluate(math.max(0, endTime - world.now)) end,
		EvaluateRemainingPercent = function(_, curve)
			return curve:Evaluate(math.max(0, endTime - world.now) / (endTime - startTime))
		end,
		EvaluateElapsedPercent = function(_, curve)
			return curve:Evaluate(math.min(1, (world.now - startTime) / (endTime - startTime)))
		end,
	}
	return setmetatable({}, { __index = function(_, key)
		return methods[key] or function() return 0 end
	end })
end

---UnitCastingInfo's answer for a cast record.
local function CastInfo(cast)
	if cast == nil then
		return nil
	end
	return cast.name, cast.name, cast.icon, cast.startTime * 1000, cast.endTime * 1000, false, cast.castId, false, cast.spellId
end

local updateFrames = {}
local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = tonumber(os.getenv("TRB_SPEC") or ""), holdDeferredSetup = true })
	local G = desktop

	-- Files alias these at load, so they are replaced before any file loads.
	G.GetTime = function() return world.now end
	G.GetTimePreciseSec = function() return world.now end
	G.GetUnitSpeed = function(unit) return unit == "player" and world.speed or 0 end
	G.UnitPower = function() return world.power end
	G.UnitStagger = function() return 0 end
	G.UnitPartialPower = function() return 0 end
	G.UnitExists = function(unit)
		return unit == "player" or (unit == "pet" and world.pet) or (unit == "target" and world.target)
	end
	G.UnitIsDead = function() return false end
	G.UnitHealth = function(unit) return unit == "pet" and 4000 or 100000 end
	G.UnitHealthMax = function(unit) return unit == "pet" and 5000 or 100000 end
	G.UnitCastingInfo = function(unit)
		if unit == "player" then
			return CastInfo(world.playerCast)
		elseif unit == "target" then
			return CastInfo(world.targetCast)
		end
	end
	G.UnitCastingDuration = function(unit)
		local cast = unit == "player" and world.playerCast or (unit == "target" and world.targetCast or nil)
		return cast ~= nil and NewDuration(cast.startTime, cast.endTime) or nil
	end
	G.GetTotemInfo = function(slot)
		local totem = slot == 1 and world.totem or nil
		if totem == nil then
			return false, "", 0, 0, 0
		end
		return true, "Test Totem", totem.startTime, totem.endTime - totem.startTime, 136001
	end
	G.GetTotemDuration = function(slot)
		local totem = slot == 1 and world.totem or nil
		return totem ~= nil and NewDuration(totem.startTime, totem.endTime) or nil
	end
	local spellApi = G.C_Spell
	local baseCooldown, baseCooldownDuration = spellApi.GetSpellCooldown, spellApi.GetSpellCooldownDuration
	spellApi.GetSpellCooldown = function(spellId)
		if world.gcdEnd ~= nil and spellId == G.TRB_GCD_SPELL_ID then
			return { startTime = world.gcdEnd - 1.5, duration = 1.5, isEnabled = true, modRate = 1 }
		end
		return baseCooldown(spellId)
	end
	spellApi.GetSpellCooldownDuration = function(spellId)
		if world.gcdEnd ~= nil and spellId == G.TRB_GCD_SPELL_ID then
			return NewDuration(world.gcdEnd - 1.5, world.gcdEnd)
		end
		return baseCooldownDuration(spellId)
	end

	-- Every frame's OnUpdate runs each tick, as the client runs a shown frame's.
	local innerCreate = G.CreateFrame
	G.CreateFrame = function(...)
		local frame = innerCreate(...)
		updateFrames[#updateFrames + 1] = frame
		return frame
	end
end

function hooks.afterLoad(ctx)
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup.
	ctx.TRB.Functions.News.Init = function() end
	desktop.TRB_GCD_SPELL_ID = ctx.TRB.Flavor.gcdSpellId
end

---Whether a frame and all its parents are shown.
local function IsVisible(frame)
	while frame ~= nil do
		if rawget(frame, "__shown") == false then
			return false
		end
		frame = rawget(frame, "__parent")
	end
	return true
end

function hooks.afterEvents(ctx)
	local outPath = os.getenv("TRB_RENDER_OUT")
	if outPath == nil or outPath == "" then
		return
	end
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local out = assert(io.open(outPath, "wb"))
	local stepName = "login"
	local tickCount = 0
	local lastText = {}

	local function Write(line)
		out:write(line, "\n")
	end

	local function Fire(spec)
		local failures, timerFailures = stubs.fireEvents(spec, ctx.addonName)
		if failures > 0 or timerFailures > 0 then
			Write(string.format("%s EVENTFAIL %s handlers=%d timers=%d", stepName, spec:match("^[^:]+"), failures, timerFailures))
		end
	end

	local function Record()
		for i, frame in ipairs(TRB.Frames.textFrames or {}) do
			local text = frame.font and rawget(frame.font, "__text") or ""
			if lastText[i] ~= text then
				lastText[i] = text
				Write(string.format("%s t%d #%d %q", stepName, tickCount, i, tostring(text)))
			end
		end
	end

	---Runs count 20Hz periods of three frames each.
	local function Tick(count)
		for _ = 1, count * 3 do
			world.now = world.now + FRAME
			tickCount = tickCount + 1
			for _, frame in ipairs(updateFrames) do
				local script = frame.__scripts and frame.__scripts.OnUpdate
				if script ~= nil and IsVisible(frame) then
					local ok, err = xpcall(function() script(frame, FRAME) end, function(e) return debug.traceback(tostring(e), 2) end)
					if not ok then
						Write(string.format("%s t%d UPDATEFAIL %s", stepName, tickCount, tostring(rawget(frame, "__name"))))
						print("UPDATE ERROR " .. tostring(err))
					end
				end
			end
			Record()
		end
	end

	local function Step(name)
		stepName = name
		Write("== " .. name)
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	Fire(parity.releaseEvent)
	for i = 1, 10 do
		local _, timerFailures = stubs.fireEvents("TRB_DRAIN_" .. i, ctx.addonName)
		if timerFailures == 0 then
			break
		end
	end

	local specCache = TRB.Functions.Character:GetActiveSpecCache()
	local displayText = specCache and specCache.settings and specCache.settings.displayText
	if displayText == nil then
		Write("no bar text settings")
		out:close()
		print("RENDER no bar text settings key=" .. tostring(TRB.Data.character.compositeKey))
		return
	end
	-- TRB_RENDER_SAVE_ONLY=1 keeps only the save's entries, so variables nothing shows stay unused.
	local extraTexts = os.getenv("TRB_RENDER_SAVE_ONLY") == "1" and {} or EXTRA_TEXTS
	for _, text in ipairs(extraTexts) do
		local entry = TRB.Functions.Settings:LoadDefaultOtherBarTextSettings("UIParent", "Screen", "$movementSpeed", "CENTER", 12, true)
		entry.text = text
		table.insert(displayText.barText, entry)
	end
	-- The GCD bar only starts while shown.
	local displaySettings = TRB.Functions.Class:GetActiveDisplaySettings()
	local gcdVisibility = displaySettings and displaySettings.displayBar and displaySettings.displayBar.gcd
	if gcdVisibility ~= nil then
		gcdVisibility.neverShow = false
		gcdVisibility.alwaysShow = true
		TRB.Functions.OtherBars:SyncGcdEvents()
		TRB.Functions.OtherBars:RefreshVisibility()
	end
	TRB.Data.activeVariables = nil
	TRB.Functions.BarText:CreateBarTextFrames()

	Step("idle")
	Tick(20)

	Step("power")
	world.power = 50
	Fire("UNIT_POWER_UPDATE:player;" .. tostring(TRB.Data.resourceToken or "MANA"))
	Tick(10)

	Step("move")
	world.speed = 7
	Fire("PLAYER_STARTED_MOVING")
	Tick(10)
	world.speed = 14
	Tick(10)

	Step("stop")
	world.speed = 0
	Fire("PLAYER_STOPPED_MOVING")
	Tick(10)

	Step("shove")
	world.speed = 7
	Tick(10)
	world.speed = 0
	Tick(10)

	Step("combat")
	Fire("PLAYER_REGEN_DISABLED")
	Tick(30)

	Step("cast")
	world.playerCast = { name = "Test Spell", icon = 136000, startTime = world.now, endTime = world.now + 1.5, castId = "cast1", spellId = 589 }
	world.gcdEnd = world.now + 1.5
	Fire("UNIT_SPELLCAST_START:player;cast1;589")
	Tick(10)
	world.playerCast = nil
	Fire("UNIT_SPELLCAST_STOP:player;cast1;589")
	Fire("UNIT_SPELLCAST_SUCCEEDED:player;cast1;589")
	Tick(25)
	world.gcdEnd = nil
	Tick(5)

	Step("pet")
	world.pet = true
	Fire("UNIT_PET:player")
	Tick(10)
	world.pet = false
	Fire("UNIT_PET:player")
	Tick(10)

	Step("totem")
	world.totem = { startTime = world.now, endTime = world.now + 1 }
	Fire("PLAYER_TOTEM_UPDATE:1")
	Tick(10)
	world.totem = nil
	Fire("PLAYER_TOTEM_UPDATE:1")
	Tick(10)

	Step("target cast")
	world.target = true
	Fire("PLAYER_TARGET_CHANGED")
	world.targetCast = { name = "Enemy Spell", icon = 136002, startTime = world.now, endTime = world.now + 1, castId = "cast2", spellId = 116 }
	Fire("UNIT_SPELLCAST_START:target;cast2;116")
	Tick(10)
	world.targetCast = nil
	Fire("UNIT_SPELLCAST_SUCCEEDED:target;cast2;116")
	Tick(15)

	Step("leave combat")
	Fire("PLAYER_REGEN_ENABLED")
	Tick(20)

	out:close()
	print(string.format("RENDER written ticks=%d entries=%d key=%s", tickCount, #(TRB.Frames.textFrames or {}), tostring(TRB.Data.character.compositeKey)))
end

return hooks
