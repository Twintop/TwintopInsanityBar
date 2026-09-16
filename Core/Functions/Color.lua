local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Color = {}

-- Memoization cache for GetRGBAFromString in the common case (no color/alpha adjustment).
-- Keyed by hexString .. (normalize and "T" or "F"), storing {r, g, b, a}.
-- Never needs explicit invalidation — a given hex string always maps to the same RGBA.
-- Optionally cleared in ResetColorCaches() to bound memory.
local rgbaCache = {}

-- The player's class never changes, so its color is resolved once and reused.
local playerClassColorHex = nil

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

---Returns the player's class color as an AARRGGBB hexadecimal string, or nil when the class token is unavailable.
---@return string? # AARRGGBB hexadecimal color string, or nil if the class color can't be resolved
function TRB.Functions.Color:GetPlayerClassColor()
	if playerClassColorHex ~= nil then
		return playerClassColorHex
	end

	local _, classFilename = UnitClass("player")
	if classFilename == nil then
		return nil
	end

	local color = C_ClassColor.GetClassColor(classFilename)
	if color == nil then
		return nil
	end

	playerClassColorHex = self:ConvertColorDecimalToHex(color.r, color.g, color.b, 1)
	return playerClassColorHex
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

-- Shield color sources -> the castbar colors-table key they pull from. Only the uninterruptible colors are
-- offered, since the shield only shows on uninterruptible casts and should read as part of that state.
local shieldColorSourceKeys = {
	uninterruptibleBar = "uninterruptible",
	uninterruptibleBorder = "uninterruptibleBorder",
}

