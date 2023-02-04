local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.String = {}

function TRB.Functions.String:ConvertToShortNumberNotation(num, numDecimalPlaces, mode, isInteger)
	numDecimalPlaces = math.max(numDecimalPlaces or 0, 0)
	isInteger = isInteger or false
	local negative = ""

	if num < 0 then
		negative = "-"
		num = -num
	end

	if num >= 10^9 then
		return string.format(negative .. "%." .. numDecimalPlaces .. "fb", TRB.Functions.Number:RoundTo(num / 10^9, numDecimalPlaces, mode))
	elseif num >= 10^6 then
        return string.format(negative .. "%." .. numDecimalPlaces .. "fm", TRB.Functions.Number:RoundTo(num / 10^6, numDecimalPlaces, mode))
    elseif num >= 10^3 then
        return string.format(negative .. "%." .. numDecimalPlaces .. "fk", TRB.Functions.Number:RoundTo(num / 10^3, numDecimalPlaces, mode))
    else
		if isInteger then
        	return string.format(negative .. "%.0f", TRB.Functions.Number:RoundTo(num, 0, mode))
		else			
			return string.format(negative .. "%." .. numDecimalPlaces .. "f", TRB.Functions.Number:RoundTo(num, 0, mode))
		end
    end
end