local _, TRB = ...
if TRB.Data.character.classId ~= 8 then --Only do this if we're on an Mage!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resourceFrame = TRB.Frames.resourceFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	arcane = TRB.Classes.SpecCache:New(),
	fire = TRB.Classes.SpecCache:New(),
	frost = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Arcane
	specCache.arcane.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.arcane.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Mage.ArcaneSpells
	specCache.arcane.spellsData.spells = TRB.Classes.Mage.ArcaneSpells:New()
	local spells = specCache.arcane.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]

	specCache.arcane.snapshotData.attributes.manaRegen = 0
	specCache.arcane.snapshotData.audio = {
	}

	specCache.arcane.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Fire
	specCache.fire.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.fire.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Mage.FireSpells
	specCache.fire.spellsData.spells = TRB.Classes.Mage.FireSpells:New()

	specCache.fire.snapshotData.attributes.manaRegen = 0
	specCache.fire.snapshotData.audio = {
	}

	specCache.fire.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Frost
	specCache.frost.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.frost.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Mage.FrostSpells
	specCache.frost.spellsData.spells = TRB.Classes.Mage.FrostSpells:New()

	specCache.frost.snapshotData.attributes.manaRegen = 0
	specCache.frost.snapshotData.audio = {
	}

	specCache.frost.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Arcane()
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "arcane", true)
end

local function FillSpellData_Arcane()
	Setup_Arcane()
	specCache.arcane.spellsData:FillSpellData()
	local spells = specCache.arcane.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.arcane.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.arcane.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["MageArcaneBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MageArcaneBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MageArcaneBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MageArcaneBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$arcaneCharges", description = L["MageArcaneBarTextVariable_arcaneCharges"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$arcaneChargesMax", description = L["MageArcaneBarTextVariable_arcaneChargesMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Fire()
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "fire")
end

local function FillSpellData_Fire()
	Setup_Fire()
	specCache.fire.spellsData:FillSpellData()
	local spells = specCache.fire.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.fire.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.fire.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["MageArcaneBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MageArcaneBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MageArcaneBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MageArcaneBarTextVariable_casting"], printInSettings = true, color = false },
	}
end

local function Setup_Frost()
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "frost")
end

local function FillSpellData_Frost()
	Setup_Frost()
	specCache.frost.spellsData:FillSpellData()
	local spells = specCache.frost.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.frost.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.frost.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["MageArcaneBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MageArcaneBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MageArcaneBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MageArcaneBarTextVariable_casting"], printInSettings = true, color = false },
	}
end

local function CalculateAbilityResourceValue(resource, threshold)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	
	if TRB.Data.character.specId == 1 then -- Arcane
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Fire
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Frost
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
	if clearAll == true then
		if TRB.Data.character.specId == 1 then
		elseif TRB.Data.character.specId == 2 then
		elseif TRB.Data.character.specId == 3 then
		end
	end
end

local function ConstructResourceBar(settings)
	for _, v in pairs(resourceFrame.thresholds) do
		v:Hide();
	end

	for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
		if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
			TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
		end
		TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
	end

	if TRB.Data.character.specId == 1 then
		TRB.Frames.resource2ContainerFrame:Show()
		for thresholdId = 1, 3 do-- TRB.Data.character.maxResource2-1 do
			if TRB.Frames.resource2Frames[1].containerFrame.thresholds[thresholdId] == nil then
				TRB.Frames.resource2Frames[1].containerFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resource2Frames[1].containerFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLineComboPoint(TRB.Frames.resource2Frames[1].containerFrame.thresholds[thresholdId], settings)
			TRB.Frames.resource2Frames[1].containerFrame.thresholds[thresholdId]:Hide()
		end
	else
		TRB.Frames.resource2ContainerFrame:Hide()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
end

