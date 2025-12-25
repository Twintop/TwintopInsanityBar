local _, TRB = ...
if TRB.Data.character.classId ~= 6 then --Only do this if we're on an Death Knight!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	blood = TRB.Classes.SpecCache:New(),
	frost = TRB.Classes.SpecCache:New(),
	unholy = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function CalculateRunicPowerGain(runicPower)
	local modifier = 1.0
	return runicPower * modifier
end

local function CreateRune()
	local rune = {
		startTime = 0,
		duration = 0,
		ready = false,
		remaining = 0,
		percentage = 1
	}
	return rune
end

local function UpdateRune(runeIndex, refresh)
	local rune = TRB.Data.character.runes[runeIndex]

	if refresh == true then
		local startTime, duration, ready = GetRuneCooldown(runeIndex)
		rune.startTime = startTime
		rune.duration = duration
		rune.ready = ready

		if rune.ready then
			rune.remaining = 0
			rune.percentage = 1
		else
			local currentTime = GetTime()
			rune.remaining = (rune.startTime + rune.duration) - currentTime
			rune.percentage = 1 - (rune.remaining / rune.duration)
		end
	else
		if not rune.ready then
			local currentTime = GetTime()
			rune.remaining = (rune.startTime + rune.duration) - currentTime
			if rune.remaining <= 0 then
				rune.remaining = 0
				rune.ready = true
				rune.percentage = 1
			else
				rune.percentage = 1 - (rune.remaining / rune.duration)
			end
		end
	end
end

local function FillSpecializationCache()
	-- Blood
	specCache.blood.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.blood.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		runes = {
			[1] = CreateRune(),
			[2] = CreateRune(),
			[3] = CreateRune(),
			[4] = CreateRune(),
			[5] = CreateRune(),
			[6] = CreateRune(),
		}
	}
	
	---@type TRB.Classes.DeathKnight.BloodSpells
	specCache.blood.spellsData.spells = TRB.Classes.DeathKnight.BloodSpells:New()
	local spells = specCache.blood.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	
	specCache.blood.snapshotData.audio = {
	}

	specCache.blood.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Frost
	specCache.frost.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		}
	}

	specCache.frost.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		runes = {
			[1] = CreateRune(),
			[2] = CreateRune(),
			[3] = CreateRune(),
			[4] = CreateRune(),
			[5] = CreateRune(),
			[6] = CreateRune(),
		}
	}
	
	---@type TRB.Classes.DeathKnight.FrostSpells
	specCache.frost.spellsData.spells = TRB.Classes.DeathKnight.FrostSpells:New()
	local spells = specCache.frost.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
	---@type TRB.Classes.Snapshot
	specCache.frost.snapshotData.snapshots[spells.breathOfSindragosa.id] = TRB.Classes.Snapshot:New(spells.breathOfSindragosa)

	specCache.frost.snapshotData.audio = {
	}

	specCache.frost.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Unholy
	specCache.unholy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.unholy.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		runes = {
			[1] = CreateRune(),
			[2] = CreateRune(),
			[3] = CreateRune(),
			[4] = CreateRune(),
			[5] = CreateRune(),
			[6] = CreateRune(),
		}
	}
	
	---@type TRB.Classes.DeathKnight.UnholySpells
	specCache.unholy.spellsData.spells = TRB.Classes.DeathKnight.UnholySpells:New()

	specCache.unholy.snapshotData.audio = {
	}

	specCache.unholy.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Blood()
	TRB.Functions.Character:FillSpecializationCacheSettings("deathknight", "blood", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Blood using new OOP system
	TRB.Frames.barGroups = TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Blood()
	Setup_Blood()
	specCache.blood.spellsData:FillSpellData()
	local spells = specCache.blood.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.blood.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.blood.barTextVariables.values = {
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

		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false },
	}
end

local function Setup_Frost()
	TRB.Functions.Character:FillSpecializationCacheSettings("deathknight", "frost")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Frost using new OOP system
	TRB.Frames.barGroups = TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Frost()
	Setup_Frost()
	specCache.frost.spellsData:FillSpellData()
	local spells = specCache.frost.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]

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

		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false },
	}
