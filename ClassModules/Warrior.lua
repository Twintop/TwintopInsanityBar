local _, TRB = ...
if TRB.Data.character.classId ~= 1 then --Only do this if we're on a Warrior!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resourceFrame = TRB.Frames.resourceFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

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
		},
		dots = {
			rendCount = 0,
			deepWoundsCount = 0
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
		overcapCue = false
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
		overcapCue = false
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
		},
		dots = {
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
		overcapCue = false
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
end

local function Setup_Fury()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "fury")
end

local function Setup_Protection()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "protection")
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

		--[[{ variable = "#charge", icon = spells.charge.icon, description = spells.charge.name, printInSettings = true },
		{ variable = "#deepWounds", icon = spells.deepWounds.icon, description = spells.deepWounds.name, printInSettings = true },
		{ variable = "#execute", icon = spells.execute.icon, description = spells.execute.name, printInSettings = true },			
		{ variable = "#ravager", icon = spells.ravager.icon, description = spells.ravager.name, printInSettings = true },
		{ variable = "#suddenDeath", icon = spells.suddenDeath.icon, description = spells.suddenDeath.name, printInSettings = true },]]
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$rage", description = L["WarriorArmsBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["WarriorArmsBarTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		--[[{ variable = "$casting", description = "", printInSettings = false, color = false },
		{ variable = "$passive", description = L["WarriorArmsBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$ragePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$ragePlusPassive", description = L["WarriorArmsBarTextVariable_ragePlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$rageTotal", description = L["WarriorArmsBarTextVariable_rageTotal"], printInSettings = true, color = false },   
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   

		{ variable = "$rend", description = L["WarriorArmsBarTextVariable_rend"], printInSettings = true, color = false },

		{ variable = "$deepWoundsCount", description = L["WarriorArmsBarTextVariable_deepWoundsCount"], printInSettings = true, color = false },
		{ variable = "$deepWoundsTime", description = L["WarriorArmsBarTextVariable_deepWoundsTime"], printInSettings = true, color = false },
		{ variable = "$rendCount", description = L["WarriorArmsBarTextVariable_rendCount"], printInSettings = true, color = false },
		{ variable = "$rendTime", description = L["WarriorArmsBarTextVariable_rendTime"], printInSettings = true, color = false },

		{ variable = "$suddenDeathTime", description = L["WarriorArmsBarTextVariable_suddenDeathTime"], printInSettings = true, color = false },
		
		{ variable = "$ravagerTicks", description = L["WarriorArmsBarTextVariable_ravagerTicks"], printInSettings = true, color = false },
		{ variable = "$ravagerRage", description = L["WarriorArmsBarTextVariable_ravagerRage"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
	}
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
		{ variable = "#suddenDeath", icon = spells.suddenDeath.icon, description = spells.suddenDeath.name, printInSettings = true },
		--{ variable = "#ravager", icon = spells.ravager.icon, description = spells.ravager.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$rage", description = L["WarriorFuryBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["WarriorFuryBarTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		--[[{ variable = "$passive", description = L["WarriorFuryBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$ragePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$ragePlusPassive", description = L["WarriorFuryBarTextVariable_ragePlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$rageTotal", description = L["WarriorFuryBarTextVariable_rageTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   

		{ variable = "$enrageTime", description = L["WarriorFuryBarTextVariable_enrageTime"], printInSettings = true, color = false },

		{ variable = "$suddenDeathTime", description = L["WarriorFuryBarTextVariable_suddenDeathTime"], printInSettings = true, color = false },
		
		{ variable = "$ravagerTicks", description = L["WarriorFuryBarTextVariable_ravagerTicks"], printInSettings = true, color = false },
		{ variable = "$ravagerRage", description = L["WarriorFuryBarTextVariable_ravagerRage"], printInSettings = true, color = false },
		
		{ variable = "$bladestormTicks", description = L["WarriorFuryBarTextVariable_bladestormicks"], printInSettings = true, color = false },
		{ variable = "$bladestormRage", description = L["WarriorFuryBarTextVariable_bladestormRage"], printInSettings = true, color = false },

		{ variable = "$whirlwindTime", description = L["WarriorFuryBarTextVariable_whirlwindTime"], printInSettings = true, color = false },
		{ variable = "$whirlwindStacks", description = L["WarriorFuryBarTextVariable_whirlwindStacks"], printInSettings = true, color = false },
		
		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
	}
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
		
		--{ variable = "#deepWounds", icon = spells.deepWounds.icon, description = spells.deepWounds.name, printInSettings = true },
		--{ variable = "#execute", icon = spells.execute.icon, description = spells.execute.name, printInSettings = true },
		{ variable = "#ignorePain", icon = spells.ignorePain.icon, description = spells.ignorePain.name, printInSettings = true },
		{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = spells.impendingVictory.name, printInSettings = true },
		--{ variable = "#ravager", icon = spells.ravager.icon, description = spells.ravager.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$rage", description = L["WarriorProtectionBarTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["WarriorProtectionBarTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		--[[{ variable = "$passive", description = L["WarriorProtectionBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$ragePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$ragePlusPassive", description = L["WarriorProtectionBarTextVariable_ragePlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$rageTotal", description = L["WarriorProtectionBarTextVariable_rageTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },

		{ variable = "$ignorePainAbsorb", description = L["WarriorProtectionBarTextVariable_ignorePainAbsorb"], printInSettings = true, color = false },]]
		{ variable = "$ignorePainTime", description = L["WarriorProtectionBarTextVariable_ignorePainTime"], printInSettings = true, color = false },

		{ variable = "$shieldBlockTime", description = L["WarriorProtectionBarTextVariable_shieldBlockTime"], printInSettings = true, color = false },
		{ variable = "$shieldBlockCharges", description = L["WarriorProtectionBarTextVariable_shieldBlockCharges"], printInSettings = true, color = false },
		{ variable = "$shieldBlockMaxCharges", description = L["WarriorProtectionBarTextVariable_shieldBlockMaxCharges"], printInSettings = true, color = false },

		--[[{ variable = "$rend", description = L["WarriorProtectionBarTextVariable_rend"], printInSettings = true, color = false },

		{ variable = "$deepWoundsCount", description = L["WarriorProtectionBarTextVariable_deepWoundsCount"], printInSettings = true, color = false },
		{ variable = "$deepWoundsTime", description = L["WarriorProtectionBarTextVariable_deepWoundsTime"], printInSettings = true, color = false },
		{ variable = "$rendCount", description = L["WarriorProtectionBarTextVariable_rendCount"], printInSettings = true, color = false },
		{ variable = "$rendTime", description = L["WarriorProtectionBarTextVariable_rendTime"], printInSettings = true, color = false },

		{ variable = "$suddenDeathTime", description = L["WarriorProtectionBarTextVariable_suddenDeathTime"], printInSettings = true, color = false },
		
		{ variable = "$ravagerTicks", description = L["WarriorProtectionBarTextVariable_ravagerTicks"], printInSettings = true, color = false },
		{ variable = "$ravagerRage", description = L["WarriorProtectionBarTextVariable_ravagerRage"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
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
		TRB.Frames.resource2ContainerFrame:Hide()
		TRB.Functions.Aura:DisableUnitAuraCache()
	elseif TRB.Data.character.specId == 2 then
		TRB.Frames.resource2ContainerFrame:Hide()
		TRB.Functions.Aura:DisableUnitAuraCache()
	elseif TRB.Data.character.specId == 3 then
		TRB.Frames.resource2ContainerFrame:Show()
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		TRB.Functions.Aura:EnableUnitAuraCache()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
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
	
	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentRageColor = sharedSettings.colors.text.overcap.color
			castingRageColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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

	--[[--$suddenDeathTime
	local _suddenDeathTime = snapshots[spells.suddenDeath.id].buff:GetRemainingTime(currentTime)
	local suddenDeathTime = TRB.Functions.BarText:TimerPrecision(_suddenDeathTime)]]

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)--TRB.Functions.Number:RoundTo(normalizedRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	--[[--$passive
	local _passiveRage = 0
	local passiveRage = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveRage, resourcePrecision, "floor"))
	
	--$rageTotal
	local _rageTotal = math.min(_passiveRage + snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
	local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_rageTotal, resourcePrecision, "floor"))
	--$ragePlusCasting
	local _ragePlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
	local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(_ragePlusCasting, resourcePrecision, "floor"))
	--$ragePlusPassive
	local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
	local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_ragePlusPassive, resourcePrecision, "floor"))

	
	--$rendCount and $rendTime
	local _rendCount = targetData.count[spells.rend.debuffId] or 0
	local rendCount = string.format("%s", _rendCount)
	local _rendTime = 0
	
	if target ~= nil then
		_rendTime = target.spells[spells.rend.debuffId].remainingTime or 0
	end

	local rendTime

	local _deepWoundsCount = targetData.count[spells.deepWounds.id] or 0
	local deepWoundsCount = string.format("%s", _deepWoundsCount)
	local _deepWoundsTime = 0
	
	if target ~= nil then
		_deepWoundsTime = target.spells[spells.deepWounds.id].remainingTime or 0
	end

	local deepWoundsTime

	--$ravagerRage
	local _ravagerRage = snapshots[spells.ravager.id].buff.resource
	local ravagerRage = string.format("%.0f", _ravagerRage)
	--$ravagerTicks
	local _ravagerTicks = snapshots[spells.ravager.id].buff.ticks
	local ravagerTicks = string.format("%.0f", _ravagerTicks)

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.rend.debuffId].active then
			if _rendTime > ((spells.rend.baseDuration + TRB.Data.character.pandemicModifier) * 0.3) then
				rendCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _rendCount)
				rendTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_rendTime))
			else
				rendCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _rendCount)
				rendTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_rendTime))
			end
		else
			rendCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _rendCount)
			rendTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end

		if target ~= nil and target.spells[spells.deepWounds.id].active then
			if _deepWoundsTime > ((spells.deepWounds.baseDuration + TRB.Data.character.pandemicModifier) * 0.3) then
				deepWoundsCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_deepWoundsTime))
			else
				deepWoundsCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_deepWoundsTime))
			end
		else
			deepWoundsCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _deepWoundsCount)
			deepWoundsTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		rendTime = TRB.Functions.BarText:TimerPrecision(_rendTime)
		deepWoundsTime = TRB.Functions.BarText:TimerPrecision(_deepWoundsTime)
	end]]
	----------------------------
