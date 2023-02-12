local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Number = {}

function TRB.Functions.Number:IsNumeric(data)
	if type(data) == "number" then
		return true
	elseif type(data) ~= "string" then
		return false
	end
	data = strtrim(data)
	local x, y = string.find(data, "[%d+][%.?][%d*]")
	if x and x == 1 and y == strlen(data) then
		return true
	end
	return false
end

function TRB.Functions.Number:RoundTo(num, numDecimalPlaces, mode)
	numDecimalPlaces = math.max(numDecimalPlaces or 0, 0)
	local newNum = tostring(tonumber(num) or 0)
	if mode == "floor" then
		local whole, decimal = strsplit(".", newNum, 2)

		if numDecimalPlaces == 0 then
			newNum = whole
		elseif decimal == nil or strlen(decimal) == 0 then
			newNum = string.format("%s.%0" .. numDecimalPlaces .. "d", whole, 0)
		else
			local chopped = string.sub(decimal, 1, numDecimalPlaces)
			if strlen(chopped) < numDecimalPlaces then
				chopped = string.format("%s%0" .. (numDecimalPlaces - strlen(chopped)) .. "d", chopped, 0)
			end
			newNum = string.format("%s.%s", whole, chopped)
		end

		return newNum
	elseif mode == "ceil" then
		local whole, decimal = strsplit(".", newNum, 2)

		if numDecimalPlaces == 0 then
			if (tonumber(whole) or 0) < num then
				whole = (tonumber(whole) or 0) + 1
			end

			newNum = tostring(whole)
		elseif decimal == nil or strlen(decimal) == 0 then
			newNum = string.format("%s.%0" .. numDecimalPlaces .. "d", whole, 0)
		else
			local chopped = string.sub(decimal, 1, numDecimalPlaces)
			if tonumber(string.format("0.%s", chopped)) < tonumber(string.format("0.%s", decimal)) then
				chopped = tostring(tonumber(chopped) + 1)
			end

			if strlen(chopped) < numDecimalPlaces then
				chopped = string.format("%s%0" .. (numDecimalPlaces - strlen(chopped)) .. "d", chopped, 0)
			end
			newNum = string.format("%s.%s", whole, chopped)
		end

		return newNum
	end

	return tonumber(string.format("%." .. numDecimalPlaces .. "f", newNum))
end