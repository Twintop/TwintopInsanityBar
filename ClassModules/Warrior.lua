local _, TRB = ...
if TRB.Data.character.classId ~= 1 then --Only do this if we're on a Warrior!
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
	arms = TRB.Classes.SpecCache:New(),
	fury = TRB.Classes.SpecCache:New(),
	protection = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Arms
	specCache.arms.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			passive = 0
		}
	}

	specCache.arms.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		effects = {
		},
		pandemicModifier = 0
	}

	---@type TRB.Classes.Warrior.ArmsSpells
	specCache.arms.spellsData.spells = TRB.Classes.Warrior.ArmsSpells:New()
	local spells = specCache.arms.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]

	specCache.arms.snapshotData.audio = {
	}
	--[[---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.execute.id] = TRB.Classes.Snapshot:New(spells.execute)]]
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.shieldBlock.id] = TRB.Classes.Snapshot:New(spells.shieldBlock)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.impendingVictory.id] = TRB.Classes.Snapshot:New(spells.impendingVictory)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.thunderClap.id] = TRB.Classes.Snapshot:New(spells.thunderClap)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.mortalStrike.id] = TRB.Classes.Snapshot:New(spells.mortalStrike)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.cleave.id] = TRB.Classes.Snapshot:New(spells.cleave)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.ignorePain.id] = TRB.Classes.Snapshot:New(spells.ignorePain)
	--[[---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.suddenDeath.id] = TRB.Classes.Snapshot:New(spells.suddenDeath)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.stormOfSwords.id] = TRB.Classes.Snapshot:New(spells.stormOfSwords)
	---@type TRB.Classes.Snapshot
	specCache.arms.snapshotData.snapshots[spells.ravager.id] = TRB.Classes.Snapshot:New(spells.ravager)]]

	-- Fury

	specCache.fury.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			passive = 0,
			ravager = 0
		},
		ravager = {
			rage = 0,
			ticks = 0
		}
	}

	specCache.fury.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		}
	}

	---@type TRB.Classes.Warrior.FurySpells
	specCache.fury.spellsData.spells = TRB.Classes.Warrior.FurySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.fury.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]

	specCache.fury.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.shieldBlock.id] = TRB.Classes.Snapshot:New(spells.shieldBlock)
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.thunderClap.id] = TRB.Classes.Snapshot:New(spells.thunderClap)
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.impendingVictory.id] = TRB.Classes.Snapshot:New(spells.impendingVictory)
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.enrage.id] = TRB.Classes.Snapshot:New(spells.enrage)
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.whirlwind.id] = TRB.Classes.Snapshot:New(spells.whirlwind)
	--[[---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.ravager.id] = TRB.Classes.Snapshot:New(spells.ravager)]]
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.bladestorm.id] = TRB.Classes.Snapshot:New(spells.bladestorm)
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.execute.id] = TRB.Classes.Snapshot:New(spells.execute)
	---@type TRB.Classes.Snapshot
	specCache.fury.snapshotData.snapshots[spells.suddenDeath.id] = TRB.Classes.Snapshot:New(spells.suddenDeath)

	-- Protection
	specCache.protection.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			passive = 0
		}
	}

	specCache.protection.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		effects = {
		},
		pandemicModifier = 0
	}

	---@type TRB.Classes.Warrior.ProtectionSpells
	specCache.protection.spellsData.spells = TRB.Classes.Warrior.ProtectionSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.protection.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

	specCache.protection.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.protection.snapshotData.snapshots[spells.impendingVictory.id] = TRB.Classes.Snapshot:New(spells.impendingVictory)
	---@type TRB.Classes.Snapshot
	specCache.protection.snapshotData.snapshots[spells.ignorePain.id] = TRB.Classes.Snapshot:New(spells.ignorePain)
	--[[---@type TRB.Classes.Snapshot
	specCache.protection.snapshotData.snapshots[spells.ravager.id] = TRB.Classes.Snapshot:New(spells.ravager)]]
	---@type TRB.Classes.Snapshot
	specCache.protection.snapshotData.snapshots[spells.shieldBlock.id] = TRB.Classes.Snapshot:New(spells.shieldBlock)
	--[[---@type TRB.Classes.Snapshot
	specCache.protection.snapshotData.snapshots[spells.shieldBlock.buffId] = TRB.Classes.Snapshot:New(spells.shieldBlock)]]
	---@type TRB.Classes.Snapshot
	specCache.protection.snapshotData.snapshots[spells.suddenDeath.id] = TRB.Classes.Snapshot:New(spells.suddenDeath)
