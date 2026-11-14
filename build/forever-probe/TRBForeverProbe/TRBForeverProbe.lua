---@diagnostic disable: undefined-global, deprecated -- every probe targets APIs that may not exist on this client
-- TRB Forever Probe: a throwaway addon that records what the client exposes so the Forever, Classic, and TBC flavors
-- of Twintop's Resource Bar can be built on facts instead of guesses. Install it alone in the Forever, Classic, or TBC
-- client's AddOns folder, log in on one character per class, and run /trbprobe. Results open in a
-- window whose text can be copied (Ctrl+A, Ctrl+C) and are also saved in TRBForeverProbeResults
-- (WTF\...\SavedVariables\TRBForeverProbe.lua) for when the beta can write saved variables again.
--
-- The toggled logs answer one tracking question each (each also runs on the live client): /trbprobe hits compares a
-- charge buff's count across a fight with the hits taken, /trbprobe swings tallies swings against the target's results,
-- /trbprobe auras lists which stack auras the client keeps secret, /trbprobe crits pairs each cast with its result on the
-- target, /trbprobe mana shows what a resource gain looks like, and /trbprobe casttime <spell id> lists every cast time and cost a spell reports.
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
	-- Classic Era's Hardcore and Season of Discovery realms run on the same client; the season tells them apart.
	Probe("client", "C_Seasons.GetActiveSeason", function() return C_Seasons.GetActiveSeason(), C_Seasons.HasActiveSeason() end)
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
	---@diagnostic disable-next-line: undefined-field -- Forever-only enum member
	Probe("talents", "C_Traits.GetConfigsByType(CamelotCombat)", function() return C_Traits.GetConfigsByType(Enum.TraitConfigType.CamelotCombat) end)
	Probe("talents", "GetMaxTalentTier()", function() return GetMaxTalentTier() end)
	Probe("talents", "HasPlayerEarnedATalentPoint()", function() return HasPlayerEarnedATalentPoint() end)
	Probe("talents", "GetNumUnspentTalents()", function() return GetNumUnspentTalents() end)
	---@diagnostic disable-next-line: missing-parameter -- probes the Vanilla two-argument form
	Probe("talents", "GetTalentInfo(1, 1)", function() return GetTalentInfo(1, 1) end)
	Probe("talents", "GetTalentTierInfo(1, 1)", function() return GetTalentTierInfo(1, 1) end)
	Probe("talents", "C_SpecializationInfo.GetTalentInfo({tier=1,column=1})", function() return C_SpecializationInfo.GetTalentInfo({ tier = 1, column = 1 }) end)
	-- Classic's talent tabs: the query shape Blizzard's Vanilla talent frame uses, and which rank's spell each learned talent reports.
	Probe("talents", "GetNumTalents(1..3)", function() return GetNumTalents(1), GetNumTalents(2), GetNumTalents(3) end)
	Probe("talents", "C_SpecializationInfo.GetTalentInfo({specializationIndex=1,talentIndex=1})", function() return C_SpecializationInfo.GetTalentInfo({ specializationIndex = 1, talentIndex = 1 }) end)
	Probe("talents", "learned talents (tab.index spellID rank/maxRank)", function()
		local parts = {}
		for tab = 1, GetNumTalentTabs() do
			for index = 1, GetNumTalents(tab) do
				local info = C_SpecializationInfo.GetTalentInfo({ specializationIndex = tab, talentIndex = index })
				if info ~= nil and info.rank > 0 then
					parts[#parts + 1] = string.format("%d.%d %s %d/%d", tab, index, tostring(info.spellID), info.rank, info.maxRank)
				end
			end
		end
		return #parts > 0 and table.concat(parts, ", ") or "none learned"
	end)

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
		---@diagnostic disable-next-line: undefined-field -- Forever-only enum member
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
	-- The Rogue and Warrior attacks are known at level 1, so a new character of either class shows a known rank 1.
	local rankedSpells = {
		{ name = "Sinister Strike", ids = { 1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294 } },
		{ name = "Eviscerate", ids = { 2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016 } },
		{ name = "Heroic Strike", ids = { 78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286 } },
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
	Probe("systems", "C_EventUtils.IsEventValid (events Core gates)", function()
		local parts = {}
		for _, event in ipairs({ "PLAYER_SWING", "PLAYER_SWING_RANGE_UPDATE", "UNIT_POWER_POINT_CHARGE", "PLAYER_MAP_CHANGED", "PLAYER_IS_GLIDING_CHANGED" }) do
			parts[#parts + 1] = event .. "=" .. tostring(C_EventUtils.IsEventValid(event))
		end
		return table.concat(parts, " ")
	end)
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
		---@diagnostic disable-next-line: redundant-parameter -- probes whether a school argument is honored
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

	-- Swing timers: the API Blizzard_SwingTimer is built on, and the weapon reads the swing bars gate on.
	Exists("swing", "C_SwingTimer.EnableRangeCheck")
	Exists("swing", "C_SwingTimer.IsTargetWithinSwingRange")
	Probe("swing", "Enum.PlayerSwingType", function() return Enum.PlayerSwingType end)
	Probe("swing", "Enum.ItemClass.Weapon", function() return Enum.ItemClass.Weapon end)
	Probe("swing", "IsAddOnLoaded Blizzard_SwingTimer", function() return C_AddOns.IsAddOnLoaded("Blizzard_SwingTimer") end)
	Probe("swing", "GetCVar showSwingTimer", function() return GetCVar("showSwingTimer") end)
	Probe("swing", "UnitAttackSpeed (main, off, ranged)", function() return UnitAttackSpeed("player") end)
	Probe("swing", "UnitRangedDamage", function() return UnitRangedDamage("player") end)
	Probe("swing", "INVSLOT_MAINHAND/OFFHAND/RANGED", function() return INVSLOT_MAINHAND, INVSLOT_OFFHAND, INVSLOT_RANGED end)
	for _, slot in ipairs({ 16, 17, 18 }) do
		Probe("swing", "slot " .. slot .. " itemID + GetItemInfoInstant", function()
			local itemId = GetInventoryItemID("player", slot)
			if itemId == nil then return "empty" end
			return itemId, C_Item.GetItemInfoInstant(itemId)
		end)
	end
	for _, name in ipairs({ "SwingTimerMainHandFrame", "SwingTimerOffHandFrame", "SwingTimerRangedFrame", "SwingTimerManagerFrame" }) do
		Probe("swing", name .. " shown/visible/parent/protected", function()
			local frame = _G[name]
			if frame == nil then return "MISSING" end
			local parent = frame:GetParent()
			return frame:IsShown(), frame:IsVisible(), parent and (parent:GetName() or "<anonymous>"), frame:IsProtected()
		end)
	end

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
	local sections = { "client", "character", "talents", "power", "spellranks", "secrets", "systems", "stats", "swing", "globals" }
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

-- /trbprobe swing: logs every swing-related event with its timestamp until run again, then opens the log.
local swingLogEvents = {
	"PLAYER_SWING", "PLAYER_SWING_RANGE_UPDATE", "WEAPON_SLOT_CHANGED", "PLAYER_EQUIPMENT_CHANGED", "UNIT_ATTACK_SPEED",
	"PLAYER_ENTER_COMBAT", "PLAYER_LEAVE_COMBAT", "START_AUTOREPEAT_SPELL", "STOP_AUTOREPEAT_SPELL", "UNIT_SPELLCAST_SUCCEEDED",
}
local swingLogFrame = CreateFrame("Frame")
local swingLog = nil

swingLogFrame:SetScript("OnEvent", function(_, event, ...)
	local parts = {}
	for i = 1, select("#", ...) do
		parts[i] = Value((select(i, ...)))
	end
	local line = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
	if event == "PLAYER_SWING" or event == "WEAPON_SLOT_CHANGED" or event == "UNIT_ATTACK_SPEED" then
		local ok, main, off, ranged = pcall(UnitAttackSpeed, "player")
		line = line .. (ok and (" UnitAttackSpeed=" .. Value(main) .. ", " .. Value(off) .. ", " .. Value(ranged)) or (" UnitAttackSpeed ERROR: " .. tostring(main)))
	end
	swingLog[#swingLog + 1] = line
	print("|cFF00FF00TRB Probe|r " .. line)
end)

local function ToggleSwingLog()
	if swingLog == nil then
		swingLog = { "TRB Forever Probe swing log " .. date("%Y-%m-%d %H:%M:%S") }
		for _, event in ipairs(swingLogEvents) do
			local ok, err
			if event == "UNIT_ATTACK_SPEED" or event == "UNIT_SPELLCAST_SUCCEEDED" then
				ok, err = pcall(swingLogFrame.RegisterUnitEvent, swingLogFrame, event, "player")
			else
				ok, err = pcall(swingLogFrame.RegisterEvent, swingLogFrame, event)
			end
			if not ok then
				swingLog[#swingLog + 1] = "RegisterEvent " .. event .. " ERROR: " .. tostring(err)
			end
		end
		print("|cFF00FF00TRB Forever Probe|r swing log ON: auto attack a target (dual wield and a ranged weapon or wand if you can), use an on-next-swing ability, swap a weapon, then type /trbprobe swing again.")
	else
		swingLogFrame:UnregisterAllEvents()
		local text = table.concat(swingLog, "\n")
		swingLog = nil
		print("|cFF00FF00TRB Forever Probe|r swing log OFF: press Ctrl+A then Ctrl+C in the window, then paste the text back.")
		ShowResults(text)
	end
end

-- Shared by the toggled logs below: the full log goes to the copy window, chat gets only the summaries.
local function Chat(text)
	print("|cFF00FF00TRB Probe|r " .. text)
end

local function CanReadAuras()
	-- A client that restricts auras says when; one with no such check reads them anytime.
	if C_Secrets ~= nil and C_Secrets.ShouldAurasBeSecret ~= nil then
		return not C_Secrets.ShouldAurasBeSecret()
	end
	return true
end

---Sorted "key xN" pairs of a tally table.
local function TallyText(tally)
	local keys = {}
	for k in pairs(tally) do keys[#keys + 1] = k end
	table.sort(keys)
	for i, k in ipairs(keys) do keys[i] = k .. " x" .. tally[k] end
	return #keys > 0 and table.concat(keys, ", ") or "none"
end

local function SpellName(spellId)
	local ok, info = pcall(C_Spell.GetSpellInfo, spellId)
	return ok and info ~= nil and info.name or "?"
end

-- /trbprobe hits: per fight, each charge buff's count before and after against a tally of the hits taken.
local chargeBuffs = {
	{ name = "Lightning Shield", ids = { 324, 325, 905, 945, 8134, 10431, 10432 } },
	{ name = "Water Shield", ids = { 408510 } },
	{ name = "Shadowguard", ids = { 18137, 19308, 19309, 19310, 19311, 19312 } },
	{ name = "Elune's Grace", ids = { 2651 } },
	{ name = "Inner Fire", ids = { 588, 7128, 602, 1006, 10951, 10952 } },
	{ name = "Shield Block", ids = { 2565 } },
	{ name = "Holy Shield", ids = { 20925, 20927, 20928, 1239570 } },
	{ name = "Redoubt", ids = { 20128 } },
	{ name = "Sweeping Strikes", ids = { 12292 } },
	{ name = "Reckless Swings", ids = { 1329555 } },
	{ name = "Flurry", ids = { 16257, 12966 } },
}
local hitsFrame = CreateFrame("Frame")
local hitsLog = nil
local hitsState = nil

---Each tracked buff the player has, as name -> charges; nil when auras can't be read right now.
local function ReadChargeBuffs()
	if not CanReadAuras() then
		return nil
	end
	local found = {}
	for _, buff in ipairs(chargeBuffs) do
		for _, id in ipairs(buff.ids) do
			local ok, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, id)
			if ok and aura ~= nil and not IsSecret(aura.applications) then
				local charges = aura.charges
				found[buff.name] = (aura.applications or 0) > 0 and aura.applications or ((charges ~= nil and not IsSecret(charges)) and charges or 0)
				break
			end
		end
	end
	return found
end

local function ChargeText(found)
	if found == nil then return "unreadable" end
	local parts = {}
	for _, buff in ipairs(chargeBuffs) do
		if found[buff.name] ~= nil then parts[#parts + 1] = buff.name .. " " .. found[buff.name] end
	end
	return #parts > 0 and table.concat(parts, ", ") or "no charge buff"
end

local function EndHitsFight()
	local state = hitsState
	if state == nil or state.fightStart == nil then return end
	local after = ReadChargeBuffs()
	local parts = {}
	for _, buff in ipairs(chargeBuffs) do
		local before = state.before ~= nil and state.before[buff.name] or nil
		local now = after ~= nil and after[buff.name] or nil
		if before ~= nil or now ~= nil then
			parts[#parts + 1] = string.format("%s %s -> %s%s", buff.name, tostring(before or 0), after == nil and "?" or tostring(now or 0),
				(state.recasts[buff.name] or 0) > 0 and (" (recast x" .. state.recasts[buff.name] .. ")") or "")
		end
	end
	local line = string.format("fight %.1fs: %s | taken: %s | wound times: %s | other casts: %s", GetTime() - state.fightStart,
		#parts > 0 and table.concat(parts, "; ") or "no charge buff", TallyText(state.taken),
		#state.woundTimes > 0 and table.concat(state.woundTimes, " ") or "none", TallyText(state.casts))
	hitsLog[#hitsLog + 1] = line
	Chat(line)
	state.fightStart = nil
	state.before = after
end

hitsFrame:SetScript("OnEvent", function(_, event, unit, a, b, _, d)
	local state = hitsState
	if state == nil then return end
	if event == "PLAYER_REGEN_DISABLED" then
		state.fightStart, state.taken, state.casts, state.recasts, state.woundTimes = GetTime(), {}, {}, {}, {}
	elseif event == "PLAYER_REGEN_ENABLED" then
		C_Timer.After(0.5, EndHitsFight)
	elseif event == "UNIT_COMBAT" then
		if state.fightStart == nil or IsSecret(a) or IsSecret(b) or IsSecret(d) then return end
		local physical = d == 1
		local key = a .. (b ~= "" and ("/" .. b) or "") .. (physical and "" or " magic")
		state.taken[key] = (state.taken[key] or 0) + 1
		local elapsed = string.format("+%.1f", GetTime() - state.fightStart)
		if a == "WOUND" then state.woundTimes[#state.woundTimes + 1] = elapsed end
		hitsLog[#hitsLog + 1] = string.format("  %s %s", elapsed, key)
		-- Where the buff reads in combat, each hit shows the charges it left.
		if CanReadAuras() then
			C_Timer.After(0.1, function()
				if hitsLog ~= nil and CanReadAuras() then hitsLog[#hitsLog + 1] = string.format("    after %s %s: %s", elapsed, key, ChargeText(ReadChargeBuffs())) end
			end)
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spellId = b
		if IsSecret(spellId) or spellId == nil then return end
		local tracked = nil
		for _, buff in ipairs(chargeBuffs) do
			if tContains(buff.ids, spellId) then tracked = buff.name end
		end
		if state.fightStart == nil then
			-- A buff cast before the pull: read what it gave once the aura is up.
			C_Timer.After(0.3, function()
				if hitsState ~= nil and hitsState.fightStart == nil then
					local found = ReadChargeBuffs()
					if found ~= nil then hitsState.before = found end
				end
			end)
		elseif tracked ~= nil then
			state.recasts[tracked] = (state.recasts[tracked] or 0) + 1
			hitsLog[#hitsLog + 1] = string.format("  +%.1f recast %s", GetTime() - state.fightStart, tracked)
		else
			local key = spellId .. " " .. SpellName(spellId)
			state.casts[key] = (state.casts[key] or 0) + 1
			hitsLog[#hitsLog + 1] = string.format("  +%.1f cast %s", GetTime() - state.fightStart, key)
		end
	end
end)

local function ToggleHitsLog()
	if hitsLog == nil then
		hitsLog = { "TRB Forever Probe hits log " .. date("%Y-%m-%d %H:%M:%S") }
		hitsState = { before = ReadChargeBuffs(), taken = {}, casts = {}, recasts = {}, woundTimes = {} }
		hitsFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		hitsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		hitsFrame:RegisterUnitEvent("UNIT_COMBAT", "player")
		hitsFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		hitsLog[#hitsLog + 1] = "start: " .. ChargeText(hitsState.before)
		Chat("hits log ON (" .. ChargeText(hitsState.before) .. "). Buff up out of combat, pull one enemy, take only 1 to 3 hits, kill it, and wait for the fight line. Repeat a few times (with a shield equipped for blocks), then /trbprobe hits again.")
	else
		hitsFrame:UnregisterAllEvents()
		local text = table.concat(hitsLog, "\n")
		hitsLog, hitsState = nil, nil
		Chat("hits log OFF: press Ctrl+A then Ctrl+C in the window, then paste the text back.")
		ShowResults(text)
	end
end

-- /trbprobe swings: whether PLAYER_SWING fires for misses, and whether the target's results show the player's crits.
local swingsFrame = CreateFrame("Frame")
local swingsLog = nil
local swingsTally = nil

swingsFrame:SetScript("OnEvent", function(_, event, a, b, c, _, e)
	if swingsLog == nil or swingsTally == nil then return end
	local key
	if event == "PLAYER_SWING" then
		key = "PLAYER_SWING type " .. Value(b)
	elseif event == "UNIT_COMBAT" then
		if IsSecret(b) or IsSecret(c) then return end
		key = "target " .. b .. (c ~= "" and ("/" .. c) or "") .. ((IsSecret(e) or e == 1) and "" or " magic")
	else
		if IsSecret(c) or c == nil then return end
		key = "cast " .. c .. " " .. SpellName(c)
	end
	swingsTally[key] = (swingsTally[key] or 0) + 1
	swingsLog[#swingsLog + 1] = string.format("%.3f %s", GetTime(), key)
end)

local function ToggleSwingsLog()
	if swingsLog == nil then
		swingsLog = { "TRB Forever Probe swings log " .. date("%Y-%m-%d %H:%M:%S") }
		swingsTally = {}
		local ok = pcall(swingsFrame.RegisterEvent, swingsFrame, "PLAYER_SWING")
		swingsFrame:RegisterUnitEvent("UNIT_COMBAT", "target")
		swingsFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		swingsLog[#swingsLog + 1] = "PLAYER_SWING registered: " .. tostring(ok)
		Chat("swings log ON" .. (ok and "" or " (this client has no PLAYER_SWING)") .. ". Solo, with no pet or damage over time effect on the target, auto attack one enemy for a minute or more, with some special attacks, then /trbprobe swings again.")
	else
		swingsFrame:UnregisterAllEvents()
		local summary = "swings: " .. TallyText(swingsTally)
		swingsLog[#swingsLog + 1] = summary
		local text = table.concat(swingsLog, "\n")
		swingsLog, swingsTally = nil, nil
		Chat(summary)
		ShowResults(text)
	end
end

-- /trbprobe auras: which stack and charge auras the client would keep secret. A static query; no aura is read.
local secretAuraCandidates = {
	{ "Eclipse", 408255 }, { "Maelstrom Weapon", 408505 }, { "Lightning Shield", 324 }, { "Water Shield", 408510 }, { "Flurry (Shaman)", 16257 },
	{ "Flurry (Warrior)", 12966 }, { "Heating Up", 400625 }, { "Fingers of Frost", 400669 }, { "Combustion", 28682 }, { "Arcane Blast", 400573 },
	{ "Inner Fire", 588 }, { "Shadowguard", 18137 }, { "Elune's Grace", 2651 }, { "Holy Shield", 20925 }, { "Redoubt", 20128 },
	{ "Reckoning", 1326084 }, { "Vengeance", 20050 }, { "Echo of Command", 1311703 }, { "Shield Block", 2565 }, { "Sweeping Strikes", 12292 },
	{ "Reckless Swings", 1329555 }, { "Gore Drinker", 1323969 }, { "Sniper Shot", 1310687 }, { "Slice and Dice", 5171 },
}

local function RunSecretAuras()
	local lines = { "TRB Forever Probe aura secrecy " .. date("%Y-%m-%d %H:%M:%S") .. " inCombat=" .. tostring(InCombatLockdown()) }
	if C_Secrets == nil or C_Secrets.ShouldSpellAuraBeSecret == nil then
		lines[#lines + 1] = "C_Secrets.ShouldSpellAuraBeSecret is MISSING on this client"
		Chat("auras: this client has no C_Secrets.ShouldSpellAuraBeSecret.")
	else
		local ok, all = pcall(C_Secrets.ShouldAurasBeSecret)
		lines[#lines + 1] = "ShouldAurasBeSecret() = " .. (ok and Value(all) or ("ERROR: " .. tostring(all)))
		local open = {}
		for _, candidate in ipairs(secretAuraCandidates) do
			local called, secret = pcall(C_Secrets.ShouldSpellAuraBeSecret, candidate[2])
			lines[#lines + 1] = string.format("  %s (%d) = %s", candidate[1], candidate[2], called and Value(secret) or ("ERROR: " .. tostring(secret)))
			if called and secret == false then open[#open + 1] = candidate[1] end
		end
		Chat(string.format("auras (%s): %d of %d not secret%s. Run it once in combat and once out.", InCombatLockdown() and "in combat" or "out of combat",
			#open, #secretAuraCandidates, #open > 0 and (": " .. table.concat(open, ", ")) or ""))
	end
	ShowResults(table.concat(lines, "\n"))
end

-- /trbprobe casttime <spell id>: every distinct cast time and cost the spell reports, in and out of combat.
local castTimeFrame = CreateFrame("Frame")
local castTimeLog = nil
local castTimeState = nil

local function SampleCastTime(reason)
	local state = castTimeState
	if state == nil then return end
	local okInfo, info = pcall(C_Spell.GetSpellInfo, state.spellId)
	local castTime = okInfo and info ~= nil and info.castTime or nil
	local okCost, costs = pcall(C_Spell.GetSpellPowerCost, state.spellId)
	local cost = okCost and type(costs) == "table" and costs[1] ~= nil and costs[1].cost or nil
	local key = string.format("%s castTime=%s cost=%s", InCombatLockdown() and "combat" or "idle", Value(castTime), Value(cost))
	if state.seen[key] == nil then
		state.seen[key] = true
		local line = string.format("%.1f new value: %s (after %s)", GetTime() - state.start, key, reason)
		castTimeLog[#castTimeLog + 1] = line
		Chat(line)
	end
end

castTimeFrame:SetScript("OnEvent", function(_, event, _, _, spellId)
	if event == "UNIT_SPELLCAST_SUCCEEDED" and not IsSecret(spellId) and spellId ~= nil then
		local reason = "cast " .. spellId .. " " .. SpellName(spellId)
		SampleCastTime(reason)
		-- Again once the cast's own buff changes have landed.
		C_Timer.After(0.3, function() SampleCastTime(reason .. " +0.3s") end)
	else
		SampleCastTime(event)
	end
end)

local function ToggleCastTimeLog(spellId)
	if castTimeLog ~= nil then
		castTimeFrame:UnregisterAllEvents()
		if castTimeState ~= nil and castTimeState.ticker ~= nil then castTimeState.ticker:Cancel() end
		local text = table.concat(castTimeLog, "\n")
		castTimeLog, castTimeState = nil, nil
		Chat("casttime log OFF: press Ctrl+A then Ctrl+C in the window, then paste the text back.")
		ShowResults(text)
		return
	end
	local name = SpellName(spellId)
	castTimeLog = { string.format("TRB Forever Probe cast time log %s spell %d %s", date("%Y-%m-%d %H:%M:%S"), spellId, name) }
	castTimeState = { spellId = spellId, seen = {}, start = GetTime() }
	castTimeFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	castTimeFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	castTimeFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
	-- Procs from hits change the value between casts.
	castTimeState.ticker = C_Timer.NewTicker(0.5, function() SampleCastTime("0.5s tick") end)
	Chat(string.format("casttime log ON for %d %s. Fight until the buff that shortens it has built up and been spent a few times, then /trbprobe casttime again.", spellId, name))
	SampleCastTime("start")
end

-- /trbprobe crits: whether each of the player's casts has its result on the target in the same frame, crits included.
local critsFrame = CreateFrame("Frame")
local critsLog = nil
local critsCasts, critsResults = nil, nil

critsFrame:SetScript("OnEvent", function(_, event, _, a, b, _, d)
	if critsLog == nil or critsCasts == nil or critsResults == nil then return end
	if event == "UNIT_COMBAT" then
		if IsSecret(a) or IsSecret(b) or a == "HEAL" or a == "ENERGIZE" then return end
		local key = a .. (b ~= "" and ("/" .. b) or "") .. ((IsSecret(d) or d == 1) and "" or " magic")
		critsResults[#critsResults + 1] = { time = GetTime(), key = key, crit = b == "CRITICAL" }
		critsLog[#critsLog + 1] = string.format("%.3f target %s", GetTime(), key)
	else
		if IsSecret(b) or b == nil then return end
		critsCasts[#critsCasts + 1] = { time = GetTime(), name = b .. " " .. SpellName(b) }
		critsLog[#critsLog + 1] = string.format("%.3f cast %s", GetTime(), b .. " " .. SpellName(b))
	end
end)

local function ToggleCritsLog()
	if critsLog == nil then
		critsLog = { "TRB Forever Probe crits log " .. date("%Y-%m-%d %H:%M:%S") }
		critsCasts, critsResults = {}, {}
		critsFrame:RegisterUnitEvent("UNIT_COMBAT", "target")
		critsFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		Chat("crits log ON. Solo, keep one enemy targeted and use each damaging ability at least ten times (instant attacks, cast spells, and ones with travel time), then /trbprobe crits again.")
		return
	end
	critsFrame:UnregisterAllEvents()
	local casts, results = critsCasts or {}, critsResults or {}
	-- A cast's result is the one in its own frame, or failing that the next unclaimed one within 2 seconds.
	local bySpell, order = {}, {}
	for _, cast in ipairs(casts) do
		local spell = bySpell[cast.name]
		if spell == nil then
			spell = { casts = 0, same = 0, sameCrits = 0, late = 0, lateCrits = 0, lateTotal = 0, none = 0 }
			bySpell[cast.name] = spell
			order[#order + 1] = cast.name
		end
		spell.casts = spell.casts + 1
		local match, late = nil, nil
		for _, result in ipairs(results) do
			if not result.used then
				if result.time == cast.time then
					match = result
					break
				elseif late == nil and result.time > cast.time and result.time - cast.time <= 2 then
					late = result
				end
			end
		end
		if match ~= nil then
			match.used = true
			spell.same = spell.same + 1
			spell.sameCrits = spell.sameCrits + (match.crit and 1 or 0)
		elseif late ~= nil then
			late.used = true
			spell.late = spell.late + 1
			spell.lateCrits = spell.lateCrits + (late.crit and 1 or 0)
			spell.lateTotal = spell.lateTotal + (late.time - cast.time)
		else
			spell.none = spell.none + 1
		end
	end
	local unclaimed, unclaimedCrits = 0, 0
	for _, result in ipairs(results) do
		if not result.used then
			unclaimed = unclaimed + 1
			unclaimedCrits = unclaimedCrits + (result.crit and 1 or 0)
		end
	end
	for _, name in ipairs(order) do
		local spell = bySpell[name]
		local line = string.format("%s: %d casts | same frame %d (%d crit) | later %d (%d crit, avg +%.2fs) | no result %d", name, spell.casts,
			spell.same, spell.sameCrits, spell.late, spell.lateCrits, spell.late > 0 and spell.lateTotal / spell.late or 0, spell.none)
		critsLog[#critsLog + 1] = line
		Chat(line)
	end
	local rest = string.format("results matched to no cast (swings, ticks, other sources): %d (%d crit)", unclaimed, unclaimedCrits)
	critsLog[#critsLog + 1] = rest
	Chat(rest)
	local text = table.concat(critsLog, "\n")
	critsLog, critsCasts, critsResults = nil, nil, nil
	ShowResults(text)
end

-- /trbprobe mana: what a resource gain looks like on the player's own UNIT_COMBAT and combat text.
local manaFrame = CreateFrame("Frame")
local manaLog = nil
local manaTally = nil

manaFrame:SetScript("OnEvent", function(_, event, a, b, c, d, e)
	if manaLog == nil or manaTally == nil then return end
	local key
	if event == "UNIT_COMBAT" then
		if IsSecret(b) then return end
		if b ~= "ENERGIZE" and b ~= "HEAL" then
			-- Counted only, to show whether there were hits a gain could have come from.
			manaTally["other " .. b] = (manaTally["other " .. b] or 0) + 1
			return
		end
		key = string.format("UNIT_COMBAT %s flag %s amount %s school %s", b, Value(c), Value(d), Value(e))
	elseif event == "COMBAT_TEXT_UPDATE" then
		if IsSecret(a) or a == nil or not a:find("ENERGIZE") then return end
		local parts = { pcall(C_CombatText.GetCurrentEventInfo) }
		for i = 2, #parts do parts[i] = Value(parts[i]) end
		key = string.format("COMBAT_TEXT %s info %s", a, parts[1] and table.concat(parts, ", ", 2) or "ERROR")
	else
		if IsSecret(c) or c == nil then return end
		manaLog[#manaLog + 1] = string.format("%.3f cast %s %s", GetTime(), c, SpellName(c))
		return
	end
	manaTally[key] = (manaTally[key] or 0) + 1
	manaLog[#manaLog + 1] = string.format("%.3f %s", GetTime(), key)
end)

local function ToggleManaLog()
	if manaLog == nil then
		manaLog = { "TRB Forever Probe mana log " .. date("%Y-%m-%d %H:%M:%S") }
		manaTally = {}
		manaFrame:RegisterUnitEvent("UNIT_COMBAT", "player")
		manaFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		local ok = pcall(manaFrame.RegisterEvent, manaFrame, "COMBAT_TEXT_UPDATE")
		local unit = "no C_CombatText"
		if C_CombatText ~= nil and C_CombatText.GetActiveUnit ~= nil then
			-- Combat text is silent until a unit is set, which only Blizzard's floating combat text does.
			if C_CombatText.GetActiveUnit() == nil then
				pcall(C_CombatText.SetActiveUnit, "player")
			end
			unit = Value(C_CombatText.GetActiveUnit())
		end
		manaLog[#manaLog + 1] = string.format("COMBAT_TEXT_UPDATE registered: %s, combat text unit: %s", tostring(ok), unit)
		Chat("mana log ON. In combat, trigger a few mana or resource gains (a proc, a potion, a shield that restores mana when hit), and take a heal, then /trbprobe mana again.")
	else
		manaFrame:UnregisterAllEvents()
		local summary = "gains seen: " .. TallyText(manaTally)
		manaLog[#manaLog + 1] = summary
		local text = table.concat(manaLog, "\n")
		manaLog, manaTally = nil, nil
		Chat(summary)
		ShowResults(text)
	end
end

local validOptions = "/trbprobe, /trbprobe swing, /trbprobe hits, /trbprobe swings, /trbprobe auras, /trbprobe crits, /trbprobe mana, /trbprobe casttime <spell id>"

SLASH_TRBFOREVERPROBE1 = "/trbprobe"
SlashCmdList["TRBFOREVERPROBE"] = function(msg)
	local option, argument = strsplit(" ", strtrim(msg or ""):lower(), 2)
	local fn
	if option == "help" then
		print("|cFF00FF00TRB Forever Probe|r Valid: " .. validOptions)
		return
	elseif option == "" then
		fn = Run
	elseif option == "swing" then
		fn = ToggleSwingLog
	elseif option == "hits" then
		fn = ToggleHitsLog
	elseif option == "swings" then
		fn = ToggleSwingsLog
	elseif option == "auras" then
		fn = RunSecretAuras
	elseif option == "crits" then
		fn = ToggleCritsLog
	elseif option == "mana" then
		fn = ToggleManaLog
	elseif option == "casttime" then
		local spellId = tonumber(argument)
		if castTimeLog == nil and (spellId == nil or SpellName(spellId) == "?") then
			print("|cFFFF0000TRB Forever Probe:|r casttime needs a spell ID this client knows, such as /trbprobe casttime 403. Run it again with no ID to stop.")
			return
		end
		fn = function() ToggleCastTimeLog(spellId) end
	else
		print("|cFFFF0000TRB Forever Probe:|r unknown option '" .. option .. "'. Valid: " .. validOptions)
		return
	end
	if option ~= "casttime" and argument ~= nil then
		print("|cFFFF0000TRB Forever Probe:|r '" .. option .. "' takes no argument. Valid: " .. validOptions)
		return
	end
	local ok, err = pcall(fn)
	if not ok then
		print("|cFFFF0000TRB Forever Probe failed:|r " .. tostring(err))
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	print("|cFF00FF00TRB Forever Probe|r loaded. Type /trbprobe to record this client's facts, or /trbprobe help for the tracking logs.")
end)
