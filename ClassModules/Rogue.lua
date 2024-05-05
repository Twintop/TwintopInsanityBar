local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 4 then --Only do this if we're on a Rogue!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resource2Frame = TRB.Frames.resource2Frame
local resourceFrame = TRB.Frames.resourceFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame
local timerFrame = TRB.Frames.timerFrame
local combatFrame = TRB.Frames.combatFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}
TRB.Data.character = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	assassination = TRB.Classes.SpecCache:New(),
	outlaw = TRB.Classes.SpecCache:New(),
	subtlety = TRB.Classes.SpecCache:New()
}

local function FillSpecializationCache()
	-- Assassination
	specCache.assassination.Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
		},
		isPvp = false
	}

	specCache.assassination.character = {
		guid = UnitGUID("player"),
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
		overcapCue = false
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
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand,
	{
		enabled = {
			[1] = false,
			[2] = false,
			[3] = false,
			[4] = false,
			[5] = false,
			[6] = false,
			[7] = false,
		}
	})
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand_2CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_2CP)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand_3CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_3CP)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand_4CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_4CP)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand_4CP2.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_4CP2)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.echoingReprimand_5CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_5CP)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.serratedBoneSpike.id] = TRB.Classes.Snapshot:New(spells.serratedBoneSpike)
	---@type TRB.Classes.Snapshot
	specCache.assassination.snapshotData.snapshots[spells.sepsis.id] = TRB.Classes.Snapshot:New(spells.sepsis)
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
	specCache.assassination.snapshotData.snapshots[spells.shadowDance.id] = TRB.Classes.Snapshot:New(spells.shadowDance)

	specCache.assassination.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Outlaw
	specCache.outlaw.Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
		},
		isPvp = false
	}

	specCache.outlaw.character = {
		guid = UnitGUID("player"),
		specId = 1,
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
		overcapCue = false
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
	specCache.outlaw.snapshotData.snapshots[spells.ghostlyStrike.id] = TRB.Classes.Snapshot:New(spells.ghostlyStrike)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.dreadblades.id] = TRB.Classes.Snapshot:New(spells.dreadblades)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.opportunity.id] = TRB.Classes.Snapshot:New(spells.opportunity)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.shadowDance.id] = TRB.Classes.Snapshot:New(spells.shadowDance)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand,
	{
		enabled = {
			[1] = false,
			[2] = false,
			[3] = false,
			[4] = false,
			[5] = false,
			[6] = false,
			[7] = false,
		}
	})
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand_2CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_2CP)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand_3CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_3CP)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand_4CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_4CP)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand_4CP2.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_4CP2)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.echoingReprimand_5CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_5CP)
	---@type TRB.Classes.Snapshot
	specCache.outlaw.snapshotData.snapshots[spells.sepsis.id] = TRB.Classes.Snapshot:New(spells.sepsis)
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

	specCache.outlaw.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Subtlety
	specCache.subtlety.Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
		},
		isPvp = false
	}

	specCache.subtlety.character = {
		guid = UnitGUID("player"),
		specId = 1,
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
		overcapCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand,
	{
		enabled = {
			[1] = false,
			[2] = false,
			[3] = false,
			[4] = false,
			[5] = false,
			[6] = false,
			[7] = false,
		}
	})
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand_2CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_2CP)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand_3CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_3CP)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand_4CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_4CP)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand_4CP2.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_4CP2)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.echoingReprimand_5CP.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand_5CP)
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
	specCache.subtlety.snapshotData.snapshots[spells.symbolsOfDeath.id] = TRB.Classes.Snapshot:New(spells.symbolsOfDeath, nil, false, true)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.goremawsBite.id] = TRB.Classes.Snapshot:New(spells.goremawsBite)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.secretTechnique.id] = TRB.Classes.Snapshot:New(spells.secretTechnique)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.sepsis.id] = TRB.Classes.Snapshot:New(spells.sepsis)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowBlades.id] = TRB.Classes.Snapshot:New(spells.shadowBlades)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shurikenTornado.id] = TRB.Classes.Snapshot:New(spells.shurikenTornado)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowyDuel.id] = TRB.Classes.Snapshot:New(spells.shadowyDuel)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowDance.id] = TRB.Classes.Snapshot:New(spells.shadowDance)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shotInTheDark.id] = TRB.Classes.Snapshot:New(spells.shotInTheDark, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.shadowTechniques.id] = TRB.Classes.Snapshot:New(spells.shadowTechniques, nil, true, true)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.flagellation.id] = TRB.Classes.Snapshot:New(spells.flagellation)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.silentStorm.id] = TRB.Classes.Snapshot:New(spells.silentStorm, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.finalityBlackPowder.id] = TRB.Classes.Snapshot:New(spells.finalityBlackPowder, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.finalityEviscerate.id] = TRB.Classes.Snapshot:New(spells.finalityEviscerate, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.subtlety.snapshotData.snapshots[spells.finalityRupture.id] = TRB.Classes.Snapshot:New(spells.finalityRupture, nil, true)

	specCache.subtlety.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Assassination()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "rogue", "assassination")
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

		{ variable = "#atrophicPoison", icon = spells.atrophicPoison.icon, description = spells.atrophicPoison.name, printInSettings = true },
		{ variable = "#amplifyingPoison", icon = spells.amplifyingPoison.icon, description = spells.amplifyingPoison.name, printInSettings = true },
		{ variable = "#blindside", icon = spells.blindside.icon, description = spells.blindside.name, printInSettings = true },
		{ variable = "#crimsonTempest", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = true },
		{ variable = "#ct", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = false },
		{ variable = "#cripplingPoison", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = true },
		{ variable = "#cp", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = false },
		{ variable = "#deadlyPoison", icon = spells.deadlyPoison.icon, description = spells.deadlyPoison.name, printInSettings = true },
		{ variable = "#dp", icon = spells.deadlyPoison.icon, description = spells.deadlyPoison.name, printInSettings = false },
		{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#echoingReprimand", icon = spells.echoingReprimand.icon, description = spells.echoingReprimand.name, printInSettings = true },
		{ variable = "#garrote", icon = spells.garrote.icon, description = spells.garrote.name, printInSettings = true },
		{ variable = "#internalBleeding", icon = spells.internalBleeding.icon, description = spells.internalBleeding.name, printInSettings = true },
		{ variable = "#ib", icon = spells.internalBleeding.icon, description = spells.internalBleeding.name, printInSettings = false },
		{ variable = "#numbingPoison", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = true },
		{ variable = "#np", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = false },
		{ variable = "#rupture", icon = spells.rupture.icon, description = spells.rupture.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#sepsis", icon = spells.sepsis.icon, description = spells.sepsis.name, printInSettings = true },
		{ variable = "#serratedBoneSpike", icon = spells.serratedBoneSpike.icon, description = spells.serratedBoneSpike.name, printInSettings = true },
		{ variable = "#stealth", icon = spells.stealth.icon, description = spells.stealth.name, printInSettings = true },
		{ variable = "#woundPoison", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = true },
		{ variable = "#wp", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = false },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueAssassinationBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["RogueAssassinationBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		{ variable = "$passive", description = L["RogueAssassinationBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["RogueAssassinationBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$regenEnergy", description = "", printInSettings = false, color = false },
		{ variable = "$energyRegen", description = "", printInSettings = false, color = false },
		{ variable = "$resourceRegen", description = "", printInSettings = false, color = false },
		{ variable = "$regenResource", description = "", printInSettings = false, color = false },
		{ variable = "$energyPlusPassive", description = L["RogueAssassinationBarTextVariable_energyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$energyTotal", description = L["RogueAssassinationBarTextVariable_energyTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueAssassinationBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueAssassinationBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

		{ variable = "$sadTime", description = L["RogueAssassinationBarTextVariable_sadTime"], printInSettings = true, color = false },
		{ variable = "$sliceAndDiceTime", description = "", printInSettings = false, color = false },

		-- Bleeds
		{ variable = "$isBleeding", description = L["RogueAssassinationBarTextVariable_isBleeding"], printInSettings = true, color = false },
		{ variable = "$ctCount", description = L["RogueAssassinationBarTextVariable_ctCount"], printInSettings = true, color = false },
		{ variable = "$crimsonTempestCount", description = "", printInSettings = false, color = false },
		{ variable = "$ctTime", description = L["RogueAssassinationBarTextVariable_ctTime"], printInSettings = true, color = false },
		{ variable = "$crimsonTempestTime", description = "", printInSettings = false, color = false },

		{ variable = "$garroteCount", description = L["RogueAssassinationBarTextVariable_garroteCount"], printInSettings = true, color = false },
		{ variable = "$garroteTime", description = L["RogueAssassinationBarTextVariable_garroteTime"], printInSettings = true, color = false },

		{ variable = "$ibCount", description = L["RogueAssassinationBarTextVariable_ibCount"], printInSettings = true, color = false },
		{ variable = "$internalBleedingCount", description = "", printInSettings = false, color = false },
		{ variable = "$ibTime", description = L["RogueAssassinationBarTextVariable_ibTime"], printInSettings = true, color = false },
		{ variable = "$internalBleedingTime", description = "", printInSettings = false, color = false },

		{ variable = "$ruptureCount", description = L["RogueAssassinationBarTextVariable_ruptureCount"], printInSettings = true, color = false },
		{ variable = "$ruptureTime", description = L["RogueAssassinationBarTextVariable_ruptureTime"], printInSettings = true, color = false },
	
		{ variable = "$sbsCount", description = L["RogueAssassinationBarTextVariable_sbsCount"], printInSettings = true, color = false },
		{ variable = "$serratedBoneSpikeCount", description = "", printInSettings = false, color = false },

		-- Poisons
		
		{ variable = "$amplifyingPoisonCount", description = L["RogueAssassinationBarTextVariable_amplifyingPoisonCount"], printInSettings = true, color = false },
		{ variable = "$amplifyingPoisonTime", description = L["RogueAssassinationBarTextVariable_amplifyingPoisonTime"], printInSettings = true, color = false },

		{ variable = "$atrophicPoisonCount", description = L["RogueAssassinationBarTextVariable_atrophicPoisonCount"], printInSettings = true, color = false },
		{ variable = "$atrophicPoisonTime", description = L["RogueAssassinationBarTextVariable_atrophicPoisonTime"], printInSettings = true, color = false },

		{ variable = "$cpCount", description = L["RogueAssassinationBarTextVariable_cpCount"], printInSettings = true, color = false },
		{ variable = "$cripplingPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$cpTime", description = L["RogueAssassinationBarTextVariable_cpTime"], printInSettings = true, color = false },
		{ variable = "$cripplingPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$dpCount", description = L["RogueAssassinationBarTextVariable_dpCount"], printInSettings = true, color = false },
		{ variable = "$deadlyPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$dpTime", description = L["RogueAssassinationBarTextVariable_dpTime"], printInSettings = true, color = false },
		{ variable = "$deadlyPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$npCount", description = L["RogueAssassinationBarTextVariable_npCount"], printInSettings = true, color = false },
		{ variable = "$numbingPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$npTime", description = L["RogueAssassinationBarTextVariable_npTime"], printInSettings = true, color = false },
		{ variable = "$numbingPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$wpCount", description = L["RogueAssassinationBarTextVariable_wpCount"], printInSettings = true, color = false },
		{ variable = "$woundPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$wpTime", description = L["RogueAssassinationBarTextVariable_wpTime"], printInSettings = true, color = false },
		{ variable = "$woundPoisonTime", description = "", printInSettings = false, color = false },

		-- Proc
		{ variable = "$blindsideTime", description = L["RogueAssassinationBarTextVariable_blindsideTime"], printInSettings = true, color = false },


		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function Setup_Outlaw()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "rogue", "outlaw")
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
		{ variable = "#dreadblades", icon = spells.dreadblades.icon, description = spells.dreadblades.name, printInSettings = true },
		{ variable = "#cripplingPoison", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = true },
		{ variable = "#cp", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = false },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#echoingReprimand", icon = spells.echoingReprimand.icon, description = spells.echoingReprimand.name, printInSettings = true },
		{ variable = "#ghostlyStrike", icon = spells.ghostlyStrike.icon, description = spells.ghostlyStrike.name, printInSettings = true },
		{ variable = "#grandMelee", icon = spells.grandMelee.icon, description = spells.grandMelee.name, printInSettings = true },
		{ variable = "#numbingPoison", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = true },
		{ variable = "#np", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = false },
		{ variable = "#opportunity", icon = spells.opportunity.icon, description = spells.opportunity.name, printInSettings = true },
		{ variable = "#pistolShot", icon = spells.pistolShot.icon, description = spells.pistolShot.name, printInSettings = true },
		{ variable = "#rollTheBones", icon = spells.rollTheBones.icon, description = spells.rollTheBones.name, printInSettings = true },
		{ variable = "#ruthlessPrecision", icon = spells.ruthlessPrecision.icon, description = spells.ruthlessPrecision.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#sepsis", icon = spells.sepsis.icon, description = spells.sepsis.name, printInSettings = true },
		{ variable = "#sinisterStrike", icon = spells.sinisterStrike.icon, description = spells.sinisterStrike.name, printInSettings = true },
		{ variable = "#skullAndCrossbones", icon = spells.skullAndCrossbones.icon, description = spells.skullAndCrossbones.name, printInSettings = true },
		{ variable = "#stealth", icon = spells.stealth.icon, description = spells.stealth.name, printInSettings = true },
		{ variable = "#trueBearing", icon = spells.trueBearing.icon, description = spells.trueBearing.name, printInSettings = true },
		{ variable = "#woundPoison", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = true },
		{ variable = "#wp", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = false },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueOutlawBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["RogueOutlawBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		{ variable = "$passive", description = L["RogueOutlawBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["RogueOutlawBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$regenEnergy", description = "", printInSettings = false, color = false },
		{ variable = "$energyRegen", description = "", printInSettings = false, color = false },
		{ variable = "$resourceRegen", description = "", printInSettings = false, color = false },
		{ variable = "$regenResource", description = "", printInSettings = false, color = false },
		{ variable = "$energyPlusPassive", description = L["RogueOutlawBarTextVariable_energyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$energyTotal", description = L["RogueOutlawBarTextVariable_energyTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueOutlawBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueOutlawBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

		{ variable = "$rtbCount", description = L["RogueOutlawBarTextVariable_rtbCount"], printInSettings = true, color = false },
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

		{ variable = "$sadTime", description = L["RogueOutlawBarTextVariable_sadTime"], printInSettings = true, color = false },
		{ variable = "$sliceAndDiceTime", description = "", printInSettings = false, color = false },

		-- Proc
		{ variable = "$opportunityTime", description = L["RogueOutlawBarTextVariable_opportunityTime"], printInSettings = true, color = false },

		-- Poisons
		{ variable = "$atrophicPoisonCount", description = L["RogueOutlawBarTextVariable_atrophicPoisonCount"], printInSettings = true, color = false },
		{ variable = "$atrophicPoisonTime", description = L["RogueOutlawBarTextVariable_atrophicPoisonTime"], printInSettings = true, color = false },

		{ variable = "$cpCount", description = L["RogueOutlawBarTextVariable_cpCount"], printInSettings = true, color = false },
		{ variable = "$cripplingPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$cpTime", description = L["RogueOutlawBarTextVariable_cpTime"], printInSettings = true, color = false },
		{ variable = "$cripplingPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$npCount", description = L["RogueOutlawBarTextVariable_npCount"], printInSettings = true, color = false },
		{ variable = "$numbingPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$npTime", description = L["RogueOutlawBarTextVariable_npTime"], printInSettings = true, color = false },
		{ variable = "$numbingPoisonTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$wpCount", description = L["RogueOutlawBarTextVariable_wpCount"], printInSettings = true, color = false },
		{ variable = "$woundPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$wpTime", description = L["RogueOutlawBarTextVariable_wpTime"], printInSettings = true, color = false },
		{ variable = "$woundPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function Setup_Subtlety()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "rogue", "subtlety")
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
		{ variable = "#cripplingPoison", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = true },
		{ variable = "#cp", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = false },
		{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
		{ variable = "#echoingReprimand", icon = spells.echoingReprimand.icon, description = spells.echoingReprimand.name, printInSettings = true },
		{ variable = "#flagellation", icon = spells.flagellation.icon, description = spells.flagellation.name, printInSettings = true },
		{ variable = "#numbingPoison", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = true },
		{ variable = "#np", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = false },
		{ variable = "#rupture", icon = spells.rupture.icon, description = spells.rupture.name, printInSettings = true },
		{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
		{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
		{ variable = "#sepsis", icon = spells.sepsis.icon, description = spells.sepsis.name, printInSettings = true },
		{ variable = "#shadowTechniques", icon = spells.shadowTechniques.icon, description = spells.shadowTechniques.name, printInSettings = true },
		{ variable = "#stealth", icon = spells.stealth.icon, description = spells.stealth.name, printInSettings = true },
		{ variable = "#sod", icon = spells.symbolsOfDeath.icon, description = spells.symbolsOfDeath.name, printInSettings = true },
		{ variable = "#symbolsOfDeath", icon = spells.symbolsOfDeath.icon, description = spells.symbolsOfDeath.name, printInSettings = false },
		{ variable = "#woundPoison", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = true },
		{ variable = "#wp", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = false },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },


		{ variable = "$energy", description = L["RogueSubtletyBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["RogueSubtletyBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = "", printInSettings = false, color = false },
		{ variable = "$passive", description = L["RogueSubtletyBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["RogueSubtletyBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$regenEnergy", description = "", printInSettings = false, color = false },
		{ variable = "$energyRegen", description = "", printInSettings = false, color = false },
		{ variable = "$regenResource", description = "", printInSettings = false, color = false },
		{ variable = "$resourceRegen", description = "", printInSettings = false, color = false },
		{ variable = "$energyPlusPassive", description = L["RogueSubtletyBarTextVariable_energyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$energyTotal", description = L["RogueSubtletyBarTextVariable_energyTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = L["RogueSubtletyBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["RogueSubtletyBarTextVariable_comboPointsMax"], printInSettings = true, color = false },
		{ variable = "$shadowTechniquesCount", description = L["RogueSubtletyBarTextVariable_shadowTechniquesCount"], printInSettings = true, color = false },

		{ variable = "$sodTime", description = L["RogueSubtletyBarTextVariable_sodTime"], printInSettings = true, color = false },
		{ variable = "$symbolsOfDeathTime", description = "", printInSettings = false, color = false },

		{ variable = "$flagellationTime", description = L["RogueSubtletyBarTextVariable_flagellationTime"], printInSettings = true, color = false },

		{ variable = "$sadTime", description = L["RogueSubtletyBarTextVariable_sadTime"], printInSettings = true, color = false },
		{ variable = "$sliceAndDiceTime", description = "", printInSettings = false, color = false },

		-- Bleeds
		{ variable = "$ruptureCount", description = L["RogueSubtletyBarTextVariable_ruptureCount"], printInSettings = true, color = false },
		{ variable = "$ruptureTime", description = L["RogueSubtletyBarTextVariable_ruptureTime"], printInSettings = true, color = false },

		-- Poisons
		{ variable = "$atrophicPoisonCount", description = L["RogueSubtletyTextVariable_atrophicPoisonCount"], printInSettings = true, color = false },
		{ variable = "$atrophicPoisonTime", description = L["RogueSubtletyTextVariable_atrophicPoisonTime"], printInSettings = true, color = false },

		{ variable = "$cpCount", description = L["RogueSubtletyBarTextVariable_cpCount"], printInSettings = true, color = false },
		{ variable = "$cripplingPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$cpTime", description = L["RogueSubtletyBarTextVariable_cpTime"], printInSettings = true, color = false },
		{ variable = "$cripplingPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$npCount", description = L["RogueSubtletyBarTextVariable_npCount"], printInSettings = true, color = false },
		{ variable = "$numbingPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$npTime", description = L["RogueSubtletyBarTextVariable_npTime"], printInSettings = true, color = false },
		{ variable = "$numbingPoisonTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$wpCount", description = L["RogueSubtletyBarTextVariable_wpCount"], printInSettings = true, color = false },
		{ variable = "$woundPoisonCount", description = "", printInSettings = false, color = false },
		{ variable = "$wpTime", description = L["RogueSubtletyBarTextVariable_wpTime"], printInSettings = true, color = false },
		{ variable = "$woundPoisonTime", description = "", printInSettings = false, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function IsTargetBleeding(guid)
	local specId = GetSpecialization()
	if specId == 1 then -- Assassination
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if guid == nil then
			guid = snapshotData.targetData.currentTargetGuid
		end
		
		local target = snapshotData.targetData.targets[guid] --[[@as TRB.Classes.Target]]

		if target == nil then
			return false
		end
	
		return target.spells[spells.garrote.id].active or target.spells[spells.rupture.id].active or target.spells[spells.internalBleeding.id].active or target.spells[spells.crimsonTempest.id].active
	end
	return false
end

local function UpdateCastingResourceFinal()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local specId = GetSpecialization()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	
	if specId == 1 then -- Assassination
		targetData:UpdateTrackedSpells(currentTime)
	elseif specId == 2 then -- Outlaw
		targetData:UpdateTrackedSpells(currentTime)
	elseif specId == 3 then -- Outlaw
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells|TRB.Classes.Rogue.OutlawSpells|TRB.Classes.Rogue.SubtletySpells]]

	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			resourceFrame.thresholds[x]:Hide()
		end
	end

	for _, v in pairs(TRB.Data.spellsData.spells) do
		local spell = v --[[@as TRB.Classes.SpellBase]]
		if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
			spell = spell --[[@as TRB.Classes.SpellThreshold]]
			if resourceFrame.thresholds[spell.thresholdId] == nil then
				resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, resourceFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLine(resourceFrame.thresholds[spell.thresholdId], settings, true)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[spell.thresholdId], spell, settings)

			resourceFrame.thresholds[spell.thresholdId]:Show()
			resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			resourceFrame.thresholds[spell.thresholdId]:Hide()
		end
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Frames.resource2ContainerFrame:Show()
	TRB.Functions.Bar:Construct(settings)
	TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
end

local function RefreshLookupData_Assassination()
	local specSettings = TRB.Data.settings.rogue.assassination
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()


	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentEnergyColor = specSettings.colors.text.current
	local castingEnergyColor = specSettings.colors.text.casting
	
	if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
		if specSettings.colors.text.overcapEnabled and overcap then
			currentEnergyColor = specSettings.colors.text.overcap
			castingEnergyColor = specSettings.colors.text.overcap
		elseif specSettings.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for _, v in pairs(spells) do
				local spell = v --[[@as TRB.Classes.SpellBase]]
				if spell ~= nil and spell.primaryResourceType ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = specSettings.colors.text.overThreshold
				castingEnergyColor = specSettings.colors.text.overThreshold
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = specSettings.colors.text.spending
	end

	--$energy
	local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, snapshotData.attributes.resource)
	--$casting
	local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshotData.casting.resourceFinal)
	--$passive
	local _regenEnergy = 0
	local _passiveEnergy
	local _passiveEnergyMinusRegen

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenEnergy = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenEnergy = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenEnergy
	local regenEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenEnergy)

	_passiveEnergy = _regenEnergy
	_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

	local passiveEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergy)
	local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergyMinusRegen)
	--$energyTotal
	local _energyTotal = math.min(_passiveEnergy + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
	--$energyPlusCasting
	local _energyPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
	--$energyPlusPassive
	local _energyPlusPassive = math.min(_passiveEnergy + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)


	-- Bleeds
	-- TODO: Somehow account for pandemic being variable
	--$ctCount and $ctTime
	local _ctCount = snapshotData.targetData.count[spells.crimsonTempest.id] or 0
	local ctCount = tostring(_ctCount)
	local _ctTime = 0
	local ctTime
	
	--$garroteCount and $garroteTime
	local _garroteCount = snapshotData.targetData.count[spells.garrote.id] or 0
	local garroteCount = tostring(_garroteCount)
	local _garroteTime = 0
	local garroteTime
	
	--$ibCount and $ibTime
	local _ibCount = snapshotData.targetData.count[spells.internalBleeding.id] or 0
	local ibCount = tostring(_ibCount)
	local _ibTime = 0
	local ibTime
	
	--$ruptureCount and $ruptureTime
	local _ruptureCount = snapshotData.targetData.count[spells.rupture.id] or 0
	local ruptureCount = tostring(_ruptureCount)
	local _ruptureTime = 0
	local ruptureTime
	
	-- Poisons
	--$cpCount and $cpTime
	local _cpCount = snapshotData.targetData.count[spells.cripplingPoison.id] or 0
	local cpCount = tostring(_cpCount)
	local _cpTime = 0
	local cpTime
			
	--$dpCount and $dpTime
	local _dpCount = snapshotData.targetData.count[spells.deadlyPoison.id] or 0
	local dpCount = tostring(_dpCount)
	local _dpTime = 0
	local dpTime
			
	--$amplifyingPoisonCount and $amplifyingPoisonTime
	local _amplifyingPoisonCount = snapshotData.targetData.count[spells.amplifyingPoison.id] or 0
	local amplifyingPoisonCount = tostring(_amplifyingPoisonCount)
	local _amplifyingPoisonTime = 0
	local amplifyingPoisonTime
			
	--$npCount and $npTime
	local _npCount = snapshotData.targetData.count[spells.numbingPoison.id] or 0
	local npCount = tostring(_npCount)
	local _npTime = 0
	local npTime
			
	--$atrophicPoisonCount and $atrophicPoisonTime
	local _atrophicPoisonCount = snapshotData.targetData.count[spells.atrophicPoison.id] or 0
	local atrophicPoisonCount = tostring(_atrophicPoisonCount)
	local _atrophicPoisonTime = 0
	local atrophicPoisonTime
			
	--$wpCount and $wpTime
	local _wpCount = snapshotData.targetData.count[spells.woundPoison.id] or 0
	local wpCount = tostring(_wpCount)
	local _wpTime = 0
	local wpTime
	
	--$sbsCount
	local _sbsCount = snapshotData.targetData.count[spells.serratedBoneSpike.debuffId] or 0
	local sbsCount = tostring(_sbsCount)
	local _sbsOnTarget = false


	if target ~= nil then
		_ctTime = target.spells[spells.crimsonTempest.id].remainingTime or 0
		_garroteTime = target.spells[spells.garrote.id].remainingTime or 0
		_ibTime = target.spells[spells.internalBleeding.id].remainingTime or 0
		_ruptureTime = target.spells[spells.rupture.id].remainingTime or 0
		_cpTime = target.spells[spells.cripplingPoison.id].remainingTime or 0
		_dpTime = target.spells[spells.deadlyPoison.id].remainingTime or 0
		_npTime = target.spells[spells.numbingPoison.id].remainingTime or 0
		_atrophicPoisonTime = target.spells[spells.atrophicPoison.id].remainingTime or 0
		_amplifyingPoisonTime = target.spells[spells.amplifyingPoison.id].remainingTime or 0
		_wpTime = target.spells[spells.woundPoison.id].remainingTime or 0
		_sbsOnTarget = target.spells[spells.serratedBoneSpike.debuffId].active or false
	end


	if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		-- Bleeds
		if _ctTime > spells.crimsonTempest.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
			ctCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ctCount)
			ctTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_ctTime))
		elseif _ctTime > 0 then
			ctCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _ctCount)
			ctTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_ctTime))
		else
			ctCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ctCount)
			ctTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _garroteTime > spells.garrote.pandemicTime then
			garroteCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _garroteCount)
			garroteTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_garroteTime))
		elseif _garroteTime > 0 then
			garroteCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _garroteCount)
			garroteTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_garroteTime))
		else
			garroteCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _garroteCount)
			garroteTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
					
		if _ibTime > 0 then
			ibCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ibCount)
			ibTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_ibTime))
		else
			ibCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ibCount)
			ibTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _ruptureTime > spells.rupture.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
			ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ruptureCount)
			ruptureTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_ruptureTime))
		elseif _ruptureTime > 0 then
			ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _ruptureCount)
			ruptureTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_ruptureTime))
		else
			ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ruptureCount)
			ruptureTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		--Poisons
		if _cpTime > 0 then
			cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _cpCount)
			cpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_cpTime))
		else
			cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _cpCount)
			cpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _dpTime > 0 then
			dpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _dpCount)
			dpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_dpTime))
		else
			dpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _dpCount)
			dpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _npTime > 0 then
			npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _npCount)
			npTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_npTime))
		else
			npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _npCount)
			npTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _wpTime > 0 then
			wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _wpCount)
			wpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_wpTime))
		else
			wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _wpCount)
			wpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _atrophicPoisonTime > 0 then
			atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _atrophicPoisonCount)
			atrophicPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_atrophicPoisonTime))
		else
			atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _atrophicPoisonCount)
			atrophicPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _amplifyingPoisonTime > 0 then
			amplifyingPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _amplifyingPoisonCount)
			amplifyingPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_amplifyingPoisonTime))
		else
			amplifyingPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _amplifyingPoisonCount)
			amplifyingPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _sbsOnTarget == false and talents:IsTalentActive(spells.serratedBoneSpike) then
			sbsCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _sbsCount)
		else
			sbsCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _sbsCount)
		end
	else
		-- Bleeds
		ctTime = TRB.Functions.BarText:TimerPrecision(_ctTime)
		garroteTime = TRB.Functions.BarText:TimerPrecision(_garroteTime)
		ibTime = TRB.Functions.BarText:TimerPrecision(_ibTime)
		ruptureTime = TRB.Functions.BarText:TimerPrecision(_ruptureTime)

		-- Poisons
		amplifyingPoisonTime = TRB.Functions.BarText:TimerPrecision(_amplifyingPoisonTime)
		atrophicPoisonTime = TRB.Functions.BarText:TimerPrecision(_atrophicPoisonTime)
		cpTime = TRB.Functions.BarText:TimerPrecision(_cpTime)
		dpTime = TRB.Functions.BarText:TimerPrecision(_dpTime)
		npTime = TRB.Functions.BarText:TimerPrecision(_npTime)
		wpTime = TRB.Functions.BarText:TimerPrecision(_wpTime)
	end
	

	--$sadTime
	local _sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
	local sadTime
	
	if _sadTime > spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_sadTime))
	elseif _sadTime > 0 then
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_sadTime))
	else
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
	end

	
	--$blindsideTime
	local _blindsideTime = snapshots[spells.blindside.id].buff:GetRemainingTime(currentTime)
	local blindsideTime = TRB.Functions.BarText:TimerPrecision(_blindsideTime)

	----------------------------

	Global_TwintopResourceBar.resource.passive = _passiveEnergy
	Global_TwintopResourceBar.resource.regen = _regenEnergy
	Global_TwintopResourceBar.dots = {
		amplifyingPoisonCount = _amplifyingPoisonCount,
		atrophicPoisonCount = _atrophicPoisonCount,
		cripplingPoisonCount = _cpCount,
		deadlyPoisonCount = _dpCount,
		numbingPoisonCount = _npCount,
		woundPoisonCount = _wpCount,
		crimsonTempestCount = _ctCount,
		garroteCount = _garroteCount,
		internalBleedingCount = _ibCount,
		ruptureCount = _ruptureCount,
		serratedBoneSpikeCount = _sbsCount
	}

	local lookup = TRB.Data.lookup or {}
	lookup["#amplifyingPoison"] = spells.amplifyingPoison.icon
	lookup["#atrophicPoison"] = spells.atrophicPoison.icon
	lookup["#blindside"] = spells.blindside.icon
	lookup["#crimsonTempest"] = spells.crimsonTempest.icon
	lookup["#ct"] = spells.crimsonTempest.icon
	lookup["#cripplingPoison"] = spells.cripplingPoison.icon
	lookup["#cp"] = spells.cripplingPoison.icon
	lookup["#deadlyPoison"] = spells.deadlyPoison.icon
	lookup["#dp"] = spells.deadlyPoison.icon
	lookup["#deathFromAbove"] = spells.deathFromAbove.icon
	lookup["#dismantle"] = spells.dismantle.icon
	lookup["#echoingReprimand"] = spells.echoingReprimand.icon
	lookup["#garrote"] = spells.garrote.icon
	lookup["#internalBleeding"] = spells.internalBleeding.icon
	lookup["#ib"] = spells.internalBleeding.icon
	lookup["#numbingPoison"] = spells.numbingPoison.icon
	lookup["#np"] = spells.numbingPoison.icon
	lookup["#rupture"] = spells.rupture.icon
	lookup["#sad"] = spells.sliceAndDice.icon
	lookup["#sliceAndDice"] = spells.sliceAndDice.icon
	lookup["#sepsis"] = spells.sepsis.icon
	lookup["#serratedBoneSpike"] = spells.serratedBoneSpike.icon
	lookup["#stealth"] = spells.stealth.icon
	lookup["#woundPoison"] = spells.woundPoison.icon
	lookup["#wp"] = spells.woundPoison.icon

	lookup["$energyTotal"] = energyTotal
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$resourcePlusCasting"] = energyPlusCasting
	lookup["$energyPlusCasting"] = energyPlusCasting
	lookup["$resourcePlusPassive"] = energyPlusPassive
	lookup["$energyPlusPassive"] = energyPlusPassive
	lookup["$resourceTotal"] = energyTotal
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$amplifyingPoisonCount"] = amplifyingPoisonCount
	lookup["$amplifyingPoisonTime"] = amplifyingPoisonTime
	lookup["$atrophicPoisonCount"] = atrophicPoisonCount
	lookup["$atrophicPoisonTime"] = atrophicPoisonTime
	lookup["$cpCount"] = cpCount
	lookup["$cripplingPoisonCount"] = cpCount
	lookup["$cpTime"] = cpTime
	lookup["$cripplingPoisonTime"] = cpTime
	lookup["$dpCount"] = dpCount
	lookup["$deadlyPoisonCount"] = dpCount
	lookup["$dpTime"] = dpTime
	lookup["$deadlyPoisonTime"] = dpTime
	lookup["$npCount"] = npCount
	lookup["$numbingPoisonCount"] = npCount
	lookup["$npTime"] = npTime
	lookup["$numbingPoisonTime"] = npTime
	lookup["$wpCount"] = wpCount
	lookup["$woundPoisonCount"] = wpCount
	lookup["$wpTime"] = wpTime
	lookup["$woundPoisonTime"] = wpTime
	lookup["$ctCount"] = ctCount
	lookup["$crimsonTempestCount"] = ctCount
	lookup["$ctTime"] = ctTime
	lookup["$crimsonTempestTime"] = ctTime
	lookup["$garroteCount"] = garroteCount
	lookup["$garroteTime"] = garroteTime
	lookup["$ibCount"] = ibCount
	lookup["$internalBleedingCount"] = ibCount
	lookup["$ibTime"] = ibTime
	lookup["$internalBleedingTime"] = ibTime
	lookup["$ruptureCount"] = ruptureCount
	lookup["$ruptureTime"] = ruptureTime
	lookup["$sbsCount"] = sbsCount
	lookup["$serratedBoneSpikeCount"] = sbsCount
	lookup["$sadTime"] = sadTime
	lookup["$sliceAndDiceTime"] = sadTime
	lookup["$blindsideTime"] = blindsideTime
	lookup["$isBleeding"] = ""
	lookup["$inStealth"] = ""

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookup["$passive"] = passiveEnergyMinusRegen
	else
		lookup["$passive"] = passiveEnergy
	end

	lookup["$regen"] = regenEnergy
	lookup["$regenEnergy"] = regenEnergy
	lookup["$regenResource"] = regenEnergy
	lookup["$resourceRegen"] = regenEnergy
	lookup["$energyRegen"] = regenEnergy
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$energyOvercap"] = overcap
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$energyTotal"] = _energyTotal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
	lookupLogic["$energyPlusCasting"] = _energyPlusCasting
	lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
	lookupLogic["$energyPlusPassive"] = _energyPlusPassive
	lookupLogic["$resourceTotal"] = _energyTotal
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$amplifyingPoisonCount"] = amplifyingPoisonCount
	lookupLogic["$amplifyingPoisonTime"] = amplifyingPoisonTime
	lookupLogic["$atrophicPoisonCount"] = atrophicPoisonCount
	lookupLogic["$atrophicPoisonTime"] = atrophicPoisonTime
	lookupLogic["$cpCount"] = _cpCount
	lookupLogic["$cripplingPoisonCount"] = _cpCount
	lookupLogic["$cpTime"] = _cpTime
	lookupLogic["$cripplingPoisonTime"] = _cpTime
	lookupLogic["$dpCount"] = _dpCount
	lookupLogic["$deadlyPoisonCount"] = _dpCount
	lookupLogic["$dpTime"] = _dpTime
	lookupLogic["$deadlyPoisonTime"] = _dpTime
	lookupLogic["$npCount"] = _npCount
	lookupLogic["$numbingPoisonCount"] = _npCount
	lookupLogic["$npTime"] = _npTime
	lookupLogic["$numbingPoisonTime"] = _npTime
	lookupLogic["$wpCount"] = _wpCount
	lookupLogic["$woundPoisonCount"] = _wpCount
	lookupLogic["$wpTime"] = _wpTime
	lookupLogic["$woundPoisonTime"] = _wpTime
	lookupLogic["$ctCount"] = _ctCount
	lookupLogic["$crimsonTempestCount"] = _ctCount
	lookupLogic["$ctTime"] = _ctTime
	lookupLogic["$crimsonTempestTime"] = _ctTime
	lookupLogic["$garroteCount"] = _garroteCount
	lookupLogic["$garroteTime"] = _garroteTime
	lookupLogic["$ibCount"] = _ibCount
	lookupLogic["$internalBleedingCount"] = _ibCount
	lookupLogic["$ibTime"] = _ibTime
	lookupLogic["$internalBleedingTime"] = _ibTime
	lookupLogic["$ruptureCount"] = _ruptureCount
	lookupLogic["$ruptureTime"] = _ruptureTime
	lookupLogic["$sbsCount"] = _sbsCount
	lookupLogic["$serratedBoneSpikeCount"] = _sbsCount
	lookupLogic["$sadTime"] = _sadTime
	lookupLogic["$sliceAndDiceTime"] = _sadTime
	lookupLogic["$blindsideTime"] = _blindsideTime
	lookupLogic["$isBleeding"] = ""
	lookupLogic["$inStealth"] = ""

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookupLogic["$passive"] = _passiveEnergyMinusRegen
	else
		lookupLogic["$passive"] = _passiveEnergy
	end

	lookupLogic["$regen"] = _regenEnergy
	lookupLogic["$regenEnergy"] = _regenEnergy
	lookupLogic["$regenResource"] = _regenEnergy
	lookupLogic["$resourceRegen"] = _regenEnergy
	lookupLogic["$energyRegen"] = _regenEnergy
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$energyOvercap"] = overcap
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Outlaw()
	local specSettings = TRB.Data.settings.rogue.outlaw
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentEnergyColor = specSettings.colors.text.current
	local castingEnergyColor = specSettings.colors.text.casting
	
	if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
		if specSettings.colors.text.overcapEnabled and overcap then
			currentEnergyColor = specSettings.colors.text.overcap
			castingEnergyColor = specSettings.colors.text.overcap
		elseif specSettings.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for _, v in pairs(spells) do
				local spell = v --[[@as TRB.Classes.SpellBase]]
				if spell ~= nil and spell.primaryResourceType ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = specSettings.colors.text.overThreshold
				castingEnergyColor = specSettings.colors.text.overThreshold
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = specSettings.colors.text.spending
	end

	--$energy
	local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, snapshotData.attributes.resource)
	--$casting
	local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshotData.casting.resourceFinal)
	--$passive
	local _regenEnergy = 0
	local _passiveEnergy
	local _passiveEnergyMinusRegen

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenEnergy = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenEnergy = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenEnergy
	local regenEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenEnergy)

	_passiveEnergy = _regenEnergy
	_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

	local passiveEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergy)
	local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergyMinusRegen)
	--$energyTotal
	local _energyTotal = math.min(_passiveEnergy + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
	--$energyPlusCasting
	local _energyPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
	--$energyPlusPassive
	local _energyPlusPassive = math.min(_passiveEnergy + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

	-- Poisons				
	--$atrophicPoisonCount and $atrophicPoisonTime
	local _atrophicPoisonCount = snapshotData.targetData.count[spells.atrophicPoison.id] or 0
	local atrophicPoisonCount = tostring(_atrophicPoisonCount)
	local _atrophicPoisonTime = 0
	local atrophicPoisonTime

	--$cpCount and $cpTime
	local _cpCount = snapshotData.targetData.count[spells.cripplingPoison.id] or 0
	local cpCount = tostring(_cpCount)
	local _cpTime = 0
	local cpTime
		
	--$npCount and $npTime
	local _npCount = snapshotData.targetData.count[spells.numbingPoison.id] or 0
	local npCount = tostring(_npCount)
	local _npTime = 0
	local npTime
			
	--$wpCount and $wpTime
	local _wpCount = snapshotData.targetData.count[spells.woundPoison.id] or 0
	local wpCount = tostring(_wpCount)
	local _wpTime = 0
	local wpTime


	if target ~= nil then
		_atrophicPoisonTime = target.spells[spells.atrophicPoison.id].remainingTime or 0
		_cpTime = target.spells[spells.cripplingPoison.id].remainingTime or 0
		_npTime = target.spells[spells.numbingPoison.id].remainingTime or 0
		_wpTime = target.spells[spells.woundPoison.id].remainingTime or 0
	end


	if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		--Poisons
		if _atrophicPoisonTime > 0 then
			atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _atrophicPoisonCount)
			atrophicPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_atrophicPoisonTime))
		else
			atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _atrophicPoisonCount)
			atrophicPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _cpTime > 0 then
			cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _cpCount)
			cpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_cpTime))
		else
			cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _cpCount)
			cpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _npTime > 0 then
			npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _npCount)
			npTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_npTime))
		else
			npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _npCount)
			npTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _wpTime > 0 then
			wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _wpCount)
			wpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_wpTime))
		else
			wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _wpCount)
			wpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		-- Poisons
		atrophicPoisonTime = TRB.Functions.BarText:TimerPrecision(_atrophicPoisonTime)
		cpTime = TRB.Functions.BarText:TimerPrecision(_cpTime)
		npTime = TRB.Functions.BarText:TimerPrecision(_npTime)
		wpTime = TRB.Functions.BarText:TimerPrecision(_wpTime)
	end

	--$sadTime
	local _sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
	local sadTime
	
	if _sadTime > spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_sadTime))
	elseif _sadTime > 0 then
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_sadTime))
	else
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
	end

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
	local opportunityTime = TRB.Functions.BarText:TimerPrecision(_opportunityTime)

	----------------------------

	Global_TwintopResourceBar.resource.passive = _passiveEnergy
	Global_TwintopResourceBar.resource.regen = _regenEnergy
	Global_TwintopResourceBar.dots = {
		atrophicPoisonCount = _atrophicPoisonCount,
		cripplingPoisonCount = _cpCount,
		numbingPoisonCount = _npCount,
		woundPoisonCount = _wpCount
	}

	local lookup = TRB.Data.lookup or {}
	lookup["#adrenalineRush"] = spells.adrenalineRush.icon
	lookup["#atrophicPoison"] = spells.atrophicPoison.icon
	lookup["#betweenTheEyes"] = spells.betweenTheEyes.icon
	lookup["#bladeFlurry"] = spells.bladeFlurry.icon
	lookup["#bladeRush"] = spells.bladeRush.icon
	lookup["#broadside"] = spells.broadside.icon
	lookup["#buriedTreasure"] = spells.buriedTreasure.icon
	lookup["#deathFromAbove"] = spells.numbingPoison.icon
	lookup["#dispatch"] = spells.dispatch.icon
	lookup["#dismantle"] = spells.numbingPoison.icon
	lookup["#dreadblades"] = spells.dreadblades.icon
	lookup["#cripplingPoison"] = spells.cripplingPoison.icon
	lookup["#cp"] = spells.cripplingPoison.icon
	lookup["#dismantle"] = spells.dismantle.icon
	lookup["#echoingReprimand"] = spells.echoingReprimand.icon
	lookup["#ghostlyStrike"] = spells.ghostlyStrike.icon
	lookup["#grandMelee"] = spells.grandMelee.icon
	lookup["#numbingPoison"] = spells.numbingPoison.icon
	lookup["#np"] = spells.numbingPoison.icon
	lookup["#opportunity"] = spells.opportunity.icon
	lookup["#pistolShot"] = spells.pistolShot.icon
	lookup["#rollTheBones"] = spells.rollTheBones.icon
	lookup["#ruthlessPrecision"] = spells.ruthlessPrecision.icon
	lookup["#sad"] = spells.sliceAndDice.icon
	lookup["#sliceAndDice"] = spells.sliceAndDice.icon
	lookup["#sepsis"] = spells.sepsis.icon
	lookup["#sinisterStrike"] = spells.sinisterStrike.icon
	lookup["#skullAndCrossbones"] = spells.skullAndCrossbones.icon
	lookup["#stealth"] = spells.stealth.icon
	lookup["#trueBearing"] = spells.trueBearing.icon
	lookup["#woundPoison"] = spells.woundPoison.icon
	lookup["#wp"] = spells.woundPoison.icon

	lookup["$energyTotal"] = energyTotal
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$resourcePlusCasting"] = energyPlusCasting
	lookup["$energyPlusCasting"] = energyPlusCasting
	lookup["$resourcePlusPassive"] = energyPlusPassive
	lookup["$energyPlusPassive"] = energyPlusPassive
	lookup["$resourceTotal"] = energyTotal
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$atrophicPoisonCount"] = atrophicPoisonCount
	lookup["$atrophicPoisonTime"] = atrophicPoisonTime
	lookup["$cpCount"] = cpCount
	lookup["$cripplingPoisonCount"] = cpCount
	lookup["$cpTime"] = cpTime
	lookup["$cripplingPoisonTime"] = cpTime
	lookup["$npCount"] = npCount
	lookup["$numbingPoisonCount"] = npCount
	lookup["$npTime"] = npTime
	lookup["$numbingPoisonTime"] = npTime
	lookup["$wpCount"] = wpCount
	lookup["$woundPoisonCount"] = wpCount
	lookup["$wpTime"] = wpTime
	lookup["$woundPoisonTime"] = wpTime
	lookup["$sadTime"] = sadTime
	lookup["$sliceAndDiceTime"] = sadTime
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
	lookup["$trueBearingTime"] = trueBearingTime

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookup["$passive"] = passiveEnergyMinusRegen
	else
		lookup["$passive"] = passiveEnergy
	end

	lookup["$regen"] = regenEnergy
	lookup["$regenEnergy"] = regenEnergy
	lookup["$regenResource"] = regenEnergy
	lookup["$resourceRegen"] = regenEnergy
	lookup["$energyRegen"] = regenEnergy
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$energyOvercap"] = overcap
	lookup["$inStealth"] = ""
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$energyTotal"] = _energyTotal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
	lookupLogic["$energyPlusCasting"] = _energyPlusCasting
	lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
	lookupLogic["$energyPlusPassive"] = _energyPlusPassive
	lookupLogic["$resourceTotal"] = _energyTotal
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$atrophicPoisonCount"] = atrophicPoisonCount
	lookupLogic["$atrophicPoisonTime"] = atrophicPoisonTime
	lookupLogic["$cpCount"] = _cpCount
	lookupLogic["$cripplingPoisonCount"] = _cpCount
	lookupLogic["$cpTime"] = _cpTime
	lookupLogic["$cripplingPoisonTime"] = _cpTime
	lookupLogic["$npCount"] = _npCount
	lookupLogic["$numbingPoisonCount"] = _npCount
	lookupLogic["$npTime"] = _npTime
	lookupLogic["$numbingPoisonTime"] = _npTime
	lookupLogic["$wpCount"] = _wpCount
	lookupLogic["$woundPoisonCount"] = _wpCount
	lookupLogic["$wpTime"] = _wpTime
	lookupLogic["$woundPoisonTime"] = _wpTime
	lookupLogic["$sadTime"] = _sadTime
	lookupLogic["$sliceAndDiceTime"] = _sadTime
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
	lookupLogic["$trueBearingTime"] = _trueBearingTime

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookupLogic["$passive"] = _passiveEnergyMinusRegen
	else
		lookupLogic["$passive"] = _passiveEnergy
	end

	lookupLogic["$regen"] = _regenEnergy
	lookupLogic["$regenEnergy"] = _regenEnergy
	lookupLogic["$regenResource"] = _regenEnergy
	lookupLogic["$resourceRegen"] = _regenEnergy
	lookupLogic["$energyRegen"] = _regenEnergy
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$energyOvercap"] = overcap
	lookupLogic["$inStealth"] = ""
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Subtlety()
	local specSettings = TRB.Data.settings.rogue.subtlety
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()


	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentEnergyColor = specSettings.colors.text.current
	local castingEnergyColor = specSettings.colors.text.casting
	
	if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
		if specSettings.colors.text.overcapEnabled and overcap then
			currentEnergyColor = specSettings.colors.text.overcap
			castingEnergyColor = specSettings.colors.text.overcap
		elseif specSettings.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for _, v in pairs(spells) do
				local spell = v --[[@as TRB.Classes.SpellBase]]
				if spell ~= nil and spell.primaryResourceType ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = specSettings.colors.text.overThreshold
				castingEnergyColor = specSettings.colors.text.overThreshold
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = specSettings.colors.text.spending
	end

	--$energy
	local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, snapshotData.attributes.resource)
	--$casting
	local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshotData.casting.resourceFinal)
	--$passive
	local _regenEnergy = 0
	local _passiveEnergy
	local _passiveEnergyMinusRegen

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenEnergy = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenEnergy = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenEnergy
	local regenEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenEnergy)

	_passiveEnergy = _regenEnergy
	_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

	local passiveEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergy)
	local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergyMinusRegen)
	--$energyTotal
	local _energyTotal = math.min(_passiveEnergy + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
	--$energyPlusCasting
	local _energyPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
	--$energyPlusPassive
	local _energyPlusPassive = math.min(_passiveEnergy + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)
	
	--$ruptureCount and $ruptureTime
	local _ruptureCount = snapshotData.targetData.count[spells.rupture.id] or 0
	local ruptureCount = tostring(_ruptureCount)
	local _ruptureTime = 0
	local ruptureTime
	
	-- Poisons
	--$cpCount and $cpTime
	local _cpCount = snapshotData.targetData.count[spells.cripplingPoison.id] or 0
	local cpCount = tostring(_cpCount)
	local _cpTime = 0
	local cpTime
					
	--$npCount and $npTime
	local _npCount = snapshotData.targetData.count[spells.numbingPoison.id] or 0
	local npCount = tostring(_npCount)
	local _npTime = 0
	local npTime
			
	--$atrophicPoisonCount and $atrophicPoisonTime
	local _atrophicPoisonCount = snapshotData.targetData.count[spells.atrophicPoison.id] or 0
	local atrophicPoisonCount = tostring(_atrophicPoisonCount)
	local _atrophicPoisonTime = 0
	local atrophicPoisonTime
			
	--$wpCount and $wpTime
	local _wpCount = snapshotData.targetData.count[spells.woundPoison.id] or 0
	local wpCount = tostring(_wpCount)
	local _wpTime = 0
	local wpTime

	if target ~= nil then
		_ruptureTime = target.spells[spells.rupture.id].remainingTime or 0
		_cpTime = target.spells[spells.cripplingPoison.id].remainingTime or 0
		_npTime = target.spells[spells.numbingPoison.id].remainingTime or 0
		_atrophicPoisonTime = target.spells[spells.atrophicPoison.id].remainingTime or 0
		_wpTime = target.spells[spells.woundPoison.id].remainingTime or 0
	end

	if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		-- Bleeds
		if _ruptureTime > spells.rupture.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
			ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ruptureCount)
			ruptureTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_ruptureTime))
		elseif _ruptureTime > 0 then
			ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _ruptureCount)
			ruptureTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_ruptureTime))
		else
			ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ruptureCount)
			ruptureTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		--Poisons
		if _cpTime > 0 then
			cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _cpCount)
			cpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_cpTime))
		else
			cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _cpCount)
			cpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _npTime > 0 then
			npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _npCount)
			npTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_npTime))
		else
			npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _npCount)
			npTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _wpTime > 0 then
			wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _wpCount)
			wpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_wpTime))
		else
			wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _wpCount)
			wpTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if _atrophicPoisonTime > 0 then
			atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _atrophicPoisonCount)
			atrophicPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_atrophicPoisonTime))
		else
			atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _atrophicPoisonCount)
			atrophicPoisonTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		-- Bleeds
		ruptureTime = TRB.Functions.BarText:TimerPrecision(_ruptureTime)

		-- Poisons
		atrophicPoisonTime = TRB.Functions.BarText:TimerPrecision(_atrophicPoisonTime)
		cpTime = TRB.Functions.BarText:TimerPrecision(_cpTime)
		npTime = TRB.Functions.BarText:TimerPrecision(_npTime)
		wpTime = TRB.Functions.BarText:TimerPrecision(_wpTime)
	end
	

	--$sadTime
	local _sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
	local sadTime
	
	if _sadTime > spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_sadTime))
	elseif _sadTime > 0 then
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_sadTime))
	else
		sadTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
	end

	--$flagellationTime
	local _flagellationTime = snapshots[spells.flagellation.id].buff:GetRemainingTime(currentTime)
	local flagellationTime = TRB.Functions.BarText:TimerPrecision(_flagellationTime)

	--$sodTime
	local _sodTime = snapshots[spells.symbolsOfDeath.id].buff:GetRemainingTime(currentTime)
	local sodTime = TRB.Functions.BarText:TimerPrecision(_sodTime)

	--$shadowTechniquesCount
	local shadowTechniquesCount = snapshots[spells.shadowTechniques.id].buff.applications or 0

	----------------------------

	Global_TwintopResourceBar.resource.passive = _passiveEnergy
	Global_TwintopResourceBar.resource.regen = _regenEnergy
	Global_TwintopResourceBar.dots = {
		atrophicPoisonCount = _atrophicPoisonCount,
		cripplingPoisonCount = _cpCount,
		numbingPoisonCount = _npCount,
		woundPoisonCount = _wpCount,
		ruptureCount = _ruptureCount
	}

	local lookup = TRB.Data.lookup or {}
	lookup["#cripplingPoison"] = spells.cripplingPoison.icon
	lookup["#cp"] = spells.cripplingPoison.icon
	lookup["#deathFromAbove"] = spells.deathFromAbove.icon
	lookup["#dismantle"] = spells.dismantle.icon
	lookup["#echoingReprimand"] = spells.echoingReprimand.icon
	lookup["#flagellation"] = spells.flagellation.icon
	lookup["#numbingPoison"] = spells.numbingPoison.icon
	lookup["#np"] = spells.numbingPoison.icon
	lookup["#rupture"] = spells.rupture.icon
	lookup["#sad"] = spells.sliceAndDice.icon
	lookup["#sliceAndDice"] = spells.sliceAndDice.icon
	lookup["#sod"] = spells.symbolsOfDeath.icon
	lookup["#symbolsOfDeath"] = spells.symbolsOfDeath.icon
	lookup["#sepsis"] = spells.sepsis.icon
	lookup["#shadowTechniques"] = spells.shadowTechniques.icon
	lookup["#stealth"] = spells.stealth.icon
	lookup["#woundPoison"] = spells.woundPoison.icon
	lookup["#wp"] = spells.woundPoison.icon

	lookup["$energyTotal"] = energyTotal
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$resourcePlusCasting"] = energyPlusCasting
	lookup["$energyPlusCasting"] = energyPlusCasting
	lookup["$resourcePlusPassive"] = energyPlusPassive
	lookup["$energyPlusPassive"] = energyPlusPassive
	lookup["$resourceTotal"] = energyTotal
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$shadowTechniquesCount"] = shadowTechniquesCount
	lookup["$atrophicPoisonCount"] = atrophicPoisonCount
	lookup["$atrophicPoisonTime"] = atrophicPoisonTime
	lookup["$cpCount"] = cpCount
	lookup["$cripplingPoisonCount"] = cpCount
	lookup["$cpTime"] = cpTime
	lookup["$cripplingPoisonTime"] = cpTime
	lookup["$npCount"] = npCount
	lookup["$numbingPoisonCount"] = npCount
	lookup["$npTime"] = npTime
	lookup["$numbingPoisonTime"] = npTime
	lookup["$wpCount"] = wpCount
	lookup["$woundPoisonCount"] = wpCount
	lookup["$wpTime"] = wpTime
	lookup["$woundPoisonTime"] = wpTime
	lookup["$ruptureCount"] = ruptureCount
	lookup["$ruptureTime"] = ruptureTime
	lookup["$sadTime"] = sadTime
	lookup["$sliceAndDiceTime"] = sadTime
	lookup["$flagellationTime"] = flagellationTime
	lookup["$sodTime"] = sodTime
	lookup["$symbolsOfDeathTime"] = sodTime
	lookup["$inStealth"] = ""

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookup["$passive"] = passiveEnergyMinusRegen
	else
		lookup["$passive"] = passiveEnergy
	end

	lookup["$regen"] = regenEnergy
	lookup["$regenEnergy"] = regenEnergy
	lookup["$regenResource"] = regenEnergy
	lookup["$resourceRegen"] = regenEnergy
	lookup["$energyRegen"] = regenEnergy
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$energyOvercap"] = overcap
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$energyTotal"] = _energyTotal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
	lookupLogic["$energyPlusCasting"] = _energyPlusCasting
	lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
	lookupLogic["$energyPlusPassive"] = _energyPlusPassive
	lookupLogic["$resourceTotal"] = _energyTotal
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$shadowTechniquesCount"] = shadowTechniquesCount
	lookupLogic["$atrophicPoisonCount"] = _atrophicPoisonCount
	lookupLogic["$atrophicPoisonTime"] = _atrophicPoisonTime
	lookupLogic["$cpCount"] = _cpCount
	lookupLogic["$cripplingPoisonCount"] = _cpCount
	lookupLogic["$cpTime"] = _cpTime
	lookupLogic["$cripplingPoisonTime"] = _cpTime
	lookupLogic["$npCount"] = _npCount
	lookupLogic["$numbingPoisonCount"] = _npCount
	lookupLogic["$npTime"] = _npTime
	lookupLogic["$numbingPoisonTime"] = _npTime
	lookupLogic["$wpCount"] = _wpCount
	lookupLogic["$woundPoisonCount"] = _wpCount
	lookupLogic["$wpTime"] = _wpTime
	lookupLogic["$woundPoisonTime"] = _wpTime
	lookupLogic["$ruptureCount"] = _ruptureCount
	lookupLogic["$ruptureTime"] = _ruptureTime
	lookupLogic["$sadTime"] = _sadTime
	lookupLogic["$sliceAndDiceTime"] = _sadTime
	lookupLogic["$flagellationTime"] = _flagellationTime
	lookupLogic["$sodTime"] = _sodTime
	lookupLogic["$symbolsOfDeathTime"] = _sodTime
	lookupLogic["$inStealth"] = ""

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookupLogic["$passive"] = _passiveEnergyMinusRegen
	else
		lookupLogic["$passive"] = _passiveEnergy
	end

	lookupLogic["$regen"] = _regenEnergy
	lookupLogic["$regenEnergy"] = _regenEnergy
	lookupLogic["$regenResource"] = _regenEnergy
	lookupLogic["$resourceRegen"] = _regenEnergy
	lookupLogic["$energyRegen"] = _regenEnergy
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$energyOvercap"] = overcap
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()
	snapshotData.casting.startTime = currentTime
	snapshotData.casting.resourceRaw = spell.resource
	snapshotData.casting.resourceFinal = spell:GetPrimaryResourceCost()
	snapshotData.casting.spellId = spell.id
	snapshotData.casting.icon = spell.icon