end

local function Setup_Arms()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "arms")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Arms using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Arms()
	Setup_Arms()
	specCache.arms.spellsData:FillSpellData()
	local spells = specCache.arms.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.arms.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		{ variable = "#cleave", icon = spells.cleave.icon, description = spells.cleave.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		{ variable = "#mortalStrike", icon = spells.mortalStrike.icon, description = spells.mortalStrike.name, printInSettings = true },
		{ variable = "#rend", icon = spells.rend.icon, description = spells.rend.name, printInSettings = true },
		{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = spells.shieldBlock.name, printInSettings = true },
		{ variable = "#slam", icon = spells.slam.icon, description = spells.slam.name, printInSettings = true },
		{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = spells.whirlwind.name, printInSettings = true },

		--[[{ variable = "#charge", icon = spells.charge.icon, description = spells.charge.name, printInSettings = true },]]
	}
	specCache.arms.barTextVariables.values = {
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

		{ variable = "$rage", description = L["WarriorArmsBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["WarriorArmsBarTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Fury()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "fury")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Fury using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Fury()
	Setup_Fury()
	specCache.fury.spellsData:FillSpellData()
	local spells = specCache.fury.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.fury.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#bladestorm", icon = spells.bladestorm.icon, description = spells.bladestorm.name, printInSettings = true },
		{ variable = "#charge", icon = spells.charge.icon, description = spells.charge.name, printInSettings = true },
		{ variable = "#enrage", icon = spells.enrage.icon, description = spells.enrage.name, printInSettings = true },
		{ variable = "#execute", icon = spells.execute.icon, description = spells.execute.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = spells.shieldBlock.name, printInSettings = true },
		{ variable = "#slam", icon = spells.slam.icon, description = spells.slam.name, printInSettings = true },
		{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = spells.whirlwind.name, printInSettings = true }
	}

	specCache.fury.barTextVariables.values = {
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

		{ variable = "$rage", description = L["WarriorFuryBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["WarriorFuryBarTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Protection()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "protection", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Protection using new OOP system (includes secondary for defensive buffs)
	TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Protection()
	Setup_Protection()
	specCache.protection.spellsData:FillSpellData()
	local spells = specCache.protection.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.protection.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		
		{ variable = "#ignorePain", icon = spells.ignorePain.icon, description = spells.ignorePain.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		{ variable = "#rend", icon = spells.rend.icon, description = spells.rend.name, printInSettings = true },
		{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = spells.shieldBlock.name, printInSettings = true },
		{ variable = "#slam", icon = spells.slam.icon, description = spells.slam.name, printInSettings = true },
		{ variable = "#suddenDeath", icon = spells.suddenDeath.icon, description = spells.suddenDeath.name, printInSettings = true }
	}
	specCache.protection.barTextVariables.values = {
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

		{ variable = "$rage", description = L["WarriorProtectionBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["WarriorProtectionBarTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$ignorePainTime", description = L["WarriorProtectionBarTextVariable_ignorePainTime"], printInSettings = true, color = false },

		{ variable = "$shieldBlockTime", description = L["WarriorProtectionBarTextVariable_shieldBlockTime"], printInSettings = true, color = false },
		{ variable = "$shieldBlockCharges", description = L["WarriorProtectionBarTextVariable_shieldBlockCharges"], printInSettings = true, color = false },
		{ variable = "$shieldBlockMaxCharges", description = L["WarriorProtectionBarTextVariable_shieldBlockMaxCharges"], printInSettings = true, color = false },
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 then
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
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

	if TRB.Data.character.specId == 1 then
		-- Arms: No secondary bar
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
		TRB.Functions.Aura:DisableUnitAuraCache()
	elseif TRB.Data.character.specId == 2 then
		-- Fury: No secondary bar
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
		TRB.Functions.Aura:DisableUnitAuraCache()
	elseif TRB.Data.character.specId == 3 then
		-- Protection: Show secondary bar for defensive buffs (Shield Block + Ignore Pain)
		if barGroups and barGroups.secondary then
			local maxDefensiveBuffs = TRB.Data.character.maxResource2 or 2
			barGroups.secondary:Show()
			barGroups.secondary:ShowNodes(maxDefensiveBuffs)
			for x = 1, maxDefensiveBuffs do
				local defensiveNode = barGroups.secondary:GetNode(x)
				if defensiveNode then
					defensiveNode:SetMinMax(0, 1)
				end
			end
		end
		TRB.Functions.Aura:EnableUnitAuraCache()
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Arms()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.arms
	local sharedSettings = TRB.Data.specCache["arms"].settings
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local _
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local currentTime = GetTime()

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= normalizedRage then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingRageColor = sharedSettings.colors.text.spending.color
	end

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)--TRB.Functions.Number:RoundTo(normalizedRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	
	--------------
	---
	local lookup = TRB.Data.lookup or {}
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$casting"] = castingRage
	TRB.Data.lookup = lookup
	
	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Fury()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.fury
	local sharedSettings = TRB.Data.specCache["fury"].settings
	local _
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local currentTime = GetTime()

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= normalizedRage then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingRageColor = sharedSettings.colors.text.spending.color
	end

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)-- TRB.Functions.Number:RoundTo(normalizedRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	
	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$casting"] = castingRage
	TRB.Data.lookup = lookup


	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Protection()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.protection
	local sharedSettings = TRB.Data.specCache["protection"].settings
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local _
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local currentTime = GetTime()

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= normalizedRage then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end
	
	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)--TRB.Functions.Number:RoundTo(normalizedRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	
	--[[
	--$ignorePainAbsorb
	local _ignorePainAbsorb = snapshots[spells.ignorePain.id].buff.customProperties["absorb"] or 0
	local ignorePainAbsorb = TRB.Functions.String:ConvertToShortNumberNotation(_ignorePainAbsorb, 1, "floor", true)]]

	--$ignorePainTime
	local _ignorePainTime = snapshots[spells.ignorePain.id].buff:GetRemainingTime(currentTime)
	local ignorePainTime = TRB.Functions.BarText:TimerPrecision(_ignorePainTime)

	--$shieldBlockTime
	local _shieldBlockTime = snapshots[spells.shieldBlock.id].buff:GetRemainingTime(currentTime)
	local shieldBlockTime = TRB.Functions.BarText:TimerPrecision(_shieldBlockTime)
	
	--$shieldBlockCharges
	local shieldBlockCharges = snapshots[spells.shieldBlock.id].cooldown.charges or 0
	
	--$shieldBlockMaxCharges
	local shieldBlockMaxCharges = snapshots[spells.shieldBlock.id].cooldown.maxCharges or 0

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingRage
	lookup["$ignorePainTime"] = ignorePainTime
	lookup["$shieldBlockTime"] = shieldBlockTime
	lookup["$shieldBlockCharges"] = shieldBlockCharges
	lookup["$shieldBlockMaxCharges"] = shieldBlockMaxCharges
	--[[lookup["$ignorePainAbsorb"] = ignorePainAbsorb]]
	TRB.Data.lookup = lookup
	
	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$ignorePainTime"] = _ignorePainTime
	lookupLogic["$shieldBlockTime"] = _shieldBlockTime
	lookupLogic["$shieldBlockCharges"] = shieldBlockCharges
	lookupLogic["$shieldBlockMaxCharges"] = shieldBlockMaxCharges
	--[[lookupLogic["$ignorePainAbsorb"] = _ignorePainAbsorb]]
	TRB.Data.lookupLogic = lookupLogic
end


---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()
	local affectingCombat = TRB.Data.character.inCombat

	if TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.shieldBlock.castId then
				snapshotData.snapshots[spells.shieldBlock.id].buff:InitializeCustom(spells.shieldBlock.duration, currentTime)
			elseif spellId == spells.ignorePain.castId then
				snapshotData.snapshots[spells.ignorePain.id].buff:InitializeCustom(spells.ignorePain.duration, currentTime)
				local bufferEntry = TRB.Functions.Aura:GetFromAuraCacheBuffer(currentTime)
				if bufferEntry ~= nil then
					snapshotData.snapshots[spells.ignorePain.id].buff:SetAuraInstanceId(bufferEntry)
				else
					TRB.Functions.Aura:InsertAuraRequest(currentTime, snapshotData.snapshots[spells.ignorePain.id].buff)
				end
			end
		end
	end
end

local function UpdateSnapshot()
	local currentTime = GetTime()
	TRB.Functions.Character:UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells|TRB.Classes.Warrior.FurySpells|TRB.Classes.Warrior.ProtectionSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	--[[snapshots[spells.impendingVictory.id].cooldown:Refresh()]]
	snapshots[spells.shieldBlock.id].cooldown:Refresh()
	--[[snapshots[spells.thunderClap.id].cooldown:Refresh()
	snapshots[spells.suddenDeath.id].buff:GetRemainingTime(currentTime)]]
end

local function UpdateSnapshot_DPS()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells|TRB.Classes.Warrior.FurySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--snapshots[spells.thunderClap.id].cooldown:Refresh()
end

local function UpdateSnapshot_Arms()
	local currentTime = GetTime()
	UpdateSnapshot_DPS()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.mortalStrike.id].cooldown:Refresh()
	snapshots[spells.cleave.id].cooldown:Refresh()
	snapshots[spells.ignorePain.id].cooldown:Refresh()]]
end

local function UpdateSnapshot_Fury()
	local currentTime = GetTime()
	UpdateSnapshot_DPS()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.whirlwind.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.bladestorm.id].buff:UpdateTicks(currentTime)
	snapshots[spells.execute.id].cooldown:Refresh()]]
end

local function UpdateSnapshot_Protection()
	local currentTime = GetTime()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.ignorePain.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.shieldBlock.id].buff:GetRemainingTime(currentTime)
	--[[
	snapshots[spells.whirlwind.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.bladestorm.id].buff:UpdateTicks(currentTime)

	snapshots[spells.execute.id].cooldown:Refresh()
	]]
