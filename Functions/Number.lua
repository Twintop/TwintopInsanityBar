local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Number = {}

---Determines if the parameter is any kind of number
---@param data any
---@return boolean
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

---Rounds the supplied number to a number of decimal places.
---@param num number # Number to round
---@param numDecimalPlaces number? # Number of decimal places to round to
---@param mode string? # Rounding mode. `floor`, `ceil`, or no rounding
---@param returnAsNumber boolean? # Should the method return a number or a string
---@return number|string
function TRB.Functions.Number:RoundTo(num, numDecimalPlaces, mode, returnAsNumber)
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
	else
		newNum = string.format("%." .. numDecimalPlaces .. "f", newNum)
	end

	if returnAsNumber then
		return tonumber(newNum)
	else
		return newNum
	end
end