end

local function CastingSpell()
	local specId = GetSpecialization()
	local currentSpell = UnitCastingInfo("player")
	local currentChannel = UnitChannelInfo("player")

	if currentSpell == nil and currentChannel == nil then
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	else
		if specId == 1 or specId == 2 or specId == 3 then
			if currentSpell == nil then
				local spellName = select(1, currentChannel)
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				--See Priest implementation for handling channeled spells
			else
				local spellName = select(1, currentSpell)
				return false
			end
		end
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	end
end

local function UpdateRollTheBones()
	TRB.Functions.Character:UpdateSnapshot()
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.RogueBaseSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()
	
	snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.subterfuge.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.shadowDance.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.echoingReprimand_2CP.id].buff:GetRemainingTime(currentTime)
	if snapshots[spells.echoingReprimand_2CP.id].buff.isActive then
		snapshots[spells.echoingReprimand.id].attributes.enabled[2] = true
	else
		snapshots[spells.echoingReprimand.id].attributes.enabled[2] = false
	end

	snapshots[spells.echoingReprimand_3CP.id].buff:GetRemainingTime(currentTime)
	if snapshots[spells.echoingReprimand_3CP.id].buff.isActive then
		snapshots[spells.echoingReprimand.id].attributes.enabled[3] = true
	else
		snapshots[spells.echoingReprimand.id].attributes.enabled[3] = false
	end

	snapshots[spells.echoingReprimand_4CP.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.echoingReprimand_4CP2.id].buff:GetRemainingTime(currentTime)
	if snapshots[spells.echoingReprimand_4CP.id].buff.isActive or snapshots[spells.echoingReprimand_4CP2.id].buff.isActive then
		snapshots[spells.echoingReprimand.id].attributes.enabled[4] = true
	else
		snapshots[spells.echoingReprimand.id].attributes.enabled[4] = false
	end

	snapshots[spells.echoingReprimand_5CP.id].buff:GetRemainingTime(currentTime)
	if snapshots[spells.echoingReprimand_5CP.id].buff.isActive then
		snapshots[spells.echoingReprimand.id].attributes.enabled[5] = true
	else
		snapshots[spells.echoingReprimand.id].attributes.enabled[5] = false
	end

	snapshots[spells.echoingReprimand.id].cooldown:Refresh()
	snapshots[spells.distract.id].cooldown:Refresh()
	snapshots[spells.feint.id].cooldown:Refresh()
	snapshots[spells.gouge.id].cooldown:Refresh()
	snapshots[spells.kidneyShot.id].cooldown:Refresh()
	snapshots[spells.shiv.id].cooldown:Refresh()
	snapshots[spells.deathFromAbove.id].cooldown:Refresh()
	snapshots[spells.dismantle.id].cooldown:Refresh()
	snapshots[spells.crimsonVial.id].cooldown:Refresh()