---Resolves the uninterruptible shield's tint to an ARGB hex string from its color source, or nil when the
---source is "default" (leave the atlas untinted/gray). Every source is a plain hex string in the castbar
---colors table (or the shield's own customColor), so this is secret-safe on the target/focus bars too. The
---custom source keeps its own alpha; the uninterruptible-color sources return RGB only (their alpha is
---meaningless to the shield -- the opacity slider is the alpha). Shared by the player and target/focus paths.
---@param shield table # The uninterruptibleShield settings block
---@param colors table? # The castbar colors table (uninterruptible / uninterruptibleBorder)
---@return string? # ARGB hex tint, or nil for the untinted default
function TRB.Functions.Color:ResolveShieldColor(shield, colors)
	local source = shield and shield.colorSource or "default"
	if source == "custom" then
		return shield.customColor or "FFFFFFFF"
	end
	if source == "default" or colors == nil then
		return nil
	end
	local key = shieldColorSourceKeys[source]
	local entry = key and colors[key]
	return entry and entry.color or nil
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

-- Threshold metadata for built ColorCurves, keyed weakly by the curve object. Lets an end cap
-- following "only non-default border colors" rebuild the same step curve based at its own color
-- (the curve's base IS the default border color, and evaluated results are secret).
local curveThresholdMeta = setmetatable({}, { __mode = "k" })

---Records the base color and above-zero step points of a built ColorCurve so a companion curve can be derived.
---@param curve any # The ColorCurve object
---@param baseColor string # The color the curve uses at/below 0 (the live border color it was built from)
---@param points { x: number, color: string }[] # Step points above 0, in ascending x order
function TRB.Functions.Color:SetCurveThresholdMeta(curve, baseColor, points)
	if curve == nil or points == nil then
		return
	end
	local key = ""
	for _, point in ipairs(points) do
		key = key .. "_" .. tostring(point.x) .. ":" .. tostring(point.color)
	end
	curveThresholdMeta[curve] = { baseColor = baseColor, key = key, points = points }
end

---Evaluates the end cap companion for a curve-driven border, preserving the pre-Midnight
---"only non-default border colors" semantics against a secret resource: below the threshold the
---border shows the curve's base color, so the cap shows its own color when that base IS the bar's
---configured (default) border color, and follows the base when an indicator overrode it; at/above
---the threshold the cap follows the indicator color. Returns nil when the node's cap doesn't follow
---non-default border colors, or the border curve carries no threshold metadata.
---@param node TRB.Classes.BarNode?
---@param borderCurve any # The ColorCurve the border result was evaluated from
---@param powerType Enum.PowerType? # Power type to evaluate against (default: TRB.Data.resource)
---@return any? # Evaluated secret color result for the end cap, or nil
function TRB.Functions.Color:EvaluateEndCapCurve(node, borderCurve, powerType)
	local config = node ~= nil and node.endCapConfig or nil
	if config == nil or config.useBorderColor ~= true or config.useBorderColorExceptDefault ~= true then
		return nil
	end
	local meta = borderCurve ~= nil and curveThresholdMeta[borderCurve] or nil
	if meta == nil then
		return nil
	end
	local resource = powerType or TRB.Data.resource
	if resource == nil then
		return nil
	end

	-- The curve base only counts as "default" when it matches the bar's configured border color;
	-- anything else is an indicator override the cap must follow (same comparison the static
	-- SetBorderColor path makes).
	local capBaseColor = config.color
	if meta.baseColor ~= nil and meta.baseColor ~= config.defaultBorderColor then
		capBaseColor = meta.baseColor
	end

	local cache = TRB.Data.cache.stepColorCurves
	local fullKey = "endCap_" .. tostring(capBaseColor) .. meta.key
	local curve = cache[fullKey]
	if curve == nil then
		curve = C_CurveUtil.CreateColorCurve()
		curve:SetType(Enum.LuaCurveType.Step)
		local baseR, baseG, baseB, baseA = self:GetRGBAFromString(capBaseColor, true)
		curve:AddPoint(0, CreateColor(baseR, baseG, baseB, baseA))
		for _, point in ipairs(meta.points) do
			local r, g, b, a = self:GetRGBAFromString(point.color, true)
			curve:AddPoint(point.x, CreateColor(r, g, b, a))
		end
		cache[fullKey] = curve
	end

	return UnitPowerPercent("player", resource, true, curve)
end

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

		self:SetCurveThresholdMeta(curve, belowColor, { { x = thresholdPercent, color = aboveColor }, { x = 2.0, color = aboveColor } })
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

	self:SetCurveThresholdMeta(colorCurve, belowColor, { { x = thresholdPercent, color = aboveColor } })
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

---Applies a fill color to a bare StatusBar, handling gradient entries the same way
---`ApplyFillColor` does for a BarNode. For fills that are not owned by a node.
---@param frame StatusBar # The StatusBar to color
---@param key string # Cache key, unique to this frame
---@param colorEntry string|TRB.Classes.Settings.ColorGradientEntry # Color string or gradient entry table
function TRB.Functions.Color:ApplyFillColorToStatusBar(frame, key, colorEntry)
	if frame == nil or colorEntry == nil then
		return
	end

	local colorString = colorEntry
	local color2String, direction
	if type(colorEntry) == "table" then
		colorString = colorEntry.color
		if colorEntry.gradientDirection and colorEntry.gradientDirection ~= "disabled" and colorEntry.color2 then
			color2String = colorEntry.color2
			direction = colorEntry.gradientDirection
		end
	end

	local texture = frame:GetStatusBarTexture()
	if color2String == nil then
		-- Neutralize any gradient left from a previous entry before the flat color goes on.
		if texture ~= nil and TRB.Data.cache.colors.gradient[key] ~= nil then
			local white = CreateColor(1, 1, 1, 1)
			texture:SetGradient("HORIZONTAL", white, white)
			TRB.Data.cache.colors.gradient[key] = nil
		end
		self:SetStatusBarColorFromRGBAString(frame, key, colorString)
		return
	end

	local cached = TRB.Data.cache.colors.gradient[key]
	if cached and cached.color1 == colorString and cached.color2 == color2String and cached.direction == direction then
		return
	end

	local r1, g1, b1, a1 = self:GetRGBAFromString(colorString, true)
	local r2, g2, b2, a2 = self:GetRGBAFromString(color2String, true)
	TRB.Data.cache.colors.bar[key] = nil
	frame:SetStatusBarColor(1, 1, 1, 1)

	if texture then
		local apiDirection = direction == "vertical" and "VERTICAL" or "HORIZONTAL"
		local minColor = CreateColor(r1, g1, b1, a1)
		local maxColor = CreateColor(r2, g2, b2, a2)
		-- VERTICAL: min=bottom, max=top. Swap so color1 lands at the top.
		if apiDirection == "VERTICAL" then
			minColor, maxColor = maxColor, minColor
		end
		texture:SetGradient(apiDirection, minColor, maxColor)
	end

	TRB.Data.cache.colors.gradient[key] = { color1 = colorString, color2 = color2String, direction = direction }
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

---Applies a color entry to one range gate, storing it so RefreshAppearance can repaint on its own.
---@param slot TRB.Classes.OverlaySlot
---@param index integer # The range gate's index on the slot
---@param colorEntry string|TRB.Classes.Settings.ColorGradientEntry
function TRB.Functions.Color:ApplyRangeOverlayFillColor(slot, index, colorEntry)
	slot.rangeColors[index] = colorEntry

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

	if color2String then
		slot:SetRangeOverlayColorGradient(index, colorString, color2String, direction)
	else
		slot:SetRangeOverlayColor(index, colorString)
	end
end

-- ============================================================================
-- Indicator color resolution
-- ============================================================================

--[[
	Indicators recolor bar elements while a condition holds (a buff is up, a proc is available, ...).
	Each spec evaluates its own conditions and owns its own bars, but the health bar and cast bar are
	shared by every spec and are rendered outside the spec update -- the cast bar runs its own OnUpdate
	loop and never sees the spec's conditionMap at all. So this resolves the shared bars alongside the
	spec's and parks the result in TRB.Data.resolvedIndicators for those render paths to read.
]]

-- Resolved colors for the two shared bars. Stamped with the composite key so a spec that never resolves
-- (Mage has no indicators; Warrior only gradient ones) can't read a previous spec's colors, and versioned
-- so the cast bar can tell when an indicator flipped mid-cast and its once-per-cast color/overlay setup
-- needs re-running.
TRB.Data.resolvedIndicators = {
	---@type string?
	compositeKey = nil,
	version = 0,
	---@type table<string, string>
	healthBar = {},
	---@type table<string, string|table>
	castbar = {},
	-- Target/Focus cast bars: shared bars like the player castbar, resolved the same way. Only border,
	-- background, and endCap are targetable (the fill is secret-driven per cast state), so no fill entries.
	---@type table<string, string>
	targetCastbar = {},
	---@type table<string, string>
	focusCastbar = {},
	-- The active gradient (secret-value) indicator, or nil. Its color isn't resolved here like the flat ones:
	-- a gradient is a curve from whatever color the element would otherwise use up to the indicator's color,
	-- and only the render path knows that base color. So the indicator itself is parked and the consumer
	-- builds the curve. See ApplyResolvedBorderOrBackground.
	---@type table?
	gradient = nil,
	-- The active spec's RAW settings. A gradient curve steps at the resource's overcap threshold, which lives
	-- on the settings root -- and the composed spec-cache settings the render paths carry don't include it.
	-- Parking it here is what lets the shared bars step at the same threshold the spec's own bars do.
	---@type table?
	specSettings = nil,
	-- barKey -> { glows, color }, resolved for every bar at once: glows land on nodes, not on a color map.
	---@type table<string, table>
	barGlows = {}
}

-- Fill elements take the whole indicator entry (so ApplyFillColor can honor color2/gradientDirection);
-- every other element only needs the flat color string.
local fillElements = {
	bar = true,
	channel = true
}

-- Target keys that aren't a colorable element: the Border Glow selection, and the pre-multiselect single
-- glow id an early build wrote. Both are truthy, so the color pass has to skip them by name.
local nonColorElements = {
	glow = true,
	glows = true
}

-- Cast bar elements, in a fixed order so the change check below can compare without allocating.
local castbarElements = { "bar", "channel", "border", "background", "tick", "endCap" }
local previousCastbar = {}

---Resolves the indicator colors for a spec's own bars plus the shared health bar and cast bar. Walks
---nodeOrder back to front so earlier (higher-priority) entries overwrite later ones. The spec's bars are
---written back into barColorMap in place; the shared bars are parked in TRB.Data.resolvedIndicators.
---Pass a nil barColorMap when the spec colors its own bars itself and only needs the shared ones.
---
---The shared bars are recomputed from scratch on every call, so a spec that calls this more than once in a
---frame (Death Knight and Elemental Shaman do, once per bar they own) MUST pass an equivalent conditionMap
---each time -- the last call decides what the health bar and cast bar see. Deriving conditionMap from live
---state, as every spec does, satisfies that on its own.
---@param sharedColors table? # spec.colors.shared -- indicatorColors + nodeOrder
---@param conditionMap table<string, boolean> # Indicator key -> whether its condition is met right now
---@param barColorMap table<string, table>? # barKey -> { bar =, border =, background = }, seeded with the spec's unindicated colors
---@param overrides table<string, table<string, boolean>>? # Optional: for each barKey the caller seeds here, records which elements an indicator claimed (specs that render an element differently once an indicator owns it)
function TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap, overrides)
	local resolved = TRB.Data.resolvedIndicators
	local healthBar = resolved.healthBar
	local castbar = resolved.castbar
	local targetCastbar = resolved.targetCastbar
	local focusCastbar = resolved.focusCastbar
	wipe(healthBar)
	wipe(castbar)
	wipe(targetCastbar)
	wipe(focusCastbar)

	local character = TRB.Data.character
	resolved.compositeKey = character.compositeKey
	local classSettings = TRB.Data.settings[character.className]
	resolved.specSettings = classSettings and classSettings[character.specName] or nil

	local indicatorColors = sharedColors and sharedColors.indicatorColors
	local nodeOrder = sharedColors and sharedColors.nodeOrder
	local gradientOrder = sharedColors and sharedColors.gradientOrder

	-- Same selection every spec makes for its own bars (walk back, first match wins), so the shared bars can
	-- never end up showing a different gradient indicator than the resource bar beside them.
	resolved.gradient = nil
	if indicatorColors and gradientOrder then
		for i = #gradientOrder, 1, -1 do
			local key = gradientOrder[i]
			local indicator = indicatorColors[key]
			if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient then
				resolved.gradient = indicator
				break
			end
		end
	end

	local barGlows = resolved.barGlows
	wipe(barGlows)

	if indicatorColors and nodeOrder then
		for i = #nodeOrder, 1, -1 do
			local key = nodeOrder[i]
			local indicator = indicatorColors[key]
			if indicator and indicator.enabled and conditionMap[key] and indicator.targets then
				for barKey, elements in pairs(indicator.targets) do
					-- Glows resolve for every bar, not just the ones in this caller's color map: the nodes
					-- they land on are found from the bar's own render path, well after this runs.
					if elements.glows ~= nil and next(elements.glows) ~= nil then
						local glowEntry = barGlows[barKey]
						if glowEntry == nil then
							glowEntry = {}
							barGlows[barKey] = glowEntry
						end
						glowEntry.glows = elements.glows
						glowEntry.color = indicator.color
					end

					local targetColors
					if barKey == "healthBar" then
						targetColors = healthBar
					elseif barKey == "castbar" then
						targetColors = castbar
					elseif barKey == "targetCastbar" then
						targetColors = targetCastbar
					elseif barKey == "focusCastbar" then
						targetColors = focusCastbar
					else
						targetColors = barColorMap and barColorMap[barKey]
					end
					if targetColors then
						local targetFlags = overrides and overrides[barKey]
						for elemKey, isTargeted in pairs(elements) do
							if isTargeted and not nonColorElements[elemKey] then
								targetColors[elemKey] = fillElements[elemKey] and indicator or indicator.color
								if targetFlags then
									targetFlags[elemKey] = true
								end
							end
						end
					end
				end
			end
		end
	end

	-- Stash each spec bar's resolved flat end cap color globally, keyed by barKey, so a node can resolve
	-- its own end cap indicator from (node, barKey) alone without the spec threading its color map through.
	-- Only the active spec's bars are keyed here, and its barKeys are unique, so there's no cross-spec
	-- collision. Set per key each call (nil when no flat indicator targets the cap) so stale colors clear.
	if barColorMap ~= nil then
		local barEndCaps = resolved.barEndCaps
		if barEndCaps == nil then
			barEndCaps = {}
			resolved.barEndCaps = barEndCaps
		end
		for barKey, colors in pairs(barColorMap) do
			barEndCaps[barKey] = colors.endCap
		end
	end

	-- The version only moves when the cast bar's resolved colors actually change. Comparing by identity is
	-- enough: a flat element resolves to a color string, a fill element to the indicator's own settings
	-- table, and both are stable while the same indicator stays active.
	local changed = false
	for i = 1, #castbarElements do
		local elemKey = castbarElements[i]
		if previousCastbar[elemKey] ~= castbar[elemKey] then
			previousCastbar[elemKey] = castbar[elemKey]
			changed = true
		end
	end
	if changed then
		resolved.version = resolved.version + 1
	end
end

---Returns the resolved indicator colors for a shared bar ("healthBar" or "castbar"), or nil when the
---active spec hasn't resolved any (it has no indicators, or hasn't run its update yet this spec).
---@param barKey string
---@return table<string, string|table>?
function TRB.Functions.Color:GetResolvedIndicators(barKey)
	local resolved = TRB.Data.resolvedIndicators
	if resolved.compositeKey ~= TRB.Data.character.compositeKey then
		return nil
	end
	return resolved[barKey]
