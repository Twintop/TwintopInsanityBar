local _, TRB = ...
if TRB.Data.character.classId ~= 3 then --Only do this if we're on a Hunter!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	beastMastery = TRB.Classes.SpecCache:New(),
	marksmanship = TRB.Classes.SpecCache:New(),
	survival = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Beast Mastery
	specCache.beastMastery.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		}
	}

	specCache.beastMastery.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		petGuid = UnitGUID("pet"),
		maxResource = 100
	}
	
	---@type TRB.Classes.Hunter.BeastMasterySpells
	specCache.beastMastery.spellsData.spells = TRB.Classes.Hunter.BeastMasterySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	local spells = specCache.beastMastery.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

	specCache.beastMastery.snapshotData.attributes.resourceRegen = 0
	specCache.beastMastery.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.killCommand.id] = TRB.Classes.Snapshot:New(spells.killCommand)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.bestialWrath.id] = TRB.Classes.Snapshot:New(spells.bestialWrath)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.wailingArrow.id] = TRB.Classes.Snapshot:New(spells.wailingArrow)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.beastCleave.id] = TRB.Classes.Snapshot:New(spells.beastCleave)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.blackArrow.id] = TRB.Classes.Snapshot:New(spells.blackArrow)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.direBeastHawk.id] = TRB.Classes.Snapshot:New(spells.direBeastHawk)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.wildThrash.id] = TRB.Classes.Snapshot:New(spells.wildThrash)

	specCache.beastMastery.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Marksmanship

	specCache.marksmanship.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		}
	}

	specCache.marksmanship.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100
	}
	
	---@type TRB.Classes.Hunter.MarksmanshipSpells
	specCache.marksmanship.spellsData.spells = TRB.Classes.Hunter.MarksmanshipSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.marksmanship.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

	specCache.marksmanship.snapshotData.attributes.resourceRegen = 0
	specCache.marksmanship.snapshotData.audio = {
		playedKillShotCue = false,
		playedAimedShotCue = true
	}
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.trueshot.id] = TRB.Classes.Snapshot:New(spells.trueshot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.aimedShot.id] = TRB.Classes.Snapshot:New(spells.aimedShot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.killShot.id] = TRB.Classes.Snapshot:New(spells.killShot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.blackArrow.id] = TRB.Classes.Snapshot:New(spells.blackArrow)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.wailingArrow.id] = TRB.Classes.Snapshot:New(spells.wailingArrow)

	specCache.marksmanship.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Survival
	specCache.survival.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		}
	}

	specCache.survival.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100
	}
	
	---@type TRB.Classes.Hunter.SurvivalSpells
	specCache.survival.spellsData.spells = TRB.Classes.Hunter.SurvivalSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.survival.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]

	specCache.survival.snapshotData.attributes.resourceRegen = 0
	specCache.survival.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.killCommand.id] = TRB.Classes.Snapshot:New(spells.killCommand)
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.wildfireBomb.id] = TRB.Classes.Snapshot:New(spells.wildfireBomb)
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.boomstick.id] = TRB.Classes.Snapshot:New(spells.boomstick)
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.takedown.id] = TRB.Classes.Snapshot:New(spells.takedown)
	

	specCache.survival.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_BeastMastery()
	TRB.Functions.Character:FillSpecializationCacheSettings("hunter", "beastMastery")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Beast Mastery using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_BeastMastery()
	Setup_BeastMastery()
	specCache.beastMastery.spellsData:FillSpellData()
	local spells = specCache.beastMastery.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.beastMastery.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#beastCleave", icon = spells.beastCleave.icon, description = spells.beastCleave.name, printInSettings = true },
		{ variable = "#bestialWrath", icon = spells.bestialWrath.icon, description = spells.bestialWrath.name, printInSettings = true },
		{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = spells.cobraShot.name, printInSettings = true },
		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
	}
	specCache.beastMastery.barTextVariables.values = {
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

		{ variable = "$focus", description = L["HunterBeastMasteryBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterBeastMasteryBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterBeastMasteryBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$beastCleaveTime", description = L["HunterBeastMasteryBarTextVariable_beastCleaveTime"], printInSettings = true, color = false },
		{ variable = "$bestialWrathTime", description = L["HunterBeastMasteryBarTextVariable_bestialWrathTime"], printInSettings = true, color = false }
	}
end

local function Setup_Marksmanship()
	TRB.Functions.Character:FillSpecializationCacheSettings("hunter", "marksmanship")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Marksmanship using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Marksmanship()
	Setup_Marksmanship()
	specCache.marksmanship.spellsData:FillSpellData()
	local spells = specCache.marksmanship.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.marksmanship.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#aimedShot", icon = spells.aimedShot.icon, description = spells.aimedShot.name, printInSettings = true },
		{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = spells.arcaneShot.name, printInSettings = true },
		{ variable = "#killShot", icon = spells.killShot.icon, description = spells.killShot.name, printInSettings = true },
		{ variable = "#multiShot", icon = spells.multiShot.icon, description = spells.multiShot.name, printInSettings = true },
		{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = spells.rapidFire.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = spells.steadyShot.name, printInSettings = true },
		{ variable = "#trueshot", icon = spells.trueshot.icon, description = spells.trueshot.name, printInSettings = true }
	}
	specCache.marksmanship.barTextVariables.values = {
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

		{ variable = "$focus", description = L["HunterMarksmanshipBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterMarksmanshipBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterMarksmanshipBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$trueshotTime", description = L["HunterMarksmanshipBarTextVariable_trueshotTime"], printInSettings = true, color = false },
	}
end

local function Setup_Survival()
	TRB.Functions.Character:FillSpecializationCacheSettings("hunter", "survival")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Survival using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Survival()
	Setup_Survival()
	specCache.survival.spellsData:FillSpellData()
	local spells = specCache.survival.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.survival.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = spells.raptorStrike.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#takedown", icon = spells.takedown.icon, description = spells.takedown.name, printInSettings = true },
		{ variable = "#wildfireBomb", icon = spells.wildfireBomb.icon, description = spells.wildfireBomb.name, printInSettings = true },
		{ variable = "#wingClip", icon = spells.wingClip.icon, description = spells.wingClip.name, printInSettings = true },
	}
	specCache.survival.barTextVariables.values = {
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

		{ variable = "$focus", description = L["HunterSurvivalBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterSurvivalBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterSurvivalBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$takedownTime", description = L["HunterSurvivalBarTextVariable_takedownTime"], printInSettings = true, color = false },
	}
end

local function CalculateAbilityResourceValue(resource, threshold)
	local modifier = 1.0
	if TRB.Data.character.specId == 2 then
		if resource > 0 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
			local trueshot = TRB.Data.snapshotData.snapshots[spells.trueshot.id] --[[@as TRB.Classes.Snapshot]]
			if trueshot.buff.isActive and not threshold then
				modifier = modifier * trueshot.spell.attributes.resourcePercent
			end
		end
	end

	return resource * modifier
end

local function UpdateCastingResourceFinal()
	TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:UpdateTrackedSpells(currentTime)
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

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

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_BeastMastery()
	local specSettings = TRB.Data.settings.hunter.beastMastery
	local sharedSettings = TRB.Data.specCache["beastMastery"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()

	local currentFocusColor = sharedSettings.colors.text.current.color
	local castingFocusColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFocusColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingFocusColor = sharedSettings.colors.text.spending.color
	end

	--$focus
	local _currentFocus = snapshotData.attributes.resource
	local currentFocus
	local castingFocus
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentFocusColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentFocus))
		castingFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", snapshotData.casting.resourceFinal))
	else
		currentFocus = string.format("|c%s%.0f|r", currentFocusColor, _currentFocus)
		castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
	end
		
	--$beastCleaveTime
	local _beastCleaveTime = snapshots[spells.beastCleave.id].buff:GetRemainingTime(currentTime)
	local beastCleaveTime = TRB.Functions.BarText:TimerPrecision(_beastCleaveTime)

	beastCleaveTime = TRB.Functions.BarText:TimerPrecision(_beastCleaveTime)

		
	--$bestialWrathTime
	local _bestialWrathTime = snapshots[spells.bestialWrath.id].buff:GetRemainingTime(currentTime)
	local bestialWrathTime = TRB.Functions.BarText:TimerPrecision(_bestialWrathTime)

	bestialWrathTime = TRB.Functions.BarText:TimerPrecision(_bestialWrathTime)
	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFocus
	lookup["$focus"] = currentFocus	
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$focusMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFocus
	lookup["$beastCleaveTime"] = beastCleaveTime
	lookup["$bestialWrathTime"] = bestialWrathTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$focus"] = snapshotData.attributes.resource
	lookupLogic["$focusMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$beastCleaveTime"] = _beastCleaveTime
	lookupLogic["$bestialWrathTime"] = _bestialWrathTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Marksmanship()
	local specSettings = TRB.Data.settings.hunter.marksmanship
	local sharedSettings = TRB.Data.specCache["marksmanship"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()

	local currentFocusColor = sharedSettings.colors.text.current.color
	local castingFocusColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFocusColor = sharedSettings.colors.text.overThreshold.color
				castingFocusColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingFocusColor = sharedSettings.colors.text.spending.color
	end

	--$focus
	local _currentFocus = snapshotData.attributes.resource
	local currentFocus
	local castingFocus
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentFocusColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentFocus))
		castingFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", snapshotData.casting.resourceFinal))
	else
		currentFocus = string.format("|c%s%.0f|r", currentFocusColor, _currentFocus)
		castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
	end
	
	--$trueshotTime
	local _trueshotTime = snapshots[spells.trueshot.id].buff:GetRemainingTime(currentTime)
	local trueshotTime = TRB.Functions.BarText:TimerPrecision(_trueshotTime)

	----------------------------


	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFocus
	lookup["$focus"] = currentFocus
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$focusMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFocus
	lookup["$trueshotTime"] = trueshotTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$focus"] = snapshotData.attributes.resource
	lookupLogic["$focusMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$trueshotTime"] = _trueshotTime
	--lookupLogic["$steadyFocusTime"] = _steadyFocusTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Survival()
	local specSettings = TRB.Data.settings.hunter.survival
	local sharedSettings = TRB.Data.specCache["survival"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()

	local currentFocusColor = sharedSettings.colors.text.current.color
	local castingFocusColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFocusColor = sharedSettings.colors.text.overThreshold.color
				castingFocusColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingFocusColor = sharedSettings.colors.text.spending.color
	end

	--$focus
	local _currentFocus = snapshotData.attributes.resource
	local currentFocus
	local castingFocus
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentFocusColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentFocus))
		castingFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", snapshotData.casting.resourceFinal))
	else
		currentFocus = string.format("|c%s%.0f|r", currentFocusColor, _currentFocus)
		castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
	end
	
	--$takedownTime
	local _takedownTime = snapshots[spells.takedown.id].buff:GetRemainingTime(currentTime)
	local takedownTime = TRB.Functions.BarText:TimerPrecision(_takedownTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFocus
	lookup["$focus"] = currentFocus	
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$focusMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFocus
	lookup["$takedownTime"] = takedownTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$focus"] = snapshotData.attributes.resource
	lookupLogic["$focusMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$takedownTime"] = _takedownTime
	TRB.Data.lookupLogic = lookupLogic
end

---comment
---@param spell TRB.Classes.SpellBase
local function FillSnapshotDataCasting(spell)
	local currentTime = GetTime()
	local casting = TRB.Data.snapshotData.casting --[[@as TRB.Classes.SnapshotCasting]]
	casting.startTime = currentTime
	if spell.resource ~= nil and spell.resource > 0 then
		casting.resourceRaw = spell.resource
		casting.resourceFinal = CalculateAbilityResourceValue(spell.resource)
	else
		casting.resourceRaw = -spell:GetPrimaryResourceCost()
		casting.resourceFinal = casting.resourceRaw
	end
	casting.spellId = spell.id
	casting.icon = spell.icon
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
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.bestialWrath.castId then
				snapshotData.snapshots[spells.bestialWrath.id].buff:InitializeCustom(spells.bestialWrath.duration, currentTime)
			elseif spellId == spells.wildThrash.castId then
				snapshotData.snapshots[spells.beastCleave.id].buff:InitializeCustom(spells.beastCleave.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.aimedShot.id then
				FillSnapshotDataCasting(spells.aimedShot)
			elseif spellId == spells.steadyShot.id then
				FillSnapshotDataCasting(spells.steadyShot)
			elseif spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
			UpdateCastingResourceFinal()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.rapidFire.id then
				local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")
				casting.spellId = spells.rapidFire.id
				casting.icon = spells.rapidFire.icon
				casting.startTime = currentChannelStartTime / 1000
				casting.endTime = currentChannelEndTime / 1000
				local duration = casting.endTime - casting.startTime
				local remainingTime = casting.endTime - currentTime
				local ticksRemaining = math.ceil(remainingTime / (duration / (spells.rapidFire.attributes.shots - 1)))
				casting.resourceRaw = math.max(ticksRemaining * spells.rapidFire.resource, 0)
				casting.resourceFinal = CalculateAbilityResourceValue(casting.resourceRaw)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.trueshot.castId then
				local duration = spells.trueshot.duration
				if talents:IsTalentActive(spells.cantMissWontMiss) then
					duration = duration + spells.cantMissWontMiss.duration
				end
				snapshotData.snapshots[spells.trueshot.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
			UpdateCastingResourceFinal()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.takedown.id then
				local duration = spells.takedown.duration
				if talents:IsTalentActive(spells.cantMissWontMiss) then
					duration = duration + spells.cantMissWontMiss.duration
				end
				snapshotData.snapshots[spells.takedown.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.HunterBaseSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateDarkRanger()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells|TRB.Classes.Hunter.MarksmanshipSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateSnapshot_BeastMastery()
	UpdateSnapshot()
	UpdateDarkRanger()
	
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	snapshots[spells.beastCleave.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Marksmanship()
	UpdateSnapshot()
	UpdateDarkRanger()

	local currentTime = GetTime()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData

	if snapshotData.casting.spellId == spells.rapidFire.id then
		local casting = snapshotData.casting
		local duration = casting.endTime - casting.startTime
		local remainingTime = casting.endTime - currentTime
		local ticksRemaining = math.ceil(remainingTime / (duration / (spells.rapidFire.attributes.shots - 1)))
		casting.resourceRaw = math.max(ticksRemaining * spells.rapidFire.resource, 0)
		casting.resourceFinal = CalculateAbilityResourceValue(casting.resourceRaw)
	end
end

local function UpdateSnapshot_Survival()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.hunter
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

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

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.beastMastery
		local specCacheSettings = TRB.Data.specCache.beastMastery.settings
		UpdateSnapshot_BeastMastery()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]				
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetResourceFrame()
				local thresholds = primaryNode:GetThresholds()
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
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
						if spell.id == spells.blackArrow.id and talents:IsTalentActive(spells.blackArrow) then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.killCommand.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.wailingArrow.id then
							if not snapshots[spells.bestialWrath.id].buff.isActive then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
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

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				if specSettings.colors.bar.bestialWrath.enabled and snapshotData.snapshots[spells.bestialWrath.id].buff.isActive and affectingCombat then
					local timeLeft = snapshots[spells.bestialWrath.id].buff.remaining
					local timeThreshold = 0
					local useEndOfBestialWrathColor = false

					if specSettings.endOfBestialWrath.enabled then
						useEndOfBestialWrathColor = true
						if specSettings.endOfBestialWrath.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfBestialWrath.gcdsMax
						elseif specSettings.endOfBestialWrath.mode == "time" then
							timeThreshold = specSettings.endOfBestialWrath.timeMax
						end
					end

					if useEndOfBestialWrathColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.bestialWrathEnd.color
					elseif specSettings.colors.bar.bestialWrath.enabled then
						barColor = specSettings.colors.bar.bestialWrath.color
					end
				end

				if specSettings.colors.bar.beastCleave.enabled and snapshotData.snapshots[spells.beastCleave.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.beastCleave.color
				end

				if spells.bestialWrath:IsUsable() then
					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					end
				else
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				end

				-- Apply overcap border color if enabled
				if specSettings.colors.bar.overcapEnabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
			end
		end

		-- Update health bar
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
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.marksmanship
		local specCacheSettings = TRB.Data.specCache.marksmanship.settings
		UpdateSnapshot_Marksmanship()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetResourceFrame()
				local thresholds = primaryNode:GetThresholds()
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
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
						if spell.id == spells.aimedShot.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end

							if specSettings.audio.aimedShot.enabled and (not snapshotData.audio.playedAimedShotCue) and snapshots[spells.aimedShot.id].cooldown:IsUsable() then
								local remainingCd = snapshots[spells.aimedShot.id].cooldown:GetRemainingTime()
								local timeThreshold = 0
								local spellInfo = C_Spell.GetSpellInfo(spell.id) --[[@as SpellInfo]]
								local castTime = spellInfo.castTime / 1000
								if specSettings.audio.aimedShot.mode == "gcd" then
									timeThreshold = gcd * specSettings.audio.aimedShot.gcds
								elseif specSettings.audio.aimedShot.mode == "time" then
									timeThreshold = specSettings.audio.aimedShot.time
								end

								timeThreshold = timeThreshold + castTime

								if snapshots[spell.id].cooldown.charges == 2 or timeThreshold >= remainingCd then
									snapshotData.audio.playedAimedShotCue = true
									PlaySoundFile(specSettings.audio.aimedShot.sound, coreSettings.audio.channel.channel)
								end
							elseif snapshots[spell.id].cooldown.charges == 2 then
								snapshotData.audio.playedAimedShotCue = true
							end
						elseif spell.id == spells.killShot.id and not talents:IsTalentActive(spells.blackArrow) then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								snapshotData.audio.playedKillShotCue = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
								if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
									snapshotData.audio.playedKillShotCue = true
									PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
								end
							else
								-- Hide the threshold if we can't use it
								showThreshold = false
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								snapshotData.audio.playedKillShotCue = false
							end
						elseif spell.id == spells.blackArrow.id and talents:IsTalentActive(spells.blackArrow) then			
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								snapshotData.audio.playedKillShotCue = false
							elseif isUsable then
								if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
									snapshotData.audio.playedKillShotCue = true
									PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
								end
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								-- Hide the threshold if we can't use it
								showThreshold = false
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								snapshotData.audio.playedKillShotCue = false
							end
						elseif spell.id == spells.wailingArrow.id then
							if not snapshots[spells.trueshot.id].buff.isActive then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
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

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local barColor = specSettings.colors.bar.base

				if snapshots[spells.trueshot.id].buff.isActive then
					local timeThreshold = 0
					local useEndOfTrueshotColor = false

					if specSettings.endOfTrueshot.enabled then
						useEndOfTrueshotColor = true
						if specSettings.endOfTrueshot.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfTrueshot.gcdsMax
						elseif specSettings.endOfTrueshot.mode == "time" then
							timeThreshold = specSettings.endOfTrueshot.timeMax
						end
					end

					if useEndOfTrueshotColor and snapshots[spells.trueshot.id].buff:GetRemainingTime() <= timeThreshold then
						barColor = specSettings.colors.bar.trueshotEnding
					else
						barColor = specSettings.colors.bar.trueshot
					end
				end

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				-- Apply overcap border color if enabled
				if specSettings.colors.bar.overcapEnabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
			end
		end

		-- Update health bar
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
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.survival
		local specCacheSettings = TRB.Data.specCache.survival.settings
		UpdateSnapshot_Survival()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetResourceFrame()
				local thresholds = primaryNode:GetThresholds()
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
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
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable or spell:IsFree() then
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

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local barColor = specSettings.colors.bar.base

				if snapshots[spells.takedown.id].buff.isActive then
					local timeThreshold = 0
					local useEndOfTakedownColor = false

					if specSettings.endOfTakedown.enabled then
						useEndOfTakedownColor = true
						if specSettings.endOfTakedown.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfTakedown.gcdsMax
						elseif specSettings.endOfTakedown.mode == "time" then
							timeThreshold = specSettings.endOfTakedown.timeMax
						end
					end

					if useEndOfTakedownColor and snapshots[spells.takedown.id].buff:GetRemainingTime() <= timeThreshold then
						barColor = specSettings.colors.bar.takedownEnd.color
					elseif specSettings.colors.bar.takedown.enabled then
						barColor = specSettings.colors.bar.takedown.color
					end
				end

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				-- Apply overcap border color if enabled
				if specSettings.colors.bar.overcapEnabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
			end
		end

		-- Update health bar
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
		specCache.beastMastery.talents:GetTalents()
		FillSpellData_BeastMastery()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.beastMastery)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_BeastMastery
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.beastMastery.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#beastCleave"] = spells.beastCleave.icon
		lookup["#bestialWrath"] = spells.bestialWrath.icon
		lookup["#cobraShot"] = spells.cobraShot.icon
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "beastMastery" then
			talents = specCache.beastMastery.talents
			TRB.Data.barConstructedForSpec = "beastMastery"
			ConstructResourceBar(specCache.beastMastery.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.marksmanship.talents:GetTalents()
		FillSpellData_Marksmanship()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.marksmanship)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Marksmanship
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.marksmanship.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#aimedShot"] = spells.aimedShot.icon
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#killShot"] = spells.killShot.icon
		lookup["#multiShot"] = spells.multiShot.icon
		lookup["#rapidFire"] = spells.rapidFire.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#steadyShot"] = spells.steadyShot.icon
		lookup["#trueshot"] = spells.trueshot.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "marksmanship" then
			talents = specCache.marksmanship.talents
			TRB.Data.barConstructedForSpec = "marksmanship"
			ConstructResourceBar(specCache.marksmanship.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.survival.talents:GetTalents()
		FillSpellData_Survival()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.survival)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Survival
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.survival.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#raptorStrike"] = spells.raptorStrike.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#takedown"] = spells.takedown.icon
		lookup["#wingClip"] = spells.wingClip.icon
		lookup["#wildfireBomb"] = spells.wildfireBomb.icon
		lookup["#takedown"] = spells.takedown.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "survival" then
			talents = specCache.survival.talents
			TRB.Data.barConstructedForSpec = "survival"
			ConstructResourceBar(specCache.survival.settings)
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
	
	if TRB.Data.character.classId == 3 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Hunter.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.beastMastery == nil or
						TwintopInsanityBarSettings.hunter.beastMastery.displayText == nil then
						settings.hunter.beastMastery.displayText.barText = TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.marksmanship == nil or
						TwintopInsanityBarSettings.hunter.marksmanship.displayText == nil then
						settings.hunter.marksmanship.displayText.barText = TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.survival == nil or
						TwintopInsanityBarSettings.hunter.survival.displayText == nil then
						settings.hunter.survival.displayText.barText = TRB.Options.Hunter.SurvivalLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.hunter ~= true then
						TRB.Data.settings.hunter.beastMastery.displayText.barText = TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSettings()
						TRB.Data.settings.hunter.marksmanship.displayText.barText = TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSettings()
						TRB.Data.settings.hunter.survival.displayText.barText = TRB.Options.Hunter.SurvivalLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.hunter = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Hunter"])
					end
				else
					local settings = TRB.Options.Hunter.LoadDefaultSettings(true)
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
						TRB.Data.settings.hunter.beastMastery = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["HunterBeastMasteryFull"], TRB.Data.settings.hunter.beastMastery)
						TRB.Data.settings.hunter.marksmanship = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["HunterMarksmanshipFull"], TRB.Data.settings.hunter.marksmanship)
						TRB.Data.settings.hunter.survival = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["HunterSurvivalFull"], TRB.Data.settings.hunter.survival)
						
						FillSpellData_BeastMastery()
						FillSpellData_Marksmanship()
						FillSpellData_Survival()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Hunter.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "hunter"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Focus, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Focus, false)

	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "beastMastery"
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "marksmanship"
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "survival"
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.hunter.beastMastery == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.hunter.marksmanship == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.hunter.survival == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
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
			-- Hunter has no secondary bar
			local showPrimary = false
			if not forceHideAll then
				if sharedSettings.displayBar.primary == "always" then
					showPrimary = true
				elseif sharedSettings.displayBar.primary == "combat" then
					showPrimary = affectingCombat or inVehicle
				end
				-- "never" means showPrimary stays false
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

			-- Apply health bar visibility
			if barGroups and barGroups.health then
				if showHealth then
					barGroups.health:Show()
					barGroups.health:ShowNodes(1)
				else
					barGroups.health:Hide()
				end
			end

			-- Track if the bar is showing
			snapshotData.attributes.isTracking = showPrimary or showHealth
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
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
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spells
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
		settings = TRB.Data.settings.hunter.beastMastery
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
		settings = TRB.Data.settings.hunter.marksmanship
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
		settings = TRB.Data.settings.hunter.survival
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Beast Mastery		
		if var == "$beastCleaveTime" then
			if snapshots[spells.beastCleave.id].buff.isActive then
				valid = true
			end
		elseif var == "$bestialWrathTime" then
			if snapshots[spells.bestialWrath.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then --Marksmanship
		if var == "$trueshotTime" then
			if snapshots[spells.trueshot.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then --Survivial
		if var == "$takedownTime" then
			if snapshots[spells.takedown.id].buff.isActive then
				valid = true
			end
		end
	end

	if var == "$resource" or var == "$focus" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$focusMax" then
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
	elseif normalizedRelativeFrame == "HealthBar" then
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

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end