end

local function UpdateSnapshot_Assassination()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()

	snapshots[spells.improvedGarrote.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.blindside.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.sepsis.id].buff:GetRemainingTime(currentTime)

	snapshots[spells.serratedBoneSpike.id].cooldown:Refresh()
	snapshots[spells.garrote.id].cooldown:Refresh()
	snapshots[spells.kingsbane.id].cooldown:Refresh()
end

local function UpdateSnapshot_Outlaw()
	UpdateSnapshot()
	UpdateRollTheBones()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.bladeRush.id].cooldown:Refresh()
	snapshots[spells.bladeFlurry.id].cooldown:Refresh()
	snapshots[spells.betweenTheEyes.id].cooldown:Refresh()
	snapshots[spells.dreadblades.id].cooldown:Refresh()
	snapshots[spells.ghostlyStrike.id].cooldown:Refresh()
	snapshots[spells.rollTheBones.id].cooldown:Refresh()
end

local function UpdateSnapshot_Subtlety()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()
	
	snapshots[spells.sepsis.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.goremawsBite.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.flagellation.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.shadowTechniques.id].buff:Refresh()
	snapshots[spells.symbolsOfDeath.id].buff:Refresh()
	
	snapshots[spells.goremawsBite.id].cooldown:Refresh()
	snapshots[spells.secretTechnique.id].cooldown:Refresh()
	snapshots[spells.shurikenTornado.id].cooldown:Refresh()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local specId = GetSpecialization()
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.rogue
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if specId == 1 then
		local specSettings = classSettings.assassination
		UpdateSnapshot_Assassination()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

				local passiveValue = 0
				if specSettings.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
				end

				if CastingSpell() and specSettings.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					passiveBarValue = castingBarValue + passiveValue
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end

				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.sepsis.id].buff.isActive or snapshots[spells.shadowDance.id].buff.isActive
				local pairOffset = 0
				for _, v in pairs(TRB.Data.spellsData.spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						local resourceAmount = -spell:GetPrimaryResourceCost()
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

						if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
							if spell.id == spells.ambush.id then
								if stealthViaBuff then
									if currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif snapshots[spells.blindside.id].buff.isActive then
									thresholdColor = specSettings.colors.threshold.over
								else
									showThreshold = false
								end
							elseif stealthViaBuff then
								if currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else
								showThreshold = false
							end
						else
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.sliceAndDice.id then
									if currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if snapshots[spell.id].buff:GetRemainingTime(currentTime) > spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
										frameLevel = TRB.Data.constants.frameLevels.thresholdBase
									else
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									end
								elseif spell.id == spells.garrote.id then
									if not talents:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									else
										if snapshots[spells.improvedGarrote.id].attributes.isActiveStealth or snapshots[spells.improvedGarrote.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										elseif snapshots[spell.id].cooldown:IsUnusable() then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
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
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						end

						if	spell:Is("TRB.Classes.SpellComboPointThreshold") and
							spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
							snapshotData.attributes.resource2 == 0 then
							thresholdColor = specSettings.colors.threshold.unusable
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
					end
					pairOffset = pairOffset + 3
				end

				local barColor = specSettings.colors.bar.base

				local affectingCombat = UnitAffectingCombat("player")

				if affectingCombat then
					local sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
					if sadTime == 0 then
						barColor = specSettings.colors.bar.noSliceAndDice
					elseif sadTime < spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
						barColor = specSettings.colors.bar.sliceAndDicePandemic
					end
				end

				local barBorderColor = specSettings.colors.bar.border
				if IsStealthed() or stealthViaBuff then
					barBorderColor = specSettings.colors.bar.borderStealth
				elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end

				barContainerFrame:SetAlpha(1.0)

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				
				local sbsCp = 0
				
				if specSettings.comboPoints.spec.serratedBoneSpikeColor and talents:IsTalentActive(spells.serratedBoneSpike) and snapshotData.targetData.currentTargetGuid ~= nil and snapshots[spells.serratedBoneSpike.id].cooldown.charges > 0 then
					sbsCp = 1 + snapshotData.targetData.count[spells.serratedBoneSpike.debuffId]
				end

				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					if snapshots[spells.echoingReprimand.id].attributes.enabled[x] then
						cpColor = specSettings.colors.comboPoints.echoingReprimand
						
						if sbsCp > 0 and x > snapshotData.attributes.resource2 and x <= (snapshotData.attributes.resource2 + sbsCp) and not specSettings.comboPoints.consistentUnfilledColor then
							cpBorderColor = specSettings.colors.comboPoints.serratedBoneSpike
						else
							cpBorderColor = specSettings.colors.comboPoints.echoingReprimand
						end

						if not specSettings.comboPoints.consistentUnfilledColor then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
						end
					elseif sbsCp > 0 and x > snapshotData.attributes.resource2 and x <= (snapshotData.attributes.resource2 + sbsCp) then
						cpBorderColor = specSettings.colors.comboPoints.serratedBoneSpike
						
						if not specSettings.comboPoints.consistentUnfilledColor then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.serratedBoneSpike, true)
						end
					end
					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	elseif specId == 2 then
		local specSettings = classSettings.outlaw
		UpdateSnapshot_Outlaw()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

				local passiveValue = 0
				if specSettings.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
				end

				if CastingSpell() and specSettings.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					passiveBarValue = castingBarValue + passiveValue
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.sepsis.id].buff.isActive or snapshots[spells.shadowDance.id].buff.isActive
				local pairOffset = 0
				for _, v in pairs(TRB.Data.spellsData.spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						local resourceAmount = -spell:GetPrimaryResourceCost()
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

						if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
							if spell.id == spells.ambush.id then
								if stealthViaBuff then
									if currentResource >= -resourceAmount then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else
									showThreshold = false
								end
							elseif stealthViaBuff then
								if currentResource >= -resourceAmount then
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else
								showThreshold = false
							end
						else
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.sinisterStrike.id then
									if currentResource >= -resourceAmount then
										if snapshots[spells.skullAndCrossbones.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										else
											thresholdColor = specSettings.colors.threshold.over
										end
									else
										if snapshots[spells.skullAndCrossbones.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.pistolShot.id then
									if currentResource >= -resourceAmount then
										if snapshots[spells.opportunity.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										else
											thresholdColor = specSettings.colors.threshold.over
										end
									else
										if snapshots[spells.opportunity.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.betweenTheEyes.id then
									if snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentResource >= -resourceAmount then
										if snapshots[spells.ruthlessPrecision.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										else
											thresholdColor = specSettings.colors.threshold.over
										end
									else
										if snapshots[spells.ruthlessPrecision.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.special
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.sliceAndDice.id then
									if currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime) > spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
										frameLevel = TRB.Data.constants.frameLevels.thresholdBase
									else
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
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
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						end

						if	spell:Is("TRB.Classes.SpellComboPointThreshold") and
							spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
							snapshotData.attributes.resource2 == 0 then
							thresholdColor = specSettings.colors.threshold.unusable
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
					end
					pairOffset = pairOffset + 3
				end

				local barColor = specSettings.colors.bar.base

				local affectingCombat = UnitAffectingCombat("player")

				if affectingCombat then
					local sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
					if sadTime == 0 then
						barColor = specSettings.colors.bar.noSliceAndDice
					elseif sadTime < spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
						barColor = specSettings.colors.bar.sliceAndDicePandemic
					end
				end

				local barBorderColor = specSettings.colors.bar.border

				if IsStealthed() or stealthViaBuff then
					barBorderColor = specSettings.colors.bar.borderStealth
				elseif snapshots[spells.rollTheBones.id].attributes.goodBuffs == true and snapshots[spells.rollTheBones.id].cooldown:IsUsable() then
					barBorderColor = specSettings.colors.bar.borderRtbGood
				elseif snapshots[spells.rollTheBones.id].attributes.goodBuffs == false and snapshots[spells.rollTheBones.id].cooldown:IsUsable() then
					barBorderColor = specSettings.colors.bar.borderRtbBad
				elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end

				barContainerFrame:SetAlpha(1.0)

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					if snapshots[spells.echoingReprimand.id].attributes.enabled[x] then
						cpColor = specSettings.colors.comboPoints.echoingReprimand
						cpBorderColor = specSettings.colors.comboPoints.echoingReprimand

						if not specSettings.comboPoints.consistentUnfilledColor then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
						end
					end

					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	elseif specId == 3 then
		local specSettings = classSettings.subtlety
		UpdateSnapshot_Subtlety()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

				local passiveValue = 0
				if specSettings.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
				end

				if CastingSpell() and specSettings.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					passiveBarValue = castingBarValue + passiveValue
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end

				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.sepsis.id].buff.isActive or snapshots[spells.shadowDance.id].buff.isActive
				local pairOffset = 0
				for _, v in pairs(TRB.Data.spellsData.spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						local resourceAmount = -spell:GetPrimaryResourceCost()
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					
						if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
							--[[if spell.id == spells.ambush.id then
								if stealthViaBuff then
									if currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else
									showThreshold = false
								end
							else]]
							if stealthViaBuff then
								if currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else
								showThreshold = false
							end
						else
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.sliceAndDice.id then
									if currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if snapshots[spell.id].buff:GetRemainingTime(currentTime) > spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
										frameLevel = TRB.Data.constants.frameLevels.thresholdBase
									else
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									end
								elseif spell.id == spells.backstab.id then
									if talents:IsTalentActive(spells.gloomblade) then
										showThreshold = false
									else
										if currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.gloomblade.id then
									if not talents:IsTalentActive(spells.gloomblade) then
										showThreshold = false
									else
										if currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.cheapShot.id then
									if snapshots[spells.shotInTheDark.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.over
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.shurikenStorm.id then
									if snapshots[spells.silentStorm.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.blackPowder.id then
									if snapshots[spells.finalityBlackPowder.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.eviscerate.id then
									if snapshots[spells.finalityEviscerate.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.rupture.id then
									if snapshots[spells.finalityRupture.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
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
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						end

						if 	spell:Is("TRB.Classes.SpellComboPointThreshold") and
							spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true then
							if snapshotData.attributes.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif thresholdColor ~= specSettings.colors.threshold.special and snapshots[spells.goremawsBite.id].buff.isActive and (snapshotData.snapshots[spell.id] == nil or snapshotData.snapshots[spell.id].cooldown:IsUsable()) then
								thresholdColor = specSettings.colors.threshold.over
								frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							end
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
					end
					pairOffset = pairOffset + 3
				end

				local barColor = specSettings.colors.bar.base

				local affectingCombat = UnitAffectingCombat("player")

				if affectingCombat then
					local sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
					if sadTime == 0 then
						barColor = specSettings.colors.bar.noSliceAndDice
					elseif sadTime < spells.sliceAndDice.attributes.pandemicTimes[snapshotData.attributes.resource2 + 1] then
						barColor = specSettings.colors.bar.sliceAndDicePandemic
					end
				end

				local barBorderColor = specSettings.colors.bar.border
				
				if snapshots[spells.symbolsOfDeath.id].buff.isActive and
					snapshots[spells.shadowTechniques.id].buff.applications >= TRB.Data.character.maxResource2 and
					talents:IsTalentActive(spells.shadowcraft) then
					barBorderColor = specSettings.colors.bar.borderShadowcraft
				elseif stealthViaBuff or IsStealthed() then
					barBorderColor = specSettings.colors.bar.borderStealth
				elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end

				barContainerFrame:SetAlpha(1.0)

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end
					if snapshots[spells.echoingReprimand.id].attributes.enabled[x] then
						cpColor = specSettings.colors.comboPoints.echoingReprimand
						cpBorderColor = specSettings.colors.comboPoints.echoingReprimand

						if not specSettings.comboPoints.consistentUnfilledColor then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
						end
					elseif x > snapshotData.attributes.resource2 and (snapshots[spells.shadowTechniques.id].buff.applications + snapshotData.attributes.resource2) >= x then							
						cpBorderColor = specSettings.colors.comboPoints.shadowTechniques

						if not specSettings.comboPoints.consistentUnfilledColor then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.shadowTechniques, true)
						end
					end

					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local triggerUpdate = false
	local _
	local specId = GetSpecialization()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

		if entry.sourceGuid == TRB.Data.character.guid then
			if specId == 1 and TRB.Data.barConstructedForSpec == "assassination" then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
				if entry.spellId == spells.blindside.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
						if TRB.Data.settings.rogue.assassination.audio.blindside.enabled then
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif entry.spellId == spells.garrote.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						if entry.type == "SPELL_CAST_SUCCESS" then
							if not((talents:IsTalentActive(spells.subterfuge) and IsStealthed()) or snapshots[spells.subterfuge.id].buff.isActive) then
								snapshots[entry.spellId].cooldown:Initialize()
							end

							if snapshots[spells.improvedGarrote.id].attributes.isActiveStealth or snapshots[spells.improvedGarrote.id].attributes.isActiveStealth then									
								snapshots[entry.spellId].cooldown:Reset()
							end
						end
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.rupture.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.internalBleeding.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.crimsonTempest.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.deadlyPoison.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.amplifyingPoison.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.kingsbane.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.serratedBoneSpike.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.serratedBoneSpike.debuffId then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.crimsonVial.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.improvedGarrote.attributes.stealthBuffId then
					snapshots[spells.improvedGarrote.id].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.improvedGarrote.buffId then
					snapshots[spells.improvedGarrote.id].buff:Initialize(entry.type)
				end
			elseif specId == 2 and TRB.Data.barConstructedForSpec == "outlaw" then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
				if entry.spellId == spells.betweenTheEyes.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.bladeFlurry.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.dreadblades.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.ghostlyStrike.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.killingSpree.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.rollTheBones.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.opportunity.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
						if TRB.Data.settings.rogue.outlaw.audio.opportunity.enabled then
							PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.opportunity.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif entry.spellId == spells.broadside.id or entry.spellId == spells.buriedTreasure.id or entry.spellId == spells.grandMelee.id or entry.spellId == spells.ruthlessPrecision.id or entry.spellId == spells.skullAndCrossbones.id or entry.spellId == spells.trueBearing.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
						if snapshots[entry.spellId].buff.duration > spells.countTheOdds.duration then
							snapshots[entry.spellId].attributes.fromCountTheOdds = false
						else
							snapshots[entry.spellId].attributes.fromCountTheOdds = true
						end
					elseif entry.type == "SPELL_AURA_REMOVED" then
						snapshots[entry.spellId].attributes.fromCountTheOdds = false
					end
				elseif entry.spellId == spells.keepItRolling.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						if snapshots[spells.broadside.id].buff.isActive then
							snapshots[spells.broadside.id].buff.duration = snapshots[spells.broadside.id].buff.duration + spells.keepItRolling.duration
						end
						if snapshots[spells.buriedTreasure.id].buff.isActive then
							snapshots[spells.buriedTreasure.id].buff.duration = snapshots[spells.buriedTreasure.id].buff.duration + spells.keepItRolling.duration
						end
						if snapshots[spells.grandMelee.id].buff.isActive then
							snapshots[spells.grandMelee.id].buff.duration = snapshots[spells.grandMelee.id].buff.duration + spells.keepItRolling.duration
						end
						if snapshots[spells.ruthlessPrecision.id].buff.isActive then
							snapshots[spells.ruthlessPrecision.id].buff.duration = snapshots[spells.ruthlessPrecision.id].buff.duration + spells.keepItRolling.duration
						end
						if snapshots[spells.skullAndCrossbones.id].buff.isActive then
							snapshots[spells.skullAndCrossbones.id].buff.duration = snapshots[spells.skullAndCrossbones.id].buff.duration + spells.keepItRolling.duration
						end
						if snapshots[spells.trueBearing.id].buff.isActive then
							snapshots[spells.trueBearing.id].buff.duration = snapshots[spells.trueBearing.id].buff.duration + spells.keepItRolling.duration
						end
					end
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "subtlety" then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
				if entry.spellId == spells.goremawsBite.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.goremawsBite.buffId then
					
					snapshots[spells.goremawsBite.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.rupture.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.secretTechnique.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.shurikenTornado.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.shotInTheDark.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.silentStorm.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.finalityBlackPowder.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.finalityEviscerate.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.finalityRupture.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.shadowTechniques.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.flagellation.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.symbolsOfDeath.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				end

				-- Shadow Techniques check workaround until a spellId dictionary can be added
				if entry.spellId == spells.cheapShot.id or
					entry.spellId == spells.shiv.id or
					entry.spellId == spells.gouge.id or
					entry.spellId == spells.echoingReprimand.id or
					entry.spellId == spells.backstab.id or
					entry.spellId == spells.shadowstrike.id or
					entry.spellId == spells.shurikenStorm.id or
					entry.spellId == spells.shurikenToss.id or
					entry.spellId == spells.shurikenTornado.id or
					entry.spellId == spells.sepsis.id or
					entry.spellId == spells.goremawsBite.id then
					snapshots[spells.shadowTechniques.id].buff:RequestRefresh(GetTime() + 0.05)
				end

				if snapshots[spells.symbolsOfDeath.id].buff.isActive and
					talents:IsTalentActive(spells.inevitability) and
					(entry.spellId == spells.backstab.id or
					entry.spellId == spells.shadowstrike.id) then
					snapshots[spells.symbolsOfDeath.id].buff:RequestRefresh(GetTime() + 0.05)
				end
			end

			-- Spec agnostic
			
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.RogueBaseSpells]]
			if entry.spellId == spells.subterfuge.id then
				snapshots[entry.spellId].buff:Initialize(entry.type)
			elseif entry.spellId == spells.shadowDance.id then
				snapshots[entry.spellId].buff:Initialize(entry.type)
			elseif entry.spellId == spells.crimsonVial.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.sliceAndDice.id then
				snapshots[entry.spellId].buff:Initialize(entry.type)
			elseif entry.spellId == spells.distract.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.feint.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.kidneyShot.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.shiv.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.adrenalineRush.id then
				if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REMOVED" then -- For right now, just redo the CheckCharacter() to get update Energy values
					TRB.Functions.Class:CheckCharacter()
				end
			elseif entry.spellId == spells.echoingReprimand.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.echoingReprimand_2CP.id or entry.spellId == spells.echoingReprimand_3CP.id or entry.spellId == spells.echoingReprimand_4CP.id or entry.spellId == spells.echoingReprimand_4CP2.id or entry.spellId == spells.echoingReprimand_5CP.id then
				snapshots[entry.spellId].buff:Initialize(entry.type)
			elseif entry.spellId == spells.sepsis.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.sepsis.buffId then
				snapshots[spells.sepsis.id].buff:Initialize(entry.type)
				if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
					if TRB.Data.settings.rogue.assassination.audio.sepsis.enabled then
						PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				end
			elseif entry.spellId == spells.cripplingPoison.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			elseif entry.spellId == spells.woundPoison.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			elseif entry.spellId == spells.numbingPoison.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			elseif entry.spellId == spells.atrophicPoison.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			elseif entry.spellId == spells.gouge.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.deathFromAbove.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			elseif entry.spellId == spells.dismantle.id then
				if entry.type == "SPELL_CAST_SUCCESS" then
					snapshots[entry.spellId].cooldown:Initialize()
				end
			end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
			triggerUpdate = true
		end
	end

	if triggerUpdate then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end)

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		TRB.Functions.Class:TriggerResourceBarUpdates()
		self.sinceLastUpdate = 0
	end
end

combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event =="PLAYER_REGEN_DISABLED" then
		TRB.Functions.Bar:ShowResourceBar()
	else
		TRB.Functions.Bar:HideResourceBar()
	end
end)

local function SwitchSpec()
	barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local specId = GetSpecialization()
	if specId == 1 then
		specCache.assassination.talents:GetTalents()
		FillSpellData_Assassination()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.assassination)
		
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.crimsonTempest)
		targetData:AddSpellTracking(spells.garrote)
		targetData:AddSpellTracking(spells.internalBleeding)
		targetData:AddSpellTracking(spells.rupture)
		targetData:AddSpellTracking(spells.amplifyingPoison)
		targetData:AddSpellTracking(spells.atrophicPoison)
		targetData:AddSpellTracking(spells.cripplingPoison)
		targetData:AddSpellTracking(spells.deadlyPoison)
		targetData:AddSpellTracking(spells.numbingPoison)
		targetData:AddSpellTracking(spells.woundPoison)
		targetData:AddSpellTracking(spells.serratedBoneSpike, true, false, false)

		spells.shiv:ResetPrimaryResourceCost()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.rogue.assassination)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.assassination)

		if TRB.Data.barConstructedForSpec ~= "assassination" then
			talents = specCache.assassination.talents
			TRB.Data.barConstructedForSpec = "assassination"
			ConstructResourceBar(specCache.assassination.settings)
		else
			TRB.Functions.Bar:SetPosition(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
		end
	elseif specId == 2 then
		specCache.outlaw.talents:GetTalents()
		FillSpellData_Outlaw()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.outlaw)
		
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.atrophicPoison)
		targetData:AddSpellTracking(spells.cripplingPoison)
		targetData:AddSpellTracking(spells.numbingPoison)
		targetData:AddSpellTracking(spells.woundPoison)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Outlaw
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.rogue.outlaw)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.outlaw)

		if TRB.Data.barConstructedForSpec ~= "outlaw" then
			talents = specCache.outlaw.talents
			TRB.Data.barConstructedForSpec = "outlaw"
			ConstructResourceBar(specCache.outlaw.settings)
		else
			TRB.Functions.Bar:SetPosition(TRB.Data.settings.rogue.outlaw, TRB.Frames.barContainerFrame)
		end
	elseif specId == 3 then
		specCache.subtlety.talents:GetTalents()
		FillSpellData_Subtlety()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.subtlety)
		
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.rupture)
		targetData:AddSpellTracking(spells.atrophicPoison)
		targetData:AddSpellTracking(spells.cripplingPoison)
		targetData:AddSpellTracking(spells.numbingPoison)
		targetData:AddSpellTracking(spells.woundPoison)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Subtlety
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.rogue.subtlety)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.subtlety)

		if TRB.Data.barConstructedForSpec ~= "subtlety" then
			talents = specCache.subtlety.talents
			TRB.Data.barConstructedForSpec = "subtlety"
			ConstructResourceBar(specCache.subtlety.settings)
		else
			TRB.Functions.Bar:SetPosition(TRB.Data.settings.rogue.subtlety, TRB.Frames.barContainerFrame)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end
	TRB.Functions.Class:EventRegistration()
