-- Checks color conversion, color curves, class colors, and VertexColor animations against the client's behavior (#874).
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx)
end

function hooks.afterEvents(ctx)
	local G = desktop
	local Color = ctx.TRB.Functions.Color
	local failures = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail) and (" (" .. detail .. ")") or ""))
		if not ok then
			failures = failures + 1
		end
	end
	local function rgba(color)
		return string.format("%.4f,%.4f,%.4f,%.4f", color:GetRGBA())
	end
	local function same(color, r, g, b, a)
		local cr, cg, cb, ca = color:GetRGBA()
		return math.abs(cr - r) < 1e-6 and math.abs(cg - g) < 1e-6 and math.abs(cb - b) < 1e-6 and math.abs(ca - a) < 1e-6
	end

	-- GetRGBAFromString reads AARRGGBB exactly as CreateColorFromHexString does, in either case.
	for _, hex in ipairs({ "FF00FF00", "80FF0000", "00000000", "FFFFFFFF", "CC80b980", "66333333", "ff7f3f1f" }) do
		local r, g, b, a = Color:GetRGBAFromString(hex, true)
		local expected = G.CreateColorFromHexString(hex)
		check("GetRGBAFromString matches CreateColorFromHexString for " .. hex, same(expected, r, g, b, a),
			string.format("%.4f,%.4f,%.4f,%.4f vs %s", r, g, b, a, rgba(expected)))
	end

	-- A picker write round-trips every byte value, alpha included.
	local roundTripFailures = 0
	for v = 0, 255 do
		local hex = string.format("%02x%02x%02x%02x", v, 255 - v, v, (v * 7) % 256)
		if Color:ConvertColorDecimalToHex(Color:GetRGBAFromString(hex, true)) ~= hex then
			roundTripFailures = roundTripFailures + 1
		end
	end
	check("ConvertColorDecimalToHex round-trips all 256 byte values", roundTripFailures == 0, roundTripFailures .. " differ")

	-- Malformed saved colors fall back instead of erroring; Blizzard's parser returns nil for them.
	local r, g, b, a = Color:GetRGBAFromString(nil, true)
	check("GetRGBAFromString(nil) falls back to near-transparent", r == 0 and g == 1 / 255 and b == 0 and a == 1 / 255)
	r, g, b, a = Color:GetRGBAFromString("FFF", true)
	check("GetRGBAFromString(\"FFF\") falls back to near-transparent", r == 0 and g == 1 / 255 and b == 0 and a == 1 / 255)
	check("CreateColorFromHexString rejects a wrong length", G.CreateColorFromHexString("FFF") == nil)

	-- Blizzard's hex writers force full alpha; markup wraps with |c...|r.
	local halfRed = G.CreateColor(1, 0, 0, 0.5)
	check("GenerateHexColor forces ff alpha", halfRed:GenerateHexColor() == "ffff0000", halfRed:GenerateHexColor())
	check("GenerateHexColorNoAlpha is uppercase RRGGBB", halfRed:GenerateHexColorNoAlpha() == "FF0000", halfRed:GenerateHexColorNoAlpha())
	check("WrapTextInColorCode wraps in the color's code", halfRed:WrapTextInColorCode("x") == "|cffff0000x|r", halfRed:WrapTextInColorCode("x"))
	check("IsEqualTo compares channels", halfRed:IsEqualTo(G.CreateColor(1, 0, 0, 0.5)) and not halfRed:IsEqualTo(G.CreateColor(1, 0, 0, 1)))

	-- A resource threshold step curve flips at the threshold, also through UnitPowerPercent.
	local stepCurve = Color:BuildResourceThresholdCurve(nil, "FF000000", "FFFFFFFF", { mode = "fixed", fixed = 50 }, 100)
	check("Threshold step curve is below color under the threshold", stepCurve ~= nil and same(stepCurve:Evaluate(0.49), 0, 0, 0, 1))
	check("Threshold step curve is above color at the threshold", stepCurve ~= nil and same(stepCurve:Evaluate(0.5), 1, 1, 1, 1))
	local unitPower, unitPowerMax = G.UnitPower, G.UnitPowerMax
	G.UnitPower, G.UnitPowerMax = function() return 60 end, function() return 100 end
	check("UnitPowerPercent evaluates the curve at the power fraction", same(G.UnitPowerPercent("player", 0, true, stepCurve), 1, 1, 1, 1))
	check("UnitPowerPercent with ScaleTo100 returns 0-100", math.abs(G.UnitPowerPercent("player", 0, false, G.CurveConstants.ScaleTo100) - 60) < 1e-6)
	G.UnitPower, G.UnitPowerMax = unitPower, unitPowerMax

	-- A threshold of 0 means the over color everywhere.
	local zeroCurve = Color:BuildThresholdValueCurve(0, 100, "FF000000", "FFFFFFFF")
	check("Zero-value threshold curve is the over color at 0", zeroCurve ~= nil and same(zeroCurve:Evaluate(0), 1, 1, 1, 1))

	-- Health curves: step snaps between thresholds, linear blends.
	local healthStep = Color:GetHealthColorCurve({ type = "step", low = { color = "FFFF0000", threshold = 0 },
		medium = { color = "FFFFFF00", threshold = 0.3 }, high = { color = "FF00FF00", threshold = 0.7 } })
	check("Step health curve is low below medium", same(healthStep:Evaluate(0.2), 1, 0, 0, 1), rgba(healthStep:Evaluate(0.2)))
	check("Step health curve is medium between medium and high", same(healthStep:Evaluate(0.5), 1, 1, 0, 1), rgba(healthStep:Evaluate(0.5)))
	check("Step health curve is high above high", same(healthStep:Evaluate(0.9), 0, 1, 0, 1), rgba(healthStep:Evaluate(0.9)))
	local healthLinear = Color:GetHealthColorCurve({ type = "linear", low = { color = "FFFF0000", threshold = 0 },
		medium = { color = "FFFFFF00", threshold = 0.3 }, high = { color = "FF00FF00", threshold = 0.7 } })
	check("Linear health curve blends medium to high", same(healthLinear:Evaluate(0.5), 0.5, 1, 0, 1), rgba(healthLinear:Evaluate(0.5)))

	-- Class colors carry colorStr, and an unknown token has no entry.
	local token = select(2, G.UnitClass("player"))
	check("RAID_CLASS_COLORS has the player's class with colorStr", G.RAID_CLASS_COLORS[token] ~= nil and #G.RAID_CLASS_COLORS[token].colorStr == 8)
	check("GetClassColor returns colorStr", select(4, G.GetClassColor(token)) == G.RAID_CLASS_COLORS[token].colorStr)
	check("C_ClassColor.GetClassColor is nil for an unknown class", G.C_ClassColor.GetClassColor("NOTACLASS") == nil)
	check("GetPlayerClassColor is an AARRGGBB string", type(Color:GetPlayerClassColor()) == "string" and #Color:GetPlayerClassColor() == 8)

	-- VertexColor animations keep their colors; groups know they're playing.
	local frame = G.CreateFrame("Frame")
	local group = frame:CreateAnimationGroup()
	local animation = group:CreateAnimation("VertexColor")
	local startColor, endColor = G.CreateColor(1, 0, 0), G.CreateColor(0, 0, 1)
	animation:SetStartColor(startColor)
	animation:SetEndColor(endColor)
	group:Play()
	check("VertexColor animation keeps its colors", animation:GetStartColor() == startColor and animation:GetEndColor() == endColor)
	check("Animation group reports playing until stopped", group:IsPlaying() and (function() group:Stop() return not group:IsPlaying() end)())

	return failures
end

return hooks
