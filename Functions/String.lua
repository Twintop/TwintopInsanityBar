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

---Checks if the original string constains the substring provided
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