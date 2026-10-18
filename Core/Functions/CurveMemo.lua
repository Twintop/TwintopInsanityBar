local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.CurveMemo = {}

-- A curve evaluation costs ~7µs in game, about 30x a widget write. Inside the 20Hz tick, player and pet
-- results are reused until the event that changes the value; fill and bar text already follow the same events.

-- Stands in for a nil power type or curve as a table key.
local NIL = {}

-- results[unit][powerType][unmodified][curve], with a parallel `present` set: a secret result can't be compared to nil.
local powerResults = { player = {}, pet = {} }
local healthResults = { player = {}, pet = {} }
local active = false

-- Power event tokens by Enum.PowerType value, e.g. RunicPower -> "RUNIC_POWER". An unknown token drops the unit's power results.
local powerTypeByToken = {}
for key, value in pairs(Enum.PowerType) do
	local token = string.upper((string.gsub(key, "(%l)(%u)", "%1_%2")))
	powerTypeByToken[token] = value
end

---Returns the result slot for one argument set, creating it on first use.
---@param byUnit table
---@param typeKey any
---@param flagKey boolean
---@return table slot
local function GetSlot(byUnit, typeKey, flagKey)
	local byType = byUnit[typeKey]
	if byType == nil then
		byType = {}
		byUnit[typeKey] = byType
	end
	local slot = byType[flagKey]
	if slot == nil then
		slot = { results = {}, present = {} }
		byType[flagKey] = slot
	end
	return slot
end

---UnitPowerPercent, memoized for player and pet while the tick runs.
---@param unit string
---@param powerType integer?
---@param unmodified boolean?
---@param curve any
---@return any
function TRB.Functions.CurveMemo.UnitPowerPercent(unit, powerType, unmodified, curve)
	local byUnit = active and powerResults[unit] or nil
	if byUnit == nil then
		return UnitPowerPercent(unit, powerType, unmodified, curve)
	end
	local slot = GetSlot(byUnit, powerType == nil and NIL or powerType, unmodified == true)
	local curveKey = curve == nil and NIL or curve
	if slot.present[curveKey] then
		return slot.results[curveKey]
	end
	local result = UnitPowerPercent(unit, powerType, unmodified, curve)
	slot.results[curveKey] = result
	slot.present[curveKey] = true
	return result
end

---UnitHealthPercent, memoized for player and pet while the tick runs.
---@param unit string
---@param usePredicted boolean?
---@param curve any
---@return any
function TRB.Functions.CurveMemo.UnitHealthPercent(unit, usePredicted, curve)
	local byUnit = active and healthResults[unit] or nil
	if byUnit == nil then
		return UnitHealthPercent(unit, usePredicted, curve)
	end
	-- usePredicted defaults to true.
	local slot = GetSlot(byUnit, NIL, usePredicted ~= false)
	local curveKey = curve == nil and NIL or curve
	if slot.present[curveKey] then
		return slot.results[curveKey]
	end
	local result = UnitHealthPercent(unit, usePredicted, curve)
	slot.results[curveKey] = result
	slot.present[curveKey] = true
	return result
end

---Turns memoization on for the 20Hz tick and off after it, so event handlers always read live values.
---@param isActive boolean
function TRB.Functions.CurveMemo:SetActive(isActive)
	active = isActive
end

---Drops every stored result.
function TRB.Functions.CurveMemo:Clear()
	for _, byUnit in pairs(powerResults) do
		wipe(byUnit)
	end
	for _, byUnit in pairs(healthResults) do
		wipe(byUnit)
	end
end

local memoFrame = CreateFrame("Frame")
for _, event in ipairs({ "UNIT_POWER_FREQUENT", "UNIT_POWER_UPDATE", "UNIT_MAXPOWER", "UNIT_DISPLAYPOWER",
	"UNIT_HEALTH", "UNIT_MAXHEALTH", "UNIT_HEAL_PREDICTION", "UNIT_ABSORB_AMOUNT_CHANGED", "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" }) do
	memoFrame:RegisterUnitEvent(event, "player", "pet")
end
memoFrame:RegisterUnitEvent("UNIT_PET", "player")
memoFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
memoFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
memoFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
memoFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
memoFrame:SetScript("OnEvent", function(_, event, unit, token)
	-- A tick that errored before turning the memo off is caught here; turning it off early only costs evaluations.
	active = false
	if event == "UNIT_POWER_FREQUENT" or event == "UNIT_POWER_UPDATE" or event == "UNIT_MAXPOWER" then
		local byUnit = powerResults[unit]
		if byUnit ~= nil then
			local powerType = token ~= nil and powerTypeByToken[token] or nil
			if powerType ~= nil then
				byUnit[powerType] = nil
				-- A nil power type reads the unit's current power, which may be this one.
				byUnit[NIL] = nil
			else
				wipe(byUnit)
			end
		end
	elseif event == "UNIT_DISPLAYPOWER" then
		local byUnit = powerResults[unit]
		if byUnit ~= nil then
			wipe(byUnit)
		end
	elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_HEAL_PREDICTION"
		or event == "UNIT_ABSORB_AMOUNT_CHANGED" or event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
		local byUnit = healthResults[unit]
		if byUnit ~= nil then
			wipe(byUnit)
		end
	else
		TRB.Functions.CurveMemo:Clear()
	end
end)