local function RefreshLookupData_Arcane()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.arcane
	local sharedSettings = TRB.Data.specCache["arcane"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.mage.arcane.colors.text.current.color
	local castingManaColor = TRB.Data.settings.mage.arcane.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.mage.arcane.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	--[[local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end]]
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, true)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$arcaneCharges"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$arcaneChargesMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$arcaneCharges"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$arcaneChargesMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Fire()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.fire
	local sharedSettings = TRB.Data.specCache["fire"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.mage.fire.colors.text.current.color
	local castingManaColor = TRB.Data.settings.mage.fire.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.mage.fire.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))
	
	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	--[[local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end]]
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, true)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Frost()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.frost
	local sharedSettings = TRB.Data.specCache["frost"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.mage.frost.colors.text.current.color
	local castingManaColor = TRB.Data.settings.mage.frost.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.mage.frost.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))
	
	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	--[[local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end]]
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, true)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell)
	local currentTime = GetTime()
	TRB.Data.snapshotData.casting.startTime = currentTime
	TRB.Data.snapshotData.casting.resourceRaw = spell.mana
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.mana)
	TRB.Data.snapshotData.casting.spellId = spell.id
	TRB.Data.snapshotData.casting.icon = spell.icon
end

local function UpdateCastingResourceFinal()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

local function UpdateSnapshot_Arcane()
	UpdateSnapshot()
end

local function UpdateSnapshot_Fire()
	UpdateSnapshot()
end

local function UpdateSnapshot_Frost()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.mage
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
		local specSettings = classSettings.arcane
		local specCacheSettings = TRB.Data.specCache.arcane.settings
		UpdateSnapshot_Arcane()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)

				local barColor = specSettings.colors.bar.base

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				local current = snapshotData.attributes.resource2
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local cpBorderColor = specSettings.colors.comboPoints.border
				local cpColor = specSettings.colors.comboPoints.base
				local cpBR = cpBackgroundRed
				local cpBG = cpBackgroundGreen
				local cpBB = cpBackgroundBlue

				TRB.Frames.resource2Frames[1].resourceFrame:SetMinMaxValues(0, TRB.Data.character.maxResource2)
				TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint1", TRB.Frames.resource2Frames[1].resourceFrame, current, TRB.Data.character.maxResource2)-- max)
				for x = 1, TRB.Data.character.maxResource2-1 do
					TRB.Frames.resource2Frames[1].containerFrame.thresholds[x]:Show()
					TRB.Functions.Color:SetThresholdColor(TRB.Frames.resource2Frames[1].containerFrame.thresholds[x], cpBorderColor, true)
					TRB.Functions.Threshold:RepositionThresholdComboPoint(specCacheSettings, "comboPointThreshold1", TRB.Frames.resource2Frames[1].containerFrame.thresholds[x], true, TRB.Frames.resource2Frames[1].containerFrame, x, TRB.Data.character.maxResource2)
				end
				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[1].borderFrame, "comboPoint1", cpBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[1].resourceFrame, "comboPoint1", cpColor)
				TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[1].containerFrame, "comboPoint1", cpBR, cpBG, cpBB, cpBackgroundAlpha)
				
				--[[local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end
					
					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[x].borderFrame, "comboPoint" .. x, cpBorderColor)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[x].resourceFrame, "comboPoint" .. x, cpColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[x].containerFrame, "comboPoint" .. x, cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end]]
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.fire
		local specCacheSettings = TRB.Data.specCache.fire.settings
		UpdateSnapshot_Fire()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.frost
		local specCacheSettings = TRB.Data.specCache.frost.settings
		UpdateSnapshot_Frost()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	end
end

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	
	if TRB.Data.character.specId == 1 then
		specCache.arcane.talents:GetTalents()
		FillSpellData_Arcane()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.arcane)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arcane
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.arcane.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.mage.arcane)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "arcane" then
			talents = specCache.arcane.talents
			TRB.Data.barConstructedForSpec = "arcane"
			ConstructResourceBar(specCache.arcane.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.fire.talents:GetTalents()
		FillSpellData_Fire()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.fire)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Fire
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.fire.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.mage.fire)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "fire" then
			talents = specCache.fire.talents
			TRB.Data.barConstructedForSpec = "fire"
			ConstructResourceBar(specCache.fire.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.frost.talents:GetTalents()
		FillSpellData_Frost()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.frost)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Frost
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.frost.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.mage.frost)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "frost" then
			talents = specCache.frost.talents
			TRB.Data.barConstructedForSpec = "frost"
			ConstructResourceBar(specCache.frost.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end
	
	TRB.Functions.Class:EventRegistration()

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
				TRB.Functions.Character:ResetCaches()
			end
		end)
	end)