end

---The Border Glows a Color Indicator claims on a bar right now, as { glows, color }, or nil when none does.
---@param barKey string
---@return table?
function TRB.Functions.Color:GetResolvedGlow(barKey)
	local resolved = TRB.Data.resolvedIndicators
	if resolved.compositeKey ~= TRB.Data.character.compositeKey then
		return nil
	end
	return resolved.barGlows[barKey]
end

---Version stamp of the resolved cast bar colors; changes only when those colors do. The cast bar's render
---path applies its fill and overlays once per cast, and re-applies when this moves.
---@return integer
function TRB.Functions.Color:GetResolvedIndicatorVersion()
	return TRB.Data.resolvedIndicators.version
end

---The active gradient (secret-value) indicator for the current spec, or nil when none is met.
---@return table?
function TRB.Functions.Color:GetResolvedGradient()
	local resolved = TRB.Data.resolvedIndicators
	if resolved.compositeKey ~= TRB.Data.character.compositeKey then
		return nil
	end
	return resolved.gradient
end

---Applies a shared bar's border or background color, letting the active gradient indicator take it over.
---A gradient can't be resolved to a color up front the way a flat indicator can: it is a step curve from the
---color the element would otherwise use up to the indicator's color at the resource's overcap threshold,
---evaluated against a secret resource value. So the base color is settled first (configured color, possibly
---overridden by a flat indicator) and the curve is built from it here -- the same thing every spec already
---does for its own bars.
---Falls back to the flat base color whenever no gradient targets this element, or the curve can't be built.
---@param node TRB.Classes.BarNode
---@param barKey string # "healthBar" or "castbar"
---@param element string # "border" or "background"
---@param baseColor string? # The color the element uses absent any gradient
function TRB.Functions.Color:ApplyResolvedBorderOrBackground(node, barKey, element, baseColor)
	local curve
	local gradient = self:GetResolvedGradient()
	if gradient ~= nil and baseColor ~= nil and TRB.Data.resource ~= nil then
		local targets = gradient.targets and gradient.targets[barKey]
		if targets and targets[element] then
			-- The raw spec settings, not the composed ones the caller carries: only they hold the overcap threshold.
			curve = self:BuildResourceThresholdCurve(TRB.Data.resolvedIndicators.specSettings, baseColor, gradient.color)
		end
	end

	if curve ~= nil then
		local colorResult = UnitPowerPercent("player", TRB.Data.resource, true, curve)
		if element == "border" then
			node:SetBorderColorCurve(colorResult, self:EvaluateEndCapCurve(node, curve))
		else
			node:SetBackgroundColorCurve(colorResult)
		end
	elseif baseColor ~= nil then
		if element == "border" then
			node:SetBorderColor(baseColor)
		else
			node:SetBackgroundColorFromString(baseColor)
		end
	end
