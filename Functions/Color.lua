local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Color = {}

-- Memoization cache for GetRGBAFromString in the common case (no color/alpha adjustment).
-- Keyed by hexString .. (normalize and "T" or "F"), storing {r, g, b, a}.
-- Never needs explicit invalidation — a given hex string always maps to the same RGBA.
-- Optionally cleared in ResetColorCaches() to bound memory.
local rgbaCache = {}

---Converts a hexdecimal AARRGGBB string to separate numerical RGBA values, either out of 0-255 or 0.0 - 1.0
---@param s string # Hexdecimal string
---@param normalize boolean? # Should this be normalized to 0.0 - 1.0?
---@param percentColorAdjust number? # How much we scale this color down
---@param percentAlphaAdjust number? # How much we scale the alpha down
---@return number, number, number, number
function TRB.Functions.Color:GetRGBAFromString(s, normalize, percentColorAdjust, percentAlphaAdjust)
	-- Fast path: when no color/alpha adjustment, use memoized result
	local canCache = (percentColorAdjust == nil or percentColorAdjust == 1) and (percentAlphaAdjust == nil or percentAlphaAdjust == 1)
	if canCache and s ~= nil and #s == 8 then
		local cacheKey = normalize and (s .. "T") or (s .. "F")
		local cached = rgbaCache[cacheKey]
		if cached then
			return cached[1], cached[2], cached[3], cached[4]
		end
		-- Compute and cache
		local _a = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 1, 2), 16)), 0, floor, true)
		local _r = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 3, 4), 16)), 0, floor, true)
		local _g = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 5, 6), 16)), 0, floor, true)
		local _b = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 7, 8), 16)), 0, floor, true)
		if normalize then
			_r, _g, _b, _a = _r/255, _g/255, _b/255, _a/255
		end
		rgbaCache[cacheKey] = { _r, _g, _b, _a }
		return _r, _g, _b, _a
	end

	-- Slow path: adjustment factors are non-default
	if percentColorAdjust == nil or percentColorAdjust > 1 then
		percentColorAdjust = 1
	elseif percentColorAdjust < 0 then
		percentColorAdjust = 0
	end

	if percentAlphaAdjust == nil or percentAlphaAdjust > 1 then
		percentAlphaAdjust = 1
	elseif percentAlphaAdjust < 0 then
		percentAlphaAdjust = 0
	end

	local _a = 1
	local _r = 0
	local _g = 1
	local _b = 0

	if not (s == nil) then
		if #s == 8 then
			_a = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 1, 2), 16)) * percentAlphaAdjust, 0, floor, true)
			_r = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 3, 4), 16)) * percentColorAdjust, 0, floor, true)
			_g = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 5, 6), 16)) * percentColorAdjust, 0, floor, true)
			_b = TRB.Functions.Number:RoundTo(min(255, tonumber(string.sub(s, 7, 8), 16)) * percentColorAdjust, 0, floor, true)
		end
	end

	if normalize then
		return _r/255, _g/255, _b/255, _a/255
	else
		return _r, _g, _b, _a
	end
end

---Clears the RGBA parse memoization cache. Call from ResetColorCaches() to bound memory.
function TRB.Functions.Color:ClearRGBACache()
	wipe(rgbaCache)
end

