-- Checks that every specialization's spellsById lists each spell once under each of its ids, through the SwitchSpec re-runs after a loading screen, a talent change, and a specialization change.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
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

	-- Counting fills shows each event re-filled, so a clean list isn't just one that was never filled again.
	local fills = 0
	local innerFill = TRB.Classes.SpellsData.FillSpellData
	TRB.Classes.SpellsData.FillSpellData = function(...)
		fills = fills + 1
		return innerFill(...)
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")
	check("the deferred setup finishes, so later events re-run SwitchSpec", TRB.Details.addonData.optionsPanelFinished == true)

	local idFields = { "id", "buffId", "debuffId", "energizeId", "talentId", "castId", "tickId" }

	---Every filled specialization's spellsById problems: a spell listed twice, a spell missing under one of its ids, or a spell no longer in its spells.
	---@return string[]
	local function Problems()
		local problems = {}
		local keys = {}
		for key in pairs(TRB.Data.specCache or {}) do
			keys[#keys + 1] = key
		end
		table.sort(keys)
		for _, key in ipairs(keys) do
			local spellsData = TRB.Data.specCache[key].spellsData
			if spellsData ~= nil and next(spellsData.spellsById) ~= nil then
				local current = {}
				for _, spell in pairs(spellsData.spells) do
					current[spell] = true
					for _, field in ipairs(idFields) do
						local id = spell[field]
						if id ~= nil and not tContains(spellsData.spellsById[id] or {}, spell) then
							problems[#problems + 1] = string.format("%s %s %s not listed", key, field, tostring(id))
						end
					end
				end
				for id, list in pairs(spellsData.spellsById) do
					local seen = {}
					for _, spell in ipairs(list) do
						if seen[spell] then
							problems[#problems + 1] = string.format("%s %s listed twice", key, tostring(id))
						elseif not current[spell] then
							problems[#problems + 1] = string.format("%s %s lists a spell no longer in its spells", key, tostring(id))
						end
						seen[spell] = true
					end
				end
			end
		end
		table.sort(problems)
		return problems
	end

	local function CheckLists(label)
		local problems = Problems()
		local shown = {}
		for i = 1, math.min(#problems, 5) do
			shown[i] = problems[i]
		end
		check(label .. ": spellsById lists each spell once under each of its ids" .. (#problems > 0 and " (" .. #problems .. " problems: " .. table.concat(shown, "; ") .. ")" or ""), #problems == 0)
	end

	local function Step(label, event)
		local before = fills
		stubs.fireEvents(event, ctx.addonName)
		Drain(event:match("^[^:]+"))
		check(label .. ": spell data filled again", fills > before)
		CheckLists(label)
	end

	local function SetSpec(index)
		desktop.GetSpecialization = function() return index end
		desktop.C_SpecializationInfo.GetSpecialization = function() return index end
	end

	CheckLists("after login")

	local entries = {}
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if entry.classId == ctx.classId then
			entries[#entries + 1] = entry
		end
	end
	-- The login spec goes last, so every specialization of a multi-spec class is changed into.
	if #entries > 1 then
		table.insert(entries, table.remove(entries, 1))
	end
	local current = desktop.C_SpecializationInfo.GetSpecialization()
	for _, entry in ipairs(entries) do
		local change = entry.specId ~= current and "a specialization change" or "a same-specialization event"
		current = entry.specId
		SetSpec(entry.specId)
		Step(entry.compositeKey .. " after " .. change, "PLAYER_SPECIALIZATION_CHANGED")
		Step(entry.compositeKey .. " after a loading screen", "PLAYER_ENTERING_WORLD")
		Step(entry.compositeKey .. " after a second loading screen", "PLAYER_ENTERING_WORLD")
		Step(entry.compositeKey .. " after a talent change", "TRAIT_CONFIG_UPDATED:12345")
		for _, talentEvent in ipairs(TRB.Flavor.talentEvents) do
			Step(entry.compositeKey .. " after " .. talentEvent, talentEvent)
		end
	end

	return errors
end

return hooks
