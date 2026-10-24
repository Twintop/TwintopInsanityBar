-- Rewrites a save's fonts into the edge cases build/font-compare.ps1 checks; usage is in harness/README.md.
local inPath, outPath, onlyCase = ...
local desktop = _G --[[@as table<string, any>]]
local io, loadfile, require, package = desktop.io, desktop.loadfile, desktop.require, desktop.package
assert(inPath and outPath, "usage: font-edge-save.lua <in> <out> [case]")
onlyCase = tonumber(onlyCase)
local harnessDir = arg[0]:match("^(.*)[/\\]") or "."
package.path = harnessDir .. "/?.lua;" .. package.path
local snapshot = require("snapshot")

local saved = {}
local chunk = assert(loadfile(inPath))
setfenv(chunk, saved)
chunk()

-- Non-default files throughout, so a default draw can't pass for the saved one.
local pickName = "Adventure"
local pickPath = "Interface\\Addons\\SharedMedia\\fonts\\adventure\\Adventure.ttf"
local otherPath = "Fonts\\2002.TTF"

local counts = { nilName = 0, emptyName = 0, noFile = 0, kept = 0 }
local n = 0
local seen = {}
local function Walk(t)
	if seen[t] then
		return
	end
	seen[t] = true
	if t.fontFaceName ~= nil and t.fontSize ~= nil then
		n = n + 1
		local case = n % 4
		if onlyCase then
			case = n == 1 and 0 or onlyCase
		end
		if case == 1 then
			t.fontFaceName, t.fontFace = nil, otherPath
			counts.nilName = counts.nilName + 1
		elseif case == 2 then
			t.fontFaceName, t.fontFace = "", otherPath
			counts.emptyName = counts.emptyName + 1
		elseif case == 3 then
			t.fontFaceName, t.fontFace = pickName, ""
			counts.noFile = counts.noFile + 1
		else
			t.fontFaceName, t.fontFace = pickName, pickPath
			counts.kept = counts.kept + 1
		end
	end
	for _, value in pairs(t) do
		if type(value) == "table" then
			Walk(value)
		end
	end
end

local out = assert(io.open(outPath, "wb"))
for name, value in pairs(saved) do
	if type(value) == "table" then
		Walk(value)
		out:write(name .. " = " .. snapshot.serialize(value) .. "\n")
	end
end
out:close()
print(string.format("fonts: nilName=%d emptyName=%d noFile=%d kept=%d", counts.nilName, counts.emptyName, counts.noFile, counts.kept))