---Converts normalized decimal RGBA values (0.0-1.0) to an AARRGGBB hexadecimal string
---@param r number? # Red channel value (0.0-1.0), nil treated as 0
---@param g number? # Green channel value (0.0-1.0), nil treated as 0
---@param b number? # Blue channel value (0.0-1.0), nil treated as 0
---@param a number? # Alpha channel value (0.0-1.0), nil treated as 0
---@return string # AARRGGBB hexadecimal color string
function TRB.Functions.Color:ConvertColorDecimalToHex(r, g, b, a)
	local _r, _g, _b, _a

	if r == 0 or r == nil then
		_r = "00"
	else
		_r = string.format("%x", math.floor(r * 255 + 0.5)) -- round-to-nearest; ceil overshoots on color picker's HSV round-trip error
		if string.len(_r) == 1 then
			_r = "0" .. _r
		end
	end

	if g == 0 or g == nil then
		_g = "00"
	else
		_g = string.format("%x", math.floor(g * 255 + 0.5))
		if string.len(_g) == 1 then
			_g = "0" .. _g
		end
	end

	if b == 0 or b == nil then
		_b = "00"
	else
		_b = string.format("%x", math.floor(b * 255 + 0.5))
		if string.len(_b) == 1 then
			_b = "0" .. _b
		end
	end

	if a == 0 or a == nil then
		_a = "00"
	else
		_a = string.format("%x", math.floor(a * 255 + 0.5))
		if string.len(_a) == 1 then
			_a = "0" .. _a
		end
	end

	return _a .. _r .. _g .. _b
end

---Sets a frame's backdrop color, using a cache to skip redundant SetBackdropColor calls when the color hasn't changed
---@param frame table # The frame whose backdrop color to set
---@param key string? # Cache key for deduplication; if nil, always applies the color
---@param r number # Red channel value (0.0-1.0)
---@param g number # Green channel value (0.0-1.0)
---@param b number # Blue channel value (0.0-1.0)
---@param a number # Alpha channel value (0.0-1.0)
function TRB.Functions.Color:SetBackdropColor(frame, key, r, g, b, a)
	local changed = false
	
	if key == nil then
		changed = true
	else
		if TRB.Data.cache.colors.backdrop[key] == nil then
			TRB.Data.cache.colors.backdrop[key] = {
				r = r,
				g = g,
				b = b,
				a = a
			}
			changed = true
		elseif TRB.Data.cache.colors.backdrop[key].r ~= r or TRB.Data.cache.colors.backdrop[key].g ~= g or TRB.Data.cache.colors.backdrop[key].b ~= b or TRB.Data.cache.colors.backdrop[key].a ~= a then
			TRB.Data.cache.colors.backdrop[key].r = r
			TRB.Data.cache.colors.backdrop[key].g = g
			TRB.Data.cache.colors.backdrop[key].b = b
			TRB.Data.cache.colors.backdrop[key].a = a
			changed = true
		end
	end

	if changed then
		frame:SetBackdropColor(r, g, b, a)
	end
end

---Sets a frame's backdrop border color, using a cache to skip redundant SetBackdropBorderColor calls when the color hasn't changed
---@param frame table # The frame whose backdrop border color to set
---@param key string? # Cache key for deduplication; if nil, always applies the color
---@param r number # Red channel value (0.0-1.0)
---@param g number # Green channel value (0.0-1.0)
---@param b number # Blue channel value (0.0-1.0)
---@param a number # Alpha channel value (0.0-1.0)
function TRB.Functions.Color:SetBackdropBorderColor(frame, key, r, g, b, a)
	local changed = false
	
	if key == nil then
		changed = true
	else
		if TRB.Data.cache.colors.border[key] == nil then
			TRB.Data.cache.colors.border[key] = {
				r = r,
				g = g,
				b = b,
				a = a
			}
			changed = true
		elseif TRB.Data.cache.colors.border[key].r ~= r or TRB.Data.cache.colors.border[key].g ~= g or TRB.Data.cache.colors.border[key].b ~= b or TRB.Data.cache.colors.border[key].a ~= a then
			TRB.Data.cache.colors.border[key].r = r
			TRB.Data.cache.colors.border[key].g = g
			TRB.Data.cache.colors.border[key].b = b
			TRB.Data.cache.colors.border[key].a = a
			changed = true
		end
	end

	if changed then
		frame:SetBackdropBorderColor(r, g, b, a)
	end
end

---Sets a frame's backdrop border color from an AARRGGBB hex string, parsing and applying it through the cached color setter
---@param frame table # The frame whose backdrop border color to set
---@param key string? # Cache key for deduplication; if nil, always applies the color
---@param rgbaString string # AARRGGBB hexadecimal color string
---@param normalize boolean? # Whether to normalize values to 0.0-1.0 (defaults to true)
function TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, key, rgbaString, normalize)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize or true)
	TRB.Functions.Color:SetBackdropBorderColor(frame, key, r, g, b, a)
