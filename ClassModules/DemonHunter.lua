local _, TRB = ...
if TRB.Data.character.classId ~=  12 then --Only do this if we're on a DemonHunter!
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
			passive = 0,
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
		overcapCue = false
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
	specCache.havoc.snapshotData.snapshots[spells.glaiveTempest.id] = TRB.Classes.Snapshot:New(spells.glaiveTempest)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura.id] = TRB.Classes.Snapshot:New(spells.immolationAura)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura1.id] = TRB.Classes.Snapshot:New(spells.immolationAura1)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura2.id] = TRB.Classes.Snapshot:New(spells.immolationAura2)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura3.id] = TRB.Classes.Snapshot:New(spells.immolationAura3)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura4.id] = TRB.Classes.Snapshot:New(spells.immolationAura4)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura5.id] = TRB.Classes.Snapshot:New(spells.immolationAura5)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.immolationAura6.id] = TRB.Classes.Snapshot:New(spells.immolationAura6)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.unboundChaos.id] = TRB.Classes.Snapshot:New(spells.unboundChaos)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.throwGlaive.id] = TRB.Classes.Snapshot:New(spells.throwGlaive)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.tacticalRetreat.id] = TRB.Classes.Snapshot:New(spells.tacticalRetreat)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.chaosTheory.id] = TRB.Classes.Snapshot:New(spells.chaosTheory)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.felBarrage.id] = TRB.Classes.Snapshot:New(spells.felBarrage)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.artOfTheGlaive.id] = TRB.Classes.Snapshot:New(spells.artOfTheGlaive)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.glaiveFlurry.id] = TRB.Classes.Snapshot:New(spells.glaiveFlurry)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.rendingStrike.id] = TRB.Classes.Snapshot:New(spells.rendingStrike)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.studentOfSuffering.id] = TRB.Classes.Snapshot:New(spells.studentOfSuffering)
	---@type TRB.Classes.Snapshot
	specCache.havoc.snapshotData.snapshots[spells.warbladesHunger.id] = TRB.Classes.Snapshot:New(spells.warbladesHunger)

	-- vengeance
	specCache.vengeance.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			passive = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
		dots = {
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
		overcapCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.chaosNova.id] = TRB.Classes.Snapshot:New(spells.chaosNova)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.felDevastation.id] = TRB.Classes.Snapshot:New(spells.felDevastation)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.immolationAura.id] = TRB.Classes.Snapshot:New(spells.immolationAura)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.soulFurnace.id] = TRB.Classes.Snapshot:New(spells.soulFurnace)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.artOfTheGlaive.id] = TRB.Classes.Snapshot:New(spells.artOfTheGlaive)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.glaiveFlurry.id] = TRB.Classes.Snapshot:New(spells.glaiveFlurry)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.rendingStrike.id] = TRB.Classes.Snapshot:New(spells.rendingStrike)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.studentOfSuffering.id] = TRB.Classes.Snapshot:New(spells.studentOfSuffering)
	---@type TRB.Classes.Snapshot
	specCache.vengeance.snapshotData.snapshots[spells.warbladesHunger.id] = TRB.Classes.Snapshot:New(spells.warbladesHunger)
	
	-- Havoc
	specCache.devourer.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			passive = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
	}

	specCache.devourer.character = {
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

	---@type TRB.Classes.DemonHunter.DevourerSpells
	specCache.devourer.spellsData.spells = TRB.Classes.DemonHunter.DevourerSpells:New()
	local spells = specCache.devourer.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]

	specCache.devourer.snapshotData.audio = {
		overcapCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.devourer.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.devourer.snapshotData.snapshots[spells.voidRay.id] = TRB.Classes.Snapshot:New(spells.voidRay)
end

local function Setup_Havoc()
	TRB.Functions.Character:FillSpecializationCacheSettings("demonhunter", "havoc")
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
		{ variable = "#artOfTheGlaive", icon = spells.artOfTheGlaive.icon, description = spells.artOfTheGlaive.name, printInSettings = true },
		{ variable = "#bladeDance", icon = spells.bladeDance.icon, description = spells.bladeDance.name, printInSettings = true },
		{ variable = "#blindFury", icon = spells.blindFury.icon, description = spells.blindFury.name, printInSettings = true },
		{ variable = "#bh", icon = spells.burningHatred.icon, description = spells.burningHatred.name, printInSettings = false },
		{ variable = "#burningHatred", icon = spells.burningHatred.icon, description = spells.burningHatred.name, printInSettings = true },
		{ variable = "#chaosNova", icon = spells.chaosNova.icon, description = spells.chaosNova.name, printInSettings = true },
		{ variable = "#chaosStrike", icon = spells.chaosStrike.icon, description = spells.chaosStrike.name, printInSettings = true },
		{ variable = "#deathSweep", icon = spells.deathSweep.icon, description = spells.deathSweep.name, printInSettings = true },
		{ variable = "#eyeBeam", icon = spells.eyeBeam.icon, description = spells.eyeBeam.name, printInSettings = true },
		{ variable = "#felBarrage", icon = spells.felBarrage.icon, description = spells.felBarrage.name, printInSettings = true },
		{ variable = "#glaiveFlurry", icon = spells.glaiveFlurry.icon, description = spells.glaiveFlurry.name, printInSettings = true },
		{ variable = "#glaiveTempest", icon = spells.glaiveTempest.icon, description = spells.glaiveTempest.name, printInSettings = true },
		{ variable = "#immolationAura", icon = spells.immolationAura.icon, description = spells.immolationAura.name, printInSettings = true },
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#rendingStrike", icon = spells.rendingStrike.icon, description = spells.rendingStrike.name, printInSettings = true },
		{ variable = "#studentOfSuffering", icon = spells.studentOfSuffering.icon, description = spells.studentOfSuffering.name, printInSettings = true },
		{ variable = "#tacticalRetreat", icon = spells.tacticalRetreat.icon, description = spells.tacticalRetreat.name, printInSettings = true },
		{ variable = "#unboundChaos", icon = spells.unboundChaos.icon, description = spells.unboundChaos.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		
		{ variable = "$fury", description = L["DemonHunterHavocBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterHavocBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterHavocBarTextVariable_casting"], printInSettings = true, color = false },
		--[[{ variable = "$passive", description = L["DemonHunterHavocBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$furyPlusCasting", description = L["DemonHunterHavocBarTextVariable_furyPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$furyPlusPassive", description = L["DemonHunterHavocBarTextVariable_furyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$furyTotal", description = L["DemonHunterHavocBarTextVariable_furyTotal"], printInSettings = true, color = false },   
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },]]
		{ variable = "$metaTime", description = L["DemonHunterHavocBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
		--[[{ variable = "$bhFury", description = L["DemonHunterHavocBarTextVariable_bhFury"], printInSettings = true, color = false },
		{ variable = "$bhTicks", description = "", printInSettings = false, color = false },
		{ variable = "$iaTicks", description = L["DemonHunterHavocBarTextVariable_iaTicks"], printInSettings = true, color = false },
		{ variable = "$bhTime", description = "", printInSettings = false, color = false },
		{ variable = "$iaTime", description = L["DemonHunterHavocBarTextVariable_iaTime"], printInSettings = true, color = false },
		{ variable = "$ucTime", description = L["DemonHunterHavocBarTextVariable_ucTime"], printInSettings = true, color = false },
		{ variable = "$tacticalRetreatFury", description = L["DemonHunterHavocBarTextVariable_tacticalRetreatFury"], printInSettings = true, color = false },
		{ variable = "$tacticalRetreatTicks", description = L["DemonHunterHavocBarTextVariable_tacticalRetreatTicks"], printInSettings = true, color = false },
		{ variable = "$tacticalRetreatTime", description = L["DemonHunterHavocBarTextVariable_tacticalRetreatTime"], printInSettings = true, color = false },

		{ variable = "$aotgStacks", description = L["DemonHunterHavocBarTextVariable_aotgStacks"], printInSettings = true, color = false },
		{ variable = "$aotgTime", description = L["DemonHunterHavocBarTextVariable_aotgTime"], printInSettings = true, color = false },
		{ variable = "$gfTime", description = L["DemonHunterHavocBarTextVariable_gfTime"], printInSettings = true, color = false },
		{ variable = "$rsTime", description = L["DemonHunterHavocBarTextVariable_rsTime"], printInSettings = true, color = false },
		
		{ variable = "$sosFury", description = L["DemonHunterHavocBarTextVariable_sosFury"], printInSettings = true, color = false },
		{ variable = "$sosTicks", description = L["DemonHunterHavocBarTextVariable_sosTicks"], printInSettings = true, color = false },
		{ variable = "$sosTime", description = L["DemonHunterHavocBarTextVariable_sosTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
	}
end

local function Setup_Vengeance()
	TRB.Functions.Character:FillSpecializationCacheSettings("demonhunter", "vengeance")
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

		{ variable = "#artOfTheGlaive", icon = spells.artOfTheGlaive.icon, description = spells.artOfTheGlaive.name, printInSettings = true },
		{ variable = "#immolationAura", icon = spells.immolationAura.icon, description = spells.immolationAura.name, printInSettings = true },
		{ variable = "#ia", icon = spells.immolationAura.icon, description = spells.immolationAura.name, printInSettings = false },
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		--{ variable = "#soulFragments", icon = spells.soulFragments.icon, description = spells.soulFragments.name, printInSettings = true },
		{ variable = "#studentOfSuffering", icon = spells.studentOfSuffering.icon, description = spells.studentOfSuffering.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		
		{ variable = "$fury", description = L["DemonHunterVengeanceBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterVengeanceBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterVengeanceBarTextVariable_casting"], printInSettings = true, color = false },
		--[[{ variable = "$passive", description = L["DemonHunterVengeanceBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$furyPlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$furyPlusPassive", description = L["DemonHunterVengeanceBarTextVariable_furyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$furyTotal", description = L["DemonHunterVengeanceBarTextVariable_furyTotal"], printInSettings = true, color = false },   
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   
		
		{ variable = "$soulFragments", description = L["DemonHunterVengeanceBarTextVariable_soulFragments"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulFragmentsMax", description = L["DemonHunterVengeanceBarTextVariable_soulFragmentsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },]]

		{ variable = "$metaTime", description = L["DemonHunterVengeanceBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },

		--[[{ variable = "$iaFury", description = L["DemonHunterVengeanceBarTextVariable_iaFury"], printInSettings = true, color = false },
		{ variable = "$iaTicks", description = L["DemonHunterVengeanceBarTextVariable_iaTicks"], printInSettings = true, color = false },
		{ variable = "$iaTime", description = L["DemonHunterVengeanceBarTextVariable_iaTime"], printInSettings = true, color = false },

		{ variable = "$aotgStacks", description = L["DemonHunterVengeanceBarTextVariable_aotgStacks"], printInSettings = true, color = false },
		{ variable = "$aotgTime", description = L["DemonHunterVengeanceBarTextVariable_aotgTime"], printInSettings = true, color = false },
		
		{ variable = "$sosFury", description = L["DemonHunterHavocBarTextVariable_sosFury"], printInSettings = true, color = false },
		{ variable = "$sosTicks", description = L["DemonHunterHavocBarTextVariable_sosTicks"], printInSettings = true, color = false },
		{ variable = "$sosTime", description = L["DemonHunterHavocBarTextVariable_sosTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
	}
end

local function Setup_Devourer()
	TRB.Functions.Character:FillSpecializationCacheSettings("demonhunter", "devourer")
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		
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
		--[[{ variable = "$passive", description = L["DemonHunterHavocBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$furyPlusCasting", description = L["DemonHunterHavocBarTextVariable_furyPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$furyPlusPassive", description = L["DemonHunterHavocBarTextVariable_furyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$furyTotal", description = L["DemonHunterHavocBarTextVariable_furyTotal"], printInSettings = true, color = false },   
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },]]
		{ variable = "$metaTime", description = L["DemonHunterDevourerBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
		
		--[[{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
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
	elseif TRB.Data.character.specId == 2 then
		TRB.Frames.resource2ContainerFrame:Show()
	elseif TRB.Data.character.specId == 3 then
		TRB.Frames.resource2ContainerFrame:Show()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
end

local function RefreshLookupData_Havoc()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.havoc
	local sharedSettings = TRB.Data.specCache["havoc"].settings
	local normalizedResource = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	--Spec specific implementation

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentFuryColor = sharedSettings.colors.text.current.color
	local castingFuryColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentFuryColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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

	--[[if snapshotData.casting.resourceFinal < 0 then
		castingFuryColor = sharedSettings.colors.text.spending.color
	end]]

	--$metamorphosisTime
	local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
	local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

	--[[--$unboundChaosTime
	local _unboundChaosTime = snapshotData.snapshots[spells.unboundChaos.id].buff:GetRemainingTime(currentTime)
	local unboundChaosTime = TRB.Functions.BarText:TimerPrecision(_unboundChaosTime)

	--$bhFury
	local bhFury = snapshotData.snapshots[spells.immolationAura.id].buff.resource + snapshotData.snapshots[spells.immolationAura1.id].buff.resource + snapshotData.snapshots[spells.immolationAura2.id].buff.resource + snapshotData.snapshots[spells.immolationAura3.id].buff.resource + snapshotData.snapshots[spells.immolationAura4.id].buff.resource + snapshotData.snapshots[spells.immolationAura5.id].buff.resource + snapshotData.snapshots[spells.immolationAura6.id].buff.resource

	--$bhTicks and $iaTicks
	local bhTicks = snapshotData.snapshots[spells.immolationAura.id].buff.ticks + snapshotData.snapshots[spells.immolationAura1.id].buff.ticks + snapshotData.snapshots[spells.immolationAura2.id].buff.ticks + snapshotData.snapshots[spells.immolationAura3.id].buff.ticks + snapshotData.snapshots[spells.immolationAura4.id].buff.ticks + snapshotData.snapshots[spells.immolationAura5.id].buff.ticks + snapshotData.snapshots[spells.immolationAura6.id].buff.ticks

	--$bhTime and $iaTime
	local _bhTime = math.max(snapshotData.snapshots[spells.immolationAura.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura1.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura2.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura3.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura4.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura5.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura6.id].buff:GetRemainingTime(currentTime))
	local bhTime = TRB.Functions.BarText:TimerPrecision(_bhTime)

	--$tacticalRetreatFury
	local tacticalRetreatFury = snapshotData.snapshots[spells.tacticalRetreat.id].buff.resource

	--$tacticalRetreatTicks
	local tacticalRetreatTicks = snapshotData.snapshots[spells.tacticalRetreat.id].buff.ticks

	--$tacticalRetreatTime
	local _tacticalRetreatTime = snapshotData.snapshots[spells.tacticalRetreat.id].buff:GetRemainingTime(currentTime)
	local tacticalRetreatTime = TRB.Functions.BarText:TimerPrecision(_tacticalRetreatTime)

	--$sosFury
	local sosFury = snapshotData.snapshots[spells.studentOfSuffering.id].buff.resource

	--$sosTicks
	local sosTicks = snapshotData.snapshots[spells.studentOfSuffering.id].buff.ticks

	--$sosTime
	local _sosTime = snapshotData.snapshots[spells.studentOfSuffering.id].buff:GetRemainingTime(currentTime)
	local sosTime = TRB.Functions.BarText:TimerPrecision(_sosTime)]]

	--$fury
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentFury = normalizedResource
	local currentFury = string.format("|c%s%s|r", currentFuryColor, _currentFury)-- TRB.Functions.Number:RoundTo(normalizedResource, resourcePrecision, "floor"))
	--$casting
	local _castingFury = snapshotData.casting.resourceFinal
	local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
	--[[--$passive
	local _passiveFury = bhFury + tacticalRetreatFury + sosFury
	local passiveFury = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveFury, resourcePrecision, "floor"))
	
	--$furyTotal
	local _furyTotal = math.min(_passiveFury + snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
	local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, resourcePrecision, "floor"))
	--$furyPlusCasting
	local _furyPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
	local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_furyPlusCasting, resourcePrecision, "floor"))
	--$furyPlusPassive
	local _furyPlusPassive = math.min(_passiveFury + normalizedResource, TRB.Data.character.maxResource)
	local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyPlusPassive, resourcePrecision, "floor"))

	--$aotgStacks
	local aotgStacks = snapshotData.snapshots[spells.artOfTheGlaive.id].buff.applications

	--$aotgTime
	local _aotgTime = snapshotData.snapshots[spells.artOfTheGlaive.id].buff:GetRemainingTime(currentTime)
	local aotgTime = TRB.Functions.BarText:TimerPrecision(_aotgTime)

	--$gfTime
	local _gfTime = snapshotData.snapshots[spells.glaiveFlurry.id].buff:GetRemainingTime(currentTime)
	local gfTime = TRB.Functions.BarText:TimerPrecision(_gfTime)

	--$rsTime
	local _rsTime = snapshotData.snapshots[spells.rendingStrike.id].buff:GetRemainingTime(currentTime)
	local rsTime = TRB.Functions.BarText:TimerPrecision(_rsTime)]]

	----------------------------

	--[[Global_TwintopResourceBar.resource.resource = normalizedResource
	Global_TwintopResourceBar.resource.passive = _passiveFury
	Global_TwintopResourceBar.resource.burningHatred = bhFury
	Global_TwintopResourceBar.resource.tacticalRetreat = tacticalRetreatFury
	Global_TwintopResourceBar.resource.studentOfSuffering = sosFury
	
	Global_TwintopResourceBar.burningHatred = Global_TwintopResourceBar.burningHatred or {}
	Global_TwintopResourceBar.burningHatred.fury = bhFury
	Global_TwintopResourceBar.burningHatred.ticks = bhTicks
	Global_TwintopResourceBar.burningHatred.time = bhTime
	
	Global_TwintopResourceBar.tacticalRetreat = Global_TwintopResourceBar.tacticalRetreat or {}
	Global_TwintopResourceBar.tacticalRetreat.fury = tacticalRetreatFury
	Global_TwintopResourceBar.tacticalRetreat.ticks = tacticalRetreatTicks
	Global_TwintopResourceBar.tacticalRetreat.time = tacticalRetreatTime
	
	Global_TwintopResourceBar.studentOfSuffering = Global_TwintopResourceBar.studentOfSuffering or {}
	Global_TwintopResourceBar.studentOfSuffering.fury = sosFury
	Global_TwintopResourceBar.studentOfSuffering.ticks = sosTicks
	Global_TwintopResourceBar.studentOfSuffering.time = sosTime]]

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
	--[[lookup["$bhFury"] = bhFury
	lookup["$bhTicks"] = bhTicks
	lookup["$iaTicks"] = bhTicks
	lookup["$iaTime"] = bhTime
	lookup["$bhTime"] = bhTime
	lookup["$tacticalRetreatFury"] = tacticalRetreatFury
	lookup["$tacticalRetreatTicks"] = tacticalRetreatTicks
	lookup["$tacticalRetreatTime"] = _tacticalRetreatTime
	lookup["$sosFury"] = sosFury
	lookup["$sosTicks"] = sosTicks
	lookup["$sosTime"] = _sosTime
	lookup["$ucTime"] = unboundChaosTime
	lookup["$furyPlusCasting"] = furyPlusCasting
	lookup["$furyTotal"] = furyTotal
	lookup["$resourcePlusCasting"] = furyPlusCasting
	lookup["$furyPlusCasting"] = furyPlusCasting
	lookup["$resourcePlusPassive"] = furyPlusPassive
	lookup["$furyPlusPassive"] = furyPlusPassive
	lookup["$resourceTotal"] = furyTotal
	lookup["$passive"] = passiveFury
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$furyOvercap"] = overcap
	lookup["$aotgStacks"] = aotgStacks
	lookup["$aotgTime"] = aotgTime
	lookup["$gfTime"] = gfTime
	lookup["$rsTime"] = rsTime]]
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
	--[[lookupLogic["$bhFury"] = bhFury
	lookupLogic["$bhTicks"] = bhTicks
	lookupLogic["$iaTicks"] = bhTicks
	lookupLogic["$iaTime"] = _bhTime
	lookupLogic["$bhTime"] = _bhTime
	lookupLogic["$tacticalRetreatFury"] = tacticalRetreatFury
	lookupLogic["$tacticalRetreatTicks"] = tacticalRetreatTicks
	lookupLogic["$tacticalRetreatTime"] = _tacticalRetreatTime
	lookupLogic["$sosFury"] = sosFury
	lookupLogic["$sosTicks"] = sosTicks
	lookupLogic["$sosTime"] = _sosTime
	lookupLogic["$ucTime"] = _unboundChaosTime
	lookupLogic["$furyPlusCasting"] = _furyPlusCasting
	lookupLogic["$furyTotal"] = _furyTotal
	lookupLogic["$resourcePlusCasting"] = _furyPlusCasting
	lookupLogic["$furyPlusCasting"] = _furyPlusCasting
	lookupLogic["$resourcePlusPassive"] = _furyPlusPassive
	lookupLogic["$furyPlusPassive"] = _furyPlusPassive
	lookupLogic["$resourceTotal"] = _furyTotal
	lookupLogic["$passive"] = _passiveFury
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$furyOvercap"] = overcap
	lookupLogic["$aotgStacks"] = aotgStacks
	lookupLogic["$aotgTime"] = _aotgTime
	lookupLogic["$gfTime"] = _gfTime
	lookupLogic["$rsTime"] = _rsTime]]
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

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentFuryColor = sharedSettings.colors.text.current.color
	local castingFuryColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentFuryColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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

	--[[if snapshotData.casting.resourceFinal < 0 then
		castingFuryColor = sharedSettings.colors.text.spending.color
	end]]

	--$metamorphosisTime
	local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
	local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

	--[[--$iaFury
	local iaFury = snapshotData.snapshots[spells.immolationAura.id].buff.resource

	--$iaTicks
	local iaTicks = snapshotData.snapshots[spells.immolationAura.id].buff.ticks

	--$iaTime
	local _iaTime = snapshotData.snapshots[spells.immolationAura.id].buff:GetRemainingTime(currentTime)
	local iaTime = TRB.Functions.BarText:TimerPrecision(_iaTime)

	--$sosFury
	local sosFury = snapshotData.snapshots[spells.studentOfSuffering.id].buff.resource

	--$sosTicks
	local sosTicks = snapshotData.snapshots[spells.studentOfSuffering.id].buff.ticks

	--$sosTime
	local _sosTime = snapshotData.snapshots[spells.studentOfSuffering.id].buff:GetRemainingTime(currentTime)
	local sosTime = TRB.Functions.BarText:TimerPrecision(_sosTime)]]

	--$fury
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentFury = normalizedResource
	local currentFury = string.format("|c%s%s|r", currentFuryColor, _currentFury)-- TRB.Functions.Number:RoundTo(normalizedResource, resourcePrecision, "floor"))
	--$casting
	local _castingFury = snapshotData.casting.resourceFinal
	local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
	--[[--$passive
	local _passiveFury = iaFury + sosFury
	local passiveFury = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveFury, resourcePrecision, "floor"))
	
	--$furyTotal
	local _furyTotal = math.min(_passiveFury + snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
	local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, resourcePrecision, "floor"))
	--$furyPlusCasting
	local _furyPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
	local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_furyPlusCasting, resourcePrecision, "floor"))
	--$furyPlusPassive
	local _furyPlusPassive = math.min(_passiveFury + normalizedResource, TRB.Data.character.maxResource)
	local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyPlusPassive, resourcePrecision, "floor"))
	
	--$aotgStacks
	local aotgStacks = snapshotData.snapshots[spells.artOfTheGlaive.id].buff.applications

	--$aotgTime
	local _aotgTime = snapshotData.snapshots[spells.artOfTheGlaive.id].buff:GetRemainingTime(currentTime)
	local aotgTime = TRB.Functions.BarText:TimerPrecision(_aotgTime)

	--$gfTime
	local _gfTime = snapshotData.snapshots[spells.glaiveFlurry.id].buff:GetRemainingTime(currentTime)
	local gfTime = TRB.Functions.BarText:TimerPrecision(_gfTime)

	--$rsTime
	local _rsTime = snapshotData.snapshots[spells.rendingStrike.id].buff:GetRemainingTime(currentTime)
	local rsTime = TRB.Functions.BarText:TimerPrecision(_rsTime)]]
	
	----------------------------

	--[[Global_TwintopResourceBar.resource.resource = normalizedResource
	Global_TwintopResourceBar.resource.passive = _passiveFury
	Global_TwintopResourceBar.resource.immolationAura = iaFury
	Global_TwintopResourceBar.resource.studentOfSuffering = sosFury

	Global_TwintopResourceBar.immolationAura = Global_TwintopResourceBar.immolationAura or {}
	Global_TwintopResourceBar.immolationAura.fury = iaFury
	Global_TwintopResourceBar.immolationAura.ticks = iaTicks
	Global_TwintopResourceBar.immolationAura.time = iaTime
	
	Global_TwintopResourceBar.studentOfSuffering = Global_TwintopResourceBar.studentOfSuffering or {}
	Global_TwintopResourceBar.studentOfSuffering.fury = sosFury
	Global_TwintopResourceBar.studentOfSuffering.ticks = sosTicks
	Global_TwintopResourceBar.studentOfSuffering.time = sosTime]]

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
	--[[lookup["#artOfTheGlaive"] = spells.artOfTheGlaive.icon
	lookup["#glaiveFlurry"] = spells.glaiveFlurry.icon
	lookup["#ia"] = spells.immolationAura.icon
	lookup["#immolationAura"] = spells.immolationAura.icon
	lookup["#metamorphosis"] = spells.metamorphosis.icon
	lookup["#meta"] = spells.metamorphosis.icon
	lookup["#rendingStrike"] = spells.rendingStrike.icon
	--lookup["#soulFragments"] = spells.soulFragments.icon]]
	--[[lookup["$iaFury"] = iaFury
	lookup["$iaTicks"] = iaTicks
	lookup["$iaTime"] = iaTime
	lookup["$sosFury"] = sosFury
	lookup["$sosTicks"] = sosTicks
	lookup["$sosTime"] = _sosTime
	lookup["$furyPlusCasting"] = furyPlusCasting
	lookup["$furyTotal"] = furyTotal
	lookup["$resourcePlusCasting"] = furyPlusCasting
	lookup["$furyPlusCasting"] = furyPlusCasting
	lookup["$resourcePlusPassive"] = furyPlusPassive
	lookup["$furyPlusPassive"] = furyPlusPassive
	lookup["$resourceTotal"] = furyTotal
	--lookup["$soulFragments"] = snapshotData.attributes.resource2
	--lookup["$comboPoints"] = snapshotData.attributes.resource2
	--lookup["$soulFragmentsMax"] = TRB.Data.character.maxResource2
	--lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$passive"] = passiveFury
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$furyOvercap"] = overcap
	lookup["$aotgStacks"] = aotgStacks
	lookup["$aotgTime"] = aotgTime
	lookup["$gfTime"] = gfTime
	lookup["$rsTime"] = rsTime]]
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
	--[[lookupLogic["$iaFury"] = iaFury
	lookupLogic["$iaTicks"] = iaTicks
	lookupLogic["$iaTime"] = _iaTime
	lookupLogic["$sosFury"] = sosFury
	lookupLogic["$sosTicks"] = sosTicks
	lookupLogic["$sosTime"] = _sosTime
	lookupLogic["$furyPlusCasting"] = _furyPlusCasting
	lookupLogic["$furyTotal"] = _furyTotal
	lookupLogic["$resourcePlusCasting"] = _furyPlusCasting
	lookupLogic["$furyPlusCasting"] = _furyPlusCasting
	lookupLogic["$resourcePlusPassive"] = _furyPlusPassive
	lookupLogic["$furyPlusPassive"] = _furyPlusPassive
	lookupLogic["$resourceTotal"] = _furyTotal
	--lookupLogic["$soulFragments"] = snapshotData.attributes.resource2
	--lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	--lookupLogic["$soulFragmentsMax"] = TRB.Data.character.maxResource2
	--lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$passive"] = _passiveFury
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$furyOvercap"] = overcap
	lookupLogic["$aotgStacks"] = aotgStacks
	lookupLogic["$aotgTime"] = _aotgTime
	lookupLogic["$gfTime"] = _gfTime
	lookupLogic["$rsTime"] = _rsTime]]
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

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentFuryColor = sharedSettings.colors.text.current.color
	local castingFuryColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentFuryColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled then
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

	--[[if snapshotData.casting.resourceFinal < 0 then
		castingFuryColor = sharedSettings.colors.text.spending.color
	end]]

	--$metamorphosisTime
	local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
	local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

	--$fury
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentFury = normalizedResource
	local currentFury = string.format("|c%s%s|r", currentFuryColor, _currentFury)-- TRB.Functions.Number:RoundTo(normalizedResource, resourcePrecision, "floor"))
	--$casting
	local _castingFury = snapshotData.casting.resourceFinal
	local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
	--[[--$passive
	local _passiveFury = bhFury + tacticalRetreatFury + sosFury
	local passiveFury = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveFury, resourcePrecision, "floor"))
	
	--$furyTotal
	local _furyTotal = math.min(_passiveFury + snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
	local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, resourcePrecision, "floor"))
	--$furyPlusCasting
	local _furyPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
	local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_furyPlusCasting, resourcePrecision, "floor"))
	--$furyPlusPassive
	local _furyPlusPassive = math.min(_passiveFury + normalizedResource, TRB.Data.character.maxResource)
	local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyPlusPassive, resourcePrecision, "floor"))]]

	--$soulFragments
	local _soulFragments = snapshotData.attributes.resource2
	local soulFragments = string.format("%s", _soulFragments)

	----------------------------

	--[[Global_TwintopResourceBar.resource.resource = normalizedResource
	Global_TwintopResourceBar.resource.passive = _passiveFury]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentFury
	lookup["$fury"] = currentFury
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$furyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingFury
	lookup["$soulFragments"] = soulFragments
	lookup["$comboPoints"] = soulFragments
	lookup["$collapsingStars"] = soulFragments
	lookup["$soulFragmentsMax"] = TRB.Data.character.maxResource2Value
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2Value
	lookup["$collapsingStarsMax"] = TRB.Data.character.maxResource2Value
	lookup["$metaTime"] = ""
	lookup["$metamorphosisTime"] = ""
	lookup["$voidMetaTime"] = ""
	lookup["$voidMetamorphosisTime"] = ""
	--[[lookup["$furyPlusCasting"] = furyPlusCasting
	lookup["$furyTotal"] = furyTotal
	lookup["$resourcePlusCasting"] = furyPlusCasting
	lookup["$furyPlusCasting"] = furyPlusCasting
	lookup["$resourcePlusPassive"] = furyPlusPassive
	lookup["$furyPlusPassive"] = furyPlusPassive
	lookup["$resourceTotal"] = furyTotal
	lookup["$passive"] = passiveFury
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$furyOvercap"] = overcap]]
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
	lookupLogic["$soulFragmentsMax"] = TRB.Data.character.maxResource2Value
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2Value
	lookupLogic["$collapsingStarsMax"] = TRB.Data.character.maxResource2Value
	lookupLogic["$metaTime"] = _metamorphosisTime
	lookupLogic["$metamorphosisTime"] = _metamorphosisTime
	lookupLogic["$voidMetaTime"] = _metamorphosisTime
	lookupLogic["$voidMetamorphosisTime"] = _metamorphosisTime
	--[[lookupLogic["$furyPlusCasting"] = _furyPlusCasting
	lookupLogic["$furyTotal"] = _furyTotal
	lookupLogic["$resourcePlusCasting"] = _furyPlusCasting
	lookupLogic["$furyPlusCasting"] = _furyPlusCasting
	lookupLogic["$resourcePlusPassive"] = _furyPlusPassive
	lookupLogic["$furyPlusPassive"] = _furyPlusPassive
	lookupLogic["$resourceTotal"] = _furyTotal
	lookupLogic["$passive"] = _passiveFury
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$furyOvercap"] = overcap]]
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
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.metamorphosis.castId then
				snapshotData.snapshots[spells.metamorphosis.id].buff:InitializeCustomSimple()
				snapshotData.snapshots[spells.metamorphosis.id].buff.attributes.triggeredTime = currentTime
			end
		elseif event == "UNIT_MODEL_CHANGED" then
			--Void Metamorphosis form change detected
			local leeway = 0.2
			if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive and
				(snapshotData.snapshots[spells.metamorphosis.id].buff.attributes.triggeredTime == nil or
				snapshotData.snapshots[spells.metamorphosis.id].buff.attributes.triggeredTime + leeway < currentTime) then
				snapshotData.snapshots[spells.metamorphosis.id].buff:Reset()
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
	--[[if talents:IsTalentActive(spells.artOfTheGlaive) then
		snapshotData.snapshots[spells.artOfTheGlaive.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.glaiveFlurry.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.rendingStrike.id].buff:GetRemainingTime(currentTime)
	end

	if talents:IsTalentActive(spells.studentOfSuffering) then
		snapshotData.snapshots[spells.studentOfSuffering.id].buff:UpdateTicks(currentTime)
	end]]
end

local function UpdateSnapshot_Havoc()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local _
	--[[snapshotData.snapshots[spells.chaosNova.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.throwGlaive.id].buff:GetRemainingTime(currentTime)]]
	
	--[[if talents:IsTalentActive(spells.burningHatred) then
		snapshotData.snapshots[spells.immolationAura.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.immolationAura1.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.immolationAura2.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.immolationAura3.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.immolationAura4.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.immolationAura5.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.immolationAura6.id].buff:UpdateTicks(currentTime)
	else
		snapshotData.snapshots[spells.immolationAura.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.immolationAura1.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.immolationAura2.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.immolationAura3.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.immolationAura4.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.immolationAura5.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.immolationAura6.id].buff:GetRemainingTime(currentTime)
	end]]

	--snapshotData.snapshots[spells.tacticalRetreat.id].buff:UpdateTicks(currentTime)

	--[[if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive and 
			snapshotData.snapshots[spells.deathSweep.id].spell.id == spells.bladeDance.id then
		snapshotData.snapshots[spells.bladeDance.id].spell = spells.deathSweep
		snapshotData.snapshots[spells.deathSweep.id].spell = spells.deathSweep
		snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh(true)
		snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh(true)
	elseif not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive and 
			snapshotData.snapshots[spells.bladeDance.id].spell.id == spells.deathSweep.id then
		snapshotData.snapshots[spells.bladeDance.id].spell = spells.bladeDance
		snapshotData.snapshots[spells.deathSweep.id].spell = spells.bladeDance
		snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh(true)
		snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh(true)
	else
		snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh()
		snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh()
	end]]

	--[[snapshotData.snapshots[spells.eyeBeam.id].cooldown:Refresh(true)
	snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh(true)
	snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh(true)
	snapshotData.snapshots[spells.chaosNova.id].cooldown:Refresh()
	snapshotData.snapshots[spells.glaiveTempest.id].cooldown:Refresh()
	snapshotData.snapshots[spells.throwGlaive.id].cooldown:Refresh()
	snapshotData.snapshots[spells.felBarrage.id].cooldown:Refresh()]]

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
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local _

	--snapshotData.snapshots[spells.immolationAura.id].buff:UpdateTicks(currentTime)

	--snapshotData.snapshots[spells.chaosNova.id].cooldown:Refresh()
	--snapshotData.snapshots[spells.felDevastation.id].cooldown:Refresh()
end

local function UpdateSnapshot_Devourer()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local _
	
	local blizzSfBar = _G["DemonHunterSoulFragmentsBar"]
	local sfMin, sfMax = blizzSfBar:GetMinMaxValues()
	local sfCurrent = blizzSfBar:GetValue()
	--[[local sfMax = spells.soulFragments.attributes.maxResource
	local sfMin = 0
	if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
		sfMax = spells.collapsingStar.attributes.maxResource
	end]]

	TRB.Frames.resource2Frames[1].resourceFrame:SetMinMaxValues(sfMin, sfMax)
	snapshotData.attributes.resource2 = sfCurrent
	TRB.Data.character.maxResource2Value = sfMax
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.demonhunter
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.havoc
		local specCacheSettings = TRB.Data.specCache.havoc.settings
		UpdateSnapshot_Havoc()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					if snapshots[spells.immolationAura.id].buff.resource > 0 or snapshots[spells.immolationAura1.id].buff.resource > 0 or snapshots[spells.immolationAura2.id].buff.resource > 0 or snapshots[spells.immolationAura3.id].buff.resource > 0 or snapshots[spells.immolationAura4.id].buff.resource > 0 or snapshots[spells.immolationAura5.id].buff.resource > 0 or snapshots[spells.immolationAura6.id].buff.resource > 0 then
						passiveValue = passiveValue + snapshots[spells.immolationAura.id].buff.resource + snapshots[spells.immolationAura1.id].buff.resource + snapshots[spells.immolationAura2.id].buff.resource + snapshots[spells.immolationAura3.id].buff.resource + snapshots[spells.immolationAura4.id].buff.resource + snapshots[spells.immolationAura5.id].buff.resource + snapshots[spells.immolationAura6.id].buff.resource
					end

					if snapshots[spells.tacticalRetreat.id].buff.resource > 0 then
						passiveValue = passiveValue + snapshots[spells.tacticalRetreat.id].buff.resource
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
							--[[if specCacheSettings.colors.threshold.special.enabled and (snapshots[spells.chaosTheory.id].buff.isActive or snapshots[spells.rendingStrike.id].buff.isActive or snapshots[spells.warbladesHunger.id].buff.isActive) then
								thresholdColor = specCacheSettings.colors.threshold.special.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
							else]]if isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.bladeDance.id or spell.id == spells.deathSweep.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							--[[elseif specCacheSettings.colors.threshold.special.enabled and snapshots[spells.glaiveFlurry.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.special.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority]]
							elseif isUsable then-- currentResource >= resourceAmount then
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
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.vengeance
		local specCacheSettings = TRB.Data.specCache.vengeance.settings
		UpdateSnapshot_Vengeance()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					if snapshots[spells.immolationAura.id].buff.resource then
						passiveValue = passiveValue + snapshots[spells.immolationAura.id].buff.resource
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
					if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.soulCleave.id or spell.id == spells.spiritBomb.id then
							--[[if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.soulFurnace.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.special.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
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
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.devourer
		local specCacheSettings = TRB.Data.specCache.devourer.settings
		UpdateSnapshot_Devourer()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				--local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local metaActive = snapshots[spells.metamorphosis.id].buff.isActive
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local passiveValue = 0
				--[[if specSettings.colors.bar.showPassive then
					if snapshots[spells.immolationAura.id].buff.resource > 0 or snapshots[spells.immolationAura1.id].buff.resource > 0 or snapshots[spells.immolationAura2.id].buff.resource > 0 or snapshots[spells.immolationAura3.id].buff.resource > 0 or snapshots[spells.immolationAura4.id].buff.resource > 0 or snapshots[spells.immolationAura5.id].buff.resource > 0 or snapshots[spells.immolationAura6.id].buff.resource > 0 then
						passiveValue = passiveValue + snapshots[spells.immolationAura.id].buff.resource + snapshots[spells.immolationAura1.id].buff.resource + snapshots[spells.immolationAura2.id].buff.resource + snapshots[spells.immolationAura3.id].buff.resource + snapshots[spells.immolationAura4.id].buff.resource + snapshots[spells.immolationAura5.id].buff.resource + snapshots[spells.immolationAura6.id].buff.resource
					end

					if snapshots[spells.tacticalRetreat.id].buff.resource > 0 then
						passiveValue = passiveValue + snapshots[spells.tacticalRetreat.id].buff.resource
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
								elseif isUsable then-- currentResource >= resourceAmount then
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
				if snapshots[spells.metamorphosis.id].buff.isActive and specSettings.colors.bar.voidMetamorphosis.enabled then
					--[[local timeThreshold = 0
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
					else]]
						barColor = specSettings.colors.bar.voidMetamorphosis.color
					--end
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
				local blizzSfBar = _G["DemonHunterSoulFragmentsBar"]
				local min, max = blizzSfBar:GetMinMaxValues()
				local current = blizzSfBar:GetValue()

				TRB.Frames.resource2Frames[1].resourceFrame:SetMinMaxValues(min, max)
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local cpBorderColor = specSettings.colors.comboPoints.border
				local cpColor = specSettings.colors.comboPoints.base

				local metaUsable = spells.metamorphosis:IsUsable()

				if specSettings.colors.comboPoints.voidMetamorphosisReady.enabled and not snapshots[spells.metamorphosis.id].buff.isActive and metaUsable then
					cpColor = specSettings.colors.comboPoints.voidMetamorphosisReady.color
				elseif specSettings.colors.comboPoints.collapsingStarReady.enabled and snapshots[spells.metamorphosis.id].buff.isActive and metaUsable then
					cpColor = specSettings.colors.comboPoints.collapsingStarReady.color
				end

				local cpBR = cpBackgroundRed
				local cpBG = cpBackgroundGreen
				local cpBB = cpBackgroundBlue

				TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint1", TRB.Frames.resource2Frames[1].resourceFrame, current, max)
				
				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[1].borderFrame, "comboPoint1", cpBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[1].resourceFrame, "comboPoint1", cpColor)
				TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[1].containerFrame, "comboPoint1", cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)

		local lookup = TRB.Data.lookup or {}
		lookup["#artOfTheGlaive"] = spells.artOfTheGlaive.icon
		lookup["#annihilation"] = spells.annihilation.icon
		lookup["#bladeDance"] = spells.bladeDance.icon
		lookup["#blindFury"] = spells.blindFury.icon
		lookup["#bh"] = spells.burningHatred.icon
		lookup["#burningHatred"] = spells.burningHatred.icon
		lookup["#chaosNova"] = spells.chaosNova.icon
		lookup["#chaosStrike"] = spells.chaosStrike.icon
		lookup["#deathSweep"] = spells.deathSweep.icon
		lookup["#eyeBeam"] = spells.eyeBeam.icon
		lookup["#felBarrage"] = spells.felBarrage.icon
		lookup["#glaiveFlurry"] = spells.glaiveFlurry.icon
		lookup["#glaiveTempest"] = spells.glaiveTempest.icon
		lookup["#immolationAura"] = spells.immolationAura.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#rendingStrike"] = spells.rendingStrike.icon
		lookup["#tacticalRetreat"] = spells.tacticalRetreat.icon
		lookup["#unboundChaos"] = spells.unboundChaos.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "havoc" then
			talents = specCache.havoc.talents
			TRB.Data.barConstructedForSpec = "havoc"
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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.vengeance)

		local lookup = TRB.Data.lookup or {}
		lookup["#artOfTheGlaive"] = spells.artOfTheGlaive.icon
		lookup["#glaiveFlurry"] = spells.glaiveFlurry.icon
		lookup["#ia"] = spells.immolationAura.icon
		lookup["#immolationAura"] = spells.immolationAura.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#rendingStrike"] = spells.rendingStrike.icon
		--lookup["#soulFragments"] = spells.soulFragments.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "vengeance" then
			talents = specCache.vengeance.talents
			TRB.Data.barConstructedForSpec = "vengeance"
			ConstructResourceBar(specCache.vengeance.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.devourer.talents:GetTalents()
		FillSpellData_Devourer()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.devourer)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devourer
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.devourer.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.devourer)

		local lookup = TRB.Data.lookup or {}
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#voidRay"] = spells.voidRay.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "devourer" then
			talents = specCache.devourer.talents
			TRB.Data.barConstructedForSpec = "devourer"
			ConstructResourceBar(specCache.devourer.settings)
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
						settings.demonhunter.havoc.displayText.barText = TRB.Options.DemonHunter.HavocLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.vengeance == nil or
						TwintopInsanityBarSettings.demonhunter.vengeance.displayText == nil then
						settings.demonhunter.vengeance.displayText.barText = TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.devourer == nil or
						TwintopInsanityBarSettings.demonhunter.devourer.displayText == nil then
						settings.demonhunter.devourer.displayText.barText = TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
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

		--[[if talents:IsTalentActive(spells.burningHatred) then
			snapshots[spells.immolationAura.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura1.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura2.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura3.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura4.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura5.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura6.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
		else
			snapshots[spells.immolationAura.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura1.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura2.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura3.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura4.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura5.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura6.id].buff:SetTickData(false, 0, 0)
		end]]
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		TRB.Data.character.specName = "vengeance"
		--[[local maxComboPoints = spells.soulFragments.attributes.maxResource
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
			end
		end]]
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		TRB.Data.character.specName = "devourer"

		local maxComboPoints = 1
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
			end
		end
		--[[if talents:IsTalentActive(spells.burningHatred) then
			snapshots[spells.immolationAura.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura1.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura2.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura3.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura4.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura5.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
			snapshots[spells.immolationAura6.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred:GetTickRate())
		else
			snapshots[spells.immolationAura.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura1.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura2.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura3.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura4.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura5.id].buff:SetTickData(false, 0, 0)
			snapshots[spells.immolationAura6.id].buff:SetTickData(false, 0, 0)
		end]]
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.demonhunter.havoc == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.demonhunter.vengeance == true then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.vengeance)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		--[[TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = spells.soulFragments.id
		TRB.Data.resource2Factor = 1]]
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.demonhunter.devourer == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.devourer)
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

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local sharedSettings
		local notZeroShowValue = 0
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
		--[[if var == "$bhFury" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura1.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura2.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura3.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura4.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura5.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura6.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$bhTicks" or var == "$iaTicks" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura1.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura2.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura3.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura4.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura5.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura6.id].buff.ticks > 0 then
				valid = true
			end
		elseif var == "$bhTime" or var == "$iaTime" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.isActive or snapshotData.snapshots[spells.immolationAura1.id].buff.isActive or snapshotData.snapshots[spells.immolationAura2.id].buff.isActive or snapshotData.snapshots[spells.immolationAura3.id].buff.isActive or snapshotData.snapshots[spells.immolationAura4.id].buff.isActive or snapshotData.snapshots[spells.immolationAura5.id].buff.isActive or snapshotData.snapshots[spells.immolationAura6.id].buff.isActive then
				valid = true
			end
		elseif var == "$ucTime" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.isActive or snapshotData.snapshots[spells.immolationAura1.id].buff.isActive or snapshotData.snapshots[spells.immolationAura2.id].buff.isActive or snapshotData.snapshots[spells.immolationAura3.id].buff.isActive or snapshotData.snapshots[spells.immolationAura4.id].buff.isActive or snapshotData.snapshots[spells.immolationAura5.id].buff.isActive or snapshotData.snapshots[spells.immolationAura6.id].buff.isActive then
				valid = true
			end
		elseif var == "$tacticalRetreatFury" then
			if snapshotData.snapshots[spells.tacticalRetreat.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$tacticalRetreatTicks" then
			if snapshotData.snapshots[spells.tacticalRetreat.id].buff.ticks > 0 then
				valid = true
			end
		elseif var == "$tacticalRetreatTime" then
			if snapshotData.snapshots[spells.tacticalRetreat.id].buff.isActive then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 2 then --Vengeance
		--[[if var == "$iaFury" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$iaTicks" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.ticks > 0 then
				valid = true
			end
		elseif var == "$iaTime" then
			if snapshotData.snapshots[spells.immolationAura.id].buff.isActive then
				valid = true
			end
		elseif var == "$comboPoints" or var == "$soulFragments" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$soulFragmentsMax" then
			valid = true
		end]]
	elseif TRB.Data.character.specId == 3 then --Devourer
	end
	
	if var == "$metamorphosisTime" or var == "$metaTime" or var == "$voidMetaTime" or var == "$voidMetamorphosisTime" then
		if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
			valid = true
		end
	--[[elseif var == "$aotgStacks" then
		if snapshotData.snapshots[spells.artOfTheGlaive.id].buff.isActive then
			valid = true
		end
	elseif var == "$aotgTime" then
		if snapshotData.snapshots[spells.artOfTheGlaive.id].buff.isActive then
			valid = true
		end
	elseif var == "$gfTime" then
		if snapshotData.snapshots[spells.glaiveFlurry.id].buff.isActive then
			valid = true
		end
	elseif var == "$rsTime" then
		if snapshotData.snapshots[spells.rendingStrike.id].buff.isActive then
			valid = true
		end
	elseif var == "$sosFury" then
		if snapshotData.snapshots[spells.studentOfSuffering.id].buff.resource > 0 then
			valid = true
		end
	elseif var == "$sosTicks" then
		if snapshotData.snapshots[spells.studentOfSuffering.id].buff.ticks > 0 then
			valid = true
		end
	elseif var == "$sosTime" then
		if snapshotData.snapshots[spells.studentOfSuffering.id].buff.isActive then
			valid = true
		end]]
	elseif var == "$resource" or var == "$fury" then
		if normalizedResource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$furyMax" then
		valid = true
	--[[elseif var == "$resourceTotal" or var == "$furyTotal" then
		if normalizedResource > 0  or TRB.Functions.Class:IsValidVariableForSpec("$passive") or TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
			then
			valid = true
		end
	elseif var == "$resourcePlusCasting" or var == "$furyPlusCasting" then
		if normalizedResource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
			valid = true
		end
	elseif var == "$overcap" or var == "$furyOvercap" or var == "$resourceOvercap" then
		local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
		if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) <= threshold then
			return true
		elseif settings.overcap.mode == "fixed" and settings.overcap.fixed <= threshold then
			return true
		end
	elseif var == "$resourcePlusPassive" or var == "$furyPlusPassive" then
		if normalizedResource > 0 or TRB.Functions.Class:IsValidVariableForSpec("$passive") or TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or TRB.Functions.Class:IsValidVariableForSpec("$iaFury") or TRB.Functions.Class:IsValidVariableForSpec("$sosFury") then
			valid = true
		end]]
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	--[[elseif var == "$passive" then
		if TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or TRB.Functions.Class:IsValidVariableForSpec("$tacticalRetreatFury") or TRB.Functions.Class:IsValidVariableForSpec("$iaFury") or TRB.Functions.Class:IsValidVariableForSpec("$sosFury") then
			valid = true
		end]]
		elseif var == "$comboPoints" or var == "$soulFragments" or var == "$collapsingStar" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$soulFragmentsMax" or var == "$collapsingStarMax" then
			valid = true
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	--local settings = TRB.Data.settings.demonhunter
	--local spells = TRB.Data.spells
	--local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	--[[
	if TRB.Data.character.specId == 1 then
	elseif TRB.Data.character.specId == 2 then
	elseif TRB.Data.character.specId == 3 then
	end]]
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end
	
	UpdateResourceBar()
end