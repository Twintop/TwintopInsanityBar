local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.String = {}

local abbrevData = {
  breakpointData = {
    {
      breakpoint = 1e15,
      abbreviation = "FOURTH_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e12,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e14,
      abbreviation = "FOURTH_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e11,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e13,
      abbreviation = "FOURTH_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e10,
      fractionDivisor = 1e2,
    },
    {
      breakpoint = 1e12,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e9,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e11,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e8,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e10,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e7,
      fractionDivisor = 1e2,
    },
    {
      breakpoint = 1e9,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e6,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e8,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e5,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e7,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e4,
      fractionDivisor = 1e2,
    },
    {
      breakpoint = 1e6,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e3,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e5,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e2,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e4,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e1,
      fractionDivisor = 1e2,
    },
  },
  locale = GetLocale()
}

--[[
--Test data for debugging, borrowed from the WoW Addons discord.
local t = {1, 12, 123, 1234, 12345, 123456, 1234567, 12345678, 123456789, 1234567890, 12345678901, 123456789012, 1234567890123, 12345678901234, 123456789012345, 1234567890123456, 12345678901234567}
local t = {1, 1.2, 1.23, 1.234, 1.2345, 12.3, 123.4, 1234.5, 12.34, 12.345, 123.4, 123.456 }
print("|cffffd200AbbreviateLargeNumbers:|r")
for _, number in next, t do
  print(" ", BreakUpLargeNumbers(number), "|cffffd200->|r", AbbreviateLargeNumbers(number, abbrevData))
end

print("|cffffd200AbbreviateNumbers:|r")
for _, number in next, t do
  print(" ", BreakUpLargeNumbers(number), "|cffffd200->|r", AbbreviateNumbers(number, abbrevData))
end]]


---Converts a number into a short notation following the pattern: 1000, 10.00k, 100.0k, 1000k, 10.00m, 100.0m, 1000m, 10.00b, 100.0b, 1000b
---As of Midnight, using built-in AbbreviateNumbers() method which means it returns capitals but in exchange can accept secrets.
---The old version has been kept as `_OLD()`
---@param num number
---@return string # Short notation output
function TRB.Functions.String:ConvertToAbbreviatedNumber(num)
	if TRB.Data.settings ~= nil and TRB.Data.settings.core ~= nil and TRB.Data.settings.core.numberAbbreviation == false then
		return BreakUpLargeNumbers(num)
	end
---@diagnostic disable-next-line: redundant-parameter
	return AbbreviateNumbers(num, abbrevData)
end

---Converts a number into a short notation following the pattern: 1000, 10.00K, 100.0K, 1000K, 10.00M, 100.0M, 1000M, 10.00B, 100.0B, 1000B
---@param num number
---@param numDecimalPlaces integer # Only used if sub 1000 and `num` is not an integer
---@param mode string # Rounding mode
---@param isInteger boolean # Is `num` an integer?
---@return string # Short notation output
function TRB.Functions.String:ConvertToShortNumberNotation(num, numDecimalPlaces, mode, isInteger)
	numDecimalPlaces = math.max(numDecimalPlaces or 0, 0)
	isInteger = isInteger or false
	local negative = ""

	if num < 0 then
		negative = "-"
		num = -num
	end

	if TRB.Data.settings ~= nil and TRB.Data.settings.core ~= nil and TRB.Data.settings.core.numberAbbreviation == false then
		if isInteger or num == math.floor(num) then
			return negative .. BreakUpLargeNumbers(TRB.Functions.Number:RoundTo(num, 0, mode))
		else
			return negative .. BreakUpLargeNumbers(TRB.Functions.Number:RoundTo(num, numDecimalPlaces, mode))
		end
	end

	if num >= 10^12 then
		return string.format(negative .. "%.0f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^9, 0, mode))
	elseif num >= 10^11 then
		return string.format(negative .. "%.1f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^9, 3, mode))
	elseif num >= 10^10 then
		return string.format(negative .. "%.2f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^9, 2, mode))
	elseif num >= 10^9 then
		return string.format(negative .. "%.0f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^6, 0, mode))
	elseif num >= 10^8 then
		return string.format(negative .. "%.1f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^6, 3, mode))
	elseif num >= 10^7 then
		return string.format(negative .. "%.2f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^6, 2, mode))
	elseif num >= 10^6 then
		return string.format(negative .. "%.0f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^3, 0, mode))
	elseif num >= 10^5 then
		return string.format(negative .. "%.1f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^3, 3, mode))
	elseif num >= 10^4 then
		return string.format(negative .. "%.2f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^3, 2, mode))
	elseif num >= 10^3 then
		return string.format(negative .. "%.0f", TRB.Functions.Number:RoundTo(num, 0, mode))
	else
		if isInteger then
			return string.format(negative .. "%.0f", TRB.Functions.Number:RoundTo(num, 0, mode))
		else
			return string.format(negative .. "%." .. numDecimalPlaces .. "f", TRB.Functions.Number:RoundTo(num, 0, mode))
		end
	end
end

---Checks if the original string contains the substring provided
---@param original string
---@param sub string
---@return boolean
function TRB.Functions.String:Contains(original, sub)
    return string.find(original, sub, 1, true) ~= nil
end

---Checks if the original string starts with the string provided
---@param original string
---@param start string
---@return boolean
function TRB.Functions.String:StartsWith(original, start)
    return string.sub(original, 1, #start) == start
end

---Checks if the original string ends with the string provided
---@param original string
---@param ending string
---@return boolean
function TRB.Functions.String:EndsWith(original, ending)
    return ending == "" or string.sub(original, -#ending) == ending
end

---Replaces all occurances of the old string with the new string within the original provided string
---@param original string
---@param old string
---@param new string
---@return string
function TRB.Functions.String:Replace(original, old, new)
    local s = original
    local search_start_idx = 1

    while true do
        local start_idx, end_idx = s:find(old, search_start_idx, true)
        if (not start_idx) then
            break
        end

        local postfix = s:sub(end_idx + 1)
        s = s:sub(1, (start_idx - 1)) .. new .. postfix

        search_start_idx = -1 * postfix:len()
    end

    return s
end

---Inserts text at the specified position within the original string
---@param original string
---@param pos integer
---@param text string
---@return string
function TRB.Functions.String:Insert(original, pos, text)
    return string.sub(original, 1, pos - 1) .. text .. string.sub(original, pos)
end

function TRB.Functions.String:Guid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end