end

local function Setup_Unholy()
	TRB.Functions.Character:FillSpecializationCacheSettings("deathknight", "unholy")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Unholy using new OOP system
	TRB.Frames.barGroups = TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Unholy()
	Setup_Unholy()
	specCache.unholy.spellsData:FillSpellData()
	local spells = specCache.unholy.spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.unholy.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.unholy.barTextVariables.values = {
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

		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false },
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
	
	if TRB.Data.character.specId == 1 then -- Blood
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Frost
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Unholy
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
	local barGroups = TRB.Frames.barGroups

	-- Construct thresholds on the BarNode (new system)
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

	-- Death Knight always uses the secondary bar for runes (always 6)
	if barGroups and barGroups.secondary then
		local maxRunes = TRB.Data.character.maxResource2 or 6
		barGroups.secondary:Show()
		barGroups.secondary:ShowNodes(maxRunes)
		for x = 1, maxRunes do
			local runeNode = barGroups.secondary:GetNode(x)
			if runeNode then
				runeNode:SetMinMax(0, 1)
			end
		end
	end

	-- Ensure legacy frames aren't displayed for this class module
	if TRB.Frames.resource2ContainerFrame then
		TRB.Frames.resource2ContainerFrame:Hide()
	end
	if TRB.Frames.barContainerFrame then
		TRB.Frames.barContainerFrame:Hide()
	end

	TRB.Functions.Class:CheckCharacter()
end