end

---Sets a status bar frame's color, using a cache to skip redundant SetStatusBarColor calls when the color hasn't changed
---@param frame table # The status bar frame whose color to set
---@param key string? # Cache key for deduplication; if nil, always applies the color
---@param r number # Red channel value (0.0-1.0)
---@param g number # Green channel value (0.0-1.0)
---@param b number # Blue channel value (0.0-1.0)
---@param a number # Alpha channel value (0.0-1.0)
function TRB.Functions.Color:SetStatusBarColor(frame, key, r, g, b, a)
	local changed = false

	if key == nil then
		changed = true
	elseif not issecretvalue(r) then
		if TRB.Data.cache.colors.bar[key] == nil then
			TRB.Data.cache.colors.bar[key] = {
				r = r,
				g = g,
				b = b,
				a = a
			}
			changed = true
		elseif TRB.Data.cache.colors.bar[key].r ~= r or TRB.Data.cache.colors.bar[key].g ~= g or TRB.Data.cache.colors.bar[key].b ~= b or TRB.Data.cache.colors.bar[key].a ~= a then
			TRB.Data.cache.colors.bar[key].r = r
			TRB.Data.cache.colors.bar[key].g = g
			TRB.Data.cache.colors.bar[key].b = b
			TRB.Data.cache.colors.bar[key].a = a
			changed = true
		end
	else
		changed = true
	end
	
	if changed then
		frame:SetStatusBarColor(r, g, b, a)
	end
end

---Sets a status bar's texture vertex color, using a cache to skip redundant calls when the color hasn't changed
---@param frame table # The status bar frame whose texture vertex color to set
---@param key string? # Cache key for deduplication; if nil, always applies the color
---@param r number # Red channel value (0.0-1.0)
---@param g number # Green channel value (0.0-1.0)
---@param b number # Blue channel value (0.0-1.0)
---@param a number # Alpha channel value (0.0-1.0)
function TRB.Functions.Color:SetStatusBarVertexColor(frame, key, r, g, b, a)
	local changed = false

	if key == nil then
		changed = true
	else
		if TRB.Data.cache.colors.bar[key] == nil then
			TRB.Data.cache.colors.bar[key] = {
				r = r,
				g = g,
				b = b,
				a = a
			}
			changed = true
		elseif TRB.Data.cache.colors.bar[key].r ~= r or TRB.Data.cache.colors.bar[key].g ~= g or TRB.Data.cache.colors.bar[key].b ~= b or TRB.Data.cache.colors.bar[key].a ~= a then
			TRB.Data.cache.colors.bar[key].r = r
			TRB.Data.cache.colors.bar[key].g = g
			TRB.Data.cache.colors.bar[key].b = b
			TRB.Data.cache.colors.bar[key].a = a
			changed = true
		end
	end
	
	if changed then
		frame:GetStatusBarTexture():SetVertexColor(r, g, b, a)
	end
end

---Sets a status bar frame's color from an AARRGGBB hex string, parsing and applying it through the cached color setter
---@param frame table # The status bar frame whose color to set
---@param key string? # Cache key for deduplication; if nil, always applies the color
---@param rgbaString string # AARRGGBB hexadecimal color string
---@param normalize boolean? # Whether to normalize values to 0.0-1.0 (defaults to true)
function TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, key, rgbaString, normalize)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize or true)
	TRB.Functions.Color:SetStatusBarColor(frame, key, r, g, b, a)
end

