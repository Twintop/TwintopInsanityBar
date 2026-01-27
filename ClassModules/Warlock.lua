local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on an Warlock!
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
	affliction = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	demonology = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	destruction = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Affliction
	specCache.affliction.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.affliction.character = {
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
	
	---@type TRB.Classes.Warlock.AfflictionSpells
	specCache.affliction.spellsData.spells = TRB.Classes.Warlock.AfflictionSpells:New()
	local spells = specCache.affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	specCache.affliction.snapshotData.audio = {
	}

	specCache.affliction.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Demonology
	specCache.demonology.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.demonology.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 10000,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Warlock.DemonologySpells
	specCache.demonology.spellsData.spells = TRB.Classes.Warlock.DemonologySpells:New()
	local spells = specCache.demonology.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

	specCache.demonology.snapshotData.audio = {
	}

	specCache.demonology.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Destruction
	specCache.destruction.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.destruction.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 10000,
		maxResource2 = 50,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Warlock.DestructionSpells
	specCache.destruction.spellsData.spells = TRB.Classes.Warlock.DestructionSpells:New()
	local spells = specCache.destruction.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

	specCache.destruction.snapshotData.audio = {
	}

	specCache.destruction.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Affliction()
	TRB.Functions.Character:FillSpecializationCacheSettings("warlock", "affliction", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Affliction using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Affliction()
	Setup_Affliction()
	specCache.affliction.spellsData:FillSpellData()
	local spells = specCache.affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.affliction.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.affliction.barTextVariables.values = {
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

		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["WarlockAfflictionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockAfflictionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockAfflictionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["WarlockAfflictionBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$soulShards", description = L["WarlockAfflictionBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockAfflictionBarTextVariable_soulShardsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Demonology()
	TRB.Functions.Character:FillSpecializationCacheSettings("warlock", "demonology", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Demonology using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Demonology()
	Setup_Demonology()
	specCache.demonology.spellsData:FillSpellData()
	local spells = specCache.demonology.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.demonology.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.demonology.barTextVariables.values = {
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

		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["WarlockDemonologyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockDemonologyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockDemonologyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["WarlockDemonologyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$soulShards", description = L["WarlockDemonologyBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockDemonologyBarTextVariable_soulShardsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end



local function Setup_Destruction()
	TRB.Functions.Character:FillSpecializationCacheSettings("warlock", "destruction", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Destruction using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Destruction()
	Setup_Destruction()
	specCache.destruction.spellsData:FillSpellData()
	local spells = specCache.destruction.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.destruction.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.destruction.barTextVariables.values = {
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

		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },
		
		{ variable = "$mana", description = L["WarlockDestructionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$manaPercent", description = L["WarlockDestructionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["WarlockDestructionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$casting", description = L["WarlockDestructionBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$soulShards", description = L["WarlockDestructionBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockDestructionBarTextVariable_soulShardsMax"], printInSettings = true, color = false },

		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then -- Affliction or Demonology
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
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- All Warlock specs use Soul Shards as secondary resource
	if barGroups and barGroups.secondary then
		local maxShards = TRB.Data.character.maxResource2
		if maxShards == nil or maxShards == 0 then
			maxShards = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxShards
	end

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for _ = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- All Warlock specs use Soul Shards secondary bar
	if barGroups and barGroups.secondary then
		local maxShards = TRB.Data.character.maxResource2 or 5
		
		-- Ensure secondary group knows the correct node count
		barGroups.secondary:SetNodeCount(maxShards)
		barGroups.secondary:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")
		barGroups.secondary:Show()
		
		-- Get effective width (may be CDM-matched) from barGroups or fall back to settings
		local effectiveWidth = (barGroups and barGroups.effectiveWidth) or settings.bar.width
		
		-- Apply layout to position all nodes correctly
		barGroups.secondary:ApplyLayout(
			effectiveWidth,
			settings.comboPoints.width,
			settings.comboPoints.height,
			settings.comboPoints.border
		)
		
		-- Set textures and colors for each Soul Shard node
		local frameLevels = TRB.Data.constants.frameLevels
		for i = 1, maxShards do
			local node = barGroups.secondary:GetNode(i)
			if node then
				node:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)
				node:SetMinMax(0, 1)
				node:SetBorderColor(settings.colors.comboPoints.border)
				node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
				node:SetColor(settings.colors.comboPoints.base)
				node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end


local function RefreshLookupData_Affliction()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.warlock.affliction
	local sharedSettings = TRB.Data.specCache["affliction"].settings
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local targetData = snapshotData.targetData
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local normalizedSoulShards = snapshotData.attributes.resource2-- / TRB.Data.resource2Factor

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
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
	
	----------------------------

	local lookup = TRB.Data.lookup or {}	
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$soulShards"] = normalizedSoulShards
	lookup["$comboPoints"] = normalizedSoulShards
	lookup["$soulShardsMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = manaMax
	lookupLogic["$manaMax"] = manaMax
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$soulShards"] = normalizedSoulShards
	lookupLogic["$comboPoints"] = normalizedSoulShards
	lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Demonology()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.warlock.demonology
	local sharedSettings = TRB.Data.specCache["demonology"].settings
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local targetData = snapshotData.targetData
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified
	local normalizedSoulShards = snapshotData.attributes.resource2

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)

	--$soulShards
	local soulShards = string.format("%.0f", normalizedSoulShards)
	--$soulShardsMax
	local soulShardsMax = string.format("%.0f", TRB.Data.character.maxResource2)

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$soulShards"] = soulShards
	lookup["$soulShardsMax"] = soulShardsMax
	lookup["$resource"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$resourcePercent"] = manaPercent
	lookup["$comboPoints"] = soulShards
	lookup["$comboPointsMax"] = soulShardsMax
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaPercent"] = manaPercentRaw
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$soulShards"] = normalizedSoulShards
	lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourcePercent"] = manaPercentRaw
	lookupLogic["$comboPoints"] = normalizedSoulShards
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Destruction()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.warlock.destruction
	local sharedSettings = TRB.Data.specCache["destruction"].settings
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local targetData = snapshotData.targetData
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified
	local normalizedSoulShards = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)

	--$soulShards
	local soulShards = string.format("%.1f", normalizedSoulShards)
	--$soulShardsMax
	local soulShardsMax = string.format("%.0f", TRB.Data.character.maxResource2)

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$soulShards"] = soulShards
	lookup["$soulShardsMax"] = soulShardsMax
	lookup["$resource"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$resourcePercent"] = manaPercent
	lookup["$comboPoints"] = soulShards
	lookup["$comboPointsMax"] = soulShardsMax
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaPercent"] = manaPercentRaw
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$soulShards"] = normalizedSoulShards
	lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourcePercent"] = manaPercentRaw
	lookupLogic["$comboPoints"] = normalizedSoulShards
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
end

local function UpdateSnapshot_Affliction()
	UpdateSnapshot()
end

local function UpdateSnapshot_Demonology()
	UpdateSnapshot()
end

local function UpdateSnapshot_Destruction()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warlock
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2Modified == nil then
		return
	end

	local function UpdateSoulShards(specSettings, specCacheSettings, normalizedResource2)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border
			local cpColor = specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = normalizedResource2 >= x

			if filled then
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, filled and 1 or 0, 1)
					shardNode:SetBorderColor(cpBorderColor)
					shardNode:SetColor(cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	local function UpdateSoulShardsAffliction(specSettings, specCacheSettings, normalizedResource2, spells)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border
			local cpColor = specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = normalizedResource2 >= x

			if filled then
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, filled and 1 or 0, 1)
					shardNode:SetBorderColor(cpBorderColor)
					shardNode:SetColor(cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	local function UpdateSoulShardsDestruction(specSettings, specCacheSettings, normalizedResource2)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border
			local cpColor = specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local fillValue = 0

			if normalizedResource2 >= x then
				fillValue = 1
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			elseif normalizedResource2 >= (x - 1) then
				-- Partial fill for Destruction
				fillValue = normalizedResource2 - (x - 1)
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, fillValue, 1)
					shardNode:SetBorderColor(cpBorderColor)
					shardNode:SetColor(cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.affliction
		local specCacheSettings = TRB.Data.specCache.affliction.settings
		UpdateSnapshot_Affliction()
		TRB.Functions.Bar:HideResourceBar()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsAffliction(specSettings, specCacheSettings, normalizedResource2, spells)
			end

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
		local specSettings = classSettings.demonology
		local specCacheSettings = TRB.Data.specCache.demonology.settings
		UpdateSnapshot_Demonology()
		TRB.Functions.Bar:HideResourceBar()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShards(specSettings, specCacheSettings, normalizedResource2)
			end

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
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.destruction
		local specCacheSettings = TRB.Data.specCache.destruction.settings
		UpdateSnapshot_Destruction()
		TRB.Functions.Bar:HideResourceBar()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsDestruction(specSettings, specCacheSettings, normalizedResource2)
			end

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
		specCache.affliction.talents:GetTalents()
		FillSpellData_Affliction()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.affliction)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Affliction
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.affliction.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "affliction" then
			talents = specCache.affliction.talents
			TRB.Data.barConstructedForSpec = "affliction"
			ConstructResourceBar(specCache.affliction.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.demonology.talents:GetTalents()
		FillSpellData_Demonology()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.demonology)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Demonology
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.demonology.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "demonology" then
			talents = specCache.demonology.talents
			TRB.Data.barConstructedForSpec = "demonology"
			ConstructResourceBar(specCache.demonology.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.destruction.talents:GetTalents()
		FillSpellData_Destruction()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.destruction)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Destruction
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.destruction.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "destruction" then
			talents = specCache.destruction.talents
			TRB.Data.barConstructedForSpec = "destruction"
			ConstructResourceBar(specCache.destruction.settings)
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
	
	if TRB.Data.character.classId == 9 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Warlock.LoadDefaultSettings(false)

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.affliction == nil or
						TwintopInsanityBarSettings.warlock.affliction.displayText == nil) then
						settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSettings()
					end

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.demonology == nil or
						TwintopInsanityBarSettings.warlock.demonology.displayText == nil) then
						settings.warlock.demonology.displayText.barText = TRB.Options.Warlock.DemonologyLoadDefaultBarTextSettings()
					end

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.destruction == nil or
						TwintopInsanityBarSettings.warlock.destruction.displayText == nil) then
						settings.warlock.destruction.displayText.barText = TRB.Options.Warlock.DestructionLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.warlock ~= true then
						TRB.Data.settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSettings()
						TRB.Data.settings.warlock.demonology.displayText.barText = TRB.Options.Warlock.DemonologyLoadDefaultBarTextSettings()
						TRB.Data.settings.warlock.destruction.displayText.barText = TRB.Options.Warlock.DestructionLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.warlock = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Warlock"])
					end
				else
					local settings = TRB.Options.Warlock.LoadDefaultSettings(true)
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
						TRB.Data.settings.warlock.affliction = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarlockAfflictionFull"], TRB.Data.settings.warlock.affliction)
						TRB.Data.settings.warlock.demonology = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarlockDemonologyFull"], TRB.Data.settings.warlock.demonology)
						TRB.Data.settings.warlock.destruction = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarlockDestructionFull"], TRB.Data.settings.warlock.destruction)

						FillSpellData_Affliction()
						FillSpellData_Demonology()
						FillSpellData_Destruction()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Warlock.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "warlock"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", TRB.Data.resource, false)
	TRB.Data.character.maxResource2 = UnitPowerMax("player", TRB.Data.resource2, false)
	TRB.Data.character.maxResource2Modified = UnitPowerMax("player", TRB.Data.resource2, true)
	TRB.Data.resource2 = Enum.PowerType.SoulShards
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2, false)
	local oldMaxResource2 = TRB.Data.character.maxResource2
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "affliction"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "demonology"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "destruction"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if sharedSettings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
			if barGroups and barGroups.secondary then
				barGroups.secondary:Show()
				TRB.Functions.Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.warlock.affliction == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.warlock.demonology == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.warlock.destruction == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
	else
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
			-- All Warlock specs use the secondary (Soul Shards) bar
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
				else
					barGroups.health:Hide()
				end
			end

			-- Track if any bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary or showHealth
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
			end
			if barGroups and barGroups.health then
				barGroups.health:Hide()
			end
			TRB.Functions.BarText:Hide(sharedSettings)
			snapshotData.attributes.isTracking = false
		end
	else
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
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		settings = TRB.Data.settings.warlock.affliction
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		settings = TRB.Data.settings.warlock.demonology
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
		settings = TRB.Data.settings.warlock.destruction
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Affliction
	elseif TRB.Data.character.specId == 2 then --Demonology
	elseif TRB.Data.character.specId == 3 then --Destruction
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
	elseif var == "$comboPoints" or var == "$soulShards" then
		valid = true
	elseif var == "$comboPointsMax"or var == "$soulShardsMax" then
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
	if not (barGroups and barGroups.primary) then
		return nil, true, false
	end

	local normalizedRelativeFrame = string.gsub(relativeToFrame or "", "_", "")
	if normalizedRelativeFrame == "Resource" or normalizedRelativeFrame == "ResourceBar" then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
			return primaryNode:GetResourceFrame(), true, isVisible
		end
		return nil, true, false
	end

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local shardNode = barGroups.secondary:GetNode(comboPoint)
			if shardNode then
				local isVisible = barGroups.secondary.isVisible and shardNode.isVisible
				return shardNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	if normalizedRelativeFrame == "HealthBar" then
		if barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetResourceFrame(), true, isVisible
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