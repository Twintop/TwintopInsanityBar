-- Checks the color of a combo point finisher's threshold line: its own rule's color while there are combo points, so
-- Under when short on power, and Unusable only with none (settings in harness/README.md).
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

-- What the stubbed APIs answer from.
local world = { now = 1000, usable = true, short = false }

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	local G = desktop
	-- Files alias these at load, so they are replaced before any file loads.
	G.GetTime = function() return world.now end
	G.GetTimePreciseSec = function() return world.now end
	G.C_Spell.IsSpellUsable = function() return world.usable, world.short end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local G = desktop
	local Character = TRB.Functions.Character
	local Threshold = TRB.Functions.Threshold
	local SpellBase = TRB.Classes.SpellBase
	local errors = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail ~= nil) and (" (" .. tostring(detail) .. ")") or ""))
		if not ok then
			errors = errors + 1
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	for i = 1, 20 do
		local _, timerFailures = stubs.fireEvents("TRB_DRAIN_SETUP_" .. i, ctx.addonName)
		if timerFailures == 0 then
			break
		end
	end

	-- The Core rule on its own: only a finisher, and only with no combo points, turns Unusable.
	local powerType = G.Enum.PowerType.Energy
	local finisher = TRB.Classes.SpellComboPointThreshold:New({
		id = 990021,
		settingKey = "driverFinisher",
		primaryResourceType = powerType,
		comboPoints = true,
	})
	local builder = TRB.Classes.SpellComboPointThreshold:New({
		id = 990022,
		settingKey = "driverBuilder",
		primaryResourceType = powerType,
		comboPoints = false,
	})
	local plain = TRB.Classes.SpellThreshold:New({
		id = 990023,
		settingKey = "driverPlain",
		primaryResourceType = powerType,
	})
	local ruleColors = { over = { color = "over" }, under = { color = "under" }, unusable = { color = "unusable" } }
	---The color the rule leaves on a line that came to it Under.
	---@param spell table
	---@param comboPoints integer?
	---@return string?
	local function RuleColor(spell, comboPoints)
		local line = TRB.Classes.ThresholdLine:New()
		line.spell = spell
		line.state = { settings = { colors = { threshold = ruleColors } }, snapshotData = { attributes = { resource2 = comboPoints } } }
		line.color = "under"
		line:UnusableWithoutComboPoints()
		return line.color
	end
	check("The rule turns a finisher with no combo points Unusable", RuleColor(finisher, 0) == "unusable" and RuleColor(finisher, nil) == "unusable")
	check("The rule leaves a finisher with combo points to its own color", RuleColor(finisher, 1) == "under" and RuleColor(finisher, 5) == "under")
	check("The rule leaves a line that spends no combo points alone", RuleColor(builder, 0) == "under" and RuleColor(plain, 0) == "under")

	-- Every finisher line of every specialization of the class, through its own rules.
	local costs = {}
	for _, costType in pairs(G.Enum.PowerType) do
		costs[#costs + 1] = { type = costType, cost = 30, minCost = 30 }
	end
	-- A cost on the bar, so the generic rules reach their usability check.
	G.C_Spell.GetSpellPowerCost = function() return costs end
	wipe(TRB.Data.cache.values.resource)

	local nodeFrame = G.CreateFrame("Frame")
	local nodeThresholds = {}
	local node = {
		GetFrame = function() return nodeFrame end,
		GetThresholds = function() return nodeThresholds end,
		RegisterThreshold = function(_, frame) nodeThresholds[#nodeThresholds + 1] = frame end,
	}
	local state = TRB.Classes.ThresholdState:New()
	local talents = { IsTalentActive = function() return true end }

	-- What each line was handed to the draw step with: its color, "curve" when a curve owns it, or false when hidden.
	local drawn = {}
	local adjust = Threshold.AdjustThresholdDisplay
	Threshold.AdjustThresholdDisplay = function(self, spell, key, threshold, showThreshold, frameLevel, pairOffset, color, ...)
		local isDrawn = adjust(self, spell, key, threshold, showThreshold, frameLevel, pairOffset, color, ...)
		drawn[key] = (showThreshold and isDrawn) and (color or "curve") or false
		return isDrawn
	end

	local entries = {}
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if entry.classId == ctx.classId then
			entries[#entries + 1] = entry
		end
	end
	-- Mainline's Feral and Vengeance color a finisher by usability alone, so they have no Unusable to check.
	local unusableWithoutComboPoints = ctx.classId == 4 or (ctx.classId == 11 and TRB.Flavor.id ~= "mainline")

	for _, entry in ipairs(entries) do
		Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		local cache = TRB.Data.specCache[entry.compositeKey]
		local spells = cache.spellsData.spells
		local settings = cache.settings
		local dictionary = settings.thresholds ~= nil and settings.thresholds.thresholdDictionary or {}
		local names = {}
		for name, spell in pairs(spells) do
			-- A line with no entry in this specialization's settings draws with another's, in that one's form.
			if type(spell) == "table" and spell.Is ~= nil and spell:Is("TRB.Classes.SpellComboPointThreshold") and spell.comboPoints == true
				and spell:IsValid() and not spell.isPvp and dictionary[spell.settingKey] ~= nil then
				names[#names + 1] = name
			end
		end
		table.sort(names)
		if #names > 0 then
			local finishers = {}
			-- A line draws only on its own bar, such as a Druid's Energy bar.
			local bars, barByTarget = {}, {}
			for i, name in ipairs(names) do
				finishers[i] = spells[name]
				dictionary[finishers[i].settingKey].enabled = true
				local barTarget = finishers[i].barTarget
				if barByTarget[barTarget] == nil then
					local bar = TRB.Classes.ThresholdBar:New(barTarget)
					bar:Set(node, 1000000)
					barByTarget[barTarget] = bar
					bars[#bars + 1] = bar
				end
			end
			local data = { thresholdSpells = finishers, spells = spells, talents = talents, requireKnown = false }
			local colors = settings.colors.threshold
			---Draws the finisher lines, and returns how many drew and the ones whose color fails the test.
			---@param comboPoints integer
			---@param usable boolean
			---@param short boolean
			---@param passes fun(color: string): boolean
			---@return integer?, string
			local function Draw(comboPoints, usable, short, passes)
				world.now = world.now + 2
				world.usable, world.short = usable, short
				SpellBase.InvalidateSpellUsable()
				for key in pairs(drawn) do
					drawn[key] = nil
				end
				state:Refresh(settings)
				state.snapshotData = cache.snapshotData
				cache.snapshotData.attributes.resource2 = comboPoints
				for _, bar in ipairs(bars) do
					local ok, err = pcall(Threshold.UpdateSpellThresholds, Threshold, bar, state, data, spells.thresholdSnowflakes)
					if not ok then
						return nil, tostring(err)
					end
				end
				local count, failed = 0, {}
				for _, spell in ipairs(finishers) do
					local color = drawn[spell.settingKey]
					if color then
						count = count + 1
						if not passes(color) then
							failed[#failed + 1] = spell.settingKey .. "=" .. tostring(color)
						end
					end
				end
				return count, table.concat(failed, ", ")
			end

			local key = entry.compositeKey
			local count, failed = Draw(3, true, false, function(color) return color ~= colors.unusable.color and color ~= colors.under.color end)
			check(key .. ": the finisher lines draw without an error", count ~= nil and count > 0, count == nil and failed or "none drew")
			if count ~= nil and count > 0 then
				check(key .. ": with combo points and usable, no finisher is Under or Unusable", failed == "", failed)
				count, failed = Draw(3, false, true, function(color) return color == colors.under.color end)
				check(key .. ": with combo points but short on power, every finisher is Under", count ~= nil and count > 0 and failed == "", failed)
				if unusableWithoutComboPoints then
					count, failed = Draw(0, false, true, function(color) return color == colors.unusable.color end)
					check(key .. ": with no combo points, every finisher is Unusable", count ~= nil and count > 0 and failed == "", failed)
					count, failed = Draw(2, false, true, function(color) return color == colors.under.color end)
					check(key .. ": with combo points again, every finisher is back to Under", count ~= nil and count > 0 and failed == "", failed)
				end
				-- Goremaw's Bite turns a usable finisher Over, and must leave one that is short on power alone.
				local goremawsBite = spells.goremawsBite ~= nil and cache.snapshotData.snapshots[spells.goremawsBite.id] or nil
				if goremawsBite ~= nil then
					goremawsBite.buff.isActive = true
					count, failed = Draw(3, false, true, function(color) return color == colors.under.color end)
					check(key .. ": with Goremaw's Bite up, a finisher short on power is still Under", count ~= nil and count > 0 and failed == "", failed)
					count, failed = Draw(3, true, false, function(color) return color == colors.over.color end)
					check(key .. ": with Goremaw's Bite up, a usable finisher is Over", count ~= nil and count > 0 and failed == "", failed)
					goremawsBite.buff.isActive = false
				end
			end
		end
	end
	Threshold.AdjustThresholdDisplay = adjust

	print(string.format("DRIVER finisher-lines: %d failures", errors))
	return errors
end

return hooks
