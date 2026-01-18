local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on an Evoker!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	devastation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
	preservation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
	augmentation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Devastation
	specCache.devastation.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.devastation.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 10000,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Evoker.DevastationSpells
	specCache.devastation.spellsData.spells = TRB.Classes.Evoker.DevastationSpells:New()
	local spells = specCache.devastation.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]

	specCache.devastation.snapshotData.attributes.manaRegen = 0
	specCache.devastation.snapshotData.audio = {
		secondaryThresholdPlayed = false
	}

	specCache.devastation.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Preservation
	specCache.preservation.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.preservation.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Evoker.PreservationSpells
	specCache.preservation.spellsData.spells = TRB.Classes.Evoker.PreservationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.preservation.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

	specCache.preservation.snapshotData.attributes.manaRegen = 0
	specCache.preservation.snapshotData.audio = {
		secondaryThresholdPlayed = false
	}

	specCache.preservation.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Augmentation
	specCache.augmentation.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.augmentation.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 10000,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Evoker.AugmentationSpells
	specCache.augmentation.spellsData.spells = TRB.Classes.Evoker.AugmentationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.augmentation.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	specCache.augmentation.snapshotData.attributes.manaRegen = 0
	specCache.augmentation.snapshotData.attributes.extendsEbonMight = false
	specCache.augmentation.snapshotData.audio = {
		playedEbonMightCue = false,
		secondaryThresholdPlayed = false
	}
	---@type TRB.Classes.Snapshot
	specCache.augmentation.snapshotData.snapshots[spells.ebonMight.id] = TRB.Classes.Snapshot:New(spells.ebonMight)

	specCache.augmentation.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Devastation()
	TRB.Functions.Character:FillSpecializationCacheSettings("evoker", "devastation")

	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()

	-- Create bar groups for Devastation using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(1)
end