local function RefreshLookupData_Blood()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.deathknight.blood
	local sharedSettings = TRB.Data.specCache["blood"].settings
	local currentTime = GetTime()
	local normalizedRunicPower = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentRunicPowerColor = TRB.Data.settings.deathknight.blood.colors.text.current.color
	local castingRunicPowerColor = TRB.Data.settings.deathknight.blood.colors.text.casting.color

	--$runicPower
	local runicPowerPrecision = TRB.Data.settings.deathknight.frost.runicPowerPrecision or 1
	local currentRunicPower = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedRunicPower, runicPowerPrecision, "floor", true))
	
	--$runicPowerMax
	local runicPowerMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, runicPowerPrecision, "floor", true))
	
	local runes = TRB.Data.character.runes
	--$runeXTime
	local _rune1Time = runes[1].remaining
	local rune1Time = TRB.Functions.BarText:TimerPrecision(_rune1Time)
	local _rune2Time = runes[2].remaining
	local rune2Time = TRB.Functions.BarText:TimerPrecision(_rune2Time)
	local _rune3Time = runes[3].remaining
	local rune3Time = TRB.Functions.BarText:TimerPrecision(_rune3Time)
	local _rune4Time = runes[4].remaining
	local rune4Time = TRB.Functions.BarText:TimerPrecision(_rune4Time)
	local _rune5Time = runes[5].remaining
	local rune5Time = TRB.Functions.BarText:TimerPrecision(_rune5Time)
	local _rune6Time = runes[6].remaining
	local rune6Time = TRB.Functions.BarText:TimerPrecision(_rune6Time)

	--$runeXReady
	local _rune1Ready = runes[1].ready
	local _rune2Ready = runes[2].ready
	local _rune3Ready = runes[3].ready
	local _rune4Ready = runes[4].ready
	local _rune5Ready = runes[5].ready
	local _rune6Ready = runes[6].ready
	local _runesReadyCount = (_rune1Ready and 1 or 0) + (_rune2Ready and 1 or 0) + (_rune3Ready and 1 or 0) + (_rune4Ready and 1 or 0) + (_rune5Ready and 1 or 0) + (_rune6Ready and 1 or 0)
	local runesReadyCount = tostring(_runesReadyCount)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$runicPower"] = currentRunicPower
	lookup["$resource"] = currentRunicPower
	lookup["$runicPowerMax"] = runicPowerMax
	lookup["$resourceMax"] = runicPowerMax
	lookup["$rune1Time"] = rune1Time
	lookup["$rune2Time"] = rune2Time
	lookup["$rune3Time"] = rune3Time
	lookup["$rune4Time"] = rune4Time
	lookup["$rune5Time"] = rune5Time
	lookup["$rune6Time"] = rune6Time
	lookup["$rune1Ready"] = ""
	lookup["$rune2Ready"] = ""
	lookup["$rune3Ready"] = ""
	lookup["$rune4Ready"] = ""
	lookup["$rune5Ready"] = ""
	lookup["$rune6Ready"] = ""
	lookup["$runesReadyCount"] = runesReadyCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$runicPower"] = normalizedRunicPower
	lookupLogic["$resource"] = normalizedRunicPower
	lookupLogic["$rune1Time"] = _rune1Time
	lookupLogic["$rune2Time"] = _rune2Time
	lookupLogic["$rune3Time"] = _rune3Time
	lookupLogic["$rune4Time"] = _rune4Time
	lookupLogic["$rune5Time"] = _rune5Time
	lookupLogic["$rune6Time"] = _rune6Time
	lookupLogic["$rune1Ready"] = _rune1Ready
	lookupLogic["$rune2Ready"] = _rune2Ready
	lookupLogic["$rune3Ready"] = _rune3Ready
	lookupLogic["$rune4Ready"] = _rune4Ready
	lookupLogic["$rune5Ready"] = _rune5Ready
	lookupLogic["$rune6Ready"] = _rune6Ready
	lookupLogic["$runesReadyCount"] = _runesReadyCount
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Frost()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.deathknight.frost
	local sharedSettings = TRB.Data.specCache["frost"].settings
	local currentTime = GetTime()
	local normalizedRunicPower = snapshotData.attributes.resourceModified

	local currentRunicPowerColor = TRB.Data.settings.deathknight.frost.colors.text.current.color
	local castingRunicPowerColor = TRB.Data.settings.deathknight.frost.colors.text.casting.color

	--$runicPower
	local runicPowerPrecision = TRB.Data.settings.deathknight.frost.runicPowerPrecision or 1
	local currentRunicPower = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedRunicPower, runicPowerPrecision, "floor", true))
	
	--$runicPowerMax
	local runicPowerMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, runicPowerPrecision, "floor", true))
	
	local runes = TRB.Data.character.runes
	--$runeXTime
	local _rune1Time = runes[1].remaining
	local rune1Time = TRB.Functions.BarText:TimerPrecision(_rune1Time)
	local _rune2Time = runes[2].remaining
	local rune2Time = TRB.Functions.BarText:TimerPrecision(_rune2Time)
	local _rune3Time = runes[3].remaining
	local rune3Time = TRB.Functions.BarText:TimerPrecision(_rune3Time)
	local _rune4Time = runes[4].remaining
	local rune4Time = TRB.Functions.BarText:TimerPrecision(_rune4Time)
	local _rune5Time = runes[5].remaining
	local rune5Time = TRB.Functions.BarText:TimerPrecision(_rune5Time)
	local _rune6Time = runes[6].remaining
	local rune6Time = TRB.Functions.BarText:TimerPrecision(_rune6Time)

	--$runeXReady
	local _rune1Ready = runes[1].ready
	local _rune2Ready = runes[2].ready
	local _rune3Ready = runes[3].ready
	local _rune4Ready = runes[4].ready
	local _rune5Ready = runes[5].ready
	local _rune6Ready = runes[6].ready
	local _runesReadyCount = (_rune1Ready and 1 or 0) + (_rune2Ready and 1 or 0) + (_rune3Ready and 1 or 0) + (_rune4Ready and 1 or 0) + (_rune5Ready and 1 or 0) + (_rune6Ready and 1 or 0)
	local runesReadyCount = tostring(_runesReadyCount)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$runicPower"] = currentRunicPower
	lookup["$resource"] = currentRunicPower
	lookup["$runicPowerMax"] = runicPowerMax
	lookup["$resourceMax"] = runicPowerMax
	lookup["$rune1Time"] = rune1Time
	lookup["$rune2Time"] = rune2Time
	lookup["$rune3Time"] = rune3Time
	lookup["$rune4Time"] = rune4Time
	lookup["$rune5Time"] = rune5Time
	lookup["$rune6Time"] = rune6Time
	lookup["$rune1Ready"] = ""
	lookup["$rune2Ready"] = ""
	lookup["$rune3Ready"] = ""
	lookup["$rune4Ready"] = ""
	lookup["$rune5Ready"] = ""
	lookup["$rune6Ready"] = ""
	lookup["$runesReadyCount"] = runesReadyCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$runicPower"] = normalizedRunicPower
	lookupLogic["$resource"] = normalizedRunicPower
	lookupLogic["$rune1Time"] = _rune1Time
	lookupLogic["$rune2Time"] = _rune2Time
	lookupLogic["$rune3Time"] = _rune3Time
	lookupLogic["$rune4Time"] = _rune4Time
	lookupLogic["$rune5Time"] = _rune5Time
	lookupLogic["$rune6Time"] = _rune6Time
	lookupLogic["$rune1Ready"] = _rune1Ready
	lookupLogic["$rune2Ready"] = _rune2Ready
	lookupLogic["$rune3Ready"] = _rune3Ready
	lookupLogic["$rune4Ready"] = _rune4Ready
	lookupLogic["$rune5Ready"] = _rune5Ready
	lookupLogic["$rune6Ready"] = _rune6Ready
	lookupLogic["$runesReadyCount"] = _runesReadyCount
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Unholy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.deathknight.unholy
	local sharedSettings = TRB.Data.specCache["unholy"].settings
	local currentTime = GetTime()
	local normalizedRunicPower = snapshotData.attributes.resourceModified

	local currentRunicPowerColor = TRB.Data.settings.deathknight.unholy.colors.text.current.color
	local castingRunicPowerColor = TRB.Data.settings.deathknight.unholy.colors.text.casting.color

	--$runicPower
	local runicPowerPrecision = TRB.Data.settings.deathknight.frost.runicPowerPrecision or 1
	local currentRunicPower = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedRunicPower, runicPowerPrecision, "floor", true))
	
	--$runicPowerMax
	local runicPowerMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, runicPowerPrecision, "floor", true))
	
	local runes = TRB.Data.character.runes
	--$runeXTime
	local _rune1Time = runes[1].remaining
	local rune1Time = TRB.Functions.BarText:TimerPrecision(_rune1Time)
	local _rune2Time = runes[2].remaining
	local rune2Time = TRB.Functions.BarText:TimerPrecision(_rune2Time)
	local _rune3Time = runes[3].remaining
	local rune3Time = TRB.Functions.BarText:TimerPrecision(_rune3Time)
	local _rune4Time = runes[4].remaining
	local rune4Time = TRB.Functions.BarText:TimerPrecision(_rune4Time)
	local _rune5Time = runes[5].remaining
	local rune5Time = TRB.Functions.BarText:TimerPrecision(_rune5Time)
	local _rune6Time = runes[6].remaining
	local rune6Time = TRB.Functions.BarText:TimerPrecision(_rune6Time)

	--$runeXReady
	local _rune1Ready = runes[1].ready
	local _rune2Ready = runes[2].ready
	local _rune3Ready = runes[3].ready
	local _rune4Ready = runes[4].ready
	local _rune5Ready = runes[5].ready
	local _rune6Ready = runes[6].ready
	local _runesReadyCount = (_rune1Ready and 1 or 0) + (_rune2Ready and 1 or 0) + (_rune3Ready and 1 or 0) + (_rune4Ready and 1 or 0) + (_rune5Ready and 1 or 0) + (_rune6Ready and 1 or 0)
	local runesReadyCount = tostring(_runesReadyCount)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$runicPower"] = currentRunicPower
	lookup["$resource"] = currentRunicPower
	lookup["$runicPowerMax"] = runicPowerMax
	lookup["$resourceMax"] = runicPowerMax
	lookup["$rune1Time"] = rune1Time
	lookup["$rune2Time"] = rune2Time
	lookup["$rune3Time"] = rune3Time
	lookup["$rune4Time"] = rune4Time
	lookup["$rune5Time"] = rune5Time
	lookup["$rune6Time"] = rune6Time
	lookup["$rune1Ready"] = ""
	lookup["$rune2Ready"] = ""
	lookup["$rune3Ready"] = ""
	lookup["$rune4Ready"] = ""
	lookup["$rune5Ready"] = ""
	lookup["$rune6Ready"] = ""
	lookup["$runesReadyCount"] = runesReadyCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$runicPower"] = normalizedRunicPower
	lookupLogic["$resource"] = normalizedRunicPower
	lookupLogic["$rune1Time"] = _rune1Time
	lookupLogic["$rune2Time"] = _rune2Time
	lookupLogic["$rune3Time"] = _rune3Time
	lookupLogic["$rune4Time"] = _rune4Time
	lookupLogic["$rune5Time"] = _rune5Time
	lookupLogic["$rune6Time"] = _rune6Time
	lookupLogic["$rune1Ready"] = _rune1Ready
	lookupLogic["$rune2Ready"] = _rune2Ready
	lookupLogic["$rune3Ready"] = _rune3Ready
	lookupLogic["$rune4Ready"] = _rune4Ready
	lookupLogic["$rune5Ready"] = _rune5Ready
	lookupLogic["$rune6Ready"] = _rune6Ready
	lookupLogic["$runesReadyCount"] = _runesReadyCount
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell)
	local currentTime = GetTime()
	TRB.Data.snapshotData.casting.startTime = currentTime
	TRB.Data.snapshotData.casting.resourceRaw = spell.runicPower
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.runicPower)
	TRB.Data.snapshotData.casting.spellId = spell.id
	TRB.Data.snapshotData.casting.icon = spell.icon
