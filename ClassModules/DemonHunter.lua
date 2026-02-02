local _, TRB = ...
if TRB.Data.character.classId ~= 12 then --Only do this if we're on a DemonHunter!
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
	havoc = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	vengeance = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	devourer = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Havoc
	specCache.havoc.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
		burningHatred = {
			fury = 0,
			ticks = 0,
			time = 0
		},
		tacticalRetreat = {
			fury = 0,
			ticks = 0,
			time = 0
		}
	}

	specCache.havoc.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 120,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.DemonHunter.HavocSpells
	specCache.havoc.spellsData.spells = TRB.Classes.DemonHunter.HavocSpells:New()
	local spells = specCache.havoc.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]

	specCache.havoc.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.bladeDance.id] = TRB.Classes.Snapshot:New(spells.bladeDance)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.chaosNova.id] = TRB.Classes.Snapshot:New(spells.chaosNova)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.deathSweep.id] = TRB.Classes.Snapshot:New(spells.deathSweep)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.eyeBeam.id] = TRB.Classes.Snapshot:New(spells.eyeBeam)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.throwGlaive.id] = TRB.Classes.Snapshot:New(spells.throwGlaive)

	-- vengeance
	specCache.vengeance.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
		burningHatred = {
			fury = 0,
			ticks = 0
		},
		tacticalRetreat = {
			fury = 0,
			ticks = 0
		}
	}

	specCache.vengeance.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 120,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.DemonHunter.VengeanceSpells
	specCache.vengeance.spellsData.spells = TRB.Classes.DemonHunter.VengeanceSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.vengeance.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

	specCache.vengeance.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.chaosNova.id] = TRB.Classes.Snapshot:New(spells.chaosNova)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.felDevastation.id] = TRB.Classes.Snapshot:New(spells.felDevastation)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis)
	
	-- Devourer
	specCache.devourer.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
	}

	specCache.devourer.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 120,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.DemonHunter.DevourerSpells
	specCache.devourer.spellsData.spells = TRB.Classes.DemonHunter.DevourerSpells:New()
	local spells = specCache.devourer.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]

	specCache.devourer.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.devourer.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis, nil, "always")
	-----@type TRB.Classes.Snapshot
	--specCache.devourer.snapshotData.snapshots[spells.voidMetamorphosis.id] = TRB.Classes.Snapshot:New(spells.voidMetamorphosis, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.devourer.snapshotData.snapshots[spells.voidRay.id] = TRB.Classes.Snapshot:New(spells.voidRay)
	---@type TRB.Classes.Snapshot
	specCache.devourer.snapshotData.snapshots[spells.soulFragments.id] = TRB.Classes.Snapshot:New(spells.soulFragments, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.devourer.snapshotData.snapshots[spells.collapsingStar.id] = TRB.Classes.Snapshot:New(spells.collapsingStar, nil, "always")
end

local function Setup_Havoc()
	TRB.Functions.Character:FillSpecializationCacheSettings("demonhunter", "havoc")

	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()

	-- Create bar groups for Havoc using new OOP system
	TRB.Frames.barGroups = TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Havoc()
	Setup_Havoc()
	specCache.havoc.spellsData:FillSpellData()
	local spells = specCache.havoc.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.havoc.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#annihilation", icon = spells.annihilation.icon, description = spells.annihilation.name, printInSettings = true },
		{ variable = "#bladeDance", icon = spells.bladeDance.icon, description = spells.bladeDance.name, printInSettings = true },
		{ variable = "#blindFury", icon = spells.blindFury.icon, description = spells.blindFury.name, printInSettings = true },
		{ variable = "#chaosNova", icon = spells.chaosNova.icon, description = spells.chaosNova.name, printInSettings = true },
		{ variable = "#chaosStrike", icon = spells.chaosStrike.icon, description = spells.chaosStrike.name, printInSettings = true },
		{ variable = "#deathSweep", icon = spells.deathSweep.icon, description = spells.deathSweep.name, printInSettings = true },
		{ variable = "#eyeBeam", icon = spells.eyeBeam.icon, description = spells.eyeBeam.name, printInSettings = true },
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
	}
	specCache.havoc.barTextVariables.values = {
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
		
		{ variable = "$fury", description = L["DemonHunterHavocBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterHavocBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterHavocBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$metaTime", description = L["DemonHunterHavocBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Vengeance()
	TRB.Functions.Character:FillSpecializationCacheSettings("demonhunter", "vengeance")

	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()

	-- Create bar groups for Vengeance using new OOP system
	TRB.Frames.barGroups = TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Vengeance()
	Setup_Vengeance()
	specCache.vengeance.spellsData:FillSpellData()
	local spells = specCache.vengeance.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.vengeance.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#soulFragments", icon = spells.soulFragments.icon, description = spells.soulFragments.name, printInSettings = true },
	}
	specCache.vengeance.barTextVariables.values = {
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
		
		{ variable = "$fury", description = L["DemonHunterVengeanceBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterVengeanceBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterVengeanceBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$soulFragments", description = L["DemonHunterVengeanceBarTextVariable_soulFragments"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulFragmentsMax", description = L["DemonHunterVengeanceBarTextVariable_soulFragmentsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$metaTime", description = L["DemonHunterVengeanceBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Devourer()
	TRB.Functions.Character:FillSpecializationCacheSettings("demonhunter", "devourer")

	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()

	-- Create bar groups for Devourer using new OOP system
	TRB.Frames.barGroups = TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Devourer()
	Setup_Devourer()
	specCache.devourer.spellsData:FillSpellData()
	local spells = specCache.devourer.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.devourer.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#collapsingStar", icon = spells.collapsingStar.icon, description = spells.collapsingStar.name, printInSettings = true },
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidRay", icon = spells.voidRay.icon, description = spells.voidRay.name, printInSettings = true },
	}
	specCache.devourer.barTextVariables.values = {
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
		
		{ variable = "$fury", description = L["DemonHunterHavocBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterHavocBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterHavocBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$soulFragments", description = L["DemonHunterDevourerBarTextVariable_soulFragments"], printInSettings = true, color = false },
		{ variable = "$collapsingStar", description = "", printInSettings = false, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulFragmentsMax", description = L["DemonHunterDevourerBarTextVariable_soulFragmentsMax"], printInSettings = true, color = false },
		{ variable = "$collapsingStarMax", description = "", printInSettings = false, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$metaTime", description = L["DemonHunterDevourerBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidRayUsable", description = L["DemonHunterDevourerBarTextVariable_voidRayUsable"], printInSettings = true, color = false },
		{ variable = "$collapsingStarUsable", description = L["DemonHunterDevourerBarTextVariable_collapsingStarUsable"], printInSettings = true, color = false },
	}
end

local function RefreshTargetTracking()
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			-- Clear old thresholds
			primaryNode:ClearThresholds()

			-- Create new threshold frames parented to the BarNode's resourceFrame
			for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		-- Construct the bar groups (sets dimensions, colors, textures, positioning)
		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Show/hide secondary bar based on spec (using BarGroups, not legacy frames)
	if TRB.Data.character.specId == 1 then -- Havoc - no secondary bar
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
	elseif TRB.Data.character.specId == 2 then -- Vengeance - Soul Fragments bar with threshold dividers
		if barGroups and barGroups.secondary then
			-- Set up the secondary bar structure with 1 node
			barGroups.secondary:SetNodeCount(1)
			local sfNode = barGroups.secondary:GetNode(1)
			if sfNode then
				sfNode:SetMinMax(0, 6) -- 0-6 Soul Fragments
				
				-- Create 5 threshold dividers to create 6 segments
				sfNode:ClearThresholds()
				for thresholdId = 1, 5 do
					local thresholdFrame = CreateFrame("Frame", nil, sfNode:GetResourceFrame())
					TRB.Functions.Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
					sfNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then -- Devourer - has secondary bar (Soul Fragments/Collapsing Star)
		if barGroups and barGroups.secondary then
			-- Set up the secondary bar structure, but don't show it yet
			-- HideResourceBar() will determine visibility based on settings
			barGroups.secondary:SetNodeCount(1)
			local sfNode = barGroups.secondary:GetNode(1)
			if sfNode then
				sfNode:SetMinMax(0, 50)
				
				-- Create 1 threshold for Collapsing Star
				sfNode:ClearThresholds()
				local thresholdFrame = CreateFrame("Frame", nil, sfNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
				sfNode:RegisterThreshold(thresholdFrame)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Havoc()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.havoc
	local sharedSettings = TRB.Data.specCache["havoc"].settings
	local normalizedResource = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	--Spec specific implementation

	local currentFuryColor = sharedSettings.colors.text.current.color
	local castingFuryColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= normalizedResource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFuryColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	-- Apply overcap color if enabled (takes precedence over overThreshold)
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentFury = normalizedResource
	local currentFury
	local _castingFury = snapshotData.casting.resourceFinal
	local castingFury
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentFuryColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentFury = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentFury))
		castingFury = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor")))
	else
		currentFury = string.format("|c%s%s|r", currentFuryColor, _currentFury)
		castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
	end

	--$metamorphosisTime
	local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
	local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFury
	lookup["$fury"] = currentFury
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$furyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFury
	lookup["$metaTime"] = metamorphosisTime
	lookup["$metamorphosisTime"] = metamorphosisTime
	lookup["$voidMetaTime"] = metamorphosisTime
	lookup["$voidMetamorphosisTime"] = metamorphosisTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedResource
	lookupLogic["$fury"] = normalizedResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$furyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = _castingFury
	lookupLogic["$metaTime"] = _metamorphosisTime
	lookupLogic["$metamorphosisTime"] = _metamorphosisTime
	lookupLogic["$voidMetaTime"] = _metamorphosisTime
	lookupLogic["$voidMetamorphosisTime"] = _metamorphosisTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Vengeance()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.vengeance
	local sharedSettings = TRB.Data.specCache["vengeance"].settings
	local normalizedResource = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	--Spec specific implementation

	local currentFuryColor = sharedSettings.colors.text.current.color
	local castingFuryColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= normalizedResource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFuryColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	-- Apply overcap color if enabled (takes precedence over overThreshold)
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentFury = normalizedResource
	local currentFury
	local _castingFury = snapshotData.casting.resourceFinal
	local castingFury
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentFuryColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentFury = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentFury))
		castingFury = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor")))
	else
		currentFury = string.format("|c%s%s|r", currentFuryColor, _currentFury)
		castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
	end
	
	--$metamorphosisTime
	local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
	local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

	--$soulFragments
	local _soulFragments = snapshotData.attributes.resource2
	local soulFragments = string.format("%s", _soulFragments)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFury
	lookup["$fury"] = currentFury
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$furyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFury
	lookup["$metaTime"] = metamorphosisTime
	lookup["$metamorphosisTime"] = metamorphosisTime
	lookup["$voidMetaTime"] = metamorphosisTime
	lookup["$voidMetamorphosisTime"] = metamorphosisTime
	lookup["$soulFragments"] = soulFragments
	lookup["$comboPoints"] = soulFragments
	lookup["$soulFragmentsMax"] = spells.soulFragments.attributes.maxResource
	lookup["$comboPointsMax"] = spells.soulFragments.attributes.maxResource
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedResource
	lookupLogic["$fury"] = normalizedResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$furyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = _castingFury
	lookupLogic["$metaTime"] = _metamorphosisTime
	lookupLogic["$metamorphosisTime"] = _metamorphosisTime
	lookupLogic["$voidMetaTime"] = _metamorphosisTime
	lookupLogic["$voidMetamorphosisTime"] = _metamorphosisTime
	lookupLogic["$soulFragments"] = _soulFragments
	lookupLogic["$comboPoints"] = _soulFragments
	lookupLogic["$soulFragmentsMax"] = spells.soulFragments.attributes.maxResource
	lookupLogic["$comboPointsMax"] = spells.soulFragments.attributes.maxResource
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Devourer()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.devourer
	local sharedSettings = TRB.Data.specCache["devourer"].settings
	local normalizedResource = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	--Spec specific implementation

	local currentFuryColor = sharedSettings.colors.text.current.color
	local castingFuryColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= normalizedResource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFuryColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	-- Apply overcap color if enabled (takes precedence over overThreshold)
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentFury = normalizedResource
	local currentFury
	local _castingFury = snapshotData.casting.resourceFinal
	local castingFury
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentFuryColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentFury = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentFury))
		castingFury = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor")))
	else
		currentFury = string.format("|c%s%s|r", currentFuryColor, _currentFury)
		castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
	end

	--$soulFragments
	local _soulFragments = snapshotData.attributes.resource2
	local soulFragments = string.format("%s", _soulFragments)

	--$soulFragmentsMax
	local _soulFragmentsMax = snapshotData.attributes.maxResource2
	local soulFragmentsMax = string.format("%s", _soulFragmentsMax)

	-- If Metamorphosis is active and Collapsing Star talent is not selected, Soul Fragments (Collapsing Star values, really) are disabled
	local metaActive = snapshotData.snapshots[spells.metamorphosis.id].buff.isActive
	if metaActive and not talents:IsTalentActive(spells.collapsingStar) then
		_soulFragments = 0
		soulFragments = ""
		_soulFragmentsMax = 0
		soulFragmentsMax = ""
	end

	-- $voidRayUsable (false while Metamorphosis is active), $collapsingStarUsable
	local _voidRayUsable = (not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive) and (spells.voidRay:IsUsable())
	local _collapsingStarUsable = snapshotData.snapshots[spells.collapsingStar.id].buff.applications >= spells.collapsingStarThreshold.resource
	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFury
	lookup["$fury"] = currentFury
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$furyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFury
	lookup["$soulFragments"] = soulFragments
	lookup["$comboPoints"] = soulFragments
	lookup["$collapsingStars"] = soulFragments
	lookup["$soulFragmentsMax"] = soulFragmentsMax
	lookup["$comboPointsMax"] = soulFragmentsMax
	lookup["$collapsingStarsMax"] = soulFragmentsMax
	lookup["$metaTime"] = ""
	lookup["$metamorphosisTime"] = ""
	lookup["$voidMetaTime"] = ""
	lookup["$voidMetamorphosisTime"] = ""
	lookup["$voidRayUsable"] = ""
	lookup["$collapsingStarUsable"] = ""
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedResource
	lookupLogic["$fury"] = normalizedResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$furyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = _castingFury
	lookupLogic["$soulFragments"] = _soulFragments
	lookupLogic["$comboPoints"] = _soulFragments
	lookupLogic["$collapsingStars"] = _soulFragments
	lookupLogic["$soulFragmentsMax"] = soulFragmentsMax
	lookupLogic["$comboPointsMax"] = soulFragmentsMax
	lookupLogic["$collapsingStarsMax"] = soulFragmentsMax
	lookupLogic["$metaTime"] = 0
	lookupLogic["$metamorphosisTime"] = 0
	lookupLogic["$voidMetaTime"] = 0
	lookupLogic["$voidMetamorphosisTime"] = 0
	lookupLogic["$voidRayUsable"] = _voidRayUsable
	lookupLogic["$collapsingStarUsable"] = _collapsingStarUsable
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

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			if casting.spellId ~= spells.eyeBeam.id and spellId == spells.eyeBeam.id and talents:IsTalentActive(spells.blindFury) then
				local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")

				casting.spellId = spells.eyeBeam.id
				casting.startTime = currentChannelStartTime / 1000
				casting.endTime = currentChannelEndTime / 1000
				casting.icon = spells.eyeBeam.icon
				local remainingTime = casting.endTime - currentTime
				--TODO: use SnapshotBuff:UpdateTicks() instead?
				local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
				local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
				casting.resourceRaw = math.max(resource, 0)
				casting.resourceFinal = casting.resourceRaw

				if talents:IsTalentActive(spells.demonic) then
					snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(spells.demonic.duration + (casting.endTime - casting.startTime), currentTime)
				end
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.metamorphosis.castId then
				snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(spells.metamorphosis.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.metamorphosis.castId then
				local duration = spells.metamorphosis.duration

				if talents:IsTalentActive(spells.vengefulBeast) then
					duration = duration + spells.vengefulBeast.duration
				end

				snapshotData.snapshots[spells.metamorphosis.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			if casting.spellId ~= spells.voidRay.id then
				local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")

				casting.spellId = spells.voidRay.id
				casting.startTime = currentChannelStartTime / 1000
				casting.endTime = currentChannelEndTime / 1000
				casting.icon = spells.voidRay.icon
				local remainingTime = casting.endTime - currentTime
				--TODO: use SnapshotBuff:UpdateTicks() instead?
				--[[local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
				local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
				casting.resourceRaw = math.max(resource, 0)
				casting.resourceFinal = casting.resourceRaw]]
			end
		end
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells|TRB.Classes.DemonHunter.VengeanceSpells|TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Havoc()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	if snapshotData.casting.spellId == spells.eyeBeam.id and talents:IsTalentActive(spells.blindFury) then
		local casting = snapshotData.casting
		local remainingTime = casting.endTime - currentTime
		local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
		local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
		casting.resourceRaw = math.max(resource, 0)
		casting.resourceFinal = casting.resourceRaw
	end
end

local function UpdateSnapshot_Vengeance()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	-- Vengeance Soul Fragments max is 6
	TRB.Data.character.maxResource2Value = 6

	-- Get Soul Fragment count via Spirit Bomb's GetSpellCastCount (returns 0-5)
	local soulFragments = C_Spell.GetSpellCastCount(spells.spiritBomb.id) or 0
	snapshotData.attributes.resource2 = soulFragments
end

local function UpdateSnapshot_Devourer()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local _
	
	if snapshotData.snapshots[spells.collapsingStar.id].buff.isActive then
		snapshotData.attributes.resource2 = snapshotData.snapshots[spells.collapsingStar.id].buff.applications
		snapshotData.attributes.maxResource2 = spells.collapsingStar.attributes.maxResource
	else
		snapshotData.attributes.resource2 = snapshotData.snapshots[spells.soulFragments.id].buff.applications
		snapshotData.attributes.maxResource2 = spells.soulFragments.attributes.maxResource
		if talents:IsTalentActive(spells.soulGlutton) then
			snapshotData.attributes.maxResource2 = snapshotData.attributes.maxResource2 + spells.soulGlutton.attributes.maxResourceMod
		end

		if talents:IsTalentActive(spells.surrenderToTheVoid) then
			snapshotData.attributes.maxResource2 = snapshotData.attributes.maxResource2 + spells.surrenderToTheVoid.attributes.maxResourceMod
		end
	end
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.demonhunter
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	TRB.Functions.Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.havoc
		local specCacheSettings = TRB.Data.specCache.havoc.settings
		UpdateSnapshot_Havoc()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
				local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local currentResource = snapshotData.attributes.resource
				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					local resourceFrame = primaryNode:GetResourceFrame()
					local thresholds = primaryNode:GetThresholds()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						pairOffset = (thresholdId - 1) * 3
						local resourceAmount = spell:GetPrimaryResourceCost()
						local isUsable = spell:IsUsable()
						local showThreshold = true
						local thresholdColor = specCacheSettings.colors.threshold.over.color
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
						local snapshot = snapshots[spell.id]

						if metaTime > 0 and (spell.attributes.demonForm ~= nil and spell.attributes.demonForm == false) then
							showThreshold = false
						elseif metaTime == 0 and (spell.attributes.demonForm ~= nil and spell.attributes.demonForm == true) then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.chaosStrike.id or spell.id == spells.annihilation.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.bladeDance.id or spell.id == spells.deathSweep.id then
								if snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specCacheSettings.colors.threshold.unusable.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif isUsable then
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
					if snapshots[spells.metamorphosis.id].buff.isActive then
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
					end

					local barBorderColor = specSettings.colors.bar.border

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.overcapEnabled and affectingCombat then
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
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
		local specSettings = classSettings.vengeance
		local specCacheSettings = TRB.Data.specCache.vengeance.settings
		UpdateSnapshot_Vengeance()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					local resourceFrame = primaryNode:GetResourceFrame()
					local thresholds = primaryNode:GetThresholds()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
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
							if spell.id == spells.soulCleave.id or spell.id == spells.spiritBomb.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						elseif resourceAmount == 0 then
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

						-- Note: Cannot check resource2 == 0 for Spirit Bomb as Soul Fragments are now a secret value
						
						if resourceAmount >= maxPrimaryBarResourceUnnormalized then
							showThreshold = false
						end

						if thresholds[thresholdId] then
							local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
							TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
						end
					end
					
					local barColor = specSettings.colors.bar.base
					if snapshots[spells.metamorphosis.id].buff.isActive then
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
					end

					local barBorderColor = specSettings.colors.bar.border

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.overcapEnabled and affectingCombat then
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
				-- Soul Fragments bar (Vengeance, 0-5 fragments)
				local current = snapshotData.attributes.resource2 or 0
				local max = TRB.Data.character.maxResource2Value or 6
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local cpBorderColor = specSettings.colors.comboPoints.border
				local cpColor = specSettings.colors.comboPoints.base

				-- Update secondary bar (Soul Fragments with threshold dividers)
				if barGroups.secondary then
					local sfNode = barGroups.secondary:GetNode(1)
					if sfNode then
						TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "secondary", sfNode, current, max)
						sfNode:SetBorderColor(cpBorderColor)
						sfNode:SetColor(cpColor)
						sfNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
						
						-- Position 5 threshold dividers at 1, 2, 3, 4, 5 to create 6 segments
						local thresholds = sfNode:GetThresholds()
						local sfResourceFrame = sfNode:GetResourceFrame()
						for thresholdId = 1, 5 do
							if thresholds[thresholdId] then
								TRB.Functions.Threshold:RepositionThresholdComboPoint(specCacheSettings, "soulFragment" .. thresholdId, thresholds[thresholdId], true, sfResourceFrame, thresholdId, max)
							end
						end
					end
				end
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
		local specSettings = classSettings.devourer
		local specCacheSettings = TRB.Data.specCache.devourer.settings
		UpdateSnapshot_Devourer()
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		local metaActive = snapshots[spells.metamorphosis.id].buff.isActive
		local metaUsable = snapshotData.snapshots[spells.soulFragments.id].buff.applications >= snapshotData.attributes.maxResource2
		local collapsingStarUsable = snapshots[spells.collapsingStar.id].buff.applications >= spells.collapsingStarThreshold.resource

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true

				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					local resourceFrame = primaryNode:GetResourceFrame()
					local thresholds = primaryNode:GetThresholds()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
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
							if spell.id == spells.voidRay.id then
								if metaActive then
									showThreshold = false
								else
									resourceAmount = spells.voidRay.resource
									
									if snapshotData.casting.spellId == spells.voidRay.id or snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
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

						if thresholds[thresholdId] then
							local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
							TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
						end
					end
					
					local barColor = specSettings.colors.bar.base
					if snapshots[spells.metamorphosis.id].buff.isActive and specSettings.colors.bar.voidMetamorphosis.enabled then
						barColor = specSettings.colors.bar.voidMetamorphosis.color
					end

					local barBorderColor = specSettings.colors.bar.border

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.overcapEnabled and affectingCombat then
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end

			if specSettings.displayBar.secondary ~= "never" then
				-- Soul Fragments bar (Devourer fixed max)
				local current = snapshotData.attributes.resource2
				local max = snapshotData.attributes.maxResource2
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local cpBorderColor = specSettings.colors.comboPoints.border
				local cpColor = specSettings.colors.comboPoints.base

				if specSettings.colors.comboPoints.voidMetamorphosisReady.enabled and metaUsable then
					cpColor = specSettings.colors.comboPoints.voidMetamorphosisReady.color
				elseif specSettings.colors.comboPoints.collapsingStarReady.enabled and collapsingStarUsable then
					cpColor = specSettings.colors.comboPoints.collapsingStarReady.color
				elseif metaActive then
					cpColor = specSettings.colors.comboPoints.collapsingStar.color
				end

				local cpBR = cpBackgroundRed
				local cpBG = cpBackgroundGreen
				local cpBB = cpBackgroundBlue

				-- Update secondary bar (Soul Fragments)
				if barGroups.secondary then
					local sfNode = barGroups.secondary:GetNode(1)
					if sfNode then
						TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "secondary", sfNode, current, max)
						sfNode:SetBorderColor(cpBorderColor)
						sfNode:SetColor(cpColor)
						sfNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						
						-- Collapsing Star threshold (only visible when buff is active)
						local thresholds = sfNode:GetThresholds()
						local sfResourceFrame = sfNode:GetResourceFrame()
						local spell = spells.collapsingStarThreshold
						if thresholds[1] and specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled then
							local showThreshold = false
							local thresholdColor = specCacheSettings.colors.threshold.over.color
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if metaActive and talents:IsTalentActive(spells.collapsingStar) then
								showThreshold = true
								local collapsingStarSnapshot = snapshots[spells.collapsingStar.id]
								local resourceAmount = spells.collapsingStarThreshold.resource

								-- Determine usability based on buff applications
								if collapsingStarSnapshot.buff.applications >= resourceAmount then
									thresholdColor = specCacheSettings.colors.threshold.over.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdOver
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
								
								thresholds[1]:SetFrameLevel(frameLevel)
								thresholds[1]:Show()
								
								-- Set the threshold color using the proper method
								TRB.Functions.Color:SetThresholdColor(thresholds[1], thresholdColor, true)
								
								TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[1], showThreshold, sfResourceFrame, resourceAmount, snapshotData.attributes.maxResource2)
							else
								thresholds[1]:Hide()
							end
						end
					end
				end
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
		specCache.havoc.talents:GetTalents()
		FillSpellData_Havoc()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.havoc)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Havoc
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.havoc.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#annihilation"] = spells.annihilation.icon
		lookup["#bladeDance"] = spells.bladeDance.icon
		lookup["#blindFury"] = spells.blindFury.icon
		lookup["#chaosNova"] = spells.chaosNova.icon
		lookup["#chaosStrike"] = spells.chaosStrike.icon
		lookup["#deathSweep"] = spells.deathSweep.icon
		lookup["#eyeBeam"] = spells.eyeBeam.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "havoc" then
			talents = specCache.havoc.talents
			TRB.Data.barConstructedForSpec = "havoc"
			TRB.Functions.Class:EventRegistration()
			ConstructResourceBar(specCache.havoc.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.vengeance.talents:GetTalents()
		FillSpellData_Vengeance()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.vengeance)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Vengeance
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.vengeance.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#soulFragments"] = spells.soulFragments.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "vengeance" then
			talents = specCache.vengeance.talents
			TRB.Data.barConstructedForSpec = "vengeance"
			TRB.Functions.Class:EventRegistration()
			ConstructResourceBar(specCache.vengeance.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.devourer.talents:GetTalents()
		FillSpellData_Devourer()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.devourer)
		-- For whatever reason, this gets reset as Vengeance's specId after when going from Vengeance to Devourer. Manually re-set it.
		TRB.Data.character.specId = 3

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		---@type TRB.Classes.TargetData
		snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devourer
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.devourer.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#collapsingStar"] = spells.collapsingStar.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#voidRay"] = spells.voidRay.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		snapshotData.snapshots[spells.soulFragments.id].buff:Refresh()

		if TRB.Data.barConstructedForSpec ~= "devourer" then
			talents = specCache.devourer.talents
			TRB.Data.barConstructedForSpec = "devourer"
			TRB.Functions.Class:EventRegistration()
			ConstructResourceBar(specCache.devourer.settings)
		end

		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				snapshotData.snapshots[spells.soulFragments.id].buff:Refresh()
			end)
		end)
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
	
	if TRB.Data.character.classId == 12 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.DemonHunter.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.havoc == nil or
						TwintopInsanityBarSettings.demonhunter.havoc.displayText == nil then
						settings.demonhunter.havoc.displayText.barText = TRB.Options.DemonHunter.HavocLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.vengeance == nil or
						TwintopInsanityBarSettings.demonhunter.vengeance.displayText == nil then
						settings.demonhunter.vengeance.displayText.barText = TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.devourer == nil or
						TwintopInsanityBarSettings.demonhunter.devourer.displayText == nil then
						settings.demonhunter.devourer.displayText.barText = TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.demonhunter ~= true then
						TRB.Data.settings.demonhunter.havoc.displayText.barText = TRB.Options.DemonHunter.HavocLoadDefaultBarTextSettings()
						TRB.Data.settings.demonhunter.vengeance.displayText.barText = TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSettings()
						TRB.Data.settings.demonhunter.devourer.displayText.barText = TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.demonhunter = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["DemonHunter"])
					end
				else
					local settings = TRB.Options.DemonHunter.LoadDefaultSettings(true)
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
						TRB.Data.settings.demonhunter.havoc = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DemonHunterHavocFull"], TRB.Data.settings.demonhunter.havoc)
						TRB.Data.settings.demonhunter.vengeance = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DemonHunterVengeanceFull"], TRB.Data.settings.demonhunter.vengeance)
						TRB.Data.settings.demonhunter.devourer = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DemonHunterDevourerFull"], TRB.Data.settings.demonhunter.devourer)

						FillSpellData_Havoc()
						FillSpellData_Vengeance()
						FillSpellData_Devourer()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.DemonHunter.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "demonhunter"
	
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Fury, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Fury, false)
	
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		TRB.Data.character.specName = "havoc"
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		TRB.Data.character.specName = "vengeance"
		
		-- Soul Fragments: 1 node with 5 thresholds, max 6 fragments
		local maxComboPoints = 1
		TRB.Data.character.maxResource2Value = 6
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(sharedSettings, TRB.Frames.barGroups)
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		TRB.Data.character.specName = "devourer"

		local maxComboPoints = 1
		TRB.Data.character.maxResource2Value = 50
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(sharedSettings, TRB.Frames.barGroups)
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.demonhunter.havoc == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.demonhunter.vengeance == true then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		-- Soul Fragments retrieved via C_Spell.GetSpellCastCount(spiritBomb.id)
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Id = spells.spiritBomb.id
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.demonhunter.devourer == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = 1
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
			-- Vengeance (specId == 2) and Devourer (specId == 3) use the secondary (Soul Fragments) bar
			local showSecondary = false
			if not forceHideAll and (TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3) then
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
					barGroups.secondary:ShowNodes(1)
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

	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local settings = nil
	local normalizedResource = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		settings = TRB.Data.settings.demonhunter.havoc
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		settings = TRB.Data.settings.demonhunter.vengeance
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		settings = TRB.Data.settings.demonhunter.devourer
	else
		return false
	end
	
	if TRB.Data.character.specId == 1 then --Havoc
	elseif TRB.Data.character.specId == 2 then --Vengeance
		if var == "$comboPoints" or var == "$soulFragments" then
			valid = false
		elseif var == "$comboPointsMax"or var == "$soulFragmentsMax" then
			valid = true
		end
	elseif TRB.Data.character.specId == 3 then --Devourer
		if var == "$comboPoints" then
			valid = true
		elseif var == "$comboPointsMax" then
			valid = true
		elseif var == "$soulFragments" or var == "$soulFragmentsMax" then
			valid = true
		elseif var == "$collapsingStar" or var == "$collapsingStarMax" then
			if talents:IsTalentActive(spells.collapsingStar) and snapshotData.snapshots[spells.collapsingStar.id].buff.isActive then
				valid = true
			end
		elseif var == "$voidRayUsable" then
			if (not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive) and (spells.voidRay:IsUsable()) then
				valid = true
			end
		elseif var == "$collapsingStarUsable" then
			if snapshotData.snapshots[spells.collapsingStar.id].buff.applications >= spells.collapsingStarThreshold.resource then
				valid = true
			end
		end
	end
	
	if var == "$metamorphosisTime" or var == "$metaTime" or var == "$voidMetaTime" or var == "$voidMetamorphosisTime" then
		if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
			valid = true
		end
	elseif var == "$health" or var == "$healthMax" or var == "$healthPercent" then
		valid = true
	elseif var == "$resource" or var == "$fury" then
		-- Do not compare resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$furyMax" then
		valid = true
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
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
	elseif relativeToFrame == "ComboPoint1" then
		if barGroups and barGroups.secondary then
			local secondaryNode = barGroups.secondary:GetNode(1)
			if secondaryNode then
				local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
				return secondaryNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end
	return nil, true, false
