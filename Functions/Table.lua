---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Table = {}

function TRB.Functions.Table:Length(T)
	local count = 0
	if T ~= nil then
		local _
		for _ in pairs(T) do
			count = count + 1
		end
	end
	return count
end

function TRB.Functions.Table:Print(T, indent)
	if not indent then
		indent = 0
	end

	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(T) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "
		end

		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. TRB.Functions.Table:Print(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end

	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

function TRB.Functions.Table:Merge(original, incoming)
	if original == nil and incoming == nil then
		return {}
	elseif original == nil then
		return incoming
	elseif incoming == nil then
		return original
	end

	for k, v in pairs(incoming) do
		if (type(v) == "table") and (type(original[k] or false) == "table") then
			TRB.Functions.Table:Merge(original[k], incoming[k])
		else
			original[k] = v
		end
	end
	return original
end