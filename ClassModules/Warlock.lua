local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on an Warlock!
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
			passive = 0,
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
		nightfallCue = false,
		tormentedCrescendoCue = false,
		tormentedCrescendo2Cue = false
	}

	specCache.affliction.barTextVariables = {
		icons = {},
		values = {}
	}
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.nightfall.id] = TRB.Classes.Snapshot:New(spells.nightfall)
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.tormentedCrescendo.id] = TRB.Classes.Snapshot:New(spells.tormentedCrescendo)
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.malignOmen.id] = TRB.Classes.Snapshot:New(spells.malignOmen)
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.succulentSoul.id] = TRB.Classes.Snapshot:New(spells.succulentSoul)

	-- Demonology
	specCache.demonology.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
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
			passive = 0,
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
	TRB.Functions.Character:FillSpecializationCacheSettings("warlock", "affliction")
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
				
		{ variable = "#agony", icon = spells.agony.icon, description = spells.agony.name, printInSettings = true },
		{ variable = "#corruption", icon = spells.corruption.icon, description = spells.corruption.name, printInSettings = true },
		{ variable = "#haunt", icon = spells.haunt.icon, description = spells.haunt.name, printInSettings = true },
		{ variable = "#malignOmen", icon = spells.malignOmen.icon, description = spells.malignOmen.name, printInSettings = true },
		{ variable = "#nightfall", icon = spells.nightfall.icon, description = spells.nightfall.name, printInSettings = true },
		{ variable = "#phantomSingularity", icon = spells.phantomSingularity.icon, description = spells.phantomSingularity.name, printInSettings = true },
		{ variable = "#shadowEmbrace", icon = spells.shadowEmbraceShadowBolt.icon, description = spells.shadowEmbraceShadowBolt.name, printInSettings = true },
		{ variable = "#soulRot", icon = spells.soulRot.icon, description = spells.soulRot.name, printInSettings = true },
		{ variable = "#succulentSoul", icon = spells.succulentSoul.icon, description = spells.succulentSoul.name, printInSettings = true },
		{ variable = "#tormentedCrescendo", icon = spells.tormentedCrescendo.icon, description = spells.tormentedCrescendo.name, printInSettings = true },
		{ variable = "#ua", icon = spells.unstableAffliction.icon, description = spells.unstableAffliction.name, printInSettings = true },
		{ variable = "#vileTaint", icon = spells.vileTaint.icon, description = spells.vileTaint.name, printInSettings = true },
		{ variable = "#wither", icon = spells.wither.icon, description = spells.wither.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

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
		
		--[[
		{ variable = "$phantomSingularityTime", description = L["WarlockAfflictionBarTextVariable_phantomSingularityTime"], printInSettings = true, color = false },

		{ variable = "$nightfallTime", description = L["WarlockAfflictionBarTextVariable_nightfallTime"], printInSettings = true, color = false },
		{ variable = "$nightfallStacks", description = L["WarlockAfflictionBarTextVariable_nightfallStacks"], printInSettings = true, color = false },
		{ variable = "$tormentedCrescendoTime", description = L["WarlockAfflictionBarTextVariable_tormentedCrescendoTime"], printInSettings = true, color = false },
		{ variable = "$tormentedCrescendoStacks", description = L["WarlockAfflictionBarTextVariable_tormentedCrescendoStacks"], printInSettings = true, color = false },
		{ variable = "$succulentSoulTime", description = L["WarlockAfflictionBarTextVariable_succulentSoulTime"], printInSettings = true, color = false },
		{ variable = "$succulentSoulStacks", description = L["WarlockAfflictionBarTextVariable_succulentSoulStacks"], printInSettings = true, color = false },
		{ variable = "$malignOmenTime", description = L["WarlockAfflictionBarTextVariable_malignOmenTime"], printInSettings = true, color = false },
		{ variable = "$malignOmenStacks", description = L["WarlockAfflictionBarTextVariable_malignOmenStacks"], printInSettings = true, color = false },]]
	}
end