end

---Recreates thresholds and secondary bar setup when re-enabling a previously disabled spec
---Demon Hunter override: handles primary bar + secondary bar setup for Vengeance/Devourer
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Class:RecreateThresholds(settings, barGroups)
	-- Primary bar thresholds
	if barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local existingThresholds = primaryNode:GetThresholds()
			local thresholdSpells = TRB.Data.cache.thresholdSpells
			if thresholdSpells and #thresholdSpells > 0 and (not existingThresholds or #existingThresholds ~= #thresholdSpells) then
				primaryNode:ClearThresholds()
				for _ = 1, #thresholdSpells do
					local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
					TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
					primaryNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	end

	-- Vengeance: Soul Fragments bar with 5 threshold dividers (0-6 scale)
	if TRB.Data.character.specId == 2 and barGroups.secondary then
		barGroups.secondary:SetNodeCount(1)
		local sfNode = barGroups.secondary:GetNode(1)
		if sfNode then
			sfNode:SetMinMax(0, 6) -- 0-6 Soul Fragments
			local existingThresholds = sfNode:GetThresholds()
			if not existingThresholds or #existingThresholds ~= 5 then
				sfNode:ClearThresholds()
				for _ = 1, 5 do
					local thresholdFrame = CreateFrame("Frame", nil, sfNode:GetResourceFrame())
					TRB.Functions.Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
					sfNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	end

	-- Devourer: Soul Fragments bar with 1 threshold for Collapsing Star (0-50 scale)
	if TRB.Data.character.specId == 3 and barGroups.secondary then
		barGroups.secondary:SetNodeCount(1)
		local sfNode = barGroups.secondary:GetNode(1)
		if sfNode then
			sfNode:SetMinMax(0, 50) -- 0-50 for Collapsing Star
			local existingThresholds = sfNode:GetThresholds()
			if not existingThresholds or #existingThresholds ~= 1 then
				sfNode:ClearThresholds()
				local thresholdFrame = CreateFrame("Frame", nil, sfNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
				sfNode:RegisterThreshold(thresholdFrame)
			end
		end
	end
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end
	
	UpdateResourceBar()
end