end

local function UpdateCastingResourceFinal()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Blood()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	--local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	--local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw-- * innervate.modifier * potionOfChilledClarity.modifier
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()
	
	if TRB.Data.character.specId == 1 then
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.breathOfSindragosa.castId then
				snapshotData.snapshots[spells.breathOfSindragosa.id].cooldown:InitializeCustom(spells.breathOfSindragosa.cooldown, currentTime)
			end
		elseif event == "SPELL_UPDATE_ICON" then

		end
	elseif TRB.Data.character.specId == 3 then
	end	
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()
	
	for x = 1, TRB.Data.character.maxResource2 do
		UpdateRune(x, true)
	end
	
	local specSettings = TRB.Data.settings.deathknight[TRB.Data.barConstructedForSpec]
	local runes = TRB.Data.character.runes
	if specSettings.colors.comboPoints.sortRunes == true then
		-- Sort: ready runes first, then by percentage (high to low)
		table.sort(runes, function(a, b)
			if a.ready ~= b.ready then
				return a.ready -- true comes before false
			end
			return a.percentage > b.percentage
		end)
	end
end

local function UpdateSnapshot_Blood()
	UpdateSnapshot()
end

local function UpdateSnapshot_Frost()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	snapshotData.snapshots[spells.breathOfSindragosa.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Unholy()
	UpdateSnapshot()
end

---Updates the rune display
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateRunes(specSettings, specCacheSettings)
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

	local runes = TRB.Data.character.runes
	local barGroups = TRB.Frames.barGroups
	
	for x = 1, TRB.Data.character.maxResource2 do
		local rune = runes[x]
		local cpBorderColor = specSettings.colors.comboPoints.border
		local cpColor = specSettings.colors.comboPoints.base
		local cpBR = cpBackgroundRed
		local cpBG = cpBackgroundGreen
		local cpBB = cpBackgroundBlue

		if not rune.ready then
			cpColor = specSettings.colors.comboPoints.cooldown
		end
		

		if barGroups and barGroups.secondary then
			local runeNode = barGroups.secondary:GetNode(x)
			if runeNode then
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "rune" .. x, runeNode, rune.percentage, 1)
				runeNode:SetBorderColor(cpBorderColor)
				runeNode:SetColor(cpColor)
				runeNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
			end
		end
	end
