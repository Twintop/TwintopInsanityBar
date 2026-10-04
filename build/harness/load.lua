-- Smoke-load harness: loads a WoW addon's TOC file list in order under stubbed APIs.
-- Usage: lua5.1 load.lua <addonDir> <tocRelPath> [classId] [fireEvents]
local addonDir, tocRel, classIdArg, fireEvents = ...
assert(addonDir and tocRel, "usage: load.lua <addonDir> <tocRelPath> [classId] [fireEvents]")
local classId = tonumber(classIdArg) or 5
local harnessDir = arg[0]:match("^(.*)[/\\]") or "."
package.path = harnessDir .. "/?.lua;" .. package.path

local function normalize(p)
	p = p:gsub("\\", "/")
	return p
end

local function dirname(p)
	return p:match("^(.*)/[^/]*$") or "."
end

-- Parse TOC metadata and file list
local tocPath = normalize(addonDir .. "/" .. tocRel)
local metadata = {}
local files = {}

local function readFile(path)
	local f, err = io.open(path, "rb")
	if not f then return nil, err end
	local s = f:read("*a")
	f:close()
	-- strip UTF-8 BOM
	if s:sub(1, 3) == "\239\187\191" then s = s:sub(4) end
	return s
end

local function addXml(xmlPath)
	local content = assert(readFile(xmlPath), "cannot read " .. xmlPath)
	local base = dirname(xmlPath)
	-- Strip XML comments
	content = content:gsub("<!%-%-.-%-%->", "")
	for tag, attrs in content:gmatch("<(%a+)%s+([^>]-)/?>") do
		if tag == "Script" or tag == "Include" then
			local file = attrs:match('file%s*=%s*"([^"]+)"')
			if file then
				local full = normalize(base .. "/" .. file)
				if full:lower():match("%.xml$") then
					addXml(full)
				else
					files[#files + 1] = full
				end
			end
		end
	end
end

do
	local content = assert(readFile(tocPath), "cannot read " .. tocPath)
	for line in content:gmatch("[^\r\n]+") do
		local key, value = line:match("^##%s*([%w%-]+):%s*(.-)%s*$")
		if key then
			metadata[key] = value
		elseif not line:match("^#") and line:match("%S") then
			local rel = line:match("^%s*(.-)%s*$")
			local full = normalize(addonDir .. "/" .. rel)
			if full:lower():match("%.xml$") then
				addXml(full)
			else
				files[#files + 1] = full
			end
		end
	end
end

-- Stubs
local stubs = require("stubs")
local addonName = "TwintopInsanityBar"
-- Optional saved variables: TRB_SAVED names a WoW SavedVariables file (assigns the globals it declares).
local savedVariables = nil
local savedPath = os.getenv("TRB_SAVED")
if savedPath and savedPath ~= "" then
	local chunk = assert(loadfile(savedPath))
	local sandbox = setmetatable({}, { __index = _G })
	setfenv(chunk, sandbox)
	chunk()
	savedVariables = {}
	for name in tostring(metadata.SavedVariables or ""):gmatch("[^,%s]+") do
		if rawget(sandbox, name) ~= nil then savedVariables[name] = sandbox[name] end
	end
end
local env = stubs.install({ addonName = addonName, metadata = metadata, classId = classId, savedVariables = savedVariables })

local TRB = {}
local failures = 0
local loaded = 0
local skipped = 0
for _, path in ipairs(files) do
	local rel = path:sub(#normalize(addonDir) + 2)
	if rel:match("^Libs/") then
		skipped = skipped + 1
	else
		local chunk, err = loadfile(path)
		if not chunk then
			failures = failures + 1
			print("SYNTAX  " .. rel .. "\n    " .. tostring(err))
		else
			local ok, rerr = xpcall(function() return chunk(addonName, TRB) end, function(e)
				return debug.traceback(tostring(e), 2)
			end)
			if ok then
				loaded = loaded + 1
			else
				failures = failures + 1
				print("ERROR   " .. rel .. "\n    " .. tostring(rerr):gsub("\n", "\n    "))
			end
		end
	end
end
print(string.format("Loaded %d files (%d libs skipped), %d failures", loaded, skipped, failures))

local timerFailures = 0
if fireEvents and fireEvents ~= "" and failures == 0 then
	local eventFailures
	eventFailures, timerFailures = stubs.fireEvents(fireEvents, addonName)
	failures = failures + eventFailures
end

local dumpSaved = os.getenv("TRB_DUMP_SAVED")
if dumpSaved and dumpSaved ~= "" then
	local snapshot = require("snapshot")
	local out = assert(io.open(dumpSaved, "wb"))
	for name in tostring(metadata.SavedVariables or ""):gmatch("[^,%s]+") do
		local value = rawget(_G, name)
		if value ~= nil then
			out:write(name .. " = " .. snapshot.serialize(value) .. "\n")
		end
	end
	out:close()
	print("Saved variables written: " .. dumpSaved)
end

local dumpPath = os.getenv("TRB_SNAPSHOT")
if dumpPath and dumpPath ~= "" then
	local snapshot = require("snapshot")
	local ok, text = pcall(function() return snapshot.serialize(snapshot.collect(TRB)) end)
	if not ok then
		print("SNAPSHOT ERROR " .. tostring(text))
		failures = failures + 1
	else
		local out = assert(io.open(dumpPath, "wb"))
		out:write(text)
		out:close()
		print("Snapshot written: " .. dumpPath .. " (" .. #text .. " bytes)")
	end
end

if stubs.finish then
	stubs.finish()
end
if timerFailures > 0 then
	print(string.format("Note: %d deferred (C_Timer) callback(s) failed inside stubbed UI code; informational only.", timerFailures))
end
os.exit(failures == 0 and 0 or 1)