---Sets a threshold frame's texture and optional icon border color from an AARRGGBB hex string, filtered by class/spec
---@param frame table # The threshold frame containing a .texture and optional .icon
---@param rgbaString string # AARRGGBB hexadecimal color string
---@param normalize boolean? # Whether to normalize values to 0.0-1.0
---@param classId number? # Optional class ID filter; if both classId and specId are nil, always applies
---@param specId number? # Optional spec ID filter; must match current character's spec if provided
function TRB.Functions.Color:SetThresholdColor(frame, rgbaString, normalize, classId, specId)
	if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
		-- Create texture if it doesn't exist yet (can happen with dynamically created thresholds)
		if frame.texture == nil then
			frame.texture = frame:CreateTexture(nil, "OVERLAY")
			frame.texture:SetAllPoints(frame)
		end
		frame.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
		if frame.icon ~= nil and frame.hasIcon == true then
			local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize)
			frame.icon:SetBackdropBorderColor(r, g, b, a)
			-- Remember the applied border color so SetThresholdIcon can restore it after any
			-- SetBackdrop re-application (which resets the border) without needing to recompute it.
			-- Reuse the table to avoid per-tick GC churn on curve-colored thresholds.
			local bc = frame.icon.borderColorCache or {}
			bc[1], bc[2], bc[3], bc[4] = r, g, b, a
			frame.icon.borderColorCache = bc
		end
	end
end

-- Step ColorCurve cache (used for resource threshold color transitions)
TRB.Data.cache = TRB.Data.cache or {}
TRB.Data.cache.stepColorCurves = TRB.Data.cache.stepColorCurves or {}

---Creates and caches a Step ColorCurve that transitions from belowColor to aboveColor at the given threshold
---@param cacheKey string # Unique key for caching (e.g., specName + color combination)
---@param belowColor string # ARGB hex color string for below threshold
---@param aboveColor string # ARGB hex color string for at/above threshold
---@param thresholdPercent number # The percentage (0-1) at which the color should change to aboveColor
---@return any # The cached ColorCurve
function TRB.Functions.Color:GetStepColorCurve(cacheKey, belowColor, aboveColor, thresholdPercent)
	-- Handle edge case: if threshold is not a finite positive number, return nil to skip curve evaluation
	if thresholdPercent == nil or thresholdPercent ~= thresholdPercent or thresholdPercent == math.huge or thresholdPercent == -math.huge then
		return nil
	end

	local cache = TRB.Data.cache.stepColorCurves
	local fullKey = cacheKey .. "_" .. belowColor .. "_" .. aboveColor .. "_" .. tostring(thresholdPercent)
	
	if cache[fullKey] == nil then
		local curve = C_CurveUtil.CreateColorCurve()
		curve:SetType(Enum.LuaCurveType.Step)
		
		local belowR, belowG, belowB, belowA = TRB.Functions.Color:GetRGBAFromString(belowColor, true)
		local aboveR, aboveG, aboveB, aboveA = TRB.Functions.Color:GetRGBAFromString(aboveColor, true)
		
		local belowColorObj = CreateColor(belowR, belowG, belowB, belowA)
		local aboveColorObj = CreateColor(aboveR, aboveG, aboveB, aboveA)
		
		-- Step curve: color changes AT the threshold point
		-- Add point at 0 for below color, at threshold for above color
		-- Add point beyond 1.0 to handle values that exceed max resource
		curve:AddPoint(0, belowColorObj)
		curve:AddPoint(thresholdPercent, aboveColorObj)
		curve:AddPoint(2.0, aboveColorObj) -- Extend beyond 100% to handle overflow
		
		cache[fullKey] = curve
	end
	
	return cache[fullKey]
end