end

resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end
	
	if TRB.Data.character.classId == 8 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Mage.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.mage == nil or
						TwintopInsanityBarSettings.mage.arcane == nil or
						TwintopInsanityBarSettings.mage.arcane.displayText == nil then
						settings.mage.arcane.displayText.barText = TRB.Options.Mage.ArcaneLoadDefaultBarTextSimpleSettings()
					elseif TwintopInsanityBarSettings.mage == nil or
						TwintopInsanityBarSettings.mage.fire == nil or
						TwintopInsanityBarSettings.mage.fire.displayText == nil then
						settings.mage.fire.displayText.barText = TRB.Options.Mage.FireLoadDefaultBarTextSimpleSettings()
					elseif TwintopInsanityBarSettings.mage == nil or
						TwintopInsanityBarSettings.mage.frost == nil or
						TwintopInsanityBarSettings.mage.frost.displayText == nil then
						settings.mage.frost.displayText.barText = TRB.Options.Mage.FrostLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Mage.LoadDefaultSettings(true)
					TRB.Data.settings = settings
				end
				FillSpecializationCache()

				SLASH_TWINTOP1 	= "/twintop"
				SLASH_TWINTOP2 	= "/tt"
				SLASH_TWINTOP3 	= "/tib"
				SLASH_TWINTOP4 	= "/tit"
				SLASH_TWINTOP5 	= "/ttib"
				SLASH_TWINTOP6 	= "/ttit"
				SLASH_TWINTOP7 	= "/trb"
				SLASH_TWINTOP8 	= "/trt"
				SLASH_TWINTOP9 	= "/ttrt"
				SLASH_TWINTOP10 = "/ttrb"
			end
		end

		if event == "PLAYER_LOGOUT" then
			TwintopInsanityBarSettings = TRB.Data.settings
		end

		if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
			if not TRB.Details.addonData.optionsPanelStarted then
				TRB.Details.addonData.optionsPanelStarted = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
						TRB.Data.settings.mage.arcane = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MageArcaneFull"], TRB.Data.settings.mage.arcane)
						TRB.Data.settings.mage.fire = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MageFireFull"], TRB.Data.settings.mage.fire)
						TRB.Data.settings.mage.frost = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MageFrostFull"], TRB.Data.settings.mage.frost)
						
						FillSpellData_Arcane()
						FillSpellData_Fire()
						FillSpellData_Frost()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Mage.ConstructOptionsPanel(specCache)
						
						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end

						TRB.Functions.Class:EventRegistration()
						TRB.Functions.News:Init()
						TRB.Details.addonData.optionsPanelFinished = true
					end)
				end)
			end

			if TRB.Details.addonData.optionsPanelFinished and (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED") then
				C_Timer.After(0, function()
					C_Timer.After(0.1, function()
						SwitchSpec()
					end)
				end)
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	local specId = GetSpecialization()
	if specId ~= TRB.Data.character.specId then
		SwitchSpec()
	end
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "mage"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
		TRB.Data.character.specName = "arcane"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "fire"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "frost"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.mage.arcane then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.mage.arcane)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ArcaneCharges
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.mage.fire then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.mage.fire)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.mage.frost then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.mage.frost)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 0
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		TRB.Functions.Bar:HideResourceBarGeneric(sharedSettings, force, notZeroShowValue, true, notZeroShowValueComboPoints)
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end
	
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.mage.arcane
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.mage.fire
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.mage.frost
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Arcane
		if var == "$comboPoints" or var == "$arcaneCharges" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$arcaneChargesMax" then
			valid = true
		end
	elseif TRB.Data.character.specId == 2 then --Fire
		-- No spec-specific variables for Fire currently
	elseif TRB.Data.character.specId == 3 then --Frost
		-- No spec-specific variables for Frost currently
	end

	--Spec agnostic
	if var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$resource" or var == "$mana" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$manaMax" then
		valid = true
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end