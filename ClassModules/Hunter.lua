local _, TRB = ...
if TRB.Data.character.classId ~= 3 then --Only do this if we're on a Hunter!
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
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
			serpentSting = 0
		},
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
		overcapCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.killCommand.id] = TRB.Classes.Snapshot:New(spells.killCommand)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.bestialWrath.id] = TRB.Classes.Snapshot:New(spells.bestialWrath)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.callOfTheWild.id] = TRB.Classes.Snapshot:New(spells.callOfTheWild)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.beastCleave.id] = TRB.Classes.Snapshot:New(spells.beastCleave)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.cobraSting.id] = TRB.Classes.Snapshot:New(spells.cobraSting, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.blackArrow.id] = TRB.Classes.Snapshot:New(spells.blackArrow)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.direBeastHawk.id] = TRB.Classes.Snapshot:New(spells.direBeastHawk)
	---@type TRB.Classes.Snapshot
	specCache.beastMastery.snapshotData.snapshots[spells.deathblow.id] = TRB.Classes.Snapshot:New(spells.deathblow)

	specCache.beastMastery.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Marksmanship

	specCache.marksmanship.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
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
		overcapCue = false,
		playedKillShotCue = false,
		playedAimedShotCue = true
	}
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.lockAndLoad.id] = TRB.Classes.Snapshot:New(spells.lockAndLoad)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.trueshot.id] = TRB.Classes.Snapshot:New(spells.trueshot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.steadyFocus.id] = TRB.Classes.Snapshot:New(spells.steadyFocus)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.aimedShot.id] = TRB.Classes.Snapshot:New(spells.aimedShot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.killShot.id] = TRB.Classes.Snapshot:New(spells.killShot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.burstingShot.id] = TRB.Classes.Snapshot:New(spells.burstingShot)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.blackArrow.id] = TRB.Classes.Snapshot:New(spells.blackArrow)
	---@type TRB.Classes.Snapshot
	specCache.marksmanship.snapshotData.snapshots[spells.deathblow.id] = TRB.Classes.Snapshot:New(spells.deathblow)

	specCache.marksmanship.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Survival
	specCache.survival.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
			serpentSting = 0
		},
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
		overcapCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.killCommand.id] = TRB.Classes.Snapshot:New(spells.killCommand)
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.wildfireBomb.id] = TRB.Classes.Snapshot:New(spells.wildfireBomb)
	---@type TRB.Classes.Snapshot
	specCache.survival.snapshotData.snapshots[spells.tipOfTheSpear.id] = TRB.Classes.Snapshot:New(spells.tipOfTheSpear)
	

	specCache.survival.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_BeastMastery()
	TRB.Functions.Character:FillSpecializationCacheSettings("hunter", "beastMastery")
end

local function Setup_Marksmanship()
	TRB.Functions.Character:FillSpecializationCacheSettings("hunter", "marksmanship")
end

