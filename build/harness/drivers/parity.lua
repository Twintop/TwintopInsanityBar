-- Client behavior the drivers need past smoke-loading, since they build options panels and bars.
local M = {}

-- The event a driver fires to run the deferred setup that HoldDeferredSetup held back.
M.releaseEvent = "TRB_RELEASE_DEFERRED"

---Installs the patches. Call it from a driver's afterInstall hook.
---@param ctx table # The harness's driver context
---@param options { spec: integer?, holdDeferredSetup: boolean? }?
function M.Install(ctx, options)
	options = options or {}
	local G = _G --[[@as table<string, any>]]
	local rawget, rawset = rawget, rawset

	-- Forever's version gate refuses to load without its project id, which the stubs lack.
	if ctx.tocRel:find("Forever", 1, true) then
		G.WOW_PROJECT_CAMELOT = 18
		G.WOW_PROJECT_ID = 18
	end

	if options.spec ~= nil then
		G.GetSpecialization = function() return options.spec end
		G.C_SpecializationInfo.GetSpecialization = function() return options.spec end
	end

	-- A template's named regions, such as a slider's <name>Text, are looked up by name.
	G.getglobal = function(name)
		local value = rawget(G, name)
		if value == nil then
			value = G.CreateFrame("Frame", name)
		end
		return value
	end
	G.string.trim = G.string.trim or function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

	-- An unknown Get* reads 0, and any other unknown member is a child frame, as template children like Swatch1 are.
	local meta = getmetatable(G.CreateFrame("Frame"))
	local baseIndex = meta.__index
	local unknown = baseIndex({}, "ZzzUnknownProbe")
	meta.__call = function() return nil end
	meta.__index = function(self, key)
		local value = baseIndex(self, key)
		if value ~= unknown or type(key) ~= "string" then
			return value
		end
		if key == "GetMinMaxValues" then
			return function() return 0, 1000000 end
		end
		if key:match("^Get") then
			return function() return 0 end
		end
		local cache = rawget(self, "__childCache")
		if cache == nil then
			cache = {}
			rawset(self, "__childCache", cache)
		end
		if cache[key] == nil then
			cache[key] = G.CreateFrame("Frame")
		end
		return cache[key]
	end

	-- WoW's string.format takes positional arguments (%2$s); desktop Lua's rejects them.
	local baseFormat = G.string.format
	local function PositionalFormat(fmt, ...)
		if type(fmt) ~= "string" or not fmt:find("%%%d+%$") then
			return baseFormat(fmt, ...)
		end
		local args = { ... }
		local ordered, count = {}, 0
		local rewritten = fmt:gsub("%%(%d+)%$", function(index)
			count = count + 1
			ordered[count] = args[tonumber(index)]
			return "%"
		end)
		return baseFormat(rewritten, unpack(ordered, 1, count))
	end
	G.string.format = PositionalFormat
	G.format = PositionalFormat

	-- A checkbox template's <name>Text label is the checkbox's child, not a parentless frame getglobal makes.
	local innerCreate = G.CreateFrame
	G.CreateFrame = function(frameType, name, parent, template, id)
		local frame = innerCreate(frameType, name, parent, template, id)
		local isCheckbox = frameType == "CheckButton" or (template ~= nil and tostring(template):find("CheckButton") ~= nil)
		if type(name) == "string" and isCheckbox and rawget(G, name .. "Text") == nil then
			innerCreate("Frame", name .. "Text", frame)
		end
		return frame
	end

	-- The harness runs timers right after each event, which would run the 1s deferred setup before PLAYER_LOGIN.
	if options.holdDeferredSetup then
		local realAfter = G.C_Timer.After
		local held = {}
		local holding = true
		G.C_Timer.After = function(delay, callback)
			if holding and delay >= 1 then
				held[#held + 1] = callback
			else
				realAfter(delay, callback)
			end
		end
		local release = G.CreateFrame("Frame")
		release:RegisterEvent(M.releaseEvent)
		release:SetScript("OnEvent", function()
			holding = false
			for _, callback in ipairs(held) do
				realAfter(0, callback)
			end
		end)
	end
end

return M