local function FillSpellData_Devastation()
	Setup_Devastation()
	specCache.devastation.spellsData:FillSpellData()
	local spells = specCache.devastation.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.devastation.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.devastation.barTextVariables.values = {
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

		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["EvokerDevastationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerDevastationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerDevastationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$essence", description = L["EvokerDevastationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerDevastationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerDevastationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Preservation()
	TRB.Functions.Character:FillSpecializationCacheSettings("evoker", "preservation", true)

	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()

	-- Create bar groups for Preservation using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(2)
end

local function FillSpellData_Preservation()
	Setup_Preservation()
	specCache.preservation.spellsData:FillSpellData()
	local spells = specCache.preservation.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.preservation.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.preservation.barTextVariables.values = {
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

		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["EvokerPreservationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerPreservationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerPreservationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["EvokerPreservationBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$essence", description = L["EvokerPreservationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerPreservationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerPreservationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Augmentation()
	TRB.Functions.Character:FillSpecializationCacheSettings("evoker", "augmentation")

	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()

	-- Create bar groups for Augmentation using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(3)
end

local function FillSpellData_Augmentation()
	Setup_Augmentation()
	specCache.augmentation.spellsData:FillSpellData()
	local spells = specCache.augmentation.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.augmentation.barTextVariables.icons = {
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#ebonMight", icon = spells.ebonMight.icon, description = spells.ebonMight.name, printInSettings = true },
	}
	specCache.augmentation.barTextVariables.values = {
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

		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["EvokerAugmentationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerAugmentationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerAugmentationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$essence", description = L["EvokerAugmentationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerAugmentationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerAugmentationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },

		{ variable = "$ebonMightTime", description = L["EvokerAugmentationBarTextVariable_ebonMightTime"], printInSettings = true, color = false },
	}
end

local function CalculateAbilityResourceValue(resource, threshold)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	
	if TRB.Data.character.specId == 1 then -- Devastation
	elseif TRB.Data.character.specId == 2 then -- Preservation
	elseif TRB.Data.character.specId == 3 then -- Augmentation
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
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Construct thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Configure secondary bar for Essence (all specs)
	-- Set up structure, but let HideResourceBar() determine visibility
	if barGroups and barGroups.secondary then
		barGroups.secondary:SetNodeCount(TRB.Data.character.maxResource2 or 5)
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Devastation()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local specSettings = TRB.Data.settings.evoker.devastation
	local sharedSettings = TRB.Data.specCache["devastation"].settings
	--Spec specific implementation
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local regen, _ = GetPowerRegenForPowerType(Enum.PowerType.Essence)

	if regen == nil or regen == 0 then
		regen = 1
	end

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / regen
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))
	
	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$resource"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Preservation()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.evoker.preservation
	local sharedSettings = TRB.Data.specCache["preservation"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local regen, _ = GetPowerRegenForPowerType(Enum.PowerType.Essence)

	if regen == nil or regen == 0 then
		regen = 1
	end

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / regen
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$resourcePercent"] = manaPercent
	lookup["$manaPercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourceMax"] = manaMax
	lookupLogic["$manaMax"] = manaMax
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Augmentation()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local specSettings = TRB.Data.settings.evoker.augmentation
	local sharedSettings = TRB.Data.specCache["augmentation"].settings
	--Spec specific implementation
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local regen, _ = GetPowerRegenForPowerType(Enum.PowerType.Essence)

	if regen == nil or regen == 0 then
		regen = 1
	end

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / regen
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	--$ebonMightTime
	local _ebonMightTime = snapshots[spells.ebonMight.id].buff:GetRemainingTime(currentTime)
	local ebonMightTime = TRB.Functions.BarText:TimerPrecision(_ebonMightTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$resource"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$essence"] = snapshotData.attributes.resource
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$ebonMightTime"] = ebonMightTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$ebonMightTime"] = _ebonMightTime
	TRB.Data.lookupLogic = lookupLogic
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Preservation()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting

	if TRB.Data.character.specId == 1 then
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_EMPOWER_START" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Preservation()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		if event == "UNIT_SPELLCAST_EMPOWER_START" then
			snapshotData.attributes.extendsEbonMight = true
			casting:SnapshotSpell()
		elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			-- Track if we're casting an ability that extends Ebon Might
			if spellId == spells.erruption.id then
				snapshotData.attributes.extendsEbonMight = true
				casting:SnapshotSpell()
			elseif spellId == spells.emeraldBlossom.id and talents:IsTalentActive(spells.dreamOfSpring.talentId) then
				snapshotData.attributes.extendsEbonMight = true
				casting:SnapshotSpell()
			else
				snapshotData.attributes.extendsEbonMight = false
				casting:Reset()
			end
		elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_EMPOWER_STOP" then
			snapshotData.attributes.extendsEbonMight = false
			casting:Reset()
		else
			casting:Reset()
		end
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
end

local function UpdateSnapshot_Devastation()
	UpdateSnapshot()
	
	local currentTime = GetTime()
end

local function UpdateSnapshot_Preservation()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateSnapshot_Augmentation()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	local currentTime = GetTime()
end

---Updates Essence bar nodes with current values and colors
---@param specSettings table # The spec-specific settings
---@param specCacheSettings table # The spec cache settings
local function UpdateEssence(specSettings, specCacheSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	for x = 1, TRB.Data.character.maxResource2 do
		local cpBorderColor = specSettings.colors.comboPoints.border
		local cpColor = specSettings.colors.comboPoints.base

		local essenceValue = 0
		if snapshotData.attributes.resource2 >= x then
			essenceValue = 1000
			-- Color logic for penultimate/final
			if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
				cpColor = specSettings.colors.comboPoints.penultimate
			elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2) or x == TRB.Data.character.maxResource2 then
				cpColor = specSettings.colors.comboPoints.final
			end
		elseif snapshotData.attributes.resource2 + 1 == x then
			essenceValue = snapshotData.attributes.essencePartial or UnitPartialPower("player", Enum.PowerType.Essence)
		end

		if barGroups and barGroups.secondary then
			local essenceNode = barGroups.secondary:GetNode(x)
			if essenceNode then
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "essence" .. x, essenceNode, essenceValue, 1000)
				essenceNode:SetBorderColor(cpBorderColor)
				essenceNode:SetColor(cpColor)
				essenceNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
			end
		end
	end
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.evoker
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local function UpdateEssenceOuter(specSettings, specCacheSettings)
		local refreshTextEssence = false
		
		if specSettings.displayBar.secondary ~= "never" then
			refreshTextEssence = true
			UpdateEssence(specSettings, specCacheSettings)
		end

		if specSettings.audio.secondaryThreshold.enabled and not snapshotData.audio.secondaryThresholdPlayed and snapshotData.attributes.resource2 <= specSettings.audio.secondaryThreshold.configuration.thresholdValue then
			snapshotData.audio.secondaryThresholdPlayed = true
			PlaySoundFile(specSettings.audio.secondaryThreshold.sound, coreSettings.audio.channel.channel)
		elseif snapshotData.attributes.resource2 > specSettings.audio.secondaryThreshold.configuration.thresholdValue then
			snapshotData.audio.secondaryThresholdPlayed = false
		end

		return refreshTextEssence
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.devastation
		local specCacheSettings = TRB.Data.specCache.devastation.settings
		UpdateSnapshot_Devastation()

		if barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		end
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				end

				if primaryNode then
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings) or refreshText

			if specSettings.displayBar.health ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.preservation
		local specCacheSettings = TRB.Data.specCache.preservation.settings
		UpdateSnapshot_Preservation()

		if barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		end
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border

				local barColor = specSettings.colors.bar.base

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings) or refreshText

			if specSettings.displayBar.health ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.augmentation
		local specCacheSettings = TRB.Data.specCache.augmentation.settings
		UpdateSnapshot_Augmentation()

		if barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		end
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				end

				-- Ebon Might bar color changes
				if snapshots[spells.ebonMight.id].buff.isActive then
					local ebonMightTimeLeft = snapshots[spells.ebonMight.id].buff.remaining
					local ebonMightTimeThreshold = 0
					local useEndOfEbonMightColor = false

					if specSettings.endOfEbonMight.enabled then
						useEndOfEbonMightColor = true
						if specSettings.endOfEbonMight.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							ebonMightTimeThreshold = gcd * specSettings.endOfEbonMight.gcdsMax
						elseif specSettings.endOfEbonMight.mode == "time" then
							ebonMightTimeThreshold = specSettings.endOfEbonMight.timeMax
						end
					end

					-- Check if casting an ability that extends Ebon Might but won't finish before it expires
					local castTimeRemaining = 0
					if snapshotData.attributes.extendsEbonMight and snapshotData.casting.endTime ~= nil then
						castTimeRemaining = snapshotData.casting.endTime - currentTime
						if castTimeRemaining < 0 then
							castTimeRemaining = 0
						end
					end

					if specSettings.colors.bar.ebonMightDropDuringCast.enabled and snapshotData.attributes.extendsEbonMight and castTimeRemaining > ebonMightTimeLeft then
						-- Cast will finish after Ebon Might expires
						barColor = specSettings.colors.bar.ebonMightDropDuringCast.color

						-- Play audio cue for ending soon
						if specSettings.audio.ebonMightEnding.enabled and not snapshotData.audio.playedEbonMightCue then
							snapshotData.audio.playedEbonMightCue = true
							PlaySoundFile(specSettings.audio.ebonMightEnding.sound, coreSettings.audio.channel.channel)
						end
					elseif useEndOfEbonMightColor and specSettings.colors.bar.inEbonMight1GCD.enabled and ebonMightTimeLeft <= ebonMightTimeThreshold then
						-- Ebon Might is ending soon
						barColor = specSettings.colors.bar.inEbonMight1GCD.color
					elseif specSettings.colors.bar.inEbonMight.enabled then
						-- Ebon Might is active
						barColor = specSettings.colors.bar.inEbonMight.color
						snapshotData.audio.playedEbonMightCue = false
					end
				else
					snapshotData.audio.playedEbonMightCue = false
				end

				if primaryNode then
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings) or refreshText

			if specSettings.displayBar.health ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
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
		specCache.devastation.talents:GetTalents()
		FillSpellData_Devastation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.devastation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData		

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devastation
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.devastation.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "devastation" then
			talents = specCache.devastation.talents
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "devastation"
			ConstructResourceBar(specCache.devastation.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.preservation.talents:GetTalents()
		FillSpellData_Preservation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.preservation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Preservation
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.preservation.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "preservation" then
			talents = specCache.devastation.talents
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "preservation"
			ConstructResourceBar(specCache.preservation.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.augmentation.talents:GetTalents()
		FillSpellData_Augmentation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.augmentation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Augmentation
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.augmentation.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ebonMight"] = spells.ebonMight.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "augmentation" then
			talents = specCache.augmentation.talents
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "augmentation"
			ConstructResourceBar(specCache.augmentation.settings)
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
				-- Ensure health values are populated so the health bar displays immediately
				TRB.Functions.Character:UpdateHealthValues()
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end)
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end
	
	if TRB.Data.character.classId == 13 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Evoker.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.devastation == nil or
						TwintopInsanityBarSettings.evoker.devastation.displayText == nil then
						settings.evoker.devastation.displayText.barText = TRB.Options.Evoker.DevastationLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.preservation == nil or
						TwintopInsanityBarSettings.evoker.preservation.displayText == nil then
						settings.evoker.preservation.displayText.barText = TRB.Options.Evoker.PreservationLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.augmentation == nil or
						TwintopInsanityBarSettings.evoker.augmentation.displayText == nil then
						settings.evoker.augmentation.displayText.barText = TRB.Options.Evoker.AugmentationLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.evoker ~= true then
						TRB.Data.settings.evoker.devastation.displayText.barText = TRB.Options.Evoker.DevastationLoadDefaultBarTextSettings()
						TRB.Data.settings.evoker.preservation.displayText.barText = TRB.Options.Evoker.PreservationLoadDefaultBarTextSettings()
						TRB.Data.settings.evoker.augmentation.displayText.barText = TRB.Options.Evoker.AugmentationLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.evoker = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Evoker"])
					end
				else
					local settings = TRB.Options.Evoker.LoadDefaultSettings(true)
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
						TRB.Data.settings.evoker.devastation = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["EvokerDevastationFull"], TRB.Data.settings.evoker.devastation)
						TRB.Data.settings.evoker.preservation = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["EvokerPreservationFull"], TRB.Data.settings.evoker.preservation)
						TRB.Data.settings.evoker.augmentation = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["EvokerAugmentationFull"], TRB.Data.settings.evoker.augmentation)
						
						FillSpellData_Devastation()
						FillSpellData_Preservation()
						FillSpellData_Augmentation()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Evoker.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "evoker"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", TRB.Data.resource, false)
	TRB.Data.character.maxResource2 = 1
	TRB.Data.resource2 = Enum.PowerType.Essence
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "devastation"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		TRB.Data.character.specName = "preservation"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "augmentation"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if sharedSettings ~= nil then
		--if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
			end
		--end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.evoker.devastation then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.evoker.preservation then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.evoker.augmentation then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		if sharedSettings ~= nil then
			local affectingCombat = TRB.Data.character.inCombat
			local inVehicle = UnitInVehicle("player")
			local forceHideAll = not TRB.Data.specSupported or force or (TRB.Data.character.advancedFlight and not sharedSettings.displayBar.dragonriding)

			-- Determine primary bar visibility independently
			local showPrimary = false
			if not forceHideAll then
				if sharedSettings.displayBar.primary == "always" then
					showPrimary = true
				elseif sharedSettings.displayBar.primary == "combat" then
					showPrimary = affectingCombat or inVehicle
				end
				-- "never" means showPrimary stays false
			end

			-- Determine secondary bar visibility independently
			-- All Evoker specs use the secondary (Essence) bar
			local showSecondary = false
			if not forceHideAll then
				if sharedSettings.displayBar.secondary == "always" then
					showSecondary = true
				elseif sharedSettings.displayBar.secondary == "combat" then
					showSecondary = affectingCombat or inVehicle
				end
				-- "never" means showSecondary stays false
			end

			-- Determine health bar visibility independently
			local showHealth = false
			if not forceHideAll then
				if sharedSettings.displayBar.health == "always" then
					showHealth = true
				elseif sharedSettings.displayBar.health == "combat" then
					showHealth = affectingCombat or inVehicle
				end
				-- "never" means showHealth stays false
			end

			-- Apply primary bar visibility
			if barGroups and barGroups.primary then
				if showPrimary then
					barGroups.primary:Show()
				else
					barGroups.primary:Hide()
				end
			end

			-- Apply secondary bar visibility
			if barGroups and barGroups.secondary then
				if showSecondary then
					barGroups.secondary:Show()
					barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
				else
					barGroups.secondary:Hide()
				end
			end

			-- Apply health bar visibility
			if barGroups and barGroups.health then
				if showHealth then
					barGroups.health:Show()
					barGroups.health:ShowNodes(1)
				else
					barGroups.health:Hide()
				end
			end

			-- Track if either bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary or showHealth
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			-- No settings - hide everything
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
			end
			if barGroups and barGroups.health then
				barGroups.health:Hide()
			end
			snapshotData.attributes.isTracking = false
		end
	else
		-- Unsupported spec - hide everything
		if barGroups and barGroups.primary then
			barGroups.primary:Hide()
		end
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
		if barGroups and barGroups.health then
			barGroups.health:Hide()
		end
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
	local spells
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		settings = TRB.Data.settings.evoker.devastation
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		settings = TRB.Data.settings.evoker.preservation
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		settings = TRB.Data.settings.evoker.augmentation
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Devastation			
	elseif TRB.Data.character.specId == 2 then --Preservation
	elseif TRB.Data.character.specId == 3 then -- Augmentation
		if var == "$ebonMightTime" then
			if snapshots[spells.ebonMight.id].buff.isActive then
				valid = true
			end
		end
	end

	-- Chronowarden
	if TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
	end

	-- Scalecommander
	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 3 then
	end

	--Spec agnostic
	if var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$resource" or var == "$mana" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourcePercent" or var == "$manaPercent" then
		-- Do not compare resource percent as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$manaMax" then
		valid = true
	elseif var == "$comboPoints" or var == "$essence" then
		valid = true
	elseif var == "$essenceRegenTime" then
		if snapshotData.attributes.resource2 < TRB.Data.character.maxResource2 then
			valid = true
		end
	elseif var == "$comboPointsMax"or var == "$essenceMax" then
		valid = true
	elseif var == "$health" or var == "$healthMax" or var == "$healthPercent" then
		valid = true
	end

	return valid
end

---Gets the Frame for the requested bar text variable, if the frame is currently enabled, and if it is visible.
---@param relativeToFrame string
---@return Frame? # Relative to Frame
---@return boolean # Is Enabled?
---@return boolean # Is Visible?
function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if relativeToFrame ~= nil then
		relativeToFrame = string.gsub(relativeToFrame, "_", "")
	end
	if relativeToFrame == "ResourceBar" or relativeToFrame == "Resource" then
		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame ~= nil then
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local essenceNode = barGroups.secondary:GetNode(index)
				if essenceNode then
					local isVisible = barGroups.secondary.isVisible and essenceNode.isVisible
					return essenceNode:GetResourceFrame(), true, isVisible
				end
			end
		end
		return nil, true, false
	end
	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end