end

---Applies a shared bar's end cap indicator color (flat or gradient), taking priority over the cap's
---useBorderColor follow. Mirrors ApplyResolvedBorderOrBackground: a flat indicator resolves to a color
---string up front (in resolvedIndicators[barKey].endCap), while a gradient builds a step curve from the
---cap's own color up to the indicator color here. Reverts to the cap's own color when nothing targets it.
---@param node TRB.Classes.BarNode
---@param barKey string # "healthBar" or "castbar"
function TRB.Functions.Color:ApplyResolvedEndCap(node, barKey)
	local config = node ~= nil and node.endCapConfig or nil
	if config == nil then
		return
	end

	local gradient = self:GetResolvedGradient()
	if gradient ~= nil and TRB.Data.resource ~= nil then
		local targets = gradient.targets and gradient.targets[barKey]
		if targets and targets.endCap then
			local curve = self:BuildResourceThresholdCurve(TRB.Data.resolvedIndicators.specSettings, config.color, gradient.color)
			if curve ~= nil then
				node:ApplyEndCapIndicator(nil, UnitPowerPercent("player", TRB.Data.resource, true, curve))
				return
			end
		end
	end

	local indicators = self:GetResolvedIndicators(barKey)
	node:ApplyEndCapIndicator(indicators and indicators.endCap or nil, nil)
end