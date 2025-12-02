local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Color = {}

---Converts a hexdecimal AARRGGBB string to separate numerical RGBA values, either out of 0-255 or 0.0 - 1.0
---@param s string # Hexdecimal string
---@param normalize boolean? # Should this be normalized to 0.0 - 1.0?
---@param percentColorAdjust number? # How much we scale this color down
---@param percentAlphaAdjust number? # How much we scale the alpha down
---@return number, number, number, number
function TRB.Functions.Color:GetRGBAFromString(s, normalize, percentColorAdjust, percentAlphaAdjust)
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

function TRB.Functions.Color:ConvertColorDecimalToHex(r, g, b, a)
	local _r, _g, _b, _a

	if r == 0 or r == nil then
		_r = "00"
	else
		_r = string.format("%x", math.ceil(r * 255))
		if string.len(_r) == 1 then
			_r = "0" .. _r
		end
	end

	if g == 0 or g == nil then
		_g = "00"
	else
		_g = string.format("%x", math.ceil(g * 255))
		if string.len(_g) == 1 then
			_g = "0" .. _g
		end
	end

	if b == 0 or b == nil then
		_b = "00"
	else
		_b = string.format("%x", math.ceil(b * 255))
		if string.len(_b) == 1 then
			_b = "0" .. _b
		end
	end

	if a == 0 or a == nil then
		_a = "00"
	else
		_a = string.format("%x", math.ceil(a * 255))
		if string.len(_a) == 1 then
			_a = "0" .. _a
		end
	end

	return _a .. _r .. _g .. _b
end

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

function TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, key, rgbaString, normalize)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize or true)
	TRB.Functions.Color:SetBackdropBorderColor(frame, key, r, g, b, a)
end

function TRB.Functions.Color:SetStatusBarColor(frame, key, r, g, b, a)
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
		frame:SetStatusBarColor(r, g, b, a)
	end
end

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

function TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, key, rgbaString, normalize)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize or true)
	TRB.Functions.Color:SetStatusBarColor(frame, key, r, g, b, a)
end

function TRB.Functions.Color:SetThresholdColor(frame, rgbaString, normalize, classId, specId)
	if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
		frame.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
		if frame.icon ~= nil and frame.hasIcon == true then
			frame.icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
		end
	end
end