end

---Updates the defensive buff secondary bar nodes for Protection
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateDefensiveBuffs(specSettings, specCacheSettings)
	local currentTime = GetTime()
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
	local cpBorderColor = specSettings.colors.comboPoints.border

	local barGroups = TRB.Frames.barGroups
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	
	local currentDefensiveBar = 1
	
	-- Defensive buff config: { spell, colorKey }
	local defensiveBuffs = {
		{ spell = spells.ignorePain, colorKey = "ignorePain" },
		{ spell = spells.shieldBlock, colorKey = "shieldBlock" }
	}
	
	for _, buffConfig in ipairs(defensiveBuffs) do
		local spell = buffConfig.spell
		local colorKey = buffConfig.colorKey
		local defensiveBarEnabled = specSettings.colors.comboPoints[colorKey] and specSettings.colors.comboPoints[colorKey].enabled
		
		if talents:IsTalentActive(spell) and defensiveBarEnabled then
			local cpColor = specSettings.colors.comboPoints[colorKey].color
			local buff = snapshots[spell.id].buff
			
			local cpTime = 0
			local cpDuration = 1
			
			if buff.isActive then
				cpTime = buff:GetRemainingTime(currentTime)
				cpDuration = buff.duration
			end
			
			if cpTime < 0 then
				cpTime = 0
			end
			
			if cpTime == math.huge or cpDuration == math.huge then
				cpTime = 0
				cpDuration = 1
			end
			
			if barGroups and barGroups.secondary then
				local defensiveNode = barGroups.secondary:GetNode(currentDefensiveBar)
				if defensiveNode then
					TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. currentDefensiveBar, defensiveNode, cpTime, cpDuration)
					defensiveNode:SetBorderColor(cpBorderColor)
					defensiveNode:SetColor(cpColor)
					defensiveNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
				end
			end
			
			currentDefensiveBar = currentDefensiveBar + 1
		end
	end
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warrior
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local barGroups = TRB.Frames.barGroups

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	local primaryResourceFrame = primaryNode:GetResourceFrame()

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.arms
		local specCacheSettings = TRB.Data.specCache.arms.settings
		UpdateSnapshot_Arms()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				
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

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
							end
						elseif spell.id == spells.whirlwind.id then
							if talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.cleave.id then
							if not talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
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

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
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
		local specSettings = classSettings.fury
		local specCacheSettings = TRB.Data.specCache.fury.settings
		UpdateSnapshot_Fury()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

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
					
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.execute.id then
							if talents:IsTalentActive(spells.improvedExecute) then
								showThreshold = false
							else
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						elseif spell.id == spells.thunderClap.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif talents:IsTalentActive(spells.crashingThunder) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.hasCooldown then
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
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

				local barColor = specSettings.colors.bar.base

				if snapshots[spells.enrage.id].buff:GetRemainingTime(currentTime) > 0 then
					barColor = specSettings.colors.bar.enrage
				end

				local barBorderColor = specSettings.colors.bar.border

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
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
		local specSettings = classSettings.protection
		local specCacheSettings = TRB.Data.specCache.protection.settings
		UpdateSnapshot_Protection()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

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
					if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
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
				
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
			end

			if specSettings.displayBar.secondary ~= "never" then
				-- Update defensive buff secondary bar nodes
				UpdateDefensiveBuffs(specSettings, specCacheSettings)
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
		specCache.arms.talents:GetTalents()
		FillSpellData_Arms()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.arms)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.arms.settings)
		
		local lookup = TRB.Data.lookup or {}
		lookup["#cleave"] = spells.cleave.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#mortalStrike"] = spells.mortalStrike.icon
		lookup["#rend"] = spells.rend.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#whirlwind"] = spells.whirlwind.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "arms" then
			talents = specCache.arms.talents
			TRB.Data.barConstructedForSpec = "arms"
			ConstructResourceBar(specCache.arms.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.fury.talents:GetTalents()
		FillSpellData_Fury()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.fury)
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Fury
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.fury.settings)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		local lookup = TRB.Data.lookup or {}
		lookup["#bladestorm"] = spells.bladestorm.icon
		lookup["#charge"] = spells.charge.icon
		lookup["#enrage"] = spells.enrage.icon
		lookup["#execute"] = spells.execute.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		lookup["#whirlwind"] = spells.whirlwind.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "fury" then
			talents = specCache.fury.talents
			TRB.Data.barConstructedForSpec = "fury"
			ConstructResourceBar(specCache.fury.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.protection.talents:GetTalents()
		FillSpellData_Protection()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.protection)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Protection
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.protection.settings)
		
		local lookup = TRB.Data.lookup or {}
		lookup["#ignorePain"] = spells.ignorePain.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "protection" then
			talents = specCache.protection.talents
			TRB.Data.barConstructedForSpec = "protection"
			ConstructResourceBar(specCache.protection.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

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
	
	if TRB.Data.character.classId == 1 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Warrior.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.arms == nil or
						TwintopInsanityBarSettings.warrior.arms.displayText == nil then
						settings.warrior.arms.displayText.barText = TRB.Options.Warrior.ArmsLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.fury == nil or
						TwintopInsanityBarSettings.warrior.fury.displayText == nil then
						settings.warrior.fury.displayText.barText = TRB.Options.Warrior.FuryLoadDefaultBarTextSettings()
					end

					if  TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.protection == nil or
						TwintopInsanityBarSettings.warrior.protection.displayText == nil then
						settings.warrior.protection.displayText.barText = TRB.Options.Warrior.ProtectionLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Warrior.LoadDefaultSettings(true)
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
						TRB.Data.settings.warrior.arms = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarriorArmsFull"], TRB.Data.settings.warrior.arms)
						TRB.Data.settings.warrior.fury = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarriorFuryFull"], TRB.Data.settings.warrior.fury)
						TRB.Data.settings.warrior.protection = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarriorProtectionFull"], TRB.Data.settings.warrior.protection)
						
						FillSpellData_Arms()
						FillSpellData_Fury()
						FillSpellData_Protection()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Warrior.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "warrior"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Rage, false)

	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		TRB.Data.character.specName = "arms"

		--[[if talents:IsTalentActive(spells.bloodletting) then
			TRB.Data.character.pandemicModifier = spells.bloodletting.attributes.pandemicModifier
		end]]
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "fury"
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "protection"
		local maxComboPoints = 2 -- Shield Block and Ignore Pain
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		local barGroups = TRB.Frames.barGroups

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.warrior.arms == true then
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.warrior.fury == true then
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.warrior.protection == true then
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups

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
			-- Only Protection (specId == 3) uses the secondary bar
			local showSecondary = false
			if not forceHideAll and TRB.Data.character.specId == 3 then
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
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local spells
	local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		settings = TRB.Data.settings.warrior.arms
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		settings = TRB.Data.settings.warrior.fury
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		settings = TRB.Data.settings.warrior.protection
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Arms
	elseif TRB.Data.character.specId == 2 then --Fury
		--[[if var == "$enrageTime" then
			if snapshots[spells.enrage.id].buff.isActive then
				valid = true
			end
		elseif var == "$whirlwindTime" then
			if snapshots[spells.whirlwind.id].buff.isActive then
				valid = true
			end
		elseif var == "$whirlwindStacks" then
			if snapshots[spells.whirlwind.id].buff.isActive then
				valid = true
			end
		elseif var == "$bladestormTicks" then
			if snapshots[spells.bladestorm.id].buff.isActive then
				valid = true
			end
		elseif var == "$bladestormResource" or var == "$bladestormRage" then
			if snapshots[spells.bladestorm.id].buff.isActive then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 3 then --Protection
		--[[if var == "$ignorePainAbsorb" then
			if snapshots[spells.ignorePain.id].buff.customProperties["absorb"] > 0 then
				valid = true
			end
		else]]if var == "$ignorePainTime" then
			if snapshots[spells.ignorePain.id].buff.isActive then
				valid = true
			end
		elseif var == "$shieldBlockTime" then
			if snapshots[spells.shieldBlock.id].buff.isActive then
				valid = true
			end
		elseif var == "$shieldBlockCharges" then
			if issecretvalue(snapshots[spells.shieldBlock.id].cooldown.charges) or snapshots[spells.shieldBlock.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$shieldBlockMaxCharges" then
			if issecretvalue(snapshots[spells.shieldBlock.id].cooldown.charges) or snapshots[spells.shieldBlock.id].cooldown.charges > 0  then
				valid = true
			end
		end
	end

	if valid == true then
		return valid
	end

	if var == "$resource" or var == "$rage" then
		-- Do not compare resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$rageMax" then
		valid = true
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
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
	local barGroups = TRB.Frames.barGroups
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
	elseif relativeToFrame ~= nil then
		-- Handle Protection's defensive buff nodes
		if TRB.Data.character.specId == 3 then
			if TRB.Functions.String:StartsWith(relativeToFrame, "IgnorePain") then
				if barGroups and barGroups.secondary then
					local node = barGroups.secondary:GetNode(1)
					if node then
						local isVisible = barGroups.secondary.isVisible and node.isVisible
						return node:GetResourceFrame(), true, isVisible
					end
				end
				return nil, true, false
			elseif TRB.Functions.String:StartsWith(relativeToFrame, "ShieldBlock") then
				if barGroups and barGroups.secondary then
					local node = barGroups.secondary:GetNode(2)
					if node then
						local isVisible = barGroups.secondary.isVisible and node.isVisible
						return node:GetResourceFrame(), true, isVisible
					end
				end
				return nil, true, false
			end
		end
		-- Handle generic combo point index pattern
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local node = barGroups.secondary:GetNode(index)
				if node then
					local isVisible = barGroups.secondary.isVisible and node.isVisible
					return node:GetResourceFrame(), true, isVisible
				end
			end
		end
		-- Handle health bar
		if relativeToFrame == "HealthBar" then
			if barGroups and barGroups.health then
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
	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end