--[[
	Global_TwintopResourceBar.resource.resource = normalizedRage
	Global_TwintopResourceBar.resource.passive = _passiveRage
		
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.rendCount = _rendCount
	Global_TwintopResourceBar.dots.deepWoundsCount = _deepWoundsCount
	
	Global_TwintopResourceBar.ravager = Global_TwintopResourceBar.ravager or {}
	Global_TwintopResourceBar.ravager.rage = _ravagerRage
	Global_TwintopResourceBar.ravager.ticks = _ravagerTicks]]

	local lookup = TRB.Data.lookup or {}
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$casting"] = castingRage
	--[[lookup["$rend"] = ""
	lookup["$rendCount"] = rendCount
	lookup["$rendTime"] = rendTime
	lookup["$deepWoundsCount"] = deepWoundsCount
	lookup["$deepWoundsTime"] = deepWoundsTime
	lookup["$suddenDeathTime"] = suddenDeathTime
	lookup["$ravagerRage"] = ravagerRage
	lookup["$ravagerTicks"] = ravagerTicks
	lookup["$rageTotal"] = rageTotal
	lookup["$resourcePlusCasting"] = ragePlusCasting
	lookup["$ragePlusCasting"] = ragePlusCasting
	lookup["$resourcePlusPassive"] = ragePlusPassive
	lookup["$ragePlusPassive"] = ragePlusPassive
	lookup["$resourceTotal"] = rageTotal
	lookup["$passive"] = passiveRage
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$rageOvercap"] = overcap]]
	TRB.Data.lookup = lookup
	
	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	--[[lookupLogic["$rend"] = talents:IsTalentActive(spells.rend)
	lookupLogic["$rendCount"] = _rendCount
	lookupLogic["$rendTime"] = _rendTime
	lookupLogic["$deepWoundsCount"] = _deepWoundsCount
	lookupLogic["$deepWoundsTime"] = _deepWoundsTime
	lookupLogic["$suddenDeathTime"] = _suddenDeathTime
	lookupLogic["$ravagerRage"] = _ravagerRage
	lookupLogic["$ravagerTicks"] = _ravagerTicks
	lookupLogic["$rageTotal"] = _rageTotal
	lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
	lookupLogic["$ragePlusCasting"] = _ragePlusCasting
	lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
	lookupLogic["$ragePlusPassive"] = _ragePlusPassive
	lookupLogic["$resourceTotal"] = _rageTotal
	lookupLogic["$passive"] = _passiveRage
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$rageOvercap"] = overcap]]
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

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentRageColor = sharedSettings.colors.text.overcap.color
			castingRageColor = sharedSettings.colors.text.overcap.color
		elseif sharedSettings.colors.text.overThreshold.enabled then]]
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
		--end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingRageColor = sharedSettings.colors.text.spending.color
	end
	
	--[[--$bladestormRage
	local _bladestormRage = snapshots[spells.bladestorm.id].buff.resource
	local bladestormRage = string.format("%.0f", _bladestormRage)
	--$bladestormTicks
	local _bladestormTicks = snapshots[spells.bladestorm.id].buff.ticks
	local bladestormTicks = string.format("%.0f", _bladestormTicks)]]

	--[[--$ravagerRage
	local _ravagerRage = snapshots[spells.ravager.id].buff.resource
	local ravagerRage = string.format("%.0f", _ravagerRage)
	--$ravagerTicks
	local _ravagerTicks = snapshots[spells.ravager.id].buff.ticks
	local ravagerTicks = string.format("%.0f", _ravagerTicks)]]

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)-- TRB.Functions.Number:RoundTo(normalizedRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	--[[--$passive
	local _passiveRage = 0-- _ravagerRage + _bladestormRage
	local passiveRage = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveRage, resourcePrecision, "floor"))
	
	--$rageTotal
	local _rageTotal = math.min(_passiveRage + snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
	local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_rageTotal, resourcePrecision, "floor"))
	--$ragePlusCasting
	local _ragePlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
	local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(_ragePlusCasting, resourcePrecision, "floor"))
	--$ragePlusPassive
	local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
	local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_ragePlusPassive, resourcePrecision, "floor"))

	--$enrageTime
	local _enrageTime = snapshots[spells.enrage.id].buff:GetRemainingTime(currentTime)
	local enrageTime = TRB.Functions.BarText:TimerPrecision(_enrageTime)
	
	--$whirlwindTime
	local _whirlwindTime = snapshots[spells.whirlwind.id].buff:GetRemainingTime(currentTime)
	local whirlwindTime = TRB.Functions.BarText:TimerPrecision(_whirlwindTime)
	--$whirlwindStacks
	local whirlwindStacks = snapshots[spells.whirlwind.id].buff.applications

	--$suddenDeathTime
	local _suddenDeathTime = snapshots[spells.suddenDeath.id].buff:GetRemainingTime(currentTime)
	local suddenDeathTime = TRB.Functions.BarText:TimerPrecision(_suddenDeathTime)]]

	----------------------------

	Global_TwintopResourceBar.resource.resource = normalizedRage
	--Global_TwintopResourceBar.resource.passive = _passiveRage
	
	--[[Global_TwintopResourceBar.bladestorm = Global_TwintopResourceBar.bladestorm or {}
	Global_TwintopResourceBar.bladestorm.rage = _bladestormRage
	Global_TwintopResourceBar.bladestorm.ticks = _bladestormTicks]]
	
	--[[Global_TwintopResourceBar.ravager = Global_TwintopResourceBar.ravager or {}
	Global_TwintopResourceBar.ravager.rage = _ravagerRage
	Global_TwintopResourceBar.ravager.ticks = _ravagerTicks]]

	local lookup = TRB.Data.lookup or {}
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$casting"] = castingRage
	--[[lookup["$suddenDeathTime"] = suddenDeathTime
	lookup["$enrageTime"] = enrageTime
	lookup["$whirlwindTime"] = whirlwindTime
	lookup["$whirlwindStacks"] = whirlwindStacks
	lookup["$rageTotal"] = rageTotal
	lookup["$resourcePlusCasting"] = ragePlusCasting
	lookup["$ragePlusCasting"] = ragePlusCasting
	lookup["$resourcePlusPassive"] = ragePlusPassive
	lookup["$ragePlusPassive"] = ragePlusPassive
	lookup["$resourceTotal"] = rageTotal
	lookup["$passive"] = passiveRage
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$rageOvercap"] = overcap
	--lookup["$ravagerRage"] = ravagerRage
	--lookup["$ravagerTicks"] = ravagerTicks
	lookup["$bladestormRage"] = bladestormRage
	lookup["$bladestormTicks"] = bladestormTicks]]
	TRB.Data.lookup = lookup


	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	--[[lookupLogic["$enrageTime"] = _enrageTime
	lookupLogic["$suddenDeathTime"] = _suddenDeathTime
	lookupLogic["$whirlwindTime"] = _whirlwindTime
	lookupLogic["$whirlwindStacks"] = whirlwindStacks
	lookupLogic["$rageTotal"] = _rageTotal
	lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
	lookupLogic["$ragePlusCasting"] = _ragePlusCasting
	lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
	lookupLogic["$ragePlusPassive"] = _ragePlusPassive
	lookupLogic["$resourceTotal"] = _rageTotal
	lookupLogic["$passive"] = _passiveRage
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$rageOvercap"] = overcap
	--lookupLogic["$ravagerRage"] = _ravagerRage
	--lookupLogic["$ravagerTicks"] = _ravagerTicks
	lookupLogic["$bladestormRage"] = _bladestormRage
	lookupLogic["$bladestormTicks"] = _bladestormTicks]]
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
	
	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentRageColor = sharedSettings.colors.text.overcap.color
			castingRageColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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

	--[[if snapshotData.casting.resourceFinal < 0 then
		castingRageColor = sharedSettings.colors.text.spending.color
	end

	
	--$suddenDeathTime
	local _suddenDeathTime = snapshots[spells.suddenDeath.id].buff:GetRemainingTime(currentTime)
	local suddenDeathTime = TRB.Functions.BarText:TimerPrecision(_suddenDeathTime)]]
	
	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)--TRB.Functions.Number:RoundTo(normalizedRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	--[[--$passive
	local _passiveRage = 0
	local passiveRage = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveRage, resourcePrecision, "floor"))
	
	--$rageTotal
	local _rageTotal = math.min(_passiveRage + snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
	local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_rageTotal, resourcePrecision, "floor"))
	--$ragePlusCasting
	local _ragePlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
	local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(_ragePlusCasting, resourcePrecision, "floor"))
	--$ragePlusPassive
	local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
	local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_ragePlusPassive, resourcePrecision, "floor"))

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

	--$rendCount and $rendTime
	--[[local _rendCount = targetData.count[spells.rend.debuffId] or 0
	local rendCount = string.format("%s", _rendCount)
	local _rendTime = 0
	
	if target ~= nil then
		_rendTime = target.spells[spells.rend.debuffId].remainingTime or 0
	end

	local rendTime

	local _deepWoundsCount = targetData.count[spells.deepWounds.id] or 0
	local deepWoundsCount = string.format("%s", _deepWoundsCount)
	local _deepWoundsTime = 0
	
	if target ~= nil then
		_deepWoundsTime = target.spells[spells.deepWounds.id].remainingTime or 0
	end

	local deepWoundsTime]]

	--[[--$ravagerRage
	local _ravagerRage = snapshots[spells.ravager.id].buff.resource
	local ravagerRage = string.format("%.0f", _ravagerRage)
	--$ravagerTicks
	local _ravagerTicks = snapshots[spells.ravager.id].buff.ticks
	local ravagerTicks = string.format("%.0f", _ravagerTicks)]]

	--[[
	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.rend.debuffId].active then
			if _rendTime > ((spells.rend.baseDuration + TRB.Data.character.pandemicModifier) * 0.3) then
				rendCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _rendCount)
				rendTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_rendTime))
			else
				rendCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _rendCount)
				rendTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_rendTime))
			end
		else
			rendCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _rendCount)
			rendTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end

		if target ~= nil and target.spells[spells.deepWounds.id].active then
			if _deepWoundsTime > ((spells.deepWounds.baseDuration + TRB.Data.character.pandemicModifier) * 0.3) then
				deepWoundsCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_deepWoundsTime))
			else
				deepWoundsCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_deepWoundsTime))
			end
		else
			deepWoundsCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _deepWoundsCount)
			deepWoundsTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		rendTime = TRB.Functions.BarText:TimerPrecision(_rendTime)
		deepWoundsTime = TRB.Functions.BarText:TimerPrecision(_deepWoundsTime)
	end]]

	----------------------------

	--[[Global_TwintopResourceBar.resource.resource = normalizedRage
	Global_TwintopResourceBar.resource.passive = _passiveRage
	
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.rendCount = _rendCount
	Global_TwintopResourceBar.dots.deepWoundsCount = _deepWoundsCount]]
	
	--[[Global_TwintopResourceBar.ravager = Global_TwintopResourceBar.ravager or {}
	Global_TwintopResourceBar.ravager.rage = _ravagerRage
	Global_TwintopResourceBar.ravager.ticks = _ravagerTicks]]

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
	--[[lookup["$ignorePainAbsorb"] = ignorePainAbsorb
	lookup["$rend"] = ""
	lookup["$rendCount"] = rendCount
	lookup["$rendTime"] = rendTime
	lookup["$deepWoundsCount"] = deepWoundsCount
	lookup["$deepWoundsTime"] = deepWoundsTime
	lookup["$suddenDeathTime"] = suddenDeathTime
	--lookup["$ravagerRage"] = ravagerRage
	--lookup["$ravagerTicks"] = ravagerTicks
	lookup["$rageTotal"] = rageTotal
	lookup["$resourcePlusCasting"] = ragePlusCasting
	lookup["$ragePlusCasting"] = ragePlusCasting
	lookup["$resourcePlusPassive"] = ragePlusPassive
	lookup["$ragePlusPassive"] = ragePlusPassive
	lookup["$resourceTotal"] = rageTotal
	lookup["$passive"] = passiveRage
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$rageOvercap"] = overcap]]
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
	--[[lookupLogic["$ignorePainAbsorb"] = _ignorePainAbsorb
	lookupLogic["$rend"] = talents:IsTalentActive(spells.rend)
	lookupLogic["$rendCount"] = _rendCount
	lookupLogic["$rendTime"] = _rendTime
	lookupLogic["$deepWoundsCount"] = _deepWoundsCount
	lookupLogic["$deepWoundsTime"] = _deepWoundsTime
	lookupLogic["$suddenDeathTime"] = _suddenDeathTime
	--lookupLogic["$ravagerRage"] = _ravagerRage
	--lookupLogic["$ravagerTicks"] = _ravagerTicks
	lookupLogic["$rageTotal"] = _rageTotal
	lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
	lookupLogic["$ragePlusCasting"] = _ragePlusCasting
	lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
	lookupLogic["$ragePlusPassive"] = _ragePlusPassive
	lookupLogic["$resourceTotal"] = _rageTotal
	lookupLogic["$passive"] = _passiveRage
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$rageOvercap"] = overcap]]
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
	snapshots[spells.suddenDeath.id].buff:GetRemainingTime(currentTime)
	--snapshots[spells.ravager.id].buff:UpdateTicks(currentTime)]]
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

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warrior
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.arms
		local specCacheSettings = TRB.Data.specCache.arms.settings
		UpdateSnapshot_Arms()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					passiveValue = passiveValue + snapshots[spells.ravager.id].buff.resource
				end]]

				--[[if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end
				passiveBarValue = castingBarValue + passiveValue]]
				
				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				--[[if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else]]
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				--end
				
				--[[local targetUnitHealth
				if target ~= nil then
					targetUnitHealth = target:GetHealthPercent()
				end]]
				
				--[[local healthMinimum = spells.execute.attributes.healthMinimum
				if talents:IsTalentActive(spells.massacre) then
					healthMinimum = spells.massacre.attributes.healthMinimum
				end]]
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then--spells.execute.id then
							--[[if snapshots[spells.suddenDeath.id].buff.isActive then
								--We only show the maximum value when this proc occurs. Current and minimum thresholds being in their expected place don't matter.
								resourceAmount = spells.executeMaximum:GetPrimaryResourceCost()
							elseif spell.settingKey == "execute" then
								resourceAmount = math.min(math.max(resourceAmount, currentResource), spells.executeMaximum:GetPrimaryResourceCost())
							end]]
							
							--[[if UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
								showThreshold = false
							elseif snapshots[spells.suddenDeath.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif targetUnitHealth >= healthMinimum then
								showThreshold = false
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else]]
							
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
								-- NOTE: Only show if we can use it. Revisit this later in beta
								--thresholdColor = specCacheSettings.colors.threshold.under.color
								--frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.whirlwind.id then
							if talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							--[[elseif currentResource >= resourceAmount or snapshots[spells.stormOfSwords.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.over.color

								--[if snapshots[spells.stormOfSwords.id].buff.isActive then
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								end]]
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.cleave.id then
							if not talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							--[[elseif snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif currentResource >= resourceAmount or snapshots[spells.stormOfSwords.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.over.color

								--[if snapshots[spells.stormOfSwords.id].buff.isActive then
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								end]]
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
						--[[elseif isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color]]
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						--[[if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color]]
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then-- maxPrimaryBarResource then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				--[[if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else]]
					snapshotData.audio.overcapCue = false
				--end

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.fury
		local specCacheSettings = TRB.Data.specCache.fury.settings
		UpdateSnapshot_Fury()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					passiveValue = passiveValue + snapshots[spells.ravager.id].buff.resource + snapshots[spells.bladestorm.id].buff.resource
				end]]

				--[[if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end
				pssiveBarValue = castingBarValue + passiveValue]]
								
				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				--[[if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else]]
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				--end
				
				--[[local targetUnitHealth
				if target ~= nil then
					targetUnitHealth = target:GetHealthPercent()
				end]]
									
				--[[local healthMinimum = spells.execute.attributes.healthMinimum
				if talents:IsTalentActive(spells.massacre) then
					healthMinimum = spells.massacre.attributes.healthMinimum
				end]]

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
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
								--[[if UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
									showThreshold = false
								elseif spell.settingKey == "executeMinimum" and (targetUnitHealth >= healthMinimum) and not snapshots[spells.suddenDeath.id].buff.isActive then
									showThreshold = false
								elseif spell.settingKey == "executeMaximum"  and (targetUnitHealth >= healthMinimum) and not snapshots[spells.suddenDeath.id].buff.isActive then
									showThreshold = false
								elseif spell.settingKey == "execute" and (targetUnitHealth >= healthMinimum) and not snapshots[spells.suddenDeath.id].buff.isActive then
									showThreshold = false
								else]]
									if spell.settingKey == "execute" then
										resourceAmount = math.min(math.max(resourceAmount, currentResource), spells.executeMaximum:GetPrimaryResourceCost())
									end

									--[[if snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
									else]]if isUsable then-- currentResource >= resourceAmount then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								--end
							end
						elseif spell.id == spells.thunderClap.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif talents:IsTalentActive(spells.crashingThunder) then
								showThreshold = false
							--[[elseif snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable]]
							elseif isUsable then-- currentResource >= resourceAmount then
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
						--[[if snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						else]]if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base

				if snapshots[spells.enrage.id].buff:GetRemainingTime(currentTime) > 0 then
					barColor = specSettings.colors.bar.enrage
				end

				local barBorderColor = specSettings.colors.bar.border

				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.protection
		local specCacheSettings = TRB.Data.specCache.protection.settings
		UpdateSnapshot_Protection()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					passiveValue = passiveValue + snapshots[spells.ravager.id].buff.resource
				end

				if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end
				passiveBarValue = castingBarValue + passiveValue]]

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				--[[if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else]]
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				--end
				
				--[[local targetUnitHealth
				if target ~= nil then
					targetUnitHealth = target:GetHealthPercent()
				end
				
				local healthMinimum = spells.execute.attributes.healthMinimum
				if talents:IsTalentActive(spells.massacre) then
					healthMinimum = spells.massacre.attributes.healthMinimum
				end]]

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
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
							--[[if snapshots[spells.suddenDeath.id].buff.isActive then
								--We only show the maximum value when this proc occurs. Current and minimum thresholds being in their expected place don't matter.
								resourceAmount = spells.executeMaximum:GetPrimaryResourceCost()
							elseif spell.settingKey == "execute" then
								resourceAmount = math.min(math.max(resourceAmount, currentResource), spells.executeMaximum:GetPrimaryResourceCost())
							end]]
							
							--[[if UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
								showThreshold = false
							elseif snapshots[spells.suddenDeath.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif targetUnitHealth >= healthMinimum then
								showThreshold = false
							else]]if isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
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
						elseif isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end

					if 	spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
						snapshotData.attributes.resource2 == 0 then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end
				
				local barColor = specSettings.colors.bar.base
				--[[if snapshots[spells.metamorphosis.id].buff.isActive then
					local timeThreshold = 0
					local useEndOfMetamorphosisColor = false

					if specSettings.endOfMetamorphosis.enabled then
						useEndOfMetamorphosisColor = true
						if specSettings.endOfMetamorphosis.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfMetamorphosis.gcdsMax
						elseif specSettings.endOfMetamorphosis.mode == "time" then
							timeThreshold = specSettings.endOfMetamorphosis.timeMax
						end
					end

					if useEndOfMetamorphosisColor and metaTime <= timeThreshold then
						barColor = specSettings.colors.bar.metamorphosisEnding
					else
						barColor = specSettings.colors.bar.metamorphosis
					end
				end]]

				local barBorderColor = specSettings.colors.bar.border

				--[[if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end]]

				barContainerFrame:SetAlpha(1.0)

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				local cpBR, cpBG, cpBB, cpBA = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local cpBorderColor = specSettings.colors.comboPoints.border
				local cpColor = specSettings.colors.comboPoints.base
				local currentCp = 1
				local buff
				
				for x = 1, 2, 1 do
					local spell
					local defensiveBarEnabled = false
					if x == 1 then
						spell = spells.ignorePain
						cpColor = specSettings.colors.comboPoints.ignorePain.color
						defensiveBarEnabled = specSettings.colors.comboPoints.ignorePain.enabled
						buff = snapshots[spell.id].buff
					elseif x == 2 then
						spell = spells.shieldBlock
						cpColor = specSettings.colors.comboPoints.shieldBlock.color
						defensiveBarEnabled = specSettings.colors.comboPoints.shieldBlock.enabled
						buff = snapshots[spell.id].buff
					else
						buff = snapshots[spell.id].buff
					end

					if talents:IsTalentActive(spell) and defensiveBarEnabled then
						local cpTime = 1
						local cpDuration = 1

						if buff.isActive then
							cpTime = buff:GetRemainingTime(currentTime)
							cpDuration = buff.duration
						else
							cpTime = 0
							cpDuration = 1
						end
						
						if cpTime < 0 then
							cpTime = 0
						end

						if cpTime == math.huge or cpDuration == math.huge then
							cpTime = 0
							cpDuration = 1
						end
						
						local comboPointName = "comboPoint" .. currentCp
						TRB.Functions.Bar:SetValue(specCacheSettings, comboPointName, TRB.Frames.resource2Frames[currentCp].resourceFrame, cpTime, cpDuration)
						TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].resourceFrame, comboPointName, cpColor)
						TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].borderFrame, comboPointName, cpBorderColor)
						TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[currentCp].containerFrame, comboPointName, cpBR, cpBG, cpBB, cpBA)
						currentCp = currentCp + 1
					end
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
		--[[local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.deepWounds)
		targetData:AddSpellTracking(spells.rend)]]

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.arms.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.arms)
		
		local lookup = TRB.Data.lookup or {}
		lookup["#cleave"] = spells.cleave.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#mortalStrike"] = spells.mortalStrike.icon
		lookup["#rend"] = spells.rend.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#whirlwind"] = spells.whirlwind.icon
		--[[lookup["#charge"] = spells.charge.icon
		lookup["#deepWounds"] = spells.deepWounds.icon
		lookup["#execute"] = spells.execute.icon
		lookup["#ravager"] = spells.ravager.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon]]
		TRB.Data.lookup = lookup
		
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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.fury)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		local lookup = TRB.Data.lookup or {}
		lookup["#bladestorm"] = spells.bladestorm.icon
		lookup["#charge"] = spells.charge.icon
		lookup["#enrage"] = spells.enrage.icon
		lookup["#execute"] = spells.execute.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		--lookup["#ravager"] = spells.ravager.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		lookup["#whirlwind"] = spells.whirlwind.icon
		TRB.Data.lookup = lookup
		
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
		--targetData:AddSpellTracking(spells.deepWounds)
		--targetData:AddSpellTracking(spells.rend)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Protection
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.protection.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.protection)
		
		local lookup = TRB.Data.lookup or {}
		--lookup["#charge"] = spells.charge.icon
		--lookup["#deepWounds"] = spells.deepWounds.icon
		--lookup["#execute"] = spells.execute.icon
		lookup["#ignorePain"] = spells.ignorePain.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		--lookup["#ravager"] = spells.ravager.icon
		lookup["#rend"] = spells.rend.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		TRB.Data.lookup = lookup
		
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
						settings.warrior.arms.displayText.barText = TRB.Options.Warrior.ArmsLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.fury == nil or
						TwintopInsanityBarSettings.warrior.fury.displayText == nil then
						settings.warrior.fury.displayText.barText = TRB.Options.Warrior.FuryLoadDefaultBarTextSimpleSettings()
					end

					if  TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.protection == nil or
						TwintopInsanityBarSettings.warrior.protection.displayText == nil then
						settings.warrior.protection.displayText.barText = TRB.Options.Warrior.ProtectionLoadDefaultBarTextSimpleSettings()
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

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.warrior.arms == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.arms)
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.warrior.fury == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.fury)
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.warrior.protection == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.protection)
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

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local notZeroShowValue = 0
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		TRB.Functions.Bar:HideResourceBarGeneric(sharedSettings, force, notZeroShowValue)
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
		--[[if var == "$rend" then
			if talents:IsTalentActive(spells.rend) then
				valid = true
			end
		elseif var == "$rendCount" then
			if targetData.count[spells.rend.debuffId] > 0 then
				valid = true
			end
		elseif var == "$rendTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.rend.debuffId] ~= nil and
				target.spells[spells.rend.debuffId].remainingTime > 0 then
				valid = true
			end
		elseif var == "$deepWoundsCount" then
			if targetData.count[spells.deepWounds.id] > 0 then
				valid = true
			end
		elseif var == "$deepWoundsTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.deepWounds.id] ~= nil and
				target.spells[spells.deepWounds.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$resourceTotal" or var == "$rageTotal" then
			if currentResource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$passive" then
			if snapshots[spells.ravager.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
			if currentResource > 0 or snapshots[spells.ravager.id].buff.resource > 0 then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 2 then --Fury
		--[[if var == "$resourceTotal" or var == "$rageTotal" then
			if currentResource > 0 or snapshots[spells.ravager.id].buff.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$passive" then
			if snapshots[spells.bladestorm.id].buff.resource > 0 or snapshots[spells.ravager.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
			if currentResource > 0 or snapshots[spells.bladestorm.id].buff.resource > 0 or snapshots[spells.ravager.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$enrageTime" then
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
		--[[if var == "$rend" then
			if talents:IsTalentActive(spells.rend) then
				valid = true
			end
		elseif var == "$ignorePainAbsorb" then
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

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
		--[[if var == "$ravagerTicks" then
			if snapshots[spells.ravager.id].buff.isActive then
				valid = true
			end
		elseif var == "$ravagerResource" or var == "$ravagerRage" then
			if snapshots[spells.ravager.id].buff.isActive then
				valid = true
			end
		end]]
	end

	if valid == true then
		return valid
	end

	if var == "$resource" or var == "$rage" then
		if currentResource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$rageMax" then
		valid = true
	--[[elseif var == "$resourcePlusCasting" or var == "$ragePlusCasting" then
		if currentResource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
			valid = true
		end
	elseif var == "$overcap" or var == "$rageOvercap" or var == "$resourceOvercap" then
		local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
		if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) <= threshold then
			return true
		elseif settings.overcap.mode == "fixed" and settings.overcap.fixed <= threshold then
			return true
		end]]
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	--[[elseif var == "$suddenDeathTime" then
		if snapshots[spells.suddenDeath.id].buff.isActive then
			valid = true
		end]]
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local settings = TRB.Data.settings.warrior
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	if TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		if TRB.Functions.String:StartsWith(relativeToFrame, "IgnorePain") then
			return _G["TwintopResourceBarFrame_ComboPoint_1"], true
		elseif TRB.Functions.String:StartsWith(relativeToFrame, "ShieldBlock") then
			return _G["TwintopResourceBarFrame_ComboPoint_2"], true
		end
	end
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end