---Evaluates a Step ColorCurve and returns the appropriate color string
---@param spec table # The spec settings containing overcap configuration
---@param belowColor string # ARGB hex color string for below threshold
---@param aboveColor string # ARGB hex color string for at/above threshold  
---@param currentResourcePercent number # Current resource percentage (0-1)
---@param maxResource number # Maximum resource value
---@param cacheKey string # Unique key for caching
---@return string # The color string to use (either belowColor or aboveColor based on threshold)
function TRB.Functions.Color:EvaluateStepColor(spec, belowColor, aboveColor, currentResourcePercent, maxResource, cacheKey)
	if spec.overcap == nil then
		return belowColor
	end
	
	-- Calculate the overcap threshold
	local overcapThreshold
	if spec.overcap.mode == "relative" then
		overcapThreshold = maxResource + (spec.overcap.relative or 0)
	else
		overcapThreshold = spec.overcap.fixed or maxResource
	end
	
	-- Calculate the percentage where the threshold triggers
	local thresholdPercent = overcapThreshold / maxResource
	
	-- Get the cached curve
	local curve = TRB.Functions.Color:GetStepColorCurve(cacheKey, belowColor, aboveColor, thresholdPercent)
	
	if curve == nil then
		return belowColor
	end
	
	-- Evaluate the curve at current resource percentage
	local colorResult = curve:Evaluate(currentResourcePercent)
	
	-- Convert the color result back to a hex string
	if colorResult and type(colorResult.GetRGBA) == "function" then
		local r, g, b, a = colorResult:GetRGBA()
		local result = TRB.Functions.Color:ConvertColorDecimalToHex(r, g, b, a)
		return result
	end
	
	return belowColor
end

---Clears the Step ColorCurve cache (call when settings change)
function TRB.Functions.Color:ClearStepColorCurveCache()
	TRB.Data.cache.stepColorCurves = {}
end

---Builds a resource threshold ColorCurve for use with UnitPowerPercent (e.g., overcap border/text color)
---@param specSettings table The spec-specific settings table (e.g., specSettings.overcap)
---@param belowColor string The color hex string for below threshold (e.g., "FF00FF00")
---@param aboveColor string The color hex string for at/above threshold
---@return table? colorCurve A ColorCurve object ready for UnitPowerPercent
function TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, belowColor, aboveColor)
	if type(belowColor) == "table" then
		belowColor = belowColor.color
	end
	if type(aboveColor) == "table" then
		aboveColor = aboveColor.color
	end
	if type(belowColor) ~= "string" or type(aboveColor) ~= "string" then
		return nil
	end

	local maxResource = TRB.Data.character.maxResourceUnmodified or 100
	local thresholdValue = maxResource

	if specSettings and specSettings.overcap then
		if specSettings.overcap.mode == "relative" then
			thresholdValue = maxResource + (specSettings.overcap.relative or 0)
		else
			thresholdValue = specSettings.overcap.fixed or maxResource
		end
	end

	local thresholdPercent = thresholdValue / maxResource

	-- Handle edge case: if threshold is not a finite positive number, return nil to skip curve evaluation
	if thresholdPercent ~= thresholdPercent or thresholdPercent == math.huge or thresholdPercent == -math.huge or maxResource <= 0 then
		return nil
	end

	-- Check cache first
	local cache = TRB.Data.cache.stepColorCurves
	local cacheKey = belowColor .. "_" .. aboveColor .. "_" .. tostring(thresholdPercent)
	
	if cache[cacheKey] then
		return cache[cacheKey]
	end

	local belowR, belowG, belowB, belowA = TRB.Functions.Color:GetRGBAFromString(belowColor, true)
	local aboveR, aboveG, aboveB, aboveA = TRB.Functions.Color:GetRGBAFromString(aboveColor, true)

	local belowColorObj = CreateColor(belowR, belowG, belowB, belowA)
	local aboveColorObj = CreateColor(aboveR, aboveG, aboveB, aboveA)

	local colorCurve = C_CurveUtil.CreateColorCurve()
	colorCurve:SetType(Enum.LuaCurveType.Step)
	colorCurve:AddPoint(0, belowColorObj)
	colorCurve:AddPoint(thresholdPercent, aboveColorObj)

	cache[cacheKey] = colorCurve
	return colorCurve
end

-- Threshold ColorCurve cache
TRB.Data.cache.thresholdCurves = TRB.Data.cache.thresholdCurves or {}

