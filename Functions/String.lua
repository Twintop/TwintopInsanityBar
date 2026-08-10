local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.String = {}

-- Western locales abbreviate on a 1,000-step scale: K=1e3, M=1e6, B=1e9, T=1e12.
local westernBreakpointData = {
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
}

-- CJK locales (zhCN/zhTW/koKR) group by myriads on a 10,000-step scale: 万/萬/만 = 1e4,
-- 亿/億/억 = 1e8, 兆/兆/조 = 1e12. Reuses the FIRST/SECOND/THIRD cap globals so the suffix
-- still auto-localizes, but divides on the correct myriad scale (avoids the 10x error where
-- e.g. 275,640 rendered as "275.6万" instead of "27.56万").
local myriadBreakpointData = {
    {
      breakpoint = 1e15,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e12,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e14,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e11,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e13,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e10,
      fractionDivisor = 1e2,
    },
    {
      breakpoint = 1e12,
      abbreviation = "THIRD_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e9,
      fractionDivisor = 1e3,
    },
    {
      breakpoint = 1e11,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e8,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e10,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e7,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e9,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e6,
      fractionDivisor = 1e2,
    },
    {
      breakpoint = 1e8,
      abbreviation = "SECOND_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e5,
      fractionDivisor = 1e3,
    },
    {
      breakpoint = 1e7,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e4,
      fractionDivisor = 1e0,
    },
    {
      breakpoint = 1e6,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e3,
      fractionDivisor = 1e1,
    },
    {
      breakpoint = 1e5,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e2,
      fractionDivisor = 1e2,
    },
    {
      breakpoint = 1e4,
      abbreviation = "FIRST_NUMBER_CAP_NO_SPACE",
      significandDivisor = 1e1,
      fractionDivisor = 1e3,
    },
}

-- CJK clients use myriad (10,000) grouping for number caps; everyone else uses 1,000-step.
local isMyriadLocale = ({ zhCN = true, zhTW = true, koKR = true })[GetLocale()] == true

local abbrevData = {
  breakpointData = isMyriadLocale and myriadBreakpointData or westernBreakpointData,
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
	-- Secret values cannot be compared or used in arithmetic; delegate to Blizzard engine APIs
	if issecretvalue(num) then
		if TRB.Data.settings ~= nil and TRB.Data.settings.core ~= nil and TRB.Data.settings.core.numberAbbreviation == false then
			return BreakUpLargeNumbers(num)
		end
---@diagnostic disable-next-line: redundant-parameter
		return AbbreviateNumbers(num, abbrevData)
	end

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

	-- CJK clients group by myriads (万/亿/兆) on a 10,000-step scale. Handle the capped tiers
	-- here, then fall through to the shared sub-10,000 formatting below.
	if isMyriadLocale then
		if num >= 10^15 then
			return string.format(negative .. "%.0f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^12, 0, mode))
		elseif num >= 10^14 then
			return string.format(negative .. "%.1f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^12, 1, mode))
		elseif num >= 10^13 then
			return string.format(negative .. "%.2f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^12, 2, mode))
		elseif num >= 10^12 then
			return string.format(negative .. "%.3f"..THIRD_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^12, 3, mode))
		elseif num >= 10^11 then
			return string.format(negative .. "%.0f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^8, 0, mode))
		elseif num >= 10^10 then
			return string.format(negative .. "%.1f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^8, 1, mode))
		elseif num >= 10^9 then
			return string.format(negative .. "%.2f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^8, 2, mode))
		elseif num >= 10^8 then
			return string.format(negative .. "%.3f"..SECOND_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^8, 3, mode))
		elseif num >= 10^7 then
			return string.format(negative .. "%.0f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^4, 0, mode))
		elseif num >= 10^6 then
			return string.format(negative .. "%.1f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^4, 1, mode))
		elseif num >= 10^5 then
			return string.format(negative .. "%.2f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^4, 2, mode))
		elseif num >= 10^4 then
			return string.format(negative .. "%.3f"..FIRST_NUMBER_CAP_NO_SPACE, TRB.Functions.Number:RoundTo(num / 10^4, 3, mode))
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

---Parses a number from a localized string, locale-safe. Ignores UI color codes (so their
---hex digits aren't mistaken for numbers) and strips international thousands separators:
---comma (1,234), period (1.234), space/NBSP/thin-space (1 234).
---@param str string?
---@param wantLast boolean? # true returns the LAST number in the string, false/nil the FIRST
---@return number?
local function ParseNumberFromString(str, wantLast)
	-- A secret string exposes no characters to match against, so there is nothing to parse.
	if not str or issecretvalue(str) then return nil end
	-- Drop color codes so their hex digits aren't mistaken for numbers.
	str = str:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	-- Match: a digit, then any mix of digits and thousands separators, ending with a digit.
	-- Handles: 1234, 1,234 (en), 1.234 (de/es), 1 234 / NBSP (fr/ru)
	local match
	for token in str:gmatch("%d[%d,%.%s\194\160]*%d") do
		match = token
		if not wantLast then break end
	end
	-- Single-digit fallback when no multi-digit run was found.
	if not match then
		for token in str:gmatch("%d") do
			match = token
			if not wantLast then break end
		end
	end
	if not match then return nil end
	return tonumber((match:gsub("[^%d]", "")))
end

---Parses the FIRST number from a localized string. See ParseNumberFromString for details.
---@param str string?
---@return number?
function TRB.Functions.String:ParseFirstNumber(str)
	return ParseNumberFromString(str, false)
end

---Parses the LAST number from a localized string (e.g. the resource value at the end of a
---spell description tooltip). See ParseNumberFromString for details.
---@param str string?
---@return number?
function TRB.Functions.String:ParseLastNumber(str)
	return ParseNumberFromString(str, true)
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

---Generates a random UUID v4 string in the format xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
---@return string guid A randomly generated UUID v4 string
function TRB.Functions.String:Guid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
---@diagnostic disable-next-line: redundant-return-value
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end