local function Setup_Demonology()
	TRB.Functions.Character:FillSpecializationCacheSettings("warlock", "demonology")
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

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
	TRB.Functions.Character:FillSpecializationCacheSettings("warlock", "destruction")
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
		{ variable = "$versatility", description = L["BarTextVariableVersatility"], printInSettings = true, color = false },
		{ variable = "$versatilityPercent", description = L["BarTextVariableVersatility"], printInSettings = false, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersatilityRating"], printInSettings = true, color = false },
		
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
	for _, v in pairs(resourceFrame.thresholds) do
		v:Hide();
	end

	for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
		if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
			TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
		end
		TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
	end

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		TRB.Functions.Bar:Construct(settings)
	end
	TRB.Frames.resource2ContainerFrame:Show()
	
	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
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
	local manaPrecision = specSettings.manaPrecision or 1
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

	--[[	
	--$shadowEmbraceStacks $shadowEmbraceTime
	local shadowEmbrace = spells.shadowEmbraceShadowBolt
	if talents:IsTalentActive(spells.drainSoul) then
		shadowEmbrace = spells.shadowEmbraceDrainSoul
	end

	local _shadowEmbraceStacks = snapshotData.targetData.trackedSpells[shadowEmbrace.id].stacks or 0
	local shadowEmbraceStacks
	local _shadowEmbraceMaxStacks = shadowEmbrace.attributes.maxStacks
	local shadowEmbraceMaxStacks = string.format("%s", _shadowEmbraceMaxStacks)
	local _shadowEmbraceTime = 0
	local shadowEmbraceTime
	if target ~= nil then
		_shadowEmbraceStacks = target.spells[shadowEmbrace.id].stacks or 0
		_shadowEmbraceTime = target.spells[shadowEmbrace.id].remainingTime or 0
	end	
	shadowEmbraceTime = TRB.Functions.BarText:TimerPrecision(_shadowEmbraceTime)
	shadowEmbraceStacks = string.format("%s", _shadowEmbraceStacks)

	--$nightfallTime
	local _nightfallTime = snapshotData.snapshots[spells.nightfall.id].buff:GetRemainingTime(currentTime)
	local nightfallTime = TRB.Functions.BarText:TimerPrecision(_nightfallTime)
	
	--$nightfallStacks
	local _nightfallStacks = snapshotData.snapshots[spells.nightfall.id].buff.applications or 0
	local nightfallStacks = string.format("%s", _nightfallStacks)

	--$tormentedCrescendoTime
	local _tormentedCrescendoTime = snapshotData.snapshots[spells.tormentedCrescendo.id].buff:GetRemainingTime(currentTime)
	local tormentedCrescendoTime =  TRB.Functions.BarText:TimerPrecision(_tormentedCrescendoTime)
	
	--$tormentedCrescendoStacks
	local _tormentedCrescendoStacks = snapshotData.snapshots[spells.tormentedCrescendo.id].buff.applications or 0
	local tormentedCrescendoStacks = string.format("%.0f", _tormentedCrescendoStacks)
	
	--$succulentSoulTime
	local _succulentSoulTime = snapshotData.snapshots[spells.succulentSoul.id].buff:GetRemainingTime()
	local succulentSoulTime =  TRB.Functions.BarText:TimerPrecision(_succulentSoulTime)
	
	--$succulentSoulStacks
	local _succulentSoulStacks = snapshotData.snapshots[spells.succulentSoul.id].buff.applications or 0
	local succulentSoulStacks = string.format("%.0f", _succulentSoulStacks)
	
	--$malignOmenTime
	local _malignOmenTime = snapshotData.snapshots[spells.malignOmen.id].buff:GetRemainingTime()
	local malignOmenTime =  TRB.Functions.BarText:TimerPrecision(_malignOmenTime)
	
	--$malignOmenStacks
	local _malignOmenStacks = snapshotData.snapshots[spells.malignOmen.id].buff.applications or 0
	local malignOmenStacks = string.format("%.0f", _malignOmenStacks)]]
	
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
	--[[
	lookup["$tormentedCrescendoTime"] = tormentedCrescendoTime
	lookup["$tormentedCrescendoStacks"] = tormentedCrescendoStacks
	lookup["$nightfallTime"] = nightfallTime
	lookup["$nightfallStacks"] = nightfallStacks
	lookup["$succulentSoulTime"] = succulentSoulTime
	lookup["$succulentSoulStacks"] = succulentSoulStacks
	lookup["$malignOmenTime"] = malignOmenTime
	lookup["$malignOmenStacks"] = malignOmenStacks
	lookup["$shadowEmbraceStacks"] = shadowEmbraceStacks
	lookup["$shadowEmbraceMaxStacks"] = shadowEmbraceMaxStacks
	lookup["$shadowEmbraceTime"] = shadowEmbraceTime]]
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
	--[[
	lookupLogic["$tormentedCrescendoTime"] = _tormentedCrescendoTime
	lookupLogic["$tormentedCrescendoStacks"] = _tormentedCrescendoStacks
	lookupLogic["$succulentSoulTime"] = _succulentSoulTime
	lookupLogic["$succulentSoulStacks"] = _succulentSoulStacks
	lookupLogic["$malignOmenTime"] = _malignOmenTime
	lookupLogic["$malignOmenStacks"] = _malignOmenStacks
	lookupLogic["$shadowEmbraceStacks"] = _shadowEmbraceStacks
	lookupLogic["$shadowEmbraceMaxStacks"] = _shadowEmbraceMaxStacks
	lookupLogic["$shadowEmbraceTime"] = _shadowEmbraceTime]]
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
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, true)
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
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, true)
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

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.affliction
		local specCacheSettings = TRB.Data.specCache.affliction.settings
		UpdateSnapshot_Affliction()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)

				barContainerFrame:SetAlpha(1.0)

				if snapshots[spells.nightfall.id].buff.isActive then
					if specSettings.colors.bar.nightfall.enabled then
						barBorderColor = specSettings.colors.bar.nightfall.color
					end

					if specSettings.audio.nightfall.enabled and snapshotData.audio.nightfallCue == false then
						snapshotData.audio.nightfallCue = true
						PlaySoundFile(specSettings.audio.nightfall.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.nightfallCue = false
				end

				if snapshots[spells.tormentedCrescendo.id].buff.isActive then
					if specSettings.colors.bar.tormentedCrescendo.enabled then
						barBorderColor = specSettings.colors.bar.tormentedCrescendo.color
					end

					if snapshots[spells.tormentedCrescendo.id].buff.applications == 1 and specSettings.audio.tormentedCrescendo.enabled and not snapshotData.audio.tormentedCrescendoCue then
						snapshotData.audio.tormentedCrescendoCue = true
						PlaySoundFile(specSettings.audio.tormentedCrescendo.sound, coreSettings.audio.channel.channel)
					elseif	snapshots[spells.tormentedCrescendo.id].buff.applications == 2 and specSettings.audio.tormentedCrescendo2.enabled and not snapshotData.audio.tormentedCrescendo2Cue then
						snapshotData.audio.tormentedCrescendo2Cue = true
						PlaySoundFile(specSettings.audio.tormentedCrescendo2.sound, coreSettings.audio.channel.channel)
					end
				end
				
				local shadowEmbrace = spells.shadowEmbraceShadowBolt
				if talents:IsTalentActive(spells.drainSoul) then
					shadowEmbrace = spells.shadowEmbraceDrainSoul
				end

				--[[if specSettings.colors.bar.shadowEmbraceNotMax.enabled and talents:IsTalentActive(shadowEmbrace) and target ~= nil and
					not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") and
					target.spells[shadowEmbrace.id].stacks < shadowEmbrace.attributes.maxStacks then
					barColor = specSettings.colors.bar.shadowEmbraceNotMax.color
				end]]
				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if normalizedResource2 >= x then
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					if specSettings.colors.comboPoints.malignOmen.enabled and snapshotData.snapshots[spells.malignOmen.id].buff.isActive then
						if x <= normalizedResource2 and snapshotData.snapshots[spells.malignOmen.id].buff.applications > (normalizedResource2 - x) then
							cpColor = specSettings.colors.comboPoints.malignOmen.color
						elseif not specSettings.colors.comboPoints.consistentUnfilledColor and x > normalizedResource2 and x <= snapshotData.snapshots[spells.malignOmen.id].buff.applications then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.malignOmen.color, true)
						end
					end

					if specSettings.colors.comboPoints.succulentSoul.enabled and snapshotData.snapshots[spells.succulentSoul.id].buff.isActive then
						if x <= normalizedResource2 and snapshotData.snapshots[spells.succulentSoul.id].buff.applications > (normalizedResource2 - x) then
							cpBorderColor = specSettings.colors.comboPoints.succulentSoul.color
						elseif x > normalizedResource2 and x <= snapshotData.snapshots[spells.succulentSoul.id].buff.applications then
							cpBorderColor = specSettings.colors.comboPoints.succulentSoul.color
						end
					end

					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[x].borderFrame, "comboPoint" .. x, cpBorderColor)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[x].resourceFrame, "comboPoint" .. x, cpColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[x].containerFrame, "comboPoint" .. x, cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.demonology
		local specCacheSettings = TRB.Data.specCache.demonology.settings
		UpdateSnapshot_Demonology()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if normalizedResource2 >= x then
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[x].borderFrame, "comboPoint" .. x, cpBorderColor)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[x].resourceFrame, "comboPoint" .. x, cpColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[x].containerFrame, "comboPoint" .. x, cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.destruction
		local specCacheSettings = TRB.Data.specCache.destruction.settings
		UpdateSnapshot_Destruction()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if normalizedResource2 >= x then
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					elseif normalizedResource2 >= (x - 1) then
						-- Partial fill
						local partialValue = normalizedResource2 - (x - 1)
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, partialValue, 1)
					else
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[x].borderFrame, "comboPoint" .. x, cpBorderColor)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[x].resourceFrame, "comboPoint" .. x, cpColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[x].containerFrame, "comboPoint" .. x, cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warlock.affliction)
		--[[
		targetData:AddSpellTracking(spells.shadowEmbraceShadowBolt)
		targetData:AddSpellTracking(spells.shadowEmbraceDrainSoul)]]

		local lookup = TRB.Data.lookup or {}
		lookup["#ua"] = spells.unstableAffliction.icon
		lookup["#agony"] = spells.agony.icon
		lookup["#corruption"] = spells.corruption.icon
		lookup["#haunt"] = spells.haunt.icon
		lookup["#vileTaint"] = spells.vileTaint.icon
		lookup["#soulRot"] = spells.soulRot.icon
		lookup["#phantomSingularity"] = spells.phantomSingularity.icon
		lookup["#nightfall"] = spells.nightfall.icon
		lookup["#tormentedCrescendo"] = spells.tormentedCrescendo.icon
		lookup["#succulentSoul"] = spells.succulentSoul.icon
		lookup["#malignOmen"] = spells.malignOmen.icon
		lookup["#shadowEmbrace"] = spells.shadowEmbraceShadowBolt.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warlock.demonology)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warlock.destruction)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
						settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSimpleSettings()
					end

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.demonology == nil or
						TwintopInsanityBarSettings.warlock.demonology.displayText == nil) then
						settings.warlock.demonology.displayText.barText = TRB.Options.Warlock.DemonologyLoadDefaultBarTextSimpleSettings()
					end

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.destruction == nil or
						TwintopInsanityBarSettings.warlock.destruction.displayText == nil) then
						settings.warlock.destruction.displayText.barText = TRB.Options.Warlock.DestructionLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
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
		--if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
		--end
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

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 3
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
		--[[if var == "$nightfallTime" then
			if snapshots[spells.nightfall.id].buff.isActive then
				valid = true
			end
		elseif var == "$nightfallStacks" then
			if snapshots[spells.nightfall.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$tormentedCrescendoTime" then
			if snapshots[spells.tormentedCrescendo.id].buff.isActive then
				valid = true
			end
		elseif var == "$tormentedCrescendoStacks" then
			if snapshots[spells.tormentedCrescendo.id].buff.isActive then
				valid = true
			end
		elseif var == "$malignOmenTime" then
			if snapshots[spells.malignOmen.id].buff.isActive then
				valid = true
			end
		elseif var == "$malignOmenStacks" then
			if snapshots[spells.malignOmen.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$succulentSoulTime" then
			if snapshots[spells.succulentSoul.id].buff.isActive then
				valid = true
			end
		elseif var == "$succulentSoulStacks" then
			if snapshots[spells.succulentSoul.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$shadowEmbraceStacks" then
			local shadowEmbrace = spells.shadowEmbraceShadowBolt
			if talents:IsTalentActive(spells.drainSoul) then
				shadowEmbrace = spells.shadowEmbraceDrainSoul
			end
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[shadowEmbrace.id] ~= nil and
			target.spells[shadowEmbrace.id].stacks > 0 then
				valid = true
			end
		elseif var == "$shadowEmbraceMaxStacks" then
			valid = true
		elseif var == "$shadowEmbraceTime" then
			local shadowEmbrace = spells.shadowEmbraceShadowBolt
			if talents:IsTalentActive(spells.drainSoul) then
				shadowEmbrace = spells.shadowEmbraceDrainSoul
			end
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[shadowEmbrace.id] ~= nil and
			target.spells[shadowEmbrace.id].remainingTime > 0 then
			valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 2 then --Demonology
	elseif TRB.Data.character.specId == 3 then --Destruction
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
	elseif var == "$comboPoints" or var == "$soulShards" then
		valid = true
	elseif var == "$comboPointsMax"or var == "$soulShardsMax" then
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