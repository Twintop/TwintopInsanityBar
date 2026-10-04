local _, TRB = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

-- Class and spec names to be used throughout, derived from the flavor's class/spec registry:
--   L[classModuleName]          e.g. L["DeathKnight"]        -> client-localized class name
--   L[specLocaleKey]            e.g. L["HunterBeastMastery"] -> client-localized spec name
--   L[specLocaleKey .. "Full"]  e.g. L["PriestShadowFull"]   -> "Shadow Priest"
-- A spec without a resolvable global ID falls back to its settings key so the UI still has a label.
do
	local classList = LocalizedClassList()
	for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		L[classEntry.classModuleName] = classList[classEntry.classToken] or classEntry.classModuleName
	end

	for _, specEntry in ipairs(TRB.Data.specRegistryOrder) do
		local specName = nil
		if specEntry.classId ~= nil and specEntry.specId ~= nil then
			specName = select(2, GetSpecializationInfoForClassID(specEntry.classId, specEntry.specId))
		end
		if specName == nil or specName == "" then
			specName = string.upper(string.sub(specEntry.specName, 1, 1)) .. string.sub(specEntry.specName, 2)
		end
		L[specEntry.specLocaleKey] = specName
	end

	-- A class with a single specialization (Forever) is labelled by its class name alone.
	for _, specEntry in ipairs(TRB.Data.specRegistryOrder) do
		if #TRB.Data.classRegistry[specEntry.className].specs == 1 then
			L[specEntry.specLocaleKey .. "Full"] = L[specEntry.classModuleName]
		else
			L[specEntry.specLocaleKey .. "Full"] = string.format("%s %s", L[specEntry.specLocaleKey], L[specEntry.classModuleName])
		end
	end
end

-- Use existing localization strings provided by Blizzard for some things.
-- Source: https://www.townlong-yak.com/framexml/live/GlobalStrings.lua

L["ResourceFury"] = POWER_TYPE_FURY
L["ResourceEnergy"] = POWER_TYPE_ENERGY
L["ResourceComboPoints"] = COMBO_POINTS_POWER
L["ResourceRage"] = POWER_TYPE_RED_POWER
L["ResourceMana"] = POWER_TYPE_MANA
L["ResourceInsanity"] = POWER_TYPE_INSANITY
L["ResourceMaelstrom"] = POWER_TYPE_MAELSTROM
L["ResourceAstralPower"] = POWER_TYPE_LUNAR_POWER
L["ResourceChi"] = CHI_POWER
L["ResourceFocus"] = POWER_TYPE_FOCUS
L["ResourceEssence"] = POWER_TYPE_ESSENCE
L["ResourceHolyPower"] = HOLY_POWER
L["ResourceSoulShards"] = SOUL_SHARDS_POWER
L["ResourceRunicPower"] = RUNIC_POWER
L["ResourceRunes"] = RUNES
L["ResourceArcaneCharges"] = ARCANE_CHARGES_POWER
L["ResourceStagger"] = STAGGER

TRB.Localization = L