---Builds a threshold ColorCurve that transitions from underColor to overColor
---at the specified cost percentage. Used for multicast (2x/3x) and split-cost (min/max) thresholds.
---@param costMultiplier number # The cost multiplier (e.g., 2 for 2x cost, or primaryResourceTypeMod)
---@param baseCost number # The base (1x) cost of the spell
---@param underColor string # ARGB hex color for when player cannot afford
---@param overColor string # ARGB hex color for when player can afford
---@return LuaColorCurveObject? colorCurve # A ColorCurve object ready for use with UnitPowerPercent
function TRB.Functions.Color:BuildThresholdCurve(costMultiplier, baseCost, underColor, overColor)
	local cache = TRB.Data.cache.thresholdCurves
	
	-- Use maxResourceUnmodified to match UnitPowerPercent's internal calculation
	local maxResource = TRB.Data.character.maxResourceUnmodified or 100
	
	-- Calculate the threshold percentage where the multicast becomes affordable
	local thresholdCost = baseCost * costMultiplier
	local thresholdPercent = thresholdCost / maxResource
	
	-- Handle edge case: if threshold is 0, negative, infinite, or NaN, or max is 0 or negative, return nil to skip curve evaluation
	if thresholdPercent <= 0 or maxResource <= 0 or thresholdPercent ~= thresholdPercent or thresholdPercent == math.huge then
		return nil
	end
	
	local cacheKey = tostring(costMultiplier) .. "_" .. tostring(baseCost) .. "_" .. tostring(maxResource) .. "_" .. underColor .. "_" .. overColor
	
	if cache[cacheKey] then
		return cache[cacheKey]
	end
	
	local underR, underG, underB, underA = TRB.Functions.Color:GetRGBAFromString(underColor, true)
	local overR, overG, overB, overA = TRB.Functions.Color:GetRGBAFromString(overColor, true)
	
	local underColorObj = CreateColor(underR, underG, underB, underA)
	local overColorObj = CreateColor(overR, overG, overB, overA)
	
	local colorCurve = C_CurveUtil.CreateColorCurve()
	colorCurve:SetType(Enum.LuaCurveType.Step)
	colorCurve:AddPoint(0, underColorObj)
	colorCurve:AddPoint(thresholdPercent, overColorObj)
	
	cache[cacheKey] = colorCurve
	return colorCurve
end

---Builds a threshold ColorCurve for an explicit value on a known max range.
---@param value number # The threshold value
---@param maxResource number # The maximum resource value represented by the bar
---@param underColor string # ARGB hex color below the threshold
---@param overColor string # ARGB hex color at or above the threshold
---@return LuaColorCurveObject? colorCurve # A ColorCurve object ready for UnitPowerPercent
function TRB.Functions.Color:BuildThresholdValueCurve(value, maxResource, underColor, overColor)
	TRB.Data.cache.customThresholdCurves = TRB.Data.cache.customThresholdCurves or {}
	local cache = TRB.Data.cache.customThresholdCurves

	value = tonumber(value) or 0
	maxResource = tonumber(maxResource) or 0
	if value < 0 or maxResource <= 0 then
		return nil
	end

	local thresholdPercent = value / maxResource
	if thresholdPercent < 0 then
		thresholdPercent = 0
	elseif thresholdPercent > 1 then
		thresholdPercent = 1
	end

	local cacheKey = tostring(value) .. "_" .. tostring(maxResource) .. "_" .. underColor .. "_" .. overColor
	if cache[cacheKey] then
		return cache[cacheKey]
	end

	local underR, underG, underB, underA = TRB.Functions.Color:GetRGBAFromString(underColor, true)
	local overR, overG, overB, overA = TRB.Functions.Color:GetRGBAFromString(overColor, true)

	local underColorObj = CreateColor(underR, underG, underB, underA)
	local overColorObj = CreateColor(overR, overG, overB, overA)

	local colorCurve = C_CurveUtil.CreateColorCurve()
	colorCurve:SetType(Enum.LuaCurveType.Step)
	if thresholdPercent <= 0 then
		-- A threshold of 0 means "any resource at or above 0 is over". Since the resource
		-- is always >= 0, the over color applies everywhere. Adding both points at the same
		-- position (0) produces a degenerate Step curve that resolves to "under", so add only
		-- the over point here.
		colorCurve:AddPoint(0, overColorObj)
	else
		colorCurve:AddPoint(0, underColorObj)
		colorCurve:AddPoint(thresholdPercent, overColorObj)
	end

	cache[cacheKey] = colorCurve
	return colorCurve
