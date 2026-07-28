local addonName, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}

---@class TRB.Functions.VersionGate
TRB.Functions.VersionGate = {}
local VersionGate = TRB.Functions.VersionGate

---@param interfaceVersion string|number|nil
---@return string
local function FormatInterfaceVersion(interfaceVersion)
	local value = tonumber(interfaceVersion)
	if value == nil then
		return "??"
	end
	return string.format("%d.%d.%d", math.floor(value / 10000), math.floor(value / 100) % 100, value % 100)
end

---X-TargetInterface mirrors the Interface directive, which GetAddOnMetadata cannot read, and may list
---several versions comma separated. Unreadable entries are dropped so a malformed list cannot block.
---@param interfaceField string|nil
---@return number[]
local function ParseInterfaceVersions(interfaceField)
	local versions = {}
	if interfaceField ~= nil then
		for entry in string.gmatch(interfaceField, "[^,]+") do
			local value = tonumber(entry)
			if value ~= nil then
				versions[#versions + 1] = value
			end
		end
	end
	return versions
end

---@param versions number[]
---@return string
local function FormatInterfaceVersions(versions)
	local formatted = {}
	for i = 1, #versions do
		formatted[i] = FormatInterfaceVersion(versions[i])
	end
	return table.concat(formatted, ", ")
end

local enforced = C_AddOns.GetAddOnMetadata(addonName, "X-VersionCheck") == "enabled"
local addonVersions = ParseInterfaceVersions(C_AddOns.GetAddOnMetadata(addonName, "X-TargetInterface"))
local clientInterface = select(4, GetBuildInfo())
local clientVersionNumber = tonumber(clientInterface)

---Whether the client's version is one of the versions this build lists. Each comparison is exact:
---a build targeting only 12.1.0 does not match 12.0.7 or 12.1.5.
---@return boolean
local function DoesClientVersionMatch()
	-- An unreadable client version is not evidence of a mismatch, so it loads normally.
	if clientVersionNumber == nil then
		return true
	end
	for i = 1, #addonVersions do
		if addonVersions[i] == clientVersionNumber then
			return true
		end
	end
	return false
end

local blocked = enforced and #addonVersions > 0 and not DoesClientVersionMatch()

---Whether this build targets a different game version than the client it is running on. Every
---bootstrapping entry point checks this before touching settings, saved variables, or frames.
---@return boolean
function VersionGate:IsBlocked()
	return blocked
end

if blocked then
	local addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version") .. "-" .. C_AddOns.GetAddOnMetadata(addonName, "X-ReleaseType")
	local targetVersion = FormatInterfaceVersions(addonVersions)
	local playingVersion = FormatInterfaceVersion(clientInterface)

	StaticPopupDialogs["TwintopResourceBar_VersionMismatch"] = {
		text = "",
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		showAlert = true,
		preferredIndex = 3,
		OnShow = function(self)
			self:SetFormattedText(L["VersionGateMismatchPopupText"], addonVersion, targetVersion, playingVersion)
		end,
	}

	-- Nothing else in the addon runs while gated, so the saved variables table is exactly what was
	-- read from disk. Hold the reference and put it back at logout so a halted load can never write
	-- partial or empty state over the user's settings.
	local savedVariables = nil

	local gateFrame = CreateFrame("Frame")
	gateFrame:RegisterEvent("ADDON_LOADED")
	gateFrame:RegisterEvent("PLAYER_LOGIN")
	gateFrame:RegisterEvent("PLAYER_LOGOUT")
	gateFrame:SetScript("OnEvent", function(_, event, arg1)
		if event == "ADDON_LOADED" then
			if arg1 == addonName then
				savedVariables = TwintopInsanityBarSettings
			end
		elseif event == "PLAYER_LOGIN" then
			print(string.format(L["VersionGateMismatchChatMessage"], addonVersion, targetVersion, playingVersion))
			StaticPopup_Show("TwintopResourceBar_VersionMismatch")
		elseif event == "PLAYER_LOGOUT" then
			TwintopInsanityBarSettings = savedVariables
		end
	end)
end
