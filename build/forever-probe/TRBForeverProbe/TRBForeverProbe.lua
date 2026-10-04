---@diagnostic disable: undefined-global, deprecated -- every probe targets APIs that may not exist on this client
-- TRB Forever Probe: a throwaway addon that records what the client exposes so the Forever flavor of
-- Twintop's Resource Bar can be built on facts instead of guesses. Install it alone in the Forever
-- client's AddOns folder, log in on one character per class, and run /trbprobe. Results open in a
-- window whose text can be copied (Ctrl+A, Ctrl+C) and are also saved in TRBForeverProbeResults
-- (WTF\...\SavedVariables\TRBForeverProbe.lua) for when the beta can write saved variables again.
--
-- Nothing here depends on the addon itself. Every probe is wrapped in pcall: an API that is missing or
-- throws is itself a finding.

local addonName = ...
local results = {}

local function IsSecret(v)
	return issecretvalue ~= nil and issecretvalue(v)
end

-- Secrets are reported by type only: tostring/format on one yields a secret string, which table.concat rejects.
local function Value(v)
	if v == nil then return "nil" end
	local t = type(v)
	if IsSecret(v) then return "<secret " .. t .. ">" end
	if t == "boolean" or t == "number" then return tostring(v) end
	if t == "string" then return string.format("%q", v) end
	if t == "table" then
		local parts = {}
		local count = 0
		for k, x in pairs(v) do
			count = count + 1
			if count > 40 then parts[#parts + 1] = "..." break end
			parts[#parts + 1] = (IsSecret(k) and "<secret key>" or tostring(k)) .. "=" .. Value(x)
		end
		return "{" .. table.concat(parts, ", ") .. "}"
	end
	return "<" .. t .. ">"
end

local function Record(section, key, ...)
	local n = select("#", ...)
	while n > 1 and select(n, ...) == nil do n = n - 1 end
	local parts = {}
	for i = 1, n do parts[i] = Value((select(i, ...))) end
	results[section] = results[section] or {}
	results[section][key] = table.concat(parts, ", ")
end

-- Both the call and the recording are protected, so no single probe can end the run.
local function Probe(section, key, fn)
	local ok, a, b, c, d, e, f, g, h = pcall(fn)
	local recorded, err
	if ok then
		recorded, err = pcall(Record, section, key, a, b, c, d, e, f, g, h)
	else
		recorded, err = pcall(Record, section, key, "ERROR: " .. tostring(a))
	end
	if not recorded then
		results[section] = results[section] or {}
		results[section][key] = "RECORD ERROR: " .. tostring(err)
	end
end

---Resolves a dotted global path ("C_Spell.GetSpellInfo") to its value, or nil.
local function Resolve(name)
	local value = _G
	for part in name:gmatch("[^%.]+") do
		if type(value) ~= "table" then return nil end
		value = rawget(value, part) or value[part]
	end
	return value
end

local function Exists(section, name)
	local value = Resolve(name)
	Record(section, name, value ~= nil and type(value) or "MISSING")
end

-- Every global the addon's Core and Forever flavor call (generated from the sources), plus the modern
-- replacements for the deprecated spec API and a few deprecated names as a control group.
local addonGlobals = {
	"AbbreviateNumbers", "BreakUpLargeNumbers", "C_AddOns.GetAddOnMetadata", "C_AddOns.IsAddOnLoaded", "C_ClassColor.GetClassColor", "C_ClassTalents.GetActiveConfigID",
	"C_ClassTalents.GetCombatConfigIDForSpecGroup", "C_CurveUtil.CreateColorCurve", "C_CurveUtil.EvaluateColorFromBoolean", "C_DurationUtil.CreateDuration",
	"C_EncodingUtil.CompressString", "C_EncodingUtil.EncodeBase64", "C_EncodingUtil.SerializeJSON", "C_GameRules.IsGameRuleActive", "C_Item.GetDetailedItemLevelInfo",
	"C_Item.GetItemIconByID", "C_Item.GetItemInfo", "C_PetBattles.IsInBattle", "C_PlayerInfo.GetGlidingInfo", "C_PvP.IsWarModeDesired", "C_ScenarioInfo.GetScenarioInfo",
	"C_Secrets.ShouldUnitSpellCastingBeSecret", "C_SpecializationInfo.GetActiveSpecGroup", "C_SpecializationInfo.GetAllSelectedPvpTalentIDs", "C_SpecializationInfo.GetNumSpecializations",
	"C_SpecializationInfo.GetNumSpecializationsForClassID", "C_SpecializationInfo.GetPvpTalentInfo", "C_SpecializationInfo.GetSpecialization", "C_SpecializationInfo.GetSpecializationInfo",
	"C_SpecializationInfo.GetSpecializationInfoForClassID", "C_SpecializationInfo.GetSpecializationInfoForSpecID", "C_SpecializationInfo.GetSpecializationSystem",
	"C_SpecializationInfo.GetTalentInfo", "C_SpecializationInfo.IsSpecSelectionEnabled", "C_Spell.EnableSpellRangeCheck", "C_Spell.GetSpellCastCount", "C_Spell.GetSpellChargeDuration",
	"C_Spell.GetSpellCharges", "C_Spell.GetSpellCooldown", "C_Spell.GetSpellCooldownDuration", "C_Spell.GetSpellInfo", "C_Spell.GetSpellPowerCost", "C_Spell.GetSpellTexture",
	"C_Spell.IsSpellInRange", "C_Spell.IsSpellUsable", "C_SpellBook.IsSpellKnown", "C_Timer.After", "C_Timer.NewTicker", "C_Timer.NewTimer", "C_Traits.GetConfigInfo",
	"C_Traits.GetConfigsByType", "C_Traits.GetDefinitionInfo", "C_Traits.GetEntryInfo", "C_Traits.GetNodeInfo", "C_Traits.GetTreeNodes", "C_UI.Reload", "C_UnitAuras.GetAuraDataByAuraInstanceID",
	"C_UnitAuras.GetBuffDataByIndex", "C_UnitAuras.GetDebuffDataByIndex", "C_UnitAuras.GetPlayerAuraBySpellID", "C_XMLUtil.GetTemplateInfo", "CombatLogGetCurrentEventInfo",
	"CreateAtlasMarkup", "CreateColor", "CreateFont", "CreateFrame", "FauxScrollFrame_SetOffset", "GetBuildInfo", "GetClassColor", "GetClassInfo", "GetCombatRating",
	"GetCombatRatingBonus", "GetCritChance", "GetInstanceInfo", "GetInventoryItemLink", "GetItemInfo", "GetLocale", "GetMasteryEffect", "GetMaxTalentTier", "GetMirrorTimerInfo",
	"GetMirrorTimerProgress", "GetNetStats", "GetNumUnspentTalents", "GetPvpTalentInfoByID", "GetRealmName", "GetScreenHeight", "GetScreenWidth", "GetSpecialization",
	"GetSpecializationInfoByID", "GetSpecializationInfoForClassID", "GetSpecializationSystem", "GetSpellInfo", "GetTalentInfo", "GetTalentTierInfo", "GetUnitChargedPowerPoints",
	"GetUnitEmpowerHoldAtMaxTime", "GetUnitEmpowerStageDuration", "HasPlayerEarnedATalentPoint", "InCombatLockdown", "IsControlKeyDown", "IsFlying", "IsInGroup",
	"IsInInstance", "IsInRaid", "IsMounted", "IsShiftKeyDown", "IsSpecSelectionEnabled", "LocalizedClassList", "MenuUtil.CreateContextMenu", "PlaySoundFile",
	"SetCursor", "Settings.RegisterAddOnCategory", "Settings.RegisterCanvasLayoutCategory", "StaticPopup_Hide", "StaticPopup_OnClick", "StaticPopup_Show", "UnitAura",
	"UnitCanAttack", "UnitCastingDuration", "UnitCastingInfo", "UnitChannelDuration", "UnitChannelInfo", "UnitClass", "UnitClassBase", "UnitEmpoweredChannelDuration",
	"UnitEmpoweredStagePercentages", "UnitExists", "UnitGUID", "UnitGetIncomingHeals", "UnitGetTotalAbsorbs", "UnitGetTotalHealAbsorbs", "UnitHealth", "UnitHealthMax",
	"UnitHealthPercent", "UnitInVehicle", "UnitIsDeadOrGhost", "UnitIsFriend", "UnitIsPVP", "UnitIsPlayer", "UnitName", "UnitOnTaxi", "UnitPower", "UnitPowerMax",
	"UnitPowerPercent", "UnitRace", "UnitSpellHaste", "UnitStat", "UnitTokenFromGUID",
}

local copyFrame

---Shows the results in a movable window with a selectable, copyable edit box.
---@param text string
local function ShowResults(text)
	if copyFrame == nil then
		copyFrame = CreateFrame("Frame", "TRBForeverProbeFrame", UIParent, "BackdropTemplate")
		copyFrame:SetSize(760, 520)
		copyFrame:SetPoint("CENTER")
		copyFrame:SetFrameStrata("DIALOG")
		copyFrame:SetMovable(true)
		copyFrame:EnableMouse(true)
		copyFrame:RegisterForDrag("LeftButton")
		copyFrame:SetScript("OnDragStart", copyFrame.StartMoving)
		copyFrame:SetScript("OnDragStop", copyFrame.StopMovingOrSizing)
		copyFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		local title = copyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		title:SetPoint("TOP", 0, -18)
		title:SetText("TRB Forever Probe: Ctrl+A, Ctrl+C, then paste the text back")
		local close = CreateFrame("Button", nil, copyFrame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", -6, -6)
		local scroll = CreateFrame("ScrollFrame", nil, copyFrame, "UIPanelScrollFrameTemplate")
		scroll:SetPoint("TOPLEFT", 22, -44)
		scroll:SetPoint("BOTTOMRIGHT", -44, 22)
		local editBox = CreateFrame("EditBox", nil, scroll)
		editBox:SetMultiLine(true)
		editBox:SetAutoFocus(false)
		editBox:SetFontObject(ChatFontNormal)
		editBox:SetWidth(680)
		editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
		scroll:SetScrollChild(editBox)
		copyFrame.editBox = editBox
	end
	copyFrame.editBox:SetText(text)
	copyFrame:Show()
	copyFrame.editBox:SetFocus()
	copyFrame.editBox:HighlightText()
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
	Probe("client", "GetSpecializationSystem()", function() return GetSpecializationSystem() end)
	Probe("client", "C_SpecializationInfo.GetSpecializationSystem()", function() return C_SpecializationInfo.GetSpecializationSystem() end)
	Probe("client", "Enum.SpecializationSystem", function() return Enum.SpecializationSystem end)
	Probe("client", "Enum.TraitConfigType", function() return Enum.TraitConfigType end)
	for _, rule in ipairs({ "HardcoreRuleset", "PvPRuleset", "RPRuleset", "SelfFoundAllowed", "NoDebuffLimit" }) do
		Probe("client", "IsGameRuleActive " .. rule, function() return Enum.GameRule[rule], C_GameRules.IsGameRuleActive(Enum.GameRule[rule]) end)
	end
	Probe("client", "GetGameRuleAsFloat VanillaRageGenerationModifier", function() return C_GameRules.GetGameRuleAsFloat(Enum.GameRule.VanillaRageGenerationModifier) end)
	Probe("client", "GetCVar loadDeprecationFallbacks", function() return GetCVar("loadDeprecationFallbacks") end)
	Probe("client", "GetAddOnInfo Blizzard_Deprecated", function() return C_AddOns.GetAddOnInfo("Blizzard_Deprecated") end)
	Probe("client", "GetRealmName", function() return GetRealmName() end)
	Probe("client", "GetNormalizedRealmName", function() return GetNormalizedRealmName() end)
	Probe("client", "UnitName player", function() return UnitName("player") end)
	Probe("client", "UnitFullName player", function() return UnitFullName("player") end)
	Probe("client", "UnitName target", function() return UnitName("target") end)

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
	Probe("character", "GetSpecializationInfoForClassID(1..13)", function()
		local out = {}
		for c = 1, 13 do
			local specs = {}
			for i = 1, 4 do
				local id, name = GetSpecializationInfoForClassID(c, i)
				if id ~= nil then specs[#specs + 1] = tostring(id) .. " " .. tostring(name) end
			end
			out[#out + 1] = c .. ":[" .. table.concat(specs, ", ") .. "]"
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
	Exists("talents", "C_SpecializationInfo.GetSpecialization")
	Exists("talents", "C_SpecializationInfo.GetSpecializationInfo")
	Exists("talents", "C_SpecializationInfo.GetNumTalentTabs")
	Exists("talents", "C_SpecializationInfo.GetTalentTabInfo")
	Exists("talents", "C_SpecializationInfo.GetTalentInfo")
	Probe("talents", "C_ClassTalents.GetActiveConfigID()", function() return C_ClassTalents.GetActiveConfigID() end)
	Probe("talents", "C_Traits.GetConfigInfo(active)", function()
		local configId = C_ClassTalents.GetActiveConfigID()
		if configId == nil then return "no active config" end
		local info = C_Traits.GetConfigInfo(configId)
		if info == nil then return "nil config info" end
		local trees = {}
		for _, treeId in ipairs(info.treeIDs or {}) do
			local nodes = C_Traits.GetTreeNodes(treeId)
			trees[#trees + 1] = tostring(treeId) .. ":" .. tostring(nodes and #nodes or "nil")
		end
		return info.type, info.name, table.concat(trees, " ")
	end)
	Probe("talents", "C_Traits.GetNodeInfo(first node)", function()
		local configId = C_ClassTalents.GetActiveConfigID()
		local info = configId and C_Traits.GetConfigInfo(configId)
		local treeId = info and info.treeIDs and info.treeIDs[1]
		local nodes = treeId and C_Traits.GetTreeNodes(treeId)
		if not nodes or #nodes == 0 then return "no nodes" end
		local node = C_Traits.GetNodeInfo(configId, nodes[1])
		local entryId = node and (node.activeEntry and node.activeEntry.entryID or node.entryIDs and node.entryIDs[1])
		local entry = entryId and C_Traits.GetEntryInfo(configId, entryId)
		local definition = entry and C_Traits.GetDefinitionInfo(entry.definitionID)
		return node and node.ID, node and node.maxRanks, node and node.currentRank, entryId, definition and definition.spellID
	end)
	Probe("talents", "GetNumTalentTabs()", function() return GetNumTalentTabs() end)
	Probe("talents", "GetTalentTabInfo(1)", function() return GetTalentTabInfo(1) end)
	Probe("talents", "C_SpecializationInfo.GetSpecialization()", function() return C_SpecializationInfo.GetSpecialization() end)
	Probe("talents", "C_SpecializationInfo.GetNumSpecializations()", function() return C_SpecializationInfo.GetNumSpecializations() end)
	Probe("talents", "C_SpecializationInfo.GetSpecializationInfo(1..3)", function()
		local out = {}
		for i = 1, 3 do out[i] = Value({ C_SpecializationInfo.GetSpecializationInfo(i) }) end
		return table.concat(out, " | ")
	end)
	Probe("talents", "C_SpecializationInfo.GetActiveSpecGroup()", function() return C_SpecializationInfo.GetActiveSpecGroup() end)
	Probe("talents", "IsSpecSelectionEnabled()", function() return IsSpecSelectionEnabled() end)
	Probe("talents", "C_SpecializationInfo.IsSpecSelectionEnabled()", function() return C_SpecializationInfo.IsSpecSelectionEnabled() end)
	Probe("talents", "C_ClassTalents.GetCombatConfigIDForSpecGroup(1)", function() return C_ClassTalents.GetCombatConfigIDForSpecGroup(1) end)
	Probe("talents", "C_Traits.GetConfigsByType(CamelotCombat)", function() return C_Traits.GetConfigsByType(Enum.TraitConfigType.CamelotCombat) end)
	Probe("talents", "GetMaxTalentTier()", function() return GetMaxTalentTier() end)
	Probe("talents", "HasPlayerEarnedATalentPoint()", function() return HasPlayerEarnedATalentPoint() end)
	Probe("talents", "GetNumUnspentTalents()", function() return GetNumUnspentTalents() end)
	Probe("talents", "GetTalentInfo(1, 1)", function() return GetTalentInfo(1, 1) end)
	Probe("talents", "GetTalentTierInfo(1, 1)", function() return GetTalentTierInfo(1, 1) end)
	Probe("talents", "C_SpecializationInfo.GetTalentInfo({tier=1,column=1})", function() return C_SpecializationInfo.GetTalentInfo({ tier = 1, column = 1 }) end)

	-- Shape of every trait config we can reach: the active one and the Forever combat config.
	local function SummarizeConfig(configId)
		if configId == nil then return "no config id" end
		local info = C_Traits.GetConfigInfo(configId)
		if info == nil then return "nil config info" end
		local trees = {}
		for _, treeId in ipairs(info.treeIDs or {}) do
			local nodes = C_Traits.GetTreeNodes(treeId) or {}
			local spent, max, spells = 0, 0, {}
			for i, nodeId in ipairs(nodes) do
				local node = C_Traits.GetNodeInfo(configId, nodeId)
				if node then
					spent = spent + (node.currentRank or 0)
					max = max + (node.maxRanks or 0)
					if i <= 3 then
						local entryId = node.activeEntry and node.activeEntry.entryID or node.entryIDs and node.entryIDs[1]
						local entry = entryId and C_Traits.GetEntryInfo(configId, entryId)
						local definition = entry and C_Traits.GetDefinitionInfo(entry.definitionID)
						spells[#spells + 1] = tostring(definition and definition.spellID)
					end
				end
			end
			trees[#trees + 1] = string.format("tree %s: %d nodes, %d/%d ranks, first spells %s", tostring(treeId), #nodes, spent, max, table.concat(spells, "/"))
		end
		return string.format("type=%s name=%s %s", tostring(info.type), tostring(info.name), table.concat(trees, "; "))
	end
	Probe("talents", "config summary: active", function() return SummarizeConfig(C_ClassTalents.GetActiveConfigID()) end)
	Probe("talents", "config summary: combat group 1", function() return SummarizeConfig(C_ClassTalents.GetCombatConfigIDForSpecGroup(1)) end)
	Probe("talents", "config summary: first CamelotCombat", function()
		local ids = C_Traits.GetConfigsByType(Enum.TraitConfigType.CamelotCombat)
		return SummarizeConfig(ids and ids[1])
	end)
	Probe("talents", "tree layout: subTrees, posX range, node types", function()
		local configId = C_ClassTalents.GetActiveConfigID()
		local info = configId and C_Traits.GetConfigInfo(configId)
		local treeId = info and info.treeIDs and info.treeIDs[1]
		if treeId == nil then return "no tree" end
		local subTrees, types, minX, maxX, minY, maxY = {}, {}, math.huge, -math.huge, math.huge, -math.huge
		for _, nodeId in ipairs(C_Traits.GetTreeNodes(treeId) or {}) do
			local node = C_Traits.GetNodeInfo(configId, nodeId)
			if node then
				subTrees[tostring(node.subTreeID)] = (subTrees[tostring(node.subTreeID)] or 0) + 1
				types[tostring(node.type)] = (types[tostring(node.type)] or 0) + 1
				minX, maxX = math.min(minX, node.posX or 0), math.max(maxX, node.posX or 0)
				minY, maxY = math.min(minY, node.posY or 0), math.max(maxY, node.posY or 0)
			end
		end
		local treeInfo = C_Traits.GetTreeInfo(configId, treeId)
		return Value(subTrees), Value(types), minX, maxX, minY, maxY, Value(treeInfo), Value(C_Traits.GetTreeCurrencyInfo(configId, treeId, true))
	end)

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

	-- Spell ranks and shapeshift forms (Druid): which "known" API sees ranks, what each rank costs, and the form ids.
	local rankedSpells = {
		{ name = "Healing Touch", ids = { 5185, 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297 } },
		{ name = "Rejuvenation", ids = { 774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299 } },
		{ name = "Maul", ids = { 6807, 6808, 6809, 8972, 9745, 9880, 9881 } },
		{ name = "Demoralizing Roar", ids = { 99, 1735, 9490, 9747, 9898 } },
		{ name = "Claw", ids = { 1082, 3029, 5201, 9849, 9850 } },
		{ name = "Rip", ids = { 1079, 9492, 9493, 9752, 9894, 9896 } },
	}
	for _, ranked in ipairs(rankedSpells) do
		Probe("spellranks", ranked.name .. " IsSpellKnown/IsPlayerSpell per rank", function()
			local out = {}
			for i, id in ipairs(ranked.ids) do
				out[i] = id .. ":" .. Value(C_SpellBook.IsSpellKnown(id)) .. "/" .. Value(IsPlayerSpell(id))
			end
			return table.concat(out, " ")
		end)
		Probe("spellranks", ranked.name .. " GetSpellPowerCost per rank", function()
			local out = {}
			for i, id in ipairs(ranked.ids) do
				out[i] = id .. ":" .. Value(C_Spell.GetSpellPowerCost(id))
			end
			return table.concat(out, " ")
		end)
		Probe("spellranks", ranked.name .. " GetSpellInfo by name", function() return C_Spell.GetSpellInfo(ranked.name) end)
		Probe("spellranks", ranked.name .. " GetSpellInfo rank 1 / subtext", function() return C_Spell.GetSpellInfo(ranked.ids[1]), C_Spell.GetSpellSubtext(ranked.ids[1]) end)
	end
	Exists("spellranks", "IsPlayerSpell")
	Exists("spellranks", "C_Spell.GetSpellSubtext")
	Exists("spellranks", "C_SpellBook.FindSpellBookSlotForSpell")
	Exists("spellranks", "SPELLS_CHANGED")
	Probe("spellranks", "GetShapeshiftFormID/GetShapeshiftForm (current form)", function() return GetShapeshiftFormID(), GetShapeshiftForm(), GetNumShapeshiftForms() end)
	Probe("spellranks", "GetShapeshiftFormInfo(1..6)", function()
		local out = {}
		for i = 1, 6 do out[i] = Value({ GetShapeshiftFormInfo(i) }) end
		return table.concat(out, " | ")
	end)
	for _, name in ipairs({ "CAT_FORM", "BEAR_FORM", "DIRE_BEAR_FORM", "TRAVEL_FORM", "AQUATIC_FORM", "MOONKIN_FORM", "TREE_OF_LIFE_FORM" }) do
		Probe("spellranks", "global " .. name, function() return _G[name] end)
	end

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

	-- Character-sheet stats (the APIs Blizzard's Camelot PaperDollFrame calls), every return value, secret or not.
	Probe("stats", "UnitStat 1..5 (str agi stam int spi)", function()
		local out = {}
		for i = 1, 5 do out[i] = Value({ UnitStat("player", i) }) end
		return table.concat(out, " | ")
	end)
	Probe("stats", "UnitDefenseSkill", function() return UnitDefenseSkill("player") end)
	Probe("stats", "GetDodgeChance/Parry/Block/ShieldBlock", function() return GetDodgeChance(), GetParryChance(), GetBlockChance(), GetShieldBlock() end)
	Probe("stats", "UnitArmor", function() return UnitArmor("player") end)
	for _, school in ipairs({ "Holy", "Fire", "Nature", "Frost", "Shadow", "Arcane" }) do
		Probe("stats", "UnitResistance " .. school, function() return Enum.Damageclass[school], UnitResistance("player", Enum.Damageclass[school]) end)
	end
	Probe("stats", "GetHitModifier/Ranged/Spell", function() return GetHitModifier(), GetRangedHitModifier(), GetSpellHitModifier() end)
	Probe("stats", "GetCombatRatingBonus CR_HIT_MELEE/RANGED/SPELL", function() return CR_HIT_MELEE, GetCombatRatingBonus(CR_HIT_MELEE), GetCombatRatingBonus(CR_HIT_RANGED), GetCombatRatingBonus(CR_HIT_SPELL) end)
	Probe("stats", "GetCritChance/Ranged/Spell", function() return GetCritChance(), GetRangedCritChance(), GetSpellCritChance() end)
	Probe("stats", "GetSpellCritChance(school 2..7)", function()
		local out = {}
		for i = 2, 7 do out[#out + 1] = Value(GetSpellCritChance(i)) end
		return table.concat(out, " ")
	end)
	Probe("stats", "UnitSpellHaste/GetMeleeHaste/GetRangedHaste", function() return UnitSpellHaste("player"), GetMeleeHaste(), GetRangedHaste() end)
	Probe("stats", "GetExpertise", function() return GetExpertise() end)
	Probe("stats", "GetArmorPenetration", function() return GetArmorPenetration() end)
	Probe("stats", "GetSpellBonusDamage(2..7)", function()
		local out = {}
		for i = 2, 7 do out[#out + 1] = Value(GetSpellBonusDamage(i)) end
		return table.concat(out, " ")
	end)
	Probe("stats", "GetSpellBonusHealing", function() return GetSpellBonusHealing() end)
	Probe("stats", "GetSpellPenetration", function() return GetSpellPenetration() end)
	Probe("stats", "UnitAttackPower/UnitRangedAttackPower", function() return Value({ UnitAttackPower("player") }), Value({ UnitRangedAttackPower("player") }) end)
	Probe("stats", "GetManaRegen", function() return GetManaRegen() end)
	Probe("stats", "GetMasteryEffect/GetVersatilityBonus(1)", function() return GetMasteryEffect(), GetVersatilityBonus(1) end)
	Probe("stats", "GetCombatRating 11/20/26/29", function() return GetCombatRating(11), GetCombatRating(20), GetCombatRating(26), GetCombatRating(29) end)
	Probe("stats", "LE_UNIT_STAT_SPIRIT", function() return LE_UNIT_STAT_SPIRIT end)

	-- Which of the addon's globals this client lacks.
	local missing = {}
	for _, name in ipairs(addonGlobals) do
		if Resolve(name) == nil then missing[#missing + 1] = name end
	end
	Record("globals", string.format("missing %d of %d", #missing, #addonGlobals), table.concat(missing, ", "))

	-- Save one entry per character.
	local function Plain(v) return IsSecret(v) and "<secret>" or tostring(v or "?") end
	local key = Plain(UnitName("player")) .. "-" .. Plain(GetRealmName())
	TRBForeverProbeResults = TRBForeverProbeResults or {}
	TRBForeverProbeResults[key] = results

	-- Everything goes to the copy window; chat only gets the client section as a sanity check.
	local lines = { "TRB Forever Probe " .. results.probedAt .. " " .. key }
	local sections = { "client", "character", "talents", "power", "spellranks", "secrets", "systems", "stats", "globals" }
	for _, section in ipairs(sections) do
		local entries = results[section] or {}
		local keys = {}
		for k in pairs(entries) do keys[#keys + 1] = k end
		table.sort(keys)
		lines[#lines + 1] = "[" .. section .. "]"
		for _, k in ipairs(keys) do
			lines[#lines + 1] = "  " .. k .. " = " .. tostring(entries[k])
			if section == "client" then
				print("  " .. k .. " = " .. tostring(entries[k]))
			end
		end
	end
	print("|cFF00FF00TRB Forever Probe|r results for " .. key .. ": press Ctrl+A then Ctrl+C in the window, then paste the text back.")
	ShowResults(table.concat(lines, "\n"))
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
