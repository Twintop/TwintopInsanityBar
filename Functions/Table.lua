---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Table = {}

---Returns the number of entries in a table (works for both array and dictionary-style tables)
---@param T table? The table to count entries in
---@return integer count The number of key-value pairs in the table
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

---Recursively serializes a table into a human-readable indented string representation for debugging
---@param T table The table to serialize
---@param indent integer? The current indentation level in spaces (default 0)
---@param maxDepth integer? The maximum recursion depth for nested tables (default 2)
---@param currentDepth integer? The current recursion depth (used internally, do not set)
---@return string output The formatted string representation of the table
function TRB.Functions.Table:Print(T, indent, maxDepth, currentDepth)
	maxDepth = maxDepth or 2
	currentDepth = currentDepth or 0
	currentDepth = currentDepth + 1
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
			if currentDepth <= maxDepth then
				toprint = toprint .. TRB.Functions.Table:Print(v, indent + 2, maxDepth, currentDepth) .. ",\r\n"
			else
				toprint = toprint .. tostring(v)
			end
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end

	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

---Deep-merges the incoming table into the original table, recursively merging nested sub-tables
---@param original table? The base table to merge into (modified in place)
---@param incoming table? The table whose values will be merged into original
---@return table merged The merged result table
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

---Appends an element to a list stored at the given key in a dictionary, creating the list if it does not exist
---@param dictionary table<any, any[]> The dictionary of lists to add to
---@param id any The key under which to store the element (skipped if nil)
---@param element any The element to append to the list
function TRB.Functions.Table:AddToDictionaryOfListsById(dictionary, id, element)
	if id ~= nil then
		dictionary[id] = dictionary[id] or {}
		table.insert(dictionary[id], element)
	end
end