end

---Clears the threshold ColorCurve cache (call when settings change)
function TRB.Functions.Color:ClearThresholdCurveCache()
	TRB.Data.cache.thresholdCurves = {}
	TRB.Data.cache.customThresholdCurves = {}
end

---Evaluates a threshold curve using UnitPowerPercent and returns the color object
---Uses UnitPowerPercent to safely handle secret resource values in Midnight
---@param colorCurve table # The ColorCurve to evaluate
---@param resourceType number # The Enum.PowerType for the resource (e.g., Enum.PowerType.Insanity)
---@return table|nil # The color object result from UnitPowerPercent, or nil if evaluation fails
function TRB.Functions.Color:EvaluateThresholdCurve(colorCurve, resourceType)
	-- Use UnitPowerPercent with the curve to safely evaluate against secret resource values
	-- Returns a color object that can be passed directly to SetColorTexture/GetRGBA
	return UnitPowerPercent("player", resourceType, true, colorCurve)
end

---Sets threshold color from a curve-evaluated color object
---This handles secret values from Midnight's hidden resource system
---@param frame table # The threshold frame
---@param colorResult table # The color object from UnitPowerPercent curve evaluation
---@param classId number|nil # Optional class ID filter
---@param specId number|nil # Optional spec ID filter  
function TRB.Functions.Color:SetThresholdColorFromCurve(frame, colorResult, classId, specId)
	if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
		if colorResult == nil or type(colorResult.GetRGBA) ~= "function" then
			return
		end
		-- Create texture if it doesn't exist yet (can happen with dynamically created thresholds)
		if frame.texture == nil then
			frame.texture = frame:CreateTexture(nil, "OVERLAY")
			frame.texture:SetAllPoints(frame)
		end
		-- Pass the color directly to SetColorTexture via GetRGBA - WoW API handles secret values
		frame.texture:SetColorTexture(colorResult:GetRGBA())
		if frame.icon ~= nil and frame.hasIcon == true then
			local r, g, b, a = colorResult:GetRGBA()
			frame.icon:SetBackdropBorderColor(r, g, b, a)
			-- Remember the applied border color so SetThresholdIcon can restore it after any
			-- SetBackdrop re-application (which resets the border) without needing to recompute it.
			-- Reuse the table to avoid per-tick GC churn on curve-colored thresholds.
			local bc = frame.icon.borderColorCache or {}
			bc[1], bc[2], bc[3], bc[4] = r, g, b, a
			frame.icon.borderColorCache = bc
			-- When the curve resolves to transparent (hidden mode), also hide the icon;
			-- when visible, ensure the icon alpha is restored.
			if a ~= nil then
				frame.icon:SetAlpha(a)
			end
		end
	end
end

---Builds a ColorCurve for icon vertex colors to mimic desaturation behavior
---Below threshold: gray (desaturated look), at/above threshold: white (full color)
---@param costMultiplier number # The multiplier for the spell cost (2 for 2x, 3 for 3x)
---@param baseCost number # The base cost of the spell (1x cost)
---@return LuaColorCurveObject? colorCurve # A ColorCurve for vertex colors
function TRB.Functions.Color:BuildIconVertexColorCurve(costMultiplier, baseCost)
	local cache = TRB.Data.cache.iconVertexColorCurves
	if cache == nil then
		TRB.Data.cache.iconVertexColorCurves = {}
		cache = TRB.Data.cache.iconVertexColorCurves
	end
	
	local maxResource = TRB.Data.character.maxResourceUnmodified or 100
	local thresholdCost = baseCost * costMultiplier
	local thresholdPercent = thresholdCost / maxResource
	
	-- Handle edge case: if threshold is 0, negative, infinite, or NaN, or max is 0 or negative, return nil to skip curve evaluation
	if thresholdPercent <= 0 or maxResource <= 0 or thresholdPercent ~= thresholdPercent or thresholdPercent == math.huge then
		return nil
	end
	
	local cacheKey = tostring(costMultiplier) .. "_" .. tostring(baseCost) .. "_" .. tostring(maxResource) .. "_vertex"
	
	if cache[cacheKey] then
		return cache[cacheKey]
	end
	
	-- Gray color for "desaturated" look (below threshold)
	local grayColor = CreateColor(0.5, 0.5, 0.5, 1)
	-- White color for full saturation (at/above threshold)
	local whiteColor = CreateColor(1, 1, 1, 1)
	
	local colorCurve = C_CurveUtil.CreateColorCurve()
	colorCurve:SetType(Enum.LuaCurveType.Step)
	colorCurve:AddPoint(0, grayColor)
	colorCurve:AddPoint(thresholdPercent, whiteColor)
	
	cache[cacheKey] = colorCurve
	return colorCurve
