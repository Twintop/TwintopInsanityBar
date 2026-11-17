-- Checks Timer Precision: decimals either side of the threshold, m:ss from a minute, and duration objects formatted
-- through the engine's rule formatter matching plain times.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx)
end

function hooks.afterEvents(ctx)
	local BarText = ctx.TRB.Functions.BarText
	local timers = ctx.TRB.Data.settings.core.timers
	local failures = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail) and (" (" .. detail .. ")") or ""))
		if not ok then
			failures = failures + 1
		end
	end
	local function Set(low, high, threshold, showMinutes)
		timers.precisionLow, timers.precisionHigh, timers.precisionThreshold, timers.showMinutes = low, high, threshold, showMinutes
	end
	local function Duration(remaining)
		return { FormatRemainingDuration = function(_, formatter) return formatter:FormatNumber(remaining) end }
	end
	local function Expect(label, value, expected)
		local text = BarText:TimerPrecision(value)
		check(label, text == expected, string.format("%s gave %s", tostring(value), tostring(text)))
	end

	check("m:ss starts off", timers.showMinutes == false)

	Set(1, 0, 5, false)
	Expect("a time below the threshold takes the low precision", 3.21, "3.2")
	Expect("a time above the threshold takes the high precision", 299.537, "300")

	Set(1, 0, 5, true)
	Expect("m:ss shows a time of a minute or more as minutes and seconds", 299.537, "4:59")
	Expect("m:ss starts at a minute", 60, "1:00")
	Expect("m:ss leaves a time under a minute in seconds", 59.4, "59")
	Expect("m:ss leaves the low precision below the threshold", 3.21, "3.2")
	Expect("m:ss doesn't cap the minutes", 3725.3, "62:05")

	Set(1, 3, 5, true)
	Expect("m:ss takes up to three decimal places", 65.4321, "1:05.432")
	Set(1, 1, 5, true)
	Expect("m:ss truncates rather than carrying 60 seconds", 119.99, "1:59.9")

	Set(1, 0, 120, true)
	Expect("m:ss below a threshold over a minute takes the low precision", 90.55, "1:30.5")
	Expect("m:ss above that threshold takes the high precision", 150.7, "2:30")

	Set(3, 3, 5, false)
	Expect("seconds take three decimal places", 12.3456, "12.346")

	-- The formatter is rebuilt as the settings change, and must render exactly what a plain time does.
	local combos = {
		{ 1, 0, 5, false }, { 1, 0, 5, true }, { 2, 1, 10, true }, { 0, 3, 30, true }, { 1, 0, 120, true },
		{ 3, 2, 60, true }, { 1, 0, 60, false },
	}
	-- Clear of every 0.001 step, where float noise in a truncation would differ between the two splits.
	local values = { 0, 0.4372, 3.2146, 4.9683, 9.5372, 30.2534, 59.4317, 60.3712, 65.4326, 90.5537, 119.9374, 150.7126,
		299.5371, 3725.3168 }
	local mismatches = {}
	for _, combo in ipairs(combos) do
		Set(combo[1], combo[2], combo[3], combo[4])
		for _, value in ipairs(values) do
			local plain, engine = BarText:TimerPrecision(value), BarText:DurationTimerPrecision(Duration(value))
			if plain ~= engine then
				table.insert(mismatches, string.format("%d/%d/%s/%s %s: %s vs %s", combo[1], combo[2], tostring(combo[3]),
					tostring(combo[4]), tostring(value), plain, engine))
			end
		end
	end
	check("a duration object's time matches a plain time under every setting", #mismatches == 0, table.concat(mismatches, "; "))

	Set(1, 0, 5, false)
	return failures
end

return hooks