end

local function UpdateResourceBar()
	local refreshText = false
	local classSettings = TRB.Data.settings.deathknight
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	local primaryResourceFrame = primaryNode:GetResourceFrame()

	local function UpdateForSpec(specKey, specSettings)
		local specCacheSettings = TRB.Data.specCache[specKey].settings

		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
						TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end

					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end

					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				UpdateRunes(specSettings, specCacheSettings)
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	end

	if TRB.Data.character.specId == 1 then
		UpdateSnapshot_Blood()
		UpdateForSpec("blood", classSettings.blood)
	elseif TRB.Data.character.specId == 2 then
		UpdateSnapshot_Frost()
		UpdateForSpec("frost", classSettings.frost)
	elseif TRB.Data.character.specId == 3 then
		UpdateSnapshot_Unholy()
		UpdateForSpec("unholy", classSettings.unholy)
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
		specCache.blood.talents:GetTalents()
		FillSpellData_Blood()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.blood)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Blood
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.blood.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.deathknight.blood)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "blood" then
			talents = specCache.blood.talents
			TRB.Data.barConstructedForSpec = "blood"
			ConstructResourceBar(specCache.blood.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.frost.talents:GetTalents()
		FillSpellData_Frost()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.frost)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Frost
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.frost.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.deathknight.frost)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "frost" then
			talents = specCache.frost.talents
			TRB.Data.barConstructedForSpec = "frost"
			ConstructResourceBar(specCache.frost.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.unholy.talents:GetTalents()
		FillSpellData_Unholy()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.unholy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unholy
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.unholy.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.deathknight.unholy)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "unholy" then
			talents = specCache.unholy.talents
			TRB.Data.barConstructedForSpec = "unholy"
			ConstructResourceBar(specCache.unholy.settings)
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