end

---Sets icon vertex color from a curve-evaluated color object
---Used to mimic desaturation when threshold icons can't use SetDesaturated with secret values
---@param frame table # The threshold frame with an icon
---@param colorResult table # The color object from UnitPowerPercent curve evaluation
function TRB.Functions.Color:SetIconVertexColorFromCurve(frame, colorResult)
	if frame == nil or frame.icon == nil or frame.icon.texture == nil then
		return
	end
	if colorResult == nil or type(colorResult.GetRGBA) ~= "function" then
		return
	end
	local r, g, b, a = colorResult:GetRGBA()
	frame.icon.texture:SetVertexColor(r, g, b, a)
end

---Applies a fill color to a BarNode, handling gradient entries automatically.
---If colorEntry is a string, applies as a flat color (backwards compat).
---If colorEntry is a table with gradientDirection ~= "disabled" and color2, applies as gradient.
---Otherwise applies colorEntry.color as a flat color.
---@param node TRB.Classes.BarNode # The BarNode to color
---@param colorEntry string|TRB.Classes.Settings.ColorGradientEntry # Color string or gradient entry table
function TRB.Functions.Color:ApplyFillColor(node, colorEntry)
	if type(colorEntry) == "string" then
		node:SetColor(colorEntry)
	elseif type(colorEntry) == "table" then
		if colorEntry.gradientDirection and colorEntry.gradientDirection ~= "disabled" and colorEntry.color2 then
			node:SetColorGradient(colorEntry.color, colorEntry.color2, colorEntry.gradientDirection)
		else
			node:SetColor(colorEntry.color)
		end
	end
end

---Applies a fill color to an OverlaySlot's main overlay, handling gradient entries.
---@param slot TRB.Classes.OverlaySlot # The OverlaySlot to color
---@param colorEntry string|TRB.Classes.Settings.ColorGradientEntry # Color string or gradient entry table
---@param overlayType string? # "appended", "inset", or nil for main overlay
function TRB.Functions.Color:ApplyOverlayFillColor(slot, colorEntry, overlayType)
	local colorString, color2String, direction
	if type(colorEntry) == "string" then
		colorString = colorEntry
	elseif type(colorEntry) == "table" then
		colorString = colorEntry.color
		if colorEntry.gradientDirection and colorEntry.gradientDirection ~= "disabled" and colorEntry.color2 then
			color2String = colorEntry.color2
			direction = colorEntry.gradientDirection
		end
	end

	if overlayType == "appended" then
		if color2String then
			slot:SetAppendedOverlayColorGradient(colorString, color2String, direction)
		else
			slot:SetAppendedOverlayColor(colorString)
		end
	elseif overlayType == "inset" then
		if color2String then
			slot:SetInsetOverlayColorGradient(colorString, color2String, direction)
		else
			slot:SetInsetOverlayColor(colorString)
		end
	else
		if color2String then
			slot:SetOverlayColorGradient(colorString, color2String, direction)
		else
			slot:SetOverlayColor(colorString)
		end
	end
end