end

resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	local specId = GetSpecialization() or 0
	if classIndexId == 4 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Options:PortForwardSettings()

					local settings = TRB.Options.Rogue.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.assassination == nil or
						TwintopInsanityBarSettings.rogue.assassination.displayText == nil then
						settings.rogue.assassination.displayText.barText = TRB.Options.Rogue.AssassinationLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.outlaw == nil or
						TwintopInsanityBarSettings.rogue.outlaw.displayText == nil then
						settings.rogue.outlaw.displayText.barText = TRB.Options.Rogue.OutlawLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.subtlety == nil or
						TwintopInsanityBarSettings.rogue.subtlety.displayText == nil then
						settings.rogue.subtlety.displayText.barText = TRB.Options.Rogue.SubtletyLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
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

		if TRB.Details.addonData.loaded and specId > 0 then
			if not TRB.Details.addonData.optionsPanel then
				TRB.Details.addonData.optionsPanel = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.rogue.assassination = TRB.Functions.LibSharedMedia:ValidateLsmValues("Assassination Rogue", TRB.Data.settings.rogue.assassination)
						TRB.Data.settings.rogue.outlaw = TRB.Functions.LibSharedMedia:ValidateLsmValues("Outlaw Rogue", TRB.Data.settings.rogue.outlaw)
						TRB.Data.settings.rogue.subtlety = TRB.Functions.LibSharedMedia:ValidateLsmValues("Subtlety Rogue", TRB.Data.settings.rogue.subtlety)
						
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
					end)
				end)
			end

			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
				SwitchSpec()
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "rogue"
	local specId = GetSpecialization()
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
	local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
	local settings = nil

	if specId == 1 then
		settings = TRB.Data.settings.rogue.assassination
	elseif specId == 2 then
		settings = TRB.Data.settings.rogue.outlaw
	elseif specId == 3 then
		settings = TRB.Data.settings.rogue.subtlety
	end
	
	if settings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	local specId = GetSpecialization()
	if specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.assassination)
		TRB.Data.specSupported = true
	elseif specId == 2 and TRB.Data.settings.core.enabled.rogue.outlaw == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.outlaw)
		TRB.Data.specSupported = true
	elseif specId == 3 and TRB.Data.settings.core.enabled.rogue.subtlety == true then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.subtlety)
		TRB.Data.specSupported = true
	else
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ComboPoints
		TRB.Data.resource2Factor = 1

		TRB.Functions.Class:CheckCharacter()

		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
		barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

		TRB.Details.addonData.registered = true
	else
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = false
		barContainerFrame:Hide()
	end
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Class:HideResourceBar(force)
	local affectingCombat = UnitAffectingCombat("player")
	local specId = GetSpecialization()
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if specId == 1 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.rogue.assassination.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.rogue.assassination.displayBar.alwaysShow) and (
					(not TRB.Data.settings.rogue.assassination.displayBar.notZeroShow) or
					(TRB.Data.settings.rogue.assassination.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.rogue.assassination.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 2 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.rogue.outlaw.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow) and (
					(not TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow) or
					(TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.rogue.outlaw.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 3 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.rogue.subtlety.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow) and (
					(not TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow) or
					(TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.rogue.subtlety.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
	if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
		return false
	end
	
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	local targets = targetData.targets

	if guid ~= nil and guid ~= "" then
		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid)
		end
		targets[guid].lastUpdate = currentTime
		return true
	end
	return false
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end
	local specId = GetSpecialization()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil
	if specId == 1 then
		settings = TRB.Data.settings.rogue.assassination
	elseif specId == 2 then
		settings = TRB.Data.settings.rogue.outlaw
	elseif specId == 3 then
		settings = TRB.Data.settings.rogue.subtlety
	else
		return false
	end

	if specId == 1 then --Assassination
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
		-- Bleeds
		if var == "$isBleeding" then
			if IsTargetBleeding() then
				valid = true
			end
		elseif var == "$ctCount" or var == "$crimsonTempestCount" then
			if snapshotData.targetData.count[spells.crimsonTempest.id] > 0 then
				valid = true
			end
		elseif var == "$ctTime" or var == "$crimsonTempestTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.crimsonTempest.id] ~= nil and
				target.spells[spells.crimsonTempest.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$garroteCount" then
			if snapshotData.targetData.count[spells.garrote.id] > 0 then
				valid = true
			end
		elseif var == "$garroteTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.garrote.id] ~= nil and
				target.spells[spells.garrote.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$ibCount" or var == "$internalBleedingCount" then
			if snapshotData.targetData.count[spells.internalBleeding.id] > 0 then
				valid = true
			end
		elseif var == "$ibTime" or var == "$internalBleedingTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.internalBleeding.id] ~= nil and
				target.spells[spells.internalBleeding.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$ruptureCount" then
			if snapshotData.targetData.count[spells.rupture.id] > 0 then
				valid = true
			end
		elseif var == "$ruptureTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.rupture.id] ~= nil and
				target.spells[spells.rupture.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$dpCount" or var == "$deadlyPoisonCount" then
			if snapshotData.targetData.count[spells.deadlyPoison.id] > 0 then
				valid = true
			end
		elseif var == "$dpTime" or var == "$deadlyPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.deadlyPoison.id] ~= nil and
				target.spells[spells.deadlyPoison.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$amplifyingPoisonCount" then
			if snapshotData.targetData.count[spells.amplifyingPoison.id] > 0 then
				valid = true
			end
		elseif var == "$amplifyingPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.amplifyingPoison.id] ~= nil and
				target.spells[spells.amplifyingPoison.id].remainingTime > 0 then
				valid = true
			end
		-- Other abilities
		elseif var == "$blindsideTime" then
			if snapshots[spells.blindside.id].buff.isActive then
				valid = true
			end
		elseif var == "$sbsCount" or var == "$serratedBoneSpikeCount" then
			if snapshotData.targetData.count[spells.serratedBoneSpike.debuffId] > 0 then
				valid = true
			end
		end
	elseif specId == 2 then --Outlaw
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
		-- Roll the Bones buff counts
		if var == "$rtbCount" or var == "$rollTheBonesCount" then
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
		end
	elseif specId == 3 then --Subtlety
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
		if var == "$shadowTechniquesCount" then
			if snapshots[spells.shadowTechniques.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$flagellationTime" then
			if snapshots[spells.flagellation.id].buff.isActive then
				valid = true
			end
		elseif var == "$ruptureCount" then
			if snapshotData.targetData.count[spells.rupture.id] > 0 then
				valid = true
			end
		elseif var == "$ruptureTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.rupture.id] ~= nil and
				target.spells[spells.rupture.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$sodTime" or var == "$symbolsOfDeathTime" then
			if snapshots[spells.symbolsOfDeath.id].buff.isActive then
				valid = true
			end
		end
	end

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.RogueBaseSpells]]
	if var == "$resource" or var == "$energy" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$energyMax" then
		valid = true
	elseif var == "$resourceTotal" or var == "$energyTotal" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
			then
			valid = true
		end
	elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
			valid = true
		end
	elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
		local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
		if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
			return true
		elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
			return true
		end
	elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$passive" then
		if snapshotData.attributes.resource < TRB.Data.character.maxResource and
			settings.generation.enabled and
			((settings.generation.mode == "time" and settings.generation.time > 0) or
			(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
			valid = true
		end
	elseif var == "$regen" or var == "$regenEnergy" or var == "$resourceRegen" or var == "$energyRegen" or var == "$regenResource" then
		if settings.generation.enabled and
			snapshotData.attributes.resource < TRB.Data.character.maxResource and
			((settings.generation.mode == "time" and settings.generation.time > 0) or
			(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
			valid = true
		end
	elseif var == "$comboPoints" then
		valid = true
	elseif var == "$comboPointsMax" then
		valid = true
	elseif var == "$sadTime" or var == "$sliceAndDiceTime" then
		if snapshots[spells.sliceAndDice.id].buff.isActive then
			valid = true
		end
	-- Poisons
	elseif var == "$cpCount" or var == "$cripplingPoisonCount" then
		if snapshotData.targetData.count[spells.cripplingPoison.id] > 0 then
			valid = true
		end
	elseif var == "$cpTime" or var == "$cripplingPoisonTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.cripplingPoison.id] ~= nil and
			target.spells[spells.cripplingPoison.id].remainingTime > 0 then
			valid = true
		end
	elseif var == "$npCount" or var == "$numbingPoisonCount" then
		if snapshotData.targetData.count[spells.numbingPoison.id] > 0 then
			valid = true
		end
	elseif var == "$npTime" or var == "$numbingPoisonTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.numbingPoison.id] ~= nil and
			target.spells[spells.numbingPoison.id].remainingTime > 0 then
			valid = true
		end
	elseif var == "$atrophicPoisonCount" then
		if snapshotData.targetData.count[spells.atrophicPoison.id] > 0 then
			valid = true
		end
	elseif var == "$atrophicPoisonPoisonTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.atrophicPoison.id] ~= nil and
			target.spells[spells.atrophicPoison.id].remainingTime > 0 then
			valid = true
		end
	elseif var == "$wpCount" or var == "$woundPoisonCount" then
		if snapshotData.targetData.count[spells.woundPoison.id] > 0 then
			valid = true
		end
	elseif var == "$wpTime" or var == "$woundPoisonTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.woundPoison.id] ~= nil and
			target.spells[spells.woundPoison.id].remainingTime > 0 then
			valid = true
		end
	elseif var == "$inStealth" then
		if IsStealthed() then
			valid = true
		end
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil
end

--HACK to fix FPS
local updateRateLimit = 0

function TRB.Functions.Class:TriggerResourceBarUpdates()
	local specId = GetSpecialization()
	if specId ~= 1 and specId ~= 2 and specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	local currentTime = GetTime()

	if updateRateLimit + 0.05 < currentTime then
		updateRateLimit = currentTime
		UpdateResourceBar()
	end
end