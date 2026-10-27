-- Checks that range checks stay on through the SwitchSpec re-runs after a loading screen, a talent change, and a specialization change.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}
local frames = {}
local enabledIds = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local innerCreate = desktop.CreateFrame
	desktop.CreateFrame = function(...)
		local frame = innerCreate(...)
		frames[#frames + 1] = frame
		return frame
	end
	desktop.C_Spell.EnableSpellRangeCheck = function(id, enable)
		enabledIds[id] = enable == true or nil
	end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local Character = TRB.Functions.Character
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
	end
	-- Runs queued timers until none fail, past the stub errors deferred UI code hits.
	local function Drain(label)
		for i = 1, 20 do
			local _, timerFailures = stubs.fireEvents("TRB_DRAIN_" .. label .. "_" .. i, ctx.addonName)
			if timerFailures == 0 then
				return
			end
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")
	check("the deferred setup finishes, so later events re-run SwitchSpec", TRB.Details.addonData.optionsPanelFinished == true)

	-- Every SwitchSpec starts by turning range checks off, so counting that shows it re-ran.
	local switches = 0
	local disable = Character.DisableSpellRangeCheckUpdate
	Character.DisableSpellRangeCheckUpdate = function(...)
		switches = switches + 1
		return disable(...)
	end

	---@return boolean registered
	---@return string summary
	local function State()
		local registered = false
		for _, frame in ipairs(frames) do
			local events = rawget(frame, "__events")
			if events ~= nil and events.SPELL_RANGE_CHECK_UPDATE then
				registered = true
			end
		end
		local ids = {}
		for id in pairs(enabledIds) do
			ids[#ids + 1] = id
		end
		table.sort(ids)
		return registered, string.format("event %s, spells on: %s", registered and "registered" or "unregistered", #ids > 0 and table.concat(ids, " ") or "none")
	end

	-- On means turning the range checks on again changes nothing.
	local function CheckOn(label)
		local registered, now = State()
		if not TRB.Data.specSupported then
			check(label .. ": range checks stay off for an unsupported specialization", not registered)
			return
		end
		Character:EnableSpellRangeCheckUpdate()
		local _, expected = State()
		if now == expected then
			check(label .. ": range checks stay on", true)
		else
			check(string.format("%s: range checks stay on (%s; turning them on gives %s)", label, now, expected), false)
		end
	end

	local function Step(label, event)
		local before = switches
		stubs.fireEvents(event, ctx.addonName)
		Drain(event:match("^[^:]+"))
		check(label .. ": SwitchSpec ran again", switches > before)
		CheckOn(label)
	end

	local function SetSpec(index)
		desktop.GetSpecialization = function() return index end
		desktop.C_SpecializationInfo.GetSpecialization = function() return index end
	end

	CheckOn("after login")
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if entry.classId == ctx.classId then
			SetSpec(entry.specId)
			Step(entry.compositeKey .. " after a specialization change", "PLAYER_SPECIALIZATION_CHANGED")
			Step(entry.compositeKey .. " after a loading screen", "PLAYER_ENTERING_WORLD")
			Step(entry.compositeKey .. " after a talent change", "TRAIT_CONFIG_UPDATED:12345")
		end
	end
	return errors
end

return hooks
