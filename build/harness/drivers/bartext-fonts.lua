-- Records the font every bar text string gets at login, for build/font-compare.ps1 (settings in harness/README.md).
local desktop = _G --[[@as table<string, any>]]
local os, io = desktop.os, desktop.io
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = tonumber(os.getenv("TRB_SPEC") or ""), holdDeferredSetup = true })

	-- Keeps the last font each string was given, and succeeds as a font that loads does.
	local meta = getmetatable(desktop.CreateFrame("Frame"))
	local index = meta.__index
	local function SetFont(self, path, size, flags)
		rawset(self, "__font", tostring(path) .. " | " .. tostring(size) .. " | " .. tostring(flags))
		return true
	end
	meta.__index = function(self, key)
		if key == "SetFont" then
			return SetFont
		end
		return index(self, key)
	end
end

---The LibSharedMedia type a saved texture, font, or sound key holds.
---@param key string
---@return string
local function MediaType(key)
	if key == "fontFace" then
		return "font"
	elseif key == "sound" then
		return "sound"
	elseif key == "border" or key:match("Border$") then
		return "border"
	elseif key == "background" or key:match("Background$") then
		return "background"
	end
	return "statusbar"
end

function hooks.afterLoad(ctx)
	if os.getenv("TRB_REGISTER_SAVED_MEDIA") ~= "1" then
		return
	end
	-- An empty path registers nothing, so a name saved without a file resolves to wherever it is really registered.
	local lsm = ctx.TRB.Details.addonData.libs.SharedMedia
	local seen = {}
	local function Walk(t)
		if seen[t] then
			return
		end
		seen[t] = true
		for key, value in pairs(t) do
			if type(value) == "table" then
				Walk(value)
			elseif type(key) == "string" and not key:match("Name$") and type(value) == "string" and value ~= "" then
				local name = t[key .. "Name"]
				if type(name) == "string" and name ~= "" and not lsm:IsValid(MediaType(key), name) then
					lsm:Register(MediaType(key), name, value)
				end
			end
		end
	end
	for _, savedName in ipairs({ "TwintopInsanityBarSettings", "TwintopInsanityBarForeverSettings" }) do
		local saved = rawget(desktop, savedName)
		if type(saved) == "table" then
			Walk(saved)
		end
	end
end

function hooks.afterEvents(ctx)
	local outPath = os.getenv("TRB_FONT_OUT")
	if outPath == nil or outPath == "" then
		return
	end
	local out = assert(io.open(outPath, "wb"))
	local count = 0
	for i, frame in ipairs(ctx.TRB.Frames.textFrames or {}) do
		local font = frame.font and rawget(frame.font, "__font")
		if font then
			count = count + 1
			out:write(string.format("%d %s\n", i, font))
		end
	end
	out:close()
	print("FONTS written " .. count .. " key=" .. tostring(ctx.TRB.Data.character.compositeKey))
end

return hooks
