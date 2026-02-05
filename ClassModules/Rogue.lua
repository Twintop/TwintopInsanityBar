local _, TRB = ...
if TRB.Data.character.classId ~= 4 then --Only do this if we're on a Rogue!
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
	assassination = TRB.Classes.SpecCache:New(),
	outlaw = TRB.Classes.SpecCache:New(),
	subtlety = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Assassination
	specCache.assassination.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.assassination.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		}
	}
	
	---@type TRB.Classes.Rogue.AssassinationSpells
	specCache.assassination.spellsData.spells = TRB.Classes.Rogue.AssassinationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	local spells = specCache.assassination.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]

	specCache.assassination.snapshotData.attributes.resourceRegen = 0
	specCache.assassination.snapshotData.attributes.comboPoints = 0
	specCache.assassination.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.kidneyShot.id] = TRB.Classes.Snapshot:New(spells.kidneyShot)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.shiv.id] = TRB.Classes.Snapshot:New(spells.shiv)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.feint.id] = TRB.Classes.Snapshot:New(spells.feint)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.gouge.id] = TRB.Classes.Snapshot:New(spells.gouge)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.garrote.id] = TRB.Classes.Snapshot:New(spells.garrote)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.improvedGarrote.id] = TRB.Classes.Snapshot:New(spells.improvedGarrote, {
		isActiveStealth = false
	})
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.kingsbane.id] = TRB.Classes.Snapshot:New(spells.kingsbane)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.blindside.id] = TRB.Classes.Snapshot:New(spells.blindside)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand)

	specCache.assassination.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Outlaw
	specCache.outlaw.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.outlaw.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		}
	}
	
	---@type TRB.Classes.Rogue.OutlawSpells
	specCache.outlaw.spellsData.spells = TRB.Classes.Rogue.OutlawSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.outlaw.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]

	specCache.outlaw.snapshotData.attributes.resourceRegen = 0
	specCache.outlaw.snapshotData.attributes.comboPoints = 0
	specCache.outlaw.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.feint.id] = TRB.Classes.Snapshot:New(spells.feint)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.kidneyShot.id] = TRB.Classes.Snapshot:New(spells.kidneyShot)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.shiv.id] = TRB.Classes.Snapshot:New(spells.shiv)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.gouge.id] = TRB.Classes.Snapshot:New(spells.gouge)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.betweenTheEyes.id] = TRB.Classes.Snapshot:New(spells.betweenTheEyes)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.bladeFlurry.id] = TRB.Classes.Snapshot:New(spells.bladeFlurry)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.bladeRush.id] = TRB.Classes.Snapshot:New(spells.bladeRush)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.opportunity.id] = TRB.Classes.Snapshot:New(spells.opportunity)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.killingSpree.id] = TRB.Classes.Snapshot:New(spells.killingSpree)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id] = TRB.Classes.Snapshot:New(spells.rollTheBones, {
		---@type table<integer, TRB.Classes.Snapshot>
		buffs = {
			[spells.broadside.id] = TRB.Classes.Snapshot:New(spells.broadside, {
				fromCountTheOdds = false
			}),
			[spells.buriedTreasure.id] = TRB.Classes.Snapshot:New(spells.buriedTreasure, {
				fromCountTheOdds = false
			}),
			[spells.grandMelee.id] = TRB.Classes.Snapshot:New(spells.grandMelee, {
				fromCountTheOdds = false
			}),
			[spells.ruthlessPrecision.id] = TRB.Classes.Snapshot:New(spells.ruthlessPrecision, {
				fromCountTheOdds = false
			}),
			[spells.skullAndCrossbones.id] = TRB.Classes.Snapshot:New(spells.skullAndCrossbones, {
				fromCountTheOdds = false
			}),
			[spells.trueBearing.id] =TRB.Classes.Snapshot:New(spells.trueBearing, {
				fromCountTheOdds = false
			})
		},
		count = 0,
		temporaryCount = 0,
		goodBuffs = false
	})
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.broadside.id] = specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.broadside.id]
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.buriedTreasure.id] = specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.buriedTreasure.id]
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.grandMelee.id] = specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.grandMelee.id]
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.ruthlessPrecision.id] = specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.ruthlessPrecision.id]
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.skullAndCrossbones.id] = specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.skullAndCrossbones.id]
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.trueBearing.id] = specCache.outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.trueBearing.id]
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.escalatingBlade.id] = TRB.Classes.Snapshot:New(spells.escalatingBlade, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand)

	specCache.outlaw.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Subtlety
	specCache.subtlety.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.subtlety.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		}
	}
	
	---@type TRB.Classes.Rogue.SubtletySpells
	specCache.subtlety.spellsData.spells = TRB.Classes.Rogue.SubtletySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.subtlety.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]

	specCache.subtlety.snapshotData.attributes.resourceRegen = 0
	specCache.subtlety.snapshotData.attributes.comboPoints = 0
	specCache.subtlety.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.feint.id] = TRB.Classes.Snapshot:New(spells.feint)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.gouge.id] = TRB.Classes.Snapshot:New(spells.gouge)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.kidneyShot.id] = TRB.Classes.Snapshot:New(spells.kidneyShot)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shiv.id] = TRB.Classes.Snapshot:New(spells.shiv)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.symbolsOfDeath.id] = TRB.Classes.Snapshot:New(spells.symbolsOfDeath)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.goremawsBite.id] = TRB.Classes.Snapshot:New(spells.goremawsBite)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.secretTechnique.id] = TRB.Classes.Snapshot:New(spells.secretTechnique)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowBlades.id] = TRB.Classes.Snapshot:New(spells.shadowBlades)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowDance.id] = TRB.Classes.Snapshot:New(spells.shadowDance)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shotInTheDark.id] = TRB.Classes.Snapshot:New(spells.shotInTheDark, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowTechniques.id] = TRB.Classes.Snapshot:New(spells.shadowTechniques, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.flagellation.id] = TRB.Classes.Snapshot:New(spells.flagellation)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.silentStorm.id] = TRB.Classes.Snapshot:New(spells.silentStorm, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.finalityBlackPowder.id] = TRB.Classes.Snapshot:New(spells.finalityBlackPowder, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.finalityEviscerate.id] = TRB.Classes.Snapshot:New(spells.finalityEviscerate, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.finalityRupture.id] = TRB.Classes.Snapshot:New(spells.finalityRupture, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.escalatingBlade.id] = TRB.Classes.Snapshot:New(spells.escalatingBlade, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand)

	specCache.subtlety.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Assassination()
	TRB.Functions.Character:FillSpecializationCacheSettings("rogue", "assassination")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Assassination using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Assassination()
	Setup_Assassination()
	specCache.assassination.spellsData:FillSpellData()
	local spells = specCache.assassination.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
	
	-- This is done here so that we can get icons for the options menu!
	specCache.assassination.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#blindside", icon = spells.blindside.icon, description = spells.blindside.name, printInSettings = true },
		{ variable = "#crimsonTempest", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = true },
		{ variable = "#ct", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = false },
		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#garrote", icon = spells.garrote.icon, description = spells.garrote.name, printInSettings = true },
		{ variable = "#rupture", icon = spells.rupture.icon, description = spells.rupture.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
	}
	specCache.assassination.barTextVariables.values = {
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
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },

		{ variable = "$energy", description = L["RogueAssassinationBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["RogueAssassinationBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueAssassinationBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueAssassinationBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

		--[[
		-- Proc
		{ variable = "$blindsideTime", description = L["RogueAssassinationBarTextVariable_blindsideTime"], printInSettings = true, color = false },]]
	}
end

local function Setup_Outlaw()
	TRB.Functions.Character:FillSpecializationCacheSettings("rogue", "outlaw")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Outlaw using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Outlaw()
	Setup_Outlaw()
	specCache.outlaw.spellsData:FillSpellData()
	local spells = specCache.outlaw.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.outlaw.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#adrenalineRush", icon = spells.adrenalineRush.icon, description = spells.adrenalineRush.name, printInSettings = true },
		{ variable = "#betweenTheEyes", icon = spells.betweenTheEyes.icon, description = spells.betweenTheEyes.name, printInSettings = true },
		{ variable = "#bladeFlurry", icon = spells.bladeFlurry.icon, description = spells.bladeFlurry.name, printInSettings = true },
		{ variable = "#bladeRush", icon = spells.bladeRush.icon, description = spells.bladeRush.name, printInSettings = true },
		{ variable = "#broadside", icon = spells.broadside.icon, description = spells.broadside.name, printInSettings = true },
		{ variable = "#buriedTreasure", icon = spells.buriedTreasure.icon, description = spells.buriedTreasure.name, printInSettings = true },
		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dispatch", icon = spells.dispatch.icon, description = spells.dispatch.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#grandMelee", icon = spells.grandMelee.icon, description = spells.grandMelee.name, printInSettings = true },
		{ variable = "#opportunity", icon = spells.opportunity.icon, description = spells.opportunity.name, printInSettings = true },
		{ variable = "#pistolShot", icon = spells.pistolShot.icon, description = spells.pistolShot.name, printInSettings = true },
		{ variable = "#rollTheBones", icon = spells.rollTheBones.icon, description = spells.rollTheBones.name, printInSettings = true },
		{ variable = "#ruthlessPrecision", icon = spells.ruthlessPrecision.icon, description = spells.ruthlessPrecision.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#sinisterStrike", icon = spells.sinisterStrike.icon, description = spells.sinisterStrike.name, printInSettings = true },
		{ variable = "#skullAndCrossbones", icon = spells.skullAndCrossbones.icon, description = spells.skullAndCrossbones.name, printInSettings = true },
		{ variable = "#trueBearing", icon = spells.trueBearing.icon, description = spells.trueBearing.name, printInSettings = true },
	}
	specCache.outlaw.barTextVariables.values = {
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
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueOutlawBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["RogueOutlawBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueOutlawBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueOutlawBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

		--[[{ variable = "$rtbCount", description = L["RogueOutlawBarTextVariable_rtbCount"], printInSettings = true, color = false },
		{ variable = "$rollTheBonesCount", description = "", printInSettings = false, color = false },

		{ variable = "$rtbTemporaryCount", description = L["RogueOutlawBarTextVariable_rtbTemporaryCount"], printInSettings = true, color = false },
		{ variable = "$rollTheBonesTemporaryCount", description = "", printInSettings = false, color = false },

		{ variable = "$rtbAllCount", description = L["RogueOutlawBarTextVariable_rtbAllCount"], printInSettings = true, color = false },
		{ variable = "$rollTheBonesAllCount", description = "", printInSettings = false, color = false },
		
		{ variable = "$rtbBuffTime", description = L["RogueOutlawBarTextVariable_rtbBuffTime"], printInSettings = true, color = false },
		{ variable = "$rollTheBonesBuffTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$rtbGoodBuff", description = L["RogueOutlawBarTextVariable_rtbGoodBuff"], printInSettings = true, color = false },
		{ variable = "$rollTheBonesGoodBuff", description = "", printInSettings = false, color = false },

		{ variable = "$broadsideTime", description = L["RogueOutlawBarTextVariable_broadsideTime"], printInSettings = true, color = false },
		{ variable = "$buriedTreasureTime", description = L["RogueOutlawBarTextVariable_buriedTreasureTime"], printInSettings = true, color = false },
		{ variable = "$grandMeleeTime", description = L["RogueOutlawBarTextVariable_grandMeleeTime"], printInSettings = true, color = false },
		{ variable = "$ruthlessPrecisionTime", description = L["RogueOutlawBarTextVariable_ruthlessPrecisionTime"], printInSettings = true, color = false },
		{ variable = "$skullAndCrossbonesTime", description = L["RogueOutlawBarTextVariable_skullAndCrossbonesTime"], printInSettings = true, color = false },
		{ variable = "$trueBearingTime", description = L["RogueOutlawBarTextVariable_trueBearingTime"], printInSettings = true, color = false },

		-- Proc
		{ variable = "$opportunityTime", description = L["RogueOutlawBarTextVariable_opportunityTime"], printInSettings = true, color = false },]]
	}
end

local function Setup_Subtlety()
	TRB.Functions.Character:FillSpecializationCacheSettings("rogue", "subtlety")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Subtlety using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Subtlety()
	Setup_Subtlety()
	specCache.subtlety.spellsData:FillSpellData()
	local spells = specCache.subtlety.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.subtlety.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#flagellation", icon = spells.flagellation.icon, description = spells.flagellation.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#shadowTechniques", icon = spells.shadowTechniques.icon, description = spells.shadowTechniques.name, printInSettings = true },
		{ variable = "#sod", icon = spells.symbolsOfDeath.icon, description = spells.symbolsOfDeath.name, printInSettings = true },
		{ variable = "#symbolsOfDeath", icon = spells.symbolsOfDeath.icon, description = spells.symbolsOfDeath.name, printInSettings = false },
	}
	specCache.subtlety.barTextVariables.values = {
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
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueSubtletyBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["RogueSubtletyBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueSubtletyBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueSubtletyBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
		--[[{ variable = "$shadowTechniquesCount", description = L["RogueSubtletyBarTextVariable_shadowTechniquesCount"], printInSettings = true, color = false },

		{ variable = "$sodTime", description = L["RogueSubtletyBarTextVariable_sodTime"], printInSettings = true, color = false },
		{ variable = "$symbolsOfDeathTime", description = "", printInSettings = false, color = false },

		{ variable = "$flagellationTime", description = L["RogueSubtletyBarTextVariable_flagellationTime"], printInSettings = true, color = false },]]
	}
end

local function UpdateCastingResourceFinal()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	
	if TRB.Data.character.specId == 1 then -- Assassination
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Outlaw
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Outlaw
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- All Rogue specs use secondary bar (Combo Points). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0, use a fallback.
	if barGroups and barGroups.secondary then
		local maxComboPoints = TRB.Data.character.maxResource2
		if maxComboPoints == nil or maxComboPoints == 0 then
			maxComboPoints = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxComboPoints
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

	-- All Rogue specs use secondary bar (Combo Points)
	if barGroups and barGroups.secondary then
		local maxComboPoints = TRB.Data.character.maxResource2 or 5
		
		-- Ensure we have enough nodes for the max combo points
		barGroups.secondary:SetMaxNodes(maxComboPoints)
		
		-- Ensure secondary group knows the correct node count
		barGroups.secondary:SetNodeCount(maxComboPoints)
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
		
		-- Explicitly set textures and colors for each Combo Point node
		local frameLevels = TRB.Data.constants.frameLevels
		for i = 1, maxComboPoints do
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

local function RefreshLookupData_Assassination()
	local specSettings = TRB.Data.settings.rogue.assassination
	local sharedSettings = TRB.Data.specCache["assassination"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedEnergy = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
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
				currentEnergyColor = sharedSettings.colors.text.overThreshold.color
				castingEnergyColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = sharedSettings.colors.text.spending.color
	end

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy
	local castingEnergy
	-- Apply overcap color if enabled (takes precedence over overThreshold, skipped when stealthed)
	if not IsStealthed() and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", _normalizedEnergy))
		castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)
		castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
		
	--[[
	--$blindsideTime
	local _blindsideTime = snapshots[spells.blindside.id].buff:GetRemainingTime(currentTime)
	local blindsideTime = TRB.Functions.BarText:TimerPrecision(_blindsideTime)]]

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$inStealth"] = ""
	--[[
	lookup["$blindsideTime"] = blindsideTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$inStealth"] = IsStealthed()
	--[[
	lookupLogic["$blindsideTime"] = _blindsideTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Outlaw()
	local specSettings = TRB.Data.settings.rogue.outlaw
	local sharedSettings = TRB.Data.specCache["outlaw"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedEnergy = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	--Spec specific implementation

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
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
				currentEnergyColor = sharedSettings.colors.text.overThreshold.color
				castingEnergyColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = sharedSettings.colors.text.spending.color
	end

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy
	local castingEnergy
	-- Apply overcap color if enabled (takes precedence over overThreshold, skipped when stealthed)
	if not IsStealthed() and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", _normalizedEnergy))
		castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)
		castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
	
	--[[
	local rollTheBones = snapshots[spells.rollTheBones.id]
	local rollTheBonesCount = rollTheBones.attributes.count
	local rollTheBonesTemporaryCount = rollTheBones.attributes.temporaryCount
	local rollTheBonesAllCount = rollTheBones.attributes.count + rollTheBones.attributes.temporaryCount

	--$rtbBuffTime
	local _rtbBuffTime = snapshots[spells.rollTheBones.id].buff.remaining
	local rtbBuffTime = TRB.Functions.BarText:TimerPrecision(_rtbBuffTime)

	--$rtbGoodBuff
	local _rtbGoodBuff = snapshots[spells.rollTheBones.id].attributes.goodBuffs

	--$broadsideTime
	local _broadsideTime = snapshots[spells.broadside.id].buff:GetRemainingTime(currentTime)
	local broadsideTime = TRB.Functions.BarText:TimerPrecision(_broadsideTime)

	--$buriedTreasureTime
	local _buriedTreasureTime = snapshots[spells.buriedTreasure.id].buff:GetRemainingTime(currentTime)
	local buriedTreasureTime = TRB.Functions.BarText:TimerPrecision(_buriedTreasureTime)

	--$grandMeleeTime
	local _grandMeleeTime = snapshots[spells.grandMelee.id].buff:GetRemainingTime(currentTime)
	local grandMeleeTime = TRB.Functions.BarText:TimerPrecision(_grandMeleeTime)

	--$ruthlessPrecisionTime
	local _ruthlessPrecisionTime = snapshots[spells.ruthlessPrecision.id].buff:GetRemainingTime(currentTime)
	local ruthlessPrecisionTime = TRB.Functions.BarText:TimerPrecision(_ruthlessPrecisionTime)

	--$skullAndCrossbonesTime
	local _skullAndCrossbonesTime = snapshots[spells.skullAndCrossbones.id].buff:GetRemainingTime(currentTime)
	local skullAndCrossbonesTime = TRB.Functions.BarText:TimerPrecision(_skullAndCrossbonesTime)

	--$trueBearingTime
	local _trueBearingTime = snapshots[spells.trueBearing.id].buff:GetRemainingTime(currentTime)
	local trueBearingTime = TRB.Functions.BarText:TimerPrecision(_trueBearingTime)

	
	--$opportunityTime
	local _opportunityTime = snapshots[spells.opportunity.id].buff:GetRemainingTime(currentTime)
	local opportunityTime = TRB.Functions.BarText:TimerPrecision(_opportunityTime)]]

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$inStealth"] = ""
	--[[
	lookup["$opportunityTime"] = opportunityTime
	lookup["$rtbCount"] = rollTheBonesCount
	lookup["$rollTheBonesCount"] = rollTheBonesCount
	lookup["$rtbGoodBuff"] = ""
	lookup["$rollTheBonesGoodBuff"] = ""
	lookup["$rtbAllCount"] = rollTheBonesAllCount
	lookup["$rollTheBonesAllCount"] = rollTheBonesAllCount
	lookup["$rtbTemporaryCount"] = rollTheBonesTemporaryCount
	lookup["$rollTheBonesTemporaryCount"] = rollTheBonesTemporaryCount
	lookup["$rtbBuffTime"] = rtbBuffTime
	lookup["$rollTheBonesBuffTime"] = rtbBuffTime
	lookup["$broadsideTime"] = broadsideTime
	lookup["$buriedTreasureTime"] = buriedTreasureTime
	lookup["$grandMeleeTime"] = grandMeleeTime
	lookup["$ruthlessPrecisionTime"] = ruthlessPrecisionTime
	lookup["$skullAndCrossbonesTime"] = skullAndCrossbonesTime
	lookup["$trueBearingTime"] = trueBearingTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$inStealth"] = IsStealthed()
	--[[
	lookupLogic["$opportunityTime"] = _opportunityTime
	lookupLogic["$rtbCount"] = rollTheBonesCount
	lookupLogic["$rollTheBonesCount"] = rollTheBonesCount
	lookupLogic["$rtbGoodBuff"] = _rtbGoodBuff
	lookupLogic["$rollTheBonesGoodBuff"] = _rtbGoodBuff
	lookupLogic["$rtbAllCount"] = rollTheBonesAllCount
	lookupLogic["$rollTheBonesAllCount"] = rollTheBonesAllCount
	lookupLogic["$rtbTemporaryCount"] = rollTheBonesTemporaryCount
	lookupLogic["$rollTheBonesTemporaryCount"] = rollTheBonesTemporaryCount
	lookupLogic["$rtbBuffTime"] = _rtbBuffTime
	lookupLogic["$rollTheBonesBuffTime"] = _rtbBuffTime
	lookupLogic["$broadsideTime"] = _broadsideTime
	lookupLogic["$buriedTreasureTime"] = _buriedTreasureTime
	lookupLogic["$grandMeleeTime"] = _grandMeleeTime
	lookupLogic["$ruthlessPrecisionTime"] = _ruthlessPrecisionTime
	lookupLogic["$skullAndCrossbonesTime"] = _skullAndCrossbonesTime
	lookupLogic["$trueBearingTime"] = _trueBearingTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Subtlety()
	local specSettings = TRB.Data.settings.rogue.subtlety
	local sharedSettings = TRB.Data.specCache["subtlety"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedEnergy = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.primaryResourceType ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = sharedSettings.colors.text.overThreshold.color
				castingEnergyColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = sharedSettings.colors.text.spending.color
	end

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy
	local castingEnergy
	-- Apply overcap color if enabled (takes precedence over overThreshold, skipped when stealthed)
	if not IsStealthed() and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", _normalizedEnergy))
		castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)
		castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
	
	--[[
	--$flagellationTime
	local _flagellationTime = snapshots[spells.flagellation.id].buff:GetRemainingTime(currentTime)
	local flagellationTime = TRB.Functions.BarText:TimerPrecision(_flagellationTime)

	--$sodTime
	local _sodTime = snapshots[spells.symbolsOfDeath.id].buff:GetRemainingTime(currentTime)
	local sodTime = TRB.Functions.BarText:TimerPrecision(_sodTime)

	--$shadowTechniquesCount
	local shadowTechniquesCount = snapshots[spells.shadowTechniques.id].buff.applications or 0]]

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$inStealth"] = ""
	--[[
	lookup["$shadowTechniquesCount"] = shadowTechniquesCount
	lookup["$flagellationTime"] = flagellationTime
	lookup["$sodTime"] = sodTime
	lookup["$symbolsOfDeathTime"] = sodTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$inStealth"] = IsStealthed()
	--[[
	lookupLogic["$shadowTechniquesCount"] = shadowTechniquesCount
	lookupLogic["$flagellationTime"] = _flagellationTime
	lookupLogic["$sodTime"] = _sodTime
	lookupLogic["$symbolsOfDeathTime"] = _sodTime]]
	TRB.Data.lookupLogic = lookupLogic
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
end

local function UpdateRollTheBones()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
	---@type TRB.Classes.Snapshot
	local rollTheBones = TRB.Data.snapshotData.snapshots[spells.rollTheBones.id]
	---@type table<integer, TRB.Classes.Snapshot>
	local buffs = rollTheBones.attributes.buffs
	local currentTime = GetTime()
			
	local rollTheBonesCount = 0
	local rollTheBonesTemporaryCount = 0
	local highestRemaining = 0
	for _, v in pairs(buffs) do
		local remaining = v.buff:GetRemainingTime(currentTime)
		if v.buff.isActive then
			if v.attributes.fromCountTheOdds then
				rollTheBonesTemporaryCount = rollTheBonesTemporaryCount + 1
			else
				rollTheBonesCount = rollTheBonesCount + 1
				if remaining > highestRemaining then
					highestRemaining = remaining
				end
			end
		end
	end
	rollTheBones.attributes.count = rollTheBonesCount
	rollTheBones.attributes.temporaryCount = rollTheBonesTemporaryCount
	rollTheBones.attributes.remaining = highestRemaining

	if rollTheBones.attributes.count >= 2 or buffs[spells.broadside.id].buff.isActive or buffs[spells.trueBearing.id].buff.isActive then
		rollTheBones.attributes.goodBuffs = true
	else
		rollTheBones.attributes.goodBuffs = false
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.RogueBaseSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateSnapshot_Assassination()
	UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.AssassinationSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateSnapshot_Outlaw()
	UpdateSnapshot()
	UpdateRollTheBones()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.OutlawSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots]]
end

local function UpdateSnapshot_Subtlety()
	UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.SubtletySpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.rogue
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	TRB.Functions.Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.assassination
		local specCacheSettings = TRB.Data.specCache.assassination.settings
		UpdateSnapshot_Assassination()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive

				local thresholds = primaryNode and primaryNode:GetThresholds() or {}
				local nodeResourceFrame = primaryNode and primaryNode:GetResourceFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if primaryNode and thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
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

					if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
						if spell.id == spells.ambush.id then
							if stealthViaBuff then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif snapshots[spells.blindside.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
							end
						elseif stealthViaBuff then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					else
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.sliceAndDice.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.garrote.id then
								if not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.improvedGarrote.id].attributes.isActiveStealth or snapshots[spells.improvedGarrote.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.mutilate.id then
								if specCacheSettings.colors.threshold["echoingReprimand"].enabled and snapshots[spells.echoingReprimand.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold["echoingReprimand"].color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
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
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					if	spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
						not isUsable then-- snapshotData.attributes.resource2 == 0 then
						thresholdColor = specCacheSettings.colors.threshold.unusable.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					end

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local barColor = specSettings.colors.bar.base

				local barBorderColor = specSettings.colors.bar.border

				if barGroups and barGroups.primary then
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				end

				if primaryNode then
					if IsStealthed() or stealthViaBuff then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderStealth)
					elseif specSettings.colors.bar.overcapEnabled and affectingCombat then
						-- Apply overcap border color if enabled (skipped when stealthed)
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

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				local charged = GetUnitChargedPowerPoints("player")
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue
					local sbs = false

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
							end

							if charged ~= nil then
								for y = 1, #charged do
									if charged[y] == x then
										cpColor = specSettings.colors.comboPoints.echoingReprimand
										
										if not sbs then
											cpBorderColor = specSettings.colors.comboPoints.echoingReprimand
										end
				
										if not specSettings.colors.comboPoints.consistentUnfilledColor then
											cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
										end
									end
								end
							end
							
							cpNode:SetBorderColor(cpBorderColor)
							cpNode:SetColor(cpColor)
							cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.outlaw
		local specCacheSettings = TRB.Data.specCache.outlaw.settings
		UpdateSnapshot_Outlaw()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive

				local thresholds = primaryNode and primaryNode:GetThresholds() or {}
				local nodeResourceFrame = primaryNode and primaryNode:GetResourceFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if primaryNode and thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
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

					if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
						if spell.id == spells.ambush.id then
							if stealthViaBuff then
								if isUsable then
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over.color
								else
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else
								showThreshold = false
							end
						elseif stealthViaBuff then
							if isUsable then
								thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over.color
							else
								thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					else
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.sinisterStrike.id then
								if specCacheSettings.colors.threshold["echoingReprimand"].enabled and snapshots[spells.echoingReprimand.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold["echoingReprimand"].color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								elseif isUsable then
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.skullAndCrossbones.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.skullAndCrossbones.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.pistolShot.id then
								if isUsable then
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.opportunity.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.opportunity.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.betweenTheEyes.id then
								if snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specCacheSettings.colors.threshold.unusable.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif isUsable then
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.ruthlessPrecision.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.ruthlessPrecision.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.sliceAndDice.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.dispatch.id then
								if snapshots[spells.escalatingBlade.id].buff.applications >= spells.escalatingBlade.maxStacks then
									showThreshold = false
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.coupDeGrace.id then
								if snapshots[spells.escalatingBlade.id].buff.applications < spells.escalatingBlade.maxStacks then
									showThreshold = false
								elseif specCacheSettings.colors.threshold.special.enabled and currentResource >= resourceAmount then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
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
					end

					if spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
						not isUsable --snapshotData.attributes.resource2 == 0
						then
						thresholdColor = specCacheSettings.colors.threshold.unusable.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					end

					if specCacheSettings.colors.threshold["restlessBlades"].enabled and spell.attributes.restlessBlades and
						(spell.attributes.floatLikeAButterfly == nil or (spell.attributes.floatLikeAButterfly and talents:IsTalentActive(spells.floatLikeAButterfly))) and
						snapshot ~= nil and snapshot.cooldown.remainingTotal > 0 and snapshot.cooldown.remaining <= snapshotData.attributes.resource2
						then
						thresholdColor = specCacheSettings.colors.threshold["restlessBlades"].color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local barColor = specSettings.colors.bar.base

				local barBorderColor = specSettings.colors.bar.border

				if barGroups and barGroups.primary then
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				end

				if primaryNode then
					if IsStealthed() or stealthViaBuff then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderStealth)
					--[[elseif snapshots[spells.rollTheBones.id].attributes.goodBuffs == true and snapshots[spells.rollTheBones.id].cooldown:IsUsable() then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderRtbGood)
					elseif snapshots[spells.rollTheBones.id].attributes.goodBuffs == false and snapshots[spells.rollTheBones.id].cooldown:IsUsable() then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderRtbBad)]]
					elseif specSettings.colors.bar.overcapEnabled and affectingCombat then
						-- Apply overcap border color if enabled (skipped when stealthed)
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

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				local charged = GetUnitChargedPowerPoints("player")

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
							end

							if charged ~= nil then
								for y = 1, #charged do
									if charged[y] == x then
										cpColor = specSettings.colors.comboPoints.echoingReprimand
										cpBorderColor = specSettings.colors.comboPoints.echoingReprimand
				
										if not specSettings.colors.comboPoints.consistentUnfilledColor then
											cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
										end
									end
								end
							end
							
							cpNode:SetBorderColor(cpBorderColor)
							cpNode:SetColor(cpColor)
							cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
		local specSettings = classSettings.subtlety
		local specCacheSettings = TRB.Data.specCache.subtlety.settings
		UpdateSnapshot_Subtlety()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				local nodeResourceFrame = nil
				if primaryNode then
					nodeResourceFrame = primaryNode:GetResourceFrame()
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				end

				local thresholds = {}
				if primaryNode then
					thresholds = primaryNode:GetThresholds()
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.shadowDance.id].buff.isActive

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if thresholds[thresholdId] == nil and primaryNode then
						thresholds[thresholdId] = primaryNode:RegisterThreshold(thresholdId)
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					
					if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
						if stealthViaBuff then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					else
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.sliceAndDice.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.backstab.id then
								if talents:IsTalentActive(spells.gloomblade) then
									showThreshold = false
								else
									if isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.gloomblade.id then
								if not talents:IsTalentActive(spells.gloomblade) then
									showThreshold = false
								else
									if specCacheSettings.colors.threshold["echoingReprimand"].enabled and snapshots[spells.echoingReprimand.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold["echoingReprimand"].color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.cheapShot.id then
								if snapshots[spells.shotInTheDark.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.over.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.shurikenStorm.id then
								if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.silentStorm.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.blackPowder.id then
								if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.finalityBlackPowder.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.eviscerate.id then
								if snapshots[spells.escalatingBlade.id].buff.applications >= spells.escalatingBlade.maxStacks then
									showThreshold = false
								elseif specCacheSettings.colors.threshold.special.enabled and snapshots[spells.finalityEviscerate.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.coupDeGrace.id then
								if snapshots[spells.escalatingBlade.id].buff.applications < spells.escalatingBlade.maxStacks then
									showThreshold = false
								elseif isUsable then
									if specCacheSettings.colors.threshold.special.enabled then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
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
					end

					if 	spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true then
						if not isUsable then-- snapshotData.attributes.resource2 == 0 then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif thresholdColor ~= specCacheSettings.colors.threshold.special.color and snapshots[spells.goremawsBite.id].buff.isActive and (snapshotData.snapshots[spell.id] == nil or snapshotData.snapshots[spell.id].cooldown:IsUsable()) then
							thresholdColor = specCacheSettings.colors.threshold.over.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdOver
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local barColor = specSettings.colors.bar.base

				local barBorderColor = specSettings.colors.bar.border
				
				if barGroups and barGroups.primary then
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				end

				if primaryNode then
					if snapshots[spells.symbolsOfDeath.id].buff.isActive and
						snapshots[spells.shadowTechniques.id].buff.applications >= TRB.Data.character.maxResource2 and
						talents:IsTalentActive(spells.shadowcraft) then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderShadowcraft)
					elseif stealthViaBuff or IsStealthed() then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderStealth)
					elseif specSettings.colors.bar.overcapEnabled and affectingCombat then
						-- Apply overcap border color if enabled (skipped when stealthed)
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

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				local charged = GetUnitChargedPowerPoints("player")

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
							end
						
							local isCharged = false
							if charged ~= nil then
								for y = 1, #charged do
									if charged[y] == x then
										cpColor = specSettings.colors.comboPoints.echoingReprimand
										cpBorderColor = specSettings.colors.comboPoints.echoingReprimand
					
										if not specSettings.colors.comboPoints.consistentUnfilledColor then
											cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
										end
										isCharged = true
									end
								end
							end

							if not isCharged and x > snapshotData.attributes.resource2 and (snapshots[spells.shadowTechniques.id].buff.applications + snapshotData.attributes.resource2) >= x then
								cpBorderColor = specSettings.colors.comboPoints.shadowTechniques

								if not specSettings.colors.comboPoints.consistentUnfilledColor then
									cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.shadowTechniques, true)
								end
							end
							
							cpNode:SetBorderColor(cpBorderColor)
							cpNode:SetColor(cpColor)
							cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
		specCache.assassination.talents:GetTalents()
		FillSpellData_Assassination()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.assassination)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		spells.shiv:ResetPrimaryResourceCost()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.assassination.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#blindside"] = spells.blindside.icon
		lookup["#crimsonTempest"] = spells.crimsonTempest.icon
		lookup["#ct"] = spells.crimsonTempest.icon
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#garrote"] = spells.garrote.icon
		lookup["#rupture"] = spells.rupture.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "assassination" then
			talents = specCache.assassination.talents
			TRB.Data.barConstructedForSpec = "assassination"
			ConstructResourceBar(specCache.assassination.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.outlaw.talents:GetTalents()
		FillSpellData_Outlaw()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.outlaw)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Outlaw
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.outlaw.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#adrenalineRush"] = spells.adrenalineRush.icon
		lookup["#betweenTheEyes"] = spells.betweenTheEyes.icon
		lookup["#bladeFlurry"] = spells.bladeFlurry.icon
		lookup["#bladeRush"] = spells.bladeRush.icon
		lookup["#broadside"] = spells.broadside.icon
		lookup["#buriedTreasure"] = spells.buriedTreasure.icon
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dispatch"] = spells.dispatch.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#grandMelee"] = spells.grandMelee.icon
		lookup["#opportunity"] = spells.opportunity.icon
		lookup["#pistolShot"] = spells.pistolShot.icon
		lookup["#rollTheBones"] = spells.rollTheBones.icon
		lookup["#ruthlessPrecision"] = spells.ruthlessPrecision.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		lookup["#sinisterStrike"] = spells.sinisterStrike.icon
		lookup["#skullAndCrossbones"] = spells.skullAndCrossbones.icon
		lookup["#trueBearing"] = spells.trueBearing.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "outlaw" then
			talents = specCache.outlaw.talents
			TRB.Data.barConstructedForSpec = "outlaw"
			ConstructResourceBar(specCache.outlaw.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.subtlety.talents:GetTalents()
		FillSpellData_Subtlety()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.subtlety)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Subtlety
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.subtlety.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#flagellation"] = spells.flagellation.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		lookup["#sod"] = spells.symbolsOfDeath.icon
		lookup["#symbolsOfDeath"] = spells.symbolsOfDeath.icon
		lookup["#shadowTechniques"] = spells.shadowTechniques.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "subtlety" then
			talents = specCache.subtlety.talents
			TRB.Data.barConstructedForSpec = "subtlety"
			ConstructResourceBar(specCache.subtlety.settings)
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
	
	if TRB.Data.character.classId == 4 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Rogue.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.assassination == nil or
						TwintopInsanityBarSettings.rogue.assassination.displayText == nil then
						settings.rogue.assassination.displayText.barText = TRB.Options.Rogue.AssassinationLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.outlaw == nil or
						TwintopInsanityBarSettings.rogue.outlaw.displayText == nil then
						settings.rogue.outlaw.displayText.barText = TRB.Options.Rogue.OutlawLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.subtlety == nil or
						TwintopInsanityBarSettings.rogue.subtlety.displayText == nil then
						settings.rogue.subtlety.displayText.barText = TRB.Options.Rogue.SubtletyLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.rogue ~= true then
						TRB.Data.settings.rogue.assassination.displayText.barText = TRB.Options.Rogue.AssassinationLoadDefaultBarTextSettings()
						TRB.Data.settings.rogue.outlaw.displayText.barText = TRB.Options.Rogue.OutlawLoadDefaultBarTextSettings()
						TRB.Data.settings.rogue.subtlety.displayText.barText = TRB.Options.Rogue.SubtletyLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.rogue = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Rogue"])
					end
				else
					local settings = TRB.Options.Rogue.LoadDefaultSettings(true)
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
						TRB.Data.settings.rogue.assassination = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["RogueAssassinationFull"], TRB.Data.settings.rogue.assassination)
						TRB.Data.settings.rogue.outlaw = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["RogueOutlawFull"], TRB.Data.settings.rogue.outlaw)
						TRB.Data.settings.rogue.subtlety = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["RogueSubtletyFull"], TRB.Data.settings.rogue.subtlety)
						
						FillSpellData_Assassination()
						FillSpellData_Outlaw()
						FillSpellData_Subtlety()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Rogue.ConstructOptionsPanel(specCache)

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
				SwitchSpec()
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
	TRB.Data.character.className = "rogue"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)
	local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
	local sharedSettings = nil
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "assassination"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "outlaw"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "subtlety"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end
	
	if sharedSettings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if barGroups and barGroups.primary then
				TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
			end
			-- Rebuild secondary bar layout when combo point count changes
			if barGroups and barGroups.secondary then
				-- Clear cached node count so ApplyBarGroupsLayout uses the new maxResource2
				barGroups.secondary.lastRebuildNodeCount = nil
				
				barGroups.secondary:SetMaxNodes(maxComboPoints)
				barGroups.secondary:SetNodeCount(maxComboPoints)
				barGroups.secondary:SetLayout(sharedSettings.comboPoints.spacing, sharedSettings.comboPoints.fullWidth, "HORIZONTAL")
				
				-- Get effective width (may be CDM-matched) from barGroups or fall back to settings
				local effectiveWidth = (barGroups and barGroups.effectiveWidth) or sharedSettings.bar.width
				
				barGroups.secondary:ApplyLayout(
					effectiveWidth,
					sharedSettings.comboPoints.width,
					sharedSettings.comboPoints.height,
					sharedSettings.comboPoints.border
				)
				-- Apply textures and colors to any newly created nodes
				local frameLevels = TRB.Data.constants.frameLevels
				for i = 1, maxComboPoints do
					local node = barGroups.secondary:GetNode(i)
					if node then
						node:SetTextures(
							sharedSettings.textures.comboPointsBar,
							sharedSettings.textures.comboPointsBorder,
							sharedSettings.textures.comboPointsBackground
						)
						node:SetMinMax(0, 1)
						node:SetBorderColor(sharedSettings.colors.comboPoints.border)
						node:SetBackgroundColorFromString(sharedSettings.colors.comboPoints.background)
						node:SetColor(sharedSettings.colors.comboPoints.base)
						node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
					end
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.rogue.outlaw == true then
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.rogue.subtlety == true then
		TRB.Data.specSupported = true
	else
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then		
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ComboPoints
		TRB.Data.resource2Factor = 1
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
			-- All Rogue specs use the secondary (Combo Points) bar
			local showSecondary = false
			if not forceHideAll then
				if sharedSettings.displayBar.secondary == "always" then
					showSecondary = true
				elseif sharedSettings.displayBar.secondary == "combat" then
					showSecondary = affectingCombat or inVehicle
				end
				-- "never" means showSecondary stays false
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
					barGroups.secondary:SetMaxNodes(TRB.Data.character.maxResource2)
					barGroups.secondary:Show()
					barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
				else
					barGroups.secondary:Hide()
				end
			end

			-- Determine health bar visibility independently
			local showHealth = false
			if not forceHideAll and sharedSettings.displayBar.health ~= nil then
				if sharedSettings.displayBar.health == "always" then
					showHealth = true
				elseif sharedSettings.displayBar.health == "combat" then
					showHealth = affectingCombat or inVehicle
				end
				-- "never" means showHealth stays false
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
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.rogue.assassination
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.rogue.outlaw
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.rogue.subtlety
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Assassination
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
		--[[
		-- Other abilities
		if var == "$blindsideTime" then
			if snapshots[spells.blindside.id].buff.isActive then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 2 then --Outlaw
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
		-- Roll the Bones buff counts
		--[[if var == "$rtbCount" or var == "$rollTheBonesCount" then
			if snapshots[spells.rollTheBones.id].attributes.count > 0 then
				valid = true
			end
		elseif var == "$rtbTemporaryCount" or var == "$rollTheBonesTemporaryCount" then
			if snapshots[spells.rollTheBones.id].attributes.temporaryCount > 0 then
				valid = true
			end
		elseif var == "$rtbAllCount" or var == "$rollTheBonesAllCount" then
			if snapshots[spells.rollTheBones.id].attributes.count > 0 or snapshots[spells.rollTheBones.id].attributes.temporaryCount > 0 then
				valid = true
			end
		elseif var == "$rtbBuffTime" or var == "$rollTheBonesBuffTime" then
			if snapshots[spells.rollTheBones.id].buff.isActive then
				valid = true
			end
		-- Roll the Bones Buffs
		elseif var == "$broadsideTime" then
			if snapshots[spells.broadside.id].buff.isActive then
				valid = true
			end
		elseif var == "$buriedTreasureTime" then
			if snapshots[spells.buriedTreasure.id].buff.isActive then
				valid = true
			end
		elseif var == "$grandMeleeTime" then
			if snapshots[spells.grandMelee.id].buff.isActive then
				valid = true
			end
		elseif var == "$ruthlessPrecisionTime" then
			if snapshots[spells.ruthlessPrecision.id].buff.isActive then
				valid = true
			end
		elseif var == "$skullAndCrossbonesTime" then
			if snapshots[spells.skullAndCrossbones.id].buff.isActive then
				valid = true
			end
		elseif var == "$trueBearingTime" then
			if snapshots[spells.trueBearing.id].buff.isActive then
				valid = true
			end
		-- Other abilities
		elseif var == "$opportunityTime" then
			if snapshots[spells.opportunity.id].buff.isActive then
				valid = true
			end
		elseif var == "$rtbGoodBuff" or var == "$rollTheBonesGoodBuff" then
			if snapshots[spells.rollTheBones.id].attributes.goodBuffs == true then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 3 then --Subtlety
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
		--[[if var == "$shadowTechniquesCount" then
			if snapshots[spells.shadowTechniques.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$flagellationTime" then
			if snapshots[spells.flagellation.id].buff.isActive then
				valid = true
			end
		elseif var == "$sodTime" or var == "$symbolsOfDeathTime" then
			if snapshots[spells.symbolsOfDeath.id].buff.isActive then
				valid = true
			end
		end]]
	end

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.RogueBaseSpells]]
	if var == "$resource" or var == "$energy" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$energyMax" then
		valid = true	
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$comboPoints" then
		valid = true
	elseif var == "$comboPointsMax" then
		valid = true
	elseif var == "$inStealth" then
		if IsStealthed() then
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
		-- Handle secondary resources (ComboPoint1, ComboPoint2, etc.)
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local secondaryNode = barGroups.secondary:GetNode(index)
				if secondaryNode then
					local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
					return secondaryNode:GetResourceFrame(), true, isVisible
				end
			end
		-- Handle health bar
		elseif relativeToFrame == "HealthBar" or relativeToFrame == "Health" then
			if barGroups and barGroups.health then
				local healthNode = barGroups.health:GetNode(1)
				if healthNode then
					local isVisible = barGroups.health.isVisible and healthNode.isVisible
					return healthNode:GetResourceFrame(), true, isVisible
				end
			end
		end
		return nil, true, false
	end
	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end