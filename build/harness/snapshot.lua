-- Deterministic serialization of addon state for golden comparisons.
local M = {}

local function sortedKeys(t)
	local keys = {}
	for k in pairs(t) do keys[#keys + 1] = k end
	table.sort(keys, function(a, b)
		local ta, tb = type(a), type(b)
		if ta ~= tb then return ta < tb end
		if ta == "number" or ta == "string" then return a < b end
		return tostring(a) < tostring(b)
	end)
	return keys
end

local function serialize(v, indent, seen, out)
	local tv = type(v)
	if tv == "table" then
		if seen[v] then out[#out + 1] = "<cycle>" return end
		seen[v] = true
		local keys = sortedKeys(v)
		if #keys == 0 then out[#out + 1] = "{}" seen[v] = nil return end
		out[#out + 1] = "{\n"
		for _, k in ipairs(keys) do
			out[#out + 1] = indent .. "  [" .. (type(k) == "string" and string.format("%q", k) or tostring(k)) .. "] = "
			serialize(v[k], indent .. "  ", seen, out)
			out[#out + 1] = ",\n"
		end
		out[#out + 1] = indent .. "}"
		seen[v] = nil
	elseif tv == "string" then
		out[#out + 1] = string.format("%q", v)
	elseif tv == "function" then
		out[#out + 1] = "<function>"
	elseif tv == "userdata" then
		out[#out + 1] = "<userdata>"
	else
		out[#out + 1] = tostring(v)
	end
end

function M.serialize(v)
	local out = {}
	serialize(v, "", {}, out)
	return table.concat(out)
end

---Collects the data worth comparing before/after a refactor.
function M.collect(TRB)
	local snap = {}
	snap.settings = TRB.Data and TRB.Data.settings
	snap.classRegistryOrder = TRB.Data and TRB.Data.classRegistryOrder
	snap.specRegistryOrder = TRB.Data and TRB.Data.specRegistryOrder
	snap.maxResource = TRB.Data and TRB.Data.maxResource
	snap.supportedSpecs = TRB.Details and TRB.Details.supportedSpecs
	snap.character = TRB.Data and TRB.Data.character and { classId = TRB.Data.character.classId, specId = TRB.Data.character.specId, className = TRB.Data.character.className, specName = TRB.Data.character.specName, maxResource = TRB.Data.character.maxResource, resourceType = TRB.Data.character.resourceType, resourceTypeName = TRB.Data.character.resourceTypeName }
	local loc = {}
	if TRB.Localization then
		for k, v in pairs(TRB.Localization) do
			if type(k) == "string" and (k:match("Full$") or k:match("^Resource")) then loc[k] = v end
		end
		for _, entry in ipairs(TRB.Data and TRB.Data.specRegistryOrder or {}) do
			local key = entry.classModuleName .. (entry.specName:gsub("^%l", string.upper))
			loc[key] = rawget(TRB.Localization, key)
			loc[entry.classModuleName] = rawget(TRB.Localization, entry.classModuleName)
		end
	end
	snap.localization = loc
	if TRB.Classes and TRB.Classes.BarTypeRegistry then
		local reg = TRB.Classes.BarTypeRegistry:GetInstance()
		local defs = {}
		for key, def in pairs(reg:GetAll()) do
			local d = {}
			for k, v in pairs(def) do
				if type(v) ~= "function" then d[k] = v end
			end
			-- Also capture what the default factories produce
			if def.GetDefaultDimensions then d.__defaultDimensions = def:GetDefaultDimensions(false) end
			if def.GetDefaultColors then d.__defaultColors = def:GetDefaultColors() end
			if def.GetDefaultTextures then d.__defaultTextures = def:GetDefaultTextures() end
			defs[key] = d
		end
		snap.barTypes = defs
	end
	local btv = {}
	for k in pairs(TRB.Data and TRB.Data.barTextVariablesRegistry or {}) do btv[k] = true end
	snap.barTextVariablesRegistryKeys = btv
	local opts = {}
	for k, v in pairs(TRB.Options or {}) do
		if type(v) == "table" and v.LoadDefaultSettings then
			local ok, res = pcall(v.LoadDefaultSettings, true)
			opts[k] = ok and res or ("ERROR: " .. tostring(res))
		end
	end
	snap.optionsDefaultsWithBarText = opts
	return snap
end

return M