TRB.Frames.resourceFrame:RegisterEvent("ADDON_LOADED")
TRB.Frames.resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
TRB.Frames.resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
TRB.Frames.resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TRB.Frames.resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
TRB.Frames.resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end
	
	if TRB.Data.character.classId == 6 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.DeathKnight.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.deathknight == nil or
						TwintopInsanityBarSettings.deathknight.blood == nil or
						TwintopInsanityBarSettings.deathknight.blood.displayText == nil then
						settings.deathknight.blood.displayText.barText = TRB.Options.DeathKnight.BloodLoadDefaultBarTextSimpleSettings()
					elseif TwintopInsanityBarSettings.deathknight == nil or
						TwintopInsanityBarSettings.deathknight.frost == nil or
						TwintopInsanityBarSettings.deathknight.frost.displayText == nil then
						settings.deathknight.frost.displayText.barText = TRB.Options.DeathKnight.FrostLoadDefaultBarTextSimpleSettings()
					elseif TwintopInsanityBarSettings.deathknight == nil or
						TwintopInsanityBarSettings.deathknight.unholy == nil or
						TwintopInsanityBarSettings.deathknight.unholy.displayText == nil then
						settings.deathknight.unholy.displayText.barText = TRB.Options.DeathKnight.UnholyLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.DeathKnight.LoadDefaultSettings(true)
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
						TRB.Data.settings.deathknight.blood = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DeathKnightBloodFull"], TRB.Data.settings.deathknight.blood)
						TRB.Data.settings.deathknight.frost = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DeathKnightFrostFull"], TRB.Data.settings.deathknight.frost)
						TRB.Data.settings.deathknight.unholy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DeathKnightUnholyFull"], TRB.Data.settings.deathknight.unholy)
						
						FillSpellData_Blood()
						FillSpellData_Frost()
						FillSpellData_Unholy()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.DeathKnight.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "deathknight"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.RunicPower, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.RunicPower, false)
	TRB.Data.character.maxResource2 = 6 -- Death Knights always have 6 runes
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "blood"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "frost"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "unholy"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if sharedSettings ~= nil then
		local barGroups = TRB.Frames.barGroups
		if barGroups and barGroups.secondary then
			barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.deathknight.blood then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.deathknight.blood)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.RunicPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = Enum.PowerType.Runes
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.deathknight.frost then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.deathknight.frost)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.RunicPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = Enum.PowerType.Runes
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.deathknight.unholy then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.deathknight.unholy)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.RunicPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = Enum.PowerType.Runes
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 0
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		if sharedSettings ~= nil then
			local affectingCombat = TRB.Data.character.inCombat
			if not TRB.Data.specSupported or force or
				(TRB.Data.character.advancedFlight and not sharedSettings.displayBar.dragonriding) or
				((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not sharedSettings.displayBar.alwaysShow))) then
				if barGroups and barGroups.primary then
					barGroups.primary:Hide()
				end
				if barGroups and barGroups.secondary then
					barGroups.secondary:Hide()
				end
				TRB.Functions.BarText:Hide(sharedSettings)
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if sharedSettings.displayBar.neverShow == true then
					if barGroups and barGroups.primary then
						barGroups.primary:Hide()
					end
					if barGroups and barGroups.secondary then
						barGroups.secondary:Hide()
					end
					TRB.Functions.BarText:Hide(sharedSettings)
				else
					if barGroups and barGroups.primary then
						barGroups.primary:Show()
					end
					if barGroups and barGroups.secondary then
						barGroups.secondary:Show()
						barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
					end
					TRB.Functions.BarText:Show(sharedSettings)
				end
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.deathknight.blood
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.deathknight.frost
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.deathknight.unholy
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Blood
		-- No spec-specific variables for Blood currently
	elseif TRB.Data.character.specId == 2 then --Frost
		-- No spec-specific variables for Frost currently
	elseif TRB.Data.character.specId == 3 then --Unholy
		-- No spec-specific variables for Unholy currently
	end

	--Spec agnostic
	if var == "$resource" or var == "$runicPower" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$runicPowerMax" then
		valid = true
	elseif var == "$rune1Time" then
		if TRB.Data.character.runes[1].remaining > 0 then
			valid = true
		end
	elseif var == "$rune2Time" then
		if TRB.Data.character.runes[2].remaining > 0 then
			valid = true
		end
	elseif var == "$rune3Time" then
		if TRB.Data.character.runes[3].remaining > 0 then
			valid = true
		end
	elseif var == "$rune4Time" then
		if TRB.Data.character.runes[4].remaining > 0 then
			valid = true
		end
	elseif var == "$rune5Time" then
		if TRB.Data.character.runes[5].remaining > 0 then
			valid = true
		end
	elseif var == "$rune6Time" then
		if TRB.Data.character.runes[6].remaining > 0 then
			valid = true
		end
	elseif var == "$rune1Ready" then
		if TRB.Data.character.runes[1].ready then
			valid = true
		end
	elseif var == "$rune2Ready" then
		if TRB.Data.character.runes[2].ready then
			valid = true
		end
	elseif var == "$rune3Ready" then
		if TRB.Data.character.runes[3].ready then
			valid = true
		end
	elseif var == "$rune4Ready" then
		if TRB.Data.character.runes[4].ready then
			valid = true
		end
	elseif var == "$rune5Ready" then
		if TRB.Data.character.runes[5].ready then
			valid = true
		end
	elseif var == "$rune6Ready" then
		if TRB.Data.character.runes[6].ready then
			valid = true
		end
	elseif var == "$runesReadyCount" then
		for x = 1, TRB.Data.character.maxResource2 do
			if TRB.Data.character.runes[x].ready then
				valid = true
				break
			end
		end
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups
	if relativeToFrame ~= nil then
		relativeToFrame = string.gsub(relativeToFrame, "_", "")
	end
	if relativeToFrame == "ResourceBar" or relativeToFrame == "Resource" then
		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				return primaryNode:GetResourceFrame(), true
			end
		end
	elseif relativeToFrame ~= nil then
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local runeNode = barGroups.secondary:GetNode(index)
				if runeNode then
					return runeNode:GetResourceFrame(), true
				end
			end
		end
	end
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end