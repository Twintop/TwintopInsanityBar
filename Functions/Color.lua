local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Color = {}


function TRB.Functions.Color:GetRGBAFromString(s, normalize)
    local _a = 1
    local _r = 0
    local _g = 1
    local _b = 0

    if not (s == nil) then
        _a = min(255, tonumber(string.sub(s, 1, 2), 16))
        _r = min(255, tonumber(string.sub(s, 3, 4), 16))
        _g = min(255, tonumber(string.sub(s, 5, 6), 16))
        _b = min(255, tonumber(string.sub(s, 7, 8), 16))
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

function TRB.Functions.Color:SetBackdropColor(frame, rgbaString, normalize, specId)
	if specId ~= nil and specId == GetSpecialization() then
		frame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
	end
end

function TRB.Functions.Color:SetBackdropBorderColor(frame, rgbaString, normalize, specId)
	if specId ~= nil and specId == GetSpecialization() then
		frame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
	end
end

function TRB.Functions.Color:SetStatusBarColor(frame, rgbaString, normalize, specId)
	if specId ~= nil and specId == GetSpecialization() then
		--frame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
	end
end

function TRB.Functions.Color:SetThresholdColor(frame, rgbaString, normalize, specId)
	if specId ~= nil and specId == GetSpecialization() then
		frame.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
		if frame.icon ~= nil then
			frame.icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(rgbaString, normalize))
		end
	end
end