local function Setup_Survival()
	TRB.Functions.Character:FillSpecializationCacheSettings("hunter", "survival")
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
		{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = spells.serpentSting.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$focus", description = L["HunterBeastMasteryBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterBeastMasteryBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterBeastMasteryBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["HunterBeastMasteryBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$regenFocus", description = "", printInSettings = false, color = false },
		{ variable = "$focusRegen", description = "", printInSettings = false, color = false },
		--[[{ variable = "$passive", description = L["HunterBeastMasteryBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$focusPlusCasting", description = L["HunterBeastMasteryBarTextVariable_focusPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$focusPlusPassive", description = L["HunterBeastMasteryBarTextVariable_focusPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$focusTotal", description = L["HunterBeastMasteryBarTextVariable_focusTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },

		{ variable = "$serpentSting", description = L["HunterBeastMasteryBarTextVariable_serpentSting"], printInSettings = true, color = false },
		{ variable = "$ssCount", description = L["HunterBeastMasteryBarTextVariable_ssCount"], printInSettings = true, color = false },
		{ variable = "$ssTime", description = L["HunterBeastMasteryBarTextVariable_ssTime"], printInSettings = true, color = false },

		{ variable = "$frenzyTime", description = L["HunterBeastMasteryBarTextVariable_frenzyTime"], printInSettings = true, color = false },
		{ variable = "$frenzyStacks", description = L["HunterBeastMasteryBarTextVariable_frenzyStacks"], printInSettings = true, color = false },
		
		{ variable = "$beastCleaveTime", description = L["HunterBeastMasteryBarTextVariable_beastCleaveTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
	}
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
		{ variable = "#burstingShot", icon = spells.burstingShot.icon, description = spells.burstingShot.name, printInSettings = true },
		{ variable = "#killShot", icon = spells.killShot.icon, description = spells.killShot.name, printInSettings = true },
		{ variable = "#lockAndLoad", icon = spells.lockAndLoad.icon, description = spells.lockAndLoad.name, printInSettings = true },
		{ variable = "#multiShot", icon = spells.multiShot.icon, description = spells.multiShot.name, printInSettings = true },
		{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = spells.rapidFire.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = spells.serpentSting.name, printInSettings = true },
		{ variable = "#steadyFocus", icon = spells.steadyFocus.icon, description = spells.steadyFocus.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$focus", description = L["HunterMarksmanshipBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterMarksmanshipBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterMarksmanshipBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["HunterMarksmanshipBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$regenFocus", description = "", printInSettings = false, color = false },
		{ variable = "$focusRegen", description = "", printInSettings = false, color = false },
		--[[{ variable = "$passive", description = L["HunterMarksmanshipBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$focusPlusCasting", description = L["HunterMarksmanshipBarTextVariable_focusPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$focusPlusPassive", description = L["HunterMarksmanshipBarTextVariable_focusPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$focusTotal", description = L["HunterMarksmanshipBarTextVariable_focusTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },]]

		{ variable = "$trueshotTime", description = L["HunterMarksmanshipBarTextVariable_trueshotTime"], printInSettings = true, color = false },
		{ variable = "$lockAndLoadTime", description = L["HunterMarksmanshipBarTextVariable_lockAndLoadTime"], printInSettings = true, color = false },

		--[[{ variable = "$steadyFocusTime", description = L["HunterMarksmanshipBarTextVariable_steadyFocusTime"], printInSettings = true, color = false },

		{ variable = "$serpentSting", description = L["HunterMarksmanshipBarTextVariable_serpentSting"], printInSettings = true, color = false },
		{ variable = "$ssCount", description = L["HunterMarksmanshipBarTextVariable_ssCount"], printInSettings = true, color = false },
		{ variable = "$ssTime", description = L["HunterMarksmanshipBarTextVariable_ssTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
	}
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

		{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = spells.arcaneShot.name, printInSettings = true },
		{ variable = "#harpoon", icon = spells.harpoon.icon, description = spells.harpoon.name, printInSettings = true },
		{ variable = "#killCommand", icon = spells.killCommand.icon, description = spells.killCommand.name, printInSettings = true },
		{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = spells.raptorStrike.name, printInSettings = true },
		{ variable = "#revivePet", icon = spells.revivePet.icon, description = spells.revivePet.name, printInSettings = true },
		{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = spells.scareBeast.name, printInSettings = true },
		{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = spells.serpentSting.name, printInSettings = true },
		{ variable = "#tipOfTheSpear", icon = spells.tipOfTheSpear.icon, description = spells.tipOfTheSpear.name, printInSettings = true },
		{ variable = "#tots", icon = spells.tipOfTheSpear.icon, description = spells.tipOfTheSpear.name, printInSettings = false },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$focus", description = L["HunterSurvivalBarTextVariable_focus"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$focusMax", description = L["HunterSurvivalBarTextVariable_focusMax"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["HunterSurvivalBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["HunterSurvivalBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$focusRegen", description = "", printInSettings = false, color = false },
		{ variable = "$regenFocus", description = "", printInSettings = false, color = false },
		--[[{ variable = "$passive", description = L["HunterSurvivalBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$focusPlusCasting", description = L["HunterSurvivalBarTextVariable_focusPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$focusPlusPassive", description = L["HunterSurvivalBarTextVariable_focusPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$focusTotal", description = L["HunterSurvivalBarTextVariable_focusTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },

		{ variable = "$serpentSting", description = L["HunterSurvivalBarTextVariable_serpentSting"], printInSettings = true, color = false },
		{ variable = "$ssCount", description = L["HunterSurvivalBarTextVariable_ssCount"], printInSettings = true, color = false },
		{ variable = "$ssTime", description = L["HunterSurvivalBarTextVariable_ssTime"], printInSettings = true, color = false },

		{ variable = "$toeFocus", description = L["HunterSurvivalBarTextVariable_toeFocus"], printInSettings = true, color = false },
		{ variable = "$toeTicks", description = L["HunterSurvivalBarTextVariable_toeTicks"], printInSettings = true, color = false },

		{ variable = "$totsTime", description = L["HunterSurvivalBarTextVariable_tipOfTheSpearTime"], printInSettings = true, color = false },
		{ variable = "$totsStacks", description = L["HunterSurvivalBarTextVariable_tipOfTheSpearStacks"], printInSettings = true, color = false },

		{ variable = "$wildfireBombCharges", description = L["HunterSurvivalBarTextVariable_wildfireBombCharges"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
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
	for _, v in pairs(resourceFrame.thresholds) do
		v:Hide();
	end

	for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
		if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
			TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
		end
		TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
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

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentFocusColor = sharedSettings.colors.text.current.color
	local castingFocusColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentFocusColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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
	local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, snapshotData.attributes.resource)
	--$casting
	local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
	--$passive
	local _regenFocus = 0
	--[[local _passiveFocus
	local _passiveFocusMinusRegen

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenFocus = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenFocus = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenFocus
	local regenFocus = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _regenFocus)
	
	--$beastCleaveTime
	local _beastCleaveTime = snapshots[spells.beastCleave.id].buff:GetRemainingTime(currentTime)
	local beastCleaveTime = TRB.Functions.BarText:TimerPrecision(_beastCleaveTime)

	if talents:IsTalentActive(spells.bloodFrenzy) and (snapshots[spells.callOfTheWild.id].buff:GetRemainingTime(currentTime)) > (snapshots[spells.beastCleave.id].buff.remaining) then
		_beastCleaveTime = snapshots[spells.callOfTheWild.id].buff.remaining
	end

	beastCleaveTime = TRB.Functions.BarText:TimerPrecision(_beastCleaveTime)
	
	_passiveFocus = _regenFocus
	_passiveFocusMinusRegen = _passiveFocus - _regenFocus

	local passiveFocus = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _passiveFocus)
	local passiveFocusMinusRegen = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _passiveFocusMinusRegen)
	--$focusTotal
	local _focusTotal = math.min(_passiveFocus + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
	--$focusPlusCasting
	local _focusPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
	--$focusPlusPassive
	local _focusPlusPassive = math.min(_passiveFocus + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

	--$frenzyTime
	local _frenzyTime = snapshots[spells.frenzy.id].buff:GetRemainingTime(currentTime)
	local frenzyTime = TRB.Functions.BarText:TimerPrecision(_frenzyTime)

	--$frenzyStacks
	local frenzyStacks = snapshots[spells.frenzy.id].buff.applications or 0


	--$ssCount and $ssTime
	local _serpentStingCount = targetData.count[spells.serpentSting.id] or 0
	local serpentStingCount = tostring(_serpentStingCount)
	local _serpentStingTime = 0
	
	if target ~= nil then
		_serpentStingTime = target.spells[spells.serpentSting.id].remainingTime or 0
	end

	local serpentStingTime

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.serpentSting.id].active then
			serpentStingCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _serpentStingCount)
			serpentStingTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_serpentStingTime))

		else
			serpentStingCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _serpentStingCount)
			serpentStingTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		serpentStingTime = TRB.Functions.BarText:TimerPrecision(_serpentStingTime)
	end]]

	----------------------------

	--[[Global_TwintopResourceBar.resource.passive = _passiveFocus
	Global_TwintopResourceBar.resource.regen = _regenFocus
	
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.ssCount = _serpentStingCount]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFocus
	lookup["$focus"] = currentFocus	
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$focusMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFocus
	--[[lookup["$frenzyTime"] = frenzyTime
	lookup["$frenzyStacks"] = frenzyStacks
	lookup["$focusPlusCasting"] = focusPlusCasting
	lookup["$focusTotal"] = focusTotal
	lookup["$resourcePlusCasting"] = focusPlusCasting
	lookup["$focusPlusCasting"] = focusPlusCasting
	lookup["$resourcePlusPassive"] = focusPlusPassive
	lookup["$focusPlusPassive"] = focusPlusPassive
	lookup["$resourceTotal"] = focusTotal	
	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookup["$passive"] = passiveFocusMinusRegen
	else
		lookup["$passive"] = passiveFocus
	end
	lookup["$beastCleaveTime"] = beastCleaveTime
	lookup["$serpentSting"] = ""
	lookup["$ssCount"] = serpentStingCount
	lookup["$ssTime"] = serpentStingTime
	lookup["$regen"] = regenFocus
	lookup["$regenFocus"] = regenFocus
	lookup["$focusRegen"] = regenFocus
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$focusOvercap"] = overcap]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$focus"] = snapshotData.attributes.resource
	lookupLogic["$focusMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	--[[lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
	lookupLogic["$frenzyTime"] = _frenzyTime
	lookupLogic["$frenzyStacks"] = frenzyStacks
	lookupLogic["$focusPlusCasting"] = _focusPlusCasting
	lookupLogic["$focusTotal"] = _focusTotal
	lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
	lookupLogic["$focusPlusCasting"] = _focusPlusCasting
	lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
	lookupLogic["$focusPlusPassive"] = _focusPlusPassive
	lookupLogic["$resourceTotal"] = _focusTotal
	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookupLogic["$passive"] = _passiveFocusMinusRegen
	else
		lookupLogic["$passive"] = _passiveFocus
	end
	lookupLogic["$beastCleaveTime"] = _beastCleaveTime
	lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
	lookupLogic["$ssCount"] = _serpentStingCount
	lookupLogic["$ssTime"] = _serpentStingTime
	lookupLogic["$regen"] = _regenFocus
	lookupLogic["$regenFocus"] = _regenFocus
	lookupLogic["$focusRegen"] = _regenFocus
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$focusOvercap"] = overcap]]
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

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentFocusColor = sharedSettings.colors.text.current.color
	local castingFocusColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentFocusColor = sharedSettings.colors.text.overcap.color
			castingFocusColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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
	local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, snapshotData.attributes.resource)
	--$casting
	local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
	--$passive
	--[[local _regenFocus = 0
	local _passiveFocus

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenFocus = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenFocus = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenFocus
	local regenFocus = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _regenFocus)
	_passiveFocus = _regenFocus

	local passiveFocus = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _passiveFocus)
	--$focusTotal
	local _focusTotal = math.min(_passiveFocus + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
	--$focusPlusCasting
	local _focusPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
	--$focusPlusPassive
	local _focusPlusPassive = math.min(_passiveFocus + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)]]

	--$trueshotTime
	local _trueshotTime = snapshots[spells.trueshot.id].buff:GetRemainingTime(currentTime)
	local trueshotTime = TRB.Functions.BarText:TimerPrecision(_trueshotTime)

	--[[--$steadyFocusTime
	local _steadyFocusTime = snapshots[spells.steadyFocus.id].buff:GetRemainingTime(currentTime)
	local steadyFocusTime = TRB.Functions.BarText:TimerPrecision(_steadyFocusTime)

	--$lockAndLoadTime
	local _lockAndLoadTime = snapshots[spells.lockAndLoad.id].buff:GetRemainingTime(currentTime)
	local lockAndLoadTime = TRB.Functions.BarText:TimerPrecision(_lockAndLoadTime)

	--$ssCount and $ssTime
	local _serpentStingCount = targetData.count[spells.serpentSting.id] or 0
	local serpentStingCount = tostring(_serpentStingCount)
	local _serpentStingTime = 0
	
	if target ~= nil then
		_serpentStingTime = target.spells[spells.serpentSting.id].remainingTime or 0
	end

	local serpentStingTime

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.serpentSting.id].active then
			serpentStingCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _serpentStingCount)
			serpentStingTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_serpentStingTime))
		else
			serpentStingCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _serpentStingCount)
			serpentStingTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		serpentStingTime = TRB.Functions.BarText:TimerPrecision(_serpentStingTime)
	end]]

	----------------------------

	--[[Global_TwintopResourceBar.resource.passive = _passiveFocus
	Global_TwintopResourceBar.resource.regen = _regenFocus
	
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.ssCount = _serpentStingCount]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFocus
	lookup["$focus"] = currentFocus	
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$focusMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFocus
	lookup["$trueshotTime"] = trueshotTime
	--[[lookup["$steadyFocusTime"] = steadyFocusTime
	lookup["$lockAndLoadTime"] = lockAndLoadTime
	lookup["$focusPlusCasting"] = focusPlusCasting
	lookup["$serpentSting"] = ""
	lookup["$ssCount"] = serpentStingCount
	lookup["$ssTime"] = serpentStingTime
	lookup["$focusTotal"] = focusTotal
	lookup["$resourcePlusCasting"] = focusPlusCasting
	lookup["$focusPlusCasting"] = focusPlusCasting
	lookup["$resourcePlusPassive"] = focusPlusPassive
	lookup["$focusPlusPassive"] = focusPlusPassive
	lookup["$resourceTotal"] = focusTotal
	lookup["$passive"] = passiveFocus
	lookup["$regen"] = regenFocus
	lookup["$regenFocus"] = regenFocus
	lookup["$focusRegen"] = regenFocus
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$focusOvercap"] = overcap]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$focus"] = snapshotData.attributes.resource
	lookupLogic["$focusMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$trueshotTime"] = _trueshotTime
	--[[lookupLogic["$steadyFocusTime"] = _steadyFocusTime
	lookupLogic["$lockAndLoadTime"] = _lockAndLoadTime
	lookupLogic["$focusPlusCasting"] = _focusPlusCasting
	lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
	lookupLogic["$ssCount"] = _serpentStingCount
	lookupLogic["$ssTime"] = _serpentStingTime
	lookupLogic["$focusTotal"] = _focusTotal
	lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
	lookupLogic["$focusPlusCasting"] = _focusPlusCasting
	lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
	lookupLogic["$focusPlusPassive"] = _focusPlusPassive
	lookupLogic["$resourceTotal"] = _focusTotal
	lookupLogic["$passive"] = _passiveFocus
	lookupLogic["$regen"] = _regenFocus
	lookupLogic["$regenFocus"] = _regenFocus
	lookupLogic["$focusRegen"] = _regenFocus
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$focusOvercap"] = overcap]]
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

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentFocusColor = sharedSettings.colors.text.current.color
	local castingFocusColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentFocusColor = sharedSettings.colors.text.overcap.color
			castingFocusColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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
	local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, snapshotData.attributes.resource)
	--$casting
	local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)

	--[[local _regenFocus = 0
	local _passiveFocus

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenFocus = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenFocus = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenFocus
	local regenFocus = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _regenFocus)
	_passiveFocus = _regenFocus

	--$passive
	local passiveFocus = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _passiveFocus)
	--$focusTotal
	local _focusTotal = math.min(_passiveFocus + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
	--$focusPlusCasting
	local _focusPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
	--$focusPlusPassive
	local _focusPlusPassive = math.min(_passiveFocus + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

	--$wildfireBombCharges
	local wildfireBombCharges = snapshots[spells.wildfireBomb.id].cooldown.charges
	
	--$ssCount and $ssTime
	local _serpentStingCount = targetData.count[spells.serpentSting.id] or 0
	local serpentStingCount = tostring(_serpentStingCount)
	local _serpentStingTime = 0
	
	if target ~= nil then
		_serpentStingTime = target.spells[spells.serpentSting.id].remainingTime or 0
	end

	local serpentStingTime

	--$totsTime 
	local _totsTime = snapshotData.snapshots[spells.tipOfTheSpear.id].buff:GetRemainingTime(currentTime)
	local totsTime = TRB.Functions.BarText:TimerPrecision(_totsTime)
	
	--$totsStacks
	local _totsStacks = snapshotData.snapshots[spells.tipOfTheSpear.id].buff.applications or 0
	local totsStacks = string.format("%s", _totsStacks)

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.serpentSting.id].active then
			serpentStingCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _serpentStingCount)
			serpentStingTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_serpentStingTime))
		else
			serpentStingCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _serpentStingCount)
			serpentStingTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		serpentStingTime = TRB.Functions.BarText:TimerPrecision(_serpentStingTime)
	end]]

	----------------------------

	--[[Global_TwintopResourceBar.resource.passive = _passiveFocus
	Global_TwintopResourceBar.resource.regen = _regenFocus
	
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.ssCount = _serpentStingCount]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFocus
	lookup["$focus"] = currentFocus	
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$focusMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFocus
	--[[lookup["$focusPlusCasting"] = focusPlusCasting
	lookup["$serpentSting"] = ""
	lookup["$ssCount"] = serpentStingCount
	lookup["$ssTime"] = serpentStingTime
	lookup["$wildfireBombCharges"] = wildfireBombCharges
	lookup["$focusTotal"] = focusTotal
	lookup["$resourcePlusCasting"] = focusPlusCasting
	lookup["$focusPlusCasting"] = focusPlusCasting
	lookup["$resourcePlusPassive"] = focusPlusPassive
	lookup["$focusPlusPassive"] = focusPlusPassive
	lookup["$resourceTotal"] = focusTotal
	lookup["$passive"] = passiveFocus
	lookup["$regen"] = regenFocus
	lookup["$regenFocus"] = regenFocus
	lookup["$focusRegen"] = regenFocus
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$focusOvercap"] = overcap
	lookup["$totsTime"] = totsTime
	lookup["$totsStacks"] = totsStacks]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$focus"] = snapshotData.attributes.resource
	lookupLogic["$focusMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	--[[lookupLogic["$focusPlusCasting"] = _focusPlusCasting
	lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
	lookupLogic["$ssCount"] = _serpentStingCount
	lookupLogic["$ssTime"] = _serpentStingTime
	lookupLogic["$wildfireBombCharges"] = wildfireBombCharges
	lookupLogic["$focusTotal"] = _focusTotal
	lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
	lookupLogic["$focusPlusCasting"] = _focusPlusCasting
	lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
	lookupLogic["$focusPlusPassive"] = _focusPlusPassive
	lookupLogic["$resourceTotal"] = _focusTotal
	lookupLogic["$passive"] = _passiveFocus
	lookupLogic["$regen"] = _regenFocus
	lookupLogic["$regenFocus"] = _regenFocus
	lookupLogic["$focusRegen"] = _regenFocus
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$focusOvercap"] = overcap
	lookupLogic["$totsTime"] = _totsTime
	lookupLogic["$totsStacks"] = _totsStacks]]
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
				--snapshotData.snapshots[spells.bestialWrath.id].buff:InitializeCustom(spells.bestialWrath.duration, currentTime)
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
			if spellId == spells.steadyShot.id then
				FillSnapshotDataCasting(spells.steadyShot)
			elseif spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
			UpdateCastingResourceFinal()
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
	
	--snapshots[spells.blackArrow.id].cooldown:Refresh()
end

local function UpdateSnapshot_BeastMastery()
	UpdateSnapshot()
	UpdateDarkRanger()

	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.bestialWrath.id].cooldown:Refresh()
	snapshots[spells.killCommand.id].cooldown:Refresh()
	
	snapshots[spells.frenzy.id].buff:Refresh(nil, false, "pet")]]
end

local function UpdateSnapshot_Marksmanship()
	UpdateSnapshot()
	UpdateDarkRanger()

	local currentTime = GetTime()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData
	local snapshots = snapshotData.snapshots

	--[[snapshots[spells.aimedShot.id].cooldown:Refresh()
	snapshots[spells.burstingShot.id].cooldown:Refresh()
	snapshots[spells.killShot.id].cooldown:Refresh()

	snapshots[spells.trueshot.id].buff:GetRemainingTime(currentTime)]]

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
	
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.wildfireBomb.id].cooldown:Refresh()
	snapshots[spells.killCommand.id].cooldown:Refresh()]]
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.hunter
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.beastMastery
		local specCacheSettings = TRB.Data.specCache.beastMastery.settings
		UpdateSnapshot_BeastMastery()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
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
						if spell.id == spells.blackArrow.id and talents:IsTalentActive(spells.blackArrow) then
							--[[local targetUnitHealth
							if target ~= nil then
								targetUnitHealth = target:GetHealthPercent()
							end]]
					
							if snapshots[spells.deathblow.id].buff.isActive and snapshotData.snapshots[spell.id].cooldown:IsUsable() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
							--[[elseif UnitIsDeadOrGhost("target") or targetUnitHealth == nil or (targetUnitHealth >= spell.attributes.healthMinimum and targetUnitHealth <= spell.attributes.healthMaximum) then
								showThreshold = false
							elseif snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable]]
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.killCommand.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then-- currentResource >= resourceAmount or snapshots[spells.cobraSting.id].buff.isActive then
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
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base

				--local bestialWrathCooldownRemaining = snapshots[spells.bestialWrath.id].cooldown:GetRemainingTime(currentTime)
				local affectingCombat = TRB.Data.character.inCombat

				local barBorderColor = specSettings.colors.bar.border

				if specSettings.colors.bar.beastCleave.enabled and TRB.Functions.Class:IsValidVariableForSpec("$beastCleaveTime") then
					barBorderColor = specSettings.colors.bar.beastCleave.color
				end

				--[[if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end]]

				--[[if bestialWrathCooldownRemaining <= gcd and affectingCombat and talents:IsTalentActive(spells.bestialWrath) then
					if specSettings.colors.bar.bestialWrathEnabled then
						barBorderColor = specSettings.colors.bar.borderbestialWrath
					end

					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barContainerFrame:SetAlpha(1.0)
					end
				else
					barContainerFrame:SetAlpha(1.0)
				end]]

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
		local specSettings = classSettings.marksmanship
		local specCacheSettings = TRB.Data.specCache.marksmanship.settings
		UpdateSnapshot_Marksmanship()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

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

				if TRB.Data.character.inCombat and specSettings.steadyFocus.enabled and talents:IsTalentActive(spells.steadyFocus) then
					local timeThreshold = 0

					if specSettings.steadyFocus.mode == "gcd" then
						local gcd = TRB.Functions.Character:GetCurrentGCDTime()
						timeThreshold = gcd * specSettings.steadyFocus.gcdsMax
					elseif specSettings.steadyFocus.mode == "time" then
						timeThreshold = specSettings.steadyFocus.timeMax
					end

					if snapshots[spells.steadyFocus.id].buff:GetRemainingTime(currentTime) <= timeThreshold then
						barBorderColor = specSettings.colors.bar.borderSteadyFocus
					end
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
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
						if spell.id == spells.aimedShot.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif snapshots[spells.lockAndLoad.id].buff.isActive or isUsable then -- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
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
							--[[local targetUnitHealth
							if target ~= nil then
								targetUnitHealth = target:GetHealthPercent()
							end]]

							if snapshots[spells.deathblow.id].buff.isActive and snapshotData.snapshots[spell.id].cooldown:IsUsable() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
									snapshotData.audio.playedKillShotCue = true
									PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
								end
							--[[elseif UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= spells.killShot.attributes.healthMinimum then
								showThreshold = false
								snapshotData.audio.playedKillShotCue = false]]
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								snapshotData.audio.playedKillShotCue = false
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
								if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
									snapshotData.audio.playedKillShotCue = true
									PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
								end
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								snapshotData.audio.playedKillShotCue = false
							end
						elseif spell.id == spells.blackArrow.id and talents:IsTalentActive(spells.blackArrow) then
							--[[local targetUnitHealth
							if target ~= nil then
								targetUnitHealth = target:GetHealthPercent()
							end]]
					
							if snapshots[spells.deathblow.id].buff.isActive and snapshotData.snapshots[spell.id].cooldown:IsUsable() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
									snapshotData.audio.playedKillShotCue = true
									PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
								end
							--[[elseif UnitIsDeadOrGhost("target") or targetUnitHealth == nil or (targetUnitHealth >= spell.attributes.healthMinimum and targetUnitHealth <= spell.attributes.healthMaximum) then
								showThreshold = false
								snapshotData.audio.playedKillShotCue = false]]
							elseif snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								snapshotData.audio.playedKillShotCue = false
							elseif isUsable then-- currentResource >= resourceAmount then
								if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
									snapshotData.audio.playedKillShotCue = true
									PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
								end
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								snapshotData.audio.playedKillShotCue = false
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
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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
		local specSettings = classSettings.survival
		local specCacheSettings = TRB.Data.specCache.survival.settings
		UpdateSnapshot_Survival()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

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

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
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
						elseif isUsable or spell:IsFree() then -- currentResource >= resourceAmount or spell:IsFree() then
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
				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end

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
	end
end

--[[
barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[@as TRB.Classes.SnapshotData]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.hunter

	local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Hunter.BeastMasterySpells|TRB.Classes.Hunter.MarksmanshipSpells|TRB.Classes.Hunter.SurvivalSpells]

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

		if entry.sourceGuid == TRB.Data.character.guid then
			if TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "beastMastery" then --Beast Mastery
				local specSettings = classSettings.beastMastery
				if entry.spellId == spells.frenzy.id and entry.destinationGuid == TRB.Data.character.petGuid then
					snapshots[entry.spellId].buff:Initialize(entry.type, nil, "pet")
				elseif entry.spellId == spells.killCommand.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.bestialWrath.id then
					snapshots[entry.spellId].cooldown:Initialize()
				elseif entry.spellId == spells.blackArrow.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.direBeastHawk.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.beastCleave.id then
					if entry.type == "SPELL_AURA_REMOVED" then
						if specSettings.audio.beastCleaveDown.enabled then
							PlaySoundFile(specSettings.audio.beastCleaveDown.sound, coreSettings.audio.channel.channel)
						end
					end
				end
			elseif TRB.Data.character.specId == 2 and TRB.Data.barConstructedForSpec == "marksmanship" then --Marksmanship
				if entry.spellId == spells.burstingShot.id then
					snapshots[entry.spellId].cooldown:Initialize()
				elseif entry.spellId == spells.aimedShot.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
						snapshotData.audio.playedAimedShotCue = false
					end
				elseif entry.spellId == spells.lockAndLoad.id then
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
						if TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.enabled then
							PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif entry.spellId == spells.blackArrow.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				end
			elseif TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "survival" then --Survival
				if entry.spellId == spells.wildfireBomb.id then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			end

			-- Spec agnostic

			if entry.spellId == spells.killShot.id then
				snapshotData.audio.playedKillShotCue = false
				snapshots[entry.spellId].cooldown:Initialize()
			elseif entry.spellId == spells.serpentSting.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
		end
	end
end)]]

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	--barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
		--targetData:AddSpellTracking(spells.serpentSting)

		TRB.Functions.RefreshLookupData = RefreshLookupData_BeastMastery
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.beastMastery.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.beastMastery)

		local lookup = TRB.Data.lookup or {}
		lookup["#beastCleave"] = spells.beastCleave.icon
		lookup["#bestialWrath"] = spells.bestialWrath.icon
		lookup["#cobraShot"] = spells.cobraShot.icon
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#serpentSting"] = spells.serpentSting.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
		--targetData:AddSpellTracking(spells.serpentSting)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Marksmanship
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.marksmanship.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.marksmanship)

		local lookup = TRB.Data.lookup or {}
		lookup["#aimedShot"] = spells.aimedShot.icon
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#burstingShot"] = spells.burstingShot.icon
		lookup["#killShot"] = spells.killShot.icon
		lookup["#lockAndLoad"] = spells.lockAndLoad.icon
		lookup["#multiShot"] = spells.multiShot.icon
		lookup["#rapidFire"] = spells.rapidFire.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#serpentSting"] = spells.serpentSting.icon
		lookup["#steadyFocus"] = spells.steadyFocus.icon
		lookup["#steadyShot"] = spells.steadyShot.icon
		lookup["#trueshot"] = spells.trueshot.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
		--targetData:AddSpellTracking(spells.serpentSting)
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Survival
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.survival.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.survival)

		local lookup = TRB.Data.lookup or {}
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#harpoon"] = spells.harpoon.icon
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#raptorStrike"] = spells.raptorStrike.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#serpentSting"] = spells.serpentSting.icon
		lookup["#tipOfTheSpear"] = spells.tipOfTheSpear.icon
		lookup["#tots"] = spells.tipOfTheSpear.icon
		lookup["#wingClip"] = spells.wingClip.icon
		lookup["#wildfireBomb"] = spells.wildfireBomb.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
						settings.hunter.beastMastery.displayText.barText = TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.marksmanship == nil or
						TwintopInsanityBarSettings.hunter.marksmanship.displayText == nil then
						settings.hunter.marksmanship.displayText.barText = TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.survival == nil or
						TwintopInsanityBarSettings.hunter.survival.displayText == nil then
						settings.hunter.survival.displayText.barText = TRB.Options.Hunter.SurvivalLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.beastMastery)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.hunter.marksmanship == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.marksmanship)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.hunter.survival == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.survival)
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

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local notZeroShowValue = TRB.Data.character.maxResource
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
		--[[if var == "$beastCleaveTime" then
			if snapshots[spells.beastCleave.id].buff.isActive or snapshots[spells.callOfTheWild.id].buff.isActive then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 2 then --Marksmanship
		if var == "$trueshotTime" then
			if snapshots[spells.trueshot.id].buff.isActive then
				valid = true
			end
		--[[elseif var == "$steadyFocusTime" then
			if snapshots[spells.steadyFocus.id].buff.isActive then
				valid = true
			end
		elseif var == "$lockAndLoadTime" then
			if snapshots[spells.lockAndLoad.id].buff.isActive then
				valid = true
			end]]
		end
	elseif TRB.Data.character.specId == 3 then --Survivial
		--[[if var == "$wildfireBombCharges" then
			if snapshots[spells.wildfireBomb.id].cooldown:IsUsable() then
				valid = true
			end
		elseif var == "$totsTime" then
			if snapshots[spells.tipOfTheSpear.id].buff.isActive then
				valid = true
			end
		elseif var == "$totsStacks" then
			if snapshots[spells.tipOfTheSpear.id].buff.applications > 0 then
				valid = true
			end
		end]]
	end

	if var == "$resource" or var == "$focus" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$focusMax" then
		valid = true
	--[[elseif var == "$resourceTotal" or var == "$focusTotal" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
			then
			valid = true
		end
	elseif var == "$resourcePlusCasting" or var == "$focusPlusCasting" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
			valid = true
		end
	elseif var == "$overcap" or var == "$focusOvercap" or var == "$resourceOvercap" then
		local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
		if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) <= threshold then
			return true
		elseif settings.overcap.mode == "fixed" and settings.overcap.fixed <= threshold then
			return true
		end
	elseif var == "$resourcePlusPassive" or var == "$focusPlusPassive" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end]]
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	--[[elseif var == "$passive" then
		if settings.generation.enabled then
			if snapshotData.attributes.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			elseif TRB.Data.character.specId == 1 and TRB.Functions.Class:IsValidVariableForSpec("$barbedShotFocus") then
				valid = true
			end
		end
	elseif var == "$regen" or var == "$regenFocus" or var == "$focusRegen" then
		if settings.generation.enabled and
			snapshotData.attributes.resource < TRB.Data.character.maxResource and
			((settings.generation.mode == "time" and settings.generation.time > 0) or
			(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
			valid = true
		end
	elseif var == "$ssCount" then
		if snapshotData.targetData.count[spells.serpentSting.id] > 0 then
			valid = true
		end
	elseif var == "$ssTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.serpentSting.id] ~= nil and
			target.spells[spells.serpentSting.id].remainingTime > 0 then
			valid = true
		end
	elseif var == "$serpentSting" then
		if talents:IsTalentActive(spells.serpentSting) then
			valid = true
		end]]
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end