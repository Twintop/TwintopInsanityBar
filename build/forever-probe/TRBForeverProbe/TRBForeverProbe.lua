---@diagnostic disable: undefined-global, deprecated -- every probe targets APIs that may not exist on this client
-- TRB Forever Probe: a throwaway addon that records what the client exposes so the Forever flavor of
-- Twintop's Resource Bar can be built on facts instead of guesses. Install it alone in the Forever
-- client's AddOns folder, log in on one character per class, and run /trbprobe. Results print to chat
-- and are saved in TRBForeverProbeResults (WTF\...\SavedVariables\TRBForeverProbe.lua), one entry per
-- character, so a single file can be shared back.
--
-- Nothing here depends on the addon itself. Every probe is wrapped in pcall: an API that is missing or
-- throws is itself a finding.

local addonName = ...
local results = {}

local function Value(v)
	if v == nil then return "nil" end
	local t = type(v)
	if t == "boolean" or t == "number" then return tostring(v) end
	if t == "string" then return string.format("%q", v) end
	if issecretvalue ~= nil and issecretvalue(v) then return "<secret " .. t .. ">" end
	if t == "table" then
		local parts = {}
		local count = 0
		for k, x in pairs(v) do
			count = count + 1
			if count > 40 then parts[#parts + 1] = "..." break end
			parts[#parts + 1] = tostring(k) .. "=" .. Value(x)
		end
		return "{" .. table.concat(parts, ", ") .. "}"
	end
	return "<" .. t .. ">"
end

local function Record(section, key, ...)
	local n = select("#", ...)
	local parts = {}
	for i = 1, n do parts[i] = Value((select(i, ...))) end
	results[section] = results[section] or {}
	results[section][key] = table.concat(parts, ", ")
end

local function Probe(section, key, fn)
	local ok, a, b, c, d, e, f, g, h = pcall(fn)
	if ok then
		Record(section, key, a, b, c, d, e, f, g, h)
	else
		Record(section, key, "ERROR: " .. tostring(a))
	end
end

local function Exists(section, name)
	local parts = {}
	for part in name:gmatch("[^%.]+") do parts[#parts + 1] = part end
	local value = _G
	for _, part in ipairs(parts) do
		if type(value) ~= "table" then value = nil break end
		value = rawget(value, part) or value[part]
	end
	Record(section, name, value ~= nil and type(value) or "MISSING")
end

local function Run()
	results = { probedAt = date("%Y-%m-%d %H:%M:%S") }

	-- Identity: which client, which project, which addon folder.
	Probe("client", "GetBuildInfo", function() return GetBuildInfo() end)
	Probe("client", "WOW_PROJECT_ID", function() return WOW_PROJECT_ID end)
	for _, name in ipairs({ "WOW_PROJECT_MAINLINE", "WOW_PROJECT_CLASSIC", "WOW_PROJECT_BURNING_CRUSADE_CLASSIC", "WOW_PROJECT_WRATH_CLASSIC", "WOW_PROJECT_CATACLYSM_CLASSIC", "WOW_PROJECT_MISTS_CLASSIC", "WOW_PROJECT_FOREVER", "WOW_PROJECT_FOREVER_CLASSIC" }) do
		Probe("client", name, function() return _G[name] end)
	end
	Probe("client", "LE_EXPANSION_LEVEL_CURRENT", function() return LE_EXPANSION_LEVEL_CURRENT end)
	Probe("client", "GetExpansionLevel", function() return GetExpansionLevel() end)
	Probe("client", "GetMaxLevelForPlayerExpansion", function() return GetMaxLevelForPlayerExpansion() end)
	Probe("client", "IsFOREVER-ish globals", function()
		local hits = {}
		for name in pairs(_G) do
			if type(name) == "string" and name:find("FOREVER") then hits[#hits + 1] = name end
		end
		table.sort(hits)
		return table.concat(hits, ", ")
	end)
	Probe("client", "GetAddOnMetadata Interface", function() return C_AddOns.GetAddOnMetadata(addonName, "Interface"), C_AddOns.GetAddOnMetadata(addonName, "X-TargetInterface") end)
	Probe("client", "GetCVar portal/agentUID", function() return GetCVar("portal"), GetCVar("agentUID") end)
	Probe("client", "GetCurrentRegion", function() return GetCurrentRegion() end)

	-- Character, class and spec.
	Probe("character", "UnitClass", function() return UnitClass("player") end)
	Probe("character", "UnitRace", function() return UnitRace("player") end)
	Probe("character", "UnitLevel", function() return UnitLevel("player") end)
	Probe("character", "GetSpecialization", function() return GetSpecialization() end)
	Probe("character", "GetNumSpecializations", function() return GetNumSpecializations() end)
	Probe("character", "GetSpecializationInfo(1..4)", function()
		local out = {}
		for i = 1, 4 do out[i] = Value({ GetSpecializationInfo(i) }) end
		return table.concat(out, " | ")
	end)
	Probe("character", "GetSpecializationInfoByID(258 shadow)", function() return GetSpecializationInfoByID(258) end)
	Probe("character", "GetSpecializationInfoByID(260 outlaw/combat)", function() return GetSpecializationInfoByID(260) end)
	Probe("character", "GetNumSpecializationsForClassID(1..13)", function()
		local out = {}
		for c = 1, 13 do out[#out + 1] = c .. ":" .. tostring(GetNumSpecializationsForClassID(c)) end
		return table.concat(out, " ")
	end)
	Probe("character", "GetClassInfo(1..13)", function()
		local out = {}
		for c = 1, 13 do
			local name, file = GetClassInfo(c)
			out[#out + 1] = c .. ":" .. tostring(file)
		end
		return table.concat(out, " ")
	end)
	Probe("character", "LocalizedClassList", function() return LocalizedClassList() end)
	Probe("character", "GetClassColor(PRIEST)", function() return GetClassColor("PRIEST") end)

	-- Talents: modern trait trees or classic tabs?
	Exists("talents", "C_ClassTalents.GetActiveConfigID")
	Exists("talents", "C_Traits.GetConfigInfo")
	Exists("talents", "GetTalentInfo")
	Exists("talents", "GetNumTalentTabs")
	Exists("talents", "GetTalentTabInfo")
	Exists("talents", "C_SpecializationInfo.GetAllSelectedPvpTalentIDs")
	Exists("talents", "GetPvpTalentInfoByID")
	Probe("talents", "C_ClassTalents.GetActiveConfigID()", function() return C_ClassTalents.GetActiveConfigID() end)
	Probe("talents", "GetNumTalentTabs()", function() return GetNumTalentTabs() end)
	Probe("talents", "GetTalentTabInfo(1)", function() return GetTalentTabInfo(1) end)

	-- Power and resources.
	Probe("power", "UnitPowerType", function() return UnitPowerType("player") end)
	Probe("power", "Enum.PowerType", function() return Enum.PowerType end)
	for _, p in ipairs({ "Mana", "Rage", "Focus", "Energy", "ComboPoints", "Runes", "RunicPower", "SoulShards", "LunarPower", "HolyPower", "Maelstrom", "Chi", "Insanity", "ArcaneCharges", "Fury", "Essence" }) do
		Probe("power", "UnitPower/Max " .. p, function()
			local e = Enum.PowerType[p]
			if e == nil then return "no enum" end
			return UnitPower("player", e), UnitPowerMax("player", e), UnitPowerMax("player", e, true)
		end)
	end
	Probe("power", "UnitPowerPercent(Mana)", function() return UnitPowerPercent("player", Enum.PowerType.Mana) end)
	Probe("power", "GetPowerRegen", function() return GetPowerRegen() end)
	Probe("power", "GetManaRegen", function() return GetManaRegen() end)
	Probe("power", "GetPowerRegenForPowerType(Mana)", function() return GetPowerRegenForPowerType(Enum.PowerType.Mana) end)
	Probe("power", "GetComboPoints", function() return GetComboPoints("player", "target") end)
	Probe("power", "GetUnitChargedPowerPoints", function() return GetUnitChargedPowerPoints("player") end)
	Probe("power", "UnitHealth/Max", function() return UnitHealth("player"), UnitHealthMax("player") end)

	-- Secret values and combat restrictions.
	Exists("secrets", "issecretvalue")
	Exists("secrets", "canaccessvalue")
	Probe("secrets", "issecretvalue(UnitPower)", function() return issecretvalue(UnitPower("player", Enum.PowerType.Mana)) end)
	Probe("secrets", "issecretvalue(UnitHealth)", function() return issecretvalue(UnitHealth("player")) end)
	Probe("secrets", "InCombatLockdown", function() return InCombatLockdown() end)

	-- Systems the mainline addon touches.
	for _, name in ipairs({
		"C_CooldownViewer.GetCooldownViewerCategorySet", "C_CooldownViewer.GetCooldownViewerCooldownInfo", "CooldownViewerSettings", "EssentialCooldownViewer",
		"C_UnitAuras.GetPlayerAuraBySpellID", "C_UnitAuras.GetAuraDataByAuraInstanceID", "C_UnitAuras.GetBuffDataByIndex",
		"C_Spell.GetSpellInfo", "C_Spell.GetSpellCooldown", "C_Spell.GetSpellCharges", "C_Spell.GetSpellPowerCost", "C_Spell.GetSpellCastCount", "C_Spell.EnableSpellRangeCheck", "C_Spell.GetSpellCooldownDuration", "C_Spell.GetSpellChargeDuration",
		"C_SpellBook.IsSpellKnown", "C_Item.GetItemInfo", "C_Item.GetDetailedItemLevelInfo",
		"C_CurveUtil.CreateColorCurve", "C_CurveUtil.EvaluateColorFromBoolean", "CurveConstants",
		"EditModeManagerFrame", "C_EditMode.GetLayouts", "Settings.RegisterCanvasLayoutSubcategory", "Settings.RegisterCanvasLayoutCategory", "AddonCompartmentFrame",
		"C_PetBattles.IsInBattle", "C_PlayerInfo.GetGlidingInfo", "IsAdvancedFlyableArea", "C_MountJournal.IsDragonridingUnlocked", "UnitInVehicle", "UnitOnTaxi",
		"GetShapeshiftForm", "GetShapeshiftFormID", "GetNumShapeshiftForms", "UPDATE_SHAPESHIFT_FORM",
		"GetMirrorTimerInfo", "GetMirrorTimerProgress", "MirrorTimerContainer",
		"C_EncodingUtil.SerializeJSON", "C_EncodingUtil.CompressString", "C_EncodingUtil.EncodeBase64", "Enum.CompressionMethod",
		"C_ScenarioInfo.GetScenarioInfo", "C_ChallengeMode.IsChallengeModeActive", "AbbreviateNumbers", "UnitPowerPercent",
		"GetCombatRatingBonus", "GetHaste", "GetCritChance", "GetMasteryEffect", "GetVersatilityBonus",
		"C_Timer.After", "hooksecurefunc", "CreateUnsecuredObjectPool", "PlaySoundFile",
	}) do
		Exists("systems", name)
	end
	Probe("systems", "C_CooldownViewer categories", function()
		local out = {}
		for _, cat in ipairs({ Enum.CooldownViewerCategory.Essential, Enum.CooldownViewerCategory.Utility, Enum.CooldownViewerCategory.TrackedBuff, Enum.CooldownViewerCategory.TrackedBar }) do
			local ids = C_CooldownViewer.GetCooldownViewerCategorySet(cat, true)
			out[#out + 1] = tostring(ids and #ids or "nil")
		end
		return table.concat(out, "/")
	end)
	Probe("systems", "GetShapeshiftForm()", function() return GetShapeshiftForm(), GetShapeshiftFormID(), GetNumShapeshiftForms() end)
	Probe("systems", "GetMirrorTimerInfo(1..3)", function() return GetMirrorTimerInfo(1), GetMirrorTimerInfo(2), GetMirrorTimerInfo(3) end)
	Probe("systems", "Settings.RegisterCanvasLayoutCategory type", function() return type(Settings.RegisterCanvasLayoutCategory) end)

	-- Save one entry per character.
	local key = string.format("%s-%s", UnitName("player") or "?", GetRealmName() or "?")
	TRBForeverProbeResults = TRBForeverProbeResults or {}
	TRBForeverProbeResults[key] = results

	-- Print a compact summary.
	print("|cFF00FF00TRB Forever Probe|r results for " .. key .. " (saved to TRBForeverProbeResults; /reload or log out to write the file):")
	local sections = { "client", "character", "talents", "power", "secrets", "systems" }
	for _, section in ipairs(sections) do
		local entries = results[section] or {}
		local keys = {}
		for k in pairs(entries) do keys[#keys + 1] = k end
		table.sort(keys)
		print("|cFFFFFF00[" .. section .. "]|r")
		for _, k in ipairs(keys) do
			print("  " .. k .. " = " .. tostring(entries[k]))
		end
	end
end

SLASH_TRBFOREVERPROBE1 = "/trbprobe"
SlashCmdList["TRBFOREVERPROBE"] = function()
	local ok, err = pcall(Run)
	if not ok then
		print("|cFFFF0000TRB Forever Probe failed:|r " .. tostring(err))
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	print("|cFF00FF00TRB Forever Probe|r loaded. Type /trbprobe to record this client's facts.")
end)
